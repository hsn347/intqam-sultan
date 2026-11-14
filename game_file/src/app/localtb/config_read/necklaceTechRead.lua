local necklaceTechRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "necklace_technology"
;(nil)[2] = true
necklaceTechRead:defineValue("technology", nil)
necklaceTechRead:defineValue("necklace_technology", function()
	local _ENV, ret
	for k, v in ipairs(necklaceTechRead.technology) do
		if not ret[v.technologyID] then
			ret[v.technologyID], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.costItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "tid"
		;(nil)[2] = "level"
		local technologyPre = serviceFunctions.tableFormat(v.technologyPre, nil)
		local _ENV, preTechID = v.technologyPre, v.technologyPre
		for _, m in ipairs(technologyPre) do
			if m.tid > 0 and m.level > 0 then
				table.insert(preTechID, m.tid)
			end
		end
		v.preTechID = preTechID
		v.technologyPre = technologyPre
		v.maxLv = math.max(v.maxLv or 1, v.lv)
		ret[v.technologyID][v.lv] = v
	end
	return ret
end)
function necklaceTechRead.getTechConfig(technologyID, lv)
	return necklaceTechRead.necklace_technology[tonumber(technologyID)][lv]
end
function necklaceTechRead.getTechAttribute(technologyID, lv)
	local cfg = necklaceTechRead.getTechConfig(technologyID, lv)
	return cfg.attribute
end
function necklaceTechRead.getTechFighting(technologyID, lv)
	local cfg = necklaceTechRead.getTechConfig(technologyID, lv)
	return cfg.fighting
end
function necklaceTechRead.getTechCondition(technologyID, lv)
	local cfg = necklaceTechRead.getTechConfig(technologyID, lv)
	return cfg.costItem
end
function necklaceTechRead.getTechPre(technologyID, lv)
	local cfg = necklaceTechRead.getTechConfig(technologyID, lv)
	return cfg.technologyPre
end
function necklaceTechRead.getTechMaxLv(technologyID)
	local cfg = necklaceTechRead.necklace_technology[tonumber(technologyID)]
	return cfg[#cfg].maxLv
end
function necklaceTechRead.getTechGroupCfg(technologyID)
	return necklaceTechRead.necklace_technology[tonumber(technologyID)]
end
function necklaceTechRead.getInitTechID()
	return necklaceTechRead.technology[1].technologyID
end
function necklaceTechRead.getItemID()
	return necklaceTechRead.technology[1].promoteItem[1]
end
function _UPVALUE1_()
	local _ENV, ret
	for k, v in ipairs(necklaceTechRead.technology) do
		if not ret[v.technologyID] then
			ret[v.technologyID], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.costItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "tid"
		;(nil)[2] = "level"
		local technologyPre = serviceFunctions.tableFormat(v.technologyPre, nil)
		local _ENV, preTechID = v.technologyPre, v.technologyPre
		for _, m in ipairs(technologyPre) do
			if m.tid > 0 and m.level > 0 then
				table.insert(preTechID, m.tid)
			end
		end
		v.preTechID = preTechID
		v.technologyPre = technologyPre
		v.maxLv = math.max(v.maxLv or 1, v.lv)
		ret[v.technologyID][v.lv] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for k, v in ipairs(necklaceTechRead.technology) do
		if not ret[v.technologyID] then
			ret[v.technologyID], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.costItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "tid"
		;(nil)[2] = "level"
		local technologyPre = serviceFunctions.tableFormat(v.technologyPre, nil)
		local _ENV, preTechID = v.technologyPre, v.technologyPre
		for _, m in ipairs(technologyPre) do
			if m.tid > 0 and m.level > 0 then
				table.insert(preTechID, m.tid)
			end
		end
		v.preTechID = preTechID
		v.technologyPre = technologyPre
		v.maxLv = math.max(v.maxLv or 1, v.lv)
		ret[v.technologyID][v.lv] = v
	end
	return ret
end)[1] = "necklace_technology_des"
necklaceTechRead:defineValue("necklace_technology_des", function()
	local _ENV, ret
	for k, v in ipairs(necklaceTechRead.technology) do
		if not ret[v.technologyID] then
			ret[v.technologyID], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.costItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "tid"
		;(nil)[2] = "level"
		local technologyPre = serviceFunctions.tableFormat(v.technologyPre, nil)
		local _ENV, preTechID = v.technologyPre, v.technologyPre
		for _, m in ipairs(technologyPre) do
			if m.tid > 0 and m.level > 0 then
				table.insert(preTechID, m.tid)
			end
		end
		v.preTechID = preTechID
		v.technologyPre = technologyPre
		v.maxLv = math.max(v.maxLv or 1, v.lv)
		ret[v.technologyID][v.lv] = v
	end
	return ret
end)
necklaceTechRead:defineValue("necklace_technology_desCfg", function()
	local _ENV, ret
	for _, v in ipairs(necklaceTechRead.necklace_technology_des) do
		ret[v.technologyID] = v
	end
	return ret
end)
function necklaceTechRead.getTechTree()
	return necklaceTechRead.necklace_technology_des
end
function necklaceTechRead.getTechShowCfg(technologyID)
	return necklaceTechRead.necklace_technology_desCfg[tonumber(technologyID)]
end
function necklaceTechRead.getName(technologyID)
	local cfg = necklaceTechRead.getTechShowCfg(technologyID)
	return cfg and i18n(cfg.techName)
end
function necklaceTechRead.getTechCfg(technologyID)
	return necklaceTechRead.necklace_technology_desCfg[technologyID]
end
return necklaceTechRead
