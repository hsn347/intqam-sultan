local activity_9001713_Read = include("aAReadClass").new()
activity_9001713_Read:defineValue("shopGoodsCfg", function()
	local config = require_data("anniversary_shop_goods", true, true).data
	local _ENV, ret = "anniversary_shop_goods", "anniversary_shop_goods"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_ENV = nil
		;(nil).goodsLabel = v.goodsLabel
		;(nil).goodsItemID = v.goods[1]
		;(nil).goodsItemCount = v.goods[2]
		;(nil).itemID = v.originalPrice[1]
		;(nil).itemCount = v.originalPrice[2]
		ret[v.classType][v.goodsID], (nil).limit = nil, v.limit
	end
	return ret
end)
function activity_9001713_Read.getItemID()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.ANNIVERSARY_SHOP_2025)
	return activity_9001713_Read.shopGoodsCfg[classType][1].itemID
end
function activity_9001713_Read.getShopGoodCfg(goodsID)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.ANNIVERSARY_SHOP_2025)
	return activity_9001713_Read.shopGoodsCfg[classType][goodsID]
end
function _UPVALUE2_()
	local config = require_data("anniversary_shop_goods", true, true).data
	local _ENV, ret = "anniversary_shop_goods", "anniversary_shop_goods"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_ENV = nil
		;(nil).goodsLabel = v.goodsLabel
		;(nil).goodsItemID = v.goods[1]
		;(nil).goodsItemCount = v.goods[2]
		;(nil).itemID = v.originalPrice[1]
		;(nil).itemCount = v.originalPrice[2]
		ret[v.classType][v.goodsID], (nil).limit = nil, v.limit
	end
	return ret
end
;(function()
	local config = require_data("anniversary_shop_goods", true, true).data
	local _ENV, ret = "anniversary_shop_goods", "anniversary_shop_goods"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_ENV = nil
		;(nil).goodsLabel = v.goodsLabel
		;(nil).goodsItemID = v.goods[1]
		;(nil).goodsItemCount = v.goods[2]
		;(nil).itemID = v.originalPrice[1]
		;(nil).itemCount = v.originalPrice[2]
		ret[v.classType][v.goodsID], (nil).limit = nil, v.limit
	end
	return ret
end)[1] = "anniversary_shop_recharge"
;(function()
	local config = require_data("anniversary_shop_goods", true, true).data
	local _ENV, ret = "anniversary_shop_goods", "anniversary_shop_goods"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_ENV = nil
		;(nil).goodsLabel = v.goodsLabel
		;(nil).goodsItemID = v.goods[1]
		;(nil).goodsItemCount = v.goods[2]
		;(nil).itemID = v.originalPrice[1]
		;(nil).itemCount = v.originalPrice[2]
		ret[v.classType][v.goodsID], (nil).limit = nil, v.limit
	end
	return ret
end)[2] = true
activity_9001713_Read:defineValue("anniversary_shop_recharge", function()
	local config = require_data("anniversary_shop_goods", true, true).data
	local _ENV, ret = "anniversary_shop_goods", "anniversary_shop_goods"
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_ENV = nil
		;(nil).goodsLabel = v.goodsLabel
		;(nil).goodsItemID = v.goods[1]
		;(nil).goodsItemCount = v.goods[2]
		;(nil).itemID = v.originalPrice[1]
		;(nil).itemCount = v.originalPrice[2]
		ret[v.classType][v.goodsID], (nil).limit = nil, v.limit
	end
	return ret
end)
function activity_9001713_Read.getRechargeCfg(rechargeID)
	if rechargeID then
		for _, v in ipairs(activity_9001713_Read.anniversary_shop_recharge) do
			if v.rechargeID == rechargeID then
				return v
			end
		end
	else
		return activity_9001713_Read.anniversary_shop_recharge
	end
end
return activity_9001713_Read
