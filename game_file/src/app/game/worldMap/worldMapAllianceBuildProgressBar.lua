local allianceTerritoryAPI = include("allianceTerritoryAPI")
local WorldMapAllianceBuildProgressBar = class("worldMapAllianceBuildProgressBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAllianceBuildProgressBar")
	end
	return target
end)
function WorldMapAllianceBuildProgressBar:ctor()
	self.timeData, _ENV, self.fadeFlag = nil, nil, true
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtNum = SoraDGetChildByName(self, "Text_num")
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 0, 4, 21))
end
function WorldMapAllianceBuildProgressBar:initData(data, hurtStatus)
	self.timeData = data
	self.cur = 0
	self.hpMax = data.wall.HPMax
	self.hurtStatus = hurtStatus or false
	self:beginTime()
end
function WorldMapAllianceBuildProgressBar:beginTime(time)
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
	self:updateTime()
end
function WorldMapAllianceBuildProgressBar:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	if self.timeData.endCallBack then
		self.timeData.endCallBack()
	end
	self:setVisible(false)
end
function WorldMapAllianceBuildProgressBar:updateTime(time)
	self.cur = allianceTerritoryAPI:calcCurrentHP(self.timeData)
	local percent = self.cur / self.hpMax * 100
	self.loadingBar:setPercent(percent)
	self.txtNum:setString(math.ceil(percent) .. "%")
	if self.cur >= self.hpMax and not self.hurtStatus then
		self:endTime()
	end
end
return WorldMapAllianceBuildProgressBar
