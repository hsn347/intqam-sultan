local specializationRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	specializationRead:defineValue("MASTERY_STATE", function()
		_UPVALUE0_ = nil
		;(nil).lock = 1
		;(nil).canLock = 2
		;(nil).normal = 3
		;(nil).canUpgrade = 4
		;(nil).canStars = 5
		;(nil).upgrading = 6
		;(nil).invalid = 7
		;(nil).canUpgradeAndStars = 8
		return nil
	end)
	local createData = function(name)
		specializationRead.mid2bid, specializationRead, specializationRead.confData, specializationRead = nil, nil, nil, nil
		local conf = require_data("specialization_conf", true, true)
		for i, v in ipairs(conf.data) do
			if not specializationRead.confData[v.building] then
				specializationRead.confData[v.building], specializationRead = nil, nil
			end
			specializationRead.confData[v.building][v.level] = v
			specializationRead.mid2bid[v.mastery] = v.building
		end
		if name == "confData" then
			return specializationRead.confData
		elseif name == "mid2bid" then
			return specializationRead.mid2bid
		end
	end
	specializationRead:defineValue("confData", createData)
	specializationRead:defineValue("mid2bid", createData)
	specializationRead:defineValue("addingData", function()
		specializationRead.addingData, specializationRead = nil, nil
		local adding = require_data("specialization_adding", true, true)
		local specializationRead, addingData = "specialization_adding", "specialization_adding"
		for i, v in ipairs(adding.data) do
			if not addingData[v.mastery] then
				addingData[v.mastery], specializationRead = nil, nil
			end
			local specializationRead, data = v.mastery, v.mastery
			data.buffID = v.buffID
			local isExist = false
			for m, n in ipairs(addingData[v.mastery]) do
				if n.buffID == v.buffID then
					data = n
					isExist = true
					break
				end
			end
			data[v.level] = v
			if not isExist then
				table.insert(addingData[v.mastery], data)
			end
		end
		specializationRead.addingData = addingData
		return specializationRead.addingData
	end)
	specializationRead:defineValue("resetData", function()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end)
	function specializationRead()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end
	;(function()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end)[1] = "specialization_des"
	specializationRead:defineValue("buffData", function()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end)
	function specializationRead()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end
	;(function()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end)[1] = "specialization_build"
	specializationRead:defineValue("buildData", function()
		specializationRead.resetData, specializationRead = nil, nil
		local reset = require_data("specialization_reset", true, true)
		for i, v in ipairs(reset.data) do
			specializationRead.resetData[v.count] = v.cost
		end
		return specializationRead.resetData
	end)
end
init()
function specializationRead.getMasteryState(bid, mid)
	mid = mid or specializationRead.getMasteryID(bid)
	local MASTERY_STATE = specializationRead.MASTERY_STATE
	local state = MASTERY_STATE.normal
	local sortWeight = 2
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local masteryData = cityCtrl:getMasteryByMid(mid)
	local cbid = specializationRead.getCondBuildingID(bid)
	local lv, iid = cityCtrl:getBuildMaxLv(cbid)
	if not masteryData then
		local needLv = specializationRead.getCondBuildingLv(bid)
		if lv < needLv then
			state = MASTERY_STATE.lock
			sortWeight = 3
		else
			state = MASTERY_STATE.canLock
			sortWeight = 1
		end
	else
		local needLv = specializationRead.getCondBuildingLv(bid, masteryData.lev)
		if lv < needLv then
			state = MASTERY_STATE.invalid
		elseif masteryData.star > 0 and lv > needLv then
			state = MASTERY_STATE.canUpgradeAndStars
		elseif masteryData.star > 0 then
			state = MASTERY_STATE.canStars
		elseif lv > needLv then
			state = MASTERY_STATE.canUpgrade
		end
	end
	return state, sortWeight
end
function specializationRead.getResetCost(count)
	return specializationRead.resetData[count] or 0
end
function specializationRead.getMasteryList()
	if not specializationRead.masteryList then
		specializationRead.masteryList, specializationRead = specializationRead.masteryList, specializationRead.masteryList
		for k, v in pairs(specializationRead.confData) do
			local bid = v[1].building
			specializationRead = nil
			;(nil).mastery = v[1].mastery
			;(nil).building = bid
			;(nil).order = specializationRead.getMasteryOrder(bid)
			table.insert(specializationRead.masteryList, nil)
		end
	end
	return specializationRead.masteryList
end
function specializationRead.getMasteryData(bid, lv)
	local data = specializationRead.confData[bid]
	return data and data[lv] and data[lv]
end
function specializationRead.getMasteryFighting(bid, lv)
	local data = specializationRead.confData[bid]
	return data and data[lv] and data[lv].fighting
end
function specializationRead.getCondBuildingLv(bid, lv)
	lv = lv or 1
	local data = specializationRead.confData[bid]
	return data and data[lv] and data[lv].buildingLvl[2] or data and data[1].buildingLvl[2]
end
function specializationRead.getCondBuildingID(bid)
	local data = specializationRead.confData[bid]
	return data and data[1].buildingLvl[1]
end
function specializationRead.getCondTime(bid, lv)
	local data = specializationRead.confData[bid]
	return data and data[lv] and data[lv].time
end
function specializationRead.getMasteryID(bid)
	local data = specializationRead.confData[bid]
	return data and data[1].mastery
end
function specializationRead.getBuildID(mid)
	return specializationRead.mid2bid[mid]
end
function specializationRead.getMasteryBuffID(mid, index)
	return specializationRead.addingData[mid][index].buffID
end
function specializationRead.getMasteryBuffInfo(mid, buffID)
	for i, v in ipairs(specializationRead.addingData[mid]) do
		if v.buffID == buffID then
			return v
		end
	end
end
function specializationRead.getMasteryBuffValue(mid, buffID, lv)
	local value, __ = specializationRead.getMasteryBuffAdd(mid, buffID, lv)
	local buffDesRead = include("buffDesRead")
	return buffDesRead.getTitleValueWithValue(buffID, value)
end
function specializationRead.getMasteryBuffAdd(mid, buffID, lv)
	local buffInfo = specializationRead.getMasteryBuffInfo(mid, buffID)
	local value = buffInfo and buffInfo[lv] and buffInfo[lv].effect[2] or 0
	local valueType = buffInfo and buffInfo[lv] and buffInfo[lv].effect[1]
	return value, valueType
end
function specializationRead.getMasteryMaxLv(bid)
	local data = specializationRead.confData[bid]
	return data and #data
end
function specializationRead.checkMasteryCanUnLock(...)
	local masteryList = clone(specializationRead.getMasteryList())
	table.sort(masteryList, function(a, b)
		return a.mastery < b.mastery
	end)
	for i, v in ipairs(masteryList) do
		local bid = v.building
		local mid = v.mastery
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local masteryData = cityCtrl:getMasteryByMid(mid)
		if not masteryData then
			local lv, __ = cityCtrl:getBuildMaxLv(bid)
			local needLv = specializationRead.getCondBuildingLv(bid)
			if lv >= needLv then
				return true, mid
			end
		end
	end
	return false
end
function specializationRead.getSkillPopViewBuffDes(buffID)
	_ENV = nil
	;(nil)[309] = "specialization_text_16"
	;(nil)[310] = "specialization_text_17"
	local (nil)[311], specialDes = "specialization_text_18", nil
	return specialDes[buffID] and i18n(specialDes[buffID]) or specializationRead.getBuffDesBase(buffID)
end
function specializationRead.getBuffDesBase(buffID)
	local data = specializationRead.buffData[buffID]
	return data and data.buffDes and i18n(data.buffDes)
end
function specializationRead.getBuffIcon(buffID)
	print("specializationRead.getBuffIcon", buffID)
	local data = specializationRead.buffData[buffID]
	return data and data.icon or "icon_specialization_16.png"
end
function specializationRead.getMasteryName(bid)
	local data = specializationRead.buildData[bid]
	return data and data.masteryName and i18n(data.masteryName)
end
function specializationRead.getBuildIcon(bid)
	local data = specializationRead.buildData[bid]
	if data then
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
			return data.buildIconByzantine
		else
			return data.buildIcon
		end
	end
end
function specializationRead.getMasteryOrder(bid)
	local data = specializationRead.buildData[bid]
	return data and data.order or 0
end
function specializationRead.getStartIcon(lv)
	if 1 <= lv and lv <= 4 then
		return "icon_specialization_01.png"
	elseif 5 <= lv and lv <= 9 then
		return "icon_specialization_02.png"
	elseif 10 <= lv and lv <= 14 then
		return "icon_specialization_03.png"
	elseif 15 <= lv and lv <= 19 then
		return "icon_specialization_04.png"
	elseif 20 <= lv then
		return "icon_specialization_05.png"
	end
	return "icon_specialization_01.png"
end
function specializationRead.getUpgradeViewBg(bid)
	local buildType = SoraDGetBuildTypeByBid(bid)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		if buildType == 1 then
			return "bg_jzzj_hstd.png"
		else
			return "bg_jzzj_lstybj.png"
		end
	elseif buildType == 1 then
		return "bg_jzzj_lscd.png"
	else
		return "bg_jzzj_hstybj.png"
	end
end
return specializationRead
