local baseComponent = require("fgui.base.baseComponent")
local shopFloor = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/shopFloor", shopFloor)
function shopFloor:onInit()
	self.fields.itemRight:fixPos()
	self.fields.itemLeft:fixPos()
end
function shopFloor:onShow()
end
function shopFloor:initData(data, isDiscount)
	if data[1] then
		self.fields.itemRight:setVisible(true)
		self.fields.itemRight:initData(data[1], isDiscount)
	else
		self.fields.itemRight:setVisible(false)
	end
	if data[2] then
		self.fields.itemLeft:setVisible(true)
		self.fields.itemLeft:initData(data[2], isDiscount)
	else
		self.fields.itemLeft:setVisible(false)
	end
end
return shopFloor
