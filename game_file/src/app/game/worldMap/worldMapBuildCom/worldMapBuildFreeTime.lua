local worldMapBuildFreeTime = class("worldMapBuildFreeTime", function(target)
	return target
end)
function worldMapBuildFreeTime:ctor()
end
function worldMapBuildFreeTime:_initFreeTimeData()
	self.timeFinish_Free = 0
	self.timeBegin_Free = 0
end
function worldMapBuildFreeTime:_initFreeTimeUI()
	local progressBar = SoraDCreatePanel("worldMapRadianceWarBeaconProgress")
	progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 15))
	progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	progressBar:addTo(self, 1)
	progressBar:setVisible(false)
	self.finishFree_progressBar = progressBar
end
function worldMapBuildFreeTime:beginFreeTime(timeNumber)
	if not self.finishFree_progressBar then
		self:_initFreeTimeUI()
	end
	if self.finishFree_progressBar then
		self.finishFree_progressBar:initFree(self)
		self.finishFree_progressBar:beginTime(timeNumber)
	end
end
function worldMapBuildFreeTime:removeFreeTimeHandle()
	if self.finishFree_progressBar then
		self.finishFree_progressBar:endTime()
	end
end
function worldMapBuildFreeTime:resetFreeTime()
	self:removeFreeTimeHandle()
end
function worldMapBuildFreeTime:isFreeCompleted()
	if self.timeFinish_Free > 0 then
		local sysTime = serviceFunctions.systemTime()
		local timeNumber = self.timeFinish_Free - sysTime
		return timeNumber < 0
	end
	return true
end
function worldMapBuildFreeTime:updateDataFreeTime(data)
	if data.finishFreeTime then
		self.timeFinish_Free = data.finishFreeTime
	end
	if data.beginFreeTime then
		self.timeBegin_Free = data.beginFreeTime
	end
end
function worldMapBuildFreeTime:setFreeTimeShow(show)
	if show and self.timeFinish_Free > 0 then
		local sysTime = serviceFunctions.systemTime()
		local timeNumber = self.timeFinish_Free - sysTime
		if timeNumber <= 0 then
			self:removeFreeTimeHandle()
		else
			self:beginFreeTime(timeNumber)
		end
	else
		self:removeFreeTimeHandle()
	end
end
return worldMapBuildFreeTime
