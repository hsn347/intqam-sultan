local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local List_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ShopSingleBuy/List_item", List_item)
function List_item:onInit()
	self:fixChildrenPos()
end
function List_item:onShow()
end
function List_item:initData(item, exchangeNum)
	self.fields.text_Name:setString(publicRead.getName(item.id))
	self.fields.text_Des:setString(publicRead.getDes(item.id))
	self.fields.com_Item:initData(item.id, item.count * exchangeNum)
end
return List_item
