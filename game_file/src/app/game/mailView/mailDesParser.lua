local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local mailDesRead = include("mailDesRead")
local kingsOrderRead = include("kingsOrderRead")
local allianceDesRead = include("allianceDesRead")
local alliancePetRead = include("alliancePetRead")
local heroTrialltCtrl = include("heroTrialltCtrl")
local chatFunctions = include("chatFunctions")
local publicRead = include("publicRead")
local worldMapDefine = include("worldMapDefine")
local mailFunctions = include("mailFunctions")
local textParser = include("textParser")
local mailLogic = include("mailLogic")
local chatDesRead = include("chatDesRead")
local chatDataParser = include("chatDataParser")
local mailDesParser.npcFuncMap, _ENV, mailDesParser.mailSourceFuncMap, _ENV, mailDesParser.mailTypeDesFuncMap, _ENV, _ENV, mailDesParser = nil, nil, nil, nil, nil, nil, "chatDataParser", "chatDataParser"
local string_fnt = string.formatnumberthousands
function mailDesParser.getTextTip(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local mailContentType = mail.property.data.contentType
	local content = mail.property.data.content
	if mail.property.data.ml_content and mail.property.data.defaultLanguage then
		content = mail.property.data.ml_content[mail.property.data.defaultLanguage]
	end
	local strTip
	local mailTypeDesFunc = mailDesParser.mailTypeDesFuncMap[mailType] and mailDesParser.mailTypeDesFuncMap[mailType].parseDes
	if mailTypeDesFunc then
		strTip = mailTypeDesFunc(mail)
		if strTip then
			return strTip
		end
	end
	local mailDesInfo = mailDesRead.getMailDesInfo(mailType, mailSource, mailContentType)
	if mailDesInfo == nil then
		return "undefined"
	end
	local describeParseType = mailDesInfo.describeParseType
	if describeParseType == gMailParseType.AUTO then
		local formatedStr = mailDesInfo.describe
		local manualNpcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseDes
		if manualNpcFunc then
			strTip = manualNpcFunc(mail, mailDesInfo, content, formatedStr)
		else
			strTip = mailDesParser.autoNpcParseDes(mail, mailDesInfo, content, formatedStr)
		end
	else
		strTip = mailDesParser.manualNpcParseDes(mail, mailDesInfo, content)
	end
	if not strTip then
		return "undefined" .. mailContentType
	end
	if mailContentType ~= gMailNPCContentType.Content_Text then
		strTip = string.htmlspecialchars(strTip)
	end
	return strTip
end
function mailDesParser.getDetailMailTitle(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local mailTitle = ""
	if mailType == gMailType.INVITE_MOVE_CITY or mailType == gMailType.GIVE_ITEM then
		print("ailDesParser.getDetailMailTitl-2", mailType, mailTitle)
		mailTitle = ""
	end
	if gMailSetTypeFunc.checkUseMailDes(mailSource) then
		local viewAngle = mailFunctions:getViewAngleFromMail(mail)
		if viewAngle == gMailViewAngle.THIRDPERSON then
			mailTitle = mailDesParser.getMailTitle(mail)
			print("ailDesParser.getDetailMailTitl-3", mailType, mailTitle)
		else
			mailTitle = mailFunctions:getMailDes(mail)
			print("ailDesParser.getDetailMailTitl-4", mailType, mailTitle)
		end
	end
	if not mailTitle or mailTitle == "" then
		mailTitle = mailDesParser.getMailSummary(mail)
		print("ailDesParser.getDetailMailTitl-5", mailType, mailTitle)
	end
	return mailTitle
end
function mailDesParser.getMailTitle(mail)
	local mailType = mail.property.mailType
	local mailTitle
	local mailTypeTitleFunc = mailDesParser.mailTypeDesFuncMap[mailType] and mailDesParser.mailTypeDesFuncMap[mailType].parseTitle
	if mailTypeTitleFunc then
		mailTitle = mailTypeTitleFunc(mail)
	else
		mailTitle = mailDesParser.defaultMailTypeParseTitle(mail)
	end
	if mailTitle then
		return mailTitle
	end
	return i18n("mail_text_26")
end
function mailDesParser.getMailSummary(mail)
	local mailType = mail.property.mailType
	local mailSummary
	local mailTypeSummaryFunc = mailDesParser.mailTypeDesFuncMap[mailType] and mailDesParser.mailTypeDesFuncMap[mailType].parseSummary
	if mailTypeSummaryFunc then
		mailSummary = mailTypeSummaryFunc(mail)
		if mailSummary then
			return string.htmlspecialchars(mailSummary)
		end
	else
		mailSummary = mailDesParser.defaultMailTypeParseSummary(mail)
		if mailSummary then
			return string.htmlspecialchars(mailSummary)
		end
	end
	if device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		local mailContentType = mail.property.data.contentType
		return "undefined" .. mailContentType
	else
		return "undefined"
	end
end
function mailDesParser.getMailMidSummary(mail)
	local mailType = mail.property.mailType
	local midSummary
	local mailTypeMidSummaryFunc = mailDesParser.mailTypeDesFuncMap[mailType] and mailDesParser.mailTypeDesFuncMap[mailType].parseMidSummary
	if mailTypeMidSummaryFunc then
		midSummary = mailTypeMidSummaryFunc(mail)
		if midSummary then
			return midSummary
		end
	else
		midSummary = mailDesParser.defaultMailTypeParseMidSummary(mail)
		if midSummary then
			return midSummary
		end
	end
	return nil
end
function mailDesParser.getPlayerFightTitle(contentData, playerInfo, num, needKid)
	local uinfo = playerInfo.uinfo
	local allianceInfo = playerInfo.allianceInfo
	local name = ""
	if uinfo then
		name = uinfo.nickName
	elseif playerInfo.bInfo then
		local subMapType = playerInfo.bInfo.id
		local buildName = allianceDesRead.getBuildName(subMapType)
		name = buildName
	end
	local strName = ""
	if allianceInfo then
		strName = mailFunctions:getWrappedName(allianceInfo.abbr, name)
	end
	local strInfo = ""
	if uinfo then
		if uinfo.id == 0 then
			playerInfo.isNpc = true
			if contentData and next(contentData) ~= nil then
				local mapType = contentData.mapType
				if mapType == gMapObjTypeDef.mapObjNewTrialCity then
					local subMapType = contentData.subMapType
					if subMapType == _G.gMapNewTrialBuildType.subMapTypeDVWBattery then
						strInfo = i18n("devilvalley_text_20")
					else
						strInfo = i18n("devilvalley_text_22")
					end
				elseif mapType == gMapObjTypeDef.mapTypeRadianceWarBeacon or mapType == gMapObjTypeDef.mapTypeRadianceWarGate or mapType == gMapObjTypeDef.mapTypeRadianceWarResource then
					if allianceInfo and allianceInfo.flag then
						strInfo = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name, allianceInfo.kid)
						playerInfo.buildIcon = allianceDesRead.getFlagIcon(allianceInfo.flag)
					else
						strInfo = mailFunctions:getMapBuildName(contentData)
						playerInfo.buildIcon = mailFunctions:getMapBuildIcon(contentData)
					end
					playerInfo.isTrialMail = false
					playerInfo.isBuild = true
				elseif mapType == gMapObjTypeDef.stronghold then
					_UPVALUE3_ = gMapObjTypeDef.stronghold
					gMapObjTypeDef.stronghold[1] = "alliance_stronghold_text_130"
					gMapObjTypeDef.stronghold[2] = "alliance_stronghold_text_131"
					local gMapObjTypeDef.stronghold[3], titleConfig = "alliance_stronghold_text_132", gMapObjTypeDef.stronghold
					if contentData.isKillLeaderNpc then
						strInfo = i18n("alliance_stronghold_text_049")
					elseif contentData.killNormalNpcLv and 0 < contentData.killNormalNpcLv and contentData.killNormalNpcLv < 4 then
						strInfo = i18n(titleConfig[contentData.killNormalNpcLv])
					end
				elseif mapType == gMapObjTypeDef.mapObjTypeKingdomLevelBuild then
					playerInfo.buildIcon = "icon_mail_monster.png"
					strInfo = i18n("Celestial_defense_text_076")
				end
				if contentData.commandHallTaskID then
					local commandHallRead = include("commandHallRead")
					strInfo = commandHallRead.getTaskName(contentData.commandHallTaskID)
					playerInfo.buildIcon = "pjjt_full.png"
				end
			end
		else
			if contentData and next(contentData) ~= nil then
				local mapType = contentData.mapType
				print("needKid,mapType", needKid, mapType)
				if mapType == gMapObjTypeDef.nebulaDefenceWarBuilding and uinfo.nickName == nil then
					local activity_9001573_Read = include("activity_9001573_Read")
					strName = activity_9001573_Read.getBuildName(uinfo.id)
					playerInfo.buildIcon = activity_9001573_Read.getBuildMailImg(uinfo.id)
					playerInfo.isNpc = true
				elseif (needKid or mapType == gMapObjTypeDef.mapTypeRadianceWarBeacon or mapType == gMapObjTypeDef.mapTypeRadianceWarGate or mapType == gMapObjTypeDef.mapTypeRadianceWarResource) and uinfo.kid then
					strName = strName .. "#" .. uinfo.kid
				end
				if mapType == nil and strName == "" then
					strName = uinfo.nickName
				end
			end
			if 1 < num then
				allianceDesRead = "#"
				;("#").name = strName
				strInfo = i18n("common_text_119", "#")
			else
				strInfo = strName
			end
			if uinfo and uinfo.battleType and (uinfo.battleType == gArenaBattleType.RAIDER_LOST_ARK or uinfo.battleType == gArenaBattleType.STAR_ENERGY_CUBE) then
				strInfo = ""
			end
		end
	else
		strInfo = strName
	end
	return strInfo
end
function mailDesParser.defaultNpcParseDes(mail, mailDesInfo, content, formatedStr)
	local mailContentType = mail.property.data.contentType
	local strTip
	if formatedStr ~= nil and formatedStr ~= "" then
		strTip = i18n(formatedStr, content)
	else
		strTip = "undefined, content type = " .. mailContentType
	end
	return strTip
end
function mailDesParser.defaultMailTypeParseTitle(mail)
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	if mailInfo and mailInfo.title ~= "" then
		local titleParseType = mailInfo.titleParseType
		local mailTitle
		if titleParseType == gMailParseType.AUTO then
			mailTitle = mailDesParser.autoParseBasic(mailInfo.title, mail.property.data)
		else
			mailTitle = i18n(mailInfo.title, mail.property.data)
		end
		return mailTitle
	end
end
function mailDesParser.defaultMailTypeParseSummary(mail)
	local mailInfo = mailDesRead.getMailTypeInfo(0, mail.property.mailType, mail.property.source)
	local mailsummary
	if mailInfo ~= nil and mailInfo.summary ~= "" then
		local summaryParseType = mailInfo.summaryParseType
		if summaryParseType == gMailParseType.AUTO then
			mailsummary = mailDesParser.autoParseBasic(mailInfo.summary, mail.property.data)
		else
			mailsummary = i18n(mailInfo.summary, mail.property.data)
		end
	end
	return mailsummary
end
function mailDesParser.defaultMailTypeParseMidSummary(mail)
	local mailInfo = mailDesRead.getMailTypeInfo(0, mail.property.mailType, mail.property.source)
	local midSummary
	if mailInfo ~= nil and mailInfo.midsummary and mailInfo.midsummary ~= "" then
		local summaryParseType = mailInfo.summaryParseType
		if summaryParseType == gMailParseType.AUTO then
			midSummary = mailDesParser.autoParseBasic(mailInfo.midsummary, mail.property.data)
		else
			midSummary = i18n(mailInfo.midsummary, mail.property.data)
		end
	end
	return midSummary
end
function mailDesParser.autoNpcParseDes(mail, mailDesInfo, content, formatedStr)
	local strTip
	local valueMap = textParser.parseValues(content)
	if formatedStr then
		strTip = i18n(formatedStr, valueMap)
	end
	return strTip
end
function mailDesParser.manualNpcParseDes(mail, mailDesInfo, content)
	local mailContentType = mail.property.data.contentType
	local strTip
	local formatedStr = mailDesInfo.describe
	local manualNpcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseDes
	if manualNpcFunc then
		strTip = manualNpcFunc(mail, mailDesInfo, content, formatedStr)
		return strTip
	else
		return mailDesParser.defaultNpcParseDes(mail, mailDesInfo, content, formatedStr)
	end
end
function mailDesParser.defaultNpcParseTitle(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local mailContentType = mail.property.data.contentType
	local mailTitle
	local mailDesInfo = mailDesRead.getMailDesInfo(mailType, mailSource, mailContentType)
	if mailDesInfo and mailDesInfo.title and mailDesInfo.title ~= "" then
		local titleParseType = mailDesInfo.titleParseType
		if titleParseType == gMailParseType.AUTO then
			mailTitle = mailDesParser.autoParseBasic(mailDesInfo.title, mail.property.data.content)
		else
			mailTitle = i18n(mailDesInfo.title, mail.property.data.content)
		end
	end
	return mailTitle
end
function mailDesParser.defaultNpcParseSummary(mail)
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	local formatedStr, summary
	if mailDesInfo then
		formatedStr = mailDesInfo.summary
		if formatedStr and formatedStr ~= "" then
			local summaryParseType = mailDesInfo.summaryParseType
			if summaryParseType == gMailParseType.AUTO then
				summary = mailDesParser.autoParseBasic(mailDesInfo.summary, mail.property.data.content)
			else
				summary = i18n(mailDesInfo.summary, mail.property.data.content)
			end
		end
	end
	if not summary and mail.property.data.content and mail.property.data.content.title then
		summary = mail.property.data.content.title
	end
	return summary
end
function mailDesParser.getBattleTitleThirdPerson_build(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local ret = "NA"
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local buildName = mailFunctions:getMapBuildName(contentData)
	print("buildName = ", buildName)
	mailDesParser = buildName
	buildName.name = buildName
	ret = i18n("mail_text_492", buildName)
	return ret
end
function mailDesParser.getBattleTitleThirdPerson_city(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local ret = "NA"
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local playerInfo = contentData.playerInfo2
	if not playerInfo.uinfo then
		mailDesParser = playerInfo.uinfo
	end
	if not playerInfo.allianceInfo then
		mailDesParser = playerInfo.allianceInfo
	end
	local strName = mailDesParser.getWrappedNameEx(playerInfo.uinfo, playerInfo.allianceInfo)
	local buildName = i18n("buildDes_name_101")
	mailDesParser = nil
	;(nil).name = strName
	;(nil).build = buildName
	ret = i18n("mail_text_491", nil)
	return ret
end
function mailDesParser.getBattleTitleThirdPerson_troop(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local ret = "NA"
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local playerInfo = contentData.playerInfo2
	if not playerInfo.uinfo then
		mailDesParser = playerInfo.uinfo
	end
	if not playerInfo.allianceInfo then
		mailDesParser = playerInfo.allianceInfo
	end
	local strName = mailDesParser.getWrappedNameEx(playerInfo.uinfo, playerInfo.allianceInfo)
	local buildName = i18n("common_text_598")
	mailDesParser = nil
	;(nil).name = strName
	;(nil).build = buildName
	ret = i18n("mail_text_491", nil)
	return ret
end
function mailDesParser.getBattleTitleThirdPerson_default(mail)
	local mailTitle
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local buildName = mailFunctions:getMapBuildName(contentData)
	local playerInfo = contentData.playerInfo2
	if playerInfo and playerInfo.allianceInfo then
		buildName = mailFunctions:getWrappedName(playerInfo.allianceInfo.abbr, buildName)
	end
	print("buildName = ", buildName, isFromBrief)
	local mailDesInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	if mailDesInfo and mailDesInfo.title and mailDesInfo.title ~= "" then
		mailDesParser = mail.property.source
		mail.property.source.build = buildName
		mailTitle = i18n(mailDesInfo.title, mail.property.source)
	end
	return mailTitle
end
function mailDesParser.getBattleSummaryThirdPerson_default(mail)
	local mailSummary
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	if mailInfo and mailInfo.title ~= "" then
		mailSummary = i18n(mailInfo.title)
	else
		mailSummary = "NA"
	end
	return mailSummary
end
function mailDesParser.getBattleTitleThirdPerson(mail)
	local mailSource = mail.property.source
	local func = mailDesParser.mailSourceFuncMap[mailSource] and mailDesParser.mailSourceFuncMap[mailSource].parseTitle3rd
	if func then
		return func(mail)
	else
		return mailDesParser.getBattleTitleThirdPerson_default(mail)
	end
end
function mailDesParser.getBattleSummaryThirdPerson(mail)
	local mailSource = mail.property.source
	local func = mailDesParser.mailSourceFuncMap[mailSource] and mailDesParser.mailSourceFuncMap[mailSource].parseSummary3rd
	if func then
		return func(mail)
	else
		return mailDesParser.getBattleSummaryThirdPerson_default(mail)
	end
end
function mailDesParser.parseScoutReportTitle(mail)
	local mailTitle
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local targetMapObj = contentData.targetMapObj
	local buildName = mailFunctions:getMapBuildName(targetMapObj)
	local mailDesInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	if mailDesInfo and mailDesInfo.title and mailDesInfo.title ~= "" then
		mailDesParser = mail.property.source
		mail.property.source.build = buildName
		mailTitle = i18n(mailDesInfo.title, mail.property.source)
	end
	return mailTitle
end
function mailDesParser.parseBattleReportTitle(mail)
	local mailTitle
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local buildName = mailFunctions:getMapBuildName(contentData)
	local viewAngle = mailFunctions:getViewAngleFromMail(mail)
	if viewAngle == gMailViewAngle.THIRDPERSON then
		mailTitle = mailDesParser.getBattleTitleThirdPerson(mail)
	else
		local mailDesInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
		if mailDesInfo and mailDesInfo.title and mailDesInfo.title ~= "" then
			mailDesParser = mail.property.source
			mail.property.source.build = buildName
			mailTitle = i18n(mailDesInfo.title, mail.property.source)
		end
	end
	return mailTitle
end
function mailDesParser.parseBattleBatteryReportTitle(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	local mailTitle, buildName
	if contentData.targetMapObj then
		buildName = mailFunctions:getMapBuildName(contentData.targetMapObj)
	else
		buildName = mailFunctions:getMapBuildName(contentData)
	end
	local viewAngle = mailFunctions:getViewAngleFromMail(mail)
	if viewAngle == gMailViewAngle.THIRDPERSON then
		mailTitle = mailDesParser.getBattleTitleThirdPerson(mail)
	else
		local mailDesInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
		if mailDesInfo and mailDesInfo.title and mailDesInfo.title ~= "" then
			mailDesParser = mail.property.source
			mail.property.source.build = buildName
			mailTitle = i18n(mailDesInfo.title, mail.property.source)
		end
	end
	return mailTitle
end
function mailDesParser.parseBattleDevilValleyReportTitle(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	local mailTitle
	local buildName = mailFunctions:getMapBuildName(contentData)
	if contentData.mapType == gMapObjTypeDef.mapObjTypePlayer then
		local playerInfo = contentData.playerInfo2
		local strName = mailFunctions:getWrappedName(playerInfo.allianceInfo.abbr, playerInfo.uinfo.nickName)
		mailDesParser = playerInfo.uinfo.nickName
		playerInfo.uinfo.nickName.name = strName
		buildName = i18n("devilvalley_text_45", playerInfo.uinfo.nickName)
	end
	local viewAngle = mailFunctions:getViewAngleFromMail(mail)
	if viewAngle == gMailViewAngle.THIRDPERSON then
		mailTitle = mailDesParser.getBattleTitleThirdPerson(mail)
	else
		local mailDesInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
		if mailDesInfo and mailDesInfo.title and mailDesInfo.title ~= "" then
			mailDesParser = mail.property.source
			mail.property.source.build = buildName
			mailTitle = i18n(mailDesInfo.title, mail.property.source)
		end
	end
	return mailTitle
end
function mailDesParser.defaultParseBattleReportTitle(mail)
	local mailTitle
	local viewAngle = mailFunctions:getViewAngleFromMail(mail)
	if viewAngle == gMailViewAngle.THIRDPERSON then
		mailTitle = mailDesParser.getBattleTitleThirdPerson(mail)
	else
		local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
		if mailInfo and mailInfo.title ~= "" then
			mailTitle = i18n(mailInfo.title)
		else
			mailTitle = "NA"
		end
	end
	return mailTitle
end
function mailDesParser.defaultParseBattleReportSummary(mail)
	local mailSummary
	local viewAngle = mailFunctions:getViewAngleFromMail(mail)
	if viewAngle == gMailViewAngle.THIRDPERSON then
		mailSummary = mailDesParser.getBattleTitleThirdPerson(mail)
	else
		local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
		if mailInfo and mailInfo.title ~= "" then
			mailSummary = i18n(mailInfo.title)
		else
			mailSummary = "NA"
		end
	end
	return mailSummary
end
function mailDesParser.parseScoutReportSummary(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local des = mailDesParser.getScountSuccessDes(contentData)
	return des
end
function mailDesParser.parseScoutReportMidSummary(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	if not contentData.uinfo then
		mailDesParser = contentData.uinfo
	end
	if not contentData.allianceInfo then
		mailDesParser = contentData.allianceInfo
	end
	local name = mailDesParser.getWrappedNameEx(contentData.uinfo, contentData.allianceInfo)
	return name
end
function mailDesParser.parseScoutBuildReportMidSummary(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	if not contentData.uinfo then
		local mailDesParser, uinfo = contentData.uinfo, contentData.uinfo
	end
	if not contentData.allianceInfo then
		local mailDesParser, allianceInfo = contentData.allianceInfo, contentData.allianceInfo
	end
	local mailSource = mail.property.source
	local targetMapObj = contentData.targetMapObj
	local buildName = mailFunctions:getMapBuildName(targetMapObj)
	local name = mailFunctions:getWrappedName(allianceInfo.abbr, buildName)
	if targetMapObj and targetMapObj.kid and lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= targetMapObj.kid and mailSource ~= gMailSource.SCOUT_LEGENDLORD_SUCCESS then
		name = name .. "#" .. targetMapObj.kid
	end
	if uinfo and uinfo.kid and lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
		name = name .. "#" .. uinfo.kid
	end
	return name
end
function mailDesParser.parseBeScoutedReportSummary(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	if not contentData.uinfo then
		mailDesParser = contentData.uinfo
	end
	if not contentData.allianceInfo then
		mailDesParser = contentData.allianceInfo
	end
	local name = mailDesParser.getWrappedNameEx(contentData.uinfo, contentData.allianceInfo)
	mailDesParser = contentData.uinfo
	local contentData.uinfo.name, argSummary = name, contentData.uinfo
	local brief = mail.property.brief
	if brief and brief.mapType == gMapObjTypeDef.mapObjTypeBattery and brief.objId then
		local palaceInfoRead = include("palaceInfoRead")
		argSummary.build = palaceInfoRead.getBatteryName(brief.objId)
	end
	local mailsummary = i18n(mailInfo.summary, argSummary)
	return mailsummary
end
function mailDesParser.parseBeScoutedReportSummary_build(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local uinfo = contentData.uinfo
	local allianceInfo = contentData.allianceInfo
	if allianceInfo == nil then
		allianceInfo, mailDesParser = nil, nil
	end
	local targetMapObj = contentData.targetMapObj
	local buildName = mailFunctions:getMapBuildName(targetMapObj)
	mailDesParser = nil
	;(nil).name = uinfo.nickName
	;(nil).build = buildName
	local mailsummary = i18n("mail_text_304", nil)
	return mailsummary
end
function mailDesParser.parseBeScoutedReportSummaryFailed(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local uinfo = contentData.uinfo
	local allianceInfo = contentData.allianceInfo
	if allianceInfo == nil then
		allianceInfo, mailDesParser = nil, nil
	end
	local mailsummary
	local strItemName = i18n("common_text_110")
	if uinfo then
		local name = mailDesParser.getWrappedNameEx(uinfo, allianceInfo)
		mailDesParser = nil
		;(nil).name = name
		;(nil).tool = strItemName
		mailsummary = i18n("common_text_3133", nil)
	else
		mailDesParser = "common_text_3133"
		;("common_text_3133").name = strItemName
		mailsummary = i18n(mailInfo.summary, "common_text_3133")
	end
	return mailsummary
end
function mailDesParser.parseScoutReportSummaryFailed(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local uinfo = contentData.uinfo
	local allianceInfo = contentData.allianceInfo
	if allianceInfo == nil then
		allianceInfo, mailDesParser = nil, nil
	end
	local mailsummary
	local strItemName = i18n("common_text_110")
	if uinfo then
		local name = mailDesParser.getWrappedNameEx(uinfo, allianceInfo)
		mailDesParser = nil
		;(nil).name = name
		;(nil).tool = strItemName
		mailsummary = i18n("common_text_3132", nil)
	else
		mailDesParser = "common_text_3132"
		;("common_text_3132").name = strItemName
		mailsummary = i18n(mailInfo.summary, "common_text_3132")
	end
	return mailsummary
end
function mailDesParser.parseOccupySummary(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if not contentData then
		return
	end
	local coordinate = contentData.targetCoordinate
	mailDesParser = nil
	;(nil).x = coordinate.x
	;(nil).y = coordinate.y
	local mailsummary = i18n(mailInfo.summary, nil)
	return mailsummary
end
function mailDesParser.parseFightSummary_city(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local isAttack = mailDesParser.getIsSelfAttack(contentData, isFromBrief, mail.property.receiver)
	local armyInfo
	if isAttack then
		armyInfo = contentData.playerInfo1
	else
		armyInfo = contentData.playerInfo2
	end
	local killNum, lostNum = mailFunctions:getKillAndLostNum(armyInfo)
	mailDesParser = nil
	;(nil).killNum = string.formatnumberthousands(killNum)
	;(nil).lostNum = string.formatnumberthousands(lostNum)
	local mailsummary = i18n(mailInfo.summary, nil)
	return mailsummary
end
function mailDesParser.parseFightSummary_city_3rd(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local playerInfo = contentData.playerInfo2
	if not playerInfo.uinfo then
		mailDesParser = playerInfo.uinfo
	end
	if not playerInfo.allianceInfo then
		mailDesParser = playerInfo.allianceInfo
	end
	local strName = mailDesParser.getWrappedNameEx(playerInfo.uinfo, playerInfo.allianceInfo)
	mailDesParser = nil
	;(nil).name = i18n("common_text_126")
	;(nil).msg = strName
	local mailsummary = i18n("common_text_1000", nil)
	return mailsummary
end
function mailDesParser.parseFightSummary_troop(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local isAttack = mailDesParser.getIsSelfAttack(contentData, isFromBrief, mail.property.receiver)
	local playerInfo
	if isAttack == true then
		playerInfo = contentData.playerInfo2
	else
		playerInfo = contentData.playerInfo1
	end
	if not playerInfo.allianceInfo then
		mailDesParser = playerInfo.allianceInfo
	end
	local strName = mailDesParser.getWrappedNameEx(playerInfo.uinfo, playerInfo.allianceInfo)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	mailDesParser = nil
	;(nil).name = strName
	local mailsummary = i18n(mailInfo.summary, nil)
	return mailsummary
end
function mailDesParser.parseFightSummary_commandHall(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local playerInfo = contentData.playerInfo2
	local killNum, lostNum = mailFunctions:getKillAndLostNum(playerInfo)
	local strName = mailDesParser.parseFightMidSummaryByPlayerInfo(contentData, playerInfo)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	mailDesParser = nil
	;(nil).killNum = string.formatnumberthousands(killNum)
	;(nil).lostNum = string.formatnumberthousands(lostNum)
	;(nil).name = strName
	local mailsummary = i18n(mailInfo.summary, nil)
	return mailsummary
end
function mailDesParser.parseFightMidSummary_city(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local isAttack = mailDesParser.getIsSelfAttack(contentData, isFromBrief, mail.property.receiver)
	local playerInfo
	if isAttack == true then
		playerInfo = contentData.playerInfo2
	else
		playerInfo = contentData.playerInfo1
	end
	local strName = ""
	if playerInfo.uinfo and playerInfo.uinfo.id == 0 then
		strName = mailFunctions:getMapBuildName(contentData)
	else
		if not playerInfo.uinfo then
			mailDesParser = playerInfo.uinfo
		end
		if not playerInfo.allianceInfo then
			mailDesParser = playerInfo.allianceInfo
		end
		strName = mailDesParser.getWrappedNameEx(playerInfo.uinfo, playerInfo.allianceInfo)
	end
	return strName
end
function mailDesParser.parseFightMidSummary_city_3rd(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local playerInfo = contentData.playerInfo1
	if not playerInfo.uinfo then
		mailDesParser = playerInfo.uinfo
	end
	if not playerInfo.allianceInfo then
		mailDesParser = playerInfo.allianceInfo
	end
	local strName = mailDesParser.getWrappedNameEx(playerInfo.uinfo, playerInfo.allianceInfo)
	mailDesParser = nil
	;(nil).name = i18n("common_text_125")
	;(nil).msg = strName
	strName = i18n("common_text_1000", nil)
	return strName
end
function mailDesParser.parseFightMidSummary_build(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local playerInfo = contentData.playerInfo2
	return mailDesParser.parseFightMidSummaryByPlayerInfo(contentData, playerInfo)
end
function mailDesParser.parseFightMidSummaryByPlayerInfo(contentData, playerInfo)
	if not playerInfo.allianceInfo then
		local mailFunctions, allianceInfo = playerInfo.allianceInfo, playerInfo.allianceInfo
	end
	local buildName = mailFunctions:getMapBuildName(contentData)
	local strName = mailFunctions:getWrappedName(allianceInfo.abbr, buildName)
	local strName = buildName
	if playerInfo and playerInfo.bInfo and playerInfo.bInfo.kid then
		if lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= playerInfo.bInfo.kid then
			strName = strName .. "#" .. playerInfo.bInfo.kid
		end
	elseif playerInfo and playerInfo.uinfo and playerInfo.uinfo.kid then
		if playerInfo.uinfo.nickName then
			strName = mailFunctions:getWrappedName(allianceInfo.abbr, playerInfo.uinfo.nickName)
		end
		if lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= playerInfo.uinfo.kid then
			strName = strName .. "#" .. playerInfo.uinfo.kid
		end
	elseif playerInfo and playerInfo.uinfo and playerInfo.uinfo.id == 0 then
		if contentData.mapType == gMapObjTypeDef.stronghold then
			_UPVALUE3_ = contentData.mapType
			contentData.mapType[1] = "alliance_stronghold_text_130"
			contentData.mapType[2] = "alliance_stronghold_text_131"
			local contentData.mapType[3], titleConfig = "alliance_stronghold_text_132", contentData.mapType
			if contentData.isKillLeaderNpc then
				strName = i18n("alliance_stronghold_text_049")
			elseif contentData.killNormalNpcLv and 0 < contentData.killNormalNpcLv and contentData.killNormalNpcLv < 4 then
				strName = i18n(titleConfig[contentData.killNormalNpcLv])
			end
		end
		if contentData.commandHallTaskID then
			local commandHallRead = include("commandHallRead")
			strName = commandHallRead.getTaskName(contentData.commandHallTaskID)
		end
	end
	return strName
end
function mailDesParser.parseFightMidSummary_commandHall(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local isAttack = mailDesParser.getIsSelfAttack(contentData, isFromBrief, mail.property.receiver)
	local playerInfo
	if isAttack == true then
		playerInfo = contentData.playerInfo2
	else
		playerInfo = contentData.playerInfo1
	end
	return mailDesParser.parseFightMidSummaryByPlayerInfo(contentData, playerInfo)
end
function mailDesParser.parseFightMidSummary_radianceBuild(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local playerInfo = contentData.playerInfo2
	if not playerInfo.allianceInfo then
		local mailDesParser, allianceInfo = playerInfo.allianceInfo, playerInfo.allianceInfo
	end
	if not playerInfo.uinfo then
		local mailDesParser, uinfo = playerInfo.uinfo, playerInfo.uinfo
	end
	local strName
	if uinfo.id then
		if uinfo.id > 0 then
			strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName, uinfo.kid)
		elseif allianceInfo.name or allianceInfo.abbr then
			strName = mailFunctions:getWrappedName(allianceInfo.abbr, allianceInfo.name, allianceInfo.kid)
		else
			strName = mailFunctions:getMapBuildName(contentData)
		end
	else
		strName = mailFunctions:getMapBuildName(contentData)
	end
	return strName
end
function mailDesParser.parseFightMidSummary_devilvalleybuild(mail)
	local contentData, isFromBrief = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return ""
	end
	local isAttack = mailDesParser.getIsSelfAttack(contentData, isFromBrief, mail.property.receiver)
	if isAttack == true then
		return i18n("devilvalley_text_22")
	else
		return i18n("devilvalley_text_20")
	end
end
function mailDesParser.getWrappedNameEx(uinfo, allianceInfo)
	local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
	if uinfo and uinfo.kid and lordInfoCtrl:getMapSourceKid() > 0 and lordInfoCtrl:getMapSourceKid() ~= uinfo.kid then
		strName = strName .. "#" .. uinfo.kid
	end
	return strName
end
function mailDesParser.parseEscortRobSummary(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local mailsummary
	if mailInfo.summary and contentData and next(contentData) ~= nil then
		if not contentData.playerInfo2.allianceInfo then
			local mailDesParser, allianceInfo = contentData.playerInfo2.allianceInfo, contentData.playerInfo2.allianceInfo
		end
		if not contentData.playerInfo2.uinfo then
			local mailDesParser, uinfo = contentData.playerInfo2.uinfo, contentData.playerInfo2.uinfo
		end
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		mailDesParser = uinfo.nickName
		uinfo.nickName.name = strName
		mailsummary = i18n(mailInfo.summary, uinfo.nickName)
	end
	return mailsummary
end
function mailDesParser.parseEscortDefSummary(mail)
	local mailInfo = mailDesParser.getMailTypeInfo(mail)
	local contentData = mailDesParser.getMailContentData(mail)
	if contentData == nil then
		return
	end
	local mailsummary
	if mailInfo.summary and mailInfo.summary ~= "" and contentData and next(contentData) ~= nil then
		if not contentData.playerInfo1 or not contentData.playerInfo1.allianceInfo then
			local mailDesParser, allianceInfo = contentData.playerInfo1.allianceInfo, contentData.playerInfo1.allianceInfo
		end
		if not contentData.playerInfo1 or not contentData.playerInfo1.uinfo then
			local mailDesParser, uinfo = contentData.playerInfo1.uinfo, contentData.playerInfo1.uinfo
		end
		local strName = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
		mailDesParser = uinfo.nickName
		uinfo.nickName.name = strName
		mailsummary = i18n(mailInfo.summary, uinfo.nickName)
	end
	return mailsummary
end
function mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
	local mailInfo = mailDesParser.getMailDesInfo(mail)
	local formatedStr = mailInfo.summary
	local contentData = mailDesParser.getMailContentData(mail)
	local mailsummary
	if formatedStr ~= "" then
		local bossType = contentData.content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType, contentData.content.lv)
		bossName = i18n(bossName)
		mailDesParser = nil
		;(nil).lv = contentData.content.lv
		;(nil).bossName = bossName
		;(nil).BossName = bossName
		mailsummary = i18n(formatedStr, nil)
	end
	return mailsummary
end
function mailDesParser.npcFuncMap_parseAncientTreasureSummary(mail)
	local mailInfo = mailDesParser.getMailDesInfo(mail)
	local formatedStr = mailInfo.summary
	local contentData = mailDesParser.getMailContentData(mail)
	local mailsummary
	if formatedStr ~= "" then
		local ancientTreasureRead = include("ancientTreasureRead")
		local buildInfo = ancientTreasureRead.getBuildInfo(contentData.content.buildType)
		mailDesParser = nil
		;(nil).type = i18n(buildInfo.name)
		;(nil).num = buildInfo.num
		mailsummary = i18n(formatedStr, nil)
	end
	return mailsummary
end
_ENV = nil
;(nil).parseTitle = function(mail)
	local mailSource = mail.property.source
	local mailTitle
	local titleFunc = mailDesParser.mailSourceFuncMap[mailSource] and mailDesParser.mailSourceFuncMap[mailSource].parseTitle
	if titleFunc then
		mailTitle = titleFunc(mail)
	end
	mailTitle = mailTitle or mailDesParser.defaultParseBattleReportTitle(mail)
	if not mailTitle then
		return "undefined"
	end
	return mailTitle
end
;(nil).parseSummary = function(mail)
	local mailSource = mail.property.source
	local mailsummary
	local summaryFunc = mailDesParser.mailSourceFuncMap[mailSource] and mailDesParser.mailSourceFuncMap[mailSource].parseSummary
	if summaryFunc then
		mailsummary = summaryFunc(mail)
	end
	mailsummary = mailsummary or mailDesParser.defaultParseBattleReportSummary(mail)
	if not mailsummary then
		return "undefined"
	end
	return mailsummary
end
mailDesParser.mailTypeDesFuncMap[gMailType.BATTLE_REPORT], (nil).parseMidSummary = nil, function(mail)
	local mailSource = mail.property.source
	local midSummary
	local midSummaryFunc = mailDesParser.mailSourceFuncMap[mailSource] and mailDesParser.mailSourceFuncMap[mailSource].parseMidSummary
	if midSummaryFunc then
		midSummary = midSummaryFunc(mail)
	end
	return midSummary
end
_ENV = nil
;(nil).parseTopTitle = function(mail)
	return i18n("common_text_541")
end
;(nil).parseDes = function(mail)
	local strTip = ""
	if mail.property.data.content then
		strTip = mail.property.data.content.text
	end
	return strTip
end
;(nil).parseTitle = function(mail)
	local mailType = mail.property.mailType
	local mailSetType = mail.property.mailSetType
	local mailTitle = i18n("common_text_541")
	if mailSetType == gMailSetType.NOTICE then
		mailTitle = i18n("mail_text_146")
	end
	if mail.property.data.content and mail.property.data.content.head then
		mailTitle = mail.property.data.content.head
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.SYSTEM_NOTICE], (nil).parseSummary = nil, function(mail)
	local contentType = mail.property.data.contentType
	local mailsummary
	if contentType == gMailSystemNoticeType.Content_Version_Update then
		_ENV = nil
		;(nil).name = mail.property.data.content.version
		mailsummary = i18n("mail_text_44", nil)
	elseif contentType == gMailSystemNoticeType.Content_Custom_Notice then
		mailsummary = mail.property.data.content.title
	end
	return mailsummary
end
_ENV = nil
;(nil).parseTopTitle = function(mail)
	return i18n("common_text_541")
end
;(nil).parseDes = function(mail)
	local strTip = ""
	local content = mail.property.data.content
	if mail.property.data.ml_content and mail.property.data.defaultLanguage then
		content = mail.property.data.ml_content[mail.property.data.defaultLanguage]
	end
	if content then
		strTip = content.text
	end
	return strTip
end
;(nil).parseTitle = function(mail)
	local mailType = mail.property.mailType
	local mailSetType = mail.property.mailSetType
	local mailTitle = i18n("common_text_541")
	if mailSetType == gMailSetType.NOTICE then
		mailTitle = i18n("mail_text_146")
	end
	if mail.property.data.content and mail.property.data.content.head then
		mailTitle = mail.property.data.content.head
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_SYSTEM_NOTICE], (nil).parseSummary = nil, function(mail)
	local contentType = mail.property.data.contentType
	local mailsummary
	local content = mail.property.data.content
	if mail.property.data.ml_content and mail.property.data.defaultLanguage then
		content = mail.property.data.ml_content[mail.property.data.defaultLanguage]
	end
	if contentType == gMailSystemNoticeType.Content_Version_Update then
		_ENV = nil
		;(nil).name = content.version
		mailsummary = i18n("mail_text_44", nil)
	elseif contentType == gMailSystemNoticeType.Content_Custom_Notice then
		mailsummary = content.title
	end
	return mailsummary
end
_ENV = nil
;(nil).parseTopTitle = function(mail)
	return i18n("mail_text_146")
end
;(nil).parseDes = mailDesParser.mailTypeDesFuncMap[gMailType.SYSTEM_NOTICE].parseDes
;(nil).parseTitle = function(mail)
	local mailType = mail.property.mailType
	local mailSetType = mail.property.mailSetType
	local mailTitle = i18n("mail_text_03")
	if mailSetType == gMailSetType.NOTICE then
		mailTitle = i18n("mail_text_146")
	end
	if mail.property.data.content and mail.property.data.content.head then
		mailTitle = mail.property.data.content.head
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY_NOTICE], (nil).parseSummary = nil, function(mail)
	local contentType = mail.property.data.contentType
	local mailsummary
	if contentType == gMailActivityNoticeType.Content_Custom_Notice then
		mailsummary = mail.property.data.content.title
	end
	return mailsummary
end
_ENV = nil
;(nil).parseTopTitle = function(mail)
	return i18n("mail_text_146")
end
;(nil).parseDes = mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_SYSTEM_NOTICE].parseDes
;(nil).parseTitle = function(mail)
	local mailType = mail.property.mailType
	local mailSetType = mail.property.mailSetType
	local mailTitle = i18n("mail_text_03")
	if mailSetType == gMailSetType.NOTICE then
		mailTitle = i18n("mail_text_146")
	end
	if mail.property.data.content and mail.property.data.content.head then
		mailTitle = mail.property.data.content.head
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_ACTIVITY_NOTICE], (nil).parseSummary = nil, function(mail)
	local contentType = mail.property.data.contentType
	local mailsummary
	local content = mail.property.data.content
	if contentType == gMailActivityNoticeType.Content_Custom_Notice then
		if mail.property.data.ml_content and mail.property.data.defaultLanguage then
			content = mail.property.data.ml_content[mail.property.data.defaultLanguage]
		end
		mailsummary = content.title
	end
	return mailsummary
end
_ENV = nil
mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT], (nil).parseSummary = nil, function(mail)
	local mailsummary = mailDesParser.createResReportItemRewards(mail)
	return mailsummary
end
_ENV = nil
;(nil).parseTitle = function(mail)
	local mailTitle
	local targetId = 0
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		if lordInfoCtrl:getLordInfo().base.uid == mail.property.sender then
			targetId = mail.property.receiver
		else
			targetId = mail.property.sender
		end
	end
	if mail:isRoom() then
		mailTitle = mail.property.data.chatroom.crName
	else
		mailTitle = mailFunctions:getWrappedName(mail.property.data.playerInfo.allianceAbbr, mail.property.data.playerInfo.nickName)
		if mail.property.data.playerInfo.sourceKID then
			local sourceKID = chatFunctions:getSelfSourceKID()
			if sourceKID ~= mail.property.data.playerInfo.sourceKID then
				mailTitle = mailTitle .. "#" .. mail.property.data.playerInfo.sourceKID
			end
		end
	end
	if mailTitle == nil or string.len(mailTitle) == 0 then
		mailTitle = tostring(targetId)
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.CHAT], (nil).parseSummary = nil, function(mail)
	local isRoom = mail:isRoom()
	if isRoom and mail.property.data.data.systemType ~= nil then
		local summary = chatDataParser.parseChatRoomSysOp(mail.property.data)
		summary = mailFunctions:getTrimAndFixedWidthStr(summary)
		return summary
	elseif isRoom and mail.property.data.data.chatType ~= nil then
		local chatType = mail.property.data.data.chatType
		local prefix
		local uid = mail.property.data.user.uid
		local isSelf = chatFunctions.getIsPlayerSelf(uid)
		if not isSelf then
			prefix = mail.property.data.user.nickName .. ":"
		else
			prefix = i18n("common_text_2043") .. ":"
		end
		if chatType == gChatRoomChatType.TEXT then
			local summary = mail.property.data.data.content
			summary = mailFunctions:getTrimAndFixedWidthStr(summary)
			summary = prefix .. summary
			summary = string.htmlspecialchars(summary)
			return summary
		elseif chatType == gChatRoomChatType.EMOJI then
			local strImageName = mailDesParser.getRichImgStr(mail.property.data.data.packetId, mail.property.data.data.content)
			local summary = prefix .. strImageName
			return summary
		elseif chatType == gChatRoomChatType.VOICE then
			local content = i18n("common_text_2054")
			local summary = prefix .. content
			return summary
		end
	elseif not isRoom then
		local contentType = mail.property.data.contentType
		local isSendToAll = mail.property.data.isSendToAll
		local uid = mail.property.sender
		local isSelf = chatFunctions.getIsPlayerSelf(uid)
		if contentType == gChatMailContentType.content_text then
			local curl = mail.property.data.curl
			local translation = mail.property.data.translation
			local content = mail.property.data.content
			if not isSelf then
				if curl ~= nil then
					if translation and translation.tl and translation.tText and curl == translation.tl then
						content = translation.tText
					end
				elseif translation ~= nil and translation.tl ~= nil and translation.tText ~= nil then
					content = translation.tText
				end
			end
			if isSendToAll and isSendToAll == 1 then
				content = i18n("common_text_083") .. content
			end
			local summary = mailFunctions:getTrimAndFixedWidthStr(content)
			summary = string.htmlspecialchars(summary)
			return summary
		elseif contentType == gChatMailContentType.content_emo then
			local summary
			local strImageName = mailDesParser.getRichImgStr(mail.property.data.packetId or gDefaultPackageId, mail.property.data.content)
			summary = strImageName
			if isSendToAll and isSendToAll == 1 then
				summary = i18n("common_text_083") .. summary
			end
			return summary
		elseif contentType == gChatMailContentType.content_audio then
			local summary = i18n("common_text_2054")
			return summary
		end
	end
end
_ENV = nil
mailDesParser.mailTypeDesFuncMap[gMailType.EXPLORE], (nil).parseSummary = nil, function(mail)
	local mailsummary
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	local exp = mail.property.data.reward.exp
	local lostArmy = mail.property.data.lostArmy
	local data = mail.property.data
	local mailDesRead, items
	if data.reward.exp > 0 then
		mailDesRead = nil
		;(nil).id = gIDDef.EXP
		;(nil).num = data.reward.exp
		table.insert(items, #items + 1, nil)
	end
	for i, v in ipairs(data.reward.items) do
		mailDesRead = nil
		;(nil).id = tonumber(data.reward.items[i].id)
		;(nil).num = data.reward.items[i].num
		table.insert(items, #items + 1, nil)
	end
	local foodNum = 0
	if items and 0 < #items then
		local des = ""
		for i, v in ipairs(items) do
			mailDesRead = nil
			;(nil).value = string.formatnumberthousands(v.num)
			des = des .. publicRead.getName(v.id) .. i18n("common_text_1952", nil)
			if i < #items then
				des = des .. ","
			end
		end
		mailsummary = des
	else
		mailDesRead = ipairs(items)
		ipairs(items).value = 0
		mailsummary = i18n("common_text_021") .. i18n("common_text_1952", ipairs(items))
	end
	return mailsummary
end
_ENV = nil
;(nil).parseTopTitle = function(mail)
	local mailTopTitle
	local contentType = mail.property.data.contentType
	local func = mailDesParser.npcFuncMap[contentType] and mailDesParser.npcFuncMap[contentType].parseTopTitle
	if func then
		mailTopTitle = func(mail)
	end
	return mailTopTitle
end
;(nil).parseTitle = function(mail)
	local mailContentType = mail.property.data.contentType
	local mailTitle
	local npcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseTitle
	if npcFunc then
		mailTitle = npcFunc(mail)
	else
		mailTitle = mailDesParser.defaultNpcParseTitle(mail)
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.GUIDE], (nil).parseSummary = nil, function(mail)
	local mailContentType = mail.property.data.contentType
	local mailSummary
	local npcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseSummary
	if npcFunc then
		mailSummary = npcFunc(mail)
	else
		mailSummary = mailDesParser.defaultNpcParseSummary(mail)
	end
	return mailSummary
end
_ENV = nil
;(nil).parseTopTitle = function(mail)
	local mailTopTitle
	local contentType = mail.property.data.contentType
	local func = mailDesParser.npcFuncMap[contentType] and mailDesParser.npcFuncMap[contentType].parseTopTitle
	if func then
		mailTopTitle = func(mail)
	end
	return mailTopTitle
end
;(nil).parseTitle = function(mail)
	local mailContentType = mail.property.data.contentType
	local mailTitle
	local npcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseTitle
	if npcFunc then
		mailTitle = npcFunc(mail)
	else
		mailTitle = mailDesParser.defaultNpcParseTitle(mail)
	end
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_GUIDE], (nil).parseSummary = nil, function(mail)
	local mailContentType = mail.property.data.contentType
	local mailSummary
	local npcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseSummary
	if npcFunc then
		mailSummary = npcFunc(mail)
	else
		mailSummary = mailDesParser.defaultNpcParseSummary(mail)
	end
	return mailSummary
end
_ENV = nil
;(nil).parseTitle = function(mail)
	local content = mail.property.data
	return textParser.formatPlayerName(content.playerInfo.allianceAbbr, content.playerInfo.nickName)
end
;(nil).parseDes = function(mail)
	local summary
	local contentType = mail.property.data.contentType
	if contentType == gChatMailContentType.content_text then
		local content = mail.property.data.content
		summary = string.htmlspecialchars(content)
		local tl = SoraDGetCtrl("settingCtrl"):getTranslateLanguage()
		if mail:getShowTransLate() and mail.property.data.translation then
			summary = mail.property.data.translation.tText[tl].text
			local langAbbrRead = include("langAbbrRead")
			local abbrName = langAbbrRead.getAbbrName(mail.property.data.translation.sl)
			abbrName = abbrName and i18n(abbrName)
			_ENV = nil
			;(nil).language = abbrName
			local prefix = i18n("common_text_1635", nil)
			summary = summary .. string.format([[
<font color='#432B0C'>
%s</font>]], prefix)
		end
	elseif contentType == gChatMailContentType.content_emo then
		local strImageName = mailDesParser.getRichImgStr(mail.property.data.packetId or gDefaultPackageId, mail.property.data.content)
		summary = strImageName
	elseif contentType == gChatMailContentType.content_audio then
		summary = i18n("common_text_2054")
	end
	return RemoveStringSpecial(summary)
end
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_GROUP_MAIL], (nil).parseSummary = nil, function(mail)
	local content = mail.property.data
	if content.title and content.title ~= "" then
		return i18n("mail_2_text_13") .. RemoveStringSpecial(content.title)
	else
		return i18n("mail_2_text_13") .. i18n("mail_2_text_14")
	end
end
mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_HELP_REPORT] = mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT]
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT]
mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT].parseTitle = function(mail)
	local mailTopTitle
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	if mailInfo then
		mailDesRead = mail.property.source
		mail.property.source.name = mail.property.data.allianceInfo.property.abbr
		mailTopTitle = i18n(mailInfo.topTitle, mail.property.source)
	end
	return mailTopTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT].parseTopTitle = function(mail)
	local mailTopTitle
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType, mail.property.source)
	if mailInfo then
		mailDesRead = mail.property.source
		mail.property.source.name = mail.property.data.allianceInfo.property.abbr
		mailTopTitle = i18n(mailInfo.topTitle, mail.property.source)
	end
	return mailTopTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION], mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT].parseSummary = mailDesParser.mailTypeDesFuncMap[gMailType.RESOURCE_GATHER_REPORT], function(mail)
	local mailsummary
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType)
	if mailInfo then
		mailDesRead = nil
		;(nil).name = mail.property.data.allianceInfo.property.abbr
		mailsummary = i18n(mailInfo.summary, nil)
	end
	return mailsummary
end
mailDesParser.mailTypeDesFuncMap[gMailType.QUIT_ALLIANCE] = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION]
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION]
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_APPLICATION], mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseTitle = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION], function(mail)
	return mail.property.data.uinfo.nickName
end
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION]
mailDesParser.mailTypeDesFuncMap[gMailType.MONSTER_REPORT], mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseSummary = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION], function(mail)
	local mailInfo = mailDesRead.getMailTypeInfo(false, mail.property.mailType)
	local monsterName = ""
	local monsterLv = 0
	if mail.property.data.monsterInfo ~= nil then
		monsterName = worldMapDefine.getMonsterName(mail.property.data.monsterInfo.id)
		monsterLv = worldMapDefine.getMonsterLevel(mail.property.data.monsterInfo.id)
	end
	local fightResult = mail.property.data.fightResult
	local strResult = ""
	if fightResult == 0 then
		strResult = i18n("common_text_152")
	elseif fightResult == 1 then
		strResult = i18n("common_text_153")
	elseif fightResult == 2 then
		strResult = i18n("common_text_154")
	end
	mailDesRead = nil
	;(nil).name = monsterName
	;(nil).lv = monsterLv
	;(nil).result = strResult
	local mailsummary = i18n(mailInfo.summary, nil)
	return mailsummary
end
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION]
mailDesParser.mailTypeDesFuncMap[gMailType.INVITE_MOVE_CITY], mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseTitle = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION], function(mail)
	local allianceInfo = mail.property.data.allianceInfo
	if allianceInfo == nil then
		allianceInfo, mailFunctions = nil, nil
	end
	return mailFunctions:getWrappedName(allianceInfo.abbr, mail.property.data.uinfo.nickName)
end
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION]
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseDes = function(mail)
	local strTip = mail.property.data.message
	return strTip
end
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseTitle = mailDesParser.mailTypeDesFuncMap[gMailType.INVITE_MOVE_CITY].parseTitle
mailDesParser.mailTypeDesFuncMap[gMailType.GIVE_ITEM], mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseSummary = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION], function(mail)
	local mailsummary = mail.property.data.message
	mailsummary = mailFunctions:getTrimAndFixedWidthStr(mailsummary)
	return mailsummary
end
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION]
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseTitle = function(mail)
	local mailTitle = mailDesParser.mailTypeDesFuncMap[gMailType.GUIDE].parseTitle(mail)
	mailTitle = mailTitle or mailDesParser.defaultMailTypeParseTitle(mail)
	return mailTitle
end
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE], mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION].parseSummary = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_INVITATION], function(mail)
	local mailSource = mail.property.source
	local func = mailDesParser.mailSourceFuncMap[mailSource] and mailDesParser.mailSourceFuncMap[mailSource].parseSummary
	if func then
		return func(mail)
	else
		local mailsummary = mailDesParser.defaultMailTypeParseSummary(mail)
		if not mailsummary then
			local mailContentType = mail.property.data.contentType
			local npcFunc = mailDesParser.npcFuncMap[mailContentType] and mailDesParser.npcFuncMap[mailContentType].parseSummary
			if npcFunc then
				mailsummary = npcFunc(mail)
			else
				mailsummary = mailDesParser.defaultNpcParseSummary(mail)
			end
		end
		return mailsummary
	end
end
mailDesParser.mailTypeDesFuncMap[gMailType.SCOUT_REPORT] = mailDesParser.mailTypeDesFuncMap[gMailType.BATTLE_REPORT]
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY] = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE]
mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_ACTIVITY] = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE]
mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE_REWARD] = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY]
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY]
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseDes = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY_NOTICE].parseDes
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseTitle = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE].parseTitle
mailDesParser.mailTypeDesFuncMap[gMailType.COMMUNITY_CENTER], mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseSummary = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY], mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE].parseSummary
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY]
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseDes = mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_ACTIVITY_NOTICE].parseDes
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseTitle = mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE].parseTitle
mailDesParser.mailTypeDesFuncMap[gMailType.OFFICIAL_COMMUNITY_CENTER], mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseSummary = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY], function(mail, ...)
	dump(mail.property.data.content, "mail.property.data.content")
	if mail.property.data.content and mail.property.data.content.title and mail.property.data.contentType == gMailSystemNoticeType.Content_Custom_Notice then
		return mail.property.data.content.title
	end
	return mailDesParser.mailTypeDesFuncMap[gMailType.ALLIANCE].parseSummary(mail, ...)
end
_ENV = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY]
mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseSummary = mailDesParser.parseScoutReportSummary
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_SUCCESS], mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY].parseMidSummary = mailDesParser.mailTypeDesFuncMap[gMailType.ACTIVITY], mailDesParser.parseScoutReportMidSummary
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_TROOP_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PALACE_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_SUCCESS], mailDesParser.parseBeScoutedReportSummary
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_TROOP_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_PALACE_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_FORTRESS_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_FAILED], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_SUCCESS], mailDesParser.parseBeScoutedReportSummaryFailed
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_TROOP_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_FAILED]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_FAILED]
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_FAILED], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_FAILED].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CITY_FAILED], mailDesParser.parseScoutReportSummaryFailed
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_TROOP_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_FAILED]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_FAILED]
mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY], mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_FAILED].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CITY_FAILED], mailDesParser.parseOccupySummary
mailDesParser.mailSourceFuncMap[gMailSource.Treasure_Map_Occupy] = mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY]
mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY].parseTitle = mailDesParser.parseScoutReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY].parseSummary = mailDesParser.parseScoutReportSummary
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY].parseMidSummary = mailDesParser.mailSourceFuncMap[gMailSource.OCCUPY], mailDesParser.parseScoutReportMidSummary
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_LEGENDLORD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_RADIANCE_BUILD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS].parseTitle = mailDesParser.parseScoutReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_PYRAMIDBUILD_SUCCESS], mailDesParser.parseBeScoutedReportSummary_build
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_PYRAMIDBUILD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_LEGENDLORD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_RADIANCE_BUILD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleBatteryReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.parseScoutReportSummary
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_CATAPULT_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseMidSummary = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS], mailDesParser.parseScoutReportMidSummary
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_FORTRESS_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS], mailDesParser.parseScoutReportSummary
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleBatteryReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_CATAPULT_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS], mailDesParser.parseBeScoutedReportSummary
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseTitle = mailDesParser.parseScoutReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.parseScoutReportSummary
mailDesParser.mailSourceFuncMap[gMailSource.SCOUT_ALLIANCEBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseMidSummary = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS], mailDesParser.parseScoutBuildReportMidSummary
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseMidSummary = mailDesParser.parseFightMidSummary_build
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.BE_SCOUTED_ALLIANCEBUILD_SUCCESS], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ALLIANCEBUILD_SUCCESS], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS].parseTitle3rd = mailDesParser.getBattleTitleThirdPerson_build
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS].parseMidSummary = mailDesParser.parseFightMidSummary_build
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ALLIANCEBUILD_SUCCESS], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_LEGENDLORD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_LEGENDLORD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS].parseTitle3rd = mailDesParser.getBattleTitleThirdPerson_build
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PYRAMIDBUILD_SUCCESS], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_RADIANCE_BUILD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_RADIANCE_BUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_LEGENDLORD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_LEGENDLORD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS].parseTitle = mailDesParser.parseBattleDevilValleyReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS].parseMidSummary = mailDesParser.parseFightMidSummary_devilvalleybuild
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PYRAMIDBUILD_SUCCESS], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_DEVILVALLEYBUILD_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_DEVILVALLEYBUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS].parseTitle = mailDesParser.defaultParseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS].parseTitle3rd = mailDesParser.getBattleTitleThirdPerson_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_DEVILVALLEYBUILD_SUCCESS], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CITY_VICTORY] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CITY_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY].parseTitle = mailDesParser.defaultParseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY].parseTitle3rd = mailDesParser.getBattleTitleThirdPerson_troop
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY].parseSummary = mailDesParser.parseFightSummary_troop
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY], mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_CITY_VICTORY], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_TROOP_VICTORY] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_TROOP_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success], mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ATTACT_TROOP_VICTORY], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Failed] = mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success]
mailDesParser.mailSourceFuncMap[gMailSource.Defense_Treasure_Map_Success] = mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success]
mailDesParser.mailSourceFuncMap[gMailSource.Defense_Treasure_Map_Failed] = mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success]
mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY], mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.Attack_Treasure_Map_Success], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PALACE_VICTORY] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_PALACE_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_FORTRESS_VICTORY] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_FORTRESS_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_FORTRESS_VICTORY] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_FORTRESS_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ANCIENT_BUILDING_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_ANCIENT_BUILDING_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ANCIENT_BUILDING_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_ANCIENT_BUILDING_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DUEL_ATTACKER_ATTACK_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DUEL_ATTACKER_ATTACK_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DUEL_DEFENDER_DEFEND_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DUEL_DEFENDER_DEFEND_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY].parseTitle = mailDesParser.parseBattleBatteryReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY].parseMidSummary = mailDesParser.parseFightMidSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_PALACE_VICTORY], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_CATAPULT_VICTORY] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_CATAPULT_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_LOSE] = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY]
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_ROB_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.DEFENSE_CATAPULT_VICTORY], mailDesParser.parseEscortRobSummary
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_ROB_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_ROB_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_ROB_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED], mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_ROB_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_ROB_SUCCESS], mailDesParser.parseEscortDefSummary
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED]
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED].parseTitle3rd = mailDesParser.getBattleTitleThirdPerson_build
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED].parseSummary3rd = mailDesParser.parseFightSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED].parseMidSummary = mailDesParser.parseFightMidSummary_radianceBuild
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED].parseMidSummary3rd = mailDesParser.mailSourceFuncMap[gMailSource.ESCORT_DEF_FAILED], mailDesParser.parseFightMidSummary_city_3rd
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS].parseSummary = mailDesParser.parseFightSummary_commandHall
mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS].parseMidSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_RADIANCE_BUILD_SUCCESS], mailDesParser.parseFightMidSummary_commandHall
mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_DEFENSE_ARMY_GROUP_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS].parseTitle = mailDesParser.parseBattleReportTitle
mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS].parseSummary = mailDesParser.parseFightSummary_city
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS].parseMidSummary = mailDesParser.mailSourceFuncMap[gMailSource.COMMAND_HALL_ATTACK_ARMY_GROUP_SUCCESS], function()
	return i18n("activity_name_9001573")
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.NEBULA_DEFENCE_USER_DEFENCE_FAILED] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.NEBULA_DEFENCE_USER_DEFENCE_SUCCESS] = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local content = mail:getProperty("data")
	if content.contentType == gMailNPCContentType.Content_Mass_Queue_Cancel_Target_Error then
		return i18n("mail_text_625")
	end
	return i18n("mail_text_626")
end
mailDesParser.mailSourceFuncMap[gMailSource.MASS_CANCEL], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local content = mail:getProperty("data")
	if content.contentType == gMailNPCContentType.Content_Mass_Queue_Cancel_Target_Error then
		_ENV = nil
		;(nil).x = content.x
		;(nil).y = content.y
		return i18n("mail_text_627", nil)
	end
	_ENV = nil
	;(nil).x = content.x
	;(nil).y = content.y
	return i18n("mail_text_628", nil)
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Necklace_Get], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local subType = content.subType
	local equipDesRead = include("equipDesRead")
	_ENV = nil
	;(nil).equipname = equipDesRead.getName(content.eid)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Warm_Heart_Person_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Warm_Heart_Person_Reward")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n("warmHeart_text_10", nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Warm_Heart_Person_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Sinbad_Hoard_GlobalRank], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Sinbad_Hoard_GlobalRank")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n("mail_text_608", nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Sinbad_Hoard_KingdomRank], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Sinbad_Hoard_KingdomRank")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n("mail_text_609", nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Warm_Heart_Alliance_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Warm_Heart_Alliance_Reward")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n("warmHeart_text_12", nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Warm_Heart_Alliance_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Warm_Heart_Alliance_Reward")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Necklace_Snatch_Success], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local subType = content.subType
	local equipDesRead = include("equipDesRead")
	_ENV = nil
	;(nil).abbr = content.abbr
	;(nil).username = content.nickName
	;(nil).kindom = content.kid
	;(nil).equipname = equipDesRead.getName(content.eid)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Necklace_Robbed_Success], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local subType = content.subType
	local equipDesRead = include("equipDesRead")
	dump(content, "Content_Necklace_Robbed_Success", 10)
	_ENV = "Content_Necklace_Robbed_Success"
	;("Content_Necklace_Robbed_Success").equipname = equipDesRead.getName(content.eid)
	;("Content_Necklace_Robbed_Success").abbr = content.abbr
	;("Content_Necklace_Robbed_Success").username = content.nickName
	;("Content_Necklace_Robbed_Success").kindom = content.kid
	strTip = i18n(mailDesInfo.describe, "Content_Necklace_Robbed_Success")
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Activity_Privilege_Gift], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local subType = content.subType
	local itemDesRead = include("itemDesRead")
	local godRewardsRead = include("godRewardsRead")
	local normalID, UpID = godRewardsRead.getItemIDByGift(content.id)
	_ENV = nil
	;(nil).name1 = itemDesRead.getName(normalID)
	;(nil).name2 = itemDesRead.getName(UpID)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	dump(mail, "mailDesParser.npcFuncMa", 10)
	local strTip
	local subType = mail.property.data.content.subType
	strTip = i18n("warSecrit_text_24")
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WarTreasure_Donate_Drum_Rank_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local subType = content.subType
	_ENV = nil
	;(nil).num = mail.property.data.rank
	;(nil).name = i18n("warSecrit_text_28")
	strTip = i18n("warSecrit_text_25", nil)
	if content.topAlliance and #content.topAlliance > 0 then
		for i = 1, #content.topAlliance do
			_ENV = nil
			;(nil).abbr = content.topAlliance[i].allianceAbbr
			;(nil).name = content.topAlliance[i].allianceName
			local name = i18n("common_text_186", nil)
			name = name .. "  " .. content.topAlliance[i].name
			_ENV = content.topAlliance[i].name
			content.topAlliance[i].name.lv = i
			content.topAlliance[i].name.name = name
			local itemRankTip = i18n("common_text_1763", content.topAlliance[i].name) .. "\n"
			strTip = strTip .. itemRankTip
		end
	end
	_ENV = 1
	;(1).name = i18n("item_name_827101")
	local lastStr = i18n("warSecrit_text_27", 1)
	strTip = strTip .. lastStr
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	dump(mail, "mailDesParser.npcFuncMa", 10)
	local strTip
	local subType = mail.property.data.content.subType
	strTip = i18n("warSecrit_text_26")
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WarTreasure_Donate_Medicine_Rank_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local subType = content.subType
	_ENV = nil
	;(nil).num = mail.property.data.rank
	;(nil).name = i18n("warSecrit_text_29")
	strTip = i18n("warSecrit_text_25", nil)
	if content.topAlliance and #content.topAlliance > 0 then
		for i = 1, #content.topAlliance do
			_ENV = nil
			;(nil).abbr = content.topAlliance[i].allianceAbbr
			;(nil).name = content.topAlliance[i].allianceName
			local name = i18n("common_text_186", nil)
			name = name .. "  " .. content.topAlliance[i].name
			_ENV = content.topAlliance[i].name
			content.topAlliance[i].name.lv = i
			content.topAlliance[i].name.name = name
			local itemRankTip = i18n("common_text_1763", content.topAlliance[i].name) .. "\n"
			strTip = strTip .. itemRankTip
		end
	end
	_ENV = 1
	;(1).name = i18n("item_name_827201")
	local lastStr = i18n("warSecrit_text_27", 1)
	strTip = strTip .. lastStr
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail, mailDesInfo, content, formatedStr)
	local activityId = mail.property.data.content.activityId
	local activityTimeRead = include("activityTimeRead")
	return activityTimeRead.getActivityShowName(activityId)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Task_Rush_Activity_Quest_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local activityId = content.activityId
	local activityTimeRead = include("activityTimeRead")
	_ENV = nil
	;(nil).name = activityTimeRead.getActivityShowName(activityId)
	return i18n(formatedStr, nil)
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail, mailDesInfo, content, formatedStr)
	local activityId = mail.property.data.content.activityId
	local activityTimeRead = include("activityTimeRead")
	return activityTimeRead.getActivityShowName(activityId)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Task_Rush_Activity_Chest_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local activityId = content.activityId
	local activityTimeRead = include("activityTimeRead")
	_ENV = nil
	;(nil).name = activityTimeRead.getActivityShowName(activityId)
	return i18n(formatedStr, nil)
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Torch_Receive_Fragment], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	_ENV = nil
	;(nil).name1 = content.userName
	;(nil).num = content.num
	;(nil).name2 = itemDesRead.getName(content.itemID)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	strTip = itemDesRead.getName(mail.property.data.content.mapID)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Torch_Dig_Return], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	dump(mail, "ailDesParser.npcFunc", 20)
	if mail.property.extra and next(mail.property.extra) then
		strTip = i18n(mailDesInfo.describe)
	else
		strTip = i18n(mailDesInfo.describe) .. "\n" .. i18n("common_text_480")
	end
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Torch_Dig_Perfect], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	strTip = itemDesRead.getName(mail.property.data.content.mapID)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	strTip = itemDesRead.getName(mail.property.data.content.mapID)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Torch_Atk_Treasure_Win], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	local name2 = content.userInfo.allianceAbbr and "(" .. content.userInfo.allianceAbbr .. ")" .. content.userInfo.userName or content.userInfo.userName
	if mail.property.extra and next(mail.property.extra) then
		_ENV = content.userInfo.userName
		content.userInfo.userName.name2 = name2
		content.userInfo.userName.num1 = content.num1
		content.userInfo.userName.num2 = content.num2
		strTip = i18n(mailDesInfo.describe, content.userInfo.userName)
	else
		_ENV = content.userInfo.userName
		content.userInfo.userName.name2 = name2
		content.userInfo.userName.num1 = content.num1
		content.userInfo.userName.num2 = content.num2
		strTip = i18n(mailDesInfo.describe, content.userInfo.userName) .. "\n" .. i18n("common_text_480")
	end
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	strTip = itemDesRead.getName(mail.property.data.content.mapID)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Torch_Def_Treasure_Lose], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	local name2 = content.userInfo.allianceAbbr and "(" .. content.userInfo.allianceAbbr .. ")" .. content.userInfo.userName or content.userInfo.userName
	_ENV = content.userInfo.userName
	content.userInfo.userName.name2 = name2
	content.userInfo.userName.num1 = content.num1
	content.userInfo.userName.num2 = content.num2
	content.userInfo.userName.num3 = content.loseCount
	content.userInfo.userName.name3 = itemDesRead.getName(content.loseItemID)
	strTip = i18n(mailDesInfo.describe, content.userInfo.userName)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Torch_Treasure_Collapse], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	strTip = itemDesRead.getName(mail.property.data.content.mapID)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	strTip = i18n("CounterSystem_title_04")
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = function(mail)
	local strTip
	local content = mail.property.data.content
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name = enemy
	strTip = i18n("CounterSystem_text_42", content.enemyNickName)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Counter_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name = enemy
	content.enemyNickName.k = mail.property.kid
	content.enemyNickName.x = content.enemyCoordinate.x
	content.enemyNickName.y = content.enemyCoordinate.y
	strTip = i18n("CounterSystem_text_43", content.enemyNickName)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	strTip = i18n("CounterSystem_title_02")
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = function(mail)
	local strTip
	local content = mail.property.data.content
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name = enemy
	strTip = i18n("CounterSystem_text_38", content.enemyNickName)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Counter_Complete_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name = enemy
	content.enemyNickName.k = mail.property.kid
	content.enemyNickName.x = content.enemyCoordinate.x
	content.enemyNickName.y = content.enemyCoordinate.y
	strTip = i18n("CounterSystem_text_39", content.enemyNickName)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	strTip = i18n("CounterSystem_title_01")
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = function(mail)
	local strTip
	local content = mail.property.data.content
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name1 = content.nickName
	content.enemyNickName.name2 = enemy
	strTip = i18n("CounterSystem_text_36", content.enemyNickName)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Counter_Offset_Reward], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name1 = content.nickName
	content.enemyNickName.name2 = enemy
	content.enemyNickName.k = mail.property.kid
	content.enemyNickName.x = content.enemyCoordinate.x
	content.enemyNickName.y = content.enemyCoordinate.y
	strTip = i18n("CounterSystem_text_37", content.enemyNickName)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	strTip = i18n("CounterSystem_title_03")
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = function(mail)
	local strTip
	local content = mail.property.data.content
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name = enemy
	strTip = i18n("CounterSystem_text_40", content.enemyNickName)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Counter_Clear_Enemy], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local enemy = mailFunctions:getWrappedName(content.enemyAbbr, content.enemyNickName)
	mailFunctions = content.enemyNickName
	content.enemyNickName.name = enemy
	strTip = i18n("CounterSystem_text_41", content.enemyNickName)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	_ENV = nil
	;(nil).item = itemDesRead.getName(content.itemId)
	;(nil).time = math.floor(content.time / 60)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	_ENV = mail.property.mailType
	mail.property.mailType.item = i18n("limited_text_10")
	strTip = i18n(mailDesRead.getMailDesInfo(mail.property.mailType, mail.property.source, gMailNPCContentType.Content_Time_Limited_Item_Will_Disappear).title, mail.property.mailType)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Time_Limited_Item_Will_Disappear], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	_ENV = mail.property.mailType
	mail.property.mailType.item = itemDesRead.getName(mail.property.data.content.itemId)
	strTip = i18n(mailDesRead.getMailDesInfo(mail.property.mailType, mail.property.source, gMailNPCContentType.Content_Time_Limited_Item_Will_Disappear).summary, mail.property.mailType)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	_ENV = nil
	;(nil).item = itemDesRead.getName(content.itemId)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	_ENV = mail.property.mailType
	mail.property.mailType.item = i18n("limited_text_10")
	strTip = i18n(mailDesRead.getMailDesInfo(mail.property.mailType, mail.property.source, gMailNPCContentType.Content_Time_Limited_Item_Disappear).title, mail.property.mailType)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Time_Limited_Item_Disappear], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local strTip
	local itemDesRead = include("itemDesRead")
	_ENV = mail.property.mailType
	mail.property.mailType.item = itemDesRead.getName(mail.property.data.content.itemId)
	strTip = i18n(mailDesRead.getMailDesInfo(mail.property.mailType, mail.property.source, gMailNPCContentType.Content_Time_Limited_Item_Disappear).summary, mail.property.mailType)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local comStr = ""
	if content.abbr and content.abbr ~= "" then
		_ENV = nil
		;(nil).abbr = content.abbr
		;(nil).name = content.nickName
		comStr = i18n("common_text_186", nil)
	else
		comStr = content.nickName
	end
	_ENV = nil
	;(nil).name = comStr
	strTip = i18n("mail_report_success_text", nil)
	return strTip
end
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseTitle = function(mail)
	local strTip
	strTip = i18n("remains_text_383")
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Report_Success], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local strTip
	strTip = i18n("remains_text_383")
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local comStr = i18n("mail_pyramid_05")
	if content.style == gSeasonType.REGULAR_SEASON then
		comStr = i18n("common_text_3300")
	end
	_ENV = nil
	;(nil).var1 = comStr
	;(nil).var2 = content.shopPoint
	strTip = i18n("mail_allianceWarShopPoint_text", nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_PyramidWar_ShopPoint_Get], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail)
	local strTip
	strTip = i18n("mail_allianceWarShopPoint_desc")
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Treasure_Crystal_Disappear], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	_ENV = nil
	;(nil).item = itemDesRead.getName(content.itemId)
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	strTip = content.text
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Text], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseSummary = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local content = mail.property.data.content
	if mail.property.data.ml_content and mail.property.data.defaultLanguage then
		content = mail.property.data.ml_content[mail.property.data.defaultLanguage]
		return content.title
	end
	strTip = content and content.title or ""
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WebActivityPersonMail], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	strTip = content.text
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WoundedSoldier], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).wound = content.wound
	;(nil).lost = content.lost
	strTip = i18n(formatedStr, nil)
	if content.elitePointInfo and content.elitePointInfo.power and content.elitePointInfo.power > 0 then
		_ENV = content.lost
		content.lost.num = content.elitePointInfo.power
		strTip = strTip .. i18n("common_text_4263", content.lost)
		if content.elitePointInfo.reachMax then
			strTip = strTip .. i18n("common_text_3131")
		end
	end
	return strTip
end
_ENV = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_IntegralTargetReard], mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS].parseDes = mailDesParser.mailSourceFuncMap[gMailSource.ATTACK_NEBULA_DEFENCE_SUCCESS], function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).lv = content.rank
	strTip = i18n(formatedStr, nil)
	if content.activityId ~= nil then
		local eventNameId = kingsOrderRead.getSectionName(content.activityId)
		local eventName = "nil"
		if eventNameId then
			eventName = i18n(eventNameId)
			if eventName == nil then
				eventName = ""
			end
		end
		_ENV = nil
		;(nil).name = eventName
		;(nil).rank = content.rank
		strTip = i18n("common_text_2153", nil)
	end
	return strTip
end
_ENV = "Content_StateActivityReard"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StateActivityReard], ("Content_StateActivityReard").parseDes = "Content_StateActivityReard", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	if content.activityId ~= nil then
		local eventNameId = kingsOrderRead.getSectionName(content.activityId)
		local eventName = "nil"
		if eventNameId then
			eventName = i18n(eventNameId)
			if eventName == nil then
				eventName = ""
			end
		end
		_ENV = nil
		;(nil).name = eventName
		;(nil).rank = content.rank
		strTip = i18n("common_text_2154", nil)
	end
	return strTip
end
_ENV = "Content_Phoenix_Challenge_Alliance_Stage_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Phoenix_Challenge_Alliance_Stage_Reward], ("Content_Phoenix_Challenge_Alliance_Stage_Reward").parseDes = "Content_Phoenix_Challenge_Alliance_Stage_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.score
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Phoenix_Challenge_Alliance_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Phoenix_Challenge_Alliance_Rank_Reward], ("Content_Phoenix_Challenge_Alliance_Rank_Reward").parseDes = "Content_Phoenix_Challenge_Alliance_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Phoenix_Challenge_Player_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Phoenix_Challenge_Player_Rank_Reward], ("Content_Phoenix_Challenge_Player_Rank_Reward").parseDes = "Content_Phoenix_Challenge_Player_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Bubble_Carnival_Exchange_Deal"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Bubble_Carnival_Exchange_Deal], ("Content_Bubble_Carnival_Exchange_Deal").parseDes = "Content_Bubble_Carnival_Exchange_Deal", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = content.name
	;(nil).item1 = publicRead.getName(content.need)
	;(nil).item2 = publicRead.getName(content.offer)
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Collect_Ribbon_Exchange_Deal] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Bubble_Carnival_Exchange_Deal]
_ENV = "Content_Prince_Gift_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Prince_Gift_Reward], ("Content_Prince_Gift_Reward").parseDes = "Content_Prince_Gift_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local nameStr = ""
	if content.id == 14141 then
		nameStr = i18n("Wisdom_of_oriental_prince_text_20")
	elseif content.id == 14140 then
		nameStr = i18n("Wisdom_of_oriental_prince_text_01")
	end
	_ENV = nil
	;(nil).name = nameStr
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Prince_Gift_Two_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Prince_Gift_Two_Reward], ("Content_Prince_Gift_Two_Reward").parseDes = "Content_Prince_Gift_Two_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local nameStr = ""
	if content.id == 14141 then
		nameStr = i18n("Wisdom_of_oriental_prince_text_20")
	elseif content.id == 14140 then
		nameStr = i18n("Wisdom_of_oriental_prince_text_01")
	end
	_ENV = nil
	;(nil).name = nameStr
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Activity_End_Exchange_Item"
;("Content_Activity_End_Exchange_Item").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	local activityId = content.activityId
	local activityName = i18n("activity_name_9001305")
	if activityId == gActivityTimeActivityID.KOH_MIGRATE then
		activityName = i18n("automatic_text_36")
	elseif activityId == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		activityName = i18n("flames_dunes_text1")
	else
		activityName = i18n("activity_name_" .. activityId)
	end
	local itemStr = ""
	for i, v in ipairs(content.delItemList) do
		local tempStr = itemDesRead.getName(content.delItemList[i].id)
		print("sdkfjlskjdf", i, itemStr, tempStr)
		if i ~= #content.delItemList then
			itemStr = itemStr .. tempStr .. ","
		else
			itemStr = itemStr .. tempStr
		end
	end
	_ENV = ipairs(content.delItemList)
	ipairs(content.delItemList).activity = activityName
	ipairs(content.delItemList).item = itemStr
	strTip = i18n("ice_carnival_text14", ipairs(content.delItemList))
	local itemStr2 = ""
	for i, v in ipairs(content.delItemList) do
		local tempStr = itemDesRead.getName(v.id)
		_ENV = tempStr
		tempStr.num = v.count
		tempStr.item = tempStr
		itemStr2 = itemStr2 .. i18n("expired_text_02", tempStr)
		if i ~= #content.delItemList then
			itemStr2 = itemStr2 .. "、"
		end
	end
	_ENV = ipairs(content.delItemList)
	ipairs(content.delItemList).items = itemStr2
	local strTip2 = i18n("expired_text_01", ipairs(content.delItemList))
	strTip = strTip .. "\n" .. strTip2
	return strTip
end
;("Content_Activity_End_Exchange_Item").parseTitle = function(mail)
	local activityId = mail.property.data.content.activityId
	local activityName = i18n("activity_name_9001305")
	if activityId == gActivityTimeActivityID.KOH_MIGRATE then
		activityName = i18n("automatic_text_36")
	elseif activityId == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		activityName = i18n("flames_dunes_text1")
	else
		activityName = i18n("activity_name_" .. activityId)
	end
	return activityName
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Activity_End_Exchange_Item], ("Content_Activity_End_Exchange_Item").parseSummary = "Content_Activity_End_Exchange_Item", function(mail)
	local strTip
	local activityId = mail.property.data.content.activityId
	local activityName = i18n("activity_name_9001305")
	if activityId == gActivityTimeActivityID.KOH_MIGRATE then
		activityName = i18n("automatic_text_36")
	elseif activityId == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		activityName = i18n("flames_dunes_text1")
	else
		activityName = i18n("activity_name_" .. activityId)
	end
	_ENV = activityId
	activityId.activity = activityName
	strTip = i18n("ice_carnival_text13", activityId)
	return strTip
end
_ENV = "Content_Dress_Time_Over"
;("Content_Dress_Time_Over").parseSummary = function(mail)
	local dressltCtrl = include("dressltCtrl")
	local castleSkinRead = include("castleSkinRead")
	local dressId = mail.property.data.content.dressId
	local subType = dressltCtrl.getSubType(dressId)
	local name = castleSkinRead.getNameBySubType(subType)
	_ENV = nil
	;(nil).name = name
	return i18n("common_text_4728", nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Dress_Time_Over], ("Content_Dress_Time_Over").parseDes = "Content_Dress_Time_Over", function(mail, mailDesInfo, content, formatedStr)
	local dressId = mail.property.data.content.dressId
	local time = mail.property.data.content.time
	local dressltCtrl = include("dressltCtrl")
	local castleSkinRead = include("castleSkinRead")
	local dressId = mail.property.data.content.dressId
	local subType = dressltCtrl.getSubType(dressId)
	local name = castleSkinRead.getNameBySubType(subType)
	_ENV = nil
	;(nil).name = name
	;(nil).time = SoraDConvertSecondToString(time)
	return i18n("common_text_4729", nil)
end
_ENV = "Content_StrongestLordReard"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StrongestLordReard], ("Content_StrongestLordReard").parseDes = "Content_StrongestLordReard", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_alibabaTreasure_rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_alibabaTreasure_rank], ("Content_alibabaTreasure_rank").parseDes = "Content_alibabaTreasure_rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Ramadan_Gift_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Gift_Reward], ("Content_Ramadan_Gift_Reward").parseDes = "Content_Ramadan_Gift_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).lv = content.lv
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Reinforcement_UpLimit"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reinforcement_UpLimit], ("Content_Reinforcement_UpLimit").parseDes = "Content_Reinforcement_UpLimit", function(mail, mailDesInfo, content, formatedStr)
	local strTip, name
	local uinfo = content.uinfo
	local allianceInfo = content.allianceInfo
	if allianceInfo ~= nil then
		name = mailFunctions:getWrappedName(allianceInfo.abbr, uinfo.nickName)
	else
		name = uinfo.nickName
	end
	local numSuccess = content.numReinforcement
	local numBack = content.numBack
	mailFunctions = nil
	;(nil).name = name
	;(nil).numSuccess = numSuccess
	;(nil).numBack = string.formatnumberthousands(numBack)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_FaceBook_Share_Lord_LvUp"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_FaceBook_Share_Lord_LvUp], ("Content_FaceBook_Share_Lord_LvUp").parseDes = "Content_FaceBook_Share_Lord_LvUp", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.fromLevel then
		_ENV = nil
		;(nil).name = "Facebook"
		;(nil).fromLevel = content.fromLevel
		;(nil).toLevel = content.toLevel
		strTip = i18n("common_text_3122", nil)
	else
		_ENV = nil
		;(nil).name = "Facebook"
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_FaceBook_Share_Castle_LvUp"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_FaceBook_Share_Castle_LvUp], ("Content_FaceBook_Share_Castle_LvUp").parseDes = "Content_FaceBook_Share_Castle_LvUp", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = "Facebook"
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Treasure_Hunt_Gift"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Treasure_Hunt_Gift], ("Content_Treasure_Hunt_Gift").parseDes = "Content_Treasure_Hunt_Gift", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = i18n("anniversary_dice_title_01")
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "ontent_Nebula_Treasure_Hunt_Gift"
mailDesParser.npcFuncMap[gMailNPCContentType.ontent_Nebula_Treasure_Hunt_Gift], ("ontent_Nebula_Treasure_Hunt_Gift").parseDes = "ontent_Nebula_Treasure_Hunt_Gift", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = i18n("activity_name_9001628")
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Manual_Gift_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Manual_Gift_Reward], ("Content_Manual_Gift_Reward").parseDes = "Content_Manual_Gift_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = i18n("opt_package_text_01")
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_ExaltedPrivilege_New_Privilege_Inform"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ExaltedPrivilege_New_Privilege_Inform], ("Content_ExaltedPrivilege_New_Privilege_Inform").parseDes = "Content_ExaltedPrivilege_New_Privilege_Inform", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local exclusiveVipRead = include("exclusiveVipRead")
	local name = ""
	for k, v in pairs(content.newPrivilege) do
		local info = exclusiveVipRead:getPrivilegeInfo(v)
		name = i18n(info.name)
		if info.type == gExaltedPrivilegeType.LORD_HEAD_PRIVILEGE then
			local head = include("head")
			local strName = i18n(head[info.value[1]].name)
			_ENV = nil
			;(nil).name = strName
			name = i18n(info.name, nil)
		end
	end
	_ENV = pairs(content.newPrivilege)
	pairs(content.newPrivilege).name = name
	strTip = i18n(formatedStr, pairs(content.newPrivilege))
	return strTip
end
_ENV = "Content_Login_Reward_Step_1"
;("Content_Login_Reward_Step_1").parseTopTitle = function(mail)
	return i18n("mail_text_46")
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Login_Reward_Step_1], ("Content_Login_Reward_Step_1").parseDes = "Content_Login_Reward_Step_1", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).curGold = content.curGold
	;(nil).nextGold = content.nextGold
	;(nil).nextDay = content.nextDay
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nafu_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nafu_Rank_Reward], ("Content_Nafu_Rank_Reward").parseDes = "Content_Nafu_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Login_Reward_Step_2] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Login_Reward_Step_1]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Login_Reward_Step_3] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Login_Reward_Step_1]
_ENV = "Content_Inviter_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Inviter_Reward], ("Content_Inviter_Reward").parseDes = "Content_Inviter_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).number = content.number
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Inviter_Reward_Back"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Inviter_Reward_Back], ("Content_Inviter_Reward_Back").parseDes = "Content_Inviter_Reward_Back", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.allianceInfo == nil then
		content.allianceInfo, mailFunctions = content.allianceInfo, content.allianceInfo
	end
	if content.uinfo then
		local name = mailFunctions:getWrappedName(content.allianceInfo.abbr, content.uinfo.nickName)
		mailFunctions = content.uinfo.nickName
		content.uinfo.nickName.name = name
		strTip = i18n(formatedStr, content.uinfo.nickName)
	else
		strTip = "format error"
	end
	return strTip
end
_ENV = "Content_Recharge_Reward"
;("Content_Recharge_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local activityId = mail.property.data.content.activityId
	if activityId and activityId == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 then
		local activity_9001601_Read = include("activity_9001601_Read")
		return activity_9001601_Read.getMailDesByRechargeID(mail.property.data.content.id)
	end
	local strTip
	local id = mail.property.data.content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	_ENV = nil
	;(nil).name = name
	strTip = i18n(formatedStr, nil)
	if id == 14476 then
		_ENV = nil
		;(nil).name = name
		strTip = i18n("magic_herb_text_017", nil)
	end
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	if heroltCtrl:getHeroStageGiftCfg(id) then
		_ENV = id
		id.name = i18n("common_text_4817")
		strTip = i18n("magic_herb_text_017", id)
	end
	local pageViewData = include("rechargeRead").getPageViewData(id)
	if pageViewData and pageViewData.gainType and pageViewData.gainType == 1 then
		_ENV = i18n("common_text_4817")
		i18n("common_text_4817").name = name
		strTip = i18n("mail_text_624", (i18n("common_text_4817")))
	end
	local specailCfg = include("rechargeRead").getSpecialRechargeCfg(id)
	if specailCfg then
		_ENV = "common_text_4817"
		;("common_text_4817").name = i18n(specailCfg.rechargeName)
		strTip = i18n(formatedStr, "common_text_4817")
	end
	return strTip
end
;("Content_Recharge_Reward").parseSummary = function(mail)
	local activityId = mail.property.data.content.activityId
	if activityId then
		local commonBuyGiftUtil = include("commonBuyGiftUtil")
		local rechargeName = commonBuyGiftUtil.getRechargeName(activityId, mail.property.data.content.id)
		if rechargeName then
			return rechargeName
		end
	end
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local id = mail.property.data.content.id
	if heroltCtrl:getHeroStageGiftCfg(id) then
		return i18n("common_text_4817")
	end
	local specailCfg = include("rechargeRead").getSpecialRechargeCfg(id)
	if specailCfg then
		return i18n(specailCfg.rechargeName)
	end
	return mailDesParser.getRechargeGiftName(mail, id)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Recharge_Reward], ("Content_Recharge_Reward").parseTitle = "Content_Recharge_Reward", function(mail)
	local activityId = mail.property.data.content.activityId
	if activityId then
		local commonBuyGiftUtil = include("commonBuyGiftUtil")
		local rechargeName = commonBuyGiftUtil.getRechargeName(activityId, mail.property.data.content.id)
		if rechargeName then
			return rechargeName
		end
	end
	local specailCfg = include("rechargeRead").getSpecialRechargeCfg(mail.property.data.content.id)
	if specailCfg then
		return i18n(specailCfg.rechargeName)
	end
	return mailDesParser.defaultMailTypeParseTitle(mail)
end
_ENV = "Content_ExaltedPrivilege_Recharge_Gift"
;("Content_ExaltedPrivilege_Recharge_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	mailDesParser = nil
	;(nil).name = name
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ExaltedPrivilege_Recharge_Gift], ("Content_ExaltedPrivilege_Recharge_Gift").parseSummary = "Content_ExaltedPrivilege_Recharge_Gift", function(mail)
	local id = mail.property.data.content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	return name
end
_ENV = "Content_Recharge_Activity_Gift_Reward"
;("Content_Recharge_Activity_Gift_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.rid
	local name = mailDesParser.getRechargeGiftName(mail, id)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	if heroltCtrl:getHeroStageGiftCfg(id) then
		name = i18n("common_text_4817")
	end
	mailDesParser = id
	id.name = name
	strTip = i18n(formatedStr, id)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Recharge_Activity_Gift_Reward], ("Content_Recharge_Activity_Gift_Reward").parseSummary = "Content_Recharge_Activity_Gift_Reward", function(mail)
	local id = mail.property.data.content.rid
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	local summary
	local name = mailDesParser.getRechargeGiftName(mail, id)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	if heroltCtrl:getHeroStageGiftCfg(id) then
		name = i18n("common_text_4817")
	end
	local formatedStr = mailDesInfo.summary
	if formatedStr ~= "" then
		mailDesParser = nil
		;(nil).name = name
		summary = i18n(formatedStr, nil)
		return summary
	else
		return name
	end
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Sultan_Present_Gift_Ex] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Recharge_Activity_Gift_Reward]
_ENV = "Content_Sultan_Present_Gift_Buy"
;("Content_Sultan_Present_Gift_Buy").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.exchangeID or 0
	local name = mailDesParser.getRechargeGiftName(mail, id)
	mailDesParser = nil
	;(nil).name = name
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Sultan_Present_Gift_Buy], ("Content_Sultan_Present_Gift_Buy").parseSummary = "Content_Sultan_Present_Gift_Buy", function(mail)
	local id = mail.property.data.content.exchangeID or 0
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	local summary
	local name = mailDesParser.getRechargeGiftName(mail, id)
	local formatedStr = mailDesInfo.summary
	if formatedStr ~= "" then
		mailDesParser = nil
		;(nil).name = name
		summary = i18n(formatedStr, nil)
		return summary
	else
		return name
	end
end
_ENV = "Content_New_Year_Present_Gift_Ex"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Year_Present_Gift_Ex], ("Content_New_Year_Present_Gift_Ex").parseDes = "Content_New_Year_Present_Gift_Ex", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.rid
	local giftName = mailDesParser.getRechargeGiftName(mail, id)
	mailDesParser = nil
	;(nil).name = giftName
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_New_Year_Present_Gift_Buy"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Year_Present_Gift_Buy], ("Content_New_Year_Present_Gift_Buy").parseDes = "Content_New_Year_Present_Gift_Buy", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.exchangeID or 0
	local rechargeRead = include("rechargeRead")
	local data = rechargeRead.getNewyearPresentPageViewData(id)
	local name = data and data.activeName or ""
	_ENV = nil
	;(nil).name = i18n(name)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Recharge_Reward_Alliance"
;("Content_Recharge_Reward_Alliance").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.id
	local giftName = mailDesParser.getRechargeGiftName(mail, id)
	local uinfo = content.uinfo
	local uid = uinfo.id
	local isSelf = chatFunctions:getIsPlayerSelf(uid)
	local isHideGiftName = mail.property.data.content.isHideGiftName or false
	if isSelf then
		mailDesParser = nil
		;(nil).name = giftName
		strTip = i18n(formatedStr, nil)
	else
		local specailCfg = include("rechargeRead").getSpecialRechargeCfg(id)
		if specailCfg then
			giftName = i18n(specailCfg.rechargeName)
		end
		if isHideGiftName then
			giftName = ""
		end
		mailDesParser = nil
		;(nil).name = uinfo.nickName
		;(nil).gift = giftName
		;(nil).reward = giftName
		strTip = i18n("common_text_1129", nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Recharge_Reward_Alliance], ("Content_Recharge_Reward_Alliance").parseSummary = "Content_Recharge_Reward_Alliance", function(mail)
	local id = mail.property.data.content.id
	local giftName = mailDesParser.getRechargeGiftName(mail, id)
	local uinfo = mail.property.data.content.uinfo
	local uid = uinfo.id
	local isSelf = chatFunctions.getIsPlayerSelf(uid)
	local isHideGiftName = mail.property.data.content.isHideGiftName or false
	local summary
	if isSelf then
		summary = giftName
		return summary
	elseif isHideGiftName then
		summary = i18n("recharge_name_03")
		return summary
	else
		local specailCfg = include("rechargeRead").getSpecialRechargeCfg(id)
		if specailCfg then
			giftName = i18n(specailCfg.rechargeName)
		end
		mailDesParser = nil
		;(nil).gift = giftName
		summary = i18n("common_text_1130", nil)
		return summary
	end
end
_ENV = "Content_Accu_Recharge_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Recharge_Reward], ("Content_Accu_Recharge_Reward").parseDes = "Content_Accu_Recharge_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).gold = content.accuGold
		strTip = i18n(formatedStr, nil)
	else
		strTip = "undefined, content type = " .. gMailNPCContentType.Content_Accu_Recharge_Reward
	end
	return strTip
end
_ENV = "Content_Accu_Consume_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Consume_Reward], ("Content_Accu_Consume_Reward").parseDes = "Content_Accu_Consume_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).gold = content.accuGold
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Lucky_Gift"
;("Content_Lucky_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = mail.property.data.content.id
	local itemName = mailDesParser.getRechargeGiftName(mail, id)
	if formatedStr ~= nil then
		mailDesParser = nil
		;(nil).name = itemName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Lucky_Gift], ("Content_Lucky_Gift").parseSummary = "Content_Lucky_Gift", function(mail)
	local id = mail.property.data.content.id
	local itemName = mailDesParser.getRechargeGiftName(mail, id)
	return itemName
end
_ENV = "Content_King_Gift"
;("Content_King_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = content.id
	local itemName = mailDesParser.getKingPackName(mail, id)
	if formatedStr ~= nil then
		mailDesParser = nil
		;(nil).gift = itemName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_King_Gift], ("Content_King_Gift").parseSummary = "Content_King_Gift", function(mail)
	local id = mail.property.data.content.id
	local itemName = mailDesParser.getKingPackName(mail, id)
	return itemName
end
_ENV = "Content_Alliance_Gift"
;("Content_Alliance_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_King_Gift].parseDes(mail, mailDesInfo, content, formatedStr)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Gift], ("Content_Alliance_Gift").parseSummary = "Content_Alliance_Gift", function(mail)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_King_Gift].parseSummary(mail)
end
_ENV = "Content_King_Official_Other"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_King_Official_Other], ("Content_King_Official_Other").parseDes = "Content_King_Official_Other", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local officialPos = content.officialPos
	local officialInfoRead = include("officialInfoRead")
	local officialItem = officialInfoRead.getInfoByType(officialPos)
	local officialName
	if officialItem then
		officialName = i18n(officialItem.name)
	end
	local privilegeDes = ""
	local bufidArray = content.bufid or officialItem.buff
	local officialBuffRead = include("officialBuffRead")
	if bufidArray then
		for i, v in ipairs(bufidArray) do
			local bufid = bufidArray[i]
			local bufItem = officialBuffRead.getItem(bufid)
			if bufItem and bufItem.buffDes then
				privilegeDes = privilegeDes .. i18n(bufItem.buffDes) .. "\n"
			end
		end
	end
	if formatedStr ~= nil then
		local isGood = officialInfoRead.judgeGoodOrBad(content.officialPos)
		local name = ""
		if isGood then
			if content.kingName ~= nil then
				formatedStr = "common_text_3163"
				name = mailFunctions:getWrappedName(content.kingAbbr, content.kingName)
			end
		elseif content.kingName ~= nil then
			formatedStr = "common_text_3165"
			name = mailFunctions:getWrappedName(content.kingAbbr, content.kingName)
		else
			formatedStr = "common_text_1526"
		end
		local isKing = content.isKing
		_ENV = content.kingName
		content.kingName.status = isKing and i18n("official_name_1") or i18n("official_name_2")
		content.kingName.name = name
		content.kingName.officialPos = officialName
		content.kingName.privilege = privilegeDes
		strTip = i18n(formatedStr, content.kingName)
	end
	return strTip
end
_ENV = "Content_Catapult_Reinforcement_UpLimit"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Catapult_Reinforcement_UpLimit], ("Content_Catapult_Reinforcement_UpLimit").parseDes = "Content_Catapult_Reinforcement_UpLimit", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local numReinforcement = content.numReinforcement
	local numLeft = content.numLeft
	local coordinate = content.coordinate
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).x = coordinate.x
		;(nil).y = coordinate.y
		;(nil).numReinforcement = numReinforcement
		;(nil).numLeft = numLeft
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Fortress_Reinforcement_UpLimit"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Fortress_Reinforcement_UpLimit], ("Content_Fortress_Reinforcement_UpLimit").parseDes = "Content_Fortress_Reinforcement_UpLimit", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Catapult_Reinforcement_UpLimit].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_PALACE_Reinforcement_UpLimit"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_PALACE_Reinforcement_UpLimit], ("Content_PALACE_Reinforcement_UpLimit").parseDes = "Content_PALACE_Reinforcement_UpLimit", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Catapult_Reinforcement_UpLimit].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_Common_Reinforcement_UpLimit"
;("Content_Common_Reinforcement_UpLimit").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local numReinforcement = content.numReinforcement
	local numLeft = content.numLeft
	local coordinate = content.coordinate
	local name
	local mapType = content.mapType
	local subMapType = content.subMapType
	if mapType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		if subMapType then
			name = allianceDesRead.getBuildName(subMapType)
		end
	elseif mapType == gMapObjTypeDef.stronghold then
		if content.objId then
			name = i18n(include("allianceStrongholdMineRead").getHoldMonsterName(content.objId))
		end
	elseif mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		local AMBC = require_data("atlantiswar_map_build_config").data
		name = i18n(AMBC[content.objId].name)
	end
	if formatedStr ~= nil then
		_ENV = AMBC[content.objId].name
		AMBC[content.objId].name.name = name or ""
		AMBC[content.objId].name.x = coordinate.x - 1
		AMBC[content.objId].name.y = coordinate.y - 1
		AMBC[content.objId].name.numReinforcement = string.formatnumberthousands(numReinforcement)
		AMBC[content.objId].name.numLeft = string.formatnumberthousands(numLeft)
		strTip = i18n(formatedStr, AMBC[content.objId].name)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Common_Reinforcement_UpLimit], ("Content_Common_Reinforcement_UpLimit").parseSummary = "Content_Common_Reinforcement_UpLimit", function(mail)
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	local content = mail.property.data.content
	local mapType = content.mapType
	local subMapType = content.subMapType
	local name = ""
	if mapType == gMapObjTypeDef.mapObjTypeAllianceBuild then
		if subMapType then
			name = allianceDesRead.getBuildName(subMapType)
		end
	elseif mapType == gMapObjTypeDef.stronghold then
		if content.objId then
			name = i18n(include("allianceStrongholdMineRead").getHoldMonsterName(content.objId))
		end
	elseif mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
		local AMBC = require_data("atlantiswar_map_build_config").data
		name = i18n(AMBC[content.objId].name)
	end
	local formatedStr, summary
	if mailDesInfo then
		formatedStr = mailDesInfo.summary
		if formatedStr ~= "" then
			mailDesParser = include("allianceStrongholdMineRead").getHoldMonsterName(content.objId)
			include("allianceStrongholdMineRead").getHoldMonsterName(content.objId).name = name
			summary = i18n(formatedStr, include("allianceStrongholdMineRead").getHoldMonsterName(content.objId))
			return summary
		end
	end
end
_ENV = "Content_Roman_Soul_Activity_Begin"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Roman_Soul_Activity_Begin], ("Content_Roman_Soul_Activity_Begin").parseDes = "Content_Roman_Soul_Activity_Begin", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content and content.uinfo and content.time and formatedStr then
		if content.difficulity ~= nil then
			_ENV = nil
			;(nil).name = content.uinfo.nickName
			;(nil).time = os.date("!%Y-%m-%d %H:%M:%S", content.time)
			;(nil).difficulity = content.difficulity
			strTip = i18n("common_text_2729", nil)
		else
			_ENV = nil
			;(nil).name = content.uinfo.nickName
			;(nil).time = os.date("!%Y-%m-%d %H:%M:%S", content.time)
			strTip = i18n(formatedStr, nil)
		end
	end
	return strTip
end
_ENV = "Content_Roman_Soul_Reward_Alliance_Target"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Roman_Soul_Reward_Alliance_Target], ("Content_Roman_Soul_Reward_Alliance_Target").parseDes = "Content_Roman_Soul_Reward_Alliance_Target", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content then
		if content.lv and formatedStr then
			local getLvName = function(lv)
				if not lv or lv < 1 or 5 < lv then
					return i18n("common_text_1495")
				end
				if lv then
					return i18n("common_text_" .. 1495 + lv - 1)
				end
			end
			_ENV = nil
			;(nil).difficulty = content.difficulty
			;(nil).lv = getLvName(content.lv)
			strTip = i18n(formatedStr, nil)
		else
			strTip = "Error: " .. gMailNPCContentType.Content_Roman_Soul_Reward_Alliance_Target
		end
	end
	return strTip
end
_ENV = "Content_Roman_Soul_Reward_Alliance_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Roman_Soul_Reward_Alliance_Rank], ("Content_Roman_Soul_Reward_Alliance_Rank").parseDes = "Content_Roman_Soul_Reward_Alliance_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content then
		if content.rank and formatedStr then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n(formatedStr, nil)
		else
			strTip = "Error: " .. gMailNPCContentType.Content_Roman_Soul_Reward_Alliance_Rank
		end
	end
	return strTip
end
_ENV = "Content_Roman_Soul_Reward_Personal_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Roman_Soul_Reward_Personal_Rank], ("Content_Roman_Soul_Reward_Personal_Rank").parseDes = "Content_Roman_Soul_Reward_Personal_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content then
		if content.rank and formatedStr then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n(formatedStr, nil)
		else
			strTip = "Error: " .. gMailNPCContentType.Content_Roman_Soul_Reward_Alliance_Rank
		end
	end
	return strTip
end
_ENV = "Content_HeroTrial_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroTrial_Rank], ("Content_HeroTrial_Rank").parseDes = "Content_HeroTrial_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content then
		if content.rank and formatedStr then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n(formatedStr, nil)
		else
			strTip = "undefined: " .. gMailNPCContentType.Content_HeroTrial_Rank
		end
	end
	return strTip
end
_ENV = "Content_HeroTrial_Like_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroTrial_Like_Rank], ("Content_HeroTrial_Like_Rank").parseDes = "Content_HeroTrial_Like_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content and content.rank and formatedStr then
		_ENV = nil
		;(nil).rank = content.rank
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Accu_Recharge_Reward_APPLE"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Recharge_Reward_APPLE], ("Content_Accu_Recharge_Reward_APPLE").parseDes = "Content_Accu_Recharge_Reward_APPLE", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).gold = content.accuGold
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Accu_Recharge_Reward_ANDROID"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Recharge_Reward_ANDROID], ("Content_Accu_Recharge_Reward_ANDROID").parseDes = "Content_Accu_Recharge_Reward_ANDROID", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Recharge_Reward_APPLE].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_Accu_Consume_Reward_APPLE"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Consume_Reward_APPLE], ("Content_Accu_Consume_Reward_APPLE").parseDes = "Content_Accu_Consume_Reward_APPLE", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).gold = content.accuGold
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Accu_Consume_Reward_ANDROID"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Consume_Reward_ANDROID], ("Content_Accu_Consume_Reward_ANDROID").parseDes = "Content_Accu_Consume_Reward_ANDROID", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Accu_Consume_Reward_APPLE].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_Group_Purchase_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Group_Purchase_Reward], ("Content_Group_Purchase_Reward").parseDes = "Content_Group_Purchase_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local itemId = content.itemId
		if itemId ~= nil then
			local item = publicRead.getName(itemId)
			publicRead = nil
			;(nil).buyGold = content.buyGold
			;(nil).item = item
			;(nil).num = content.itemNum
			;(nil).priceDiff = content.priceDiff
			;(nil).groupGold = content.groupGold
			strTip = i18n(formatedStr, nil)
		end
	end
	return strTip
end
_ENV = "Content_Alliance_Donate_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Donate_Rank_Reward], ("Content_Alliance_Donate_Rank_Reward").parseDes = "Content_Alliance_Donate_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Alliance_Donate_Rank_Without_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Donate_Rank_Without_Reward], ("Content_Alliance_Donate_Rank_Without_Reward").parseDes = "Content_Alliance_Donate_Rank_Without_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		strTip = i18n(formatedStr, nil)
		for i = 1, #content.rankTable do
			_ENV = nil
			;(nil).lv = i
			;(nil).name = content.rankTable[i].nickName
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Alliance_Donate_Without_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Donate_Without_Rank], ("Content_Alliance_Donate_Without_Rank").parseDes = "Content_Alliance_Donate_Without_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		for i = 1, #content.rankTable do
			_ENV = nil
			;(nil).lv = i
			;(nil).name = content.rankTable[i].nickName
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Red_Gift_Money_Return"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Red_Gift_Money_Return], ("Content_Red_Gift_Money_Return").parseDes = "Content_Red_Gift_Money_Return", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.sendTime)
		_ENV = nil
		;(nil).date = timeStr
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_IOS_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_IOS_Rank_Reward], ("Content_IOS_Rank_Reward").parseDes = "Content_IOS_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local rank = content.rank
		_ENV = nil
		;(nil).rank = rank
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_ANDROID_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ANDROID_Rank_Reward], ("Content_ANDROID_Rank_Reward").parseDes = "Content_ANDROID_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_IOS_Rank_Reward].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_Ramadan_Treasure_Box_Reward"
;("Content_Ramadan_Treasure_Box_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local class = content.class
	if class then
		local lv = content.lv
		local name = mailDesParser.getChestPackShowName(mail, class)
		if name then
			mailDesParser = nil
			;(nil).lv = lv
			;(nil).name = name
			strTip = i18n("common_text_2097", nil)
		end
	end
	if not strTip and formatedStr ~= nil then
		local lv = content.lv
		mailDesParser = "common_text_2097"
		;("common_text_2097").lv = lv
		strTip = i18n(formatedStr, "common_text_2097")
	end
	return strTip
end
;("Content_Ramadan_Treasure_Box_Reward").parseTitle = function(mail)
	print("神秘骆驼标题---------")
	local class = mail.property.data.content.class
	if class then
		local name = mailDesParser.getChestPackShowName(mail, class)
		if name then
			return name
		end
	end
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Treasure_Box_Reward], ("Content_Ramadan_Treasure_Box_Reward").parseSummary = "Content_Ramadan_Treasure_Box_Reward", function(mail)
	local class = mail.property.data.content.class
	if class then
		local name = mailDesParser.getChestPackShowName(mail, class)
		if name then
			mailDesParser = nil
			;(nil).name = name
			local summary = i18n("common_text_2096", nil)
			return summary
		end
	end
end
_ENV = "Content_History_Recharge_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_History_Recharge_Reward], ("Content_History_Recharge_Reward").parseDes = "Content_History_Recharge_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local gold = content.gold
		_ENV = nil
		;(nil).gold = gold
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_HeroTrial_AutoBattle_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroTrial_AutoBattle_End], ("Content_HeroTrial_AutoBattle_End").parseDes = "Content_HeroTrial_AutoBattle_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		local num = content.num
		if num ~= nil and num ~= 0 then
			if content.stage ~= nil then
				local numEnd = heroTrialltCtrl.transformStage(content.stage)
				print("numEnd, ", numEnd)
				_ENV = numEnd
				numEnd.time = timeStr
				numEnd.num = num
				numEnd.numEnd = numEnd
				strTip = i18n("common_text_2361", numEnd)
			else
				_ENV = "common_text_2361"
				;("common_text_2361").time = timeStr
				;("common_text_2361").num = num
				strTip = i18n(formatedStr, "common_text_2361")
			end
		else
			_ENV = "common_text_2361"
			;("common_text_2361").time = timeStr
			;("common_text_2361").num = num
			strTip = i18n("mail_text_183", "common_text_2361")
		end
	end
	return strTip
end
_ENV = "Content_HeroTrial_AutoBattle_Loose_Ten"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroTrial_AutoBattle_Loose_Ten], ("Content_HeroTrial_AutoBattle_Loose_Ten").parseDes = "Content_HeroTrial_AutoBattle_Loose_Ten", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		local num = content.num
		if num ~= nil and num ~= 0 then
			if content.stage ~= nil then
				local numEnd = heroTrialltCtrl.transformStage(content.stage)
				_ENV = nil
				;(nil).time = timeStr
				;(nil).num = num
				;(nil).numEnd = numEnd
				strTip = i18n("common_text_2362", nil)
			else
				_ENV = "common_text_2362"
				;("common_text_2362").time = timeStr
				;("common_text_2362").num = num
				strTip = i18n(formatedStr, "common_text_2362")
			end
		else
			_ENV = "common_text_2362"
			;("common_text_2362").time = timeStr
			;("common_text_2362").num = num
			strTip = i18n("mail_text_184", "common_text_2362")
		end
	end
	return strTip
end
_ENV = "Content_HeroTrial_AutoBattle_All_Dead"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroTrial_AutoBattle_All_Dead], ("Content_HeroTrial_AutoBattle_All_Dead").parseDes = "Content_HeroTrial_AutoBattle_All_Dead", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		local num = content.num
		if num ~= nil and num ~= 0 then
			if content.stage ~= nil then
				local numEnd = heroTrialltCtrl.transformStage(content.stage)
				_ENV = nil
				;(nil).time = timeStr
				;(nil).num = num
				;(nil).numEnd = numEnd
				strTip = i18n("common_text_2363", nil)
			else
				_ENV = "common_text_2363"
				;("common_text_2363").time = timeStr
				;("common_text_2363").num = num
				strTip = i18n(formatedStr, "common_text_2363")
			end
		else
			_ENV = "common_text_2363"
			;("common_text_2363").time = timeStr
			;("common_text_2363").num = num
			strTip = i18n("mail_text_185", "common_text_2363")
		end
	end
	return strTip
end
_ENV = "Content_HeroTrial_AutoBattle_Success"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroTrial_AutoBattle_Success], ("Content_HeroTrial_AutoBattle_Success").parseDes = "Content_HeroTrial_AutoBattle_Success", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		if content.stage ~= nil then
			local numEnd = heroTrialltCtrl.transformStage(content.stage)
			_ENV = nil
			;(nil).time = timeStr
			;(nil).numEnd = numEnd
			strTip = i18n("common_text_2364", nil)
		else
			_ENV = "common_text_2364"
			;("common_text_2364").time = timeStr
			strTip = i18n(formatedStr, "common_text_2364")
		end
	end
	return strTip
end
_ENV = "Content_WorldBoss_AttackSuccess"
;("Content_WorldBoss_AttackSuccess").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local extra = mail.property.extra
		if not extra or 0 == #extra then
			formatedStr = "remains_text_166"
		end
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType, content.lv)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).bossName = bossName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WorldBoss_AttackSuccess], ("Content_WorldBoss_AttackSuccess").parseSummary = "Content_WorldBoss_AttackSuccess", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_HeroBoss_AttackSuccess"
;("Content_HeroBoss_AttackSuccess").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).BossName = bossName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroBoss_AttackSuccess], ("Content_HeroBoss_AttackSuccess").parseSummary = "Content_HeroBoss_AttackSuccess", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_WorldBoss_AttackFailure"
;("Content_WorldBoss_AttackFailure").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType, content.lv)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).lv = content.lv
		;(nil).bossName = bossName
		strTip = i18n(formatedStr, nil)
		if bossType == gBossType.monkeyBoss then
			local num = content.leftAttackNum or SoraDGetCtrl("activity_9001721_Ctrl"):getBossLeftAttackNum()
			worldMapDefine = content.lv
			content.lv.num = num
			strTip = i18n("worldboss_monkey_20", content.lv)
		end
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WorldBoss_AttackFailure], ("Content_WorldBoss_AttackFailure").parseSummary = "Content_WorldBoss_AttackFailure", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_HeroBoss_AttackFailure"
;("Content_HeroBoss_AttackFailure").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).BossName = bossName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroBoss_AttackFailure], ("Content_HeroBoss_AttackFailure").parseSummary = "Content_HeroBoss_AttackFailure", function(mail)
	local bossSummary = mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
	return bossSummary
end
_ENV = "Content_WorldBoss_AttackRewardOverFlow"
;("Content_WorldBoss_AttackRewardOverFlow").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType, content.lv)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).lv = content.lv
		;(nil).bossName = bossName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WorldBoss_AttackRewardOverFlow], ("Content_WorldBoss_AttackRewardOverFlow").parseSummary = "Content_WorldBoss_AttackRewardOverFlow", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_WorldBoss_KillReward"
;("Content_WorldBoss_KillReward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		if bossType == 6 or bossType == 10 or bossType == gBossType.ruinsWarMyBoss then
			formatedStr = "remains_text_186"
		elseif bossType == 7 or bossType == 11 or bossType == gBossType.ruinsWarZjssgBoss then
			formatedStr = "remains_text_185"
		elseif bossType == gBossType.ruinsWarBxmsBoss then
			formatedStr = "mail_text_590"
		elseif bossType == gBossType.ruinsWarMmjxBoss then
			formatedStr = "mail_text_591"
		end
		local bossName = worldMapDefine.getWorldBossName(bossType, content.lv)
		bossName = i18n(bossName)
		_ENV = nil
		;(nil).lv = content.lv
		;(nil).bossName = bossName
		strTip = i18n(formatedStr, nil)
		if bossType == gBossType.monkeyBoss then
			bossName = i18n("worldboss_monkey_08")
			_ENV = nil
			;(nil).bossName = bossName
			strTip = i18n("worldboss_monkey_16", nil)
		end
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WorldBoss_KillReward], ("Content_WorldBoss_KillReward").parseSummary = "Content_WorldBoss_KillReward", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_Baboon_Boss_Captain_Reward"
;("Content_Baboon_Boss_Captain_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local bossType = content.bossType
	local bossName = worldMapDefine.getWorldBossName(bossType)
	bossName = i18n(bossName)
	worldMapDefine = nil
	;(nil).var1 = content.lv
	;(nil).var2 = bossName
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Baboon_Boss_Captain_Reward], ("Content_Baboon_Boss_Captain_Reward").parseSummary = "Content_Baboon_Boss_Captain_Reward", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_Boss_Gift_Reward"
;("Content_Boss_Gift_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local activityID = tonumber(content.activityid)
	local varStr = ""
	if activityID == gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY then
		varStr = i18n("activity_name_9001201")
	elseif activityID == gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY then
		varStr = i18n("activity_name_9001197")
	end
	_ENV = nil
	;(nil).var = varStr
	;(nil).num = content.count
	return i18n("alliancerewards_text_05", nil)
end
;("Content_Boss_Gift_Reward").parseTitle = function(mail)
	local activityID = tonumber(mail.property.data.content.activityid)
	local varStr = ""
	if activityID == gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY then
		varStr = i18n("activity_name_9001201")
	elseif activityID == gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY then
		varStr = i18n("activity_name_9001197")
	end
	_ENV = nil
	;(nil).var = varStr
	return i18n("alliancerewards_text_03", nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Boss_Gift_Reward], ("Content_Boss_Gift_Reward").parseSummary = "Content_Boss_Gift_Reward", function(mail)
	return i18n("alliancerewards_text_04")
end
_ENV = "Content_HeroBoss_AttackBySelf"
;("Content_HeroBoss_AttackBySelf").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).BossName = bossName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroBoss_AttackBySelf], ("Content_HeroBoss_AttackBySelf").parseSummary = "Content_HeroBoss_AttackBySelf", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_WorldBoss_KillSmallReward"
;("Content_WorldBoss_KillSmallReward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType, content.lv)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).lv = content.lv
		;(nil).bossName = bossName
		;(nil).name = content.name
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WorldBoss_KillSmallReward], ("Content_WorldBoss_KillSmallReward").parseSummary = "Content_WorldBoss_KillSmallReward", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_HeroBoss_AttackByAllies"
;("Content_HeroBoss_AttackByAllies").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).BossName = bossName
		;(nil).lordName = content.name
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroBoss_AttackByAllies], ("Content_HeroBoss_AttackByAllies").parseSummary = "Content_HeroBoss_AttackByAllies", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_WorldBoss_KillRewardOverFlow"
;("Content_WorldBoss_KillRewardOverFlow").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local bossType = content.bossType
		local bossName = worldMapDefine.getWorldBossName(bossType, content.lv)
		bossName = i18n(bossName)
		worldMapDefine = nil
		;(nil).lv = content.lv
		;(nil).bossName = bossName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WorldBoss_KillRewardOverFlow], ("Content_WorldBoss_KillRewardOverFlow").parseSummary = "Content_WorldBoss_KillRewardOverFlow", function(mail)
	return mailDesParser.npcFuncMap_parseWorldBossSummary(mail)
end
_ENV = "Content_Escort_Treasure_Help_Ally_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Escort_Treasure_Help_Ally_Reward], ("Content_Escort_Treasure_Help_Ally_Reward").parseDes = "Content_Escort_Treasure_Help_Ally_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = content.name
		;(nil).addAtk = (content.addAtk or 0) / 10
		;(nil).addDef = (content.addDef or 0) / 10
		;(nil).addLife = (content.addLife or 0) / 10
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Escort_Treasure_Success"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Escort_Treasure_Success], ("Content_Escort_Treasure_Success").parseDes = "Content_Escort_Treasure_Success", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local carLv = content.carId
		local escortDesRead = include("escortDesRead")
		local car = i18n(escortDesRead.getCarName(carLv))
		_ENV = escortDesRead.getCarName(carLv)
		escortDesRead.getCarName(carLv).car = car
		strTip = i18n(formatedStr, escortDesRead.getCarName(carLv))
	end
	return strTip
end
_ENV = "Content_Escort_Treasure_Addition_Buf_Open"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Escort_Treasure_Addition_Buf_Open], ("Content_Escort_Treasure_Addition_Buf_Open").parseDes = "Content_Escort_Treasure_Addition_Buf_Open", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		_ENV = nil
		;(nil).name = content.name
		;(nil).time = timeStr
		;(nil).addPercent = content.addPercent * 100
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Escort_Treasure_Addition_Buf_Closed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Escort_Treasure_Addition_Buf_Closed], ("Content_Escort_Treasure_Addition_Buf_Closed").parseDes = "Content_Escort_Treasure_Addition_Buf_Closed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		_ENV = nil
		;(nil).time = timeStr
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Attack_Kingdom_Palace_Failure"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Attack_Kingdom_Palace_Failure], ("Content_Attack_Kingdom_Palace_Failure").parseDes = "Content_Attack_Kingdom_Palace_Failure", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		if content.rank ~= nil then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n("common_text_2365", nil)
		end
	end
	return strTip
end
_ENV = "Content_Attack_Kingdom_Palace_Victory"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Attack_Kingdom_Palace_Victory], ("Content_Attack_Kingdom_Palace_Victory").parseDes = "Content_Attack_Kingdom_Palace_Victory", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		if content.rank ~= nil then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n("common_text_2366", nil)
		end
	end
	return strTip
end
_ENV = "Content_Defense_Kingdom_Palace_Failure"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Defense_Kingdom_Palace_Failure], ("Content_Defense_Kingdom_Palace_Failure").parseDes = "Content_Defense_Kingdom_Palace_Failure", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		if content.rank ~= nil then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n("common_text_2367", nil)
		end
	end
	return strTip
end
_ENV = "Content_Defense_Kingdom_Palace_Victory"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Defense_Kingdom_Palace_Victory], ("Content_Defense_Kingdom_Palace_Victory").parseDes = "Content_Defense_Kingdom_Palace_Victory", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		if content.rank ~= nil then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n("common_text_2368", nil)
		end
	end
	return strTip
end
_ENV = "Content_StrongestLordRankState"
;("Content_StrongestLordRankState").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local activityId = content.activityId
		local stage = content.stage
		local nextActivityId = content.nextActivityId
		local nextStage = content.nextStage
		local eventName = mailDesParser.getKingsOrderActivityName(activityId)
		local nextEventName = mailDesParser.getKingsOrderActivityName(nextActivityId)
		if nextEventName ~= nil and nextEventName ~= "" then
			mailDesParser = nil
			;(nil).stage = stage
			;(nil).curActivity = eventName
			;(nil).nextStage = nextStage
			;(nil).nextActivity = nextEventName
			strTip = i18n(formatedStr, nil)
		else
			mailDesParser = nil
			;(nil).stage = stage
			;(nil).curActivity = eventName
			strTip = i18n("common_text_2523", nil)
		end
		if content.topTen and #content.topTen > 0 then
			mailDesParser = nil
			;(nil).stage = stage
			;(nil).curActivity = eventName
			;(nil).num = #content.topTen
			strTip = strTip .. i18n("common_text_2569", nil) .. "\n"
			for i = 1, #content.topTen do
				local name = mailFunctions:getWrappedName(content.topTen[i].abbr, content.topTen[i].nickName)
				mailDesParser = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StrongestLordRankState], ("Content_StrongestLordRankState").parseSummary = "Content_StrongestLordRankState", function(mail)
	print("mailDesParser.npcFuncMap[gMailNPCContentType.Content_StrongestLordRankState]-------")
	local activityId = mail.property.data.content.activityId
	local eventName = mailDesParser.getKingsOrderActivityName(activityId)
	return eventName
end
_ENV = "Content_StrongestLordRank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StrongestLordRank], ("Content_StrongestLordRank").parseDes = "Content_StrongestLordRank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil and content.topTen and #content.topTen > 0 then
		local name = mailFunctions:getWrappedName(content.topTen[1].abbr, content.topTen[1].nickName)
		mailFunctions = content.topTen[1].nickName
		content.topTen[1].nickName.name = name
		strTip = i18n(formatedStr, content.topTen[1].nickName)
		if #content.topTen > 0 then
			mailFunctions = nil
			;(nil).num = #content.topTen
			strTip = strTip .. i18n("common_text_2568", nil) .. "\n"
			for i = 1, #content.topTen do
				name = mailFunctions:getWrappedName(content.topTen[i].abbr, content.topTen[i].nickName)
				mailFunctions = content.topTen[i].nickName
				content.topTen[i].nickName.lv = i
				content.topTen[i].nickName.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", content.topTen[i].nickName)
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_TongTian_Tower_End_Notify"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_TongTian_Tower_End_Notify], ("Content_TongTian_Tower_End_Notify").parseDes = "Content_TongTian_Tower_End_Notify", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil and content.rankData and #content.rankData > 0 then
		local name = mailFunctions:getWrappedName(content.rankData[1].alliance, content.rankData[1].nickName)
		mailFunctions = content.rankData[1].nickName
		content.rankData[1].nickName.name = name
		content.rankData[1].nickName.num = #content.rankData
		strTip = i18n(formatedStr, content.rankData[1].nickName)
		if #content.rankData > 0 then
			for i = 1, #content.rankData do
				name = mailFunctions:getWrappedName(content.rankData[i].alliance, content.rankData[i].nickName)
				mailFunctions = content.rankData[i].nickName
				content.rankData[i].nickName.lv = i
				content.rankData[i].nickName.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", content.rankData[i].nickName)
				if content.rankData[i].floor then
					mailFunctions = nil
					;(nil).num = content.rankData[i].floor
					itemRankTip = itemRankTip .. "  " .. i18n("Promise_Summit_text_01", nil)
				end
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_Kingdom_Conquest_Win"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Kingdom_Conquest_Win], ("Content_Kingdom_Conquest_Win").parseDes = "Content_Kingdom_Conquest_Win", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		if content.battleType == 1 and content.targetKName then
			_ENV = nil
			;(nil).targetKName = content.targetKName
			;(nil).percent = 30
			strTip = i18n("conquestwar_text_03", nil)
		elseif content.battleType == 2 and content.targetKName then
			_ENV = nil
			;(nil).targetKName = content.targetKName
			;(nil).percent = 15
			strTip = i18n("conquestwar_text_04", nil)
		else
			strTip = i18n(formatedStr)
		end
		for i = 1, #content.topTen do
			local name = mailFunctions:getWrappedName(content.topTen[i].abbr, content.topTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Kingdom_Conquest_Lose"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Kingdom_Conquest_Lose], ("Content_Kingdom_Conquest_Lose").parseDes = "Content_Kingdom_Conquest_Lose", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		for i = 1, #content.topTen do
			local name = mailFunctions:getWrappedName(content.topTen[i].abbr, content.topTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Activity_Open"
;("Content_Activity_Open").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	local activityId = content.activityId
	local activityType = content.classtype
	local activityTimeRead = include("activityTimeRead")
	if activityId then
		local des = activityTimeRead.getActivityDesByID(activityId, activityType)
		if des and des ~= "" then
			strTip = i18n(des)
		end
	end
	if strTip == "" and formatedStr ~= nil and activityId then
		local activityTimeRead = include("activityTimeRead")
		local name = activityTimeRead.getActivityNameByID(activityId, activityType)
		if name and name ~= "" and activityId ~= gActivityTimeActivityID.JADE_STONE_MALL_ACTIVITY then
			_ENV = nil
			;(nil).activity = i18n(name)
			strTip = i18n(formatedStr, nil)
		end
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Activity_Open], ("Content_Activity_Open").parseSummary = "Content_Activity_Open", function(mail)
	local activityTimeRead = include("activityTimeRead")
	local activityId = mail.property.data.content.activityId
	local activityType = mail.property.data.content.classtype
	local mailsummary
	if activityId then
		local name = activityTimeRead.getActivityNameByID(activityId, activityType)
		if name and name ~= "" then
			mailsummary = i18n(name)
		end
	end
	return mailsummary
end
_ENV = "Content_Dismiss_Official_Pos"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Dismiss_Official_Pos], ("Content_Dismiss_Official_Pos").parseDes = "Content_Dismiss_Official_Pos", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local officialPos = content.officialPos
	local officialInfoRead = include("officialInfoRead")
	local officialItem = officialInfoRead.getInfoByType(officialPos)
	local officialName = ""
	if officialItem then
		officialName = i18n(officialItem.name)
	end
	if formatedStr ~= nil then
		local isGood = officialInfoRead.judgeGoodOrBad(content.officialPos)
		local name = ""
		if content.kingName ~= nil then
			name = mailFunctions:getWrappedName(content.kingAbbr, content.kingName)
			formatedStr = "common_text_3164"
		end
		local isKing = content.isKing
		_ENV = content.kingName
		content.kingName.status = isKing and i18n("official_name_1") or i18n("official_name_2")
		content.kingName.name = name
		content.kingName.officialPos = officialName
		strTip = i18n(formatedStr, content.kingName)
	end
	return strTip
end
_ENV = "Content_Merge_Server_Dismiss_Official"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Merge_Server_Dismiss_Official], ("Content_Merge_Server_Dismiss_Official").parseDes = "Content_Merge_Server_Dismiss_Official", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local officialPos = content.oType
	local officialInfoRead = include("officialInfoRead")
	local officialItem = officialInfoRead.getInfoByType(tonumber(officialPos))
	local officialName = ""
	if officialItem then
		officialName = i18n(officialItem.name)
	end
	if formatedStr ~= nil then
		_ENV = tonumber(officialPos)
		tonumber(officialPos).name = officialName
		strTip = i18n(formatedStr, tonumber(officialPos))
	end
	return strTip
end
_ENV = "Content_Alliance_Army_Assist"
;("Content_Alliance_Army_Assist").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = content.name
		;(nil).x = content.coordinate and content.coordinate.x
		;(nil).y = content.coordinate and content.coordinate.y
		;(nil).armyNum = string.formatnumberthousands(content.armyNum)
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Army_Assist], ("Content_Alliance_Army_Assist").parseSummary = "Content_Alliance_Army_Assist", function(mail)
	return mailDesParser.defaultNpcParseSummary(mail)
end
_ENV = "Content_Seize_The_Treasure"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Seize_The_Treasure], ("Content_Seize_The_Treasure").parseDes = "Content_Seize_The_Treasure", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil and content.item then
		local itemName = publicRead.getName(content.item)
		publicRead = nil
		;(nil).item = itemName
		;(nil).num = content.num
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Alliance_Recharge_Gift"
;("Content_Alliance_Recharge_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = content.gift
	local giftName = mailDesParser.getSingleRechargeGiftName(id)
	if content.isHideGiftName then
		giftName = ""
	end
	mailDesParser = nil
	;(nil).name = content.name
	;(nil).gold = content.gold
	;(nil).gift = giftName
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Recharge_Gift], ("Content_Alliance_Recharge_Gift").parseSummary = "Content_Alliance_Recharge_Gift", function(mail)
	local id = mail.property.data.content.gift
	local summary = mailDesParser.getSingleRechargeGiftName(id)
	if mail.property.data.content.isHideGiftName then
		summary = i18n("recharge_name_03")
	else
		summary = mailDesParser.getSingleRechargeGiftName(id)
	end
	return summary
end
_ENV = "Content_Personal_Time_Competition_RankReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Personal_Time_Competition_RankReward], ("Content_Personal_Time_Competition_RankReward").parseDes = "Content_Personal_Time_Competition_RankReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		;(nil).num = content.topTen and #content.topTen or 0
		strTip = i18n(formatedStr, nil)
		if content.topTen and #content.topTen > 0 then
			strTip = strTip .. "\n"
			for i = 1, #content.topTen do
				local name = mailFunctions:getWrappedName(content.topTen[i].allianceAbbr, content.topTen[i].nickName)
				name = "#" .. content.topTen[i].kingdom .. " " .. name
				_ENV = name
				name.lv = i
				name.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", name)
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_HeroBoss_RankAward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroBoss_RankAward], ("Content_HeroBoss_RankAward").parseDes = "Content_HeroBoss_RankAward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		;(nil).point = content.totalPoint
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Develop_Arms_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Develop_Arms_Rank], ("Content_Develop_Arms_Rank").parseDes = "Content_Develop_Arms_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		;(nil).num = content.topTen and #content.topTen or 0
		strTip = i18n(formatedStr, nil)
		if content.topTen and #content.topTen > 0 then
			strTip = strTip .. "\n"
			for i = 1, #content.topTen do
				local name = mailFunctions:getWrappedName(content.topTen[i].allianceAbbr, content.topTen[i].nickName)
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_Be_King"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Be_King], ("Content_Be_King").parseDes = "Content_Be_King", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local officialPos = content.officialPos
	local officialInfoRead = include("officialInfoRead")
	local officialItem = officialInfoRead.getInfoByType(officialPos)
	local officialName
	if officialItem then
		officialName = i18n(officialItem.name)
	end
	local privilegeDes = ""
	local bufidArray = content.bufid or officialItem.buff
	local officialBuffRead = include("officialBuffRead")
	if bufidArray then
		for i, v in ipairs(bufidArray) do
			local bufid = bufidArray[i]
			local bufItem = officialBuffRead.getItem(bufid)
			if bufItem and bufItem.buffDes then
				privilegeDes = privilegeDes .. i18n(bufItem.buffDes) .. "\n"
			end
		end
	end
	if formatedStr ~= nil then
		_ENV = ipairs(bufidArray)
		ipairs(bufidArray).kingdomName = content.kingdomName
		ipairs(bufidArray).privilege = privilegeDes
		strTip = i18n(formatedStr, ipairs(bufidArray))
	end
	return strTip
end
_ENV = "Content_Merge_Server_Unbind"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Merge_Server_Unbind], ("Content_Merge_Server_Unbind").parseDes = "Content_Merge_Server_Unbind", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).kingdomName = serviceFunctions.getKingdomFormatName(content.kingdomName, content.kid)
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Chaser_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Chaser_Reward], ("Content_Chaser_Reward").parseDes = "Content_Chaser_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local lv = content.lv
		local buildLogic = include("buildLogic")
		local isWarLv, warLv, percent = buildLogic.isBuildWarLv(lv)
		if isWarLv then
			if percent == 0 then
				_ENV = nil
				_ENV = nil
				;(nil).lv = warLv
				;(nil).lv = i18n("common_text_1948", nil)
				strTip = i18n(formatedStr, nil)
			else
				_ENV = nil
				_ENV = nil
				;(nil).lv = warLv .. "(" .. percent * 100 .. "%)"
				;(nil).lv = i18n("common_text_1948", nil)
				strTip = i18n(formatedStr, nil)
			end
		else
			strTip = i18n(formatedStr, content)
		end
	end
	return strTip
end
_ENV = "Content_Auction_Win"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Auction_Win], ("Content_Auction_Win").parseDes = "Content_Auction_Win", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local itemId = content.itemId
		local num = content.num or 1
		if itemId ~= nil then
			local item = publicRead.getName(itemId)
			if item then
				publicRead = nil
				;(nil).name = item
				;(nil).num = num
				strTip = i18n(formatedStr, nil)
			else
				publicRead = nil
				;(nil).name = itemId
				;(nil).num = num
				strTip = i18n(formatedStr, nil)
			end
		end
	end
	return strTip
end
_ENV = "Content_New_Give_Item"
;("Content_New_Give_Item").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = content.nickName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Give_Item], ("Content_New_Give_Item").parseSummary = "Content_New_Give_Item", function(mail)
	local itemid = mail.property.data.content.itemID
	local summary = itemid == nil and i18n("item_name_860601") or publicRead.getName(itemid)
	return summary
end
_ENV = "Content_Auction_Beyond"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Auction_Beyond], ("Content_Auction_Beyond").parseDes = "Content_Auction_Beyond", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Auction_Win].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_Kingdom_Conquest_Lose_Personal_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Kingdom_Conquest_Lose_Personal_Reward], ("Content_Kingdom_Conquest_Lose_Personal_Reward").parseDes = "Content_Kingdom_Conquest_Lose_Personal_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.score ~= nil then
		strTip = i18n("common_text_2843", content)
	elseif formatedStr ~= nil then
		strTip = i18n(formatedStr, content)
	end
	return strTip
end
_ENV = "Content_Kingdom_Conquest_Win_Personal_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Kingdom_Conquest_Win_Personal_Reward], ("Content_Kingdom_Conquest_Win_Personal_Reward").parseDes = "Content_Kingdom_Conquest_Win_Personal_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.score ~= nil then
		strTip = i18n("common_text_2855", content)
	elseif formatedStr ~= nil then
		strTip = i18n(formatedStr, content)
	end
	return strTip
end
_ENV = "Content_Wrong_Search_Monster_Answer"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Wrong_Search_Monster_Answer], ("Content_Wrong_Search_Monster_Answer").parseDes = "Content_Wrong_Search_Monster_Answer", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local time = content.time
		local timeStr = SoraDConverSecondToDate(time)
		_ENV = nil
		;(nil).count = content.count
		;(nil).time = timeStr
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Wrong_Search_Monster_Answer_Max"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Wrong_Search_Monster_Answer_Max], ("Content_Wrong_Search_Monster_Answer_Max").parseDes = "Content_Wrong_Search_Monster_Answer_Max", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local time = content.time
		local timeStr = SoraDConverSecondToDate(time)
		_ENV = nil
		;(nil).count = content.count
		;(nil).time = timeStr
		;(nil).timeReset = timeStr
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_CrazyIntegral_Personal_Rank_Award"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_CrazyIntegral_Personal_Rank_Award], ("Content_CrazyIntegral_Personal_Rank_Award").parseDes = "Content_CrazyIntegral_Personal_Rank_Award", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		;(nil).num = #content.topTen
		strTip = i18n(formatedStr, nil)
		for i = 1, #content.topTen do
			local name = mailFunctions:getWrappedName(content.topTen[i].abbr, content.topTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_CrazyIntegral_Alliance_Rank_Award"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_CrazyIntegral_Alliance_Rank_Award], ("Content_CrazyIntegral_Alliance_Rank_Award").parseDes = "Content_CrazyIntegral_Alliance_Rank_Award", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		;(nil).num = #content.topTen
		strTip = i18n(formatedStr, nil)
		for i = 1, #content.topTen do
			_ENV = nil
			;(nil).abbr = content.topTen[i].abbr
			;(nil).name = content.topTen[i].abbName
			local name = i18n("common_text_186", nil)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_CrazyIntegral_Kingdom_Rank_Award"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_CrazyIntegral_Kingdom_Rank_Award], ("Content_CrazyIntegral_Kingdom_Rank_Award").parseDes = "Content_CrazyIntegral_Kingdom_Rank_Award", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		;(nil).num = #content.topFive
		strTip = i18n(formatedStr, nil)
		for i = 1, #content.topFive do
			local name = content.topFive[i].kname
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topFive[i].kid ~= nil then
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Alliance_Flag_Build"
;("Content_Alliance_Flag_Build").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = content.nickName
		;(nil).x = content.coordinate.x
		;(nil).y = content.coordinate.y
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Flag_Build], ("Content_Alliance_Flag_Build").parseSummary = "Content_Alliance_Flag_Build", function(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local mailContentType = mail.property.data.contentType
	local mailDesInfo = mailDesRead.getMailDesInfo(mailType, mailSource, mailContentType)
	local content = mail.property.data.content
	if mailDesInfo then
		local formatedStr = mailDesInfo.summary
		if formatedStr ~= "" then
			mailDesRead = nil
			;(nil).name = content.nickName
			;(nil).x = content.coordinate.x
			;(nil).y = content.coordinate.y
			local summary = i18n(formatedStr, nil)
			return summary
		end
	end
end
_ENV = "Content_Build_Alliance_Building"
;("Content_Build_Alliance_Building").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = content.nickName
		;(nil).build = allianceDesRead.getBuildName(content.bid)
		;(nil).x = content.coordinate.x
		;(nil).y = content.coordinate.y
		strTip = i18n("common_text_4738", nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Build_Alliance_Building], ("Content_Build_Alliance_Building").parseSummary = "Content_Build_Alliance_Building", function(mail)
	local mailType = mail.property.mailType
	local mailSource = mail.property.source
	local mailContentType = mail.property.data.contentType
	local mailDesInfo = mailDesRead.getMailDesInfo(mailType, mailSource, mailContentType)
	local content = mail.property.data.content
	if mailDesInfo then
		local formatedStr = mailDesInfo.summary
		if formatedStr ~= "" then
			mailDesRead = nil
			;(nil).name = content.nickName
			;(nil).build = allianceDesRead.getBuildName(content.bid)
			;(nil).x = content.coordinate.x
			;(nil).y = content.coordinate.y
			local summary = i18n("alliance_text_17", nil)
			return summary
		end
	end
end
_ENV = "Content_Alliance_Flag_Be_Destroyed"
;("Content_Alliance_Flag_Be_Destroyed").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local buildId = content.buildId
		local buildName = allianceDesRead.getBuildName(buildId)
		allianceDesRead = nil
		;(nil).abbr = content.abbr
		;(nil).build = buildName
		;(nil).x = content.coordinate.x
		;(nil).y = content.coordinate.y
		;(nil).abbrAtk = content.abbrAtk
		;(nil).allianceNameAtk = content.allianceNameAtk
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Flag_Be_Destroyed], ("Content_Alliance_Flag_Be_Destroyed").parseSummary = "Content_Alliance_Flag_Be_Destroyed", function(mail)
	local summary
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	if mailDesInfo then
		local formatedStr = mailDesInfo.summary
		if formatedStr ~= "" then
			local buildId = mail.property.data.content.buildId
			local buildName = allianceDesRead.getBuildName(buildId)
			mailDesParser = nil
			;(nil).build = buildName
			summary = i18n(formatedStr, nil)
			return summary
		end
	end
end
_ENV = "Content_CrazyIntegral_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_CrazyIntegral_End], ("Content_CrazyIntegral_End").parseDes = "Content_CrazyIntegral_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr)
		if content.topServers then
			_ENV = nil
			;(nil).rank = #content.topServers
			strTip = strTip .. "\n" .. i18n("common_text_3095", nil)
			for i = 1, #content.topServers do
				local name = content.topServers[i].kname
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				if content.topServers[i].kid ~= nil then
				end
				strTip = strTip .. itemRankTip
			end
		end
		if content.topAlliances then
			_ENV = content.topServers[i].kname
			content.topServers[i].kname.rank = #content.topAlliances
			strTip = strTip .. [[


]] .. i18n("common_text_3096", content.topServers[i].kname)
			for i = 1, #content.topAlliances do
				_ENV = strTip
				strTip.abbr = content.topAlliances[i].abbr
				strTip.name = content.topAlliances[i].abbName
				local name = i18n("common_text_186", strTip)
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				if content.topAlliances[i].kid ~= nil then
					itemRankTip = itemRankTip .. " #" .. content.topAlliances[i].kid
				end
				strTip = strTip .. itemRankTip
			end
		end
		if content.topPlayers then
			_ENV = i18n("common_text_186", strTip)
			i18n("common_text_186", strTip).rank = #content.topPlayers
			strTip = strTip .. [[


]] .. i18n("common_text_3097", (i18n("common_text_186", strTip)))
			for i = 1, #content.topPlayers do
				local name = mailFunctions:getWrappedName(content.topPlayers[i].abbr, content.topPlayers[i].nickName)
				_ENV = content.topAlliances[i].kid
				content.topAlliances[i].kid.lv = i
				content.topAlliances[i].kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", content.topAlliances[i].kid)
				if content.topPlayers[i].kid ~= nil then
					itemRankTip = itemRankTip .. " #" .. content.topPlayers[i].kid
				end
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_Monsterpalce_superaward_normal"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Monsterpalce_superaward_normal], ("Content_Monsterpalce_superaward_normal").parseDes = "Content_Monsterpalce_superaward_normal", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local name = mailFunctions:getWrappedName(content.abbr, content.name)
		mailFunctions = content.name
		content.name.name = name
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_Snow_Wolf_superaward_normal"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Snow_Wolf_superaward_normal], ("Content_Snow_Wolf_superaward_normal").parseDes = "Content_Snow_Wolf_superaward_normal", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local name = mailFunctions:getWrappedName(content.abbr, content.name)
		mailFunctions = content.name
		content.name.name = name
		content.name.goldNum = content.goldNum or 30000
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_Monsterpalce_superaward_elite"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Monsterpalce_superaward_elite], ("Content_Monsterpalce_superaward_elite").parseDes = "Content_Monsterpalce_superaward_elite", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Monsterpalce_superaward_normal].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_Snow_Wolf_superaward_elite"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Snow_Wolf_superaward_elite], ("Content_Snow_Wolf_superaward_elite").parseDes = "Content_Snow_Wolf_superaward_elite", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local name = mailFunctions:getWrappedName(content.abbr, content.name)
		mailFunctions = content.name
		content.name.name = name
		content.name.goldNum = content.goldNum or 30000
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_Return_Of_The_King"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Return_Of_The_King], ("Content_Return_Of_The_King").parseDes = "Content_Return_Of_The_King", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		_ENV = nil
		;(nil).name = content.name
		;(nil).time = timeStr
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Pyramid_Battle_Register_Success"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Pyramid_Battle_Register_Success], ("Content_Pyramid_Battle_Register_Success").parseDes = "Content_Pyramid_Battle_Register_Success", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local beginTime = os.date("!%Y-%m-%d %H:%M", content.beginTime)
		local endTime = os.date("!%Y-%m-%d %H:%M", content.endTime)
		_ENV = nil
		;(nil).name = content.name
		;(nil).beginTime = beginTime
		;(nil).endTime = endTime
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Pyramid_Battle_Winner_Notice"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Pyramid_Battle_Winner_Notice], ("Content_Pyramid_Battle_Winner_Notice").parseDes = "Content_Pyramid_Battle_Winner_Notice", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		if content.isPostWar then
			formatedStr = "common_text_4015"
		end
		_ENV = nil
		;(nil).ourScore = content.ourScore
		;(nil).enemyScore = content.enemyScore
		;(nil).honour = content.honour
		strTip = i18n(formatedStr, nil)
		if content.topThree and #content.topThree > 0 then
			_ENV = content.honour
			content.honour.num = #content.topThree
			strTip = strTip .. i18n("common_text_3219", content.honour)
			for i = 1, #content.topThree do
				local name = content.topThree[i].nickName
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_Pyramid_Battle_Loser_Notice"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Pyramid_Battle_Loser_Notice], ("Content_Pyramid_Battle_Loser_Notice").parseDes = "Content_Pyramid_Battle_Loser_Notice", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		if content.isPostWar then
			formatedStr = "common_text_4024"
		end
		_ENV = nil
		;(nil).ourScore = content.ourScore
		;(nil).enemyScore = content.enemyScore
		;(nil).honour = content.honour
		strTip = i18n(formatedStr, nil)
		if content.topThree and #content.topThree > 0 then
			_ENV = content.honour
			content.honour.num = #content.topThree
			strTip = strTip .. i18n("common_text_3219", content.honour)
			for i = 1, #content.topThree do
				local name = content.topThree[i].nickName
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
			end
		end
	end
	return strTip
end
_ENV = "Content_Pyramid_Battle_Playoff_Time"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Pyramid_Battle_Playoff_Time], ("Content_Pyramid_Battle_Playoff_Time").parseDes = "Content_Pyramid_Battle_Playoff_Time", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).time = timeStr
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Flower_Messenger_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Flower_Messenger_Rank], ("Content_Flower_Messenger_Rank").parseDes = "Content_Flower_Messenger_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr, content)
	end
	if content.topTen and #content.topTen > 0 then
		for i = 1, #content.topTen do
			local name = mailFunctions:getWrappedName(content.topTen[i].abbr, content.topTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Corolla_Contention_Charm_Star_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Corolla_Contention_Charm_Star_Rank], ("Content_Corolla_Contention_Charm_Star_Rank").parseDes = "Content_Corolla_Contention_Charm_Star_Rank", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_Flower_Messenger_Rank].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_GrowFund_Open"
;("Content_GrowFund_Open").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.buyGold == nil and content.backGold == nil then
		if formatedStr ~= nil then
			strTip = i18n(formatedStr, content)
		end
	elseif content.buyGold ~= nil and content.backGold ~= nil then
		strTip = i18n("common_text_3503", content)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_GrowFund_Open], ("Content_GrowFund_Open").parseSummary = "Content_GrowFund_Open", function(mail)
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	local formatedStr = mailDesInfo and mailDesInfo.summary
	local mailsummary
	if formatedStr and formatedStr ~= "" then
		mailDesParser = nil
		;(nil).activity = i18n("activityname_14")
		mailsummary = i18n(formatedStr, nil)
	end
	return mailsummary
end
_ENV = "Content_Alliance_Mobilize_Rank_Reawrd"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Mobilize_Rank_Reawrd], ("Content_Alliance_Mobilize_Rank_Reawrd").parseDes = "Content_Alliance_Mobilize_Rank_Reawrd", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.rank then
		_ENV = nil
		;(nil).rank = content.rank
		strTip = i18n("mail_text_424", nil)
	elseif formatedStr ~= nil then
		strTip = i18n(formatedStr, content)
	end
	return strTip
end
_ENV = "Content_Alliance_Mobilize_Mission_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Mobilize_Mission_Reward], ("Content_Alliance_Mobilize_Mission_Reward").parseDes = "Content_Alliance_Mobilize_Mission_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		strTip = i18n(formatedStr, content)
	end
	return strTip
end
_ENV = "Content_Alliance_Mobilize_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Mobilize_End], ("Content_Alliance_Mobilize_End").parseDes = "Content_Alliance_Mobilize_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.topFiveAlliances and #content.topFiveAlliances > 0 then
		_ENV = nil
		if not content.topFiveAlliances then
			_ENV = content.topFiveAlliances
		end
		;(nil).num = #content.topFiveAlliances
		strTip = i18n("common_text_3609", nil)
	elseif formatedStr ~= nil then
		strTip = i18n(formatedStr, content)
	end
	if content.topFiveAlliances and #content.topFiveAlliances > 0 then
		strTip = strTip .. "\n"
		for i = 1, #content.topFiveAlliances do
			_ENV = nil
			;(nil).abbr = content.topFiveAlliances[i].abbr
			;(nil).name = content.topFiveAlliances[i].abbName
			local name = i18n("common_text_186", nil)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.topFiveAlliances[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topFiveAlliances[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	if content.topThreePlayers and 0 < #content.topThreePlayers then
		_ENV = i18n("common_text_186", nil)
		i18n("common_text_186", nil).num = #content.topThreePlayers
		strTip = strTip .. "\n" .. i18n("common_text_3608", (i18n("common_text_186", nil)))
		for i = 1, #content.topThreePlayers do
			local name = mailFunctions:getWrappedName(content.topThreePlayers[i].abbr, content.topThreePlayers[i].nickName)
			_ENV = content.topFiveAlliances[i].kid
			content.topFiveAlliances[i].kid.lv = i
			content.topFiveAlliances[i].kid.name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", content.topFiveAlliances[i].kid)
			if content.topThreePlayers[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.topThreePlayers[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Alliance_Mobilize_Rank_Result"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Mobilize_Rank_Result], ("Content_Alliance_Mobilize_Rank_Result").parseDes = "Content_Alliance_Mobilize_Rank_Result", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.currentRank == gMobilizationMatchDef.MATCH_LEV_1 then
		local rank = content.nextRank
		local rankName = mobilizationltCtrl:getMobilizationNameByLv(rank)
		_ENV = nil
		;(nil).rank = i18n(rankName)
		strTip = i18n("common_text_3630", nil)
	else
		local rank = content.nextRank
		local rankName = mobilizationltCtrl:getMobilizationNameByLv(rank)
		if formatedStr ~= nil then
			_ENV = nil
			;(nil).rank = i18n(rankName)
			strTip = i18n(formatedStr, nil)
		end
	end
	return strTip
end
_ENV = "Content_CrazyCollection_GoodHeart"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_CrazyCollection_GoodHeart], ("Content_CrazyCollection_GoodHeart").parseDes = "Content_CrazyCollection_GoodHeart", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local item = publicRead.getName(content.item)
		local lordName = content.name
		if content.abbr then
			publicRead = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.name
			lordName = i18n("common_text_186", nil)
		end
		publicRead = nil
		;(nil).item = item
		;(nil).name = lordName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Seven_Day_Gift"
;("Content_Seven_Day_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local hasEquip = content.hasEquip
	local strTip
	local id = content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	if hasEquip == false then
		mailDesParser = nil
		;(nil).gift = name
		strTip = i18n(formatedStr, nil)
	else
		mailDesParser = nil
		;(nil).gift = name
		strTip = i18n("common_text_3831", nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Seven_Day_Gift], ("Content_Seven_Day_Gift").parseSummary = "Content_Seven_Day_Gift", function(mail)
	local id = mail.property.data.content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	return name
end
_ENV = "Content_Castle_LevelUp_Gift"
;("Content_Castle_LevelUp_Gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = content.id
	local lv = content.lv
	if not lv then
		return
	end
	local isShowWarLv, textLv = SoraDGetBuildWarLv(lv)
	if isShowWarLv then
		_ENV = nil
		;(nil).lv = textLv
		strTip = i18n("common_text_3995", nil)
	else
		_ENV = nil
		;(nil).lv = textLv
		strTip = i18n("common_text_3992", nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Castle_LevelUp_Gift], ("Content_Castle_LevelUp_Gift").parseSummary = "Content_Castle_LevelUp_Gift", function(mail)
	local summary
	local id = mail.property.data.content.id
	local lv = mail.property.data.content.lv
	if not lv then
		return
	end
	local isShowWarLv, textLv = SoraDGetBuildWarLv(lv)
	if isShowWarLv then
		_ENV = nil
		;(nil).lv = textLv
		summary = i18n("common_text_3993", nil)
	else
		_ENV = nil
		;(nil).lv = textLv
		summary = i18n("common_text_3991", nil)
	end
	return summary
end
_ENV = "Content_Lamp_Privilege_Gift"
;("Content_Lamp_Privilege_Gift").parseSummary = function(mail)
	local lv = mail.property.data.content.lv
	_ENV = nil
	;(nil).name = i18n("magic_lamp_name_01")
	;(nil).lv = lv
	return i18n("rechare_activename_2100", nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Lamp_Privilege_Gift], ("Content_Lamp_Privilege_Gift").parseDes = "Content_Lamp_Privilege_Gift", function(mail)
	local lv = mail.property.data.content.lv
	_ENV = nil
	;(nil).name = i18n("magic_lamp_name_01")
	;(nil).lv = lv
	return i18n("rechare_activename_2101", nil)
end
_ENV = "Content_Lamp_2_Privilege_Gift"
;("Content_Lamp_2_Privilege_Gift").parseSummary = function(mail)
	local lv = mail.property.data.content.lv
	_ENV = nil
	;(nil).name = i18n("magic_lamp_name_02")
	;(nil).lv = lv
	return i18n("rechare_activename_2100", nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Lamp_2_Privilege_Gift], ("Content_Lamp_2_Privilege_Gift").parseDes = "Content_Lamp_2_Privilege_Gift", function(mail)
	local lv = mail.property.data.content.lv
	_ENV = nil
	;(nil).name = i18n("magic_lamp_name_02")
	;(nil).lv = lv
	return i18n("rechare_activename_2101", nil)
end
_ENV = "Content_Pyramid_Battle_Strongest_Alliance_Born"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Pyramid_Battle_Strongest_Alliance_Born], ("Content_Pyramid_Battle_Strongest_Alliance_Born").parseDes = "Content_Pyramid_Battle_Strongest_Alliance_Born", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).kingdomName = content.kingdomName
		;(nil).abbr = content.abbr
		;(nil).allianceName = content.allianceName
		strTip = i18n(formatedStr, nil)
		if content.topAlliance and #content.topAlliance > 0 then
			for i = 1, #content.topAlliance do
				_ENV = nil
				;(nil).abbr = content.topAlliance[i].abbr
				;(nil).name = content.topAlliance[i].alliance
				local name = i18n("common_text_186", nil)
				name = name .. "#" .. content.topAlliance[i].kid
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
			end
			strTip = strTip .. [[


]]
			i18n("common_text_4052")
		end
	end
	return strTip
end
_ENV = "Content_WAR_END"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_WAR_END], ("Content_WAR_END").parseDes = "Content_WAR_END", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		if content.topAlliance and #content.topAlliance > 0 then
			_ENV = nil
			;(nil).num = #content.topAlliance
			strTip = i18n(formatedStr, nil)
			for i = 1, #content.topAlliance do
				_ENV = nil
				;(nil).abbr = content.topAlliance[i].abbr
				;(nil).name = content.topAlliance[i].alliance
				local name = i18n("common_text_186", nil)
				name = name .. "  " .. content.topAlliance[i].score
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
			end
		else
			_ENV = 1
			;(1).num = #content.topAlliance
			strTip = i18n(formatedStr, 1)
		end
	end
	return strTip
end
_ENV = "Content_KingDom_Battle_Report_Back"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_KingDom_Battle_Report_Back], ("Content_KingDom_Battle_Report_Back").parseDes = "Content_KingDom_Battle_Report_Back", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		if content.abbr then
			_ENV = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.nickname
			if i18n("common_text_186", nil) then
				goto lbl_23
			end
		end
		local showName = content.nickname
		::lbl_23::
		_ENV = content.nickname
		content.nickname.time = timeStr
		content.nickname.lord = showName
		strTip = i18n(formatedStr, content.nickname)
	end
	return strTip
end
_ENV = "Content_KingDom_Battle_Report_NoSpecial"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_KingDom_Battle_Report_NoSpecial], ("Content_KingDom_Battle_Report_NoSpecial").parseDes = "Content_KingDom_Battle_Report_NoSpecial", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		if content.abbr then
			_ENV = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.nickname
			if i18n("common_text_186", nil) then
				goto lbl_23
			end
		end
		local showName = content.nickname
		::lbl_23::
		if content.point then
			_ENV = content.nickname
			content.nickname.time = timeStr
			content.nickname.lord = showName
			content.nickname.point = content.point
			strTip = i18n(formatedStr, content.nickname)
		else
			_ENV = content.nickname
			content.nickname.time = timeStr
			content.nickname.lord = showName
			strTip = i18n("common_text_4185", content.nickname)
		end
	end
	return strTip
end
_ENV = "Content_KingDom_Battle_Report_IsWork"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_KingDom_Battle_Report_IsWork], ("Content_KingDom_Battle_Report_IsWork").parseDes = "Content_KingDom_Battle_Report_IsWork", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		if content.abbr then
			_ENV = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.nickname
			if i18n("common_text_186", nil) then
				goto lbl_23
			end
		end
		local showName = content.nickname
		::lbl_23::
		_ENV = content.nickname
		content.nickname.time = timeStr
		content.nickname.lord = showName
		content.nickname.point = content.point
		content.nickname.num = content.num
		content.nickname.turn = content.turn
		strTip = i18n(formatedStr, content.nickname)
	end
	return strTip
end
_ENV = "Content_KingDom_Battle_Report_IAmTraitor"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_KingDom_Battle_Report_IAmTraitor], ("Content_KingDom_Battle_Report_IAmTraitor").parseDes = "Content_KingDom_Battle_Report_IAmTraitor", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local timeStr = os.date("!%Y-%m-%d %H:%M:%S", content.time)
		if content.abbr then
			_ENV = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.nickname
			if i18n("common_text_186", nil) then
				goto lbl_23
			end
		end
		local showName = content.nickname
		::lbl_23::
		_ENV = content.nickname
		content.nickname.time = timeStr
		content.nickname.lord = showName
		content.nickname.num = content.num
		content.nickname.turn = content.turn
		strTip = i18n(formatedStr, content.nickname)
	end
	return strTip
end
_ENV = "Content_Legend_Equip_Will_Time_Up"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_Equip_Will_Time_Up], ("Content_Legend_Equip_Will_Time_Up").parseDes = "Content_Legend_Equip_Will_Time_Up", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local equipDesRead = include("equipDesRead")
		local tmpName = equipDesRead.getName(content.eid)
		local mailTime = mail.property.time
		local leftTime = SoraDConverSecondToDate(content.lefttime - mailTime > 0 and content.lefttime - mailTime or 0)
		_ENV = nil
		;(nil).eName = tmpName
		;(nil).time = leftTime
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Nebula_Equip_Will_Time_Up"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Equip_Will_Time_Up], ("Content_Nebula_Equip_Will_Time_Up").parseDes = "Content_Nebula_Equip_Will_Time_Up", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local equipDesRead = include("equipDesRead")
		local tmpName = equipDesRead.getName(content.eid)
		local mailTime = mail.property.time
		local leftTime = SoraDConverSecondToDate(content.lefttime - mailTime > 0 and content.lefttime - mailTime or 0)
		_ENV = nil
		;(nil).Name = tmpName
		;(nil).time = leftTime
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Legend_Equip_Time_Up"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_Equip_Time_Up], ("Content_Legend_Equip_Time_Up").parseDes = "Content_Legend_Equip_Time_Up", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local equipDesRead = include("equipDesRead")
		local tmpName = equipDesRead.getName(content.eid)
		_ENV = nil
		;(nil).eName = tmpName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Ornaments_Time_Up"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ornaments_Time_Up], ("Content_Ornaments_Time_Up").parseDes = "Content_Ornaments_Time_Up", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local equipDesRead = include("equipDesRead")
		local tmpName = equipDesRead.getName(content.eid)
		_ENV = nil
		;(nil).name = tmpName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_LegendKingWar_Begin"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendKingWar_Begin], ("Content_LegendKingWar_Begin").parseDes = "Content_LegendKingWar_Begin", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, rewards
		for j, reward in ipairs(content.reward) do
			rewards[j] = ""
			for i, v in ipairs(reward) do
				rewards[j] = rewards[j] .. "\t"
				_ENV = nil
				;(nil).name = publicRead.getName(v.id)
				;(nil).count = v.count
				rewards[j] = rewards[j] .. i18n("common_text_1460", nil)
				if i < #reward then
					rewards[j] = rewards[j] .. "\n"
				end
			end
		end
		_ENV = ipairs(content.reward)
		ipairs(content.reward).reward1 = rewards[1]
		ipairs(content.reward).reward2 = rewards[2]
		ipairs(content.reward).reward3 = rewards[3]
		strTip = i18n(formatedStr, ipairs(content.reward))
	end
	return strTip
end
_ENV = "Content_LegendKingWar_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendKingWar_End], ("Content_LegendKingWar_End").parseDes = "Content_LegendKingWar_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = ""
		if content.topThree and content.topThree[1] then
			local name = content.topThree[1].nickName or i18n("common_text_480")
			if content.topThree[1].abbr then
				_ENV = nil
				;(nil).abbr = content.topThree[1].abbr
				;(nil).name = name
				strName = i18n("common_text_186", nil)
			else
				strName = name
			end
			strName = strName .. "#" .. content.topThree[1].kid
		end
		_ENV = "#"
		;("#").name = strName
		strTip = i18n(formatedStr, "#")
		if content.topThree then
			for i = 1, #content.topThree do
				if content.topThree[i].abbr then
					_ENV = nil
					;(nil).abbr = content.topThree[i].abbr
					;(nil).name = content.topThree[i].nickName
				end
				local name = i18n("common_text_186", nil) or content.topThree[i].nickName or i18n("common_text_480")
				name = name .. "#" .. (content.topThree[i].kid or "nil")
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
				local timeStr = SoraDConvertSecondToString(content.topThree[i].time)
				strTip = strTip .. "    " .. timeStr
			end
		end
	end
	return strTip
end
_ENV = "Content_StarKing_Begin"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_Begin], ("Content_StarKing_Begin").parseDes = "Content_StarKing_Begin", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, rewards
		for j, reward in ipairs(content.reward) do
			rewards[j] = ""
			for i, v in ipairs(reward) do
				rewards[j] = rewards[j] .. "\t"
				_ENV = nil
				;(nil).name = publicRead.getName(v.id)
				;(nil).count = v.count
				rewards[j] = rewards[j] .. i18n("common_text_1460", nil)
				if i < #reward then
					rewards[j] = rewards[j] .. "\n"
				end
			end
		end
		_ENV = ipairs(content.reward)
		ipairs(content.reward).reward1 = rewards[1]
		ipairs(content.reward).reward2 = rewards[2]
		ipairs(content.reward).reward3 = rewards[3]
		strTip = i18n(formatedStr, ipairs(content.reward))
	end
	return strTip
end
_ENV = "Content_StarKing_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_End], ("Content_StarKing_End").parseDes = "Content_StarKing_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = ""
		if content.topThree and content.topThree[1] then
			local name = content.topThree[1].nickName or i18n("common_text_480")
			if content.topThree[1].abbr then
				_ENV = nil
				;(nil).abbr = content.topThree[1].abbr
				;(nil).name = name
				strName = i18n("common_text_186", nil)
			else
				strName = name
			end
			strName = strName .. "#" .. content.topThree[1].kid
		end
		_ENV = "#"
		;("#").name = strName
		strTip = i18n(formatedStr, "#")
		if content.topThree then
			for i = 1, #content.topThree do
				if content.topThree[i].abbr then
					_ENV = nil
					;(nil).abbr = content.topThree[i].abbr
					;(nil).name = content.topThree[i].nickName
				end
				local name = i18n("common_text_186", nil) or content.topThree[i].nickName or i18n("common_text_480")
				name = name .. "#" .. (content.topThree[i].kid or "nil")
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
				local timeStr = SoraDConvertSecondToString(content.topThree[i].time)
				strTip = strTip .. "    " .. timeStr
			end
		end
	end
	return strTip
end
_ENV = "Content_Callback_Invite_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Callback_Invite_Reward], ("Content_Callback_Invite_Reward").parseDes = "Content_Callback_Invite_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = mailFunctions:getWrappedName(content.userInfo.abbr, content.userInfo.nickName, content.userInfo.sourceKid or content.userInfo.kid)
		mailFunctions = content.userInfo.nickName
		content.userInfo.nickName.string = strName
		strTip = i18n(formatedStr, content.userInfo.nickName)
	end
	return strTip
end
_ENV = "Content_Callback_Task_Share_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Callback_Task_Share_Reward], ("Content_Callback_Task_Share_Reward").parseDes = "Content_Callback_Task_Share_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = mailFunctions:getWrappedName(content.userInfo.abbr, content.userInfo.nickName, content.userInfo.sourceKid or content.userInfo.kid)
		local num = string.formatnumberthousands(content.num)
		mailFunctions = content.userInfo.sourceKid or content.userInfo.kid
		;(content.userInfo.sourceKid or content.userInfo.kid).string = strName
		;(content.userInfo.sourceKid or content.userInfo.kid).num = num
		strTip = i18n(formatedStr, content.userInfo.sourceKid or content.userInfo.kid)
	end
	return strTip
end
_ENV = "Content_CrossMission_ExtraReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_CrossMission_ExtraReward], ("Content_CrossMission_ExtraReward").parseDes = "Content_CrossMission_ExtraReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.finishAll == false then
		strTip = i18n("decrypt_text_05")
	else
		strTip = i18n("mail_text_512")
	end
	return strTip
end
_ENV = "Content_Anniversary_Uncover_ExtraReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Anniversary_Uncover_ExtraReward], ("Content_Anniversary_Uncover_ExtraReward").parseDes = "Content_Anniversary_Uncover_ExtraReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.finishAll == false then
		strTip = i18n("anniversary_cross_text_07")
	else
		strTip = i18n("anniversary_cross_text_04")
	end
	return strTip
end
_ENV = "Content_Callback_Recharge_Share_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Callback_Recharge_Share_Reward], ("Content_Callback_Recharge_Share_Reward").parseDes = "Content_Callback_Recharge_Share_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		dump(content, "gMailNPCContentType.Content_Callback_Recharge_Share_Reward", 10)
		local strName = mailFunctions:getWrappedName(content.userInfo.abbr, content.userInfo.nickName, content.userInfo.sourceKid or content.userInfo.kid)
		local num = string.formatnumberthousands(content.num)
		_ENV = content.userInfo.sourceKid or content.userInfo.kid
		;(content.userInfo.sourceKid or content.userInfo.kid).string = strName
		;(content.userInfo.sourceKid or content.userInfo.kid).num = num
		strTip = i18n(formatedStr, content.userInfo.sourceKid or content.userInfo.kid)
	end
	return strTip
end
_ENV = "Content_LegendKingWar_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendKingWar_Rank], ("Content_LegendKingWar_Rank").parseDes = "Content_LegendKingWar_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_StarKing_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_Rank], ("Content_StarKing_Rank").parseDes = "Content_StarKing_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_LegendKingWar_Being_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendKingWar_Being_Appointed], ("Content_LegendKingWar_Being_Appointed").parseDes = "Content_LegendKingWar_Being_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local legendKingRead = include("legendKingRead")
	if formatedStr ~= nil then
		local strName = content.legendKingName or ""
		if content.legendKingAbbr ~= nil then
			_ENV = nil
			;(nil).abbr = content.legendKingAbbr
			;(nil).name = content.legendKingName
			strName = i18n("common_text_186", nil)
		end
		strName = strName .. "#" .. content.legendKingKid
		local officialId = content.officialId
		local official = legendKingRead.getOfficialName(gLegendBuffType.PLAYER, officialId)
		local bufDesTb = legendKingRead.getBuffDesTbById(gLegendBuffType.PLAYER, officialId)
		local officialType = legendKingRead.getOfficialType(gLegendBuffType.PLAYER, officialId)
		local privileges = table.concat(bufDesTb, "\n")
		if officialType == gLegendOfficialType.GOOD then
			_ENV = nil
			;(nil).name = strName
			;(nil).official = official
			;(nil).privileges = privileges
			strTip = i18n(formatedStr, nil)
		else
			_ENV = nil
			;(nil).name = strName
			;(nil).official = official
			;(nil).privileges = privileges
			strTip = i18n("mail_text_479", nil)
		end
	end
	return strTip
end
_ENV = "Content_StarKing_Being_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_Being_Appointed], ("Content_StarKing_Being_Appointed").parseDes = "Content_StarKing_Being_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local legendKingRead = include("legendKingRead")
	if formatedStr ~= nil then
		local strName = content.legendKingName or ""
		if content.legendKingAbbr ~= nil then
			_ENV = nil
			;(nil).abbr = content.legendKingAbbr
			;(nil).name = content.legendKingName
			strName = i18n("common_text_186", nil)
		end
		strName = strName .. "#" .. content.legendKingKid
		local officialId = content.officialId
		local mapid = worldMapDefine.getKingStarMapid(content.activityId)
		local official = legendKingRead.getOfficialName(gLegendBuffType.PLAYER, officialId, mapid)
		local bufDesTb = legendKingRead.getBuffDesTbById(gLegendBuffType.PLAYER, officialId, mapid)
		local officialType = legendKingRead.getOfficialType(gLegendBuffType.PLAYER, officialId, mapid)
		local privileges = table.concat(bufDesTb, "\n")
		if officialType == gLegendOfficialType.GOOD then
			_ENV = nil
			;(nil).name = strName
			;(nil).official = official
			;(nil).privileges = privileges
			strTip = i18n(formatedStr, nil)
		else
			_ENV = nil
			;(nil).name = strName
			;(nil).official = official
			;(nil).privileges = privileges
			strTip = i18n("kingstarbattle_mail_32", nil)
		end
	end
	return strTip
end
_ENV = "Content_LegendKingWar_Being_Dismissed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendKingWar_Being_Dismissed], ("Content_LegendKingWar_Being_Dismissed").parseDes = "Content_LegendKingWar_Being_Dismissed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local legendKingRead = include("legendKingRead")
	if formatedStr ~= nil then
		local strName = content.legendKingName or ""
		if content.legendKingAbbr ~= nil then
			_ENV = nil
			;(nil).abbr = content.legendKingAbbr
			;(nil).name = content.legendKingName
			strName = i18n("common_text_186", nil)
		end
		strName = strName .. "#" .. content.legendKingKid
		local officialId = content.officialId
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.PLAYER, officialId)
		local officialType = legendKingRead.getOfficialType(gLegendBuffType.PLAYER, officialId)
		if officialType == gLegendOfficialType.GOOD then
			_ENV = nil
			;(nil).name = strName
			;(nil).official = officialName
			strTip = i18n(formatedStr, nil)
		else
			_ENV = nil
			;(nil).name = strName
			;(nil).official = officialName
			strTip = i18n("mail_text_480", nil)
		end
	end
	return strTip
end
_ENV = "Content_StarKing_Being_Dismissed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_Being_Dismissed], ("Content_StarKing_Being_Dismissed").parseDes = "Content_StarKing_Being_Dismissed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local legendKingRead = include("legendKingRead")
	if formatedStr ~= nil then
		local strName = content.legendKingName or ""
		if content.legendKingAbbr ~= nil then
			_ENV = nil
			;(nil).abbr = content.legendKingAbbr
			;(nil).name = content.legendKingName
			strName = i18n("common_text_186", nil)
		end
		strName = strName .. "#" .. content.legendKingKid
		local officialId = content.officialId
		local mapid = worldMapDefine.getKingStarMapid(content.activityId)
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.PLAYER, officialId, mapid)
		local officialType = legendKingRead.getOfficialType(gLegendBuffType.PLAYER, officialId, mapid)
		if officialType == gLegendOfficialType.GOOD then
			_ENV = mapid
			mapid.name = strName
			mapid.official = officialName
			strTip = i18n(formatedStr, mapid)
		else
			_ENV = mapid
			mapid.name = strName
			mapid.official = officialName
			strTip = i18n("kingstarbattle_mail_11", mapid)
		end
	end
	return strTip
end
_ENV = "Content_Legend_King_Gift_Bag"
;("Content_Legend_King_Gift_Bag").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local strName = content.legendKingName or ""
	if content.abbr ~= nil then
		_ENV = nil
		;(nil).abbr = content.abbr
		;(nil).name = content.name
		strName = i18n("common_text_186", nil)
	end
	if content.kid then
		strName = strName .. "#" .. content.kid
	end
	if content.rank == 1 then
		_ENV = content.kid
		content.kid.name = strName
		strName = i18n("legendaryking_text_07", content.kid)
	end
	local id = content.gift
	local giftName = mailDesParser.getLegendKingGiftName(id)
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = strName
		;(nil).gift = giftName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_King_Gift_Bag], ("Content_Legend_King_Gift_Bag").parseSummary = "Content_Legend_King_Gift_Bag", function(mail)
	local id = mail.property.data.content.gift
	local summary = mailDesParser.getLegendKingGiftName(id)
	return summary
end
_ENV = "Content_StarKing_King_Gift_Bag"
;("Content_StarKing_King_Gift_Bag").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local strName = content.name or ""
	if content.abbr ~= nil then
		_ENV = nil
		;(nil).abbr = content.abbr
		;(nil).name = content.name
		strName = i18n("common_text_186", nil)
	end
	if content.kid then
		strName = strName .. "#" .. content.kid
	end
	if content.rank == 1 then
		_ENV = content.kid
		content.kid.name = strName
		strName = i18n("kingstarbattle_text_79", content.kid)
	end
	local id = content.gift
	local mapid = worldMapDefine.getKingStarMapid(content.activityId)
	local giftName = mailDesParser.getLegendKingGiftName(id, mapid)
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = strName
		;(nil).gift = giftName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_King_Gift_Bag], ("Content_StarKing_King_Gift_Bag").parseSummary = "Content_StarKing_King_Gift_Bag", function(mail)
	local content = mail.property.data.content
	local id = content.gift
	local mapid = worldMapDefine.getKingStarMapid(content.activityId)
	local summary = mailDesParser.getLegendKingGiftName(id, mapid)
	return summary
end
_ENV = "Content_LegendKingWar_Kingdom_Being_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendKingWar_Kingdom_Being_Appointed], ("Content_LegendKingWar_Kingdom_Being_Appointed").parseDes = "Content_LegendKingWar_Kingdom_Being_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local legendKingRead = include("legendKingRead")
	if formatedStr ~= nil then
		local strName = ""
		local officialId = content.officialId
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.KINGDOM, officialId)
		local bufDesTb = legendKingRead.getBuffDesTbById(gLegendBuffType.KINGDOM, officialId)
		local privileges = table.concat(bufDesTb, "\n")
		_ENV = nil
		;(nil).name = strName
		;(nil).official = officialName
		;(nil).privilege = privileges
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_StarKing_Kingdom_Being_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_Kingdom_Being_Appointed], ("Content_StarKing_Kingdom_Being_Appointed").parseDes = "Content_StarKing_Kingdom_Being_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local legendKingRead = include("legendKingRead")
	if formatedStr ~= nil then
		local strName = ""
		local officialId = content.officialId
		local mapid = worldMapDefine.getKingStarMapid(content.activityId)
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.KINGDOM, officialId, mapid)
		local bufDesTb = legendKingRead.getBuffDesTbById(gLegendBuffType.KINGDOM, officialId, mapid)
		local privileges = table.concat(bufDesTb, "\n")
		_ENV = nil
		;(nil).name = strName
		;(nil).official = officialName
		;(nil).privilege = privileges
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Arena_Global_Rank"
;("Content_Arena_Global_Rank").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	local rankList = content.rankData
	local groupID = content.group
	for i, v in ipairs(rankList) do
		local arenaltCtrl = include("arenaltCtrl")
		local showName = arenaltCtrl.specialCreateName(v, true)
		_ENV = nil
		;(nil).lv = v.rank
		;(nil).name = showName
		strTip = strTip .. i18n(formatedStr, nil) .. "\n"
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Arena_Global_Rank], ("Content_Arena_Global_Rank").parseSummary = "Content_Arena_Global_Rank", function(mail)
	local mailInfo = mailDesParser.getMailDesInfo(mail)
	local formatedStr = mailInfo.summary
	local contentData = mailDesParser.getMailContentData(mail)
	local mailsummary
	if formatedStr ~= "" then
		local arenaltCtrl = include("arenaltCtrl")
		local titleHead = formatedStr
		local index = arenaltCtrl.getSubSectionIndex(gArenaBattleType.AREAN_GLOBAL, contentData.content.group)
		local groupInfo = arenaltCtrl.getSubSectionList(index)
		local name = groupInfo.name or ""
		mailDesParser = nil
		;(nil).title = i18n(titleHead)
		;(nil).des = i18n(name)
		mailsummary = i18n("common_text_2482", nil)
	end
	return mailsummary
end
_ENV = "Content_Arena_Local_Change_Group"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Arena_Local_Change_Group], ("Content_Arena_Local_Change_Group").parseDes = "Content_Arena_Local_Change_Group", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = ARENA_GROUPCHANGE_LOCAL_COUNTS
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Arena_Global_Change_Group"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Arena_Global_Change_Group], ("Content_Arena_Global_Change_Group").parseDes = "Content_Arena_Global_Change_Group", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = ARENA_GROUPCHANGE_GLOBAL_COUNTS
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Donate_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Donate_Rank_Reward], ("Content_Donate_Rank_Reward").parseDes = "Content_Donate_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Donate_Rank_List"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Donate_Rank_List], ("Content_Donate_Rank_List").parseDes = "Content_Donate_Rank_List", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local rankStr = ""
	if content.topInfo then
		for i, v in ipairs(content.topInfo) do
			if v.abbr and v.abbr ~= "" then
				_ENV = nil
				;(nil).abbr = v.abbr
				;(nil).name = v.nickName
				if i18n("common_text_186", nil) then
					goto lbl_27
				end
			end
			local showName = v.nickName
			::lbl_27::
			_ENV = nil
			;(nil).lv = v.rank
			;(nil).name = showName
			rankStr = rankStr .. i18n("common_text_1763", nil) .. "\n"
		end
	end
	strTip = i18n(formatedStr) .. "\n" .. rankStr
	return strTip
end
_ENV = "Content_Inviter_Castle_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Inviter_Castle_Reward], ("Content_Inviter_Castle_Reward").parseDes = "Content_Inviter_Castle_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).lordName = content.lordName
	;(nil).lv = content.lv
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_World_Cup_Cheer_Win"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_World_Cup_Cheer_Win], ("Content_World_Cup_Cheer_Win").parseDes = "Content_World_Cup_Cheer_Win", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.cheerCount
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_World_Cup_Cheer_Tie"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_World_Cup_Cheer_Tie], ("Content_World_Cup_Cheer_Tie").parseDes = "Content_World_Cup_Cheer_Tie", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.cheerCount
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_World_Cup_Cheer_Lose"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_World_Cup_Cheer_Lose], ("Content_World_Cup_Cheer_Lose").parseDes = "Content_World_Cup_Cheer_Lose", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.cheerCount
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_World_Cup_Cheer_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_World_Cup_Cheer_Rank_Reward], ("Content_World_Cup_Cheer_Rank_Reward").parseDes = "Content_World_Cup_Cheer_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.score
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Alliance_Official_Appoint"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Official_Appoint], ("Content_Alliance_Official_Appoint").parseDes = "Content_Alliance_Official_Appoint", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local officialName = allianceDesRead.getOfficialName(content.official)
	allianceDesRead = nil
	;(nil).office = officialName
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Alliance_Official_Fire"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Official_Fire], ("Content_Alliance_Official_Fire").parseDes = "Content_Alliance_Official_Fire", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local officialName = allianceDesRead.getOfficialName(content.official)
	allianceDesRead = nil
	;(nil).office = officialName
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_LegendHegemonWar_Begin"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendHegemonWar_Begin], ("Content_LegendHegemonWar_Begin").parseDes = "Content_LegendHegemonWar_Begin", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, rewards
		for j, reward in ipairs(content.reward) do
			rewards[j] = ""
			for i, v in ipairs(reward) do
				rewards[j] = rewards[j] .. "\t"
				_ENV = nil
				;(nil).name = publicRead.getName(v.id)
				;(nil).count = v.count
				rewards[j] = rewards[j] .. i18n("common_text_1460", nil)
				if i < #reward then
					rewards[j] = rewards[j] .. "\n"
				end
			end
		end
		_ENV = ipairs(content.reward)
		ipairs(content.reward).reward1 = rewards[1]
		ipairs(content.reward).reward2 = rewards[2]
		ipairs(content.reward).reward3 = rewards[3]
		strTip = i18n(formatedStr, ipairs(content.reward))
	end
	return strTip
end
_ENV = "Content_LegendHegemonWar_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendHegemonWar_End], ("Content_LegendHegemonWar_End").parseDes = "Content_LegendHegemonWar_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = ""
		if content.topThree and content.topThree[1] then
			if content.topThree[1].abbr then
				_ENV = nil
				;(nil).abbr = content.topThree[1].abbr
				;(nil).name = content.topThree[1].nickName
				strName = i18n("common_text_186", nil)
			else
				strName = content.topThree[1].nickName
			end
			strName = strName .. "#" .. content.topThree[1].kid
		end
		local bid = content.bid
		local hegemonRead = include("hegemonRead")
		local build = hegemonRead.getName(bid)
		_ENV = nil
		;(nil).name = strName
		;(nil).build = build
		strTip = i18n(formatedStr, nil)
		if content.topThree then
			for i = 1, #content.topThree do
				if content.topThree[i].abbr then
					_ENV = nil
					;(nil).abbr = content.topThree[i].abbr
					;(nil).name = content.topThree[i].nickName
					if i18n("common_text_186", nil) then
						goto lbl_84
					end
				end
				local name = content.topThree[i].nickName
				::lbl_84::
				name = name .. "#" .. (content.topThree[i].kid or "nil")
				_ENV = nil
				;(nil).lv = i
				;(nil).name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", nil)
				strTip = strTip .. itemRankTip
				local timeStr = SoraDConvertSecondToString(content.topThree[i].time)
				strTip = strTip .. "    " .. timeStr
			end
		end
	end
	return strTip
end
_ENV = "Content_LegendHegemonWar_HegemonReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendHegemonWar_HegemonReward], ("Content_LegendHegemonWar_HegemonReward").parseDes = "Content_LegendHegemonWar_HegemonReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local hegemonRead = include("hegemonRead")
		local bid = content.bid
		local build = hegemonRead.getName(bid)
		_ENV = nil
		;(nil).build = build
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_LegendHegemonWar_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendHegemonWar_Rank], ("Content_LegendHegemonWar_Rank").parseDes = "Content_LegendHegemonWar_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.rank
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_LegendHegemonWar_Being_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendHegemonWar_Being_Appointed], ("Content_LegendHegemonWar_Being_Appointed").parseDes = "Content_LegendHegemonWar_Being_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local hegemonRead = include("hegemonRead")
	if formatedStr ~= nil then
		local strName = content.name or ""
		if content.abbr ~= nil then
			_ENV = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.name
			strName = i18n("common_text_186", nil)
		end
		strName = strName .. "#" .. content.kid
		local officialId = content.officialId
		local official = hegemonRead.getOfficialName(officialId)
		local bufDesTb = hegemonRead.getBuffDesTbById(officialId)
		local officialType = hegemonRead.getOfficialType(officialId)
		local privileges = table.concat(bufDesTb, "\n")
		local bid = content.bid
		local build = hegemonRead.getName(bid)
		if officialType == gLegendOfficialType.GOOD then
			_ENV = nil
			;(nil).build = build
			;(nil).name = strName
			;(nil).official = official
			;(nil).privileges = privileges
			strTip = i18n(formatedStr, nil)
		else
			_ENV = nil
			;(nil).build = build
			;(nil).name = strName
			;(nil).official = official
			;(nil).privileges = privileges
			strTip = i18n("mail_text_479", nil)
		end
	end
	return strTip
end
_ENV = "Content_LegendHegemonWar_Being_Dismissed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_LegendHegemonWar_Being_Dismissed], ("Content_LegendHegemonWar_Being_Dismissed").parseDes = "Content_LegendHegemonWar_Being_Dismissed", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local hegemonRead = include("hegemonRead")
	if formatedStr ~= nil then
		local strName = content.name or ""
		if content.abbr ~= nil then
			_ENV = nil
			;(nil).abbr = content.abbr
			;(nil).name = content.name
			strName = i18n("common_text_186", nil)
		end
		strName = strName .. "#" .. content.kid
		local officialId = content.officialId
		local officialName = hegemonRead.getOfficialName(officialId)
		local officialType = hegemonRead.getOfficialType(officialId)
		local bid = content.bid
		local build = hegemonRead.getName(bid)
		if officialType == gLegendOfficialType.GOOD then
			_ENV = nil
			;(nil).build = build
			;(nil).name = strName
			;(nil).official = officialName
			strTip = i18n(formatedStr, nil)
		else
			_ENV = nil
			;(nil).name = strName
			;(nil).official = officialName
			strTip = i18n("mail_text_480", nil)
		end
	end
	return strTip
end
_ENV = "Content_Legend_Hegemon_Gift_Bag"
;("Content_Legend_Hegemon_Gift_Bag").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local strName = content.name or ""
	if content.abbr ~= nil then
		_ENV = nil
		;(nil).abbr = content.abbr
		;(nil).name = content.name
		strName = i18n("common_text_186", nil)
	end
	if content.kid then
		strName = strName .. "#" .. content.kid
	end
	if content.rank == 1 then
		_ENV = content.kid
		content.kid.name = strName
		strName = i18n("hegemon_title_18", content.kid)
	end
	local id = content.gift
	local giftName = mailDesParser.getHegemonGiftName(id)
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).name = strName
		;(nil).gift = giftName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_Hegemon_Gift_Bag], ("Content_Legend_Hegemon_Gift_Bag").parseSummary = "Content_Legend_Hegemon_Gift_Bag", function(mail)
	local id = mail.property.data.content.gift
	local summary = mailDesParser.getHegemonGiftName(id)
	return summary
end
_ENV = "Content_HeroSys_Release_Hero"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Release_Hero], ("Content_HeroSys_Release_Hero").parseDes = "Content_HeroSys_Release_Hero", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = content.heroID
		local heroInfo = heroltCtrl.getHeroInfo(heroID)
		local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
		local strName = mailFunctions:getWrappedName(content.abbr, content.name, content.sourceKid or content.kid)
		_ENV = content.name
		content.name.hero = heroName
		content.name.name = strName
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_HeroSys_Becapture_Hero"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Becapture_Hero], ("Content_HeroSys_Becapture_Hero").parseDes = "Content_HeroSys_Becapture_Hero", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Release_Hero].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_HeroSys_Execute_Hero"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Execute_Hero], ("Content_HeroSys_Execute_Hero").parseDes = "Content_HeroSys_Execute_Hero", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Release_Hero].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_HeroSys_Prison_Break"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Prison_Break], ("Content_HeroSys_Prison_Break").parseDes = "Content_HeroSys_Prison_Break", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Release_Hero].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_HeroSys_GetRansomAward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_GetRansomAward], ("Content_HeroSys_GetRansomAward").parseDes = "Content_HeroSys_GetRansomAward", function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Release_Hero].parseDes(mail, mailDesInfo, content, formatedStr)
end
_ENV = "Content_HeroSys_Hero_Escape"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Hero_Escape], ("Content_HeroSys_Hero_Escape").parseDes = "Content_HeroSys_Hero_Escape", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = content.heroID
		local heroInfo = heroltCtrl.getHeroInfo(heroID)
		local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
		local strName = mailFunctions:getWrappedName(content.abbr, content.name, content.sourceKid or content.kid)
		_ENV = content.name
		content.name.heroName = heroName
		content.name.lord = strName
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_HeroSys_Use_Peace"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Use_Peace], ("Content_HeroSys_Use_Peace").parseDes = "Content_HeroSys_Use_Peace", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local list = ""
		for i, v in ipairs(content.heroList) do
			local heroInfo = heroltCtrl.getHeroInfo(v.heroID)
			local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
			local strName = mailFunctions:getWrappedName(v.abbr, v.name, v.sourceKid)
			list = list .. heroName .. strName .. "\n"
		end
		_ENV = ipairs(content.heroList)
		ipairs(content.heroList).list = list
		strTip = i18n(formatedStr, ipairs(content.heroList))
	end
	return strTip
end
_ENV = "Content_Nebula_Defence_Build_Rewards"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Defence_Build_Rewards], ("Content_Nebula_Defence_Build_Rewards").parseDes = "Content_Nebula_Defence_Build_Rewards", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local activity_9001573_Read = include("activity_9001573_Read")
		local cfg = activity_9001573_Read.getBuild(content.buildInfo.buildID)
		local buildName = ""
		if cfg.buildType == gWorldTypeServerDef.subTypeNebulaDefenceWarTower then
			buildName = i18n("Celestial_defense_text_080")
		else
			buildName = i18n(cfg.buildName)
		end
		_ENV = nil
		;(nil).build = buildName
		;(nil).x = content.buildInfo.x
		;(nil).y = content.buildInfo.y
		;(nil).num = content.num
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Nebula_Defence_Rank_Rewards"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Defence_Rank_Rewards], ("Content_Nebula_Defence_Rank_Rewards").parseDes = "Content_Nebula_Defence_Rank_Rewards", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).rank = content.num
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Nebula_Defence_Kill_Rewards"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Defence_Kill_Rewards], ("Content_Nebula_Defence_Kill_Rewards").parseDes = "Content_Nebula_Defence_Kill_Rewards", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local activity_9001573_Read = include("activity_9001573_Read")
		local buildName = activity_9001573_Read.getBuildName(content.buildID)
		_ENV = nil
		;(nil).build = buildName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_HeroSys_Ransom_Hero"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Ransom_Hero], ("Content_HeroSys_Ransom_Hero").parseDes = "Content_HeroSys_Ransom_Hero", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = content.heroID
		local heroInfo = heroltCtrl.getHeroInfo(heroID)
		local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
		local resTb = content.res
		local itemName = publicRead.getName(resTb.id)
		local resStr = itemName .. "X" .. string.formatnumberthousands(resTb.count)
		_ENV = resTb.count
		resTb.count.hero = heroName
		resTb.count.res = resStr
		strTip = i18n(formatedStr, resTb.count)
	end
	return strTip
end
_ENV = "Content_HeroSys_Update_Wanted_Gold"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Update_Wanted_Gold], ("Content_HeroSys_Update_Wanted_Gold").parseDes = "Content_HeroSys_Update_Wanted_Gold", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = mailFunctions:getWrappedName(content.abbr, content.name, content.kid)
		mailFunctions = content.name
		content.name.name = strName
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_HeroSys_Upgrade_Hero"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Upgrade_Hero], ("Content_HeroSys_Upgrade_Hero").parseDes = "Content_HeroSys_Upgrade_Hero", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = content.heroID
		local heroInfo = heroltCtrl.getHeroInfo(heroID)
		local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
		local color = heroltCtrl.getHeroQuality2Word(content.quality)
		_ENV = nil
		;(nil).hero = heroName
		;(nil).color = color
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_HeroSys_Awake_Hero"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_Awake_Hero], ("Content_HeroSys_Awake_Hero").parseDes = "Content_HeroSys_Awake_Hero", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = content.heroID
		local heroInfo = heroltCtrl.getHeroInfo(heroID)
		local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
		local color = heroltCtrl.getHeroQuality2Word(content.quality)
		_ENV = nil
		;(nil).name = heroName
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_HeroSys_GetWantedAward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_GetWantedAward], ("Content_HeroSys_GetWantedAward").parseDes = "Content_HeroSys_GetWantedAward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strName = mailFunctions:getWrappedName(content.abbr, content.name, content.sourceKid)
		mailFunctions = content.name
		content.name.name = strName
		strTip = i18n(formatedStr, content.name)
	end
	return strTip
end
_ENV = "Content_HeroSys_WantedReward_Return"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_HeroSys_WantedReward_Return], ("Content_HeroSys_WantedReward_Return").parseDes = "Content_HeroSys_WantedReward_Return", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local strKey = formatedStr
		local reason = content.reason
		if reason == gHeroStateChangeReason.CHANGE_RELEASE then
			strKey = "mail_text_502"
		elseif reason == gHeroStateChangeReason.CHANGE_KILL then
			strKey = "mail_text_503"
		elseif reason == gHeroStateChangeReason.CHANGE_PRISON_BREAK then
			strKey = "mail_text_504"
		end
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local heroID = content.heroID
		local heroInfo = heroltCtrl.getHeroInfo(heroID)
		local heroName = heroInfo and i18n(heroInfo.herName) or "NA"
		_ENV = nil
		;(nil).hero = heroName
		strTip = i18n(strKey, nil)
	end
	return strTip
end
_ENV = "Content_ABeast_AttackSuccess"
;("Content_ABeast_AttackSuccess").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local petType = content.beastType
	local petName = alliancePetRead.getName(petType)
	alliancePetRead = nil
	;(nil).petname = petName
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ABeast_AttackSuccess], ("Content_ABeast_AttackSuccess").parseSummary = "Content_ABeast_AttackSuccess", function(mail)
	local content = mail.property.data.content
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	if mailDesInfo then
		local formatedStr = mailDesInfo.summary
		if formatedStr ~= "" then
			mailDesParser = nil
			;(nil).Lvl = content.beastLv
			;(nil).petname = alliancePetRead.getName(content.beastType)
			local summary = i18n(formatedStr, nil)
			return summary
		end
	end
end
_ENV = "Content_ABeast_AttackFailure"
;("Content_ABeast_AttackFailure").parseDes = function(mail, mailDesInfo, content, formatedStr)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_ABeast_AttackSuccess].parseDes(mail, mailDesInfo, content, formatedStr)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ABeast_AttackFailure], ("Content_ABeast_AttackFailure").parseSummary = "Content_ABeast_AttackFailure", function(mail)
	return mailDesParser.npcFuncMap[gMailNPCContentType.Content_ABeast_AttackSuccess].parseSummary(mail)
end
_ENV = "Content_ABeast_KillReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ABeast_KillReward], ("Content_ABeast_KillReward").parseDes = "Content_ABeast_KillReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local petType = content.beastType
	local petName = alliancePetRead.getName(petType)
	alliancePetRead = nil
	;(nil).Lvl = content.beastLv
	;(nil).petname = petName
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Daily_Discount_Reward"
;("Content_Daily_Discount_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local id = content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	if formatedStr and formatedStr ~= "" then
		mailDesParser = nil
		;(nil).gift = name
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Daily_Discount_Reward], ("Content_Daily_Discount_Reward").parseSummary = "Content_Daily_Discount_Reward", function(mail)
	local id = mail.property.data.content.id
	local name = mailDesParser.getRechargeGiftName(mail, id)
	return name
end
_ENV = "Content_Reamins_War_Suc"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reamins_War_Suc], ("Content_Reamins_War_Suc").parseDes = "Content_Reamins_War_Suc", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local RW_WIN_REASON = _G.RW_WIN_REASON
	local resultType = content.type
	if resultType == RW_WIN_REASON.POINTS_DIFF then
		formatedStr = "remains_text_162"
	elseif resultType == RW_WIN_REASON.TEAM_ALL_QUIT then
		formatedStr = "remains_text_163"
	else
		formatedStr = "remains_text_113"
	end
	local remainsWarltCtrl = include("remainsWarltCtrl")
	local remainsWarRead = include("remainsWarRead")
	local score = remainsWarltCtrl.getRuinsWarGrade(content.point)
	local strScore = remainsWarRead.getScoreName(score)
	local args = clone(content)
	args.point = strScore
	args.selfPoint = string.formatnumberthousands(content.selfPoint)
	args.otherPoint = string.formatnumberthousands(content.otherPoint)
	strTip = i18n(formatedStr, args)
	return strTip
end
_ENV = "Content_Reamins_Team_Leader"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reamins_Team_Leader], ("Content_Reamins_Team_Leader").parseDes = "Content_Reamins_Team_Leader", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.teamName then
		formatedStr = "remains_text_111"
		strTip = i18n(formatedStr)
	else
		formatedStr = "remains_text_307"
		local name = content.nickname
		local allianceAbbr = content.allianceAbbr
		if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
			_ENV = nil
			;(nil).abbr = allianceAbbr
			;(nil).name = content.nickname
			name = i18n("common_text_186", nil)
		end
		if content.kid then
			name = name .. "#" .. tostring(content.kid)
		end
		_ENV = tostring(content.kid)
		tostring(content.kid).name = name
		strTip = i18n(formatedStr, (tostring(content.kid)))
	end
	return strTip
end
_ENV = "Content_Legend_Lord_Team_Leader"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_Lord_Team_Leader], ("Content_Legend_Lord_Team_Leader").parseDes = "Content_Legend_Lord_Team_Leader", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local name = content.nickname
	local allianceAbbr = content.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = content.nickname
		name = i18n("common_text_186", nil)
	end
	if content.kid then
		name = name .. "#" .. tostring(content.kid)
	end
	_ENV = tostring(content.kid)
	tostring(content.kid).name = name
	strTip = i18n(formatedStr, (tostring(content.kid)))
	return strTip
end
_ENV = "Content_StarKing_Team_Leader"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_StarKing_Team_Leader], ("Content_StarKing_Team_Leader").parseDes = "Content_StarKing_Team_Leader", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local name = content.nickname
	local allianceAbbr = content.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = content.nickname
		name = i18n("common_text_186", nil)
	end
	if content.kid then
		name = name .. "#" .. tostring(content.kid)
	end
	_ENV = tostring(content.kid)
	tostring(content.kid).name = name
	strTip = i18n(formatedStr, (tostring(content.kid)))
	return strTip
end
_ENV = "Content_Legend_Hegemon_Team_Leader"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_Hegemon_Team_Leader], ("Content_Legend_Hegemon_Team_Leader").parseDes = "Content_Legend_Hegemon_Team_Leader", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local name = content.nickname
	local allianceAbbr = content.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = content.nickname
		name = i18n("common_text_186", nil)
	end
	if content.kid then
		name = name .. "#" .. tostring(content.kid)
	end
	_ENV = tostring(content.kid)
	tostring(content.kid).name = name
	strTip = i18n(formatedStr, (tostring(content.kid)))
	return strTip
end
_ENV = "Content_Reamins_War_Fail"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reamins_War_Fail], ("Content_Reamins_War_Fail").parseDes = "Content_Reamins_War_Fail", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local RW_WIN_REASON = _G.RW_WIN_REASON
	local resultType = content.type
	if resultType == RW_WIN_REASON.POINTS_DIFF then
		formatedStr = "remains_text_164"
	elseif resultType == RW_WIN_REASON.TEAM_ALL_QUIT then
		formatedStr = "remains_text_165"
	else
		formatedStr = "remains_text_114"
	end
	local remainsWarltCtrl = include("remainsWarltCtrl")
	local remainsWarRead = include("remainsWarRead")
	local score = remainsWarltCtrl.getRuinsWarGrade(content.point)
	local strScore = remainsWarRead.getScoreName(score)
	local args = clone(content)
	args.point = strScore
	args.selfPoint = string.formatnumberthousands(content.selfPoint)
	args.otherPoint = string.formatnumberthousands(content.otherPoint)
	strTip = i18n(formatedStr, args)
	return strTip
end
_ENV = "Content_Devil_Valley_Win"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Devil_Valley_Win], ("Content_Devil_Valley_Win").parseDes = "Content_Devil_Valley_Win", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local newTrialRead = include("newTrialRead")
	_ENV = nil
	;(nil).name = newTrialRead.getName(content.challengeLv)
	;(nil).point = content.point
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Devil_Valley_Lose"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Devil_Valley_Lose], ("Content_Devil_Valley_Lose").parseDes = "Content_Devil_Valley_Lose", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local newTrialRead = include("newTrialRead")
	_ENV = nil
	;(nil).name = newTrialRead.getName(content.challengeLv)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Devil_Valley_Win_Not_Point"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Devil_Valley_Win_Not_Point], ("Content_Devil_Valley_Win_Not_Point").parseDes = "Content_Devil_Valley_Win_Not_Point", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local newTrialRead = include("newTrialRead")
	_ENV = nil
	;(nil).name = newTrialRead.getName(content.challengeLv)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Devil_Not_Receive_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Devil_Not_Receive_Reward], ("Content_Devil_Not_Receive_Reward").parseDes = "Content_Devil_Not_Receive_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local newTrialRead = include("newTrialRead")
	_ENV = nil
	;(nil).name = newTrialRead.getName(content.challengeLv)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Knights_Charge_PersonalRankReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Knights_Charge_PersonalRankReward], ("Content_Knights_Charge_PersonalRankReward").parseDes = "Content_Knights_Charge_PersonalRankReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Knights_Charge_AllianceRankReward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Knights_Charge_AllianceRankReward], ("Content_Knights_Charge_AllianceRankReward").parseDes = "Content_Knights_Charge_AllianceRankReward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).abbr = content.abbr
	;(nil).name = content.aName
	local allianceName = i18n("common_text_186", nil)
	_ENV = content.aName
	content.aName.num = content.rank
	content.aName.name = allianceName
	strTip = i18n(formatedStr, content.aName)
	return strTip
end
_ENV = "Content_Reamins_War_Season_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reamins_War_Season_End], ("Content_Reamins_War_Season_End").parseDes = "Content_Reamins_War_Season_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.rank
	strTip = i18n("mail_text_526", nil)
	return strTip
end
_ENV = "Content_Parliament_Decree_Find_City"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Parliament_Decree_Find_City], ("Content_Parliament_Decree_Find_City").parseDes = "Content_Parliament_Decree_Find_City", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local posStr = string.format("(x:%d y:%d)", content.x or 0, content.y or 0)
	_ENV = content.y or 0
	;(content.y or 0).name = content.name
	;(content.y or 0).position = _pq(posStr)
	strTip = i18n(formatedStr, content.y or 0)
	return strTip
end
_ENV = "Content_Parliament_Trick_Fail"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Parliament_Trick_Fail], ("Content_Parliament_Trick_Fail").parseDes = "Content_Parliament_Trick_Fail", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local buffDesRead = include("buffDesRead")
	local effectValue = buffDesRead.getTitleWithValue(content.effectType, content.effectValue or 0)
	_ENV = nil
	;(nil).des = effectValue
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Autokillmonster_Stop"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Autokillmonster_Stop], ("Content_Autokillmonster_Stop").parseDes = "Content_Autokillmonster_Stop", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_UPVALUE5_ = nil
	;(nil)[1] = "mail_text_14"
	;(nil)[2] = "automatic_text_29"
	;(nil)[3] = "common_text_988"
	;(nil)[4] = "automatic_text_28"
	local (nil)[5], desTable = "automatic_text_36", nil
	local des
	if content.stopReason and desTable[content.stopReason] then
		des = i18n(desTable[content.stopReason])
	else
		des = ""
	end
	_ENV = "automatic_text_28"
	;("automatic_text_28").des = des
	strTip = i18n(formatedStr, "automatic_text_28")
	return strTip
end
_ENV = "Content_PyramidWar_Legion_Join"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_PyramidWar_Legion_Join], ("Content_PyramidWar_Legion_Join").parseDes = "Content_PyramidWar_Legion_Join", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).userName = content.userName
	;(nil).legionName = content.legionName
	strTip = i18n("mail_pyramid_02", nil)
	return strTip
end
_ENV = "Content_PyramidWar_Legion_Remove"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_PyramidWar_Legion_Remove], ("Content_PyramidWar_Legion_Remove").parseDes = "Content_PyramidWar_Legion_Remove", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).userName = content.userName
	;(nil).legionName = content.legionName
	strTip = i18n("mail_pyramid_04", nil)
	return strTip
end
_ENV = "Content_Reamins_War_Season_Title_List"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reamins_War_Season_Title_List], ("Content_Reamins_War_Season_Title_List").parseDes = "Content_Reamins_War_Season_Title_List", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.season or 1
	local strTitle = i18n("remains_text_02", nil)
	_ENV = content.season or 1
	;(content.season or 1).name = strTitle
	strTip = i18n("mail_text_528", content.season or 1)
	if content.playerInfo and #content.playerInfo > 0 then
		for _, v in ipairs(content.playerInfo) do
			local name = v.nickName
			local allianceAbbr = v.abbr
			if allianceAbbr ~= nil and 0 < string.len(allianceAbbr) then
				_ENV = nil
				;(nil).abbr = allianceAbbr
				;(nil).name = v.nickName
				name = i18n("common_text_186", nil)
			end
			if v.kid then
				name = name .. "#" .. tostring(v.kid)
			end
			local itemRankTip = "\n" .. name
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Reamins_War_Title_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Reamins_War_Title_Rank], ("Content_Reamins_War_Title_Rank").parseDes = "Content_Reamins_War_Title_Rank", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local remainsWarRead = include("remainsWarRead")
	local title = remainsWarRead.getRuinsTitleName(content.title)
	_ENV = nil
	;(nil).num = content.season
	;(nil).title = title
	;(nil).rank = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Cost_gold_For_Gift"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Cost_gold_For_Gift], ("Content_Cost_gold_For_Gift").parseDes = "Content_Cost_gold_For_Gift", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).Num = content.id
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_New_King_Fund_Invest"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_King_Fund_Invest], ("Content_New_King_Fund_Invest").parseDes = "Content_New_King_Fund_Invest", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).Gold = content.gold
	;(nil).Day = content.day
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_New_King_Fund_Return"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_King_Fund_Return], ("Content_New_King_Fund_Return").parseDes = "Content_New_King_Fund_Return", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local rate = content.rate or 0
	_ENV = nil
	;(nil).Gold = content.gold
	;(nil).Day = content.day
	;(nil).Rate = string.format("%s%%", rate / 10)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Party_Open_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Party_Open_Reward], ("Content_Party_Open_Reward").parseDes = "Content_Party_Open_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local partyltCtrl = include("partyltCtrl")
	local partyName = partyltCtrl.getPartyNameByLv(content.partyLv)
	_ENV = nil
	;(nil).num = content.attendCount
	;(nil).feast = partyName
	;(nil).point = content.score
	strTip = i18n("mail_feast_text_01", nil)
	return strTip
end
_ENV = "Content_Party_Attend_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Party_Attend_Reward], ("Content_Party_Attend_Reward").parseDes = "Content_Party_Attend_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local partyltCtrl = include("partyltCtrl")
	local partyName = partyltCtrl.getPartyNameByLv(content.partyLv)
	_ENV = nil
	;(nil).name = content.partyHostName
	;(nil).feast = partyName
	;(nil).point = content.score
	strTip = i18n("mail_feast_text_03", nil)
	return strTip
end
_ENV = "Content_Party_Attend_Extra_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Party_Attend_Extra_Reward], ("Content_Party_Attend_Extra_Reward").parseDes = "Content_Party_Attend_Extra_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local partyltCtrl = include("partyltCtrl")
	local partyName = partyltCtrl.getPartyNameByLv(content.partyLv)
	_ENV = nil
	;(nil).name = content.partyHostName
	;(nil).feast = partyName
	;(nil).point = content.score
	strTip = i18n("mail_feast_text_02", nil)
	return strTip
end
_ENV = "Content_Party_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Party_Rank_Reward], ("Content_Party_Rank_Reward").parseDes = "Content_Party_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	;(nil).point = content.score
	strTip = i18n("mail_feast_text_04", nil)
	return strTip
end
_ENV = "Content_Christmas_Tree_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Christmas_Tree_Reward], ("Content_Christmas_Tree_Reward").parseDes = "Content_Christmas_Tree_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local treeName = publicRead.getName(content.itemId)
	publicRead = nil
	;(nil).Player = content.nickName
	;(nil).TreeType = treeName
	;(nil).x = content.x
	;(nil).y = content.y
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Christmas_Plant_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Christmas_Plant_Reward], ("Content_Christmas_Plant_Reward").parseDes = "Content_Christmas_Plant_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local treeName = publicRead.getName(content.itemId)
	local posStr = string.format("（%d, %d）", content.x, content.y)
	publicRead = content.y
	content.y.Coordinate = posStr
	content.y.TreeType = treeName
	content.y.Times = content.times
	strTip = i18n(formatedStr, content.y)
	return strTip
end
_ENV = "Content_New_Year_Day_Item_gift"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Year_Day_Item_gift], ("Content_New_Year_Day_Item_gift").parseDes = "Content_New_Year_Day_Item_gift", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).item = publicRead.getName(content.itemID)
	;(nil).num = content.goldNum
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_New_Year_Day_Get_Coins"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Year_Day_Get_Coins], ("Content_New_Year_Day_Get_Coins").parseDes = "Content_New_Year_Day_Get_Coins", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).num = content.goldNum
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_New_Server_Rank_Match"
;("Content_New_Server_Rank_Match").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.rankType == 1 then
		_ENV = nil
		;(nil).name = i18n("kindom_competition_text_15")
		;(nil).Range = content.rank
		strTip = i18n("mail_kindomcompetition_text_01", nil)
	elseif content.rankType == 2 then
		_ENV = nil
		;(nil).name = i18n("kindom_competition_text_17")
		;(nil).Range = content.rank
		strTip = i18n("mail_kindomcompetition_text_01", nil)
	elseif content.rankType == 3 then
		_ENV = nil
		;(nil).name = i18n("kindom_competition_text_16")
		;(nil).Range = content.rank
		strTip = i18n("mail_kindomcompetition_text_01", nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Server_Rank_Match], ("Content_New_Server_Rank_Match").parseSummary = "Content_New_Server_Rank_Match", function(mail)
	local mailsummary
	local rankType = mail.property.data.content.rankType
	if rankType == 1 then
		mailsummary = i18n("kindom_competition_text_08")
	elseif rankType == 2 then
		mailsummary = i18n("kindom_competition_text_09")
	elseif rankType == 3 then
		mailsummary = i18n("kindom_competition_text_10")
	end
	mailsummary = mailsummary or "undefined"
	return mailsummary
end
_ENV = "Content_Spend_Gold_Rebate"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Spend_Gold_Rebate], ("Content_Spend_Gold_Rebate").parseDes = "Content_Spend_Gold_Rebate", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).gold1 = content.needGold
	;(nil).gold2 = content.rebate
	strTip = i18n("mail_goldreturn_text_01", nil)
	return strTip
end
_ENV = "Content_Recharge_Feedback_Mail"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Recharge_Feedback_Mail], ("Content_Recharge_Feedback_Mail").parseDes = "Content_Recharge_Feedback_Mail", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).gold = content.gold
	strTip = i18n("mail_text_89", nil)
	return strTip
end
_ENV = "Content_Weekly_Discount_Reward"
;("Content_Weekly_Discount_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local rechargeRead = include("rechargeRead")
	local info = rechargeRead.getPageViewData(content.id)
	local giftName = i18n(info.activeName)
	_ENV = nil
	;(nil).gift = giftName
	strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Weekly_Discount_Reward], ("Content_Weekly_Discount_Reward").parseSummary = "Content_Weekly_Discount_Reward", function(mail)
	local mailsummary
	local id = mail.property.data.content.id
	local rechargeRead = include("rechargeRead")
	local info = rechargeRead.getPageViewData(id)
	mailsummary = i18n(info.activeName)
	return mailsummary
end
_ENV = "Content_Crazy_Shopping_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Crazy_Shopping_Reward], ("Content_Crazy_Shopping_Reward").parseDes = "Content_Crazy_Shopping_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).Num = content.count
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Vip_privilege_gift"
;("Content_Vip_privilege_gift").parseSummary = function(mail)
	local mailsummary
	local id = mail.property.data.content.id
	local rechargeRead = include("rechargeRead")
	local packageName = rechargeRead.getPageViewData(id).activeName
	mailsummary = i18n(packageName)
	return mailsummary
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Vip_privilege_gift], ("Content_Vip_privilege_gift").parseDes = "Content_Vip_privilege_gift", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local rechargeRead = include("rechargeRead")
	local packageName = i18n(rechargeRead.getPageViewData(content.id).activeName)
	_ENV = nil
	;(nil).gift = packageName
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Amazing_Fortune_Final_Reward_INFORM"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Amazing_Fortune_Final_Reward_INFORM], ("Content_Amazing_Fortune_Final_Reward_INFORM").parseDes = "Content_Amazing_Fortune_Final_Reward_INFORM", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local name = mailFunctions:getWrappedName(content.abbr, content.nickName)
	mailFunctions = content.nickName
	content.nickName.server = "K" .. content.kid
	content.nickName.name = name
	strTip = i18n(formatedStr, content.nickName)
	return strTip
end
_ENV = "Content_Activity_Supplement_Mail"
;("Content_Activity_Supplement_Mail").parseTitle = function(mail)
	local mailTitle
	local actId = mail.property.data.content.actId
	if actId then
		mailTitle = clientEventMgr.getEventNameById(actId)
	end
	return mailTitle
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Activity_Supplement_Mail], ("Content_Activity_Supplement_Mail").parseDes = "Content_Activity_Supplement_Mail", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).name = clientEventMgr.getEventNameById(content.actId)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_New_Sales_Room_Win"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Sales_Room_Win], ("Content_New_Sales_Room_Win").parseDes = "Content_New_Sales_Room_Win", mailDesParser.npcFuncMap[gMailNPCContentType.Content_Auction_Win].parseDes
_ENV = "Content_New_Sales_Room_Fail_Refund"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Sales_Room_Fail_Refund], ("Content_New_Sales_Room_Fail_Refund").parseDes = "Content_New_Sales_Room_Fail_Refund", function(mail, mailDesInfo, content, formatedStr)
	local costid = content.costid
	local resStr = costid == gIDDef.BORE and i18n("remains_name_01") or i18n("common_text_020")
	_ENV = nil
	;(nil).type = resStr
	local strTip = i18n(formatedStr, nil)
	_ENV = nil
	;(nil).name = publicRead.getName(content.item[1])
	;(nil).count = content.item[2]
	local itemStr = i18n("common_text_1460", nil)
	if not content.extrashow then
		_ENV = content.extrashow
	end
	for i, v in ipairs(content.extrashow) do
		_ENV = nil
		;(nil).item = itemStr
		;(nil).gold = v.count
		;(nil).type = resStr
		local temp = i18n("mail_auction_text_03", nil)
		strTip = string.format([[
%s
%s]], strTip, temp)
	end
	return strTip
end
_ENV = "Content_Ancient_Treasure_Alliance_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Treasure_Alliance_Reward], ("Content_Ancient_Treasure_Alliance_Reward").parseDes = "Content_Ancient_Treasure_Alliance_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.count then
		_ENV = nil
		;(nil).num = content.count
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Ancient_Build_Reinforcement_UpLimit"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Build_Reinforcement_UpLimit], ("Content_Ancient_Build_Reinforcement_UpLimit").parseDes = "Content_Ancient_Build_Reinforcement_UpLimit", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if next(content) then
		_ENV = nil
		;(nil).name = i18n("AncienTreasure_buildname_01")
		;(nil).x = content.coordinate.x
		;(nil).y = content.coordinate.y
		;(nil).numReinforcement = content.numReinforcement
		;(nil).numLeft = content.numLeft
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Ancient_Explore_Info"
;("Content_Ancient_Explore_Info").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.buildX and content.buildY then
		_ENV = nil
		;(nil).x = content.buildX
		;(nil).y = content.buildY
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Explore_Info], ("Content_Ancient_Explore_Info").parseSummary = "Content_Ancient_Explore_Info", function(mail)
	return mailDesParser.npcFuncMap_parseAncientTreasureSummary(mail)
end
_ENV = "Content_Ancient_Explore_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Explore_Reward], ("Content_Ancient_Explore_Reward").parseDes = "Content_Ancient_Explore_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.buildX and content.buildY then
		local ancientTreasureRead = include("ancientTreasureRead")
		local buildInfo = ancientTreasureRead.getBuildInfo(content.buildType)
		local torchCount = content.torchCount
		local spadeCount = content.spadeCount
		_ENV = nil
		;(nil).name = content.nickName
		;(nil).x = content.buildX
		;(nil).y = content.buildY
		;(nil).type = i18n(buildInfo.name)
		;(nil).num = buildInfo.num
		;(nil).count = torchCount + spadeCount
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Ancient_Initiator_Notice"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Initiator_Notice], ("Content_Ancient_Initiator_Notice").parseDes = "Content_Ancient_Initiator_Notice", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.buildX and content.buildY then
		_ENV = nil
		;(nil).x = content.buildX
		;(nil).y = content.buildY
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Ancient_Explore_Reward_Limit"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Explore_Reward_Limit], ("Content_Ancient_Explore_Reward_Limit").parseDes = "Content_Ancient_Explore_Reward_Limit", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.buildX and content.buildY and content.buildType then
		_ENV = nil
		;(nil).name = content.nickName
		;(nil).x = content.buildX
		;(nil).y = content.buildY
		strTip = i18n(formatedStr, nil)
		local ancientTreasureRead = include("ancientTreasureRead")
		local buildInfo = ancientTreasureRead.getBuildInfo(content.buildType)
		_ENV = nil
		;(nil).type = i18n(buildInfo.name)
		strTip = strTip .. "\n" .. i18n("common_text_3516", nil)
		_ENV = nil
		;(nil).num = buildInfo.num
		strTip = strTip .. "\n" .. i18n("AncienTreasure_text_31", nil)
	end
	return strTip
end
_ENV = "Content_Alliance_Active_Daily_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Active_Daily_Reward], ("Content_Alliance_Active_Daily_Reward").parseDes = "Content_Alliance_Active_Daily_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.point then
		_ENV = nil
		;(nil).num = content.point
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Alliance_Active_Week_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Active_Week_Rank_Reward], ("Content_Alliance_Active_Week_Rank_Reward").parseDes = "Content_Alliance_Active_Week_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.rank then
		if content.rewardType == 1 then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n("mail_text_585", nil)
		elseif content.rewardType == 2 then
			_ENV = nil
			;(nil).rank = content.rank
			strTip = i18n("mail_text_584", nil)
		end
	end
	return strTip
end
_ENV = "Content_Alliance_Active_Upgrade_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Active_Upgrade_Reward], ("Content_Alliance_Active_Upgrade_Reward").parseDes = "Content_Alliance_Active_Upgrade_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.lv then
		_ENV = nil
		;(nil).lv = content.lv
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_End], ("Content_Ramadan_Shining_Castle_End").parseDes = "Content_Ramadan_Shining_Castle_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	if content.giveTopTen and content.shiningTopTen then
		strTip = i18n("mail_ramadanshining_03") .. "\n"
		for i = 1, #content.giveTopTen do
			local name = mailFunctions:getWrappedName(content.giveTopTen[i].abbr, content.giveTopTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.giveTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.giveTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
		strTip = strTip .. [[


]] .. i18n("mail_ramadanshining_02") .. "\n"
		for i = 1, #content.shiningTopTen do
			local name = mailFunctions:getWrappedName(content.shiningTopTen[i].abbr, content.shiningTopTen[i].nickName)
			_ENV = content.giveTopTen[i].kid
			content.giveTopTen[i].kid.lv = i
			content.giveTopTen[i].kid.name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", content.giveTopTen[i].kid)
			if content.shiningTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.shiningTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_End_2"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_End_2], ("Content_Ramadan_Shining_Castle_End_2").parseDes = "Content_Ramadan_Shining_Castle_End_2", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	if content.giveTopTen and content.shiningTopTen then
		strTip = i18n("castle_text_06") .. "\n"
		for i = 1, #content.giveTopTen do
			local name = mailFunctions:getWrappedName(content.giveTopTen[i].abbr, content.giveTopTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.giveTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.giveTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
		strTip = strTip .. [[


]] .. i18n("castle_text_07") .. "\n"
		for i = 1, #content.shiningTopTen do
			local name = mailFunctions:getWrappedName(content.shiningTopTen[i].abbr, content.shiningTopTen[i].nickName)
			_ENV = content.giveTopTen[i].kid
			content.giveTopTen[i].kid.lv = i
			content.giveTopTen[i].kid.name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", content.giveTopTen[i].kid)
			if content.shiningTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.shiningTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_End_3"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_End_3], ("Content_Ramadan_Shining_Castle_End_3").parseDes = "Content_Ramadan_Shining_Castle_End_3", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	if content.giveTopTen and content.shiningTopTen then
		strTip = i18n("dazzlingRamadan_text_06") .. "\n"
		for i = 1, #content.giveTopTen do
			local name = mailFunctions:getWrappedName(content.giveTopTen[i].abbr, content.giveTopTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.giveTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.giveTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
		strTip = strTip .. [[


]] .. i18n("dazzlingRamadan_text_05") .. "\n"
		for i = 1, #content.shiningTopTen do
			local name = mailFunctions:getWrappedName(content.shiningTopTen[i].abbr, content.shiningTopTen[i].nickName)
			_ENV = content.giveTopTen[i].kid
			content.giveTopTen[i].kid.lv = i
			content.giveTopTen[i].kid.name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", content.giveTopTen[i].kid)
			if content.shiningTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.shiningTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_End_4"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_End_4], ("Content_Ramadan_Shining_Castle_End_4").parseDes = "Content_Ramadan_Shining_Castle_End_4", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	if content.giveTopTen and content.shiningTopTen then
		strTip = i18n("snowwolf_text_12") .. "\n"
		for i = 1, #content.giveTopTen do
			local name = mailFunctions:getWrappedName(content.giveTopTen[i].abbr, content.giveTopTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.giveTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.giveTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
		strTip = strTip .. [[


]] .. i18n("snowwolf_text_11") .. "\n"
		for i = 1, #content.shiningTopTen do
			local name = mailFunctions:getWrappedName(content.shiningTopTen[i].abbr, content.shiningTopTen[i].nickName)
			_ENV = content.giveTopTen[i].kid
			content.giveTopTen[i].kid.lv = i
			content.giveTopTen[i].kid.name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", content.giveTopTen[i].kid)
			if content.shiningTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.shiningTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_End_5"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_End_5], ("Content_Ramadan_Shining_Castle_End_5").parseDes = "Content_Ramadan_Shining_Castle_End_5", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	if content.giveTopTen and content.shiningTopTen then
		strTip = i18n("ice_dragon_12") .. "\n"
		for i = 1, #content.giveTopTen do
			local name = mailFunctions:getWrappedName(content.giveTopTen[i].abbr, content.giveTopTen[i].nickName)
			_ENV = nil
			;(nil).lv = i
			;(nil).name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", nil)
			if content.giveTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.giveTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
		strTip = strTip .. [[


]] .. i18n("ice_dragon_11") .. "\n"
		for i = 1, #content.shiningTopTen do
			local name = mailFunctions:getWrappedName(content.shiningTopTen[i].abbr, content.shiningTopTen[i].nickName)
			_ENV = content.giveTopTen[i].kid
			content.giveTopTen[i].kid.lv = i
			content.giveTopTen[i].kid.name = name
			local itemRankTip = "\n" .. i18n("common_text_1763", content.giveTopTen[i].kid)
			if content.shiningTopTen[i].kid ~= nil then
				itemRankTip = itemRankTip .. " #" .. content.shiningTopTen[i].kid
			end
			strTip = strTip .. itemRankTip
		end
	end
	return strTip
end
_ENV = "Content_ANTIDUEL_INEFFECT"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_ANTIDUEL_INEFFECT], ("Content_ANTIDUEL_INEFFECT").parseDes = "Content_ANTIDUEL_INEFFECT", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.time then
		local name = content.name or "unknow name"
		local allianceAbbr = content.aname
		if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
			_ENV = nil
			;(nil).abbr = allianceAbbr
			;(nil).name = name
			name = i18n("common_text_186", nil)
		end
		if content.kid then
			name = name .. "#" .. tostring(content.kid)
		end
		local fightTime = SoraDConvertTimeToYear(content.time, true)
		_ENV = content.kid
		content.kid.time = fightTime
		content.kid.Name = name
		strTip = i18n(formatedStr, content.kid)
	end
	return strTip
end
_ENV = "Content_DUEL_FAIL_REASON_RESIST"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_DUEL_FAIL_REASON_RESIST], ("Content_DUEL_FAIL_REASON_RESIST").parseDes = "Content_DUEL_FAIL_REASON_RESIST", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	local name = content.name or "unknow name"
	local allianceAbbr = content.aname
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = name
		name = i18n("common_text_186", nil)
	end
	if content.kid then
		name = name .. "#" .. tostring(content.kid)
	end
	_ENV = tostring(content.kid)
	tostring(content.kid).name = name
	tostring(content.kid).x = content.pos.x
	tostring(content.kid).y = content.pos.y
	strTip = i18n(formatedStr, (tostring(content.kid)))
	return strTip
end
_ENV = "Content_Radiance_War_Begin"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_Begin], ("Content_Radiance_War_Begin").parseDes = "Content_Radiance_War_Begin", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local radianceWarRead = include("radianceWarRead")
		if not radianceWarRead.getRewardList(1) then
			local _ENV, reward = radianceWarRead.getRewardList(1), radianceWarRead.getRewardList(1)
		end
		reward, _ENV = reward[1], reward[1]
		reward = reward[1] or radianceWarRead.getRewardList(1)
		local rewardsStr = ""
		for i, v in ipairs(reward.reward) do
			rewardsStr = rewardsStr .. [[

	]]
			_ENV = nil
			;(nil).name = publicRead.getName(v.id)
			;(nil).count = v.count
			rewardsStr = rewardsStr .. i18n("common_text_1460", nil)
			if i < #reward then
				rewardsStr = rewardsStr .. "\n"
			end
		end
		_ENV = ipairs(reward.reward)
		ipairs(reward.reward).reward = rewardsStr
		strTip = i18n(formatedStr, ipairs(reward.reward))
	end
	return strTip
end
_ENV = "Content_Radiance_War_Season_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_Season_End], ("Content_Radiance_War_Season_End").parseDes = "Content_Radiance_War_Season_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, config
		if content.kid and content.kid <= 0 then
			config.name = i18n("alliance_office_text_15")
		else
			config.name = content.name or ""
		end
		strTip = i18n(formatedStr, config)
	end
	return strTip
end
_ENV = "Content_Radiance_War_Rank_Place_Person"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_Rank_Place_Person], ("Content_Radiance_War_Rank_Place_Person").parseDes = "Content_Radiance_War_Rank_Place_Person", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, config
		config.num = content.num or ""
		config.time = SoraDConvertSecondToString(content.time or 0)
		strTip = i18n(formatedStr, config)
	end
	return strTip
end
_ENV = "Content_Radiance_War_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_End], ("Content_Radiance_War_End").parseDes = "Content_Radiance_War_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, config
		if content.kid and content.kid <= 0 then
			config.name = i18n("alliance_office_text_15")
		else
			local kingdomName = mailFunctions:getWrappedName(content.abbr, content.name)
			config.name = kingdomName or ""
			config.kid = content.kid
		end
		config.time = SoraDConvertSecondToString(content.time)
		local empty = "\n" .. i18n("common_text_480")
		config.gate = empty
		config.killer = empty
		config.place = empty
		if content.topGate and next(content.topGate) then
			local str = ""
			for i, v in ipairs(content.topGate) do
				local name = mailFunctions:getWrappedName(v.abbr, v.name, v.kid)
				_ENV = v.kid
				v.kid.lv = i
				v.kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", v.kid)
				itemRankTip = itemRankTip .. "\t" .. string.formatnumberthousands(v.num)
				str = str .. itemRankTip
			end
			config.gate = str
		end
		if content.topKiller and next(content.topKiller) then
			local str = ""
			for i, v in ipairs(content.topKiller) do
				local name = mailFunctions:getWrappedName(v.abbr, v.name, v.kid)
				_ENV = v.kid
				v.kid.lv = i
				v.kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", v.kid)
				itemRankTip = itemRankTip .. "\t" .. string.formatnumberthousands(v.num)
				str = str .. itemRankTip
			end
			config.killer = str
		end
		if content.topPlace and next(content.topPlace) then
			local str = ""
			for i, v in ipairs(content.topPlace) do
				local name = mailFunctions:getWrappedName(v.abbr, v.name, v.kid)
				_ENV = v.kid
				v.kid.lv = i
				v.kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", v.kid)
				itemRankTip = itemRankTip .. "\t" .. SoraDConvertSecondToString(v.num)
				str = str .. itemRankTip
			end
			config.place = str
		end
		strTip = i18n(formatedStr, config)
	end
	return strTip
end
_ENV = "Content_Radiance_War_End_New"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_End_New], ("Content_Radiance_War_End_New").parseDes = "Content_Radiance_War_End_New", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, config
		if content.kid and content.kid <= 0 then
			config.name = i18n("alliance_office_text_15")
		else
			local kingdomName = mailFunctions:getWrappedName(content.abbr, content.name)
			config.name = kingdomName or ""
			config.kid = content.kid
		end
		config.time = SoraDConvertSecondToString(content.time)
		local empty = "\n" .. i18n("common_text_480")
		config.gate = empty
		config.killer = empty
		config.place = empty
		if content.topTeamExploit and next(content.topTeamExploit) then
			local str = ""
			for i, v in ipairs(content.topTeamExploit) do
				local name = mailFunctions:getWrappedName(v.abbr, v.name, v.kid)
				_ENV = v.kid
				v.kid.lv = i
				v.kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", v.kid)
				itemRankTip = itemRankTip .. "\t" .. string.formatnumberthousands(v.num)
				str = str .. itemRankTip
			end
			config.gate = str
		end
		if content.topPlayerExploit and next(content.topPlayerExploit) then
			local str = ""
			for i, v in ipairs(content.topPlayerExploit) do
				local name = mailFunctions:getWrappedName(v.abbr, v.name, v.kid)
				_ENV = v.kid
				v.kid.lv = i
				v.kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", v.kid)
				itemRankTip = itemRankTip .. "\t" .. string.formatnumberthousands(v.num)
				str = str .. itemRankTip
			end
			config.killer = str
		end
		if content.topPlace and next(content.topPlace) then
			local str = ""
			for i, v in ipairs(content.topPlace) do
				local name = mailFunctions:getWrappedName(v.abbr, v.name, v.kid)
				_ENV = v.kid
				v.kid.lv = i
				v.kid.name = name
				local itemRankTip = "\n" .. i18n("common_text_1763", v.kid)
				itemRankTip = itemRankTip .. "\t" .. SoraDConvertSecondToString(v.num)
				str = str .. itemRankTip
			end
			config.place = str
		end
		strTip = i18n(formatedStr, config)
	end
	return strTip
end
_ENV = "Content_Radince_War_Wounded_Army_Cure_Detail"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radince_War_Wounded_Army_Cure_Detail], ("Content_Radince_War_Wounded_Army_Cure_Detail").parseDes = "Content_Radince_War_Wounded_Army_Cure_Detail", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, config
		if content.armyList and next(content.armyList) then
			local str = ""
			local armyDes = include("armyDesRead")
			for i, v in ipairs(content.armyList) do
				local name = armyDes.getName(v.id)
				local armyInfo = name
				if 1 < i then
					armyInfo = " " .. armyInfo
				end
				armyInfo = armyInfo .. "x" .. string.formatnumberthousands(v.count)
				str = str .. armyInfo
			end
			config.armyInfo = str
		else
			config.armyInfo = i18n("common_text_480")
		end
		strTip = i18n(formatedStr, config)
	end
	return strTip
end
_ENV = "Content_Together_Feed_Sheep_Luck_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Together_Feed_Sheep_Luck_Reward], ("Content_Together_Feed_Sheep_Luck_Reward").parseDes = "Content_Together_Feed_Sheep_Luck_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		local _ENV, config
		config.num = content.stage
		strTip = i18n(formatedStr, config)
	end
	return strTip
end
_ENV = "Content_Radiance_War_OCCUPY_FAIL"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_OCCUPY_FAIL], ("Content_Radiance_War_OCCUPY_FAIL").parseDes = "Content_Radiance_War_OCCUPY_FAIL", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).x = content.x - 1 or 0
		;(nil).y = content.y - 1
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Give_Radiance_Quarry"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Give_Radiance_Quarry], ("Content_Give_Radiance_Quarry").parseDes = "Content_Give_Radiance_Quarry", mailDesParser.npcFuncMap[gMailNPCContentType.Content_Auction_Win].parseDes
_ENV = "Content_Radince_War_Wounded_Army_Cure_Complete"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radince_War_Wounded_Army_Cure_Complete], ("Content_Radince_War_Wounded_Army_Cure_Complete").parseDes = "Content_Radince_War_Wounded_Army_Cure_Complete", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).count = string.formatnumberthousands(content.count)
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Radiance_War_BUILD_LIMIT"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Radiance_War_BUILD_LIMIT], ("Content_Radiance_War_BUILD_LIMIT").parseDes = "Content_Radiance_War_BUILD_LIMIT", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if formatedStr ~= nil then
		_ENV = nil
		;(nil).x = content.x - 1 or 0
		;(nil).y = content.y - 1
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Glorious_Contest"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Glorious_Contest], ("Content_Glorious_Contest").parseDes = "Content_Glorious_Contest", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.lv then
		_ENV = nil
		;(nil).lv = content.lv
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Glorious_Shine"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Glorious_Shine], ("Content_Glorious_Shine").parseDes = "Content_Glorious_Shine", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr)
	if content.buffList and content.buffTime then
		local _ENV, buffName = content.buffTime, content.buffTime
		local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
		local buffDesRead = include("buffDesRead")
		for k, v in ipairs(content.buffList) do
			local buffType = buffltCtrl:getEffectType(v)
			local buffValue = buffltCtrl:getEffect(v)
			table.insert(buffName, buffDesRead.getTitleWithValue(buffType, buffValue))
		end
		_ENV = ipairs(content.buffList)
		ipairs(content.buffList).buffname = table.concat(buffName, ",")
		ipairs(content.buffList).endtime = SoraDConverTimeStr(content.buffTime)
		strTip = i18n(formatedStr, ipairs(content.buffList))
	end
	return strTip
end
_ENV = "Content_EID_TYCOON_RANK_TOP_TEN"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_EID_TYCOON_RANK_TOP_TEN], ("Content_EID_TYCOON_RANK_TOP_TEN").parseDes = "Content_EID_TYCOON_RANK_TOP_TEN", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local rankStr = ""
	if content.topInfo then
		for rank, v in ipairs(content.topInfo) do
			if v.allianceName and v.allianceName ~= "" then
				_ENV = nil
				;(nil).abbr = v.allianceName
				;(nil).name = v.nickName
				if i18n("common_text_186", nil) then
					goto lbl_27
				end
			end
			local showName = v.nickName
			::lbl_27::
			_ENV = nil
			;(nil).lv = rank
			;(nil).name = showName
			rankStr = rankStr .. i18n("common_text_1763", nil) .. "\n"
		end
	end
	strTip = i18n(formatedStr) .. "\n" .. rankStr
	return strTip
end
_ENV = "Content_Buff_Item_End"
;("Content_Buff_Item_End").parseTitle = function(mail)
	local str
	local itemDesRead = include("itemDesRead")
	local itemId = mail.property.data.content.itemId
	if itemId then
		_ENV = nil
		;(nil).name = itemDesRead.getName(itemId)
		str = i18n("common_text_4514", nil)
	end
	return str
end
;("Content_Buff_Item_End").parseSummary = function(mail)
	local str
	local itemDesRead = include("itemDesRead")
	local itemId = mail.property.data.content.itemId
	if itemId then
		_ENV = nil
		;(nil).name = itemDesRead.getName(itemId)
		str = i18n("common_text_4514", nil)
	end
	return str
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Buff_Item_End], ("Content_Buff_Item_End").parseDes = "Content_Buff_Item_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	local itemId = mail.property.data.content.itemId
	local time = mail.property.data.content.beginTime
	if itemId and time then
		_ENV = nil
		;(nil).time = os.date("!%Y-%m-%d %H:%M:%S", time)
		;(nil).name = itemDesRead.getName(itemId)
		strTip = i18n(formatedStr, nil)
	end
	return strTip
end
_ENV = "Content_Item_Invalid"
;("Content_Item_Invalid").parseTitle = function(mail, mailDesInfo, content, formatedStr)
	local str
	mailDesInfo = mailDesRead.getMailDesInfo(mail.property.mailType, mail.property.source, mail.property.data.contentType)
	local itemId = mail.property.data.content.itemId
	if itemId then
		local itemDesRead = include("itemDesRead")
		mailDesRead = nil
		;(nil).name = itemDesRead.getName(itemId)
		str = i18n(mailDesInfo.title, nil)
	end
	return str
end
;("Content_Item_Invalid").parseSummary = function(mail, mailDesInfo, content, formatedStr)
	local str
	local itemDesRead = include("itemDesRead")
	local itemId = mail.property.data.content.id
	mailDesInfo = mailDesRead.getMailDesInfo(mail.property.mailType, mail.property.source, mail.property.data.contentType)
	if itemId then
		_ENV = mail.property.source
		mail.property.source.name = itemDesRead.getName(itemId)
		str = i18n(mailDesInfo.summary, mail.property.source)
	end
	return str
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Item_Invalid], ("Content_Item_Invalid").parseDes = "Content_Item_Invalid", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local itemDesRead = include("itemDesRead")
	local itemId = mail.property.data.content.id
	local invalidTime = mail.property.data.content.invalidTime
	local count = mail.property.data.content.count
	if itemId and invalidTime and count then
		_ENV = nil
		;(nil).time = os.date("!%Y-%m-%d %H:%M:%S", invalidTime)
		;(nil).item = itemDesRead.getName(itemId)
		;(nil).num = count
		strTip = i18n(mailDesInfo.describe, nil)
	end
	return strTip
end
_ENV = "Content_RECHARGE_CARD_TIME_UP_INFORM"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RECHARGE_CARD_TIME_UP_INFORM], ("Content_RECHARGE_CARD_TIME_UP_INFORM").parseDes = "Content_RECHARGE_CARD_TIME_UP_INFORM", mailDesParser.npcFuncMap[gMailNPCContentType.Content_Recharge_Activity_Gift_Reward].parseDes
_ENV = "Content_New_King_Recharge"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_King_Recharge], ("Content_New_King_Recharge").parseDes = "Content_New_King_Recharge", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).price = "$" .. tostring(content.price)
	strTip = i18n("recharge_new_user_text05", nil)
	return strTip
end
_ENV = "Content_Ramadan_Feast_Create_Success"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Feast_Create_Success], ("Content_Ramadan_Feast_Create_Success").parseDes = "Content_Ramadan_Feast_Create_Success", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local name = mailFunctions:getWrappedName(content.allianceAbbr, content.nickName)
	mailFunctions = content.nickName
	content.nickName.var1 = name
	content.nickName.var2 = content.feastLv
	strTip = i18n("mail_feast_placed_text", content.nickName)
	return strTip
end
_ENV = "Content_Ramadan_Feast_Share_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Feast_Share_Reward], ("Content_Ramadan_Feast_Share_Reward").parseDes = "Content_Ramadan_Feast_Share_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).var1 = content.feastLv
	strTip = i18n("mail_feast_success_text", nil)
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_Give_Rank_Reward_3"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_Give_Rank_Reward_3], ("Content_Ramadan_Shining_Castle_Give_Rank_Reward_3").parseDes = "Content_Ramadan_Shining_Castle_Give_Rank_Reward_3", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Ramadan_Shining_Castle_Shining_Rank_Reward_3"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ramadan_Shining_Castle_Shining_Rank_Reward_3], ("Content_Ramadan_Shining_Castle_Shining_Rank_Reward_3").parseDes = "Content_Ramadan_Shining_Castle_Shining_Rank_Reward_3", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Lost_Ruins_Quest_Overdue"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Lost_Ruins_Quest_Overdue], ("Content_Lost_Ruins_Quest_Overdue").parseDes = "Content_Lost_Ruins_Quest_Overdue", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local eventQuestRead = include("eventQuestRead")
	content.x = content.x or 1
	content.y = content.y or 1
	_ENV = nil
	;(nil).x = content.x - 1 or 0
	;(nil).y = content.y - 1 or 0
	;(nil).tasdes = i18n(eventQuestRead.getDes(content.questId))
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_Ice_Dragon_Lost_Quest_Overdue"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ice_Dragon_Lost_Quest_Overdue], ("Content_Ice_Dragon_Lost_Quest_Overdue").parseDes = "Content_Ice_Dragon_Lost_Quest_Overdue", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local eventQuestRead = include("eventQuestRead")
	content.x = content.x or 1
	content.y = content.y or 1
	_ENV = nil
	;(nil).x = content.x - 1 or 0
	;(nil).y = content.y - 1 or 0
	;(nil).tasdes = i18n(eventQuestRead.getDes(content.questId))
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_Legend_Of_Pegasus_Quest_Overdue"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Legend_Of_Pegasus_Quest_Overdue], ("Content_Legend_Of_Pegasus_Quest_Overdue").parseDes = "Content_Legend_Of_Pegasus_Quest_Overdue", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local eventQuestRead = include("eventQuestRead")
	content.x = content.x or 1
	content.y = content.y or 1
	_ENV = nil
	;(nil).x = content.x - 1 or 0
	;(nil).y = content.y - 1 or 0
	;(nil).tasdes = i18n(eventQuestRead.getDes(content.questId))
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_Firedragon_Of_Anger_Quest_Overdue"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Firedragon_Of_Anger_Quest_Overdue], ("Content_Firedragon_Of_Anger_Quest_Overdue").parseDes = "Content_Firedragon_Of_Anger_Quest_Overdue", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local eventQuestRead = include("eventQuestRead")
	content.x = content.x or 1
	content.y = content.y or 1
	_ENV = nil
	;(nil).x = content.x - 1 or 0
	;(nil).y = content.y - 1 or 0
	;(nil).tasdes = i18n(eventQuestRead.getDes(content.questId))
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_Firedragon_Of_Anger_Quest_Overdue"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Firedragon_Of_Anger_Quest_Overdue], ("Content_Firedragon_Of_Anger_Quest_Overdue").parseDes = "Content_Firedragon_Of_Anger_Quest_Overdue", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local eventQuestRead = include("eventQuestRead")
	content.x = content.x or 1
	content.y = content.y or 1
	_ENV = nil
	;(nil).x = content.x - 1 or 0
	;(nil).y = content.y - 1 or 0
	;(nil).tasdes = i18n(eventQuestRead.getDes(content.questId))
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_Wind_Tower_Timeout"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Wind_Tower_Timeout], ("Content_Wind_Tower_Timeout").parseDes = "Content_Wind_Tower_Timeout", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local eventQuestRead = include("eventQuestRead")
	local pos = content.pos or cc.p(1, 1)
	_ENV = nil
	;(nil).x = pos.x - 1 or 0
	;(nil).y = pos.y - 1 or 0
	;(nil).tasdes = i18n(eventQuestRead.getDes(content.questId))
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_New_Recharge_Gold_For_Reward"
;("Content_New_Recharge_Gold_For_Reward").parseTitle = function(mail)
	local str
	str = i18n("rebate_many_text_06")
	return str
end
;("Content_New_Recharge_Gold_For_Reward").parseSummary = function(mail)
	local str
	str = i18n("rebate_many_text_07")
	return str
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_New_Recharge_Gold_For_Reward], ("Content_New_Recharge_Gold_For_Reward").parseDes = "Content_New_Recharge_Gold_For_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).gold = string.formatnumberthousands(content.gold)
	strTip = i18n("mail_text_9001075_ROS", nil)
	return strTip
end
_ENV = "Content_Warm_Heart_Person_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Warm_Heart_Person_Reward], ("Content_Warm_Heart_Person_Reward").parseDes = "Content_Warm_Heart_Person_Reward", function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Warm_Heart_Person_Reward")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n("warmHeart_text_10", nil)
	return strTip
end
_ENV = "Content_Warm_Heart_Alliance_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Warm_Heart_Alliance_Reward], ("Content_Warm_Heart_Alliance_Reward").parseDes = "Content_Warm_Heart_Alliance_Reward", function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Warm_Heart_Alliance_Reward")
	local strTip
	_ENV = nil
	;(nil).var = content.rank
	strTip = i18n("warmHeart_text_12", nil)
	return strTip
end
_ENV = "Content_Walls_privilege_gift"
;("Content_Walls_privilege_gift").parseDes = function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Walls_privilege_gift")
	local strTip
	local rechargeRead = include("rechargeRead")
	local giftStyle = rechargeRead.getPageViewData(content.id)
	_ENV = nil
	;(nil).gift = i18n(giftStyle.activeName)
	strTip = i18n("mail_text_446", nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Walls_privilege_gift], ("Content_Walls_privilege_gift").parseSummary = "Content_Walls_privilege_gift", function(mail)
	local content = mail.property.data.content
	dump(content, "Content_Walls_privilege_gift")
	local rechargeRead = include("rechargeRead")
	local giftStyle = rechargeRead.getPageViewData(content.id)
	return i18n(giftStyle.activeName)
end
_ENV = "Content_Custom_Info_Activation_Code_Reward"
;("Content_Custom_Info_Activation_Code_Reward").parseTitle = function(mail)
	local str
	local content = mail.property.data.content
	local lang = SoraDFIsRA() and "ar" or "en"
	str = content.text[lang] and content.text[lang].title
	return str
end
;("Content_Custom_Info_Activation_Code_Reward").parseSummary = function(mail)
	local str
	local content = mail.property.data.content
	local lang = SoraDFIsRA() and "ar" or "en"
	str = content.text[lang] and content.text[lang].title
	return str
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Custom_Info_Activation_Code_Reward], ("Content_Custom_Info_Activation_Code_Reward").parseDes = "Content_Custom_Info_Activation_Code_Reward", function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_Custom_Info_Activation_Code_Reward")
	local strTip
	local lang = SoraDFIsRA() and "ar" or "en"
	strTip = content.text[lang] and content.text[lang].content
	return strTip
end
_ENV = "Content_collect_Torch_Activity_End_Notify"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_collect_Torch_Activity_End_Notify], ("Content_collect_Torch_Activity_End_Notify").parseDes = "Content_collect_Torch_Activity_End_Notify", function(mail, mailDesInfo, content, formatedStr)
	dump(content, "Content_collect_Torch_Activity_End_Notify")
	_ENV = "Content_collect_Torch_Activity_End_Notify"
	;("Content_collect_Torch_Activity_End_Notify").name = mailFunctions:getWrappedName(content.rankData[1].uInfo.allianceAbbr, content.rankData[1].uInfo.nickName)
	;("Content_collect_Torch_Activity_End_Notify").num = #content.rankData
	local strTip = i18n("mail_text_607", "Content_collect_Torch_Activity_End_Notify")
	for i, v in ipairs(content.rankData) do
		local name = mailFunctions:getWrappedName(v.uInfo.allianceAbbr, v.uInfo.nickName)
		_ENV = nil
		;(nil).lv = i
		;(nil).name = name
		local itemRankTip = "\n" .. i18n("common_text_1763", nil)
		strTip = strTip .. itemRankTip
	end
	return strTip
end
_ENV = "Content_Koh_Migrate_recv_Spec_Invited"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Koh_Migrate_recv_Spec_Invited], ("Content_Koh_Migrate_recv_Spec_Invited").parseDes = "Content_Koh_Migrate_recv_Spec_Invited", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var1 = content.kid
	return i18n(formatedStr, nil)
end
_ENV = "Content_Koh_Migrate_cancel_Spec_Invited"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Koh_Migrate_cancel_Spec_Invited], ("Content_Koh_Migrate_cancel_Spec_Invited").parseDes = "Content_Koh_Migrate_cancel_Spec_Invited", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var1 = content.kid
	return i18n(formatedStr, nil)
end
_ENV = "Content_Koh_Migrate_Spec_Invited_Player_Move_In"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Koh_Migrate_Spec_Invited_Player_Move_In], ("Content_Koh_Migrate_Spec_Invited_Player_Move_In").parseDes = "Content_Koh_Migrate_Spec_Invited_Player_Move_In", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var1 = content.nickname
	return i18n(formatedStr, nil)
end
_ENV = "Content_Koh_Migrate_Spec_Invited_Player_Normal_Move_In"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Koh_Migrate_Spec_Invited_Player_Normal_Move_In], ("Content_Koh_Migrate_Spec_Invited_Player_Normal_Move_In").parseDes = "Content_Koh_Migrate_Spec_Invited_Player_Normal_Move_In", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var1 = content.nickname
	return i18n(formatedStr, nil)
end
_ENV = "Content_Koh_Migrate_Spec_Invited_Player_Move_Away"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Koh_Migrate_Spec_Invited_Player_Move_Away], ("Content_Koh_Migrate_Spec_Invited_Player_Move_Away").parseDes = "Content_Koh_Migrate_Spec_Invited_Player_Move_Away", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var1 = content.nickname
	return i18n(formatedStr, nil)
end
_ENV = "Content_Atlantis_War_Season_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_War_Season_End], ("Content_Atlantis_War_Season_End").parseDes = "Content_Atlantis_War_Season_End", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr) .. "\n"
	local rankData = content.rankData
	for i, v in ipairs(rankData) do
		local kingdomName = serviceFunctions.getKingdomFormatName(v.kingdomName, v.kid)
		_ENV = nil
		;(nil).lv = i
		;(nil).name = kingdomName
		strTip = string.format([[
%s
%s]], strTip, i18n("common_text_1763", nil))
	end
	return strTip
end
_ENV = "Content_Atlantis_War_Title_Rank_Reward"
;("Content_Atlantis_War_Title_Rank_Reward").parseSummary = function(mail)
	local content = mail.property.data.content
	local ATC = require_data("atlantiswar_title_config").data
	return i18n(ATC[content.title].name)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_War_Title_Rank_Reward], ("Content_Atlantis_War_Title_Rank_Reward").parseDes = "Content_Atlantis_War_Title_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local ATC = require_data("atlantiswar_title_config").data
	local titleName = i18n(ATC[content.title].name)
	_ENV = nil
	;(nil).titleName = titleName
	;(nil).rank = content.rank
	return i18n(formatedStr, nil)
end
_ENV = "Content_Atlantis_War_Round_Title_Reward"
;("Content_Atlantis_War_Round_Title_Reward").parseSummary = function(mail)
	local content = mail.property.data.content
	local ATC = require_data("atlantiswar_title_config").data
	return i18n(ATC[content.title].name)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_War_Round_Title_Reward], ("Content_Atlantis_War_Round_Title_Reward").parseDes = "Content_Atlantis_War_Round_Title_Reward", function(mail, mailDesInfo, content, formatedStr)
	local ATC = require_data("atlantiswar_title_config").data
	local titleName = i18n(ATC[content.title].name)
	_ENV = nil
	;(nil).titleName = titleName
	return i18n(formatedStr, nil)
end
_ENV = "Content_Notice_Activity_Will_End"
;("Content_Notice_Activity_Will_End").parseSummary = function(mail)
	local content = mail.property.data.content
	local activityID = content.activityID
	local activityTimeRead = include("activityTimeRead")
	local str = activityTimeRead.getActivityNameByID(activityID)
	return i18n(str)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Notice_Activity_Will_End], ("Content_Notice_Activity_Will_End").parseDes = "Content_Notice_Activity_Will_End", function(mail, mailDesInfo, content, formatedStr)
	local endtime = os.date("!%Y-%m-%d %H:%M", content.endtime)
	local activityID = content.activityID
	if activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
		formatedStr = "sudanGift_text_15"
	end
	_ENV = nil
	;(nil).time = endtime
	return i18n(formatedStr, nil)
end
_ENV = "Content_Smelt_Activity_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Smelt_Activity_Reward], ("Content_Smelt_Activity_Reward").parseDes = "Content_Smelt_Activity_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).num = content.stage
	return i18n(formatedStr, nil)
end
_ENV = "Content_Honor_Back_Smelt_Activity_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Honor_Back_Smelt_Activity_Reward], ("Content_Honor_Back_Smelt_Activity_Reward").parseDes = "Content_Honor_Back_Smelt_Activity_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).num = content.stage
	return i18n(formatedStr, nil)
end
_ENV = "Content_Mermaid_Gift_Luck_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Mermaid_Gift_Luck_Rank], ("Content_Mermaid_Gift_Luck_Rank").parseDes = "Content_Mermaid_Gift_Luck_Rank", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).num = content.num
	return i18n(formatedStr, nil)
end
_ENV = "Content_Mermaid_Gift_Score_Rank"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Mermaid_Gift_Score_Rank], ("Content_Mermaid_Gift_Score_Rank").parseDes = "Content_Mermaid_Gift_Score_Rank", function(mail, mailDesInfo, content, formatedStr)
	local mermaidGiftCtrl = SoraDGetCtrl("mermaidGiftCtrl")
	_ENV = nil
	;(nil).num = content.num
	;(nil).num1 = mermaidGiftCtrl:getGiftCharNum()
	return i18n(formatedStr, nil)
end
_ENV = "Content_Nebula_MileStone_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_MileStone_Reward], ("Content_Nebula_MileStone_Reward").parseDes = "Content_Nebula_MileStone_Reward", function(mail, mailDesInfo, content, formatedStr)
	local nebulaMileStoneRead = include("nebulaMileStoneRead")
	_ENV = nil
	;(nil).name = nebulaMileStoneRead.getName(content.taskID)
	return i18n(formatedStr, nil)
end
_ENV = "Content_Atlantis_Privilege_Appoint"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_Privilege_Appoint], ("Content_Atlantis_Privilege_Appoint").parseDes = "Content_Atlantis_Privilege_Appoint", function(mail, mailDesInfo, content, formatedStr)
	local atlantisActivityRead = include("atlantisActivityRead")
	local officeInfo = atlantisActivityRead.getOfficialInfoByType(content.appointType)
	_ENV = nil
	;(nil).var1 = content.nickName
	;(nil).var2 = content.appointKid
	;(nil).var3 = i18n(officeInfo.name)
	local str = i18n(formatedStr, nil)
	for _, bufferId in ipairs(officeInfo.buff) do
		local buffDes, type = atlantisActivityRead.getBufferName(bufferId)
		str = str .. "\n" .. buffDes
	end
	return str
end
_ENV = "Content_Atlantis_Privilege_Dismiss"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_Privilege_Dismiss], ("Content_Atlantis_Privilege_Dismiss").parseDes = "Content_Atlantis_Privilege_Dismiss", function(mail, mailDesInfo, content, formatedStr)
	local atlantisActivityRead = include("atlantisActivityRead")
	local officeInfo = atlantisActivityRead.getOfficialInfoByType(content.appointType)
	_ENV = nil
	;(nil).var1 = content.nickName
	;(nil).var2 = content.disMissKid
	;(nil).var3 = i18n(officeInfo.name)
	local str = i18n(formatedStr, nil)
	return str
end
_ENV = "Content_Atlantis_Privilege_Treasure"
;("Content_Atlantis_Privilege_Treasure").parseSummary = function(mail)
	local content = mail.property.data.content
	return i18n(include("atlantisActivityRead").getPackageName(content.treasureID))
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_Privilege_Treasure], ("Content_Atlantis_Privilege_Treasure").parseDes = "Content_Atlantis_Privilege_Treasure", function(mail, mailDesInfo, content, formatedStr)
	local atlantisActivityRead = include("atlantisActivityRead")
	_ENV = nil
	;(nil).var1 = content.nickName
	;(nil).var2 = content.kid
	;(nil).var3 = i18n(atlantisActivityRead.getPackageName(content.treasureID))
	local str = i18n(formatedStr, nil)
	return str
end
_ENV = "Content_Nebula_Privilege_System_Appoint"
;("Content_Nebula_Privilege_System_Appoint").parseSummary = function(mail)
	local content = mail.property.data.content
	if not content.isNew then
		return i18n("nebula_war_text_0560")
	end
	local changeData = mail.property.data.content.changeData
	return i18n(include("nebulaPrivilegelRead").getOfficialName(changeData.officerID))
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Privilege_System_Appoint], ("Content_Nebula_Privilege_System_Appoint").parseDes = "Content_Nebula_Privilege_System_Appoint", function(mail, mailDesInfo, content, formatedStr)
	if not content.isNew then
		return i18n("nebula_war_text_0560")
	end
	local changeData = content.changeData
	local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
	if not nebulaPrivilegelRead.checkIsAppointID(changeData.officerID) then
		formatedStr = "nebula_officer_text_011"
	end
	local officerName = nebulaPrivilegelRead.getOfficialName(changeData.officerID)
	_ENV = nil
	;(nil).official = i18n(officerName)
	local str = i18n(formatedStr, nil)
	return str
end
_ENV = "Content_Nebula_Privilege_Player_Appoint"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Privilege_Player_Appoint], ("Content_Nebula_Privilege_Player_Appoint").parseDes = "Content_Nebula_Privilege_Player_Appoint", function(mail, mailDesInfo, content, formatedStr)
	if not content.isNew then
		return i18n("nebula_war_text_0560")
	end
	local changeData = content.changeData
	local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
	local officeInfo = nebulaPrivilegelRead.getOfficerInfo(changeData.officerID)
	local name = i18n(nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID))
	_ENV = nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID)
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var = name
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var1 = changeData.appointNickName
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var2 = changeData.appointKid
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var3 = i18n(officeInfo.name)
	local str = i18n(formatedStr, nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID))
	for _, bufferId in ipairs(officeInfo.buff) do
		local buffDes = nebulaPrivilegelRead.getBufferName(bufferId)
		str = str .. "\n" .. buffDes
	end
	return str
end
_ENV = "Content_Nebula_Privilege_Dismiss"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Privilege_Dismiss], ("Content_Nebula_Privilege_Dismiss").parseDes = "Content_Nebula_Privilege_Dismiss", function(mail, mailDesInfo, content, formatedStr)
	if not content.isNew then
		return i18n("nebula_war_text_0560")
	end
	local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
	local changeData = content.changeData
	local officeInfo = nebulaPrivilegelRead.getOfficerInfo(changeData.officerID)
	local name = i18n(nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID))
	_ENV = nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID)
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var = name
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var1 = changeData.appointNickName
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var2 = changeData.appointKid
	nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID).var3 = i18n(officeInfo.name)
	local str = i18n(formatedStr, nebulaPrivilegelRead.getOfficialName(changeData.appointOfficerID))
	return str
end
_ENV = "Content_Nebula_Privilege_Treasure"
;("Content_Nebula_Privilege_Treasure").parseSummary = function(mail)
	local content = mail.property.data.content
	if not content.isNew then
		return i18n("nebula_war_text_0560")
	end
	local changeData = content.changeData
	return i18n(include("nebulaPrivilegelRead").getPackageName(changeData.treasureID))
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Privilege_Treasure], ("Content_Nebula_Privilege_Treasure").parseDes = "Content_Nebula_Privilege_Treasure", function(mail, mailDesInfo, content, formatedStr)
	if not content.isNew then
		return i18n("nebula_war_text_0560")
	end
	local changeData = content.changeData
	local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
	local name = i18n(nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID))
	_ENV = nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID)
	nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID).var = name
	nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID).var1 = changeData.sendNickName
	nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID).var2 = changeData.sendKid
	nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID).var3 = i18n(nebulaPrivilegelRead.getPackageName(changeData.treasureID))
	local str = i18n(formatedStr, nebulaPrivilegelRead.getOfficialName(changeData.sendOfficerID))
	return str
end
_ENV = "Content_Atlantis_War_Mass_Boss"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_War_Mass_Boss], ("Content_Atlantis_War_Mass_Boss").parseDes = "Content_Atlantis_War_Mass_Boss", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local bossType = content.bossType
	local bossName = worldMapDefine.getWorldBossName(bossType)
	bossName = i18n(bossName)
	worldMapDefine = nil
	;(nil).bossName = bossName
	strTip = i18n("remains_text_166", nil)
	return strTip
end
_ENV = "Content_Stronghold_First_Kill_Reward"
;("Content_Stronghold_First_Kill_Reward").parseDes = function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.buildId then
		local bossName = include("allianceStrongholdMineRead").getHoldMonsterName(content.buildId)
		_ENV = nil
		;(nil).var = bossName
		strTip = i18n(mailDesInfo.describe, nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Stronghold_First_Kill_Reward], ("Content_Stronghold_First_Kill_Reward").parseSummary = "Content_Stronghold_First_Kill_Reward", function(mail)
	local strTip
	local buildId = mail:getProperty("data").content.buildId
	if buildId then
		local bossName = include("allianceStrongholdMineRead").getHoldMonsterName(buildId)
		_ENV = nil
		;(nil).var = bossName
		strTip = i18n("alliance_stronghold_text_074", nil)
	end
	return strTip
end
_ENV = "Content_Stronghold_Finish_Occupy"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Stronghold_Finish_Occupy], ("Content_Stronghold_Finish_Occupy").parseDes = "Content_Stronghold_Finish_Occupy", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	if content.buildId then
		local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
		_ENV = nil
		;(nil).var = allianceStrongholdMineRead.getGateLv(content.buildId) .. i18n(allianceStrongholdMineRead.getHoldMonsterName(content.buildId))
		local bossName = i18n("alliance_stronghold_text_032", nil)
		local pos = allianceStrongholdMineRead.getGatePos(content.buildId)
		local bType = allianceStrongholdMineRead.getGateBuffType(content.buildId)
		local _, buffList = allianceStrongholdMineRead.getBuffByType(bType)
		local buffStr = ""
		for i, v in ipairs(buffList) do
			local str = include("buffDesRead").getTitleWithValue(v.buffType, v.buffVal)
			buffStr = buffStr .. str .. "\n"
		end
		_ENV = ipairs(buffList)
		ipairs(buffList).var = bossName
		ipairs(buffList).num1 = pos.x
		ipairs(buffList).num2 = pos.y
		ipairs(buffList).buff = buffStr
		strTip = i18n(mailDesInfo.describe, ipairs(buffList))
	end
	return strTip
end
_ENV = "Content_Ice_Crazy_Activity_End_Notify"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ice_Crazy_Activity_End_Notify], ("Content_Ice_Crazy_Activity_End_Notify").parseDes = "Content_Ice_Crazy_Activity_End_Notify", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr) .. "\n"
	if not content.rankData then
		local _ENV, rankData = content.rankData, content.rankData
	end
	for i, v in ipairs(rankData) do
		local strName = mailFunctions:getWrappedName(v.alliance, v.nickName)
		_ENV = nil
		;(nil).lv = i
		;(nil).name = strName
		strTip = string.format([[
%s
%s]], strTip, i18n("common_text_1763", nil))
	end
	return strTip
end
_ENV = "Content_Alliance_Beast_Trail"
;("Content_Alliance_Beast_Trail").parseSummary = function(mail)
	local strTip = ""
	local alliancePetRead = include("alliancePetRead")
	local content = mail:getProperty("data").content
	if content then
		local petname = alliancePetRead.getName(content.beastType)
		_ENV = nil
		;(nil).petname = petname
		strTip = i18n("alliance_beast_text_40", nil)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Beast_Trail], ("Content_Alliance_Beast_Trail").parseDes = "Content_Alliance_Beast_Trail", function(mail, mailDesInfo, content, formatedStr)
	local alliancePetRead = include("alliancePetRead")
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).Lvl = content.beastLv
	;(nil).petname = alliancePetRead.getName(content.beastType)
	;(nil).x = content.pos.x - 1
	;(nil).y = content.pos.y - 1
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Ancient_Treasure_Excavated"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Ancient_Treasure_Excavated], ("Content_Ancient_Treasure_Excavated").parseDes = "Content_Ancient_Treasure_Excavated", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).x = content.x - 1
	;(nil).y = content.y - 1
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Alliance_Be_Remove_Friends"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Be_Remove_Friends], ("Content_Alliance_Be_Remove_Friends").parseDes = "Content_Alliance_Be_Remove_Friends", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	_ENV = nil
	;(nil).abbr = content.abbr
	;(nil).allianceName = content.allianceName
	;(nil).opAllianceName = content.opAllianceName
	;(nil).opAbbr = content.opAbbr
	;(nil).operator = content.opAid == content.aid and i18n("common_text_187") or content.opUsername
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Atlantis_War_Season_Treasure"
;("Content_Atlantis_War_Season_Treasure").parseSummary = function(mail)
	local strTip = ""
	local content = mail.property.data.content
	if content then
		local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
		strTip = atlantisActivityCtrl:getTreasureName(content.treasureType)
	end
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Atlantis_War_Season_Treasure], ("Content_Atlantis_War_Season_Treasure").parseDes = "Content_Atlantis_War_Season_Treasure", function(mail, mailDesInfo, content, formatedStr)
	local strTip = ""
	local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
	local treasureName = atlantisActivityCtrl:getTreasureName(content.treasureType)
	_ENV = nil
	;(nil).kid = content.kid
	;(nil).name = content.nickName
	;(nil).var = treasureName
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Alliance_Escort_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Alliance_Escort_Reward], ("Content_Alliance_Escort_Reward").parseDes = "Content_Alliance_Escort_Reward", function(mail, mailDesInfo, content, formatedStr)
	local resultStr = content.result == 1 and i18n("treasureEscort_text47") or i18n("common_text_291")
	_ENV = nil
	;(nil).result = resultStr
	local strTip = i18n("treasureEscort_text41", nil)
	return strTip
end
_ENV = "Content_Nebula_Region_Group_Complete"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Region_Group_Complete], ("Content_Nebula_Region_Group_Complete").parseDes = "Content_Nebula_Region_Group_Complete", function(mail, mailDesInfo, content, formatedStr)
	local nebulaWarRead = include("nebulaWarRead")
	_ENV = nil
	;(nil).area = nebulaWarRead.getAreaName(content.regionId)
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Supremacy_Road_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Supremacy_Road_Reward], ("Content_Supremacy_Road_Reward").parseDes = "Content_Supremacy_Road_Reward", function(mail, mailDesInfo, content, formatedStr)
	local supremacyRoadCtrl = SoraDGetCtrl("supremacyRoadCtrl")
	local name = supremacyRoadCtrl:getQuestTypeMailName(content.questType)
	_ENV = nil
	;(nil).name = i18n(name)
	;(nil).num = content.stage
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_War_First_Occupy_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_First_Occupy_Reward], ("Content_Nebula_War_First_Occupy_Reward").parseDes = "Content_Nebula_War_First_Occupy_Reward", function(mail, mailDesInfo, content, formatedStr)
	return i18n("nebula_war_text_0560")
end
_ENV = "Content_Gift_Giving_Activity_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Gift_Giving_Activity_Reward], ("Content_Gift_Giving_Activity_Reward").parseDes = "Content_Gift_Giving_Activity_Reward", function(mail, mailDesInfo, content, formatedStr)
	local mergeName = ""
	local hasMe = true
	local myUid = lordInfoCtrl:getLordInfo().uid
	for i, v in ipairs(content.senders) do
		if mergeName ~= "" then
			mergeName = mergeName .. "、"
		end
		if v.fromUid == myUid and not hasMe then
			mergeName = mergeName .. i18n("mail_text_26")
			hasMe = true
		else
			mergeName = mergeName .. mailFunctions:getWrappedName(v.fromAbbr, v.fromName)
		end
	end
	if mergeName and mergeName ~= "" then
		mergeName = string.sub(mergeName, 1, -1)
	end
	lordInfoCtrl = -1
	;(-1).name = mergeName
	dump(i18n(formatedStr, -1), "Fdkfkldkfl")
	lordInfoCtrl = "Fdkfkldkfl"
	;("Fdkfkldkfl").name = mergeName
	local strTip = i18n(formatedStr, "Fdkfkldkfl")
	return strTip
end
_ENV = "Content_Explore_Desert_Meteorite"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Explore_Desert_Meteorite], ("Content_Explore_Desert_Meteorite").parseDes = "Content_Explore_Desert_Meteorite", function(mail, mailDesInfo, content, formatedStr)
	local contentData = mail:getProperty("data")
	local durationTime = SoraDConvertSecondToString(contentData.duration)
	_ENV = nil
	;(nil).time = durationTime
	;(nil).x = contentData.coordinate.x
	;(nil).y = contentData.coordinate.y
	return i18n(formatedStr, nil)
end
_ENV = "Content_Anniversary_2022_End_Notify"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Anniversary_2022_End_Notify], ("Content_Anniversary_2022_End_Notify").parseDes = "Content_Anniversary_2022_End_Notify", function(mail, mailDesInfo, content, formatedStr)
	local strTip = i18n(formatedStr) .. "\n"
	if not content.rankData then
		local _ENV, rankData = content.rankData, content.rankData
	end
	for i, v in ipairs(rankData) do
		local strName = mailFunctions:getWrappedName(v.alliance, v.nickName)
		_ENV = nil
		;(nil).lv = i
		;(nil).name = strName
		strTip = string.format([[
%s
%s]], strTip, i18n("common_text_1763", nil))
	end
	return strTip
end
_ENV = "Content_Football_Champion_Right_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Football_Champion_Right_Reward], ("Content_Football_Champion_Right_Reward").parseDes = "Content_Football_Champion_Right_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var = i18n(include("footballChampionRead").getConfigByIndex(content.matchIndex).question)
	local strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Football_Champion_Mistake_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Football_Champion_Right_Reward]
_ENV = "Content_Nebula_War_First_Occupy_Common_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_First_Occupy_Common_Reward], ("Content_Nebula_War_First_Occupy_Common_Reward").parseDes = "Content_Nebula_War_First_Occupy_Common_Reward", function(mail, mailDesInfo, content, formatedStr)
	return i18n("nebula_war_text_0560")
end
_ENV = "Content_Nebula_War_Occupy_Common_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_Occupy_Common_Rank_Reward], ("Content_Nebula_War_Occupy_Common_Rank_Reward").parseDes = "Content_Nebula_War_Occupy_Common_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).num = content.rank
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Super_Team_kicked"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Super_Team_kicked], ("Content_Super_Team_kicked").parseDes = "Content_Super_Team_kicked", function(mail, mailDesInfo, content, formatedStr)
	local teamDef = include("teamDef")
	local team = teamDef.getTeamName_Nebula(content.abbr)
	_ENV = nil
	;(nil).name = content.name
	;(nil).team = team
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_Camp_Integral_Rank_Reward"
;("Content_Nebula_Camp_Integral_Rank_Reward").parseSummary = function(mail)
	local mailsummary
	local mailDesInfo = mailDesParser.getMailDesInfo(mail)
	if mailDesInfo then
		local content = mail.property.data.content
		local result = content.isWin and i18n("camp_integral_13") or i18n("camp_integral_14")
		if mailDesInfo.summary and mailDesInfo.summary ~= "" then
			mailDesParser = nil
			;(nil).result = result
			mailsummary = i18n(mailDesInfo.summary, nil)
		end
	end
	return mailsummary
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Camp_Integral_Rank_Reward], ("Content_Nebula_Camp_Integral_Rank_Reward").parseDes = "Content_Nebula_Camp_Integral_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local result = content.isWin and i18n("camp_integral_13") or i18n("camp_integral_14")
	_ENV = nil
	;(nil).num = content.round
	;(nil).result = result
	;(nil).rank = content.rank
	local strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Camp_Integral_Participation_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Camp_Integral_Rank_Reward]
_ENV = "Content_Web_Recharge_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Web_Recharge_Reward], ("Content_Web_Recharge_Reward").parseDes = "Content_Web_Recharge_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).num = content.quantity or 1
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Team_kicked"
;("Content_Team_kicked").parseSummary = function(mail)
	local teamAreaEnum = include("teamDef").teamAreaEnum
	local content = mail.property.data.content
	local areaEnum = content.areaEnum
	if areaEnum == teamAreaEnum.NEBULA_EMPEROR then
		return i18n("nebulaemperor_text_163")
	elseif areaEnum == teamAreaEnum.NEBULA_ALL_STAR then
		return i18n("NebulaAllstar_313")
	else
		return mailDesParser.defaultNpcParseSummary(mail)
	end
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Team_kicked], ("Content_Team_kicked").parseDes = "Content_Team_kicked", function(mail, mailDesInfo, content, formatedStr)
	local teamAreaEnum = include("teamDef").teamAreaEnum
	local areaEnum = content.areaEnum
	if areaEnum == teamAreaEnum.NEBULA_EMPEROR then
		_ENV = nil
		;(nil).name = content.name
		return i18n("nebulaemperor_text_164", nil)
	elseif areaEnum == teamAreaEnum.NEBULA_ALL_STAR then
		_ENV = nil
		;(nil).name = content.name
		return i18n("NebulaAllstar_312", nil)
	else
		return mailDesParser.autoNpcParseDes(mail, mailDesInfo, content, formatedStr)
	end
end
_ENV = "Content_RocketRush_Alliance_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RocketRush_Alliance_Rank_Reward], ("Content_RocketRush_Alliance_Rank_Reward").parseDes = "Content_RocketRush_Alliance_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	_ENV = nil
	;(nil).rank = content.rank
	strTip = i18n(mailDesInfo.describe, nil)
	return strTip
end
_ENV = "Content_Nebula_Emperor_Winner"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Emperor_Winner], ("Content_Nebula_Emperor_Winner").parseDes = "Content_Nebula_Emperor_Winner", function(mail, mailDesInfo, content, formatedStr)
	local nebulaWarRead = include("nebulaWarRead")
	local areaName = nebulaWarRead.getAreaName(content.area)
	_ENV = nil
	;(nil).area = areaName
	;(nil).name = content.name
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_Emperor_Title_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Emperor_Title_Appointed], ("Content_Nebula_Emperor_Title_Appointed").parseDes = "Content_Nebula_Emperor_Title_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local nebulaEmperorRead = include("nebulaEmperorRead")
	local officerID = content.title
	local officialName = nebulaEmperorRead.getOfficerName(officerID)
	local privileges = nebulaEmperorRead.getOfficerBuffMailDes(officerID)
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).official = officialName
	;(nil).privileges = privileges
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_Emperor_Title_Canceled"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Emperor_Title_Canceled], ("Content_Nebula_Emperor_Title_Canceled").parseDes = "Content_Nebula_Emperor_Title_Canceled", function(mail, mailDesInfo, content, formatedStr)
	local nebulaEmperorRead = include("nebulaEmperorRead")
	local officerID = content.title
	local officialName = nebulaEmperorRead.getOfficerName(officerID)
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).official = officialName
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_Emperor_RegionTitle_Appointed"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Emperor_RegionTitle_Appointed], ("Content_Nebula_Emperor_RegionTitle_Appointed").parseDes = "Content_Nebula_Emperor_RegionTitle_Appointed", function(mail, mailDesInfo, content, formatedStr)
	local nebulaEmperorRead = include("nebulaEmperorRead")
	local officerID = content.title
	local officialName = nebulaEmperorRead.getOfficerName(officerID)
	local privileges = nebulaEmperorRead.getOfficerBuffMailDes(officerID)
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).official = officialName
	;(nil).privilege = privileges
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_Emperor_Award_Gift"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_Emperor_Award_Gift], ("Content_Nebula_Emperor_Award_Gift").parseDes = "Content_Nebula_Emperor_Award_Gift", function(mail, mailDesInfo, content, formatedStr)
	local nebulaEmperorRead = include("nebulaEmperorRead")
	local giftName = nebulaEmperorRead.getPackageName(content.gift)
	_ENV = nil
	;(nil).name = content.nickName
	;(nil).gift = giftName
	local strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Nebula_War_Score_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_Score_Rank_Reward], ("Content_Nebula_War_Score_Rank_Reward").parseDes = "Content_Nebula_War_Score_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).round = content.round
	;(nil).num = content.rank
	local strTip = i18n(formatedStr, nil)
	return strTip
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_Score_Super_Team_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_Score_Rank_Reward]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_Score_Normal_Team_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_War_Score_Rank_Reward]
_ENV = "Content_NEBULA_EXCHANGE_MALL_Will_End"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_NEBULA_EXCHANGE_MALL_Will_End], ("Content_NEBULA_EXCHANGE_MALL_Will_End").parseTitle = "Content_NEBULA_EXCHANGE_MALL_Will_End", function(mail)
	local content = mail.property.data.content
	local strTip = i18n("activity_name_" .. (content.activityID or 9001391))
	return strTip
end
_ENV = "Content_Common_Activity_End_Reward"
;("Content_Common_Activity_End_Reward").parseTitle = function(mail)
	local mailTitle
	local activityID = mail.property.data.content.activityId
	if activityID then
		local activityTimeRead = include("activityTimeRead")
		mailTitle = activityTimeRead.getActivityShowName(activityID)
	end
	return mailTitle
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Common_Activity_End_Reward], ("Content_Common_Activity_End_Reward").parseDes = "Content_Common_Activity_End_Reward", function(mail, mailDesInfo, content, formatedStr)
	local strTip
	local activityTimeRead = include("activityTimeRead")
	local activityID = content.activityId
	_ENV = nil
	;(nil).name = activityTimeRead.getActivityShowName(activityID)
	strTip = i18n(formatedStr, nil)
	return strTip
end
_ENV = "Content_Team_Be_Commander"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Team_Be_Commander], ("Content_Team_Be_Commander").parseDes = "Content_Team_Be_Commander", function(mail, mailDesInfo, content, formatedStr)
	local nebulaWarRead = include("nebulaWarRead")
	local areaName = nebulaWarRead.getAreaName(content.regionId)
	_ENV = nil
	;(nil).NAME = areaName
	return i18n(formatedStr, nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Team_Be_All_Star_Team_Member] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Team_Be_Commander]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Team_Be_Backup_Group_Team_Member] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Team_Be_Commander]
_ENV = "Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward], ("Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward").parseDes = "Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).NUM = content.num
	return i18n(formatedStr, nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Kill_Score_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Support_Player_Kill_Score_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Rob_Value_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Support_Player_Rob_Value_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Star_Player_Charm_Rank_Reward] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_Nebula_AllStar_War_Camp_Occupy_Rank_Reward]
_ENV = "Content_Data_Palm_Rank_Rewards"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Data_Palm_Rank_Rewards], ("Content_Data_Palm_Rank_Rewards").parseDes = "Content_Data_Palm_Rank_Rewards", function(mail, mailDesInfo, content, formatedStr)
	local activity_9001594_Ctrl = SoraDGetCtrl("activity_9001594_Ctrl")
	local itemName = activity_9001594_Ctrl:getItemName()
	_ENV = nil
	;(nil).num = string.formatnumberthousands(content.count)
	;(nil).item = itemName
	;(nil).rank = content.rank
	return i18n(formatedStr, nil)
end
_ENV = "Content_Lion_Paradise_Rank_Rewards"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Lion_Paradise_Rank_Rewards], ("Content_Lion_Paradise_Rank_Rewards").parseDes = "Content_Lion_Paradise_Rank_Rewards", function(mail, mailDesInfo, content, formatedStr)
	local activity_9001720_Ctrl = SoraDGetCtrl("activity_9001720_Ctrl")
	local itemName = activity_9001720_Ctrl:getItemName()
	_ENV = nil
	;(nil).num = string.formatnumberthousands(content.count)
	;(nil).item = itemName
	;(nil).rank = content.rank
	return i18n(formatedStr, nil)
end
_ENV = "Content_Chat_Anchor_Month_VIP_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Chat_Anchor_Month_VIP_Reward], ("Content_Chat_Anchor_Month_VIP_Reward").parseDes = "Content_Chat_Anchor_Month_VIP_Reward", function(mail, mailDesInfo, content, formatedStr)
	local djRead = include("djRead")
	local cfg = djRead.getMonthLvCfg(content.lv)
	_ENV = nil
	;(nil).lv = i18n(cfg.nameMonth)
	return i18n(formatedStr, nil)
end
_ENV = "Content_Bubble_Grange_Rank_Rewards"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Bubble_Grange_Rank_Rewards], ("Content_Bubble_Grange_Rank_Rewards").parseDes = "Content_Bubble_Grange_Rank_Rewards", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).lv = content.lv
	;(nil).rank = content.rank
	return i18n(formatedStr, nil)
end
_ENV = "Content_Gathering_Feast_2024_Place"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Gathering_Feast_2024_Place], ("Content_Gathering_Feast_2024_Place").parseDes = "Content_Gathering_Feast_2024_Place", function(mail, mailDesInfo, content, formatedStr)
	local name = mailFunctions:getWrappedName(content.allianceAbbr, content.nickName)
	mailFunctions = content.nickName
	content.nickName.var1 = name
	content.nickName.var2 = content.feastLv
	local strTip = i18n(formatedStr, content.nickName)
	return strTip
end
_ENV = "Content_Gathering_Feast_2024_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Gathering_Feast_2024_Reward], ("Content_Gathering_Feast_2024_Reward").parseDes = "Content_Gathering_Feast_2024_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).var1 = content.feastId
	local strTip = i18n("mail_feast_success_text", nil)
	return strTip
end
_ENV = "Content_Corban_Market_Cumulate_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Corban_Market_Cumulate_Reward], ("Content_Corban_Market_Cumulate_Reward").parseDes = "Content_Corban_Market_Cumulate_Reward", function(mail, mailDesInfo, content, formatedStr)
	local activity_9001639_Read = include("activity_9001639_Read")
	local cfg = activity_9001639_Read.getDailyCfgByIndex(content.idx)
	_ENV = nil
	;(nil).gold = content.count or cfg.goldaim
	return i18n(formatedStr, nil)
end
_ENV = "Content_Phoenix_Arrival_Stage_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Phoenix_Arrival_Stage_Reward], ("Content_Phoenix_Arrival_Stage_Reward").parseDes = "Content_Phoenix_Arrival_Stage_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).num = content.score
	;(nil).num1 = content.stage
	return i18n(formatedStr, nil)
end
_ENV = "Content_Bubble_Land_Party_Gift"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Bubble_Land_Party_Gift], ("Content_Bubble_Land_Party_Gift").parseDes = "Content_Bubble_Land_Party_Gift", function(mail, mailDesInfo, content, formatedStr)
	local activity_9001670_Read = include("activity_9001670_Read")
	local giftType = content.giftType
	local giftName = activity_9001670_Read.getGiftName(giftType)
	local itemName = ""
	if not content.extrashow then
		local _ENV, extrashow = content.extrashow, content.extrashow
	end
	if next(extrashow) then
		local itemID = extrashow[1].id
		local itemDesRead = include("itemDesRead")
		itemName = itemDesRead.getName(itemID)
	end
	_ENV = itemDesRead.getName(itemID)
	itemDesRead.getName(itemID).item1 = giftName
	itemDesRead.getName(itemID).item2 = itemName
	return i18n(formatedStr, (itemDesRead.getName(itemID)))
end
_ENV = "Content_Fantasy_Land_Party_Gift"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Fantasy_Land_Party_Gift], ("Content_Fantasy_Land_Party_Gift").parseDes = "Content_Fantasy_Land_Party_Gift", function(mail, mailDesInfo, content, formatedStr)
	local activity_9001717_Read = include("activity_9001717_Read")
	local giftType = content.giftType
	local giftName = activity_9001717_Read.getGiftName(giftType)
	local itemName = ""
	if not content.extrashow then
		local _ENV, extrashow = content.extrashow, content.extrashow
	end
	if next(extrashow) then
		local itemID = extrashow[1].id
		local itemDesRead = include("itemDesRead")
		itemName = itemDesRead.getName(itemID)
	end
	_ENV = itemDesRead.getName(itemID)
	itemDesRead.getName(itemID).item1 = giftName
	itemDesRead.getName(itemID).item2 = itemName
	return i18n(formatedStr, (itemDesRead.getName(itemID)))
end
_ENV = "Content_Snow_Competition_Break_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Snow_Competition_Break_Reward], ("Content_Snow_Competition_Break_Reward").parseDes = "Content_Snow_Competition_Break_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).time = string.format("%s", os.date("!%Y-%m-%d %H:%M:%S", content.gameBeginTime))
	;(nil).distance = content.distance
	return i18n(formatedStr, nil)
end
_ENV = "Content_Sky_Competition_Break_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Sky_Competition_Break_Reward], ("Content_Sky_Competition_Break_Reward").parseDes = "Content_Sky_Competition_Break_Reward", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).time = string.format("%s", os.date("!%Y-%m-%d %H:%M:%S", content.gameBeginTime))
	;(nil).distance = content.distance
	return i18n(formatedStr, nil)
end
_ENV = "Content_RoaringFlameWar_Week_Rank_Camp_Score"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Camp_Score], ("Content_RoaringFlameWar_Week_Rank_Camp_Score").parseDes = "Content_RoaringFlameWar_Week_Rank_Camp_Score", function(mail, mailDesInfo, content, formatedStr)
	local weekTime = content.weekTime
	local timeStr1 = os.date("!%m-%d", weekTime.beginTime)
	local timeStr2 = os.date("!%m-%d", weekTime.endTime)
	local timeStr = timeStr1 .. "~" .. timeStr2
	_ENV = nil
	;(nil).time = timeStr
	;(nil).point = string_fnt(content.score)
	;(nil).num = content.rank
	return i18n(formatedStr, nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Honor] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Camp_Score]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Kill_Score] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Camp_Score]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Phoenix_Damage] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Week_Rank_Camp_Score]
_ENV = "Content_RoaringFlameWar_Season_Rank_Camp_Score"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Score], ("Content_RoaringFlameWar_Season_Rank_Camp_Score").parseDes = "Content_RoaringFlameWar_Season_Rank_Camp_Score", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).point = string_fnt(content.score)
	;(nil).num = content.rank
	return i18n(formatedStr, nil)
end
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Honor] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Score]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Kill_Score] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Score]
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Phoenix_Damage] = mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Score]
_ENV = "Content_RoaringFlameWar_Season_Rank_Camp_Honor"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_Season_Rank_Camp_Honor], ("Content_RoaringFlameWar_Season_Rank_Camp_Honor").parseDes = "Content_RoaringFlameWar_Season_Rank_Camp_Honor", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).val = content.campRank
	;(nil).point = string_fnt(content.score)
	;(nil).num = content.rank
	return i18n(formatedStr, nil)
end
_ENV = "Content_RoaringFlameWar_FirstOccupy_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlameWar_FirstOccupy_Reward], ("Content_RoaringFlameWar_FirstOccupy_Reward").parseDes = "Content_RoaringFlameWar_FirstOccupy_Reward", function(mail, mailDesInfo, content, formatedStr)
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	_ENV = nil
	;(nil).buildId = content.buildId
	local params = roaringFlameWarUtil.getChatSysTextParams(nil)
	local cityStr = params.lv .. params.city .. params.xy
	_ENV = nil
	;(nil).city = cityStr
	return i18n(formatedStr, nil)
end
_ENV = "Content_RoaringFlame_Occupy_Palace"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlame_Occupy_Palace], ("Content_RoaringFlame_Occupy_Palace").parseDes = "Content_RoaringFlame_Occupy_Palace", function(mail, mailDesInfo, content, formatedStr)
	local roaringFlameWarRead = include("roaringFlameWarRead")
	if not content.occupyPalaceRank then
		local _ENV, occupyPalaceRank = content.occupyPalaceRank, content.occupyPalaceRank
	end
	if not occupyPalaceRank[1] then
		local _ENV, first = occupyPalaceRank[1], occupyPalaceRank[1]
	end
	local campName = roaringFlameWarRead.getCampName(first.campId)
	local buildName = roaringFlameWarRead.getBuildNameByBuildId(content.buildId)
	_ENV = nil
	;(nil).camp = campName
	;(nil).city = buildName
	return i18n(formatedStr, nil)
end
_ENV = "Content_RoaringFlame_Phoenix_Damage"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_RoaringFlame_Phoenix_Damage], ("Content_RoaringFlame_Phoenix_Damage").parseDes = "Content_RoaringFlame_Phoenix_Damage", function(mail, mailDesInfo, content, formatedStr)
	_ENV = nil
	;(nil).val = string_fnt(content.damage)
	return i18n(formatedStr, nil)
end
_ENV = "Content_Garden_Farmland_Market_Buy"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Garden_Farmland_Market_Buy], ("Content_Garden_Farmland_Market_Buy").parseDes = "Content_Garden_Farmland_Market_Buy", function(mail, mailDesInfo, content, formatedStr)
	local buyName = publicRead.getName(content.buyId)
	local costName = publicRead.getName(content.costId)
	publicRead = nil
	;(nil).num1 = content.buyCount
	;(nil).name = buyName
	;(nil).num2 = content.costCount
	;(nil).name2 = costName
	return i18n(formatedStr, nil)
end
_ENV = "Content_Garden_Farmland_Market_Sale"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Garden_Farmland_Market_Sale], ("Content_Garden_Farmland_Market_Sale").parseDes = "Content_Garden_Farmland_Market_Sale", function(mail, mailDesInfo, content, formatedStr)
	local saleName = publicRead.getName(content.saleId)
	local getName = publicRead.getName(content.getId)
	publicRead = nil
	;(nil).num = content.saleCount
	;(nil).name = saleName
	;(nil).num2 = content.getCount
	;(nil).name2 = getName
	return i18n(formatedStr, nil)
end
_ENV = "Content_Green_Grass_Flip_Rank_Reward"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Green_Grass_Flip_Rank_Reward], ("Content_Green_Grass_Flip_Rank_Reward").parseDes = "Content_Green_Grass_Flip_Rank_Reward", function(mail, mailDesInfo, content, formatedStr)
	local rank = content.rank
	_ENV = nil
	;(nil).rank = rank
	return i18n(formatedStr, nil)
end
_ENV = "Content_Green_Grass_Predict_Result"
mailDesParser.npcFuncMap[gMailNPCContentType.Content_Green_Grass_Predict_Result], ("Content_Green_Grass_Predict_Result").parseDes = "Content_Green_Grass_Predict_Result", function(mail, mailDesInfo, content, formatedStr)
	local activity_9001734_Read = include("activity_9001734_Read")
	local title = ""
	if tonumber(content.id) == 9999 then
		local titleCfg = activity_9001734_Read.getBetTitleCfg(content.title)
		if titleCfg and titleCfg.betTitle then
			title = i18n(titleCfg.betTitle)
		end
	else
		local config1 = activity_9001734_Read.getCountryCfg(content.team1)
		local config2 = activity_9001734_Read.getCountryCfg(content.team2)
		if config1 and config2 then
			title = i18n(config1.country) .. "VS" .. i18n(config2.country)
		end
	end
	_ENV = i18n(config1.country)
	i18n(config1.country).title = title
	return i18n(formatedStr, (i18n(config1.country)))
end
function mailDesParser.autoParseBasic(key, data)
