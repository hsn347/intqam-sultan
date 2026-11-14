local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_normal = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_normal", UI_Btn_normal)
fgui.register_extension("ui://CommonUI/UI_Btn_middle", UI_Btn_normal)
function UI_Btn_normal:onInit()
	self.fields.Label_reddot:setVisible(false)
end
function UI_Btn_normal:onShow()
end
function UI_Btn_normal:setBtnColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function UI_Btn_normal:setTitleColor(color)
	self.fields.title:setColor(color)
end
function UI_Btn_normal:setGrayed(value)
	self.fields.btnBg:setGrayed(value)
end
function UI_Btn_normal:setTime(time, lastStr, endHandle)
	self.titleTimer = SoraDCreateTimerLabel(self, self.fields.title)
	self.titleTimer:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n(lastStr, nil)
	end)
	self.titleTimer:setTimeEndListener(endHandle)
	self.titleTimer:beginTime(time)
end
return UI_Btn_normal
