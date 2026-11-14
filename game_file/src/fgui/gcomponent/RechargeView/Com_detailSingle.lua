local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_detailSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_detailSingle", Com_detailSingle)
fgui.register_extension("ui://RechargeView/Com_itemSingle", Com_detailSingle)
function Com_detailSingle:onInit()
	self:fixChildrenPos()
end
function Com_detailSingle:onShow()
end
function Com_detailSingle:initData(index, data)
	self.fields.Bg_white:setVisible(index % 2 == 0 and true or false)
	self.fields.Text_num:setString("X" .. data.count)
	self.fields.Text_name:setString(publicRead.getName(data.id))
	self.fields.Com_item:initData(data.id)
end
return Com_detailSingle
