local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Button_cost = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://JerseyActivity/Button_cost", Button_cost)
function Button_cost:onInit()
	self:fixChildrenPos()
end
function Button_cost:onShow()
end
function Button_cost:setCost(id, num)
	local iconPng = publicRead.getIcon(id)
	self.fields.Icon_gold:setURL(iconPng)
	local haveGold = publicUtil.getCount(id)
	self.fields.Text_gold:setString(string.formatnumberthousands(num))
	self.controllers.Ctrl_status:setSelectedIndex(num <= haveGold and 0 or 1)
end
return Button_cost
