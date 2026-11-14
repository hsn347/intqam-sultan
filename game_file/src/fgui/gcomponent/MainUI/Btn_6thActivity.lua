local baseComponent = require("fgui.base.baseComponent")
local Btn_6thActivity = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_6thActivity", Btn_6thActivity)
function Btn_6thActivity:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_6thActivity:onShow()
end
function Btn_6thActivity:setTime(time)
	self.Text_Time:beginTime(time)
end
function Btn_6thActivity:onBtnClick()
	SoraDPlaySound()
end
return Btn_6thActivity
