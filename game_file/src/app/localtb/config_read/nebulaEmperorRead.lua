local nebulaEmperorRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "nebulaemperorconstant"
;(nil)[2] = true
nebulaEmperorRead:defineValue("constantTable", nil)
function nebulaEmperorRead.getConstValue(key, defaultValue)
	local info = nebulaEmperorRead.constantTable[key]
	local value = info and info.value and info.value[1]
	if value then
		return value
	end
	return defaultValue
end
function nebulaEmperorRead.getTeamNumMax()
	return nebulaEmperorRead.getConstValue("teamNumMax", 200)
end
function nebulaEmperorRead.getTeamCommandMax()
	return nebulaEmperorRead.getConstValue("headmanNum", 4)
end
function nebulaEmperorRead.getTeamAssemblerMax()
	return nebulaEmperorRead.getConstValue("initiateNum", 10)
end
function nebulaEmperorRead.getTreatmentCost()
	return nebulaEmperorRead.getConstValue("treatmentCost", 50)
end
function nebulaEmperorRead.getTreatmentSpeed()
	return nebulaEmperorRead.getConstValue("treatmentSpeed", 2)
end
function nebulaEmperorRead.getNeedLv(...)
	return nebulaEmperorRead.getConstValue("needLv", 54)
end
function nebulaEmperorRead.getPalaceEnergyMax(...)
	return nebulaEmperorRead.getConstValue("energyMax", 10000)
end
function nebulaEmperorRead.getAreaEnergyMax(...)
	return nebulaEmperorRead.getConstValue("getEnergyMax", 1000)
end
function nebulaEmperorRead.getDonateGoldMax(...)
	return nebulaEmperorRead.getConstValue("donateGoldMax", 1000)
end
local createData = function(name)
	local _ENV, config
	local _ENV, buildIDList
	local nebulaemperorbuild = require_data("nebulaemperorbuild", true, true).data
	for i, v in ipairs(nebulaemperorbuild) do
		config[v.buildID] = v
		if not buildIDList[v.buildtype] then
			_ENV = buildIDList[v.buildtype]
		end
		buildIDList[v.buildtype] = buildIDList[v.buildtype]
		table.insert(buildIDList[v.buildtype], v.buildID)
	end
	nebulaEmperorRead.nebulaemperorbuild = config
	for __, v in pairs(buildIDList) do
		table.sort(v, function(a, b)
			local dataA = nebulaEmperorRead.nebulaemperorbuild[a]
			local dataB = nebulaEmperorRead.nebulaemperorbuild[b]
			if dataA.x ~= dataB.x then
				return dataA.x < dataB.x
			end
			return dataA.y < dataB.y
		end)
	end
	nebulaEmperorRead.buildIDList = buildIDList
	if name == "nebulaemperorbuild" then
		return nebulaEmperorRead.nebulaemperorbuild
	elseif name == "buildIDList" then
		return nebulaEmperorRead.buildIDList
	end
end
nebulaEmperorRead:defineValue("nebulaemperorbuild", createData)
nebulaEmperorRead:defineValue("buildIDList", createData)
function nebulaEmperorRead.getBuildConfig(buildID)
	return nebulaEmperorRead.nebulaemperorbuild[buildID]
end
function nebulaEmperorRead.getBuildName(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg and i18n(cfg.name)
end
function nebulaEmperorRead.getBuildImage(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg.image
end
function nebulaEmperorRead.getBuildType(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg.buildtype
end
function nebulaEmperorRead.getBuildSize(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg.size
end
function nebulaEmperorRead.getBuildIconLod(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg.iconLod
end
function nebulaEmperorRead.getBuildCamp(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg.camp
end
function nebulaEmperorRead.getBuildPos(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cc.p(cfg.x, cfg.y)
end
function nebulaEmperorRead.getBuildIcon(buildID)
	local cfg = nebulaEmperorRead.getBuildConfig(buildID)
	return cfg.icon
end
function nebulaEmperorRead.getBuildNameByType(buildType)
	local buildIDList = nebulaEmperorRead.getBuildIDListByType(buildType)
	local buildID = buildIDList[1]
	if buildID then
		return nebulaEmperorRead.getBuildName(buildID)
	end
end
function nebulaEmperorRead.getBuildIDListByType(buildType)
	if not nebulaEmperorRead.buildIDList[buildType] then
		nebulaEmperorRead = nebulaEmperorRead.buildIDList[buildType]
	end
	return nebulaEmperorRead.buildIDList[buildType]
end
_UPVALUE2_ = createData
createData[1] = "nebulaemperorbuff"
createData[2] = true
nebulaEmperorRead:defineValue("nebulaemperorbuff", createData)
function nebulaEmperorRead.getEnergyBuff()
	return nebulaEmperorRead.nebulaemperorbuff
end
function nebulaEmperorRead.getEnergyBuffIDList()
	return table.ikeys(nebulaEmperorRead.nebulaemperorbuff)
end
function nebulaEmperorRead.getEnergyBuffConfig(buffID)
	return nebulaEmperorRead.nebulaemperorbuff[buffID]
end
function nebulaEmperorRead.getEnergyBuffName(buffID)
	local cfg = nebulaEmperorRead.getEnergyBuffConfig(buffID)
	return i18n(cfg.name)
end
_UPVALUE2_ = createData
createData[1] = "nebulaemperortitle"
createData[2] = true
nebulaEmperorRead:defineValue("nebulaemperortitle", createData)
function nebulaEmperorRead.getOfficerList(buffType)
	local _ENV, ret
	for i, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		if not buffType or buffType == v.buffType then
			table.insert(ret, v.type)
		end
	end
	return ret
end
function nebulaEmperorRead.getOfficerConfig(officerID)
	return nebulaEmperorRead.nebulaemperortitle[officerID]
end
function nebulaEmperorRead.getOfficerName(officerID)
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	return i18n(cfg.name)
end
function nebulaEmperorRead.getOfficerType(officerID)
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	return cfg.buffType
end
function nebulaEmperorRead.getOfficerImg(officerID)
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	return cfg.img
end
function nebulaEmperorRead.getOfficerImg2(officerID)
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	return cfg.img2
end
function nebulaEmperorRead.getOfficerBuff(officerID)
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	return cfg.buff
end
function nebulaEmperorRead.getOfficerBuffMailDes(officerID)
	local privileges = ""
	local buffArray = nebulaEmperorRead.getOfficerBuff(officerID)
	for i, buff in ipairs(buffArray) do
		local buffName = nebulaEmperorRead.getBufferName(buff)
		if i ~= 1 then
			privileges = privileges .. "\n"
		end
		privileges = privileges .. buffName
	end
	return privileges
end
function nebulaEmperorRead.getBuffDesTbById(officerID)
	local buffArray = nebulaEmperorRead.getOfficerBuff(officerID)
	local nebulaEmperorRead, ret = officerID, officerID
	for __, buff in ipairs(buffArray) do
		local buffName = nebulaEmperorRead.getBufferName(buff)
		table.insert(ret, buffName)
	end
	return ret
end
nebulaEmperorRead:defineValue("buff", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getTitleBuff(title, buffType)
	if title and buffType then
		return nebulaEmperorRead.buff[title] and nebulaEmperorRead.buff[title][buffType] or 0
	end
end
function _UPVALUE1_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperortitledes"
nebulaEmperorRead:defineValue("nebulaemperortitledes", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getBufferConfig(bufferId)
	return nebulaEmperorRead.nebulaemperortitledes[bufferId]
end
function nebulaEmperorRead.getBufferName(bufferId)
	local cfg = nebulaEmperorRead.getBufferConfig(bufferId)
	if cfg then
		return i18n(cfg.buffDes)
	else
		return bufferId
	end
end
function _UPVALUE2_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperorscore"
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[2] = true
nebulaEmperorRead:defineValue("nebulaemperorscore", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getRankHelpScoreList(...)
	return nebulaEmperorRead.nebulaemperorscore
end
function _UPVALUE1_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperordonatedes"
nebulaEmperorRead:defineValue("nebulaemperordonatedes", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getDonateSkillConfig(...)
	return nebulaEmperorRead.nebulaemperordonatedes[1]
end
function _UPVALUE2_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperordonate"
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[2] = true
nebulaEmperorRead:defineValue("nebulaemperordonate", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getDonateGoldConfig(grade)
	grade = math.min(grade, nebulaEmperorRead.getDonateLvMax())
	return nebulaEmperorRead.nebulaemperordonate[grade]
end
function nebulaEmperorRead.getDonateLvMax()
	return #nebulaEmperorRead.nebulaemperordonate
end
function nebulaEmperorRead.getDonateLv(value)
	for i, v in ipairs(nebulaEmperorRead.nebulaemperordonate) do
		if value < v.needGold then
			return i - 1
		end
	end
	return nebulaEmperorRead.getDonateLvMax()
end
function nebulaEmperorRead.isDonateLvMax(grade)
	return grade >= nebulaEmperorRead.getDonateLvMax()
end
function nebulaEmperorRead.getDonateNeedGold(grade)
	local cfg = nebulaEmperorRead.getDonateGoldConfig(grade)
	return cfg and cfg.needGold or 0
end
function nebulaEmperorRead.getDonateSkillDes(grade)
	local cfg = nebulaEmperorRead.getDonateGoldConfig(grade)
	return i18n(cfg and cfg.text)
end
function _UPVALUE2_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperordonaterewards"
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[2] = true
nebulaEmperorRead:defineValue("nebulaemperordonaterewards", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getDonateRewardConfig(grade)
	return nebulaEmperorRead.nebulaemperordonaterewards[grade]
end
function nebulaEmperorRead.getDonateRewardMax()
	return #nebulaEmperorRead.nebulaemperordonaterewards
end
function nebulaEmperorRead.getDonateRewardNeedGold(grade)
	local cfg = nebulaEmperorRead.getDonateRewardConfig(grade)
	return cfg.needGold
end
function nebulaEmperorRead.getDonateRewardNeedGoldMax()
	local gradeMax = nebulaEmperorRead.getDonateRewardMax()
	return nebulaEmperorRead.getDonateRewardNeedGold(gradeMax)
end
function nebulaEmperorRead.getDonateRewards(grade)
	local cfg = nebulaEmperorRead.getDonateRewardConfig(grade)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.rewards, nil)
end
function nebulaEmperorRead.getDonateRewardGoldPercent(totalGold)
	local gradeMax = nebulaEmperorRead.getDonateRewardMax()
	local _needGold = 0
	for i, v in ipairs(nebulaEmperorRead.nebulaemperordonaterewards) do
		if totalGold < v.needGold then
			local percent = v.grade / gradeMax - (v.needGold - totalGold) / (v.needGold - _needGold) / gradeMax
			return percent
		end
		_needGold = v.needGold
	end
	return 1
end
function nebulaEmperorRead.getDonateRewardFrame(grade)
	local cfg = nebulaEmperorRead.getDonateRewardConfig(grade)
	return cfg.frame
end
function _UPVALUE2_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperoraward"
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[2] = true
nebulaEmperorRead:defineValue("nebulaemperoraward", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getPackageConfig(giftID)
	return nebulaEmperorRead.nebulaemperoraward[giftID]
end
function nebulaEmperorRead.getPackageName(giftID)
	local cfg = nebulaEmperorRead.getPackageConfig(giftID)
	return i18n(cfg.name)
end
function nebulaEmperorRead.getOfficerAward(...)
	return nebulaEmperorRead.nebulaemperoraward
end
function nebulaEmperorRead.getPackageList(...)
	return table.ikeys(nebulaEmperorRead.nebulaemperoraward)
end
function _UPVALUE2_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperorrevive"
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[2] = true
nebulaEmperorRead:defineValue("nebulaemperorrevive", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getNeedSoulNum(lv)
	local needSoulNum = 0
	local cfg = nebulaEmperorRead.nebulaemperorrevive[lv]
	if cfg then
		needSoulNum = cfg.reviveNum / cfg.condition[2]
	end
	return needSoulNum
end
function _UPVALUE2_()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[1] = "nebulaemperormap"
;(function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)[2] = true
nebulaEmperorRead:defineValue("nebulaemperormap", function()
	nebulaEmperorRead.buff, nebulaEmperorRead = nil, nil
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperortitle) do
		local nebulaEmperorRead, buffList
		for _, buffID in ipairs(v.buff) do
			local buffType = buffltCtrl:getEffectType(buffID)
			local buffValue = buffltCtrl:getEffect(buffID)
			if buffType then
				buffList[buffType] = buffValue
			end
		end
		nebulaEmperorRead.buff[v.type] = buffList
	end
	return nebulaEmperorRead.buff
end)
function nebulaEmperorRead.getMapAreaConfig(areaType, camp)
	local _ENV, ret
	for __, v in ipairs(nebulaEmperorRead.nebulaemperormap) do
		if v.type == areaType and (not camp or camp == v.camp) then
			table.insert(ret, v.area)
		end
	end
	return ret
end
local createData = function(name)
	local _ENV, ret
	local nebulaemperorrewards = require_data("nebulaemperorrewards", true, true).data
	for i, v in ipairs(nebulaemperorrewards) do
		if not ret[v.rewardsType] then
			_ENV = ret[v.rewardsType]
		end
		ret[v.rewardsType] = ret[v.rewardsType]
		table.insert(ret[v.rewardsType], v)
	end
	return ret
end
nebulaEmperorRead:defineValue("nebulaemperorrewards", createData)
function nebulaEmperorRead.getRewardConfigByType(rewardsType)
	return nebulaEmperorRead.nebulaemperorrewards[rewardsType]
end
_UPVALUE2_ = createData
createData[1] = "nebulaemperorgift"
createData[2] = true
nebulaEmperorRead:defineValue("nebulaemperorgift", createData)
function nebulaEmperorRead.getGiftList()
	local _ENV, ret
	local starLv = SoraDGetBuildStarLv()
	for __, v in ipairs(nebulaEmperorRead.nebulaemperorgift) do
		if starLv >= v.castleLv then
			table.insert(ret, v)
		end
	end
	return ret
end
_UPVALUE2_ = createData
createData[1] = "nebulaemperor_cure_cost"
createData[2] = true
nebulaEmperorRead:defineValue("nebulaemperor_cure_cost", createData)
nebulaEmperorRead:defineValue("cureCostConfig", function()
	local _ENV, ret
	for __, v in ipairs(nebulaEmperorRead.nebulaemperor_cure_cost) do
		ret[v.armyLv] = v
	end
	return ret
end)
function nebulaEmperorRead.getCostResPercent(armyLv, resId)
	armyLv = armyLv or 1
	resId = resId or gIDDef.FOOD
	local cfg = nebulaEmperorRead.cureCostConfig[armyLv]
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local state = activityShowCtrl:getParamCurState(gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY)
	if resId == gIDDef.FOOD then
		return cfg.costFood / 1000
	elseif resId == gIDDef.WOOD then
		return cfg.costWood / 1000
	elseif resId == gIDDef.IRON then
		return cfg.costIron / 1000
	elseif resId == gIDDef.MITHRIL then
		return cfg.costSilver / 1000
	elseif resId == gIDDef.CRYSTAL then
		return cfg.costCrystal / 1000
	elseif resId == gIDDef.METEOR_CRYSTAL then
		if state == ACTIVITY_STATE.ACTIVE then
			return cfg.costMeteor / 1000
		else
			return 0
		end
	end
	return 1
end
return nebulaEmperorRead
