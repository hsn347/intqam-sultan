local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_menuEquip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_menuEquip", Btn_menuEquip)
function Btn_menuEquip:onInit()
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.wear:setVisible(false)
	self:fixChildrenPos()
end
function Btn_menuEquip:onShow()
end
function Btn_menuEquip:initDataEX(data, isOrange)
	self.fields.icon_base:setVisible(false)
	if isOrange then
		self.fields.icon_base:setVisible(true)
		self.fields.icon_base:setSpriteFrame(equipDesRead.color[gQualityDef.ORANGE])
	end
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(data.equipmentID))
	equipDesRead = equipDesRead.getIcon(data.equipmentID)
	equipDesRead.getIcon(data.equipmentID).lv = data.level
	self.fields.Text_lv:setString(i18n("common_text_100", equipDesRead.getIcon(data.equipmentID)))
end
function Btn_menuEquip:initData(data)
	self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(data:getEquipmentQuality()))
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(data:getEID()))
	local showSLV = data:getEquipmentSLV()
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(data:getEID())
	local equipLv = data:getEquipmentLV()
	if isSuitEquip then
		equipLv = equipLv % 100
	end
	local maxSLV = equipmentltCtrl.getStrengthenMaxLv(data:getEquipmentLV(), data:getEquipmentType())
	local topNum = showSLV < maxSLV and "+" .. showSLV or "MAX"
	equipDesRead = data:getEquipmentType()
	data:getEquipmentType().lv = equipLv
	local numStr = i18n("common_text_100", data:getEquipmentType())
	if data:getEquipmentPart() == gEquipmentPart.RING or data:getEquipmentPart() == gEquipmentPart.NECKLACE then
		numStr = ""
		topNum = ""
	end
	self.fields.Text_qlv:setString(topNum)
	self.fields.Text_lv:setString(numStr)
	local endTime = data:getEquipmentEndTimeProperty()
	if endTime and 0 < endTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(endTime - serviceFunctions.systemTime())
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.wear:setVisible(data:isWearing())
	local eType = data:getEquipmentType()
	self.fields.Effect_coolSquare:setVisible(gEquipTypeDef.EQUIP_LEGEND == eType or gEquipTypeDef.EQUIP_NEBULA == eType)
end
return Btn_menuEquip
