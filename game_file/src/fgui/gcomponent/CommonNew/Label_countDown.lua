local baseComponent = require("fgui.base.baseComponent")
local Label_countDown = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Label_countDown", Label_countDown)
fgui.register_extension("ui://Activity2112/Label_snowTime", Label_countDown)
fgui.register_extension("ui://TowerDefend/Com_time", Label_countDown)
fgui.register_extension("ui://KingdomBattle/com_Text", Label_countDown)
function Label_countDown:onInit()
	self.text_time = SoraDCreateTimerLabel(self, self:getChild("title"))
end
function Label_countDown:onShow()
end
function Label_countDown:beginTime(time, isUp, isNum, maxTime)
	self.text_time:beginTime(time, isUp, isNum, maxTime)
end
function Label_countDown:beginTimeNode(getTimeFun)
	self.text_time:beginTimeNode(getTimeFun)
end
function Label_countDown:endTime()
	self.text_time:endTime()
end
function Label_countDown:removeTime()
	self.text_time:removeTime()
end
function Label_countDown:setTimeLast(timeHandle)
	self.text_time:setTimeLast(timeHandle)
end
function Label_countDown:setTimeUpdateListener(listener)
	self.text_time:setTimeUpdateListener(listener)
end
function Label_countDown:setTimeEndListener(listener)
	self.text_time:setTimeEndListener(listener)
end
function Label_countDown:endTimeNoCauseEndCallBack()
	self.text_time:endTimeNoCauseEndCallBack()
end
function Label_countDown:setTimeColor(color)
	self.text_time:setColor(color)
end
function Label_countDown:setTimeFontSize(fontSize)
	self.text_time:setFontSize(fontSize)
end
function Label_countDown:updateLabel(timeNumber)
	self.text_time:updateLabel(timeNumber)
end
function Label_countDown:getTimeNumber()
	return self.text_time.timeNumber
end
return Label_countDown
