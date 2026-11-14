local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ChatPopupMenuPanel = class("ChatPopupMenuPanel", baseFguiPanel)
function ChatPopupMenuPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ChatPopupMenuPanel:ctor", self.viewName)
end
function ChatPopupMenuPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ChatPopupMenuPanel:onInit()
	print("=======ChatPopupMenuPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(self.param.data)
end
function ChatPopupMenuPanel:onShow()
	print("=======ChatPopupMenuPanel:onShow")
end
function ChatPopupMenuPanel:initData(data)
	dump(data, "chatPopupMenu data====", 10)
	table.sort(data.data, function(a, b)
		return b < a
	end)
	self.other = data.other
	self.fields.Panel_bg:setTitle(data.name)
	self.datas = data.data
	self.tableBtnList, _ENV, self.coordinateIndex = data.data, data.data, 0
	self.fields.scroll:setContentSize(cc.size(470, math.ceil(#data.data / 2) * 85))
	self.fields.scroll:setNumItems(math.ceil(#data.data / 2))
end
function ChatPopupMenuPanel:onItemRenderer(index, obj)
	obj:setClickHandler(handler(self, self.buttonEvent))
	_UPVALUE2_ = obj.setClickHandler
	obj.setClickHandler[1] = obj.fields.btn1
	local obj.setClickHandler[2], btns = obj.fields.btn2, obj.setClickHandler
	for i = 1, 2 do
		local data = self.datas[index * 2 + i]
		local singleBtn = btns[i]
		singleBtn:setVisible(data ~= nil)
		singleBtn._dataTag = data
		if data == chatConst.OpId.OpCoordinate then
			if self.coordinateIndex == 0 then
				self.coordinateIndex = 1
			else
				self.coordinateIndex = self.coordinateIndex + 1
			end
			singleBtn:setTitle(self:getBtnName(data, self.coordinateIndex))
			singleBtn.coordinateIndex = self.coordinateIndex
		elseif data == chatConst.OpId.OpViewPlayer then
			if self.coordinateIndex == 0 then
				self.coordinateIndex = 1
			else
				self.coordinateIndex = self.coordinateIndex + 1
			end
			singleBtn:setTitle(self:getBtnName(data, self.coordinateIndex))
			singleBtn.coordinateIndex = self.coordinateIndex
		else
			singleBtn:setTitle(self:getBtnName(data))
		end
		table.insert(self.tableBtnList, singleBtn)
	end
end
function ChatPopupMenuPanel:setHandle(handle)
	self.handle = handle
end
function ChatPopupMenuPanel:getBtnName(id, index)
	local chatConst = include("chatConst")
	local btnName = ""
	if id == chatConst.OpId.OpSendFlower then
		btnName = i18n("common_text_2309")
	elseif id == chatConst.OpId.OpViewInfo then
		btnName = i18n("common_text_501")
	elseif id == chatConst.OpId.OpShield then
		btnName = i18n("common_text_076")
	elseif id == chatConst.OpId.OpUnShield then
		btnName = i18n("common_text_077")
	elseif id == chatConst.OpId.OpCopy then
		btnName = i18n("common_text_078")
	elseif id == chatConst.OpId.OpInvite then
		btnName = i18n("common_text_075")
	elseif id == chatConst.OpId.OpJoin then
		btnName = i18n("common_text_068")
	elseif id == chatConst.OpId.OpSendEmail then
		btnName = i18n("chat_text_69")
	elseif id == chatConst.OpId.OpShieldThisLord then
		btnName = i18n("common_text_080")
	elseif id == chatConst.OpId.OpShieldThisAlliance then
		btnName = i18n("common_text_081")
	elseif id == chatConst.OpId.OpDeleteMsg then
		btnName = i18n("alliance_text_49")
	elseif id == chatConst.OpId.OpViewAlliance then
		btnName = i18n("common_text_082")
	elseif id == chatConst.OpId.OpUnShieldThisLord then
		btnName = i18n("common_text_539")
	elseif id == chatConst.OpId.OpUnShieldThisAlliance then
		btnName = i18n("common_text_540")
	elseif id == chatConst.OpId.OnKickOutAlliance then
		btnName = i18n("common_text_232")
	elseif id == chatConst.OpId.OpCoordinate then
		if self.other and self.other.coordinates and self.other.coordinates[index] then
			_ENV = nil
			;(nil).x = self.other.coordinates[index].x
			;(nil).y = self.other.coordinates[index].y
			btnName = i18n("common_text_465", nil)
		end
	elseif id == chatConst.OpId.OpTranslate then
		btnName = i18n("common_text_1634")
	elseif id == chatConst.OpId.OpOriginText then
		btnName = i18n("common_text_1636")
	elseif id == chatConst.OpId.OpReport then
		btnName = i18n("common_text_1451")
	elseif id == chatConst.OpId.OpViewBattleReport then
		btnName = i18n("common_text_504")
	elseif id == chatConst.OpId.OpForbidLord then
		btnName = i18n("common_text_1880")
	elseif id == chatConst.OpId.OpViewPlayer then
		if self.other and self.other.players and self.other.players[index] then
			local mailFunctions = include("mailFunctions")
			local name = mailFunctions:getWrappedName(self.other.players[index].alliance, self.other.players[index].nickName)
			btnName = name
		end
	elseif id == chatConst.OpId.OpReportHeadImg then
		btnName = i18n("common_text_3440")
	elseif id == chatConst.OpId.OpBuy then
		btnName = i18n("common_text_282")
	elseif id == chatConst.OpId.OpRemainsReport then
		btnName = i18n("common_text_1451")
	elseif id == chatConst.OpId.OpSetCaptain then
		btnName = i18n("pyramid_btn_17")
	elseif id == chatConst.OpId.OpCancleCaptain then
		btnName = i18n("pyramid_btn_18")
	elseif id == chatConst.OpId.OpSendGiftNebulaAllStar then
		btnName = i18n("NebulaAllstar_209")
	end
	return btnName
end
function ChatPopupMenuPanel:buttonEvent(target)
	SoraDPlaySound()
	local chatConst = include("chatConst")
	local btnTag = target._dataTag
	local needClose = true
	if btnTag == chatConst.OpId.OpSendFlower then
		self:sendFlower()
	elseif btnTag == chatConst.OpId.OpViewInfo then
		self:btnViewPlayerInfo()
	elseif btnTag == chatConst.OpId.OpShield then
		self:btnShield()
	elseif btnTag == chatConst.OpId.OpUnShield then
		self:btnUnShield()
	elseif btnTag == chatConst.OpId.OpCopy then
		self:btnCopy()
	elseif btnTag == chatConst.OpId.OpInvite then
		self:btnInvite()
	elseif btnTag == chatConst.OpId.OpJoin then
		self:btnJoin()
	elseif btnTag == chatConst.OpId.OpSendEmail then
		self:btnSendMail()
	elseif btnTag == chatConst.OpId.OpShieldThisLord then
		self:btnShieldThisLord()
	elseif btnTag == chatConst.OpId.OpShieldThisAlliance then
		self:btnShieldThisAlliance()
	elseif btnTag == chatConst.OpId.OpDeleteMsg then
		self:btnDeleteMsg()
	elseif btnTag == chatConst.OpId.OpViewAlliance then
		self:btnViewAlliance()
	elseif btnTag == chatConst.OpId.OpUnShieldThisLord then
		self:btnUnShieldThisLord()
	elseif btnTag == chatConst.OpId.OpUnShieldThisAlliance then
		self:btnUnShieldThisAlliance()
	elseif btnTag == chatConst.OpId.OnKickOutAlliance then
		self:btnKickOutAlliance()
	elseif btnTag == chatConst.OpId.OpCoordinate then
		self:btnCoordinate(target)
		return
	elseif btnTag == chatConst.OpId.OpTranslate then
		self:btnTranslate()
	elseif btnTag == chatConst.OpId.OpOriginText then
		self:btnOrigin()
	elseif btnTag == chatConst.OpId.OpReport then
		self:btnReport()
	elseif btnTag == chatConst.OpId.OpViewBattleReport then
		self:btnViewBattleReport()
	elseif btnTag == chatConst.OpId.OpForbidLord then
		self:btnForbidLord()
	elseif btnTag == chatConst.OpId.OpViewPlayer then
		self:btnViewPlayer(target)
	elseif btnTag == chatConst.OpId.OpReportHeadImg then
		print("点击了举报头像----")
		self:btnReportHeadImg()
	elseif btnTag == chatConst.OpId.OpBuy then
		needClose = self:btnBuyBubble()
	elseif btnTag == chatConst.OpId.OpRemainsReport then
		SoraDGetCtrl("remainsWarCtrl"):reqReportUser(self.other.playerId)
	end
	if btnTag ~= chatConst.OpId.OnKickOutAlliance then
		if self.handle then
			self.handle(btnTag)
		end
		if needClose and self.close then
			self:close()
		end
	end
end
function ChatPopupMenuPanel:btnKickOutAlliance()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if kingdomMapCtrl:isHasMassQueue4Uid(self.other.playerId) then
		SoraDShowMsgBox(i18n("common_text_670"), i18n("common_text_204"))
	else
		_ENV = i18n("common_text_204")
		i18n("common_text_204").name = self.other.nickName
		msg = i18n("common_text_671", i18n("common_text_204"))
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				allianceMgr:reqExpelMember(self.other.playerId)
				if self.handle then
					self.handle(chatConst.OpId.OnKickOutAlliance)
				end
				self:removeFromParent()
			end
		end)
	end
end
function ChatPopupMenuPanel:sendFlower()
	_ENV = nil
	;(nil).uid = self.other.playerId
	;(nil).kid = self.other.kid
	uiManager:show("flowerSendView", nil)
end
function ChatPopupMenuPanel:btnViewPlayerInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.other.playerId
	;(nil).kid = self.other.kid
	SoraDSendMessage(nil)
end
function ChatPopupMenuPanel:btnReportHeadImg()
	local curl = self.other.avatarUrl
	local playerID = self.other.playerId
	SoraDReportHeadImg(playerID, curl)
end
function ChatPopupMenuPanel:btnShield()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_SHIELD_USER"
	;(nil).playerId = self.other.playerId
	;(nil).nickName = self.other.nickName
	SoraDSendMessage(nil)
end
function ChatPopupMenuPanel:btnUnShield()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_UNSHIELD_USER"
	;(nil).playerId = self.other.playerId
	;(nil).nickName = self.other.nickName
	SoraDSendMessage(nil)
end
function ChatPopupMenuPanel:btnCopy()
	SoraDCopyText(self.other.content)
end
function ChatPopupMenuPanel:btnSendMail()
	if self.other == nil then
		return
	end
	local playerId = self.other.playerId
	local nickName = self.other.nickName
	local allianceAbbr = self.other.allianceAbbr
	_ENV = nil
	;(nil).targetType = gMailType.CHAT
	;(nil).target = playerId
	;(nil).nickName = nickName
	local (nil).allianceAbbr, data = allianceAbbr, nil
	local panel = SoraDCreateChatView(data)
	self:close()
end
function ChatPopupMenuPanel:btnJoin()
	if self.other == nil then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceId = self.other.allianceId
	local alliance = allianceMgr:getAlliance()
	if alliance == nil then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceQuery = gametop.playertop_:getModule("allianceQuery")
		if allianceId == nil then
			return
		end
		_ENV = nil
		_ENV, (nil).aid = nil, allianceId
		;(nil).from = "chat"
		allianceQuery:reqAllianceByID(nil, nil)
	else
	end
end
function ChatPopupMenuPanel:btnInvite()
	if self.other == nil then
		return
	end
	local playerId = self.other.playerId
	local kid = self.other.kid
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
function ChatPopupMenuPanel:btnShieldThisLord()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	_ENV = "allianceMsg"
	;("allianceMsg").msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, ("allianceMsg").opType = gAShieldListOperate.add, gAShieldListOperate.add
	;("allianceMsg").opList, gAShieldListOperate.add.uid = gAShieldListOperate.add, self.other.playerId
	;("allianceMsg").nickName = self.other.nickName
	;("allianceMsg").abbr = self.other.allianceAbbr
	SoraDSendMessage("allianceMsg")
end
function ChatPopupMenuPanel:btnShieldThisAlliance()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	_ENV = "allianceMsg"
	;("allianceMsg").msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, ("allianceMsg").opType = gAShieldListOperate.add, gAShieldListOperate.add
	;("allianceMsg").opList, gAShieldListOperate.add.aid = gAShieldListOperate.add, self.other.allianceId
	;("allianceMsg").nickName = self.other.nickName
	;("allianceMsg").abbr = self.other.allianceAbbr
	SoraDSendMessage("allianceMsg")
end
function ChatPopupMenuPanel:btnDeleteMsg()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	print("删除联盟留言=========")
end
function ChatPopupMenuPanel:btnViewAlliance()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	_ENV = nil
	_ENV, (nil).aid = self.other.allianceId, self.other.allianceId
	self.other.allianceId.from = "allianceChat"
	allianceQuery:reqAllianceByID(nil, self.other.allianceId)
end
function ChatPopupMenuPanel:btnUnShieldThisLord()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	_ENV = "allianceMsg"
	;("allianceMsg").msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, ("allianceMsg").opType = gAShieldListOperate.del, gAShieldListOperate.del
	;("allianceMsg").opList, gAShieldListOperate.del.uid = gAShieldListOperate.del, self.other.playerId
	;("allianceMsg").nickName = self.other.nickName
	;("allianceMsg").abbr = self.other.allianceAbbr
	SoraDSendMessage("allianceMsg")
end
function ChatPopupMenuPanel:btnUnShieldThisAlliance()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	_ENV = "allianceMsg"
	;("allianceMsg").msg = "MESSAGE_ALLIANCE_OPERATE_SHIELD_LIST"
	_ENV, ("allianceMsg").opType = gAShieldListOperate.del, gAShieldListOperate.del
	;("allianceMsg").opList, gAShieldListOperate.del.aid = gAShieldListOperate.del, self.other.allianceId
	;("allianceMsg").nickName = self.other.nickName
	;("allianceMsg").abbr = self.other.allianceAbbr
	SoraDSendMessage("allianceMsg")
end
function ChatPopupMenuPanel:btnCoordinate(target)
	local coordinateIndex = target.coordinateIndex
	if coordinateIndex and self.other and self.other.coordinates and self.other.coordinates[coordinateIndex] then
		local coordinate = self.other.coordinates[coordinateIndex]
		coordinate.x = math.min(1200, math.max(0, coordinate.x))
		coordinate.y = math.min(1200, math.max(0, coordinate.y))
		SoraDGotoWorldMapPoint(coordinate, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function ChatPopupMenuPanel:btnViewPlayer(target)
	local coordinateIndex = target.coordinateIndex
	if coordinateIndex and self.other and self.other.players and self.other.players[coordinateIndex] then
		local uid = self.other.players[coordinateIndex].uid
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = uid
		SoraDSendMessage(nil)
	end
end
function ChatPopupMenuPanel:btnTranslate()
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local data = self.other.data
	if data and data.itemNode then
		local settingCtrl = gametop.playertop_:getModule("settingCtrl")
		local tl = settingCtrl:getTranslateLanguage()
		local isNeedTranslate, tText = translateCtrl:needTranslate(data.translation)
		if isNeedTranslate == false and data.translation.tText ~= nil and data.translation.tText[tl] ~= nil then
			print("本地切换")
			data.itemNode:toggleTranslate()
			_UPVALUE1_ = data.itemNode.toggleTranslate
			local data.itemNode.toggleTranslate[1], translationList = data.translation, data.itemNode.toggleTranslate
			local isAutoTranslate = false
			local chatType = data.chatType
			_ENV = nil
			;(nil).msg = "MESSAGE_CHAT_TRANSLATION_CHANGED"
			;(nil).chatType = chatType
			;(nil).translationList = translationList
			;(nil).isAutoTranslate = isAutoTranslate
			SoraDSendMessage(nil)
		else
			print("请求翻译----------------")
			local from = "chatAlliance"
			if data.chatType == gChatTypeUI.kingdom then
				from = "chatKingdom"
			elseif data.chatType == gChatTypeUI.alliance then
				from = "chatAlliance"
			elseif data.chatType == gChatTypeUI.mail then
				from = "chatMail"
			elseif data.chatType == gChatTypeUI.allianceMsg then
				from = "chatAllianceMsg"
				print("Error ! Not Implemented ! Should not com here!")
			elseif data.chatType == gChatTypeUI.chatRoom then
				from = "chatRoomMsg"
			end
			local isAutoTransalte = false
			_UPVALUE1_ = nil
			;(nil)[1] = data
			chatTranslateMgr:reqTranslate(from, nil, isAutoTransalte)
		end
	end
end
function ChatPopupMenuPanel:btnOrigin()
	print("显示原文=================")
	local data = self.other.data
	if data and data.itemNode then
		data.itemNode:toggleTranslate()
		_UPVALUE1_ = data.itemNode.toggleTranslate
		local data.itemNode.toggleTranslate[1], translationList = data.translation, data.itemNode.toggleTranslate
		local isAutoTranslate = false
		local chatType = data.chatType
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_TRANSLATION_CHANGED"
		;(nil).chatType = chatType
		;(nil).translationList = translationList
		;(nil).isAutoTranslate = isAutoTranslate
		SoraDSendMessage(nil)
	end
end
function ChatPopupMenuPanel:btnReport()
	local chatId = self.other.chatId
	local playerId = self.other.playerId
	local content = self.other.content
	dump(self.other, "other")
	if self.other.data and self.other.data.dataType == gChatDataType.dataType_audio then
		content = self.other.data.customData.audioId
	end
	_ENV = self.other.data.customData
	self.other.data.customData.complainid = chatFunctions:getSelfId()
	self.other.data.customData.bycomplainid = playerId
	self.other.data.customData.message = content
	self.other.data.customData.serverid = gametop.playertop_:getKingdomID()
	local self.other.data.customData.targetName, complainData = self.other.data.customData.nickName, self.other.data.customData
	_ENV = nil
	;(nil).data = complainData
	;(nil).chatId = chatId
	uiManager:show("chatReportView", nil)
end
function ChatPopupMenuPanel:btnViewBattleReport()
	print("TODO:跳转到邮件战报界面")
	dump(self.other.customData, "战报的额外数据")
	if self.other.customData.mid then
		local mailFunctions = include("mailFunctions")
		mailFunctions:doRequestMailReport(self.other.customData.mid)
	end
end
function ChatPopupMenuPanel:btnForbidLord()
	print("禁止该领主发言----")
	_ENV = "禁止该领主发言----"
	;("禁止该领主发言----").msg = "MESSAGE_CHAT_FORBID_LORD"
	_ENV, ("禁止该领主发言----").opType = gAShieldListOperate.add, gAShieldListOperate.add
	;("禁止该领主发言----").opList, gAShieldListOperate.add.uid = gAShieldListOperate.add, self.other.playerId
	;("禁止该领主发言----").nickName = self.other.nickName
	;("禁止该领主发言----").abbr = self.other.allianceAbbr
	SoraDSendMessage("禁止该领主发言----")
end
function ChatPopupMenuPanel:btnBuyBubble()
	print("TODOhlp:购买气泡按钮---------")
	local bubbleId = 0
	if self.other and self.other.data and self.other.data.customProperty and self.other.data.customProperty.sysBubbleId then
		bubbleId = self.other.data.customProperty.sysBubbleId
	end
	print("bubbleId = ", bubbleId)
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
	return false
end
function ChatPopupMenuPanel:getBtnByTag(tag)
	for i, v in ipairs(self.tableBtnList) do
		if v._dataTag == tag then
			return v
		end
	end
end
return ChatPopupMenuPanel
