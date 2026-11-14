local payBackCtrl = SoraDGetCtrl("payBackCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BackMoneyPopViewPanel = class("BackMoneyPopViewPanel", baseFguiPanel)
function BackMoneyPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BackMoneyPopViewPanel:ctor", self.viewName)
	self.isAddToPopManager = true
	self.isCantCloseByReturn = true
end
function BackMoneyPopViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BackMoney"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function BackMoneyPopViewPanel:onInit()
	print("=======BackMoneyPopViewPanel:onInit")
	self.fields.bg:setTitle(i18n("PayBack_Text_01"))
	self.fields.Text_tip:setString(i18n("PayBack_Text_05"))
	self.fields.Button_x:addClickListener(handler(self, self.onCloseClick))
	self.fields.Button_callMe:setTitleText(i18n("PayBack_Text_06"))
	self.fields.Button_callMe:addClickListener(handler(self, self.onCallMeClick))
	self.fields.Button_buyGift:setTitleText(i18n("PayBack_Text_07"))
	self.fields.Button_buyGift:addClickListener(handler(self, self.onBuyGiftClick))
	self.maxCount = constantRead.getConstValue("PayBack_Max_Num")
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_left)
	self.Text_time:setVisible(false)
	self.Text_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("PayBack_Text_17", nil)
	end)
	self.Text_time:setTimeEndListener(function()
		self.Text_time:setVisible(false)
		self.fields.Button_x:setVisible(false)
		self = nil
		;(nil).num = self.maxCount
		self.fields.Text_msg:setString(i18n("PayBack_Text_03", nil))
	end)
	self.fields.Button_callMe:fixPos()
	self.fields.Button_buyGift:fixPos()
end
function BackMoneyPopViewPanel:onShow()
	print("=======BackMoneyPopViewPanel:onShow")
	self:updateView()
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.payback_1, nil)
end
function BackMoneyPopViewPanel:updateView()
	local state = payBackCtrl:getState()
	local payState = payBackCtrl:getPayState()
	self.fields.Button_x:setVisible(true)
	local count = payBackCtrl:getCount()
	if state then
		local val = constantRead.getConstValue("PayBack_Second_Close")
		if count > self.maxCount or payState == 1 then
			state = gPayBackState.CANNOT_CLOSE
		end
		if state == gPayBackState.CANNOT_CLOSE and val == 0 then
			self.fields.Button_x:setVisible(false)
		else
			local leftTime = payBackCtrl:getStateTime()
			if 0 < leftTime then
				self.Text_time:setVisible(true)
				self.Text_time:beginTime(leftTime)
			end
		end
		payBackCtrl = self.Text_time
		self.Text_time.num = count
		local msgStr = i18n("PayBack_Text_02", self.Text_time)
		if state ~= gPayBackState.CAN_CLOSE then
			payBackCtrl = leftTime
			leftTime.num = count
			msgStr = i18n("PayBack_Text_03", leftTime)
			if payState == 1 then
				msgStr = i18n("PayBack_Text_21")
			elseif count > self.maxCount then
				msgStr = i18n("PayBack_Text_19")
			end
		end
		self.fields.Text_msg:setString(msgStr)
	end
	local price = payBackCtrl:getPrice()
	local priceStr = fguiHelper.getColorString("#FFC864", "$" .. price)
	payBackCtrl = nil
	;(nil).num = priceStr
	self.fields.Text_dsc:setString(i18n("PayBack_Text_04", nil))
	payBackCtrl = i18n("PayBack_Text_04", nil)
	i18n("PayBack_Text_04", nil).num = fguiHelper.getColorString("#FFC864", count)
	self.fields.Text_backCount:setString(i18n("PayBack_Text_20", i18n("PayBack_Text_04", nil)))
	self.fields.Text_backCount:setVisible(0 < count)
end
function BackMoneyPopViewPanel:onHide()
	print("=======BackMoneyPopViewPanel:onHide")
end
function BackMoneyPopViewPanel:onDispose()
	print("=======BackMoneyPopViewPanel:onDispose")
end
function BackMoneyPopViewPanel:onCloseClick()
	SoraDPlaySound()
	self:close()
end
function BackMoneyPopViewPanel:onCallMeClick()
	SoraDPlaySound()
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.payback_2, nil)
	userSDKManager.openFeedback("payBack", true)
end
function BackMoneyPopViewPanel:onBuyGiftClick()
	SoraDPlaySound()
	_ENV = nil
	userSDKManager.logEvent(gSDKDef.TDonEvent.payback_4, nil)
	_ENV = nil
	;(nil).byUID = true
	local isRead = SoraDConfigGet("Game:BackMoneyAgree:isRead~bool", nil) or false
	if not isRead then
		uiManager:show("BackMoneyAgree")
	else
		uiManager:show("BackMoneyList")
	end
end
return BackMoneyPopViewPanel
