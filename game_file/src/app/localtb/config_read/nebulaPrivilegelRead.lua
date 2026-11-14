local nebulaPrivilegelRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebula_officer_config"
;(nil)[2] = false
nebulaPrivilegelRead:defineValue("config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_officer_describe"
;(nil)[2] = false
nebulaPrivilegelRead:defineValue("describe", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nebula_officer_award"
;(nil)[2] = true
nebulaPrivilegelRead:defineValue("award", nil)
nebulaPrivilegelRead:defineValue("officers", function()
	local _ENV, officers
	for _, v in ipairs(nebulaPrivilegelRead.describe) do
		local rounds = officers[v.round]
		if not rounds then
			rounds, _ENV = nil, nil
			officers[v.round] = rounds
		end
		v.officerpos = "officerpos" .. v.pos
		rounds[#rounds + 1] = v
	end
	return officers
end)
nebulaPrivilegelRead:defineValue("awards", function()
	local _ENV, ret
	for _, v in ipairs(nebulaPrivilegelRead.award) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		local classType = v.classType or 1
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		if not ret[classType][v.round] then
			_ENV = ret[classType][v.round]
		end
		ret[classType][v.round] = ret[classType][v.round]
		table.insert(ret[classType][v.round], v)
	end
	return ret
end)
nebulaPrivilegelRead:defineValue("officerInfo", function()
	local _ENV, officers
	for _, v in pairs(nebulaPrivilegelRead.describe) do
		officers[v.officerID] = v
	end
	return officers
end)
function nebulaPrivilegelRead.getOfficers(round)
	if not nebulaPrivilegelRead.officers[round] then
		nebulaPrivilegelRead = nebulaPrivilegelRead.officers[round]
	end
	return nebulaPrivilegelRead.officers[round]
end
function nebulaPrivilegelRead.getOfficerInfo(officerID)
	return nebulaPrivilegelRead.officerInfo[officerID]
end
function nebulaPrivilegelRead.getOfficialName(officerID)
	local info = nebulaPrivilegelRead.officerInfo[officerID]
	return info and info.name
end
function nebulaPrivilegelRead.getOfficialImg2(officerID)
	local cfg = nebulaPrivilegelRead.officerInfo[officerID]
	return cfg.img2
end
function nebulaPrivilegelRead.getOfficialPos(officerID)
	local cfg = nebulaPrivilegelRead.officerInfo[officerID]
	return cfg.pos
end
function nebulaPrivilegelRead.getBufferName(bufferId)
	local buffItem = nebulaPrivilegelRead.config[bufferId]
	if buffItem then
		return i18n(buffItem.buffDes), buffItem.type
	end
end
function nebulaPrivilegelRead.getOfficialDes(officerID)
	local cfg = nebulaPrivilegelRead.getOfficerInfo(officerID)
	return i18n(cfg.officerDes)
end
function nebulaPrivilegelRead.getAllBuffList()
	return nebulaPrivilegelRead.officerInfo
end
function nebulaPrivilegelRead.getOfficerAward(round)
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local config = nebulaPrivilegelRead.awards[group]
	config = config or nebulaPrivilegelRead.awards[1]
	if not config[round] then
		_ENV = config[round]
	end
	return config[round]
end
function nebulaPrivilegelRead.getOfficerAwardNew(round)
	local _ENV, ret
	local nebulaWarUtil = include("nebulaWarUtil")
	local isCampeType1 = nebulaWarUtil.checkSelfCampType1()
	local awards = nebulaPrivilegelRead.getOfficerAward(round)
	for __, cfg in ipairs(awards) do
		local officer = nebulaPrivilegelRead.getOfficerInfo(cfg.appointID)
		local campType = officer.campType
		if campType == 0 then
			table.insert(ret, cfg)
		elseif campType == 1 then
			if not isCampeType1 then
				table.insert(ret, cfg)
			end
		elseif campType == 2 and isCampeType1 then
			table.insert(ret, cfg)
		end
	end
	return ret
end
function nebulaPrivilegelRead.getPackageName(giftID)
	for _, v in ipairs(nebulaPrivilegelRead.award) do
		if v.treasureID == giftID then
			return i18n(v.name)
		end
	end
end
function nebulaPrivilegelRead.getOfficialNameByGiftID(giftID)
	for _, v in ipairs(nebulaPrivilegelRead.award) do
		if v.treasureID == giftID then
			return nebulaPrivilegelRead.getOfficialName(v.appointID)
		end
	end
end
nebulaPrivilegelRead:defineValue("appointIDMap", function()
	local _ENV, ret
	for _, v in ipairs(nebulaPrivilegelRead.describe) do
		if not ret[v.appointID] then
			_ENV = ret[v.appointID]
		end
		ret[v.appointID] = ret[v.appointID]
		table.insert(ret[v.appointID], v.officerID)
	end
	return ret
end)
function nebulaPrivilegelRead.checkIsAppointID(officerID)
	local idList = nebulaPrivilegelRead.getOfficerIDList(officerID)
	return idList ~= nil
end
function nebulaPrivilegelRead.getOfficerIDList(appointID)
	return nebulaPrivilegelRead.appointIDMap[appointID]
end
return nebulaPrivilegelRead
