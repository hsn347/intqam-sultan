local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_preAttr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/list_preAttr", list_preAttr)
function list_preAttr:onInit()
	self:fixChildrenPos()
end
function list_preAttr:onShow()
end
function list_preAttr:initData(data, equipCell)
	local pid = data[1]
	local val = data[2]
	local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(equipCell:getEID())
	local equipLv = equipCell:getEquipmentLV()
	if isSuitEquip then
		equipLv = equipLv % 100
	end
	local name, value = equipDesRead.getAttrName(pid, val, true)
	local _, maxValue, dataType = equipmentltCtrl.getEquipmentExtraPropertyRange(equipLv, pid, equipCell:getEquipmentType())
	self.fields.Text_name:setString(name)
	local quality = equipmentltCtrl.getEquipmentExtraPropertyQuality(equipLv, pid, val, equipCell:getEquipmentType())
	local color = equipDesRead.getAttrColor(quality)
	if dataType == 2 then
		equipmentltCtrl = equipCell:getEquipmentType()
		equipCell:getEquipmentType().var1 = fguiHelper.getColorString(SoraDRGB2HtmlColor(color), value)
		equipCell:getEquipmentType().var2 = "(MAX " .. maxValue .. ")"
		self.fields.Text_val:setString(i18n("%{var1}%{var2}", equipCell:getEquipmentType()))
	else
		equipmentltCtrl = i18n("%{var1}%{var2}", equipCell:getEquipmentType())
		i18n("%{var1}%{var2}", equipCell:getEquipmentType()).var1 = fguiHelper.getColorString(SoraDRGB2HtmlColor(color), value)
		i18n("%{var1}%{var2}", equipCell:getEquipmentType()).var2 = "(MAX " .. maxValue / 10 .. "%)"
		self.fields.Text_val:setString(i18n("%{var1}%{var2}", i18n("%{var1}%{var2}", equipCell:getEquipmentType())))
	end
	self.fields.Text_name:setColor(color)
end
return list_preAttr
