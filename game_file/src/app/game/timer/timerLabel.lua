local timerLabel = class("timerLabel", function(textLabel)
	if textLabel == nil then
		_ENV = nil
		;(nil).UILabelType = 2
		;(nil).text = ""
		;(nil).size = 20
		textLabel = cc.ui.UILabel.new(nil)
	end
	return textLabel
end)
function timerLabel:ctor()
	self.timeNumber = 0
	self.timeHandle = nil
	self.timeEndListener = nil
	self.timeUpdateListener = nil
	self.timeNodeGetTicket = nil
	self.finishTime = 0
	if self.setNodeEventEnabled then
		self:setNodeEventEnabled(true)
	else
		self:addEventListener(fgui.UIEventType.Exit, handler(self, self.onExit))
	end
end
function timerLabel.getServerTime(...)
	local gametop = gModuleMgr.getObject("gametop")
	if gametop then
		local timeCtrl = gametop.playertop_:getModule("timeCtrl")
		if timeCtrl then
			return timeCtrl:getServerTime()
		end
	end
	return os.time()
end
function timerLabel:beginTime(time, isUp, isNum, maxTime)
	self.timeNumber = time
	self.isUp = isUp or false
	self.isNum = isNum or false
	self.maxTime = maxTime
	self.finishTime = self.getServerTime() + self.timeNumber
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
	self:updateTime()
	self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime), nil, nil, true)
end
function timerLabel:beginTimeNode(getTimeFun)
	self.timeNodeGetTicket = getTimeFun
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
	self:updateTimeNode()
	self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTimeNode), nil, nil, true)
end
function timerLabel:endTime()
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
	if self.timeEndListener then
		print("--定时器结束回调--")
		self.timeEndListener()
	end
end
function timerLabel:endTimeNoCauseEndCallBack()
	print("endtime")
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
end
function timerLabel:removeTime()
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
end
function timerLabel:setTimeLast(timeHandle)
	self.timeLast = timeHandle
end
function timerLabel:updateLabel(timeNumber)
	if self.isNum then
		if self.timeLast then
			self:setString(self.timeLast(timeNumber))
		else
			self:setString(timeNumber)
		end
	elseif self.timeLast then
		self:setString(self.timeLast(SoraDConvertSecondToString(timeNumber), timeNumber))
	else
		self:setString(SoraDConvertSecondToString(timeNumber))
	end
end
function timerLabel:updateTimeNode(time)
	local timeNumber = self.timeNodeGetTicket and self.timeNodeGetTicket()
	if not timeNumber or timeNumber < 0 then
		self:endTime()
		return
	end
	self:updateLabel(timeNumber)
	if self.timeUpdateListener then
		self.timeUpdateListener(timeNumber)
	end
	if timeNumber == 0 then
		self:endTime()
		return
	end
end
function timerLabel:updateTime(time)
	if not self.timeNumber then
		if self.endTime then
			self:endTime()
		end
		return
	end
	if self.isUp then
		if self.maxTime and self.timeNumber >= self.maxTime then
			self:updateLabel(self.timeNumber)
			if self.endTime then
				self:endTime()
			end
			return
		end
		self.timeNumber = self.timeNumber + 1
	else
		self.timeNumber = self.finishTime - self.getServerTime()
	end
	if self.timeNumber < 0 then
		if self.endTime then
			self:endTime()
		end
		return
	end
	self:updateLabel(self.timeNumber)
	if self.timeUpdateListener then
		self.timeUpdateListener(self.timeNumber)
	end
end
function timerLabel:setTimeUpdateListener(listener)
	self.timeUpdateListener = listener
end
function timerLabel:setTimeEndListener(listener)
	self.timeEndListener = listener
end
function timerLabel:onEnter()
end
function timerLabel:onExit()
	SoraDManagerRemoveTimerByTarget(self)
end
function timerLabel:onCleanup()
	SoraDManagerRemoveTimerByTarget(self)
end
return timerLabel
