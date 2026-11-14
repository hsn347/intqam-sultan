local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local _ENV, mailLogic = "mailMgr", "mailMgr"
local getIsPlayerAttack = function(battleInfo)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local result = false
	local attackArmyInfo = battleInfo.attackArmyInfo
	if nil == attackArmyInfo then
		result = false
		return result
	end
	for i, v in ipairs(attackArmyInfo) do
		if v.uinfo.id == uid then
			result = true
			break
		end
	end
	return result
end
local getIsPlayerDefend = function(battleInfo)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local uid = lordInfoCtrl:getLordInfo().base.uid
	local result = false
	local defenceArmyInfo = battleInfo.defenceArmyInfo
	if nil == defenceArmyInfo then
		result = false
		return result
	end
	for i, v in ipairs(defenceArmyInfo) do
		if v.uinfo.id == uid then
			result = true
			break
		end
	end
	return result
end
function mailLogic.createSummaryOfBattleReport(source, data)
	if gMailSetTypeFunc.checkIsBattleMailSource(source) then
		local _ENV, ret = gMailSetTypeFunc.checkIsBattleMailSource(source), gMailSetTypeFunc.checkIsBattleMailSource(source)
		ret.playerInfo1, _ENV, ret.result = data.result, data.result, data.result
		if "table" == type(data.playerInfo1) then
			if "table" == type(data.playerInfo1.uinfo) then
				_ENV = data.playerInfo1.uinfo
				data.playerInfo1.uinfo.id = data.playerInfo1.uinfo.id
				data.playerInfo1.uinfo.nickName = data.playerInfo1.uinfo.nickName
				ret.playerInfo1.uinfo, data.playerInfo1.uinfo.kid = data.playerInfo1.uinfo, data.playerInfo1.uinfo.kid
			end
			if "table" == type(data.playerInfo1.allianceInfo) then
				_ENV = data.playerInfo1.allianceInfo
				data.playerInfo1.allianceInfo.aid = data.playerInfo1.allianceInfo.aid
				data.playerInfo1.allianceInfo.kid = data.playerInfo1.allianceInfo.kid
				data.playerInfo1.allianceInfo.name = data.playerInfo1.allianceInfo.name
				ret.playerInfo1.allianceInfo, data.playerInfo1.allianceInfo.abbr = data.playerInfo1.allianceInfo, data.playerInfo1.allianceInfo.abbr
			end
			if "table" == type(data.playerInfo1.fightSummary) then
				_ENV = data.playerInfo1.fightSummary
				data.playerInfo1.fightSummary.killNum = data.playerInfo1.fightSummary.killNum
				ret.playerInfo1.fightSummary, data.playerInfo1.fightSummary.lostNum = data.playerInfo1.fightSummary, data.playerInfo1.fightSummary.lostNum
			end
		end
		ret.playerInfo2, _ENV = ret.playerInfo1, ret.playerInfo1
		if "table" == type(data.playerInfo2) then
			if "table" == type(data.playerInfo2.uinfo) then
				_ENV = data.playerInfo2.uinfo
				data.playerInfo2.uinfo.id = data.playerInfo2.uinfo.id
				data.playerInfo2.uinfo.nickName = data.playerInfo2.uinfo.nickName
				ret.playerInfo2.uinfo, data.playerInfo2.uinfo.kid = data.playerInfo2.uinfo, data.playerInfo2.uinfo.kid
			end
			if "table" == type(data.playerInfo2.allianceInfo) then
				_ENV = data.playerInfo2.allianceInfo
				data.playerInfo2.allianceInfo.aid = data.playerInfo2.allianceInfo.aid
				data.playerInfo2.allianceInfo.kid = data.playerInfo2.allianceInfo.kid
				data.playerInfo2.allianceInfo.name = data.playerInfo2.allianceInfo.name
				ret.playerInfo2.allianceInfo, data.playerInfo2.allianceInfo.abbr = data.playerInfo2.allianceInfo, data.playerInfo2.allianceInfo.abbr
			end
			if "table" == type(data.playerInfo2.fightSummary) then
				_ENV = data.playerInfo2.fightSummary
				data.playerInfo2.fightSummary.killNum = data.playerInfo2.fightSummary.killNum
				ret.playerInfo2.fightSummary, data.playerInfo2.fightSummary.lostNum = data.playerInfo2.fightSummary, data.playerInfo2.fightSummary.lostNum
			end
		end
		ret.targetCoordinate = data.targetCoordinate
		ret.isSelfInAttack = getIsPlayerAttack(data.battleInfo)
		ret.isSelfInDefend = getIsPlayerDefend(data.battleInfo)
		ret.isHeavyLose = data.isHeavyLose
		ret.mapType = data.mapType
		ret.subMapType = data.subMapType
		ret.objId = data.objId
		ret.isKillLeaderNpc = data.isKillLeaderNpc
		ret.killNormalNpcLv = data.killNormalNpcLv
		ret.commandHallTaskID = data.commandHallTaskID
		return ret
	elseif gMailSetTypeFunc.checkIsScoutMailSource(source) then
		local _ENV, ret = gMailSetTypeFunc.checkIsScoutMailSource(source), gMailSetTypeFunc.checkIsScoutMailSource(source)
		ret.uinfo = data.uinfo
		ret.allianceInfo = data.allianceInfo
		ret.targetCoordinate = data.targetCoordinate
		if "table" == type(data.resInfo) and next(data.resInfo) then
			ret.resTotal = 0
			for k, v in pairs(data.resInfo) do
				ret.resTotal = ret.resTotal + (v.ownNum and v.ownNum or 0) + (v.unCollectNum and v.unCollectNum or 0)
			end
		end
		ret.targetMapObj = data.targetMapObj
		ret.numDefArmy = data.numDefArmy
		if data.cityDefenceArmy then
			ret.cityDefenceArmy, _ENV = data.cityDefenceArmy, data.cityDefenceArmy
			ret.cityDefenceArmy.isPrecise = data.cityDefenceArmy.isPrecise
			ret.cityDefenceArmy.hasArmyType = data.cityDefenceArmy.hasArmyType
			ret.cityDefenceArmy.defenceArmyNum = data.cityDefenceArmy.defenceArmyNum
		end
		if data.reinforcements then
			ret.reinforcements, _ENV = data.reinforcements, data.reinforcements
			ret.reinforcements.isPrecise = data.reinforcements.isPrecise
			ret.reinforcements.num = data.reinforcements.num
		end
		if data.numReinforcements then
			ret.numReinforcements = data.numReinforcements
		end
		if data.targetMapObj then
			ret.mapType = data.targetMapObj.mapType
			ret.subMapType = data.targetMapObj.subMapType
			ret.objId = data.targetMapObj.objId
		end
		if data.spyResult then
			ret.spyResult = data.spyResult
		end
		if data.itemId then
			ret.itemId = data.itemId
		end
		return ret
	elseif gMailSource.SCOUT_INVALID == source or gMailSource.ATTACK_INVALID == source then
		local ret = data
		return ret
	end
end
function mailLogic.getReportSetTypeList()
	return gMailSetTypeFunc.getReportSetTypeList()
end
function mailLogic.needNoticeMailNumPer(mailSetType)
	gMailSetTypeFunc.needNoticeMailNumPer(mailSetType)
end
return mailLogic
