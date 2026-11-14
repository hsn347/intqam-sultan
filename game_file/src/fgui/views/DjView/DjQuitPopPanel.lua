local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjQuitPopPanel = class("DjQuitPopPanel", baseFguiPanel)
function DjQuitPopPanel:ctor(...)
	self.isLRU = true
	DjQuitPopPanel.super.ctor(self, ...)
	print("DjQuitPopPanel:ctor", self.viewName)
end
function DjQuitPopPanel:onInit()
	print("=======DjQuitPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Anchor_text_210"))
	self.fields.Button_ok:setTitle(i18n("Anchor_text_210"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	self.fields.Button_cancel:setTitle(i18n("Anchor_text_209"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClick_Button_cancel))
	self.fields.Text_msg:setString(i18n("Anchor_text_206"))
	self.fields.Text_back:setString(i18n("Anchor_text_207"))
	self.fields.Text_quit:setString(i18n("Anchor_text_208"))
	self.fields.Button_ok:fixPos()
	self.fields.Button_cancel:fixPos()
end
function DjQuitPopPanel:endShow()
	print("=======DjQuitPopPanel:endShow")
	self.handle_ok = self.param.handle_ok
	self.handle_cancel = self.param.handle_cancel
end
function DjQuitPopPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	if self.handle_ok then
		self.handle_ok()
	end
	self:close()
end
function DjQuitPopPanel:onClick_Button_cancel(context)
	SoraDPlaySound()
	if self.handle_cancel then
		self.handle_cancel()
	end
	self:close()
end
return DjQuitPopPanel
