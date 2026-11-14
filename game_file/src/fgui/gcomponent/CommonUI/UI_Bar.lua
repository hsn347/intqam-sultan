local baseComponent = require("fgui.base.baseComponent")
local UI_Bar = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Bar", UI_Bar)
fgui.register_extension("ui://CommonUI/UI_Bar1", UI_Bar)
fgui.register_extension("ui://CommonUI/UI_Bar2", UI_Bar)
fgui.register_extension("ui://CommonUI/UI_Bar3", UI_Bar)
fgui.register_extension("ui://CommonUI/UI_Bar4", UI_Bar)
function UI_Bar:onInit()
	self.fields.Label_time:setVisible(false)
	self.fields.bar:fixPos()
end
function UI_Bar:onShow()
end
function UI_Bar:setBarTitle(str)
	self.fields.title:setString(str)
end
function UI_Bar:hideTitle()
	self.fields.title:setVisible(false)
end
function UI_Bar:hideLabelTime()
	self.fields.Label_time:setVisible(false)
end
function UI_Bar:showLabelTime()
	self.fields.Label_time:setVisible(true)
end
function UI_Bar:setTime(leftTime, totalTime, isUp, timeLast)
	self.totalTime = totalTime
	self.isUp = isUp
	self.fields.title:setVisible(false)
	self.fields.Label_time:setVisible(true)
	if timeLast then
		self.fields.Label_time:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).time = strTime
			return i18n(timeLast, nil)
		end)
	end
	self.fields.Label_time:setTimeUpdateListener(function(time)
		self:setValue(self.isUp and self.totalTime - time or time)
		if self.timeUpdateFun then
			self.timeUpdateFun(time)
		end
	end)
	self:setMax(self.totalTime)
	self.fields.Label_time:beginTime(leftTime)
end
function UI_Bar:setTimeUpdateFun(callback)
	self.timeUpdateFun = callback
end
function UI_Bar:setTimeUpdateListener(callback)
	self.fields.Label_time:setTimeUpdateListener(function(time)
		self:setValue(self.isUp and self.totalTime - time or time)
		if callback then
			callback(time)
		end
	end)
end
function UI_Bar:setBarColor(index)
	self.controllers.color:setSelectedIndex(index)
end
function UI_Bar:setLabelTimeStr(timeStr)
	self.fields.Label_time:setString(timeStr)
end
return UI_Bar
