local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillDetailsLookPanel = class("MagicLampSkillDetailsLookPanel", baseFguiPanel)
function MagicLampSkillDetailsLookPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillDetailsLookPanel:ctor", self.viewName)
end
function MagicLampSkillDetailsLookPanel:onInit()
	print("=======MagicLampSkillDetailsLookPanel:onInit")
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
end
function MagicLampSkillDetailsLookPanel:onShow()
	print("=======MagicLampSkillDetailsLookPanel:onShow")
	if self.param.data then
		self.data = self.param.data
	else
		_ENV = self.param.data
		self.data, self.param.data.skillType = self.param.data, self.param.skillType
	end
	self.fields.Com_skillBig:initData(self.data)
	self.fields.Com_skillBig:updateLookView()
end
return MagicLampSkillDetailsLookPanel
