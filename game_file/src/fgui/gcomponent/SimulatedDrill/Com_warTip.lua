local simulatedDrillCtrl = SoraDGetCtrl("simulatedDrillCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_warTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SimulatedDrill/Com_warTip", Com_warTip)
function Com_warTip:onInit()
	self.fields.Text_tip:setString(i18n("simulated_drill_text_31"))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeEndListener(handler(self, self.onTimeEnd))
	self.Text_time:setTimeUpdateListener(handler(self, self.onTimeUpdate))
end
function Com_warTip:onShow()
	self:setVisible(false)
end
function Com_warTip:updateData(callback)
	self.callback = callback
	local remainTime = simulatedDrillCtrl:getWarTipRemainTime()
	if 0 < remainTime then
		self:setVisible(true)
		self.Text_time:beginTime(remainTime)
	else
		self:onTimeEnd()
	end
end
function Com_warTip:onTimeEnd()
	self:setVisible(false)
	if self.callback then
		self.callback()
	end
end
function Com_warTip:onTimeUpdate(timeNumber)
	if timeNumber == 3 then
		uiManager:show("NebulaAllStarReady")
	end
end
return Com_warTip
