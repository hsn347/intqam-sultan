local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local allianceLog = class("allianceLog", gameModule)
local msgCtrl = include("msgCtrl")
local _ENV, RSP = "msgCtrl", "msgCtrl"
function allianceLog:ctor(properties)
	allianceLog.super.ctor(self, properties)
	self:resetData()
end
function allianceLog:resetData()
	self.loglist, _UPVALUE0_ = nil, nil
end
function allianceLog:EnterGame()
	allianceLog.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_LOG, handler(self, RSP.AllianceLogDataRsp))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BATTLE_RECORD, handler(self, RSP.getBattleRecordRsp))
end
function allianceLog:Logout()
	self:resetData()
end
function allianceLog:addLog(alog)
	local cursize = #self.loglist
	local maxsize = gConstValue.ALLIANCE_LOG_MAX_COUNT + 1
	local tempsize = cursize - maxsize + 1
	if 0 < tempsize then
		for i = 1, tempsize do
			cursize = #self.loglist
			table.remove(self.loglist, cursize)
		end
	end
	table.insert(self.loglist, 1, alog)
end
function allianceLog:sortLogList()
	local _ENV, temp
	local _ENV, keyarray
	for k, logdata in pairs(self.loglist) do
		local key = os.date("%Y-%m-%d-%H", logdata.time)
		if not temp[key] then
			temp[key], _ENV = temp[key], temp[key]
			table.insert(keyarray, key)
		end
		table.insert(temp[key], logdata)
	end
	local _ENV, ret = (for generator), pairs(self.loglist)
	for k, v in pairs(keyarray) do
		local data = temp[v]
		table.sort(data, function(l, r)
			if l and r then
				return l.time > r.time
			else
				return false
			end
		end)
		local key = os.date("%Y-%m-%d %H:%M", data[1].time)
		_ENV = nil
		;(nil).key = key
		;(nil).data = data
		table.insert(ret, nil)
	end
	return ret
end
function allianceLog:getLogList()
	local ret = self:sortLogList()
	return ret
end
function allianceLog:addAllianceNotice()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local alliance = allianceMgr:getAlliance()
	if alliance then
		local alog = clone(gALog)
		alog.tp = gALogType.NOTICE
		alog.data.content = alliance:getProperty("notice")
		alog.time = serviceFunctions.systemTime()
		self:addLog(alog)
	end
end
function allianceLog:modifyLogListNotice(notice)
	for k, alog in pairs(self.loglist) do
		if alog.tp == gALogType.NOTICE then
			alog.data.content = notice
			alog.time = serviceFunctions.systemTime()
		end
	end
end
function allianceLog:reqAllianceLogData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_LOG, nil, ...)
end
function allianceLog:reqBattleRecord(aid, index, atktype, ...)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).index = index
	;(nil).atktype = atktype
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BATTLE_RECORD, nil, ...)
end
function RSP:AllianceLogDataRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self.loglist = data
		self:addAllianceNotice()
		_ENV = self
		self.msg = "MESSAGE_ALLIACNE_GET_LOG_SUCCESS"
		SoraDSendMessage(self)
	else
		print("rsp error: ", content.err)
	end
end
function RSP:getBattleRecordRsp(content)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		_ENV = nil
		;(nil).msg = "MESSAGE_ALLIANCE_GET_WAR_HISTORY_SUCCESS"
		;(nil).historyList = retdata
		;(nil).atktype = content.data.atktype
		SoraDSendMessage(nil)
	else
		print("rsp error: ", content.err)
	end
end
return allianceLog
