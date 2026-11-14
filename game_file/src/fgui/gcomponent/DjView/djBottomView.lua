local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local djCtrl = gametop.playertop_:getModule("djCtrl")
local chatConst = include("chatConst")
local chatFunctions = include("chatFunctions")
local itemDesRead = include("itemDesRead")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatThemeMgr = gChatMgrs:getMgr("chatThemeMgr")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local djBottomView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/djBottomView", djBottomView)
_ENV = fgui.register_extension
fgui.register_extension.noticeItemId = 502001
fgui.register_extension.notceShopItemId = 1000059
fgui.register_extension.inputHeight = 64
_ENV, fgui.register_extension.editboxHeight = "ui://DjView/djBottomView", 55
;("ui://DjView/djBottomView").left = 15
;("ui://DjView/djBottomView").right = 15
;("ui://DjView/djBottomView").top = 12
_ENV, fgui.register_extension.paddingEditbox, ("ui://DjView/djBottomView").bottom = "ui://DjView/djBottomView", "ui://DjView/djBottomView", 12
_ENV = nil
;(nil).width = 560
;("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text], (nil).height = nil, 64
_ENV = nil
;(nil).width = 504
;("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text_Emo], (nil).height = nil, 64
_ENV = nil
;(nil).width = 424
;("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text_Emo_Horn], (nil).height = nil, 64
_ENV = nil
;(nil).width = 496
;("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text_Emo_Audio], (nil).height = nil, 64
_ENV = nil
;(nil).width = 560
;("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text_Audio], (nil).height = nil, 64
_ENV = nil
;(nil).width = 490
;("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text_Horn], (nil).height = nil, 64
_ENV = nil
;(nil).width = 424
_ENV, fgui.register_extension.inputBgCfg, ("ui://DjView/djBottomView")[chatConst.ChatInputType.Input_Text_Emo_Audio_Horn], (nil).height = "ui://DjView/djBottomView", "ui://DjView/djBottomView", nil, 64
;("ui://DjView/djBottomView").normal = "frame_LT_shurukuang01.png"
_ENV, fgui.register_extension.inputBgImage, ("ui://DjView/djBottomView").notice = "ui://DjView/djBottomView", "ui://DjView/djBottomView", "frame_LT_shurukuang02.png"
;("ui://DjView/djBottomView").left = 8
_ENV, fgui.register_extension.paddingBtnSend, ("ui://DjView/djBottomView").right = "ui://DjView/djBottomView", "ui://DjView/djBottomView", 6
;("ui://DjView/djBottomView").left = 8
_ENV, fgui.register_extension.paddingBtnAudio, ("ui://DjView/djBottomView").right = "ui://DjView/djBottomView", "ui://DjView/djBottomView", 6
;("ui://DjView/djBottomView").left = 6
_ENV, fgui.register_extension.paddingInput, ("ui://DjView/djBottomView").right = "ui://DjView/djBottomView", "ui://DjView/djBottomView", 6
;("ui://DjView/djBottomView").left = 4
fgui.register_extension.paddingBtnEmoticon, ("ui://DjView/djBottomView").right = "ui://DjView/djBottomView", 4
local fgui.register_extension.inputFontSize, _defaultParam = 24, fgui.register_extension
function djBottomView:onInit()
	self.maxCharCount = gChatMaxLength.normalChatLength
	self.isChangeDirty = false
	self.isShowBtnKNotice = false
	self.isShowBtnEmotion = false
	self.isPrizeShow = false
	self.isPrizeInit = false
	self.prizeData, _ENV, self.oldStr = gChatMaxLength.normalChatLength, gChatMaxLength.normalChatLength, ""
	self.prizeIndex = 1
	self.nodeChat = SoraDGetChildByName(self, "Node_chat")
	self.buttonSend = SoraDGetChildByName(self, "Button_Send")
	self.btnPrize = SoraDGetChildByName(self, "Button_prize")
	self.btnBeInvite = SoraDGetChildByName(self, "Button_beInvite")
	self.btnBeInvite:setVisible(false)
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.btnRank:setVisible(false)
	self.nodeDj = self.controllers.Node_dj
	self.btnStart = SoraDGetChildByName(self, "Button_start")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.nodePrize = SoraDGetChildByName(self, "Node_Prize")
	self.scrollPrize = SoraDGetChildByName(self, "giftList")
	self.btnGiving = SoraDGetChildByName(self, "Button_giving")
	self.btnGiving:setTitleText(i18n("common_text_3644"))
	self.labelTotalGold = SoraDGetChildByName(self, "Text_totalGold")
	self.labelTotalGold = SoraDChangeTextToHtml(self.labelTotalGold)
	self.scrollPrize:setItemRenderer(handler(self, self.onItemRender))
	self.gift_mask = SoraDGetChildByName(self, "gift_mask")
	self.textBg = SoraDGetChildByName(self, "textBg")
	self.nodeBg = SoraDGetChildByName(self, "nodeBg")
	self.textBg2 = SoraDGetChildByName(self, "textBg2")
	self.textField = SoraDGetChildByName(self, "textField")
	self.textField:setName("textField")
	if self.textField.setControlType then
		self.textField:setControlType(1)
	end
	self.textField:setSingleLine(true)
	self.textField:setNoToolBar(true)
	function self.textField:getCharCount()
		return string.utf8len(self:getText())
	end
	function self.textField:getString()
		return RemoveStringSpecial(self:getText())
	end
	self.textField:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_072")))
	self.textField:registerScriptEditBoxHandler(handler(self, self.editBoxTextEvent))
	self.btnPrize:addClickEventListener(handler(self, self.onBtnPrize))
	self.gift_mask:addClickListener(handler(self, self.onBtnPrize))
	self.buttonSend:addClickEventListener(handler(self, self.OnBtnSendEvent))
	self.btnGiving:addClickEventListener(handler(self, self.OnBtnSendGiftEvent))
	self.btnStart:addClickEventListener(handler(self, self.OnBtnStartEvent))
	self.btnRank:addClickEventListener(handler(self, self.OnBtnRankEvent))
	self.btnBeInvite:addClickEventListener(handler(self, self.onBtnBeInvite))
	self:initKNotice()
	self.fields.Com_btns:fixPos()
end
function djBottomView:onShow()
	self.nodePrize:setVisible(false)
end
function djBottomView:onHide()
	self:stopTimer()
end
function djBottomView:initKNotice()
	self:setMaxCharCount(gChatMaxLength.normalChatLength)
	self:setChatInputType(chatConst.ChatInputType.Input_Text)
end
function djBottomView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CHAT_CLOSE_IME", handler(self, self.hideKeyPad))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_AUDIENCE_BEINVITE", handler(self, self.beInvite))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateGold))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_SHOW_EFFECT", handler(self, self.showPrivilegeDebut))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(...)
		if self.prizeData[2] then
			for i, v in ipairs(self.prizeData) do
				if v.data.shopItemID then
					local count = self:getItemCount(v.data.itemId)
					if 0 < count then
						v.point.labelGold:setVisible(true)
						self = nil
						;(nil).count = string.formatnumberthousands(count)
						v.point.labelGold:setString(i18n("common_text_1377", nil))
						v.point.lab_item:setVisible(false)
					else
						v.point.labelGold:setVisible(false)
						v.point.lab_item:setVisible(true)
						v.point.lab_item:initData(v.data.price[1], v.data.price[2], true)
					end
				end
			end
		end
	end)
end
function djBottomView:initData(djUid, parent)
	self.djuid = djUid
	print("self.djuid=====", self.djuid)
	self.parent = parent
	self:updateView()
end
function djBottomView:updateGold()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	local numColor = display.CORLOR_YELLOW
	gametop = nil
	gametop, gametop, (nil).gold = haveGold, string.formatnumberthousands(haveGold), string.formatnumberthousands(haveGold)
	string.formatnumberthousands(haveGold).gold, haveGold.color = haveGold, numColor
	self.labelTotalGold:setString(i18n_html("Anchor_text_67", nil, (string.formatnumberthousands(haveGold))))
end
function djBottomView:beInvite(target, data)
	if data and data.isInvite then
		self.btnBeInvite:setVisible(true)
	else
		self.btnBeInvite:setVisible(false)
	end
end
function djBottomView:updateView()
	self.btnPrize:setVisible(not djCtrl:isDJAnchor())
	self.nodeDj:setSelectedIndex(djCtrl:isDJAnchor() and 1 or 0)
	self.fields.Com_btns:setPositionY(djCtrl:isDJAnchor() and -297 or -227)
	fguiHelper.get_controllers(self.nodePrize).c1:setSelectedIndex(1)
	fguiHelper.get_controllers(self.nodeChat).c1:setSelectedIndex(djCtrl:isDJAnchor() and 1 or 0)
	if not SoraDFIsRA() then
		self.nodeChat:fixChildrenPos(true)
	end
	if djCtrl:isDJAnchor() then
		self:updateDJNode()
	else
		self.btnBeInvite:setVisible(djCtrl:isBeInvite())
	end
	self.btnRank:setVisible(djCtrl.isBroadcast)
end
function djBottomView:updateDJNode()
	if djCtrl.isBroadcastDJ then
		self.btnStart:setTitleText("")
		self.btnStart:setBtnColorIndex(1)
		self.labelTime:setVisible(true)
		if self.timerKey == nil then
			self:startTimer(1)
			self:updateTime()
		end
	else
		self:stopTimer()
		self.btnStart:setTitleText(i18n("Anchor_text_65"))
		self.btnStart:setBtnColorIndex(0)
		self.labelTime:setVisible(false)
	end
end
function djBottomView:updatePrizeView()
	local data = djCtrl:getPrizeList()
	self.prizeData, djCtrl = djCtrl, djCtrl
	for i, v in ipairs(data) do
		djCtrl = nil
		;(nil).data = v
		table.insert(self.prizeData, nil)
	end
	self.scrollPrize:setNumItems(#self.prizeData)
	self.scrollPrize:scrollToView(0)
	self:updateZanNode()
	self:updateGold()
end
function djBottomView:onItemRender(index, single)
	local data = self.prizeData[index + 1].data
	self.prizeData[index + 1].point = single
	single.labelPoint = SoraDGetChildByName(single, "Text_point")
	single.nodeZan = fguiHelper.get_controllers(single).Node_zan
	single.btnMinus = SoraDGetChildByName(single, "Button_minus")
	single.btnAdd = SoraDGetChildByName(single, "Button_add")
	single.labelGold = SoraDGetChildByName(single, "Text_gold")
	single.lab_item = SoraDGetChildByName(single, "lab_item")
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.imgPrize = SoraDGetChildByName(single, "Image_prize")
	single.imgPrizeBg = SoraDGetChildByName(single, "Image_prizeBg")
	single.imgLight = SoraDGetChildByName(single, "Image_light")
	single.imgPrize:setURL(itemDesRead.getIcon(data.itemId))
	single.labelName:setString(itemDesRead.getName(data.itemId))
	if data.shopItemID then
		single.nodeZan:setSelectedIndex(0)
		single.labelGold:setColor(display.COLOR_WHITE)
		local count = self:getItemCount(data.itemId)
		if 0 < count then
			single.labelGold:setVisible(true)
			_ENV = itemDesRead.getName(data.itemId)
			itemDesRead.getName(data.itemId).count = string.formatnumberthousands(count)
			single.labelGold:setString(i18n("common_text_1377", itemDesRead.getName(data.itemId)))
			single.lab_item:setVisible(false)
		else
			single.labelGold:setVisible(false)
			single.lab_item:setVisible(true)
			single.lab_item:initData(data.price[1], data.price[2], true)
		end
		single.labelPoint:setString("+" .. data.point)
		single.imgLight:setVisible(false)
	else
		single.lab_item:setVisible(false)
		single.nodeZan:setSelectedIndex(1)
		single.btnMinus:setTag(1)
		single.btnAdd:setTag(2)
		single.btnMinus:setSwallowTouches(false)
		single.btnAdd:setSwallowTouches(false)
		single.btnMinus:addClickEventListener(handler(self, self.onBtnPrizeZanSingle))
		single.btnAdd:addClickEventListener(handler(self, self.onBtnPrizeZanSingle))
		_ENV = single.btnAdd.addClickEventListener
		_ENV, single.btnAdd.addClickEventListener.point = single.btnAdd, single
		single.btnAdd[1] = 9
		single.btnAdd[2] = 44
		single.btnAdd[3] = 77
		single.btnAdd[4] = 444
		single.btnAdd[5] = 777
		single.btnAdd[6] = 999
		single.btnAdd[7] = 4444
		single.btnAdd[8] = 7777
		single.btnAdd.addClickEventListener.nums, single.btnAdd[9] = single.btnAdd, 9999
		self.zanData, single.btnAdd.addClickEventListener.numIndex = single.btnAdd.addClickEventListener, 1
		self.curLight = single.imgLight
	end
	single.imgPrizeBg:setTouchEnabled(true)
	single.imgPrizeBg:setSwallowTouches(false)
	single:setTag(index + 1)
	if not single.addClicked then
		single:addClickEventListener(handler(self, self.onBtnPrizeSingle))
		single.addClicked = true
	end
	return single
end
function djBottomView:updateZanNode()
	local data = self.prizeData[1].data
	local num = self.zanData.nums[self.zanData.numIndex]
	self.zanData.point.labelPoint:setString("+" .. string.formatnumberthousands(data.point * num))
	self.zanData.point.labelGold:setVisible(true)
	self.zanData.point.labelGold:setString(tostring(num))
	self.zanData.point.lab_item:setVisible(false)
end
function djBottomView:onBtnPrizeZanSingle(button, type)
	print("点击了礼物按钮")
	SoraDPlaySound()
	local offset = 1
	if button:getTag() == 1 then
		offset = -1
	end
	self.zanData.numIndex = math.max(1, math.min(self.zanData.numIndex + offset, 9))
	self:updateZanNode()
end
function djBottomView:onBtnBeInvite()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Anchor_text_192")
	;(nil).confirmFunc = function()
		djCtrl:reqAgreeInvite()
	end
	;(nil).cancelFunc = function()
		djCtrl:reqAgreeInvite(true)
		self.btnBeInvite:setVisible(false)
	end
	uiManager:show("MessageBox", nil)
end
function djBottomView:checkTextSend(chatChannel, subType)
	local interval = gChatChannel2MsgInterval[chatChannel]
	if type(interval) == "table" then
		interval = interval[subType]
	end
	local canSend = chatSendMgr:checkIntervalTime(interval)
	return canSend
end
function djBottomView:OnBtnSendGiftEvent(button, type)
	print("发送按钮: Send Click", self.prizeIndex)
	SoraDPlaySound()
	if djCtrl.isBroadcastDJ then
		SoraDShowMsgTip(i18n("Anchor_text_55"))
		return
	end
	local curChannel = chatDataMgr:getChatChannel()
	if self.prizeData[self.prizeIndex] then
		if not djCtrl.isBroadcast then
			SoraDShowMsgTip(i18n("Anchor_text_26"))
			return
		end
		local data = self.prizeData[self.prizeIndex].data
		local shopItemID, costItemID
		local itemID = data.itemId
		local count = 1
		local canSend = true
		if self.prizeIndex == 1 then
			count = self.zanData.nums[self.zanData.numIndex]
			print("itemID", itemID, count)
			canSend = count <= self:getItemCount(itemID)
		else
			local haveCount = self:getItemCount(itemID)
			if haveCount <= 0 then
				costItemID = data.price[1]
				shopItemID = data.shopItemID
				canSend = SoraDEnoughGold(data.price[2] * count, true)
			end
		end
		if canSend then
			_ENV = data.price[2] * count
			;(data.price[2] * count).messageType = gChatTypeDef.chat_content_dj_gift
			;(data.price[2] * count).costItemID = costItemID
			;(data.price[2] * count).itemID = itemID
			;(data.price[2] * count).count = count
			;(data.price[2] * count).shopItemID = shopItemID
			djCtrl:sendMessage(data.price[2] * count, gChatTypeDef.chat_content_dj_gift)
		else
			SoraDShowMsgTip(i18n("Anchor_text_27"))
		end
	end
end
function djBottomView:OnBtnSendEvent(button, type)
	print("发送按钮: Send Click")
	SoraDPlaySound()
	local textContent = self.textField:getString()
	if textContent and string.len(textContent) > 0 then
		_ENV = nil
		;(nil).messageType = gChatTypeDef.chat_content_dj_text
		;(nil).content = textContent
		djCtrl:sendMessage(nil, gChatTypeDef.chat_content_dj_text)
	end
	self.textField:setText("")
end
function djBottomView:onBtnPrizeSingle(button, type)
	print("点击了礼物按钮", button:getTag())
	SoraDPlaySound()
	if self.curLight then
		self.curLight:setVisible(false)
	end
	self.curLight = button.imgLight
	self.curLight:setVisible(true)
	self.prizeIndex = button:getTag()
end
function djBottomView:OnBtnStartEvent(button, type)
	SoraDPlaySound()
	local fun = function(...)
		if djCtrl.isDJ then
			djCtrl:sendDJOpen()
			SoraDShowLoading(nil, nil, nil, nil, 10)
		else
			SoraDShowMsgTip(i18n("Anchor_text_18"))
			SoraDRemoveAllPanelFromManager()
		end
	end
	if djCtrl.isBroadcastDJ then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(djCtrl:getCurDJLiveBeginTime())
		SoraDShowMsgBox(i18n("Anchor_text_33", nil), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				fun()
			end
		end)
	else
		VoiceChatSDKManager:getInstance():req4Permission()
		fun()
	end
end
function djBottomView:onBtnPrize(button, type)
	print("点击了礼包按钮")
	SoraDPlaySound()
	local isVisible = not self.nodePrize:isVisible()
	self.nodePrize:setVisible(isVisible)
	if isVisible and not self.isPrizeInit then
		self:updatePrizeView()
		self.isPrizeInit = true
	end
	self.isPrizeShow = isVisible
end
function djBottomView:switchBtn(bool)
	self.isPrizeShow = bool
end
function djBottomView:showKeyPad(...)
	self.textField:touchDownAction(self.textField, ccui.TouchEventType.ended)
	if self.parent and self.parent.showKeyboardMask then
		self.parent:showKeyboardMask()
	end
end
function djBottomView:hideKeyPad(...)
	self.textField:closeKeyboard()
end
function djBottomView:startTimer(delay)
	print("----------startTimer()-----")
	if self.timerKey == nil then
		self.timerKey = SoraDCreateTimerEx(self, handler(self, self.updateTime), delay)
	end
end
function djBottomView:stopTimer()
	if self.timerKey then
		SoraDManagerRemoveTimer(self, self.timerKey)
		self.timerKey = nil
	end
end
function djBottomView:updateTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(djCtrl:getCurDJLiveBeginTime())
	self.labelTime:setString(string.format([[
%s
%s]], i18n("Anchor_text_32", nil), i18n("Anchor_text_66")))
end
function djBottomView:onExitOther()
	self:stopTimer()
	self:hideKeyPad()
end
function djBottomView:updateTheme()
end
function djBottomView:getItemCount(itemId)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(itemId)
	return itemCount
end
function djBottomView:confirmUseItemCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local textContent = self.textField:getString()
		if textContent and string.len(textContent) > 0 then
			if string.len(textContent) > gChatMaxLength.kongdomNoticeChatLength then
				textContent = SubStringUTF8(textContent, 1, gChatMaxLength.kongdomNoticeChatLength)
			end
			chatCtrl:sendServiceMessageByProp(textContent)
		end
		self.textField:setText("")
	end
end
function djBottomView:getBottomViewHeight()
	return self.textBg:getContentSize().height
end
function djBottomView:setViewType(viewType)
	self.viewType = viewType
	if self.viewType == "chatView" then
		self.isCanChat = chatCtrl:canChat()
		if not self.isCanChat then
			self.textField:setPlaceHolder(i18n("common_text_1039"))
		else
			self.textField:setPlaceHolder(i18n("common_text_072"))
		end
	end
end
function djBottomView:getViewType()
	return self.viewType
end
function djBottomView:setMaxCharCount(maxCharCount)
	if self.textField then
		self.maxCharCount = maxCharCount
		self.textField:setMaxLength(self.maxCharCount)
		local charCount = self.textField:getCharCount()
		local strCount = string.format("%d/%d", charCount, self.maxCharCount)
	end
end
function djBottomView:getLTrimTextCount()
	local strText = self.textField:getString()
	strText = string.ltrim(strText)
	if strText == nil then
		strText = ""
	end
	return string.utf8len(strText)
end
function djBottomView:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	if strEventName == "began" then
		if self.parent and self.parent.showKeyboardMask then
			self.parent:showKeyboardMask()
		end
	elseif strEventName == "ended" then
	elseif strEventName == "return" then
		if self.parent and self.parent.hideKeyboardMask then
			self.parent:hideKeyboardMask()
		end
	elseif strEventName == "changed" then
	end
end
function djBottomView:setChatInputType(chatInputType)
end
function djBottomView:OnBtnRankEvent(button, type)
	SoraDPlaySound()
	_ENV = nil
	;(nil).uid = self.djuid
	uiManager:show("DjRankView", nil)
end
function djBottomView:refreshReceiveBtn(...)
end
function djBottomView:showPrivilegeDebut(...)
	if not self.debutEffect then
		local effect = SoraDCreatAnimation("Node_Effect_ltjm101", nil, false)
		effect:addTo(self, -1)
		effect:setPosition(0, 300)
		_UPVALUE3_ = 300
		;(300)[1] = cca.delay(3.0)
		;(300)[2] = cca.callFunc(function()
			self.debutEffect = nil
		end)
		;(300)[3] = cca.delay(3.0)
		;(300)[4] = cca.callFunc(function()
			effect:removeFromParent()
		end)
		;(300)[5] = cca.callFunc(function()
			effect:removeFromParent()
		end)
		effect:runAction(cca.seq(300))
		self.debutEffect = effect
	end
end
return djBottomView
