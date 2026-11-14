local rechargeGiftltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		rechargeGiftltCtrl.data, rechargeGiftltCtrl.giftList = rechargeGiftltCtrl:getConfig()
		if name == "data" then
			return rechargeGiftltCtrl.data
		elseif name == "giftList" then
			return rechargeGiftltCtrl.giftList
		end
	end
	rechargeGiftltCtrl:defineValue("data", createData)
	rechargeGiftltCtrl:defineValue("giftList", createData)
end
function rechargeGiftltCtrl:getConfig()
	local config = require_once("app." .. LocalTblPath .. ".config_server.recharge_gift_config")
	local _ENV, giftList = "app." .. LocalTblPath .. ".config_server.recharge_gift_config", "app." .. LocalTblPath .. ".config_server.recharge_gift_config"
	for rid, data in pairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		data.result = serviceFunctions.tableFormat(data.result, nil)
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "quality"
		;(nil)[3] = "count"
		data.equipment = serviceFunctions.tableFormat(data.equipment, nil)
		local conditionsSplit = string.split(data.condition, ";")
		local _ENV, condition = data.condition, data.condition
		for _, v in pairs(conditionsSplit) do
			local conditionSplit = string.split(v, ",")
			local conditionType = tonumber(conditionSplit[1])
			local aim
			if gRechargeGiftCondType.CASTLE_LEVEL == conditionType then
				aim = tonumber(conditionSplit[2])
			end
			if nil ~= conditionType then
				_ENV = tonumber(conditionSplit[2])
				condition[conditionType], tonumber(conditionSplit[2]).aim = tonumber(conditionSplit[2]), aim
			end
		end
		data.condition = condition
		local giftType = data.giftType
		if not giftList[giftType] then
			_ENV = giftList[giftType]
		end
		giftList[giftType] = giftList[giftType]
		giftList[giftType][rid] = data
	end
	return config, giftList
end
function rechargeGiftltCtrl:rechargeIDValid(rid)
	if rid and self.data[rid] then
		return true
	end
	return false
end
function rechargeGiftltCtrl:getGiftType(rid)
	return self.data[rid] and self.data[rid].giftType
end
function rechargeGiftltCtrl:getResult(rid)
	local result = self.data[rid] and self.data[rid].result
	if result then
		result = clone(result)
		local equipment = self:getEquipment(rid)
		if "table" == type(equipment) and next(equipment) then
			for i, v in ipairs(equipment) do
				table.insert(result, v)
			end
		end
	end
	return result
end
function rechargeGiftltCtrl:getEquipment(rid)
	return self.data[rid] and self.data[rid].equipment
end
function rechargeGiftltCtrl:getPrice(rid)
	return self.data[rid] and self.data[rid].price
end
function rechargeGiftltCtrl:getCondition(rid)
	return self.data[rid] and self.data[rid].condition
end
function rechargeGiftltCtrl:getGold(rid)
	return self.data[rid] and self.data[rid].gold
end
function rechargeGiftltCtrl:getOriginalPrice(rid)
	return self.data[rid] and self.data[rid].originalPrice
end
function rechargeGiftltCtrl:getGiftList(giftType)
	return giftType and self.giftList[giftType]
end
function rechargeGiftltCtrl:getDiscount(rid)
	return self.data[rid] and self.data[rid].discount
end
function rechargeGiftltCtrl:getRefund(rid)
	return self.data[rid] and self.data[rid].refund
end
init()
return rechargeGiftltCtrl
