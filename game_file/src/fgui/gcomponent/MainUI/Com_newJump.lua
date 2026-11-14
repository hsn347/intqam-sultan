local baseComponent = require("fgui.base.baseComponent")
local Com_newJump = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MainUI/Com_newJump", Com_newJump)
function Com_newJump:onInit()
	self.fields.n1:setString("NEW")
	self.fields.n2:setString("NEW")
end
function Com_newJump:onShow()
end
return Com_newJump
