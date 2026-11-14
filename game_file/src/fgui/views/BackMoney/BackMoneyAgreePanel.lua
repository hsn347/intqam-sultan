local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BackMoneyAgreePanel = class("BackMoneyAgreePanel", baseFguiPanel)
function BackMoneyAgreePanel:ctor(...)
	self.super.ctor(self, ...)
	print("BackMoneyAgreePanel:ctor", self.viewName)
end
function BackMoneyAgreePanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BackMoney"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function BackMoneyAgreePanel:onInit()
	print("=======BackMoneyAgreePanel:onInit")
	self.fields.bg:setTitle(i18n("PayBack_Text_09"))
	self.fields.Text_msg:setString(i18n("PayBack_Text_10"))
	self.fields.Text_sure:setString(i18n("PayBack_Text_11"))
	self.fields.Button_ok:setTitleText(i18n("common_text_054"))
	self.fields.Button_ok:addClickListener(handler(self, self.onOkClick))
	self.fields.Check_tick:addClickListener(function()
		SoraDPlaySound()
	end)
end
function BackMoneyAgreePanel:onShow()
	print("=======BackMoneyAgreePanel:onShow")
end
function BackMoneyAgreePanel:onHide()
	print("=======BackMoneyAgreePanel:onHide")
end
function BackMoneyAgreePanel:onDispose()
	print("=======BackMoneyAgreePanel:onDispose")
end
function BackMoneyAgreePanel:onOkClick()
	SoraDPlaySound()
	if self.fields.Check_tick:isSelected() then
		_ENV = nil
		userSDKManager.logEvent(gSDKDef.TDonEvent.payback_5, nil)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:BackMoneyAgree:isRead~bool", true, nil)
		uiManager:show("BackMoneyList")
		self:close()
	else
		SoraDShowMsgTip(i18n("PayBack_Text_12"))
	end
end
return BackMoneyAgreePanel
