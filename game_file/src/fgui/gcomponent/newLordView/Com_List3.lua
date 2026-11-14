local baseComponent = require("fgui.base.baseComponent")
local Com_List3 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List3", Com_List3)
function Com_List3:onInit()
	self.fields.com_shop1:fixPos()
	self.fields.com_shop2:fixPos()
end
function Com_List3:onShow()
end
function Com_List3:initData(data)
	if data.left then
		self.fields.com_shop1:setVisible(true)
		self.fields.com_shop1:initData(data.left)
	else
		self.fields.com_shop1:setVisible(false)
	end
	if data.right then
		self.fields.com_shop2:setVisible(true)
		self.fields.com_shop2:initData(data.right)
	else
		self.fields.com_shop2:setVisible(false)
	end
end
return Com_List3
