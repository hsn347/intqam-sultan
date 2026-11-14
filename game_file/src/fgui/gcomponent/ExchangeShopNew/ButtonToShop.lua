local baseComponent = require("fgui.base.baseComponent")
local ButtonToShop = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ButtonToShop", ButtonToShop)
function ButtonToShop:onInit()
	self:fixChildrenPos()
end
function ButtonToShop:setIconAndNum(itemIdList)
	local itemShowNum = math.min(2, #itemIdList)
	self:setContentSize(cc.size(itemShowNum * 90, 40))
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
function ButtonToShop:setIconNumVisibility(flag)
	self.fields.item_Num1:setVisible(flag)
	self.fields.item_Num2:setVisible(flag)
end
function ButtonToShop:setTitle(str)
	self.fields.title:setString(str)
end
function ButtonToShop:onItemRenderer(index, object)
	object:initData(self.costIDArray[index + 1], 1, 2)
end
return ButtonToShop
