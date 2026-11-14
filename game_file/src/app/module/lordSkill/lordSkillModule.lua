local lordSkillSet = include("lordSkillSet")
local lordSkillltCtrl = include("lordSkillltCtrl")
local CDComponent = include("CDComponent")
local gametop = gModuleMgr.getObject("gametop")
local _ENV, lordSkillModule = "gametop", "gametop"
function lordSkillModule:initialize(data)
	if data then
		for _, setInfo in pairs(data.setListData) do
			setInfo.list["11055"] = nil
		end
		data.CDData["11055"] = nil
	end
	self._data = data or self:_getDefaultData()
	self._setList, _ENV, self._CDComponent = CDComponent.new(self._data.CDData), CDComponent.new(self._data.CDData), CDComponent.new(self._data.CDData)
	local setListConfig = lordSkillltCtrl:getSkillSetList()
	if setListConfig then
		for _, setID in ipairs(setListConfig) do
			self._setList[setID] = lordSkillSet.new(setID)
			local setData = self._data.setListData[setID]
			self._data.setListData[setID] = self._setList[setID]:initialize(setData)
		end
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	buffCtrl:addEventListener(tostring(gBuffEffect.TROOP_PROTECT), handler(self, self._troopProtectBuffCallback))
	buffCtrl:addEventListener(tostring(gBuffEffect.SNEAK_INTO), handler(self, self._sneakIntoBuffCallback))
	buffCtrl:addEventListener(tostring(gBuffEffect.SHEEP_PICKINGUP_INPASSING), handler(self, self._sheepPickingupCB))
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordInfoCtrl:addEventListener(gEventName.event_update_lord_upgrade, handler(self, self._lordUpgradeCallback))
	lordInfoCtrl:addEventListener(gEventName.event_vip_upgrade, handler(self, self._VIPUpgradeCallback))
end
function lordSkillModule:upgradeSkill(setID, skillID, upgradeLevel)
	skillID = SoraDFloor(skillID)
	print("lordSkillModule:upgradeSkill", setID, skillID, upgradeLevel)
	local skillSet = self:getSet(setID)
	if not skillSet then
		return gErrDef.Err_NOT_FOUND_SKILLSET
	end
	if not lordSkillltCtrl:setSkillIDValid(skillID) then
		return gErrDef.Err_CLIENT_EXCEPTION
	end
	return skillSet:upgradeSkill(skillID, upgradeLevel, self._data.pointTotal)
end
function lordSkillModule:switchSkillSet(setID)
	print("lordSkillModule:switchSkillSet", setID)
	local activeSetID = self:getActiveSetID()
	if activeSetID == setID then
		return gErrDef.Err_SKILLSET_ALREADY_ACTIVE
	end
	self._data.activeSetID = setID
	return gErrDef.Err_None
end
function lordSkillModule:resetSkillSet(setID)
	print("lordSkillModule:resetSkillSet", setID)
	local skillSet = self:getSet(setID)
	if not skillSet then
		return gErrDef.Err_NOT_FOUND_SKILLSET
	end
	return skillSet:reset()
end
function lordSkillModule:refreshSkillCD(skillID, beginTime, CD)
	self._CDComponent:setCD(tostring(skillID), beginTime, CD)
end
function lordSkillModule:setSkillSetTitle(setID, title)
	print("lordSkillModule:setSkillSetTitle", setID, title)
	local skillSet = self:getSet(setID)
	if not skillSet then
		return gErrDef.Err_NOT_FOUND_SKILLSET
	end
	return skillSet:setTitle(title)
end
function lordSkillModule:isSkillSetUnlock(setID)
	local condition = lordSkillltCtrl:getLordSkillSetCondition(setID)
	return serviceFunctions.checkCondtion(condition)
end
function lordSkillModule:getSkillSetTitle(setID)
	local skillSet = self:getSet(setID)
	if not skillSet then
		return
	end
	return skillSet:getTitle()
end
function lordSkillModule:queryBuff(buffType)
	local activeSet = self:getActiveSet()
	return activeSet and activeSet:queryBuff(buffType) or 0
end
function lordSkillModule:useSkill(skillID, beginTime, CD)
	Log.i("lordSkillModule:useSkill", skillID)
	if not lordSkillltCtrl:setSkillIDValid(skillID) then
		return gErrDef.Err_CLIENT_EXCEPTION
	end
	local activeSet = self:getActiveSet()
	if not activeSet:foundSkill(skillID) then
		return gErrDef.Err_SKILLSET_NOT_FOUND_SKILL
	end
	local skillLevel = activeSet:getSkillLevel(skillID)
	local buffType = lordSkillltCtrl:getSkillBuffInfo(skillID, skillLevel)
	if gLordTechnologyType.HELP ~= buffType and gLordTechnologyType.SNEAK_INTO ~= buffType then
		self._CDComponent:setCD(tostring(skillID), beginTime, CD)
	end
end
function lordSkillModule:getActiveSetID()
	return self._data.activeSetID
end
function lordSkillModule:getSkillPointTotal()
	return self._data.pointTotal
end
function lordSkillModule:getSet(setID)
	setID = setID or self:getActiveSetID()
	return setID and self._setList[tostring(setID)]
end
function lordSkillModule:getActiveSet()
	local activeSetID = self:getActiveSetID()
	return self:getSet(activeSetID)
end
function lordSkillModule:getSkillSetData(setID)
	_ENV = nil
	;(nil).battle = nil
	;(nil).develop = nil
	;(nil).auxiliary = nil
	;(nil).skillPoints = 0
	;(nil).battlePoints = 0
	;(nil).developPoints = 0
	local (nil).auxiliaryPoints, ret = 0, nil
	local skillSet = self:getSet(setID)
	if not skillSet then
		return ret
	end
	local pointTotal = self:getSkillPointTotal()
	local usedPointTotal = skillSet:getUsedPointTotal()
	if pointTotal and usedPointTotal then
		ret.skillPoints = pointTotal - usedPointTotal
	end
	local skillPointInfo = skillSet:getSkillPointInfo()
	if skillPointInfo and next(skillPointInfo) then
		ret.battlePoints = skillPointInfo[gLordSkillType.BATTLE] or 0
		ret.developPoints = skillPointInfo[gLordSkillType.DEVELOP] or 0
		ret.auxiliaryPoints = skillPointInfo[gLordSkillType.AUXILIARY] or 0
	end
	local createSkillDataList = function(skillType, des)
		local list = lordSkillltCtrl:getSkillListByType(skillType)
		local lordSkillltCtrl, dataList = lordSkillltCtrl, lordSkillltCtrl
		for skillID, _ in pairs(list) do
			local detail = self:getSkillDetail(setID, skillID)
			dataList[tostring(skillID)] = detail
		end
		return dataList
	end
	ret.battle = createSkillDataList(gLordSkillType.BATTLE)
	ret.develop = createSkillDataList(gLordSkillType.DEVELOP)
	ret.auxiliary = createSkillDataList(gLordSkillType.AUXILIARY)
	return ret
end
function lordSkillModule:getRemainPoint(setID)
	local remainPoint = 0
	local skillSet = self:getSet(setID)
	if not skillSet then
		return remainPoint
	end
	local pointTotal = self:getSkillPointTotal()
	local usedPointTotal = skillSet:getUsedPointTotal()
	remainPoint = pointTotal - usedPointTotal
	remainPoint = math.max(remainPoint, 0)
	return remainPoint
end
function lordSkillModule:getSkillDetail(setID, skillID)
	local skillSet = self:getSet(setID)
	if not skillSet then
		return
	end
	local detail = clone(lordSkillltCtrl:getSkillDetail(skillID))
	function detail.update()
		detail.currentLevel = skillSet:getSkillLevel(skillID) or 0
		if detail.currentLevel > 0 then
			detail.isOpened = true
		else
			detail.isOpened = skillSet:checkPrepositiveSkill(skillID)
		end
	end
	detail.update()
	return detail
end
function lordSkillModule:getSkillCDData(skillID)
	local activeSet = self:getActiveSet()
	local level = activeSet:getSkillLevel(skillID)
	local defaultCD = self:_getSkillCD(skillID)
	_ENV = self
	self.skillID = tostring(skillID)
	self.defaultCD = defaultCD
	self.CDRemainTime = 0
	local self.isOpened, data = false, self
	local update = function()
		local CDRemainTime = self._CDComponent:getCDRemainTime(tostring(skillID))
		data.CDRemainTime = CDRemainTime
		if activeSet:getSkillLevel(skillID) then
			data.isOpened = true
		else
			data.isOpened = false
		end
	end
	data.update = update
	data.update()
	return data
end
function lordSkillModule:skillInCD(skillID)
	return self._CDComponent:inCD(tostring(skillID))
end
function lordSkillModule:getSkillCDRemainTime(skillID)
	return self._CDComponent:getCDRemainTime(tostring(skillID))
end
function lordSkillModule:_getDefaultData()
	lordSkillltCtrl = nil
	;(nil).setListData, lordSkillltCtrl, (nil).pointTotal = nil, nil, 0
	;(nil).CDData, lordSkillltCtrl, (nil).activeSetID = lordSkillltCtrl:getDefaultSetID(), lordSkillltCtrl:getDefaultSetID(), lordSkillltCtrl:getDefaultSetID()
	return nil
end
function lordSkillModule:_getSkillCD(skillID, skillLevel)
	local gametop = gModuleMgr.getObject("gametop")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	if not skillLevel then
		local activeSet = self:getActiveSet()
		skillLevel = activeSet:getSkillLevel(skillID) or 1
	end
	local CD = lordSkillltCtrl:getSkillCD(skillID, skillLevel)
	local CDReduce = buffCtrl:getBuffEffect(gBuffEffect.SKILL_CDTIME_REDUCE) or 0
	local ret = math.floor(CD * (1 / (1 + CDReduce / 1000)))
	return ret
end
function lordSkillModule:_sneakIntoBuffCallback(event)
	if event.eventType == "close" then
		print("lordSkillModule:_sneakIntoBuffCallback close")
		local skillID = 13032
		local CD = self:_getSkillCD(skillID)
		self._CDComponent:setCD(tostring(skillID), serviceFunctions.systemTime(), CD)
	end
end
function lordSkillModule:_lordUpgradeCallback(event)
	print("lordSkillModule:_lordUpgradeCallback", event.level)
	local eventData = event
	local level = eventData.level
	self:_updatePointTotal(level)
end
function lordSkillModule:_VIPUpgradeCallback(event)
	print("lordSkillModule:_VIPUpgradeCallback", event.level)
	self:_updatePointTotal()
end
function lordSkillModule:_updatePointTotal(level)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lordLevel = level or lordInfoCtrl:getLordLevel()
	print("lordSkillModule:_updatePointTotal lordLevel", lordLevel)
	self._data.pointTotal = lordSkillltCtrl:calcSkillPoint(lordLevel)
	print("lordSkillModule:_updatePointTotal self._data.pointTotal", self._data.pointTotal)
	local vipSkillPoint = lordInfoCtrl:getVIPSkillPoints() or 0
	print("lordSkillModule:_updatePointTotal vipSkillPoint", vipSkillPoint, self._data.pointTotal)
	self._data.pointTotal = self._data.pointTotal + vipSkillPoint
end
function lordSkillModule:_troopProtectBuffCallback(event)
	if event.eventType == "close" then
		print("lordCtrl:_troopProtectBuffCallback close")
		local skillID = 11028
		local CD = self:_getSkillCD(skillID)
		self._CDComponent:setCD(tostring(skillID), serviceFunctions.systemTime(), CD)
	end
end
function lordSkillModule:_sheepPickingupCB(event)
	if event.eventType == "close" then
		print("lordCtrl:_sheepPickingupCB close")
		local skillID = 13040
		local CD = self:_getSkillCD(skillID)
		self._CDComponent:setCD(tostring(skillID), serviceFunctions.systemTime(), CD)
	end
end
return lordSkillModule
