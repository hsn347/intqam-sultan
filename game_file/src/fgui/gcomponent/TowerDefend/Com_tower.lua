local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_tower = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_tower", Com_tower)
fgui.register_extension("ui://TowerDefend/Com_mainTower", Com_tower)
local MAX_TOWER_LEVEL = 5
_ENV = "ui://TowerDefend/Com_mainTower"
;("ui://TowerDefend/Com_mainTower").BUILD = 1
;("ui://TowerDefend/Com_mainTower").UPGRADE = 2
local _ENV, ("ui://TowerDefend/Com_mainTower").RETROFIT, BuildType = Com_tower, 3, "ui://TowerDefend/Com_mainTower"
Com_tower.BALLISTA = 101
Com_tower.FORT = 102
Com_tower.MAGETOWER = 103
local _ENV, Com_tower.MAINTOWER, TowerID = nil, 104, Com_tower
;(nil)[101] = "弩箭"
;(nil)[102] = "炮台"
local (nil)[103], towerName = "法师塔", nil
local towerLv = towerDefendRead.towerLv
local towerConfig = towerDefendRead.towerConfig
local timeScaleFactor = 5
function Com_tower:onInit()
	_ENV = nil
	;(nil).lvIndex = 0
	;(nil).curLevel = 0
	self.towerData, (nil).nextLvIndex = nil, 1
	self.towerID = nil
	self.fields.touch_show:addClickListener(handler(self, self.onClickSpace))
	if self.fields.touch_show2 then
		self.fields.touch_show2:addClickListener(handler(self, self.onClickSpace))
		self.fields.touch_show3:addClickListener(handler(self, self.onClickSpace))
		self.fields.touch_show4:addClickListener(handler(self, self.onClickSpace))
	end
	self.fields.Ani_load:setTimeScale(timeScaleFactor)
	self.lastAttackMonster = nil
end
function Com_tower:setMainTowerFlag()
	self.mainTower = true
	self.towerData.lvIndex = 0
	self.towerData.nextLvIndex = towerDefendRead.getLvIndex(104, 1)
	self.fields.touch_show4:addClickListener(handler(self, self.onClickSpace))
end
function Com_tower:initData(index)
	self:stopAllActions()
	self.buildShow = false
	if self.towerData.curLevel > 0 then
		self.fields.Label_level:setVisible(true)
		self.fields.Label_level:setString(self.towerData.curLevel)
	end
	self.fields.Label_level:getController("c1"):setSelectedIndex(not towerDefendRead.isMaxLv(self.towerData.curLevel, self.towerData.lvIndex) and 0 or 1)
	if self.towerID then
		self.controllers.tower:setSelectedIndex(self.towerID - 100)
		self.controllers.towerTouch:setSelectedIndex(self.towerID - 100)
		self.fields.Ani_load:setVisible(false)
		self:setAttack()
	end
	if self.towerID == 103 then
		self.fields.Ani_load:setRotation(0)
		self.fields.n11:setRotation(0)
		self.fields.Ani_load:setBlendFunc(gl.ONE, gl.ONE)
		if not self.posAdjust then
			self.fields.Ani_load:setPositionY(self.fields.Ani_load:getPositionY() - 30)
			self.posAdjust = true
		end
	end
end
function Com_tower:registerEvent()
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_PAUSE", handler(self, self.gamePause))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_CONTINUE", handler(self, self.gameContinue))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_FAIL", handler(self, self.gamePause))
end
function Com_tower:gamePause()
	self:stopAllActions()
	self.fields.Ani_load:setTimeScale(0)
end
function Com_tower:gameContinue()
	if self.towerID then
		self:setAttack()
	end
	self.fields.Ani_load:setTimeScale(timeScaleFactor)
end
function Com_tower:resetState()
	self.controllers.c1:setSelectedIndex(0)
	self.buildShow = false
end
function Com_tower:onClickSpace(sound)
	if sound == false then
	end
	local sound = true
	if sound then
		SoraDPlaySound()
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_TOWER_CLOSE"
	SoraDSendMessage(nil)
	self.buildShow = true
	if self.towerID == nil then
		BuildType, self.buildType = BuildType.BUILD, BuildType.BUILD
		self.arrayButtons, BuildType.BUILD[1] = BuildType.BUILD, self.fields.Com_build
		self:showAction()
		self.controllers.c1:setSelectedIndex(1)
		_ENV = nil
		;(nil).cost = towerLv[self.towerData.nextLvIndex].cost
		self.fields.Com_build:initData(1, nil, handler(self, self.onClickBuild))
	elseif not towerDefendRead.isTowerMaxLevel(self.towerData.curLevel, self.towerData.lvIndex) then
		BuildType, self.buildType = BuildType.UPGRADE, BuildType.UPGRADE
		self.arrayButtons, BuildType.UPGRADE[1] = BuildType.UPGRADE, self.fields.Com_build
		self:showAction()
		self.controllers.c1:setSelectedIndex(2)
		_ENV = nil
		;(nil).cost = towerLv[self.towerData.nextLvIndex].cost
		self.fields.Com_build:initData(4, nil, handler(self, self.onClickBuild))
	elseif self.towerID == TowerID.BALLISTA then
		towerLv = self.towerID
		self.arrayButtons, self.towerID[1] = self.towerID, self.fields.Com_retrofit1
		self.arrayButtons, self.towerID[2] = self.towerID, self.fields.Com_retrofit2
		self:showAction()
		self.controllers.c1:setSelectedIndex(3)
		local info1 = towerDefendRead.getLvInfo(TowerID.FORT, towerDefendRead.getAdvanceLevel(TowerID.FORT))
		local info2 = towerDefendRead.getLvInfo(TowerID.MAGETOWER, towerDefendRead.getAdvanceLevel(TowerID.MAGETOWER))
		self.fields.Com_retrofit1:initData(2, info1, handler(self, self.clickRetrofit))
		self.fields.Com_retrofit2:initData(3, info2, handler(self, self.clickRetrofit))
	else
		SoraDShowMsgTip(i18n("common_text_339"))
	end
	self:setCostTextColor()
end
local ACTION_TIME = 0.13
local tag_act_init_view = 30000
local tag_act_single_btn = 1000
local tag_act_tip_show_end = 999
function Com_tower:showAction()
	self.circleOffsetY = 280
	self.circleOffsetX = 100
	self.circleRadius = 260
	local numberOfBtns = #self.arrayButtons
	local radius = self.circleRadius
	local sep = 6
	if 4 <= numberOfBtns then
		sep = 7
	end
	local deltaAngle = 120 / sep
	local deltaAngleRadius = math.rad(deltaAngle)
	local beginAngleRadius = -math.pi + (math.pi - deltaAngleRadius * (numberOfBtns - 1)) / 2
	for i, v in ipairs(self.arrayButtons) do
		local itemAngleRad = beginAngleRadius + (i - 1) * deltaAngleRadius
		local xPosBegin = math.cos(itemAngleRad) * radius / 2 + 60
		local yPosBegin = math.sin(itemAngleRad) * radius / 2 + self.circleOffsetY
		local xPosEnd = math.cos(itemAngleRad) * radius + 60
		local yPosEnd = math.sin(itemAngleRad) * radius + self.circleOffsetY
		if #self.arrayButtons > 1 then
			yPosEnd = 15
		end
		v:setPosition(xPosBegin, yPosBegin)
		v:setScale(0.5)
		local scaleAction = ffa.scaleTo(ACTION_TIME, 1.0)
		local moveToActin = ffa.moveTo(ACTION_TIME, xPosEnd, yPosEnd)
		tag_act_single_btn = xPosEnd
		xPosEnd[1] = moveToActin
		xPosEnd[2] = scaleAction
		local spawnAction = ffa.spawn(xPosEnd)
		spawnAction:setTag(tag_act_single_btn)
		v:stopAllActionsByTag(tag_act_single_btn)
		v:runAction(spawnAction)
		v:setVisible(true)
	end
	self.circleFrameBg = self.fields.circle
	if self.circleFrameBg then
		self.circleFrameBg:stopAllActions()
		self.circleFrameBg:setVisible(true)
		self.circleFrameBg:setPosition(self.circleOffsetX, -self.circleRadius + 45 + self.circleOffsetY)
		self.circleFrameBg:runAction(ffa.moveBy(ACTION_TIME, 0, -30))
	end
end
function Com_tower:setCostTextColor()
	if self.fields.Com_build:isVisible() then
		self.fields.Com_build:setCostTextColor()
	end
	if self.fields.Com_retrofit1:isVisible() then
		self.fields.Com_retrofit1:setCostTextColor()
		self.fields.Com_retrofit2:setCostTextColor()
	end
end
function Com_tower:clickRetrofit(info)
	SoraDPlaySound()
	if towerDefendRead.gold < info.cost then
		SoraDShowMsgTip(i18n("EP_settle_tips_0002"))
		return
	end
	self:stopAllActions()
	if info.towerID == TowerID.FORT then
		self.fields.Ani_load:setPositionY(self.fields.Ani_load:getPositionY() + 10)
	elseif info.towerID == TowerID.MAGETOWER then
		self.fields.Ani_load:setRotation(0)
		self.fields.n11:setRotation(0)
	end
	towerDefendRead.gold = towerDefendRead.gold - info.cost
	_ENV = info.cost
	info.cost.msg = "MESSAGE_TOWER_DEFEND_GOLD_REFRESH"
	SoraDSendMessage(info.cost)
	self.towerID = info.towerID
	self.towerData.curLevel = info.level
	self.towerData.lvIndex = towerDefendRead.getLvIndex(self.towerID, info.level)
	self.towerData.nextLvIndex = self.towerData.lvIndex + 1
	self:showEffect()
	self:resetState()
	self:initData()
end
function Com_tower:onClickBuild()
	SoraDPlaySound()
	if towerDefendRead.gold < towerLv[self.towerData.nextLvIndex].cost then
		SoraDShowMsgTip(i18n("EP_settle_tips_0002"))
		return
	end
	if self.buildType == BuildType.BUILD then
		self.towerID = TowerID.BALLISTA
		if self.mainTower then
			self.towerID = TowerID.MAINTOWER
			_ENV = BuildType.BUILD
			BuildType.BUILD.msg = "MESSAGE_TOWER_DEFEND_ENERGY_TIMER"
			SoraDSendMessage(BuildType.BUILD)
		end
		self.controllers.state:setSelectedIndex(1)
	elseif self.buildType == BuildType.UPGRADE then
	end
	towerDefendRead.gold = towerDefendRead.gold - towerLv[self.towerData.nextLvIndex].cost
	_ENV = towerLv[self.towerData.nextLvIndex].cost
	towerLv[self.towerData.nextLvIndex].cost.msg = "MESSAGE_TOWER_DEFEND_GOLD_REFRESH"
	SoraDSendMessage(towerLv[self.towerData.nextLvIndex].cost)
	self.towerData.curLevel = self.towerData.curLevel + 1
	self.towerData.lvIndex = towerDefendRead.getLvIndex(self.towerID, self.towerData.curLevel)
	self.towerData.nextLvIndex = self.towerData.lvIndex + 1
	self:showEffect()
	self:initData()
	self:resetState()
end
function Com_tower:onClickBuildDefault()
	if self.buildType == BuildType.BUILD then
		self.towerID = TowerID.BALLISTA
		self.controllers.state:setSelectedIndex(1)
	end
	self.towerData.curLevel = self.towerData.curLevel + 1
	self.towerData.lvIndex = towerDefendRead.getLvIndex(self.towerID, self.towerData.curLevel)
	self.towerData.nextLvIndex = self.towerData.lvIndex + 1
	self:initData()
end
function Com_tower:getBuildState()
	if self.mainTower and self.towerID == 104 then
		return true
	else
		return false
	end
end
function Com_tower:showEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_jzsj_new_01.plist"
	;(nil).x = 2.136
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.167
	;(nil).plist = "et_jzsj_new_02.plist"
	_ENV, (nil).scale = nil, 1.2
	;(nil).x = -2
	_ENV, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, 12
	;(nil).plist = "et_jzsj_new_03.plist"
	_ENV, (nil).scale = nil, 1.4
	;(nil).x = -4
	;(nil).pos, (nil).y = nil, 30.7
	_ENV, (nil)[3], (nil).rotate = nil, nil, 0.72
	_ENV, (nil).plist = nil, "et_jzsj_new_04.plist"
	;(nil).x = 0.856
	_ENV, (nil).scale, (nil).y = nil, nil, 2.349
	;(nil).x = -6
	_ENV, (nil)[4], (nil).pos, (nil).y = nil, nil, nil, 55
	_ENV, (nil).plist = nil, "et_jzsj_new_05.plist"
	;(nil).x = 4.301
	_ENV, (nil).scale, (nil).y = nil, nil, 5.615
	;(nil).x = -9
	_ENV, (nil)[5], (nil).pos, (nil).y = nil, nil, nil, 61.75
	;(nil).plist = "et_jzsj_new_06.plist"
	_ENV, (nil).scale = nil, 2.5
	;(nil).x = -3
	_ENV, (nil)[6], (nil).pos, (nil).y = nil, nil, nil, 29.2
	_ENV, (nil).plist = nil, "et_jzsj_new_07.plist"
	;(nil).x = 4.654
	_ENV, (nil).scale, (nil).y = nil, nil, 2.603
	;(nil).x = 1.67
	;(nil)[7], (nil).pos, (nil).y = nil, nil, -4.17
	local param
	self.et_node = SoraDCreateEffectNode(param, nil, true)
	self.et_node:addTo(self)
	self.et_node:setName("Node_effect")
	local targetPos = cc.p(self.et_node:getPositionX() + 100, self.et_node:getPositionY() + 70)
	self.et_node:setPosition(targetPos)
	self.et_node:setVisible(true)
end
_ENV, Com_tower.setAttack = function(self)
	self:stopAllActions()
	local info = towerDefendRead.getTowerInfoByIDLevel(self.towerID, self.towerData.curLevel)
	_ENV = self.towerData.curLevel
	self.towerData.curLevel[1] = ffa.delay(info.coldDown)
	self.towerData.curLevel[2] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	self.towerData.curLevel[3] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	local seq = ffa.seq(self.towerData.curLevel)
	self:runAction(ffa.repeatForever(seq))
end, function(self)
	self:stopAllActions()
	local info = towerDefendRead.getTowerInfoByIDLevel(self.towerID, self.towerData.curLevel)
	_ENV = self.towerData.curLevel
	self.towerData.curLevel[1] = ffa.delay(info.coldDown)
	self.towerData.curLevel[2] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	self.towerData.curLevel[3] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	local seq = ffa.seq(self.towerData.curLevel)
	self:runAction(ffa.repeatForever(seq))
end
;(function(self)
	self:stopAllActions()
	local info = towerDefendRead.getTowerInfoByIDLevel(self.towerID, self.towerData.curLevel)
	_ENV = self.towerData.curLevel
	self.towerData.curLevel[1] = ffa.delay(info.coldDown)
	self.towerData.curLevel[2] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	self.towerData.curLevel[3] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	local seq = ffa.seq(self.towerData.curLevel)
	self:runAction(ffa.repeatForever(seq))
end).ALIVE = 1
local (function(self)
	self:stopAllActions()
	local info = towerDefendRead.getTowerInfoByIDLevel(self.towerID, self.towerData.curLevel)
	_ENV = self.towerData.curLevel
	self.towerData.curLevel[1] = ffa.delay(info.coldDown)
	self.towerData.curLevel[2] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	self.towerData.curLevel[3] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	local seq = ffa.seq(self.towerData.curLevel)
	self:runAction(ffa.repeatForever(seq))
end).DIE, MonsterState = 2, function(self)
	self:stopAllActions()
	local info = towerDefendRead.getTowerInfoByIDLevel(self.towerID, self.towerData.curLevel)
	_ENV = self.towerData.curLevel
	self.towerData.curLevel[1] = ffa.delay(info.coldDown)
	self.towerData.curLevel[2] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	self.towerData.curLevel[3] = ffa.callFunc(function()
		self:generateTowerAttack()
	end)
	local seq = ffa.seq(self.towerData.curLevel)
	self:runAction(ffa.repeatForever(seq))
end
function Com_tower:generateTowerAttack()
	local aliveMonster = towerDefendRead.getMonsterObject()
	if aliveMonster == nil or not next(aliveMonster) then
		return
	end
	local i, v
	local k = 0
	local info = towerDefendRead.getTowerInfoByIDLevel(self.towerID, self.towerData.curLevel)
	self.atkScope = info.atkScope
	self.range = info.range * towerDefendRead.getHeightScale() + 200
	self.range = self.range * (display.height / 1136)
	self.atk = info.atk
	self.slowDown = info.slowDown
	self.minDis = 0
	self.targetObj = nil
	self.secondsMinObject = nil
	for i, v in ipairs(aliveMonster) do
		local isIn, dis = self:distanceInRange(self, v.instance, self.range)
		if v.state == MonsterState.ALIVE and isIn and dis > self.minDis then
			self.minDis = dis
			self.secondsMinObject = self.targetObj
			self.targetObj = v
		end
	end
	if self.targetObj and self.lastAttackMonster == self.targetObj.instance then
		self.targetObj = self.secondsMinObject
	end
	if self.targetObj then
		self:playRotateAni(nil, nil, self.targetObj)
	end
end
function Com_tower:CalculateAttack1(targetObj)
	local v = targetObj
	_UPVALUE0_ = nil
	;(nil).atk = self.atk
	;(nil).slowDown = self.slowDown
	;(nil).atkScope = self.atkScope
	self:generateATowerAttack(v.instance, nil, false, false, self.range, self, targetObj)
	self:playStandbyAni()
	if v.instance:getInfo().hp <= self.atk then
		self.lastAttackMonster = v.instance
	end
end
function Com_tower:CalculateAttack2(targetObj)
	local v = targetObj
	if v == nil then
		dump(self.towerID, "skfsjkdfjskfjkdfjk")
	end
	_ENV = nil
	;(nil).atk = self.atk
	;(nil).slowDown = self.slowDown
	;(nil).atkScope = self.atkScope
	self:generateATowerAttack(v.instance, nil, false, true, self.atkScope, self, targetObj)
	self:playStandbyAni()
	if v.instance:getInfo().hp <= self.atk then
		self.lastAttackMonster = v.instance
	end
end
function Com_tower:CalculateAttack3(targetObj)
	local v = targetObj
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.15)
	;(nil)[2] = ffa.callFunc(function()
		self = nil
		;(nil).atk = self.atk
		;(nil).slowDown = self.slowDown
		;(nil).atkScope = self.atkScope
		self:generateATowerAttack(v.instance, nil, false, true, self.atkScope, self, targetObj)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self = nil
		;(nil).atk = self.atk
		;(nil).slowDown = self.slowDown
		;(nil).atkScope = self.atkScope
		self:generateATowerAttack(v.instance, nil, false, true, self.atkScope, self, targetObj)
	end)
	self:runAction(ffa.seq(nil))
	self:playStandbyAni()
	if v.instance:getInfo().hp <= self.atk then
		self.lastAttackMonster = v.instance
	end
end
function Com_tower:CalculateHurt1(targetObj, data)
	local v = targetObj
	if v.state == MonsterState.ALIVE then
		v.instance:getHurt(data.atk, data.slowDown)
	end
end
function Com_tower:CalculateHurt2(targetObj, data)
	local v = targetObj
	local aliveMonster = towerDefendRead.getMonsterObject()
	for ii, vv in ipairs(aliveMonster) do
		if vv.state == MonsterState.ALIVE and self:distanceInRange(v.instance, vv.instance, data.atkScope) then
			vv.instance:getHurt(data.atk, data.slowDown)
		end
	end
end
function Com_tower:CalculateHurt3(targetObj, data)
	local v = targetObj
	local aliveMonster = towerDefendRead.getMonsterObject()
	for ii, vv in ipairs(aliveMonster) do
		if vv.state == MonsterState.ALIVE and self:distanceInRange(v.instance, vv.instance, data.atkScope) then
			towerDefendRead = vv.instance
			vv.instance.atk = data.atk
			vv.instance.slowDown = data.slowDown
			self:generateATowerAttack(vv.instance, vv.instance, true, true, data.atkScope, self, targetObj)
			vv.instance:getHurt(data.atk, data.slowDown)
		end
	end
end
function Com_tower:hurtFunction(towerID, targetObj, data)
	if towerID == 101 then
		self:CalculateHurt1(targetObj, data)
	elseif towerID == 102 or towerID == 104 then
		self:CalculateHurt2(targetObj, data)
	elseif towerID == 103 then
		self:CalculateHurt3(targetObj, data)
	end
end
_ENV, Com_tower.attackFunction = function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end, function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end
;(function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end)[101] = 24
;(function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end)[102] = 24
;(function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end)[103] = 0
local _ENV, (function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end)[104], standbyFrameCount = nil, 24, function(self, targetObj)
	if self.towerID == 101 then
		self:CalculateAttack1(targetObj)
	elseif self.towerID == 102 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 104 then
		self:CalculateAttack2(targetObj)
	elseif self.towerID == 103 then
		self:CalculateAttack3(targetObj)
	end
end
;(nil)[101] = 24
;(nil)[102] = 16
;(nil)[103] = 23
local _ENV, (nil)[104], atkFrameCount = nil, 24, nil
;(nil)[101] = 8
;(nil)[102] = 8
;(nil)[103] = 8
local (nil)[104], rotateFrameCount = 8, nil
function Com_tower:playStandbyAni()
end
function Com_tower:playRotateAni(special, centerPos, targetObj)
	if special then
		self:stopAllActions()
		local angle2 = self:getAngle(self:getPosition(), centerPos) + 90
		self:setRotationByOutside(angle2)
	end
	if self.towerID ~= 103 and not special then
		local angle2 = self:getAngle(self:getPosition(), targetObj.instance:getPosition()) + 90
		self:setRotationByOutside(angle2)
	end
	self:playAtkAni(special, targetObj)
end
function Com_tower:setRotationByOutside(angle, time)
	self.fields.Ani_load:runAction(ffa.rotateTo(time or 0.1, angle))
	self.fields.Com_muzzle:setRotation(angle)
	if self.fields.n11 then
		self.fields.n22:runAction(ffa.rotateTo(time or 0.1, angle))
		self.fields.n33:runAction(ffa.rotateTo(time or 0.1, angle))
	else
		self.fields.n44:runAction(ffa.rotateTo(time or 0.1, angle))
	end
end
function Com_tower:getAngle(startPos, endPos)
	return SoraDGetAngleByPos1(startPos, endPos)
end
_ENV, Com_tower.getRadian = function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end, function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end
;(function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end)[101] = "ballista_attack"
;(function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end)[102] = "turret_attack"
;(function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end)[103] = "magic_attack"
local (function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end)[104], criSound = "turret_attack", function(self, a, b)
	return math.atan2(b.x - a.x, b.y - a.y)
end
_ENV, _ENV, Com_tower.playAtkAni = nil, function(self, special, targetObj)
	local startFrameIndex = 1
	if self.towerID == 103 then
		startFrameIndex = 0
	end
	local framesNpc = display.newFrames(towerDefendRead.towerConfig[self.towerID].towerAtk, startFrameIndex, atkFrameCount[self.towerID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setVisible(true)
	if self.towerID ~= 103 then
		self.controllers.tower:setSelectedIndex(0)
	end
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1)
	towerDefendRead = -1
	;(-1)[1] = ffa.delay(0.4)
	;(-1)[2] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	;(-1)[3] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	self.fields.Ani_load:runAction(ffa.seq(-1))
end, function(self, special, targetObj)
	local startFrameIndex = 1
	if self.towerID == 103 then
		startFrameIndex = 0
	end
	local framesNpc = display.newFrames(towerDefendRead.towerConfig[self.towerID].towerAtk, startFrameIndex, atkFrameCount[self.towerID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setVisible(true)
	if self.towerID ~= 103 then
		self.controllers.tower:setSelectedIndex(0)
	end
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1)
	towerDefendRead = -1
	;(-1)[1] = ffa.delay(0.4)
	;(-1)[2] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	;(-1)[3] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	self.fields.Ani_load:runAction(ffa.seq(-1))
end
;(nil).frameName = "dh_paokou_%02d.png"
;(nil).frameCount = 36
_ENV, (function(self, special, targetObj)
	local startFrameIndex = 1
	if self.towerID == 103 then
		startFrameIndex = 0
	end
	local framesNpc = display.newFrames(towerDefendRead.towerConfig[self.towerID].towerAtk, startFrameIndex, atkFrameCount[self.towerID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setVisible(true)
	if self.towerID ~= 103 then
		self.controllers.tower:setSelectedIndex(0)
	end
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1)
	towerDefendRead = -1
	;(-1)[1] = ffa.delay(0.4)
	;(-1)[2] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	;(-1)[3] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	self.fields.Ani_load:runAction(ffa.seq(-1))
end)[102], (nil).time = nil, nil, 0.03333333333333333
;(nil).frameName = "dh_paokou_%02d.png"
;(nil).frameCount = 36
;(function(self, special, targetObj)
	local startFrameIndex = 1
	if self.towerID == 103 then
		startFrameIndex = 0
	end
	local framesNpc = display.newFrames(towerDefendRead.towerConfig[self.towerID].towerAtk, startFrameIndex, atkFrameCount[self.towerID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setVisible(true)
	if self.towerID ~= 103 then
		self.controllers.tower:setSelectedIndex(0)
	end
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1)
	towerDefendRead = -1
	;(-1)[1] = ffa.delay(0.4)
	;(-1)[2] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	;(-1)[3] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	self.fields.Ani_load:runAction(ffa.seq(-1))
end)[104], (nil).time = nil, 0.03333333333333333
local function muzzleConfig(self, special, targetObj)
	local startFrameIndex = 1
	if self.towerID == 103 then
		startFrameIndex = 0
	end
	local framesNpc = display.newFrames(towerDefendRead.towerConfig[self.towerID].towerAtk, startFrameIndex, atkFrameCount[self.towerID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setVisible(true)
	if self.towerID ~= 103 then
		self.controllers.tower:setSelectedIndex(0)
	end
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1)
	towerDefendRead = -1
	;(-1)[1] = ffa.delay(0.4)
	;(-1)[2] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	;(-1)[3] = ffa.callFunc(function()
		self:playStandbyAni()
		if self.towerID == 102 or self.towerID == 104 then
			self:playMuzzleAni(special, targetObj)
		else
			self:attackFunction(targetObj)
		end
		SoraDPlaySound("towerDefend", criSound[self.towerID])
	end)
	self.fields.Ani_load:runAction(ffa.seq(-1))
end
function Com_tower:playMuzzleAni(special, targetObj)
	self.fields.Com_muzzle:setCallback(function()
		self.fields.Com_muzzle:setVisible(false)
	end)
	self.fields.Com_muzzle:setVisible(true)
	self.fields.Com_muzzle:showEffect()
	if special and self.mainTower then
		_ENV = self.fields.Com_muzzle
		self.fields.Com_muzzle.msg = "MESSAGE_TOWER_DEFEND_MAIN_SKILL"
		SoraDSendMessage(self.fields.Com_muzzle)
	else
		self:attackFunction(targetObj)
	end
end
function Com_tower:playMuzzleAniMainTower()
	self.fields.Com_muzzle:setCallback(function()
		self.fields.Com_muzzle:setVisible(false)
	end)
	self.fields.Com_muzzle:setVisible(true)
	self.fields.Com_muzzle:showEffect()
end
function Com_tower:generateMainAttack()
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_GENERATE_LINE"
	;(nil).mainAttack = true
	SoraDSendMessage(nil)
end
function Com_tower:generateATowerAttack(obj, atkData, special, circle, ss, towerObj, targetObj)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_GENERATE_LINE"
	;(nil).obj = obj
	;(nil).targetObj = targetObj
	;(nil).atkData = atkData
	;(nil).special = special
	;(nil).towerID = self.towerID
	;(nil).circle = circle
	;(nil).radius = ss
	;(nil).towerObj = towerObj
	SoraDSendMessage(nil)
end
function Com_tower:distanceInRange(obj1, obj2, range)
	local pos1 = obj1:localToGlobal(cc.p(0, 0))
	local pos2 = obj2:localToGlobal(cc.p(0, 0))
	local dis = range * range - ((pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.y - pos2.y) * (pos1.y - pos2.y))
	if 0 <= dis then
		return true, dis
	end
	return false
end
function Com_tower:distanceInRange2(obj1, obj2, scope)
	local pos1 = obj1:getPosition()
	local pos2 = obj2:getPosition()
	local dis = scope * scope - ((pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.y - pos2.y) * (pos1.y - pos2.y))
	if 0 <= dis then
		return true, dis
	end
	return false
end
function Com_tower:getTowerID()
	return self.towerID
end
function Com_tower:getLevel()
	return self.towerData.curLevel
end
function Com_tower:onShow()
end
return Com_tower
