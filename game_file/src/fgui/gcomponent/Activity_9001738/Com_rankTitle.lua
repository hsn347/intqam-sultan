local baseComponent = require("fgui.base.baseComponent")
local Com_rankTitle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_rankTitle", Com_rankTitle)
function Com_rankTitle:onInit()
	self:fixChildrenPos()
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_count:setString(i18n("freekick_master_text_08"))
end
function Com_rankTitle:onShow()
end
return Com_rankTitle
