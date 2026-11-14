_ENV = nil
;(nil).shotBeginPos = cc.p(329, 195)
;(nil).shotBeginShowPos = cc.p(350, 398)
;(nil).shotBeginScale = 0.8
;(nil).dtJiannuShow = 0.5666666666666667
;(nil).dtJiannuShot = 0.26666666666666666
;(nil).dtJiannuMove = 0.25
;(nil).timeSpeedNormal = 1.44
;(nil).timeSpeedFast = 2.0
;(nil).tag_move_act = 10
;(nil).distanceScaleMin = 0.3
local (nil).distanceScaleMax, _defaultParam = 1.3, nil
local allianceHuntDesRead = include("allianceHuntDesRead")
local nodeBolt = class("nodeBolt", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeBolt")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		print("nodeBolt直接返回对象------")
		return target
	end
end)
function nodeBolt:ctor()
	self:createUI()
	self.nodeAnimArrow = SoraDGetChildByName(self, "node_anim_arrow")
	self.spArrow = SoraDGetChildByName(self, "sp_arrow")
	self.tbJiannu, _ENV, self.powerMode = HUNTING_POWER_MODE.NORMAL, HUNTING_POWER_MODE.NORMAL, HUNTING_POWER_MODE.NORMAL
	self.speedScale = _defaultParam.timeSpeedNormal
	self.isInCD = false
end
function nodeBolt:setBattleView(battleView)
	self.battleView = battleView
end
function nodeBolt:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeBolt:init(data)
end
function nodeBolt:setPowerMode(powerMode)
	self.powerMode = powerMode
end
function nodeBolt:getPowerMode()
	return self.powerMode
end
function nodeBolt:updateBoltPos(touchPos, bResetAction)
	self.targetPos = touchPos
	local oriPosX = self:getPositionX()
	self:setPositionX(0)
	local nodeTargetPos = self:convertToNodeSpace(self.targetPos)
	local targetX = nodeTargetPos.x - _defaultParam.shotBeginPos.x
	print("touchPos.x = ", touchPos.x, ",targetX = ", targetX)
	bResetAction = false
	if bResetAction then
		local dt = 0.2
		self:setPositionX(oriPosX)
		self:setPositionY(0)
		local actMoveTo1 = cca.moveTo(dt / 2, cc.p(oriPosX + (targetX - oriPosX) / 2, -200))
		local actMoveTo2 = cca.moveTo(dt / 2, cc.p(targetX, 0))
		_UPVALUE2_ = cc.p(targetX, 0)
		cc.p(targetX, 0)[1] = actMoveTo1
		cc.p(targetX, 0)[2] = actMoveTo2
		local seq = cca.seq(cc.p(targetX, 0))
		seq:setTag(_defaultParam.tag_move_act)
		self:runAction(seq)
	else
		self:setPositionY(0)
		self:stopAllActionsByTag(_defaultParam.tag_move_act)
		self:setPositionX(targetX)
	end
end
function nodeBolt:playShotAnim(touchPos, speedMode)
	if self.isInCD then
		return
	end
	self.isInCD = true
	self.targetPos = touchPos
	if speedMode == gAllianceHuntSpeedMode.NORMAL then
		self.speedScale = _defaultParam.timeSpeedNormal
		SoraDPlaySound("huntSound", "hunt_shoot_long")
	elseif speedMode == gAllianceHuntSpeedMode.FAST then
		self.speedScale = _defaultParam.timeSpeedFast
		SoraDPlaySound("huntSound", "hunt_shoot_short")
	end
	self.spArrow:setVisible(false)
	if not self.nodeBoltAnim or not self.nodeBoltAnim.action then
		_ENV = self.spArrow
		self.spArrow.cssFileName = "nodeBoltAnim"
		self.spArrow.loop = false
		self.spArrow.scheduler = self.myScheduler
		self.spArrow.actionManager = self.myActionManager
		self.spArrow.speed = self.speedScale
		self.nodeBoltAnim = SoraDCreatAnimationParam(self.spArrow)
		self.nodeBoltAnim:addTo(self)
	else
		local action = self.nodeBoltAnim.action
		if action and tolua.cast(action, "cc.Action") then
			print("有缓存对象")
			action:setTimeSpeed(self.speedScale)
			action:gotoFrameAndPlay(0, false)
		end
	end
	self:setPositionX(0)
	local nodeTargetPos = self:convertToNodeSpace(self.targetPos)
	local targetX = nodeTargetPos.x - _defaultParam.shotBeginPos.x
	print("targetX = ", targetX)
	self:setPositionX(targetX)
	self:playShotArrow(speedMode)
end
function nodeBolt:playShotArrow(speedMode)
	if not self.battleView then
		return
	end
	self.nodeJiannuBeginPos = SoraDCoverToPoint(self, _defaultParam.shotBeginPos, self.battleView)
	local nodeJiannu = self:getJiannu()
	nodeJiannu:setPosition(self.nodeJiannuBeginPos)
	nodeJiannu:setVisible(false)
	nodeJiannu:setRotation(0)
	nodeJiannu:setScale(1)
	nodeJiannu:setPowerMode(self.powerMode)
	nodeJiannu:setPowerVisible(false)
	if self.powerMode == HUNTING_POWER_MODE.NORMAL then
		nodeJiannu:setPowerVisible(false)
	else
		nodeJiannu:setPowerVisible(true)
	end
	print("执行射箭动画-----------------")
	local showCallFunc = cca.callFunc(function()
		nodeJiannu:setVisible(true)
	end)
	local viewPos = self.battleView:convertToNodeSpace(self.targetPos)
	local distanceScale = math.max(_defaultParam.distanceScaleMin, math.min(_defaultParam.distanceScaleMax, viewPos.y / 760))
	local dtMove = distanceScale * _defaultParam.dtJiannuMove / self.speedScale
	print("distanceScale = ", distanceScale)
	local moveCallFunc = cca.callFunc(function()
		print("弓箭射出-----")
		dump(viewPos, "viewPos")
		local deltaY = _defaultParam.shotBeginShowPos.y - _defaultParam.shotBeginPos.y
		local showPosY = nodeJiannu:getPositionY() + deltaY
		nodeJiannu:setPositionY(showPosY)
		print("nodeJiannu:showPosY  = ", showPosY)
		nodeJiannu:setScale(_defaultParam.shotBeginScale)
		local dt = dtMove
		local moveTo = cca.moveTo(dt, viewPos)
		nodeJiannu:runAction(moveTo)
		local scaleTo = cca.scaleTo(dt, 0.4)
		nodeJiannu:runAction(scaleTo)
		print("要播放特效了----")
		local effectCallFunc = cca.callFunc(function()
			print("effectCallFunc")
			self:playShotEffect(viewPos, nodeJiannu:getPowerMode())
		end)
		_defaultParam = nil
		;(nil)[1] = cca.delay(math.max(0, dt - 0.1))
		;(nil)[2] = effectCallFunc
		nodeJiannu:runAction(cca.seq(nil))
	end)
	local endCallFunc = cca.callFunc(function()
		print("弓箭射击到终点了")
		if self.battleView and self.battleView.onShotCallBack then
			self.battleView:onShotCallBack(nodeJiannu:getPowerMode())
		end
		nodeJiannu:setVisible(false)
		table.insert(self.tbJiannu, nodeJiannu)
		self.isInCD = false
	end)
	local dtDelayShow = _defaultParam.dtJiannuShow / self.speedScale
	local dtDelayShot = _defaultParam.dtJiannuShot / self.speedScale
	self.nodeJiannu = nodeJiannu
	_UPVALUE7_ = math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[1] = cca.delay(dtDelayShow)
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[2] = showCallFunc
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[3] = cca.delay(dtDelayShot)
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[4] = moveCallFunc
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[5] = cca.delay(dtMove)
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[6] = cca.delay(0.02)
	math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)[7] = endCallFunc
	nodeJiannu:runAction(cca.seq(math.min(_defaultParam.distanceScaleMax, viewPos.y / 760)))
end
function nodeBolt:playShotEffect(viewPos, powerMode)
	if powerMode == HUNTING_POWER_MODE.FULL then
		_ENV = nil
		;(nil).cssFileName = "node_attacked_effect_big"
		;(nil).loop = false
		;(nil).scheduler = self.myScheduler
		;(nil).actionManager = self.myActionManager
		;(nil).speed = 1.0
		local effectNode = SoraDCreatAnimationParam(nil)
		effectNode:addTo(self.battleView, allianceHuntDesRead.zOrder.z_shot_effect)
		effectNode:setPosition(viewPos)
		self.effectNode = effectNode
		allianceHuntDesRead = allianceHuntDesRead.zOrder.z_shot_effect
		allianceHuntDesRead.zOrder.z_shot_effect[1] = cca.delay(0.5833333333333334)
		allianceHuntDesRead.zOrder.z_shot_effect[2] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		allianceHuntDesRead.zOrder.z_shot_effect[3] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		allianceHuntDesRead.zOrder.z_shot_effect[4] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		allianceHuntDesRead.zOrder.z_shot_effect[5] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		effectNode:runAction(cca.seq(allianceHuntDesRead.zOrder.z_shot_effect))
		local childs = effectNode:getChildren()
		SoraDSetNodeArrayAdditive(childs)
		for i = 1, 3 do
			local etParticle = SoraDGetChildByName(effectNode, "Particle_" .. i)
			etParticle:resetSystem()
		end
	else
		_ENV = effectNode:getChildren()
		effectNode:getChildren().cssFileName = "node_attacked_effect"
		effectNode:getChildren().loop = false
		effectNode:getChildren().scheduler = self.myScheduler
		effectNode:getChildren().actionManager = self.myActionManager
		effectNode:getChildren().speed = 1.0
		local effectNode = SoraDCreatAnimationParam((effectNode:getChildren()))
		effectNode:addTo(self.battleView, allianceHuntDesRead.zOrder.z_shot_effect)
		effectNode:setPosition(viewPos)
		self.effectNode = effectNode
		allianceHuntDesRead = allianceHuntDesRead.zOrder.z_shot_effect
		allianceHuntDesRead.zOrder.z_shot_effect[1] = cca.delay(0.5833333333333334)
		allianceHuntDesRead.zOrder.z_shot_effect[2] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		allianceHuntDesRead.zOrder.z_shot_effect[3] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		allianceHuntDesRead.zOrder.z_shot_effect[4] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		allianceHuntDesRead.zOrder.z_shot_effect[5] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.effectNode = nil
		end)
		effectNode:runAction(cca.seq(allianceHuntDesRead.zOrder.z_shot_effect))
		local childs = effectNode:getChildByName("shouji"):getChildren()
		SoraDSetNodeArrayAdditive(childs)
	end
end
function nodeBolt:updateArrowNum(num)
	if 1 <= num then
		self.spArrow:setSpriteFrame("shoulie_nujian_01.png")
	else
		self.spArrow:setSpriteFrame("shoulie_nujian_16.png")
	end
end
function nodeBolt:onMessageListener()
end
function nodeBolt:getJiannu()
	local nodeJiannu
	if #self.tbJiannu > 0 then
		nodeJiannu = table.remove(self.tbJiannu)
	else
		nodeJiannu = include("nodeJiannu").new()
		nodeJiannu:addTo(self.battleView, allianceHuntDesRead.zOrder.z_arrow)
		SoraDSetNodeSchedulerAndManager(nodeJiannu, self.myScheduler, self.myActionManager)
	end
	return nodeJiannu
end
function nodeBolt:getIsInCD()
	return self.isInCD
end
function nodeBolt:initSchedulerAndManager(customScheduler, actionManager)
	self.myScheduler = customScheduler
	_UPVALUE2_, self.myActionManager = nil, actionManager
	;(nil)[1] = self
	local (nil)[2], nodes = self.nodeBoltAnim, nil
	SoraDSetNodesSchedulerAndManager(nodes, self.myScheduler, self.myActionManager)
end
function nodeBolt:pause()
	_UPVALUE4_ = nil
	;(nil)[1] = self
	;(nil)[2] = self.nodeBoltAnim
	;(nil)[3] = self.nodeJiannu
	local (nil)[4], target = self.effectNode, nil
	for k, v in pairs(target) do
		v:getActionManager():pauseTarget(v)
	end
end
function nodeBolt:resume()
	_UPVALUE4_ = nil
	;(nil)[1] = self
	;(nil)[2] = self.nodeBoltAnim
	;(nil)[3] = self.nodeJiannu
	local (nil)[4], target = self.effectNode, nil
	for k, v in pairs(target) do
		v:getActionManager():resumeTarget(v)
	end
end
return nodeBolt
