local baseComponent = require("fgui.base.baseComponent")
local Com_msg1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_msg1", Com_msg1)
function Com_msg1:onInit()
end
function Com_msg1:onShow()
end
function Com_msg1:initData(data)
	self.fields.title:setString(data.title)
	self.fields.title:setColor(data.color)
end
return Com_msg1
