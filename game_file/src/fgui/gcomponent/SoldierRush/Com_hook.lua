local baseComponent = require("fgui.base.baseComponent")
local Com_hook = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_hook", Com_hook)
function Com_hook:onInit()
	self.fields.title:setString(i18n("soldier_rush_text_119"))
end
function Com_hook:onShow()
end
function Com_hook:setRed(ret)
	self.fields.Label_reddot:initData(ret, 0)
end
return Com_hook
