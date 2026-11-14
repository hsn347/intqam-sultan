local baseComponent = require("fgui.base.baseComponent")
local Com_WTV_Progresss = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_WTV_Progresss", Com_WTV_Progresss)
function Com_WTV_Progresss:onInit()
	self:fixChildrenPos()
	self.fields.glass:setVisible(false)
	self.txtTitle = SoraDCreateTimerLabel(self, self.fields.txtTitle)
end
function Com_WTV_Progresss:onShow()
end
function Com_WTV_Progresss:initData(curTime, totalTime, timeLast, callBack)
	self.curTime = curTime
	self.totalTime = totalTime
	self.myCallBack = callBack
	self.timeLast = timeLast
	if curTime and totalTime then
		self:beginTime()
	else
		self:tipLevelLimit()
	end
end
function Com_WTV_Progresss:tipLevelLimit(...)
	self:setPercent(1, 1)
	_ENV = nil
	;(nil).level = WATCH_TOWER_VIEW_ARRIVETIME_LV
	self:setTitle(i18n("common_text_596", nil))
end
function Com_WTV_Progresss:endTime(...)
	self.txtTitle:endTime()
end
function Com_WTV_Progresss:setTitle(text)
	self.txtTitle:setString(text)
	self.fields.glass:setVisible(false)
end
function Com_WTV_Progresss:setPercent(cur, max)
	self:setMax(max)
	self:setValue(cur)
end
function Com_WTV_Progresss:beginTime()
	if self.timeLast then
		self.txtTitle:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n(self.timeLast, nil)
		end)
	end
	self.fields.glass:setVisible(false)
	if self.myCallBack then
		self.txtTitle:setTimeEndListener(handler(self, self.myCallBack))
	end
	self.txtTitle:setTimeUpdateListener(function(ticket)
		self:setPercent(ticket, self.totalTime)
	end)
	self.txtTitle:beginTime(self.curTime)
end
function Com_WTV_Progresss:showWaitingTitle(titleStr)
	self:setTitle(string.format("%s(%s)", titleStr, i18n("watchtower_text1")))
	self.fields.glass:setVisible(true)
end
return Com_WTV_Progresss
