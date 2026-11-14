local dressltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local getDressConfig = function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_server.dress_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.dress_config", "app." .. LocalTblPath .. ".config_server.dress_config"
		local _ENV, dressType_list = LocalTblPath, LocalTblPath
		local _ENV, subTypeList = ".config_server.dress_config", ".config_server.dress_config"
		for k, v in pairs(config) do
			local dressID = v.dressID
			ret[dressID] = v
			v.dType = tostring(v.dType)
			local subType = v.subType
			if not dressType_list[v.dType] then
				_ENV = dressType_list[v.dType]
			end
			dressType_list[v.dType] = dressType_list[v.dType]
			if not dressType_list[v.dType][subType] then
				_ENV = dressType_list[v.dType][subType]
			end
			dressType_list[v.dType][subType] = dressType_list[v.dType][subType]
			dressType_list[v.dType][subType][dressID] = dressID
			if not subTypeList[subType] then
				subTypeList[subType], _ENV = subTypeList[subType], subTypeList[subType]
			end
			table.insert(subTypeList[subType], dressID)
		end
		dressltCtrl.dresslt = ret
		dressltCtrl.dressType_list = dressType_list
		dressltCtrl.subTypeList = subTypeList
		if name == "dresslt" then
			return ret
		elseif name == "dressType_list" then
			return dressType_list
		elseif name == "subTypeList" then
			return subTypeList
		end
	end
	dressltCtrl:defineValue("dresslt", getDressConfig)
	dressltCtrl:defineValue("dressType_list", getDressConfig)
	dressltCtrl:defineValue("subTypeList", getDressConfig)
	dressltCtrl:defineValue("dressTypeList", function()
		dressltCtrl.dressTypeList, dressltCtrl = nil, nil
		for k, v in pairs(gDressType) do
			dressltCtrl.dressTypeList[v] = true
		end
		return dressltCtrl.dressTypeList
	end)
end
init()
function dressltCtrl.isDress(dressID)
	if not dressID then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	if not dressltCtrl.dresslt[dressID] then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	return gErrDef.Err_None
end
function dressltCtrl.isDressType(dressType)
	if not dressType then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	if not dressltCtrl.dressTypeList[dressType] then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	return gErrDef.Err_None
end
function dressltCtrl.getDressType(dressID)
	return dressltCtrl.dresslt[dressID].dType
end
function dressltCtrl.getDressLifeType(dressID)
	return dressltCtrl.dresslt[dressID].lifeType
end
function dressltCtrl.getDressLifetime(dressID)
	return dressltCtrl.dresslt[dressID].lifetime
end
function dressltCtrl.getSubType(dressID)
	return dressltCtrl.dresslt[dressID].subType
end
function dressltCtrl.getCastleDressList()
	return dressltCtrl.getDressList(gDressType.CASTLE)
end
function dressltCtrl.getDressList(dressType)
	return dressltCtrl.dressType_list[dressType]
end
function dressltCtrl.getForeverCastleDress()
	local castleList = dressltCtrl.getCastleDressList()
	local dressltCtrl, retList
	for subType, list in pairs(castleList) do
		for dressID, _ in pairs(list) do
			if dressltCtrl.isForever(dressID) then
				dressltCtrl = nil
				;(nil).dressID = dressID
				;(nil).subType = subType
				table.insert(retList, nil)
			end
		end
	end
	return retList
end
function dressltCtrl.isForever(dressID)
	local lifeType = dressltCtrl.getDressLifeType(dressID)
	if gDressLifeType.FOREVER == lifeType then
		return true
	end
	return false
end
function dressltCtrl.getDresslistBySubType(subType)
	return dressltCtrl.subTypeList[subType]
end
function dressltCtrl.getFirstDressIDBySubType(subType)
	return dressltCtrl.subTypeList[subType] and dressltCtrl.subTypeList[subType][1] or nil
end
function dressltCtrl.getOwnAttribute(subType)
	local castleSkinRead = include("castleSkinRead")
	return castleSkinRead.getOwnAttrBySubType(subType)
end
function dressltCtrl.getUseAttribute(subType)
	local castleSkinRead = include("castleSkinRead")
	return castleSkinRead.getUseAttrBySubType(subType)
end
function dressltCtrl.isShowDress(dressID)
	print("dressID==== 1", dressID)
	local constantRead = include("constantRead")
	local castleSkinRead = include("castleSkinRead")
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local cfgLv = IsArClient and constantRead.getConstValue("CASTLE_SKIN_NEWCLOTHES_KOH") or constantRead.getConstValue("CASTLE_SKIN_NEWCLOTHES_ROS") or 999
	if cfgLv >= lordInfoCtrl:getMapSourceKid() and not dressltCtrl.isLegendaryKingDress(dressID) and not dressltCtrl.isKingStarDress(dressID) then
		return true
	end
	print("dressID==== 2", dressID)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local subType = dressltCtrl.getSubType(dressID)
	local dressList = dressltCtrl.getDresslistBySubType(subType)
	local items = backpackltCtrl:getItemByResult(dressID, dressList)
	local isHave = false
	for k, v in ipairs(items) do
		if backpackCtrl:getItemCount(v) > 0 then
			isHave = true
			break
		end
	end
	if isHave then
		return true
	end
	print("dressID==== 3", dressID)
	local dressCtrl = SoraDGetCtrl("dressCtrl")
	print("dressID========", dressCtrl:ownDress(dressID))
	if dressCtrl:ownDress(dressID) then
		return true
	end
	local castleDressID = dressCtrl:getCurDressID(gDressType.CASTLE)
	local nameDressID = dressCtrl:getCurDressID(gDressType.CASTLE_NAMEPLATE)
	local chatPopDressID = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
	local chatFrameDressID = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
	if castleDressID and castleSkinRead.getCastleType(castleDressID) == castleSkinRead.getCastleType(dressID) then
		return true
	end
	if nameDressID and nameDressID == dressID then
		return true
	end
	if chatPopDressID and chatPopDressID == dressID then
		return true
	end
	if chatFrameDressID and chatFrameDressID == dressID then
		return true
	end
	print("dressID==== 4", dressID)
	local ret = true
	local unlockConditions = dressltCtrl.dresslt[dressID].unlockConditions
	if unlockConditions and next(unlockConditions) then
		local unlockType = unlockConditions[1]
		local unlockParam = unlockConditions[2]
		if unlockType == 1 then
			if unlockParam == 1 then
				ret = true
			elseif unlockParam == 2 then
				local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
				if not rechargeActivityCtrl:getMonthActivityList() then
					local _ENV, data = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
				end
				ret = next(data) and true or false
			elseif unlockParam == 3 then
				ret = true
			elseif unlockParam == 4 then
				ret = true
			elseif unlockParam == 5 then
				ret = true
			elseif unlockParam == 6 then
				local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
				local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
				local exclusiveVipRead = include("exclusiveVipRead")
				local totalScore = exaltedPrivilegeCtrl:getTotalScores()
				local curPrivilegeList, curSore = exclusiveVipRead:getPrivilegeList(totalScore)
				local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
				local totalRecharge = premiumStoreCtrl:getDollor()
				local historyInfo, nextHistoryInfo = exclusiveVipRead:getReachRechargeInfo(totalRecharge)
				local needWeekGold = exclusiveVipRead:getWeeklyRechargeNeedGold()
				local weekTotalRecharge = exaltedPrivilegeCtrl:getWeekRechargeGold()
				local weekNeedHistoryRechargeGold = exclusiveVipRead:getweeklyHistoryRechargeNeedGold()
				local packageList, isPackageExit = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
				local isHistoryReach = false
				local isWeekReach = false
				if not historyInfo then
					if totalRecharge >= nextHistoryInfo.charge_amount then
						isHistoryReach = true
					end
				elseif totalRecharge >= historyInfo.charge_amount then
					isHistoryReach = true
				end
				if totalRecharge >= weekNeedHistoryRechargeGold then
					isWeekReach = true
				end
				if 0 < table.nums(curPrivilegeList) or 0 < table.nums(welfareInfo) or isPackageExit or isHistoryReach or isWeekReach then
					ret = true
				else
					ret = false
				end
			end
		elseif unlockType == 2 then
			if unlockParam == 1 then
				ret = dressCtrl:isDressKWOpened() or false
			elseif unlockParam == 2 then
				ret = SoraDGetCastleLv() >= CASTLE_LV15_LIMITED
			elseif unlockParam == 3 then
				ret = true
			elseif unlockParam == 4 then
				local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
				local regionType = nebulaActivityCtrl:getKingdomRegionType()
				ret = SoraDGetCastleLv() >= CASTLE_LV15_LIMITED and NEBULA_REGION_TYPE.SEPARATIST_REGIME ~= regionType
			elseif unlockParam == 5 then
				ret = SoraDGetCastleLv() >= CASTLE_LV15_LIMITED
			elseif unlockParam == 6 then
				local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
				local regionType = nebulaActivityCtrl:getKingdomRegionType()
				ret = SoraDGetCastleLv() >= CASTLE_LV15_LIMITED and NEBULA_REGION_TYPE.SEPARATIST_REGIME == regionType
			end
		elseif unlockType == 3 then
			ret = dressCtrl:isDressOpened(unlockParam)
		elseif unlockType == 4 then
			ret = dressCtrl:isDressOpened(unlockParam)
		end
	else
		ret = false
	end
	print("isShowDress dressID======", dressID, ret)
	return ret
end
function dressltCtrl.isLegendaryKingDress(dressID)
	if not dressltCtrl.LegendaryKingDressMap then
		dressltCtrl = dressltCtrl.LegendaryKingDressMap
		dressltCtrl.LegendaryKingDressMap[9002812] = true
		dressltCtrl.LegendaryKingDressMap[9002437] = true
		dressltCtrl.LegendaryKingDressMap[9002535] = true
		dressltCtrl.LegendaryKingDressMap[9002247] = true
		dressltCtrl.LegendaryKingDressMap, dressltCtrl.LegendaryKingDressMap[9002711] = dressltCtrl.LegendaryKingDressMap, true
	end
	if dressltCtrl.LegendaryKingDressMap[dressID] then
		return true
	else
		return false
	end
end
function dressltCtrl.isKingStarDress(dressID)
	if not dressltCtrl.kingStarDressMap then
		dressltCtrl = dressltCtrl.kingStarDressMap
		dressltCtrl.kingStarDressMap[9006020] = true
		dressltCtrl.kingStarDressMap[9007020] = true
		dressltCtrl.kingStarDressMap[9003017] = true
		dressltCtrl.kingStarDressMap[9004023] = true
		dressltCtrl.kingStarDressMap, dressltCtrl.kingStarDressMap[9002328] = dressltCtrl.kingStarDressMap, true
	end
	if dressltCtrl.kingStarDressMap[dressID] then
		return true
	else
		return false
	end
end
function dressltCtrl.getAvatarFrameCfg(index)
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	_UPVALUE0_, (nil)[53], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[61], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[62], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[86], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[92], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[94], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[108], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[109], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[110], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[112], (nil).offsetY = nil, nil, 7
	_UPVALUE0_, (nil)[113], (nil).offsetY = nil, nil, 7
	;(nil).offsetY = 7
	_UPVALUE0_, (nil)[58], (nil).scale = nil, nil, 0.9
	;(nil).offsetY = 7
	_UPVALUE0_, (nil)[95], (nil).scale = nil, nil, 0.9
	;(nil).offsetY = 7
	_UPVALUE0_, (nil)[96], (nil).scale = nil, nil, 0.9
	;(nil).offsetY = 7
	_UPVALUE0_, (nil)[105], (nil).scale = nil, nil, 0.9
	_UPVALUE0_, (nil)[63], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[115], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[116], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[117], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[119], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[106], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[107], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[111], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[114], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[127], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[118], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[120], (nil).offsetY = nil, nil, 4
	_UPVALUE0_, (nil)[121], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[122], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[123], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[125], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[126], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[128], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[134], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[136], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[137], (nil).offsetY = nil, nil, 10
	_UPVALUE0_, (nil)[139], (nil).offsetY = nil, nil, 10
	;(nil)[140], (nil).offsetY = nil, 10
	local cfg
	return cfg[index]
end
return dressltCtrl
