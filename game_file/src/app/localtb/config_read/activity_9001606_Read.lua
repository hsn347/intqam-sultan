local activity_9001606_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "ruleshow"
;(nil)[2] = true
activity_9001606_Read:defineValue("ruleshow", nil)
activity_9001606_Read:defineValue("rules", function()
	local _ENV, rules
	for _, v in ipairs(activity_9001606_Read.ruleshow) do
		if not rules[v.type] then
			_ENV = rules[v.type]
		end
		rules[v.type] = rules[v.type]
		table.insert(rules[v.type], v)
	end
	return rules
end)
function _UPVALUE2_()
	local _ENV, rules
	for _, v in ipairs(activity_9001606_Read.ruleshow) do
		if not rules[v.type] then
			_ENV = rules[v.type]
		end
		rules[v.type] = rules[v.type]
		table.insert(rules[v.type], v)
	end
	return rules
end
;(function()
	local _ENV, rules
	for _, v in ipairs(activity_9001606_Read.ruleshow) do
		if not rules[v.type] then
			_ENV = rules[v.type]
		end
		rules[v.type] = rules[v.type]
		table.insert(rules[v.type], v)
	end
	return rules
end)[1] = "onceaward"
;(function()
	local _ENV, rules
	for _, v in ipairs(activity_9001606_Read.ruleshow) do
		if not rules[v.type] then
			_ENV = rules[v.type]
		end
		rules[v.type] = rules[v.type]
		table.insert(rules[v.type], v)
	end
	return rules
end)[2] = true
activity_9001606_Read:defineValue("onceaward", function()
	local _ENV, rules
	for _, v in ipairs(activity_9001606_Read.ruleshow) do
		if not rules[v.type] then
			_ENV = rules[v.type]
		end
		rules[v.type] = rules[v.type]
		table.insert(rules[v.type], v)
	end
	return rules
end)
function activity_9001606_Read.getRuleCfg()
	return activity_9001606_Read.rules
end
function activity_9001606_Read.getOnceRewards()
	local reward = activity_9001606_Read.onceaward[1].reward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(reward, nil)
end
return activity_9001606_Read
