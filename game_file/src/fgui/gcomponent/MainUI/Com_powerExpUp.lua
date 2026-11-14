local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_powerExpUp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_powerExpUp", Com_powerExpUp)
function Com_powerExpUp:onInit()
	self.fields.Effect_1:setIsLoop(false)
end
function Com_powerExpUp:onShow()
end
function Com_powerExpUp:playAct(data)
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
	self.fields.Text_exp:setString(strEXP)
	lordInfoCtrl = i18n("common_text_918", nil)
	i18n("common_text_918", nil).power = addPower
	local strPower = tostring(i18n("common_text_917", i18n("common_text_918", nil)))
	self.fields.Text_power:setString(strPower)
	self.fields.n3:fixPos()
	self.fields.Text_exp:fixPos()
	self.fields.n1:fixPos()
	self.fields.Text_power:fixPos()
	_UPVALUE5_ = self.fields.Text_power
	self.fields.Text_power[1] = ffa.scaleTo(0.25, 1, 1)
	self.fields.Text_power[2] = ffa.delay(0.2)
	self.fields.Text_power[3] = ffa.callFunc(function()
		self.fields.Effect_1:playOnce()
	end)
	self.fields.Text_power[4] = ffa.delay(1.2)
	self.fields.Text_power[5] = ffa.scaleTo(0.25, 1, 0)
	self.fields.Text_power[6] = ffa.callFunc(function()
		self:setVisible(false)
	end)
	self.fields.Text_power[7] = ffa.callFunc(function()
		self:setVisible(false)
	end)
	self.fields.Text_power[8] = ffa.callFunc(function()
		self:setVisible(false)
	end)
	local seq = ffa.seq(self.fields.Text_power)
	self:runAction(seq)
end
return Com_powerExpUp
