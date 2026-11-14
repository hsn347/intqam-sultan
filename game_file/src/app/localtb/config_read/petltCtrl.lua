local petltCtrl = include("aAReadClass").new()
function petltCtrl.init()
	petltCtrl:defineValue("petLevelConf", function()
		petltCtrl.petLevelConf, petltCtrl = nil, nil
		local pet_level_conf = require_once("app." .. LocalTblPath .. ".config_server.pet_level_conf")
		for k, v in pairs(pet_level_conf) do
			if not petltCtrl.petLevelConf[v.petid] then
				petltCtrl.petLevelConf[v.petid], petltCtrl = nil, nil
			end
			petltCtrl.petLevelConf[v.petid][v.lv] = v
		end
		return petltCtrl.petLevelConf
	end)
	petltCtrl:defineValue("petRankConf", function()
		petltCtrl.petRankConf, petltCtrl = nil, nil
		local pet_rank_conf = require_once("app." .. LocalTblPath .. ".config_server.pet_rank_conf")
		for k, v in pairs(pet_rank_conf) do
			if not petltCtrl.petRankConf[v.petid] then
				petltCtrl.petRankConf[v.petid], petltCtrl = nil, nil
			end
			petltCtrl.petRankConf[v.petid][v.rank] = v
		end
		return petltCtrl.petRankConf
	end)
	local createData = function(name)
		petltCtrl.petUnlockConf, petltCtrl, petltCtrl.petSort, petltCtrl = nil, nil, nil, nil
		local pet_unlock_conf = require_once("app." .. LocalTblPath .. ".config_server.pet_unlock_conf")
		table.sort(pet_unlock_conf, function(l, r)
			return l.order < r.order
		end)
		petltCtrl.petSort, petltCtrl = table.sort, table.sort
		for _, v in ipairs(pet_unlock_conf) do
			petltCtrl.petUnlockConf[v.petid] = v
			table.insert(petltCtrl.petSort, v.petid)
		end
		if name == "petSort" then
			return petltCtrl.petSort
		elseif name == "petUnlockConf" then
			return petltCtrl.petUnlockConf
		end
	end
	petltCtrl:defineValue("petSort", createData)
	petltCtrl:defineValue("petUnlockConf", createData)
	_UPVALUE2_ = createData
	createData[1] = "pet_upgrade_gold"
	createData[2] = true
	petltCtrl:defineValue("petUpgradeGold", createData)
end
function petltCtrl.getPetUnlockInfo(petid)
	return petltCtrl.petUnlockConf[petid]
end
function petltCtrl.getPetidIsExist(petid)
	for k, v in pairs(petltCtrl.petUnlockConf) do
		if petid == v.petid then
			return true
		end
	end
	return false
end
function petltCtrl.getDebrisidIsExist(debrisid)
	for k, v in pairs(petltCtrl.petUnlockConf) do
		if debrisid == v.debrisid then
			return true, v.petid
		end
	end
	return false
end
function petltCtrl.getPetLevConf(petid)
	return petltCtrl.petLevelConf[petid]
end
function petltCtrl.getPetMaxLev(petid)
	local maxLev = 0
	if petltCtrl.petLevelConf[petid] then
		for k, v in pairs(petltCtrl.petLevelConf[petid]) do
			if maxLev < v.lv then
				maxLev = v.lv
			end
		end
	end
	return maxLev
end
function petltCtrl.getPetMaxLevInRank(petid, rank)
	if petltCtrl.petRankConf[petid] and petltCtrl.petRankConf[petid][rank] then
		return petltCtrl.petRankConf[petid][rank].maxlv
	end
	return 0
end
function petltCtrl.getPetLevelPro(petid, lv, key)
	if petid and lv and key then
		if petltCtrl.petLevelConf[petid] then
			if petltCtrl.petLevelConf[petid][lv] then
				if petltCtrl.petLevelConf[petid][lv][key] then
					return petltCtrl.petLevelConf[petid][lv][key]
				else
					print("petltCtrl.getPetLevelPro key error", key)
				end
			else
				print("petltCtrl.getPetLevelPro lv error", lv)
			end
		else
			print("petltCtrl.getPetLevelPro petid error", petid)
		end
	else
		print("petltCtrl.getPetLevelPro petid,lv,key nil", petid, lv, key)
	end
end
function petltCtrl.getPetRankPro(petid, rank, key)
	if petid and rank and key then
		if petltCtrl.petRankConf[petid] then
			if petltCtrl.petRankConf[petid][rank] then
				if petltCtrl.petRankConf[petid][rank][key] then
					return petltCtrl.petRankConf[petid][rank][key]
				else
					print("petltCtrl.getPetRankPro key error", key)
				end
			else
				print("petltCtrl.getPetRankPro rank error", rank)
			end
		else
			print("petltCtrl.getPetRankPro petid error", petid)
		end
	else
		print("petltCtrl.getPetRankPro petid,rank,key nil", petid, rank, key)
	end
end
function petltCtrl.getPetCustomSort()
	return petltCtrl.petSort
end
function petltCtrl.getPetIDList()
	local petidlist = table.keys(petltCtrl.petLevelConf)
	return petidlist
end
function petltCtrl.getPetMapInfoList()
	local _ENV, ret
	for i, v in pairs(petltCtrl.getPetCustomSort()) do
		if petltCtrl.getPetidIsExist(tonumber(v)) then
			_ENV = tonumber(v)
			tonumber(v).pid = v
			tonumber(v).rankInfo = petltCtrl.getPetRankList(v)
			table.insert(ret, tonumber(v))
		end
	end
	return ret
end
function petltCtrl.getPetMaxRank(petid)
	local maxRank = 0
	local info = petltCtrl.petRankConf[petid]
	if info then
		for k, v in pairs(info) do
			if maxRank < v.rank then
				maxRank = v.rank
			end
		end
	end
	return maxRank
end
function petltCtrl.getPetMaxLvExpWithRankFromLv(petid, rank, curLv)
	local ret = 0
	local maxLv = petltCtrl.getPetRankPro(petid, rank, "maxlv")
	if maxLv then
		for i = curLv, maxLv - 1 do
			ret = ret + petltCtrl.getPetLevelPro(petid, i, "exp")
		end
	end
	return ret
end
function petltCtrl.getPetRankList(petid)
	local petltCtrl, ret
	local rankInfo = petltCtrl.petRankConf[petid]
	if rankInfo then
		for k, v in pairs(rankInfo) do
			petltCtrl = nil
			ret[v.rank], (nil).maxLv = nil, v.maxlv
		end
	end
	return ret
end
function petltCtrl.getPetTelentAndSecialSkill(petid, rank, lv)
	if not petltCtrl.petTelentAndSecialSkillCache then
		petltCtrl.petTelentAndSecialSkillCache, petltCtrl = petltCtrl.petTelentAndSecialSkillCache, petltCtrl.petTelentAndSecialSkillCache
	end
	_UPVALUE5_ = nil
	;(nil)[1] = petid
	;(nil)[2] = "_"
	;(nil)[3] = rank
	;(nil)[4] = "_"
	;(nil)[5] = lv
	local cacheKey = table.concat(nil)
	local ret = petltCtrl.petTelentAndSecialSkillCache[cacheKey]
	if ret then
		return ret
	end
	ret, petid.special_send, petltCtrl, petid.special_add, petltCtrl, petid.telent, petltCtrl, petltCtrl = petid, "_", "_", "_", "_", "_", "_", petid
	local talent_skill = petltCtrl.getPetLevelPro(petid, lv, gPetLevelConfKey.talent_skill)
	local special_skill_add = petltCtrl.getPetRankPro(petid, rank, gPetRankConfKey.special_skill_add)
	local special_skill_send = petltCtrl.getPetRankPro(petid, rank, gPetRankConfKey.special_skill_send)
	if talent_skill then
		for k, power in pairs(talent_skill) do
			local attrType = tonumber(string.sub(power, 1, 2))
			local valueType = tonumber(string.sub(power, 3, 4))
			local value = tonumber(string.sub(power, 5, string.len(power)))
			petltCtrl = string.sub(power, 5, string.len(power))
			string.sub(power, 5, string.len(power)).attrType = attrType
			string.sub(power, 5, string.len(power)).valueType = valueType
			string.sub(power, 5, string.len(power)).value = value
			string.sub(power, 5, string.len(power)).attrGroup = 1
			table.insert(ret.telent, string.sub(power, 5, string.len(power)))
		end
	end
	if special_skill_add then
		for k, power in pairs(special_skill_add) do
			local attrType = tonumber(string.sub(power, 1, 2))
			local valueType = tonumber(string.sub(power, 3, 4))
			local value = tonumber(string.sub(power, 5, string.len(power)))
			petltCtrl = string.sub(power, 5, string.len(power))
			string.sub(power, 5, string.len(power)).attrType = attrType
			string.sub(power, 5, string.len(power)).valueType = valueType
			string.sub(power, 5, string.len(power)).value = value
			string.sub(power, 5, string.len(power)).attrGroup = 2
			table.insert(ret.special_add, string.sub(power, 5, string.len(power)))
		end
	end
	if special_skill_send then
		_UPVALUE2_ = pairs(special_skill_add)
		pairs(special_skill_add)[1] = "goodid"
		pairs(special_skill_add)[2] = "count"
		local tb = serviceFunctions.tableFormat(special_skill_send, pairs(special_skill_add))
		for k, v in pairs(tb) do
			v.time = petltCtrl.getPetRankPro(petid, rank, gPetRankConfKey.special_skill_send_time)
			v.attrGroup = 3
			table.insert(ret.special_send, v)
		end
	end
	petltCtrl.petTelentAndSecialSkillCache[cacheKey] = ret
	return ret
end
function petltCtrl.getFeedGoldAddExp(goldtimes)
	if goldtimes > #petltCtrl.petUpgradeGold then
		goldtimes = #petltCtrl.petUpgradeGold
	end
	local info = petltCtrl.petUpgradeGold[goldtimes]
	return info.exp, info.gold
end
function petltCtrl.getTalentSkillUnlockLevel(petid, curLevel)
	local nums = table.nums(petltCtrl.getPetLevelPro(petid, curLevel, gPetLevelConfKey.talent_skill))
	for i = curLevel, #petltCtrl.petLevelConf[petid] do
		local talent_skill = petltCtrl.getPetLevelPro(petid, i, gPetLevelConfKey.talent_skill)
		if nums < #talent_skill then
			nums = #talent_skill
			return i
		end
	end
end
function petltCtrl.getTalentSkillUpgradeLevel(petid, curLevel, attrType)
	local curValue = 0
	local talent_skill = petltCtrl.getPetLevelPro(petid, curLevel, gPetLevelConfKey.talent_skill)
	if talent_skill then
		for k, power in pairs(talent_skill) do
			if attrType == tonumber(string.sub(power, 1, 2)) then
				curValue = tonumber(string.sub(power, 5, string.len(power)))
			end
		end
	end
	for i = curLevel, #petltCtrl.petLevelConf[petid] do
		local talent_skill = petltCtrl.getPetLevelPro(petid, i, gPetLevelConfKey.talent_skill)
		if talent_skill then
			for k, power in pairs(talent_skill) do
				local tp = tonumber(string.sub(power, 1, 2))
				if attrType == tp then
					local value = tonumber(string.sub(power, 5, string.len(power)))
					if curValue < value then
						return i, value
					end
				end
			end
		end
	end
end
function petltCtrl.getTalentSendUpgradeRank(petid, rank, data)
	local ranks = petltCtrl.petRankConf[petid]
	for key, value in pairs(ranks) do
		if rank < key then
			_UPVALUE2_ = nil
			;(nil)[1] = "goodid"
			;(nil)[2] = "count"
			local tb = serviceFunctions.tableFormat(value.special_skill_send, nil)
			for key2, value2 in pairs(tb) do
				if value2.goodid == data.goodid then
					local petDesRead = include("petDesRead")
					local attrStr, attrValue = petDesRead.getAttrStrAndValue(value2)
					return key, attrValue
				end
			end
		end
	end
end
function petltCtrl.getPetPowerByLvAndRank(petid, lv, rank)
	local rankInfo = petltCtrl.petRankConf[petid][rank]
	local levelInfo = petltCtrl.petLevelConf[petid][lv]
	if not rankInfo or not levelInfo then
		return 0
	end
	return rankInfo.power + levelInfo.power
end
petltCtrl.init()
return petltCtrl
