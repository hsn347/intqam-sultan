local baseComponent = require("fgui.base.baseComponent")
local ButtonToShopNew = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ButtonToShopNew", ButtonToShopNew)
function ButtonToShopNew:onInit()
	self:fixChildrenPos()
end
function ButtonToShopNew:onShow()
end
function ButtonToShopNew:setIconAndNum(itemIdList)
	self:setContentSize(cc.size(#itemIdList * 90, 40))
	self.costIDArray = itemIdList
	for i = 1, 2 do
		if self.costIDArray[i] then
			self.fields["item_Num" .. i]:setVisible(true)
			self.fields["item_Num" .. i]:initData(self.costIDArray[i], 1, 2)
		else
			self.fields["item_Num" .. i]:setVisible(false)
		end
	end
end
function ButtonToShopNew:setIconNumVisibility(flag)
	self.fields.item_Num1:setVisible(flag)
	self.fields.item_Num2:setVisible(flag)
end
function ButtonToShopNew:setTitle(str)
	self.fields.title:setString(str)
end
function ButtonToShopNew:onItemRenderer(index, object)
	object:initData(self.costIDArray[index + 1], 1, 2)
end
return ButtonToShopNew
