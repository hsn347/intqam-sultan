local chatBaseMgr = include("chatBaseMgr")
local chatMenuHandlerMgr = class("chatMenuHandlerMgr", chatBaseMgr)
local chatConst = include("chatConst")
local condParser = include("condParser")
local chatConst = include("chatConst")
function chatMenuHandlerMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatMsgMgr = gChatMgrs:getMgr("chatMsgMgr")
	self.chatTranslateMgr = gChatMgrs:getMgr("chatTranslateMgr")
	self:reset()
end
function chatMenuHandlerMgr:reset()
end
function chatMenuHandlerMgr:clean()
	self:reset()
end
function chatMenuHandlerMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatMenuHandlerMgr:registerMessageListener()
	self:removeMessageListener()
end
function chatMenuHandlerMgr:onMenuClick(target, opId, data)
	local f = chatMenuHandlerMgr.menuHandlerList[tostring(opId)]
	if f then
		f(self, target, opId, data)
	else
		print("聊天菜单对应的方法未对应--------- onMenuClick: opId = ", opId)
	end
end
function chatMenuHandlerMgr:onMenuCommonView(target, opId, data)
	local message = data.customData
	print("chatMenuHandlerMgr:onMenuCommonView", message.dataType)
	local f = chatMenuHandlerMgr.commonViewHandlerList[message.dataType]
	if f then
		f(self, target, opId, data)
	else
		print("聊天菜单对应的方法未对应--------- onMenuCommonView: opId = ", opId)
	end
end
function chatMenuHandlerMgr:onMenuCopy(target, opId, data)
	local message = data.customData
	SoraDCopyText(message.content)
end
function chatMenuHandlerMgr:onMenuQuote(target, opId, data)
	local message = data.customData
	local chatFunctions = include("chatFunctions")
	local replyMsg = chatFunctions.buildReplyMsgFromChatData(message)
	if not replyMsg then
		return
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_SET_REPLY_MSG"
	;(nil).replyMsg = replyMsg
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuOrigin(target, opId, data)
	print("显示原文=================")
	local message = data.customData
	if message and message.itemNode then
		_ENV = nil
		;(nil).isAutoTranslate = false
		self.chatTranslateMgr:toggleTranslate(message, nil)
		if message.chatChannel == gChatChannel.TEAMMSG then
			local translateCtrl = SoraDGetCtrl("translateCtrl")
			translateCtrl:setIsShowTranslate(message.key, message.chatId, false)
		end
		_UPVALUE1_ = translateCtrl
		local SoraDGetCtrl("translateCtrl")[1], translationList = message.translation, SoraDGetCtrl("translateCtrl")
		local isAutoTranslate = false
		local chatChannel = message.chatChannel
		local chatSet = gChatSet.TOTAL
		_ENV = false
		;(false).msg = "MESSAGE_CHAT_TRANSLATION_CHANGED"
		;(false).chatChannel = chatChannel
		;(false).chatSet = chatSet
		;(false).translationList = translationList
		;(false).isAutoTranslate = isAutoTranslate
		SoraDSendMessage(false)
	end
end
function chatMenuHandlerMgr:onMenuTranslate(target, opId, data)
	local message = data.customData
	if message and message.itemNode then
		if message.chatChannel == gChatChannel.TEAMMSG then
			local translateCtrl = SoraDGetCtrl("translateCtrl")
			translateCtrl:setIsShowTranslate(message.key, message.chatId, true)
		end
		_ENV = message.key
		message.key.isAutoTranslate = false
		local canShowTranslation = self.chatTranslateMgr:canShowTranslation(message.translation, message.key)
		print("canShowTranslation = ", canShowTranslation)
		if canShowTranslation then
			_ENV = message.chatId
			message.chatId.isAutoTranslate = false
			self.chatTranslateMgr:toggleTranslate(message, message.chatId)
			_UPVALUE1_ = self.chatTranslateMgr.toggleTranslate
			local self.chatTranslateMgr.toggleTranslate[1], translationList = message.translation, self.chatTranslateMgr.toggleTranslate
			local chatChannel = message.chatChannel
			local chatSet = gChatSet.TOTAL
			_ENV = true
			;(true).msg = "MESSAGE_CHAT_TRANSLATION_CHANGED"
			;(true).chatChannel = chatChannel
			;(true).chatSet = chatSet
			;(true).key = message.key
			;(true).translationList = translationList
			;(true).isAutoTranslate = isAutoTranslate
			SoraDSendMessage(true)
		else
			local chatChannel = message.chatChannel
			local from = gChatChannel2From[chatChannel]
			local dataKey = message.key
			local isAutoTransalte = false
			_ENV = nil
			_UPVALUE1_, (nil).from = nil, from
			;(nil).dataItemList, (nil)[1] = nil, message
			;(nil).isAutoTransalte = isAutoTransalte
			;(nil).dataKey = dataKey
			self.chatTranslateMgr:reqTranslate(nil)
		end
	end
end
function chatMenuHandlerMgr:onMenuJoin(target, opId, data)
	local message = data.customData
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceId = message.allianceId
	local alliance = allianceMgr:getAlliance()
	if alliance == nil then
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		if allianceId == nil then
			return
		end
		_ENV = nil
		_ENV, (nil).aid = nil, allianceId
		;(nil).from = "chat"
		allianceQuery:reqAllianceByID(nil, nil)
	else
		print("您已经有联盟了!!")
	end
end
function chatMenuHandlerMgr:onMenuInvite(target, opId, data)
	local message = data.customData
	local playerId = message.playerId
	local kid = message.kid
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	local ok, err = permissionCtrl:checkPermission(gAPermission.RECRUIT)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceDesRead = include("allianceDesRead")
	if ok == true and kid ~= nil and kid ~= gametop.playertop_:getKingdomID() then
		SoraDShowMsgTip(i18n("common_text_2168"))
		return
	end
	if ok == true and not allianceDesRead.getPlayerConquestWarMigration() and not allianceDesRead.getPlayerBattleGroundMigration() then
		SoraDShowMsgBox(i18n("common_text_2301"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				allianceMgr:reqInviteJoin(playerId)
			end
		end)
	else
	end
end
function chatMenuHandlerMgr:onMenuShield(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_SHIELD_USER"
	;(nil).playerId = message.playerId
	;(nil).nickName = message.nickName
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuUnShield(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_UNSHIELD_USER"
	;(nil).playerId = message.playerId
	;(nil).nickName = message.nickName
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuForbidLord(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_FORBID_LORD"
	_ENV, (nil).opType = gAShieldListOperate.add, gAShieldListOperate.add
	;(nil).opList, gAShieldListOperate.add.uid = gAShieldListOperate.add, message.playerId
	;(nil).nickName = message.nickName
	;(nil).abbr = message.allianceAbbr
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuReport(target, opId, data)
	dump(data, "sssss", 10)
	local gametop = gModuleMgr.getObject("gametop")
	local chatFunctions = include("chatFunctions")
	local message = data.customData
	local chatId = message.chatId
	local playerId = message.playerId
	local content = message.content
	if message.data and message.data.dataType == gChatDataType.dataType_audio then
		content = message.data.customData.audioId
	end
	_ENV = message.data.customData
	message.data.customData.complainid = chatFunctions:getSelfId()
	message.data.customData.bycomplainid = playerId
	message.data.customData.message = content
	message.data.customData.serverid = gametop.playertop_:getKingdomID()
	message.data.customData.chatChannel = message.chatChannel
	message.data.customData.targetName = message.nickName
	local message.data.customData.messagetime, complainData = message.date, message.data.customData
	dump(complainData, "complainData", 10)
	_ENV = 10
	;(10).data = complainData
	;(10).chatId = chatId
	uiManager:show("chatReportView", 10)
end
function chatMenuHandlerMgr:onMenuReportHeadImg(target, opId, data)
	local message = data.customData
	local curl = message.avatarUrl
	local playerID = message.playerId
	SoraDReportHeadImg(playerID, curl)
end
function chatMenuHandlerMgr:onMenuBuy(target, opId, data)
	local message = data.customData
	local bubbleId = 0
	if message.customProperty and message.customProperty.sysBubbleId then
		bubbleId = message.customProperty.sysBubbleId
	end
	print("bubbleId = ", bubbleId)
	local gotoBuyBubble = function(bubbleId)
		SoraDRemoveAllPanelFromManager()
		local xOffset = display.size.width * 0.5
		xOffset = xOffset + 60
		local showCastleChangeView = function()
			_ENV = nil
			;(nil).dressID = bubbleId
			uiManager:show("castleChangeView", nil)
		end
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		local scale = 0.4
		if currentView.__cname == "worldMapView" then
			_ENV = currentView.__cname
			currentView.__cname.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			currentView.__cname.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			currentView.__cname.scale = scale
			currentView.__cname.xOffset = xOffset
			currentView.__cname.yOffset = display.rheight - 375
			currentView.__cname.buildIndex = 1050
			currentView.__cname.noOffsetDuration = true
			currentView.__cname.noScaleDuration = true
			currentView.__cname.handle = showCastleChangeView
			local currentView.__cname.delay, data = 0.5, currentView.__cname
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			;(nil).otherData = data
			SoraDSendMessage(nil)
		else
			showCastleChangeView()
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			SoraDSendMessage.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			SoraDSendMessage.scale = scale
			SoraDSendMessage.xOffset = xOffset
			SoraDSendMessage.yOffset = display.rheight - 375
			SoraDSendMessage.buildIndex = 1050
			SoraDSendMessage.noOffsetDuration = true
			SoraDSendMessage.noScaleDuration = true
			SoraDSendMessage(SoraDSendMessage)
		end
	end
	SoraDDelayCallOnce("onMenuBuy", function()
		gotoBuyBubble(bubbleId)
	end)
end
function chatMenuHandlerMgr:onMenuShieldThisAlliance(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, (nil).opType = gAShieldListOperate.add, gAShieldListOperate.add
	;(nil).opList, gAShieldListOperate.add.aid = gAShieldListOperate.add, message.allianceId
	;(nil).nickName = message.nickName
	;(nil).abbr = message.alliance
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuUnShieldThisAlliance(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, (nil).opType = gAShieldListOperate.del, gAShieldListOperate.del
	;(nil).opList, gAShieldListOperate.del.aid = gAShieldListOperate.del, message.allianceId
	;(nil).nickName = message.nickName
	;(nil).abbr = message.alliance
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuShieldThisLord(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, (nil).opType = gAShieldListOperate.add, gAShieldListOperate.add
	;(nil).opList, gAShieldListOperate.add.uid = gAShieldListOperate.add, message.playerId
	;(nil).nickName = message.nickName
	;(nil).abbr = message.alliance
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuUnShieldThisLord(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, (nil).opType = gAShieldListOperate.del, gAShieldListOperate.del
	;(nil).opList, gAShieldListOperate.del.uid = gAShieldListOperate.del, message.playerId
	;(nil).nickName = message.nickName
	;(nil).abbr = message.alliance
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuDeleteMsg(target, opId, data)
	local message = data.customData
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	;(nil).opId = opId
	;(nil).msgID = message.chatId
	SoraDSendMessage(nil)
end
function chatMenuHandlerMgr:onMenuCommonView_equip(target, opId, data)
	local message = data.customData
	local customData = message.customData
	_ENV = nil
	;(nil).isOnlyShow = true
	;(nil).singleData = customData
	uiManager:show("storageBoxInfoView", nil)
end
function chatMenuHandlerMgr:onMenuCommonView_sharePos(target, opId, data)
	local message = data.customData
	local customData = message.customData
	local posX, posY = 1, 1
	local mapId = 1
	if customData.values and customData.values.x and customData.values.y then
		posX, posY = customData.values.x, customData.values.y
		mapId = customData.values.mapId
	else
		posX, posY = customData.data.content.x, customData.data.content.y
		mapId = customData.data.content.mapId
	end
	if mapId and worldMapDefine.isGardenKingdomID(mapId) then
		local manorCityUtil = include("manorCityUtil")
		manorCityUtil.gotoGardenWar(cc.p(posX, posY), true)
		return
	end
	_ENV = manorCityUtil.gotoGardenWar
	manorCityUtil.gotoGardenWar.x = posX
	manorCityUtil.gotoGardenWar.y = posY
	SoraDGotoWorldMapPoint(manorCityUtil.gotoGardenWar, true, mapId)
	SoraDRemoveAllPanelFromManager()
end
function chatMenuHandlerMgr:onMenuCommonView_fightReport(target, opId, data)
	local message = data.customData
	local customData = message.customData
	dump(customData, "customData")
	if customData.mid then
		local mailFunctions = include("mailFunctions")
		SoraDShowLoading()
		mailFunctions:doRequestMailReport(customData.mid, false, message.playerId)
	end
end
function chatMenuHandlerMgr:onMenuCommonView_pyramid_share(target, opId, data)
	local castleLV = SoraDGetCastleLv()
	if tonumber(castleLV) < CASTLE_LV8_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV8_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	else
		uiManager:show("pyramidMain")
	end
end
function chatMenuHandlerMgr:onMenuCommonView_eliminateGame_share(target, opId, data)
end
function chatMenuHandlerMgr:onMenuCommonView_starsWishGame_share(target, opId, data)
	include("starsWishingGameCommon").enterGame()
end
function chatMenuHandlerMgr:onMenuCommonView_rally(target, opId, data)
	local message = data.customData
	local queueId = message.customData.queueId
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local hasQueue = kingdomMapCtrl.kingdomMapCell:isHasWarHallQueues(queueId)
	if not hasQueue then
		if data.customData.customData.values.mapId ~= gametop.playertop_:getMapID() then
			SoraDShowMsgTip(i18n("worldwar_text_17"))
		else
			SoraDShowMsgTip(i18n("assembled_text_01"))
		end
		return
	end
	local allianceCtrl = SoraDGetCtrl("allianceCtrl")
	local allianceWarListRallyMgr = allianceCtrl:getAllianceWarListRallyMgr(queueId)
	allianceWarListRallyMgr:onPlusClick()
end
function chatMenuHandlerMgr:onMenuCommonView_groupbuy_good(target, opId, data)
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_4479"))
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GROUP_BUY) then
		SoraDCreatePanel("groupBuyView"):show()
	end
end
function chatMenuHandlerMgr:onMenuCommonView_pet(target, opId, data)
	local message = data.customData
	local customData = message.customData
	if customData.values.petid then
		local petDesRead = include("petDesRead")
		local petCfg = petDesRead.getPetCfg(customData.values.petid, customData.values.rank)
		if not petCfg then
			_ENV = nil
			;(nil).des = i18n("common_text_2975")
			SoraDShowMsgTip(i18n("common_text_1437", nil))
			return
		end
		_ENV = i18n("common_text_1437", nil)
		i18n("common_text_1437", nil).petData = customData.values
		uiManager:show("PetShareView", i18n("common_text_1437", nil))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_feast_share(target, opId, data)
	local message = data.customData
	local customData = message.customData
	if customData.values.pos.x and customData.values.pos.y then
		if worldMapDefine.inInCrossWar() then
			SoraDShowMsgTip(i18n("tips_feast_across_limit"))
			return
		end
		print("slkdfjlskdjflskd", customData.values.pos.x, customData.values.pos.y)
		_ENV = "slkdfjlskdjflskd"
		;("slkdfjlskdjflskd").x = customData.values.pos.x - 1
		;("slkdfjlskdjflskd").y = customData.values.pos.y - 1
		SoraDGotoWorldMapPoint("slkdfjlskdjflskd", true)
		SoraDRemoveAllPanelFromManager()
	end
end
function chatMenuHandlerMgr:onMenuCommonView_hero_share(target, opId, data)
	dump(data, "chatMenuHandlerMgr:onMenuCommonView_hero_share", 10)
	local message = data.customData
	local customData = message.customData
	if not customData.values and customData.data and customData.data.content then
		customData = customData.data.content
	end
	if customData.values and customData.values.heroID then
		_ENV = nil
		;(nil).heroID = customData.values.heroID
		;(nil).quality = customData.values.quality
		;(nil).level = customData.values.level
		;(nil).dressID = customData.values.dressID
		uiManager:show("HeroIntroduction", nil)
	end
end
function chatMenuHandlerMgr:onMenuCommonView_arms_share(target, opId, data)
	local message = data.customData
	local customData = message.customData
	if customData.values.armsID then
		uiManager:show("ArtifactShare", customData.values)
	end
end
function chatMenuHandlerMgr:onMenuCommonView_share_voice_room(target, opId, data)
	print("TODOHLP:打开语音室")
	local message = data.customData
	local customData = message.customData
	local roomID = customData.roomId
	VoiceChatSDKManager.openView()
end
function chatMenuHandlerMgr:onMenuCommonView_allianceTreasure(target, opId, data)
	if worldMapDefine.isInWarForbid(false, true) then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
	local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
	if isInConquestWar then
		SoraDShowMsgTip(i18n("common_text_4264"))
	elseif tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE then
		if GLOBAL_GAME_ALLIANCE_MODE then
			_ENV = i18n("common_text_4264")
			i18n("common_text_4264").tag = 3
			uiManager:show("allianceStoreHouseView", i18n("common_text_4264"))
		else
			local panel = SoraDCreatePanel("allianceStoreHouseView")
			panel:gotoBtn(3)
			panel:show()
		end
	else
		SoraDShowMsgTip(i18n("allitreas_text_03"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_lengendWar(target, opId, data)
	local gotoLegend = function()
		SoraDRemoveAllPanelFromManager()
		SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
	end
	SoraDDelayCallOnce("onMenuCommonView_lengendWar", function()
		gotoLegend()
	end)
end
function chatMenuHandlerMgr:onMenuCommonView_starking(target, opId, data)
	local mapId = worldMapDefine.KINGSTAR_KINGDOM_ID
	if data.customData and data.customData.customData and data.customData.customData.values and data.customData.customData.values.mapId then
		mapId = data.customData.customData.values.mapId
	end
	local gotoLegend = function()
		SoraDRemoveAllPanelFromManager()
		SoraDGotoWorldMapPoint(cc.p(150, 150), false, mapId)
	end
	SoraDDelayCallOnce("onMenuCommonView_starking", function()
		gotoLegend()
	end)
end
function chatMenuHandlerMgr:onMenuCommonView_hegemonWar(target, opId, data)
	local message = data.customData
	local customData = message.customData
	local gotoHegemon = function()
		SoraDRemoveAllPanelFromManager()
		local hegemonRead = include("hegemonRead")
		local coordinate = hegemonRead.getBuildCoordinateByType(customData.values.subMapType)
		SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
	end
	SoraDDelayCallOnce("onMenuCommonView_lengendWar", function()
		gotoHegemon()
	end)
end
function chatMenuHandlerMgr:onMenuCommonView_open_escort_buff_alliance(target, opId, data)
	local gotoEscort = function()
		worldMapFunction.GotoEscort(function()
			SoraDRemoveAllPanelFromManager()
		end)
	end
	SoraDDelayCallOnce("onMenuCommonView_open_escort_buff_alliance", function()
		gotoEscort()
	end)
end
function chatMenuHandlerMgr:onMenuCommonView_alliance_beast(target, opId, data)
	local gotoAllianceBeast = function()
		local allianceTerritoryAPI = include("allianceTerritoryAPI")
		local pos = allianceTerritoryAPI:getMainBuildingPos(gAllianceBuilding.ALTAR)
		local var = data.customData.customData.values
		if worldMapDefine.inInCrossWar() then
			SoraDShowMsgTip(i18n("common_text_4479"))
		elseif pos and next(pos) then
			SoraDGotoWorldMapPoint(pos, true, var.mapId)
			SoraDRemoveAllPanelFromManager()
		else
			SoraDShowMsgTip(i18n("alliance_beast_notice_04"))
		end
	end
	SoraDDelayCallOnce("onMenuCommonView_alliance_beast", function()
		gotoAllianceBeast()
	end)
end
function chatMenuHandlerMgr:onMenuCommonView_remains_war_team_invite(target, opId, data)
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_4479"))
	else
		local remainsWarUtil = include("remainsWarUtil")
		local message = data.customData
		local customData = message.customData
		remainsWarUtil.doAllianceInvite(customData.values, true)
	end
end
function chatMenuHandlerMgr:onMenuCommonView_remains_war_share_settle_info(target, opId, data)
	local remainsWarUtil = include("remainsWarUtil")
	local message = data.customData
	local customData = message.customData
	remainsWarUtil.doOpenShareSettleInfo(customData)
end
function chatMenuHandlerMgr:onMenuCommonView_remains_war_share_season_info(target, opId, data)
	local remainsWarUtil = include("remainsWarUtil")
	local message = data.customData
	local serverMsg = message.serverMsg
	local customData = message.customData
	remainsWarUtil.doOpenShareSeasonInfo(customData, serverMsg)
end
function chatMenuHandlerMgr:onMenuCommonView_party_share(target, opId, data)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PARTY_ACTIVITY, true) then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		if cityCtrl:getBuildMaxLv(BUILDID.CASTLE) >= CASTLE_LV6_LIMITED then
			local partyCtrl = SoraDGetCtrl("partyCtrl", gametop)
			partyCtrl:sendGetOnePartyInfo(data.customData.customData.partyID)
			SoraDShowLoading(nil, nil, nil, false, nil, true)
		else
			_ENV = nil
			;(nil).num = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		end
	else
		SoraDShowMsgTip(i18n("common_text_1859"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_alliance_counter_sys(target, opId, data)
	print("联盟反击跳转=========")
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceCounterSysCtrl = gametop.playertop_:getModule("allianceCounterSysCtrl")
	if data.customData.customData.values.nickName then
		local panel = uiManager:show("allianceOwnCounterInfoView").view
		panel:initData(data.customData.customData.values, true)
	else
		local uid = data.customData.customData.values.uid
		local data = allianceCounterSysCtrl:getAllianceEnemyInfo(uid)
		if data == nil then
			SoraDShowMsgTip(i18n("CounterSystem_text_08"))
			return
		end
		if data then
			panel = uiManager:show("allianceCounterInfoView").view
			panel:initData(data)
		end
	end
end
function chatMenuHandlerMgr:onMenuCommonView_ancient_treasure(target, opId, data)
	print("上古秘宝跳转=========")
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_4479"))
		return
	end
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = i18n("common_text_4479")
		i18n("common_text_4479").num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_4479")))
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) and not ancientTreasureCtrl:isTreasureStageOpen() then
		SoraDShowMsgTip(i18n("common_text_608"))
		return
	end
	local var = data.customData.customData.values
	if var.buildID and not ancientTreasureCtrl:getBuildInfoInAlliance(var.buildID) then
		SoraDShowMsgTip(i18n("common_text_2601"))
		return
	end
	if var then
		_ENV = i18n("common_text_2601")
		i18n("common_text_2601").x = var.buildX
		i18n("common_text_2601").y = var.buildY
		SoraDGotoWorldMapPoint(i18n("common_text_2601"))
		SoraDRemoveAllPanelFromManager()
	end
end
function chatMenuHandlerMgr:onMenuCommonView_solomonKey_reward(target, opId, data)
	local message = data.customData
	local customData = message.customData
	local keyID = customData.values.item.keyID
	local solomonKeyRead = include("solomonKeyRead")
	local panel = SoraDCreatePanel("solomonKeyView")
	panel:initData(keyID)
	panel:show()
end
function chatMenuHandlerMgr:onMenuCommonView_devil_valley_team(target, opId, data)
	local message = data.customData
	local customData = message.customData
	local gametop = gModuleMgr.getObject("gametop")
	local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
	if devilValleyCtrl:hasTeams() then
		if devilValleyCtrl:getMyTeamIdEx() ~= customData.teamIdEx then
			devilValleyCtrl:sendReqJoinTeam(customData.teamIdEx, customData.challengeLv)
			return
		end
		local teams = devilValleyCtrl:getMyTeams()
		if teams.start then
			if devilValleyCtrl:getSelfIsStart() then
				SoraDShowMsgTip(i18n("devilvalley_text_44"))
				return
			end
			SoraDShowMsgBox(i18n("devilvalley_tips_07"), i18n("devilvalley_btn_14"), i18n("devilvalley_btn_13"), function(eventType)
				if MSGBOX_CALLBACK_YES == eventType and SoraDGetCtrl("devilValleyCtrl"):checkEnterCondition() then
					SoraDGetCtrl("devilValleyCtrl"):sendReqStartChallenge()
				end
			end)
		else
			local panel = SoraDCreatePanel("newTrialMyTeamView")
			panel:initData()
			panel:show()
		end
	else
		devilValleyCtrl:sendReqJoinTeam(customData.teamIdEx, customData.challengeLv)
	end
end
function chatMenuHandlerMgr:onMenuCommonView_king_of_glory(target, opId, data)
	local castleLV = SoraDGetCastleLv()
	if tonumber(castleLV) < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY) then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY, 6)
		return
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_corban_market_reward(target, opId, data)
	local castleLV = SoraDGetCastleLv()
	if tonumber(castleLV) < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CORBAN_MARKET_ACTIVITY) then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.CORBAN_MARKET_ACTIVITY, 6)
		return
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_eid_celebration_share(target, opId, data)
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EID_CELEBRATION_ACTIVITY) then
		_ENV = i18n("common_text_1151", nil)
		i18n("common_text_1151", nil).tag = 2
		uiManager:show("Activity_9001643_main", i18n("common_text_1151", nil))
		return
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_bubble_post_share(target, opId, data)
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
		return
	end
	local activityID = data.customData.customData.values.activityId or gActivityTimeActivityID.BUBBLE_CARNIVAL
	if not clientEventMgr.judgeIsOpen(activityID) then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001692 then
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").tag = 2
		uiManager:show("Activity_9001692_Main", i18n("common_text_2486"))
	else
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").tag = 2
		uiManager:show("Activity_9001663_main", i18n("common_text_2486"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_9001594(target, opId, data)
	clientEventMgr.singleClickEvent(gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY)
end
function chatMenuHandlerMgr:onMenuCommonView_9001720(target, opId, data)
	clientEventMgr.singleClickEvent(gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720)
end
function chatMenuHandlerMgr:onMenuCommonView_9001661(target, opId, data)
end
function chatMenuHandlerMgr:onMenuCommonView_roaring_flame_war_decree_gift(target, opId, data)
	if SoraDGetCastleLv() < CASTLE_LV110_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV110_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	elseif clientEventMgr.getEventInfoByeid(gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY) then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local curState = roaringFlameWarCtrl:getCurState()
		if curState == ROARING_FLAME_WAR_STATE.BATTLE then
			_ENV = i18n("common_text_1151", nil)
			i18n("common_text_1151", nil).tag = 1
			uiManager:show("RoaringFlame_Decree", i18n("common_text_1151", nil))
			uiManager:show("RoaringFlame_CampReward")
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_decree_gift_user_num(target, opId, data)
	if SoraDGetCastleLv() < CASTLE_LV110_LIMITED then
		_ENV = nil
		;(nil).blv = CASTLE_LV110_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil))
	elseif clientEventMgr.getEventInfoByeid(gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY) then
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local curState = roaringFlameWarCtrl:getCurState()
		if curState == ROARING_FLAME_WAR_STATE.BATTLE then
			_ENV = i18n("common_text_1151", nil)
			i18n("common_text_1151", nil).tag = 1
			uiManager:show("RoaringFlame_Decree", i18n("common_text_1151", nil))
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function chatMenuHandlerMgr:onMenuCommonView_9001725(target, opId, data)
	if not commonCheck.SIMULATED_DRILL then
		SoraDShowMsgTip(i18n("allitreas_text_03"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_4479"))
		return
	end
	local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_9001725==", 10)
	local selfRoom = simulatedDrillCtrl:getSelfRoom()
	if selfRoom then
		if simulatedDrillCtrl:checkSameRoom(selfRoom, values) then
			SoraDShowMsgTip(i18n("simulated_drill_text_50"))
		else
			SoraDShowMsgTip(i18n("simulated_drill_text_51"))
		end
		return
	end
	simulatedDrillCtrl:reqRoomEnter(values.roomId, values.key, nil, values.createTime, "chat")
end
function chatMenuHandlerMgr:onMenuCommonView_9001731(target, opId, data)
	if worldMapDefine.inInCrossWar() or worldMapDefine.isInGardenCity() then
		SoraDShowMsgTip(i18n("Ludo_test_040"))
		return
	end
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FLYING_CHESS_ACTIVITY) then
		SoraDShowMsgTip(i18n("Ludo_test_042"))
		return
	end
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = i18n("Ludo_test_042")
		i18n("Ludo_test_042").num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", i18n("Ludo_test_042")))
		return
	end
	local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_9001731==", 10)
	activity_9001731_Ctrl:reqRoomEnter(values.roomId, values.createTime)
end
_ENV, chatMenuHandlerMgr.onMenuCommonView_manor_banquet = function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end, function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpCopy)] = chatMenuHandlerMgr.onMenuCopy
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpQuote)] = chatMenuHandlerMgr.onMenuQuote
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpOriginText)] = chatMenuHandlerMgr.onMenuOrigin
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpTranslate)] = chatMenuHandlerMgr.onMenuTranslate
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpJoin)] = chatMenuHandlerMgr.onMenuJoin
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpInvite)] = chatMenuHandlerMgr.onMenuInvite
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpShield)] = chatMenuHandlerMgr.onMenuShield
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpUnShield)] = chatMenuHandlerMgr.onMenuUnShield
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpForbidLord)] = chatMenuHandlerMgr.onMenuForbidLord
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpReport)] = chatMenuHandlerMgr.onMenuReport
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpCommonView)] = chatMenuHandlerMgr.onMenuCommonView
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpReportHeadImg)] = chatMenuHandlerMgr.onMenuReportHeadImg
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpBuy)] = chatMenuHandlerMgr.onMenuBuy
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpShieldThisAlliance)] = chatMenuHandlerMgr.onMenuShieldThisAlliance
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpUnShieldThisAlliance)] = chatMenuHandlerMgr.onMenuUnShieldThisAlliance
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpShieldThisLord)] = chatMenuHandlerMgr.onMenuShieldThisLord
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpUnShieldThisLord)] = chatMenuHandlerMgr.onMenuUnShieldThisLord
_ENV, chatMenuHandlerMgr.menuHandlerList, (function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[tostring(chatConst.OpId.OpDeleteMsg)] = function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end, function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end, chatMenuHandlerMgr.onMenuDeleteMsg
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_equip_create] = chatMenuHandlerMgr.onMenuCommonView_equip
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_fightReport] = chatMenuHandlerMgr.onMenuCommonView_fightReport
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_pyramid_share] = chatMenuHandlerMgr.onMenuCommonView_pyramid_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_eliminateGame_share] = chatMenuHandlerMgr.onMenuCommonView_eliminateGame_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_starsWishGame_share] = chatMenuHandlerMgr.onMenuCommonView_starsWishGame_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_rally] = chatMenuHandlerMgr.onMenuCommonView_rally
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_groupbuy_good] = chatMenuHandlerMgr.onMenuCommonView_groupbuy_good
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_pet] = chatMenuHandlerMgr.onMenuCommonView_pet
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_hero_share] = chatMenuHandlerMgr.onMenuCommonView_hero_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_arms_share] = chatMenuHandlerMgr.onMenuCommonView_arms_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_share_voice_room] = chatMenuHandlerMgr.onMenuCommonView_share_voice_room
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_allianceTreasure] = chatMenuHandlerMgr.onMenuCommonView_allianceTreasure
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_lengendWar] = chatMenuHandlerMgr.onMenuCommonView_lengendWar
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_starking] = chatMenuHandlerMgr.onMenuCommonView_starking
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_hegemonWar] = chatMenuHandlerMgr.onMenuCommonView_hegemonWar
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_open_escort_buff_alliance] = chatMenuHandlerMgr.onMenuCommonView_open_escort_buff_alliance
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_alliance_beast_rally] = chatMenuHandlerMgr.onMenuCommonView_rally
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_alliance_beast_call] = chatMenuHandlerMgr.onMenuCommonView_alliance_beast
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_alliance_beast_trial] = chatMenuHandlerMgr.onMenuCommonView_alliance_beast
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_remains_war_team_invite] = chatMenuHandlerMgr.onMenuCommonView_remains_war_team_invite
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_solomonKey_reward] = chatMenuHandlerMgr.onMenuCommonView_solomonKey_reward
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_devil_valley_team] = chatMenuHandlerMgr.onMenuCommonView_devil_valley_team
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_remains_war_share_settle_info] = chatMenuHandlerMgr.onMenuCommonView_remains_war_share_settle_info
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_remains_war_share_season_info] = chatMenuHandlerMgr.onMenuCommonView_remains_war_share_season_info
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_party_share] = chatMenuHandlerMgr.onMenuCommonView_party_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_ancient_treasure] = chatMenuHandlerMgr.onMenuCommonView_ancient_treasure
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_ancient_treasure_rally] = chatMenuHandlerMgr.onMenuCommonView_ancient_treasure
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_alliance_counter_sys] = chatMenuHandlerMgr.onMenuCommonView_alliance_counter_sys
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_alliance_own_counter_sys] = chatMenuHandlerMgr.onMenuCommonView_alliance_counter_sys
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_feast_share] = chatMenuHandlerMgr.onMenuCommonView_feast_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_pos_share] = chatMenuHandlerMgr.onMenuCommonView_sharePos
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_king_of_glory] = chatMenuHandlerMgr.onMenuCommonView_king_of_glory
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_hero_prison_share] = chatMenuHandlerMgr.onMenuCommonView_hero_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_9001594] = chatMenuHandlerMgr.onMenuCommonView_9001594
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_corban_market_reward] = chatMenuHandlerMgr.onMenuCommonView_corban_market_reward
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.eid_celebration_share] = chatMenuHandlerMgr.onMenuCommonView_eid_celebration_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_bubble_post] = chatMenuHandlerMgr.onMenuCommonView_bubble_post_share
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_9001661] = chatMenuHandlerMgr.onMenuCommonView_9001661
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.roaring_flame_war_decree_gift] = chatMenuHandlerMgr.onMenuCommonView_roaring_flame_war_decree_gift
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.decree_gift_user_num] = chatMenuHandlerMgr.onMenuCommonView_decree_gift_user_num
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_9001720] = chatMenuHandlerMgr.onMenuCommonView_9001720
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_9001725] = chatMenuHandlerMgr.onMenuCommonView_9001725
;(function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_9001731] = chatMenuHandlerMgr.onMenuCommonView_9001731
chatMenuHandlerMgr.commonViewHandlerList, (function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end)[gChatDataType.dataType_manor_banquet] = function(self, target, opId, data)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local message = data.customData
	local values = message.customData.values
	dump(values, "==onMenuCommonView_manor_banquet==", 10)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	local cfg = manorCityRead.getBanquetRewardConfig(values.lv)
	if serviceFunctions.systemTime() > cfg.time + values.time then
		SoraDShowMsgTip(i18n("Socialize_text_41"))
		return
	end
	SoraDRemoveAllPanelFromManager()
	manorCityUtil.gotoGardenCity()
	manorCityCtrl:reqGardenMapQueryMap(data.customData.playerId)
end, chatMenuHandlerMgr.onMenuCommonView_manor_banquet
return chatMenuHandlerMgr
