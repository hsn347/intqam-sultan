local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local dailyAwardTreasureDetailPanel = class("dailyAwardTreasureDetailPanel", baseFguiPanel)
function dailyAwardTreasureDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("dailyAwardTreasureDetailPanel:ctor", self.viewName)
end
function dailyAwardTreasureDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function dailyAwardTreasureDetailPanel:onInit()
	print("=======dailyAwardTreasureDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4414"))
	self.fields.btn_refresh:setString(i18n("common_text_911"))
	self.fields.btn_refresh:addClickListener(handler(self, self.OnBtnRefresh))
	self.fields.btn_refreshGold:addClickListener(handler(self, self.OnBtnRefresh))
	self.fields.btn_gold:addClickListener(handler(self, self.OnBtnGold))
	self.fields.text_multValue:setAlign(0)
	self.fields.btn_gold:fixPos()
	self.fields.btn_refresh:fixPos()
	self.fields.btn_refreshGold:fixPos()
end
function dailyAwardTreasureDetailPanel:onShow()
	print("=======dailyAwardTreasureDetailPanel:onShow")
	self.data = self.param.data
	self:initData(self.data)
end
function dailyAwardTreasureDetailPanel:initData(data)
	self.data = data
	local reward = everydayTaskCtrl:getChestRewardByIndex(self.data.index)
	self.data.reward = reward
	local item = self.data.reward.item
	self.preAwardData = item
	self.fields.item:initData(item)
	self.fields.text_item_name:setString(itemDesRead.getName(item))
	self.fields.text_multValue:setString("X" .. self.data.reward.num)
	self.fields.btn_gold:initData(gIDDef.GOLD, self.data.reward.offPrice, self.data.reward.price)
	if self.data.reward.free > 0 then
		self.refreshGold = 0
	else
		self.refreshGold = self.data.reward.cost
		self.fields.btn_refreshGold:setItemID(gIDDef.GOLD)
		everydayTaskCtrl = self.data.reward.price
		self.data.reward.price.gold = self.refreshGold
		self.fields.btn_refreshGold:setTitleGold(i18n("common_text_434", self.data.reward.price))
	end
	self.fields.btn_refresh:setVisible(0 >= self.refreshGold)
	self.fields.btn_refreshGold:setVisible(0 < self.refreshGold)
end
function dailyAwardTreasureDetailPanel:refreshActionBefore()
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.scaleTo(0.2, 1.3, 1.3)
	;(nil)[2] = ffa.scaleTo(0.21666666666666667, 0.001, 1.3)
	;(nil)[3] = ffa.callFunc(function()
		local index = self.data.index
		local reward = everydayTaskCtrl:getChestRewardByIndex(index)
		self = nil
		;(nil).reward = reward
		;(nil).index = index
		self:initData(nil)
		self:refreshActionAfter()
	end)
	;(nil)[4] = ffa.callFunc(function()
		local index = self.data.index
		local reward = everydayTaskCtrl:getChestRewardByIndex(index)
		self = nil
		;(nil).reward = reward
		;(nil).index = index
		self:initData(nil)
		self:refreshActionAfter()
	end)
	;(nil)[5] = ffa.callFunc(function()
		local index = self.data.index
		local reward = everydayTaskCtrl:getChestRewardByIndex(index)
		self = nil
		;(nil).reward = reward
		;(nil).index = index
		self:initData(nil)
		self:refreshActionAfter()
	end)
	local seq_item = ffa.seq(nil)
	self.fields.item:runAction(seq_item)
	self.fields.text_item_name:runAction(ffa.fadeOut(0.2))
	self.fields.text_multValue:runAction(ffa.fadeOut(0.2))
end
function dailyAwardTreasureDetailPanel:refreshActionAfter()
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.scaleTo(0.06666666666666667, 1.3, 1.3)
	;(nil)[2] = ffa.scaleTo(0.1, 1, 1)
	;(nil)[3] = ffa.scaleTo(0.1, 1.1, 1.1)
	;(nil)[4] = ffa.scaleTo(0.13333333333333333, 1, 1)
	;(nil)[5] = ffa.scaleTo(0.13333333333333333, 1, 1)
	;(nil)[6] = ffa.scaleTo(0.13333333333333333, 1, 1)
	;(nil)[7] = ffa.scaleTo(0.13333333333333333, 1, 1)
	local seq_item = ffa.seq(nil)
	self.fields.item:runAction(seq_item)
	self.fields.text_item_name:runAction(ffa.fadeIn(0.2))
	self.fields.text_multValue:runAction(ffa.fadeIn(0.2))
end
function dailyAwardTreasureDetailPanel:sMsgRefreshTreasure(target, data)
	SoraDCloseLoading(self)
	self:refreshActionBefore()
end
function dailyAwardTreasureDetailPanel:sMsgGetTreasure(target, data)
	SoraDCloseLoading(self)
	if data and data.err == gErrDef.Err_None then
		self:close()
		_ENV = self
		self.msg = "MESSAGE_UI_DAILYAWARD_REFRESH_TREASURES"
		SoraDSendMessage(self)
	end
end
function dailyAwardTreasureDetailPanel:confirmCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local isEnough = SoraDEnoughGold(self.refreshGold)
		self.isNeedRefreshGoldTip = false
		if isEnough then
			SoraDShowLoading(self)
			everydayTaskCtrl:sendRefreshMsg(self.data.index)
		end
	end
end
function dailyAwardTreasureDetailPanel:OnBtnRefresh()
	SoraDPlaySound()
	if self.refreshGold > 0 and self.isNeedRefreshGoldTip then
		_ENV = nil
		;(nil).gold = self.refreshGold
		local strMsg = i18n("common_text_2755", nil)
		SoraDShowMsgBox(strMsg, i18n("common_text_054"), nil, handler(self, self.confirmCallBack))
	else
		self:confirmCallBack(MSGBOX_CALLBACK_YES)
		if self.refreshGold == 0 then
			self.isNeedRefreshGoldTip = true
		end
	end
end
function dailyAwardTreasureDetailPanel:confirmGoldCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES and self.data and self.data.reward then
		local isEnough = SoraDEnoughGold(self.data.reward.offPrice)
		if isEnough then
			SoraDShowLoading(self)
			everydayTaskCtrl:sendReceiveChestMsg(self.data.index)
		end
	end
end
function dailyAwardTreasureDetailPanel:OnBtnGold()
	SoraDPlaySound()
	_ENV = nil
	;(nil).gold = self.data.reward.offPrice
	local strMsg = i18n("common_text_2702", nil)
	SoraDShowMsgBox(strMsg, i18n("common_text_054"), nil, handler(self, self.confirmGoldCallBack))
end
return dailyAwardTreasureDetailPanel
