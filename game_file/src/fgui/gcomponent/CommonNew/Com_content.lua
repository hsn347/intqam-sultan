local baseComponent = require("fgui.base.baseComponent")
local Com_content = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_content", Com_content)
function Com_content:onInit()
end
function Com_content:setAlignCenter()
	self.fields.title:setAlign(1)
	self.fields.title:setVerticalAlign(1)
end
function Com_content:onShow()
end
return Com_content
