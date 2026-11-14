local baseComponent = require("fgui.base.baseComponent")
local Btn_pyramidBattle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_pyramidBattle", Btn_pyramidBattle)
function Btn_pyramidBattle:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_pyramidBattle:onShow()
end
function Btn_pyramidBattle:setTime(time)
	self.Text_Time:beginTime(time)
end
function Btn_pyramidBattle:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("pyramidBattleView"):show()
	_ENV = SoraDCreatePanel("pyramidBattleView")
	SoraDCreatePanel("pyramidBattleView").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage((SoraDCreatePanel("pyramidBattleView")))
end
return Btn_pyramidBattle
