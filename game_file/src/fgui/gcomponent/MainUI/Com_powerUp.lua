local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_powerUp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_powerUp", Com_powerUp)
function Com_powerUp:onInit()
	self.fields.Effect_1:setIsLoop(false)
end
function Com_powerUp:onShow()
end
function Com_powerUp:playAct()
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local curPower = lordInfo.totalFc
	local oriPower = 0
	local mainui = SoraDCurrentMainUI()
	if mainui and mainui:getMainUITop() then
		oriPower = mainui:getMainUITop():getCurPower()
	end
	if oriPower ~= 0 and oriPower ~= curPower then
		self:setScaleY(0)
		self:setVisible(true)
		local power = curPower - oriPower
		if 0 < power then
			lordInfoCtrl = nil
			;(nil).power = power
			if i18n("common_text_917", nil) then
				goto lbl_44
			end
		end
		lordInfoCtrl = nil
		;(nil).power = power
		local str = i18n("common_text_1418", nil)
		::lbl_44::
		self.fields.title:setString(str)
		self.fields.n1:fixPos()
		self.fields.title:fixPos()
		_UPVALUE5_ = self.fields.title
		self.fields.title[1] = ffa.scaleTo(0.25, 1, 1)
		self.fields.title[2] = ffa.delay(0.2)
		self.fields.title[3] = ffa.callFunc(function()
			self.fields.Effect_1:playOnce()
		end)
		self.fields.title[4] = ffa.delay(1.2)
		self.fields.title[5] = ffa.scaleTo(0.25, 1, 0)
		self.fields.title[6] = ffa.callFunc(function()
			self:setVisible(false)
		end)
		self.fields.title[7] = ffa.callFunc(function()
			self:setVisible(false)
		end)
		self.fields.title[8] = ffa.callFunc(function()
			self:setVisible(false)
		end)
		local seq = ffa.seq(self.fields.title)
		self:runAction(seq)
	end
end
return Com_powerUp
