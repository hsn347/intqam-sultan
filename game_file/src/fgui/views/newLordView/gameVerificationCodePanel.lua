local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameVerificationCodePanel = class("gameVerificationCodePanel", baseFguiPanel)
local settingCtrl = SoraDGetCtrl("settingCtrl")
function gameVerificationCodePanel:ctor(...)
	gameVerificationCodePanel.super.ctor(self, ...)
	self.debug = true
	print("gameVerificationCodePanel:ctor", self.viewName)
end
function gameVerificationCodePanel:onInit()
	print("=======gameVerificationCodePanel:onInit")
	self.fields.Com_title:initData(i18n("Safety_lock_text_16"), handler(self, self.onClickClose))
	self.fields.title:setString(i18n("newstart_text_35"))
	self.fields.Text_desc:setString(i18n("Safety_lock_text_20"))
	self.fields.title2:setString(i18n("common_text_001"))
	self.fields.Button_refresh:setTitle(i18n("common_text_911"))
	self.fields.Button_copy:setTitle(i18n("common_text_078"))
	self.fields.Button_refresh:addClickEventListener(handler(self, self.onRefreshClick))
	self.fields.Button_copy:addClickEventListener(handler(self, self.onCopyClick))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.Text_title)
	self.text_time:setTimeLast(function(time)
		dump(self.text_time.timeNumber, "text_time:setTimeLast")
		_ENV = "text_time:setTimeLast"
		;("text_time:setTimeLast").num = self.text_time.timeNumber
		return i18n("Safety_lock_text_18", "text_time:setTimeLast")
	end)
	self.text_time:setTimeEndListener(function()
		self.fields.Button_refresh:setEnabled(true)
		self.fields.Text_title:setString(i18n("Safety_lock_text_19"))
	end)
	self.fields.Button_refresh:fixPos()
	self.fields.Button_copy:fixPos()
end
function gameVerificationCodePanel:onShow()
	print("=======gameVerificationCodePanel:onShow")
	self:updateView()
end
function gameVerificationCodePanel:updateView()
	self.tokenData = settingCtrl:getWebPayVerifyTokenData()
	self.verificationCode = self.tokenData.token
	self.refreshTime = self.tokenData.refreshTime
	local cArray = SoraDConvertStringToArray(self.verificationCode)
	local codeLength = string.len(self.verificationCode)
	local maxLength = 6
	for i = 1, codeLength do
		self.fields["text_num" .. i]:setString(cArray[i])
	end
	self.cdTime = 60 - (serviceFunctions.systemTime() - self.refreshTime)
	if self.cdTime > 0 then
		self.text_time:beginTime(self.cdTime)
	else
		self.text_time:setString(i18n("Safety_lock_text_19"))
	end
	self.fields.Button_refresh:setEnabled(self.cdTime <= 0)
end
function gameVerificationCodePanel:onRefreshClick(type)
	SoraDPlaySound()
	settingCtrl:reqWebPayVerifyTokenRefresh()
end
function gameVerificationCodePanel:onCopyClick(type)
	SoraDPlaySound()
	SoraDCopyText(self.verificationCode)
	SoraDShowMsgTip(i18n("common_text_1062"))
end
return gameVerificationCodePanel
