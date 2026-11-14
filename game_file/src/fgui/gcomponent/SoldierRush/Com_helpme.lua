local baseComponent = require("fgui.base.baseComponent")
local Com_helpme = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_helpme", Com_helpme)
function Com_helpme:onInit()
	self.fields.title:setString(i18n("soldier_rush_text_28"))
	self.fields.title:fixPos()
end
function Com_helpme:onShow()
end
return Com_helpme
