local buffContainer = include("buffContainer")
local lordSkillltCtrl = include("lordSkillltCtrl")
local shieldedWordsltCtrl = include("shieldedWordsltCtrl")
local lordSkillSet = class("lordSkillSet")
function lordSkillSet:ctor(setID)
	_UPVALUE0_ = nil
	;(nil).setID = setID
	;(nil).title = ""
	;(nil).usedPoint = 0
	self._data, (nil).list, _UPVALUE0_, (nil).power = nil, nil, nil, 0
end
function lordSkillSet:initialize(setData)
	self._data = setData or self._data
	self:_initializeBuff()
	return self._data
end
function lordSkillSet:compatibleOldVersion(oldSkillData)
	if oldSkillData and oldSkillData.skillBasic and next(oldSkillData.skillBasic) then
		local power = 0
		local usedPoint = 0
		if next(self._data.list) then
			self._data.list, _ENV = self._data.list, self._data.list
		end
		for _, v in pairs(oldSkillData.skillBasic) do
			local skillID = v[1]
			local level = v[2]
			self:setSkillLevel(skillID, level)
			usedPoint = usedPoint + level
			power = power + lordSkillltCtrl:getSkillPower(skillID, level)
		end
		self._data.power = power
		self._data.usedPoint = usedPoint
		self:_initializeBuff()
	else
		print("lordSkillSet:compatibleOldVersion not found oldSkillData")
	end
end
function lordSkillSet:queryBuff(buffType)
	return self._buffContainer:query(buffType)
end
function lordSkillSet:reset()
	if 0 == self._data.usedPoint then
		return gErrDef.Err_SKILLSET_NEED_NOT_RESET
	end
	self._data.usedPoint = 0
	self._data.power = 0
	self._data.list, _ENV = nil, nil
	self._buffContainer:clean()
	return gErrDef.Err_None
end
function lordSkillSet:checkPrepositiveSkill(skillID)
	local prepositiveSkillList = lordSkillltCtrl:getPrepositiveSkillList(skillID)
	if not prepositiveSkillList or not next(prepositiveSkillList) then
		return true
	end
	for prepositiveSkillID, _ in pairs(prepositiveSkillList) do
		local levelMax = lordSkillltCtrl:getSkillLevelMax(prepositiveSkillID)
		if levelMax == self:getSkillLevel(prepositiveSkillID) then
			return true
		end
	end
	return false
end
function lordSkillSet:checkSkillUpgradeCondition(skillID, upgradeLevel)
	local curLevel = self:getSkillLevel(skillID)
	if curLevel then
		local levelMax = lordSkillltCtrl:getSkillLevelMax(skillID)
		if upgradeLevel <= levelMax - curLevel then
			return true
		end
		return false
	else
		return self:checkPrepositiveSkill(skillID)
	end
end
function lordSkillSet:upgradeSkill(skillID, upgradeLevel, pointTotal)
	if not self:checkPrepositiveSkill(skillID) then
		return gErrDef.Err_SKILL_UPGRADE_COND_NOT_ENOUGH
	end
	local remainPoint = pointTotal - self._data.usedPoint
	if remainPoint <= 0 then
		return gErrDef.Err_SKILLSET_POINT_NOT_ENOUGH
	end
	local level = self:getSkillLevel(skillID)
	if not level then
		level = 0
		self:setSkillLevel(skillID, level)
	end
	local remainLevel = self:_getUpgradeRemainLevel(skillID)
	remainLevel = math.min(remainLevel, remainPoint)
	local addLevel
	if 0 < upgradeLevel then
		if upgradeLevel > remainLevel then
			return gErrDef.Err_ILLEGAL_PARAMS
		end
		addLevel = upgradeLevel
	else
		addLevel = remainLevel
	end
	self._data.usedPoint = self._data.usedPoint + addLevel
	local curLevel = level + addLevel
	self:setSkillLevel(skillID, curLevel)
	self:_updateBuff(skillID, curLevel)
	self:updateSkillPower(skillID, level, curLevel)
	return gErrDef.Err_None, level, curLevel
end
function lordSkillSet:updateSkillPower(skillID, curLevel, addLevel)
	local curSkillPower = lordSkillltCtrl:getSkillPower(skillID, curLevel)
	local oldLevel = curLevel - addLevel
	local oldSkillPower = 0
	if 0 < oldLevel then
		oldSkillPower = lordSkillltCtrl:getSkillPower(skillID, oldLevel)
	end
	local changePower = curSkillPower - oldSkillPower
	self._data.power = self._data.power + changePower
end
function lordSkillSet:setTitle(title)
	if self._data.title == title then
		return gErrDef.Err_SKILL_TITLE_ILLEGAL
	end
	local ret = self:_isTitleLegal(title)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	self._data.title = title
	return gErrDef.Err_None
end
function lordSkillSet:getTitle()
	return self._data.title
end
function lordSkillSet:foundSkill(skillID)
	if self:getSkillLevel(skillID) then
		return true
	end
	return false
end
function lordSkillSet:setSkillLevel(skillID, level)
	self._data.list[tostring(skillID)] = level
end
function lordSkillSet:getSkillLevel(skillID)
	return self._data.list[tostring(skillID)]
end
function lordSkillSet:getUsedPointTotal()
	return self._data.usedPoint
end
function lordSkillSet:getSkillPointInfo()
	local _ENV, info
	for skillIDStr, level in pairs(self._data.list) do
		local skillType = lordSkillltCtrl:getSkillType(tonumber(skillIDStr))
		local point = info[skillType] or 0
		point = point + level
		info[skillType] = point
	end
	return info
end
function lordSkillSet:_initializeBuff()
	self._buffContainer = buffContainer.new()
	for skillIDStr, level in pairs(self._data.list) do
		local skillID = tonumber(skillIDStr)
		self:_updateBuff(skillID, level)
	end
end
function lordSkillSet:_updateBuff(skillID, level)
	if not lordSkillltCtrl:passiveSkill(skillID) then
		return
	end
	local buffType, buffValue = lordSkillltCtrl:getSkillBuffInfo(skillID, level)
	if buffType and buffValue then
		self._buffContainer:update(buffType, buffValue, skillID)
	else
		print("lordSkillSet:_updateBuff: not found skill config", skillID, level)
	end
end
function lordSkillSet:_getUpgradeRemainLevel(skillID)
	local curLevel = self:getSkillLevel(skillID) or 0
	local levelMax = lordSkillltCtrl:getSkillLevelMax(skillID)
	return levelMax - curLevel
end
function lordSkillSet:_isTitleLegal(title)
	if "string" ~= type(title) then
		return gErrDef.Err_SKILL_TITLE_ILLEGAL
	end
	if "" == string.trim(title) then
		return gErrDef.Err_SKILL_TITLE_ILLEGAL
	end
	local len = string.utf8len(title)
	if len < 1 or 10 < len then
		return gErrDef.Err_SKILL_TITLE_ILLEGAL
	end
	local ok = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isEquipmentSetTitleLegality(title)
	if not ok then
		return gErrDef.Err_SKILL_TITLE_ILLEGAL
	end
	ok = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(title)
	if ok then
		return gErrDef.Err_SKILL_TITLE_ILLEGAL
	end
	return gErrDef.Err_None
end
return lordSkillSet
