local baseComponent = require("fgui.base.baseComponent")
local Com_banner = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_banner", Com_banner)
function Com_banner:setURL(...)
	self.fields.Image_banner:setURL(...)
end
