local baseComponent = require("fgui.base.baseComponent")
local Btn_skillFuil = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_skillFuil", Btn_skillFuil)
function Btn_skillFuil:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_skillFuil:onShow()
end
function Btn_skillFuil:setTime(time)
	self.Text_Time:beginTime(time)
end
function Btn_skillFuil:onBtnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXTREMELY_SKILLFUIL, true) then
		uiManager:show("ExtremelySkillfulMain")
	end
end
return Btn_skillFuil
