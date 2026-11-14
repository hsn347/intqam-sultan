local lordSkillDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	if IsArClient then
		_ENV = nil
		;(nil)[1] = "lordskilldes"
		lordSkillDesRead:defineValue("tableDesData", nil)
		_ENV = nil
		;(nil)[1] = "skilltree"
		lordSkillDesRead:defineValue("tableSkillTree", nil)
	else
		_ENV = nil
		;(nil)[1] = "lordskilldes"
		lordSkillDesRead:defineValue("tableDesData", nil)
		_ENV = nil
		;(nil)[1] = "skilltree"
		lordSkillDesRead:defineValue("tableSkillTree", nil)
	end
end
init()
function lordSkillDesRead.getName(sid)
	sid = tonumber(sid)
	return i18n(lordSkillDesRead.tableDesData[sid].name)
end
function lordSkillDesRead.getDes(sid)
	sid = tonumber(sid)
	if lordSkillDesRead.tableDesData[sid] == nil then
		return ""
	end
	if sid == lordSkillIDDefine.siegeLore or sid == lordSkillIDDefine.killBarrier then
		local lordSkillModuleAPI = include("lordSkillModuleAPI")
		local curSkillDetail = lordSkillModuleAPI:getSkillDetail(tonumber(lordSkillModuleAPI:getActiveSetID()) or 1, sid)
		curSkillDetail.currentLevel = math.max(curSkillDetail.currentLevel or 1, 1)
		local buffValue = lordSkillModuleAPI:getBuffInfoText(tonumber(lordSkillModuleAPI:getActiveSetID()), sid, curSkillDetail.currentLevel)
		return lordSkillDesRead.getHaveNumDes(sid, buffValue / 10)
	end
	return i18n(lordSkillDesRead.tableDesData[sid].des)
end
function lordSkillDesRead.getHaveNumDes(sid, percent)
	sid = tonumber(sid)
	_ENV = nil
	;(nil).num = percent
	return i18n(lordSkillDesRead.tableDesData[sid].des, nil)
end
function lordSkillDesRead.getIcon(sid, fromMemory)
	sid = tonumber(sid)
	if fromMemory then
		return "#" .. lordSkillDesRead.tableDesData[sid].icon
	end
	return lordSkillDesRead.tableDesData[sid].icon
end
function lordSkillDesRead.getTree(type)
	local _ENV, tree
	if type == LORD_ATTR.Auxiliary then
		tree = lordSkillDesRead.tableSkillTree.assist.id
	elseif type == LORD_ATTR.Develop then
		tree = lordSkillDesRead.tableSkillTree.develop.id
	elseif type == LORD_ATTR.Battle then
		tree = lordSkillDesRead.tableSkillTree.battle.id
	end
	return tree
end
function lordSkillDesRead.getBuffID(sid)
	_ENV, sid = tonumber(sid), tonumber(sid)
	tonumber(sid)[11028] = 4501
	tonumber(sid)[11029] = 4506
	tonumber(sid)[12022] = 4507
	tonumber(sid)[12023] = 4504
	tonumber(sid)[13022] = 4505
	tonumber(sid)[11042] = 5128
	tonumber(sid)[12031] = 5129
	tonumber(sid)[13032] = 5130
	tonumber(sid)[13040] = 5425
	tonumber(sid)[11056] = 5436
	local tonumber(sid)[11057], tableSkillBuffID = 5446, tonumber(sid)
	return tableSkillBuffID[sid]
end
function lordSkillDesRead.getQueueType(sid)
	_ENV, sid = tonumber(sid), tonumber(sid)
	tonumber(sid)[11011] = gQueueTypeDef.skill_immediatelt_return
	tonumber(sid)[11028] = gQueueTypeDef.skill_help
	tonumber(sid)[12008] = gQueueTypeDef.skill_bumper
	tonumber(sid)[13020] = gQueueTypeDef.skill_dap
	tonumber(sid)[11029] = gQueueTypeDef.general_mibilization
	tonumber(sid)[12022] = gQueueTypeDef.crazy_gather
	tonumber(sid)[12023] = gQueueTypeDef.gather_protect
	tonumber(sid)[13022] = gQueueTypeDef.rapid_march
	tonumber(sid)[13021] = gQueueTypeDef.physical_abundant
	tonumber(sid)[11042] = gQueueTypeDef.skill_mass_num
	tonumber(sid)[12031] = gQueueTypeDef.skill_resource_up
	local tonumber(sid)[13032], tableSkillQueueType = gQueueTypeDef.skill_sneak_into, tonumber(sid)
	return tableSkillQueueType[sid]
end
return lordSkillDesRead
