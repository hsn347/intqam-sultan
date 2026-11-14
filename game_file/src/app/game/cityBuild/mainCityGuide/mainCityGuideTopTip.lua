local mainCityGuideTopTip = class("mainCityGuideTopTip", function(target)
	if target == nil then
		return SoraDCreateCSBNode("mainCityGuideTopTip")
	end
	if type(target) == "string" then
		return SoraDCreateCSBNode(target)
	end
	return target
end)
function mainCityGuideTopTip:ctor()
	self.button = SoraDGetChildByName(self, "button")
	self.icon = SoraDGetChildByName(self, "icon")
	local spriteFinger = SoraDFingerAction()
	spriteFinger:setPosition(self.icon:getPosition())
	spriteFinger:addTo(self, 4)
	self.spriteFinger = spriteFinger
	self.button:addTouchEventListener(handler(self, self.btnClick))
	self.imgBar = SoraDGetChildByName(self, "Sprite_bar")
	self.loadingBar = display.newProgressTimer(self.imgBar, display.PROGRESS_TIMER_RADIAL)
	self.loadingBar:setVisible(false)
	self.loadingBar:setPosition(cc.p(self.imgBar:getPositionX(), self.imgBar:getPositionY()))
	self.loadingBar:addTo(self, 5)
	self.loadingBar:setScale(self.imgBar:getScale())
	self.imgBar:removeFromParent(true)
end
function mainCityGuideTopTip:initData(data)
	self.data = data
	self.icon:loadTexture(data.icon, ccui.TextureResType.plistType)
	self:setPosition(data.pos)
end
function mainCityGuideTopTip:reUse(data)
	if data then
		self:initData(data)
	end
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	self.spriteFinger:setVisible(true)
end
function mainCityGuideTopTip:setClickCallback(callback)
	self.callback = callback
end
function mainCityGuideTopTip:btnClick()
	if self.callback then
		SoraDPlaySound()
		self.callback(self.data, self)
		self.callback = nil
		self.spriteFinger:setVisible(false)
	end
end
function mainCityGuideTopTip:playAnimation(playEndCallback, time)
	if self.data.param and self.data.param.time then
		time = self.data.param.time
	end
	self.icon:loadTexture("icon_cqjs_daojishi.png", ccui.TextureResType.plistType)
	self:scheduleUpdateWithPriorityLua(handler(self, self.loadingBarUpdateListener), 0)
	self.loadingBar:setVisible(true)
	self.totalTime = time and time or 1
	self.leftTime = self.totalTime
	self:loadingBarUpdateListener(0)
	self.playEndCallback = playEndCallback
end
function mainCityGuideTopTip:loadingBarUpdateListener(curTime)
	self.leftTime = self.leftTime - curTime
	self.loadingBar:setPercentage((self.totalTime - self.leftTime) * 100 / self.totalTime)
	if self.leftTime <= 0 then
		self:timerSleep()
	end
end
function mainCityGuideTopTip:timerSleep()
	self:unscheduleUpdate()
	self.loadingBar:setVisible(false)
	if self.playEndCallback then
		self.playEndCallback()
	end
end
function mainCityGuideTopTip:getBubbleType()
	return self.data.type
end
return mainCityGuideTopTip
