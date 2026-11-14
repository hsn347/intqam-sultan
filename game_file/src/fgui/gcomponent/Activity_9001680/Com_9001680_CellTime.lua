local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_CellTime = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001680/Com_9001680_CellTime", Com_9001680_CellTime)
function Com_9001680_CellTime:onInit()
	self.timeLabel = SoraDCreateTimerLabel(self, self.fields.label_time)
	self:setTouchEnabled(false)
	self.pickAni = fguiHelper.get_transitions(self.fields.Com_9001680_PickAni)
end
function Com_9001680_CellTime:onShow()
end
function Com_9001680_CellTime:beginTime(time, isPickAni)
	self.timeLabel:beginTime(time)
	self.controllers.c1:setSelectedIndex(isPickAni and 1 or 0)
	if isPickAni then
		self.pickAni.t0:play(-1, 0, 0, -1)
	end
end
function Com_9001680_CellTime:onPutToPool()
	self.timeLabel:endTime()
	self:setVisible(false)
end
return Com_9001680_CellTime
