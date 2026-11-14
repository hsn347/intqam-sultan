local baseComponent = require("fgui.base.baseComponent")
local Com_equipAdd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_equipAdd", Com_equipAdd)
function Com_equipAdd:onInit()
	_ENV = nil
	;(nil)[gEquipmentPart.WEAPON] = "武器"
	;(nil)[gEquipmentPart.BODY] = "衣服"
	;(nil)[gEquipmentPart.HEAD] = "头盔"
	;(nil)[gEquipmentPart.LEG] = "裤子"
	;(nil)[gEquipmentPart.FOOT] = "鞋子"
	;(nil)[gEquipmentPart.HAND] = "手套"
	;(nil)[gEquipmentPart.RING] = "戒指"
	self.partName, (nil)[gEquipmentPart.NECKLACE] = nil, "项链"
	self.fields.Button_touch:addClickListener(handler(self, self.btnClick))
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
	self.fields.Button_remove:fixPos()
end
function Com_equipAdd:onShow()
end
function Com_equipAdd:initData(index, editData)
	self.index = index
	self.editData = editData
	self.equip = self.editData.equipmentCfg and self.editData.equipmentCfg[tostring(index)]
	if self.equip then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.equip:initDataEX(self.equip)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.title:setString(self.partName[index])
	end
end
function Com_equipAdd:btnClick()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 0 then
		_ENV = nil
		;(nil).part = self.index
		;(nil).name = self.partName[self.index]
		uiManager:show("CheatEquipChoose", nil)
	elseif self.index <= gEquipmentPart.HAND then
		_ENV = nil
		;(nil).part = self.index
		;(nil).equip = self.equip
		uiManager:show("CheatEquipBuffPop", nil)
	end
end
function Com_equipAdd:btnRemoveClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_EQUIP"
	;(nil).part = self.index
	;(nil).equip = nil
	SoraDSendMessage(nil)
end
return Com_equipAdd
