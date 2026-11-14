local baseComponent = require("fgui.base.baseComponent")
local Btn_sultanWelBack = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_sultanWelBack", Btn_sultanWelBack)
function Btn_sultanWelBack:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_sultanWelBack:onShow()
end
function Btn_sultanWelBack:setTime(time)
	self.Text_Time:beginTime(time)
end
function Btn_sultanWelBack:onBtnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_WELCOME_ACTIVITY, true) then
		SoraDCreatePanel("sultansBackWelBackView"):show()
	end
end
return Btn_sultanWelBack
