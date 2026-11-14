local baseComponent = require("fgui.base.baseComponent")
local Label_Tip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Intetior/Label_Tip", Label_Tip)
function Label_Tip:onInit()
	self:fixChildrenPos()
	self.fields.Button_Detail:addClickListener(handler(self, self.onClickDetail))
end
function Label_Tip:onShow()
end
function Label_Tip:onClickDetail()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("parliament_btn_08")
	;(nil).content = i18n("parliament_text_152")
	uiManager:show("RuleView", nil)
end
return Label_Tip
