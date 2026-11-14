local buffDesRead = include("buffDesRead")
local godEquipmentAwakeSingle = class("godEquipmentAwakeSingle", function(luaFileName)
	return SoraDCreateBasePanel("godEquipmentAwakeSingle")
end)
function godEquipmentAwakeSingle:ctor()
	self.data, _ENV, self.arrtArray, _ENV = nil, nil, nil, nil
	self.isSelected = false
	for i = 1, 4 do
		self.arrtArray[i] = SoraDGetChildByName(self, "Node_attr_" .. i)
	end
	self.Text_power = SoraDGetChildByName(self, "Text_power")
	self.Text_power:setString(i18n("common_text_090"))
	self.Text_power_value = SoraDGetChildByName(self, "Text_power_value")
	self.CheckBox_item = SoraDGetChildByName(self, "CheckBox_item")
	self.CheckBox_item:setSwallowTouches(false)
	self.CheckBox_item:addTouchEventListener(handler(self, self.checkBoxClick))
	self.btn_cmd = SoraDGetChildByName(self, "btn_cmd")
end
function godEquipmentAwakeSingle:initData(data, otherData)
	self.data = data
	self:setScroll(otherData and otherData.scroll)
	self.btn_cmd:setVisible(self.data.isCmd)
	local power_str = "0"
	local color = cc.c3b(255, 255, 255)
	if self.data.prePower > self.data.oriPower then
		power_str = SoraDFValueSuit(self.data.prePower - self.data.oriPower)
		color = cc.c3b(0, 190, 30)
	elseif self.data.prePower < self.data.oriPower then
		power_str = SoraDFValueSuit(self.data.oriPower - self.data.prePower, "-")
		color = cc.c3b(190, 40, 40)
	end
	self.Text_power_value:setString(power_str)
	self.Text_power_value:setColor(color)
	for k, v in ipairs(self.arrtArray) do
		self.data[k].value = SoraDPreciseDecimal(self.data[k].value, 1)
		self.data[k].cur = SoraDPreciseDecimal(self.data[k].cur, 1)
		local Text_attr = v:getChildByName("Text_attr")
		Text_attr:setString(buffDesRead.getTitleBase(self.data[k].buffType))
		local Text_attr_value = v:getChildByName("Text_attr_value")
		local _color = cc.c3b(255, 255, 255)
		if self.data[k].value > self.data[k].cur then
			_color = cc.c3b(0, 190, 30)
			Text_attr_value:setString(SoraDFValueSuit(buffDesRead.getTitleValueWithValue(self.data[k].buffType, SoraDPreciseDecimal(self.data[k].value - self.data[k].cur, 2), true)))
		elseif self.data[k].value < self.data[k].cur then
			_color = cc.c3b(190, 40, 40)
			Text_attr_value:setString(SoraDFValueSuit(buffDesRead.getTitleValueWithValue(self.data[k].buffType, SoraDPreciseDecimal(self.data[k].cur - self.data[k].value, 2), true), "-"))
		elseif include("miraculousWeaponltCtrl").getWeaponMaxBuffValue(self.data.weaponID, self.data[k].buffType) == self.data[k].cur then
			Text_attr_value:setString("MAX")
		else
			Text_attr_value:setString("0%")
		end
		Text_attr_value:setColor(_color)
	end
	self.isSelected = self.data.isSelected
	self.CheckBox_item:setSelected(self.isSelected)
end
function godEquipmentAwakeSingle:setScroll(scroll)
	self.scroll = scroll
end
function godEquipmentAwakeSingle:getIsSelected()
	return self.isSelected, self.data.key
end
function godEquipmentAwakeSingle:checkBoxClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		self.CheckBox_item:setSelected(self.CheckBox_item:isSelected())
		self.isSelected = not self.isSelected
		local gametop = gModuleMgr.getObject("gametop")
		local miraculousWeaponCtrl = gametop.playertop_:getModule("miraculousWeaponCtrl")
		miraculousWeaponCtrl:changeSelectedStatus(self.data.weaponID, self.data.key, self.isSelected)
		_ENV = miraculousWeaponCtrl
		miraculousWeaponCtrl.msg = "MESSAGE_UI_GODEQUIP_SELECTATTR_UPDATE"
		SoraDSendMessage(miraculousWeaponCtrl)
	end
end
return godEquipmentAwakeSingle
