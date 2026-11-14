local starTreasuryRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "startreasuryquest"
;(nil)[2] = true
starTreasuryRead:defineValue("quest", nil)
_UPVALUE2_ = nil
;(nil)[1] = "startreasurybox"
;(nil)[2] = true
starTreasuryRead:defineValue("box", nil)
starTreasuryRead:defineValue("questCfgs", function()
	starTreasuryRead.questCfgs, starTreasuryRead = nil, nil
	for k, v in ipairs(starTreasuryRead.quest) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "count"
		v.boxType = serviceFunctions.tableFormat(v.boxType, nil)
		if not starTreasuryRead.questCfgs[v.type] then
			starTreasuryRead.questCfgs[v.type], starTreasuryRead = nil, nil
		end
		table.insert(starTreasuryRead.questCfgs[v.type], v)
	end
	return starTreasuryRead.questCfgs
end)
starTreasuryRead:defineValue("boxCfgs", function()
	starTreasuryRead.boxCfgs, starTreasuryRead = nil, nil
	for k, v in ipairs(starTreasuryRead.box) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.totalReward = serviceFunctions.tableFormat(v.totalReward, nil)
		if not starTreasuryRead.boxCfgs[v.classify] then
			starTreasuryRead.boxCfgs[v.classify], starTreasuryRead = nil, nil
		end
		table.insert(starTreasuryRead.boxCfgs[v.classify], v)
	end
	return starTreasuryRead.boxCfgs
end)
function starTreasuryRead.getQuestList(stype)
	if not starTreasuryRead.questCfgs[stype] then
		starTreasuryRead = starTreasuryRead.questCfgs[stype]
	end
	return starTreasuryRead.questCfgs[stype]
end
function starTreasuryRead.getBoxList(stype)
	if not starTreasuryRead.boxCfgs[stype] then
		starTreasuryRead = starTreasuryRead.boxCfgs[stype]
	end
	return starTreasuryRead.boxCfgs[stype]
end
function starTreasuryRead.getBoxCfgByRid(rid)
	for i, v in ipairs(starTreasuryRead.box) do
		if rid == v.recharge then
			return v
		end
	end
end
function starTreasuryRead.getBoxCfgByType(boxType, stype)
	if not starTreasuryRead.boxCfgs[stype] then
		local starTreasuryRead, boxList = starTreasuryRead.boxCfgs[stype], starTreasuryRead.boxCfgs[stype]
	end
	for k, v in pairs(boxList) do
		if v.type == boxType then
			return v
		end
	end
end
return starTreasuryRead
