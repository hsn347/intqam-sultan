local baseComponent = require("fgui.base.baseComponent")
local Lab_info = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://RechargeView/Lab_info", Lab_info)
function Lab_info:onInit()
	self:fixChildrenPos()
end
function Lab_info:onShow()
end
function Lab_info:initData(data)
	self.fields.title:setString(data.title)
end
return Lab_info
