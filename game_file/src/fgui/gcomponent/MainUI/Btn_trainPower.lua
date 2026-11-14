local baseComponent = require("fgui.base.baseComponent")
local Btn_trainPower = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_trainPower", Btn_trainPower)
function Btn_trainPower:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_trainPower:onShow()
end
function Btn_trainPower:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_trainPower:onBtnClick()
	SoraDPlaySound("uicontrol", 49)
	SoraDCreatePanel("trainPowerView"):show()
end
return Btn_trainPower
