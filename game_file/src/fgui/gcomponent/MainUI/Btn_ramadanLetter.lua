local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_ramadanLetter = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_ramadanLetter", Btn_ramadanLetter)
function Btn_ramadanLetter:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_ramadanLetter:onShow()
end
function Btn_ramadanLetter:onBtnClick()
end
return Btn_ramadanLetter
