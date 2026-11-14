local luckyFalconCtrl = SoraDGetCtrl("luckyFalconCtrl")
local luckyFalconRead = include("luckyFalconRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://LuckyFalcon/Btn_box", Btn_box)
function Btn_box:onInit()
	self.fields.effect:setVisible(false)
	self.fields.g:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_box:onShow()
end
function Btn_box:initData(index, status)
	self.index = index
	self.fields.effect:stopAllActions()
	self.fields.effect:setVisible(false)
	self.fields.g:setVisible(false)
	self.transitions.t0:stop()
	if status == 1 then
	elseif status == 2 then
		self.fields.effect:setVisible(true)
		_ENV = nil
		;(nil)[1] = ffa.rotateBy(2.25, 360)
		;(nil)[2] = ffa.rotateBy(2.25, 360)
		;(nil)[3] = ffa.rotateBy(2.25, 360)
		self.fields.effect:runAction(ffa.repeatForever(ffa.seq(nil)))
		self.transitions.t0:play(-1, 0)
	elseif status == 3 then
		self.fields.g:setVisible(true)
	end
end
function Btn_box:btnClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("commonMoreGiftView")
	local extraReward = luckyFalconRead.getExtraRewardInfo(luckyFalconCtrl:getClassType(), self.index)
	_ENV = nil
	;(nil).claimIndex = self.index
	panel:initData(extraReward, i18n("pray_text_11"), "", nil)
	panel:show()
end
return Btn_box
