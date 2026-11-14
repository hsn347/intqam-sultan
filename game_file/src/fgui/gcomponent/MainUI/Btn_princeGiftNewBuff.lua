local baseComponent = require("fgui.base.baseComponent")
local Btn_princeGiftNewBuff = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_princeGiftNewBuff", Btn_princeGiftNewBuff)
function Btn_princeGiftNewBuff:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_princeGiftNewBuff:onShow()
end
function Btn_princeGiftNewBuff:setTime(time)
	self.Text_Time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_BOTTOM_SWITCH_UPDATE"
		;(nil).sType = 5
		SoraDSendMessage(nil)
	end)
	self.Text_Time:beginTime(time)
end
function Btn_princeGiftNewBuff:onBtnClick()
	SoraDPlaySound()
	local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
	local panel = SoraDCreatePanel("princeGiftNewBuffPreviewPopView")
	panel:initData(princeGiftNewCtrl:getBuffDesc())
	panel:show()
end
return Btn_princeGiftNewBuff
