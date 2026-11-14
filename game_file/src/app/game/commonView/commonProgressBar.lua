local CommonProgressBar = class("commonProgressBar", function(target)
	if target == nil then
		SoraDPrint(self, "需要自己构建进度条CSB文件")
	end
	return target
end)
function CommonProgressBar:ctor()
	_ENV = nil
	;(nil).maxValue = 100
	;(nil).curValue = 0
	self.progressDate, (nil).actionValue = nil, 0
	self.actionDelay = 0
	self.timer = nil
	self.handle = nil
	self.isInit = false
	self.noRefreshLabel = false
	self.m_progressBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.m_progressLabel = SoraDGetChildByName(self, "Text_progress")
	if self.m_progressBar then
		self:updateData(0)
	end
end
function CommonProgressBar:setHandle(handle)
	self.handle = handle
end
function CommonProgressBar:setActionDelay(delay)
	self.actionDelay = delay
end
function CommonProgressBar:setProgressLabel(str)
	if self.m_progressLabel then
		self.m_progressLabel:setString(str)
	end
end
function CommonProgressBar:setProgressDate(progressValue)
	self.progressDate.maxValue = tonumber(progressValue.maxValue)
	self.progressDate.curValue = tonumber(progressValue.curValue)
	self:updateData(self.progressDate.curValue)
	self.isInit = true
end
function CommonProgressBar:getProgress()
	return self.m_progressBar:getPercent()
end
function CommonProgressBar:getProgressValue()
	return self.progressDate.curValue
end
function CommonProgressBar:getProgressData()
	return self.progressDate
end
function CommonProgressBar:setInitState(isInit)
	self.isInit = isInit
end
function CommonProgressBar:getInitState()
	return self.isInit
end
function CommonProgressBar:setNoRefreshLabel(ret)
	self.noRefreshLabel = ret
end
function CommonProgressBar:updateData(curValue)
	if curValue > self.progressDate.curValue then
		self.progressDate.actionValue = self.progressDate.curValue
	end
	if curValue > self.progressDate.maxValue then
		self.progressDate.curValue = self.progressDate.maxValue
	else
		self.progressDate.curValue = curValue
	end
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	if self.isInit and self.actionDelay > 0 and self.progressDate.curValue > self.progressDate.actionValue then
		local preValue = (self.progressDate.curValue - self.progressDate.actionValue) / (self.actionDelay * 60)
		self.timer = SoradCreateTimer(self, function(...)
			self.progressDate.actionValue = self.progressDate.actionValue + preValue
			self.m_progressBar:setPercent(self.progressDate.actionValue / self.progressDate.maxValue * 100)
			if self.m_progressLabel and not self.noRefreshLabel then
				self.m_progressLabel:setString(math.floor(self.progressDate.actionValue) .. "/" .. self.progressDate.maxValue)
			end
			if self.progressDate.actionValue >= self.progressDate.curValue then
				self:updateData(self.progressDate.curValue)
			elseif self.handle then
				self.handle(self.progressDate)
			end
		end, true)
	else
		self.m_progressBar:setPercent(self.progressDate.curValue / self.progressDate.maxValue * 100)
		self.progressDate.actionValue = self.progressDate.curValue
		if self.m_progressLabel and not self.noRefreshLabel then
			self.m_progressLabel:setString(self.progressDate.curValue .. "/" .. self.progressDate.maxValue)
		end
	end
	if self.handle then
		self.handle(self.progressDate)
	end
end
function CommonProgressBar:setProgressImg(imgName)
	self.m_progressBar:loadTexture(imgName, ccui.TextureResType.plistType)
end
function CommonProgressBar:setProgressContentSize(size)
	if self.m_progressBar then
		self.m_progressBar:setContentSize(size)
	end
end
return CommonProgressBar
