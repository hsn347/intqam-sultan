local _ENV, equipmentMgr
local MAX_SIZE = 200
local MAX_RING_SIZE = 50
local MAX_NECKLACE_SIZE = 50
local initUnits = 42
local unlockUnits = 6
local size = 0
local ringSize = 0
local necklaceSize = 0
local _ENV, equipment_list
local _ENV, equipment_ring_list
local _ENV, equipment_necklace_list
local _ENV, equipment_newList
local _ENV, parts_list
local forging_equipment, isEnhanceChanged
local _ENV, enhanceData
local _ENV, filerEquipAttrTypeList
function equipmentMgr.cleanNewList()
	equipment_newList = nil
	equipment_newList = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:GameSettingView:equipmentNewList~table", equipment_newList, nil)
end
function equipmentMgr.cleanNewListByEquip(equipment)
	local epid = tostring(equipment:getEPID())
	equipment_newList[epid] = nil
	_ENV = equipment:getEPID()
	equipment:getEPID().byUID = true
	SoraDConfigSet("Game:GameSettingView:equipmentNewList~table", equipment_newList, equipment:getEPID())
end
function equipmentMgr.addNewList(equipment)
	local epid = tostring(equipment:getEPID())
	equipment_newList[epid] = true
	_ENV = equipment:getEPID()
	equipment:getEPID().byUID = true
	SoraDConfigSet("Game:GameSettingView:equipmentNewList~table", equipment_newList, equipment:getEPID())
end
function equipmentMgr.isNewList(equipment)
	local epid = tostring(equipment:getEPID())
	return equipment_newList[epid]
end
function equipmentMgr.getEquipment(epid)
	return equipment_list[epid] or equipment_ring_list[epid] or equipment_necklace_list[epid]
end
function equipmentMgr.getRingEquipmentHaveBuy(eid)
	local equipDesRead = include("equipDesRead")
	for i, v in pairs(equipment_ring_list) do
		if equipDesRead.getIcon(v:getEID()) == equipDesRead.getIcon(eid) then
			return true
		end
	end
	return false
end
function equipmentMgr.getNeckLaceEquipmentHaveBuyEx(eid)
	local equipDesRead = include("equipDesRead")
	local _targetIcon = equipDesRead.getIcon(eid)
	local _endTime = 0
	local ret
	for i, v in pairs(equipment_necklace_list) do
		if equipDesRead.getIcon(v:getEID()) == _targetIcon then
			local endTime = v:getEquipmentEndTimeProperty()
			if endTime and _endTime < endTime then
				_endTime = endTime
				ret = v
			end
		end
	end
	return 0 < _endTime, ret
end
function equipmentMgr.isOwnHideNecklace(eid)
	for i, v in pairs(equipment_necklace_list) do
		if v:getEID() == eid then
			return true
		end
	end
	return false
end
function equipmentMgr.isHaveLegendEquipment()
	local ret = false
	for i, v in pairs(equipment_list) do
		if v:getEquipmentQuality() == gQualityDef.LEGEND then
			ret = true
		end
	end
	return ret
end
function equipmentMgr.isHaveNebulaEquipment()
	local ret = false
	for i, v in pairs(equipment_list) do
		if v:getEquipmentQuality() == gQualityDef.NEBULA then
			ret = true
		end
	end
	return ret
end
function equipmentMgr.getHaveEquipment(eidList)
	local _ENV, ret
	for i, v in pairs(equipment_list) do
		if SoraDisInList(v:getEID(), eidList) then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(a, b)
		return a:getEID() < b:getEID()
	end)
	return ret
end
function equipmentMgr.isFull()
	if equipmentMgr.isForgingEquipment() then
		return size + 1 >= MAX_SIZE
	else
		return size >= MAX_SIZE
	end
end
function equipmentMgr.addEquipment(epid, equipment, isInit)
	local part = equipment:getEquipmentPart()
	print("equipmentMgr.addEquipment", part, equipment:getEID())
	if 0 < part and part <= gEquipmentPart.HAND then
		print("addEquipment-equipadd", size)
		equipment_list[epid] = equipment
		if not isInit then
			equipmentMgr.addNewList(equipment)
		end
	elseif part == gEquipmentPart.NECKLACE then
		print("addEquipment-necklaceadd", necklaceSize)
		equipment_necklace_list[epid] = equipment
	elseif part == gEquipmentPart.RING then
		print("addEquipment-ringadd", ringSize)
		equipment_ring_list[epid] = equipment
	end
end
function equipmentMgr.removeEquipment(epid)
	if equipment_list[epid] then
	elseif equipment_ring_list[epid] then
	else
	end
	local equipment = equipment_list[epid] or equipment_ring_list[epid] or equipment_necklace_list[epid]
	equipment_list[epid] = nil
	equipment_ring_list[epid] = nil
	equipment_necklace_list[epid] = nil
	return equipment
end
function equipmentMgr.setPartEquipment(part, equipment)
	parts_list[part] = equipment
end
function equipmentMgr.getPartEquipment(part)
	return parts_list[part]
end
function equipmentMgr.getAllPartEquipment()
	return parts_list
end
function equipmentMgr.getEquipmentList()
	return equipment_list
end
function equipmentMgr.getEquipmentNecklaceList()
	return equipment_necklace_list
end
function equipmentMgr.getEquipmentRingList()
	return equipment_ring_list
end
function equipmentMgr.sortEquip(l, r)
	if l:getEquipmentPart() == r:getEquipmentPart() then
		if l:getEquipmentLV() == r:getEquipmentLV() then
			return l:getEquipmentQuality() > r:getEquipmentQuality()
		else
			return l:getEquipmentLV() > r:getEquipmentLV()
		end
	else
		return l:getEquipmentPart() < r:getEquipmentPart()
	end
end
function equipmentMgr.getEquipmentArray()
	local _ENV, array
	for epid, equipment in pairs(equipment_list) do
		table.insert(array, equipment)
	end
	if next(array) then
		table.sort(array, equipmentMgr.sortEquip)
	end
	return array
end
function equipmentMgr.isHasEquipFiler()
	return next(filerEquipAttrTypeList) ~= nil
end
function equipmentMgr.resetEquipFilerType()
	filerEquipAttrTypeList = nil
end
function equipmentMgr.isEquipFiler(attrType)
	return filerEquipAttrTypeList[attrType]
end
function equipmentMgr.getEquipFilerData()
	return filerEquipAttrTypeList
end
function equipmentMgr.setEquipFilerData(filerAttrType)
	filerAttrType = {}
end
function equipmentMgr.getEquipFilerList()
	if not equipmentMgr.equipFilerList then
		local equipDesRead = include("equipDesRead")
		local suitList = equipDesRead.getSuitInfoList()
		local equipmentMgr, equipmentMgr, filerList
		filerList[0], (nil).name = nil, "suit_text_07"
		for k, v in pairs(suitList) do
			local suitName = equipDesRead.getSuitTendencyByID(k)
			equipmentMgr = k
			filerList[k], k.name = k, suitName
		end
		equipmentMgr.equipFilerList = filerList
	end
	return equipmentMgr.equipFilerList
end
function equipmentMgr.getEquipmentArrayWithFiler(eid)
	local _ENV, array
	local equipmentltCtrl = include("equipmentltCtrl")
	local check = equipmentMgr.isEquipFiler
	local isHasEquipFiler = equipmentMgr.isHasEquipFiler()
	for epid, equipment in pairs(equipment_list) do
		local info = equipmentltCtrl.getEquipCfg(equipment:getEID())
		if info then
			if eid then
				if (not isHasEquipFiler or isHasEquipFiler and check(info.suitequipID)) and eid == equipment:getEID() then
					table.insert(array, equipment)
				end
			elseif not isHasEquipFiler or isHasEquipFiler and check(info.suitequipID) then
				table.insert(array, equipment)
			end
		end
	end
	if next(array) then
		table.sort(array, equipmentMgr.sortEquip)
	end
	return array
end
function equipmentMgr.getEquipmentArrayWithFilerFromRing(part)
	local _ENV, array
	local equipmentltCtrl = include("equipmentltCtrl")
	local check = equipmentMgr.isEquipFiler
	local isHasEquipFiler = equipmentMgr.isHasEquipFiler()
	local tmpList = equipment_ring_list
	if part == gEquipmentPart.NECKLACE then
		tmpList = equipment_necklace_list
	end
	for epid, equipment in pairs(tmpList) do
		local info = equipmentltCtrl.getEquipCfg(equipment:getEID())
		if info and (not isHasEquipFiler or isHasEquipFiler and check(info.suitequipID)) then
			table.insert(array, equipment)
		end
	end
	if next(array) then
		table.sort(array, equipmentMgr.sortEquip)
	end
	return array
end
function equipmentMgr.getAllEquipmentByPart(part, notWear)
	local equipment_list, array
	local tmpList = equipment_list
	if part == gEquipmentPart.NECKLACE then
		tmpList = equipment_necklace_list
	elseif part == gEquipmentPart.RING then
		tmpList = equipment_ring_list
	end
	for epid, equipment in pairs(tmpList) do
		if part == equipment:getEquipmentPart() and (not notWear or not equipment:isWearing()) then
			table.insert(array, equipment)
		end
	end
	if next(array) then
		table.sort(array, function(l, r)
			if l:getEquipmentLV() == r:getEquipmentLV() then
				if l:getEquipmentQuality() == r:getEquipmentQuality() then
					return l:getEquipmentSLV() > r:getEquipmentSLV()
				else
					return l:getEquipmentQuality() > r:getEquipmentQuality()
				end
			elseif l:getEquipmentQuality() == gQualityDef.LEGEND and r:getEquipmentQuality() == gQualityDef.LEGEND then
				return l:getEquipmentSLV() > r:getEquipmentSLV()
			elseif l:getEquipmentQuality() == gQualityDef.LEGEND or r:getEquipmentQuality() == gQualityDef.LEGEND then
				return l:getEquipmentQuality() > r:getEquipmentQuality()
			else
				return l:getEquipmentLV() > r:getEquipmentLV()
			end
		end)
	end
	return array
end
function equipmentMgr.getFilterEquipmentByPart(part, filterEpid)
	local _ENV, array
	for epid, equipment in pairs(equipment_list) do
		if part == equipment:getEquipmentPart() and (not filterEpid or filterEpid ~= equipment:getEPID()) then
			table.insert(array, equipment)
		end
	end
	if next(array) then
		table.sort(array, function(l, r)
			if l:getEquipmentLV() == r:getEquipmentLV() then
				if l:getEquipmentQuality() == r:getEquipmentQuality() then
					return l:getEquipmentSLV() > r:getEquipmentSLV()
				else
					return l:getEquipmentQuality() > r:getEquipmentQuality()
				end
			elseif l:getEquipmentQuality() == gQualityDef.LEGEND and r:getEquipmentQuality() == gQualityDef.LEGEND then
				return l:getEquipmentSLV() > r:getEquipmentSLV()
			elseif l:getEquipmentQuality() == gQualityDef.LEGEND or r:getEquipmentQuality() == gQualityDef.LEGEND then
				return l:getEquipmentQuality() > r:getEquipmentQuality()
			else
				return l:getEquipmentLV() > r:getEquipmentLV()
			end
		end)
	end
	return array
end
function equipmentMgr.isForgingEquipment()
	if forging_equipment then
		return true
	else
		return false
	end
end
function equipmentMgr.setForgingEquipment(equipment)
	equipment = {}
end
function equipmentMgr.getForgingEquipment()
	return forging_equipment
end
function equipmentMgr.getLimitNum()
	return MAX_SIZE
end
function equipmentMgr.getEquipmentNum()
	return size
end
function equipmentMgr.getShowUnitNum()
	if size <= initUnits then
		return initUnits
	end
	if size % unlockUnits == 0 then
		return size
	else
		return size + (unlockUnits - size % unlockUnits)
	end
end
function equipmentMgr.getShowRingUnitNum()
	if ringSize <= initUnits then
		return initUnits
	end
	if ringSize % unlockUnits == 0 then
		return ringSize
	else
		return ringSize + (unlockUnits - ringSize % unlockUnits)
	end
end
function equipmentMgr.getShowNeckLaceUnitNum()
	if necklaceSize <= initUnits then
		return initUnits
	end
	if necklaceSize % unlockUnits == 0 then
		return necklaceSize
	else
		return necklaceSize + (unlockUnits - necklaceSize % unlockUnits)
	end
end
function equipmentMgr.isWearWeaponEnhance()
	if isEnhanceChanged == false then
		return enhanceData.ret, enhanceData.qualityTable
	end
	local ret = false
	local isEnhanceChanged, qualityTable = enhanceData.qualityTable, enhanceData.qualityTable
	local equipmentltCtrl = include("equipmentltCtrl")
	for i, v in pairs(equipment_list) do
		local quality = v:getEquipmentQuality()
		local lv = v:getEquipmentLV()
		if quality >= gQualityDef.ORANGE and v:isWearing() and equipmentltCtrl.isInResonance(quality, lv) then
			if not qualityTable[quality] then
				qualityTable[quality], isEnhanceChanged = qualityTable[quality], qualityTable[quality]
			end
			if not qualityTable[quality][lv] then
				qualityTable[quality][lv] = v:getEquipmentSLV()
			else
				qualityTable[quality][lv] = qualityTable[quality][lv] + v:getEquipmentSLV()
			end
		end
	end
	for quality, v in pairs(qualityTable) do
		for lv, slv in pairs(v) do
			local isSuit = equipmentltCtrl.isSuitResonance(quality, lv, slv)
			if isSuit then
				ret = true
			end
		end
	end
	enhanceData.ret = ret
	enhanceData.qualityTable = qualityTable
	return ret, qualityTable
end
function equipmentMgr.getWearWeaponEnhanceBuff(effectType)
	if isEnhanceChanged == false and enhanceData.buffList ~= nil then
		return enhanceData.buffList[effectType]
	end
	local ret, qualityTable = equipmentMgr.isWearWeaponEnhance()
	local isEnhanceChanged, buffList
	if ret then
		local equipmentltCtrl = include("equipmentltCtrl")
		for quality, data in pairs(qualityTable) do
			for level, slv in pairs(data) do
				local growth = equipmentltCtrl.getGrowth(quality, level, slv)
				if growth then
					for ki, vi in ipairs(growth) do
						buffList[vi.buffType] = (buffList[vi.buffType] or 0) + vi.buffVal
					end
				end
			end
		end
	end
	enhanceData.buffList = buffList
	return buffList[effectType]
end
function equipmentMgr.setEnhanceChange(ret)
	ret = {}
end
function equipmentMgr.clean()
	size = {}
	size = {}
	size = {}
	size = {}
	size = {}
	size = {}
end
function equipmentMgr.dump()
	print(">>>>>>>>>>>>>>>>>forging equipment:")
	if forging_equipment and forging_equipment ~= true then
		forging_equipment:dump()
	end
	print(">>>>>>>>>>>>>>>>>equipment list:")
	for epid, equipment in pairs(equipment_list) do
		equipment:dump()
	end
	print(">>>>>>>>>>>>>>>>>equipment part list:")
	for part, equipment in pairs(parts_list) do
		equipment:dump()
	end
end
function equipmentMgr.init()
	equipment_newList = nil
	;(nil).byUID = true
end
return equipmentMgr
