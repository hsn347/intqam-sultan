local baseComponent = require("fgui.base.baseComponent")
local Btn_techBox = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/Btn_techBox", Btn_techBox)
function Btn_techBox:onInit()
	self.fields.Text_tip:setString(i18n("flames_dunes_text340"))
end
function Btn_techBox:onShow()
end
function Btn_techBox:setStatus(status)
	self.controllers.c1:setSelectedIndex(status)
	self:setReddot(status == 1)
	self.fields.n1:stopAllActions()
	self.fields.n1:setRotation(0)
	self.fields.n1:setScale(1)
	if status == 1 then
		_UPVALUE8_ = nil
		;(nil)[1] = ffa.scaleTo(0.25, 1.2)
		;(nil)[2] = ffa.scaleTo(0.3333333333333333, 1)
		;(nil)[3] = ffa.rotateTo(0.25, 10)
		;(nil)[4] = ffa.rotateTo(0.21666666666666667, -10)
		;(nil)[5] = ffa.rotateTo(0.2, 8)
		;(nil)[6] = ffa.rotateTo(0.16666666666666666, -5)
		;(nil)[7] = ffa.rotateTo(0.15, 2)
		;(nil)[8] = ffa.rotateTo(0.15, 0)
		;(nil)[9] = ffa.delay(1.6666666666666667)
		;(nil)[10] = ffa.delay(1.6666666666666667)
		self.fields.n1:runAction(ffa.repeatForever(ffa.seq(nil)))
	end
end
return Btn_techBox
