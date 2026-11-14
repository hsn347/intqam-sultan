local windTowerMapTip = class("windTowerMapTip", function(target)
	return SoraDCreateBasePanel("cityCoolingTip")
end)
function windTowerMapTip:ctor()
	SoraDGetChildByName(self, "Node_bg"):setVisible(false)
	self.labelTime = SoraDGetChildByName(self, "textTime")
	self.labelTime = SoraDCreateTimerLabel(self, self.labelTime)
	self.spriteIcon = SoraDGetChildByName(self, "iconImg")
	local loadingBg = SoraDGetChildByName(self, "spriteLoadingBarBg")
	self.loadingBar = SoraDGetChildByName(loadingBg, "LoadingBar_bar")
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 4, 4, 1))
	self.iconImg = SoraDGetChildByName(self, "iconImg")
	self.labelTip = SoraDGetChildByName(self, "textTip")
	self.labelTip:setVisible(false)
end
local gWindTowerStatus = _G.gWindTowerStatus
function windTowerMapTip:initActivityTime(leftTime, totalTime, status, isSurveying)
	if status == gWindTowerStatus.SURVEY then
		self.iconImg:setSpriteFrame("icon_lostRuins_search.png")
	elseif status == gWindTowerStatus.RECIEVED then
		self.iconImg:setSpriteFrame("icon_main_build_05.png")
	elseif status == gWindTowerStatus.GIVE_UP or status == gWindTowerStatus.RECIEVED_REWARD or status == gWindTowerStatus.OVERDUE or status == gWindTowerStatus.CANCEL then
		if isSurveying then
			self.iconImg:setSpriteFrame("icon_lostRuins_search.png")
		else
			self.iconImg:setSpriteFrame("icon_lostRuins_time.png")
		end
	end
	self.labelTime:setTimeUpdateListener(function(remainTime)
		local percentage = (totalTime - remainTime) * 100 / totalTime
		self.loadingBar:setPercent(percentage)
		self.labelTime:setString(SoraDConvertSecondToString(remainTime))
	end)
	self.labelTime:beginTime(leftTime)
end
return windTowerMapTip
