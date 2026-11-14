local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_list", Com_list)
function Com_list:onInit()
	self:fixChildrenPos()
	self.fields.arrow:setRotation(SoraDFIsRA() and 90 or -90)
end
function Com_list:onShow()
end
function Com_list:initData(data)
	if data.noToVal then
		self:initDataEX(data)
	else
		self.fields.arrow:setVisible(true)
		self.fields.Text_curVal:setVisible(true)
		self.fields.Text_name:setString(data.name)
		self.fields.Text_name:setColor(data.color)
		self.fields.Text_curVal:setString(data.curVal)
		self.fields.Text_curVal:setColor(data.color)
		self.fields.Text_toVal:setString(data.toVal)
		self.fields.Text_toVal:setColor(data.color)
	end
end
function Com_list:initDataEX(data)
	self.fields.arrow:setVisible(false)
	self.fields.Text_curVal:setVisible(false)
	self.fields.Text_name:setString(data.name)
	self.fields.Text_name:setColor(data.color)
	self.fields.Text_toVal:setString(data.val or data.curVal)
	self.fields.Text_toVal:setColor(data.color)
end
return Com_list
