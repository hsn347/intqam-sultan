local baseComponent = require("fgui.base.baseComponent")
local Com_larger = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_larger", Com_larger)
function Com_larger:onInit()
	self.fields.nl:setString("(")
	self.fields.nr:setString(")")
	self.fields.arr:fixPos()
end
function Com_larger:onShow()
end
function Com_larger:initData(str)
	self.fields.title:setString(str)
	self.fields.title:fixPos()
end
return Com_larger
