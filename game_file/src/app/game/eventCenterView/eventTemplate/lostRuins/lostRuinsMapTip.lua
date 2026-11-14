local lostRuinsMapTip = class("lostRuinsMapTip", function(target)
	return SoraDCreateBasePanel("cityCoolingTip")
end)
function lostRuinsMapTip:ctor()
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
function lostRuinsMapTip:initActivityTime(leftTime, totalTime, status, isSurveying)
	if status == gLosRuinsStatus.SURVEY then
		self.iconImg:setSpriteFrame("icon_lostRuins_search.png")
	elseif status == gLosRuinsStatus.RECIEVED then
		self.iconImg:setSpriteFrame("icon_main_build_05.png")
	elseif status == gLosRuinsStatus.GIVE_UP or status == gLosRuinsStatus.RECIEVED_REWARD or status == gLosRuinsStatus.OVERDUE or status == gLosRuinsStatus.CANCEL then
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
function lostRuinsMapTip:setTimeEndCallBack(callback)
	self.labelTime:setTimeEndListener(callback)
end
return lostRuinsMapTip
