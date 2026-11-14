local maxH = 40
local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_style = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_style", UI_Btn_style)
fgui.register_extension("ui://CommonUI/UI_Btn_style2", UI_Btn_style)
function UI_Btn_style:onInit()
	self.fields.Label_reddot:setVisible(false)
end
function UI_Btn_style:onShow()
end
function UI_Btn_style:setTitleColor(color)
	self.fields.title:setColor(color)
end
function UI_Btn_style:setString(...)
	self.fields.title:setString(...)
	fguiHelper.setTextHeight(self.fields.title, maxH)
end
function UI_Btn_style:setTitle(...)
	self.fields.title:setString(...)
	fguiHelper.setTextHeight(self.fields.title, maxH)
end
return UI_Btn_style
