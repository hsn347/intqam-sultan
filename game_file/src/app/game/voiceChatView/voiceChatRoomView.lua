local gametop = gModuleMgr.getObject("gametop")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local chatConst = include("chatConst")
local scrollNode = include("scrollNode")
local voiceChatRoomView = class("voiceChatRoomView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("voiceChatRoomView")
	end
	return target
end)
function voiceChatRoomView:ctor()
	self.needCallBack2SDK = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_voice")
	self.nodeTitle:setTitle(i18n("chat_btn_01"))
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg", true)
	self.ccsNightBg:setContentHeight(self:getPanelOffsetHeight() - 70)
	self.ccsNightBg:updateTheme()
	self.createOCXs, _ENV, self.canUseOCXs, _ENV, self.listData, _ENV = self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme, self.ccsNightBg.updateTheme
	self.myUID = tostring(gametop.playertop_:getPlayerID())
	self.txtPeople = SoraDGetChildByName(self, "Text_people")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.spLock = SoraDGetChildByName(self, "Sprite_lock")
	self.nodeItem = SoraDGetChildByName(self, "Node_lordItem")
	self.nodeItemSelf = SoraDGetChildByName(self, "Node_lordItem_self")
	self.txtRoomID = SoraDGetChildByName(self, "Text_roomID")
	self.bgBottomSheer = SoraDGetChildByName(self, "Image_bottomSheer")
	self.bgBottomSheer:setTouchEnabled(true)
	self.bgBottomSheer:addTouchEventListener(handler(self, self.bgBottomSheerClick))
	self.txtRecordTime = SoraDGetChildByName(self, "Text_first_recordTime")
	self.txtRecordContent = SoraDGetChildByName(self, "Text_first_recordContent")
	self.btnExit = SoraDGetChildByName(self, "Button_exit")
	self.btnExit:addTouchEventListener(handler(self, self.btnExitClick))
	self.btnOption = SoraDGetChildByName(self, "Button_option")
	self.btnOption:addTouchEventListener(handler(self, self.btnOptionClick))
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	self.btnShare:addTouchEventListener(handler(self, self.btnShareClick))
	SoraDGetChildByName(self, "Text_holdTip"):setString(i18n("chat_btn_08"))
	SoraDGetChildByName(self, "Text_freeTip"):setString(i18n("chat_btn_09"))
	self.btnExit:setTitleText(i18n("chat_text_19"))
	self.checkBoxHold = SoraDGetChildByName(self, "CheckBox_hold")
	self.checkBoxFree = SoraDGetChildByName(self, "CheckBox_free")
	self.checkBoxHold:addTouchEventListener(handler(self, self.checkBoxHoldClick))
	self.checkBoxFree:addTouchEventListener(handler(self, self.checkBoxFreeClick))
	self:initData()
	self:updateSpeakMethod()
end
function voiceChatRoomView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONLEAVECHANNEL", handler(self, self.onExitRoom))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NORMALERRCALLBACK", function(...)
		SoraDCloseLoading(self)
	end)
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMINFOUPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMJOIN", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMEXIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_NOTICE_ROOMKICK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_ONSOMEONESPEAK", handler(self, self.someoneSpeakCallBack))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SERVER_EVENTRECORD", handler(self, self.initRecords))
end
function voiceChatRoomView:initData(target, redata)
	self.roomMainData = voiceRoomCtrl.roomInfo
	dump(self.roomMainData, "self.roomMainData")
	if not voiceRoomCtrl.roomInfo.memInfos then
		voiceRoomCtrl = voiceRoomCtrl.roomInfo.memInfos
	end
	self.roomMemberList = voiceRoomCtrl.roomInfo.memInfos
	self.amIMaster = voiceRoomCtrl:judgeIsMaster()
	self:initView()
end
function voiceChatRoomView:initView(...)
	_ENV = nil
	;(nil).name = self.roomMainData.roomName
	self.nodeTitle:setTitle(i18n("chat_text_52", nil))
	local total = voiceRoomCtrl:getMaxMemCount()
	_ENV = i18n("chat_text_52", nil)
	_ENV = i18n("chat_text_52", nil)
	i18n("chat_text_52", nil).member = self.roomMainData.memCount
	i18n("chat_text_52", nil).total = total
	i18n("chat_text_52", nil).num = i18n("common_text_155", i18n("chat_text_52", nil))
	self.txtPeople:setString(i18n("chat_text_14", i18n("chat_text_52", nil)))
	_ENV = i18n("chat_text_14", i18n("chat_text_52", nil))
	i18n("chat_text_14", i18n("chat_text_52", nil)).id = self.roomMainData.roomID
	self.txtRoomID:setString(i18n("chat_text_04", i18n("chat_text_14", i18n("chat_text_52", nil))))
	self.spLock:setVisible(self.roomMainData.password)
	self:listMembers()
	self:initRecords()
end
function voiceChatRoomView:initRecords(target, redata)
	local records = voiceRoomCtrl:getRoomRecordsInfo()
	local topRecord = records[#records]
	if topRecord then
		self.txtRecordTime:setString(os.date("!%Y-%m-%d %H:%M:%S", topRecord.time))
		self.txtRecordContent:setString(voiceRoomCtrl.doRecordsMsg(topRecord))
	end
end
function voiceChatRoomView:cleanList(...)
	for _, v in pairs(self.listData) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.canUseOCXs, v.point)
		end
	end
end
function voiceChatRoomView:listMembers(...)
	self:cleanList()
	self.listData, _ENV = self.cleanList, self.cleanList
	local getPlacePosX = function(index)
		if SoraDFIsRA() then
			return index % 2 > 0 and 325 or 15
		else
			return index % 2 > 0 and 15 or 325
		end
	end
	local _ENV, sortTbl = self, self
	local leaderInfo = self.roomMemberList[tostring(self.roomMainData.leader)]
	table.insert(sortTbl, leaderInfo)
	for k, v in pairs(self.roomMemberList) do
		if k ~= tostring(self.roomMainData.leader) then
			table.insert(sortTbl, v)
		end
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, math.ceil(#sortTbl / 2) * 85)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(sortTbl) do
		_ENV = cc.size(sSize.width, sH)
		cc.size(sSize.width, sH).posX = getPlacePosX(i)
		cc.size(sSize.width, sH).posY = sH - (math.ceil(i / 2) - 1) * 85
		cc.size(sSize.width, sH).data = v
		table.insert(self.listData, cc.size(sSize.width, sH))
	end
	if not self.isInitScroll then
		self.scroll:addEventListener(handler(self, self.updateScroll))
		self.isInitScroll = true
	end
	self:updateScroll()
end
function voiceChatRoomView:createItem(info, ocx)
	if not ocx then
		ocx = self.nodeItem:clone()
		local imgBg = SoraDGetChildByName(ocx, "Image_itemBg")
		imgBg = scrollNode.new(imgBg)
		imgBg:setScroll(self.scroll)
		table.insert(self.createOCXs, ocx)
		function ocx.runSpeakAction()
			local iconSpeak = SoraDGetChildByName(ocx, "Image_speak")
			iconSpeak:setVisible(true)
			ocx = nil
			;(nil)[1] = cca.delay(3)
			;(nil)[2] = cca.callFunc(function(...)
				iconSpeak:setVisible(false)
			end)
			;(nil)[3] = cca.callFunc(function(...)
				iconSpeak:setVisible(false)
			end)
			iconSpeak:runAction(cca.seq(nil))
		end
	end
	ocx:setName(info.sdkuid or "null")
	local imgBg = SoraDGetChildByName(ocx, "Image_itemBg")
	imgBg:setTouchEnabled(true)
	imgBg:setSwallowTouches(false)
	imgBg.bringData = info
	imgBg:addTouchEventListener(handler(self, self.itemClick))
	local txtLordName = SoraDGetChildByName(ocx, "Text_lordName")
	txtLordName:setString(info.nickName)
	local txtAbbr = SoraDGetChildByName(ocx, "Text_abbr")
	txtAbbr:setString(info.abbr)
	local imgHead = SoraDGetChildByName(ocx, "Image_head")
	SoraDGetHeadFromManager(imgHead, info.iconID, info.avatar)
	local imgState = SoraDGetChildByName(ocx, "Image_state")
	imgState:setVisible(info.isFobid)
	local spOwner = SoraDGetChildByName(ocx, "Sprite_owner")
	local imgHeadBg = SoraDGetChildByName(ocx, "Image_headBg")
	local imgBg = SoraDGetChildByName(ocx, "Image_itemBg")
	if tostring(info.uid) == tostring(self.roomMainData.leader) then
		spOwner:setVisible(true)
		txtLordName:setColor(cc.c3b(215, 195, 155))
		imgHeadBg:loadTexture("frame_main_head.png", ccui.TextureResType.plistType)
		imgBg:setOpacity(140.25)
	else
		spOwner:setVisible(false)
		txtLordName:setColor(cc.c3b(50, 30, 0))
		imgHeadBg:loadTexture("frame_LegendaryKing_head_square.png", ccui.TextureResType.plistType)
		imgBg:setOpacity(63.75)
	end
	if self.myUID == tostring(info.uid) then
		txtLordName:setColor(cc.c3b(0, 255, 255))
	else
		txtLordName:setColor(cc.c3b(50, 30, 0))
	end
	return ocx
end
function voiceChatRoomView:menuCallBack(menuType, info)
	print("menuType=", menuType)
	local fromInfo = info.customData
	_ENV = "menuType="
	;("menuType=")[chatConst.OpId.OpLookPlayer] = function(tmpInfo)
		print("chatConst.OpId.OpLookPlayer tmpInfo.uid =", tmpInfo.uid)
		local kid = gametop.playertop_:getKingdomID()
		_ENV = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(tmpInfo.uid, kid, nil)
	end
	;("menuType=")[chatConst.OpId.OpMuteUser] = function(tmpInfo)
		print("chatConst.OpId.OpMuteUser")
		print("self.roomMainData.roomID, tmpInfo.uid = ", self.roomMainData.roomID, tmpInfo.uid)
		SoraDShowMsgBox(i18n("chat_text_53"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
			if MSGBOX_CALLBACK_YES == msgType then
				voiceRoomCtrl:shutUser(self.roomMainData.roomID, tmpInfo.uid)
			end
		end)
	end
	;("menuType=")[chatConst.OpId.OpUnMuteUser] = function(tmpInfo)
		print("chatConst.OpId.OpUnMuteUser")
		print("self.roomMainData.roomID, tmpInfo.uid = ", self.roomMainData.roomID, tmpInfo.uid)
		voiceRoomCtrl:unshutUser(self.roomMainData.roomID, tmpInfo.uid)
	end
	;("menuType=")[chatConst.OpId.OpKickUser] = function(tmpInfo)
		print("chatConst.OpId.OpKickUser")
		print("self.roomMainData.roomID, tmpInfo.uid = ", self.roomMainData.roomID, tmpInfo.uid)
		SoraDShowMsgBox(i18n("chat_text_54"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
			if MSGBOX_CALLBACK_YES == msgType then
				voiceRoomCtrl:kickUser(self.roomMainData.roomID, tmpInfo.uid)
			end
		end)
	end
	local ("menuType=")[chatConst.OpId.OpSetOwner], controlList = function(tmpInfo)
		print("chatConst.OpId.OpSetOwner")
		print("self.roomMainData.roomID, tmpInfo.uid = ", self.roomMainData.roomID, tmpInfo.uid)
		SoraDShowMsgBox(i18n("chat_text_16"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
			if MSGBOX_CALLBACK_YES == msgType then
				voiceRoomCtrl:transferOwner(self.roomMainData.roomID, tmpInfo.uid)
			end
		end)
	end, "menuType="
	if controlList[menuType] then
		controlList[menuType](fromInfo)
	end
end
function voiceChatRoomView:itemClick(button, eventType)
	SoraDPlaySound()
	local chatMenu = include("chatMenu")
	local menuNode = chatMenu.new()
	menuNode:setSwallowTouches(true)
	menuNode:show()
	local _ENV, menus = menuNode.show, menuNode.show
	if tostring(button.bringData.uid) == self.myUID then
		chatConst = tostring(button.bringData.uid)
		menus, tostring(button.bringData.uid)[1] = tostring(button.bringData.uid), chatConst.OpId.OpLookPlayer
		if button.bringData.isFobid then
			table.insert(menus, chatConst.OpId.OpUnMuteUser)
		end
	elseif self.amIMaster then
		_UPVALUE3_ = self.amIMaster
		menus, self.amIMaster[1] = self.amIMaster, chatConst.OpId.OpLookPlayer
		menus, self.amIMaster[2] = self.amIMaster, chatConst.OpId.OpKickUser
		menus, self.amIMaster[3] = self.amIMaster, chatConst.OpId.OpSetOwner
		if button.bringData.isFobid then
			table.insert(menus, chatConst.OpId.OpUnMuteUser)
		else
			table.insert(menus, chatConst.OpId.OpMuteUser)
		end
	else
		chatConst = table.insert
		menus, table.insert[1] = table.insert, chatConst.OpId.OpLookPlayer
	end
	local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
	_ENV = self
	self.menus = menus
	self.isRA = false
	self.worldPos = pos
	self.alignv = gMenuAlignVType.bottom
	self.customData = button.bringData
	local self.handle, data = handler(self, self.menuCallBack), self
	menuNode:init(data)
end
function voiceChatRoomView:updateScroll(...)
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
function voiceChatRoomView:setSpeakStyleCheckBox(...)
	local speakStyle = VoiceChatSDKManager:getInstance().speakStyle
	if speakStyle == gSpeakStyle.hold then
		self.checkBoxHold:setSelected(true)
		self.checkBoxFree:setSelected(false)
	elseif speakStyle == gSpeakStyle.free then
		self.checkBoxHold:setSelected(false)
		self.checkBoxFree:setSelected(true)
	end
end
function voiceChatRoomView:updateSpeakMethod(...)
	self:setSpeakStyleCheckBox()
	VoiceChatSDKManager:getInstance():changeSpeakStyle()
end
function voiceChatRoomView:checkBoxHoldClick(checkBox, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		if VoiceChatSDKManager:getInstance().isBeMuted then
			checkBox:setSelected(not checkBox:isSelected())
			SoraDShowMsgTip(i18n("chat_text_18"))
		else
			if checkBox:isSelected() then
				checkBox:setSelected(not checkBox:isSelected())
			end
			self.checkBoxFree:setSelected(false)
			VoiceChatSDKManager:getInstance():changeSpeakStyle(gSpeakStyle.hold)
		end
	end
end
function voiceChatRoomView:checkBoxFreeClick(checkBox, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		if VoiceChatSDKManager:getInstance().isBeMuted then
			checkBox:setSelected(not checkBox:isSelected())
			SoraDShowMsgTip(i18n("chat_text_18"))
		else
			if checkBox:isSelected() then
				checkBox:setSelected(not checkBox:isSelected())
			end
			self.checkBoxHold:setSelected(false)
			VoiceChatSDKManager:getInstance():changeSpeakStyle(gSpeakStyle.free)
		end
	end
end
function voiceChatRoomView:btnExitClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local doIt = function(...)
			SoraDShowLoading(self)
			local roomId = VoiceChatSDKManager:getInstance().chatRoomId
			voiceRoomCtrl:exitRoom(roomId)
		end
		if self.amIMaster then
			SoraDShowMsgBox(i18n("chat_text_17"), i18n("common_text_204"), i18n("common_text_185"), function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					doIt()
				end
			end)
		else
			doIt()
		end
	end
end
function voiceChatRoomView:btnOptionClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self:checkHasAlliance() then
			SoraDShowMsgTip(i18n("common_text_826"))
			return
		end
		local panel = SoraDCreatePanel("voiceChatOptionView")
		panel:show()
	end
end
function voiceChatRoomView:btnAddClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self:checkHasAlliance() then
			SoraDShowMsgTip(i18n("common_text_826"))
			return
		end
		if self.amIMaster then
			local chatRoomSelPlayers = SoraDCreatePanel("chatRoomSelPlayers")
			chatRoomSelPlayers:show()
			local chatFunctions = include("chatFunctions")
			local chatConst = include("chatConst")
			local roomId = VoiceChatSDKManager:getInstance().chatRoomId or 0
			local memberIDs = (function(...)
				local _ENV, ret
				for k, v in pairs(self.roomMemberList) do
					table.insert(ret, v.uid)
				end
				return ret
			end)()
			_ENV = i18n("common_text_826")
			i18n("common_text_826").selPlayerOpType = chatConst.selPlayerOpType.selPlayerOnlineVoice
			i18n("common_text_826").members = memberIDs
			_ENV, i18n("common_text_826").owner = selfid, selfid
			selfid.roomId = roomId
			i18n("common_text_826").otherData, selfid.allianceName = selfid, "abbr"
			local i18n("common_text_826").isShowOnline, data = false, i18n("common_text_826")
			chatRoomSelPlayers:initWithData(data)
			chatRoomSelPlayers:setHandle(function(selectedPeople, otherData)
				dump(selectedPeople, "selectedPeople")
				dump(otherData, "otherData")
				local _ENV, selectedUids = dump, dump
				for i, v in ipairs(selectedPeople) do
					table.insert(selectedUids, v.playerId)
				end
				local chatDataModuleAPI = include("chatDataModuleAPI")
				chatDataModuleAPI:inviteUsersJoinVoiceRoom(roomId, selectedUids)
			end)
		else
			SoraDShowMsgTip(i18n("chat_text_46"))
		end
	end
end
function voiceChatRoomView:bgBottomSheerClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("voiceChatRecordsView")
		panel:show()
	end
end
function voiceChatRoomView:btnShareClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self:checkHasAlliance() then
			SoraDShowMsgTip(i18n("common_text_826"))
			return
		end
		local roomID = self.roomMainData.roomID
		if roomID == nil or not voiceRoomCtrl:isCanSendShare(roomID) then
			SoraDShowMsgTip(i18n("remains_text_149"))
			return
		end
		voiceRoomCtrl:setSendShare(roomID)
		VoiceChatSDKManager:getInstance().share(roomID, self.roomMainData.roomName)
	end
end
function voiceChatRoomView:checkHasAlliance()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	return allianceMgr:hasJoinAlliance(true)
end
function voiceChatRoomView:serverMessageGetLordInfo(target, data)
	if data.clientData then
		local targetName = data.clientData.targetName
		if targetName == self.__cname and data.lord then
			SoraDOpenLordView(data.lord)
		end
	end
end
function voiceChatRoomView:someoneSpeakCallBack(target, redata)
	local speakData = redata.speakData
	for _, v in ipairs(self.createOCXs) do
		local volume = speakData[v:getName()]
		if volume and tonumber(volume) > 0 then
			print("volume=", volume, "name = ", v:getName())
			v.runSpeakAction()
		end
	end
end
function voiceChatRoomView:onExitRoom(target, redata)
	SoraDRemoveAllAfterPanelFromManager(self)
end
return voiceChatRoomView
