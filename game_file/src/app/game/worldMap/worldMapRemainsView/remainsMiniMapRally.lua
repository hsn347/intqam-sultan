local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapUtil = include("kingdomMapUtil")
local remainsMiniMapRally = class("remainsMiniMapRally", function(target)
	return display.newNode()
end)
function remainsMiniMapRally:ctor()
	self.indexID = nil
	self.hasCapture = false
	self.targetData = nil
	self.mainView = nil
end
function remainsMiniMapRally:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_DELETE_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_ADD_NEW", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE_NEW", handler(self, self.updateView))
end
function remainsMiniMapRally:setMainView(mainView, queueRoot)
	self.mainView = mainView
	self.queueRoot = queueRoot
	self.nodeWar = display.newNode()
	self.nodeWar:addTo(self)
end
function remainsMiniMapRally:resetNode()
	if self.nodeWar then
		self.nodeWar:removeAllChildren()
	end
end
function remainsMiniMapRally:updateView(target, data)
	if data.queueRoot and data.queueRoot ~= self.queueRoot then
		return
	end
	if data.indexID == self.indexID then
		self:initData(self.indexID)
	end
end
function remainsMiniMapRally:updateData(indexID, warHallData, isFilter)
	self:initData(indexID, warHallData, isFilter)
end
function remainsMiniMapRally:initData(indexID, warHallData, isFilter)
	self.indexID = indexID
	local warHallQueues
	if warHallData then
		warHallQueues = warHallData
		self.isFilter = isFilter
	else
		warHallData = self.queueRoot:getWarHallData(self.indexID)
		if warHallData then
			self.isFilter = warHallData.isFilter
			warHallQueues, _ENV = warHallData.queues, warHallData.queues
			warHallQueues = warHallData and warHallData.queues or warHallData
		end
	end
	local tableMainData
	if warHallQueues then
		local index, queue = next(warHallQueues)
		if index and queue then
			tableMainData = queue
		end
	end
	self:resetNode()
	if not tableMainData then
		return
	end
	self.tableMainData = tableMainData
	self.viewType = gAWarViewMemberType.NONE
	self.hasCapture = false
	local targetData = self:getShowTarget()
	self.targetData = targetData
	local fromAid = self.tableMainData:getAid()
	local selfAid = allianceMgr:getOwnTeamID()
	local toAid = kingdomMapUtil.getTargetAid(targetData, fromAid, selfAid)
	if fromAid == toAid then
		if self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self:showAttack(self.tableMainData.from)
			self:showDefend(self.tableMainData.to)
		end
	elseif fromAid == selfAid then
		if self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self:showAttack(self.tableMainData.from)
			self:showDefend(self.tableMainData.to)
		end
	elseif toAid == selfAid and self.tableMainData.status ~= gMapMoveLineStatusType.moveLineStatusTypeMoving then
		self:showDefend(targetData, true)
	end
end
function remainsMiniMapRally:addBuild(mainData, key)
	local effect = SoraDCreatAnimation(key)
	effect:addTo(self.nodeWar)
	self.mainView:setNodePos(effect, cc.p(mainData.x, mainData.y))
end
function remainsMiniMapRally:showAttack(mainData)
	local objType = mainData.objType
	if objType == gMapObjTypeDef.mapObjTypePlayer then
		self:addBuild(mainData, "nodeEffect_01")
	end
end
function remainsMiniMapRally:showDefend(mainData, showBuild)
	local objType = mainData.objType
	if objType == gMapObjTypeDef.mapObjTypePlayer then
		if showBuild then
			self:addBuild(mainData, "nodeEffect_02")
		end
	elseif objType == gMapObjTypeDef.mapObjTypeBoss or objType == gMapObjTypeDef.mapObjTypeRemainsWar then
		self:addBuild(mainData, "nodeEffect_03")
	end
end
function remainsMiniMapRally:getShowTarget()
	if self.tableMainData:isTargetCapture() then
		local queuesFix = self.queueRoot:getWorkingCaptainQueue(self.tableMainData)
		if queuesFix then
			self.hasCapture = true
			return queuesFix:getFrom()
		end
	end
	self.hasCapture = false
	return self.tableMainData.to
end
function remainsMiniMapRally:resetData()
	self.tableMainData = nil
	self.targetData = nil
	self:resetNode()
end
return remainsMiniMapRally
