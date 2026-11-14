local baseComponent = require("fgui.base.baseComponent")
local Com_fromTo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_fromTo", Com_fromTo)
function Com_fromTo:onInit()
	self.fields.Text_from:fixPos()
	self.fields.Text_to:fixPos()
	self.fields.arr:setRotation(SoraDFIsRA() and 90 or -90)
end
function Com_fromTo:onShow()
end
function Com_fromTo:initData(from, to)
	self.fields.Text_from:setString(from)
	self.fields.Text_to:setString(to)
end
return Com_fromTo
