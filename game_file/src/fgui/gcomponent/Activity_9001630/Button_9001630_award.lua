local baseComponent = require("fgui.base.baseComponent")
local Button_9001630_award = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001630/Button_9001630_award", Button_9001630_award)
function Button_9001630_award:onInit()
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.title)
	self.Text_time:setTimeLast(function(ticket)
		return i18n("datepalm_tree_text18") .. "\n" .. ticket
	end)
end
function Button_9001630_award:onShow()
end
function Button_9001630_award:initData(isHaveDaily)
	self.controllers.c1:setSelectedIndex(isHaveDaily and 0 or 1)
	self.Text_time:endTime()
	if not isHaveDaily then
		self.Text_time:beginTime(serviceFunctions.getTomorrowZeroHourUTC() - serviceFunctions.systemTime())
	else
		self.Text_time:setString(i18n("datepalm_tree_text18"))
	end
end
return Button_9001630_award
