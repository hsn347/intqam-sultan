local chatConst = include("chatConst")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local allianceMsg = gametop.playertop_:getModule("allianceMsg")
local _ENV, chatFunctions = gametop.playertop_, gametop.playertop_
chatFunctions.mapWidth = 1200
chatFunctions.mapHeight = 1200
function chatFunctions.ShowPlayerMenu(data)
	local mailFunctions = include("mailFunctions")
	local name = mailFunctions:getWrappedName(data.alliance, data.nickName)
	local menuData, other, coordinates, players
	if data.chatType == gChatTypeUI.escortKingdom or data.chatType == gChatTypeUI.escortAlliance then
		name = i18n("common_text_705")
		_ENV, menuData, players = chatFunctions.getMenuDataForData(data)
		other, chatFunctions.getMenuDataForData(data).players = chatFunctions.getMenuDataForData(data)
	elseif data then
		if chatFunctions.getIsPlayerSelf(data.playerId) then
			_ENV, menuData, coordinates = chatFunctions.getMenuDataForSelf(data)
			chatFunctions.getMenuDataForSelf(data).playerId = data.playerId
			chatFunctions.getMenuDataForSelf(data).nickName = data.nickName
			chatFunctions.getMenuDataForSelf(data).allianceAbbr = data.alliance
			chatFunctions.getMenuDataForSelf(data).allianceId = data.allianceId
			chatFunctions.getMenuDataForSelf(data).content = data.content
			chatFunctions.getMenuDataForSelf(data).coordinates = coordinates
			other, chatFunctions.getMenuDataForSelf(data).kid = chatFunctions.getMenuDataForSelf(data)
		else
			menuData, coordinates = chatFunctions.getMenuDataForData(data)
			if menuData == nil then
				return
			end
		end
		_ENV = chatFunctions.getMenuDataForData(data)
		chatFunctions.getMenuDataForData(data).playerId = data.playerId
		chatFunctions.getMenuDataForData(data).nickName = data.nickName
		chatFunctions.getMenuDataForData(data).allianceAbbr = data.alliance
		chatFunctions.getMenuDataForData(data).allianceId = data.allianceId
		chatFunctions.getMenuDataForData(data).content = data.content
		chatFunctions.getMenuDataForData(data).coordinates = coordinates
		chatFunctions.getMenuDataForData(data).data = data
		chatFunctions.getMenuDataForData(data).chatId = tostring(data)
		chatFunctions.getMenuDataForData(data).customData = data.customData
		chatFunctions.getMenuDataForData(data).avatarUrl = data.avatarUrl
		other, chatFunctions.getMenuDataForData(data).kid = chatFunctions.getMenuDataForData(data)
		print("chatId = ", tostring(data))
	end
	return SoraDShowPlayerOperatePanel(name, menuData, other, nil)
end
function chatFunctions.getIsPlayerSelf(playerId)
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		if lordInfoCtrl:getLordInfo().base.uid == playerId then
			return true
		else
			return false
		end
	end
end
function chatFunctions.getMenuDataForData(data, isSDK)
	dump(data, "chatFunctions.getMenuDataForData(data, isSDK)")
	local chatType = data.chatType
	local dataType = data.dataType
	local textType = data.textType
	if chatType == gChatTypeUI.escortKingdom or chatType == gChatTypeUI.escortAlliance then
		local menuData, players = chatFunctions.getMenuDataForEscortLog(data)
		return menuData, players
	end
	if chatType == gChatTypeUI.allianceMsg then
		local menuData = chatFunctions.getMenuDataForAllianceChat(data, isSDK)
		return menuData
	end
	local _ENV, menuData = menuData, chatFunctions.getMenuDataForAllianceChat(data, isSDK)
	if not isSDK then
		table.insert(menuData, chatConst.OpId.OpViewInfo)
	end
	if data.playerId == 0 then
		return menuData
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curLevel >= CASTLE_LV10_LIMITED and not isSDK then
		table.insert(menuData, chatConst.OpId.OpSendFlower)
	end
	if dataType ~= gChatDataType.dataType_audio and dataType ~= gChatDataType.dataType_emotion then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpCopy)
	end
	print("textType = ", textType, ",data.isSysMsg = ", data.isSysMsg, ", dataType = ", dataType, ", data.isShowTranslate = ", data.isShowTranslate)
	if dataType == 0 and (textType == nil or textType == 0 or textType == gChatTextType.text_plain) and (not data.isSysMsg or data.isSysMsg == 0) then
		if data.isShowTranslate == false or data.isShowTranslate == nil or data.isShowTranslate == 0 then
			print("插入翻译按钮")
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpTranslate)
		else
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpOriginText)
		end
	end
	if dataType == gChatDataType.dataType_fightReport and not isSDK then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpViewBattleReport)
	end
	if isSDK then
		print("dataType = -------", dataType)
		if dataType == gChatDataType.dataType_fightReport or dataType == gChatDataType.dataType_equip_create or dataType == gChatDataType.dataType_rally or dataType == gChatDataType.dataType_pyramid_share or dataType == gChatDataType.dataType_eliminateGame_share or dataType == gChatDataType.dataType_starsWishGame_share or dataType == gChatDataType.dataType_groupbuy_good or dataType == gChatDataType.dataType_pet or dataType == gChatDataType.dataType_hero_share or dataType == gChatDataType.dataType_lengendWar or dataType == gChatDataType.dataType_starking or dataType == gChatDataType.dataType_ancient_treasure or dataType == gChatDataType.dataType_ancient_treasure_rally or dataType == gChatDataType.dataType_hegemonWar or dataType == gChatDataType.dataType_king_of_glory or dataType == gChatDataType.dataType_hero_prison_share then
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpCommonView)
		end
	end
	if data.chatType ~= gChatTypeUI.mail and not isSDK then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpSendEmail)
	end
	local bIsShield = chatFunctions.getIsShield(data.playerId)
	if bIsShield == true then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpUnShield)
	elseif bIsShield == false then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpShield)
	end
	table.insert(menuData, #menuData + 1, chatConst.OpId.OpReport)
	if data.avatarUrl and data.avatarUrl ~= "" then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpReportHeadImg)
	end
	local playerAlliance = allianceMgr:getAlliance()
	if data.allianceId == nil and playerAlliance ~= nil then
		local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
		local ok, err = permissionCtrl:checkPermission(gAPermission.RECRUIT)
		if ok == true then
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpInvite)
			print("权限足够!")
		else
			print("您的权限不足!")
		end
	end
	if data.allianceId ~= nil and data.allianceId ~= 0 and playerAlliance == nil then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpJoin)
	end
	local content = data.content
	local coordinates = SoraDGetCoordinateFromText(content, chatFunctions.mapWidth, chatFunctions.mapHeight)
	if coordinates and 0 < #coordinates and not isSDK then
		for i = 1, #coordinates do
			if 1 < i then
				break
			end
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpCoordinate)
		end
	end
	if chatType == gChatTypeUI.alliance then
		local member = memberMgr:getOwnMember()
		local rank = member:getProperty("rank")
		if rank ~= gAllianceRank.R5 or allianceMsg:isLordInShieldList(data.playerId) then
		else
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpForbidLord)
		end
	end
	_UPVALUE7_ = member
	memberMgr:getOwnMember()[1] = gBubbleId.BUBBLE_ID_NORMAL
	memberMgr:getOwnMember()[2] = gBubbleId.BUBBLE_ID_SYSTEM
	memberMgr:getOwnMember()[3] = gBubbleId.BUBBLE_ID_KING
	memberMgr:getOwnMember()[4] = gBubbleId.BUBBLE_ID_RED_PACKET
	memberMgr:getOwnMember()[5] = gBubbleId.BUBBLE_ID_SUPER_PACKET
	memberMgr:getOwnMember()[6] = gBubbleId.BUBBLE_ID_HORN
	local memberMgr:getOwnMember()[7], checkBubbleTbl = gBubbleId.BUBBLE_ID_LEGEND_KING, memberMgr:getOwnMember()
	local isFiltered = false
	for i, v in ipairs(checkBubbleTbl) do
		if v == data.bubbleId then
			isFiltered = true
		end
	end
	if not isFiltered then
		dump(data.customProperty, "自定义数据-------")
		if data.customProperty and data.customProperty.sysBubbleId and 0 < data.customProperty.sysBubbleId then
			print("data.customProperty.sysBubbleId = ", data.customProperty.sysBubbleId)
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpBuy)
			print("插入了购买按钮")
		end
	end
	print("#menuData", #menuData)
	return menuData, coordinates
end
function chatFunctions.getMenuDataForAllianceChat(data, isSDK)
	local gametop = gModuleMgr.getObject("gametop")
	local targetAllianceId = data.targetAllianceId
	local ownAid = allianceMgr:getOwnAid()
	if ownAid == nil or ownAid ~= targetAllianceId then
		return
	end
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	chatConst = member
	member[1] = chatConst.OpId.OpViewInfo
	member[2] = chatConst.OpId.OpCopy
	local member[3], menuData = chatConst.OpId.OpSendEmail, member
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curLevel >= CASTLE_LV10_LIMITED then
		table.insert(menuData, chatConst.OpId.OpSendFlower)
	end
	if data.allianceId ~= nil and data.allianceId ~= 0 then
		if rank == gAllianceRank.R5 then
			if data.member == true then
				if allianceMsg:isLordInShieldList(data.playerId) then
					table.insert(menuData, #menuData + 1, chatConst.OpId.OpUnShieldThisLord)
				else
					table.insert(menuData, #menuData + 1, chatConst.OpId.OpShieldThisLord)
				end
			else
				if allianceMsg:isAllianceInShieldList(data.allianceId) then
					table.insert(menuData, #menuData + 1, chatConst.OpId.OpUnShieldThisAlliance)
				else
					table.insert(menuData, #menuData + 1, chatConst.OpId.OpShieldThisAlliance)
				end
				if allianceMsg:isLordInShieldList(data.playerId) then
					table.insert(menuData, #menuData + 1, chatConst.OpId.OpUnShieldThisLord)
				else
					table.insert(menuData, #menuData + 1, chatConst.OpId.OpShieldThisLord)
				end
				table.insert(menuData, #menuData + 1, chatConst.OpId.OpViewAlliance)
			end
		end
	elseif rank == gAllianceRank.R5 then
		if allianceMsg:isLordInShieldList(data.playerId) then
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpUnShieldThisLord)
		else
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpShieldThisLord)
		end
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpInvite)
	end
	local content = data.content
	local coordinates = SoraDGetCoordinateFromText(content, chatFunctions.mapWidth, chatFunctions.mapHeight)
	if coordinates and 0 < #coordinates then
		for i = 1, #coordinates do
			if 1 < i then
				break
			end
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpCoordinate)
		end
	end
	table.insert(menuData, #menuData + 1, chatConst.OpId.OpReport)
	table.insert(menuData, 1, chatConst.OpId.OpTranslate)
	return menuData, coordinates
end
function chatFunctions.getMenuDataForEscortLog(data)
	local _ENV, menuData
	local _ENV, players
	local msg = data.serverMsg
	local intelType = msg.data.intelType
	if intelType == gEscortIntelType.ESCORT_WITH_MAX_LEVEL_CART then
		_ENV = nil
		;(nil).uid = msg.data.opPlayer.uid
		;(nil).alliance = msg.data.opPlayer.alliance
		;(nil).nickName = msg.data.opPlayer.nickName
		table.insert(players, #players + 1, nil)
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpViewPlayer)
	elseif intelType == gEscortIntelType.OPEN_ALLIANCE_GAIN_PLUS then
		_ENV = chatConst.OpId.OpViewPlayer
		chatConst.OpId.OpViewPlayer.uid = msg.data.opPlayer.uid
		chatConst.OpId.OpViewPlayer.alliance = msg.data.opPlayer.alliance
		chatConst.OpId.OpViewPlayer.nickName = msg.data.opPlayer.nickName
		table.insert(players, #players + 1, chatConst.OpId.OpViewPlayer)
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpViewPlayer)
	elseif intelType == gEscortIntelType.ESCORT_ROB then
		_ENV = chatConst.OpId.OpViewPlayer
		chatConst.OpId.OpViewPlayer.uid = msg.data.targetPlayers[1].uid
		chatConst.OpId.OpViewPlayer.alliance = msg.data.targetPlayers[1].alliance
		chatConst.OpId.OpViewPlayer.nickName = msg.data.targetPlayers[1].nickName
		table.insert(players, #players + 1, chatConst.OpId.OpViewPlayer)
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpViewPlayer)
		_ENV = chatConst.OpId.OpViewPlayer
		chatConst.OpId.OpViewPlayer.uid = msg.data.opPlayer.uid
		chatConst.OpId.OpViewPlayer.alliance = msg.data.opPlayer.alliance
		chatConst.OpId.OpViewPlayer.nickName = msg.data.opPlayer.nickName
		table.insert(players, #players + 1, chatConst.OpId.OpViewPlayer)
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpViewPlayer)
	end
	return menuData, players
end
function chatFunctions.getIsShield(uid)
	local shieldList = chatCtrl:getAllianceShield()
	if shieldList[tostring(uid)] ~= nil then
		return true
	end
	return false
end
function chatFunctions:getSelfId()
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil then
		return lordInfoCtrl:getLordInfo().base.uid
	end
end
function chatFunctions:getSelfImageId()
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil then
		return lordInfoCtrl:getLordInfo().base.imageId
	end
end
function chatFunctions:getSelfAvatar()
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil then
		return lordInfoCtrl:getLordInfo().base.avatar
	end
end
function chatFunctions:getSelfNickName()
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil then
		return lordInfoCtrl:getLordInfo().base.nickName
	end
end
function chatFunctions:getSelfSourceKID()
	return lordInfoCtrl:getMapSourceKid()
end
function chatFunctions:getIsSameDay(time1, time2)
	local ret = false
	if type(time1) == "string" then
		time1 = 0
	end
	if type(time2) == "string" then
		time2 = 0
	end
	local timeTable1 = os.date("*t", time1)
	local timeTable2 = os.date("*t", time2)
	ret = timeTable1.year == timeTable2.year and timeTable1.month == timeTable2.month and timeTable1.day == timeTable2.day
	return ret
end
function chatFunctions.getMenuDataForSelf(data, isSDK)
	local dataType = data.dataType
	local _ENV, menuData
	if dataType ~= gChatDataType.dataType_audio and dataType ~= gChatDataType.dataType_emotion then
		table.insert(menuData, #menuData + 1, chatConst.OpId.OpCopy)
	end
	if isSDK then
		if dataType == gChatDataType.dataType_fightReport or dataType == gChatDataType.dataType_equip_create or dataType == gChatDataType.dataType_rally or dataType == gChatDataType.dataType_pyramid_share or dataType == gChatDataType.dataType_eliminateGame_share or dataType == gChatDataType.dataType_starsWishGame_share or dataType == gChatDataType.dataType_groupbuy_good or dataType == gChatDataType.dataType_pet or dataType == gChatDataType.dataType_hero_share or dataType == gChatDataType.dataType_lengendWar or dataType == gChatDataType.dataType_starking or dataType == gChatDataType.dataType_ancient_treasure or dataType == gChatDataType.dataType_ancient_treasure_rally or dataType == gChatDataType.dataType_hegemonWar or dataType == gChatDataType.dataType_king_of_glory or dataType == gChatDataType.dataType_hero_prison_share then
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpCommonView)
		end
		return menuData
	end
	local content = data.content
	local coordinates = SoraDGetCoordinateFromText(content, chatFunctions.mapWidth, chatFunctions.mapHeight)
	if coordinates and 0 < #coordinates then
		for i = 1, #coordinates do
			if 1 < i then
				break
			end
			table.insert(menuData, #menuData + 1, chatConst.OpId.OpCoordinate)
		end
	end
	return menuData, coordinates
end
function chatFunctions:getIsRPClaimedAll(redPacketInfo)
	return redPacketInfo.left == 0
end
function chatFunctions:getIsRPExpired(redPacketInfo)
	local ret = true
	if redPacketInfo.isExpired ~= nil then
		ret = redPacketInfo.isExpired
		return ret
	else
		local beginTime = redPacketInfo.begintime
		return self:getIsRPExpiredByTime(beginTime)
	end
end
function chatFunctions:getIsRPExpiredByTime(sendTime)
	local isExpired = false
	local delta = gChatExpired.redPacket
	local time = os.time()
	local beginTime = sendTime
	if type(beginTime) == "string" then
		beginTime = time - delta
	end
	local timeDelta = time - beginTime
	if delta <= timeDelta then
		isExpired = true
	end
	return isExpired
end
function chatFunctions:getIsSelfClaimedRP(redPacketInfo)
	local playerId = self:getSelfId()
	for i, v in ipairs(redPacketInfo.log) do
		if v.uid == playerId then
			return true
		end
	end
	return false
end
function chatFunctions:getIsSelfRPSender(redPacketInfo)
	local playerId = self:getSelfId()
	return self:getIsPlayerRPSender(playerId, redPacketInfo)
end
function chatFunctions:getIsPlayerRPSender(playerId, redPacketInfo)
	local ret = false
	if playerId == redPacketInfo.sender then
		ret = true
	end
	return ret
end
function chatFunctions:isNeedShowDropBoxDetail(redPacketInfo)
	local isClaimedAll = self:getIsRPClaimedAll(redPacketInfo)
	if isClaimedAll then
		return true
	end
	local isExpired = self:getIsRPExpired(redPacketInfo)
	if isExpired then
		return true
	end
	local isSelfClaimed = self:getIsSelfClaimedRP(redPacketInfo)
	if isSelfClaimed then
		return true
	end
	return false
end
function chatFunctions:isNeedShowRedPacketDetail(redPacketInfo)
	local isSelfSender = self:getIsSelfRPSender(redPacketInfo)
	if isSelfSender then
		return true
	end
	local isClaimedAll = self:getIsRPClaimedAll(redPacketInfo)
	if isClaimedAll then
		return true
	end
	local isExpired = self:getIsRPExpired(redPacketInfo)
	if isExpired then
		return true
	end
	local isSelfClaimed = self:getIsSelfClaimedRP(redPacketInfo)
	if isSelfClaimed then
		return true
	end
	return false
end
function chatFunctions:ShowRedPacketTip(text)
	SoraDShowMsgTip(text)
end
function chatFunctions:sendComplain(data)
	dump(data, "投诉内容======")
	local url = gSvrConfig.complainAddr
	local request = network.createHTTPRequest(function(event)
		if event == nil then
			return
		end
		local ok = event.name == "completed"
		local request = event.request
		if not ok then
			print(request:getErrorCode(), request.getErrorMessage ~= nil and request:getErrorMessage() or "")
			return
		end
		local code = request:getResponseStatusCode()
		if code ~= 200 then
			print(code)
			return
		end
		local response = request:getResponseString()
		print("response", response)
	end, url, "POST")
	local userid = self:getSelfId()
	local gameName = SoraDGetPackageName()
	local usercenterid = userSDKManager.userid
	local createtime = tostring(os.time())
	print("ganemName = ", gameName, ", usercenterid = ", usercenterid, ", createtime = ", createtime)
	request:addPOSTValue("game", gameName)
	request:addPOSTValue("complainid", data.complainid)
	request:addPOSTValue("bycomplainid", data.bycomplainid)
	request:addPOSTValue("message", data.message)
	request:addPOSTValue("serverid", data.serverid)
	request:addPOSTValue("usercenterid", userSDKManager.userid)
	request:addPOSTValue("deviceid", userSDKManager.deviceId or "")
	request:addPOSTValue("createtime", tostring(os.time()))
	if data.messagetime then
		request:addPOSTValue("messagetime", tostring(data.messagetime))
	end
	_ENV = request
	request.name = data.targetName
	local value = json.encode(request)
	request:addPOSTValue("other", value)
	local appid = userSDKManager.isAR() and "100000601" or "100000611"
	print("appid", appid)
	request:addPOSTValue("appid", appid)
	if data.reportReason then
		request:addPOSTValue("type", data.reportReason)
		print("添加了type字段------", data.reportReason)
	end
	if data.complaintype then
		request:addPOSTValue("complaintype", data.complaintype)
		print("添加了 complaintype ---", data.complaintype)
	end
	local md5Sign = crypto.md5(createtime .. gChatComplainKey, false)
	request:addPOSTValue("sign", md5Sign)
	print("sign = ", md5Sign)
	request:start()
end
function chatFunctions:getIsSelfKing()
	local isKing = worldMapDefine.kingdomStatus == gKingStatus.king
	if isKing == true then
		return isKing
	end
	local tablePlayerInfo = lordInfoCtrl:getLordInfo()
	if tablePlayerInfo.official == gKingOfficialType.king then
		isKing = true
	end
	return isKing
end
function chatFunctions:getIsSelfLegendKing()
	local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
	return legendLordCtrl:getIsSelfLegendKing()
end
function chatFunctions:getIsSelfKingStar()
	local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
	return kingStarCtrl:getIsSelfLegendKing()
end
function chatFunctions:getIsSelfHegemon()
	local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
	return hegemonCtrl:getIsSelfHegemon()
end
function chatFunctions:getMenuName(id, other, index)
	local chatConst = include("chatConst")
	local btnName = ""
	local opCfg = chatConst.OpConfig[tostring(id)]
	if opCfg then
		btnName = opCfg.des
		if not opCfg.isCustom then
			btnName = i18n(opCfg.des)
			return btnName
		end
		if opCfg.isCustom then
			if id == chatConst.OpId.OpViewPlayer then
				if other and other.players and other.players[index] then
					local name = mailFunctions:getWrappedName(other.players[index].alliance, other.players[index].nickName)
					btnName = name
				end
			elseif id == chatConst.OpId.OpCoordinate and other and other.coordinates and other.coordinates[index] then
				_ENV = other.players[index].alliance
				other.players[index].alliance.x = other.coordinates[index].x
				other.players[index].alliance.y = other.coordinates[index].y
				btnName = i18n("common_text_465", other.players[index].alliance)
			end
		end
	end
	return btnName
end
function chatFunctions.getMenuDataForSDK(data)
	local chatFunctions, menuData
	if chatFunctions.getIsPlayerSelf(data.playerId) then
		menuData = chatFunctions.getMenuDataForSelf(data, true)
	else
		menuData = chatFunctions.getMenuDataForData(data, true)
	end
	return menuData
end
function chatFunctions.getSelfDefaultBubbleId(theme)
	local ret = gBubbleId.BUBBLE_ID_SELF
	if theme == gChatTheme.dark then
		ret = gBubbleId.BUBBLE_ID_SELF_NIGHT
	end
	return ret
end
function chatFunctions.getOtherDefaultBubbleId(theme)
	local ret = gBubbleId.BUBBLE_ID_OTHER
	if theme == gChatTheme.dark then
		ret = gBubbleId.BUBBLE_ID_OTHER_NIGHT
	end
	return ret
end
function chatFunctions.getShowBubbleId(param)
	local data = param.data
	local checkRes = param.checkRes
	local theme = param.theme or gCurrentChatTheme
	local playerId = data.playerId
	local bubbleId = data.bubbleId
	local direction = data.direction
	local ret = gBubbleId.BUBBLE_ID_SELF
	if gBubbleIsNoraml[bubbleId] then
		print("这是普通的bubbleId, theme = ", theme)
		if chatFunctions.getIsPlayerSelf(playerId) then
			ret = chatFunctions.getSelfDefaultBubbleId(theme)
			print("是自己----, id = ", ret)
		else
			ret = chatFunctions.getOtherDefaultBubbleId(theme)
		end
		return ret
	elseif gBubbleIsSystem[bubbleId] then
		if theme == gChatTheme.normal then
			ret = gBubbleId.BUBBLE_ID_SYSTEM
		else
			ret = gBubbleId.BUBBLE_ID_SYSTEM_NIGHT
		end
		return ret
	elseif gBubbleIdNoCheck[bubbleId] then
		ret = bubbleId
		return ret
	else
		if not checkRes then
			ret = bubbleId
			return ret
		end
		local chatResMgr = gChatMgrs:getMgr("chatResMgr")
		local chatSkinRead = include("chatSkinRead")
		local cfg = chatSkinRead.getBubbleCfg(bubbleId)
		if not cfg then
			if chatFunctions.getIsPlayerSelf(playerId) then
				ret = chatFunctions.getSelfDefaultBubbleId(theme)
			else
				ret = chatFunctions.getOtherDefaultBubbleId(theme)
			end
			return ret
		end
		if cfg.resType == gChatResType.localType then
			return bubbleId
		end
		local resKey = cfg.rightbg
		if direction == gChatDirection.left and cfg.leftbg ~= "" then
			resKey = cfg.leftbg
		end
		local hasRes = chatResMgr:hasRes(resKey)
		if hasRes then
			ret = bubbleId
			return ret
		else
			if chatFunctions.getIsPlayerSelf(playerId) then
				ret = chatFunctions.getSelfDefaultBubbleId(theme)
			else
				ret = chatFunctions.getOtherDefaultBubbleId(theme)
			end
			chatResMgr:addFileListener(data, resKey, gChatFileType.bubble)
			return ret, resKey
		end
	end
end
function chatFunctions.getBubbleKey(bubbleId, direction)
end
function chatFunctions.getShowAvatarFrameId(param)
	local data = param.data
	local avatarFrameId = data.avatarFrameId
	if not param.checkRes then
		return avatarFrameId
	end
	local chatResMgr = gChatMgrs:getMgr("chatResMgr")
	local chatSkinRead = include("chatSkinRead")
	local cfg = chatSkinRead.getAvatarFrameCfg(avatarFrameId)
	if cfg.resType == gChatResType.localType then
		return avatarFrameId
	end
	local resKey = cfg.img
	chatResMgr:hasRes(resKey)
	chatResMgr:addFileListener(param.data, resKey, gChatFileType.avatarframe)
	return avatarFrameId
end
function chatFunctions.getShowHeadWearId(param)
	local data = param.data
	local headWearId = data.headWearId
	if not param.checkRes then
		return headWearId
	end
	local chatResMgr = gChatMgrs:getMgr("chatResMgr")
	local chatSkinRead = include("chatSkinRead")
	local cfg = chatSkinRead.getHeadWearCfg(headWearId)
	if cfg.resType == gChatResType.localType then
		return headWearId
	end
	local resKey = cfg.img
	chatResMgr:hasRes(resKey)
	chatResMgr:addFileListener(param.data, resKey, gChatFileType.headwear)
	return headWearId
end
function chatFunctions:getNpcName(npcId)
	return i18n("mail_text_26")
end
function chatFunctions:getNpcHead(npcId)
	return "icon_mail_guidenpc.png"
end
function chatFunctions:getChatMailKey(target, chatChannel)
	local key
	if chatChannel == gChatChannel.MAIL then
		key = gMailType.CHAT .. "@" .. target
	elseif chatChannel == gChatChannel.CHATROOM then
		key = "room" .. "@" .. target
	end
	return key
end
function chatFunctions.getReplySummary(replyMsg)
	if not replyMsg then
		return ""
	end
	if replyMsg.contentType == gChatTypeDef.chat_content_expression then
		return i18n("common_text_4963")
	end
	if not replyMsg.refContent then
		local _ENV, refContent = replyMsg.refContent, replyMsg.refContent
	end
	local text = refContent.text or ""
	local textType = refContent.textType
	if text ~= "" and (textType == gChatTextType.text_auto or textType == gChatTextType.text_id) then
		if not refContent.values then
			_ENV = refContent.values
		end
		text = i18n(text, refContent.values)
	end
	return SoraDStripHtmlTags(text)
end
function chatFunctions.getReplyDisplayText(replyMsg)
	if not replyMsg then
		return ""
	end
	_ENV = nil
	;(nil).name = _p(replyMsg.nickName or "")
	;(nil).text = _p(chatFunctions.getReplySummary(replyMsg))
	return i18n("common_text_4962", nil)
end
function chatFunctions.buildReplyMsgFromChatData(message)
	if not message then
		return nil
	end
	local dataType = message.dataType
	if dataType ~= gChatDataType.dataType_text and dataType ~= gChatDataType.dataType_emotion then
		return nil
	end
	local msgID = message.chatId
	if not msgID then
		return nil
	end
	local nickName = message.nickName or ""
	local contentType, refContent
	if dataType == gChatDataType.dataType_emotion then
		_ENV, contentType = gChatTypeDef, gChatTypeDef.chat_content_expression
		gChatTypeDef.text = not message.emoticonId and message.customData and message.customData.emoticonId
		gChatTypeDef.packetId = not message.packetId and message.customData and message.customData.packetId
		gChatTypeDef.width = message.customData and message.customData.width
		refContent, gChatTypeDef.height = gChatTypeDef, message.customData and message.customData.height
	else
		contentType = gChatTypeDef.chat_content_text
		local displayText = message.content or ""
		if displayText == "" and message.text then
			displayText = message.text
		end
		displayText = SoraDStripHtmlTags(displayText or "")
		local serverContent = message.serverMsg and message.serverMsg.content
		if displayText == "" and type(serverContent) == "table" then
			local rawText = serverContent.text or ""
			local textType = serverContent.textType or gChatTextType.text_plain
			if textType == gChatTextType.text_auto or textType == gChatTextType.text_id then
				if not serverContent.values then
					_ENV = serverContent.values
				end
				displayText = i18n(rawText, serverContent.values)
			else
				displayText = rawText
			end
			displayText = SoraDStripHtmlTags(displayText or "")
		end
		_ENV = rawText
		;("").text = displayText
		refContent, ("").textType = "", gChatTextType.text_plain
	end
	_ENV = displayText
	SoraDStripHtmlTags(displayText or "").msgID = msgID
	SoraDStripHtmlTags(displayText or "").nickName = nickName
	SoraDStripHtmlTags(displayText or "").contentType = contentType
	SoraDStripHtmlTags(displayText or "").refContent = refContent
	return (SoraDStripHtmlTags(displayText or ""))
end
function chatFunctions.navigateToReplyMsg(chatChannel, chatSet, key, msgID)
	if not msgID then
		return
	end
	local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	local chatSetType = chatSet or gChatSet.TOTAL
	local isExist = chatDataMgr:hasExistData(chatChannel, chatSetType, key, msgID)
	if isExist then
		_ENV = chatChannel
		chatChannel.msg = "MESSAGE_CHAT_NAVIGATE_REPLY_MSG"
		chatChannel.chatChannel = chatChannel
		chatChannel.chatSet = chatSetType
		chatChannel.key = key
		chatChannel.msgID = msgID
		SoraDSendMessage(chatChannel)
		return
	end
end
return chatFunctions
