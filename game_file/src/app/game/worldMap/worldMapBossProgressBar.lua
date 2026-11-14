local WorldMapBossProgressBar = class("worldMapBossProgressBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapBossProgressBar")
	end
	return target
end)
local GROU_ID = worldMapDefine.GROU_ID
function WorldMapBossProgressBar:ctor()
	self.shieldProgressBarNode = SoraDGetChildByName(self, "shieldLoadingBarBg")
	self.shieldProgressBar = SoraDGetChildByName(self, "shield_progress")
	self.Text_shield = SoraDGetChildByName(self, "Text_shield")
	if self.Text_shield then
		self.Text_shield:setString(i18n("Dessert_Thief_26"))
	end
	self.progressBarBg = SoraDGetChildByName(self, "spriteLoadingBarBg")
	self.progressBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtTime = SoraDGetChildByName(self, "Text_num")
end
function WorldMapBossProgressBar:setPercent(percent)
	self:setVisible(true)
	if self.shieldProgressBarNode then
		self.shieldProgressBarNode:setVisible(false)
	end
	self.progressBarBg:setVisible(true)
	self.progressBar:setPercent(percent)
	self.txtTime:setString(SoraDFValueSuit(percent, "%"))
	if self.Text_count then
		self.Text_count:setVisible(false)
	end
end
function WorldMapBossProgressBar:setShieldValue(value, maxValue)
	if self.shieldProgressBarNode then
		self.shieldProgressBarNode:setVisible(true)
	end
	self.progressBarBg:setVisible(false)
	local percent = value / maxValue * 100
	self:setVisible(true)
	if self.shieldProgressBar then
		self.shieldProgressBar:setPercent(percent)
	end
	self.txtTime:setString(value)
	if self.Text_count then
		self.Text_count:setVisible(false)
	end
end
function WorldMapBossProgressBar:setTimeValue(value, maxValue)
	if self.shieldProgressBarNode then
		self.shieldProgressBarNode:setVisible(true)
	end
	self.progressBarBg:setVisible(false)
	if self.Text_count then
		self.Text_count:setVisible(false)
	end
	local shield_text_bg = SoraDGetChildByName(self, "shield_text_bg")
	shield_text_bg:setVisible(false)
	self.Text_shield:setVisible(false)
	local percent = value / maxValue * 100
	self:setVisible(true)
	if self.shieldProgressBar then
		self.shieldProgressBar:setPercent(percent)
		self.shieldProgressBar:setCapInsets(cc.rect(1, 1, 1, 1))
		self.shieldProgressBar:loadTexture("img_common_bars_blue.png", ccui.TextureResType.plistType)
	end
	if not self.txtTime2 then
		self.txtTime2 = SoraDCreateTimerLabel(self, self.txtTime)
		self.txtTime2:setTimeUpdateListener(function(time)
			local percent = time / self.maxValue * 100
			self.shieldProgressBar:setPercent(percent)
		end)
	end
	self.maxValue = maxValue
	self.txtTime2:beginTime(value)
end
function WorldMapBossProgressBar:setTextCount(count)
	if not self.Text_count then
		self.Text_count = SoraDGetChildByName(self, "Text_count")
	end
	self.Text_count:setVisible(true)
	self.Text_count:setString(SoraDFValueSuit("x", count))
end
function WorldMapBossProgressBar:_initTips()
	local nodeTips = SoraDCreateCSBNode("worldMapRadianceWarTips")
	nodeTips:addTo(self)
	nodeTips:setPosition(0, 40)
	nodeTips:setVisible(false)
	self.nodeTips = nodeTips
	self.nodeTips:setGroupID(GROU_ID.group_moveline_text)
	self.nodeTips:setGroupAuto(true)
	self.Text_tips = SoraDGetChildByName(nodeTips, "Text_tips")
	self.Text_tips = SoraDCreateTimerLabel(self, self.Text_tips)
	self.Text_tips:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("brightWar_text_143", nil)
	end)
	self.Text_tips:setTimeEndListener(function()
		self.nodeTips:setVisible(false)
	end)
end
function WorldMapBossProgressBar:updateTips(recoverHpTime)
	if not self.nodeTips then
		self:_initTips()
	end
	local leftTime = recoverHpTime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.nodeTips:setVisible(true)
		self.Text_tips:beginTime(leftTime)
	else
		self.nodeTips:setVisible(false)
	end
end
function WorldMapBossProgressBar:setReleaseTime(releaseTime)
	if 0 < releaseTime then
		if not self.txtReaseTime then
			self.txtReaseTime = SoraDCreateTimerLabel(self, SoraDGetChildByName(self, "Text_release_time"))
		end
		self.txtReaseTime:removeTime()
		self.txtReaseTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("wasteland_text_023", nil)
		end)
		self.txtReaseTime:beginTime(releaseTime)
		self.txtReaseTime:setVisible(true)
	end
	if releaseTime <= 0 and self.txtReaseTime then
		self.txtReaseTime:removeTime()
		self.txtReaseTime:setVisible(false)
	end
end
return WorldMapBossProgressBar
