local baseComponent = require("fgui.base.baseComponent")
local Com_shop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_shop", Com_shop)
function Com_shop:onInit()
	self:fixChildrenPos()
end
function Com_shop:onShow()
end
function Com_shop:initData(data, otherData)
	if data.item1 then
		self.fields.Com_shopItem1:setVisible(true)
		self.fields.Com_shopItem1:initData(data.item1, otherData)
	else
		self.fields.Com_shopItem1:setVisible(false)
	end
	if data.item2 then
		self.fields.Com_shopItem2:setVisible(true)
		self.fields.Com_shopItem2:initData(data.item2, otherData)
	else
		self.fields.Com_shopItem2:setVisible(false)
	end
end
return Com_shop
