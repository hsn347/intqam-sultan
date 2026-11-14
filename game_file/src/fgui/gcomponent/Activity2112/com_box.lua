local baseComponent = require("fgui.base.baseComponent")
local newYearSignInCtrl = SoraDGetCtrl("newYearSignInCtrl")
local com_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity2112/com_box", com_box)
fgui.register_extension("ui://Activity2112/com_bigBox", com_box)
function com_box:onInit()
	if self.fields.n12 then
		self.fields.n12:setAllFrameName("G_dh_jianianhua%.2d.png", 1)
	end
end
function com_box:onShow()
end
function com_box:initData(day)
	self.day = day
	_ENV = nil
	;(nil).count = day
	self.fields.textDay:setString(i18n("common_text_523", nil))
	local state = newYearSignInCtrl:getDayRewardStatus(day)
	self.controllers.c1:setSelectedIndex(state <= 2 and state or 0)
	if state == 2 then
		self.transitions.t1:play(-1, 0)
	else
		self.transitions.t1:stop()
	end
end
return com_box
