local baseComponent = require("fgui.base.baseComponent")
local activity_9001711_Ctrl = SoraDGetCtrl("activity_9001711_Ctrl")
local Btn_9001711 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_9001711", Btn_9001711)
function Btn_9001711:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self:addClickEventListener(handler(self, self.onBtnClick))
	self.Text_Time:setTimeLast(function(ticket, timeNumber)
		self.Text_Time:setColor(timeNumber < 1800 and cc.c3b(255, 27, 26) or cc.c3b(240, 230, 210))
		return ticket
	end)
	self.Text_Time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001711_UPDATE"
		SoraDSendMessage(nil)
	end)
end
function Btn_9001711:onShow()
end
function Btn_9001711:updateData()
	local lastTime = SoraDGetCtrl("activity_9001711_Ctrl"):getMinBuyEndTime() - serviceFunctions.systemTime()
	if 0 < lastTime then
		self.Text_Time:beginTime(lastTime)
	end
end
function Btn_9001711:updateReddot(isShow, num)
	self.fields.Label_reddot:initData(isShow, num)
end
function Btn_9001711:onBtnClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001724_Main")
end
return Btn_9001711
