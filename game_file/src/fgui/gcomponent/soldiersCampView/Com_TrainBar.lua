local baseComponent = require("fgui.base.baseComponent")
local Com_TrainBar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_TrainBar", Com_TrainBar)
function Com_TrainBar:onInit()
	self.fields.timer:setTimeUpdateListener(handler(self, self.onTimeUpdate))
	self.fields.bar:fixPos()
	self.fields.bar:fix()
end
function Com_TrainBar:onShow()
end
function Com_TrainBar:initData(leftTime, totaltime, handle)
	self.totaltime = totaltime
	self.handle = handle
	self.fields.timer:beginTime(leftTime)
	self.fields.bar:setWidth((self.totaltime - leftTime) * 488 / self.totaltime)
end
function Com_TrainBar:onTimeUpdate(time)
	self.fields.bar:setWidth((self.totaltime - time) * 488 / self.totaltime)
	if self.handle then
		self.handle(time)
	end
	if time <= 0 then
		_ENV = time
		time.msg = "MESSAGE_SOLDIER_TRAIN_DONE"
		SoraDSendMessage(time)
	end
end
return Com_TrainBar
