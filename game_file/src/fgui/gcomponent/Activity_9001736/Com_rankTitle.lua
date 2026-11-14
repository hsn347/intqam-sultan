local baseComponent = require("fgui.base.baseComponent")
local Com_rankTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001736/Com_rankTitle", Com_rankTitle)
function Com_rankTitle:onInit()
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_2037"))
	self.fields.Text_power:setString(i18n("football_match_text_011"))
	self.fields.Text_score:setString(i18n("common_text_2195"))
	self:fixChildrenPos()
end
function Com_rankTitle:onShow()
end
return Com_rankTitle
