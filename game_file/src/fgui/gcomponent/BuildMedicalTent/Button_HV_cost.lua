local baseComponent = require("fgui.base.baseComponent")
local Button_HV_cost = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://BuildMedicalTent/Button_HV_cost", Button_HV_cost)
function Button_HV_cost:onInit()
end
function Button_HV_cost:onShow()
end
function Button_HV_cost:setCostIcon(icon)
	self.fields.Icon_gold:setURL(icon)
end
function Button_HV_cost:setTitleColor(color)
	self.fields.title:setColor(color)
end
function Button_HV_cost:setGoldColor(color)
	self.fields.Text_gold:setColor(color)
end
function Button_HV_cost:setCostTitle(str)
	self.fields.Text_gold:setString(str)
end
function Button_HV_cost:setRightNowVisible(isVisible)
	self.controllers.c2:setSelectedIndex(isVisible and 0 or 1)
end
function Button_HV_cost:setBtnBgGray(flag)
	self.fields.btnBg:setGrayed(flag)
end
return Button_HV_cost
