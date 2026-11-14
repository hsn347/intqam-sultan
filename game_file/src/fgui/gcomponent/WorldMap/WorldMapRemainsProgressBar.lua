local baseComponent = require("fgui.base.baseComponent")
local WorldMapRemainsProgressBar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://WorldMap/WorldMapRemainsProgressBar", WorldMapRemainsProgressBar)
function WorldMapRemainsProgressBar:onInit()
	self.timeData, _UPVALUE0_, self.fadeFlag = nil, nil, true
	self:setMax(100)
end
function WorldMapRemainsProgressBar:onShow()
end
function WorldMapRemainsProgressBar:initData(timeLoading)
	self.timeData = timeLoading
	self:beginTime(self.timeData.allTime - self.timeData.finishTime)
	self.fields.Text_percent:setAlpha(0)
	self.fields.Text_time:setAlpha(1)
	self:stopAction()
	self:turnAction()
end
function WorldMapRemainsProgressBar:beginTime(time)
	self.timeNumber = time
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function WorldMapRemainsProgressBar:endTime()
	if self.timeHandler then
		self:setValue(100)
		self.fields.Text_percent:setString("100%")
		self.fields.Text_time:setString("00:00:00")
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
end
function WorldMapRemainsProgressBar:updateTime(time)
	if self.timeNumber <= 0 then
		self:endTime()
		return
	end
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(self.timeNumber)
	self.fields.Text_time:setString(i18n("common_text_458", nil))
	self:setValue((self.timeData.allTime - self.timeNumber) / self.timeData.allTime * 100)
	self.fields.Text_percent:setString(math.floor(self:getValue()) .. "%")
	self.timeNumber = self.timeNumber - 1
end
function WorldMapRemainsProgressBar:stopAction()
	self.fields.Text_time:stopAllActions()
	self.fields.Text_percent:stopAllActions()
end
function WorldMapRemainsProgressBar:turnAction()
	local action0 = ffa.fadeOut(1.0)
	local action1 = ffa.fadeIn(1.0)
	local actionDelay = ffa.delay(4.0)
	local callFunc = ffa.callFunc(function()
		self.fadeFlag = not self.fadeFlag
		self:turnAction()
	end)
	if self.fadeFlag then
		_UPVALUE4_ = nil
		;(nil)[1] = action1
		;(nil)[2] = actionDelay
		;(nil)[3] = action0
		;(nil)[4] = callFunc
		self.fields.Text_time:runAction(ffa.seq(nil))
	else
		_UPVALUE4_ = ffa.seq(nil)
		ffa.seq(nil)[1] = action1
		ffa.seq(nil)[2] = actionDelay
		ffa.seq(nil)[3] = action0
		ffa.seq(nil)[4] = callFunc
		self.fields.Text_percent:runAction(ffa.seq(ffa.seq(nil)))
	end
end
return WorldMapRemainsProgressBar
