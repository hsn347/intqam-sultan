local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_equipTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_equipTop", Com_equipTop)
fgui.register_extension("ui://SmithyView/Com_equipTopSp", Com_equipTop)
function Com_equipTop:onInit()
end
function Com_equipTop:onShow()
end
function Com_equipTop:initData(equip, isRefine)
	local equipLv = equip:getEquipmentLV()
	local toEquip
	if isRefine then
		toEquip = equipDesRead.getKingEquipConfig(equip:getEID())
		if toEquip then
			equipLv = toEquip.level
			equipDesRead = equip:getEID()
			equip:getEID().lv = equipLv
			equip:getEID().name = equipDesRead.getName(toEquip.equipmentID)
			self.fields.title:setString(i18n("common_text_134", equip:getEID()))
		else
			equipDesRead = i18n("common_text_134", equip:getEID())
			i18n("common_text_134", equip:getEID()).lv = equipLv
			i18n("common_text_134", equip:getEID()).name = equipDesRead.getName(equip:getEID())
			self.fields.title:setString(i18n("common_text_134", i18n("common_text_134", equip:getEID())))
		end
	else
		equipDesRead = i18n("common_text_134", i18n("common_text_134", equip:getEID()))
		i18n("common_text_134", i18n("common_text_134", equip:getEID())).lv = equipLv
		i18n("common_text_134", i18n("common_text_134", equip:getEID())).name = equipDesRead.getName(equip:getEID())
		self.fields.title:setString(i18n("common_text_134", i18n("common_text_134", i18n("common_text_134", equip:getEID()))))
	end
	self.fields.title:setColor(equipDesRead.getAttrColor(equip:getEquipmentQuality()))
	self.fields.Com_equip:initData(equip, nil, nil, toEquip)
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(equip:getEID()))
end
function Com_equipTop:initDataEX(equip)
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(equip.equipmentID))
	local lvStr = ""
	if gEquipTypeDef.EQUIP_LEGEND ~= equip.equipType then
		equipDesRead = equipDesRead.getIcon(equip.equipmentID)
		equipDesRead.getIcon(equip.equipmentID).lv = equip.level
		lvStr = i18n("common_text_100", equipDesRead.getIcon(equip.equipmentID))
	end
	self.fields.title:setString(lvStr .. " " .. equipDesRead.getName(equip.equipmentID))
end
return Com_equipTop
