local extremelySkillfulRead = include("aAReadClass").new()
function extremelySkillfulRead.init()
	_ENV = nil
	;(nil)[1] = "marvelousworkmanship"
	extremelySkillfulRead:defineValue("marvelousworkmanship", nil)
	extremelySkillfulRead:defineValue("marvelousworkmanshiplv", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshiplv")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)
	function _UPVALUE2_()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshiplv")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end
	;(function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshiplv")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)[1] = "marvelousworkmanshipquest"
	;(function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshiplv")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)[2] = true
	extremelySkillfulRead:defineValue("marvelousworkmanshipquest", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshiplv")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)
	extremelySkillfulRead:defineValue("marvelousworkmanshipffect", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshipffect")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				_ENV, _ENV, _ENV, _UPVALUE3_ = nil, nil, nil, nil
				ret[v.classType], (nil)[1] = nil, nil
				ret[v.classType], (nil)[2] = nil, nil
				ret[v.classType], (nil)[3] = nil, nil
			end
			_ENV = nil
			;(nil).CastleLv = v.CastleLv
			;(nil).PrivilegeEffect = v.PrivilegeEffect1
			;(nil).EffectIcon = v.EffectIcon1
			table.insert(ret[v.classType][1], nil)
			_ENV = nil
			;(nil).CastleLv = v.CastleLv
			;(nil).PrivilegeEffect = v.PrivilegeEffect2
			;(nil).EffectIcon = v.EffectIcon2
			table.insert(ret[v.classType][2], nil)
			_ENV = nil
			;(nil).CastleLv = v.CastleLv
			;(nil).PrivilegeEffect = v.PrivilegeEffect3
			;(nil).EffectIcon = v.EffectIcon3
			table.insert(ret[v.classType][3], nil)
		end
		return ret
	end)
	extremelySkillfulRead:defineValue("marvelousworkmanshiprecharge", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.marvelousworkmanshiprecharge")
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)
end
function extremelySkillfulRead.getBuffList(type, classType)
	return extremelySkillfulRead.marvelousworkmanshipffect[classType][type]
end
function extremelySkillfulRead.getBuffNums(classType)
	return table.nums(extremelySkillfulRead.marvelousworkmanshipffect[classType][1][1].PrivilegeEffect)
end
function extremelySkillfulRead.getAllAwardByIndex(classType)
	if not extremelySkillfulRead.marvelousworkmanship[classType] then
		extremelySkillfulRead, extremelySkillfulRead, extremelySkillfulRead = nil, nil, extremelySkillfulRead.marvelousworkmanship[classType]
		return extremelySkillfulRead.marvelousworkmanship[classType], nil, nil
	end
	local item = extremelySkillfulRead.marvelousworkmanship[classType]
	return item.AllReward1, item.AllReward2, item.AllReward3
end
function extremelySkillfulRead.getTaskListByIndex(classType)
	if not classType then
		_ENV = nil
		return nil
	end
	local _ENV, taskList
	for i, qeustGroup in ipairs(extremelySkillfulRead.marvelousworkmanshipquest) do
		if classType == qeustGroup.classType then
			local taskSet = qeustGroup.QuestId
			local fogShow = qeustGroup.FogShow
			for i, taskID in ipairs(taskSet) do
				if not (not (0 < fogShow) or SoraDGetCtrl("ExtremelySkillfulCtrl"):isTaskShow(fogShow)) then
					break
				end
				if not SoraDGetCtrl("ExtremelySkillfulCtrl"):isTaskClaimed(taskID) then
					table.insert(taskList, taskID)
					break
				elseif i == #taskSet then
					table.insert(taskList, taskID)
					break
				end
			end
		end
	end
	return taskList
end
function extremelySkillfulRead.getLvRewardList(index)
	if not index then
		extremelySkillfulRead = nil
		return nil
	end
	return extremelySkillfulRead.marvelousworkmanshiplv[index]
end
function extremelySkillfulRead.getUnlockItem(index)
	if not index then
		extremelySkillfulRead = nil
		return nil
	end
	return extremelySkillfulRead.marvelousworkmanship[index] and extremelySkillfulRead.marvelousworkmanship[index].UnlockItem
end
function extremelySkillfulRead.getNextExp(level, index)
	for _, info in ipairs(extremelySkillfulRead.marvelousworkmanshiplv[index]) do
		if info.Lv == level + 1 then
			return info.NeedExp
		end
	end
	return extremelySkillfulRead.marvelousworkmanshiplv[index][#extremelySkillfulRead.marvelousworkmanshiplv[index]].NeedExp
end
function extremelySkillfulRead.getMaxExpLv(index)
	local maxLv = 0
	for _, info in ipairs(extremelySkillfulRead.marvelousworkmanshiplv[index]) do
		if maxLv < info.Lv then
			maxLv = info.Lv
		end
	end
	return maxLv
end
function extremelySkillfulRead.getMaxEffectCastleLv(type, classType)
	type = type or 1
	classType = classType or SoraDGetCtrl("ExtremelySkillfulCtrl"):getGroupIndex()
	return extremelySkillfulRead.marvelousworkmanshipffect[classType][type][#extremelySkillfulRead.marvelousworkmanshipffect[classType][type]].CastleLv
end
function extremelySkillfulRead.getGiftAwardInfo(index, classType)
	if not extremelySkillfulRead.marvelousworkmanshiprecharge[classType][index] then
		extremelySkillfulRead = extremelySkillfulRead.marvelousworkmanshiprecharge[classType][index]
	end
	return extremelySkillfulRead.marvelousworkmanshiprecharge[classType][index]
end
function extremelySkillfulRead.getGiftAwardInfoByRid(rid, classType)
	for i, v in ipairs(extremelySkillfulRead.marvelousworkmanshiprecharge[classType]) do
		if v.RechargeID == rid then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(extremelySkillfulRead.marvelousworkmanshiprecharge[classType])
end
function extremelySkillfulRead.getGiftIdList(classType)
	local _ENV, ret
	for index, value in ipairs(extremelySkillfulRead.marvelousworkmanshiprecharge[classType]) do
		table.insert(ret, value.RechargeID)
	end
	return ret
end
function extremelySkillfulRead.getNowEffectInfo(type, lv)
	type = type or 1
	local classType = SoraDGetCtrl("ExtremelySkillfulCtrl"):getGroupIndex()
	for i, v in ipairs(extremelySkillfulRead.marvelousworkmanshipffect[classType][type]) do
		if not lv then
			if v.CastleLv[1] == 1 then
				lv = SoraDGetCastleLv()
			elseif v.CastleLv[1] == 2 then
				lv = SoraDGetBuildStarLv()
			end
		end
		if lv >= v.CastleLv[2] and lv <= v.CastleLv[3] then
			return v, true
		end
	end
	return extremelySkillfulRead.marvelousworkmanshipffect[classType][type][#extremelySkillfulRead.marvelousworkmanshipffect[classType][type]], false
end
extremelySkillfulRead.init()
return extremelySkillfulRead
