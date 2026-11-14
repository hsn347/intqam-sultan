local activity_9001639_Read = include("aAReadClass").new()
activity_9001639_Read:defineValue("eidal_market_gift", function()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end)
function activity_9001639_Read.getGiftCfg()
	return activity_9001639_Read.eidal_market_gift
end
function _UPVALUE2_()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end
;(function()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end)[1] = "eidal_market_daily_recharge"
;(function()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end)[2] = true
activity_9001639_Read:defineValue("eidalDailyCfg", function()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end)
function activity_9001639_Read.getDailyCfg()
	return activity_9001639_Read.eidalDailyCfg
end
function activity_9001639_Read.getDailyCfgByIndex(index)
	return activity_9001639_Read.eidalDailyCfg[index]
end
function _UPVALUE1_()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end
;(function()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end)[1] = "eidal_market_broadcast_color"
activity_9001639_Read:defineValue("eidal_market_broadcast_color", function()
	local config = require_data("eidal_market_gift", true, true).data
	local _ENV, ret = "eidal_market_gift", "eidal_market_gift"
	for _, v in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.result = serviceFunctions.tableFormat(v.result, nil)
		_ENV = "id"
		;("id").id = gIDDef.GOLD
		;("id").count = v.gold
		table.insert(v.result, 1, "id")
		table.insert(ret, v)
	end
	table.sort(ret, function(a, b)
		return a.id < b.id
	end)
	return ret
end)
function activity_9001639_Read.getBroadcastColor(num)
	local color = "#ffd43e"
	for k, v in ipairs(activity_9001639_Read.eidal_market_broadcast_color) do
		if num >= v.ItemNum then
			color = v.Color
		end
	end
	return color
end
return activity_9001639_Read
