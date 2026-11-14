local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_autoTime = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_autoTime", Com_autoTime)
function Com_autoTime:onInit()
	self.fields.autoTime = SoraDCreateTimerLabel(self, self.fields.autoTime)
	self.fields.autoTime:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_1768", nil)
	end)
end
function Com_autoTime:onShow()
end
function Com_autoTime:initData()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.auto_trial_prepare)
	if queue then
		local leftTime = queue.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self:setVisible(true)
			self.fields.autoTime:beginTime(leftTime)
		else
			self:setVisible(false)
		end
	else
		self:setVisible(false)
	end
end
return Com_autoTime
