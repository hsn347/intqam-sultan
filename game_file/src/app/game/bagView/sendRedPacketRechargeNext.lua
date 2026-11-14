local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local propCtrl = gametop.playertop_:getModule("propCtrl")
_ENV, _ENV = "propCtrl", gametop.playertop_
;("propCtrl").min = 50
_ENV, gametop.playertop_.gold, ("propCtrl").max = "propCtrl", "propCtrl", 99999
;("propCtrl").min = 10
gametop.playertop_.count, ("propCtrl").max = "propCtrl", 200
local tableInput = gametop.playertop_
local SendRedPacketRechargeNext = class("sendRedPacketRechargeNext", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sendRedPacketRechargeNext")
	end
	return target
end)
function SendRedPacketRechargeNext:ctor()
	self.infoTbl, _ENV, self.isHaveTextField = nil, nil, true
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_gift")
	self.nodeGift = SoraDGetChildByName(self, "Node_gift")
	local scrollH = math.max(815, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	self.nodeGift:setPositionY(scrollH - 870)
	self.nodeFramMail = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.mailViewFrame = SoraDGetExtendChildFromCCSByName(self, "CCS_mailViewFrame_node", true)
	self.imgMsg = SoraDGetChildByName(self, "Image_msg")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Image_bg"):setPositionY(display.cy)
	self.labelSendTo = SoraDGetChildByName(self, "Text_sendTo")
	self.labelKingdom = SoraDGetChildByName(self, "Text_kingdom")
	self.labelAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.labelGoldTitle = SoraDGetChildByName(self, "Text_goldTitle")
	self.labelGiftTitle = SoraDGetChildByName(self, "Text_giftTitle")
	self.labelMsgTitle = SoraDGetChildByName(self, "Text_msgTitle")
	self.labelGiftDes = SoraDGetChildByName(self, "Text_giftDes")
	self.labelGoldDes = SoraDGetChildByName(self, "Text_goldDes")
	self.txtGold = SoraDGetChildByName(self, "BitmapFontLabel_gold")
	self.textFieldCount = SoraDGetChildByName(self, "TextField_gift")
	self.textFieldCount:addEventListener(handler(self, self.OnInputChangeEnd))
	self.textFieldCount:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textFieldCount:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	_ENV = handler(self, self.OnInputChangeEnd)
	handler(self, self.OnInputChangeEnd).min = tableInput.count.min
	handler(self, self.OnInputChangeEnd).max = tableInput.count.max
	self.textFieldCount:setPlaceHolder(i18n("common_text_1828", handler(self, self.OnInputChangeEnd)))
	self.textFieldCount:setTextColor(cc.c4b(0, 0, 0, 255))
	self.textFieldCount:setPlaceHolderColor(cc.c3b(170, 170, 170))
	self.editContent = ccui.EditBox:create(cc.size(550, 50), "bg_transparent.png", ccui.TextureResType.plistType)
	self.editContent:setPosition(cc.p(300, 35))
	self.editContent:setFontColor(display.COLOR_BLACK)
	self.editContent:setMaxLength(gChatMaxLength.redPacketContent)
	self.editContent:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.editContent:setPlaceHolder(i18n("common_text_1832"))
	self.editContent:addTo(self.imgMsg)
	self.nodeFramMail:setTitle(i18n("common_text_3479"))
	self.labelSendTo:setString(i18n("common_text_1833"))
	self.labelKingdom:setString(i18n("common_text_070"))
	self.labelAlliance:setString(i18n("common_text_946"))
	self.labelGoldTitle:setString(i18n("common_text_1827"))
	self.labelGiftTitle:setString(i18n("common_text_1826"))
	self.labelMsgTitle:setString(i18n("common_text_1998"))
	self.labelGiftDes:setString(i18n("common_text_3482"))
	self.labelGoldDes:setString(i18n("common_text_3481"))
	self.btnSend = SoraDGetChildByName(self, "Button_send")
	self.btnSend:setTitleText(i18n("common_text_073"))
	self.btnSend:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnGood = SoraDGetChildByName(self, "Button_good")
	self.btnGood:setPressedActionEnabled(true)
	self.btnGood:addTouchEventListener(handler(self, self.btnGoodClickCallBack))
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnAlliance:addTouchEventListener(handler(self, self.btnTypeClickCallBack))
	self.btnKingdom = SoraDGetChildByName(self, "Button_kingdom")
	self.btnKingdom:addTouchEventListener(handler(self, self.btnTypeClickCallBack))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REDPACKETNEXTSUCCESS", handler(self, self.rechargeSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REDPACKETNEXTCEHCKFAIL", handler(self, self.rechargeFail))
	self:changeType(allianceMgr:hasJoinAlliance() ~= nil)
	self:updateCreateBtnTouchEnable()
end
function SendRedPacketRechargeNext:updateCreateBtnTouchEnable()
	local isEnable = true
	local count = self.textFieldCount:getString()
	local gold = self.infoTbl.gold
	isEnable = count ~= "" and gold ~= ""
	self.btnSend:setTouchEnabled(isEnable)
	self.btnSend:setBright(isEnable)
	if self.outAppPurchaseButtons then
		self.outAppPurchaseButtons:setGray(isEnable)
	end
end
function SendRedPacketRechargeNext:OnInputChangeEnd(textField, eventType)
	if eventType == ccui.TextFiledEventType.attach_with_ime and self.scroll and not SoraDIsNodeVisibleOnScroll(textField, self.scroll) then
		print("node is not on view")
		if textField.closeIME then
			textField:closeIME()
		end
	end
	local curData = textField == self.textFieldGold and tableInput.gold or tableInput.count
	local input = textField:getString()
	input = math.floor(tonumber(input) or 0)
	if input > curData.max then
		input = curData.max
	end
	textField:setString(input)
	if eventType == ccui.TextFiledEventType.detach_with_ime then
		if input == nil or input < curData.min then
			input = curData.min
		end
		textField:setString(input)
		self:updateCreateBtnTouchEnable()
	end
end
function SendRedPacketRechargeNext:initData(infoTbl)
	self.infoTbl = infoTbl
	if self.infoTbl.result and self.infoTbl.result[1] == gIDDef.GOLD then
		self.infoTbl.gold = self.infoTbl.result[2]
	end
	self:initView()
	self:updateOutAppPurchase()
end
function SendRedPacketRechargeNext:initView(...)
	self.txtGold:setString(self.infoTbl.gold)
	local showPrice, isGetPrice = paymentManager.judgePrice(self.infoTbl.rid, self.infoTbl.price)
	self.btnSend:setTitleText(showPrice)
	self.nowPrice = showPrice
end
function SendRedPacketRechargeNext:rechargeFail(target, redata)
	SoraDCloseLoading(self)
end
function SendRedPacketRechargeNext:rechargeSuccess(...)
	local chatChannel = self.btnAlliance:isSelected() and gChatChannel.ALLIANCE or gChatChannel.KINGDOM
	local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
	chatRedPacketMgr:setSendRPChannel(chatChannel)
	_ENV = chatRedPacketMgr
	chatRedPacketMgr.msg = "MESSAGE_ITEM_USE_SUCCESS_RED_PACKET"
	chatRedPacketMgr.isSuccess = true
	SoraDSendMessage(chatRedPacketMgr)
	self:close(nil, ccui.TouchEventType.ended)
end
function SendRedPacketRechargeNext:btnTypeClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self:changeType(button == self.btnAlliance)
	end
end
function SendRedPacketRechargeNext:btnGoodClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		local publicRead = include("publicRead")
		_UPVALUE18_ = "publicRead"
		;("publicRead")[1] = 100306
		;("publicRead")[2] = 1
		;("publicRead")[3] = 100206
		;("publicRead")[4] = 1
		;("publicRead")[5] = 100506
		;("publicRead")[6] = 1
		;("publicRead")[7] = 100606
		;("publicRead")[8] = 1
		;("publicRead")[9] = 500603
		;("publicRead")[10] = 1
		;("publicRead")[11] = 500602
		;("publicRead")[12] = 1
		;("publicRead")[13] = 500902
		;("publicRead")[14] = 1
		;("publicRead")[15] = 600204
		;("publicRead")[16] = 1
		;("publicRead")[17] = 502703
		;("publicRead")[18] = 1
		;("publicRead")[19] = 300302
		local ("publicRead")[20], rewardList = 1, "publicRead"
		local uList = SoraDIntArr2FormatTable(rewardList)
		local des = ""
		for i, v in ipairs(uList) do
			des = des .. "\n" .. publicRead.getName(v.id) .. "*" .. v.num
		end
		_ENV = 1
		;(1).list = des
		SoraDShowHelpMsgTip(i18n("common_text_3483", 1))
	end
end
function SendRedPacketRechargeNext:changeType(isAlliance)
	self.btnAlliance:setSelected(isAlliance)
	self.btnAlliance:setTouchEnabled(not isAlliance)
	self.btnKingdom:setSelected(not isAlliance)
	self.btnKingdom:setTouchEnabled(isAlliance)
end
function SendRedPacketRechargeNext:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function SendRedPacketRechargeNext:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tmpGold = tonumber(self.infoTbl.gold)
		local tmpNum = tonumber(self.textFieldCount:getString())
		local tmpText = self.editContent:getText() == "" and self.editContent:getPlaceHolder() or self.editContent:getText()
		local tmpType = self.btnAlliance:isSelected() and 1 or 2
		local tmpUID = lordInfoCtrl:getLordInfo().base.uid
		if allianceMgr:hasJoinAlliance() == nil and tmpType == 1 then
			SoraDShowMsgBox(i18n("common_text_1793"), i18n("common_text_068"), nil, function(msgType)
				if msgType == MSGBOX_CALLBACK_YES then
					uiManager:show("AllianceJoinView")
				end
			end)
		elseif tmpNum <= 0 then
			SoraDShowMsgTip(i18n("common_text_4050"))
		else
			_ENV = i18n("common_text_4050")
			i18n("common_text_4050").tmpType = tmpType
			i18n("common_text_4050").tmpNum = tmpNum
			i18n("common_text_4050").tmpText = tmpText
			paymentManager.normalGiftBuyClassify(self.infoTbl.rid, i18n("common_text_4050"))
		end
	elseif eventType == ccui.TouchEventType.began then
		self:updateCreateBtnTouchEnable()
	end
end
function SendRedPacketRechargeNext:updateOutAppPurchase(isShow)
	if SoraDCheckOAPIsOpen(self.infoTbl.rid) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(SoraDGetChildByName(self, "BottomBg"))
			self.outAppPurchaseButtons:setPosition(cc.p(320, 37))
		end
		self.outAppPurchaseButtons:setVisible(true)
		self.btnSend:setVisible(false)
		_ENV = false
		;(false).rid = self.infoTbl.rid
		;(false).nowPrice = self.nowPrice
		;(false).handlePurchaseBack = handler(self, self.rechargeSuccess)
		;(false).handleItemBuyClick = handler(self, self.handleItemBuyClick)
		;(false).handleBuyClick = handler(self, self.btnClickCallBack)
		self.outAppPurchaseButtons:initData(false)
		self.outAppPurchaseButtons:setGray(false)
		_ENV, _UPVALUE1_ = false, self.outAppPurchaseButtons
		;(false).rechargeID = self.infoTbl.rid
		self.outAppPurchaseButtons[1] = false
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, SoraDGetChildByName(self, "BottomBg"), cc.p(560, display.height - 130), 0.9)
	else
		_ENV, _UPVALUE1_ = SoraDGetChildByName(self, "BottomBg"), self.outAppPurchaseButtons
		SoraDGetChildByName(self, "BottomBg").rechargeID = self.infoTbl.rid
		self.outAppPurchaseButtons[1] = SoraDGetChildByName(self, "BottomBg")
		SoraDCreateRechargeGiftNode(self.outAppPurchaseButtons, SoraDGetChildByName(self, "BottomBg"), cc.p(110, 45), 0.9)
	end
end
function SendRedPacketRechargeNext:handleItemBuyClick()
	local tmpGold = tonumber(self.infoTbl.gold)
	local tmpNum = tonumber(self.textFieldCount:getString())
	local tmpText = self.editContent:getText() == "" and self.editContent:getPlaceHolder() or self.editContent:getText()
	local tmpType = self.btnAlliance:isSelected() and 1 or 2
	local tmpUID = lordInfoCtrl:getLordInfo().base.uid
	if allianceMgr:hasJoinAlliance() == nil and tmpType == 1 then
		SoraDShowMsgBox(i18n("common_text_1793"), i18n("common_text_068"), nil, function(msgType)
			if msgType == MSGBOX_CALLBACK_YES then
				uiManager:show("AllianceJoinView")
			end
		end)
		return false
	elseif tmpNum <= 0 then
		SoraDShowMsgTip(i18n("common_text_4050"))
		return false
	else
		_ENV = i18n("common_text_4050")
		i18n("common_text_4050").chatChannel = tmpType
		i18n("common_text_4050").giftCount = tmpNum
		i18n("common_text_4050").message = tmpText
		return true, i18n("common_text_4050")
	end
end
return SendRedPacketRechargeNext
