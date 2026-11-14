local activity_9001496_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "buildthrivingbuff"
;(nil)[2] = true
activity_9001496_Read:defineValue("buildthrivingbuff", nil)
activity_9001496_Read:defineValue("buffConfig", function()
	return activity_9001496_Read.getClassTypeConfig(activity_9001496_Read.buildthrivingbuff)
end)
function activity_9001496_Read.getBuffConfig()
	local classType = activity_9001496_Read.getClassType()
	return activity_9001496_Read.buffConfig[classType]
end
function activity_9001496_Read.getFirstBuff(...)
	local buildthrivingbuff = activity_9001496_Read.getBuffConfig()
	return buildthrivingbuff[1].buff
end
function activity_9001496_Read.getBuffLvMax(...)
	local buildthrivingbuff = activity_9001496_Read.getBuffConfig()
	return buildthrivingbuff[#buildthrivingbuff].lv[2]
end
function _UPVALUE2_()
	return activity_9001496_Read.getClassTypeConfig(activity_9001496_Read.buildthrivingbuff)
end
;(function()
	return activity_9001496_Read.getClassTypeConfig(activity_9001496_Read.buildthrivingbuff)
end)[1] = "buildthrivingquest"
;(function()
	return activity_9001496_Read.getClassTypeConfig(activity_9001496_Read.buildthrivingbuff)
end)[2] = true
activity_9001496_Read:defineValue("buildthrivingquest", function()
	return activity_9001496_Read.getClassTypeConfig(activity_9001496_Read.buildthrivingbuff)
end)
activity_9001496_Read:defineValue("questConfig", function()
	return activity_9001496_Read.getClassTypeConfig(activity_9001496_Read.buildthrivingquest)
end)
function activity_9001496_Read.getTaskConfig()
	local classType = activity_9001496_Read.getClassType()
	return activity_9001496_Read.questConfig[classType]
end
function activity_9001496_Read.getClassType(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY)
	return classType
end
function activity_9001496_Read.getRechargePriceMax()
	local ret = 0
	local taskConfig = activity_9001496_Read.getTaskConfig()
	for i, v in ipairs(taskConfig) do
		if ret < v.price then
			ret = v.price
		end
	end
	return ret
end
activity_9001496_Read:defineValue("buildthrivinggift", function()
	local _ENV, config
	local buildthrivinggift = require_data("buildthrivinggift", true).data
	for i, v in ipairs(buildthrivinggift) do
		local gType = v.Type
		local classType = v.classType
		if not config[classType] then
			_ENV = config[classType]
		end
		config[classType] = config[classType]
		if not config[classType][gType] then
			_ENV = config[classType][gType]
		end
		config[classType][gType] = config[classType][gType]
		table.insert(config[classType][gType], v)
	end
	return config
end)
function activity_9001496_Read.getGiftList(gType)
	local classType = activity_9001496_Read.getClassType()
	local config = activity_9001496_Read.buildthrivinggift[classType]
	return config[gType]
end
activity_9001496_Read:defineValue("giftCfg", function()
	local _ENV, config
	local buildthrivinggift = require_data("buildthrivinggift", true).data
	for i, v in ipairs(buildthrivinggift) do
		local classType = v.classType
		if not config[classType] then
			_ENV = config[classType]
		end
		config[classType] = config[classType]
		config[classType][v.GiftId] = v
	end
	return config
end)
function activity_9001496_Read.getGiftCfg(gType)
	local classType = activity_9001496_Read.getClassType()
	local config = activity_9001496_Read.giftCfg[classType]
	return config[gType]
end
function _UPVALUE1_()
	local _ENV, config
	local buildthrivinggift = require_data("buildthrivinggift", true).data
	for i, v in ipairs(buildthrivinggift) do
		local classType = v.classType
		if not config[classType] then
			_ENV = config[classType]
		end
		config[classType] = config[classType]
		config[classType][v.GiftId] = v
	end
	return config
end
;(function()
	local _ENV, config
	local buildthrivinggift = require_data("buildthrivinggift", true).data
	for i, v in ipairs(buildthrivinggift) do
		local classType = v.classType
		if not config[classType] then
			_ENV = config[classType]
		end
		config[classType] = config[classType]
		config[classType][v.GiftId] = v
	end
	return config
end)[1] = "buildthrivinglabel"
activity_9001496_Read:defineValue("buildthrivinglabel", function()
	local _ENV, config
	local buildthrivinggift = require_data("buildthrivinggift", true).data
	for i, v in ipairs(buildthrivinggift) do
		local classType = v.classType
		if not config[classType] then
			_ENV = config[classType]
		end
		config[classType] = config[classType]
		config[classType][v.GiftId] = v
	end
	return config
end)
function activity_9001496_Read.getLabelList(...)
	local _ENV, ret
	for i, v in ipairs(activity_9001496_Read.buildthrivinglabel) do
		if activity_9001496_Read.getGiftList(v.ID) then
			table.insert(ret, v)
		end
	end
	return ret
end
function activity_9001496_Read.getLabelCfg(lType)
	return activity_9001496_Read.buildthrivinglabel[lType]
end
function activity_9001496_Read.getLabelPicture(lType)
	local cfg = activity_9001496_Read.getLabelCfg(lType)
	return cfg.picture
end
function activity_9001496_Read.getActivityViewImageBg(...)
	local classType = activity_9001496_Read.getClassType()
	activity_9001496_Read = nil
	;(nil)[1] = "frame_BuildThriving_bg02.png"
	;(nil)[2] = "frame_BuildThriving_bg02.png"
	;(nil)[3] = "frame_BuildThriving_bg02.png"
	local (nil)[4], classType2bg = "frame_BuildThriving_bg02.png", nil
	return classType2bg[classType] or classType2bg[1]
end
return activity_9001496_Read
