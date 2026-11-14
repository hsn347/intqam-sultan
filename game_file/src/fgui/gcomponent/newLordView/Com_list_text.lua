local baseComponent = require("fgui.base.baseComponent")
local Com_list_text = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_list_text", Com_list_text)
fgui.register_extension("ui://newLordView/Com_list_text1", Com_list_text)
function Com_list_text:onInit()
	self:fixChildrenPos()
end
function Com_list_text:onShow()
end
function Com_list_text:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.Text_Name:setString(data.name)
	self.fields.Text_Value:setString(data.value)
end
return Com_list_text
