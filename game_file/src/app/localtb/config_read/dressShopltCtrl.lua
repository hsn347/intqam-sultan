local dressShopltCtrl = include("aAReadClass").new()
function dressShopltCtrl:initialize()
end
function dressShopltCtrl:destroy()
	self:stopTimer()
end
function dressShopltCtrl:isShopItemID(shopItemID)
	if self:getShopItem(shopItemID) then
		return true
	end
	return false
end
function dressShopltCtrl:getResult(shopItemID)
	return self:getShopItemProperty(shopItemID, "result")
end
function dressShopltCtrl:getCurrency(shopItemID)
	return self:getShopItemProperty(shopItemID, "currency")
end
function dressShopltCtrl:getDiscountPrice(shopItemID)
	return self:getShopItemProperty(shopItemID, "discountPrice")
end
function dressShopltCtrl:getOriginalPrice(shopItemID)
	return self:getShopItemProperty(shopItemID, "originalPrice")
end
function dressShopltCtrl:getDiscountBeginTime(shopItemID)
	return self:getShopItemProperty(shopItemID, "discountBeginTime")
end
function dressShopltCtrl:getDiscountEndTime(shopItemID)
	return self:getShopItemProperty(shopItemID, "discountEndTime")
end
function dressShopltCtrl:getSellStatus(shopItemID)
	return self:getShopItemProperty(shopItemID, "sellStatus")
end
function dressShopltCtrl:getSellBeginTime(shopItemID)
	return self:getShopItemProperty(shopItemID, "sellBeginTime")
end
function dressShopltCtrl:getSellEndTime(shopItemID)
	return self:getShopItemProperty(shopItemID, "sellEndTime")
end
function dressShopltCtrl:getIndex(shopItemID)
	return self:getShopItemProperty(shopItemID, "index")
end
function dressShopltCtrl:getShowType(shopItemID)
	return self:getShopItemProperty(shopItemID, "showType")
end
function dressShopltCtrl:getShopItemIDList()
	return self.shopItemIDList
end
function dressShopltCtrl:getShopItemTopOrder(shopItemID)
	local toTopOrder = 0
	for k, v in pairs(self.customConfig) do
		if tonumber(k) == shopItemID then
			toTopOrder = v.toTopOrder
			break
		end
	end
	return toTopOrder
end
function dressShopltCtrl:getShopItemTopOrderTime(shopItemID)
	local toTopTime = 0
	for k, v in pairs(self.customConfig) do
		if tonumber(k) == shopItemID then
			toTopTime = v.toTopTime
			break
		end
	end
	return toTopTime
end
function dressShopltCtrl:getShopItemHotMark(shopItemID)
	local hot = 0
	for k, v in pairs(self.customConfig) do
		if tonumber(k) == shopItemID then
			hot = v.hot
			break
		end
	end
	return hot
end
function dressShopltCtrl:inSale(shopItemID)
	local honorDressShopItemID = 1010018
	if honorDressShopItemID == shopItemID then
		local premiumStoreCtrl = serviceFunctions.getModule("premiumStoreCtrl")
		local dressCtrl = serviceFunctions.getModule("dressCtrl")
		local backpackCtrl = serviceFunctions.getModule("backpackCtrl")
		local itemList = self:getResult(shopItemID)
		local itemID = itemList[1].id
		local itemCount = backpackCtrl:getItemCount(itemID)
		local dressID = gModuleMgr.sharedMgr("backpackltCtrl"):getResult(itemID)
		if 0 < itemCount or dressCtrl:ownDress(dressID) then
			return false
		end
		local ok, currentPrice, shopItemID = premiumStoreCtrl:getDressInfo(itemID)
		return ok
	end
	local sellBeginTime = self:getSellBeginTime(shopItemID)
	local sellEndTime = self:getSellEndTime(shopItemID)
	if 0 ~= sellBeginTime and 0 ~= sellEndTime then
		local currentTime = serviceFunctions.systemTime()
		if sellBeginTime < currentTime and sellEndTime > currentTime then
			return true
		else
			return false
		end
	end
	local saleStatus = self:getSellStatus(shopItemID)
	if gStatus.YES == saleStatus then
		return true
	end
	return false
end
function dressShopltCtrl:inDiscount(shopItemID)
	local discountPrice = self:getDiscountPrice(shopItemID)
	local oprginalPrice = self:getOriginalPrice(shopItemID)
	if discountPrice >= oprginalPrice then
		return false
	end
	local discountBeginTime = self:getDiscountBeginTime(shopItemID)
	local discountEndTime = self:getDiscountEndTime(shopItemID)
	if 0 ~= discountBeginTime and 0 ~= discountEndTime then
		local currentTime = serviceFunctions.systemTime()
		if discountBeginTime < currentTime and discountEndTime > currentTime then
			return true
		else
			return false
		end
	end
	return true
end
function dressShopltCtrl:getCurrentPrice(shopItemID)
	if self:inDiscount(shopItemID) then
		return self:getDiscountPrice(shopItemID)
	else
		return self:getOriginalPrice(shopItemID)
	end
end
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		local lang = userSDKManager.getChannel()
		local _ENV, config
		if "ar" == lang then
			config = require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_ar")
		elseif "en" == lang or "fa" == lang or userSDKManager.isKO() then
			config = require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en")
		else
			config, _ENV = require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en"), require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en")
		end
		dressShopltCtrl.defaultConfig, _ENV, dressShopltCtrl.shopItemIDList, _ENV = require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en"), require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en"), require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en"), require_once("app." .. LocalTblPath .. ".config_server.shop_dress_config_en")
		for index, v in pairs(config) do
			local shopItemID = v.shopItemID
			v.index = index
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.result = serviceFunctions.tableFormat(v.result, nil)
			dressShopltCtrl.defaultConfig[shopItemID] = v
			table.insert(dressShopltCtrl.shopItemIDList, shopItemID)
		end
		if name == "shopItemIDList" then
			return dressShopltCtrl.shopItemIDList
		elseif name == "defaultConfig" then
			return dressShopltCtrl.defaultConfig
		end
	end
	dressShopltCtrl:defineValue("shopItemIDList", createData)
	dressShopltCtrl:defineValue("defaultConfig", createData)
end
init()
function dressShopltCtrl:getDefaultShopItem(shopItemID)
	return self.defaultConfig[shopItemID]
end
function dressShopltCtrl:initializeCustomConfig(data)
