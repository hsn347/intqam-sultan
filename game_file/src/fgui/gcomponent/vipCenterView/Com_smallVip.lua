local baseComponent = require("fgui.base.baseComponent")
local Com_smallVip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_smallVip", Com_smallVip)
function Com_smallVip:onInit()
end
function Com_smallVip:onShow()
end
function Com_smallVip:initData(level)
	if level > VIP_SVIP_LV then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Lab_lv:initData(level - VIP_SVIP_LV, true)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Lab_lv:initData(level)
	end
end
function Com_smallVip:setStatus(isActive)
	self.controllers.c2:setSelectedIndex(isActive and 1 or 0)
end
return Com_smallVip
