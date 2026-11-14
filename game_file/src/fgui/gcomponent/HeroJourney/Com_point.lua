local baseComponent = require("fgui.base.baseComponent")
local Com_point = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://HeroJourney/Com_point", Com_point)
function Com_point:onInit()
	self:fixChildrenPos()
	self.fields.Text_score:setString(i18n("common_text_448"))
end
function Com_point:onShow()
end
return Com_point
