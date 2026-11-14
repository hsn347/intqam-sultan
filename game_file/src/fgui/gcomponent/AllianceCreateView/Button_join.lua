local baseComponent = require("fgui.base.baseComponent")
local Button_join = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceCreateView/Button_join", Button_join)
function Button_join:onInit()
	self.fields.Text_applyed:setString(i18n("alliance_office_btn_02"))
	self.fields.timer:setTimeLast(function(time)
		return time .. "s"
	end)
	self.fields.timer:setTimeEndListener(function()
		self:setStatus(2, i18n("common_text_184"))
	end)
end
function Button_join:onShow()
end
function Button_join:setStatus(state, title, leftTime)
	self.controllers.c1:setSelectedIndex(state)
	if title then
		self.fields.title:setString(title)
	end
	if state == 1 and 0 < leftTime then
		self.fields.timer:beginTime(leftTime, false, true)
		self:setTouchEnabled(false)
	else
		self:setTouchEnabled(true)
	end
end
return Button_join
