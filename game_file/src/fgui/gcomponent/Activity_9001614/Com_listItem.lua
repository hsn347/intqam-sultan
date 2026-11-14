local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_listItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001614/Com_listItem", Com_listItem)
function Com_listItem:onInit()
	self:fixChildrenPos()
	self.fields.n31:fix()
	self.fields.n32:fix()
	self.fields.Particle_1:setRotation(SoraDFIsRA() and -90 or 90)
end
function Com_listItem:onShow()
end
function Com_listItem:initData(data, index)
	self.data = data
	self.fields.nbg:setVisible(index % 2 == 1)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.item:initData(self.data.id)
	self.fields.Text_itemName:setString(publicRead.getName(self.data.id))
	self.fields.Text_itemName:setColor(publicRead.checkLevelCondition(self.data.id) and cc.c3b(190, 40, 40) or cc.c3b(205, 190, 148))
	self.fields.Text_itemCount:setString("x" .. self.data.count)
end
return Com_listItem
