local _ENV, dailyLimitShopItemMgr
function dailyLimitShopItemMgr:initialize(data)
	self.data, _UPVALUE0_ = nil, nil
	self.data.buyCountInfo = data
end
function dailyLimitShopItemMgr:destroy()
	self.data, _UPVALUE0_ = nil, nil
end
function dailyLimitShopItemMgr:addShopItemBuyCount(shopItemID, buyCount)
	self:addBuyCount(shopItemID, buyCount)
	return gErrDef.Err_None
end
function dailyLimitShopItemMgr:beLimited(shopItemID, buyCount)
	if not gModuleMgr.sharedMgr("shopltCtrl"):isLimitShopItem(shopItemID) then
		return false
	end
	local count = self:getBuyCount(shopItemID)
	local total = count + buyCount
	local limitNum = gModuleMgr.sharedMgr("shopltCtrl"):getLimitNum(shopItemID)
	if total <= limitNum then
		return false
	end
	return true
end
function dailyLimitShopItemMgr:clean()
	self.data, _UPVALUE0_ = nil, nil
end
function dailyLimitShopItemMgr:addBuyCount(shopItemID, count)
	if not self.data.buyCountInfo then
		_ENV = self.data.buyCountInfo
	end
	self.data.buyCountInfo = self.data.buyCountInfo
	local info = self.data.buyCountInfo
	local shopItemIDStr = tostring(shopItemID)
	info[shopItemIDStr] = info[shopItemIDStr] or 0
	info[shopItemIDStr] = info[shopItemIDStr] + count
end
function dailyLimitShopItemMgr:getBuyCount(shopItemID)
	local ret = 0
	if not self.data.buyCountInfo then
		return ret
	end
	local shopItemIDStr = tostring(shopItemID)
	ret = self.data.buyCountInfo[shopItemIDStr] or 0
	return ret
end
return dailyLimitShopItemMgr
