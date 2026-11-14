local cityBuildTopTipHand = class("cityBuildTopTipHand", function(cssFile)
	local view = include("ccsView")
	return view.new(cssFile)
end)
function cityBuildTopTipHand:ctor()
end
function cityBuildTopTipHand:initWithIndex(index)
	self.index = index
end
function cityBuildTopTipHand:beginTime(time)
	self.timeNumber = time
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function cityBuildTopTipHand:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:hideTopTipHandEffect()
	self:removeFromParent()
end
function cityBuildTopTipHand:updateTime(time)
	if self.timeNumber <= 0 then
		self:endTime()
		return
	end
	self.timeNumber = self.timeNumber - 1
end
function cityBuildTopTipHand:showTopTipHandEffect()
	local actMoveBy1 = cca.moveBy(0.5, 0, -30)
	local actMoveBy2 = actMoveBy1:reverse()
	_UPVALUE2_ = -30
	;(-30)[1] = actMoveBy1
	;(-30)[2] = actMoveBy2
	local actSeq = cca.seq(-30)
	local actRepeat = cca.repeatForever(actSeq)
	self:runAction(actRepeat)
	self:beginTime(5)
end
function cityBuildTopTipHand:hideTopTipHandEffect()
	self:stopAllActions()
end
function cityBuildTopTipHand:onEnter()
	self:showTopTipHandEffect()
end
function cityBuildTopTipHand:onExit()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
end
return cityBuildTopTipHand
