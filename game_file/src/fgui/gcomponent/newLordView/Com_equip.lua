local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_equip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_equip", Com_equip)
function Com_equip:onInit()
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self:fixChildrenPos()
end
function Com_equip:onShow()
end
function Com_equip:initData(data)
	self.fields.icon_base:setSpriteFrame(equipDesRead.getBg(data:getEquipmentQuality()))
	self.fields.icon:setSpriteFrame(equipDesRead.getIcon(data:getEID()))
	local showSLV = data:getEquipmentSLV()
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(data:getEID())
	local equipLv = data:getEquipmentLV()
	if isSuitEquip then
		equipLv = equipLv % 100
	end
	local maxSLV = equipmentltCtrl.getStrengthenMaxLv(data:getEquipmentLV(), data:getEquipmentType())
	local topNum = showSLV >= maxSLV and "MAX" or "+" .. showSLV
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
	local eType = data:getEquipmentType()
	self.fields.Effect_coolSquare:setVisible(gEquipTypeDef.EQUIP_LEGEND == eType or gEquipTypeDef.EQUIP_NEBULA == eType)
end
function Com_equip:setSelectStatus(ret)
	self.controllers.c2:setSelectedIndex(ret and 1 or 0)
end
return Com_equip
