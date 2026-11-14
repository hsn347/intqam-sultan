local baseComponent = require("fgui.base.baseComponent")
local Com_upBar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_upBar", Com_upBar)
function Com_upBar:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
end
function Com_upBar:onShow()
end
function Com_upBar:updateShow(showTime)
	local percent = showTime / (self.queue.ottime or self.queue.totaltime)
	self.fields.n1:setFillAmount(percent)
	self.fields.n0:setFillAmount(percent)
	self.fields.et:setRotation((100 - percent * 100) * 360 / 100)
	if self.queue.data.upgradeType == gHeroSysUpType.AWAKE then
		_ENV = (100 - percent * 100) * 360 / 100
		;(100 - percent * 100) * 360 / 100.time = showTime
		return i18n("hero_text_108", (100 - percent * 100) * 360 / 100)
	else
		_ENV = (100 - percent * 100) * 360 / 100
		;(100 - percent * 100) * 360 / 100.time = showTime
		return i18n("hero_text_40", (100 - percent * 100) * 360 / 100)
	end
end
function Com_upBar:initData(queue)
	self.queue = queue
	local curTime = self.queue.timerNode.timer:getRemainTime()
	self.Text_Time:setTimeUpdateListener(handler(self, self.updateShow))
	self.Text_Time:beginTime(curTime)
end
return Com_upBar
