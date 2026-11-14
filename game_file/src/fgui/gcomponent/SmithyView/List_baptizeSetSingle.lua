local equipDesRead = include("equipDesRead")
local constantRead = include("constantRead")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local List_baptizeSetSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_baptizeSetSingle", List_baptizeSetSingle)
function List_baptizeSetSingle:onInit()
	self.fields.Button_set:addClickListener(handler(self, self.onBtnSet))
	self.fields.Button_view:addClickListener(handler(self, self.onBtnView))
	self.fields.Button_edit:addClickListener(handler(self, self.onBtnEdit))
	self.fields.Button_del:addClickListener(handler(self, self.onBtnDel))
	self:fixChildrenPos()
end
function List_baptizeSetSingle:onShow()
end
function List_baptizeSetSingle:initData(data, quality)
	self.data = data
	self.quality = quality
	local isSetted = self.data.info and next(self.data.info) and true or false
	self.controllers.c1:setSelectedIndex(isSetted and 1 or 0)
	if isSetted then
		self:setHeight(59 + #self.data.info * 29)
		self.fields.bg:setHeight(59 + #self.data.info * 29)
		self.fields.Button_view:setHeight(59 + #self.data.info * 29)
		self.fields.Text_des:setHeight(#self.data.info * 29)
		self.fields.Text_name:setPositionY(2)
		self.fields.Text_name:setString(self.data.name and self.data.name or i18n("equipment_training_text_13"))
		local attCfgs = equipDesRead.getAttributeGroupCfg()
		local _ENV, attrStr = self.fields.Text_name, self.fields.Text_name
		for k, v in ipairs(self.data.info) do
			table.insert(attrStr, i18n(attCfgs[v].name))
		end
		self.fields.Text_des:setString(table.concat(attrStr, "\n"))
	else
		self:setHeight(59)
		self.fields.Button_view:setHeight(59)
		self.fields.Text_name:setPositionY(7)
		self.fields.Text_name:setString(i18n("equipment_training_text_13"))
	end
end
function List_baptizeSetSingle:onBtnSet()
	SoraDPlaySound()
	local setCount = equipmentCtrl:getSettedAttributeGroupCount()
	local maxGroup = constantRead.getConstValue("EQUIPMENT_ATTRIBUTE_GROUP_MAX_COUNT")
	if setCount >= maxGroup then
		SoraDShowMsgTip(i18n("equipment_training_text_16"))
	else
		_ENV = i18n("equipment_training_text_16")
		i18n("equipment_training_text_16").data = self.data
		i18n("equipment_training_text_16").quality = self.quality
		uiManager:show("equipBaptizeSetSelectView", i18n("equipment_training_text_16"))
	end
end
function List_baptizeSetSingle:onBtnView()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	;(nil).quality = self.quality
	uiManager:show("equipBaptizeSetSelectView", nil)
end
function List_baptizeSetSingle:onBtnEdit()
	SoraDPlaySound()
	_ENV = nil
	;(nil).renameType = 6
	;(nil).quality = self.quality
	;(nil).data = self.data
	uiManager:show("lordEquipRename", nil)
end
function List_baptizeSetSingle:onBtnDel()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("equipment_training_text_10")
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		equipmentCtrl:setAttributeGroupInfo(2, self.quality, self.data.position)
	end
	uiManager:show("MessageBox", nil)
end
return List_baptizeSetSingle
