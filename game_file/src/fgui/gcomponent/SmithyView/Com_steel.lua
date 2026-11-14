local baseComponent = require("fgui.base.baseComponent")
local Com_steel = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_steel", Com_steel)
function Com_steel:onInit()
	self.fields.Button_help:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_steel:onShow()
end
function Com_steel:initData(steel)
	self.fields.title:setString(string.formatnumberthousands(steel))
end
function Com_steel:btnClick()
	SoraDPlaySound()
	_ENV = "common_text_2380"
	;("common_text_2380").float = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("common_text_2380"), "common_text_2380")
end
return Com_steel
