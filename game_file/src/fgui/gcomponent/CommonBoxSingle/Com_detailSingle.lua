local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_detailSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_detailSingle", Com_detailSingle)
function Com_detailSingle:onInit()
	self:fixChildrenPos()
end
function Com_detailSingle:initData(index, data)
	self.fields.Bg_white:setVisible(bit.band(index, 1) == 0 and true or false)
	self.fields.Text_num:setString("X" .. data.count)
	self.fields.Text_name:setString(itemDesRead.getName(data.itemid))
	self.fields.Com_item:initData(data.itemid)
	self.fields.Icon_get:setVisible(data.getFlag)
end
function Com_detailSingle:onShow()
end
return Com_detailSingle
