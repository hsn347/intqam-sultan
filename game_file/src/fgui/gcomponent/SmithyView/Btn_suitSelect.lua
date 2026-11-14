local equipmentMgr = include("equipmentMgr")
local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_suitSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_suitSelect", Btn_suitSelect)
function Btn_suitSelect:onInit()
	self.fields.select:setVisible(false)
	self.fields.own:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_suitSelect:onShow()
end
function Btn_suitSelect:initData(data, index, showIndex)
	self.data = data
	self.index = index
	self.fields.icon_base:setSpriteFrame(equipDesRead.color[self.data.quality])
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(self.data.equipmentID))
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local isOwn = false
	for k, v in ipairs(tabelBaseList) do
		if v:getEID() == self.data.equipmentID and v:getEquipmentQuality() == self.data.quality then
			isOwn = true
			break
		end
	end
	self.fields.own:setVisible(isOwn)
	self.fields.select:setVisible(index == showIndex)
end
function Btn_suitSelect:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_EQUIP_SUIT_CELL_SELECT_ONLY"
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
return Btn_suitSelect
