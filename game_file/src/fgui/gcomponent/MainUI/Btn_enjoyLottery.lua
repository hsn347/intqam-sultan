local baseComponent = require("fgui.base.baseComponent")
local Btn_enjoyLottery = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_enjoyLottery", Btn_enjoyLottery)
function Btn_enjoyLottery:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_enjoyLottery:onShow()
end
function Btn_enjoyLottery:onBtnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ENJOY_LOTTERY, true) then
		SoraDCreatePanel("enjoyLotteryView"):show()
	end
end
return Btn_enjoyLottery
