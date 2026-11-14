local baseComponent = require("fgui.base.baseComponent")
local Com_selectType = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://commonSpeedUpByItemBox/Com_selectType", Com_selectType)
function Com_selectType:onInit()
	self.fields.Text_choose:setString(i18n("accelerate_text_005"))
	self.fields.Button_choose:addClickListener(handler(self, self.btnChooseClick))
	self.fields.Button_choose:fixPos()
end
function Com_selectType:onShow()
end
function Com_selectType:btnChooseClick()
	SoraDPlaySound()
	uiManager:show("commonSpeedUpTypeView")
end
return Com_selectType
