local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_monster = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_monster", Com_monster)
_ENV = fgui.register_extension
fgui.register_extension.ALIVE = 1
fgui.register_extension.DIE = 2
local _ENV, fgui.register_extension.INDEAD, MonsterState = "ui://TowerDefend/Com_monster", 3, fgui.register_extension
;("ui://TowerDefend/Com_monster").SOLDIER = 101
;("ui://TowerDefend/Com_monster").GENERAL = 102
local ("ui://TowerDefend/Com_monster").BOSS, MosterID = 103, "ui://TowerDefend/Com_monster"
function Com_monster:onInit()
	self.fields.Ani_lei:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Ani_lei:setScale(1.5)
	self:setVisible(false)
end
function Com_monster:registerEvent()
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_PAUSE", handler(self, self.gamePause))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_CONTINUE", handler(self, self.gameContinue))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_FAIL", handler(self, self.gameFail))
end
function Com_monster:gameFail(target, retData)
	self:stopAllActions()
	self.fields.Ani_load:setTimeScale(0)
end
function Com_monster:gamePause()
	self.fields.Ani_load:setTimeScale(0)
end
function Com_monster:gameContinue()
	self.fields.Ani_load:setTimeScale(1)
end
local uniqueUid = 0
function Com_monster:initData(index, monsterID, level, instance, uniqueUid)
	self:stopAllActions()
	if monsterID == nil or level == nil then
		return
	end
	if not self.data then
		self.data, towerDefendRead = self.data, self.data
	end
	local monsterInfo = towerDefendRead.getMonsterInfoByIDLevel(monsterID, level)
	self.data.info = monsterInfo
	self.data.uniqueUid = uniqueUid
	uniqueUid = uniqueUid + 1
	self.data.state = MonsterState.ALIVE
	self.data.instance = instance
	self.data.canMove = false
	self.data.slowDown = 1
	self.data.hp = self.data.info.hp
end
function Com_monster:clearInfo()
	self.data.state = MonsterState.DIE
	self.data.info, MonsterState = MonsterState.DIE, MonsterState.DIE
	self.data.canMove = false
	self.data.slowDown = 1
	self.data.hp = 0
end
function Com_monster:setTableIndex(pos)
	self.tableIndex = pos
end
function Com_monster:getTableIndex(pos)
	return self.tableIndex
end
function Com_monster:getInfo()
	return self.data
end
local time = 1
function Com_monster:getHurt(damage, slowdown, noEnergy)
	self.data.canMove = false
	if self.data.state == MonsterState.ALIVE and damage >= self.data.hp then
		SoraDManagerRemoveTimerByTarget(self)
		self.data.hp = 0
		self.data.state = MonsterState.DIE
		self.fields.Ani_lei:setVisible(false)
		self:playDieAnimation()
		towerDefendRead.increaseKillNum()
		if not noEnergy then
			MonsterState = self
			self.msg = "MESSAGE_TOWER_DEFEND_DROPCOIN_EFFECT"
			self.bonus = self.data.info.killBonus
			self.pos = self:getPosition()
			SoraDSendMessage(self)
			MonsterState = self
			self.msg = "MESSAGE_TOWER_DEFEND_ENERGY_REFRESH"
			self.energy = self.data.info.killEnergy
			SoraDSendMessage(self)
		else
			MonsterState = self
			self.msg = "MESSAGE_TOWER_DEFEND_DROPCOIN_EFFECT"
			self.bonus = self.data.info.killBonus
			self.pos = self:getPosition()
			SoraDSendMessage(self)
		end
		return
	end
	self.data.hp = self.data.hp - damage
	if slowdown and slowdown[1] ~= 0 then
		self.data.slowDown = 1 - slowdown[1] * 0.001
		self.slowdown = slowdown
		self:playSlowDownAnim()
	end
	self.slowdown = slowdown
	self:playHurtAnim()
end
function Com_monster:playSlowDownAnim()
	local framesNpc = display.newFrames("dh_Tex_XL_mnytf02_%03d.png", 0, 11)
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_lei:setAnimation(animationNpc)
	self.fields.Ani_lei:setVisible(true)
	self.fields.Ani_lei:setPlaying(true)
	self.fields.Ani_lei:setPlaySettings(1, -1, 10, -1, function()
		self.fields.Ani_lei:setVisible(false)
		self.fields.Ani_lei:setPlaying(false)
		if self.slowdown ~= 0 then
			self.data.slowDown = 1
		end
	end)
end
function Com_monster:playAtk()
	if self.data.state == MonsterState.DIE then
		SoraDManagerRemoveTimerByTarget(self)
		return
	end
	self.data.canMove = false
	self:generateAttackImmediately()
end
function Com_monster:generateAttackImmediately()
	if self.data.state == MonsterState.DIE then
		SoraDManagerRemoveTimerByTarget(self)
		return
	end
	if self.generateTimeHandle then
		SoraDManagerRemoveTimer(self, self.generateTimeHandle)
	end
	self.generateTimeHandle = SoraDCreateDelayTimer(self, function()
		self:playAtkAnim()
	end, 0)
end
function Com_monster:generateAttackByInterval()
	if self.data.state == MonsterState.DIE then
		SoraDManagerRemoveTimerByTarget(self)
		return
	end
	if self.generateTimeHandle then
		SoraDManagerRemoveTimer(self, self.generateTimeHandle)
	end
	self.generateTimeHandle = SoraDCreateDelayTimer(self, function()
		self:playAtkAnim()
	end, self.data.info.atkSpeed)
end
_ENV, Com_monster.generateAttack = function(self)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
	;(nil).atk = self.data.info.atk
	SoraDSendMessage(nil)
end, function(self)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
	;(nil).atk = self.data.info.atk
	SoraDSendMessage(nil)
end
;(function(self)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
	;(nil).atk = self.data.info.atk
	SoraDSendMessage(nil)
end)[101] = 24
;(function(self)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
	;(nil).atk = self.data.info.atk
	SoraDSendMessage(nil)
end)[102] = 24
local _ENV, (function(self)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
	;(nil).atk = self.data.info.atk
	SoraDSendMessage(nil)
end)[103], bornFrameCount = nil, 0, function(self)
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_CITYWALL_STATE"
	;(nil).atk = self.data.info.atk
	SoraDSendMessage(nil)
end
;(nil)[101] = 24
;(nil)[102] = 24
local _ENV, (nil)[103], walkFrameCount = nil, 24, nil
;(nil)[101] = 24
;(nil)[102] = 24
local _ENV, (nil)[103], atkFrameCount = nil, 24, nil
;(nil)[101] = 16
;(nil)[102] = 16
local _ENV, (nil)[103], hurtFrameCount = nil, 16, nil
;(nil)[101] = 24
;(nil)[102] = 24
local (nil)[103], standbyFrameCount = 24, nil
local dieFrameCount = 23
function Com_monster:playBornAnim()
	local bornAniName = towerDefendRead.monsterConfig[self.data.info.monsterID].monsterBorn
	local seq
	if self.data.info.monsterID == 103 then
		self.fields.Ani_load:setVisible(true)
		self.fields.Ani_load:setPlaying(true)
		self:playWalkAnim()
		self.data.canMove = true
		self:setVisible(true)
	else
		local framesNpc = display.newFrames(bornAniName, 1, bornFrameCount[self.data.info.monsterID])
		local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
		self.fields.Ani_load:setAnimation(animationNpc)
		self.fields.Ani_load:setVisible(true)
		self.fields.Ani_load:setPlaying(true)
		self:setVisible(true)
		self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
			self.data.canMove = true
			self:playWalkAnim()
		end)
	end
end
function Com_monster:playStandbyAnim()
	local framesNpc = display.newFrames(towerDefendRead.monsterConfig[self.data.info.monsterID].monsterStandby, 1, standbyFrameCount[self.data.info.monsterID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaySettings(1, -1, -1, -1)
end
function Com_monster:playWalkAnim()
	local framesNpc = display.newFrames(towerDefendRead.monsterConfig[self.data.info.monsterID].monsterWalk, 1, walkFrameCount[self.data.info.monsterID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaySettings(1, -1, -1, -1)
end
function Com_monster:playAtkAnim()
	if self.data.state == MonsterState.DIE then
		SoraDManagerRemoveTimerByTarget(self)
		self:playDieAnimation()
		return
	end
	local framesNpc = display.newFrames(towerDefendRead.monsterConfig[self.data.info.monsterID].monsterAtk, 1, atkFrameCount[self.data.info.monsterID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
		self:generateAttack()
		self:generateAttackByInterval()
		self:playStandbyAnim()
	end)
end
function Com_monster:playHurtAnim()
	local framesNpc = display.newFrames(towerDefendRead.monsterConfig[self.data.info.monsterID].monsterHurt, 1, hurtFrameCount[self.data.info.monsterID])
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.data.canMove = false
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
		self.data.canMove = true
		self:playWalkAnim()
	end)
end
function Com_monster:playDieAnimation()
	local framesNpc = display.newFrames(towerDefendRead.monsterConfig[self.data.info.monsterID].monsterDie, 1, dieFrameCount)
	local animationNpc = display.newAnimation(framesNpc, 0.03333333333333333)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaySettings(1, -1, 1, -1, function()
		self.fields.Ani_load:setPlaying(false)
		self.data.instance:setVisible(false)
		self:clearInfo()
		_ENV = nil
		;(nil)[1] = ffa.delay(3)
		;(nil)[2] = ffa.callFunc(function()
			towerDefendRead.addDeadMonsterObject(self:getTableIndex())
		end)
		;(nil)[3] = ffa.callFunc(function()
			towerDefendRead.addDeadMonsterObject(self:getTableIndex())
		end)
		self:runAction(ffa.seq(nil))
	end)
end
function Com_monster:setItVisible(flag)
end
function Com_monster:setTip(str)
	self.fields.Text_tip:setString(str)
end
function Com_monster:onShow()
end
return Com_monster
