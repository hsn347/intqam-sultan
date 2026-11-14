local gametop = gModuleMgr.getObject("gametop")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local voiceChatListView = class("voiceChatListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("voiceChatListView")
	end
	return target
end)
function voiceChatListView:ctor()
	self.needCallBack2SDK = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_voice")
	self.nodeTitle:setTitle(i18n("chat_btn_01"))
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg", true)
	self.ccsNightBg:setContentHeight(self:getPanelOffsetHeight() - 70)
	self.ccsNightBg:updateTheme()
	self.canUseOCXs, _ENV, self.listData, _ENV = self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.txtNoContent = SoraDGetChildByName(self, "Top_Text_notice")
	self.txtNoContent:setString(i18n("chat_text_01"))
	self.itemCopy = SoraDGetChildByName(self, "Node_item")
	self.txtFieldSearch = SoraDGetChildByName(self, "TextField_search")
	self.txtFieldSearch = SoraDChangeToEditBox(self.txtFieldSearch)
	self.txtFieldSearch:setPlaceHolderColor(cc.c3b(0, 0, 0))
	self.txtFieldSearch:setPlaceHolder(i18n("chat_text_02"))
	self.txtFieldSearch:setTextHorizontalAlignment(SoraDFLabelR())
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClick))
	self.btnHelp = SoraDGetChildByName(self, "Button_roomHelp")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnCreate = SoraDGetChildByName(self, "Button_create")
	self.btnCreate:addTouchEventListener(handler(self, self.btnCreateClick))
	if worldMapDefine.isInTeamStatus() then
		SoraDGetChildByName(self, "Text_roomTip"):setString(i18n("free_team_text_76"))
	else
		SoraDGetChildByName(self, "Text_roomTip"):setString(i18n("chat_text_07"))
	end
	self:req4Permission()
	self:req4RoomList()
end
function voiceChatListView:req4Permission(...)
	VoiceChatSDKManager:getInstance():req4Permission()
end
function voiceChatListView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_ROOMLISTCALLBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONJOINCHANNELSUCCESS", handler(self, self.onSuccessJoin))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK", function(...)
		SoraDCloseLoading(self)
	end)
end
function voiceChatListView:req4RoomList(...)
	SoraDShowLoading(self)
	voiceRoomCtrl:getRoomList()
end
function voiceChatListView:initData(target, redata)
	SoraDCloseLoading(self)
	if not redata.retdata then
		_ENV = redata.retdata
	end
	self.roomList = redata.retdata
	self.oriRoomList = clone(self.roomList)
	self:initView()
end
function voiceChatListView:searchData(filterString)
	filterString = filterString or ""
	local _ENV, filterTbl
	if not self.oriRoomList then
		self.oriRoomList, _ENV = self.oriRoomList, self.oriRoomList
	end
	for _, v in ipairs(self.oriRoomList) do
		if string.find(tostring(v.roomID), filterString, 1, true) then
			table.insert(filterTbl, v)
		elseif string.find(v.roomName, filterString, 1, true) then
			table.insert(filterTbl, v)
		end
	end
	self.roomList = filterTbl
	self:initView()
end
function voiceChatListView:initView(...)
	self:listRooms()
	self.txtNoContent:setVisible(not next(self.roomList))
end
function voiceChatListView:cleanList(...)
	for _, v in pairs(self.listData) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.canUseOCXs, v.point)
		end
	end
end
function voiceChatListView:listRooms(...)
	self:cleanList()
	self.listData, _ENV = self.cleanList, self.cleanList
	local iCount = #self.roomList
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, math.ceil(iCount / 2) * 135)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(self.roomList) do
		_ENV = cc.size(sSize.width, sH)
		cc.size(sSize.width, sH).posX = sSize.width / 2
		cc.size(sSize.width, sH).posY = sH - (i - 1) * 135
		cc.size(sSize.width, sH).data = v
		table.insert(self.listData, cc.size(sSize.width, sH))
	end
	if not self.isInitScroll then
		self.scroll:addEventListener(handler(self, self.updateScroll))
		self.isInitScroll = true
	end
	self:updateScroll()
end
function voiceChatListView:updateScroll(...)
	local scrollInner = self.scroll:getInnerContainer()
	local sSize = self.scroll:getContentSize()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for k, v in pairs(self.listData) do
		if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
			if v.point then
				table.insert(self.canUseOCXs, v.point)
				v.point:setVisible(false)
				v.point = nil
			end
		elseif v.point then
			v.point:setVisible(true)
			v.point:setPosition(v.posX, v.posY)
		elseif 0 < #self.canUseOCXs then
			v.point = table.remove(self.canUseOCXs)
			self:createItem(v.data, v.point)
			v.point:setVisible(true)
			v.point:setPosition(v.posX, v.posY)
		else
			local single = self:createItem(v.data)
			single:setPosition(v.posX, v.posY)
			single:addTo(self.scroll)
			v.point = single
		end
	end
end
function voiceChatListView:onSuccessJoin(target, redata)
	self.needCallBack2SDK = false
	self:removeFromParent()
end
function voiceChatListView:enterRoomCB(roomid, pwd)
	if VoiceChatSDKManager:getInstance().vociePermission then
		SoraDShowLoading(self, nil, nil, nil, 30)
		print("点击加入房间:", roomid, pwd)
		voiceRoomCtrl:joinRoom(roomid, pwd)
	else
		SoraDShowMsgTip(i18n("chat_text_55"))
	end
end
function voiceChatListView:addBtnEvent(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local info = button.bringData
		if info.password then
			local panel = SoraDCreatePanel("voiceChatPwdVerify")
			panel:setCBhandler(function(pwd)
				self:enterRoomCB(info.roomID, pwd)
			end)
			panel:show()
		else
			self:enterRoomCB(info.roomID)
		end
	end
end
function voiceChatListView:createItem(info, ocx)
	ocx = ocx or self.itemCopy:clone()
	local btnAdd = SoraDGetChildByName(ocx, "Button_add")
	local txtOnwer = SoraDGetChildByName(ocx, "Text_onwer")
	local txtRoomID = SoraDGetChildByName(ocx, "Text_roomID")
	local txtRoomName = SoraDGetChildByName(ocx, "Text_roomName")
	local txtPeople = SoraDGetChildByName(ocx, "Text_people")
	local spLock = SoraDGetChildByName(ocx, "Sprite_lock")
	local imgHead = SoraDGetChildByName(ocx, "Image_head")
	local txtPeopleTip = SoraDGetChildByName(ocx, "Text_peopleTip")
	txtPeopleTip:setString(i18n("chat_text_03"))
	txtPeople:setPositionX(txtPeopleTip:getPositionX() - SoraDFSign(1) * txtPeopleTip:getContentSize().width)
	SoraDGetHeadFromManager(imgHead, info.iconID, info.avatar)
	spLock:setVisible(info.password)
	local total = voiceRoomCtrl:getMaxMemCount()
	_ENV = txtPeopleTip
	txtPeopleTip.member = info.memCount
	txtPeopleTip.total = total
	txtPeople:setString(i18n("common_text_155", txtPeopleTip))
	_ENV = i18n("common_text_155", txtPeopleTip)
	i18n("common_text_155", txtPeopleTip).name = info.nickName
	txtOnwer:setString(i18n("chat_text_05", i18n("common_text_155", txtPeopleTip)))
	_ENV = i18n("chat_text_05", i18n("common_text_155", txtPeopleTip))
	i18n("chat_text_05", i18n("common_text_155", txtPeopleTip)).name = info.roomName
	txtRoomName:setString(i18n("chat_text_06", i18n("chat_text_05", i18n("common_text_155", txtPeopleTip))))
	_ENV = i18n("chat_text_06", i18n("chat_text_05", i18n("common_text_155", txtPeopleTip)))
	i18n("chat_text_06", i18n("chat_text_05", i18n("common_text_155", txtPeopleTip))).id = info.roomID
	txtRoomID:setString(i18n("chat_text_04", i18n("chat_text_06", i18n("chat_text_05", i18n("common_text_155", txtPeopleTip)))))
	btnAdd.bringData = info
	btnAdd:setTitleText(i18n("common_text_068"))
	btnAdd:addTouchEventListener(handler(self, self.addBtnEvent))
	return ocx
end
function voiceChatListView:btnCreateClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if not allianceMgr:hasJoinAlliance(true) then
			SoraDShowMsgTip(i18n("notice_0066"))
		else
			local panel = SoraDCreatePanel("voiceChatCreateRoomView")
			panel:show()
		end
	end
end
function voiceChatListView:btnSearchClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local channel = self.txtFieldSearch:getString()
		self:searchData(channel)
	end
end
function voiceChatListView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.VOICE_HELP)
	end
end
function voiceChatListView:onExitPanel(...)
	self.txtFieldSearch:closeIME()
end
return voiceChatListView
