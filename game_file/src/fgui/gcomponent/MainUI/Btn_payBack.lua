local baseComponent = require("fgui.base.baseComponent")
local Btn_payBack = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_payBack", Btn_payBack)
function Btn_payBack:onInit()
	self.fields.red:fixPos()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_payBack:onShow()
end
function Btn_payBack:onBtnClick()
	SoraDPlaySound()
	uiManager:show("BackMoneyPopView")
end
return Btn_payBack
