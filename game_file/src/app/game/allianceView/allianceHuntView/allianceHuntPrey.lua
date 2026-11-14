local allianceHuntDesRead = include("allianceHuntDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
_ENV = gametop.playertop_
_ENV, gametop.playertop_.arrow_hurt = "allianceHuntCtrl", 1
;("allianceHuntCtrl")[1] = cc.c4f(0, 0, 1, 1)
;("allianceHuntCtrl")[2] = cc.c4f(0, 1, 0, 1)
;("allianceHuntCtrl")[3] = cc.c4f(0, 1, 1, 1)
gametop.playertop_.debugColor, ("allianceHuntCtrl")[4] = "allianceHuntCtrl", cc.c4f(1, 0, 0, 1)
gametop.playertop_.tag_walk = 300
gametop.playertop_.base_walk_time = 15
gametop.playertop_.preySpeedFastScale = 1.0
local _ENV, gametop.playertop_.preySpeedNomalScale, _defaultParam = "allianceHuntCtrl", 1.0, gametop.playertop_
;("allianceHuntCtrl").walk = 1
;("allianceHuntCtrl").attacked = 2
;("allianceHuntCtrl").dead = 3
local ("allianceHuntCtrl").recycle, AnimalState = 4, "allianceHuntCtrl"
local allianceHuntPrey = class("allianceHuntPrey", function()
	return display.newNode()
end)
function allianceHuntPrey:ctor()
	self.isDebug = gAllianceHuntDebug
	self.spPrey = display.newSprite("#dl_jl_yd_01.png")
	self.spPrey:addTo(self)
	self.isInRecycle = false
	self.speedMode = gAllianceHuntSpeedMode.NORMAL
end
function allianceHuntPrey:reset()
	self.isInRecycle = false
	self.state = AnimalState.walk
	self.spPrey:setOpacity(255)
end
function allianceHuntPrey:init(data, battleArea)
	self:reset()
	self.data = data
	self.battleArea = battleArea
	local preyCfg = allianceHuntDesRead.getPreyCfg(self.data.preyInfo.preyID)
	self.preySpeed = allianceHuntDesRead:getPrySpeed(self.data.preyInfo.preyID)
	self.preyTotalTime = _defaultParam.base_walk_time / (self.preySpeed / 100)
	self.speedScale = 1.0
	self.animScale = math.min(1, self.preyTotalTime / _defaultParam.base_walk_time)
	print("self.preyTotalTime = ", self.preyTotalTime, ", self.data.preyInfo.preyID  = ", self.data.preyInfo.preyID)
	self.preyCfg = preyCfg
	if preyCfg then
		self.spPrey:setSpriteFrame(preyCfg.defaultImg)
	end
	self:setPositionX(self.battleArea.spawnX)
	self:setPositionY(self:getRandomPosY())
	self:walk()
	self:updateZorder()
	self:initDebugView()
end
function allianceHuntPrey:updateZorder()
	local hitBox = self.preyCfg.hitBox
	local v = hitBox[1]
	local x, y, w, h = v[1], v[2], v[3], v[4]
	local yBottom = y - h / 2
	self:setLocalZOrder(display.height - (self:getPositionY() + yBottom))
	if not self.isDebug then
		return
	end
	self.zOrderPos = cc.p(0, yBottom)
	if not self.zOrderLabel then
		local labelName = ccui.Text:create()
		labelName:setFontSize(18)
		labelName:addTo(self)
		self.zOrderLabel = labelName
	end
	self.zOrderLabel:setString(display.height - (self:getPositionY() + yBottom))
	self.zOrderLabel:setPositionY(yBottom)
end
function allianceHuntPrey:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
		local drawNodeFrame = cc.DrawNode:create()
		drawNodeFrame:setName("debugNode2")
		drawNodeFrame:addTo(self, 2)
		drawNodeFrame:setPosition(cc.p(0, 0))
		self._drawNodeFrame = drawNodeFrame
	end
	self._debugNode:clear()
	self._drawNodeFrame:clear()
	local hitBox = self.preyCfg.hitBox
	for i, v in ipairs(hitBox) do
		local x, y, w, h = v[1], v[2], v[3], v[4]
		local yBottom = y - h / 2
		local beginX = x - w / 2
		local yTop = y + h / 2
		local endX = x + w / 2
		local center = cc.p(x, y)
		local lb = cc.p(beginX, yBottom)
		local lt = cc.p(beginX, yTop)
		local rt = cc.p(endX, yTop)
		local rb = cc.p(endX, yBottom)
		_UPVALUE4_ = cc.p(0, 0)
		cc.p(0, 0)[1] = lb
		cc.p(0, 0)[2] = lt
		cc.p(0, 0)[3] = rt
		cc.p(0, 0)[4] = rb
		self._debugNode:drawPoly(cc.p(0, 0))
		self._debugNode:drawPoint(center, 8, _defaultParam.debugColor[i])
	end
	self._debugNode:drawPoint(self.zOrderPos, 8, _defaultParam.debugColor[2])
	do
		local spContentSize = self.spPrey:getContentSize()
		local halfw = spContentSize.width / 2
		local halfh = spContentSize.height / 2
		local lb = cc.p(-halfw, -halfh)
		local lt = cc.p(-halfw, halfh)
		local rt = cc.p(halfw, halfh)
		local rb = cc.p(halfw, -halfh)
		_UPVALUE4_ = y - h / 2
		;(y - h / 2)[1] = lb
		;(y - h / 2)[2] = lt
		;(y - h / 2)[3] = rt
		;(y - h / 2)[4] = rb
		self._drawNodeFrame:drawPoly(y - h / 2, 4, true, _defaultParam.debugColor[4])
		self._drawNodeFrame:drawPoint(cc.p(0, 0), 8, _defaultParam.debugColor[4])
	end
end
function allianceHuntPrey:getRandomPosY()
	local roadIndex = self.data.roadIndex
	local beginY = self.battleArea.roadH[roadIndex]
	print("roadIndex = ", roadIndex, ", beginY = ", beginY)
	local randomY = beginY + math.random(1, self.battleArea.singleH)
	return randomY
end
function allianceHuntPrey:walk()
	self:stopAllActionsByTag(_defaultParam.tag_walk)
	self.state = AnimalState.walk
	self:playWalkAnim()
	local speedScale = self:getSpeedScale()
	local dt = self.preyTotalTime / speedScale
	dt = (self.battleArea.endX - self:getPositionX()) / (self.battleArea.endX - self.battleArea.spawnX) * dt
	local x = self.battleArea.endX
	local y = self:getPositionY()
	local moveTo = cca.moveTo(dt, x, y)
	local recycleFunc = cca.callFunc(function()
		self:recycleSelf()
	end)
	_ENV = y
	y[1] = moveTo
	y[2] = recycleFunc
	local seq = cca.seq(y)
	seq:setTag(_defaultParam.tag_walk)
	self:runAction(seq)
end
function allianceHuntPrey:getSpeedScale()
	do return 1.0 end
	local speedScale = _defaultParam.preySpeedNomalScale
	if self.speedMode == gAllianceHuntSpeedMode.NORMAL then
		speedScale = _defaultParam.preySpeedNomalScale
	elseif self.speedMode == gAllianceHuntSpeedMode.FAST then
		speedScale = _defaultParam.preySpeedFastScale
	end
	return speedScale
end
function allianceHuntPrey:hit(attackData)
	if self.data.preyInfo.hp == 0 then
		return 0
	end
	local attackType = attackData.attackType
	self.attackType = attackType
	local monsterIndex = self.data.generateIndex
	local hitType
	if attackType == ATTACK_TYPE.ATTACK_HEAD then
		self.data.preyInfo.hp = 0
		hitType = HUNTING_HIT_TYPE.SUPER_ATTACK
	elseif attackType == ATTACK_TYPE.ATTACK_BODY then
		self.data.preyInfo.hp = self.data.preyInfo.hp - 1
		hitType = HUNTING_HIT_TYPE.NORMAL_ATTACK
	end
	SoraDPlaySound("huntSound", "hunt_CrossBow_impact")
	SoraDPlaySound("huntSound", self.data.preyInfo.preyID)
	if self.data.preyInfo.hp == 0 then
		self:playDeadAnim()
		self:playHitLabelAnim()
		self:playScoreAnim()
		return self.data.preyInfo.killPoint
	else
		self:playHitAnim()
		self:playHitLabelAnim()
	end
	return 0
end
function allianceHuntPrey:isAlive()
	return self.data.preyInfo.hp > 0
end
function allianceHuntPrey:getArrowNum()
	return self.data.preyInfo.arrowNum
end
function allianceHuntPrey:playHitLabelAnim()
	local str
	if self.attackType == ATTACK_TYPE.ATTACK_HEAD then
		self:playHeadShotAnim()
		return
	elseif self.attackType == ATTACK_TYPE.ATTACK_BODY then
		str = i18n("alliance_hunt_text_13")
	end
	local parentView = self:getParent()
	local text = HtmlRichText:create("", "", 24)
	text:addTo(parentView, allianceHuntDesRead.zOrder.z_hurt_text)
	text:setPosition(cc.p(self:getPositionX() + 60, self:getPositionY() + 80))
	text:setString(str)
	local dt = 0.3
	local moveH = 80
	local moveBy = cca.moveBy(dt, 0, moveH)
	local callFunc = cca.callFunc(function()
		text:removeFromParent()
		self.nodeText = nil
	end)
	local baseScale = 1.0
	local fadeOut = cca.fadeOut(dt)
	_UPVALUE3_ = cc.p(self:getPositionX() + 60, self:getPositionY() + 80)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[1] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[2] = cca.scaleTo(0.05, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[3] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[4] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[5] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[6] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seq = cca.seq(cc.p(self:getPositionX() + 60, self:getPositionY() + 80))
	_UPVALUE2_ = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	cca.scaleTo(0.08333333333333333, 1.68 * baseScale)[1] = moveBy
	cca.scaleTo(0.08333333333333333, 1.68 * baseScale)[2] = fadeOut
	local spawn = cca.spawn((cca.scaleTo(0.08333333333333333, 1.68 * baseScale)))
	_UPVALUE3_ = moveBy
	moveBy[1] = seq
	moveBy[2] = spawn
	moveBy[3] = callFunc
	local seq2 = cca.seq(moveBy)
	self.nodeText = text
	text:runAction(seq2)
end
function allianceHuntPrey:playArrowLabelAnim(delay)
	local str
	_ENV = nil
	;(nil).num = self.data.preyInfo.arrowNum
	str = i18n("alliance_hunt_text_32", nil)
	local parentView = self:getParent()
	local text = HtmlRichText:create("", "", 22)
	text:addTo(parentView, allianceHuntDesRead.zOrder.z_hurt_text)
	text:setPosition(cc.p(self:getPositionX() + 60, self:getPositionY() + 60))
	text:setString(str)
	text:setVisible(false)
	local dt = 0.3
	local moveH = 80
	local moveBy = cca.moveBy(dt, 0, moveH)
	local callFunc = cca.callFunc(function()
		text:removeFromParent()
		self.nodeText1 = nil
	end)
	local baseScale = 1.0
	local fadeOut = cca.fadeOut(dt)
	_UPVALUE3_ = cc.p(self:getPositionX() + 60, self:getPositionY() + 60)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[1] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[2] = cca.scaleTo(0.05, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[3] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[4] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[5] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[6] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 60)[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seq = cca.seq(cc.p(self:getPositionX() + 60, self:getPositionY() + 60))
	local showFunc = cca.callFunc(function()
		text:setVisible(true)
	end)
	_UPVALUE2_ = cca.scaleTo(0.05, 1.0 * baseScale)
	cca.scaleTo(0.05, 1.0 * baseScale)[1] = moveBy
	cca.scaleTo(0.05, 1.0 * baseScale)[2] = fadeOut
	local spawn = cca.spawn((cca.scaleTo(0.05, 1.0 * baseScale)))
	_UPVALUE5_ = moveBy
	moveBy[1] = cca.delay(delay or 0)
	moveBy[2] = showFunc
	moveBy[3] = seq
	moveBy[4] = spawn
	moveBy[5] = callFunc
	local seq2 = cca.seq(moveBy)
	self.nodeText1 = text
	text:runAction(seq2)
end
function allianceHuntPrey:playHeroScore(delay)
	local curHeroScore = math.floor(self.data.preyInfo.killPoint * self.heroScoreRate - self.data.preyInfo.killPoint)
	if curHeroScore <= 0 then
		return
	end
	local str
	_ENV = nil
	;(nil).num = curHeroScore
	str = i18n("alliance_hunt_text_31", nil)
	local parentView = self:getParent()
	local text = HtmlRichText:create("", "", 20)
	text:addTo(parentView, allianceHuntDesRead.zOrder.z_hurt_text)
	text:setPosition(cc.p(self:getPositionX() + 60, self:getPositionY() + 30))
	text:setString(str)
	text:setVisible(false)
	local dt = 0.3
	local moveH = 80
	local moveBy = cca.moveBy(dt, 0, moveH)
	local callFunc = cca.callFunc(function()
		text:removeFromParent()
		self.nodeText2 = nil
	end)
	local baseScale = 1.0
	local fadeOut = cca.fadeOut(dt)
	_UPVALUE3_ = cc.p(self:getPositionX() + 60, self:getPositionY() + 30)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[1] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[2] = cca.scaleTo(0.05, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[3] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[4] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[5] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[6] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 30)[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seq = cca.seq(cc.p(self:getPositionX() + 60, self:getPositionY() + 30))
	local showFunc = cca.callFunc(function()
		text:setVisible(true)
	end)
	_UPVALUE2_ = cca.scaleTo(0.05, 1.0 * baseScale)
	cca.scaleTo(0.05, 1.0 * baseScale)[1] = moveBy
	cca.scaleTo(0.05, 1.0 * baseScale)[2] = fadeOut
	local spawn = cca.spawn((cca.scaleTo(0.05, 1.0 * baseScale)))
	_UPVALUE5_ = moveBy
	moveBy[1] = cca.delay(delay or 0)
	moveBy[2] = showFunc
	moveBy[3] = seq
	moveBy[4] = spawn
	moveBy[5] = callFunc
	local seq2 = cca.seq(moveBy)
	self.nodeText2 = text
	text:runAction(seq2)
end
function allianceHuntPrey:playHeadShotAnim()
	_ENV = nil
	;(nil).cssFileName = "et_ah_onekill"
	;(nil).loop = false
	;(nil).scheduler = self.myScheduler
	;(nil).actionManager = self.myActionManager
	;(nil).speed = 0.7
	local nodeHeadShot = SoraDCreatAnimationParam(nil)
	local parentView = self:getParent()
	nodeHeadShot:addTo(parentView, allianceHuntDesRead.zOrder.z_hurt_effect)
	nodeHeadShot:setPosition(cc.p(self:getPositionX() + 60, self:getPositionY() + 80))
	SoraDPlaySound("huntSound", "hunt_hit_once")
	local delay1 = cca.delay(0.2)
	local callFunc1 = cca.callFunc(function()
		local etParticle = SoraDGetChildByName(nodeHeadShot, "et_particle_fade")
		etParticle:resetSystem()
	end)
	local delay2 = cca.delay(0.4)
	local callFunc2 = cca.callFunc(function()
		nodeHeadShot:removeFromParent()
		self.nodeHeadShot = nil
	end)
	_UPVALUE4_ = cc.p(self:getPositionX() + 60, self:getPositionY() + 80)
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[1] = delay1
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[2] = callFunc1
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[3] = delay2
	cc.p(self:getPositionX() + 60, self:getPositionY() + 80)[4] = callFunc2
	local seq = cca.seq(cc.p(self:getPositionX() + 60, self:getPositionY() + 80))
	self.nodeHeadShot = nodeHeadShot
	nodeHeadShot:runAction(seq)
end
function allianceHuntPrey:setBattleView(battleView)
	self.battleView = battleView
end
function allianceHuntPrey:checkAndPlayEnergyAnim()
end
function allianceHuntPrey:playDeadAnim()
	self.state = AnimalState.dead
	local reskey = "alliancehunt"
	local preyCfg = self.preyCfg
	local count = preyCfg.deadImgCfg.aend - preyCfg.deadImgCfg.astart + 1
	local imgformat = preyCfg.deadImgCfg.imgformat
	local firstImg = string.format(imgformat, preyCfg.deadImgCfg.astart)
	self.spPrey:setSpriteFrame(firstImg)
	local frames = display.newFrames(imgformat, preyCfg.deadImgCfg.astart, preyCfg.deadImgCfg.aend - preyCfg.deadImgCfg.astart + 1)
	local animation = display.newAnimation(frames, 0.03333333333333333)
	animation = cc.Animate:create(animation)
	self.spPrey:stopAllActions()
	local delay = 0
	self:stopWalk()
	self:playAnimationOnce(self.spPrey, animation, delay, cca.delay(0), cca.callFunc(function()
		self:afterDeadAnim()
	end))
	if self.data.preyInfo.preyID == 1600 then
		local dt = 0.16666666666666666
		local targetY = self.battleArea.roadH[3] + self.battleArea.singleH
		self:runAction(cca.moveTo(dt, self:getPositionX(), targetY))
	end
end
function allianceHuntPrey:afterDeadAnim()
	print("---进行回收操作")
	local time_out = 2.0
	_UPVALUE1_ = nil
	;(nil)[1] = cca.fadeOut(time_out)
	;(nil)[2] = cca.callFunc(function()
		self:recycleSelf()
	end)
	;(nil)[3] = cca.callFunc(function()
		self:recycleSelf()
	end)
	local seq = cca.seq(nil)
	self.spPrey:runAction(seq)
end
function allianceHuntPrey:recycleSelf()
	self.state = AnimalState.recycle
	self:setVisible(false)
	self.isInRecycle = true
	self:stopAllActions()
	local parentView = self:getParent()
	if parentView and parentView.recyclePrey then
		parentView:recyclePrey(self)
	end
end
function allianceHuntPrey:playScoreAnim()
	local numScale = 1.0
	local curNum = self.data.preyInfo.killPoint
	curNum = math.floor(curNum * numScale)
	_ENV = nil
	;(nil).text = "+" .. curNum
	;(nil).actType = 1
	self:SoraDCreateWaveBMP(nil)
	self:playHeroScore(0.5)
	if self.data.preyInfo.hp == 0 and 0 < self.data.preyInfo.arrowNum then
		self:playArrowLabelAnim(0.4)
	end
end
function allianceHuntPrey:playWalkAnim()
	local reskey = "alliancehunt"
	local preyCfg = self.preyCfg
	local imgformat = preyCfg.walkImgCfg.imgformat
	local firstImg = string.format(imgformat, preyCfg.walkImgCfg.astart)
	self.spPrey:setSpriteFrame(firstImg)
	local count = preyCfg.walkImgCfg.aend - preyCfg.walkImgCfg.astart + 1
	local frames = display.newFrames(imgformat, preyCfg.walkImgCfg.astart, preyCfg.walkImgCfg.aend - preyCfg.walkImgCfg.astart + 1)
	local speedScale = self:getSpeedScale()
	local animation = display.newAnimation(frames, 0.03333333333333333)
	self.spPrey:stopAllActions()
	local delay = 0
	animation = cc.Animate:create(animation)
	self:playAnimationForever(self.spPrey, animation, delay)
end
function allianceHuntPrey:playAnimationForever(target, animation, delay)
	local action
	if type(delay) == "number" and 0 < delay then
		_UPVALUE3_ = delay
		delay[1] = cc.DelayTime:create(delay)
		delay[2] = cc.Show:create()
		delay[3] = animation
		local sequence = transition.sequence(delay)
		action = cc.RepeatForever:create(sequence)
	else
		action = cc.RepeatForever:create(animation)
	end
	target:runAction(action)
	return action
end
function allianceHuntPrey:playAnimationOnce(target, animation, delay, afterDelay, afterCallBack)
	local action
	if type(delay) == "number" and 0 < delay then
		_UPVALUE5_ = delay
		delay[1] = cc.DelayTime:create(delay)
		delay[2] = cc.Show:create()
		delay[3] = animation
		delay[4] = afterDelay
		delay[5] = afterCallBack
		local sequence = transition.sequence(delay)
		action = sequence
	else
		_UPVALUE3_ = delay
		delay[1] = animation
		delay[2] = afterDelay
		delay[3] = afterCallBack
		local sequence = transition.sequence(delay)
		action = sequence
	end
	target:runAction(action)
	return action
end
function allianceHuntPrey:stopWalk()
	self:stopAllActionsByTag(_defaultParam.tag_walk)
end
function allianceHuntPrey:resumeWalk()
	print("allianceHuntPrey:resumeWalk()---------------------")
	self:walk()
end
function allianceHuntPrey:playHitAnim()
	self.state = AnimalState.attacked
	local preyCfg = self.preyCfg
	local count = preyCfg.attackImgCfg.aend - preyCfg.attackImgCfg.astart + 1
	local imgformat = preyCfg.attackImgCfg.imgformat
	local firstImg = string.format(imgformat, preyCfg.attackImgCfg.astart)
	self.spPrey:setSpriteFrame(firstImg)
	local frames = display.newFrames(imgformat, preyCfg.attackImgCfg.astart, preyCfg.attackImgCfg.aend - preyCfg.attackImgCfg.astart + 1)
	local animation = display.newAnimation(frames, 0.03333333333333333)
	animation = cc.Animate:create(animation)
	self.spPrey:stopAllActions()
	local delay = 0
	self:stopWalk()
	self:playAnimationOnce(self.spPrey, animation, delay, cca.delay(0), cca.callFunc(function()
		self:resumeWalk()
	end))
end
function allianceHuntPrey:hitTest(worldPoint)
	local nodePoint = self:convertToNodeSpace(worldPoint)
	local hitRect = self.preyCfg.hitRect
	local isHitHead = cc.rectContainsPoint(hitRect[2], nodePoint)
	if isHitHead then
		print("打中了头部------", self.data.preyInfo.preyID)
		return ATTACK_TYPE.ATTACK_HEAD
	end
	local isHitBody = cc.rectContainsPoint(hitRect[1], nodePoint)
	if isHitBody then
		print("打中了身体------", self.data.preyInfo.preyID)
		return ATTACK_TYPE.ATTACK_BODY
	end
	return ATTACK_TYPE.ATTACK_NONE
end
function allianceHuntPrey:SoraDCreateWaveBMP(actionData)
	local _ENV, text = nil, actionData.text or "NA"
	;(nil).color = cc.c3b(255, 255, 0)
	;(nil).fontSize = 18
	;(nil).pos = cc.p(140, -80)
	;(nil).zOrder = 10
	;(nil).duration = 0.4
	;(nil).moveH = 155
	;(nil).scale = 1.0
	local (nil).font, param = "res/fonts/font_gold.fnt", nil
	local waveLabel
	local parentView = self:getParent()
	local nodeEffect = display.newNode()
	nodeEffect:setScale(0.7)
	nodeEffect:addTo(parentView, allianceHuntDesRead.zOrder.z_hurt_text)
	nodeEffect:setPosition(cc.p(self:getPositionX() + 80, self:getPositionY() - 80))
	_ENV = nodeEffect
	nodeEffect.text = text
	nodeEffect.font = param.font
	waveLabel = display.newBMFontLabel(nodeEffect)
	waveLabel:addTo(nodeEffect, param.zOrder)
	waveLabel:setCascadeColorEnabled(false)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(cc.p(-50, 172))
	SoraDSetNodeSchedulerAndManager(waveLabel, self.myScheduler, self.myActionManager)
	local baseScale = param.scale
	waveLabel:setScale(0.1 * baseScale)
	waveLabel:setOpacity(0)
	_UPVALUE6_ = waveLabel
	allianceHuntDesRead = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	waveLabel[1] = cca.delay(0.06666666666666667)
	waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
	waveLabel[3] = cca.spawn(0.24)
	waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(waveLabel)
	local moveBy = cca.moveBy(param.duration, 0, param.moveH)
	local fadeTo = cca.fadeTo(param.duration, 0)
	_UPVALUE2_ = 0
	;(0)[1] = moveBy
	;(0)[2] = fadeTo
	local spawn = cca.spawn(0)
	local callFunc = cca.callFunc(function()
		waveLabel:removeFromParent()
		self.waveLabel = nil
	end)
	_UPVALUE3_ = fadeTo
	fadeTo[1] = seqPrepare
	fadeTo[2] = spawn
	fadeTo[3] = callFunc
	local seq = cca.seq(fadeTo)
	self.waveLabel = waveLabel
	waveLabel:runAction(seq)
	return waveLabel
end
function allianceHuntPrey:getIsInRecycle()
	return self.isInRecycle
end
function allianceHuntPrey:updateAnimation()
	if self.state == AnimalState.walk then
		self:walk()
	end
end
function allianceHuntPrey:setSpeedMode(speedMode)
	self.speedMode = speedMode
	if self.speedMode == gAllianceHuntSpeedMode.FAST then
		print("加速模式开启--------------")
	end
	self:updateAnimation()
end
function allianceHuntPrey:setHeroScoreRate(heroScoreRate)
	self.heroScoreRate = heroScoreRate
end
function allianceHuntPrey:initSchedulerAndManager(customScheduler, actionManager)
	print("设定自定义的scheduler-----")
	self.myScheduler = customScheduler
	_UPVALUE2_, self.myActionManager = print, actionManager
	print[1] = self
	local print[2], nodes = self.spPrey, print
	SoraDSetNodesSchedulerAndManager(nodes, self.myScheduler, self.myActionManager)
end
function allianceHuntPrey:pause()
	_UPVALUE7_ = nil
	;(nil)[1] = self
	;(nil)[2] = self.nodeText
	;(nil)[3] = self.nodeText1
	;(nil)[4] = self.nodeText2
	;(nil)[5] = self.spPrey
	;(nil)[6] = self.waveLabel
	local (nil)[7], targets = self.nodeHeadShot, nil
	for k, v in pairs(targets) do
		v:getActionManager():pauseTarget(v)
	end
end
function allianceHuntPrey:resume()
	_UPVALUE7_ = nil
	;(nil)[1] = self
	;(nil)[2] = self.nodeText
	;(nil)[3] = self.nodeText1
	;(nil)[4] = self.nodeText2
	;(nil)[5] = self.spPrey
	;(nil)[6] = self.waveLabel
	local (nil)[7], targets = self.nodeHeadShot, nil
	for k, v in pairs(targets) do
		v:getActionManager():resumeTarget(v)
	end
end
return allianceHuntPrey
