local towerDefendRead = include("towerDefendRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_dropCoin = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TowerDefend/Com_dropCoin", Com_dropCoin)
_ENV, Com_dropCoin.onInit = function(self)
end, function(self)
end
;(function(self)
end).IN = 1
local (function(self)
end).OUT, DropState = 2, function(self)
end
function Com_dropCoin:initData(gold, instance)
	self:stopAllActions()
	if not self.info then
		self.info, DropState = self.info, self.info
	end
	self.gold = gold
	self.info.state = DropState.IN
	self.info.instance = instance
end
local frameCount = 15
function Com_dropCoin:setTailLineRotation(angle, time)
	self.fields.Ani_load:runAction(ffa.rotateTo(0.1, angle))
	self.fields.icon:runAction(ffa.rotateTo(0.1, angle))
	self.frameRate = frameCount / time
end
function Com_dropCoin:dropShow()
	self.fields.icon:setAlpha(1)
	self.fields.icon:setRotation(0)
end
function Com_dropCoin:showFlyEffect()
	self:stopAllActions()
	local framesNpc = display.newFrames("dh_Tex_XL_mnttf09_%03d.png", 0, 15)
	local animationNpc = display.newAnimation(framesNpc, 0.06666666666666667)
	self.fields.Ani_load:setAnimation(animationNpc)
	self.fields.Ani_load:setPlaying(true)
	self.transitions.fly:play()
end
function Com_dropCoin:endFly()
	self:addCoin()
	self.info.state = DropState.OUT
	self.fields.Ani_load:setVisible(false)
	self.fields.Ani_load:setPlaying(false)
	self:stopAllActions()
	_ENV = nil
	;(nil)[1] = ffa.delay(0.5)
	;(nil)[2] = ffa.callFunc(function()
		towerDefendRead.addDropCoinObject(self.info.instance)
	end)
	;(nil)[3] = ffa.callFunc(function()
		towerDefendRead.addDropCoinObject(self.info.instance)
	end)
	self:runAction(ffa.seq(nil))
end
function Com_dropCoin:addCoin()
	_ENV = nil
	;(nil).msg = "MESSAGE_TOWER_DEFEND_GOLD_REFRESH"
	;(nil).bonus = self.gold
	SoraDSendMessage(nil)
end
function Com_dropCoin:onShow()
end
return Com_dropCoin
