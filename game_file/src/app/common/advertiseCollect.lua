advertiseCollect, _ENV = nil, nil
local gSDKDef = _G.gSDKDef
_ENV = nil
_ENV = nil
;(nil).func = "CheckTriggerAutoIncrease"
;(nil).Max = 100
;(nil)[gSDKDef.TDonEvent.advertise_coin_btn], (nil).step = nil, 5
_ENV = nil
;(nil).func = "CheckTriggerAutoIncrease"
;(nil).Max = 100
;(nil)[gSDKDef.TDonEvent.advertise_lucky_gift], (nil).step = nil, 5
_ENV = nil
;(nil).func = "CheckTriggerNum"
;(nil)[gSDKDef.TDonEvent.advertise_trigger_pay], (nil).Max = nil, 10
_ENV = nil
;(nil).func = "CheckTriggerNum"
;(nil)[gSDKDef.TDonEvent.advertise_cancel_pay], (nil).Max = nil, 10
_ENV = nil
;(nil).func = "CheckTriggerAutoIncrease"
;(nil).Max = 200
;(nil)[gSDKDef.TDonEvent.advertise_recharge_btn], (nil).step = nil, 10
_ENV = nil
;(nil).func = "CheckTriggerAutoIncrease"
;(nil).Max = 100
;(nil)[gSDKDef.TDonEvent.advertise_switch_gift], (nil).step = nil, 5
_ENV = nil
;(nil).func = "CheckTriggerIncrease"
;(nil).Max = 1500000
;(nil)[gSDKDef.TDonEvent.advertise_fight_point], (nil).step = nil, 100000
_ENV = nil
;(nil).func = "CheckTriggerValue"
;(nil)[gSDKDef.TDonEvent.advertise_castle_level], (nil).Max = nil, 25
local CheckCheckFunc
local COMMON_CACHE_KEY = "System:AdvertiseCollect:TriggerNum%d~integer"
local COMMON_COLLECT_KEY = "System:AdvertiseCollect:CollectNum%d~integer"
function advertiseCollect.TriggerEvent(event, eventArgs)
	print("advertiseCollect.TriggerEvent", event, tostring(eventArgs))
	local eventCfg = CheckCheckFunc[event]
	if eventCfg and advertiseCollect[eventCfg.func] then
		advertiseCollect[eventCfg.func](event, eventArgs)
	end
end
function advertiseCollect.CheckTriggerIncrease(event, eventArgs, isAutoIncrease)
	isAutoIncrease = isAutoIncrease or false
	local Key = string.format(COMMON_CACHE_KEY, event)
	_ENV = nil
	;(nil).byUID = true
	local lastTriggerNum = SoraDConfigGet(Key, nil) or 0
	local checkCfg = CheckCheckFunc[event]
	local checkMax = true
	if lastTriggerNum >= checkCfg.Max then
		checkMax = false
	end
	print("CheckTriggerIncrease", lastTriggerNum)
	if checkMax and (lastTriggerNum == 0 and isAutoIncrease and eventArgs == 1 or eventArgs >= lastTriggerNum + checkCfg.step) then
		_ENV = lastTriggerNum
		lastTriggerNum.target = eventArgs
		userSDKManager.logEventForNewAccount(event, lastTriggerNum)
		if not isAutoIncrease and eventArgs < checkCfg.Max then
			lastTriggerNum = math.floor(eventArgs / checkCfg.step) * checkCfg.step
		elseif 2 <= eventArgs then
			lastTriggerNum = eventArgs
		end
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet(Key, lastTriggerNum, nil)
	end
end
function advertiseCollect.CheckTriggerAutoIncrease(event, eventArgs)
	local Key = string.format(COMMON_COLLECT_KEY, event)
	_ENV = nil
	;(nil).byUID = true
	local collectNum = SoraDConfigGet(Key, nil) or 0
	collectNum = collectNum + 1
	advertiseCollect.CheckTriggerIncrease(event, collectNum, true)
	_ENV = true
	;(true).byUID = true
	SoraDConfigSet(Key, collectNum, true)
end
function advertiseCollect.CheckTriggerNum(event)
	local Key = string.format(COMMON_CACHE_KEY, event)
	_ENV = nil
	;(nil).byUID = true
	local cacheNum = SoraDConfigGet(Key, nil) or 0
	advertiseCollect.CheckTriggerValue(event, cacheNum + 1)
end
function advertiseCollect.CheckTriggerValue(event, eventArgs)
	local Key = string.format(COMMON_CACHE_KEY, event)
	_ENV = nil
	;(nil).byUID = true
	local cacheNum = SoraDConfigGet(Key, nil) or 0
	local checkCfg = CheckCheckFunc[event]
	if eventArgs > cacheNum and eventArgs <= checkCfg.Max then
		_ENV = nil
		;(nil).target = eventArgs
		userSDKManager.logEventForNewAccount(event, nil)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet(Key, eventArgs, nil)
	end
end
function advertiseCollect.cleanAllCache()
	for k, v in pairs(CheckCheckFunc) do
		local key = string.format(COMMON_CACHE_KEY, k)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet(key, 0, nil)
		if v.func == "CheckTriggerAutoIncrease" then
			_ENV = k
			k.byUID = true
			SoraDConfigSet(string.format(COMMON_COLLECT_KEY, k), 0, k)
		end
	end
end
function advertiseCollect.printAllCache()
	for k, v in pairs(CheckCheckFunc) do
		local key = string.format(COMMON_CACHE_KEY, k)
		_ENV = nil
		;(nil).byUID = true
		local tv = SoraDConfigGet(key, nil) or 0
		print("TriggerNum:", k, tv)
		if v.func == "CheckTriggerAutoIncrease" then
			_ENV = COMMON_COLLECT_KEY
			COMMON_COLLECT_KEY.byUID = true
			local cv = SoraDConfigGet(string.format(COMMON_COLLECT_KEY, k), COMMON_COLLECT_KEY) or 0
			print("CollectNum:", k, cv)
		end
	end
end
return advertiseCollect
