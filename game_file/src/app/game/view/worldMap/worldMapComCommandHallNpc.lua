local gametop = gModuleMgr.getObject("gametop")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local instanceFactory = include("instanceFactory")
local worldMapComCommandHallNpc = class("worldMapComCommandHallNpc", include("worldMapCom"))
function worldMapComCommandHallNpc:ctor()
	worldMapComCommandHallNpc.super.ctor(self, "worldMapComCommandHallNpc")
end
function worldMapComCommandHallNpc:init()
	worldMapComCommandHallNpc.super.init(self)
	self.currentShowTilesArray, worldMapComCommandHallNpc, self.worldMapCell = self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, self.target_.currentInMapViewCell
	self.curLod = nil
	self.moveLine = nil
	self:initCommandHallNpc()
	self:initCommandHallNpcQueue()
end
function worldMapComCommandHallNpc:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodLevel))
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellSwap))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:toggle3D()
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_INITDATA_UPDATE", handler(self, self.onMsgInitNpc))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_NPC_UPDATE", handler(self, self.onMsgUpdateNpc))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE", handler(self, self.onMsgUpdateCommitTask))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_UPDATE_SHOW_ATTACK", handler(self, self.onMsgUpdateShowAttack))
end
function worldMapComCommandHallNpc:resetData()
	worldMapComCommandHallNpc.super.resetData(self)
end
function worldMapComCommandHallNpc:updateLodLevel(event)
	local lodLevel = self.target_:getCurLod()
	if self.curLod == lodLevel then
		return
	end
	self.curLod = lodLevel
	self.Node_CommandHallNpc:setVisible(self.curLod <= 1)
end
function worldMapComCommandHallNpc:updateInfo(event)
	self:checkVisibleMoveLine()
end
function worldMapComCommandHallNpc:updateCellSwap(...)
	if not self:checkInSelfKingdom() then
		self:removeMoveLine()
		self:removeCommandHallNpc()
	else
		self:initCommandHallNpcQueue()
		self:refreshCommandHallNpc()
	end
end
function worldMapComCommandHallNpc:toggle3D(...)
	for __, instance in pairs(self.currentShowTilesArray) do
		if instance and instance.__cname then
			instance:toggle3D()
		end
	end
end
function worldMapComCommandHallNpc:onMsgInitNpc(...)
	if not self:checkInSelfKingdom() then
		return
	end
	self:refreshCommandHallNpc()
	self:initCommandHallNpcQueue()
end
function worldMapComCommandHallNpc:checkVisibleMoveLine(...)
	if self.moveLine then
		local troopInstance = self.moveLine:getTroopInstance()
		if troopInstance and troopInstance:isVisible() then
			troopInstance:updateCheckVisible()
		end
	end
end
function worldMapComCommandHallNpc:setMoveLine(moveLine)
	self.moveLine = moveLine
end
function worldMapComCommandHallNpc:getCommandHallMoveLine(moveLineID)
	if self.moveLine then
		if moveLineID and moveLineID ~= self.moveLine:getMoveLineID() then
			return
		end
		local troopInstance = self.moveLine:getTroopInstance()
		if troopInstance then
			local matrixState = troopInstance:getMatrixState()
			if matrixState == gMapMoveLineStatusType.moveLineStatusTypeMoving then
				return self.moveLine
			end
		end
	end
end
function worldMapComCommandHallNpc:removeMoveLine(...)
	if self.moveLine then
		local troopInstance = self.moveLine:getTroopInstance()
		if troopInstance then
			troopInstance:finshWork()
		end
		self.moveLine:deleteMoveLine()
		self.moveLine = nil
	end
end
function worldMapComCommandHallNpc:initCommandHallNpcQueue()
	self:removeMoveLine()
	if not self:checkInSelfKingdom() then
		return
	end
	if worldMapDefine.inInCrossWar() then
		return
	end
	local commandHallUtil = include("commandHallUtil")
	if not commandHallUtil.getConfigShowAttack() then
		return
	end
	local moveLineData = commandHallUtil.getCommandHallNpcQueueData()
	if not moveLineData then
		return
	end
	local mapViewCell = self.target_:getWorldMapCell(moveLineData.kingdomId)
	if not mapViewCell then
		return
	end
	local movelineFactory = include("movelineFactory")
	local moveLine = movelineFactory.createMapMoveLine(mapViewCell, moveLineData, nil, false, self.target_.mapClassType, 1)
	self:setMoveLine(moveLine)
end
function worldMapComCommandHallNpc:initCommandHallNpc(...)
	local node = display.newNode()
	node:addTo(self.worldMapCell, -1)
	node:setName("Node_CommandHallNpc")
	self.Node_CommandHallNpc = node
	self:refreshCommandHallNpc()
	self:updateLodLevel()
end
function worldMapComCommandHallNpc:refreshCommandHallNpc(...)
	self:removeCommandHallNpc()
	if worldMapDefine.inInCrossWar() then
		return
	end
	local taskList = commandHallCtrl:getTaskList()
	for i, task in ipairs(taskList) do
		self:addNpc(task)
	end
	dump(self.currentShowTilesArray, "==self.currentShowTilesArray==")
end
function worldMapComCommandHallNpc:removeCommandHallNpc(...)
	for __, instance in pairs(self.currentShowTilesArray) do
		if instance and instance.__cname then
			instance:removeFromParent()
		end
	end
	self.currentShowTilesArray, _ENV = pairs(self.currentShowTilesArray)
end
function worldMapComCommandHallNpc:onMsgUpdateNpc(target, event)
	dump(event, "==worldMapComCommandHallNpc:updateNpc==")
	if not self:checkInSelfKingdom() then
		return
	end
	local data = event.data
	if event.msgType == gMapSyncMsgType.REMOVE_MAPOBJ then
		self:removeNpc(data)
	elseif event.msgType == gMapSyncMsgType.ADD_MAPOBJ then
		self:addNpc(data.task)
	elseif event.msgType == gMapSyncMsgType.UPDATE_MAPOBJ then
		local instance = self:getCommandHallNpc(data.pos)
		if instance then
			if data.statue == gMapObjStateTypeDef.gMapObjStateTypeFighting then
				_ENV = nil
				;(nil).statue = gMapObjStateTypeDef.gMapObjStateTypeFree
				instance:addFireEffect(8, nil)
			elseif data.statue == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
				_ENV = nil
				;(nil).statue = data.statue
				instance:addFireEffect(8, nil)
			end
		end
	end
end
function worldMapComCommandHallNpc:addNpc(task)
	if task and task.obj and task.obj.x and task.statue == gCommandHallTaskStatue.BEGIN then
		local commandHallUtil = include("commandHallUtil")
		if not commandHallUtil.checkTaskTypeShowNpc(task.type) then
			return
		end
		local tilePoint = mapSyncUtilClient.serverTOClientPos(cc.p(task.obj.x, task.obj.y))
		local holdInstace = 1
		local instance = SoraDCreatePanel("worldMapCommandHallNpc")
		instance:addTo(self.Node_CommandHallNpc, task.obj.x + task.obj.y)
		local instancePoint = self.worldMapCell:getPointWithTile(tilePoint, holdInstace)
		instance:setPosition(instancePoint)
		local tilesArray = instanceFactory.getTilesArrayByInstace(tilePoint, holdInstace)
		instance:setTilesArray(tilesArray)
		instance:setTilePoint(tilePoint)
		instance:setHoldInstace(holdInstace)
		local faceType = task.obj.faceTo
		local isFlipX
		if faceType == gMapNpcFaceTypeDef.monsterFaceType_RightBottom then
			isFlipX = true
		else
			isFlipX = false
		end
		_ENV = cc.p(task.obj.x, task.obj.y)
		cc.p(task.obj.x, task.obj.y).taskID = task.taskID
		cc.p(task.obj.x, task.obj.y).taskIndex = task.index
		cc.p(task.obj.x, task.obj.y).isFlipX = isFlipX
		instance:initInstanceData(cc.p(task.obj.x, task.obj.y))
		instance:toggle3D()
		local tilesArray = instance:getTilesArray()
		for _, v in pairs(tilesArray) do
			self.currentShowTilesArray[v] = instance
		end
	end
end
function worldMapComCommandHallNpc:removeNpc(data)
	local instance = data.instance
	if instance and instance.__cname then
		self:removeNpcByInstance(instance)
	end
	local pos = data.pos
	if pos then
		local instance = self:getCommandHallNpc(pos)
		if instance and instance.__cname then
			self:removeNpcByInstance(instance)
		end
	end
end
function worldMapComCommandHallNpc:removeNpcByInstance(instance)
	local tilesArray = instance:getTilesArray()
	for _, v in pairs(tilesArray) do
		self.currentShowTilesArray[v] = nil
	end
	instance:removeFromParent()
end
function worldMapComCommandHallNpc:getCommandHallNpc(tilePoint)
	local key = tilePoint.x .. "," .. tilePoint.y
	local instance = self.currentShowTilesArray[key]
	if instance and instance.__cname then
		return instance
	end
end
function worldMapComCommandHallNpc:getCommandHallNpcByIndex(index)
	for __, instance in pairs(self.currentShowTilesArray) do
		if instance and instance.__cname and instance:getTaskIndex() == index then
			return instance
		end
	end
end
function worldMapComCommandHallNpc:onMsgUpdateCommitTask(target, event)
	if not self:checkInSelfKingdom() then
		return
	end
	if event.showFighting then
		return
	end
	if not event.diffList then
		local _ENV, diffList = event.diffList, event.diffList
	end
	if not diffList.removeList then
		local _ENV, removeList = diffList.removeList, diffList.removeList
	end
	if not diffList.addList then
		local _ENV, addList = diffList.addList, diffList.addList
	end
	if not diffList.updateList then
		local _ENV, updateList = diffList.updateList, diffList.updateList
	end
	for __, _index in ipairs(removeList) do
		local instance = self:getCommandHallNpcByIndex(_index)
		_ENV = nil
		;(nil).instance = instance
		self:removeNpc(nil)
	end
	for __, _index in ipairs(addList) do
		local task = commandHallCtrl:getTaskByIndex(_index)
		if task.type == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
			self:initCommandHallNpcQueue()
		else
			self:addNpc(task)
		end
	end
	for __, _index in ipairs(updateList) do
		local task = commandHallCtrl:getTaskByIndex(_index)
		if task and task.obj and task.obj.x and task.statue == gCommandHallTaskStatue.FINISH then
			local tilePoint = mapSyncUtilClient.serverTOClientPos(cc.p(task.obj.x, task.obj.y))
			_ENV = cc.p(task.obj.x, task.obj.y)
			cc.p(task.obj.x, task.obj.y).pos = tilePoint
			self:removeNpc(cc.p(task.obj.x, task.obj.y))
		end
	end
end
function worldMapComCommandHallNpc:onMsgUpdateShowAttack(...)
	if not self:checkInSelfKingdom() then
		return
	end
	self:initCommandHallNpcQueue()
end
function worldMapComCommandHallNpc:checkInSelfKingdom(...)
	local currentInMapViewCell = self.target_.currentInMapViewCell
	local curMapID = currentInMapViewCell:getKingdomID()
	if curMapID == gametop.playertop_:getKingdomID() then
		return true
	else
		return false
	end
end
function worldMapComCommandHallNpc:exportMethods(...)
	_UPVALUE2_ = nil
	;(nil)[1] = "getCommandHallNpc"
	;(nil)[2] = "getCommandHallMoveLine"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComCommandHallNpc
