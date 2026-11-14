local worldMapBuildOccupyTime = class("worldMapBuildOccupyTime", function(target)
	return target
end)
function worldMapBuildOccupyTime:ctor()
end
function worldMapBuildOccupyTime:_initOccupyTimeData()
	self.timeFinish_Occupy = 0
	self.timeBegin_Occupy = 0
	self.finishOccupy = false
end
function worldMapBuildOccupyTime:_initOccupyTimeUI()
	local progressBar = SoraDCreatePanel("worldMapRadianceWarBeaconProgress")
	progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 15))
	progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	progressBar:addTo(self, 1)
	progressBar:setVisible(false)
	self.finishOccupy_progressBar = progressBar
end
function worldMapBuildOccupyTime:beginOccupyTime(timeNumber, isUp)
	if not self.finishOccupy_progressBar then
		self:_initOccupyTimeUI()
	end
	if self.finishOccupy_progressBar then
		self.finishOccupy_progressBar:initOccupy(self)
		self.finishOccupy_progressBar:beginTime(timeNumber, isUp)
	end
end
function worldMapBuildOccupyTime:removeOccupyTimeHandle()
	if self.finishOccupy_progressBar then
		self.finishOccupy_progressBar:endTime()
	end
end
function worldMapBuildOccupyTime:resetOccupyTime()
	self:removeOccupyTimeHandle()
end
function worldMapBuildOccupyTime:isOccupCompleted()
	return self.finishOccupy
end
function worldMapBuildOccupyTime:updateDataOccupyTime(data)
	if data.finishOccupyTime then
		self.timeFinish_Occupy = data.finishOccupyTime
	end
	if data.beginOccupyTime then
		self.timeBegin_Occupy = data.beginOccupyTime
	end
	if data.histOccupySecs then
		self.histOccupySecs = data.histOccupySecs
	end
	if data.finishOccupy ~= nil then
		self.finishOccupy = data.finishOccupy
	end
end
function worldMapBuildOccupyTime:setOccupyTimeShow(show)
	if self:getInstanceType() == gMapObjTypeDef.nebulaWarBuilding and show and self.finishOccupy then
		self:showFinishOccupy()
		return
	end
	if show and self.timeFinish_Occupy > 0 and not self.finishOccupy then
		local sysTime = serviceFunctions.systemTime()
		local timeNumber = self.timeFinish_Occupy - sysTime
		if timeNumber <= 0 then
			self:removeOccupyTimeHandle()
		else
			self:beginOccupyTime(timeNumber)
		end
	else
		self:removeOccupyTimeHandle()
	end
end
function worldMapBuildOccupyTime:showFinishOccupy(...)
	if not self.finishOccupy_progressBar then
		self:_initOccupyTimeUI()
	end
	self.finishOccupy_progressBar:showFinishOccupy()
end
function worldMapBuildOccupyTime:setOccupyTimeScale(scale)
	if not self.finishOccupy_progressBar then
		return
	end
	self.finishOccupy_progressBar:setProgressScale(scale)
end
function worldMapBuildOccupyTime:setPalaceOccupyTimeShow(show)
	if show then
		local timeNumber = serviceFunctions.systemTime() - self.timeBegin_Occupy
		if self:getInstanceType() == gMapObjTypeDef.roaringFlameWarBuilding then
			timeNumber = timeNumber + (self.histOccupySecs or 0)
			local roaringFlameWarUtil = include("roaringFlameWarUtil")
			local maxTime = roaringFlameWarUtil.getWarStateDuration()
			self.timeFinish_Occupy = self.timeBegin_Occupy + maxTime
		end
		if -1 <= timeNumber then
			self:beginOccupyTime(timeNumber, true)
			self.finishOccupy_progressBar:setIsShowFinish(false)
			self.finishOccupy_progressBar:hideTips()
		else
			self:removeOccupyTimeHandle()
		end
	else
		self:removeOccupyTimeHandle()
	end
end
return worldMapBuildOccupyTime
