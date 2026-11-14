local baseComponent = require("fgui.base.baseComponent")
local Btn_goldPackage = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_goldPackage", Btn_goldPackage)
function Btn_goldPackage:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_goldPackage:onShow()
end
function Btn_goldPackage:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("eventGoldPackageView"):show()
end
return Btn_goldPackage
