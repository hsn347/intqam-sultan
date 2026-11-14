local activity_9001678_Read = include("aAReadClass").new()
activity_9001678_Read:defineValue("frosty_market_goods", function()
	local config = require_data("frosty_market_goods", true, true).data
	local _ENV, ret = "frosty_market_goods", "frosty_market_goods"
	for k, v in ipairs(config) do
		if not ret[v.skinType] then
			ret[v.skinType], _ENV = nil, nil
		end
		if not ret[v.skinType][v.classType] then
			ret[v.skinType][v.classType], _ENV = nil, nil
		end
		_ENV = ret[v.skinType]
		ret[v.skinType].id = v.goods[1]
		_ENV, v.goodCfg, ret[v.skinType].count = ret[v.skinType], ret[v.skinType], v.goods[2]
		ret[v.skinType].id = v.originalPrice[1]
		v.oriPrice, ret[v.skinType].count = ret[v.skinType], v.originalPrice[2]
		_UPVALUE2_ = nil
		;(nil)[1] = "val"
		;(nil)[2] = "rate"
		v.discount = serviceFunctions.tableFormat(v.discount, nil)
		ret[v.skinType][v.classType][v.goodsID] = v
	end
	return ret
end)
function activity_9001678_Read.getFrostyMarketCfg(goodsID)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.FROSTY_MARKET)
	local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
	local skin = activity_9001678_Ctrl:getSkin()
	return activity_9001678_Read.frosty_market_goods[skin][classType][goodsID]
end
function activity_9001678_Read.getFrostyMarketToolID()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.FROSTY_MARKET)
	local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
	local skin = activity_9001678_Ctrl:getSkin()
	return activity_9001678_Read.frosty_market_goods[skin][classType][1].oriPrice.id
end
activity_9001678_Read:defineValue("frosty_market_recharge", function()
	local config = require_data("frosty_market_recharge", true, true).data
	local _ENV, ret = "frosty_market_recharge", "frosty_market_recharge"
	for k, v in ipairs(config) do
		if not ret[v.skinType] then
			ret[v.skinType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.reward, 1, "id")
		table.insert(ret[v.skinType], v)
	end
	return ret
end)
function activity_9001678_Read.getFrostyRechargeCfg()
	local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
	local skin = activity_9001678_Ctrl:getSkin()
	return activity_9001678_Read.frosty_market_recharge[skin]
end
return activity_9001678_Read
