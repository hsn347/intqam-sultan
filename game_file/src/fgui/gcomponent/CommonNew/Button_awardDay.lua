local baseComponent = require("fgui.base.baseComponent")
local Button_awardDay = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonNew/Button_awardDay", Button_awardDay)
function Button_awardDay:onInit()
	self.isTimeModel = false
	self.fields.mv_reward:setAllFrameName("dh_heronewtrial_%02d.png", 1)
end
function Button_awardDay:onShow()
end
function Button_awardDay:setState(state)
	self.controllers.c_state:setSelectedIndex(state)
end
function Button_awardDay:setTime(time, isUp, timeMax)
	if not self.isTimeModel then
		self.fields.title = SoraDCreateTimerLabel(self, self.fields.title)
		self.isTimeModel = true
	end
	self.fields.title:beginTime(time, isUp, nil, timeMax)
end
return Button_awardDay
