local miraculousWeaponltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "miraculous_resonance_config"
	;(nil)[2] = true
	miraculousWeaponltCtrl:defineValue("resonanceTbl", nil)
	_ENV = nil
	;(nil)[1] = "miraculous_weapon_config"
	;(nil)[2] = true
	miraculousWeaponltCtrl:defineValue("weaponOriTbl", nil)
	_ENV = nil
	;(nil)[1] = "miraculous_weapon_chip_unlock"
	;(nil)[2] = true
	miraculousWeaponltCtrl:defineValue("weaponChipsTbl", nil)
	_ENV = nil
	;(nil)[1] = "weapon_wake_config"
	;(nil)[2] = true
	miraculousWeaponltCtrl:defineValue("weaponWakeTbl", nil)
	miraculousWeaponltCtrl:defineValue("weaponTbl", function()
		miraculousWeaponltCtrl.weaponTbl, miraculousWeaponltCtrl = nil, nil
		local weaponConfig = miraculousWeaponltCtrl.weaponOriTbl
		for k, v in ipairs(weaponConfig) do
			miraculousWeaponltCtrl.weaponTbl[v.weaponID] = v
		end
		return miraculousWeaponltCtrl.weaponTbl
	end)
end
init()
function miraculousWeaponltCtrl.getGadPowerBuffList(oriMaxPower)
	local buffDesRead = include("buffDesRead")
	local tbl = miraculousWeaponltCtrl.resonanceTbl
	for k, v in ipairs(tbl) do
		v.index = k
		v.isReach = oriMaxPower > v.power
		v.id = v.buffList[1]
		v.buffName = buffDesRead.getTitleBase(v.buffList[1])
		v.buffIcon = v.icon
		local value = v.buffList[3]
		if v.buffList[2] == 1 then
			value = tostring(value / 10) .. "%"
		end
		v.value = value
	end
	return tbl
end
function miraculousWeaponltCtrl.getWeaponIDByIndex(index)
	return miraculousWeaponltCtrl.weaponOriTbl[index].weaponID
end
function miraculousWeaponltCtrl.getAllWeapon()
	return miraculousWeaponltCtrl.weaponTbl
end
function miraculousWeaponltCtrl.getWeaponInfo(weaponID)
	return miraculousWeaponltCtrl.weaponTbl[weaponID]
end
function miraculousWeaponltCtrl.getWeaponMaxBuffValue(weaponID, buffType)
	_UPVALUE4_ = weaponID
	weaponID[1] = "buffType"
	weaponID[2] = "mode"
	weaponID[3] = "eType"
	weaponID[4] = "value"
	local buffList = serviceFunctions.tableFormat(miraculousWeaponltCtrl.getWeaponInfo(weaponID).init_buff, weaponID)
	local max = 0
	local min = 0
	for k, v in ipairs(buffList) do
		if v.buffType == buffType then
			max = v.value
			min = v.eType
			break
		end
	end
	return max, min
end
function miraculousWeaponltCtrl.hasAnyChipsBeUnlock(isUnlocking)
	local ret = false
	local chip
	local gametop = gModuleMgr.getObject("gametop")
	local miraculousWeaponCtrl = gametop.playertop_:getModule("miraculousWeaponCtrl")
	for k, v in ipairs(miraculousWeaponltCtrl.weaponChipsTbl) do
		local chipInfo = miraculousWeaponCtrl:getWeaponChipsInfo(v.weaponID, v.chipIndex)
		if chipInfo.status == gWeaponChipStatus.BEUNLOCK or isUnlocking and chipInfo.status == gWeaponChipStatus.UNLOCKING then
			ret = true
			chip = v
			break
		end
	end
	return ret, chip
end
function miraculousWeaponltCtrl.getChipsInfo(weaponID, chipIndex)
	local _ENV, chip
	for k, v in ipairs(miraculousWeaponltCtrl.weaponChipsTbl) do
		if v.weaponID == weaponID and v.chipIndex == chipIndex then
			chip = v
			break
		end
	end
	return chip
end
function miraculousWeaponltCtrl.getWeaponWakeCost(num, rewakeType)
	local ret
	local num = math.max(1, num)
	local rewakeType = rewakeType or gAwakeOpType.NORMAL
	for k, v in ipairs(miraculousWeaponltCtrl.weaponWakeTbl) do
		if v.rewakeType == rewakeType and num >= v.num[1] and num <= v.num[2] then
			_ENV = v.num[2]
			v.num[2].id = v.exItem[1]
			ret, v.num[2].value = v.num[2], v.exItem[2]
			break
		end
	end
	local lastTbl = miraculousWeaponltCtrl.weaponWakeTbl[#miraculousWeaponltCtrl.weaponWakeTbl]
	if not ret and num > lastTbl.num[2] then
		_ENV = lastTbl.num[2]
		lastTbl.num[2].id = lastTbl.exItem[1]
		ret, lastTbl.num[2].value = lastTbl.num[2], lastTbl.exItem[2]
	end
	return ret
end
return miraculousWeaponltCtrl
