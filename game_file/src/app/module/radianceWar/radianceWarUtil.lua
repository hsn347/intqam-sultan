local _ENV, radianceWarUtil
local gametop = gModuleMgr.getObject("gametop")
local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local radianceWarDef = include("radianceWarDef")
local radianceWarRead = include("radianceWarRead")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
local getSystemTimeZone = function()
	local curTime = serviceFunctions.systemTime()
	return curTime
end
function radianceWarUtil.checkEnterBattleField()
	local err = gErrDef.Err_None
	if not radianceActivityCtrl:isWarBattle() then
		err = gErrDef.Err_RADIANCE_WAR_NOT_MATCH_SUCCESS
	elseif not allianceMgr:hasJoinAlliance() then
		err = gErrDef.Err_RADIANCE_WAR_NOT_JOIN_ALLIANCE
	else
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buiLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		local castle_limited = _G.CASTLE_LV40_LIMITED
		if buiLevel < castle_limited then
			err = gErrDef.Err_RADIANCE_WAR_CASTLE_LEVEL
		else
			if kingdomMapCtrl:isHasQueue() ~= 0 then
				err = gErrDef.Err_RADIANCE_WAR_PLAYER_HAS_QUEUE
			else
			end
		end
	end
	return err
end
function radianceWarUtil.checkQuitBattleField()
	local err = gErrDef.Err_None
	if kingdomMapCtrl:isHasQueue() ~= 0 then
		err = gErrDef.Err_RADIANCE_WAR_PLAYER_HAS_QUEUE
	else
	end
	return err
end
function radianceWarUtil.errShowTips(err)
	if err == gErrDef.Err_None then
		return
	end
	if err == gErrDef.Err_RADIANCE_WAR_CASTLE_LEVEL then
		local castle_limited = _G.CASTLE_LV40_LIMITED
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(castle_limited)
		if 0 < warLv then
			_ENV = nil
			;(nil).lv = warLv
			local lv = i18n("common_text_1948", nil)
			_ENV = nil
			;(nil).num = lv
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		else
			_ENV = i18n("common_text_1795", nil)
			i18n("common_text_1795", nil).num = castle_limited
			SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_1795", nil)))
		end
	else
		local msgNotice = include("msgNotice")
		local notice_id = msgNotice.getTipCode(err)
		if notice_id then
			local fun = msgNotice.getSpecialFun(notice_id)
			if nil == fun then
				print("notice_id =", err, notice_id)
				_ENV = "notice_id ="
				;("notice_id =").msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
				;("notice_id =").messageID = notice_id
				SoraDSendMessage("notice_id =")
			elseif "function" == type(fun) then
			end
		else
			_ENV = type(fun)
			type(fun).msg = "MESSAGE_MAINSCEN_MESSAGEINFO"
			type(fun).messageID = err
			SoraDSendMessage((type(fun)))
		end
	end
end
function radianceWarUtil.isInSelfLeagueManor(pos, leagueId, size, radioation, isFull)
	leagueId = leagueId or allianceMgr:getOwnTeamID() or 0
	radioation = radioation or 0
	size = size or 1
	local selfManorRect = cc.rect(tonumber(pos.x) - radioation, tonumber(pos.y) - radioation, 2 * radioation + size, 2 * radioation + size)
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if isFull then
			local isAllIn = true
			for i = selfManorRect.x, selfManorRect.x + selfManorRect.width do
				for j = selfManorRect.y, selfManorRect.y + selfManorRect.height do
					local rect = cc.rect(i, j, 0, 0)
					if not currentView:isInSelfLeagueManor(leagueId, rect, true) then
						isAllIn = false
						break
					end
				end
			end
			return isAllIn
		else
			return currentView:isInSelfLeagueManor(leagueId, selfManorRect)
		end
	end
	return false
end
function radianceWarUtil.getWarStatusTimeStr(curState)
	curState = curState or radianceActivityCtrl:getWarStatus()
	if curState == RADIANCE_WAR_STATE.MATCH or curState == RADIANCE_WAR_STATE.RESULT then
		return "common_text_606"
	elseif curState == RADIANCE_WAR_STATE.BATTLE then
		if radianceWarUtil.checkEnterWarByTime() or not radianceWarUtil.getWarBattleEnd() then
			return "common_text_607"
		end
		return "common_text_606"
	else
		return "king_tri_text_16"
	end
end
function radianceWarUtil.getWarStatusTime(curState)
	curState = curState or radianceActivityCtrl:getWarStatus()
	if curState == RADIANCE_WAR_STATE.MATCH or curState == RADIANCE_WAR_STATE.RESULT then
		return radianceActivityCtrl:getWarStatusTime_imp(RADIANCE_WAR_STATE.RESULT)
	elseif curState == RADIANCE_WAR_STATE.BATTLE then
		if radianceWarUtil.checkEnterWarByTime() or not radianceWarUtil.getWarBattleEnd() then
			return radianceActivityCtrl:getWarStatusTime_imp(RADIANCE_WAR_STATE.FINISH)
		end
		return radianceWarUtil.getWarOpenTime()
	else
		return radianceActivityCtrl:getWarStatusTime_imp(RADIANCE_WAR_STATE.FINISH)
	end
end
function radianceWarUtil.isWarFinish()
	return radianceActivityCtrl:isWarFinish()
end
local isInTimeRange = function(open, close, curTime)
	curTime = curTime or getSystemTimeZone()
	return open <= curTime and close >= curTime
end
function radianceWarUtil.checkEnterWarByTime()
	local curTime = getSystemTimeZone()
	do
		local timeCfg = radianceWarRead.getActiveTimeCfg(curTime)
		if timeCfg and isInTimeRange(timeCfg.open, timeCfg.close, curTime) then
			return true
		end
	end
	return false
end
function radianceWarUtil.enterWar()
	local err = radianceWarUtil.checkEnterBattleField()
	if gErrDef.Err_None ~= err then
		if err == gErrDef.Err_RADIANCE_WAR_PLAYER_HAS_QUEUE then
			SoraDShowMsgTip(i18n("brightWar_text_142"))
		else
			radianceWarUtil.errShowTips(err)
		end
		return
	end
	if not radianceWarUtil.checkEnterWarByTime() then
		SoraDCreatePanel("radianceWarDispatchArmyView"):show()
		local timeCfg = radianceWarRead.getActiveTimeCfg()
		local date = ""
		if timeCfg then
			date = os.date("!%Y-%m-%d %H:%M:%S-", timeCfg.open) .. os.date("!%H:%M:%S", timeCfg.close)
		end
		radianceWarUtil = timeCfg.close
		timeCfg.close.date = date
		SoraDShowMsgTip(i18n("brightWar_text_145", timeCfg.close))
		return
	end
	SoraDCreatePanel("radianceWarDispatchArmyView"):show()
end
function radianceWarUtil.quitWar()
	local err = radianceWarUtil.checkQuitBattleField()
	if gErrDef.Err_None ~= err then
		if err == gErrDef.Err_RADIANCE_WAR_PLAYER_HAS_QUEUE then
			SoraDShowMsgTip(i18n("brightWar_text_141"))
		else
			radianceWarUtil.errShowTips(err)
		end
		return
	end
	local showMsg = i18n("brightWar_text_130")
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			radianceActivityCtrl:reqQuitBattlefield()
		end
	end)
end
function radianceWarUtil.openRadianceWarView()
	local isWar = worldMapDefine.isInRadiance()
	_ENV = nil
	;(nil).isWar = not isWar
	uiManager:show("AllianceWarView", nil)
end
function radianceWarUtil.getWarLeftTime()
	local endTime
	local sysTime = getSystemTimeZone()
	local timeCfg = radianceWarRead.getActiveTimeCfg(sysTime)
	if timeCfg and isInTimeRange(timeCfg.open, timeCfg.close, sysTime) then
		endTime = timeCfg.close
	end
	if endTime and sysTime < endTime then
		return endTime - sysTime
	end
	return 0
end
function radianceWarUtil.isWarHospitalCureing()
	return radianceWarUtil.getWarHospitalCureTime() > 0
end
function radianceWarUtil.getWarHospitalCureTime()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.radiance_war_hostpital_queue)
	if queue then
		local leftTime = queue.timerNode.timer:getRemainTime()
		return leftTime
	end
	return 0
end
function radianceWarUtil.cancelWarHospitalCure()
	if radianceWarUtil.isWarHospitalCureing() then
		SoraDShowMsgBox(i18n("brightWar_text_171"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES and radianceWarUtil.isWarHospitalCureing() then
				local queueCtrl = gametop.playertop_:getModule("queueCtrl")
				queueCtrl:cancelQueueReq(gQueueTypeDef.radiance_war_hostpital_queue)
			end
		end)
	end
end
function radianceWarUtil.getRadianceQuarryItemNum()
	local itemID = radianceWarDef.RADIANCE_QUARRY
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local num = backpackCtrl:getItemCount(itemID) or 0
	return num
end
function radianceWarUtil.checkRadianceQuarryEnough(num)
	local hasNum = radianceWarUtil.getRadianceQuarryItemNum()
	return num <= hasNum
end
function radianceWarUtil.checkCanOccupyAmberMine()
	local total = radianceActivityCtrl:getWarTotalAmberPoint()
	local max = include("constantRead").getConstValue("RADIANCE_WAR_AMBER_POINT_MAX") or 0
	return total < max
end
function radianceWarUtil.getWarBattleEnd(curTime)
	curTime = curTime or getSystemTimeZone()
	local timeCfg = radianceWarRead.getActiveTimeCfgOpen(curTime)
	if timeCfg and curTime < timeCfg.close then
		return true
	end
	return false
end
function radianceWarUtil.getWarOpenTime(curTime)
	curTime = curTime or getSystemTimeZone()
	local timeCfg = radianceWarRead.getActiveTimeCfgOpen(curTime)
	if timeCfg and curTime < timeCfg.open then
		return timeCfg.open - curTime
	end
	return 0
end
function radianceWarUtil.getBuildBelongPos(pos)
	local scene = SoraDCurrentSceneShowView("worldMapView")
	return scene:getBelongBuild(pos)
end
function radianceWarUtil.showGuildToBuild(pos)
	SoraDShowMsgTip(i18n("brightWar_text_80"))
	local buildPos = radianceWarUtil.getBuildBelongPos(pos)
	if buildPos then
		local funOpen = function()
			SoraDGotoWorldMapPoint(buildPos, true)
		end
		SoraDDelayCallOnce("openBuild", funOpen)
	end
end
function radianceWarUtil.getWarMapId()
	if worldMapDefine.isRadianceKingdomID() then
		return worldMapDefine.currentMapKindomID
	end
	return radianceActivityCtrl:getWarMapId()
end
local POINT_MAX = include("constantRead").getConstValue("RADIANCE_WAR_AMBER_POINT_MAX") or 0
function radianceWarUtil.getResCount(data, curTime)
	if data.subMapType == 5 then
		local total = radianceActivityCtrl:getWarTotalAmberPoint()
		if total >= POINT_MAX then
			return 0
		end
	end
	curTime = curTime or serviceFunctions.systemTime()
	local curCount = (curTime - data.lastCollTime) * data.lastCollSpeed + data.alreadyCollNum
	return curCount
end
local _isRelease
function radianceWarUtil.toogleRelease()
	if _isRelease then
		SoraDShowMsgTip("open forbid")
	else
		SoraDShowMsgTip("close forbid")
	end
end
function radianceWarUtil.isRelease()
	if _isRelease ~= nil then
		return _isRelease
	end
	return _isRelease
end
_UPVALUE2_, radianceWarUtil.getBuildOpenLiftTime = function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end, function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end
;(function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[1] = cc.rect(0, 0, 1200, 1200)
;(function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[2] = cc.rect(210, 193, 780, 814)
;(function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[3] = cc.rect(453, 458, 294, 284)
;(function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[4] = cc.rect(453, 458, 294, 284)
;(function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[5] = cc.rect(453, 458, 294, 284)
;(function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[6] = cc.rect(453, 458, 294, 284)
local (function(mapType, lv)
	local beginTime = radianceWarRead.getBuildOpenTime(mapType, lv)
	local ret = 0
	if beginTime then
		local sysTime = serviceFunctions.systemTime()
		if beginTime > sysTime then
			return beginTime - sysTime
		end
	end
	return ret
end)[7], gRadianceWarMapZoneRect = cc.rect(453, 458, 294, 284)
local gGetRadianceWarMapZone = function(x, y)
	local pos = cc.p(x, y)
	for i = #gRadianceWarMapZoneRect, 1, -1 do
		local rect = gRadianceWarMapZoneRect[i]
		if cc.rectContainsPoint(rect, pos) then
			return i
		end
	end
	return 1
end
local toRect = cc.rect(589, 589, 22, 22)
local isInWarForbidSpeed_imp = function(queue, noshowTips, activity)
	local ret = true
	if queue:getToMapType() ~= gMapObjTypeDef.mapTypeRadianceWarPalace and queue:getToMapType() ~= gMapObjTypeDef.mapTypeRadianceWarBeacon then
		worldMapDefine.isInWarForbid(noshowTips, activity)
	elseif gGetRadianceWarMapZone(queue:getFromX(), queue:getFromY()) ~= 3 then
		if not noshowTips then
			if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
				SoraDShowMsgTip(i18n("brightWar_text_214"))
			else
				SoraDShowMsgTip(i18n("brightWar_text_212"))
			end
		end
	elseif not cc.rectContainsPoint(toRect, cc.p(queue:getToX(), queue:getToY())) then
		if not noshowTips then
			if queue:getMoveLineType() == gMapMoveLineType.moveLineTypeMass then
				SoraDShowMsgTip(i18n("brightWar_text_215"))
			else
				SoraDShowMsgTip(i18n("brightWar_text_213"))
			end
		end
	else
		ret = false
	end
	return ret
end
function radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	local ret = true
	if queue then
		if queue:getQueueType() == _G.gMapMoveLineServerType.moveLineTypeReturn then
			ret = false
		elseif queue:isMainQueueFun() then
			return isInWarForbidSpeed_imp(queue, noshowTips, activity)
		elseif queue:isWorking() then
			local mainQueue = kingdomMapCtrl.kingdomMapCell:getMassMainQueue(queue:getMainId())
			if mainQueue then
				return isInWarForbidSpeed_imp(mainQueue, noshowTips, activity)
			else
				ret = false
			end
		else
			ret = false
		end
	end
	return ret
end
return radianceWarUtil
