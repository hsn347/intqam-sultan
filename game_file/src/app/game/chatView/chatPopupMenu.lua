local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatConst = include("chatConst")
local chatFunctions = include("chatFunctions")
local mailFunctions = include("mailFunctions")
local chatTranslateMgr = gChatMgrs:getMgr("chatTranslateMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatPopupMenu = class("chatPopupMenu", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("chatPopupMenu")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatPopupMenu:ctor()
	self.tableBtnList, _ENV = nil, nil
	self.handle = nil
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.bottomNode:setPositionY(display.iPhoneXBottom)
	self.btn1 = SoraDGetChildByName(self, "Button_1")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.panelCut = SoraDGetChildByName(self, "Panel_cut")
	self.imgFrm = SoraDGetChildByName(self, "Image_frm")
	self.titleRight = SoraDGetChildByName(self, "Image_title_right")
	self.titleLeft = SoraDGetChildByName(self, "Image_title_left")
	self.frmRight = SoraDGetChildByName(self, "Image_frm_right")
	self.frmLeft = SoraDGetChildByName(self, "Image_frm_left")
	if self.imgBg then
		self.imgBg:setFillType(1)
	end
	self.btn1:addTouchEventListener(handler(self, self.buttonEvent))
	self:setBackGround(102.0)
end
function chatPopupMenu:initData(data)
	dump(data, "chatPopupMenu data====", 10)
	table.sort(data.data, function(a, b)
		return b < a
	end)
	self.other = data.other
	self.labelName:setString(data.name)
	local coordinateIndex = 0
	for i, v in ipairs(data.data) do
		local singleBtn = self.btn1
		if 1 < i then
			singleBtn = self.btn1:clone()
			singleBtn:addTouchEventListener(handler(self, self.buttonEvent))
			singleBtn:addTo(self.nodeTouch)
		end
		singleBtn:setTag(v)
		if v == chatConst.OpId.OpCoordinate then
			if coordinateIndex == 0 then
				coordinateIndex = 1
			else
				coordinateIndex = coordinateIndex + 1
			end
			singleBtn:setTitleText(self:getBtnName(v, coordinateIndex))
			singleBtn.coordinateIndex = coordinateIndex
		elseif v == chatConst.OpId.OpViewPlayer then
			if coordinateIndex == 0 then
				coordinateIndex = 1
			else
				coordinateIndex = coordinateIndex + 1
			end
			singleBtn:setTitleText(self:getBtnName(v, coordinateIndex))
			singleBtn.coordinateIndex = coordinateIndex
		else
			singleBtn:setTitleText(self:getBtnName(v))
		end
		singleBtn:setPosition(cc.p(271, 50 + (i - 1) * 75))
		table.insert(self.tableBtnList, singleBtn)
	end
	local panelH = 60 + 75 * #self.tableBtnList
	self.nodeTouch:setContentSize(cc.size(542, panelH))
	self.panelCut:setContentSize(cc.size(542, panelH))
	self.panelCut:setPositionY(panelH / 2)
	self.imgFrm:setContentSize(cc.size(542, panelH))
	self.imgFrm:setPositionY(panelH / 2)
	self.titleRight:setPositionY(panelH - 5)
	self.titleLeft:setPositionY(panelH - 5)
	self.frmRight:setContentSize(cc.size(278, panelH + 20))
	self.frmLeft:setContentSize(cc.size(278, panelH + 20))
	self.frmRight:setPositionY(panelH + 9)
	self.frmLeft:setPositionY(panelH + 9)
	self.labelName:setPosition(cc.p(320, panelH - 25))
	self.imgBg:setContentSize(cc.size(542, panelH))
	self.imgBg:setPositionY(panelH / 2)
end
function chatPopupMenu:setHandle(handle)
	self.handle = handle
end
function chatPopupMenu:getBtnName(id, index)
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
	end
	return btnName
end
function chatPopupMenu:buttonEvent(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local chatConst = include("chatConst")
		local btnTag = target:getTag()
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
			if needClose then
				self:close(target, event)
			end
		end
	end
end
function chatPopupMenu:btnKickOutAlliance()
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
function chatPopupMenu:sendFlower()
	_ENV = nil
	;(nil).uid = self.other.playerId
	;(nil).kid = self.other.kid
	uiManager:show("flowerSendView", nil)
end
function chatPopupMenu:btnViewPlayerInfo()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.other.playerId
	;(nil).kid = self.other.kid
	SoraDSendMessage(nil)
end
function chatPopupMenu:btnReportHeadImg()
	local curl = self.other.avatarUrl
	local playerID = self.other.playerId
	SoraDReportHeadImg(playerID, curl)
end
function chatPopupMenu:btnShield()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_SHIELD_USER"
	;(nil).playerId = self.other.playerId
	;(nil).nickName = self.other.nickName
	SoraDSendMessage(nil)
end
function chatPopupMenu:btnUnShield()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_UNSHIELD_USER"
	;(nil).playerId = self.other.playerId
	;(nil).nickName = self.other.nickName
	SoraDSendMessage(nil)
end
function chatPopupMenu:btnCopy()
	SoraDCopyText(self.other.content)
end
function chatPopupMenu:btnSendMail()
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
function chatPopupMenu:btnJoin()
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
function chatPopupMenu:btnInvite()
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
function chatPopupMenu:btnShieldThisLord()
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
function chatPopupMenu:btnShieldThisAlliance()
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
function chatPopupMenu:btnDeleteMsg()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMsg = gametop.playertop_:getModule("allianceMsg")
	print("删除联盟留言=========")
end
function chatPopupMenu:btnViewAlliance()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	_ENV = nil
	_ENV, (nil).aid = self.other.allianceId, self.other.allianceId
	self.other.allianceId.from = "allianceChat"
	allianceQuery:reqAllianceByID(nil, self.other.allianceId)
end
function chatPopupMenu:btnUnShieldThisLord()
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
function chatPopupMenu:btnUnShieldThisAlliance()
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
function chatPopupMenu:btnCoordinate(target)
	local coordinateIndex = target.coordinateIndex
	if coordinateIndex and self.other and self.other.coordinates and self.other.coordinates[coordinateIndex] then
		local coordinate = self.other.coordinates[coordinateIndex]
		coordinate.x = math.min(1200, math.max(0, coordinate.x))
		coordinate.y = math.min(1200, math.max(0, coordinate.y))
		SoraDGotoWorldMapPoint(coordinate, true)
		SoraDRemoveAllPanelFromManager()
	end
end
function chatPopupMenu:btnViewPlayer(target)
	local coordinateIndex = target.coordinateIndex
	if coordinateIndex and self.other and self.other.players and self.other.players[coordinateIndex] then
		local uid = self.other.players[coordinateIndex].uid
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = uid
		SoraDSendMessage(nil)
	end
end
function chatPopupMenu:btnTranslate()
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local data = self.other.data
	if data and data.itemNode then
		local settingCtrl = gametop.playertop_:getModule("settingCtrl")
		local tl = settingCtrl:getTranslateLanguage()
		local isNeedTranslate, tText = translateCtrl:needTranslate(data.translation)
		if isNeedTranslate == false and data.translation.tText ~= nil and data.translation.tText[tl] ~= nil then
			print("本地切换")
			data.itemNode:toggleTranslate()
			_ENV = data.itemNode.toggleTranslate
			local data.itemNode.toggleTranslate[1], translationList = data.translation, data.itemNode.toggleTranslate
			local isAutoTranslate = false
			local chatType = data.chatType
			gametop = nil
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
			_ENV = nil
			;(nil)[1] = data
			chatTranslateMgr:reqTranslate(from, nil, isAutoTransalte)
		end
	end
end
function chatPopupMenu:btnOrigin()
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
function chatPopupMenu:btnReport()
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
function chatPopupMenu:btnViewBattleReport()
	print("TODO:跳转到邮件战报界面")
	dump(self.other.customData, "战报的额外数据")
	if self.other.customData.mid then
		local mailFunctions = include("mailFunctions")
		mailFunctions:doRequestMailReport(self.other.customData.mid)
	end
end
function chatPopupMenu:btnForbidLord()
	print("禁止该领主发言----")
	_ENV = "禁止该领主发言----"
	;("禁止该领主发言----").msg = "MESSAGE_CHAT_FORBID_LORD"
	_ENV, ("禁止该领主发言----").opType = gAShieldListOperate.add, gAShieldListOperate.add
	;("禁止该领主发言----").opList, gAShieldListOperate.add.uid = gAShieldListOperate.add, self.other.playerId
	;("禁止该领主发言----").nickName = self.other.nickName
	;("禁止该领主发言----").abbr = self.other.allianceAbbr
	SoraDSendMessage("禁止该领主发言----")
end
function chatPopupMenu:btnBuyBubble()
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
function chatPopupMenu:getBtnByTag(tag)
	for i, v in ipairs(self.tableBtnList) do
		if v:getTag() == tag then
			return v
		end
	end
end
return chatPopupMenu
