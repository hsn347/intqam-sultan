local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_preview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/list_preview", list_preview)
function list_preview:onInit()
	self.fields.Button_replace:setString(i18n("common_text_1371"))
	self.fields.Button_replace:addClickListener(handler(self, self.btnReplaceClick))
	self.fields.List:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.Button_replace:getController("c1"):setSelectedIndex(0)
end
function list_preview:onShow()
end
function list_preview:onAttrRenderer(index, obj)
	obj:initData(self.data[index + 1], self.equipCell)
end
function list_preview:initData(data, equipCell)
	self.data = data.data
	self.index = data.index
	self.equipCell = equipCell
	self.fields.List:setNumItems(#self.data)
	self:setHeight(#self.data * 32 + 72)
	if data.isNotice then
		self.fields.Button_replace:getController("c1"):setSelectedIndex(1)
		self.fields.Button_replace:getChild("nGet"):playAct()
	else
		self.fields.Button_replace:getController("c1"):setSelectedIndex(0)
	end
end
function list_preview:btnReplaceClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_1384"), i18n("common_text_204"), i18n("common_text_3626"), handler(self, self.baptizeSure))
end
function list_preview:baptizeSure(event)
	if event == MSGBOX_CALLBACK_YES then
		if not self.equipCell:getIsTenRemake() then
			equipmentCtrl:confirmRemakeProperty(self.equipCell:getEPID())
		else
			equipmentCtrl:confirmRemakeTenProperty(self.equipCell:getEPID(), self.index)
		end
	elseif event == MSGBOX_CALLBACK_NO and not self.equipCell:getIsTenRemake() then
		equipmentCtrl:deleteRemakeProperty(self.equipCell:getEPID())
	end
end
return list_preview
