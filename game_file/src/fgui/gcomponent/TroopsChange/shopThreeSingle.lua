local baseComponent = require("fgui.base.baseComponent")
local shopThreeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/shopThreeSingle", shopThreeSingle)
function shopThreeSingle:onInit()
	self.fields.shopItem_1:fixPos()
	self.fields.shopItem_2:fixPos()
	self.fields.shopItem_3:fixPos()
end
function shopThreeSingle:initData(data1, data2, data3)
	if data1 then
		self.fields.shopItem_1:initData(data1)
	else
		self.fields.shopItem_1:setVisible(false)
	end
	if data2 then
		self.fields.shopItem_2:initData(data2)
	else
		self.fields.shopItem_2:setVisible(false)
	end
	if data3 then
		self.fields.shopItem_3:initData(data3)
	else
		self.fields.shopItem_3:setVisible(false)
	end
end
return shopThreeSingle
