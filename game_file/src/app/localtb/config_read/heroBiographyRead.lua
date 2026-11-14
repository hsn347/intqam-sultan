local heroBiographyRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "hero_biography"
	;(nil)[2] = true
	heroBiographyRead:defineValue("biography", nil)
	_ENV = nil
	;(nil)[1] = "hero_biography_skill"
	;(nil)[2] = true
	heroBiographyRead:defineValue("skill", nil)
	heroBiographyRead = nil
	;(nil)[1] = "hero_mission_config"
	heroBiographyRead:defineValue("taskDescribe", nil)
	heroBiographyRead:defineValue("config", function()
		heroBiographyRead.config, heroBiographyRead = nil, nil
		local config = require_once("app." .. LocalTblPath .. ".config_client.hero_biography_config")
		for k, v in pairs(config) do
			heroBiographyRead.config[v.GroupID] = v
		end
		return heroBiographyRead.config
	end)
	heroBiographyRead:defineValue("skillConfig", function()
		heroBiographyRead.skillConfig, heroBiographyRead = nil, nil
		local skillConfig = require_once("app." .. LocalTblPath .. ".config_client.hero_biography_skill_config")
		for k, v in pairs(skillConfig) do
			heroBiographyRead.skillConfig[v.skillID] = v
		end
		return heroBiographyRead.skillConfig
	end)
	heroBiographyRead:defineValue("skillRef", function()
		heroBiographyRead.skillRef, heroBiographyRead = nil, nil
		for k, v in pairs(heroBiographyRead.skill) do
			heroBiographyRead.skillRef[v.skillID] = v
		end
		return heroBiographyRead.skillRef
	end)
	local createData = function(name)
		heroBiographyRead.heroUnLockAward, heroBiographyRead, heroBiographyRead.task, heroBiographyRead = nil, nil, nil, nil
		local taskConfig = require_once("app." .. LocalTblPath .. ".config_server.hero_mission")
		for i, v in ipairs(taskConfig) do
			if not heroBiographyRead.task[v.heroID] then
				heroBiographyRead.task[v.heroID], heroBiographyRead = nil, nil
			end
			if v.type ~= 1 then
				heroBiographyRead = v.type
				v.type.des = heroBiographyRead.getTaskDescribe(v.ID)
				v.type.missionID = v.missionID
				v.type.type = v.type
				v.type.quality = v.quality
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				local v.type.reward, info = serviceFunctions.tableFormat(v.reward, nil), v.type
				table.insert(heroBiographyRead.task[v.heroID], info)
			else
				heroBiographyRead = heroBiographyRead.task[v.heroID]
				_UPVALUE2_ = "count"
				;("count")[1] = "id"
				;("count")[2] = "count"
				heroBiographyRead.task[v.heroID].reward = serviceFunctions.tableFormat(v.reward, "count")
				heroBiographyRead.heroUnLockAward[v.heroID], heroBiographyRead.task[v.heroID].taskID = heroBiographyRead.task[v.heroID], v.missionID
			end
		end
		if name == "task" then
			return heroBiographyRead.task
		elseif name == "heroUnLockAward" then
			return heroBiographyRead.heroUnLockAward
		end
	end
	heroBiographyRead:defineValue("task", createData)
	heroBiographyRead:defineValue("heroUnLockAward", createData)
	heroBiographyRead:defineValue("heroBiographyIndexList", function()
		heroBiographyRead.heroBiographyIndexList, heroBiographyRead = nil, nil
		local biography = heroBiographyRead.getRealBiofraphy()
		for i, v in pairs(biography) do
			if next(v.heroGroupID) then
				for _, heroID in ipairs(v.heroGroupID) do
					if not heroBiographyRead.heroBiographyIndexList[heroID] then
						heroBiographyRead.heroBiographyIndexList[heroID], heroBiographyRead = nil, nil
					end
					heroBiographyRead = nil
					;(nil).id = v.ID
					;(nil).groupID = v.GroupID
					table.insert(heroBiographyRead.heroBiographyIndexList[heroID], nil)
				end
			end
		end
		return heroBiographyRead.heroBiographyIndexList
	end)
end
function heroBiographyRead.getSkills()
	return heroBiographyRead.skill
end
function heroBiographyRead.getHeroUnlockTaskConfig(heroID)
	if not heroBiographyRead.heroUnLockAward[heroID] then
		heroBiographyRead = heroBiographyRead.heroUnLockAward[heroID]
	end
	return heroBiographyRead.heroUnLockAward[heroID]
end
function heroBiographyRead.getHeroUnlockTaskID(heroID)
	local cfg = heroBiographyRead.getHeroUnlockTaskConfig(heroID)
	return cfg and cfg.taskID
end
function heroBiographyRead.getHeroUnlockTaskAward(heroID)
	local cfg = heroBiographyRead.getHeroUnlockTaskConfig(heroID)
	return cfg and cfg.reward
end
function heroBiographyRead.getTaskDescribe(ID)
	return heroBiographyRead.taskDescribe[ID].des
end
function heroBiographyRead.getHeroBiographyList(heroID)
	return heroBiographyRead.heroBiographyIndexList[heroID]
end
function heroBiographyRead.getRealBiofraphy()
	local _ENV, ret
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	for k, v in ipairs(heroBiographyRead.biography) do
		local isAllShow = true
		for _, heroID in ipairs(v.heroGroupID) do
			if not heroltCtrl:isHeroUnLock(heroID) then
				isAllShow = false
			end
		end
		if isAllShow then
			table.insert(ret, v)
		end
	end
	return ret
end
function heroBiographyRead.getStoryTb()
	return heroBiographyRead.getRealBiofraphy()
end
function heroBiographyRead.getStoryNum()
	return #heroBiographyRead.getRealBiofraphy()
end
function heroBiographyRead.getBiographyNum()
	return table.nums(heroBiographyRead.biography)
end
function heroBiographyRead.getStoryIndexList()
	local heroBiographyRead, list
	local biography = heroBiographyRead.getRealBiofraphy()
	for k, v in ipairs(biography) do
		table.insert(list, v.GroupID)
	end
	table.sort(list, function(a, b)
		return a < b
	end)
	return list
end
function heroBiographyRead.getHeroListByStoryIndex(index)
	local biography = heroBiographyRead.getRealBiofraphy()
	for k, v in ipairs(biography) do
		if v.GroupID == index then
			return v.heroGroupID
		end
	end
	heroBiographyRead = (for generator)
	return ipairs(biography)
end
function heroBiographyRead.getStoryName(index)
	local lang = SoraDGetDefaultLanguage()
	lang = lang == "ar" and "ar" or "en"
	return string.format("%s_%s.png", heroBiographyRead.config[index].groupName, lang)
end
function heroBiographyRead.getBiographyName(index)
	return heroBiographyRead.config[index].groupName
end
function heroBiographyRead.getStoryDes(index)
	return i18n(heroBiographyRead.config[index].groupStory)
end
function heroBiographyRead.getLvArray(index)
	local lv1, lv2 = 0, 0
	for k, v in ipairs(heroBiographyRead.skill) do
		if v.GroupID == index and v.type == 2 then
			if 0 < v.missionNum and lv1 == 0 then
				lv1 = v.missionNum
			end
			if lv1 < v.missionNum and lv2 == 0 then
				lv2 = v.missionNum
			end
		end
	end
	return lv1, lv2
end
function heroBiographyRead.getStorySkillArray(index, stage, missionNum)
	local _ENV, retArray
	local stage = stage or 1
	local missionNum = missionNum or 0
	for k, v in pairs(heroBiographyRead.skill) do
		if v.GroupID == index and stage == v.type and missionNum == v.missionNum then
			local _ENV, numArray = v.missionNum, v.missionNum
			for i, val in ipairs(v.buffNum) do
				if v.buffMode[i] == 1 then
					val = val / 10 .. "%"
				elseif v.buffMode[i] == 5 then
					val = val / 1000
				end
				numArray["num" .. i] = val
				numArray["var" .. i] = val
				if i == 1 then
					numArray.num = val
					numArray.var = val
				end
			end
			_ENV = ipairs(v.buffNum)
			ipairs(v.buffNum).skillID = v.skillID
			ipairs(v.buffNum).des = i18n(heroBiographyRead.skillConfig[v.skillID].des, numArray)
			table.insert(retArray, ipairs(v.buffNum))
		end
	end
	table.sort(retArray, function(a, b)
		return a.skillID < b.skillID
	end)
	return retArray
end
function heroBiographyRead.getStorySkillShowArray(index, isMaxView)
	local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
	local retStatus = heroBiographyCtrl:getHeroStoryStatus(index)
	if isMaxView then
		retStatus = gHeroStoryUnLockType.ACTIVED
	end
	local _ENV, retArray = gHeroStoryUnLockType, gHeroStoryUnLockType
	for k, v in ipairs(heroBiographyRead.skill) do
		local _ENV, numArray
		local _ENV, paramArray
		for i, val in ipairs(v.buffNum) do
			local pval = 0
			local rval = 0
			if v.buffMode[i] == 1 then
				pval = -val
				rval = val / 10 .. "%"
			elseif v.buffMode[i] == 5 then
				pval = val / 1000
				rval = val / 1000
			else
				pval = val
				rval = val
			end
			numArray["num" .. i] = rval
			paramArray["num" .. i] = pval
			numArray["var" .. i] = rval
			paramArray["var" .. i] = pval
			if i == 1 then
				numArray.num = rval
				paramArray.num = pval
				numArray.var = rval
				paramArray.var = pval
			end
		end
		if v.GroupID == index and 1 == v.type then
			_ENV = ipairs(v.buffNum)
			ipairs(v.buffNum).skillID = v.skillID
			ipairs(v.buffNum).des = i18n(heroBiographyRead.skillConfig[v.skillID].des, numArray)
			ipairs(v.buffNum).tip = heroBiographyRead.skillConfig[v.skillID].des
			ipairs(v.buffNum).param = paramArray
			table.insert(retArray, ipairs(v.buffNum))
		end
		local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		if v.GroupID == index and 2 == v.type and retStatus == gHeroStoryUnLockType.ACTIVED then
			local ret = true
			for _, heroID in ipairs(heroList) do
				local info = heroCtrl:getHeroInfoByID(heroID)
				if info and info.level < v.missionNum or not info then
					ret = false
					break
				end
			end
			if ret or isMaxView then
				_ENV = ipairs(heroList)
				ipairs(heroList).skillID = v.skillID
				ipairs(heroList).des = i18n(heroBiographyRead.skillConfig[v.skillID].des, numArray)
				ipairs(heroList).tip = heroBiographyRead.skillConfig[v.skillID].des
				ipairs(heroList).param = paramArray
				table.insert(retArray, ipairs(heroList))
			end
		end
		if v.GroupID == index and 4 == v.type and retStatus == gHeroStoryUnLockType.ACTIVED then
			local ret = true
			for _, heroID in ipairs(heroList) do
				local info = heroCtrl:getHeroInfoByID(heroID)
				if not (not info or info.isAwake) or not info then
					ret = false
					break
				end
			end
			if ret or isMaxView then
				_ENV = ipairs(heroList)
				ipairs(heroList).skillID = v.skillID
				ipairs(heroList).des = i18n(heroBiographyRead.skillConfig[v.skillID].des, numArray)
				ipairs(heroList).tip = heroBiographyRead.skillConfig[v.skillID].des
				ipairs(heroList).param = paramArray
				table.insert(retArray, ipairs(heroList))
			end
		end
	end
	table.sort(retArray, function(a, b)
		return a.skillID < b.skillID
	end)
	local _ENV, tipArray = table.sort, table.sort
	for k, v in ipairs(retArray) do
		if not tipArray[v.tip] then
			tipArray[v.tip], _ENV = heroBiographyRead.getHeroListByStoryIndex(index), heroBiographyRead.getHeroListByStoryIndex(index)
		end
		table.insert(tipArray[v.tip], k)
	end
	local _ENV, mergeArray = (for generator), ipairs(retArray)
	local index = 1
	for tip, array in pairs(tipArray) do
		for _, v in ipairs(array) do
			if not mergeArray[index] then
				_ENV = mergeArray[index]
				mergeArray[index].des = retArray[v].des
				mergeArray[index].skillID = retArray[v].skillID
				mergeArray[index].tip = tip
				mergeArray[index], mergeArray[index].param = mergeArray[index], retArray[v].param
			else
				local param = mergeArray[index].param
				local _param = retArray[v].param
				for m, n in pairs(param) do
					param[m] = param[m] + (_param[m] or 0)
				end
				mergeArray[index].param = param
			end
		end
		index = index + 1
	end
	table.sort(mergeArray, function(a, b)
		return a.skillID < b.skillID
	end)
	for k, v in ipairs(mergeArray) do
		for ki, vi in pairs(v.param) do
			if vi < 0 then
				v.param[ki] = math.abs(vi / 10) .. "%"
			end
		end
		v.des = i18n(v.tip, v.param)
	end
	return retArray, mergeArray
end
function heroBiographyRead.getIsActivedSkill(skillID, skill)
	local skill = skill or heroBiographyRead.skillRef[skillID]
	if not skill then
		return nil
	end
	local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local retStatus = heroBiographyCtrl:getHeroStoryStatus(skill.GroupID)
	local heroList = heroBiographyRead.getHeroListByStoryIndex(skill.GroupID)
	if 1 == skill.type and retStatus == gHeroStoryUnLockType.ACTIVED then
		return skill
	end
	if 2 == skill.type and retStatus == gHeroStoryUnLockType.ACTIVED then
		local ret = true
		for _, heroID in ipairs(heroList) do
			local info = heroCtrl:getHeroInfoByID(heroID)
			if info and info.level < skill.missionNum or not info then
				ret = false
				break
			end
		end
		if ret then
			return skill
		end
	end
	if 4 == skill.type and retStatus == gHeroStoryUnLockType.ACTIVED then
		local ret = true
		for _, heroID in ipairs(heroList) do
			local info = heroCtrl:getHeroInfoByID(heroID)
			if not (not info or info.isAwake) or not info then
				ret = false
				break
			end
		end
		if ret then
			return skill
		end
	end
	return nil
end
function heroBiographyRead.getSkillBuff(skillID)
	local heroBiographyRead, buffData
	if heroBiographyRead.skillRef[skillID] then
		local buffType = heroBiographyRead.skillRef[skillID].buffType
		local buffMode = heroBiographyRead.skillRef[skillID].buffMode
		local buffNum = heroBiographyRead.skillRef[skillID].buffNum
		for k, v in ipairs(buffType) do
			local val = buffNum[k]
			if buffMode[k] == 5 then
				val = buffNum[k] / 1000
			end
			buffData[v] = val
		end
	end
	return buffData
end
function heroBiographyRead.getHeroTaskConfig(heroID)
	if not heroBiographyRead.task[heroID] then
		heroBiographyRead = heroBiographyRead.task[heroID]
	end
	return heroBiographyRead.task[heroID]
end
init()
return heroBiographyRead
