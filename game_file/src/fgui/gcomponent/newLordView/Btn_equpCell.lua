local baseComponent = require("fgui.base.baseComponent")
local Btn_equpCell = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Btn_equpCell", Btn_equpCell)
function Btn_equpCell:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Btn_equpCell:onShow()
end
function Btn_equpCell:initData(data, epid, setID)
	self.data = data.data
	self.setID = setID
	if self.data then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.equip:initData(self.data)
		self.fields.cur:setVisible(self.data:getEPID() == epid)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.cur:setVisible(false)
	end
end
function Btn_equpCell:onClick()
	SoraDPlaySound()
	if self.data then
		local partType = self.data:getEquipmentPart()
		if partType >= gEquipmentPart.RING then
			_ENV = nil
			;(nil).data = self.data
			;(nil).setID = self.setID
			uiManager:show("ringNeckInfoView", nil)
		else
			_ENV = nil
			;(nil).type = gEquipMaterialType.EQUIP
			;(nil).singleData = self.data
			uiManager:show("storageBoxInfoView", nil)
		end
	end
end
return Btn_equpCell
