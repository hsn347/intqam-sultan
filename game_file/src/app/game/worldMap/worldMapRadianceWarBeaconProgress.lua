local worldMapRadianceWarBeaconProgress = class("worldMapBeaconProgressBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapBeaconProgressBar")
	end
	return target
end)
function worldMapRadianceWarBeaconProgress:ctor()
	self.progressBar = SoraDGetChildByName(self, "LoadingBar_progress")
	if SoraDFIsRA() then
		self.progressBar:setDirection(1)
	else
		self.progressBar:setDirection(0)
	end
	self.maxOccupyTime = 20
	self.spriteLoadingBarBg = SoraDGetChildByName(self, "spriteLoadingBarBg")
	self.txtTime = SoraDGetChildByName(self, "Text_num")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeLast(function(str, tick)
		local percent = tick / self.maxOccupyTime * 100
		self.progressBar:setPercent(percent)
		return SoraDConvertSecondToString(tick)
	end)
	self.txtTime:setTimeEndListener(function()
		if self.showFinish then
			self:showFinishOccupy()
		else
			self:setVisible(false)
		end
	end)
	self.Node_tips = SoraDGetChildByName(self, "Node_tips")
	self.Text_tips = SoraDGetChildByName(self, "Text_tips")
	if self.Node_tips then
		self.Node_tips:setVisible(false)
	end
end
function worldMapRadianceWarBeaconProgress:initOccupy(instance)
	local time = 0
	if instance.timeFinish_Occupy and 0 < instance.timeFinish_Occupy and instance.timeBegin_Occupy and 0 < instance.timeBegin_Occupy then
		time = instance.timeFinish_Occupy - instance.timeBegin_Occupy
	end
	self.maxOccupyTime = 0 < time and time or 20
	self:showTips(instance)
	if instance:getInstanceType() == gMapObjTypeDef.nebulaWarBuilding then
		self:setIsShowFinish(true)
		self.spriteLoadingBarBg:setVisible(true)
		self.txtTime:setVisible(true)
	end
end
function worldMapRadianceWarBeaconProgress:initFree(instance)
	self.progressBar:loadTexture("progressbar_main_building02.png", ccui.TextureResType.plistType)
	local time = 0
	if instance.timeFinish_Free and 0 < instance.timeFinish_Free and instance.timeBegin_Free and 0 < instance.timeBegin_Free then
		time = instance.timeFinish_Free - instance.timeBegin_Free
	end
	self.maxOccupyTime = 0 < time and time or 20
end
function worldMapRadianceWarBeaconProgress:beginTime(time, isUp)
	if isUp then
		self.progressBar:setDirection(0)
	elseif SoraDFIsRA() then
		self.progressBar:setDirection(1)
	else
		self.progressBar:setDirection(0)
	end
	self:setVisible(true)
	self.txtTime:beginTime(time, isUp)
end
function worldMapRadianceWarBeaconProgress:endTime()
	self.txtTime:endTime()
	self:setVisible(false)
end
function worldMapRadianceWarBeaconProgress:showTips(instance)
	if self.Node_tips then
		self.Node_tips:setVisible(true)
	end
	if self.Text_tips then
		self.Text_tips:setString(i18n("brightWar_text_115"))
	end
	if gMapObjTypeDef.mapTypeRadianceWarGate == instance.siteClassID then
		self.Node_tips:setPositionY(70)
	elseif gMapObjTypeDef.nebulaWarBuilding == instance:getInstanceType() then
		self.Node_tips:setPositionY(130)
	else
		self.Node_tips:setPositionY(110)
	end
end
function worldMapRadianceWarBeaconProgress:hideTips(...)
	if self.Node_tips then
		self.Node_tips:setVisible(false)
	end
end
function worldMapRadianceWarBeaconProgress:setIsShowFinish(showFinish)
	self.showFinish = showFinish
end
function worldMapRadianceWarBeaconProgress:showFinishOccupy()
	self:setVisible(true)
	self.Node_tips:setVisible(true)
	self.Node_tips:setPositionY(130)
	self.Text_tips:setString(i18n("nebula_war_text_0092"))
	self.spriteLoadingBarBg:setVisible(false)
	self.txtTime:setVisible(false)
end
function worldMapRadianceWarBeaconProgress:setProgressScale(scale)
	self.Node_tips:setScale(scale)
	self.spriteLoadingBarBg:setScale(0.7 * scale)
	self.txtTime:setScale(scale)
end
return worldMapRadianceWarBeaconProgress
