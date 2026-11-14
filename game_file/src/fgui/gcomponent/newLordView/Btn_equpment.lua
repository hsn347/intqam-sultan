local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local baseComponent = require("fgui.base.baseComponent")
local Btn_equpment = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Btn_equpment", Btn_equpment)
function Btn_equpment:onInit()
	self.isLong = false
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onClick))
	self:addClickListener(handler(self, self.onOutClick))
	self:fixChildrenPos()
end
function Btn_equpment:onShow()
end
function Btn_equpment:initData(index, data, setID, isSelf)
	self.index = index
	self.data = data
	self.setID = setID
	self.isSelf = isSelf
	self.fields.icon_type:setIcon(equipDesRead.getPartGrayIcon(index))
	if not data then
		if #equipmentMgr.getAllEquipmentByPart(index) > 0 and self.isSelf then
			self.controllers.c1:setSelectedIndex(2)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	else
		self.controllers.c1:setSelectedIndex(3)
		self.fields.equip:initData(data)
	end
end
function Btn_equpment:isWearEquip()
	return self.controllers.c1:getSelectedIndex() == 3
end
function Btn_equpment:initWear(index, data)
	self.fields.icon_type:setIcon(equipDesRead.getPartGrayIcon(index))
	if data then
		self.controllers.c1:setSelectedIndex(3)
		self.fields.equip:initData(data)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_equpment:initRingNeckLace(index, data)
	self.fields.icon_type:setIcon(equipDesRead.getPartGrayIcon(index))
	if data then
		self.controllers.c1:setSelectedIndex(3)
		self.fields.equip:initData(data)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Btn_equpment:onLongPress()
	self.isLong = true
	if self.controllers.c1:getSelectedIndex() == 3 then
		_ENV = self.controllers.c1
		self.controllers.c1.msg = "MESSAGE_UI_LORD_EQUIP_DETAIL"
		self.controllers.c1.data = self.data
		self.controllers.c1.index = self.index
		SoraDSendMessage(self.controllers.c1)
	end
end
function Btn_equpment:onClick()
	if self.isLong then
		self.isLong = false
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_LORD_EQUIP_DETAIL"
		SoraDSendMessage(nil)
		return
	end
	if not self.isSelf then
		return
	end
	if SoraDGetCastleLv() < CASTLE_LV10_LIMITED then
		SoraDShowMsgTip(i18n("common_text_1400"), nil, button)
		return
	end
	if self.index <= gEquipmentPart.HAND then
		if self.controllers.c1:getSelectedIndex() == 2 or self.controllers.c1:getSelectedIndex() == 3 then
			_ENV = button
			button.part = self.index
			button.setID = self.setID
			uiManager:show("equipWearView", button)
			SoraDGetEquip()
		end
	elseif self.controllers.c1:getSelectedIndex() ~= 1 then
		_ENV = button
		button.part = self.index
		button.setID = self.setID
		uiManager:show("ringNeckLaceWearView", button)
	end
end
function Btn_equpment:onOutClick()
	self.isLong = false
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LORD_EQUIP_DETAIL"
	SoraDSendMessage(nil)
end
return Btn_equpment
