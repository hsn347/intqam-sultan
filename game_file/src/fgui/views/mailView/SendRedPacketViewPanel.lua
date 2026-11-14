local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local mailFunctions = include("mailFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SendRedPacketViewPanel = class("SendRedPacketViewPanel", baseFguiPanel)
_UPVALUE2_ = nil
;(nil)[1] = 50
;(nil)[2] = 20000
local gold_range = constantRead.getConstValueArray("GOODWILL_PAKA_GOLD_RANGE", nil)
_UPVALUE2_ = 50
;(50)[1] = 10
;(50)[2] = 50
local num_range = constantRead.getConstValueArray("GOODWILL_PAKA_NUM_RANGE", 50)
_ENV, _ENV = 50, "GOODWILL_PAKA_NUM_RANGE"
;(50).min = gold_range[1]
_ENV, ("GOODWILL_PAKA_NUM_RANGE").gold, (50).max = 50, 50, gold_range[2]
;(50).min = num_range[1]
;("GOODWILL_PAKA_NUM_RANGE").count, (50).max = 50, num_range[2]
local tableInput = "GOODWILL_PAKA_NUM_RANGE"
function SendRedPacketViewPanel:ctor(...)
	SendRedPacketViewPanel.super.ctor(self, ...)
	print("SendRedPacketViewPanel:ctor", self.viewName)
	self.debug = true
end
function SendRedPacketViewPanel:onInit()
	print("=======SendRedPacketViewPanel:onInit")
	self.itemID = 0
	self.fields.Com_title:initData(i18n("common_text_1825"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.labelSendTo = SoraDGetChildByName(self, "Text_sendTo")
	self.labelKingdom = SoraDGetChildByName(self, "Text_kingdom")
	self.labelAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.labelGoldTitle = SoraDGetChildByName(self, "Text_goldTitle")
	self.labelGiftTitle = SoraDGetChildByName(self, "Text_giftTitle")
	self.labelGiftDes = SoraDGetChildByName(self, "Text_giftDes")
	self.labelGoldDes = SoraDGetChildByName(self, "Text_goldDes")
	self.fields.TextField_gift:addEventListener(fgui.UIEventType.Submit, handler(self, self.OnInputChangeEnd))
	self.fields.TextField_gold:addEventListener(fgui.UIEventType.Submit, handler(self, self.OnInputChangeEnd))
	_ENV = handler(self, self.OnInputChangeEnd)
	handler(self, self.OnInputChangeEnd).min = tableInput.gold.min
	handler(self, self.OnInputChangeEnd).max = tableInput.gold.max
	self.fields.TextField_gold:setPrompt(i18n("common_text_1829", handler(self, self.OnInputChangeEnd)))
	_ENV = i18n("common_text_1829", handler(self, self.OnInputChangeEnd))
	i18n("common_text_1829", handler(self, self.OnInputChangeEnd)).min = tableInput.count.min
	i18n("common_text_1829", handler(self, self.OnInputChangeEnd)).max = tableInput.count.max
	self.fields.TextField_gift:setPrompt(i18n("common_text_1828", i18n("common_text_1829", handler(self, self.OnInputChangeEnd))))
	self.labelSendTo:setString(i18n("common_text_1833"))
	self.labelKingdom:setString(i18n("common_text_070"))
	self.labelAlliance:setString(i18n("common_text_946"))
	self.labelGoldTitle:setString(i18n("common_text_1827"))
	self.labelGiftTitle:setString(i18n("common_text_1826"))
	self.labelGiftDes:setString(i18n("common_text_1997"))
	self.labelGoldDes:setString(i18n("common_text_1996"))
	self.btnAlliance = SoraDGetChildByName(self, "Button_alliance")
	self.btnKingdom = SoraDGetChildByName(self, "Button_kingdom")
	self.btnSend = SoraDGetChildByName(self, "Button_send")
	self.btnSend:setTitleText(i18n("common_text_073"))
	self.btnAlliance:addClickEventListener(handler(self, self.btnTypeClickCallBack))
	self.btnKingdom:addClickEventListener(handler(self, self.btnTypeClickCallBack))
	self.btnSend:addClickEventListener(handler(self, self.btnClickCallBack))
	self.editContent = i18n("common_text_1832")
	self:changeType(allianceMgr:hasJoinAlliance() ~= nil)
	self:updateCreateBtnTouchEnable()
	if self.param and self.param.itemID then
		self:initData(self.param.itemID)
	end
end
function SendRedPacketViewPanel:onShow()
	print("=======SendRedPacketViewPanel:onShow")
end
function SendRedPacketViewPanel:OnEditBoxTouch(target, type)
	print("target = ", target, ", type = ", type)
	print("ccui.TouchEventType.began = ", ccui.TouchEventType.began)
	if type == ccui.TouchEventType.began then
		print("点击到了这里----------")
		SoraDPlaySound()
		local chatCtrl = gametop.playertop_:getModule("chatCtrl")
		local isCanChat = chatCtrl:canChat()
		if not isCanChat then
			SoraDShowMsgTip(i18n("commom_text_4306"))
			return
		end
		target:touchDownAction(target, type)
	elseif type == ccui.TouchEventType.ended then
		local chatCtrl = gametop.playertop_:getModule("chatCtrl")
		local isCanChat = chatCtrl:canChat()
		if not isCanChat then
			return
		end
		target:touchDownAction(target, type)
	end
end
function SendRedPacketViewPanel:updateCreateBtnTouchEnable()
	local isEnable = true
	local count = self.fields.TextField_gift:getText()
	local gold = self.fields.TextField_gold:getText()
	isEnable = count ~= "" and gold ~= ""
	self.btnSend:setTouchEnabled(isEnable)
	self.btnSend:setBright(isEnable)
end
function SendRedPacketViewPanel:OnInputChangeEnd(context, eventType)
	self:checkValid(context:getSender(), eventType)
end
function SendRedPacketViewPanel:checkValid(textField, eventType)
	local curData = textField == self.fields.TextField_gold and tableInput.gold or tableInput.count
	local input = textField:getText()
	input = math.floor(tonumber(input) or 0)
	if input > curData.max then
		input = curData.max
	end
	textField:setString(input)
	if eventType == nil or eventType == ccui.TextFiledEventType.detach_with_ime then
		if input == nil or input < curData.min then
			input = curData.min
		end
		textField:setString(input)
		self:updateCreateBtnTouchEnable()
	end
end
function SendRedPacketViewPanel:initData(itemID)
	self.itemID = itemID
	if self.itemID == 857901 then
		_ENV = nil
		;(nil).name = lordInfoCtrl:getBaseInfo().nickName
		self.editContent = i18n("anniversary_tips_001", nil)
	end
end
function SendRedPacketViewPanel:btnTypeClickCallBack(button, type)
	SoraDPlaySound()
	self:changeType(button == self.btnAlliance)
end
function SendRedPacketViewPanel:changeType(isAlliance)
	self.btnAlliance:setSelected(isAlliance)
	self.btnAlliance:setTouchEnabled(not isAlliance)
	self.btnKingdom:setSelected(not isAlliance)
	self.btnKingdom:setTouchEnabled(isAlliance)
	if self.itemID == 857901 then
		if isAlliance then
			_ENV = isAlliance
			isAlliance.name = lordInfoCtrl:getBaseInfo().nickName
			self.editContent = i18n("anniversary_tips_001", isAlliance)
		else
			_ENV = isAlliance
			isAlliance.name = mailFunctions:getWrappedName(lordInfoCtrl:getLordInfo().abbr, lordInfoCtrl:getBaseInfo().nickName)
			self.editContent = i18n("anniversary_tips_001", isAlliance)
		end
	end
end
function SendRedPacketViewPanel:btnHelpClickCallBack(button, type)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.GOLD_GIFT)
end
function SendRedPacketViewPanel:btnClickCallBack(button, type)
	SoraDPlaySound()
	local tmpGold = tonumber(self.fields.TextField_gold:getText())
	local tmpNum = tonumber(self.fields.TextField_gift:getText())
	local tmpText = self.editContent
	local chatChannel = self.btnAlliance:isSelected() and gChatChannel.ALLIANCE or gChatChannel.KINGDOM
	local tmpUID = lordInfoCtrl:getLordInfo().base.uid
	if allianceMgr:hasJoinAlliance() == nil and chatChannel == gChatChannel.ALLIANCE then
		SoraDShowMsgBox(i18n("common_text_1793"), i18n("common_text_068"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				uiManager:show("AllianceJoinView")
			end
		end)
	elseif SoraDEnoughGold(tmpGold) then
		_ENV = nil
		;(nil).gold = tmpGold
		SoraDShowMsgBox(i18n("common_text_1831", nil), i18n("common_text_054"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
				chatRedPacketMgr:setSendRPChannel(chatChannel)
				local rpChatType = gChatChannel2RPChatType[chatChannel]
				local redEnvelopesType = gRedEnvelopesType.GOLD_GIFT
				if self.itemID == 835501 then
					redEnvelopesType = gRedEnvelopesType.ICE_CRAZY_ACTIVITY
				end
				if self.itemID == 857901 then
					redEnvelopesType = gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY
				end
				print("self.itemID,redEnvelopesType========", self.itemID, redEnvelopesType)
				_ENV = nil
				;(nil).gold = tmpGold
				;(nil).num = tmpNum
				;(nil).text = tmpText
				;(nil).type = rpChatType
				;(nil).uid = tmpUID
				;(nil).redEnvelopesType = redEnvelopesType
				backpackCtrl:reqUseItem(self.itemID, 1, nil)
				self:close(nil, ccui.TouchEventType.ended)
			end
		end)
	end
end
return SendRedPacketViewPanel
