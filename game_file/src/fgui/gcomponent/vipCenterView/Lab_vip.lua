local baseComponent = require("fgui.base.baseComponent")
local Lab_vip = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://vipCenterView/Lab_vip", Lab_vip)
function Lab_vip:onInit()
end
function Lab_vip:onShow()
end
function Lab_vip:initData(lv, isSvip)
	self.controllers.c1:setSelectedIndex(isSvip and 1 or 0)
	if isSvip then
		self.fields.title_svip:setString("SVIP" .. lv)
	else
		self.fields.title_vip:setString("VIP" .. lv)
	end
end
return Lab_vip
