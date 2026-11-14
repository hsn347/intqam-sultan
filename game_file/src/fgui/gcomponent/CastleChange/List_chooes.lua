local baseComponent = require("fgui.base.baseComponent")
local List_chooes = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CastleChange/List_chooes", List_chooes)
function List_chooes:onInit()
	self:fixChildrenPos()
end
function List_chooes:onShow()
end
function List_chooes:initData(data, curGroupId)
	if data.choose1 then
		self.fields.choose1:setGroupId(data.choose1.groupId)
		self.fields.choose1:setTitle(i18n(data.choose1.groupName))
		self.fields.choose1:setSelected(curGroupId == data.choose1.groupId)
		self.fields.choose1:setVisible(true)
	else
		self.fields.choose1:setVisible(false)
	end
	if data.choose2 then
		self.fields.choose2:setGroupId(data.choose2.groupId)
		self.fields.choose2:setTitle(i18n(data.choose2.groupName))
		self.fields.choose2:setSelected(curGroupId == data.choose2.groupId)
		self.fields.choose2:setVisible(true)
	else
		self.fields.choose2:setVisible(false)
	end
end
return List_chooes
