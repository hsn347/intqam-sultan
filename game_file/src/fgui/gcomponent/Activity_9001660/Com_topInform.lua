local baseComponent = require("fgui.base.baseComponent")
local Com_topInform = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001660/Com_topInform", Com_topInform)
function Com_topInform:onInit()
	self.fields.laba:fixPos()
	self.fields.laba:fix()
end
function Com_topInform:onShow()
end
function Com_topInform:setAction(showText, time, handle)
	self.fields.Lab_title:setAction(showText, time, handle)
end
return Com_topInform
