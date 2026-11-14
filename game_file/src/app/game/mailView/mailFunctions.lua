local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailCtrl = SoraDGetCtrl("mailCtrl")
local mailLogic = include("mailLogic")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local chatFunctions = include("chatFunctions")
local allianceDesRead = include("allianceDesRead")
local _ENV, mailFunctions = "allianceDesRead", "allianceDesRead"
function mailFunctions:getStaticTabList()
	local _UPVALUE8_, _ENV, setTypes
	setTypes, (nil)[1] = nil, gMailSetType.INFO_MAIL
	setTypes, (nil)[2] = nil, gMailSetType.ALLIANCE
	setTypes, (nil)[3] = nil, gMailSetType.NEW_BATTLE
	setTypes, (nil)[4] = nil, gMailSetType.SCOUT_REPORT
	setTypes, (nil)[5] = nil, gMailSetTypeFunc.getReportSetTypeList()
	setTypes, (nil)[6] = nil, gMailSetType.NEW_SYS
	setTypes, (nil)[7] = nil, gMailSetType.OFFICIAL
	setTypes, (nil)[8] = nil, gMailSetType.COLLECT
	return setTypes
end
function mailFunctions:getMailDetailDate(mail)
	local propertyData = mail.property
	local strTime = os.date("%Y-%m-%d %H:%M:%S", propertyData.time)
	return strTime
end
function mailFunctions:getStrCoordinate(x, y)
	local strCoordinate = "X:" .. x .. " Y:" .. y
	return strCoordinate
end
function mailFunctions:getWrappedName(allianceAbbr, nickName, sourceKid)
	local ret = ""
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		ret = "(" .. allianceAbbr .. ")"
	end
	if nickName ~= nil then
		ret = ret .. nickName
	end
	if sourceKid ~= nil and 0 ~= sourceKid then
		ret = ret .. "#" .. tostring(sourceKid)
	end
	return ret
end
function mailFunctions:getSceneImgByMailType(mailType, mailSource)
	if mailSource == nil then
		local imgName = gMailSetTypeFunc.getSceneImgByMailType(mailType)
		return SoraDCheckPNG(imgName, gDefaultPNG.MAIL_INFOBG)
	end
	return "bg_mailinfo_collect.png"
end
function mailFunctions:getViewAngleFromMail(mail)
	local viewAngle = gMailViewAngle.ATTACk
	local mailSource = mail.property.source
	local isFromBrief = false
	local contentData
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		isFromBrief = true
		contentData = mail.property.brief
	else
		contentData = mail.property.data
	end
	if isFromBrief == true then
		return self:getViewAngleFromBrief(contentData)
	else
		if not userSDKManager.isBeta() and device.platform ~= "mac" then
			contentData.fightDetail = nil
		end
		if contentData.battleInfo == nil then
			return viewAngle
		end
		return self:getViewAngleFromBatttleInfo(mail.property.receiver, contentData.battleInfo)
	end
end
function mailFunctions:getViewAngleFromBrief(contentData)
	local isSelfAttack = contentData.isSelfInAttack
	local isSelfDefence = contentData.isSelfInDefend
	if isSelfAttack == nil and isSelfDefence == nil then
		return gMailViewAngle.ATTACk
	end
	if isSelfAttack then
		return gMailViewAngle.ATTACK
	elseif isSelfDefence == true or isSelfDefence == nil then
		return gMailViewAngle.DEFENCE
	else
		return gMailViewAngle.THIRDPERSON
	end
end
function mailFunctions:getViewAngleFromBatttleInfo(playerId, battleInfo)
	local viewAngle = gMailViewAngle.ATTACK
	local isPlayerAttack = self:getIsPlayerAttack(playerId, battleInfo)
	local isPlayerDefense = self:getIsPlayerDefense(playerId, battleInfo)
	if isPlayerAttack then
		viewAngle = gMailViewAngle.ATTACK
	elseif isPlayerDefense then
		viewAngle = gMailViewAngle.DEFENCE
	else
		viewAngle = gMailViewAngle.THIRDPERSON
	end
	return viewAngle
end
function mailFunctions:getIsPlayerAttack(playerId, battleInfo)
	if not battleInfo then
		return false
	end
	local attackArmyInfo = battleInfo.attackArmyInfo
	if nil == attackArmyInfo then
		return false
	end
	if tolua.type(playerId) == "number" then
		for i, v in ipairs(attackArmyInfo) do
			if v.uinfo.id == playerId then
				return true
			end
		end
	elseif tolua.type(playerId) == "table" then
		for i, id in ipairs(playerId) do
			for i, v in ipairs(attackArmyInfo) do
				if v.uinfo.id == id then
					return true
				end
			end
		end
	end
	return false
end
function mailFunctions:getIsPlayerDefense(playerId, battleInfo)
	local defenceArmyInfo = battleInfo.defenceArmyInfo
	if nil == defenceArmyInfo then
		return false
	end
	if tolua.type(playerId) == "number" then
		for i, v in ipairs(defenceArmyInfo) do
			if v.uinfo.id == playerId then
				return true
			end
		end
	elseif tolua.type(playerId) == "table" then
		for i, id in ipairs(playerId) do
			for i, v in ipairs(defenceArmyInfo) do
				if v.uinfo.id == id then
					return true
				end
			end
		end
	end
	return false
end
function mailFunctions:getKillAndLostNum(armyInfo)
	local totalKill = 0
	local totalLost = 0
	totalKill = armyInfo.fightSummary.killNum
	totalLost = armyInfo.fightSummary.lostNum
	return totalKill, totalLost
end
function mailFunctions:getMailDes(mail)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		if mailSource == gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS or mailSource == gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_FAILED then
			local mailDesParser = include("mailDesParser")
			strName2 = mailDesParser.getPlayerFightTitle(contentData, contentData.playerInfo2)
		end
		_ENV = contentData
		contentData.x = targetCoordinate.x
		contentData.y = targetCoordinate.y
		contentData.defName = strName2
		result = i18n(formatedStr, contentData)
		return result
	else
		local formatedStr = self:getMailDesStr(mailSource)
		print("isSelfAttack", mailSource, formatedStr)
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = mailSource, mailSource
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		if mailSource == gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_SUCCESS or mailSource == gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_FAILED then
			local mailDesParser = include("mailDesParser")
			strName1 = mailDesParser.getPlayerFightTitle(contentData, contentData.playerInfo1)
		end
		_ENV = contentData
		contentData.x = targetCoordinate.x
		contentData.y = targetCoordinate.y
		contentData.atkName = strName1
		result = i18n(formatedStr, contentData)
		return result
	end
end
function mailFunctions:getMailCoordinate(mail)
	local contentData
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
	else
		contentData = mail.property.data
	end
	local mailSource = mail.property.source
	local coordinate = contentData.targetCoordinate
	if coordinate == nil and contentData and contentData.uinfo and contentData.uinfo.coordinate then
		coordinate = contentData.uinfo.coordinate
		coordinate.kid = contentData.uinfo.kid
	end
	if coordinate == nil and contentData and contentData.targetMapObj and contentData.targetMapObj.x then
		coordinate = cc.p(contentData.targetMapObj.x, contentData.targetMapObj.y)
		coordinate.kid = contentData.targetMapObj.kid
	end
	if coordinate == nil and contentData.content and contentData.content.coordinate then
		coordinate = contentData.content.coordinate
	end
	if coordinate == nil then
		_ENV = contentData.content
		contentData.content.x = 0
		coordinate, contentData.content.y = contentData.content, 0
	end
	return coordinate
end
_ENV, mailFunctions.getMailReportDes = function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end, function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end
_ENV = nil
;(nil).attackDes = "common_text_1052"
;(nil).defenceDes = "common_text_1054"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACT_CITY_VICTORY], (nil).reportdes = nil, "common_text_1052"
_ENV = nil
;(nil).attackDes = "common_text_1052"
;(nil).defenceDes = "common_text_1054"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACT_CITY_LOSE], (nil).reportdes = nil, "common_text_1052"
_ENV = nil
;(nil).attackDes = "common_text_1052"
;(nil).defenceDes = "common_text_1054"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_CITY_BIG_FAILURE], (nil).reportdes = nil, "common_text_1052"
_ENV = nil
;(nil).attackDes = "common_text_1052"
;(nil).defenceDes = "common_text_1054"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_CITY_VICTORY], (nil).reportdes = nil, "common_text_1054"
_ENV = nil
;(nil).attackDes = "common_text_1052"
;(nil).defenceDes = "common_text_1054"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_CITY_LOSE], (nil).reportdes = nil, "common_text_1054"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACT_TROOP_VICTORY], (nil).reportdes = nil, "common_text_1053"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_TROOP_BIG_FAILURE], (nil).reportdes = nil, "common_text_1053"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACT_TROOP_LOSE], (nil).reportdes = nil, "common_text_1053"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_TROOP_VICTORY], (nil).reportdes = nil, "common_text_1055"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_TROOP_LOSE], (nil).reportdes = nil, "common_text_1055"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_PALACE_VICTORY], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_PALACE_LOSE], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_CATAPULT_VICTORY], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_CATAPULT_LOSE], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_FORTRESS_VICTORY], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_FORTRESS_LOSE], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_ANCIENT_BUILDING_SUCCESS], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_ANCIENT_BUILDING_FAILED], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_PALACE_VICTORY], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_PALACE_LOSE], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_CATAPULT_VICTORY], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_CATAPULT_LOSE], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_FORTRESS_VICTORY], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_FORTRESS_LOSE], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(nil).defenceDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DEFENSE_ANCIENT_BUILDING_FAILED], (nil).reportdes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.Attack_Treasure_Map_Success], (nil).reportdes = nil, "common_text_1058"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.Attack_Treasure_Map_Failed], (nil).reportdes = nil, "common_text_1058"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.Defense_Treasure_Map_Success], (nil).reportdes = nil, "common_text_1059"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(nil).defenceDes = "common_text_1055"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.Defense_Treasure_Map_Failed], (nil).reportdes = nil, "common_text_1059"
_ENV = nil
;(nil).attackDes = "mail_lordskill_04"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DUEL_ATTACKER_ATTACK_SUCCESS], (nil).defenceDes = nil, "mail_lordskill_07"
_ENV = nil
;(nil).attackDes = "mail_lordskill_04"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DUEL_ATTACKER_ATTACK_FAILED], (nil).defenceDes = nil, "mail_lordskill_07"
_ENV = nil
;(nil).attackDes = "mail_lordskill_04"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DUEL_DEFENDER_DEFEND_SUCCESS], (nil).defenceDes = nil, "mail_lordskill_07"
_ENV = nil
;(nil).attackDes = "mail_lordskill_04"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.DUEL_DEFENDER_DEFEND_FAILED], (nil).defenceDes = nil, "mail_lordskill_07"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS], (nil).defenceDes = nil, "common_text_1054"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_FAILED], (nil).defenceDes = nil, "common_text_1054"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_SUCCESS], (nil).defenceDes = nil, "common_text_1054"
_ENV = nil
;(nil).attackDes = "common_text_1053"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_FAILED], (nil).defenceDes = nil, "common_text_1054"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], (nil).defenceDes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.ATTACK_NEBULA_DEFENCE_FAILED], (nil).defenceDes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.NEBULA_DEFENCE_USER_DEFENCE_FAILED], (nil).defenceDes = nil, "common_text_1422"
_ENV = nil
;(nil).attackDes = "common_text_1422"
;(function(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end)[gMailSource.NEBULA_DEFENCE_USER_DEFENCE_SUCCESS], (nil).defenceDes = nil, "common_text_1422"
local function sourceMailStr(self, mail, reportPlayerId)
	local mailSource = mail.property.source
	local result = "NA"
	local contentData
	local isFromBrief = false
	if mail.property.brief ~= nil and next(mail.property.brief) ~= nil then
		contentData = mail.property.brief
		isFromBrief = true
	else
		contentData = mail.property.data
	end
	local targetCoordinate = contentData.targetCoordinate
	if targetCoordinate == nil then
		_ENV = mail.property.brief
		mail.property.brief.x = 0
		targetCoordinate, mail.property.brief.y = mail.property.brief, 0
	end
	local strName1 = "NA"
	local strName2 = "NA"
	local isSelfAttack = false
	if isFromBrief == true then
		isSelfAttack = contentData.isSelfInAttack
		if reportPlayerId ~= nil then
			if reportPlayerId == contentData.playerInfo1.uinfo.id then
				isSelfAttack = true
			else
				isSelfAttack = false
			end
		end
	else
		isSelfAttack = self:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
	end
	if isSelfAttack then
		local formatedStr = self:getMailReportDesStr(mailSource, true)
		local uinfo = contentData.playerInfo2.uinfo
		local allianceInfo = contentData.playerInfo2.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = true, true
		end
		strName2 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName2 = strName2 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.defName = strName2
		result = i18n(formatedStr, uinfo.kid)
	else
		local formatedStr = self:getMailReportDesStr(mailSource)
		strName2 = i18n("common_text_142")
		local uinfo = contentData.playerInfo1.uinfo
		local allianceInfo = contentData.playerInfo1.allianceInfo
		if allianceInfo == nil then
			allianceInfo, _ENV = i18n(formatedStr, uinfo.kid), i18n(formatedStr, uinfo.kid)
		end
		strName1 = self:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		if uinfo and uinfo.kid and 0 < lordInfoCtrl:getMapSourceKid() and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
			strName1 = strName1 .. "#" .. uinfo.kid
		end
		_ENV = uinfo.kid
		uinfo.kid.x = targetCoordinate.x
		uinfo.kid.y = targetCoordinate.y
		uinfo.kid.atkName = strName1
		result = i18n(formatedStr, uinfo.kid)
	end
	result = i18n("common_text_504") .. "\n" .. result
	if mail.property.data.mailReportType == gMailReportType.ARENA then
		result = i18n("common_text_504")
	end
	return result
end
function mailFunctions:getMailDesStr(mailSource, isPlayerAttack)
	print("sourceType", mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end
_ENV, mailFunctions.getMailReportDesStr = function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end, function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.SOLDIER_TYPE_BUBING)] = "common_text_143"
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.SOLDIER_TYPE_QIBING)] = "common_text_144"
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.SOLDIER_TYPE_GONGBING)] = "common_text_145"
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.SOLDIER_TYPE_CHEBING)] = "common_text_146"
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.TRAP_TYPE_STONE)] = "common_text_683"
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.TRAP_TYPE_ARROW)] = "common_text_684"
;(function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.TRAP_TYPE_WOOD)] = "common_text_682"
local (function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end)[tostring(gSoldierType.SOLDIER_TYPE_ELITE)], soldierTypeNameTable = "common_text_3772", function(self, mailSource, isPlayerAttack)
	if isPlayerAttack then
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].attackDes or "NA"
	else
		return sourceMailStr[mailSource] and sourceMailStr[mailSource].defenceDes or "NA"
	end
end
_ENV, mailFunctions.getSoldierName = function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end, function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.infantryDf)] = "common_text_4659"
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.infantryAk)] = "common_text_4660"
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.cavalry)] = "common_text_144"
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.cavalryArrow)] = "common_text_4661"
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.archer)] = "common_text_145"
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.crossbow)] = "armyName_603"
;(function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.charists)] = "common_text_146"
local (function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end)[tostring(gArmyType.siegeVehicles)], armyTypeNameTable = "armyName_706", function(self, soldierType)
	return i18n(soldierTypeNameTable[tostring(soldierType)])
end
_ENV, mailFunctions.getArmyTypeName = function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end, function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end
;(function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end)[tostring(gSoldierType.SOLDIER_TYPE_BUBING)] = "icon_artifact_bubing.png"
;(function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end)[tostring(gSoldierType.SOLDIER_TYPE_QIBING)] = "icon_artifact_qibing.png"
;(function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end)[tostring(gSoldierType.SOLDIER_TYPE_GONGBING)] = "icon_artifact_gongbing.png"
local (function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end)[tostring(gSoldierType.SOLDIER_TYPE_CHEBING)], soldierTypeIcon = "icon_artifact_chebing.png", function(self, armyType)
	return i18n(armyTypeNameTable[tostring(armyType)])
end
_ENV, mailFunctions.getSoldierClassIcon = function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end, function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.ATTACK)] = "common_text_008"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.DEFENCE)] = "common_text_041"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.LIFE)] = "common_text_147"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.HURT)] = "mail_2_text_57"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.TRAP_ATK)] = "common_text_149"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.MASSACRE)] = "common_text_3184"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.REDEMPTION)] = "common_text_3185"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.SIEGEKILL)] = "technology_name_24118"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.LONG_ATTACK)] = "warSecrit_text_35"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.SHORT_ATTACK)] = "warSecrit_text_34"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.KILL_BARRIER)] = "lordskill_name_11057"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.BASE_ATK)] = "common_text_008"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.BASE_DEF)] = "common_text_041"
;(function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.BASE_HP)] = "common_text_147"
local (function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end)[tostring(gTroopAttrType.ATK_SPEED_ADD)], troopAttrTypeNameTable = "mail_2_text_34", function(self, soldierType)
	return soldierTypeIcon[tostring(soldierType)]
end
_ENV, mailFunctions.getAttrTypeName = function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end, function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[101] = "common_text_1313"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[102] = "common_text_1317"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[103] = "mail_2_text_74"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[104] = "mail_2_text_58"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[105] = "war_stone_name_21"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[106] = "war_stone_name_22"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[107] = "war_stone_name_23"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[108] = "mail_2_text_59"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[116] = "common_text_4553"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[201] = "mail_2_text_76"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[202] = "mail_2_text_77"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[203] = "mail_2_text_78"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[204] = "mail_2_text_62"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[205] = "war_stone_name_28"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[206] = "war_stone_name_29"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[207] = "war_stone_name_30"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[208] = "mail_2_text_63"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[216] = "common_text_4554"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[301] = "common_text_1314"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[302] = "common_text_1318"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[303] = "mail_2_text_75"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[304] = "mail_2_text_60"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[305] = "war_stone_name_24"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[306] = "war_stone_name_25"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[307] = "war_stone_name_26"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[308] = "mail_2_text_61"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[316] = "common_text_4918"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[401] = "common_text_1316"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[402] = "common_text_1320"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[403] = "common_text_1324"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[404] = "mail_2_text_64"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[405] = "mail_2_text_79"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[406] = "war_stone_name_32"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[407] = "war_stone_name_33"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[408] = "mail_2_text_65"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[416] = "common_text_4917"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[501] = "common_text_3238"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[502] = "common_text_3239"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[503] = "common_text_3240"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[504] = "mail_2_text_66"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[505] = "war_stone_name_35"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[506] = "war_stone_name_36"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[507] = "war_stone_name_37"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[508] = "mail_2_text_67"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[516] = "common_text_4916"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[609] = "mail_2_text_68"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[709] = "mail_2_text_69"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[809] = "mail_2_text_70"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[909] = "common_text_149"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[910] = "common_text_3184"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[911] = "common_text_3185"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[912] = "technology_name_24118"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[913] = "warSecrit_text_35"
;(function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[914] = "warSecrit_text_34"
local (function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end)[915], troopAttrStr = "lordskill_name_11057", function(self, troopAttrType)
	local key = troopAttrTypeNameTable[tostring(troopAttrType)]
	if key ~= nil then
		return i18n(key)
	else
		return "undefined"
	end
end
function mailFunctions:getFormattedTroopAttr(soldierType, troopAttrType)
	print("soldierType,troopAttrType", soldierType, troopAttrType, troopAttrStr[self:getSortIndex(soldierType, troopAttrType)])
	return i18n(troopAttrStr[self:getSortIndex(soldierType, troopAttrType)])
end
function mailFunctions:getSortIndex(soldierType, troopAttrType)
	_ENV = nil
	;(nil)[gSoldierType.SOLDIER_TYPE_BUBING] = 100
	;(nil)[gSoldierType.SOLDIER_TYPE_GONGBING] = 200
	;(nil)[gSoldierType.SOLDIER_TYPE_QIBING] = 300
	;(nil)[gSoldierType.SOLDIER_TYPE_CHEBING] = 400
	;(nil)[gSoldierType.SOLDIER_TYPE_ELITE] = 500
	;(nil)[gSoldierType.TRAP_TYPE_STONE] = 600
	;(nil)[gSoldierType.TRAP_TYPE_ARROW] = 700
	local _ENV, (nil)[gSoldierType.TRAP_TYPE_WOOD], soldierTypeSort = gSoldierType.TRAP_TYPE_WOOD, 800, nil
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.ATTACK] = 1
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.DEFENCE] = 2
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.LIFE] = 3
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.HURT] = 4
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.BASE_ATK] = 5
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.BASE_DEF] = 6
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.BASE_HP] = 7
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.ATK_SPEED_ADD] = 8
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.TRAP_ATK] = 9
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.MASSACRE] = 10
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.REDEMPTION] = 11
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.SIEGEKILL] = 12
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.LONG_ATTACK] = 13
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.SHORT_ATTACK] = 14
	gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.KILL_BARRIER] = 15
	local gSoldierType.TRAP_TYPE_WOOD[gTroopAttrType.DMG_REDUCE], troopAttrTypeSort = 16, gSoldierType.TRAP_TYPE_WOOD
	return (soldierType and soldierTypeSort[soldierType] or 900) + (troopAttrTypeSort[troopAttrType] or troopAttrType)
end
function mailFunctions:getFormatedPercentNum(isAdd, num)
	if not num or num == 0 then
		return "--"
	end
	local strPrefix = ""
	if isAdd then
		strPrefix = "+"
	else
		strPrefix = "-"
	end
	local strPostfix = "%"
	local strResult = strPrefix .. num .. strPostfix
	return strResult
end
function mailFunctions:getFormatedNum(isAdd, num)
	if not num or num == 0 then
		return "--"
	end
	local strPrefix = ""
	if isAdd then
		strPrefix = "+"
	else
		strPrefix = "-"
	end
	local strResult = strPrefix .. num / 1000
	return strResult
end
function mailFunctions:sortResItems(items)
	for i, v in ipairs(items) do
		v.sortIndex = self:getSorIndex(v.id)
	end
	table.sort(items, function(a, b)
		return a.sortIndex < b.sortIndex
	end)
end
function mailFunctions:getSorIndex(id)
	local retSortIndex = gIDSortMap[tostring(id)]
	if retSortIndex == nil then
		retSortIndex = tonumber(id)
	end
	return retSortIndex
end
function mailFunctions:getIsPlayerOwnSide(playerInfo)
	local isOwnSide = false
	if nil ~= playerInfo then
		if playerInfo.allianceInfo and playerInfo.allianceInfo.aid ~= nil then
			local ownUid = chatFunctions:getSelfId()
			local playerId = playerInfo.uinfo and playerInfo.uinfo.id
			if ownUid == playerId then
				isOwnSide = true
			else
				local allianceMgr = SoraDGetCtrl("allianceMgr")
				local ownAid = allianceMgr:getOwnTeamID()
				if playerInfo.allianceInfo.aid == ownAid then
					isOwnSide = true
				end
			end
		else
			local ownUid = chatFunctions:getSelfId()
			local playerId = playerInfo.uinfo.id
			if ownUid == playerId then
				isOwnSide = true
			end
		end
	end
	return isOwnSide
end
function mailFunctions:getTrimAndFixedWidthStr(convertText, width, fontSize)
	if width == nil then
		width = 320
	end
	if fontSize == nil then
		fontSize = 24
	end
	convertText = convertText or ""
	local trimedStr = string.trim(convertText)
	trimedStr = string.gsub(trimedStr, "\n", ",")
	trimedStr = string.gsub(trimedStr, "\r", "")
	local retString, label = SoraDConvertOmissionText(width, trimedStr, fontSize)
	return retString
end
function mailFunctions:doRequestSingleMail(mid)
	if not mid then
		return
	end
	mailCtrl:getMailDetailWithStatus(mid)
end
function mailFunctions:doRequestMailReport(mid, needView, targetPlayerId)
	if not mid then
		return
	end
	if needView then
		mailCtrl:getMailDetailWithStatus(mid, needView)
	else
		mailCtrl:getMailDetailWithoutStatus(mid, targetPlayerId)
	end
end
function mailFunctions:resetMailSource(mail, senderId)
	if not mail then
		return
	end
	local mailType = mail.property.mailType
	if mailType ~= gMailType.BATTLE_REPORT and mailType ~= gMailType.SCOUT_REPORT then
		return
	end
	local viewAngle = self:getViewAngleFromMail(mail)
	if viewAngle == gMailViewAngle.THIRDPERSON then
		return
	end
	local mailSource = mail.property.source
	if mail.property.brief and next(mail.property.brief) ~= nil then
		self:resetMailSourceFromBrief(mail)
	end
	if not mail.property.data or next(mail.property.data) == nil then
		return
	end
	local result = mail.property.data.result
	if gMailSetTypeFunc.getConvertMailSource(mailSource) then
		local contentData = mail.property.data
		local lordUid = senderId or lordInfoCtrl:getLordInfo().base.uid
		local isAttack = mailFunctions:getIsPlayerAttack(mail.property.receiver, contentData.battleInfo)
		if mailSource == gMailSource.ESCORT_ROB_SUCCESS or mailSource == gMailSource.ESCORT_ROB_FAILED then
			isAttack = lordUid == contentData.playerInfo1.uinfo.id
		end
		if isAttack then
			if mail.property.data.isHeavyLose == 1 then
				mailSource, result = self:convertSourceAndResult(isAttack, mailSource, result, mail.property.data.isHeavyLose)
			end
		else
			mailSource, result = self:convertSourceAndResult(isAttack, mailSource, result)
		end
		mail.property.source = mailSource
		mail.property.data.result = result
	else
		result = self:verifyResult(mailSource)
		mail.property.data.result = result
	end
end
function mailFunctions:resetMailSourceFromBrief(mail)
	if not mail then
		return
	end
	local mailType = mail.property.mailType
	if mailType ~= gMailType.BATTLE_REPORT and mailType ~= gMailType.SCOUT_REPORT then
		return
	end
	local mailSource = mail.property.source
	if not mail.property.brief or next(mail.property.brief) == nil then
		return
	end
	local result = mail.property.brief.result
	if gMailSetTypeFunc.getConvertMailSource(mailSource) then
		local isAttack = mail.property.brief.isSelfInAttack
		if isAttack == true and mail.property.brief.isHeavyLose == 1 then
			mailSource, result = self:convertSourceAndResult(isAttack, mailSource, result, mail.property.brief.isHeavyLose)
			mail.property.source = mailSource
			mail.property.brief.result = result
		end
		if isAttack == false then
			mailSource, result = self:convertSourceAndResult(isAttack, mailSource, result)
			mail.property.source = mailSource
			mail.property.brief.result = result
		end
	else
		result = self:verifyResult(mailSource)
		mail.property.brief.result = result
	end
end
function mailFunctions:convertSourceAndResult(isAttack, mailSource, result, isHeavyLose)
	local tmpSource = mailSource
	if not isAttack then
		mailSource = gMailSetTypeFunc.getConvertMailSource(mailSource)
	elseif isHeavyLose == 1 then
		if mailSource == gMailSource.ATTACT_CITY_LOSE then
			mailSource = gMailSource.ATTACK_CITY_BIG_FAILURE
		elseif mailSource == gMailSource.ATTACT_TROOP_LOSE or mailSource == gMailSource.ATTACK_PALACE_LOSE or mailSource == gMailSource.ATTACK_CATAPULT_LOSE then
			mailSource = gMailSource.ATTACK_TROOP_BIG_FAILURE
		end
	end
	return mailSource, self:verifyResult(mailSource)
end
function mailFunctions:verifyResult(mailSource)
	local result
	_UPVALUE17_ = nil
	_UPVALUE18_, (nil)[1] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS
	_UPVALUE18_, (nil)[2] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_FORTRESS_VICTORY
	_UPVALUE18_, (nil)[3] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.ESCORT_DEF_SUCCESS
	_UPVALUE18_, (nil)[4] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_CITY_VICTORY
	_UPVALUE18_, (nil)[5] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_TROOP_VICTORY
	_UPVALUE18_, (nil)[6] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.Defense_Treasure_Map_Success
	_UPVALUE18_, (nil)[7] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_PALACE_VICTORY
	_UPVALUE18_, (nil)[8] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_CATAPULT_VICTORY
	_UPVALUE18_, (nil)[9] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS
	_UPVALUE18_, (nil)[10] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_LEGENDLORD_SUCCESS
	_UPVALUE18_, (nil)[11] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_RADIANCE_BUILD_SUCCESS
	_UPVALUE18_, (nil)[12] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_DEVILVALLEYBUILD_SUCCESS
	_UPVALUE18_, (nil)[13] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS
	_UPVALUE18_, (nil)[14] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS
	_UPVALUE18_, (nil)[15] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_SUCCESS
	_UPVALUE18_, (nil)[16] = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS
	local _UPVALUE18_, (nil)[17], checkTableWin = gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS, gMailSource.NEBULA_DEFENCE_USER_DEFENCE_SUCCESS, nil
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[1] = gMailSource.DEFENSE_ANCIENT_BUILDING_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[2] = gMailSource.DEFENSE_FORTRESS_LOSE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[3] = gMailSource.ESCORT_DEF_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[4] = gMailSource.DEFENSE_CITY_LOSE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[5] = gMailSource.DEFENSE_TROOP_LOSE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[6] = gMailSource.Defense_Treasure_Map_Failed
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[7] = gMailSource.DEFENSE_PALACE_LOSE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[8] = gMailSource.DEFENSE_CATAPULT_LOSE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[9] = gMailSource.ATTACK_CITY_BIG_FAILURE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[10] = gMailSource.ATTACK_TROOP_BIG_FAILURE
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[11] = gMailSource.ATTACK_LEGENDLORD_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[12] = gMailSource.DEFENSE_ALLIANCEBUILD_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[13] = gMailSource.DEFENSE_LEGENDLORD_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[14] = gMailSource.DEFENSE_RADIANCE_BUILD_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[15] = gMailSource.DEFENSE_DEVILVALLEYBUILD_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[16] = gMailSource.DEFENSE_PYRAMIDBUILD_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[17] = gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[18] = gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_FAILED
	gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[19] = gMailSource.ATTACK_NEBULA_DEFENCE_FAILED
	local gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS[20], checkTableLose = gMailSource.NEBULA_DEFENCE_USER_DEFENCE_FAILED, gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS
	for i, v in ipairs(checkTableWin) do
		if checkTableWin[i] == mailSource then
			result = 0
			return result
		end
	end
	for i, v in ipairs(checkTableLose) do
		if checkTableLose[i] == mailSource then
			result = 1
			return result
		end
	end
	return
end
function mailFunctions:getMapBuildName(mapType, subMapType)
	local objId
	dump(mapType, "mailFunctions:getMapBuildName")
	if type(mapType) == "table" then
		subMapType = mapType.subMapType
		objId = mapType.objId
		mapType = mapType.mapType
	end
	if mapType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		return allianceDesRead.getBuildName(subMapType)
	elseif mapType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
		return worldMapDefine.getPyramidbuildingName(subMapType, objId)
	elseif mapType == gMapObjTypeDef.mapObjTypeBattery then
		if objId then
			local palaceInfoRead = include("palaceInfoRead")
			return palaceInfoRead.getBatteryName(objId)
		end
		return i18n("common_text_840")
	elseif mapType == gMapObjTypeDef.mapTypeATBuilding then
		return i18n("AncienTreasure_buildname_01")
	elseif mapType == gMapObjTypeDef.mapObjTypeLegendLord then
		local hegemonRead = include("hegemonRead")
		return hegemonRead.getNameBySubMaptype(subMapType)
	elseif mapType == gMapObjTypeDef.mapObjTypeRemainsWar then
		return i18n("remains_name_04")
	elseif mapType == gMapObjTypeDef.mapTypeRadianceWarPalace or mapType == gMapObjTypeDef.mapTypeRadianceWarGate or mapType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
		local radianceWarRead = include("radianceWarRead")
		return radianceWarRead.getBuildName(mapType, objId)
	elseif mapType == gMapObjTypeDef.mapTypeRadianceWarResource then
		local radianceWarRead = include("radianceWarRead")
		return radianceWarRead.getResourceName(objId, true)
	elseif mapType == gMapObjTypeDef.mapObjNewTrialCity then
		if subMapType == 1 then
			return i18n("devilvalley_text_22")
		elseif subMapType == 2 then
			return i18n("devilvalley_text_20")
		end
	elseif mapType == gMapObjTypeDef.mapObjTypePlayer then
		return i18n("devilvalley_text_45")
	elseif mapType == gMapObjTypeDef.stronghold then
		local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
		_ENV = true
		;(true).var = allianceStrongholdMineRead.getGateLv(objId) .. i18n(allianceStrongholdMineRead.getHoldMonsterName(objId))
		return i18n("alliance_stronghold_text_032", true)
	elseif mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		local AMBC = require_data("atlantiswar_map_build_config").data
		return i18n(AMBC[objId].name)
	else
		local mapObjUtil = include("mapObjUtil")
		return mapObjUtil.getBuildName(mapType, subMapType, objId)
	end
	return ""
end
function mailFunctions:getMapBuildIcon(mapType, subMapType)
	local objId
	if type(mapType) == "table" then
		subMapType = mapType.subMapType
		objId = mapType.objId
		mapType = mapType.mapType
	end
	if mapType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		return allianceDesRead.getBuildIcon(subMapType)
	elseif mapType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
		return worldMapDefine.getPyramidbuildingImage(subMapType)
	elseif mapType == gMapObjTypeDef.mapObjTypeBattery then
		return "paotai_dj_w_01.png"
	elseif mapType == gMapObjTypeDef.mapTypeATBuilding then
		return "Map_build_sgmk.png"
	elseif mapType == gMapObjTypeDef.mapObjTypeKingdomLevelBuild then
		return "icon_mail_monster.png"
	elseif mapType == gMapObjTypeDef.mapTypeRadianceWarPalace or mapType == gMapObjTypeDef.mapTypeRadianceWarGate or mapType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
		local radianceWarRead = include("radianceWarRead")
		return radianceWarRead.getBuildIcon(mapType)
	elseif mapType == gMapObjTypeDef.mapTypeRadianceWarResource then
		local radianceWarRead = include("radianceWarRead")
		return radianceWarRead.getResourceImageName(objId)
	end
end
function mailFunctions:getOtherName(source, contentData, otherPlayer)
	local otherName = ""
	if source == gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS or source == gMailSource.ATTACK_ALLIANCEBUILD_FAILED then
		local buildId = contentData.subMapType
		local buildName = include("allianceDesRead").getBuildName(buildId)
		if otherPlayer.allianceInfo then
			otherName = self:getWrappedName(otherPlayer.allianceInfo.abbr, buildName)
		else
			otherName = buildName
		end
	elseif source == gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS or source == gMailSource.ATTACK_PYRAMIDBUILD_FAILED then
		local buildName = self:getMapBuildName(contentData)
		otherName = buildName
	elseif source == gMailSource.ATTACK_LEGENDLORD_SUCCESS or source == gMailSource.ATTACK_LEGENDLORD_FAILED then
		local buildName = self:getMapBuildName(contentData)
		if otherPlayer.allianceInfo then
			otherName = self:getWrappedName(otherPlayer.allianceInfo.abbr, buildName)
		else
			otherName = buildName
		end
	elseif source == gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS or source == gMailSource.ATTACK_RADIANCE_BUILD_FAILED then
		local buildName = self:getMapBuildName(contentData)
		if otherPlayer.allianceInfo then
			otherName = self:getWrappedName(otherPlayer.allianceInfo.abbr, buildName)
		else
			otherName = buildName
		end
	elseif source == gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS or source == gMailSource.ATTACK_NEBULA_DEFENCE_FAILED then
		local buildName = self:getMapBuildName(contentData)
		otherName = buildName
	elseif source == gMailSource.NEBULA_DEFENCE_USER_DEFENCE_FAILED or source == gMailSource.NEBULA_DEFENCE_USER_DEFENCE_SUCCESS then
		otherName = i18n("Celestial_defense_text_042")
	elseif otherPlayer.allianceInfo then
		otherName = self:getWrappedName(otherPlayer.allianceInfo.abbr, otherPlayer.uinfo.nickName)
	else
		otherName = otherPlayer.uinfo.nickName
	end
	return otherName
end
function mailFunctions:getMailDate(mail)
	local propertyData = mail.property
	local time = propertyData.time
	if type(time) == "string" then
		time = 0
	end
	local strTime = SoraDConvertTimeToDate(time, false, true)
	return strTime
end
function mailFunctions:getAttackName(type)
	_UPVALUE4_ = nil
	;(nil)[1] = "fight_mail_11"
	;(nil)[2] = "fight_mail_12"
	;(nil)[3] = "fight_mail_14"
	local (nil)[4], nameList = "fight_mail_13", nil
	return i18n(nameList[type])
end
function mailFunctions:isCityBattle(sourceType)
	if sourceType == gMailSource.ATTACT_CITY_VICTORY or sourceType == gMailSource.ATTACT_CITY_LOSE or sourceType == gMailSource.DEFENSE_CITY_VICTORY or sourceType == gMailSource.DEFENSE_CITY_LOSE then
		return true
	end
end
function mailFunctions:getTotalNumStr(attackSummary, defenceSummary, isNumber)
	local unknownStr = "????"
	local attackTotalNum, defenceTotalNum
	if attackSummary.lostNum or attackSummary.woundedNum or attackSummary.surviveNum or not not attackSummary.woundedRebackNum then
		attackTotalNum = (attackSummary.lostNum or 0) + (attackSummary.woundedNum or 0) + (attackSummary.surviveNum or 0) + (attackSummary.woundedRebackNum or 0)
	end
	if defenceSummary.lostNum or defenceSummary.woundedNum or defenceSummary.surviveNum or not not defenceSummary.woundedRebackNum then
		defenceTotalNum = (defenceSummary.lostNum or 0) + (defenceSummary.woundedNum or 0) + (defenceSummary.surviveNum or 0) + (defenceSummary.woundedRebackNum or 0)
	end
	if isNumber then
		return attackTotalNum, defenceTotalNum
	end
	local attackNum = attackTotalNum and string.formatnumberthousands(attackTotalNum) or unknownStr
	local defenceNum = defenceTotalNum and string.formatnumberthousands(defenceTotalNum) or unknownStr
	return attackNum, defenceNum
end
function mailFunctions:getFightDetailTitle(v, defendName, attackName)
	local name1, name2, color1, color2
	if v[1] == 0 then
		name1 = defendName
		name2 = attackName
		color2 = "#A02828"
		color1 = "#13508F"
	else
		name1 = attackName
		name2 = defendName
		color1 = "#A02828"
		color2 = "#13508F"
	end
	local damage = SoraDConvertNumberWithUnit(v[3])
	local num = SoraDConvertNumberWithUnit(v[4])
	local backDamage = v[5] and v[5].strikeBackDmg or 0
	if 0 < backDamage then
		_ENV = nil
		;(nil).name1 = name1
		;(nil).name2 = name2
		;(nil).damage_tpye = self:getAttackName(v[2])
		_ENV, _ENV, (nil).num = self, self:getAttackName(v[2]), damage
		_ENV, self:getAttackName(v[2]).name1, self.color = self, self, color1
		_ENV, self:getAttackName(v[2]).name2, self.color = self, self, color2
		_ENV, self:getAttackName(v[2]).damage_tpye, self.b = self, self, gDmgType.normal ~= v[2]
		_ENV, self:getAttackName(v[2]).num, self.color = self, self, "#A02828"
		self:getAttackName(v[2]).__default, self.color = self, "#55230F"
		local str = i18n_html("war_report_text_0017", nil, (self:getAttackName(v[2])))
		_ENV = self
		self.color = "#55230F"
		_ENV = gDmgType.normal ~= v[2]
		;(gDmgType.normal ~= v[2]).name1 = name2
		;(gDmgType.normal ~= v[2]).name2 = name1
		;(gDmgType.normal ~= v[2]).damage_tpye = self:getAttackName(4)
		_ENV, _ENV, (gDmgType.normal ~= v[2]).num = backDamage, SoraDConvertNumberWithUnit(backDamage), SoraDConvertNumberWithUnit(backDamage)
		_ENV, SoraDConvertNumberWithUnit(backDamage).name1, backDamage.color = backDamage, backDamage, color2
		_ENV, SoraDConvertNumberWithUnit(backDamage).name2, backDamage.color = backDamage, backDamage, color1
		_ENV, SoraDConvertNumberWithUnit(backDamage).damage_tpye, backDamage.b = backDamage, backDamage, true
		_ENV, SoraDConvertNumberWithUnit(backDamage).num, backDamage.color = backDamage, backDamage, "#A02828"
		SoraDConvertNumberWithUnit(backDamage).__default, backDamage.color = backDamage, "#55230F"
		str = str .. SoraDWrapHtmlTagByStyle(",", self) .. i18n_html("war_report_text_0017", gDmgType.normal ~= v[2], (SoraDConvertNumberWithUnit(backDamage)))
		return str
	else
		_ENV = SoraDWrapHtmlTagByStyle(",", self)
		SoraDWrapHtmlTagByStyle(",", self).name1 = name1
		SoraDWrapHtmlTagByStyle(",", self).name2 = name2
		SoraDWrapHtmlTagByStyle(",", self).damageType = self:getAttackName(v[2])
		SoraDWrapHtmlTagByStyle(",", self).damage = damage
		_ENV, _ENV, SoraDWrapHtmlTagByStyle(",", self).num = self, self:getAttackName(v[2]), num
		_ENV, self:getAttackName(v[2]).name1, self.color = self, self, color1
		_ENV, self:getAttackName(v[2]).name2, self.color = self, self, color2
		_ENV, self:getAttackName(v[2]).damageType, self.b = self, self, gDmgType.normal ~= v[2]
		_ENV, self:getAttackName(v[2]).damage, self.color = self, self, "#A02828"
		_ENV, self:getAttackName(v[2]).num, self.color = self, self, "#B45900"
		self:getAttackName(v[2]).__default, self.color = self, "#55230F"
		return i18n_html("fight_mail_10", SoraDWrapHtmlTagByStyle(",", self), (self:getAttackName(v[2])))
	end
end
function mailFunctions:getFightDetailSpecialEffectTitle(skillType, times, name, defendName, attackOrDefend)
	local mailDesRead = include("mailDesRead")
	local special_skill, attacked = mailDesRead.getBattleLogSpecial(skillType)
	if special_skill == nil then
		return nil
	end
	return special_skill, attacked
end
return mailFunctions
