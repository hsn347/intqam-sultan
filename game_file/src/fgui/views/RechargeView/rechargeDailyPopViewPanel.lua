local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
_ENV = "dailyDiscountGiftCtrl"
;("dailyDiscountGiftCtrl").free = gCmd.REQ_RECEIVE_FREE_GIFT
local ("dailyDiscountGiftCtrl").special, REQtoSend = gCmd.REQ_RECEIVE_SPECIAL_GIFT, "dailyDiscountGiftCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeDailyPopViewPanel = class("rechargeDailyPopViewPanel", baseFguiPanel)
function rechargeDailyPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeDailyPopViewPanel:ctor", self.viewName)
end
function rechargeDailyPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeDailyPopViewPanel:onInit()
	print("=======rechargeDailyPopViewPanel:onInit")
	self.giftsData, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("hero_title_02"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickReceive))
end
function rechargeDailyPopViewPanel:onShow()
	print("=======rechargeDailyPopViewPanel:onShow")
	self.data = self.param.data
	self:initData()
end
function rechargeDailyPopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.giftsData[index + 1].id, self.giftsData[index + 1].count)
end
function rechargeDailyPopViewPanel:initData()
	self.curType = self.data.curType
	self.fields.Text_alter:setString(self.data.content)
	if self.data.receiveTime ~= 0 and serviceFunctions.isSameDay(self.data.receiveTime) then
		self.fields.Button_receive:setString(i18n("common_text_1892"))
		self.fields.Button_receive:setEnabled(false)
	elseif self.data.buyGiftCount ~= nil and self.data.buyGiftCount < 3 then
		self.fields.Button_receive:setString(i18n("common_text_1146"))
		self.fields.Button_receive:setEnabled(false)
	else
		self.fields.Button_receive:setString(i18n("common_text_1146"))
		self.fields.Button_receive:setEnabled(true)
	end
	self.giftsData = self.data.giftsData
	self.fields.List:setNumItems(#self.giftsData)
end
function rechargeDailyPopViewPanel:dailySpecialGiftRefresh(target, data)
	self.curTime = dailyDiscountGiftCtrl:getDailyDiscountGiftData().rewardGiftTime
	if not serviceFunctions.isSameDay(self.curTime) then
		SoraDShowMsgTip(i18n("spcial_office_text_03"))
		self.fields.Button_receive:setString(i18n("common_text_1146"))
		self.fields.Button_receive:setEnabled(false)
	else
		SoraDShowMsgTip(i18n("common_text_1892"))
		self:removeFromParent()
	end
end
function rechargeDailyPopViewPanel:dailyFreeGiftRefresh(target, data)
	SoraDShowMsgTip(i18n("common_text_1892"))
	self:close()
end
function rechargeDailyPopViewPanel:onClickReceive()
	SoraDPlaySound()
	self.curTime = serviceFunctions.systemTime()
	dailyDiscountGiftCtrl:receiveGift(REQtoSend[self.curType])
end
return rechargeDailyPopViewPanel
