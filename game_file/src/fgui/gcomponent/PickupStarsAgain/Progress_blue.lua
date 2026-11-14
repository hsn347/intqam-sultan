local baseComponent = require("fgui.base.baseComponent")
local Progress_blue = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/Progress_blue", Progress_blue)
function Progress_blue:onInit()
	self.fields.bar:fixPos()
	self.fields.bar:getChild("n10"):fixPos()
end
function Progress_blue:onShow()
end
return Progress_blue
