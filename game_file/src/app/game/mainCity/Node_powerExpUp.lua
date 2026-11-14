local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local Node_powerExpUp = class("Node_powerExpUp", function()
	return SoraDCreateBasePanel("Node_powerExpUp")
end)
function Node_powerExpUp:ctor()
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.effect = SoraDCreatAnimationEx("power_up", nil, false)
	self.effect:setVisible(false)
	self.effect:addTo(self.Node_effect)
	self.Node_e = SoraDGetChildByName(self, "Node_e")
	self.Text_exp = SoraDGetChildByName(self, "Text_exp")
	self.Node_p = SoraDGetChildByName(self, "Node_p")
	self.Text_power = SoraDGetChildByName(self, "Text_power")
end
function Node_powerExpUp:playAct(data)
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local isReachFullExp = lordInfo.isReachFullExp
	if isReachFullExp then
		self:setVisible(false)
		return
	end
	local addEXP = data.addEXP
	local addPower = data.addPower
	self:setScaleY(0)
	self:setVisible(true)
	lordInfoCtrl = nil
	;(nil).exp = addEXP
	local strEXP = tostring(i18n("common_text_918", nil))
	self.Text_exp:setString(strEXP)
	SoraDToCenter(self.Node_e, 20, not SoraDFIsRA())
	lordInfoCtrl = not SoraDFIsRA()
	;(not SoraDFIsRA()).power = addPower
	local strPower = tostring(i18n("common_text_917", not SoraDFIsRA()))
	self.Text_power:setString(strPower)
	SoraDToCenter(self.Node_p, 20, not SoraDFIsRA())
	_UPVALUE5_ = self.Node_p
	self.Node_p[1] = cca.scaleTo(0.25, 1, 1)
	self.Node_p[2] = cca.delay(0.1)
	self.Node_p[3] = cca.callFunc(function()
		self.effect:setVisible(true)
		SoraDResetEffectNode(self.effect)
		if self.effect.action then
			self.effect.action:gotoFrameAndPlay(0, false)
		end
	end)
	self.Node_p[4] = cca.delay(1.2)
	self.Node_p[5] = cca.scaleTo(0.25, 1, 0)
	self.Node_p[6] = cca.callFunc(function()
		self:setVisible(false)
	end)
	self.Node_p[7] = cca.callFunc(function()
		self:setVisible(false)
	end)
	self.Node_p[8] = cca.callFunc(function()
		self:setVisible(false)
	end)
	local seq = cca.seq(self.Node_p)
	self:runAction(seq)
end
return Node_powerExpUp
