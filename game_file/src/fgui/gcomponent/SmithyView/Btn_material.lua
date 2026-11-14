local baseComponent = require("fgui.base.baseComponent")
local Btn_material = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_material", Btn_material)
function Btn_material:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_material:onShow()
end
function Btn_material:initData(data, selectID)
	self.data = data
	self.selectID = selectID
	if self.data and next(self.data) then
		self.fields.material:setVisible(true)
		self.fields.material:initData(self.data, self.selectID)
	else
		self.fields.material:setVisible(false)
	end
end
function Btn_material:btnClick()
	SoraDPlaySound()
	if self.data and next(self.data) then
		_ENV = nil
		;(nil).type = gEquipMaterialType.MATERIAL
		;(nil).singleData = self.data
		uiManager:show("storageBoxInfoView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_UI_EQUIP_MATERIAL_SELECT"
		uiManager.id = self.data.id
		SoraDSendMessage(uiManager)
	end
end
return Btn_material
