local goldSoukRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "gold_souk_shop"
	;(nil)[2] = true
	goldSoukRead:defineValue("shop", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "gold_souk_cumulative_reward"
	;(nil)[2] = true
	goldSoukRead:defineValue("reward", nil)
end
init()
function goldSoukRead.getShopCfg(lv, classtype)
	local _ENV, cfg
	for k, v in ipairs(goldSoukRead.shop) do
		if lv >= v.Lv[1] and lv <= v.Lv[2] and v.classType == classtype then
			table.insert(cfg, v)
		end
	end
	return cfg
end
function goldSoukRead.getRewardCfg()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.GOLD_SOUK_ACTIVITY)
	local classtype = param.classtype or 1
	local _ENV, reward = gActivityTimeActivityID.GOLD_SOUK_ACTIVITY, gActivityTimeActivityID.GOLD_SOUK_ACTIVITY
	for k, v in ipairs(goldSoukRead.reward) do
		if v.classType == classtype then
			table.insert(reward, v)
		end
	end
	return reward
end
return goldSoukRead
