local baseComponent = require("fgui.base.baseComponent")
local Button_prisonHeros = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Button_prisonHeros", Button_prisonHeros)
function Button_prisonHeros:onInit()
end
function Button_prisonHeros:onShow()
end
function Button_prisonHeros:setRed(num)
	self.fields.lab_red:setTitle(num)
end
return Button_prisonHeros
