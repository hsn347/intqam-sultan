local baseComponent = require("fgui.base.baseComponent")
local UI_Com_new = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_new", UI_Com_new)
function UI_Com_new:onInit()
	if SoraDFIsRA() then
		self.fields.icon:setURL("img_common_new_ar.png")
	else
		self.fields.icon:setURL("img_common_new_en.png")
	end
end
function UI_Com_new:onShow()
end
return UI_Com_new
