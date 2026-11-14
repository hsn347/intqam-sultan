local nebulaMileStoneRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebula_milestone_config"
;(nil)[2] = true
nebulaMileStoneRead:defineValue("config", nil)
_UPVALUE1_ = nil
;(nil)[1] = "nebula_milestone_des"
nebulaMileStoneRead:defineValue("des", nil)
_UPVALUE1_ = nil
;(nil)[1] = "nebula_function_des"
nebulaMileStoneRead:defineValue("funcDes", nil)
_UPVALUE1_ = nil
;(nil)[1] = "nebula_function_chapter"
nebulaMileStoneRead:defineValue("chapters", nil)
nebulaMileStoneRead:defineValue("funcDesCfg", function()
	local _ENV, ret
	for k, v in pairs(nebulaMileStoneRead.funcDes) do
		if not ret[v.type] then
			_ENV = ret[v.type]
		end
		ret[v.type] = ret[v.type]
		table.insert(ret[v.type], v)
	end
	return ret
end)
nebulaMileStoneRead:defineValue("mileStoneCfg", function()
	local _ENV, ret
	for k, v in pairs(nebulaMileStoneRead.config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "unlockType"
		;(nil)[2] = "value"
		v.unlockFunction = serviceFunctions.tableFormat(v.unlockFunction, nil)
		if not ret[v.type] then
			_ENV = ret[v.type]
		end
		ret[v.type] = ret[v.type]
		if not ret[v.type][v.season] then
			_ENV = ret[v.type][v.season]
		end
		ret[v.type][v.season] = ret[v.type][v.season]
		if not ret[v.type][v.season][v.round] then
			_ENV = ret[v.type][v.season][v.round]
		end
		ret[v.type][v.season][v.round] = ret[v.type][v.season][v.round]
		table.insert(ret[v.type][v.season][v.round], v)
	end
	return ret
end)
function nebulaMileStoneRead.getName(milestoneID)
	local heroltCtrl = include("heroltCtrl")
	local desCfg = nebulaMileStoneRead.des[milestoneID]
	return desCfg and heroltCtrl:getTacticsDesc(desCfg.milestoneName) or ""
end
function nebulaMileStoneRead.getDes(milestoneID)
	local heroltCtrl = include("heroltCtrl")
	local desCfg = nebulaMileStoneRead.des[milestoneID]
	return desCfg and heroltCtrl:getTacticsDesc(desCfg.milestoneDes) or ""
end
function nebulaMileStoneRead.getFuncDes(milestoneID)
	local config = nebulaMileStoneRead.des[milestoneID]
	local heroltCtrl = include("heroltCtrl")
	return heroltCtrl:getTacticsDesc(config.milestoneunlock) or ""
end
function nebulaMileStoneRead.getBanner(milestoneID)
	return nebulaMileStoneRead.des[milestoneID].milestoneBanner
end
function nebulaMileStoneRead.getConfigs(round)
	local season = 1
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local mileStoneCfg = nebulaMileStoneRead.mileStoneCfg[group]
	local cfgs = mileStoneCfg[season] and mileStoneCfg[season][round]
	table.sort(cfgs, function(a, b)
		return a.prevID < b.prevID
	end)
	return cfgs
end
function nebulaMileStoneRead.getConfigByUnlockType(unlockType, value)
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local mileStoneCfg = nebulaMileStoneRead.mileStoneCfg
	for k, v in pairs(nebulaMileStoneRead.config) do
		if group == nil or group ~= nil and v.type == group then
			for k2, v2 in pairs(v.unlockFunction) do
				if v2.unlockType == unlockType and (value == nil or value ~= nil and value <= v2.value) then
					return v
				end
			end
		end
	end
	return nil
end
function nebulaMileStoneRead.getDefaultConfigs()
	local season = 0
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local mileStoneCfg = nebulaMileStoneRead.mileStoneCfg[group]
	for k, v in pairs(mileStoneCfg) do
		if k > season then
			season = k
		end
	end
	return mileStoneCfg[season]
end
function nebulaMileStoneRead.getFuncDeses()
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local funcDesCfg = nebulaMileStoneRead.funcDesCfg[group]
	return funcDesCfg
end
function nebulaMileStoneRead.getChapters()
	return nebulaMileStoneRead.chapters
end
return nebulaMileStoneRead
