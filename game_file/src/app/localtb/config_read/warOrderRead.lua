local warOrderRead = include("aAReadClass").new()
function warOrderRead.init()
	local createData = function(name)
		local _ENV, ret
		local maxLv = 1
		local maxIndex = 1
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			maxLv = v.lv
			maxIndex = k
			table.insert(ret[v.classType], v)
		end
		_ENV = (for generator)
		ipairs(cfg).buraq_lv_exp = "buraq_lv_reward"
		ipairs(cfg).magiclampdecree_lv_exp = "magiclampdecree_lv_reward"
		local ipairs(cfg).wardrum_lv_exp, name2reward = "wardrum_lv_reward", ipairs(cfg)
		local cfgMax = require_data(name2reward[name], true, true).data
		for k, v in ipairs(cfgMax) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			v.index = maxIndex
			v.lvMax = maxLv
			v.lv = maxLv + 1
			table.insert(ret[v.classType], v)
		end
		return ret
	end
	local createData2 = function(name)
		local _ENV, ret
		local maxLv = 1
		local maxIndex = 1
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			maxLv = v.lv
			maxIndex = k
			local groupID = v.groupID or 1
			if not ret[groupID] then
				_ENV = ret[groupID]
			end
			ret[groupID] = ret[groupID]
			if not ret[groupID][v.classType] then
				_ENV = ret[groupID][v.classType]
			end
			ret[groupID][v.classType] = ret[groupID][v.classType]
			table.insert(ret[groupID][v.classType], v)
		end
		_ENV = (for generator)
		local ipairs(cfg).magiclampdecree_lv_exp, name2reward = "magiclampdecree_lv_reward", ipairs(cfg)
		local rewardName = name2reward[name]
		if not rewardName then
			return ret
		end
		local cfgMax = require_data(rewardName, true, true).data
		for groupID, __ in ipairs(ret) do
			for k, v in ipairs(cfgMax) do
				if not ret[groupID][v.classType] then
					_ENV = ret[groupID][v.classType]
				end
				ret[groupID][v.classType] = ret[groupID][v.classType]
				v.index = maxIndex
				v.lvMax = maxLv
				v.lv = maxLv + 1
				table.insert(ret[groupID][v.classType], v)
			end
		end
		return ret
	end
	warOrderRead:defineValue("buraq_lv_exp", createData)
	warOrderRead:defineValue("magiclampdecree_lv_exp", createData2)
	warOrderRead:defineValue("wardrum_lv_exp", createData)
	warOrderRead:defineValue("magichatchdecree_reward", function(...)
		local baseConfig = require_data("magichatchdecree_reward", true, true).data
		return warOrderRead.getClassTypeConfig(baseConfig, "classType")
	end)
	warOrderRead:defineValue("anilalampdecree_reward", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "buraq_recharge"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("buraq_recharge", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	warOrderRead = nil
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end).keyList, (nil)[1] = nil, "groupID"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "magiclampdecree_recharge"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("magiclampdecree_recharge", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "wardrum_recharge"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("wardrum_recharge", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "magichatchdecree_recharge"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("magichatchdecree_recharge", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	warOrderRead = nil
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end).keyList, (nil)[1] = nil, "groupID"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "anilalampdecree_recharge"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("anilalampdecree_recharge", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "buraq_quest"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("buraq_quest", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	warOrderRead = nil
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end).keyList, (nil)[1] = nil, "groupID"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "magiclampdecree_quest"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("magiclampdecree_quest", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "wardrum_quest"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("wardrum_quest", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "magichatchdecree_quest"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("magichatchdecree_quest", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	warOrderRead = nil
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end).keyList, (nil)[1] = nil, "groupID"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "anilalampdecree_quest"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = true
	warOrderRead:defineValue("anilalampdecree_quest", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function warOrderRead(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "buraq_reward_show"
	warOrderRead:defineValue("buraq_reward_show", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	warOrderRead = nil
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end).keyList, (nil)[1] = nil, "groupID"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "magiclampdecree_reward_show"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = false
	warOrderRead:defineValue("magiclampdecree_reward_show", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function warOrderRead(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "wardrum_reward_show"
	warOrderRead:defineValue("wardrum_reward_show", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function warOrderRead(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "magichatchdecree_reward_show"
	warOrderRead:defineValue("magichatchdecree_reward_show", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function _UPVALUE2_(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	warOrderRead = nil
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end).keyList, (nil)[1] = nil, "groupID"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "anilalampdecree_reward_show"
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[2] = false
	warOrderRead:defineValue("anilalampdecree_reward_show", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	function warOrderRead(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end
	;(function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)[1] = "buraq_bg_res"
	warOrderRead:defineValue("buraq_bg_res", function(...)
		local baseConfig = require_data("anilalampdecree_reward", true, true).data
		_UPVALUE2_ = true
		;(true)[1] = "groupID"
		;(true)[2] = "classType"
		return warOrderRead.getKeyListConfig(baseConfig, true)
	end)
	local createData = function(name)
		local _ENV, ret
		local cfg = require_data(name, false, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.RechargeID] then
				if not ret[v.RechargeID] then
					_ENV = ret[v.RechargeID]
				end
				ret[v.RechargeID] = ret[v.RechargeID]
			end
			_ENV = nil
			;(nil).EffectDescription = v.EffectDescription
			;(nil).EffectIcon = v.EffectIcon
			table.insert(ret[v.RechargeID], nil)
		end
		return ret
	end
	local createData2 = function(name)
		local _ENV, ret
		local cfg = require_data(name, false, true).data
		for k, v in ipairs(cfg) do
			local groupID = v.groupID or 1
			if not ret[groupID] then
				_ENV = ret[groupID]
			end
			ret[groupID] = ret[groupID]
			if not ret[groupID][v.RechargeID] then
				_ENV = ret[groupID][v.RechargeID]
			end
			ret[groupID][v.RechargeID] = ret[groupID][v.RechargeID]
			_ENV = v.RechargeID
			v.RechargeID.EffectDescription = v.EffectDescription
			v.RechargeID.EffectIcon = v.EffectIcon
			table.insert(ret[groupID][v.RechargeID], v.RechargeID)
		end
		return ret
	end
	warOrderRead:defineValue("buraq_effect_show", createData)
	warOrderRead:defineValue("magiclampdecree_effect_show", createData2)
	warOrderRead:defineValue("wardrum_effect_show", createData)
	warOrderRead:defineValue("magichatchdecree_effect_show", createData)
	warOrderRead:defineValue("anilalampdecree_effect_show", createData2)
	local createData = function(name)
		local _ENV, ret
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			local classType = v.classType or 1
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][v.BuildType] then
				_ENV = ret[classType][v.BuildType]
			end
			ret[classType][v.BuildType] = ret[classType][v.BuildType]
			_ENV = ret[classType][v.BuildType]
			ret[classType][v.BuildType].CastleLv = v.Lv
			ret[classType][v.BuildType].PrivilegeEffect = v.PrivilegeEffect
			ret[classType][v.BuildType][v.RechargeID], ret[classType][v.BuildType].EffectIcon = ret[classType][v.BuildType], v.EffectIcon
		end
		return ret
	end
	warOrderRead:defineValue("buraq_effect", createData)
	local createData = function(name)
		local _ENV, ret
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.BuildType] then
				ret[v.BuildType], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).CastleLv = v.Lv
			;(nil).PrivilegeEffect = v.PrivilegeEffect
			ret[v.BuildType][v.RechargeID], (nil).EffectIcon = nil, v.EffectIcon
		end
		return ret
	end
	local createData2 = function(name)
		local _ENV, ret
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			local groupID = v.groupID or 1
			if not ret[groupID] then
				_ENV = ret[groupID]
			end
			ret[groupID] = ret[groupID]
			if not ret[groupID][v.BuildType] then
				_ENV = ret[groupID][v.BuildType]
			end
			ret[groupID][v.BuildType] = ret[groupID][v.BuildType]
			_ENV = ret[groupID][v.BuildType]
			ret[groupID][v.BuildType].CastleLv = v.Lv
			ret[groupID][v.BuildType].PrivilegeEffect = v.PrivilegeEffect
			ret[groupID][v.BuildType][v.RechargeID], ret[groupID][v.BuildType].EffectIcon = ret[groupID][v.BuildType], v.EffectIcon
		end
		return ret
	end
	warOrderRead:defineValue("magiclampdecree_effect", createData2)
	warOrderRead:defineValue("wardrum_effect", createData)
	warOrderRead:defineValue("magichatchdecree_effect", createData)
	warOrderRead:defineValue("anilalampdecree_effect", createData2)
	_UPVALUE2_ = createData2
	warOrderRead = nil
	createData2.keyList, (nil)[1] = nil, "groupID"
	createData2[1] = "magiclampdecree_effect"
	createData2[2] = true
	warOrderRead:defineValue("magiclampdecree_effect_base", createData2)
	_UPVALUE2_ = createData2
	createData2[1] = "wardrum_effect"
	createData2[2] = true
	warOrderRead:defineValue("wardrum_effect_base", createData2)
	_UPVALUE2_ = createData2
	createData2[1] = "magichatchdecree_effect"
	createData2[2] = true
	warOrderRead:defineValue("magichatchdecree_effect_base", createData2)
	_UPVALUE2_ = createData2
	warOrderRead = nil
	createData2.keyList, (nil)[1] = nil, "groupID"
	createData2[1] = "anilalampdecree_effect"
	createData2[2] = true
	warOrderRead:defineValue("anilalampdecree_effect_base", createData2)
end
function warOrderRead.getAllAward(activityID, index, rechargeID)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		return warOrderRead.magiclampdecree_reward_show[groupId][index].Rewards
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		return warOrderRead.magichatchdecree_reward_show[index].Rewards
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		return warOrderRead.anilalampdecree_reward_show[groupId][index].Rewards
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		local _ENV, rewards = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581, gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
		local _ENV, ret = activity_9001701_Ctrl:getGroupId(), activity_9001701_Ctrl:getGroupId()
		local classType = SoraDGetCtrl("activityShowCtrl"):getParamClassType(activityID)
		if not warOrderRead.wardrum_lv_exp[classType] then
			_ENV = warOrderRead.wardrum_lv_exp[classType]
		end
		for k, v in ipairs(warOrderRead.wardrum_lv_exp[classType]) do
			local award = v["goldAward" .. index]
			for i = 1, #award - 1, 2 do
				if not rewards[award[i]] then
					rewards[award[i]] = award[i + 1]
				else
					rewards[award[i]] = rewards[award[i]] + award[i + 1]
				end
			end
		end
		for id, count in pairs(rewards) do
			_ENV = #award - 1
			;(#award - 1).id = id
			;(#award - 1).count = count
			table.insert(ret, #award - 1)
		end
		table.sort(ret, function(a, b)
			return a.id < b.id
		end)
		return ret
	else
		for i, v in ipairs(warOrderRead.buraq_reward_show) do
			if v.RechargeID == rechargeID then
				return v.Rewards
			end
		end
	end
end
function warOrderRead.getLvAwardList(activityID, classType)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		if not warOrderRead.magiclampdecree_lv_exp[groupId][classType] then
			_ENV = warOrderRead.magiclampdecree_lv_exp[groupId][classType]
		end
		return warOrderRead.magiclampdecree_lv_exp[groupId][classType]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		if not warOrderRead.wardrum_lv_exp[classType] then
			_ENV = warOrderRead.wardrum_lv_exp[classType]
		end
		return warOrderRead.wardrum_lv_exp[classType]
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		local config = warOrderRead.magichatchdecree_reward
		if not config[classType] and not config[1] then
			_ENV = config[1]
		end
		return config[1]
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		local config = warOrderRead.anilalampdecree_reward[groupId]
		if not config[classType] and not config[1] then
			_ENV = config[1]
		end
		return config[1]
	else
		if not warOrderRead.buraq_lv_exp[classType] then
			_ENV = warOrderRead.buraq_lv_exp[classType]
		end
		return warOrderRead.buraq_lv_exp[classType]
	end
end
function warOrderRead.getRechargeConfig(activityID, rewardType)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		return warOrderRead.magiclampdecree_recharge[groupId][rewardType]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		local classType = SoraDGetCtrl("activityShowCtrl"):getParamClassType(activityID)
		for i, v in ipairs(warOrderRead.wardrum_recharge) do
			if v.rewardType == rewardType and v.classType == classType then
				return v
			end
		end
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		return warOrderRead.magichatchdecree_recharge[rewardType]
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		return warOrderRead.anilalampdecree_recharge[groupId][rewardType]
	else
		local classType = SoraDGetCtrl("activityShowCtrl"):getParamClassType(activityID)
		for i, v in ipairs(warOrderRead.buraq_recharge) do
			if v.rewardType == rewardType and v.classType == classType then
				return v
			end
		end
	end
end
function warOrderRead.getTaskListByIndex(activityID, classType)
	if not classType then
		_ENV = nil
		return nil
	end
	local _ENV, taskList
	local config
	local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		config = warOrderRead.magiclampdecree_quest[groupId]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		config = warOrderRead.wardrum_quest
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		config = warOrderRead.magichatchdecree_quest
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		config = warOrderRead.anilalampdecree_quest[groupId]
	else
		config = warOrderRead.buraq_quest
	end
	for i, qeustGroup in ipairs(config) do
		if classType == qeustGroup.classType then
			local taskSet = qeustGroup.questID
			local fogShow = qeustGroup.FogShow or 0
			for i, taskID in ipairs(taskSet) do
				if not (not (0 < fogShow) or SoraDGetCtrl("kingdomMapCtrl"):checkFogLv(fogShow)) then
					break
				end
				if not curCtrl:isTaskClaimed(taskID) then
					table.insert(taskList, taskID)
					break
				elseif i == #taskSet then
					table.insert(taskList, taskID)
					break
				end
			end
		end
	end
	return taskList
end
function warOrderRead.getNextExp(activityID, level, classType)
	local list = warOrderRead.getLvAwardList(activityID, classType)
	for _, info in ipairs(list) do
		if info.lv == level + 1 then
			return info.exp
		end
	end
	return list[#list].exp
end
function warOrderRead.getGiftAwardInfo(activityID, index)
	if not warOrderRead.getRechargeConfig(activityID, index) then
		warOrderRead = warOrderRead.getRechargeConfig(activityID, index)
	end
	return (warOrderRead.getRechargeConfig(activityID, index))
end
function warOrderRead.getBuffInfo(activityID, buffType, index)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 then
		local activity_9001601_Read = include("activity_9001601_Read")
		return activity_9001601_Read.getBuffInfo(buffType, index)
	end
	local rechargeID = warOrderRead.getRechargeIDByIndex(activityID, index)
	print("rechargeID", activityID, rechargeID, buffType, index)
	local config
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		config = warOrderRead.magiclampdecree_effect[groupId]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		config = warOrderRead.wardrum_effect
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		config = warOrderRead.magichatchdecree_effect
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		config = warOrderRead.anilalampdecree_effect[groupId]
	else
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local classType = activityShowCtrl:getParamClassType(activityID)
		config = warOrderRead.buraq_effect[classType]
	end
	if config[buffType] then
		return config[buffType][rechargeID]
	end
end
function warOrderRead.getRechargeIDByIndex(activityID, index)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY] = true
	;(nil)[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY] = true
	local (nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], config = true, nil
	if config[activityID] then
		local classMax = warOrderRead.getClassTypeMax(activityID)
		if index > classMax then
			index = index - classMax
		end
		local info = warOrderRead.getGiftAwardInfo(activityID, index)
		return info.RechargeID
	end
	local rechargeID = 1
	if 1 < index then
		local info = warOrderRead.getGiftAwardInfo(activityID, index - 1)
		rechargeID = info.RechargeID
	end
	return rechargeID
end
function warOrderRead.getEffectShow(activityID, rechargeID)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		return warOrderRead.magiclampdecree_effect_show[groupId][rechargeID]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		return warOrderRead.wardrum_effect_show[rechargeID]
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		return warOrderRead.magichatchdecree_effect_show[rechargeID]
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		return warOrderRead.anilalampdecree_effect_show[groupId][rechargeID]
	else
		return warOrderRead.buraq_effect_show[rechargeID]
	end
end
function warOrderRead.openSkillBuffView(activityID)
	if activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY or activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 or activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 then
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("BraqueTestSkillfulBuff", nil)
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("Activity_9001683_Buff", nil)
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("Activity_9001683_Buff", nil)
	else
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("Activity_9001565_Buff", nil)
	end
end
function warOrderRead.getEffectCount(activityID, buildType)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		if not warOrderRead.magiclampdecree_effect[groupId][buildType] then
			local _ENV, config = warOrderRead.magiclampdecree_effect[groupId][buildType], warOrderRead.magiclampdecree_effect[groupId][buildType]
		end
		return table.nums(config)
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		if not warOrderRead.wardrum_effect[buildType] then
			local _ENV, config = warOrderRead.wardrum_effect[buildType], warOrderRead.wardrum_effect[buildType]
		end
		return table.nums(config)
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		if not warOrderRead.magichatchdecree_effect[buildType] then
			local _ENV, config = warOrderRead.magichatchdecree_effect[buildType], warOrderRead.magichatchdecree_effect[buildType]
		end
		return table.nums(config)
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		if not warOrderRead.anilalampdecree_effect[groupId][buildType] then
			local _ENV, config = warOrderRead.anilalampdecree_effect[groupId][buildType], warOrderRead.anilalampdecree_effect[groupId][buildType]
		end
		return table.nums(config)
	else
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local classType = activityShowCtrl:getParamClassType(activityID)
		if not warOrderRead.buraq_effect[classType][buildType] then
			local _ENV, config = warOrderRead.buraq_effect[classType][buildType], warOrderRead.buraq_effect[classType][buildType]
		end
		return table.nums(config)
	end
end
function warOrderRead.getClassTypeMax(activityID)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		return #warOrderRead.magiclampdecree_effect_base[groupId]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		return #warOrderRead.wardrum_effect_base
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		return #warOrderRead.magichatchdecree_effect_base
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		return #warOrderRead.anilalampdecree_effect_base[groupId]
	else
		return 1
	end
end
function warOrderRead.getStarLvMax(activityID)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
		local groupId = activity_9001565_Ctrl:getGroupId()
		local config = warOrderRead.magiclampdecree_effect_base[groupId]
		return config[#config].Lv[2]
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		local config = warOrderRead.wardrum_effect_base
		return config[#config].Lv[2]
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		local config = warOrderRead.magichatchdecree_effect_base
		return config[#config].Lv[2]
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		local groupId = activity_9001701_Ctrl:getGroupId()
		local config = warOrderRead.anilalampdecree_effect_base[groupId]
		return config[#config].Lv[2]
	else
		return 1
	end
end
function warOrderRead.getHeroDressID(classType)
	for i, v in ipairs(warOrderRead.buraq_bg_res) do
		if v.classType == classType then
			return v.heroDress
		end
	end
end
function warOrderRead.isBuffEffect(activityID, buffType, index)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return false
	end
	if 0 < index then
		local effectInfo = warOrderRead.getBuffInfo(activityID, buffType, index)
		if effectInfo then
			local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
			local lv = warOrderCtrl:getNowLvByBuffType(buffType)
			if lv >= effectInfo.CastleLv[1] and lv <= effectInfo.CastleLv[2] then
				return true
			end
		end
	end
	return false
end
function warOrderRead.getBuffVale(activityID, effectType, index)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return 0
	end
	local value = 0
	for _, buffType in pairs(BUILD_ENUM) do
		for i = 1, 3 do
			if i <= index and warOrderRead.isBuffEffect(activityID, buffType, index) then
				local effectInfo = warOrderRead.getBuffInfo(activityID, buffType, i)
				if not effectInfo or not effectInfo.PrivilegeEffect then
					local _ENV, privilegeEffect = effectInfo.PrivilegeEffect, effectInfo.PrivilegeEffect
				end
				local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
				for _, v in ipairs(privilegeEffect) do
					if buffltCtrl:getEffectType(v) == effectType then
						local effect, _ = buffltCtrl:getEffect(v)
						value = value + effect
						print("==warOrderRead:getBuffVale==", effect, effectType, value, i, buffType, v)
						break
					end
				end
			end
		end
	end
	return value
end
function warOrderRead.getMagicLampBuffEffect(effectType)
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	_UPVALUE7_ = "buffCtrl"
	;("buffCtrl")[1] = gBuffSource.WAR_ORDER
	;("buffCtrl")[2] = gBuffSource.WAR_HORN
	;("buffCtrl")[3] = gBuffSource.ACTIVITY_9001565
	;("buffCtrl")[4] = gBuffSource.ACTIVITY_9001601
	;("buffCtrl")[5] = gBuffSource.ACTIVITY_9001656
	;("buffCtrl")[6] = gBuffSource.ACTIVITY_9001701
	local ("buffCtrl")[7], sourceList = gBuffSource.KOH_MIGRATE_HELP_9001708, "buffCtrl"
	local _ENV, tempList = gBuffSource.WAR_ORDER, gBuffSource.WAR_ORDER
	for __, source in ipairs(sourceList) do
		local value = buffCtrl:getBuffEffect(effectType, source) or 0
		table.insert(tempList, value)
	end
	local ret = 1
	for __, percent in ipairs(tempList) do
		ret = ret * (1 - percent / 1000)
	end
	return ret
end
function warOrderRead.getBuildBuffEffect(effectType, buildData)
	local buffCtrl = SoraDGetCtrl("buffCtrl")
	_UPVALUE5_ = "buffCtrl"
	;("buffCtrl")[1] = gBuffSource.WAR_ORDER
	;("buffCtrl")[2] = gBuffSource.WAR_HORN
	;("buffCtrl")[3] = gBuffSource.ACTIVITY_9001601
	;("buffCtrl")[4] = gBuffSource.ACTIVITY_9001656
	local ("buffCtrl")[5], sourceList = gBuffSource.KOH_MIGRATE_HELP_9001708, "buffCtrl"
	local _ENV, tempList = gBuffSource.WAR_ORDER, gBuffSource.WAR_ORDER
	for __, source in ipairs(sourceList) do
		local value = buffCtrl:getBuffEffect(effectType, source) or 0
		table.insert(tempList, value)
	end
	local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
	local effectValueR = radiantDecreeCtrl:getBuffVale(effectType, buildData)
	local activity_9001710_Ctrl = SoraDGetCtrl("activity_9001710_Ctrl")
	table.insert(tempList, activity_9001710_Ctrl:getBuffVale(effectType, buildData and buildData.bid))
	local effectValueW = buffCtrl:getBuffEffect(effectType, gBuffSource.PALACE_OF_WISDOM_ACTIVITY)
	table.insert(tempList, math.max(effectValueW, effectValueR))
	local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
	table.insert(tempList, ExtremelySkillfulCtrl:getBuffVale(effectType))
	local ret = 1
	for __, percent in ipairs(tempList) do
		ret = ret * (1 - percent / 1000)
	end
	return ret
end
warOrderRead.init()
return warOrderRead
