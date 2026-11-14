local wishingMeteorRead = include("aAReadClass").new()
function wishingMeteorRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "wishing_meteor"
	;(nil)[2] = true
	wishingMeteorRead:defineValue("rewardConfig", nil)
end
function wishingMeteorRead.getAwardConfig()
	return wishingMeteorRead.rewardConfig
end
function wishingMeteorRead.getCountById(index, id)
	local awardConfig = wishingMeteorRead.rewardConfig[index].reward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	awardConfig = serviceFunctions.tableFormat(awardConfig, nil)
	for i, v in ipairs(awardConfig) do
		if v.id == id then
			return v.count
		end
	end
	return 0
end
wishingMeteorRead.init()
return wishingMeteorRead
