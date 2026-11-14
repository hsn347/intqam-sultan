local baseComponent = require("fgui.base.baseComponent")
local Button_createAlliance = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceCreateView/Button_createAlliance", Button_createAlliance)
function Button_createAlliance:onInit()
	self.fields.Text_createTitle:setString(i18n("common_text_168"))
end
function Button_createAlliance:onShow()
end
function Button_createAlliance:initData(isFree)
	self.controllers.c1:setSelectedIndex(isFree and 0 or 1)
	if isFree then
		self.fields.Text_condition:setString(i18n("common_text_049"))
	else
		_ENV = i18n("common_text_049")
		i18n("common_text_049").lv = CASTLE_LV6_LIMITED
		self.fields.Text_condition:setString(string.format("%s/%s", fguiHelper.getColorString("#FFFF00", gConstValue.ALLIANCE_CREATE_ALLIANCE_GOLD), i18n("common_text_169", i18n("common_text_049"))))
		self.fields.Text_condition:fixPos()
		self.fields.Icon_gold:fixPos()
	end
end
return Button_createAlliance
