local equipmentMgr = include("equipmentMgr")
local baseComponent = require("fgui.base.baseComponent")
local Btn_equipment = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_equipment", Btn_equipment)
function Btn_equipment:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_equipment:onShow()
end
function Btn_equipment:initData(data, selectID)
	self.data = data
	self.selectID = selectID
	if self.data and next(self.data) then
		self.fields.equip:setVisible(true)
		self.fields.equip:initData(self.data, self.selectID)
	else
		self.fields.equip:setVisible(false)
	end
end
function Btn_equipment:btnClick()
	SoraDPlaySound()
	if self.data and next(self.data) then
		_ENV = nil
		;(nil).type = gEquipMaterialType.EQUIP
		;(nil).singleData = self.data
		uiManager:show("storageBoxInfoView", nil)
		equipmentMgr.cleanNewListByEquip(self.data)
		_ENV = self.data
		self.data.msg = "MESSAGE_UI_EQUIP_SELECT"
		self.data.id = self.data:getEID()
		SoraDSendMessage(self.data)
	end
end
return Btn_equipment
