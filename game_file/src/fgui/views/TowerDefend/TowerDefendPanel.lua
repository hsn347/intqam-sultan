local towerDefendRead = include("towerDefendRead")
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local TowerDefendPanel = class("TowerDefendPanel", baseFguiPanel)
function TowerDefendPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("TowerDefendPanel:ctor", self.viewName)
end
_ENV, TowerDefendPanel.getPackageList = function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[2] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[2] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
	end
	return self._packageList
end
;(function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[2] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
	end
	return self._packageList
end).ALIVE = 1
;(function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[2] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
	end
	return self._packageList
end).DIE = 2
local _ENV, (function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[2] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
	end
	return self._packageList
end).ATTACK, MonsterState = baseFguiPanel, 3, function(self)
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RoadRoughGame"
		self._packageList, self._packageList[2] = self._packageList, "CaveExploreActivity"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
	end
	return self._packageList
end
baseFguiPanel.BALLISTA = 101
baseFguiPanel.FORT = 102
local _UPVALUE2_, _UPVALUE9_, baseFguiPanel.MAGETOWER, TowerID = nil, nil, 103, baseFguiPanel
_UPVALUE2_, (nil)[1] = 1, 1
_UPVALUE2_, (nil)[2] = 1, 1
_UPVALUE2_, (1)[1] = 1, 1
_UPVALUE2_, (1)[2] = 1, 2
_UPVALUE2_, (1)[1] = 1, 1
_UPVALUE2_, (1)[2] = 1, 3
_UPVALUE2_, (1)[1] = 2, 2
_UPVALUE2_, (1)[2] = 2, 1
_UPVALUE2_, (2)[1] = 2, 2
_UPVALUE2_, (2)[2] = 2, 2
_UPVALUE2_, (2)[1] = 2, 2
_UPVALUE2_, (2)[2] = 2, 3
_UPVALUE2_, (2)[1] = 3, 3
_UPVALUE2_, (2)[2] = 3, 1
_UPVALUE2_, (3)[1] = 3, 3
_UPVALUE2_, (3)[2] = 3, 2
;(3)[1] = 3
;(3)[2] = 3
_UPVALUE4_, (nil)[1] = nil, nil
_UPVALUE4_, (nil)[2] = nil, 1
_UPVALUE4_, (nil)[3] = nil, 1
_UPVALUE4_, (nil)[4] = nil, 1
_UPVALUE4_, (nil)[5] = nil, 2
_UPVALUE4_, (nil)[6] = nil, 2
_UPVALUE4_, (nil)[7] = nil, 2
_UPVALUE4_, (nil)[8] = nil, 3
local _UPVALUE4_, (nil)[9], posIndex = nil, 3, nil
;(nil)[1] = 120
;(nil)[2] = 60
;(nil)[3] = 30
local (nil)[4], remindTime = 10, nil
function TowerDefendPanel:onInit()
	SoraDPlayStopMusic()
	self.tf_bgm = SoraDPlayMusic("towerDefend", "td_bgm")
	self.activityID = gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY
	towerDefendRead.setPanelFixHeight(self:getHeight())
	self.zorderIndex = 1000
	_ENV, self.dropGoldNum = towerDefendRead.setPanelFixHeight, 0
	towerDefendRead.setPanelFixHeight.killNumTotal = 0
	towerDefendRead.setPanelFixHeight.skillEnergy = 0
	self.gameData, towerDefendRead.setPanelFixHeight.attackWave = towerDefendRead.setPanelFixHeight, 0
	self.isInStory = self.proxy.param and self.proxy.param.isInStory or false
	self.isHidePrePanel = true
	self.isHideCurrentSceneView = true
	print("=======TowerDefendPanel:onInit")
	self.fields.Button_stop:addClickListener(handler(self, self.onClickClose))
	self.fields.Button_test:addClickListener(handler(self, self.onClickTest))
	self.fields.touch_finger:addClickListener(handler(self, self.onClickGuideCallBack))
	self.fields.touch_tower:addClickListener(handler(self, self.onClickTowerBuildHide))
	self.fields.touch_skill:addClickListener(handler(self, self.generateSkillAttack))
	self.fields.Com_monster:setVisible(true)
	self.fields.Com_monster:setItVisible(false)
	self.battleTime = towerDefendRead.getGameConfig().gameTime
	towerDefendRead.clearAll()
	self.fields.Com_mainTower:setMainTowerFlag()
	self.wallDamageFlag = false
	self.fields.Label_time:updateLabel(towerDefendRead.getGameConfig().gameTime)
	for i = 1, 6 do
		self.fields["Ani_mainAttack" .. i]:setCallBack(function()
			self.fields["Ani_mainAttack" .. i]:setVisible(false)
		end)
	end
	self.firstComeIn = self.param and self.param.showGuide or false
end
local coinMoveSpeed = 720
local limitDropGoldNum = 50
function TowerDefendPanel:generateAGoldDrop(data)
	if self.dropGoldNum >= limitDropGoldNum then
		self:goldRefresh(data)
		return
	end
	self.dropGoldNum = self.dropGoldNum + 1
	self.fields.Label_point:stopAllActions()
	self.fields.Label_point:runAction(ffa.seq(ffa.delay(1), ffa.callFunc(function()
		self.dropGoldNum = 0
	end)))
	local comp = towerDefendRead.getRecycleDropCoinObject()
	if not comp then
		comp = fgui.UIPackage:createObjectFromURL("ui://TowerDefend/Com_dropCoin")
		comp:addTo(self.fields.Node_dropCoin)
	else
		comp:setVisible(true)
	end
	comp:initData(data.bonus, comp)
	comp:setPosition(data.pos)
	local distance = cc.pGetDistance(comp:getPosition(), self.fields.Label_point:getPosition())
	local time = distance / coinMoveSpeed
	time = time <= 1 and time or 1
	local pos = cc.p(self.fields.Label_point:getPositionX() + 105, self.fields.Label_point:getPositionY() + 35)
	local moveAction1 = ffa.moveTo(0.1, cc.p(comp:getPositionX(), comp:getPositionY() + 30))
	comp:stopAllActions()
	comp:dropShow()
	towerDefendRead = cc.p(comp:getPositionX(), comp:getPositionY() + 30)
	cc.p(comp:getPositionX(), comp:getPositionY() + 30)[1] = moveAction1
	cc.p(comp:getPositionX(), comp:getPositionY() + 30)[2] = ffa.delay(0.3)
	cc.p(comp:getPositionX(), comp:getPositionY() + 30)[3] = ffa.callFunc(function()
		local moveAction2 = ffa.moveTo(time, pos)
		time = pos
		pos[1] = moveAction2
		pos[2] = ffa.callFunc(function()
			comp:setVisible(false)
			comp:endFly()
		end)
		pos[3] = ffa.callFunc(function()
			comp:setVisible(false)
			comp:endFly()
		end)
		pos[4] = ffa.callFunc(function()
			comp:setVisible(false)
			comp:endFly()
		end)
		local seq = ffa.seq(pos)
		local angle = self:getAngle(comp:getPosition(), self.fields.Label_point:getPosition()) + 90
		comp:setTailLineRotation(angle, time)
		comp:showFlyEffect()
		comp:runAction(seq)
	end)
	cc.p(comp:getPositionX(), comp:getPositionY() + 30)[4] = ffa.callFunc(function()
		local moveAction2 = ffa.moveTo(time, pos)
		time = pos
		pos[1] = moveAction2
		pos[2] = ffa.callFunc(function()
			comp:setVisible(false)
			comp:endFly()
		end)
		pos[3] = ffa.callFunc(function()
			comp:setVisible(false)
			comp:endFly()
		end)
		pos[4] = ffa.callFunc(function()
			comp:setVisible(false)
			comp:endFly()
		end)
		local seq = ffa.seq(pos)
		local angle = self:getAngle(comp:getPosition(), self.fields.Label_point:getPosition()) + 90
		comp:setTailLineRotation(angle, time)
		comp:showFlyEffect()
		comp:runAction(seq)
	end)
	comp:runAction(ffa.seq(cc.p(comp:getPositionX(), comp:getPositionY() + 30)))
end
local moveSpeed = 1500
local fastMoveSpeed = 3000
local jianMoveSpeed = 2346
function TowerDefendPanel:generateAAttackLine(data)
	if data.towerID == 103 then
		self:generateATowerAttack(data)
		return
	end
	local comp = towerDefendRead.getRecycleShootLineObject()
	if not comp then
		comp = fgui.UIPackage:createObjectFromURL("ui://TowerDefend/Com_dandao")
		comp:addTo(self.fields.Node_dandao)
	else
		comp:setVisible(true)
	end
	comp:initData(data.towerID, comp, data)
	comp:setPosition(data.towerObj:getPosition())
	local angle = self:getAngle(data.towerObj:getPosition(), data.obj:getPosition()) + 90
	comp:setRotation(angle)
	if data.towerID == 102 then
		comp:setPositionX(comp:getPositionX() + 172 * math.cos(math.rad(angle - 90)))
		comp:setPositionY(comp:getPositionY() + 172 * math.sin(math.rad(angle - 90)))
	elseif data.towerID == 104 then
		comp:setPositionX(comp:getPositionX() + 350 * math.cos(math.rad(angle - 90)))
		comp:setPositionY(comp:getPositionY() + 350 * math.sin(math.rad(angle - 90)))
	else
		comp:setPositionX(comp:getPositionX() + 72 * math.cos(math.rad(angle - 90)))
		comp:setPositionY(comp:getPositionY() + 72 * math.sin(math.rad(angle - 90)))
	end
	local distance = cc.pGetDistance(comp:getPosition(), data.obj:getPosition())
	if data.towerID == 101 then
		local time = distance / jianMoveSpeed
		time = time <= 1 and time or 1
		local moveAction = ffa.moveTo(time, data.obj:getPosition())
		_ENV = data.obj:getPosition()
		data.obj:getPosition()[1] = moveAction
		data.obj:getPosition()[2] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		data.obj:getPosition()[3] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		data.obj:getPosition()[4] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		data.obj:getPosition()[5] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		data.obj:getPosition()[6] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		data.obj:getPosition()[7] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		local seq = ffa.seq(data.obj:getPosition())
		comp:initFly()
		comp:runAction(seq)
	else
		local time1 = distance / fastMoveSpeed
		time1 = time1 <= 1 and time1 or 1
		local time2 = distance / moveSpeed
		time2 = time2 <= 1 and time2 or 1
		local midPos = cc.p((comp:getPositionX() + data.obj:getPositionX()) / 2, (comp:getPositionY() + data.obj:getPositionY()) / 2)
		local moveAction1 = ffa.moveTo(time1, midPos)
		local moveAction2 = ffa.moveTo(time2, data.obj:getPosition())
		jianMoveSpeed = data.obj:getPosition()
		data.obj:getPosition()[1] = moveAction1
		data.obj:getPosition()[2] = moveAction2
		data.obj:getPosition()[3] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		data.obj:getPosition()[4] = ffa.callFunc(function()
			comp:endFly()
			comp:setVisible(false)
			self:generateATowerAttack(data)
		end)
		local seq = ffa.seq(data.obj:getPosition())
		comp:initFly(time1 + time2)
		comp:runAction(seq)
	end
	if data.towerObj then
		self.fields.n153:setPositionX(data.towerObj:getPosition().x)
		self.fields.n153:setPositionY(data.towerObj:getPosition().y)
	end
end
function TowerDefendPanel:getAngle(startPos, endPos)
	return SoraDGetAngleByPos1(startPos, endPos)
end
function TowerDefendPanel:generateATowerAttack(retData)
	local data = retData
	local comp = towerDefendRead.getRecycleAttackObject()
	if not comp then
		comp = fgui.UIPackage:createObjectFromURL("ui://TowerDefend/Com_attack")
		comp:addTo(self.fields.Node_attack)
	end
	comp:setVisible(true)
	comp:initData(data.towerID, comp)
	comp:setAnchorPoint(0.5, 0)
	comp:setPosition(data.obj:getPosition())
	comp:setAniCallBack(function()
		comp:setVisible(false)
	end)
	if not data.special then
		comp:releaseBoom()
		data.towerObj:hurtFunction(data.towerID, data.targetObj, data.atkData)
	else
		comp:releaseBoomShizi()
	end
	if data.circle and data.radius then
		self.fields.n146:setWidth(data.radius * 2)
		self.fields.n146:setHeight(data.radius * 2)
		self.fields.n146:setPositionX(data.obj:getPosition().x)
		self.fields.n146:setPositionY(data.obj:getPosition().y)
	end
	if (data.towerID == 103 or data.towerID == 104) and data.circle then
		comp:setSlownDownEffectRange(data.radius)
		return
	end
	if data.towerID == 102 and data.circle then
		comp:setTowerAttackRange(data.radius)
		return
	end
	if data.towerObj then
		self.fields.n151:setWidth(data.radius * 2)
		self.fields.n151:setHeight(data.radius * 2)
	end
end
function TowerDefendPanel:calculateSkillAttack(index, angle, pos)
	self:skillAttackShakeScreen()
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setPositionX(pos.x)
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setPositionY(pos.y)
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setRotation(angle)
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setScale(1 + math.random(1, 30) * 0.01)
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setCallBack(function(indexNum)
		self.fields["Ani_mainAttack" .. 9 - indexNum + 1]:setVisible(false)
	end)
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setVisible(true)
	self.fields["Ani_mainAttack" .. 9 - index + 1]:setPlay()
	self.fields["Ani_mainAttack" .. 9 - index + 1]:initData(index)
	SoraDPlaySound("towerDefend", "under_attack")
	local k = 0
	local info = towerDefendRead.skill[101]
	local atk = info.damege
	local origin = self:calculateOrigin(index)
	self.fields.box:setPositionX(origin.x)
	self.fields.box:setPositionY(origin.y)
	local aliveMonster = towerDefendRead.getMonsterObject()
	for i, v in ipairs(aliveMonster) do
		if v.state == MonsterState.ALIVE and self:distanceInRectRange(origin, v.instance) then
			v.instance:getHurt(atk, nil, true)
		end
	end
end
function TowerDefendPanel:distanceInRectRange(o, object)
	local value = object:getPosition()
	local offset = 50
	self.fields.box2:setPosition(self:calculateCenter2(self.skillIndex))
	self.fields.box2:setWidth(self.skillWidthStep + offset * 2)
	self.fields.box2:setHeight(self.skillHeightStep + offset * 2)
	if o.x - offset <= value.x and value.x <= o.x + offset + self.skillWidthStep and o.y - offset <= value.y and value.y <= o.y + offset + self.skillHeightStep then
		return true
	end
	return false
end
function TowerDefendPanel:calculateCenter2(index)
	local y = self.skillHeightStep * (posIndex[index][1] - 1) + (self.skillHeightStep - self.fields.box2:getHeight()) / 2
	local x = self.skillWidthStep * (posIndex[index][2] - 1) + (self.skillWidthStep - self.fields.box2:getWidth()) / 2
	return cc.p(x, y)
end
function TowerDefendPanel:generateSkillAttack()
	if not self.fields.Com_mainTower:getBuildState() then
		return
	end
	if self.isSkillAttacking then
		return
	end
	self.isSkillAttacking = true
	self.skillIndex = 9
	self.generateSkillHandle = SoraDCreateDelayTimer(self, function()
		self:increaseEnergy(-towerDefendRead.skill[101].cost)
		self:setAttackEffect(self.skillIndex)
	end, 0)
end
function TowerDefendPanel:generateSkillAttackTimer()
	self.skillIndex = self.skillIndex - 1
	if self.skillIndex <= 3 then
		SoraDManagerRemoveTimer(self, self.generateSkillHandle)
		self.isSkillAttacking = false
		self.fields.Com_mainTower:setAttack()
		return
	end
	if self.generateSkillHandle then
		SoraDManagerRemoveTimer(self, self.generateSkillHandle)
	end
	self.generateSkillHandle = SoraDCreateDelayTimer(self, function()
		self:setAttackEffect(self.skillIndex)
	end, towerDefendRead.skill[101].coolDown)
end
function TowerDefendPanel:setAttackEffect(index)
	local startPos = self.fields.Com_mainTower:getPosition()
	local centerPos = self:calculateCenter(index)
	centerPos = cc.p(centerPos.x + math.random(-30, 30), centerPos.y + math.random(-30, 30))
	local randomAnlge = 0
	local angle2 = self:getAngle(startPos, centerPos) + 90 + randomAnlge
	self.fields.Com_mainTower:setRotationByOutside(angle2, 0.01)
	self.fields.Com_mainTower:playMuzzleAniMainTower()
	SoraDPlaySound("towerDefend", "cannon_attack")
	self:generateMainAttackLine(self.fields.Com_mainTower, centerPos, index, randomAnlge)
	self:generateSkillAttackTimer()
end
local fastSpeed = 3760
local slowSpeed = 1544
function TowerDefendPanel:generateMainAttackLine(towerObj, endPos, index, randomAnlge)
	local comp = towerDefendRead.getRecycleShootLineObject()
	if not comp then
		comp = fgui.UIPackage:createObjectFromURL("ui://TowerDefend/Com_dandao")
		comp:addTo(self.fields.Node_dandao)
	else
		comp:setVisible(true)
	end
	comp:initData(104)
	comp:setScale(1 - math.random(1, 30) * 0.01)
	comp:setPosition(towerObj:getPosition())
	local angle = self:getAngle(comp:getPosition(), endPos) + 90 + randomAnlge
	comp:setRotation(angle)
	comp:setPositionX(comp:getPositionX() + 350 * math.cos(math.rad(angle - 90)))
	comp:setPositionY(comp:getPositionY() + 350 * math.sin(math.rad(angle - 90)))
	local offsetPos = endPos
	local distance = cc.pGetDistance(comp:getPosition(), offsetPos)
	local time1 = distance / fastSpeed
	time1 = time1 <= 1 and time1 or 1
	local time2 = distance / slowSpeed
	time2 = time2 <= 1 and time2 or 1
	local midPos = cc.p((comp:getPositionX() + offsetPos.x) / 2, (comp:getPositionY() + offsetPos.y) / 2)
	local moveAction1 = ffa.moveTo(time1, midPos)
	local moveAction2 = ffa.moveTo(time2, offsetPos)
	fastSpeed = offsetPos
	offsetPos[1] = moveAction1
	offsetPos[2] = moveAction2
	offsetPos[3] = ffa.callFunc(function()
		comp:endFly()
		comp:setVisible(false)
		self:calculateSkillAttack(index, angle, offsetPos)
	end)
	offsetPos[4] = ffa.callFunc(function()
		comp:endFly()
		comp:setVisible(false)
		self:calculateSkillAttack(index, angle, offsetPos)
	end)
	local seq = ffa.seq(offsetPos)
	comp:initFly(time1 + time2)
	comp:runAction(seq)
end
function TowerDefendPanel:skillAttackShakeScreen()
	_UPVALUE0_ = nil
	;(nil).diff_max = 10
	;(nil).interval = 0.01
	self:shakeEffect(self, 0.1, nil)
end
function TowerDefendPanel:shakeEffect(target, time, params)
	if target.animShaker then
		target.animShaker:stop()
	end
	local AnimShaker = include("AnimShaker")
	local animShaker = AnimShaker.new(target, time, params)
	target.animShaker = animShaker
	animShaker:run()
end
function TowerDefendPanel:calculateOrigin(index)
	local y = self.skillHeightStep * (posIndex[index][1] - 1)
	local x = self.skillWidthStep * (posIndex[index][2] - 1)
	return cc.p(x, y)
end
function TowerDefendPanel:calculateCenter(index)
	local y = self.skillHeightStep * (posIndex[index][1] - 1) + (self.skillHeightStep - self.fields.box:getHeight()) / 2
	local x = self.skillWidthStep * (posIndex[index][2] - 1) + (self.skillWidthStep - self.fields.box:getWidth()) / 2
	return cc.p(x, y)
end
function TowerDefendPanel:initData()
	print("=======TowerDefendPanel:onInit")
	self.fields.Label_point:setString(towerDefendRead.gold)
	for i = 1, 2 do
		self.fields["n" .. i]:initData(i)
	end
	self.fields.Com_mainTower:initData()
	self.fields.Com_skillProgress:initData(self.gameData.skillEnergy, towerDefendRead.skill[101].cost)
	self:showStory()
end
function TowerDefendPanel:showStory()
	print("====TowerDefendPanel:showStory")
	_ENV, _ENV = "====TowerDefendPanel:showStory", print
	;("====TowerDefendPanel:showStory").index = 1
	;("====TowerDefendPanel:showStory").stage = 1
	;("====TowerDefendPanel:showStory").talkID = 100001
	;("====TowerDefendPanel:showStory").type = 1
	;("====TowerDefendPanel:showStory").banner = ""
	_UPVALUE1_, ("====TowerDefendPanel:showStory").person = nil, 0
	;("====TowerDefendPanel:showStory").key1, (nil)[1] = nil, "EP_npc_dialogue_0001"
	_UPVALUE1_, ("====TowerDefendPanel:showStory").later1 = nil, 100002
	;("====TowerDefendPanel:showStory").key2, (nil)[1] = nil, "EP_npc_name_0001"
	_ENV, print[1], ("====TowerDefendPanel:showStory").later2 = "====TowerDefendPanel:showStory", "====TowerDefendPanel:showStory", 0
	;("====TowerDefendPanel:showStory").index = 2
	;("====TowerDefendPanel:showStory").stage = 1
	;("====TowerDefendPanel:showStory").talkID = 100002
	;("====TowerDefendPanel:showStory").type = 1
	;("====TowerDefendPanel:showStory").banner = ""
	_UPVALUE1_, ("====TowerDefendPanel:showStory").person = nil, 0
	;("====TowerDefendPanel:showStory").key1, (nil)[1] = nil, "EP_npc_dialogue_0002"
	_UPVALUE1_, ("====TowerDefendPanel:showStory").later1 = nil, 100003
	;("====TowerDefendPanel:showStory").key2, (nil)[1] = nil, "exitic_pavillion_text_0046"
	print[2], ("====TowerDefendPanel:showStory").later2 = "====TowerDefendPanel:showStory", 0
	local dialogue = print
	self.fields.Com_story:initData(false, dialogue)
end
function TowerDefendPanel:gameEntry()
	self:gameCountDown()
end
function TowerDefendPanel:gameCountDown()
	self.transitions.ready:setHook("openEnd", function()
		self.fields.com_readyAni:showCountDown()
	end)
	self.controllers.countDown:setSelectedIndex(1)
end
function TowerDefendPanel:countDownAniEnd()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.fadeOut(0.5)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.com_readyAni:setVisible(false)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.com_readyAni:setVisible(false)
	end)
	self.fields.com_readyAni:runAction(ffa.seq(nil))
	_UPVALUE1_ = ffa.seq(nil)
	ffa.seq(nil)[1] = ffa.fadeOut(0.5)
	ffa.seq(nil)[2] = ffa.callFunc(function()
		self.fields.Com_warn:setVisible(false)
		self.fields.touch_disable:setVisible(false)
		self:setGameStart()
	end)
	ffa.seq(nil)[3] = ffa.callFunc(function()
		self.fields.Com_warn:setVisible(false)
		self.fields.touch_disable:setVisible(false)
		self:setGameStart()
	end)
	self.fields.Com_warn:runAction(ffa.seq(ffa.seq(nil)))
	self.transitions.warn:stop()
end
function TowerDefendPanel:setGameStart()
	self:beginAllTimer()
end
function TowerDefendPanel:beginAllTimer()
	self:beginGameTime()
	if not self.monster_bgm then
		self.monster_bgm = SoraDPlaySound("towerDefend", "monster_bgm")
	end
	self:generateMonster()
	if self.firstComeIn then
		self.firstBuildGuide = true
		self.guideTower = self.fields.n2
		self:buildTowerGuide()
	else
		self:goldIncrement()
		if self.fields.Com_mainTower:getBuildState() then
			self:energyIncrement()
		end
	end
end
function TowerDefendPanel:beginGameTime()
	self.fields.Label_time:endTimeNoCauseEndCallBack()
	self.fields.Label_time:setTimeEndListener(function()
		self:gameSuccess()
	end)
	self.remindIndex = 1
	self.fields.Label_time:setTimeUpdateListener(function()
		self.continueTimeStr = self.fields.Label_time:getTitle()
		if remindTime[self.remindIndex] and self:strConvertToTime() <= remindTime[self.remindIndex] then
			self = nil
			;(nil).time = self:strConvertToTime()
			self.fields.Text_tip:setString(i18n("EP_game_tutorial_0006", nil))
			self.fields.Text_tip:setVisible(true)
			self.fields.Node_tip:setVisible(true)
			remindTime = i18n("EP_game_tutorial_0006", nil)
			i18n("EP_game_tutorial_0006", nil)[1] = ffa.delay(towerDefendRead.getGameConfig().showStayTime)
			i18n("EP_game_tutorial_0006", nil)[2] = ffa.callFunc(function()
				self.fields.Text_tip:setVisible(false)
				self.fields.Node_tip:setVisible(false)
			end)
			i18n("EP_game_tutorial_0006", nil)[3] = ffa.callFunc(function()
				self.fields.Text_tip:setVisible(false)
				self.fields.Node_tip:setVisible(false)
			end)
			self.fields.Image_tip:runAction(ffa.seq(i18n("EP_game_tutorial_0006", nil)))
			self.remindIndex = self.remindIndex + 1
		end
		self:updateMonster()
	end)
	if self.continueTime then
		self.fields.Label_time:beginTime(self.continueTime)
	else
		self.fields.Label_time:beginTime(towerDefendRead.getGameConfig().gameTime)
	end
end
function TowerDefendPanel:gamePause()
	self.fields.Label_time:endTimeNoCauseEndCallBack()
	_ENV = self.fields.Label_time
	self.fields.Label_time.msg = "MESSAGE_TOWER_DEFEND_GAME_PAUSE"
	SoraDSendMessage(self.fields.Label_time)
	SoraDManagerRemoveTimerByTarget(self)
end
function TowerDefendPanel:gameContinue()
	if not self.view then
		return
	end
	self.continueTime = self:strConvertToTime()
	self:beginGameTime()
	if self.monsterNum >= self.monsterTotalNum then
		self:generateMonster()
	else
		self:generateMonsterByInterval()
	end
	self:goldIncrement()
	if self.fields.Com_mainTower:getBuildState() then
		self:energyIncrement()
	end
	_ENV = self
	self.msg = "MESSAGE_TOWER_DEFEND_GAME_CONTINUE"
	SoraDSendMessage(self)
end
function TowerDefendPanel:strConvertToTime()
	local num = 48
	local timeNumber = (string.byte(self.continueTimeStr, 4) - num) * 10 + (string.byte(self.continueTimeStr, 5) - num)
	timeNumber = timeNumber * 60 + (string.byte(self.continueTimeStr, 7) - num) * 10 + (string.byte(self.continueTimeStr, 8) - num)
	return timeNumber
end
function TowerDefendPanel:buildTowerGuide()
	self.guideComplete = false
	self.continueTimeStr = self.fields.Label_time:getTitle()
	self:gamePause()
	self.clickHandHandle = handler(self, self.clickTowerGuide)
	self.fields.effect_finger:setPositionX(self.guideTower:getPositionX())
	self.fields.effect_finger:setPositionY(self.guideTower:getPositionY() + 20)
	self:showHand()
end
function TowerDefendPanel:showHand()
	self.fields.effect_finger:stopActionByTag(1)
	self.fields.touch_guide:setVisible(true)
	self.fields.touch_finger:setVisible(true)
	_ENV = self.fields.touch_finger
	self.fields.touch_finger[1] = ffa.callFunc(function(...)
		self.fields.effect_finger:setVisible(true)
	end)
	self.fields.touch_finger[2] = ffa.callFunc(function(...)
		self.fields.effect_finger:setVisible(true)
	end)
	local seq = ffa.seq(self.fields.touch_finger)
	seq:setTag(1)
	self.fields.effect_finger:runAction(seq)
	print("======显示手指QuestGuideNode========")
end
function TowerDefendPanel:clickTowerGuide()
	self.clickHandHandle = handler(self, self.clickBuildGuide)
	self.guideTower:onClickSpace()
	if self.upgradeGuide then
		self.fields.Com_guideText:setChatTextOnly(i18n("EP_game_tutorial_0002"))
	elseif self.secondBuildGuide then
		self.fields.Com_guideText:setChatTextOnly(i18n("game_tutorial_0004"))
	else
		self.fields.Com_guideText:setChatTextOnly(i18n("EP_game_tutorial_0001"))
	end
	self.fields.effect_finger:setPositionY(self.guideTower:getPositionY() + 25)
	self.fields.effect_finger:setPositionX(self.guideTower:getPositionX() - 5)
	self.fields.Com_guideText:setPositionX(self.guideTower:getPositionX() - 250)
	self.fields.Com_guideText:setPositionY(self.guideTower:getPositionY() - 150)
	self.fields.Com_guideText:setVisible(true)
end
function TowerDefendPanel:clickBuildGuide()
	self.guideTower:onClickBuild()
	self:hideGuideHand()
end
function TowerDefendPanel:hideGuideHand()
	self.fields.effect_finger:stopActionByTag(1)
	self.fields.effect_finger:setVisible(false)
	self.fields.touch_guide:setVisible(false)
	self.fields.touch_finger:setVisible(false)
	self.fields.Com_guideText:setVisible(false)
	self:gameContinue()
	self.guideComplete = true
end
function TowerDefendPanel:onClickGuideCallBack()
	self.clickHandHandle()
end
function TowerDefendPanel:gameTimeGuide()
	self.guideComplete = false
	self.continueTimeStr = self.fields.Label_time:getTitle()
	self:gamePause()
	self.fields.Com_guideText:setChatTextOnly(i18n("EP_game_tutorial_0005"))
	self.fields.Com_guideText:setVisible(true)
	self.fields.Com_guideText:setPositionX(self.fields.Label_time:getPositionX() - 220)
	self.fields.Com_guideText:setPositionY(self.fields.Label_time:getPositionY() - 70)
	self.fields.effect_finger:setPositionX(self.fields.Label_time:getPositionX() + 50)
	self.fields.effect_finger:setPositionY(self.fields.Label_time:getPositionY() + 10)
	self.clickHandHandle = handler(self, self.gameTimeGuideClick)
	self:showHand()
end
function TowerDefendPanel:gameTimeGuideClick()
	self:hideGuideHand()
	self.gameTimeGuide = true
end
function TowerDefendPanel:skillEnergyGuide()
	self.guideComplete = false
	self.continueTimeStr = self.fields.Label_time:getTitle()
	self:gamePause()
	self.fields.Com_guideText:setChatTextOnly(i18n("EP_game_tutorial_0003"))
	self.fields.Com_guideText:setVisible(true)
	self.fields.Com_guideText:setPositionX(self.fields.Com_skillProgress:getPositionX() - 230)
	self.fields.Com_guideText:setPositionY(self.fields.Com_skillProgress:getPositionY() - 220)
	self.fields.effect_finger:setPositionX(self.fields.Com_skillProgress:getPositionX())
	self.fields.effect_finger:setPositionY(self.fields.Com_skillProgress:getPositionY())
	self.clickHandHandle = handler(self, self.mainCannonReleaseSkills)
	self:showHand()
end
function TowerDefendPanel:mainCannonReleaseSkills()
	self:generateSkillAttack()
	self:hideGuideHand()
end
function TowerDefendPanel:calculateAngle(px, py)
	local tmp = (px * 1 + py * 0) / math.sqrt(px * px + py * py)
	return math.acos(tmp)
end
function TowerDefendPanel:timerEnd()
	self.fields.touch_disable:setVisible(true)
	self:generateTimerEnd()
	self:incrementTimerEnd()
end
function TowerDefendPanel:generateTimerEnd()
	if self.breakTimeHandle then
		SoraDManagerRemoveTimer(self, self.breakTimeHandle)
	end
	if self.generateTimeHandle then
		SoraDManagerRemoveTimer(self, self.generateTimeHandle)
	end
end
function TowerDefendPanel:incrementTimerEnd()
	if self.goldRecoverTimeHandle then
		SoraDManagerRemoveTimer(self, self.goldRecoverTimeHandle)
	end
	if self.energyRecoverTimeHandle then
		SoraDManagerRemoveTimer(self, self.energyRecoverTimeHandle)
	end
end
local stepOffset = 1
local stepTime = 1
function TowerDefendPanel:updateMonster()
	local aliveMonster = towerDefendRead.getMonsterObject()
	if aliveMonster == nil or not next(aliveMonster) then
		return
	end
	for i, v in ipairs(aliveMonster) do
		if v.state == MonsterState.ALIVE and v.canMove then
			v.instance:setSortingOrder(v.instance:getPositionY())
			_ENV = v.instance
			v.instance[1] = ffa.moveTo(stepTime, v.instance:getPositionX(), v.instance:getPositionY() + v.info.speed * v.slowDown * stepOffset)
			v.instance[2] = ffa.callFunc(function()
				if v.instance:localToGlobal(cc.p(0, 0)).y >= self.fields.referLine:localToGlobal(cc.p(0, 0)).y then
					v.instance:playAtk()
					v.canMove = false
				end
			end)
			v.instance[3] = ffa.callFunc(function()
				if v.instance:localToGlobal(cc.p(0, 0)).y >= self.fields.referLine:localToGlobal(cc.p(0, 0)).y then
					v.instance:playAtk()
					v.canMove = false
				end
			end)
			v.instance[4] = ffa.callFunc(function()
				if v.instance:localToGlobal(cc.p(0, 0)).y >= self.fields.referLine:localToGlobal(cc.p(0, 0)).y then
					v.instance:playAtk()
					v.canMove = false
				end
			end)
			v.instance[5] = ffa.callFunc(function()
				if v.instance:localToGlobal(cc.p(0, 0)).y >= self.fields.referLine:localToGlobal(cc.p(0, 0)).y then
					v.instance:playAtk()
					v.canMove = false
				end
			end)
			v.instance[6] = ffa.callFunc(function()
				if v.instance:localToGlobal(cc.p(0, 0)).y >= self.fields.referLine:localToGlobal(cc.p(0, 0)).y then
					v.instance:playAtk()
					v.canMove = false
				end
			end)
			local seq = ffa.seq(v.instance)
			if v.instance:localToGlobal(cc.p(0, 0)).y >= self.fields.referLine:localToGlobal(cc.p(0, 0)).y then
				v.instance:playAtk()
				v.canMove = false
			else
				v.instance:runAction(seq)
			end
		end
	end
	self:showKillNum()
end
function TowerDefendPanel:killNumEffectEnd()
	self.showKillAction = false
	self:hideKillNum()
end
function TowerDefendPanel:showKillNum()
	if towerDefendRead.killNum <= 0 then
		return
	end
	if not self.hasfirstKill then
		self.showKillAction = true
		self.gameData.killNumTotal = self.gameData.killNumTotal + towerDefendRead.killNum
		self.fields.Com_point:setVisible(true)
		self.fields.Com_point:setData(towerDefendRead.killNum)
		self.fields.Com_point:setCallBackHandle(handler(self, self.killNumEffectEnd))
		self.fields.Com_point:getTransition("firstShow"):play()
		self.hasfirstKill = true
		towerDefendRead.clearKillNum()
		self:hideKillNum()
	else
		if self.showKillAction then
			return
		end
		self.showKillAction = true
		self.fields.Com_point:setVisible(true)
		local tmp = self.gameData.killNumTotal + towerDefendRead.killNum
		if 0 < self.gameData.killNumTotal and math.floor(self.gameData.killNumTotal / 100) ~= math.floor(tmp / 100) then
			self.killHit = true
		end
		towerDefendRead = math.floor(tmp / 100)
		math.floor(tmp / 100)[1] = ffa.callFunc(function()
			if self.gameData.killNumTotal == tmp then
				self.fields.Com_point:stopActionByTag(3)
				if self.killHit then
					self.fields.Com_point:setCallBackHandle(handler(self, self.killNumEffectEnd))
					self.fields.Com_point:playHitEffect()
					self.killHit = false
				else
					self.showKillAction = false
					self:hideKillNum()
				end
			elseif self.gameData.killNumTotal < tmp then
				self.gameData.killNumTotal = self.gameData.killNumTotal + 1
				self.fields.Com_point:setData(self.gameData.killNumTotal)
			else
				self.fields.Com_point:stopActionByTag(3)
			end
		end)
		math.floor(tmp / 100)[2] = ffa.callFunc(function()
			if self.gameData.killNumTotal == tmp then
				self.fields.Com_point:stopActionByTag(3)
				if self.killHit then
					self.fields.Com_point:setCallBackHandle(handler(self, self.killNumEffectEnd))
					self.fields.Com_point:playHitEffect()
					self.killHit = false
				else
					self.showKillAction = false
					self:hideKillNum()
				end
			elseif self.gameData.killNumTotal < tmp then
				self.gameData.killNumTotal = self.gameData.killNumTotal + 1
				self.fields.Com_point:setData(self.gameData.killNumTotal)
			else
				self.fields.Com_point:stopActionByTag(3)
			end
		end)
		math.floor(tmp / 100)[3] = ffa.callFunc(function()
			if self.gameData.killNumTotal == tmp then
				self.fields.Com_point:stopActionByTag(3)
				if self.killHit then
					self.fields.Com_point:setCallBackHandle(handler(self, self.killNumEffectEnd))
					self.fields.Com_point:playHitEffect()
					self.killHit = false
				else
					self.showKillAction = false
					self:hideKillNum()
				end
			elseif self.gameData.killNumTotal < tmp then
				self.gameData.killNumTotal = self.gameData.killNumTotal + 1
				self.fields.Com_point:setData(self.gameData.killNumTotal)
			else
				self.fields.Com_point:stopActionByTag(3)
			end
		end)
		local seq = ffa.seq((math.floor(tmp / 100)))
		local action = ffa.repeatForever(seq)
		action:setTag(3)
		self.fields.Com_point:stopAllActions()
		self.fields.Com_point:runAction(action)
		towerDefendRead.clearKillNum()
	end
end
function TowerDefendPanel:hideKillNum()
	towerDefendRead = nil
	;(nil)[1] = ffa.delay(towerDefendRead.getGameConfig().hideCountTime)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Com_point:setVisible(false)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Com_point:setVisible(false)
	end)
	local seq = ffa.seq(nil)
	self.fields.Com_point:runAction(seq)
end
function TowerDefendPanel:generateMonster()
	self.gameData.attackWave = self.gameData.attackWave + 1
	self.monsterNum = 0
	self.monsterData, self.monsterTotalNum = towerDefendRead.getMonsterTotalNumByWave(self.gameData.attackWave)
	self.generateInterval = towerDefendRead.getGameConfig().bornTime * 1.0 / self.monsterTotalNum
	self.generateTimeHandle = SoraDCreateDelayTimer(self, function()
		self:generateAMonsterRandom()
	end, 0)
end
function TowerDefendPanel:generateMonsterByInterval()
	if self.generateTimeHandle then
		SoraDManagerRemoveTimer(self, self.generateTimeHandle)
	end
	self.generateTimeHandle = SoraDCreateDelayTimer(self, function()
		self:generateAMonsterRandom()
	end, self.generateInterval)
end
local uniqueUid = 1
function TowerDefendPanel:generateAMonsterRandom()
	self:createMonster()
	self.monsterNum = self.monsterNum + 1
	if self.monsterNum >= self.monsterTotalNum then
		SoraDManagerRemoveTimer(self, self.generateTimeHandle)
		if towerDefendRead.isMonserGenerateFinish(self.gameData.attackWave) then
			self:generateTimerEnd()
			return
		end
		if self.breakTimeHandle then
			SoraDManagerRemoveTimer(self, self.breakTimeHandle)
		end
		self.breakTimeHandle = SoraDCreateDelayTimer(self, function()
			self:generateMonster()
		end, towerDefendRead.getGameConfig().breakTime)
	else
		_ENV = self
		self.msg = "MESSAGE_TOWER_DEFEND_GENERATE_TIMER"
		SoraDSendMessage(self)
	end
end
function TowerDefendPanel:createMonster()
	if not self.generateSequence or not next(self.generateSequence) then
		self:generateMonsterSequence()
	end
	local info = self:getAMonsterInfo()
	if not info then
	end
	local index = table.remove(self.generateSequence)
	local comp, tableIndex = towerDefendRead.getRecycleMonsterObject()
	if not comp then
		comp = fgui.UIPackage:createObjectFromURL("ui://TowerDefend/Com_monster")
		comp:addTo(self.fields.Com_monster, self.zorderIndex)
		self.zorderIndex = self.zorderIndex - 1
	else
	end
	comp:initData(1, info.monsterID, info.level, comp, uniqueUid)
	comp:setPosition(self.offset + self.fields.Com_monster:getPositionX() + math.random(4) - 1 + self.posLength * (index - 1), 0)
	local curTableIndex = towerDefendRead.addMonsterObject(comp:getInfo(), tableIndex)
	comp:setTableIndex(curTableIndex)
	comp:playBornAnim()
end
function TowerDefendPanel:getAMonsterInfo()
	local hasFlag = false
	for i, v in ipairs(self.monsterData) do
		if v.num ~= 0 then
			hasFlag = true
		end
	end
	if not hasFlag then
		return nil
	end
	while true do
		local randomIndex = math.random(1, table.nums(self.monsterData))
		if self.monsterData[randomIndex] and self.monsterData[randomIndex].num ~= 0 then
			self.monsterData[randomIndex].num = self.monsterData[randomIndex].num - 1
			return self.monsterData[randomIndex]
		end
	end
end
function TowerDefendPanel:generateMonsterSequence()
	self.generateSequence, towerDefendRead = nil, nil
	local towerDefendRead, sequence
	for i = 1, towerDefendRead.getGameConfig().bornPoint do
		sequence[i] = i
	end
	local index = 0
	for i = 1, towerDefendRead.getGameConfig().bornPoint do
		index = SoraDRandomItem(sequence)
		self.generateSequence[i] = sequence[index]
		table.remove(sequence, index)
	end
end
function TowerDefendPanel:goldIncrement()
	if self.goldRecoverTimeHandle then
		SoraDManagerRemoveTimer(self, self.goldRecoverTimeHandle)
	end
	self.goldRecoverTimeHandle = SoraDCreateDelayTimer(self, function()
		self:increaseGold(towerDefendRead.getGameConfig().goldRecover[2])
		self = self
		self.msg = "MESSAGE_TOWER_DEFEND_GOLD_TIMER"
		SoraDSendMessage(self)
	end, towerDefendRead.getGameConfig().goldRecover[1])
end
function TowerDefendPanel:increaseGold(inc)
	if inc <= 0 then
	end
	towerDefendRead.gold = towerDefendRead.gold + inc
	self:goldRefresh()
	self:goldUpdate()
end
function TowerDefendPanel:goldRefresh(data)
	if data and data.bonus then
		towerDefendRead.gold = towerDefendRead.gold + data.bonus
	end
	self.fields.Label_point:setString(towerDefendRead.gold)
end
function TowerDefendPanel:goldUpdate()
	for i = 1, 2 do
		self.fields["n" .. i]:setCostTextColor(towerDefendRead.gold)
	end
	self.fields.Com_mainTower:setCostTextColor(towerDefendRead.gold)
end
function TowerDefendPanel:energyIncrement()
	if self.energyRecoverTimeHandle then
		SoraDManagerRemoveTimer(self, self.energyRecoverTimeHandle)
	end
	self.energyRecoverTimeHandle = SoraDCreateDelayTimer(self, function()
		self:increaseEnergy(towerDefendRead.getGameConfig().energyRecover[2])
		self = self
		self.msg = "MESSAGE_TOWER_DEFEND_ENERGY_TIMER"
		SoraDSendMessage(self)
	end, towerDefendRead.getGameConfig().energyRecover[1])
end
function TowerDefendPanel:increaseEnergy(inc)
	self.gameData.skillEnergy = self.gameData.skillEnergy + inc
	self:energyRefresh()
end
function TowerDefendPanel:energyRefresh(data)
	if not self.fields.Com_mainTower:getBuildState() then
		return
	else
		self.fields.Com_skillProgress:setVisible(true)
		self.fields.touch_skill:setVisible(true)
	end
	if data and data.energy then
		self.gameData.skillEnergy = self.gameData.skillEnergy + data.energy
	end
	self.fields.Com_skillProgress:initData(self.gameData.skillEnergy, towerDefendRead.skill[101].cost)
	self:energyUpdate()
	if self.firstComeIn and self.skillGuide ~= true and self.gameData.skillEnergy >= towerDefendRead.skill[101].cost then
		self.skillGuide = true
		self:skillEnergyGuide()
	end
end
function TowerDefendPanel:energyUpdate()
	if self.gameData.skillEnergy >= towerDefendRead.skill[101].cost then
		self.fields.touch_skill:setTouchable(true)
	else
		self.fields.touch_skill:setTouchable(false)
	end
end
function TowerDefendPanel:gameFail(data)
	self:stopMusic()
	if not data.fail then
		return
	end
	if self.gameFailFlag then
		return
	end
	if self.msgPanel then
		self.msgPanel:removeFromParent()
	end
	self.gameFailFlag = true
	self.fields.Label_time:endTimeNoCauseEndCallBack()
	SoraDManagerRemoveTimerByTarget(self)
	self:stopAllActions()
	_ENV = nil
	;(nil).type = 4
	;(nil).isWin = false
	;(nil).isInStory = self.isInStory
	;(nil).totalKillNum = self.gameData.killNumTotal
	uiManager:show("ForeignPsettlement", nil)
end
function TowerDefendPanel:gameSuccess()
	self:stopMusic()
	if self.gameSuccessFlag then
		return
	end
	if self.msgPanel then
		self.msgPanel:removeFromParent()
	end
	_ENV = self.msgPanel
	self.msgPanel.msg = "MESSAGE_TOWER_DEFEND_GAME_FAIL"
	self.msgPanel.fail = false
	SoraDSendMessage(self.msgPanel)
	self.gameSuccessFlag = true
	SoraDManagerRemoveTimerByTarget(self)
	self:stopAllActions()
	if self.isInStory then
		local isWin
		_ENV = nil
		;(nil).isWin = isWin
		;(nil).isInStory = self.isInStory
		uiManager:show("ForeignPVictory", nil)
	else
		_ENV = "ForeignPVictory"
		;("ForeignPVictory").type = 4
		;("ForeignPVictory").isWin = true
		;("ForeignPVictory").isInStory = self.isInStory
		;("ForeignPVictory").totalKillNum = self.gameData.killNumTotal
		uiManager:show("ForeignPsettlement", "ForeignPVictory")
	end
end
function TowerDefendPanel:stopMusic()
	SoraDPlayStopEffect(self.monster_bgm)
	SoraDPlayStopEffect(self.tf_bgm)
end
function TowerDefendPanel:onClickStop()
	self.msgPanel = SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
		self.msgPanel = nil
		if exitType == MSGBOX_CALLBACK_YES then
			if self.isGameOver then
				return
			end
			self = nil
			;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
			;(nil).isWin = false
			;(nil).gameType = 4
			;(nil).isInStory = self.isInStory
			SoraDSendMessage(nil)
		end
	end)
end
function TowerDefendPanel:onClickClose()
	self.msgPanel = SoraDShowMsgBoxNew(i18n("exitic_pavillion_text_0118"), nil, i18n("common_text_185"), function(exitType)
		self.msgPanel = nil
		if exitType == MSGBOX_CALLBACK_YES then
			if self.isGameOver then
				return
			end
			self:stopMusic()
			SoraDResetBackGroundMusic()
			self = self
			self.msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
			self.isWin = false
			self.gameType = 4
			self.isInStory = self.isInStory
			SoraDSendMessage(self)
		end
	end)
end
function TowerDefendPanel:onClickTest()
	uiManager:show("TestTowerdefend"):setOwnerKey()
end
function TowerDefendPanel:cityWallDestroyState(data)
	if data.atk then
		self.fields.Com_cityWall:setVisible(true)
		self.fields.Com_cityWall:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.delay(3)
		;(nil)[2] = ffa.callFunc(function()
			self.fields.Com_cityWall:setVisible(false)
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.fields.Com_cityWall:setVisible(false)
		end)
		self.fields.Com_cityWall:runAction(ffa.seq(nil))
		self.fields.Com_cityWall:getAttack(data.atk)
		if not self.wallHasDamage then
			if not self.wallHasDamage and not self.wallDamageFlag then
				self.fields.Com_wallEffect:stopAllActions()
				self.fields.Com_wallEffect:setVisible(true)
				self.fields.Com_wallEffect:setPlay(true)
				self.wallDamageFlag = true
				self:hideCityWallHitEffect()
			else
				self.fields.Com_wallEffect:stopAllActions()
				self:hideCityWallHitEffect()
			end
		end
	else
		if self.wallHasDamage then
			return
		end
		self.wallHasDamage = true
		self.transitions.wallDamage:play()
		self.fields.Com_wallEffect:stopAllActions()
		self.fields.Com_wallEffect:setVisible(true)
		self.fields.Com_wallEffect:setPlay(true)
	end
end
function TowerDefendPanel:hideCityWallHitEffect()
	towerDefendRead = nil
	;(nil)[1] = ffa.delay(towerDefendRead.getGameConfig().differenceTime)
	;(nil)[2] = ffa.callFunc(function()
		self.wallDamageFlag = false
		self.fields.Com_wallEffect:setVisible(false)
		self.fields.Com_wallEffect:setPlay(false)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.wallDamageFlag = false
		self.fields.Com_wallEffect:setVisible(false)
		self.fields.Com_wallEffect:setPlay(false)
	end)
	local seq = ffa.seq(nil)
	self.fields.Com_wallEffect:runAction(seq)
end
function TowerDefendPanel:onClickTowerBuildHide()
	for i = 1, 2 do
		self.fields["n" .. i]:resetState()
	end
	self.fields.Com_mainTower:resetState()
end
function TowerDefendPanel:endShow()
	print("=======TowerDefendPanel:endShow")
	towerDefendRead.setPanelRealHeight(self:getHeight())
	self.posLength = self.fields.Image_referWidth:getWidth() / towerDefendRead.getGameConfig().bornPoint
	self.offset = self.fields.Image_referWidth:getPositionX() + (self.posLength - self.fields.Com_monster:getWidth()) / 2
	self.screenSize = self:getWidth()
	self.skillWidthStep = self:getWidth() / 3
	local yh = self.fields.referLine:getPositionY()
	self.skillHeightStep = yh / 3
	self.fields.n123:setPositionY(self.skillWidthStep)
	self.fields.n124:setPositionY(self.skillWidthStep * 2)
	self.fields.n121:setPositionY(self.skillHeightStep)
	self.fields.n122:setPositionY(self.skillHeightStep * 2)
	self.fields.n127:setPositionY(self.skillHeightStep * 3)
	self:initData()
end
function TowerDefendPanel:test()
	self.fields.Com_monster:setItVisible(true)
	self.fields.Com_monster:setVisible(true)
	local offset = (self.posLength - self.fields.Com_monster:getWidth()) / 2
	for i = 1, towerDefendRead.getGameConfig().bornPoint do
		local comp = fgui.UIPackage:createObjectFromURL("ui://TowerDefend/Com_monster")
		comp:setPosition(offset + self.fields.Com_monster:getPositionX() + self.posLength * (i - 1), 100)
		comp:setVisible(true)
		comp:initData(1, 101, 1, comp, 1)
		comp:addTo(self.fields.Com_monster)
		comp:setTip(i)
		comp:playBornAnim()
		self.fields.Com_monster:setPositionY(400)
	end
end
function TowerDefendPanel:onHide()
	print("=======TowerDefendPanel:onHide")
end
function TowerDefendPanel:onDispose()
	print("=======TowerDefendPanel:onDispose")
end
return TowerDefendPanel
