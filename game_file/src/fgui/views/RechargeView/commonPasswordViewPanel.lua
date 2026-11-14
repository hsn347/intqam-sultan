_ENV = nil
;(nil).gold = 1
local (nil).vip, passWordType = 2, nil
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonPasswordViewPanel = class("commonPasswordViewPanel", baseFguiPanel)
function commonPasswordViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonPasswordViewPanel:ctor", self.viewName)
end
function commonPasswordViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonPasswordViewPanel:onInit()
	print("=======commonPasswordViewPanel:onInit")
	self.isSet = true
	self.pwdType = passWordType.gold
	self.btnCallback = nil
	self.fields.Button_set:setString(i18n("common_text_713"))
	self.fields.Button_set:addClickListener(handler(self, self.btnSetClick))
	self.fields.Button_ver:setString(i18n("common_text_2065"))
	self.fields.Button_ver:addClickListener(handler(self, self.btnVerClick))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Button_help:fixPos()
end
function commonPasswordViewPanel:onShow()
	print("=======commonPasswordViewPanel:onShow")
	self.isSet = self.param.isSet
	self.pwdType = self.param.pwdType or passWordType.gold
	self.btnCallback = self.param.btnCallback
	self.bgTitle = self.param.title
	self.setdes = self.param.des
	self.verHolder = self.param.verHolder
	self.tipStr = self.param.tip
	self.btnHelpCallback = self.param.helpCallback
	self.isIgnoreCheckFormat = self.param.ignoreCheckFormat
	self.fields.Text_tip:setVisible(self.tipStr ~= nil)
	if self.tipStr then
		self.fields.Text_tip:setString(self.tipStr)
	end
	self.fields.TextField_set1pwd:initData(self.isIgnoreCheckFormat and 20 or 6, i18n("common_text_2067"))
	self.fields.TextField_set2pwd:initData(self.isIgnoreCheckFormat and 20 or 6, i18n("common_text_2068"))
	self.fields.TextField_ver:initData(self.isIgnoreCheckFormat and 20 or 6, self.verHolder or i18n("common_text_2067"))
	self:initView()
end
function commonPasswordViewPanel:initView()
	self.controllers.c1:setSelectedIndex(self.isSet and 0 or 1)
	if self.isSet then
		self.fields.Panel_bg:setString(self.bgTitle or i18n("common_text_2063"))
		if self.setdes then
			self.fields.Text_setDes:setString(self.setdes)
		else
			self.fields.Text_setDes:setString(self.pwdType == passWordType.gold and i18n("common_text_2055") or i18n("privilege_text_138"))
		end
	else
		self.fields.Panel_bg:setString(self.bgTitle or i18n("common_text_2064"))
		self.fields.Text_setDes:setString(self.setdes or i18n("common_text_2060"))
	end
end
function commonPasswordViewPanel:closeMe(target, data)
	self:close()
end
function commonPasswordViewPanel:pwdBack(target, data)
	if data and gErrDef.Err_None ~= data.err then
		SoraDShowMsgTip(data.tip or i18n("common_text_2061"))
		self.fields.TextField_ver:setText("")
		self.fields.TextField_ver:setGVisible(false)
	elseif data and gErrDef.Err_None == data.err then
		SoraDShowMsgTip(data.tip or i18n("common_text_2062"))
		self:close()
	end
end
function commonPasswordViewPanel:checkFormat(textField)
	if self.isIgnoreCheckFormat then
		return true
	end
	local dR = false
	local correctTextField = function(ocx)
		local oriString = ocx:getText()
		local fixWord = string.match(oriString, "[%d]+") or ""
		if string.utf8len(fixWord) < COMMON_PASSWORD_MIN_LEN then
			ocx:setString("")
		end
		return ocx
	end
	if self.isSet then
		local pwd1 = correctTextField(self.fields.TextField_set1pwd):getText()
		local pwd2 = correctTextField(self.fields.TextField_set2pwd):getText()
		if string.utf8len(pwd1) < COMMON_PASSWORD_MIN_LEN then
			SoraDShowMsgTip(i18n("common_text_2057"))
			self.fields.TextField_set1pwd:setGVisible(false)
		else
			self.fields.TextField_set1pwd:setGVisible(true)
		end
		if string.utf8len(pwd2) < COMMON_PASSWORD_MIN_LEN then
			SoraDShowMsgTip(i18n("common_text_2067"))
			self.fields.TextField_set2pwd:setGVisible(false)
		elseif pwd1 ~= pwd2 then
			SoraDShowMsgTip(i18n("common_text_2087"))
			self.fields.TextField_set2pwd:setGVisible(false)
		else
			self.fields.TextField_set2pwd:setGVisible(true)
			dR = true
		end
	else
		local pwd = correctTextField(self.fields.TextField_ver):getText()
		if string.utf8len(pwd) < COMMON_PASSWORD_MIN_LEN then
			SoraDShowMsgTip(i18n("common_text_2057"))
			self.fields.TextField_ver:setGVisible(false)
		else
			self.fields.TextField_ver:setGVisible(true)
			dR = true
		end
	end
	return dR
end
function commonPasswordViewPanel:btnSetClick()
	SoraDPlaySound()
	if self.btnCallback and self:checkFormat() then
		self.btnCallback(self.fields.TextField_set2pwd:getText())
		self:close()
	end
end
function commonPasswordViewPanel:btnVerClick()
	SoraDPlaySound()
	if self.btnCallback and self:checkFormat() then
		dump(self.fields.TextField_ver:getText(), "commonPasswordViewPanel:btnVerClick()")
		self.btnCallback(self.fields.TextField_ver:getText(), self)
	end
end
function commonPasswordViewPanel:btnHelpClick()
	SoraDPlaySound()
	if self.btnHelpCallback then
		self.btnHelpCallback()
	else
		userSDKManager.openFeedback("gameSettings")
	end
end
return commonPasswordViewPanel
