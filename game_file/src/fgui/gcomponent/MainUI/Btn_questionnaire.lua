local baseComponent = require("fgui.base.baseComponent")
local Btn_questionnaire = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_questionnaire", Btn_questionnaire)
function Btn_questionnaire:onInit()
	self.fields.lab_red:fixPos()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_questionnaire:onShow()
end
function Btn_questionnaire:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_questionnaire:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("questionnaireView"):show()
end
return Btn_questionnaire
