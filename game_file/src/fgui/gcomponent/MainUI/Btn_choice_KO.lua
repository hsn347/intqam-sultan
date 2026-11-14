local baseComponent = require("fgui.base.baseComponent")
local Btn_choice_KO = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_choice_KO", Btn_choice_KO)
function Btn_choice_KO:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_choice_KO:onShow()
end
function Btn_choice_KO:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("koUserNotifyView"):show()
end
return Btn_choice_KO
