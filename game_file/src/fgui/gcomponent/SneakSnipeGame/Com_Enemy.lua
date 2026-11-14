local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Enemy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SneakSnipeGame/Com_Enemy", Com_Enemy)
_ENV = fgui.register_extension
fgui.register_extension.stand = 1
fgui.register_extension.walk = 2
fgui.register_extension.fight = 3
local fgui.register_extension.dead, status = 4, fgui.register_extension
local walkSpeed = 0.023
function Com_Enemy:onInit()
	self.fields.Com_sigh:setVisible(false)
	self.fields.bloodEffect:setAllFrameName("dh_qxjj_gjsj_%02d.png", 1)
	self.fields.bowEffect:setAllFrameName("dh_qxjj_gjsf_%02d.png", 1)
end
function Com_Enemy:onShow()
end
function Com_Enemy:endSigh()
	self.fields.Com_sigh:setVisible(false)
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self.fields.attack:setAllFrameName("sjxyx_gj_%02d.png", 1)
	self.fields.attack:setPlaySettings(0, 12, 1, -1, function()
		_ENV = nil
		;(nil)[1] = ffa.delay(math.random(constantRead.getConstValue("SNIPE_ENEMYSHOT_MIN", 20), constantRead.getConstValue("SNIPE_ENEMYSHOT_MAX", 40)) / 10)
		;(nil)[2] = ffa.callFunc(function()
			if self.isFinish then
				self:toStand()
				return
			end
			self.fields.attack:setPlaySettings(13, 12, 1, -1)
			self.fields.bowEffect:setVisible(true)
			self.fields.bowEffect:setPlaySettings(0, 9, 1, -1, function()
				if self.isFinish then
					self:toStand()
				end
			end)
			self = self.fields.bowEffect
			self.fields.bowEffect.msg = "MESSAGE_SNEAK_SNIPE_GAME_SUBBLOOD"
			SoraDSendMessage(self.fields.bowEffect)
		end)
		;(nil)[3] = ffa.callFunc(function()
			if self.isFinish then
				self:toStand()
				return
			end
			self.fields.attack:setPlaySettings(13, 12, 1, -1)
			self.fields.bowEffect:setVisible(true)
			self.fields.bowEffect:setPlaySettings(0, 9, 1, -1, function()
				if self.isFinish then
					self:toStand()
				end
			end)
			self = self.fields.bowEffect
			self.fields.bowEffect.msg = "MESSAGE_SNEAK_SNIPE_GAME_SUBBLOOD"
			SoraDSendMessage(self.fields.bowEffect)
		end)
		;(nil)[4] = ffa.callFunc(function()
			if self.isFinish then
				self:toStand()
				return
			end
			self.fields.attack:setPlaySettings(13, 12, 1, -1)
			self.fields.bowEffect:setVisible(true)
			self.fields.bowEffect:setPlaySettings(0, 9, 1, -1, function()
				if self.isFinish then
					self:toStand()
				end
			end)
			self = self.fields.bowEffect
			self.fields.bowEffect.msg = "MESSAGE_SNEAK_SNIPE_GAME_SUBBLOOD"
			SoraDSendMessage(self.fields.bowEffect)
		end)
		;(nil)[5] = ffa.callFunc(function()
			if self.isFinish then
				self:toStand()
				return
			end
			self.fields.attack:setPlaySettings(13, 12, 1, -1)
			self.fields.bowEffect:setVisible(true)
			self.fields.bowEffect:setPlaySettings(0, 9, 1, -1, function()
				if self.isFinish then
					self:toStand()
				end
			end)
			self = self.fields.bowEffect
			self.fields.bowEffect.msg = "MESSAGE_SNEAK_SNIPE_GAME_SUBBLOOD"
			SoraDSendMessage(self.fields.bowEffect)
		end)
		;(nil)[6] = ffa.callFunc(function()
			if self.isFinish then
				self:toStand()
				return
			end
			self.fields.attack:setPlaySettings(13, 12, 1, -1)
			self.fields.bowEffect:setVisible(true)
			self.fields.bowEffect:setPlaySettings(0, 9, 1, -1, function()
				if self.isFinish then
					self:toStand()
				end
			end)
			self = self.fields.bowEffect
			self.fields.bowEffect.msg = "MESSAGE_SNEAK_SNIPE_GAME_SUBBLOOD"
			SoraDSendMessage(self.fields.bowEffect)
		end)
		self:runAction(ffa.repeatForever(ffa.seq(nil)))
	end)
end
function Com_Enemy:toFight(delayTime)
	if self.status == status.fight then
		return
	end
	SoraDPlaySound("hideSnip", "snipe_danger")
	self.status = status.fight
	self.controllers.c1:setSelectedIndex(status.stand - 1)
	self:stopAllActions()
	_ENV = nil
	;(nil)[1] = ffa.delay(delayTime)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Com_sigh:setVisible(true)
		self.fields.Com_sigh:setTimeScale(2)
		self.fields.Com_sigh:setAllFrameName("dh_qxjj_gth_%02d.png", 1)
		self.fields.Com_sigh:setPlaySettings(0, -1, 1, -1, handler(self, self.endSigh))
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Com_sigh:setVisible(true)
		self.fields.Com_sigh:setTimeScale(2)
		self.fields.Com_sigh:setAllFrameName("dh_qxjj_gth_%02d.png", 1)
		self.fields.Com_sigh:setPlaySettings(0, -1, 1, -1, handler(self, self.endSigh))
	end)
	self:runAction(ffa.seq(nil))
	self.fields.stand:setAllFrameName("sjxyx_dj_%02d.png", 1)
	self.fields.stand:setPlaySettings(0, -1, 0, -1)
end
function Com_Enemy:toDead()
	if self.status == status.dead then
		return
	end
	SoraDPlaySound("hideSnip", "snipe_hit")
	self:setTouchEnabled(false)
	self.status = status.dead
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self:stopAllActions()
	self.fields.bloodEffect:setVisible(true)
	self.fields.bloodEffect:setPlaySettings(0, 18, 1, -1)
	self.fields.dead:setAllFrameName("sjxyx_sw_%02d.png", 1)
	self.fields.dead:setPlaySettings(0, -1, 1, -1, function()
		self:setVisible(false)
	end)
end
function Com_Enemy:toWalk(distance)
	if self.status == status.walk then
		return
	end
	print("Com_Enemy:toWalk")
	self.status = status.walk
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self:stopAllActions()
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.moveBy(math.abs(distance) * walkSpeed, distance, 0)
	;(nil)[2] = ffa.callFunc(function()
		self:setScaleX(-self:getScaleX())
	end)
	;(nil)[3] = ffa.moveBy(math.abs(distance) * walkSpeed, -distance, 0)
	;(nil)[4] = ffa.callFunc(function()
		self:setScaleX(-self:getScaleX())
	end)
	;(nil)[5] = ffa.callFunc(function()
		self:setScaleX(-self:getScaleX())
	end)
	;(nil)[6] = ffa.callFunc(function()
		self:setScaleX(-self:getScaleX())
	end)
	self:runAction(ffa.repeatForever(ffa.seq(nil)))
	self.fields.walk:setAllFrameName("sjxyx_yd_%02d.png", 1)
	self.fields.walk:setPlaySettings(0, -1, 0, -1)
end
function Com_Enemy:toStand()
	if self.status == status.stand then
		return
	end
	print("Com_Enemy:toStand")
	self.status = status.stand
	self:stopAllActions()
	self.controllers.c1:setSelectedIndex(self.status - 1)
	self.fields.stand:setAllFrameName("sjxyx_dj_%02d.png", 1)
	self.fields.stand:setPlaySettings(0, -1, 0, -1)
	self.fields.bowEffect:setVisible(false)
end
function Com_Enemy:changToFinish()
	self.isFinish = true
end
return Com_Enemy
