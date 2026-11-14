local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarsTower/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Text_num:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_item:fixPos()
end
function Com_list:onShow()
end
function Com_list:initData(id, count)
	self.fields.Text_num:setString("x" .. count)
	self.fields.Text_name:setString(publicRead.getName(id))
	self.fields.Com_item:initData(id, count)
end
return Com_list
