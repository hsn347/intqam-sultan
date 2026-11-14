local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_listSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampPrivilege/Com_listSingle", Com_listSingle)
function Com_listSingle:onInit()
	self:fixChildrenPos()
end
function Com_listSingle:onShow()
end
function Com_listSingle:initData(data, index)
	self.fields.nbg:setVisible(index % 2 == 1)
	self.fields.item:initData(data.id)
	self.fields.Text_itemName:setString(publicRead.getName(data.id))
	self.fields.Text_itemCount:setString("x" .. data.count)
end
return Com_listSingle
