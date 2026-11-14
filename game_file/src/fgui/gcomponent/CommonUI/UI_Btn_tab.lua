local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_tab = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_tab", UI_Btn_tab)
fgui.register_extension("ui://CommonUI/UI_Btn_tabW", UI_Btn_tab)
fgui.register_extension("ui://CommonUI/UI_Btn_tab_new", UI_Btn_tab)
function UI_Btn_tab:onInit()
	self.fields.Label_reddot:setVisible(false)
	if self.fields.lock then
		self.fields.lock:fixPos()
	end
	self.fields.title:fixPos()
	if self.fields.Sprite_new then
		self.fields.Sprite_new:setVisible(false)
	end
end
function UI_Btn_tab:onShow()
end
function UI_Btn_tab:isShowLock(isShow)
	if self.fields.lock then
		self.controllers.c_lock:setSelectedIndex(isShow and 1 or 0)
	end
end
function UI_Btn_tab:setNewState(isVisible)
	if self.fields.Sprite_new then
		self.fields.Sprite_new:setVisible(isVisible)
	end
end
return UI_Btn_tab
