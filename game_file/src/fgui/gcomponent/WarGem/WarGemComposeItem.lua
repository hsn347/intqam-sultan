local baseComponent = require("fgui.base.baseComponent")
local WarGemComposeItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/WarGemComposeItem", WarGemComposeItem)
function WarGemComposeItem:onInit()
	self:fixChildrenPos()
	self.fields.Image_arrow:fix()
end
function WarGemComposeItem:onShow()
end
function WarGemComposeItem:initData(id, num, needNum)
	self.fields.Com_item:initData(id, num, needNum)
	if num == 0 and not needNum then
		self.fields.Com_item:setNumText(num)
	end
end
function WarGemComposeItem:setArrow(value)
	self.controllers.c1:setSelectedIndex(value and 1 or 0)
end
return WarGemComposeItem
