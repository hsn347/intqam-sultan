local shoppingCart = include("shoppingCart")
local dressShoppingCart = class("dressShoppingCart", shoppingCart)
function dressShoppingCart:ctor(data)
	dressShoppingCart.super.ctor(self, data)
end
function dressShoppingCart:initialize(data)
	dressShoppingCart.super.initialize(self, data)
end
function dressShoppingCart:hasShopItem(shopItemID)
	local count = 1
	return dressShoppingCart.super.hasShopItem(self, shopItemID, count)
end
function dressShoppingCart:addShopItem(shopItemID)
	if self:hasShopItem(shopItemID) then
		return gErrDef.Err_DRESS_SHOP_REPEAT_ADD_CART
	end
	local count = 1
	return dressShoppingCart.super.addShopItem(self, shopItemID, count)
end
function dressShoppingCart:removeShopItem(shopItemID)
	local count = 1
	return dressShoppingCart.super.removeShopItem(self, shopItemID, count)
end
return dressShoppingCart
