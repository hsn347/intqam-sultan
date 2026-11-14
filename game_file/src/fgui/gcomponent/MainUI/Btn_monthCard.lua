local baseComponent = require("fgui.base.baseComponent")
local Btn_monthCard = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_monthCard", Btn_monthCard)
function Btn_monthCard:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_monthCard:onShow()
end
function Btn_monthCard:onBtnClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).toCategory = gRechargeCenterCategory.MONTH
		;(nil).toNodeTag = 0
		uiManager:show("rechargeView", nil)
	else
		SoraDCreatePanel("rechargeMonthlyFrame"):show()
	end
end
return Btn_monthCard
