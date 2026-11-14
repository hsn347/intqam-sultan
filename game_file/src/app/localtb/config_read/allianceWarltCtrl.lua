local allianceWarltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "alliancewar_shop"
	;(nil)[2] = true
	allianceWarltCtrl:defineValue("as", nil)
	_ENV = nil
	;(nil)[1] = "alliancewar_shop_point"
	;(nil)[2] = true
	allianceWarltCtrl:defineValue("asp", nil)
	_ENV = nil
	;(nil)[1] = "alliancewar_shop_point_limit"
	;(nil)[2] = true
	allianceWarltCtrl:defineValue("aspl", nil)
	print("allianceWarltCtrl.init()")
	local createData = function(name)
		allianceWarltCtrl.allianceBuildings, allianceWarltCtrl, allianceWarltCtrl.idRefAllianceWarBuilding, allianceWarltCtrl, allianceWarltCtrl.posRefAllianceWarBuilding, allianceWarltCtrl = nil, nil, nil, nil, nil, nil
		local allianceWarBuilding = require_once("app." .. LocalTblPath .. ".config_server.alliancewarbuilding")
		for id, allianceBuild in pairs(allianceWarBuilding) do
			allianceBuild.x = allianceBuild.x - gPointClientPointPlus
			allianceBuild.y = allianceBuild.y - gPointClientPointPlus
			allianceWarltCtrl.allianceBuildings[id] = allianceBuild
			allianceBuild.id = id
			allianceBuild.objId = id
			local x, y = allianceBuild.x, allianceBuild.y
			if not allianceWarltCtrl.posRefAllianceWarBuilding[x] then
				allianceWarltCtrl.posRefAllianceWarBuilding[x], allianceWarltCtrl = nil, nil
			end
			allianceWarltCtrl.posRefAllianceWarBuilding[x][y] = allianceBuild
			allianceWarltCtrl.idRefAllianceWarBuilding[allianceBuild.id] = allianceBuild
		end
		if name == "posRefAllianceWarBuilding" then
			return allianceWarltCtrl.posRefAllianceWarBuilding
		elseif name == "idRefAllianceWarBuilding" then
			return allianceWarltCtrl.idRefAllianceWarBuilding
		else
			return allianceWarltCtrl.allianceBuildings
		end
	end
	allianceWarltCtrl:defineValue("posRefAllianceWarBuilding", createData)
	allianceWarltCtrl:defineValue("idRefAllianceWarBuilding", createData)
	allianceWarltCtrl:defineValue("allianceBuildings", createData)
	_ENV = createData
	createData[1] = "alliancewar_personal_reward"
	createData[2] = true
	allianceWarltCtrl:defineValue("alliancewar_personal_reward", createData)
	_ENV = createData
	createData[1] = "alliancewar_pbl_pointsrewards"
	createData[2] = true
	allianceWarltCtrl:defineValue("alliancewar_pbl_pointsrewards", createData)
	_ENV = createData
	createData[1] = "alliancewar_alliance_reward"
	createData[2] = true
	allianceWarltCtrl:defineValue("alliancewar_alliance_reward", createData)
end
init()
function allianceWarltCtrl.getShopScoreLimit(matchType, castleLv)
	local scoreLimit = 0
	for i, v in ipairs(allianceWarltCtrl.aspl) do
		if matchType == v.pointType and castleLv >= v.castleLv[1] and castleLv <= v.castleLv[2] then
			scoreLimit = v.pointLimit
			break
		end
	end
	return scoreLimit
end
function allianceWarltCtrl.getShopTaskInfo(matchType)
	local _ENV, taskInfo
	for i, v in ipairs(allianceWarltCtrl.asp) do
		if matchType == v.pointType and v.isShowDesc == 1 then
			table.insert(taskInfo, v)
		end
	end
	return taskInfo
end
function allianceWarltCtrl.getShopItemInfo(matchType)
	local _ENV, shopInfo
	local itemDesRead = include("itemDesRead")
	local pyramidwarShopCtrl = SoraDGetCtrl("pyramidwarShopCtrl")
	local commonScore = matchType == gSeasonType.REGULAR_SEASON and pyramidwarShopCtrl:getRegularScore() or pyramidwarShopCtrl:getPeakScore()
	local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
	local groupId = pyramidWarCtrl:getGroupID()
	for i, v in ipairs(allianceWarltCtrl.as) do
		if matchType == v.shopType and groupId == v.groupId then
			table.insert(shopInfo, v)
		end
	end
	for i, v in ipairs(shopInfo) do
		local alreadyExchangeTimes = pyramidwarShopCtrl:getExchangedTimes(matchType, v.shopId)
		local remainTimes = v.limit - alreadyExchangeTimes
		v.weight = itemDesRead.getQuality(v.item[1])
		if commonScore > v.point then
			v.weight = v.weight + 1
		end
		if 0 < remainTimes then
			v.weight = v.weight + 1
		else
			v.weight = 0
		end
	end
	table.sort(shopInfo, function(l, r)
		if l.weight == r.weight then
			return l.item[1] < r.item[1]
		else
			return l.weight > r.weight
		end
	end)
	return shopInfo
end
function allianceWarltCtrl.getAllianceWarBuildingByPos(x, y)
	if allianceWarltCtrl.posRefAllianceWarBuilding[x] then
		return allianceWarltCtrl.posRefAllianceWarBuilding[x][y]
	end
end
function allianceWarltCtrl.getAllianceWarBuildingById(id)
	return allianceWarltCtrl.idRefAllianceWarBuilding[id]
end
function allianceWarltCtrl.getAllianceWarBuildings()
	return allianceWarltCtrl.allianceBuildings
end
function allianceWarltCtrl.getAlliancewarPBLPointsRewards()
	local _ENV, ret
	for k, v in pairs(allianceWarltCtrl.alliancewar_pbl_pointsrewards) do
		table.insert(ret, v)
	end
	table.sort(ret, function(l, r)
		return l.point[1] > r.point[1]
	end)
	return ret
end
function allianceWarltCtrl.getAlliancewarPersonalReward(rtype, style)
	local _ENV, ret
	local pyramidWarCtrl = SoraDGetCtrl("pyramidWarCtrl")
	local groupId = pyramidWarCtrl:getGroupID()
	for k, v in pairs(allianceWarltCtrl.alliancewar_personal_reward) do
		if rtype == v.rewardtype and style == v.style and groupId == v.groupId then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(l, r)
		return l.point[1] > r.point[1]
	end)
	return ret
end
function allianceWarltCtrl.getAlliancewarAllianceReward(rtype)
	local _ENV, ret
	for k, v in ipairs(allianceWarltCtrl.alliancewar_alliance_reward) do
		if rtype == v.rewardtype then
			table.insert(ret, v)
		end
	end
	return ret
end
function allianceWarltCtrl.getAlliancewarAllianceRewardSendMax(rank)
	local ret = 0
	for k, v in ipairs(allianceWarltCtrl.alliancewar_alliance_reward) do
		if gPostSeasonAllianceReward.ALLIANCE_GIFTBAG == v.rewardtype and v.point[1] == rank and v.point[2] == rank then
			ret = v.sendcount
		end
	end
	return ret
end
return allianceWarltCtrl
