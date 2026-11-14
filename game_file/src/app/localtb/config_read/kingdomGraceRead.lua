local kingdomGraceRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "grace_exchange_config"
	;(nil)[2] = true
	kingdomGraceRead:defineValue("exchangeConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "grace_score_config"
	;(nil)[2] = true
	kingdomGraceRead:defineValue("scroeConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "grace_sunshine_reward"
	;(nil)[2] = true
	kingdomGraceRead:defineValue("sunshineConfig", nil)
end
init()
function kingdomGraceRead.getExchangeConfig(group, propertyName)
	for i, v in ipairs(kingdomGraceRead.exchangeConfig) do
		if v.group == group then
			return v[propertyName] or 0
		end
	end
	return 0
end
function kingdomGraceRead.getScoreConfig()
	return kingdomGraceRead.scroeConfig
end
function kingdomGraceRead.getSunshineConfig(group, propertyName)
	for i, v in ipairs(kingdomGraceRead.sunshineConfig) do
		if v.group == group then
			return v[propertyName]
		end
	end
end
return kingdomGraceRead
