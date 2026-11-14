local allianceDinnerRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "alliance_dinner"
;(nil)[2] = true
allianceDinnerRead:defineValue("alliance_dinner", nil)
_UPVALUE2_ = nil
;(nil)[1] = "alliance_dinner_rank"
;(nil)[2] = true
allianceDinnerRead:defineValue("alliance_dinner_rank", nil)
_UPVALUE1_ = nil
;(nil)[1] = "alliance_dinner_show"
allianceDinnerRead:defineValue("alliance_dinner_show", nil)
allianceDinnerRead:defineValue("dinner", function()
	allianceDinnerRead.dinner, allianceDinnerRead = nil, nil
	for k, v in ipairs(allianceDinnerRead.alliance_dinner) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.dishNeed = serviceFunctions.tableFormat(v.dishNeed, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.firstReward = serviceFunctions.tableFormat(v.firstReward, nil)
		if not allianceDinnerRead.dinner[v.classType] then
			allianceDinnerRead.dinner[v.classType], allianceDinnerRead = nil, nil
		end
		table.insert(allianceDinnerRead.dinner[v.classType], v)
	end
	return allianceDinnerRead.dinner
end)
allianceDinnerRead:defineValue("rank", function()
	allianceDinnerRead.rank, allianceDinnerRead = nil, nil
	for k, v in ipairs(allianceDinnerRead.alliance_dinner_rank) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not allianceDinnerRead.rank[v.classType] then
			allianceDinnerRead.rank[v.classType], allianceDinnerRead = nil, nil
		end
		table.insert(allianceDinnerRead.rank[v.classType], v)
	end
	return allianceDinnerRead.rank
end)
allianceDinnerRead:defineValue("show", function()
	allianceDinnerRead.show, allianceDinnerRead = nil, nil
	for k, v in ipairs(allianceDinnerRead.alliance_dinner_show) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		if not allianceDinnerRead.show[v.classType] then
			allianceDinnerRead.show[v.classType], allianceDinnerRead = nil, nil
		end
		table.insert(allianceDinnerRead.show[v.classType], v)
	end
	return allianceDinnerRead.show
end)
function allianceDinnerRead.getDinnerCfg(classType)
	return allianceDinnerRead.dinner[classType]
end
function allianceDinnerRead.getRankCfg(classType)
	return allianceDinnerRead.rank[classType]
end
function allianceDinnerRead.getDinnerShowCfg(classType)
	return allianceDinnerRead.show[classType]
end
return allianceDinnerRead
