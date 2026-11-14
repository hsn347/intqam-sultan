local lordSkillltCtrl = include("lordSkillltCtrl")
local _ENV, lordSkillModuleAPI = "lordSkillltCtrl", "lordSkillltCtrl"
function lordSkillModuleAPI:upgradeSkill(setID, skillID, upgradeLevel)
	skillID = tonumber(skillID)
	local lordSkillCtrl = self:getModuleCtrl()
	lordSkillCtrl:upgradeSkill(setID, skillID, upgradeLevel)
end
function lordSkillModuleAPI:resetSkillSet(setID)
	local lordSkillCtrl = self:getModuleCtrl()
	lordSkillCtrl:resetSkillSet(setID)
end
function lordSkillModuleAPI:switchSkillSet(setID)
	local lordSkillCtrl = self:getModuleCtrl()
	lordSkillCtrl:switchSkillSet(setID)
end
function lordSkillModuleAPI:setSkillSetTitle(setID, title)
	local lordSkillCtrl = self:getModuleCtrl()
	lordSkillCtrl:setSkillSetTitle(setID, title)
end
function lordSkillModuleAPI:useSkill(skillID)
	skillID = tonumber(skillID)
	local lordSkillCtrl = self:getModuleCtrl()
	lordSkillCtrl:useSkill(skillID)
end
function lordSkillModuleAPI:getSkillSetData(setID)
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:getSkillSetData(setID)
end
function lordSkillModuleAPI:getRemainPoint(setID)
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:getRemainPoint(setID)
end
function lordSkillModuleAPI:getActiveSetID()
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:getActiveSetID()
end
function lordSkillModuleAPI:getSkillSetTitle(setID)
	print("lordSkillModuleAPI:getSkillSetTitle", setID)
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:getSkillSetTitle(setID)
end
function lordSkillModuleAPI:isSkillSetUnlock(setID)
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:isSkillSetUnlock(setID)
end
function lordSkillModuleAPI:getSkillDetail(setID, skillID)
	skillID = tonumber(skillID)
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:getSkillDetail(setID, skillID)
end
function lordSkillModuleAPI:getBuffInfoText(setID, skillID, curLevel)
	skillID = tonumber(skillID)
	local _, curBuffValue, curBuffUnit = lordSkillltCtrl:getSkillBuffInfo(skillID, curLevel)
	curBuffValue = curBuffValue or 0
	local nextLevel = curLevel + 1
	local _, nextBuffValue, nextBuffUnit = lordSkillltCtrl:getSkillBuffInfo(skillID, nextLevel)
	local addBuffValue = nextBuffValue and nextBuffValue - curBuffValue
	local unit = curBuffUnit or nextBuffUnit
	if unit == "01" then
		curBuffValue = curBuffValue and curBuffValue * 100 .. "%"
		addBuffValue = addBuffValue and addBuffValue * 100 .. "%"
		nextBuffValue = nextBuffValue and nextBuffValue * 100 .. "%"
	end
	return curBuffValue, addBuffValue, nextBuffValue
end
function lordSkillModuleAPI:getSkillBuff(setID, skillID, level)
	skillID = tonumber(skillID)
	local buffType, buffValue, buffUnit = lordSkillltCtrl:getSkillBuffInfo(skillID, level)
	if buffValue and "01" == buffUnit then
		buffValue = buffValue * 1000
	end
	_ENV = level
	level.pid = buffType
	level.type = buffUnit
	level.value = buffValue
	return level
end
function lordSkillModuleAPI:getSkillPost(skillID)
	skillID = tonumber(skillID)
	if not lordSkillltCtrl:getSkillNextList(skillID) then
		_ENV = lordSkillltCtrl:getSkillNextList(skillID)
	end
	return (lordSkillltCtrl:getSkillNextList(skillID))
end
function lordSkillModuleAPI:getUseSkillList()
	local list = lordSkillltCtrl:getUseSkillList()
	local lordSkillCtrl = self:getModuleCtrl()
	local lordSkillltCtrl, ret = self, self
	for skillID, _ in pairs(list) do
		local data = lordSkillCtrl:getSkillCDData(skillID)
		table.insert(ret, data)
	end
	table.sort(ret, function(l, r)
		return tonumber(l.skillID) > tonumber(r.skillID)
	end)
	return ret
end
function lordSkillModuleAPI:getSkillType(skillID)
	skillID = tonumber(skillID)
	return lordSkillltCtrl:getSkillType(skillID)
end
function lordSkillModuleAPI:skillInCD(skillID)
	skillID = tonumber(skillID)
	local lordSkillCtrl = self:getModuleCtrl()
	if lordSkillCtrl:skillInCD(skillID) then
		return true, lordSkillCtrl:getSkillCDRemainTime(skillID)
	end
	return false
end
function lordSkillModuleAPI:getSkillCDData(skillID)
	skillID = tonumber(skillID)
	local lordSkillCtrl = self:getModuleCtrl()
	return lordSkillCtrl:getSkillCDData(skillID)
end
function lordSkillModuleAPI:getModuleCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("lordSkillCtrl")
end
return lordSkillModuleAPI
