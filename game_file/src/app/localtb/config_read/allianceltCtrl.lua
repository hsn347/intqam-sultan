local allianceltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	allianceltCtrl:defineValue("allianceItemList", function()
		local _ENV, allianceItemList
		local iteminfo = require_once("app." .. LocalTblPath .. ".config_server.alliance_item_list")
		for i, v in ipairs(iteminfo) do
			allianceItemList[v.itemID] = v
		end
		return allianceItemList
	end)
	allianceltCtrl:defineValue("aScienceStar", function()
		local sciencestar = require_once("app." .. LocalTblPath .. ".config_server.alliance_science_lv_star")
		local _ENV, aScienceStar = "app." .. LocalTblPath .. ".config_server.alliance_science_lv_star", "app." .. LocalTblPath .. ".config_server.alliance_science_lv_star"
		for _, v in ipairs(sciencestar) do
			if not aScienceStar[v.id] then
				aScienceStar[v.id], _ENV = nil, nil
			end
			if not aScienceStar[v.id][v.level] then
				aScienceStar[v.id][v.level], _ENV = nil, nil
			end
			aScienceStar[v.id][v.level][v.star] = v
		end
		return aScienceStar
	end)
	allianceltCtrl:defineValue("allanceScienceLv", function()
		local sciencelv = require_once("app." .. LocalTblPath .. ".config_server.alliance_science_lv")
		local _ENV, allanceScienceLv = "app." .. LocalTblPath .. ".config_server.alliance_science_lv", "app." .. LocalTblPath .. ".config_server.alliance_science_lv"
		for _, v in ipairs(sciencelv) do
			if not allanceScienceLv[v.id] then
				allanceScienceLv[v.id], _ENV = nil, nil
			end
			allanceScienceLv[v.id][v.level] = v
		end
		return allanceScienceLv
	end)
	allianceltCtrl:defineValue("allanceScienceInfo", function()
		local scienceinfo = require_once("app." .. LocalTblPath .. ".config_server.alliance_science_info")
		local _ENV, allanceScienceInfo = "app." .. LocalTblPath .. ".config_server.alliance_science_info", "app." .. LocalTblPath .. ".config_server.alliance_science_info"
		for _, v in ipairs(scienceinfo) do
			allanceScienceInfo[v.id] = v
		end
		return allanceScienceInfo
	end)
	allianceltCtrl:defineValue("allanceCorpsUnlockInfo", function()
		local unlockinfo = require_once("app." .. LocalTblPath .. ".config_server.unlocking_corps")
		local _ENV, allanceCorpsUnlockInfo = "app." .. LocalTblPath .. ".config_server.unlocking_corps", "app." .. LocalTblPath .. ".config_server.unlocking_corps"
		for _, v in ipairs(unlockinfo) do
			allanceCorpsUnlockInfo[v.corps] = v
		end
		return allanceCorpsUnlockInfo
	end)
end
init()
function allianceltCtrl:getCorpsCount()
	return #allianceltCtrl.allanceCorpsUnlockInfo
end
function allianceltCtrl:getLegionUnlock(index)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local ret = false
	local ssdata = allianceltCtrl.allanceCorpsUnlockInfo[index].condition
	if 0 < #ssdata then
		local sdata = allianceScience:getScienceData(ssdata[1])
		if sdata then
			ret = sdata.lv >= ssdata[2]
		else
			ret = false
		end
	else
		ret = true
	end
	return ret, ssdata
end
function allianceltCtrl.getAllianceItemList()
	local _ENV, ret
	local keys = table.keys(allianceltCtrl.allianceItemList)
	table.sort(keys)
	for k, v in pairs(keys) do
		local item = allianceltCtrl.allianceItemList[v]
		table.insert(ret, item)
	end
	return ret
end
function allianceltCtrl.getPrice(itemid, priceType)
	local item = allianceltCtrl.allianceItemList[itemid]
	local price = item.priceBonus
	if priceType == gIDDef.ALLIANCE_HONOR then
		price = item.priceHonor
	end
	return price
end
function allianceltCtrl:getMaxBuyCount(itemid)
	local item = allianceltCtrl.allianceItemList[tonumber(itemid)]
	if item.max == 0 then
		return
	else
		return item.max
	end
end
function allianceltCtrl.scienceAttr(id, attr)
	local sciencecell = allianceltCtrl.allanceScienceInfo[id]
	if sciencecell then
		local ret = sciencecell[attr]
		if ret then
			return ret
		else
		end
	else
	end
end
function allianceltCtrl.scienceLvInfo(id, lv, key)
	local sciencecell = allianceltCtrl.allanceScienceLv[id]
	if sciencecell then
		local lvinfo = sciencecell[lv]
		if lvinfo then
			local ret = lvinfo[key]
			if ret then
				return ret
			else
			end
		else
		end
	else
	end
end
function allianceltCtrl.getScienceIDListByScitype(scitype)
	local _ENV, ret
	for k, v in pairs(allianceltCtrl.allanceScienceInfo) do
		if v.sciType == scitype then
			table.insert(ret, v.id)
		end
	end
	return ret
end
function allianceltCtrl.getScienceIDList(groupid)
	local _ENV, ret
	for id, sciencecell in pairs(allianceltCtrl.allanceScienceInfo) do
		if sciencecell.group == groupid then
			table.insert(ret, id)
		end
	end
	return ret
end
local getCostRes = function(usetb, resid)
	for i = 1, #usetb / 3 do
		local id = usetb[3 * i - 2]
		local count = usetb[3 * i - 1]
		if id == resid then
			return count
		end
	end
end
function allianceltCtrl.getDonateCost(sciid, scilv, donatetype, resid)
	local count
	if donatetype == gAScienceDonateType.Middle then
		local middleuse = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.MIDDLE_USE)
		count = getCostRes(middleuse, resid)
	elseif donatetype == gAScienceDonateType.Senior then
		local senioruse = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.SENIOR_USE)
		count = getCostRes(senioruse, resid)
	elseif donatetype == gAScienceDonateType.Junior then
		local senioruse = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.JUNIOR_USE)
		count = getCostRes(senioruse, resid)
	end
	return count
end
function allianceltCtrl.getSciPoint(sciid, scilv, donatetype)
	local ret = 0
	if donatetype == gAScienceDonateType.Junior then
		ret = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.JUNIOR_SCI_POINT)
	elseif donatetype == gAScienceDonateType.Middle then
		ret = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.MIDDLE_SCI_POINT)
	elseif donatetype == gAScienceDonateType.Senior then
		ret = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.SENIOR_SCI_POINT)
	end
	return ret
end
function allianceltCtrl.getHonor(sciid, scilv, donatetype)
	local ret = 0
	if donatetype == gAScienceDonateType.Junior then
		ret = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.JUNIOR_HONOR)
	elseif donatetype == gAScienceDonateType.Middle then
		ret = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.MIDDLE_HONOR)
	elseif donatetype == gAScienceDonateType.Senior then
		ret = allianceltCtrl.scienceLvInfo(sciid, scilv, gAScienceLv.SENIOR_HONOR)
	end
	return ret
end
function allianceltCtrl.getSciStarLvUpNeedPoint(sciid, scilv, star)
	local ret = allianceltCtrl.aScienceStar[sciid][scilv][star]
	if ret and next(ret) then
		return ret.point
	else
		return nil
	end
end
function allianceltCtrl.getSciStarLvUpCanSpeed(sciid, scilv, star)
	local ret = allianceltCtrl.aScienceStar[sciid][scilv][star]
	if ret and next(ret) then
		return ret.speedUp
	else
		return nil
	end
end
function allianceltCtrl.getScienceValue(sid, lv)
	local sid = tonumber(sid)
	local power = allianceltCtrl.scienceLvInfo(sid, lv, gAScienceLv.TECHNOLOTY_POWER)
	if power then
		local dtype = string.sub(power, 3, 4)
		local retvalue = tonumber(string.sub(power, 5, 10))
		if tonumber(dtype) == 1 then
			return tonumber(dtype), retvalue / 1000
		else
			return tonumber(dtype), retvalue
		end
	end
end
function allianceltCtrl.getSciIDListBySciType(scitype)
	local _ENV, ret
	for k, v in pairs(allianceltCtrl.allanceScienceInfo) do
		if tonumber(v.sciType) == scitype then
			table.insert(ret, k)
		end
	end
	return ret
end
function allianceltCtrl.getProsperityDonateInfo(...)
	local alliance_prosperous = require_data("alliance_prosperous", true).data
	return alliance_prosperous[1]
end
function allianceltCtrl.getProsperityDonateCost(useData, resid)
	return getCostRes(useData, resid)
end
return allianceltCtrl
