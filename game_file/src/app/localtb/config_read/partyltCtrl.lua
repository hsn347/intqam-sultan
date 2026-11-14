local _ENV, partyltCtrl
local partyCtrl = SoraDGetCtrl("partyCtrl")
function partyltCtrl.init()
end
function partyltCtrl.getPartyData()
	return partyCtrl:getPartyData()
end
function partyltCtrl.getLeftInviteNum()
	local data = partyltCtrl:getPartyData()
	return data.maxCount1 - data.count1
end
function partyltCtrl.getLeftFeastNum()
	local data = partyltCtrl:getPartyData()
	return data.maxCount2 - data.count2
end
function partyltCtrl.getLeftTiredTime()
	return math.max(partyltCtrl:getPartyData().tiredEndtime - serviceFunctions.systemTime(), 0)
end
function partyltCtrl.getLeftTiredGold()
	local costGold = math.ceil(partyltCtrl.getLeftTiredTime() / 3600 * 50)
	return costGold
end
function partyltCtrl.isTired()
	return partyltCtrl:getPartyData().isTired
end
function partyltCtrl.getFeastAttendInfo(partyID)
	local data = partyCtrl:getPartyData()
	if data.myAttendPartyList then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		for i, v in ipairs(data.myAttendPartyList) do
			local ownUUID = lordInfoCtrl:getLordInfo().base.uid
			if v.uidListInfo[tostring(ownUUID)] and partyID == v.partyID and v.uidListInfo[tostring(ownUUID)].sEvent < 4 then
				return v.uidListInfo[tostring(ownUUID)]
			end
		end
	end
	return nil
end
function partyltCtrl.isScoreBoxReceive(score)
	local data = partyltCtrl:getPartyData()
	if data and data.receiveArray and data.receiveArray[tostring(score)] then
		return true
	end
	return false
end
function partyltCtrl.getFeastInfoById(feastID)
	local partyData = partyCtrl:getPartyData()
	if partyData.myOpenParty and partyData.myOpenParty.partyID == feastID then
		return partyData.myOpenParty, true
	end
	local data = partyCtrl:getPartyCenterData()
	for i, v in ipairs(data) do
		if v.partyID == feastID then
			return v, false
		end
	end
	local userData = partyCtrl:getPartyUserData()
	for i, v in ipairs(userData) do
		if v.partyID == feastID then
			return v, false
		end
	end
	local alonePartyInfo = partyCtrl:getAlonePartyData()
	if alonePartyInfo and alonePartyInfo.partyID == feastID then
		return alonePartyInfo, true
	end
	return nil, false
end
function partyltCtrl.getFeastCellInfoByLocation(feastID, location)
	local feastInfo = partyltCtrl.getFeastInfoById(feastID)
	if feastInfo then
		for k, v in pairs(feastInfo.uidListInfo) do
			if v.location == location then
				local uid = tonumber(k)
				return v, uid
			end
		end
	end
end
function partyltCtrl.isFeastCanSit(feastID)
	local feastInfo = partyltCtrl.getFeastInfoById(feastID)
	if feastInfo and table.nums(feastInfo.uidListInfo) < feastInfo.maxCount then
		return true
	end
	return false
end
function partyltCtrl.isPlayerOpenParty(feastID)
	local partyData = partyCtrl:getPartyData()
	if partyData.myOpenParty and partyData.myOpenParty.partyID == feastID then
		return true
	end
	return false
end
function partyltCtrl.isAttendFeast(feastID)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local ownUUID = lordInfoCtrl:getLordInfo().base.uid
	local feastInfo, isJoinOrOpen = partyltCtrl.getFeastInfoById(feastID)
	if feastInfo and feastInfo.uidListInfo[tostring(ownUUID)] then
		return true
	end
	if isJoinOrOpen and ownUUID == feastInfo.hostUid then
		return true
	end
	return false
end
function partyltCtrl.isSkipRewardTipsCheck()
	_ENV = nil
	;(nil).byUID = true
	local keepTime = tonumber(SoraDConfigGet("Game:partyRewardTipsSkip:saveTime~integer", nil)) or 0
	if keepTime < os.time() then
		return false
	else
		return true
	end
end
function partyltCtrl.setSkipRewardTipsCheck(isSkip)
	if isSkip then
		local noticeModule = include("noticeModule")
		local keepTime = noticeModule.reFutureDayTheTime(1, 0, 0, 0) + os.time()
		_ENV = 0
		;(0).byUID = true
		SoraDConfigSet("Game:partyRewardTipsSkip:saveTime~integer", keepTime, 0)
	else
		_ENV = "Game:partyRewardTipsSkip:saveTime~integer"
		;("Game:partyRewardTipsSkip:saveTime~integer").byUID = true
		SoraDConfigSet("Game:partyRewardTipsSkip:saveTime~integer", 0, "Game:partyRewardTipsSkip:saveTime~integer")
	end
end
function partyltCtrl.getPartyNameByLv(partyLv)
	local FAD = require_data("feastattribute", true)
	return i18n(FAD.data[partyLv].FeastName)
end
function partyltCtrl.clearFinishParty(partyCenterData)
	local _ENV, timeList
	local _ENV, dataList
	local _ENV, clearList
	local curTime = SoraDGetCtrl("timeCtrl"):getServerTime()
	for k, v in ipairs(partyCenterData) do
		local leftTime = math.max(v.endTime - curTime, 0)
		if 0 < leftTime then
			table.insert(timeList, leftTime)
			table.insert(dataList, v)
		end
	end
	local isClear = false
	if #timeList < #partyCenterData then
		partyCtrl.partyCenterData = dataList
		isClear = true
	end
	return timeList, isClear
end
partyltCtrl.init()
return partyltCtrl
