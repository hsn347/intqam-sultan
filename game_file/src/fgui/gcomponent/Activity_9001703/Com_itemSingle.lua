local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_itemSingle", Com_itemSingle)
function Com_itemSingle:onInit()
	self:fixChildrenPos()
end
function Com_itemSingle:onShow()
end
function Com_itemSingle:initData(data, index)
	self.fields.nbg:setVisible(index % 2 == 1)
	self.fields.item:initData(data.id)
	self.fields.Text_name:setString(publicRead.getName(data.id))
	self.fields.Text_num:setString("x" .. data.count)
end
return Com_itemSingle
