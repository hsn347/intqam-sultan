local baseComponent = require("fgui.base.baseComponent")
local Com_icon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SiriusMerchant/Com_icon", Com_icon)
function Com_icon:onInit()
end
function Com_icon:onShow()
end
function Com_icon:initData(id, count)
	self.fields.Com_Item:initData(id, count)
end
return Com_icon
