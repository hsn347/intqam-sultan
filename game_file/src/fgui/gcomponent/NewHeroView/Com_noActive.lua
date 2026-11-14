local baseComponent = require("fgui.base.baseComponent")
local Com_noActive = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_noActive", Com_noActive)
function Com_noActive:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
end
function Com_noActive:onShow()
end
function Com_noActive:setTime(time)
	self.Text_Time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("notactivate_text_1", nil)
	end)
	self.Text_Time:setTimeEndListener(function()
		self:setVisible(false)
	end)
	self.Text_Time:beginTime(time)
end
return Com_noActive
