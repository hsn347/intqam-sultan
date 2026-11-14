local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local htPointMgr = include("htPointMgr")
local htMapMgr = include("htMapMgr")
local htBattleMgr = include("htBattleMgr")
local htLogMgr = include("htLogMgr")
local htLikeMgr = include("htLikeMgr")
local heroTrialltCtrl = include("heroTrialltCtrl")
local heroTrialCtrl = class("heroTrialCtrl", gameModule)
local _ENV, REQ = "heroTrialCtrl", "heroTrialCtrl"
local _ENV, RSP = gameModule, gameModule
function heroTrialCtrl:initClientData(data)
	if not data then
		REQ.reqInitData()
		return
	end
	local htPointData = data.htPointData
	htPointMgr.init(htPointData)
	local mapInfo = data.mapInfo
	htMapMgr.init(mapInfo)
	local logList = data.logList
	local logMapID = data.logMapID
	htLogMgr.init(logList, logMapID)
	local battleData = data.battleData
	htBattleMgr.init(battleData)
	htLikeMgr.init()
end
function heroTrialCtrl:getMarchInfo()
end
function heroTrialCtrl:getMapInfo(mapID)
	assert(heroTrialltCtrl.isMapID(mapID), string.format("heroTrialCtrl.getMapInfo: (%s) is not a mapID!", tostring(mapID)))
	REQ.reqMapInfo(mapID)
end
function heroTrialCtrl:getBattleReport(logID)
	local report = htLogMgr.getLogDetail(logID)
	if report then
		return
	end
	REQ.reqBattleReport(logID)
end
function heroTrialCtrl:openTrial(mapID)
	if not mapID then
		return
	end
	assert(heroTrialltCtrl.isMapID(mapID), string.format("heroTrialCtrl.openTrial: (%s) is not a mapID!", tostring(mapID)))
	local ret = htBattleMgr.whetherTrialCanOpen(mapID)
	if gErrDef.Err_None ~= ret then
		print("heroTrialCtrl.openTrial: mapID, ret = ", mapID, ret)
		return
	end
	REQ.reqOpenTrial(mapID)
end
function heroTrialCtrl:quitTrial()
	local ret = htBattleMgr.whetherTrialCanQuit()
	if gErrDef.Err_None ~= ret then
		print("heroTrialCtrl.quitTrial: ret = ", ret)
		return
	end
	REQ.reqQuitTrial()
end
function heroTrialCtrl:attackStage(stageID, soldiers)
	assert(heroTrialltCtrl.isStageID(stageID), string.format("heroTrialCtrl.attackStage: (%s) is not a stageID!", tostring(stageID)))
	local ret = htBattleMgr.whetherCanGeneralTrial(stageID, soldiers)
	if gErrDef.Err_None ~= ret then
		print("heroTrialCtrl.attackStage: stageID, ret = ", stageID, ret)
		return
	end
	REQ.reqGeneralTrial(stageID, soldiers)
end
function heroTrialCtrl:autoTrial(stageID, soldiers)
	assert(heroTrialltCtrl.isStageID(stageID), string.format("heroTrialCtrl.autoTrial: (%s) is not a stageID!", tostring(stageID)))
	REQ.reqAutoTrial(stageID, soldiers)
end
function heroTrialCtrl:quitAutoTrial()
	local ret = htBattleMgr.stopAutoTrial()
	if gErrDef.Err_None ~= ret then
		return
	end
	REQ.reqStopAutoTrial()
end
function heroTrialCtrl:like(mapID, uid, rank)
	assert(heroTrialltCtrl.isMapID(mapID), string.format("heroTrialCtrl.like: (%s) is not a mapID!", tostring(mapID)))
	assert("number" == type(uid) and 0 < uid, string.format("heroTrialCtrl.like: (%s) is not a uid!", tostring(uid)))
	assert("number" == type(rank) and 0 < rank, string.format("heroTrialCtrl.like: (%s) is not a rank!", tostring(rank)))
	if not htMapMgr.whetherMapUnlock(mapID) then
		print(string.format("heroTrialCtrl.like: the map(%s) has been unlocked!", mapID))
		return gErrDef.Err_HT_MAP_NOT_UNLOCK
	end
	local ok, ret = htLikeMgr.whetherMapLikedToday(mapID)
	print("ok, ret = ", ok, ret)
	if ok then
		return ret
	end
	REQ.reqLike(mapID, uid, rank)
end
function heroTrialCtrl:speedUp(itemID, SUType)
	REQ.reqSpeedUp(itemID, SUType)
end
function REQ.reqOpenTrial(mapID)
	serverproxy = nil
	local (nil).mapID, data = mapID, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_OPEN_TRIAL, data)
end
function REQ.reqQuitTrial()
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_QUIT_TRIAL)
end
function REQ.reqGeneralTrial(stageID, soldiers)
	serverproxy = nil
	;(nil).stageID = stageID
	local (nil).soldiers, data = soldiers, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_GENERAl_TRIAL, data)
end
function REQ.reqAutoTrial(stageID, soldiers)
	serverproxy = nil
	;(nil).stageID = stageID
	local (nil).soldiers, data = soldiers, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_AUTO_TRIAL, data)
end
function REQ.reqStopAutoTrial()
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_STOP_AUTO_TRIAL)
end
function REQ.reqLike(mapID, uid, rank)
	serverproxy = nil
	;(nil).mapID = mapID
	;(nil).uid = uid
	local (nil).rank, data = rank, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_LIKE, data)
end
function REQ.reqBattleReport(logID)
	serverproxy = nil
	local (nil).logID, data = logID, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_BATTLE_REPORT, data)
end
function REQ.reqMapInfo(mapID)
	serverproxy = nil
	local (nil).mapID, data = mapID, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_MAP_INFO, data)
end
function REQ.reqSpeedUp(itemID, SUType)
	serverproxy = nil
	;(nil).itemID = itemID
	local (nil).SUType, data = SUType, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_SPEED_UP, data)
end
function REQ.reqInitData()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_INIT_DATA, data)
end
function heroTrialCtrl:reqSweep(mapID)
	serverproxy = nil
	local (nil).mapID, data = mapID, nil
	serverproxy:Request(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_SWEEP, data)
end
function RSP:noitfyDataRsp(content)
	dump(content.data, "heroTrialCtrl.noitfyDataRsp", 10)
	for i, notifyData in ipairs(content.data) do
		local notifyType = notifyData.notifyType
		if "addPoint" == notifyType then
			local changePoint = notifyData.changePoint
			local curPoint = notifyData.curPoint
			htPointMgr.setPoint(curPoint)
			htPointMgr.updateReceiverQueue()
			local inRCD = notifyData.inRCD
			if inRCD then
				local bTime = notifyData.bTime
				htPointMgr.setBeginTimeOfRecovry(bTime)
			end
			_ENV = htPointMgr.setBeginTimeOfRecovry
			htPointMgr.setBeginTimeOfRecovry.msg = "MESSAGE_SERVER_HEROTRIAL_POINT_UPDATE"
			SoraDSendMessage(htPointMgr.setBeginTimeOfRecovry)
		elseif "subPoint" == notifyType then
			local changePoint = notifyData.changePoint
			local curPoint = notifyData.curPoint
			htPointMgr.setPoint(curPoint)
			htPointMgr.updateReceiverQueue()
			local inRCD = notifyData.inRCD
			if inRCD then
				local bTime = notifyData.bTime
				htPointMgr.setBeginTimeOfRecovry(bTime)
			end
			_ENV = htPointMgr.setBeginTimeOfRecovry
			htPointMgr.setBeginTimeOfRecovry.msg = "MESSAGE_SERVER_HEROTRIAL_POINT_UPDATE"
			SoraDSendMessage(htPointMgr.setBeginTimeOfRecovry)
		elseif "prepare" == notifyType then
			local bTime = notifyData.bTime
			local preTime = notifyData.preTime
			htBattleMgr.autoTrial(bTime, preTime)
			_ENV = bTime
			bTime.msg = "MESSAGE_SERVER_HEROTRIAL_AUTOTIME"
			SoraDSendMessage(bTime)
		elseif "march" == notifyType then
			local stageID = notifyData.stageID
			local soldiers = notifyData.soldiers
			local bTime = notifyData.bTime
			local marchTime = notifyData.marchTime
			local mvTimeData = notifyData.mvTimeData
			local ret = htBattleMgr.setMVTimeData(mvTimeData)
			htBattleMgr.generalTrial(stageID, soldiers, bTime, marchTime)
			_ENV = stageID
			stageID.msg = "MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE"
			SoraDSendMessage(stageID)
		elseif "battle" == notifyType then
			local stageID = notifyData.stageID
			local battleRet = notifyData.battleRet
			local finish = notifyData.finish
			local soldiers = notifyData.soldiers
			local deSoldiers = notifyData.deSoldiers
			local marchSoldiers = notifyData.marchSoldiers
			htBattleMgr.finishBattle(battleRet, stageID, finish, soldiers, deSoldiers)
			if battleRet then
				htMapMgr.setLastCompleteStage(stageID)
			end
			_ENV = stageID
			stageID.msg = "MESSAGE_SERVER_HEROTRIAL_END_BATTLE"
			stageID.soldiers = marchSoldiers
			stageID.battleRet = battleRet
			stageID.finish = finish
			SoraDSendMessage(stageID)
		elseif "log" == notifyType then
			local logID = notifyData.logID
			local logData = notifyData.logData
			logData.logID = logID
			htLogMgr.record(logData)
			_ENV = logData
			logData.msg = "MESSAGE_SERVER_HEROTRIAL_UPDATE_LOG"
			logData.data = logData
			SoraDSendMessage(logData)
		elseif "stopAuto" == notifyType then
			htBattleMgr.stopAutoTrial()
			_ENV = notifyData.logData
			notifyData.logData.msg = "MESSAGE_SERVER_HEROTRIAL_STOP_AUTO"
			SoraDSendMessage(notifyData.logData)
		end
	end
	_ENV = ipairs(content.data)
	ipairs(content.data).msg = "MESSAGE_UI_PANDECT_TRIAL"
	ipairs(content.data).queueType = gQueueTypeDef.trial_march
	SoraDSendMessage(ipairs(content.data))
end
function RSP:openTrialRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local rspData = rsp.data
		local mapID = rspData.mapID
		local soldiers = rspData.soldiers
		htBattleMgr.openTrial(mapID, soldiers)
	end
	_ENV = rspData.mapID
	rspData.mapID.msg = "MESSAGE_SERVER_HEROTRIAL_RSP"
	rspData.mapID.rsp = rsp
	SoraDSendMessage(rspData.mapID)
end
function RSP:quitTrialRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		htBattleMgr.quitTrial()
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROTRIAL_RSP"
	gErrDef.Err_None.rsp = rsp
	SoraDSendMessage(gErrDef.Err_None)
end
function RSP:generalTrialRsp(rsp)
	if rsp.err == gErrDef.Err_None then
	end
end
function RSP:autoTrialRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		htBattleMgr.openAutoTrial()
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROTRIAL_RSP"
	gErrDef.Err_None.rsp = rsp
	SoraDSendMessage(gErrDef.Err_None)
end
function RSP:stopAutoTrialRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local rspData = rsp.data
	end
end
function RSP:likeRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local rspData = rsp.data
		local mapID = rspData.mapID
		local rankingData = rspData.rankingData
		local time = rspData.time
		htLikeMgr.recordLike(mapID, time)
	else
		local rspData = rsp.data
		local mapID = rspData.mapID
		local time = rspData.time
		htLikeMgr.recordLike(mapID, time)
	end
	_ENV = rspData.mapID
	rspData.mapID.msg = "MESSAGE_SERVER_HEROTRIAL_RSP"
	rspData.mapID.rsp = rsp
	SoraDSendMessage(rspData.mapID)
end
function RSP:getReportRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local rspData = rsp.data
	end
end
function RSP:getMapInfoRsp(rsp)
	dump(rsp, "heroTrialCtrl.getMapInfoRsp", 10)
	if rsp.err == gErrDef.Err_None then
		local rspData = rsp.data
		local likeStatus = rspData.likeStatus
		local rankingData = rspData.rankingData
		local mapID = rspData.mapID
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_HEROTRIAL_MAPINFO"
		;(nil).likeStatus = likeStatus
		;(nil).rankingData = rankingData
		;(nil).mapID = mapID
		SoraDSendMessage(nil)
		if likeStatus then
			htLikeMgr.recordLike(mapID)
		end
		htLikeMgr.dump()
	end
end
function RSP:speedUpRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local rspData = rsp.data
		local mvTimeData = rspData.mvTimeData
		local reduceTime = rspData.reduceTime
		local moveTime = rspData.moveTime
		local ret = htBattleMgr.setMVTimeData(mvTimeData, moveTime)
		htBattleMgr.speedUp(reduceTime)
		_ENV = reduceTime
		reduceTime.msg = "MESSAGE_SERVER_HEROTRIAL_SPEEDUP"
		reduceTime.mvTimeData = ret
		SoraDSendMessage(reduceTime)
	end
end
function RSP:reqInitDataRsp(rsp)
	dump(rsp, "heroTrialCtrl.reqInitDataRsp", 10)
	if rsp.err == gErrDef.Err_None then
		local data = rsp.data
		if not data then
			return
		end
		local htPointData = data.htPointData
		htPointMgr.init(htPointData)
		local mapInfo = data.mapInfo
		htMapMgr.init(mapInfo)
		local logList = data.logList
		local logMapID = data.logMapID
		htLogMgr.init(logList, logMapID)
		local battleData = data.battleData
		htBattleMgr.init(battleData)
		htLikeMgr.init()
	end
end
function RSP:reqSweepRsp(rsp)
	dump(rsp, "heroTrialCtrl.reqSweepRsp", 10)
	if rsp.err == gErrDef.Err_None then
		local panel = SoraDCreatePanel("commonRewardPopView")
		_ENV = 10
		;(10).rewards = rsp.rspdata
		;(10).des = i18n("privilege_text_99")
		;(10).title = i18n("epicbattle_btn_01")
		;(10).btnText = i18n("common_text_204")
		panel:initData(10)
		panel:show()
	end
end
function heroTrialCtrl:ctor(properties)
	heroTrialCtrl.super.ctor(self, properties)
end
function heroTrialCtrl:EnterGame()
	heroTrialCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_OPEN_TRIAL, handler(self, RSP.openTrialRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_QUIT_TRIAL, handler(self, RSP.quitTrialRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_GENERAl_TRIAL, handler(self, RSP.generalTrialRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_AUTO_TRIAL, handler(self, RSP.autoTrialRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_STOP_AUTO_TRIAL, handler(self, RSP.stopAutoTrialRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_LIKE, handler(self, RSP.likeRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_BATTLE_REPORT, handler(self, RSP.getReportRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_MAP_INFO, handler(self, RSP.getMapInfoRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_SPEED_UP, handler(self, RSP.speedUpRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_INIT_DATA, handler(self, RSP.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_HT_MODULE, gCmd.REQ_HT_SWEEP, handler(self, RSP.reqSweepRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.HERO_TRIAL, handler(self, RSP.noitfyDataRsp))
end
function heroTrialCtrl:resetData()
	htPointMgr.logout()
	htMapMgr.logout()
	htLogMgr.logout()
	htBattleMgr.logout()
	htLikeMgr.logout()
end
function heroTrialCtrl:Logout()
	heroTrialCtrl.super.Logout(self)
	self:resetData()
end
return heroTrialCtrl
