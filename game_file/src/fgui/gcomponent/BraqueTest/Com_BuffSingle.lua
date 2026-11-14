local baseComponent = require("fgui.base.baseComponent")
local Com_BuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BraqueTest/Com_BuffSingle", Com_BuffSingle)
fgui.register_extension("ui://BraqueTest/Com_BuffSingle2", Com_BuffSingle)
function Com_BuffSingle:onInit()
	self:fixChildrenPos()
end
function Com_BuffSingle:onShow()
end
function Com_BuffSingle:initData(data, index)
	self.fields.title:setString(data.title)
	self.controllers.c1:setSelectedIndex(index % 2)
	self.fields.Text_value1:setString(data.value1)
	if self.fields.Text_value2 then
		self.fields.Text_value2:setString(data.value2)
	end
	if self.fields.Text_value3 then
		self.fields.Text_value3:setString(data.value3)
	end
end
return Com_BuffSingle
