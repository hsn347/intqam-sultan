local shoppingCart = class("shoppingCart")
function shoppingCart:ctor(data)
	self:setData(data)
end
function shoppingCart:initialize(data)
	self:setData(data)
end
function shoppingCart:release()
	self:clean()
end
function shoppingCart:addShopItem(shopItemID, count)
	local currentCount = self:getShopItemCount(shopItemID)
	local total = currentCount + count
	self:setShopItemCount(shopItemID, total)
	return gErrDef.Err_None
end
function shoppingCart:removeShopItem(shopItemID, count)
	if not self:hasShopItem(shopItemID, count) then
		return
	end
	local currentCount = self:getShopItemCount(shopItemID)
	local remainCount = count - currentCount
	self:setShopItemCount(shopItemID, remainCount)
	return gErrDef.Err_None
end
function shoppingCart:hasShopItem(shopItemID, count)
	local currentCount = self:getShopItemCount(shopItemID)
	if count > currentCount then
		return false
	end
	return true
end
function shoppingCart:clean()
	self.data, _UPVALUE0_ = nil, nil
end
function shoppingCart:getShopItemData()
	return self.data
end
function shoppingCart:dump()
end
function shoppingCart:setData(data)
