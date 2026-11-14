local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_small = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_small", UI_Btn_small)
function UI_Btn_small:onInit()
	self.fields.Label_reddot:setVisible(false)
end
function UI_Btn_small:onShow()
end
function UI_Btn_small:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function UI_Btn_small:hideBtnImage(...)
	self.fields.n0:setVisible(false)
	self.fields.n1:setVisible(false)
	self.fields.n4:setVisible(false)
end
return UI_Btn_small
