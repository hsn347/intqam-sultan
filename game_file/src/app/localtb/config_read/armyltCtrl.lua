local armyltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		armyltCtrl.biuld_army_list, armyltCtrl, armyltCtrl.build_wlv_army_list, armyltCtrl, armyltCtrl.armyInfo, armyltCtrl = nil, nil, nil, nil, nil, nil
		local armyinfo = require_once("app." .. LocalTblPath .. ".config_server.armyinfo")
		armyltCtrl.armyReadInfo = armyinfo
		for i, v in ipairs(armyinfo) do
			armyltCtrl.armyInfo[v.armyID] = v
			local bid = v.barrackID
			local blv = v.barrackLevel
			local starlv = v.starlv
			if blv <= CASTLE_MAXLV_NOWAR then
				if not armyltCtrl.biuld_army_list[bid] then
					armyltCtrl = armyltCtrl.biuld_army_list[bid]
				end
				armyltCtrl.biuld_army_list[bid] = armyltCtrl.biuld_army_list[bid]
				table.insert(armyltCtrl.biuld_army_list[bid], v.armyID)
				local wlv = 0
				if not armyltCtrl.build_wlv_army_list[bid] then
					armyltCtrl = armyltCtrl.build_wlv_army_list[bid]
				end
				armyltCtrl.build_wlv_army_list[bid] = armyltCtrl.build_wlv_army_list[bid]
				if not armyltCtrl.build_wlv_army_list[bid][wlv] then
					armyltCtrl = armyltCtrl.build_wlv_army_list[bid][wlv]
				end
				armyltCtrl.build_wlv_army_list[bid][wlv] = armyltCtrl.build_wlv_army_list[bid][wlv]
				table.insert(armyltCtrl.build_wlv_army_list[bid][wlv], v.armyID)
			else
				blv = blv - CASTLE_MAXLV_NOWAR
				local wlv = 0
				if 0 < blv then
					wlv = math.floor(blv / 10)
				end
				if wlv >= CASTLE_MIN_WARLV then
					if not armyltCtrl.build_wlv_army_list[bid] then
						armyltCtrl = armyltCtrl.build_wlv_army_list[bid]
					end
					armyltCtrl.build_wlv_army_list[bid] = armyltCtrl.build_wlv_army_list[bid]
					if not armyltCtrl.build_wlv_army_list[bid][wlv] then
						armyltCtrl = armyltCtrl.build_wlv_army_list[bid][wlv]
					end
					armyltCtrl.build_wlv_army_list[bid][wlv] = armyltCtrl.build_wlv_army_list[bid][wlv]
					table.insert(armyltCtrl.build_wlv_army_list[bid][wlv], v.armyID)
				end
			end
		end
		for k, v in pairs(armyltCtrl.build_wlv_army_list) do
			local newArmyIDs
			if k == BUILDID.STABLES then
				_UPVALUE2_ = BUILDID.STABLES
				newArmyIDs, BUILDID.STABLES[1] = BUILDID.STABLES, 10004511
				newArmyIDs, BUILDID.STABLES[2] = BUILDID.STABLES, 10009512
			elseif k == BUILDID.RANGE then
				_UPVALUE2_ = BUILDID.RANGE
				newArmyIDs, BUILDID.RANGE[1] = BUILDID.RANGE, 10004611
				newArmyIDs, BUILDID.RANGE[2] = BUILDID.RANGE, 10009612
			elseif k == BUILDID.CHARIOT_PLANT then
				_UPVALUE2_ = BUILDID.CHARIOT_PLANT
				newArmyIDs, BUILDID.CHARIOT_PLANT[1] = BUILDID.CHARIOT_PLANT, 10004411
				newArmyIDs, BUILDID.CHARIOT_PLANT[2] = BUILDID.CHARIOT_PLANT, 10009412
			elseif k == BUILDID.BARRACKS then
				_UPVALUE2_ = BUILDID.BARRACKS
				newArmyIDs, BUILDID.BARRACKS[1] = BUILDID.BARRACKS, 10004711
				newArmyIDs, BUILDID.BARRACKS[2] = BUILDID.BARRACKS, 10009712
			end
			if newArmyIDs and next(newArmyIDs) then
				local maxWLV = 10
				for i = 0, maxWLV - 1 do
					if i < 5 then
						table.insert(v[i], newArmyIDs[1])
					else
						table.insert(v[i], newArmyIDs[2])
					end
				end
			end
		end
		_UPVALUE6_, armyltCtrl.mostAttarList, armyltCtrl = pairs(armyltCtrl.build_wlv_army_list)
		pairs(armyltCtrl.build_wlv_army_list)[1] = "attack"
		pairs(armyltCtrl.build_wlv_army_list)[2] = "defense"
		pairs(armyltCtrl.build_wlv_army_list)[3] = "life"
		pairs(armyltCtrl.build_wlv_army_list)[4] = "power"
		pairs(armyltCtrl.build_wlv_army_list)[5] = "speed"
		local pairs(armyltCtrl.build_wlv_army_list)[6], attrTable = "atkDistance", pairs(armyltCtrl.build_wlv_army_list)
		for _, v in ipairs(armyinfo) do
			local bid = v.barrackID
			local temp = armyltCtrl.mostAttarList[tostring(bid)]
			if temp then
				for _, attr in pairs(attrTable) do
					if v[attr] and temp[attr] < v[attr] then
						armyltCtrl.mostAttarList[tostring(bid)][attr] = armyltCtrl.getArmyAttrAndSp(v.armyID, attr)
					end
				end
			else
				armyltCtrl.mostAttarList[tostring(bid)], armyltCtrl = bid, bid
				for _, attr in pairs(attrTable) do
					armyltCtrl.mostAttarList[tostring(bid)][attr] = armyltCtrl.getArmyAttrAndSp(v.armyID, attr)
				end
			end
		end
		if name == "armyInfo" then
			return armyltCtrl.armyInfo
		elseif name == "build_wlv_army_list" then
			return armyltCtrl.build_wlv_army_list
		elseif name == "biuld_army_list" then
			return armyltCtrl.biuld_army_list
		elseif name == "mostAttarList" then
			return armyltCtrl.mostAttarList
		elseif name == "armyReadInfo" then
			return armyltCtrl.armyReadInfo
		end
	end
	armyltCtrl:defineValue("armyInfo", createData)
	armyltCtrl:defineValue("armyReadInfo", createData)
	armyltCtrl:defineValue("build_wlv_army_list", createData)
	armyltCtrl:defineValue("biuld_army_list", createData)
	armyltCtrl:defineValue("mostAttarList", createData)
	local createData2 = function(name)
		local armyspeciality = require_once("app." .. LocalTblPath .. ".config_server.armyspeciality")
		for _, spec in pairs(armyspeciality) do
			if string.trim(spec.armyspecialityeffect1) ~= "" then
				spec.effect1 = string.split(spec.armyspecialityeffect1, ";")
			end
			if string.trim(spec.armyspecialityeffect2) ~= "" then
				spec.effect2 = string.split(spec.armyspecialityeffect2, ";")
			end
			if string.trim(spec.armyspecialityeffect3) ~= "" then
				spec.effect3 = string.split(spec.armyspecialityeffect3, ";")
			end
		end
		local _ENV, mapArmySp = (for generator), pairs(armyspeciality)
		for _, army in pairs(armyltCtrl.armyInfo) do
			local _ENV, armySp = spec.armyspecialityeffect3, spec.armyspecialityeffect3
			armySp.resourceWarAkPlus = 0
			armySp.immuneTrap = false
			armySp.restrainArmyTypeDfsRedDmg, _ENV, armySp.restrainArmyTypeAtkAddDmg, _ENV, armySp.akBackrowRate = ";", ";", ";", ";", 0
			armySp.dodge = 0
			armySp.cityWarAkPlus = 0
			armySp.cityWarDfPlus = 0
			armySp.priorAkArmyClass = 0
			armySp.immuneDf = false
			armySp.hpPlus = 0
			armySp.dfPlus = 0
			armySp.akPlus = 0
			armySp.atkInvPlus = 0
			armySp.speedPlus = 0
			armySp.freeWeightPlus = 0
			armySp.penetrateRate = 0
			armySp.penetrateDmgRate = 0
			armySp.akBackrowDmgPlus = 0
			armySp.alertRate = 0
			armySp.alertDmgPlus = 0
			armySp.isShelter = false
			armySp.shelterDfPlus = 0
			armySp.critRate = 0
			armySp.rebound = 0
			armySp.spurting = 0
			mapArmySp[army.armyID] = armySp
			for _, id in pairs(army.speciality) do
				local specialityData = armyspeciality[id]
				if not specialityData then
					break
				end
				local _ENV, arrSpec
				if 0 < specialityData.armyspecialitytype1 then
					_ENV = nil
					;(nil).sType = specialityData.armyspecialitytype1
					;(nil).effect = specialityData.effect1
					table.insert(arrSpec, nil)
				end
				if 0 < specialityData.armyspecialitytype2 then
					_ENV = nil
					;(nil).sType = specialityData.armyspecialitytype2
					;(nil).effect = specialityData.effect2
					table.insert(arrSpec, nil)
				end
				if 0 < specialityData.armyspecialitytype3 then
					_ENV = nil
					;(nil).sType = specialityData.armyspecialitytype3
					;(nil).effect = specialityData.effect3
					table.insert(arrSpec, nil)
				end
				for _, spec in pairs(arrSpec) do
					local sType = spec.sType
					local effect = spec.effect
					if spec.effect and 0 < #spec.effect then
						if sType == gArmySpeciality.resourceWarAkPlus then
							armySp.resourceWarAkPlus = serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.immuneTrap then
							armySp.immuneTrap = true
						elseif sType == gArmySpeciality.charge then
							armySp.akBackrowRate = serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.infantryAkRestrain then
							armySp.restrainArmyTypeAtkAddDmg[gArmyType.infantryAk] = serviceFunctions.getPermillageValue(effect[1])
							armySp.restrainArmyTypeDfsRedDmg[gArmyType.infantryAk] = serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.cavalryRestrain then
							armySp.restrainArmyTypeAtkAddDmg[gArmyType.archer] = serviceFunctions.getPermillageValue(effect[1])
							armySp.restrainArmyTypeDfsRedDmg[gArmyType.archer] = serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.cavalryArrowRestrain then
							armySp.restrainArmyTypeAtkAddDmg[gArmyType.crossbow] = serviceFunctions.getPermillageValue(effect[1])
							armySp.restrainArmyTypeDfsRedDmg[gArmyType.crossbow] = serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.archerRestrain then
							armySp.restrainArmyTypeAtkAddDmg[gArmyType.cavalry] = serviceFunctions.getPermillageValue(effect[1])
							armySp.restrainArmyTypeDfsRedDmg[gArmyType.cavalry] = serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.crossbowRestrain then
							armySp.restrainArmyTypeAtkAddDmg[gArmyType.cavalryArrow] = serviceFunctions.getPermillageValue(effect[1])
							armySp.restrainArmyTypeDfsRedDmg[gArmyType.cavalryArrow] = serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.dodge then
							armySp.dodge = serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.cityWarAkPlus then
							armySp.cityWarAkPlus = serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.cityWarDfPlus then
							armySp.cityWarDfPlus = serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.priorInfantry then
							armySp.priorAkArmyClass = gArmyClass.infantry
						elseif sType == gArmySpeciality.priorCavalry then
							armySp.priorAkArmyClass = gArmyClass.cavalry
						elseif sType == gArmySpeciality.priorArcher then
							armySp.priorAkArmyClass = gArmyClass.archer
						elseif sType == gArmySpeciality.immuneDf then
							armySp.immuneDf = true
						elseif sType == gArmySpeciality.hpPlus then
							armySp.hpPlus = armySp.hpPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.dfPlus then
							armySp.dfPlus = armySp.dfPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.akPlus then
							armySp.akPlus = armySp.akPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.atkInvPlus then
							armySp.atkInvPlus = armySp.atkInvPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.moveSpeed then
							armySp.speedPlus = armySp.speedPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.blows then
							armySp.akPlus = armySp.akPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.weightPlus then
							armySp.freeWeightPlus = armySp.freeWeightPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.penetrate then
							armySp.penetrateRate = armySp.penetrateRate + serviceFunctions.getPermillageValue(effect[1])
							armySp.penetrateDmgRate = armySp.penetrateDmgRate + serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.volley then
							armySp.akBackrowDmgPlus = armySp.akBackrowDmgPlus + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.alert then
							armySp.alertRate = serviceFunctions.getPermillageValue(effect[1])
							armySp.alertDmgPlus = serviceFunctions.getPermillageValue(effect[2])
						elseif sType == gArmySpeciality.collide then
							armySp.isShelter = true
							armySp.shelterDfPlus = serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.crit then
							armySp.critRate = armySp.critRate + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.rebound then
							armySp.rebound = armySp.rebound + serviceFunctions.getPermillageValue(effect[1])
						elseif sType == gArmySpeciality.spurting then
							armySp.spurting = armySp.spurting + serviceFunctions.getPermillageValue(effect[1])
						end
					end
				end
			end
		end
		armyltCtrl.mapArmySp = mapArmySp
		armyltCtrl.armyspeciality = armyspeciality
		if name == "mapArmySp" then
			return mapArmySp
		elseif name == "armyspeciality" then
			return armyspeciality
		end
	end
	armyltCtrl:defineValue("mapArmySp", createData2)
	armyltCtrl:defineValue("armyspeciality", createData2)
	armyltCtrl:defineValue("mostAttarList", function()
		local _UPVALUE6_, _ENV, mostAttarList
		;(nil)[1] = "attack"
		;(nil)[2] = "defense"
		;(nil)[3] = "life"
		;(nil)[4] = "power"
		;(nil)[5] = "speed"
		local (nil)[6], attrTable = "atkDistance", nil
		for _, v in pairs(armyltCtrl.armyInfo) do
			local bid = v.barrackID
			local temp = mostAttarList[tostring(bid)]
			if temp then
				for _, attr in pairs(attrTable) do
					if v[attr] and temp[attr] < v[attr] then
						mostAttarList[tostring(bid)][attr] = armyltCtrl.getArmyAttrAndSp(v.armyID, attr)
					end
				end
			else
				mostAttarList[tostring(bid)], _ENV = bid, bid
				for _, attr in pairs(attrTable) do
					mostAttarList[tostring(bid)][attr] = armyltCtrl.getArmyAttrAndSp(v.armyID, attr)
				end
			end
		end
		return mostAttarList
	end)
	armyltCtrl:defineValue("legendarykingCureCostCfg", function()
		local _ENV, ret
		local legendaryking_cure_cost = require_data("legendaryking_cure_cost", true).data
		for i, v in ipairs(legendaryking_cure_cost) do
			if not ret[v.costType] then
				_ENV = ret[v.costType]
			end
			ret[v.costType] = ret[v.costType]
			ret[v.costType][v.armyLv] = v
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		local legendaryking_cure_cost = require_data("legendaryking_cure_cost", true).data
		for i, v in ipairs(legendaryking_cure_cost) do
			if not ret[v.costType] then
				_ENV = ret[v.costType]
			end
			ret[v.costType] = ret[v.costType]
			ret[v.costType][v.armyLv] = v
		end
		return ret
	end
	;(function()
		local _ENV, ret
		local legendaryking_cure_cost = require_data("legendaryking_cure_cost", true).data
		for i, v in ipairs(legendaryking_cure_cost) do
			if not ret[v.costType] then
				_ENV = ret[v.costType]
			end
			ret[v.costType] = ret[v.costType]
			ret[v.costType][v.armyLv] = v
		end
		return ret
	end)[1] = "soldier_quick_train"
	;(function()
		local _ENV, ret
		local legendaryking_cure_cost = require_data("legendaryking_cure_cost", true).data
		for i, v in ipairs(legendaryking_cure_cost) do
			if not ret[v.costType] then
				_ENV = ret[v.costType]
			end
			ret[v.costType] = ret[v.costType]
			ret[v.costType][v.armyLv] = v
		end
		return ret
	end)[2] = true
	armyltCtrl:defineValue("soldier_quick_train", function()
		local _ENV, ret
		local legendaryking_cure_cost = require_data("legendaryking_cure_cost", true).data
		for i, v in ipairs(legendaryking_cure_cost) do
			if not ret[v.costType] then
				_ENV = ret[v.costType]
			end
			ret[v.costType] = ret[v.costType]
			ret[v.costType][v.armyLv] = v
		end
		return ret
	end)
end
function armyltCtrl.getQuickTrainCfg()
	return armyltCtrl.soldier_quick_train
end
function armyltCtrl.armyAttr(armyid, attr)
	armyid = tonumber(armyid)
	local army = armyltCtrl.armyInfo[armyid]
	if army then
		local ret = army[attr]
		if ret then
			return ret
		else
			print("armyltCtrl.armyAttr attr not found attr=", attr)
		end
	else
		print("armyltCtrl.armyAttr armyid not found armyid=", armyid)
	end
end
function armyltCtrl.getArmyIDList(bid)
	local bid = tonumber(bid)
	local _ENV, ret = bid, bid
	for k, v in pairs(armyltCtrl.armyInfo) do
		if bid == armyltCtrl.armyAttr(k, ARMY_ATTR.BARRACK_ID) then
			table.insert(ret, k)
		end
	end
	return ret
end
function armyltCtrl.isArmyID(armyid)
	local armyid = tonumber(armyid)
	if armyltCtrl.armyInfo[armyid] and armyltCtrl.armyAttr(armyid, ARMY_ATTR.BARRACK_ID) ~= BUILDID.FORTRESS then
		return true
	end
	return false
end
function armyltCtrl.isWarframeArmyID(armyid)
	local armyid = tonumber(armyid)
	local armorType = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMORTYPE)
	if armyltCtrl.armyInfo[armyid] and armorType ~= 0 then
		return true, armorType
	end
	return false, armorType
end
function armyltCtrl.getTrainArmyIDList(bid, wlv, starLv)
	local getArmyLv = function(armyid)
		return armyid % 100
	end
	local getTrainArmy = function(bid, wlv, starLv)
		local _ENV, ret
		for k, v in ipairs(armyltCtrl.build_wlv_army_list[bid][wlv]) do
			local configStarlv = armyltCtrl.armyAttr(v, ARMY_ATTR.STAR_LEVEL)
			if configStarlv == 0 then
				table.insert(ret, v)
			end
			if 0 < configStarlv and configStarlv == starLv and ret[getArmyLv(v)] then
				ret[getArmyLv(v)] = v
			end
		end
		return ret
	end
	if not wlv or wlv < 0 then
		return armyltCtrl.biuld_army_list[bid]
	end
	if bid and wlv then
		return getTrainArmy(bid, wlv, starLv or 0)
	end
	_ENV = getTrainArmy
	return getTrainArmy
end
function armyltCtrl.getSoldierType(armyid)
	local armyType = armyltCtrl.armyAttr(armyid, ARMY_ATTR.ARMY_TYPE)
	if gArmyType.infantryDf == armyType or gArmyType.infantryAk == armyType then
		return gSoldierType.SOLDIER_TYPE_BUBING
	elseif gArmyType.cavalry == armyType or gArmyType.cavalryArrow == armyType then
		return gSoldierType.SOLDIER_TYPE_QIBING
	elseif gArmyType.archer == armyType or gArmyType.crossbow == armyType then
		return gSoldierType.SOLDIER_TYPE_GONGBING
	elseif gArmyType.charists == armyType or gArmyType.siegeVehicles == armyType then
		return gSoldierType.SOLDIER_TYPE_CHEBING
	elseif gArmyType.elite == armyType then
		return gSoldierType.SOLDIER_TYPE_ELITE
	end
end
function armyltCtrl.getArmySpecialityLv(speciality)
	if speciality then
		return armyltCtrl.armyspeciality[speciality].armyspecialityLv
	end
end
_ENV, armyltCtrl.getEliteAllAbility = function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end, function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end
;(function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end)[ARMY_ATTR.ATTACK] = "akPlus"
;(function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end)[ARMY_ATTR.DEFENSE] = "dfPlus"
;(function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end)[ARMY_ATTR.LIFE] = "hpPlus"
;(function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end)[ARMY_ATTR.STRIKE] = "critRate"
;(function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end)[ARMY_ATTR.SPEED] = "speedPlus"
local (function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end)[ARMY_ATTR.FREE_WEIGHT], armyAttr_armySpeciality = "freeWeightPlus", function(blv)
	local armyID = 0
	for k, v in pairs(armyltCtrl.armyReadInfo) do
		if BUILDID.ELITE_PALACE == v.barrackID and blv >= v.barrackLevel and armyID < v.armyID then
			armyID = v.armyID
		end
	end
	local ability = 0
	if 0 < armyID then
		local akPlus = armyltCtrl.mapArmySp[armyID].akPlus
		local dfPlus = armyltCtrl.mapArmySp[armyID].dfPlus
		local hpPlus = armyltCtrl.mapArmySp[armyID].hpPlus
		if 0 < akPlus and akPlus == dfPlus and dfPlus == hpPlus then
			ability = akPlus
		end
	end
	return ability
end
function armyltCtrl.getSpecialityAddition(armyID)
	local armyltCtrl, ret
	local info = armyltCtrl.mapArmySp[armyID]
	if info then
		for attr, key in pairs(armyAttr_armySpeciality) do
			local value = info[key]
			if "number" == type(value) then
				if 0 < value then
					ret[attr] = true
				else
					ret[attr] = false
				end
			elseif value then
				ret[attr] = true
			else
				ret[attr] = false
			end
		end
	end
	return ret
end
function armyltCtrl.getArmyTypeAndLv(armyid)
	armyid = tonumber(armyid)
	if not armyid then
		return
	end
	armyid = armyid % 1000
	local sType, lv = string.match(armyid, "(%d)(%d%d)")
	sType = tonumber(sType)
	lv = tonumber(lv)
	return sType, lv
end
function armyltCtrl.getArmyAttrAndSp(armyID, attrKey, extraAdd)
	local attr = armyltCtrl.armyAttr(armyID, attrKey) or 0
	if "number" ~= type(attr) then
		return attr
	end
	local sp = 0
	local spKey = armyAttr_armySpeciality[attrKey]
	if spKey then
		local spInfo = armyltCtrl.mapArmySp[armyID]
		if spInfo then
			sp = spInfo[spKey] or 0
		end
	end
	local total = attr
	local spRate = sp
	if extraAdd and 0 < extraAdd then
		sp = sp + extraAdd
	end
	if 0 < sp then
		sp = attr * (sp / 1000) * 10
		sp = tostring(sp)
		sp = tonumber(sp)
		sp = math.ceil(sp)
		sp = sp / 10
		total = total + sp
	end
	if 0 < spRate and sp == 0 then
		print("EX armyID: " .. tostring(armyID) .. "(" .. tostring(attrKey) .. ")")
	end
	return total
end
function armyltCtrl.getArmySp(armyID)
	return armyltCtrl.mapArmySp[armyID]
end
function armyltCtrl.getTrainCostElitePoint(armyID)
	return armyltCtrl.armyAttr(armyID, ARMY_ATTR.COST_ELITE_POINT)
end
function armyltCtrl.getDeadToElitePoint(armyID)
	return armyltCtrl.armyAttr(armyID, ARMY_ATTR.GET_ELITE_POINT)
end
function armyltCtrl.getMostAttrByBid(bid, attr)
	if armyltCtrl.mostAttarList and armyltCtrl.mostAttarList[tostring(bid)] then
		return armyltCtrl.mostAttarList[tostring(bid)][attr]
	end
	return 0
end
function armyltCtrl.getArmyBasePower(armyList)
	local armypower = 0
	for k, v in pairs(armyList) do
		local armyid = tonumber(v.id)
		local armycount = tonumber(v.num)
		local basepower = armyltCtrl.armyAttr(armyid, ARMY_ATTR.POWER) or 0
		armypower = armypower + basepower * armycount
	end
	return armypower
end
function armyltCtrl.getLegendarykingCureCostCfg(ctype, lv)
	return armyltCtrl.legendarykingCureCostCfg[ctype][lv]
end
init()
return armyltCtrl
