local baseComponent = require("fgui.base.baseComponent")
local Handbook_title = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ManorFarm/Handbook_title", Handbook_title)
function Handbook_title:onInit()
	self.fields.title:setString(i18n("title_text"))
end
function Handbook_title:onShow()
end
function Handbook_title:initData(data)
	self.fields.title:setString(data.name)
	self.fields.icon:setURL(data.frame)
end
return Handbook_title
