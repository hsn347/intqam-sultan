local baseComponent = require("fgui.base.baseComponent")
local Button_refresh = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMobilizationView/Button_refresh", Button_refresh)
function Button_refresh:onInit()
	self.fields.Text_refresh:setString(i18n("common_text_911"))
	self:fixChildrenPos()
end
function Button_refresh:onShow()
end
return Button_refresh
