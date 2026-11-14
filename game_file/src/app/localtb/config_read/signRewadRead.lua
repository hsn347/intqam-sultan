local signRewadRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "remedy_sign_price"
	;(nil)[2] = true
	signRewadRead:defineValue("price", nil)
	signRewadRead:defineValue("config", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function signRewadRead()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "sign_reward_show"
	signRewadRead:defineValue("style", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "eid_banquet"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("signCfg", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "eid_banquet_remedy"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("remedy", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "nebula_sign_reward"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("nebula_sign_reward", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "nebula_sign_supplement"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("nebula_sign_supplement", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "sign_reward_config_2022"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("sign_reward_config_2022", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "remedy_sign_price_2022"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("remedy_sign_price_2022", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "snowmangift_reward"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("snowmangift_reward", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	function _ENV()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[1] = "2024icefestivalsignin"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)[2] = true
	signRewadRead:defineValue("icefestivalsignin", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.sign_reward_config")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.sign_reward_config", "app." .. LocalTblPath .. ".config_server.sign_reward_config"
		local index = 1
		for k, v in ipairs(cfg) do
			if not list[v.rewardType] then
				list[v.rewardType], _ENV = nil, nil
				index = 1
			end
			v.day = index
			table.insert(list[v.rewardType], v)
			index = index + 1
		end
		return list
	end)
	signRewadRead:defineValue("eidaladhasign_reward", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.eidaladhasign_reward")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.eidaladhasign_reward", "app." .. LocalTblPath .. ".config_server.eidaladhasign_reward"
		for k, v in ipairs(config) do
			if not list[v.group] then
				list[v.group], _ENV = nil, nil
			end
			table.insert(list[v.group], v.day, v)
		end
		return list
	end)
	signRewadRead:defineValue("ramadan_signin_reward", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.ramadan_signin_reward")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.ramadan_signin_reward", "app." .. LocalTblPath .. ".config_server.ramadan_signin_reward"
		for k, v in ipairs(config) do
			if not list[v.group] then
				list[v.group], _ENV = nil, nil
			end
			table.insert(list[v.group], v.day, v)
		end
		return list
	end)
end
init()
function signRewadRead.getGoldInfo()
	return signRewadRead.price
end
function signRewadRead.getRewardConfig(rewardType)
	local rewardType = rewardType or 1
	return signRewadRead.config[rewardType]
end
function signRewadRead.getCumuDayArray(rewardType)
	local _ENV, ret
	local rewardType = rewardType or 1
	for k, v in ipairs(signRewadRead.config[rewardType]) do
		if next(v.cumulateReward) then
			table.insert(ret, v.day)
		end
	end
	return ret
end
function signRewadRead.getStyleByID(_id)
	if signRewadRead.style[_id] then
		return signRewadRead.style[_id].blockStyle
	else
		return nil
	end
end
function signRewadRead.getSignCfg(castleLv)
	local _ENV, cfg
	for k, v in ipairs(signRewadRead.signCfg) do
		if castleLv >= v.Lv[1] and castleLv <= v.Lv[2] then
			table.insert(cfg, v)
		end
	end
	return cfg
end
function signRewadRead.getCumuSignCfg()
	for k, v in ipairs(signRewadRead.signCfg) do
		if next(v.cumulateReward) then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return serviceFunctions.tableFormat(v.cumulateReward, nil), v.day
		end
	end
end
function signRewadRead.getRemedyPrice(times)
	local times = math.min(times, #signRewadRead.remedy)
	return signRewadRead.remedy[times].price
end
function signRewadRead.getSonwComSignCfg()
	return signRewadRead.icefestivalsignin
end
function signRewadRead.getSonwComCumuSignCfg(day)
	for k, v in ipairs(signRewadRead.icefestivalsignin) do
		if next(v.cumulateReward) then
			local status = SoraDGetCtrl("activity_9001576_Ctrl"):getExtraRewardInfoByDay(v.day)
			if status == gSignRewardStatus.ALREADY_RECEIVE then
				if v.day == #signRewadRead.icefestivalsignin then
					return v
				end
			else
				return v
			end
		end
	end
end
function signRewadRead.getNebulaRegionSignCfg(classType)
	local _ENV, data
	local index = 1
	for i, v in ipairs(signRewadRead.nebula_sign_reward) do
		if v.group_id == classType then
			data[index] = v
			index = index + 1
		elseif classType < v.group_id then
			return data
		end
	end
	return data
end
function signRewadRead.nebulaRegionSignRemedyPrice(day)
	return signRewadRead.nebula_sign_supplement[day].gold
end
function signRewadRead.getAnniversary2022ExtraDay()
	local _ENV, extraList
	for i, v in ipairs(signRewadRead.sign_reward_config_2022) do
		if v.cumulateReward and next(v.cumulateReward) then
			table.insert(extraList, v.id)
		end
	end
	return extraList
end
function signRewadRead.getAnniversary2022SignCfg(day)
	return signRewadRead.sign_reward_config_2022[day]
end
function signRewadRead.getAnniversary2022TotalDay()
	return table.nums(signRewadRead.sign_reward_config_2022)
end
function signRewadRead.getAnniversary2022RemedyPrice(time)
	return signRewadRead.remedy_sign_price_2022[time].price
end
function signRewadRead:getAnniversary2022Award(day)
	if not signRewadRead.sign_reward_config_2022[tonumber(day)].normalReward then
		signRewadRead = signRewadRead.sign_reward_config_2022[tonumber(day)].normalReward
	end
	return signRewadRead.sign_reward_config_2022[tonumber(day)].normalReward
end
function signRewadRead:getAnniversary2022Extra(day)
	if not signRewadRead.sign_reward_config_2022[tonumber(day)].cumulateReward then
		signRewadRead = signRewadRead.sign_reward_config_2022[tonumber(day)].cumulateReward
	end
	return signRewadRead.sign_reward_config_2022[tonumber(day)].cumulateReward
end
function signRewadRead.getSnowmanGiftSignCfg(classType, day)
	local _ENV, cfg
	for k, v in ipairs(signRewadRead.snowmangift_reward) do
		if v.day == day and v.group == classType then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return serviceFunctions.tableFormat(v.normalReward, nil)
		end
	end
	return cfg
end
function signRewadRead.getSnowmanGiftCumuSignCfg(classType)
	for k, v in ipairs(signRewadRead.snowmangift_reward) do
		print("next(v.cumulateReward) and v.group == classType", v.group == classType, classType)
		if next(v.cumulateReward) and v.group == classType then
			_UPVALUE2_ = v.group == classType
			;(v.group == classType)[1] = "id"
			;(v.group == classType)[2] = "count"
			return serviceFunctions.tableFormat(v.cumulateReward, v.group == classType)
		end
	end
end
function signRewadRead.getRamadan2023ExtraDay(classType)
	local _ENV, extraList
	for i, v in ipairs(signRewadRead.ramadan_signin_reward[classType]) do
		if v.cumulateReward and next(v.cumulateReward) then
			table.insert(extraList, v.day)
		end
	end
	return extraList
end
function signRewadRead.getRamadan2023SignCfg(classType, day)
	return signRewadRead.ramadan_signin_reward[classType][day]
end
function signRewadRead.getRamadan2023TotalDay(classType)
	return table.nums(signRewadRead.ramadan_signin_reward[classType])
end
function signRewadRead.getRamadan2023RemedyPrice(classType, day)
	return signRewadRead.ramadan_signin_reward[classType][tonumber(day)].gold
end
function signRewadRead:getRamadan2023Award(classType, day)
	if not signRewadRead.ramadan_signin_reward[classType][tonumber(day)].reward then
		signRewadRead = signRewadRead.ramadan_signin_reward[classType][tonumber(day)].reward
	end
	return signRewadRead.ramadan_signin_reward[classType][tonumber(day)].reward
end
function signRewadRead:getRamadan2023Extra(classType, day)
	if not signRewadRead.ramadan_signin_reward[classType][tonumber(day)].cumulateReward then
		signRewadRead = signRewadRead.ramadan_signin_reward[classType][tonumber(day)].cumulateReward
	end
	return signRewadRead.ramadan_signin_reward[classType][tonumber(day)].cumulateReward
end
function signRewadRead.getEidaladhaSignCfg(classType)
	return signRewadRead.eidaladhasign_reward[classType]
end
function signRewadRead:getEidaladhaExtra(classType)
	if not signRewadRead.eidaladhasign_reward[classType][7].cumulateReward then
		signRewadRead = signRewadRead.eidaladhasign_reward[classType][7].cumulateReward
	end
	return signRewadRead.eidaladhasign_reward[classType][7].cumulateReward
end
function signRewadRead.getEidaladhaPrice(classType, day)
	return signRewadRead.eidaladhasign_reward[classType][tonumber(day)].gold
end
return signRewadRead
