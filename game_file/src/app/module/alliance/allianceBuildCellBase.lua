local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local allianceBuildCellBase = class("allianceBuildCellBase")
function allianceBuildCellBase:ctor(property, command)
	self.property = property
	self.command = command
	local bid = self:getBID()
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	self.cond = clone(allianceResPointltCtrl.getCondOfSetBuilding(bid))
	self.needBonus = allianceResPointltCtrl.getNeedBonus(bid)
end
function allianceBuildCellBase:create(bid, iid)
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	local initLevel = allianceResPointltCtrl.getBuildingInitLV(bid)
	local initStatus = gAllianceBuildingStatus.FREE
	_ENV = nil
	;(nil).bid = bid
	;(nil).iid = iid
	;(nil).level = initLevel
	;(nil).pos = nil
	;(nil).status = initStatus
	;(nil).completeTime = nil
	local (nil).mapData, property
	return self.new(property)
end
function allianceBuildCellBase:demolish()
	if self:isFree() then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	self.property.pos = nil
	self.property.completeTime = nil
	self.property.mapData = nil
	self:setStatus(gAllianceBuildingStatus.FREE)
	return gErrDef.Err_None
end
function allianceBuildCellBase:syncServiceData(property)
	self.property = property
end
function allianceBuildCellBase:getBID()
	return self.property.bid
end
function allianceBuildCellBase:getIID()
	return self.property.iid
end
function allianceBuildCellBase:getLevel()
	return self.property.level
end
function allianceBuildCellBase:getCompleteTime()
	return self.property.completeTime
end
function allianceBuildCellBase:set(pos)
	if gAllianceBuildingStatus.FREE ~= self:getStatus() then
		print("allianceBuildCellBase:setBuilding failed! status error", self:getStatus())
		return
	end
	self.property.pos = pos
	self:setStatus(gAllianceBuildingStatus.BUILD)
	return gErrDef.Err_None
end
function allianceBuildCellBase:complete(completeTime)
	self.property.completeTime = completeTime
	self:setStatus(gAllianceBuildingStatus.COMPLETE)
	return gErrDef.Err_None
end
function allianceBuildCellBase:isFree()
	return gAllianceBuildingStatus.FREE == self:getStatus()
end
function allianceBuildCellBase:isBuilding()
	return gAllianceBuildingStatus.BUILD == self:getStatus()
end
function allianceBuildCellBase:isCompleted()
	return gAllianceBuildingStatus.COMPLETE == self:getStatus()
end
function allianceBuildCellBase:getPos()
	return self.property.pos
end
function allianceBuildCellBase:setStatus(status)
	self.property.status = status
	return gErrDef.Err_None
end
function allianceBuildCellBase:getStatus()
	return self.property.status
end
function allianceBuildCellBase:updateMapData(mapData)
	self.property.mapData = mapData
	return gErrDef.Err_None
end
function allianceBuildCellBase:getMapData()
	return self.property.mapData
end
function allianceBuildCellBase:hasPermission()
	local uid = gametop.playertop_:getPlayerID()
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	if not permissionCtrl:hasPlayerPermission(gAPermission.SET_BUILDING, uid) then
		return gErrDef.Err_ALLIANCE_NO_PERMISSION
	end
	return gErrDef.Err_None
end
function allianceBuildCellBase:isCondEnough()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	for i, v in ipairs(self.cond) do
		if gAllianceBuildCondType.POWER == v.id then
			local power = allianceMgr:getAllianceTotalBattle()
			if power < v.aim then
				return gErrDef.Err_ALLIANCE_POWER_NOT_ENOUGH
			end
		elseif gAllianceBuildCondType.MEMBER == v.id then
			local memberCount = alliance:getMemberCount()
			if memberCount < v.aim then
				return gErrDef.Err_ALLIANCE_MEM_COUNT_NOT_ENOUGH
			end
		end
	end
	return gErrDef.Err_None
end
function allianceBuildCellBase:getCondOfSetBuilding()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	for i, v in ipairs(self.cond) do
		if gAllianceBuildCondType.POWER == v.id then
			v.cur = allianceMgr:getAllianceTotalBattle()
		elseif gAllianceBuildCondType.MEMBER == v.id then
			v.cur = alliance:getMemberCount()
		elseif gAllianceBuildCondType.BONUS == v.id then
			v.cur = alliance:getProperty("bonus")
		end
	end
	return self.cond
end
function allianceBuildCellBase:getBuildingStatus()
	if self:isFree() then
		if gErrDef.Err_None ~= self:isCondEnough() then
			return gAllianceBuildingStatus.LOCK
		else
			return self:getStatus()
		end
	elseif self:isBuilding() or self:isCompleted() then
		return self:getStatus()
	end
end
function allianceBuildCellBase:getNeedBonus()
	return self.needBonus
end
function allianceBuildCellBase:dump(description)
end
return allianceBuildCellBase
