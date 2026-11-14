local baseComponent = require("fgui.base.baseComponent")
local Btn_princeGiftBuff = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_princeGiftBuff", Btn_princeGiftBuff)
function Btn_princeGiftBuff:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_princeGiftBuff:onShow()
end
function Btn_princeGiftBuff:setTime(time)
	self.Text_Time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_BOTTOM_SWITCH_UPDATE"
		;(nil).sType = 6
		SoraDSendMessage(nil)
	end)
	self.Text_Time:beginTime(time)
end
function Btn_princeGiftBuff:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("princeGiftBuffStrengthenView"):show()
end
return Btn_princeGiftBuff
