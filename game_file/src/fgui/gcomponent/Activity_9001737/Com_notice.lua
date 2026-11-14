local baseComponent = require("fgui.base.baseComponent")
local Com_notice = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001737/Com_notice", Com_notice)
function Com_notice:onInit()
	self.fields.Label_title:setString(i18n("common_text_3657"))
	self.fields.Label_content:setString(i18n("troublemaker_text_02"))
end
function Com_notice:onShow()
end
return Com_notice
