local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_gainSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_gainSingle", Com_gainSingle)
fgui.register_extension("ui://Chaser/Com_gainSingle", Com_gainSingle)
function Com_gainSingle:onInit()
	self:fixChildrenPos()
end
function Com_gainSingle:onShow()
end
function Com_gainSingle:initData(data, index)
	self.fields.Bg_white:setVisible(index % 2 == 0)
	self.fields.Com_item:initData(data.id)
	self.fields.Text_name:setString(publicRead.getName(data.id))
	self.fields.Text_num:setString("x" .. string.formatnumberthousands(data.count))
end
return Com_gainSingle
