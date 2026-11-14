local activity_9001708_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyList, (nil)[1] = nil, "taskType"
;(nil).insertKey = "taskID"
;(nil)[1] = "migrant_move_help_task"
;(nil)[2] = true
activity_9001708_Read:defineValue("migrant_move_help_task", nil)
function activity_9001708_Read.getTaskIDList(taskType)
	if not activity_9001708_Read.migrant_move_help_task[taskType] then
		activity_9001708_Read = activity_9001708_Read.migrant_move_help_task[taskType]
	end
	return activity_9001708_Read.migrant_move_help_task[taskType]
end
_UPVALUE2_ = nil
_UPVALUE3_, _ENV = "taskType"
_UPVALUE2_, (nil).buff, ("taskType")[1] = "taskType", "taskType", "buffId"
_UPVALUE2_, (nil).buff, ("taskType")[2] = "taskType", "taskType", "lvType"
_UPVALUE2_, (nil).buff, ("taskType")[3] = "taskType", "taskType", "maxLv"
_UPVALUE1_, (nil).tableFormat, (nil).gift, ("taskType")[1] = nil, nil, "taskType", "id"
_UPVALUE1_, (nil).tableFormat, (nil).gift, ("taskType")[2] = nil, nil, "taskType", "count"
;(nil).keyMap, (nil)[1] = nil, "giftId"
;(nil)[1] = "migrant_move_help_recharge"
;(nil)[2] = true
activity_9001708_Read:defineValue("migrant_move_help_recharge", nil)
function activity_9001708_Read.getRechargeConfig(giftId)
	return activity_9001708_Read.migrant_move_help_recharge[giftId]
end
function activity_9001708_Read.getRechargeBuffDes(giftId)
	local cfg = activity_9001708_Read.getRechargeConfig(giftId)
	return i18n(cfg.buffDes)
end
function activity_9001708_Read.getRechargeBuff(giftId)
	local cfg = activity_9001708_Read.getRechargeConfig(giftId)
	return cfg.buff
end
function activity_9001708_Read.getRechargeExtraData(giftId)
	local cfg = activity_9001708_Read.getRechargeConfig(giftId)
	return cfg.extraData
end
function activity_9001708_Read.getNotBuffPackageList()
	local _ENV, ret
	for giftId, cfg in pairs(activity_9001708_Read.migrant_move_help_recharge) do
		local buff = activity_9001708_Read.getRechargeBuff(giftId)
		if #buff == 0 then
			_ENV = nil
			;(nil).id = giftId
			;(nil).giftType = "normalGift"
			;(nil).price = cfg.price
			table.insert(ret, nil)
		end
	end
	_UPVALUE2_, _UPVALUE2_ = nil, pairs(activity_9001708_Read.migrant_move_help_recharge)
	_UPVALUE2_, (nil)[1] = "price", "price"
	_UPVALUE2_, (nil)[2] = "price", ">"
	;("price")[1] = "id"
	;("price")[2] = "<"
	pairs(activity_9001708_Read.migrant_move_help_recharge)[1] = nil
	pairs(activity_9001708_Read.migrant_move_help_recharge)[2] = "price"
	serviceFunctions.sort(ret, pairs(activity_9001708_Read.migrant_move_help_recharge))
	return ret
end
function activity_9001708_Read.getExchangeConfig(activityID)
	local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
	local config = newExchangeMallCtrl:getConfigByActivityID(activityID)
	local _ENV, ret = newExchangeMallCtrl, newExchangeMallCtrl
	for __, cfg in ipairs(config) do
		local itemSheet = cfg.itemSheet or 0
		if not ret[itemSheet] then
			_ENV = ret[itemSheet]
		end
		ret[itemSheet] = ret[itemSheet]
		table.insert(ret[itemSheet], cfg)
	end
	return ret
end
return activity_9001708_Read
