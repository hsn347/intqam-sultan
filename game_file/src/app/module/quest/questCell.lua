local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local questCell = class("questCell")
_ENV = "questCell"
;("questCell").questID = 0
;("questCell").status = gQuestStatus.NONE
;("questCell").progress = 0
;("questCell").aim = 0
;("questCell").time = nil
local ("questCell").lock, property = nil, "questCell"
function questCell:perform()
	self.property.status = gQuestStatus.PERFORMING
end
function questCell:canCommit()
	local status = self:getStatus()
	return gQuestStatus.COMMIT == status
end
function questCell:isPerforming()
	local status = self:getStatus()
	return gQuestStatus.PERFORMING == status
end
function questCell:hasBeenFinished()
	local status = self:getStatus()
	return gQuestStatus.FINISH == status
end
function questCell:finish()
	self:setStatus(gQuestStatus.FINISH)
end
function questCell:getQuestID()
	return self.property.questID
end
function questCell:setQuestID(id)
	self.property.questID = id
end
function questCell:setProgress(val)
	if not val or self.property.progress == val then
		return
	end
	self.property.progress = val
	if self.property.progress >= self.property.aim then
		self:setStatus(gQuestStatus.COMMIT)
	end
	return self:getStatus()
end
function questCell:getProgress()
	self.property.progress = self.property.progress or 0
	local questType = questltCtrl:getQuestType(self:getQuestID())
	if gQuestType.EXPLORE == questType then
		local hours = math.floor(self.property.aim / 60)
		if 0 < hours then
			return math.floor(self.property.progress / 60)
		end
	elseif gQuestType.UPGRADE_BUILDING == questType then
		if self:canCommit() then
			return self:getAim()
		end
		local buildLogic = include("buildLogic")
		local isAimWlv, aimWlv = buildLogic.isBuildWarLv(self.property.aim)
		local isProgressWlv, progressWlv = buildLogic.isBuildWarLv(self.property.progress)
		if isAimWlv and 0 < aimWlv then
			if isProgressWlv then
				return progressWlv
			else
				return 0
			end
		else
			return self.property.progress
		end
	end
	return self.property.progress or 0
end
function questCell:setAim(val)
	self.property.aim = val
end
function questCell:getAim()
	local questType = questltCtrl:getQuestType(self:getQuestID())
	if gQuestType.EXPLORE == questType then
		if self.property.aim then
			local hours = math.floor(self.property.aim / 60)
			if 0 < hours then
				return hours
			end
		end
	elseif gQuestType.UPGRADE_BUILDING == questType then
		local ok, wlv = include("buildLogic").isBuildWarLv(self.property.aim)
		if ok then
			if 0 == wlv then
				return 30
			end
			return wlv
		end
	end
	return self.property.aim or 0
end
function questCell:setStatus(val)
	self.property.status = val
end
function questCell:getStatus()
	return self.property.status
end
function questCell:setProperty(property)
	self.property = property
end
function questCell:isLock()
	return self.property.lock
end
function questCell:ctor(properties)
	properties = properties or property
	self.property = clone(properties)
end
function questCell:dump()
end
return questCell
