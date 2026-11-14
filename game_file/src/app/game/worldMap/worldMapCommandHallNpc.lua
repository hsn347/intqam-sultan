local commandHallRead = include("commandHallRead")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local commandHallUtil = include("commandHallUtil")
local worldMapCommandHallNpc = class("worldMapCommandHallNpc", function()
	local target = include("worldMapInstance").new("worldMapCommandHallNpc")
	return target
end)
function worldMapCommandHallNpc:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapCommandHallNpc:_initData()
	self.statue = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.framesNumber = 16
	self.framesTimes = 0.06666666666666667
	self.taskID = 0
	self.imgNameAngle = nil
	self.isFlipX = nil
end
function worldMapCommandHallNpc:_initUI()
	local sprite = display.newSprite("#bhmt_dj_ws.png")
	self:addChild(sprite, -1)
	self.npcImage = sprite
	local taskNode = commandHallUtil.createTaskNode()
	taskNode:addTo(self)
	taskNode:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 70))
	taskNode:setScale(0.75)
	self.taskNode = taskNode
end
function worldMapCommandHallNpc:initInstanceData(data)
	dump(data, "==worldMapCommandHallNpc:initInstanceData==")
	if data.taskIndex then
		self.taskIndex = data.taskIndex
	end
	if data.taskID then
		self.taskID = data.taskID
		self.taskNode:setTaskID(self.taskID)
		local taskType = commandHallRead.getTaskType(self.taskID)
		self.imgName = commandHallRead.getTaskNpcResource(taskType)
		if string.find(self.imgName, ".png") then
			self.isBuild = true
			self.npcImage:setSpriteFrame(self.imgName)
		else
			self.isBuild = false
			self.npcImage:setSpriteFrame(self.imgName .. "_dj_ws_01.png")
		end
		if taskType == gCommandHallTaskType.RESCUE_TASK then
			self.npcImage:setPosition(-10, 0)
			self.npcImage:setScale(0.8)
		elseif taskType == gCommandHallTaskType.SNIPE_HUNTER_TASK then
			self.npcImage:setPosition(-10, 30)
		end
		if taskType == gCommandHallTaskType.RESCUE_TASK then
			self.taskNode:setPosition(0, 80)
		elseif taskType == gCommandHallTaskType.REBEL_ARMY_PIONEER_TASK then
			self.taskNode:setPosition(0, 90)
		end
	end
	self.isFlipX = data.isFlipX
	self:updateData(data)
end
function worldMapCommandHallNpc:updateData(data)
	if data.statue then
		self.statue = data.statue
	end
	self:updateStatue()
end
function worldMapCommandHallNpc:updateStatue(...)
	if self.isBuild then
		return
	end
	if self.statue == gMapObjStateTypeDef.gMapObjStateTypeFree then
		self:doStandingAnimation()
	elseif self.statue == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		self:doDieingAnimation()
	end
end
function worldMapCommandHallNpc:doStandingAnimation(...)
	self:doStopAllActions()
	local frames = display.newFrames(self.imgName .. "_dj_ws_%02d.png", 1, self.framesNumber)
	local animation = display.newAnimation(frames, self.framesTimes)
	self.npcImage:playAnimationForever(animation)
	self.npcImage:setFlippedX(self.isFlipX)
end
function worldMapCommandHallNpc:doDieingAnimation(...)
	self:doStopAllActions()
	local frames = display.newFrames(self.imgName .. "_sw_ws_%02d.png", 1, self.framesNumber)
	local animation = display.newAnimation(frames, self.framesTimes)
	self.npcImage:playAnimationOnce(animation, false, handler(self, self.finishedAfterDead), 0.0)
end
function worldMapCommandHallNpc:finishedAfterDead()
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(1.0)
	;(nil)[2] = cca.callFunc(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_COMMANDHALL_NPC_UPDATE"
		_ENV, (nil).msgType = gMapSyncMsgType.REMOVE_MAPOBJ, gMapSyncMsgType.REMOVE_MAPOBJ
		;(nil).data, gMapSyncMsgType.REMOVE_MAPOBJ.instance = gMapSyncMsgType.REMOVE_MAPOBJ, self
		SoraDSendMessage(nil)
	end)
	;(nil)[3] = cca.callFunc(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_COMMANDHALL_NPC_UPDATE"
		_ENV, (nil).msgType = gMapSyncMsgType.REMOVE_MAPOBJ, gMapSyncMsgType.REMOVE_MAPOBJ
		;(nil).data, gMapSyncMsgType.REMOVE_MAPOBJ.instance = gMapSyncMsgType.REMOVE_MAPOBJ, self
		SoraDSendMessage(nil)
	end)
	local seq = cca.seq(nil)
	self:runAction(seq)
end
function worldMapCommandHallNpc:doStopAllActions(...)
	self.npcImage:stopAllActions()
end
function worldMapCommandHallNpc:addFireEffect(fightTime, data)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local facePoint = cityCtrl:getCurCityPos()
	self:beginAttack(facePoint)
	_UPVALUE1_ = self
	self[1] = cca.delay(fightTime)
	self[2] = cca.callFunc(function()
		self:updateData(data)
	end)
	self[3] = cca.callFunc(function()
		self:updateData(data)
	end)
	local seq = cca.seq(self)
	self.npcImage:runAction(seq)
end
function worldMapCommandHallNpc:beginAttack(facePoint)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		facePoint = worldMapView:getPointWithTile(facePoint)
	end
	local pointX, pointY = self:getPosition()
	local beginPoint = cc.p(pointX, pointY)
	local endPoint = facePoint
	local rotation, fightingImgNameAngle, isFlipX = worldMapFunction.getMonsterImgAngel(beginPoint, endPoint)
	self.npcImage:setFlippedX(isFlipX)
	self.fightingFrames = display.newFrames(self.imgName .. "_gj_" .. fightingImgNameAngle .. "_%02d.png", 1, self.framesNumber)
	self:doStopAllActions()
	self:doFightingAnimation()
	SoraDPlaySound("worldmap", 3)
end
function worldMapCommandHallNpc:doFightingAnimation(...)
	local animation = display.newAnimation(self.fightingFrames, self.framesTimes)
	self.npcImage:playAnimationOnce(animation, false, function()
		self:doFightingAnimation()
	end)
end
function worldMapCommandHallNpc:onClickInstance(...)
	local kingdomMapCell = kingdomMapCtrl:getKingdomMapCell()
	if kingdomMapCell:hasFromUserCommandHallQueue(self.taskIndex, nil) then
		SoraDShowMsgTip(i18n("commandhall_text_74"))
		return nil, false
	end
	local taskType = commandHallRead.getTaskType(self.taskID)
	if taskType == gCommandHallTaskType.SNIPE_HUNTER_TASK and kingdomMapCell:hasFromUserCommandHallQueue(nil, taskType) then
		SoraDShowMsgTip(i18n("commandhall_text_77"))
		return nil, false
	end
	local selectShowPanel = uiManager:show("worldMapCommandHallNpcView").view
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initData(self)
	selectShowPanel:upateInfoPanel(self.taskID, self.taskIndex)
	return selectShowPanel, true
end
function worldMapCommandHallNpc:getTaskIndex(...)
	return self.taskIndex
end
return worldMapCommandHallNpc
