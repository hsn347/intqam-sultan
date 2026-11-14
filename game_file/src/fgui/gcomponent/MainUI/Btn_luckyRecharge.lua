local baseComponent = require("fgui.base.baseComponent")
local Btn_luckyRecharge = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_luckyRecharge", Btn_luckyRecharge)
function Btn_luckyRecharge:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_luckyRecharge:onShow()
end
function Btn_luckyRecharge:setTitle(str)
	self.fields.title:setString(str)
end
function Btn_luckyRecharge:initData(data)
	if data and data.index then
		self:setShowType(data.index)
	end
end
function Btn_luckyRecharge:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Btn_luckyRecharge:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("eventLuckyRechargeView"):show()
end
return Btn_luckyRecharge
