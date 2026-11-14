local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_power = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_power", Com_power)
function Com_power:onInit()
	self.power = nil
	self.oriPower = nil
	self:addClickListener(handler(self, self.onBtnPowerClick))
end
function Com_power:onShow()
	self.controllers.c1:setSelectedIndex(GLOBAL_MAINUI_STYLE)
end
function Com_power:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAINUI_POWER_UPDATE", handler(self, self.powerShake))
end
function Com_power:setPower(power)
	self.fields.title:setString(string.formatnumberthousands(power))
	self.power = power
	self.oriPower = power
end
function Com_power:getPower()
	return self.oriPower
end
function Com_power:onBtnPowerClick()
	SoraDPlaySound("uicontrol", 19)
	uiManager:show("lordPowerView")
end
function Com_power:powerShake()
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local curPower = lordInfo.totalFc
	local tmpPower = self.oriPower
	self.power = curPower
	if tmpPower and tmpPower ~= curPower then
		self.oriPower = curPower
		local mutiple = 1
		_UPVALUE8_ = nil
		;(nil)[1] = ffa.scaleTo(0.3 * mutiple, 1.05)
		;(nil)[2] = ffa.scaleTo(0.1 * mutiple, 1)
		;(nil)[3] = ffa.scaleTo(0.2 * mutiple, 1.2)
		;(nil)[4] = ffa.callFunc(function()
			SoraDCreateScoreLabel(self.fields.title, true):runScoreAnimation(tmpPower, curPower, 1 * mutiple)
		end)
		;(nil)[5] = ffa.scaleTo(0.1 * mutiple, 1.05)
		;(nil)[6] = ffa.scaleTo(0.1 * mutiple, 1.2)
		;(nil)[7] = ffa.scaleTo(0.1 * mutiple, 1.05)
		;(nil)[8] = ffa.scaleTo(0.2 * mutiple, 1.2)
		;(nil)[9] = ffa.scaleTo(0.3 * mutiple, 1)
		;(nil)[10] = ffa.scaleTo(0.3 * mutiple, 1)
		;(nil)[11] = ffa.scaleTo(0.3 * mutiple, 1)
		local seq = ffa.seq(nil)
		self:stopAllActions()
		self:setScale(1)
		self.fields.title:setString(string.formatnumberthousands(self.power))
		self:runAction(seq)
	end
end
return Com_power
