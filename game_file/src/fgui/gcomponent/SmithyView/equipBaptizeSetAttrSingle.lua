local baseComponent = require("fgui.base.baseComponent")
local equipBaptizeSetAttrSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/equipBaptizeSetAttrSingle", equipBaptizeSetAttrSingle)
function equipBaptizeSetAttrSingle:onInit()
	self.fields.Button_choose:addClickListener(handler(self, self.onBtnChoose))
	self:fixChildrenPos()
end
function equipBaptizeSetAttrSingle:onShow()
end
function equipBaptizeSetAttrSingle:initData(data, selectArray, handle)
	self.handle = handle
	self.index = data.index
	self.fields.bg:setVisible(data.idx % 2 == 1)
	self.fields.Text_name:setString(i18n(data.name))
	self.isSelected = SoraDisInList(self.index, selectArray)
	self.fields.Button_choose:setSelected(self.isSelected)
end
function equipBaptizeSetAttrSingle:onBtnChoose()
	SoraDPlaySound()
	self.isSelected = not self.isSelected
	self.fields.Button_choose:setSelected(self.isSelected)
	if self.handle then
		self.handle(self.isSelected and self.index or -self.index)
	end
end
return equipBaptizeSetAttrSingle
