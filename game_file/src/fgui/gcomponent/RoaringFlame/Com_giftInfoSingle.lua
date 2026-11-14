local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_giftInfoSingle", Com_giftInfoSingle)
function Com_giftInfoSingle:onInit()
	self:fixChildrenPos()
end
function Com_giftInfoSingle:onShow()
end
function Com_giftInfoSingle:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.Com_item:initData(data.id)
	self.fields.Text_itemName:setString(publicRead.getName(data.id))
	self.fields.Text_itemCount:setString("x" .. data.count)
end
return Com_giftInfoSingle
