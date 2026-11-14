local baseComponent = require("fgui.base.baseComponent")
local Panel_builderTime = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Panel_builderTime", Panel_builderTime)
function Panel_builderTime:onInit()
	self:setVisible(false)
	self.fields.Text_builderTimeTitle:setString(i18n("common_text_844"))
	self.labelBuilder = SoraDCreateTimerLabel(self, self.fields.Text_builderTime)
	self.labelBuilder:setTimeEndListener(function(...)
		self:setVisible(false)
	end)
end
function Panel_builderTime:onShow()
end
function Panel_builderTime:setTimeTitle(str)
	self.fields.Text_builderTimeTitle:setString(str)
end
function Panel_builderTime:setTime(time)
	self.labelBuilder:beginTime(time)
end
function Panel_builderTime:setTimeVisble(ret)
	self.labelBuilder:setVisible(ret)
end
return Panel_builderTime
