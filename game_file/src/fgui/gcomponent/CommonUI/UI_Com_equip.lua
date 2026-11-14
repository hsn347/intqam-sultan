local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentMgr = include("equipmentMgr")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_equip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_equip", UI_Com_equip)
function UI_Com_equip:onInit()
	self.fields.bg_qlv:fix()
	self.fields.bg_lv:fix()
	self.fields.Text_qlv:fixPos()
	self.fields.Text_lv:fixPos()
end
function UI_Com_equip:onShow()
end
function UI_Com_equip:initDataEX(equip)
	self.fields.base:setSpriteFrame(equipDesRead.getBg(equip.qly))
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(equip.eid))
	local equipType = equipmentltCtrl.getEquipmentType(equip.eid, equip.qly)
	local maxSLV = equipmentltCtrl.getStrengthenMaxLv(equip.lv, equipType)
	local showSLV = equip.slv
	local isShow = true
	local part = equipmentltCtrl.getEquipmentPart(equip.eid)
	if part == gEquipmentPart.RING or part == gEquipmentPart.NECKLACE then
		isShow = false
	else
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(equip.eid)
		local equipLv = equip.lv
		if isSuitEquip then
			equipLv = equipLv % 100
		end
		equipDesRead = equipDesRead.getIcon(equip.eid)
		equipDesRead.getIcon(equip.eid).lv = equipLv
		self.fields.Text_lv:setString(i18n("common_text_100", equipDesRead.getIcon(equip.eid)))
		self.fields.Text_qlv:setString(maxSLV <= showSLV and "MAX" or "+" .. showSLV)
	end
	self.fields.Text_lv:setVisible(isShow)
	self.fields.bg_lv:setVisible(isShow)
	self.fields.Text_qlv:setVisible(isShow)
	self.fields.bg_qlv:setVisible(isShow)
	if gEquipTypeDef.EQUIP_LEGEND == equipType or gEquipTypeDef.EQUIP_NEBULA == equipType then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
end
function UI_Com_equip:initData(equip)
	self.equip = equip
	self.fields.base:setSpriteFrame(equipDesRead.getBg(self.equip:getEquipmentQuality()))
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(self.equip:getEID()))
	local maxSLV = equipmentltCtrl.getStrengthenMaxLv(self.equip:getEquipmentLV(), self.equip:getEquipmentType())
	local showSLV = self.equip:getEquipmentSLV()
	local isShow = true
	if self.equip:getEquipmentPart() == gEquipmentPart.RING or self.equip:getEquipmentPart() == gEquipmentPart.NECKLACE then
		isShow = false
	else
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(self.equip:getEID())
		local equipLv = self.equip:getEquipmentLV()
		if isSuitEquip then
			equipLv = equipLv % 100
		end
		equipDesRead = self.equip:getEID()
		self.equip:getEID().lv = equipLv
		self.fields.Text_lv:setString(i18n("common_text_100", self.equip:getEID()))
		self.fields.Text_qlv:setString(maxSLV <= showSLV and "MAX" or "+" .. showSLV)
	end
	self.fields.Text_lv:setVisible(isShow)
	self.fields.bg_lv:setVisible(isShow)
	self.fields.Text_qlv:setVisible(isShow)
	self.fields.bg_qlv:setVisible(isShow)
	local leftTime = (self.equip:getEquipmentEndTimeProperty() or 0) - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_time:beginTime(leftTime)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	local equipType = self.equip:getEquipmentType()
	if gEquipTypeDef.EQUIP_LEGEND == equipType or gEquipTypeDef.EQUIP_NEBULA == equipType then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
end
return UI_Com_equip
