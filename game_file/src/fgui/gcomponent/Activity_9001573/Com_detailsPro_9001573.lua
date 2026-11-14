local baseComponent = require("fgui.base.baseComponent")
local Com_detailsPro_9001573 = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://Activity_9001573/Com_detailsPro_9001573", Com_detailsPro_9001573)
function Com_detailsPro_9001573:onInit()
	self:fixChildrenPos()
end
function Com_detailsPro_9001573:onShow()
end
function Com_detailsPro_9001573:initData(des, value, icon, barSp)
	self.fields.txt_des:setString(des)
	self.fields.txt_value:setString(value)
	self.fields.icon:setURL(icon)
	self.fields.bar:setURL(barSp)
end
return Com_detailsPro_9001573
