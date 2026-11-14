local baseComponent = require("fgui.base.baseComponent")
local Btn_newPlayerBuff = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_newPlayerBuff", Btn_newPlayerBuff)
function Btn_newPlayerBuff:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_newPlayerBuff:onShow()
end
function Btn_newPlayerBuff:setTime(time)
	self.Text_Time:setTimeLast(function(ticket)
		return i18n("guide_text_159") .. "\n" .. ticket
	end)
	self.Text_Time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINSCEN_BOTTOM_SWITCH_UPDATE"
		;(nil).sType = 6
		SoraDSendMessage(nil)
	end)
	self.Text_Time:beginTime(time)
end
function Btn_newPlayerBuff:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).tab = 2
	uiManager:show("citybuffView", nil)
end
return Btn_newPlayerBuff
