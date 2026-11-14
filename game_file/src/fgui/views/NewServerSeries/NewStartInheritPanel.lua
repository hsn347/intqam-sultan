local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewStartInheritPanel = class("NewStartInheritPanel", baseFguiPanel)
_ENV = "NewStartInheritPanel"
;("NewStartInheritPanel").NONE = 0
;("NewStartInheritPanel").OLD = 1
;("NewStartInheritPanel").NEW = 2
;("NewStartInheritPanel").NEW_END = 3
local ("NewStartInheritPanel").OLD_END, USER_STATE_ENUM = 4, "NewStartInheritPanel"
function NewStartInheritPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NewStartInheritPanel:ctor", self.viewName)
end
function NewStartInheritPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NewStartInheritPanel:onInit()
	print("=======NewStartInheritPanel:onInit")
	self.controllers.c_lang:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.Text_des:setString(i18n("newstart_text_33"))
	self.fields.Text_des1:setString(i18n("newstart_text_27"))
	self.fields.Text_inherit1:setString(i18n("newstart_text_25"))
	self.fields.Input_inherit:addEventListener(fgui.UIEventType.Submit, handler(self, self.onInputTextSubmit))
	self.fields.Input_inherit:setPrompt(i18n("newstart_text_26"))
	self.fields.Input_inherit:setColor(cc.c3b(47, 46, 46))
	self.fields.Button_inherit:addClickListener(handler(self, self.onClickBtnInherit))
	self.controllers.c_state:setSelectedIndex(1)
end
function NewStartInheritPanel:onShow()
	print("=======NewStartInheritPanel:onShow")
	newStartMainCtrl:reqInitNew()
	SoraDShowLoading()
end
function NewStartInheritPanel:onInputTextSubmit(...)
	local inherit = self.fields.Input_inherit:getText()
	local strLen = string.len(inherit)
	self.fields.Button_inherit:setEnabled(0 < strLen)
end
function NewStartInheritPanel:onClickBtnInherit(...)
	SoraDPlaySound()
	if self.userState == USER_STATE_ENUM.NEW then
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			SoraDShowMsgTip(i18n("newstart_text_33"))
			self:closePanel()
			return
		end
		uiManager:show("NewServerReturn")
		self:closePanel()
		return
	end
	local inherit = self.fields.Input_inherit:getText()
	local strLen = string.len(inherit)
	if 0 < strLen and strLen <= 20 then
		newStartMainCtrl:reqCheckCorreltion(inherit)
		SoraDShowLoading()
	else
		SoraDShowMsgTip(i18n("newstart_text_31"))
	end
end
function NewStartInheritPanel:refreshView(...)
	SoraDCloseLoading()
	local data = newStartMainCtrl:getInheritData()
	self.userState = data.userState
	if self.userState == USER_STATE_ENUM.NEW then
		self.controllers.c_state:setSelectedIndex(0)
		local name = data.inheritName .. "#" .. data.kid
		_ENV = nil
		;(nil).color = "#AB7725"
		self.fields.Text_des2:setString(SoraDWrapHtmlTagByStyle(name, nil) .. i18n("newstart_text_32"))
		self.fields.Button_inherit:setString(i18n("common_text_204"))
		self.fields.Button_inherit:setEnabled(true)
	else
		self.controllers.c_state:setSelectedIndex(1)
		self.fields.Button_inherit:setString(i18n("newstart_text_27"))
		self.fields.Button_inherit:setEnabled(false)
	end
end
return NewStartInheritPanel
