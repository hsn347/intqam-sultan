local arenaltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "arena_subsection"
	;(nil)[2] = true
	arenaltCtrl:defineValue("pointTbl", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "arena_rewards"
	;(nil)[2] = true
	arenaltCtrl:defineValue("priceTbl", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "arena_point_buy"
	;(nil)[2] = true
	arenaltCtrl:defineValue("buyTbl", nil)
	arenaltCtrl = nil
	;(nil)[1] = "arena_buff_des"
	arenaltCtrl:defineValue("armyBuff", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "arena_buff_restrain"
	;(nil)[2] = true
	arenaltCtrl:defineValue("restraint", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "arena_buff_buy"
	;(nil)[2] = true
	arenaltCtrl:defineValue("buffBuy", nil)
end
function arenaltCtrl.getSubSectionList(sid)
	if sid then
		if not arenaltCtrl.pointTbl[sid] then
			arenaltCtrl = arenaltCtrl.pointTbl[sid]
		end
		return arenaltCtrl.pointTbl[sid]
	else
		return arenaltCtrl.pointTbl
	end
end
function arenaltCtrl.getSubSectionListByType(battleType)
	local subList = arenaltCtrl.getSubSectionList()
	local arenaltCtrl, ret
	for i, v in ipairs(subList) do
		if v.type == battleType then
			table.insert(ret, v)
		end
	end
	return ret
end
function arenaltCtrl.getSubSectionIndex(battleType, grading)
	local subList = arenaltCtrl.getSubSectionList()
	for i, v in ipairs(subList) do
		if battleType == v.type and grading == v.grading then
			return v.index
		end
	end
	return 1
end
function arenaltCtrl.getRestraintList(bType)
	local _ENV, ret
	for i, v in ipairs(arenaltCtrl.restraint) do
		if v.type == bType then
			table.insert(ret, v)
		end
	end
	return ret
end
function arenaltCtrl.getCostGoldByTypeAndTimes(bType, remainTimes)
	local _ENV, ret
	for i, v in ipairs(arenaltCtrl.buffBuy) do
		if v.type == bType and v.Count == remainTimes then
			ret = v
			break
		end
	end
	if not next(ret) then
		ret.Gold = 100
	end
	return ret
end
function arenaltCtrl.getMaxRefreshBuffTimes(bType)
	local maxTimes = 0
	for i, v in ipairs(arenaltCtrl.buffBuy) do
		if v.type == bType and maxTimes < v.Count then
			maxTimes = v.Count
		end
	end
	return maxTimes
end
function arenaltCtrl.getRewardByType(bType, blockID)
	local _ENV, ret
	if gArenaBattleType.ARENA_LOCAL == bType then
		for _, v in ipairs(arenaltCtrl.priceTbl) do
			if v.type == 1 then
				if blockID then
					if v.grading == blockID then
						table.insert(ret, v)
					end
				else
					table.insert(ret, v)
				end
			end
		end
	elseif gArenaBattleType.AREAN_GLOBAL == bType then
		for _, v in ipairs(arenaltCtrl.priceTbl) do
			if v.type == 2 then
				if blockID then
					if v.grading == blockID then
						table.insert(ret, v)
					end
				else
					table.insert(ret, v)
				end
			end
		end
	end
	return ret
end
function arenaltCtrl.getBuyCon(count)
	count = count + 1
	local maxGold = 100
	local maxCount = 1
	local gold = 0
	local findIt = false
	for i, v in ipairs(arenaltCtrl.buyTbl) do
		if tonumber(v.Count) == tonumber(count) then
			gold = v.Gold
			findIt = true
			break
		end
		maxCount = math.max(maxCount, v.Count)
		maxGold = math.max(maxGold, v.Gold)
	end
	if findIt then
		return gold
	else
		return maxGold
	end
end
function arenaltCtrl.getArmyBuff(buffID)
	for _, v in pairs(arenaltCtrl.armyBuff) do
		if v.effectType == buffID then
			return v
		end
	end
end
function arenaltCtrl.judgeIsStar(buffIDList, armyID)
	local judgeFun = function(bid, aid)
		local innerRet = false
		for _, v in pairs(arenaltCtrl.armyBuff) do
			if v.effectType == bid then
				local cid = math.floor(aid / 100.0 % 10) * 100
				if cid == v.effectIDRange then
					innerRet = true
					break
				end
			end
		end
		return innerRet
	end
	local ret = false
	if buffIDList and next(buffIDList) then
		for _, v in pairs(buffIDList) do
			if judgeFun(v.effectType, armyID) then
				ret = true
				break
			end
		end
	end
	return ret
end
function arenaltCtrl.specialCreateName(info, needKid)
	if info.robotFlag then
		local noid = tonumber(info.nickName)
		if noid then
			_ENV = nil
			;(nil).num = noid
			info.nickName = i18n("arena_name_06", nil)
		end
	end
	local showName = info.nickName
	if needKid and info.kid and info.kid > 0 and not info.robotFlag then
		showName = showName .. "#" .. info.kid
	end
	return showName
end
function arenaltCtrl.reportReMake(inData, battleType)
	if battleType ~= gArenaBattleType.RAIDER_LOST_ARK or battleType ~= gArenaBattleType.STAR_ENERGY_CUBE then
		inData.playerInfo1.uinfo.nickName = arenaltCtrl.specialCreateName(inData.playerInfo1.uinfo, battleType ~= gArenaBattleType.ARENA_LOCAL)
		inData.playerInfo2.uinfo.nickName = arenaltCtrl.specialCreateName(inData.playerInfo2.uinfo, battleType ~= gArenaBattleType.ARENA_LOCAL)
	end
	if battleType == gArenaBattleType.RAIDER_LOST_ARK then
		inData.playerInfo2.uinfo.battleType = gArenaBattleType.RAIDER_LOST_ARK
	end
	if battleType == gArenaBattleType.STAR_ENERGY_CUBE then
		inData.playerInfo2.uinfo.battleType = gArenaBattleType.STAR_ENERGY_CUBE
	end
	inData.result = inData.bWin and 0 or 1
	inData.mailReportType = gMailReportType.ARENA
	local chatFunctions = include("chatFunctions")
	_ENV = "chatFunctions"
	;("chatFunctions").data = inData
	;("chatFunctions").mailType = 1
	;("chatFunctions").source = 2
	;("chatFunctions").time = inData.time
	local ("chatFunctions").receiver, originData = chatFunctions:getSelfId(), "chatFunctions"
	return include("mail").new(originData)
end
function arenaltCtrl.showGroupServer()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
	local arenaCtrl = gametop.playertop_:getModule("arenaCtrl")
	local battleInfo = arenaCtrl:getBattleInfo(gArenaBattleType.ARENA_LOCAL)
	local totalKingdom = kingdomCtrl:getKingdomNum()
	local kid = gametop.playertop_:getKingdomID()
	local _tempB = kid
	local _tempE = kid
	local groupKidList = battleInfo.groupKidList
	if groupKidList then
		local kids = battleInfo.arenaGroup ~= 6 and groupKidList[1] or groupKidList[2]
		return string.format("(%s)", table.concat(kids, ","))
	else
		local _matiple = kid % 5
		_tempB = math.floor(kid / 5) * 5 + 1
		_tempE = math.ceil(kid / 5) * 5
		if _matiple == 0 then
			_tempB = math.floor(kid / 5) * 5 - 5 + 1
			_tempE = math.ceil(kid / 5) * 5
		end
		if battleInfo.arenaGroup == 6 then
			if kid % 10 == 0 then
				_tempB = kid - 9
				_tempE = kid
			else
				_tempB = kid - kid % 10 + 1
				_tempE = kid - kid % 10 + 10
			end
		end
	end
	_tempE = math.min(_tempE, totalKingdom)
	_ENV = totalKingdom
	totalKingdom._begin = _tempB
	totalKingdom._end = _tempE
	return i18n("arena_text_40", totalKingdom)
end
function arenaltCtrl.getArenaResetDate(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("ARENA_RESET_DATA", 1)
end
init()
return arenaltCtrl
