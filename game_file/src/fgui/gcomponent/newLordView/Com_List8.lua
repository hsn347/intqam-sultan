local baseComponent = require("fgui.base.baseComponent")
local Com_List8 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List8", Com_List8)
function Com_List8:onInit()
	self:fixChildrenPos()
end
function Com_List8:onShow()
end
function Com_List8:initData(data)
	self.controllers.c1:setSelectedIndex(data.model)
	if data.model == 2 then
		self.fields.Text_noReach:setString(data.name)
	else
		self.fields.Text_name:setString(data.name)
		self.fields.Text_value:setString(data.value)
		if data.icon then
			self.fields.decorate:setSpriteFrame(data.icon)
			self.fields.decorate:fixPos()
		end
	end
end
return Com_List8
