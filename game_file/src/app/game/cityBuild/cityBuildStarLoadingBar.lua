local cityBuildStarLoadingBar = class("cityBuildStarLoadingBar", function()
	if target == nil then
		return SoraDCreateBasePanel("cityBuildStarLoadingBar")
	end
	return target
end)
function cityBuildStarLoadingBar:ctor()
	self:initWidget()
end
function cityBuildStarLoadingBar:initWidget()
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	if SoraDFIsRA() then
		self.loadingBar:setRotation(180)
		self.loadingBar:setPosition(1, 2)
	end
end
function cityBuildStarLoadingBar:initData(queue)
	self.queue = queue
	self:beginTime()
end
function cityBuildStarLoadingBar:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function cityBuildStarLoadingBar:updateTime(dt)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	if leftTime <= 0 then
		self:endTime()
	end
	local totaltime = self.queue.ottime or self.queue.totaltime
	self.loadingBar:setPercent((totaltime - leftTime) * 100 / totaltime)
end
function cityBuildStarLoadingBar:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
end
return cityBuildStarLoadingBar
