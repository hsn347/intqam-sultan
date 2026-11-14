local baseComponent = require("fgui.base.baseComponent")
local UI_Com_skip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_skip", UI_Com_skip)
function UI_Com_skip:onInit()
	self.fields.mv_check:setAllFrameName("G_checkd_glow%.2d.png", 1)
	self.fields.mv_check:setVisible(false)
	self.fields.title:setAlign(0)
	self.fields.Check_tick:addClickListener(handler(self, self.btnTickClick))
end
function UI_Com_skip:onShow()
end
function UI_Com_skip:initData(isSkip, title, handle)
	self.handle = handle
	self.fields.title:setString(title or i18n("weapon_creating_10"))
	self.fields.Check_tick:setSelected(isSkip or false)
	self.fields.mv_check:setVisible(self.controllers.c_show:getSelectedIndex() == 1 and isSkip or false)
end
function UI_Com_skip:setSelected(isSkip)
	self.fields.Check_tick:setSelected(isSkip)
	self.fields.mv_check:setVisible(self.controllers.c_show:getSelectedIndex() == 1 and isSkip)
end
function UI_Com_skip:btnTickClick()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.fields.Check_tick:isSelected())
	end
end
return UI_Com_skip
