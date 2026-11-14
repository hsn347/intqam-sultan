local baseComponent = require("fgui.base.baseComponent")
local Label_msgTip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RadiantDecree/Label_msgTip", Label_msgTip)
function Label_msgTip:onInit()
end
function Label_msgTip:showMsg(title)
	self.fields.title:setString(i18n(title))
	self.transitions.t0:play()
end
function Label_msgTip:onShow()
end
return Label_msgTip
