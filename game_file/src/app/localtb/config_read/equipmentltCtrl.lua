local equipmentltCtrl = include("aAReadClass").new()
local _ENV, _ENV, equipmentPart = nil, "aAReadClass", "aAReadClass"
;(nil)[gQualityDef.LEGEND] = 5
;(nil)[gQualityDef.NEBULA] = 5
;(nil)[gQualityDef.GOLD] = 5
;(nil)[gQualityDef.ORANGE] = 4
;(nil)[gQualityDef.PURPLE] = 3
;(nil)[gQualityDef.BLUE] = 2
;(nil)[gQualityDef.GREEN] = 1
local _UPVALUE4_, (nil)[gQualityDef.WHITE], extraPropertyNumConfig = gQualityDef.WHITE, 0, nil
gQualityDef.WHITE[1] = gQualityDef.PURPLE
gQualityDef.WHITE[2] = gQualityDef.BLUE
gQualityDef.WHITE[3] = gQualityDef.GREEN
local gQualityDef.WHITE[4], qualityIndex = gQualityDef.WHITE, gQualityDef.WHITE
local HIGHEST_QUALITY = gQualityDef.PURPLE
local MAX_EQUIPMENT_LEVEL = 110
local STRENGTHEN_MAX_LEVEL = 30
local isInited = false
local init = function()
	if isInited then
		return
	end
	for k, v in pairs(gEquipmentPart) do
		equipmentPart[v] = true
	end
	equipmentPart = nil
	;(nil)[1] = "equipment_base_property_config"
	;(nil)[2] = true
	equipmentltCtrl:defineValue("equipmentCfg", nil)
	local createData = function(name)
		equipmentltCtrl.equipmentCfgEidTokey, equipmentltCtrl = nil, nil
		local equipmentltCtrl, config
		for i = 1, #equipmentltCtrl.equipmentCfg do
			if not config[i] then
				config[i], equipmentltCtrl = config[i], config[i]
			end
			config[i] = equipmentltCtrl.equipmentCfg[i]
		end
		for i, v in pairs(equipmentltCtrl.equipmentCfg) do
			local eid = v.equipmentID
			equipmentltCtrl.equipmentCfgEidTokey[eid] = i
		end
		local equipmentltCtrl, ret = (for generator), pairs(equipmentltCtrl.equipmentCfg)
		local equipmentltCtrl, temp = pairs(equipmentltCtrl.equipmentCfg)
		local equipmentltCtrl, orangeTemp = pairs(equipmentltCtrl.equipmentCfg)
		for i, v in ipairs(config) do
			local elv = v.level
			if elv <= MAX_EQUIPMENT_LEVEL then
				local eid = v.equipmentID
				local quality = v.quality
				if not ret[eid] then
					equipmentltCtrl = ret[eid]
				end
				ret[eid] = ret[eid]
				ret[eid][quality] = v
				v.extraNum = equipmentltCtrl.getExtraPropertyNum(quality)
				local part = v.eType
				v.propertyValue = v.propertyValue
				if v.suitequipID == 0 then
					if quality == HIGHEST_QUALITY then
						if not temp[part] then
							equipmentltCtrl = temp[part]
						end
						temp[part] = temp[part]
						table.insert(temp[part], v)
					elseif quality == gQualityDef.ORANGE then
						if not orangeTemp[part] then
							equipmentltCtrl = orangeTemp[part]
						end
						orangeTemp[part] = orangeTemp[part]
						table.insert(orangeTemp[part], v)
					end
				end
			end
		end
		equipmentltCtrl.equipment_list, equipmentltCtrl, equipmentltCtrl.equipmentBasePropertyConfig = ipairs(config)
		for _, part in pairs(gEquipmentPart) do
			if not temp[part] then
				local equipmentltCtrl, array = temp[part], temp[part]
			end
			print("temp", part)
			table.sort(array, function(l, r)
				if l.level == r.level then
					return l.equipmentID < r.equipmentID
				else
					return l.level < r.level
				end
			end)
			equipmentltCtrl.equipment_list[part] = array
		end
		equipmentltCtrl.equipment_orange_list, equipmentltCtrl = pairs(gEquipmentPart)
		for _, part in pairs(gEquipmentPart) do
			if not orangeTemp[part] then
				local equipmentltCtrl, array = orangeTemp[part], orangeTemp[part]
			end
			print("orangeTemp", part)
			table.sort(array, function(l, r)
				if l.level == r.level then
					return l.equipmentID < r.equipmentID
				else
					return l.level < r.level
				end
			end)
			equipmentltCtrl.equipment_orange_list[part] = array
		end
		if name == "equipmentCfgEidTokey" then
			return equipmentltCtrl.equipmentCfgEidTokey
		elseif name == "equipmentBasePropertyConfig" then
			return equipmentltCtrl.equipmentBasePropertyConfig
		elseif name == "equipment_list" then
			return equipmentltCtrl.equipment_list
		elseif name == "equipment_orange_list" then
			return equipmentltCtrl.equipment_orange_list
		end
	end
	equipmentltCtrl:defineValue("equipmentCfgEidTokey", createData)
	equipmentltCtrl:defineValue("equipmentBasePropertyConfig", createData)
	equipmentltCtrl:defineValue("equipment_list", createData)
	equipmentltCtrl:defineValue("equipment_orange_list", createData)
	equipmentltCtrl:defineValue("forgeMaterialConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_material_group")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_material_group", "app." .. LocalTblPath .. ".config_server.equipment_material_group"
		for i, v in ipairs(config) do
			local materialType = v.materialType
			ret[materialType] = v.materialItemID
		end
		equipmentltCtrl.forgeMaterialConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("forgeEquipmentConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.forge_equipment_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.forge_equipment_config", "app." .. LocalTblPath .. ".config_server.forge_equipment_config"
		for i, v in ipairs(config) do
			local elv = v.level
			if elv <= MAX_EQUIPMENT_LEVEL then
				local eid = v.equipmentID
				ret[eid] = v
				local _ENV, t
				for i, materialType in ipairs(v.material) do
					t[i] = equipmentltCtrl.forgeMaterialConfig[materialType]
				end
				v.material = t
			end
		end
		equipmentltCtrl.forgeEquipmentConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("remakeEquipmentConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.remake_equipment_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.remake_equipment_config", "app." .. LocalTblPath .. ".config_server.remake_equipment_config"
		for i, v in ipairs(config) do
			local quality = v.quality
			ret[quality] = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "num"
			v.material = serviceFunctions.tableFormat(v.material, nil)
		end
		equipmentltCtrl.remakeEquipmentConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("strengthenEquipmentConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.strengthen_equipment_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.strengthen_equipment_config", "app." .. LocalTblPath .. ".config_server.strengthen_equipment_config"
		for i, v in ipairs(config) do
			local elv = v.equipmentLv
			if elv <= MAX_EQUIPMENT_LEVEL then
				local equipType = v.equipType
				local slv = v.strengthenLv
				if not ret[equipType] then
					_ENV = ret[equipType]
				end
				ret[equipType] = ret[equipType]
				if not ret[equipType][elv] then
					_ENV = ret[equipType][elv]
				end
				ret[equipType][elv] = ret[equipType][elv]
				ret[equipType][elv][slv] = v
			end
		end
		equipmentltCtrl.strengthenEquipmentConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("maxStrengthLv", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.strengthen_equipment_config")
		local _ENV, maxStrengthLv = "app." .. LocalTblPath .. ".config_server.strengthen_equipment_config", "app." .. LocalTblPath .. ".config_server.strengthen_equipment_config"
		for i, v in ipairs(config) do
			local elv = v.equipmentLv
			if elv <= MAX_EQUIPMENT_LEVEL then
				local equipType = v.equipType
				local slv = v.strengthenLv
				if not maxStrengthLv[equipType] then
					maxStrengthLv[equipType], _ENV = maxStrengthLv[equipType], maxStrengthLv[equipType]
				end
				maxStrengthLv[equipType][elv] = math.max(slv, maxStrengthLv[equipType][elv] or 1)
			end
		end
		equipmentltCtrl.maxStrengthLv = maxStrengthLv
		return maxStrengthLv
	end)
	local createData2 = function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_material_formula")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_material_formula", "app." .. LocalTblPath .. ".config_server.equipment_material_formula"
		local _ENV, temp = LocalTblPath, LocalTblPath
		for i, v in ipairs(config) do
			local resultID = v.resultMaterial[1]
			local materialID = v.spendMaterial[1]
			local materialNum = v.spendMaterial[2]
			temp[materialID] = resultID
			local resultNum = v.resultMaterial[2]
			v.resultNum = resultNum
			ret[resultID] = v
		end
		equipmentltCtrl.mergeMaterialConfig = ret
		equipmentltCtrl.materialMegreConfig = temp
		if name == "mergeMaterialConfig" then
			return ret
		elseif name == "materialMegreConfig" then
			return temp
		end
	end
	equipmentltCtrl:defineValue("mergeMaterialConfig", createData2)
	equipmentltCtrl:defineValue("materialMegreConfig", createData2)
	equipmentltCtrl:defineValue("equipmentExtraPropertyConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_extra_property_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config", "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config"
		for i, v in ipairs(config) do
			local elv = v.level
			local propertyType = v.propertyType
			local equipType = v.equipType
			if not ret[equipType] then
				_ENV = ret[equipType]
			end
			ret[equipType] = ret[equipType]
			if not ret[equipType][elv] then
				_ENV = ret[equipType][elv]
			end
			ret[equipType][elv] = ret[equipType][elv]
			ret[equipType][elv][propertyType] = v
		end
		equipmentltCtrl.equipmentExtraPropertyConfig = ret
		return ret
	end)
	function equipmentPart()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_extra_property_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config", "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config"
		for i, v in ipairs(config) do
			local elv = v.level
			local propertyType = v.propertyType
			local equipType = v.equipType
			if not ret[equipType] then
				_ENV = ret[equipType]
			end
			ret[equipType] = ret[equipType]
			if not ret[equipType][elv] then
				_ENV = ret[equipType][elv]
			end
			ret[equipType][elv] = ret[equipType][elv]
			ret[equipType][elv][propertyType] = v
		end
		equipmentltCtrl.equipmentExtraPropertyConfig = ret
		return ret
	end
	;(function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_extra_property_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config", "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config"
		for i, v in ipairs(config) do
			local elv = v.level
			local propertyType = v.propertyType
			local equipType = v.equipType
			if not ret[equipType] then
				_ENV = ret[equipType]
			end
			ret[equipType] = ret[equipType]
			if not ret[equipType][elv] then
				_ENV = ret[equipType][elv]
			end
			ret[equipType][elv] = ret[equipType][elv]
			ret[equipType][elv][propertyType] = v
		end
		equipmentltCtrl.equipmentExtraPropertyConfig = ret
		return ret
	end)[1] = "remake_equipment_rate_config"
	;(function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_extra_property_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config", "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config"
		for i, v in ipairs(config) do
			local elv = v.level
			local propertyType = v.propertyType
			local equipType = v.equipType
			if not ret[equipType] then
				_ENV = ret[equipType]
			end
			ret[equipType] = ret[equipType]
			if not ret[equipType][elv] then
				_ENV = ret[equipType][elv]
			end
			ret[equipType][elv] = ret[equipType][elv]
			ret[equipType][elv][propertyType] = v
		end
		equipmentltCtrl.equipmentExtraPropertyConfig = ret
		return ret
	end)[2] = true
	equipmentltCtrl:defineValue("remakeEquipmentRateConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_extra_property_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config", "app." .. LocalTblPath .. ".config_server.equipment_extra_property_config"
		for i, v in ipairs(config) do
			local elv = v.level
			local propertyType = v.propertyType
			local equipType = v.equipType
			if not ret[equipType] then
				_ENV = ret[equipType]
			end
			ret[equipType] = ret[equipType]
			if not ret[equipType][elv] then
				_ENV = ret[equipType][elv]
			end
			ret[equipType][elv] = ret[equipType][elv]
			ret[equipType][elv][propertyType] = v
		end
		equipmentltCtrl.equipmentExtraPropertyConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("disassmbleEquipmentConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.disassemble_equipment_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.disassemble_equipment_config", "app." .. LocalTblPath .. ".config_server.disassemble_equipment_config"
		for i, v in ipairs(config) do
			local elv = v.equipmentLv
			ret[elv] = v
		end
		equipmentltCtrl.disassmbleEquipmentConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("equipmentPowerConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_power_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_power_config", "app." .. LocalTblPath .. ".config_server.equipment_power_config"
		for i, v in ipairs(config) do
			local propertyType = v.propertyType
			ret[propertyType] = v
		end
		equipmentltCtrl.equipmentPowerConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("equipmentSetConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_set_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_set_config", "app." .. LocalTblPath .. ".config_server.equipment_set_config"
		for i, v in ipairs(config) do
			v.order = i
			v.setID = tostring(v.setID)
			_ENV, _ENV, ret[v.setID] = v.setID, v.setID, v
			v.setID.condKey = v.condition[1]
			v.setID.condValue = v.condition[2]
			v.condition, v.setID[1], v.setID.targetValue = v.setID, v.setID, v.condition[3]
		end
		equipmentltCtrl.equipmentSetConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("propertyOrder", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_property_order")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.equipment_property_order", "app." .. LocalTblPath .. ".config_server.equipment_property_order"
		for i, v in ipairs(config) do
			ret[v.propertyType] = v
		end
		equipmentltCtrl.propertyOrder = ret
		return ret
	end)
	equipmentltCtrl:defineValue("forgeSuitConfig", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.suit_forge")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.suit_forge", "app." .. LocalTblPath .. ".config_server.suit_forge"
		for k, v in pairs(config) do
			ret[v.equipmentID] = v
		end
		equipmentltCtrl.forgeSuitConfig = ret
		return ret
	end)
	equipmentltCtrl:defineValue("suit_forge_material", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.suit_forge_material")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.suit_forge_material", "app." .. LocalTblPath .. ".config_server.suit_forge_material"
		for k, v in ipairs(config) do
			if not ret[v.equipmentID] then
				ret[v.equipmentID], _ENV = nil, nil
			end
			ret[v.equipmentID][v.quility] = v
		end
		equipmentltCtrl.suit_forge_material = ret
		return ret
	end)
	equipmentltCtrl:defineValue("suit_Result", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.suit_attribute")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.suit_attribute", "app." .. LocalTblPath .. ".config_server.suit_attribute"
		for i, v in ipairs(config) do
			ret[v.suitequipID] = v
		end
		equipmentltCtrl.suit_Result = ret
		return ret
	end)
	equipmentltCtrl:defineValue("suit_list", function()
		local _ENV, config
		local index = 1
		for k, v in pairs(equipmentltCtrl.equipmentCfg) do
			if v.suitequipID ~= 0 then
				if not config[index] then
					config[index], _ENV = config[index], config[index]
				end
				config[index] = equipmentltCtrl.equipmentCfg[k]
				index = index + 1
			end
		end
		local _ENV, ret = (for generator), pairs(equipmentltCtrl.equipmentCfg)
		local _ENV, temp = pairs(equipmentltCtrl.equipmentCfg)
		for i, v in ipairs(config) do
			local elv = v.level
			if elv <= MAX_EQUIPMENT_LEVEL then
				local eid = v.equipmentID
				local quality = v.quality
				if not ret[eid] then
					_ENV = ret[eid]
				end
				ret[eid] = ret[eid]
				ret[eid][quality] = v
				v.extraNum = equipmentltCtrl.getExtraPropertyNum(quality)
				local part = v.eType
				v.propertyValue = v.propertyValue
				if not temp[part] then
					_ENV = temp[part]
				end
				temp[part] = temp[part]
				table.insert(temp[part], v)
			end
		end
		equipmentltCtrl.suit_list, _ENV = ipairs(config)
		for _, part in pairs(gEquipmentPart) do
			if not temp[part] then
				local _ENV, array = temp[part], temp[part]
			end
			table.sort(array, function(l, r)
				if l.level == r.level then
					return l.equipmentID < r.equipmentID
				else
					return l.level < r.level
				end
			end)
			equipmentltCtrl.suit_list[part] = array
		end
		return equipmentltCtrl.suit_list
	end)
	local createData3 = function(name)
		equipmentltCtrl.ringshop_all_list, equipmentltCtrl, equipmentltCtrl.ringshop_list, equipmentltCtrl = nil, nil, nil, nil
		local config = require_once("app." .. LocalTblPath .. ".config_server.equipment_ringshop")
		for i, v in pairs(config) do
			print(i, v)
			if v.type == 1 then
				table.insert(equipmentltCtrl.ringshop_list, v)
			end
			table.insert(equipmentltCtrl.ringshop_all_list, v)
		end
		table.sort(equipmentltCtrl.ringshop_list, function(l, r)
			if l.index <= r.index then
				return true
			else
				return false
			end
		end)
		if name == "ringshop_list" then
			return equipmentltCtrl.ringshop_list
		elseif name == "ringshop_all_list" then
			return equipmentltCtrl.ringshop_all_list
		end
	end
	equipmentltCtrl:defineValue("ringshop_list", createData3)
	equipmentltCtrl:defineValue("ringshop_all_list", createData3)
	equipmentltCtrl:defineValue("orangeEquip_list", function()
		equipmentltCtrl.orangeEquip_list, equipmentltCtrl = nil, nil
		local config = require_once("app." .. LocalTblPath .. ".config_server.forge_equipment_orange")
		for k, v in pairs(config) do
			equipmentltCtrl.orangeEquip_list[v.equipmentID] = v
		end
		table.sort(equipmentltCtrl.orangeEquip_list, function(l, r)
			return l.index < r.index
		end)
		return equipmentltCtrl.orangeEquip_list
	end)
	equipmentltCtrl:defineValue("orangeEquip_dis_list", function()
		equipmentltCtrl.orangeEquip_dis_list, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.disassemble_equipment_orange")
		for k, v in pairs(cfg) do
			equipmentltCtrl.orangeEquip_dis_list[v.equipmentID] = v
		end
		table.sort(equipmentltCtrl.orangeEquip_dis_list, function(l, r)
			return l.index < r.index
		end)
		return equipmentltCtrl.orangeEquip_dis_list
	end)
	function _ENV()
		equipmentltCtrl.orangeEquip_dis_list, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.disassemble_equipment_orange")
		for k, v in pairs(cfg) do
			equipmentltCtrl.orangeEquip_dis_list[v.equipmentID] = v
		end
		table.sort(equipmentltCtrl.orangeEquip_dis_list, function(l, r)
			return l.index < r.index
		end)
		return equipmentltCtrl.orangeEquip_dis_list
	end
	;(function()
		equipmentltCtrl.orangeEquip_dis_list, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.disassemble_equipment_orange")
		for k, v in pairs(cfg) do
			equipmentltCtrl.orangeEquip_dis_list[v.equipmentID] = v
		end
		table.sort(equipmentltCtrl.orangeEquip_dis_list, function(l, r)
			return l.index < r.index
		end)
		return equipmentltCtrl.orangeEquip_dis_list
	end)[1] = "suit_obtain"
	equipmentltCtrl:defineValue("materailOutputCfg", function()
		equipmentltCtrl.orangeEquip_dis_list, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.disassemble_equipment_orange")
		for k, v in pairs(cfg) do
			equipmentltCtrl.orangeEquip_dis_list[v.equipmentID] = v
		end
		table.sort(equipmentltCtrl.orangeEquip_dis_list, function(l, r)
			return l.index < r.index
		end)
		return equipmentltCtrl.orangeEquip_dis_list
	end)
	equipmentltCtrl:defineValue("recoin_expend", function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)
	function equipmentPart()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end
	;(function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)[1] = "strengthenresonance"
	;(function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)[2] = true
	equipmentltCtrl:defineValue("strengthenresonance", function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)
	function equipmentPart()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end
	;(function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)[1] = "slim_sort_config"
	;(function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)[2] = true
	equipmentltCtrl:defineValue("slim_sort_config", function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)
	function equipmentPart()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end
	;(function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)[1] = "slim_range_config"
	;(function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)[2] = true
	equipmentltCtrl:defineValue("slim_range_config", function()
		equipmentltCtrl.recoin_expend, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.equipment_recoin_expend")
		for k, v in ipairs(cfg) do
			if not equipmentltCtrl.recoin_expend[v.level] then
				equipmentltCtrl.recoin_expend[v.level], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality] then
				equipmentltCtrl.recoin_expend[v.level][v.quality], equipmentltCtrl = nil, nil
			end
			if not equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType] then
				equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType], equipmentltCtrl = nil, nil
			end
			equipmentltCtrl.recoin_expend[v.level][v.quality][v.equipType][v.strengthenLv] = v
		end
		return equipmentltCtrl.recoin_expend
	end)
	equipmentltCtrl:defineValue("legend_equip_return", function()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end)
	function _ENV()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end
	;(function()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end)[1] = "legend_equip_return_show"
	equipmentltCtrl:defineValue("legend_equip_return_show", function()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end)
	function equipmentPart()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end
	;(function()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end)[1] = "nebulaequip_limit_return"
	;(function()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end)[2] = true
	equipmentltCtrl:defineValue("nebulaequip_limit_return", function()
		equipmentltCtrl.legend_equip_return, equipmentltCtrl = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.legend_equip_return")
		for k, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			equipmentltCtrl.legend_equip_return[tostring(v.equipid)] = serviceFunctions.tableFormat(v.returnItem, nil)
		end
		return equipmentltCtrl.legend_equip_return
	end)
end
function equipmentltCtrl.getEquipmentList(part)
	if equipmentltCtrl.isEquipmentPart(part) then
		return equipmentltCtrl.equipment_list[part]
	end
end
function equipmentltCtrl.getOrangeEquipmentList(part)
	if equipmentltCtrl.isEquipmentPart(part) then
		return equipmentltCtrl.equipment_orange_list[part]
	end
end
function equipmentltCtrl.filterEquipData(equipData)
	local _ENV, newEquipData
	for i, v in ipairs(equipData) do
		local equipLv = v.level
		if 95 < equipLv then
			local lordLocalData = include("lordLocalData")
			local maxLordLv = lordLocalData.getMaxLordLv()
			if equipLv <= maxLordLv then
				table.insert(newEquipData, v)
			end
		else
			table.insert(newEquipData, v)
		end
	end
	return newEquipData
end
function equipmentltCtrl.getEquipment(eid, showSuit)
	if equipmentltCtrl.forgeEquipmentConfig[eid] then
		return equipmentltCtrl.forgeEquipmentConfig[eid]
	end
	if showSuit and equipmentltCtrl.forgeSuitConfig[eid] then
		return equipmentltCtrl.forgeSuitConfig[eid]
	end
end
function equipmentltCtrl.isEquipmentID(eid)
	if "number" == type(eid) and equipmentltCtrl.equipmentBasePropertyConfig[eid] then
		return true
	else
		return false
	end
end
function equipmentltCtrl.isEquipmentPID(epid)
	if "number" == type(epid) and 0 < epid then
		return true
	else
		return false
	end
end
function equipmentltCtrl.isEquipmentPart(part)
	if part and equipmentPart[part] then
		return true
	else
		return false
	end
end
function equipmentltCtrl.getStrengthenMaxLv(equipLv, equipType)
	if equipLv and equipType then
		return equipmentltCtrl.maxStrengthLv[equipType][equipLv] or STRENGTHEN_MAX_LEVEL
	end
	return STRENGTHEN_MAX_LEVEL
end
function equipmentltCtrl.needMainEquipment(eid)
	if equipmentltCtrl.getMainMaterialLv(eid) then
		return true
	end
end
function equipmentltCtrl.getEquipmentType(eid, quality)
	return equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].equipType
end
function equipmentltCtrl.getEquipmentSuitID(eid, quality)
	return equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].suitequipID
end
function equipmentltCtrl.getEquipmentLv(eid)
	local cfg = equipmentltCtrl.getEquipCfg(eid)
	return cfg.level
end
function equipmentltCtrl.getSuitLv(eid)
	return math.fmod(math.floor(eid / 100), 100)
end
function equipmentltCtrl.getHighestQuality()
	return HIGHEST_QUALITY
end
function equipmentltCtrl.getForgeEquipmentTime(eid)
	return equipmentltCtrl.forgeEquipmentConfig[eid].time
end
function equipmentltCtrl.getForgeEquipmentLevel(eid)
	return equipmentltCtrl.forgeEquipmentConfig[eid].level
end
function equipmentltCtrl.getForgeOrangeEquipmentTime(eid)
	return equipmentltCtrl.orangeEquip_list[eid].time
end
function equipmentltCtrl.getForgeSuitTime(eid, quality)
	return equipmentltCtrl.forgeSuitConfig[eid].time[quality + 1]
end
function equipmentltCtrl.getEquipmentPart(eid)
	return math.fmod(math.floor(eid / 100000), 10)
end
function equipmentltCtrl.getMainMaterialLv(eid)
	if equipmentltCtrl.forgeEquipmentConfig[eid] then
		return equipmentltCtrl.forgeEquipmentConfig[eid].mainMaterial[1], equipmentltCtrl.forgeEquipmentConfig[eid].mainMaterial[2]
	end
end
function equipmentltCtrl.getOrangeMainMaterial(eid)
	local equipmentltCtrl, mainMaterial
	if equipmentltCtrl.orangeEquip_list[eid] then
		for i, v in ipairs(equipmentltCtrl.orangeEquip_list[eid].mainMaterial) do
			table.insert(mainMaterial, v)
		end
	end
	return mainMaterial
end
function equipmentltCtrl.getMaterialOfForging(eid)
	return equipmentltCtrl.forgeEquipmentConfig[eid].material
end
function equipmentltCtrl.getMaterialOfForgeOrange(eid)
	local _ENV, tempTable
	for i, v in ipairs(equipmentltCtrl.orangeEquip_list[eid].material) do
		table.insert(tempTable, v)
	end
	return tempTable
end
function equipmentltCtrl.getSuitMaterialOfForging(eid, quality)
	return equipmentltCtrl.suit_forge_material[eid][quality].material
end
function equipmentltCtrl.getSuitsResultInfoByID(sid)
	if equipmentltCtrl.suit_Result[sid] then
		return equipmentltCtrl.suit_Result[sid]
	end
end
function equipmentltCtrl.getExtraPropertyNum(quality)
	return extraPropertyNumConfig[quality]
end
function equipmentltCtrl.getEquipmentBasePropertyEx(eid, quality, slv)
	local propertyType, propertyValue, propertyType2, propertyValue2, propertyType3, propertyValue3, propertyType4, propertyValue4 = equipmentltCtrl.getEquipmentBaseProperty(eid, quality, slv)
	_UPVALUE8_ = nil
	;(nil)[1] = propertyType
	;(nil)[2] = propertyValue
	;(nil)[3] = propertyType2
	;(nil)[4] = propertyValue2
	;(nil)[5] = propertyType3
	;(nil)[6] = propertyValue3
	;(nil)[7] = propertyType4
	;(nil)[8] = propertyValue4
	return nil
end
function equipmentltCtrl.getEquipmentBaseProperty(eid, quality, slv)
	print("equipmentltCtrl eid quality slv：", eid, quality, slv)
	local factor = IsArClient and 1 or 10
	print("非套装系数因子为：", factor)
	local propertyType = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyType
	local propertyValue = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyValue
	local propertyType2 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyType2
	local propertyValue2 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyValue2
	local propertyType3 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyType3
	local propertyValue3 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyValue3
	local propertyType4 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyType4
	local propertyValue4 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].propertyValue4
	local addition = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].addition
	local addition2 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].addition2
	local addition3 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].addition3
	local addition4 = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].addition4
	_UPVALUE3_ = nil
	;(nil)[1] = "minLv"
	;(nil)[2] = "maxLv"
	;(nil)[3] = "value"
	addition = serviceFunctions.tableFormat(addition, nil)
	for _, v in ipairs(addition) do
		if slv >= v.minLv and slv <= v.maxLv then
			propertyValue = propertyValue + v.value * (slv - v.minLv + 1)
		elseif slv > v.maxLv then
			propertyValue = propertyValue + v.value * (v.maxLv - v.minLv + 1)
		end
	end
	_UPVALUE3_ = ipairs(addition)
	ipairs(addition)[1] = "minLv"
	ipairs(addition)[2] = "maxLv"
	ipairs(addition)[3] = "value"
	addition2 = serviceFunctions.tableFormat(addition2, ipairs(addition))
	for _, v in ipairs(addition2) do
		if slv >= v.minLv and slv <= v.maxLv then
			propertyValue2 = propertyValue2 + v.value * (slv - v.minLv + 1)
		elseif slv > v.maxLv then
			propertyValue2 = propertyValue2 + v.value * (v.maxLv - v.minLv + 1)
		end
	end
	_UPVALUE3_ = ipairs(addition2)
	ipairs(addition2)[1] = "minLv"
	ipairs(addition2)[2] = "maxLv"
	ipairs(addition2)[3] = "value"
	addition3 = serviceFunctions.tableFormat(addition3, ipairs(addition2))
	for _, v in ipairs(addition3) do
		if slv >= v.minLv and slv <= v.maxLv then
			propertyValue3 = propertyValue3 + v.value * (slv - v.minLv + 1)
		elseif slv > v.maxLv then
			propertyValue3 = propertyValue3 + v.value * (v.maxLv - v.minLv + 1)
		end
	end
	_UPVALUE3_ = ipairs(addition3)
	ipairs(addition3)[1] = "minLv"
	ipairs(addition3)[2] = "maxLv"
	ipairs(addition3)[3] = "value"
	addition4 = serviceFunctions.tableFormat(addition4, ipairs(addition3))
	for _, v in ipairs(addition4) do
		if slv >= v.minLv and slv <= v.maxLv then
			propertyValue4 = propertyValue4 + v.value * (slv - v.minLv + 1)
		elseif slv > v.maxLv then
			propertyValue4 = propertyValue4 + v.value * (v.maxLv - v.minLv + 1)
		end
	end
	propertyValue = propertyValue / factor
	propertyValue2 = propertyValue2 / factor
	propertyValue3 = propertyValue3 / factor
	propertyValue4 = propertyValue4 / factor
	return propertyType, propertyValue, propertyType2, propertyValue2, propertyType3, propertyValue3, propertyType4, propertyValue4
end
function equipmentltCtrl.getEquipmentSpecialProperty(eid, quality)
	local special = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].specialType
	local equipmentltCtrl, retTbl
	for i = 1, table.nums(special), 2 do
		equipmentltCtrl = nil
		;(nil).attrID = special[i]
		;(nil).attrValue = special[i + 1]
		table.insert(retTbl, nil)
	end
	return retTbl
end
function equipmentltCtrl.getEquipmentAllProperty(eid, quality, slv)
	print("equipmentltCtrl eid quality slv：", eid, quality, slv)
	local factor = IsArClient and 1 or 10
	print("非套装系数因子为：", factor)
	local keyTypeName = "propertyType"
	local keyValueName = "propertyValue"
	local keyAddName = "addition"
	local maxPropety = 3
	local _ENV, retTbl
	for i = 1, maxPropety do
		local keyExten = i
		if i == 1 then
			keyExten = ""
		end
		local propertyType = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality][keyTypeName .. keyExten]
		if propertyType and propertyType ~= 0 then
			local propertyValue = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality][keyValueName .. keyExten]
			local addition = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality][keyAddName .. keyExten]
			_UPVALUE3_ = nil
			;(nil)[1] = "minLv"
			;(nil)[2] = "maxLv"
			;(nil)[3] = "value"
			addition = serviceFunctions.tableFormat(addition, nil)
			for _, v in ipairs(addition) do
				if slv >= v.minLv and slv <= v.maxLv then
					propertyValue = propertyValue + v.value * (slv - v.minLv + 1)
				elseif slv > v.maxLv then
					propertyValue = propertyValue + v.value * (v.maxLv - v.minLv + 1)
				end
			end
			propertyValue = propertyValue / factor
			local dataType = equipmentltCtrl.equipmentBasePropertyConfig[eid][quality]["dataType" .. keyExten]
			_ENV = "minLv"
			;("minLv").propertyType = propertyType
			;("minLv").propertyValue = propertyValue
			;("minLv").dataType = dataType
			table.insert(retTbl, "minLv")
		end
	end
	return retTbl
end
function equipmentltCtrl.getEquipmentLimitTime(eid, quality)
	return equipmentltCtrl.equipmentBasePropertyConfig[eid][quality].limitTime
end
function equipmentltCtrl.getSteelNumOfForging(eid)
	return equipmentltCtrl.forgeEquipmentConfig[eid].needSteel
end
function equipmentltCtrl.getSteelNumOfForgeOrange(eid)
	return equipmentltCtrl.orangeEquip_list[eid].needSteel
end
function equipmentltCtrl.getSteelNumOfSuitForging(eid, quality)
	return equipmentltCtrl.forgeSuitConfig[eid].needSteel[quality + 1]
end
function equipmentltCtrl.getBluePrintInfo(eid)
	local equipmentltCtrl, bluePrint
	if equipmentltCtrl.orangeEquip_list[eid] then
		for i, v in ipairs(equipmentltCtrl.orangeEquip_list[eid].bluePrint) do
			table.insert(bluePrint, v)
		end
	end
	return bluePrint
end
function equipmentltCtrl.getStrengthenMaterialAndNum(elv, slv, equipType)
	local materialID = equipmentltCtrl.strengthenEquipmentConfig[equipType][elv][slv].materialId
	local num = equipmentltCtrl.strengthenEquipmentConfig[equipType][elv][slv].materialNum
	return materialID, num
end
function equipmentltCtrl.getStrengthenMaterialID(equipType)
	equipType = equipType or 1
	return equipmentltCtrl.getStrengthenMaterialAndNum(1, 1, equipType)
end
function equipmentltCtrl.getSteelNumOfStrengthen(elv, slv, equipType)
	return equipmentltCtrl.strengthenEquipmentConfig[equipType][elv][slv].needSteel
end
function equipmentltCtrl.getRemakeMaterialAndNum(quality)
	return equipmentltCtrl.remakeEquipmentConfig[quality].material
end
function equipmentltCtrl.getRemakeSteelNum(quality)
	return equipmentltCtrl.remakeEquipmentConfig[quality].needSteel
end
function equipmentltCtrl.getMaterialType(materialID)
	return tonumber(string.sub(materialID, 1, -2) .. 0)
end
function equipmentltCtrl.getMaterialList(materialType)
	return equipmentltCtrl.forgeMaterialConfig[materialType]
end
function equipmentltCtrl.getMaterialActoinType(materialID)
	local toID = equipmentltCtrl.getMaterialIDAfterMerge(materialID)
	local srcID = equipmentltCtrl.getMaterialIDOfMerge(materialID)
	local isEquipSetMaterial = equipmentltCtrl.isMaterialCanDecompose(materialID)
	if isEquipSetMaterial then
		if toID and srcID then
			return gMaterialActionType.ALL_ACTION
		elseif srcID then
			return gMaterialActionType.DECOMPOSITION
		elseif toID then
			return gMaterialActionType.COMPONE
		end
	elseif toID then
		return gMaterialActionType.COMPONE
	end
	return gMaterialActionType.NONE_ACTION
end
function equipmentltCtrl.isMaterialCanDecompose(materialID)
	if materialID and equipmentltCtrl.mergeMaterialConfig[materialID] then
		return equipmentltCtrl.mergeMaterialConfig[materialID].decompose == 1
	end
end
function equipmentltCtrl.getForgeQuality(mainMaterialQuality, materialArray)
	if not materialArray or #materialArray == 0 then
		return
	end
	local totalRate = 100
	local _ENV, qualityRate
	local materialNum = #materialArray
	local minQuality
	if mainMaterialQuality then
		minQuality = mainMaterialQuality
		qualityRate[mainMaterialQuality] = totalRate / 2
		totalRate = totalRate - qualityRate[mainMaterialQuality]
	end
	local rateInv = totalRate / materialNum
	for i, materialID in ipairs(materialArray) do
		local quality = gModuleMgr.sharedMgr("backpackltCtrl"):getItemQuality(materialID)
		qualityRate[quality] = qualityRate[quality] or 0
		qualityRate[quality] = qualityRate[quality] + rateInv
		if not minQuality or minQuality > quality then
			minQuality = quality
		end
	end
	for i, q in ipairs(qualityIndex) do
		if q >= minQuality then
			if 1 == i then
				qualityRate[q] = qualityRate[q] or 0
			elseif 2 <= i then
				local curRate = qualityRate[q]
				if not curRate then
					local preQuality = qualityIndex[i - 1]
					curRate = qualityRate[preQuality] * 0.2
					qualityRate[q] = curRate
					qualityRate[preQuality] = qualityRate[preQuality] - curRate
				end
			end
		else
			qualityRate[q] = 0
		end
	end
	for k, v in pairs(qualityRate) do
		qualityRate[k] = SoraDRounding(v)
	end
	return qualityRate
end
function equipmentltCtrl.getEquipmentExtraPropertyRange(elv, propertyType, equipType)
	equipType = equipType or 0
	local minValue = equipmentltCtrl.equipmentExtraPropertyConfig[equipType][elv][propertyType].minValue
	local maxValue = equipmentltCtrl.equipmentExtraPropertyConfig[equipType][elv][propertyType].maxValue
	local dataType = equipmentltCtrl.equipmentExtraPropertyConfig[equipType][elv][propertyType].dataType
	return minValue, maxValue, dataType
end
function equipmentltCtrl.getEquipmentExtraPropertyQuality(elv, propertyType, propertyValue, equipType)
	local equipType = equipType or 0
	local minValue, maxValue = equipmentltCtrl.getEquipmentExtraPropertyRange(elv, propertyType, equipType)
	local rate = (propertyValue - minValue) * 1000 / (maxValue - minValue)
	if rate < 1 then
		return gQualityDef.WHITE
	end
	local num = #equipmentltCtrl.remakeEquipmentRateConfig
	for i = 1, num do
		local minRate = equipmentltCtrl.remakeEquipmentRateConfig[i].rangeMin
		local maxRate = equipmentltCtrl.remakeEquipmentRateConfig[i].rangeMax
		if rate <= maxRate then
			return equipmentltCtrl.remakeEquipmentRateConfig[i].quality
		end
	end
end
function equipmentltCtrl.getAllRemakeMaterial()
	if not equipmentltCtrl.remakeMaterial then
		local equipmentltCtrl, temp = equipmentltCtrl.remakeMaterial, equipmentltCtrl.remakeMaterial
		for quality, v in pairs(equipmentltCtrl.remakeEquipmentConfig) do
			for i, materialData in ipairs(v.material) do
				temp[materialData.id] = 1
			end
		end
		equipmentltCtrl.remakeMaterial, equipmentltCtrl = pairs(equipmentltCtrl.remakeEquipmentConfig)
		for id, _ in pairs(temp) do
			table.insert(equipmentltCtrl.remakeMaterial, id)
		end
		table.sort(equipmentltCtrl.remakeMaterial)
	end
	return equipmentltCtrl.remakeMaterial
end
function equipmentltCtrl.getMaterialIDAfterMerge(materialID)
	if materialID then
		return equipmentltCtrl.materialMegreConfig[materialID]
	end
end
function equipmentltCtrl.getMaterialIDOfMerge(materialID)
	if materialID and equipmentltCtrl.mergeMaterialConfig[materialID] then
		return equipmentltCtrl.mergeMaterialConfig[materialID].spendMaterial[1]
	end
end
function equipmentltCtrl.canMerge(materialID)
	if materialID and equipmentltCtrl.materialMegreConfig[materialID] then
		return true
	end
end
function equipmentltCtrl.canDisassemble(materialID)
	if equipmentltCtrl.getMaterialIDOfMerge(meterialID) then
		return true
	end
	return false
end
function equipmentltCtrl.getMaxMaterialNumOfDisassmble(elv)
	return equipmentltCtrl.disassmbleEquipmentConfig[elv].maxNum
end
function equipmentltCtrl.getMaterialNumRateOfDisassmble(elv)
	local minRate = equipmentltCtrl.disassmbleEquipmentConfig[elv].minRate
	local maxRate = equipmentltCtrl.disassmbleEquipmentConfig[elv].maxRate
	return minRate, maxRate
end
function equipmentltCtrl.getMaterialNumRangeOfDisassmble(elv)
	local maxNum = equipmentltCtrl.getMaxMaterialNumOfDisassmble(elv)
	local minRate, maxRate = equipmentltCtrl.getMaterialNumRateOfDisassmble(elv)
	return math.ceil(maxNum * minRate / 1000), math.ceil(maxNum * maxRate / 1000)
end
function equipmentltCtrl.getEquipmentPower(basePropertyType, basePropertyValue, extraProperty)
	local power = 0
	if basePropertyType and basePropertyValue then
		local rateCoefficient = equipmentltCtrl.equipmentPowerConfig[basePropertyType].rate
		local powerCoefficient = equipmentltCtrl.equipmentPowerConfig[basePropertyType].power
		power = power + basePropertyValue / rateCoefficient * powerCoefficient
	end
	if extraProperty then
		for i, v in ipairs(extraProperty) do
			local propertyType, propertyValue = v[1], v[2]
			local rateCoefficient = equipmentltCtrl.equipmentPowerConfig[propertyType].rate
			local powerCoefficient = equipmentltCtrl.equipmentPowerConfig[propertyType].power
			power = power + propertyValue / rateCoefficient * powerCoefficient
		end
	end
	return math.floor(power)
end
function equipmentltCtrl.getEquipCfg(eid)
	local index = equipmentltCtrl.equipmentCfgEidTokey[eid]
	if equipmentltCtrl.equipmentCfg[index] then
		return equipmentltCtrl.equipmentCfg[index]
	end
end
function equipmentltCtrl.getSuitPartList(ePart, eid)
	local equipmentltCtrl, ret
	if equipmentltCtrl.suit_list[ePart] then
		for i, v in ipairs(equipmentltCtrl.suit_list[ePart]) do
			if eid == v.equipmentID then
				table.insert(ret, v)
			end
		end
	end
	table.sort(ret, function(l, r)
		return l.quality < r.quality
	end)
	return ret
end
function equipmentltCtrl.setIDValid(setID)
	if equipmentltCtrl.equipmentSetConfig[setID] then
		return true
	end
	return false
end
function equipmentltCtrl.getEquipmentSetList()
	local _ENV, ret
	for setID, _ in pairs(equipmentltCtrl.equipmentSetConfig) do
		table.insert(ret, setID)
	end
	return ret
end
function equipmentltCtrl.getEquipmentSetCondition(setID)
	return equipmentltCtrl.equipmentSetConfig[setID].condition
end
function equipmentltCtrl.getOrder(setID)
	return equipmentltCtrl.equipmentSetConfig[setID].order
end
function equipmentltCtrl.getDefaultSetID()
	return "1"
end
function equipmentltCtrl.getPropertyOrder(property)
	local data = property and equipmentltCtrl.propertyOrder[property]
	local propertyType = data and data.btype
	return propertyType
end
function equipmentltCtrl.getNextLvEquipInfo(eid)
	local partType = equipmentltCtrl.getEquipmentPart(eid)
	if partType == gEquipmentPart.RING or partType == gEquipmentPart.NECKLACE then
		return nil
	end
	local equipmentltCtrl, equipData
	for i, v in ipairs(equipmentltCtrl.getEquipmentList(partType)) do
		table.insert(equipData, v)
	end
	for i, v in ipairs(equipData) do
		if v.equipmentID == eid and equipData[i + 1] then
			return equipData[i + 1]
		end
	end
	return nil
end
function equipmentltCtrl.getNextOrangeEquipInfo(eid, isOrange)
	local partType = equipmentltCtrl.getEquipmentPart(eid)
	if partType == gEquipmentPart.RING or partType == gEquipmentPart.NECKLACE then
		return nil
	end
	local equipData = equipmentltCtrl.getOrangeEquipmentList(partType)
	equipData = equipmentltCtrl.filterEquipData(equipData)
	for i, v in ipairs(equipData) do
		if not isOrange then
			if v.equipmentID == eid then
				return equipData[i]
			end
		elseif v.equipmentID == eid and equipData[i + 1] then
			return equipData[i + 1]
		end
	end
	return nil
end
function equipmentltCtrl.judgeSuitEquipByEid(eid)
	local isSuitEquip = false
	if not equipmentltCtrl.getEquipCfg(eid) then
		local equipmentltCtrl, cfg = equipmentltCtrl.getEquipCfg(eid), equipmentltCtrl.getEquipCfg(eid)
	end
	if cfg.equipType == gEquipTypeDef.EQUIP_SUIT and cfg.suitequipID ~= 0 then
		isSuitEquip = true
	end
	return isSuitEquip
end
function equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(index, eid, eQuality, slv)
	local partList = equipmentltCtrl.getSuitPartList(index, eid)
	local factor = IsArClient and 1 or 10
	print("套装系数因子为：", factor)
	local propertyType, propertyValue = partList[eQuality + 1].propertyType, partList[eQuality + 1].propertyValue
	local propertyType2, propertyValue2 = partList[eQuality + 1].propertyType2, partList[eQuality + 1].propertyValue2
	local addition = partList[eQuality + 1].addition
	local addition2 = partList[eQuality + 1].addition2
	local newAddition = 0
	_UPVALUE3_ = nil
	;(nil)[1] = "minLv"
	;(nil)[2] = "maxLv"
	;(nil)[3] = "value"
	addition = serviceFunctions.tableFormat(addition, nil)
	for _, v in ipairs(addition) do
		if slv >= v.minLv and slv <= v.maxLv then
			propertyValue = propertyValue + v.value * (slv - v.minLv + 1)
			newAddition = v.value * (slv - v.minLv + 1)
		elseif slv > v.maxLv then
			propertyValue = propertyValue + v.value * (v.maxLv - v.minLv + 1)
			newAddition = v.value * (v.maxLv - v.minLv + 1)
		elseif slv == 0 then
			newAddition = v.value
		end
	end
	propertyValue = propertyValue / factor
	newAddition = newAddition / factor
	local newAddition2 = 0
	_UPVALUE3_ = "minLv"
	;("minLv")[1] = "minLv"
	;("minLv")[2] = "maxLv"
	;("minLv")[3] = "value"
	addition2 = serviceFunctions.tableFormat(addition2, "minLv")
	for _, v in ipairs(addition2) do
		if slv >= v.minLv and slv <= v.maxLv then
			propertyValue2 = propertyValue2 + v.value * (slv - v.minLv + 1)
			newAddition2 = v.value * (slv - v.minLv + 1)
		elseif slv > v.maxLv then
			propertyValue2 = propertyValue2 + v.value * (v.maxLv - v.minLv + 1)
			newAddition2 = v.value * (v.maxLv - v.minLv + 1)
		elseif slv == 0 then
			newAddition2 = v.value
		end
	end
	propertyValue2 = propertyValue2 / factor
	newAddition2 = newAddition2 / factor
	return propertyType, propertyValue, propertyType2, propertyValue2, newAddition, newAddition2
end
function equipmentltCtrl.getRingShopList()
	if not equipmentltCtrl.ringshop_list then
		equipmentltCtrl = equipmentltCtrl.ringshop_list
	end
	return equipmentltCtrl.ringshop_list
end
function equipmentltCtrl.getRingShopByID(shopItemID)
	for i, v in ipairs(equipmentltCtrl.ringshop_all_list) do
		if v.shopItemID == shopItemID then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(equipmentltCtrl.ringshop_all_list)
end
function equipmentltCtrl.getOutput(itemID)
	return equipmentltCtrl.materailOutputCfg[itemID] and equipmentltCtrl.materailOutputCfg[itemID].jumpId
end
function equipmentltCtrl.getDisThings(eid)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local bluePrint = serviceFunctions.tableFormat(equipmentltCtrl.orangeEquip_dis_list[eid].bluePrint, nil)
	_UPVALUE2_ = "id"
	;("id")[1] = "id"
	;("id")[2] = "count"
	local material = serviceFunctions.tableFormat(equipmentltCtrl.orangeEquip_dis_list[eid].material, "id")
	return bluePrint, material
end
function equipmentltCtrl.getExpendItem(level, quality, equipType, strengthenLv)
	print("level,quality,equipType,strengthenLv=====", level, quality, equipType, strengthenLv)
	local cfg = equipmentltCtrl.recoin_expend[level][quality][equipType][strengthenLv]
	return cfg.expend[1], cfg.expend[2]
end
function equipmentltCtrl.isSuitResonance(quality, lv, slv)
	local ret = false
	local _ENV, cfg
	for k, v in ipairs(equipmentltCtrl.strengthenresonance) do
		if v.quality == quality and v.level == lv and slv >= v.sumLv then
			ret = true
			cfg = v
		end
	end
	return ret, cfg
end
function equipmentltCtrl.isInResonance(quality, lv)
	local ret = false
	for k, v in ipairs(equipmentltCtrl.strengthenresonance) do
		if v.quality == quality and v.level == lv then
			ret = true
			break
		end
	end
	return ret
end
function equipmentltCtrl.getNextSumLv(quality, lv, slv)
	local sumLv = slv
	for k, v in ipairs(equipmentltCtrl.strengthenresonance) do
		if v.quality == quality and v.level == lv and slv < v.sumLv then
			sumLv = v.sumLv
			break
		end
	end
	return sumLv
end
function equipmentltCtrl.getGrowth(quality, lv, sumLv)
	local growth
	for k, v in ipairs(equipmentltCtrl.strengthenresonance) do
		if v.quality == quality and v.level == lv and sumLv >= v.sumLv then
			_UPVALUE2_ = nil
			;(nil)[1] = "buffType"
			;(nil)[2] = "buffVal"
			growth = serviceFunctions.tableFormat(v.growth, nil)
		end
	end
	return growth
end
function equipmentltCtrl.getResonanceCfg(quality, lv)
	local _ENV, cfg
	for k, v in ipairs(equipmentltCtrl.strengthenresonance) do
		if v.quality == quality and v.level == lv then
			_ENV = nil
			;(nil).sumLv = v.sumLv
			_UPVALUE2_ = nil
			;(nil)[1] = "buffType"
			;(nil)[2] = "buffVal"
			;(nil).growth = serviceFunctions.tableFormat(v.growth, nil)
			table.insert(cfg, nil)
		end
	end
	return cfg
end
function equipmentltCtrl.getPropertyTypeByGroup(group)
	local typeName = ""
	for k, v in pairs(equipmentltCtrl.slim_sort_config) do
		if group == v.group then
			typeName = v.name
			break
		end
	end
	return typeName
end
function equipmentltCtrl.getPropertyListByGroup(group)
	local _ENV, propertyList
	for k, v in pairs(equipmentltCtrl.slim_sort_config) do
		if group == v.group then
			table.insert(propertyList, v.propertyType)
		end
	end
	return propertyList
end
function equipmentltCtrl.getRangeByQuality(quality)
	local rangeName = ""
	for k, v in pairs(equipmentltCtrl.slim_range_config) do
		if quality == v.quality then
			rangeName = v.name
		end
	end
	return rangeName
end
function equipmentltCtrl.getLegendEquipReturnCfg(equipid)
	return equipmentltCtrl.legend_equip_return[tostring(equipid)]
end
function equipmentltCtrl.getLegendEquipReturnShowCfg()
	return equipmentltCtrl.legend_equip_return_show
end
function equipmentltCtrl.getNebulaEquipLimitReturnCfg()
	return equipmentltCtrl.nebulaequip_limit_return
end
init()
return equipmentltCtrl
