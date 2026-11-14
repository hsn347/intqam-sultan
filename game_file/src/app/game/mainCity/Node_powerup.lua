local Node_powerup = class("Node_powerup", function()
	return SoraDCreateBasePanel("Node_powerup")
end)
function Node_powerup:ctor()
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.effect = SoraDCreatAnimationEx("power_up", nil, false)
	self.effect:setVisible(false)
	self.effect:addTo(self.Node_effect)
	self.Node_t = SoraDGetChildByName(self, "Node_t")
	self.Text_power = SoraDGetChildByName(self, "Text_power")
	self.bg = SoraDGetChildByName(self, "frame_recharge__sheer_time_1")
	self.bg:setSpriteFrame("img_conmon_tipst.png")
	self.bg:setScale(1)
	self.bg:setOpacity(178.5)
end
function Node_powerup:playAct(data)
	local curPower = data.curPower
	local oriPower = data.oriPower
	if oriPower and curPower and oriPower ~= curPower then
		self:stopAllActions()
		self:setScaleY(0)
		self:setVisible(true)
		local power = curPower - oriPower
		if 0 < power then
			_ENV = nil
			;(nil).power = power
			if i18n("common_text_917", nil) then
				goto lbl_32
			end
		end
		_ENV = nil
		;(nil).power = power
		local str = i18n("common_text_1418", nil)
		::lbl_32::
		self.Text_power:setString(str)
		SoraDToCenter(self.Node_t, 20, not SoraDFIsRA())
		_UPVALUE5_ = self.Node_t
		self.Node_t[1] = cca.scaleTo(0.25, 1, 1)
		self.Node_t[2] = cca.delay(0.1)
		self.Node_t[3] = cca.callFunc(function()
			self.effect:setVisible(true)
			SoraDResetEffectNode(self.effect)
			if self.effect.action then
				self.effect.action:gotoFrameAndPlay(0, false)
			end
		end)
		self.Node_t[4] = cca.delay(1.2)
		self.Node_t[5] = cca.scaleTo(0.25, 1, 0)
		self.Node_t[6] = cca.callFunc(function()
			self:setVisible(false)
		end)
		self.Node_t[7] = cca.callFunc(function()
			self:setVisible(false)
		end)
		self.Node_t[8] = cca.callFunc(function()
			self:setVisible(false)
		end)
		local seq = cca.seq(self.Node_t)
		self:runAction(seq)
	end
end
return Node_powerup
