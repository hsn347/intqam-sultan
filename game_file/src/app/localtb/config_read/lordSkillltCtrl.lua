local lordSkillltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	lordSkillltCtrl:defineValue("_data", function()
		lordSkillltCtrl._data, lordSkillltCtrl = nil, nil
		local skillConfig = require_once("app." .. LocalTblPath .. ".config_server.skill")
		local lordSkillltCtrl, skillList = "app." .. LocalTblPath .. ".config_server.skill", "app." .. LocalTblPath .. ".config_server.skill"
		local lordSkillltCtrl, skillTypeList = LocalTblPath, LocalTblPath
		local lordSkillltCtrl, skillNextList = ".config_server.skill", ".config_server.skill"
		local lordSkillltCtrl, useSkillList
		lordSkillltCtrl._data.skillList = skillList
		lordSkillltCtrl._data.skillTypeList = skillTypeList
		lordSkillltCtrl._data.skillNextList = skillNextList
		lordSkillltCtrl._data.useSkillList = useSkillList
		for _, v in ipairs(skillConfig) do
			local uniqueSkillID = v.skillID
			local skillID = tonumber(string.sub(uniqueSkillID, 0, 5))
			local skillType = v.skillType
			local currentLevel = v.skillCurLv
			if not skillList[skillID] then
				lordSkillltCtrl = skillList[skillID]
				skillList[skillID].skillID = skillID
				skillList[skillID].skillType = v.skillType
				skillList[skillID].isAcitve = v.isAcitve == 1 and true or false
				skillList[skillID].minLevel = currentLevel
				skillList[skillID], skillList[skillID].CDData, lordSkillltCtrl, skillList[skillID].powerData, lordSkillltCtrl, skillList[skillID].buffData, lordSkillltCtrl, skillList[skillID].preposeList, lordSkillltCtrl, skillList[skillID].maxLevel = skillList[skillID], v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, v.isAcitve == 1 and true or false, currentLevel
				if not skillTypeList[skillType] then
					lordSkillltCtrl = skillTypeList[skillType]
				end
				skillTypeList[skillType] = skillTypeList[skillType]
				skillTypeList[skillType][skillID] = skillList[skillID]
				if skillList[skillID].isAcitve then
					useSkillList[skillID] = skillID
				end
			end
			skillList[skillID].minLevel = math.min(skillList[skillID].minLevel, currentLevel)
			skillList[skillID].maxLevel = math.max(skillList[skillID].maxLevel, currentLevel)
			local skillProperty = v.skillProperty
			local skillBuffType = tonumber(string.sub(skillProperty, 1, 2))
			local unit = string.sub(skillProperty, 3, 4)
			local cardinal = unit == "01" and 1000 or 1
			local skillBuffValue = tonumber(string.sub(skillProperty, 5, string.len(skillProperty))) / cardinal
			lordSkillltCtrl = string.sub(skillProperty, 5, string.len(skillProperty))
			string.sub(skillProperty, 5, string.len(skillProperty)).unit = unit
			string.sub(skillProperty, 5, string.len(skillProperty)).skillBuffType = skillBuffType
			local string.sub(skillProperty, 5, string.len(skillProperty)).skillBuffValue, buff = skillBuffValue, string.sub(skillProperty, 5, string.len(skillProperty))
			skillList[skillID].buffData[currentLevel] = buff
			local power = v.FightingCapacity
			skillList[skillID].powerData[currentLevel] = power
			skillList[skillID].CDData[currentLevel] = v.skillCurCD
			local lordSkillltCtrl, preposeList = skillList[skillID].CDData, skillList[skillID].CDData
			for i = 1, 3 do
				local key = "skillPrepose" .. i
				local preposeSkill = v[key]
				local preposeSkillID = tonumber(string.sub(preposeSkill, 0, 5))
				if nil ~= preposeSkillID and 0 ~= preposeSkillID then
					preposeList[preposeSkillID] = preposeSkillID
					v[key] = nil
					if not skillNextList[preposeSkillID] then
						lordSkillltCtrl = skillNextList[preposeSkillID]
					end
					skillNextList[preposeSkillID] = skillNextList[preposeSkillID]
					table.insert(skillNextList[preposeSkillID], skillID)
				end
			end
			v.preposeList = preposeList
			if next(preposeList) then
				skillList[skillID].preposeList = preposeList
			end
		end
		local setConfig = require("app." .. LocalTblPath .. ".config_server.lordskill_set_config")
		local lordSkillltCtrl, temp = "app." .. LocalTblPath .. ".config_server.lordskill_set_config", "app." .. LocalTblPath .. ".config_server.lordskill_set_config"
		lordSkillltCtrl._data.setConfig = temp
		for _, v in pairs(setConfig) do
			v.setID = tostring(v.setID)
			lordSkillltCtrl, lordSkillltCtrl, temp[v.setID] = v.setID, v.setID, v
			v.setID.condKey = v.condition[1]
			v.setID.condValue = v.condition[2]
			v.condition, v.setID[1], v.setID.targetValue = v.setID, v.setID, v.condition[3]
		end
		return lordSkillltCtrl._data
	end)
end
init()
function lordSkillltCtrl:setSkillIDValid(skillID)
	if self:getSkillDetail(skillID) then
		return true
	end
	return false
end
function lordSkillltCtrl:getSkillDetail(skillID)
	return self._data.skillList[skillID]
end
function lordSkillltCtrl:getSkillPower(skillID, level)
	local powerData = self:_getSkillProperty(skillID, "powerData")
	local power = powerData and powerData[level]
	power = power or 0
	return power
end
function lordSkillltCtrl:getSkillLevelMax(skillID)
	return self:_getSkillProperty(skillID, "maxLevel")
end
function lordSkillltCtrl:getActiveType(skillID)
	return self:_getSkillProperty(skillID, "isAcitve")
end
function lordSkillltCtrl:getSkillCD(skillID, level)
	local CDData = self:_getSkillProperty(skillID, "CDData")
	local CD = CDData and CDData[level]
	CD = CD or 0
	return CD
end
function lordSkillltCtrl:getPrepositiveSkillList(skillID)
	return self:_getSkillProperty(skillID, "preposeList")
end
function lordSkillltCtrl:passiveSkill(skillID)
	local activity = self:getActiveType(skillID)
	if not activity then
		return true
	end
end
function lordSkillltCtrl:manualSkill(skillID)
	return not self:passiveSkill(skillID)
end
function lordSkillltCtrl:getSkillBuffInfo(skillID, level)
	local buffData = self:_getSkillProperty(skillID, "buffData")
	local buff = buffData and buffData[level]
	if buff then
		return buff.skillBuffType, buff.skillBuffValue, buff.unit
	end
end
function lordSkillltCtrl:getSkillType(skillID)
	return self:_getSkillProperty(skillID, "skillType")
end
function lordSkillltCtrl:getSkillListByType(skillType)
	return self._data.skillTypeList[skillType]
end
function lordSkillltCtrl:getSkillSetList()
	local _ENV, ret
	for setID, _ in pairs(self._data.setConfig) do
		table.insert(ret, setID)
	end
	return ret
end
function lordSkillltCtrl:getSkillNextList(skillID)
	return self._data.skillNextList[skillID]
end
function lordSkillltCtrl:setIDValid(setID)
	if self._data.setConfig[setID] then
		return true
	end
	return false
end
function lordSkillltCtrl:getDefaultSetID()
	return "1"
end
function lordSkillltCtrl:getLordSkillSetCondition(setID)
	return self._data.setConfig[setID].condition
end
function lordSkillltCtrl:getUseSkillList()
	return self._data.useSkillList
end
function lordSkillltCtrl:calcSkillPoint(lordLevel)
	local skillPoint = 0
	local rank = include("lordLocalData").getLordRankLevData()
	for level, v in ipairs(rank) do
		if level <= lordLevel then
			skillPoint = v.skillPoint + skillPoint
		end
	end
	return skillPoint
end
function lordSkillltCtrl:_getSkillProperty(skillID, propertyName)
	local detail = self._data.skillList[skillID]
	return detail and detail[propertyName]
end
return lordSkillltCtrl
