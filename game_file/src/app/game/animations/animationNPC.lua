local animationNPC = class("animationNPC", function(target)
	if target == nil then
		return SoraDCreateBasePanel("animationNPC")
	end
	return target
end)
function animationNPC:ctor()
	self:setContentSize(cc.size(0, 0))
	self:setPosition(cc.p(0, 0))
	self.nodeNPC = SoraDGetChildByName(self, "Center_Node_npc")
	self.eyes = SoraDGetChildByName(self.nodeNPC, "et_MM_yanpi")
	self.animationGirlNPC = self.nodeNPC:getActionByTag(self.nodeNPC:getTag())
	self.animationGirlNPC:gotoFrameAndPlay(0, true)
	self:playBlinkAction()
end
function animationNPC:setNPCScale(scale)
	self.nodeNPC:setScale(scale or 1)
end
function animationNPC:setNPCPosition(pos)
	pos = pos or cc.p(display.cx, display.cy)
	self.nodeNPC:setPosition(cc.p(pos.x, pos.y))
end
function animationNPC:setNPCFlippedX()
	self.nodeNPC:setPositionX(self:getContentSize().width - self.nodeNPC:getPositionX())
	self:setScaleX(-1)
end
function animationNPC:playBlinkAction()
	self.eyes:setScaleY(0)
	_UPVALUE3_ = self.eyes
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(0.1, 1)
	;(nil)[2] = cca.fadeIn(0.1)
	;(nil)[3] = cca.fadeIn(0.1)
	;(nil)[4] = cca.fadeIn(0.1)
	;(nil)[5] = cca.fadeIn(0.1)
	_UPVALUE1_ = cca.scaleTo(0.1, 1)
	cca.scaleTo(0.1, 1)[1] = cca.scaleTo(0.3, 1, 0)
	cca.scaleTo(0.1, 1)[2] = cca.fadeOut(0.2)
	cca.scaleTo(0.1, 1)[3] = cca.fadeOut(0.2)
	cca.scaleTo(0.1, 1)[4] = cca.fadeOut(0.2)
	self.eyes[1] = cca.delay(1)
	self.eyes[2] = cca.spawn(nil)
	self.eyes[3] = cca.spawn((cca.scaleTo(0.1, 1)))
	self.eyes[4] = cca.delay(1)
	self.eyes[5] = cca.delay(1)
	self.eyes[6] = cca.delay(1)
	self.eyes[7] = cca.delay(1)
	self.eyes[8] = cca.delay(1)
	local seq = transition.sequence(self.eyes)
	self.eyes:runAction(cc.RepeatForever:create(seq))
end
return animationNPC
