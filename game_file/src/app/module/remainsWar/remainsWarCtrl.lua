local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = class("remainsWarCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local RW_MSG_TYPE = _G.RW_MSG_TYPE
local RW_CAMP = _G.RW_CAMP
function remainsWarCtrl:reqRemainsWarData(mapId)
	serverproxy = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_RW_MGR_MODULE, gCmd.REQ_RW_DATA, nil)
end
function remainsWarCtrl:reqRemainsWarPlayerPointsList(mapId)
	serverproxy = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_RW_MGR_MODULE, gCmd.REQ_RW_PLAYER_POINTS_LIST, nil)
end
function remainsWarCtrl:reqRemainsWarRomeAttack(mapId)
	serverproxy = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_RW_MGR_MODULE, gCmd.REQ_RW_ROME_ATTACK, nil)
end
function remainsWarCtrl:reqSyncRW(mapId)
	if 0 < mapId then
		serverproxy = nil
		;(nil).mapId = mapId
		serverproxy:Request(gCmd.CMD_RW_MGR_MODULE, gCmd.REQ_SYNC_RW, nil)
	end
end
function remainsWarCtrl:reqStopSyncRW(mapId)
	serverproxy = nil
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_RW_MGR_MODULE, gCmd.REQ_STOP_SYNC_RW, nil)
end
function remainsWarCtrl:reqPlayerBuffList(mapId, uid)
	serverproxy = nil
	;(nil).mapId = mapId
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_RW_MGR_MODULE, gCmd.REQ_RW_PLAYER_BUFF_LIST, nil)
end
function remainsWarCtrl:getRemainsWarData()
	if not self.remainsWarData or not next(self.remainsWarData) then
		_ENV, next(self.remainsWarData).warCampData, _ENV, _ENV = self.remainsWarData, self.remainsWarData, self.remainsWarData, next(self.remainsWarData)
		self.remainsWarData.southPoint = 0
		next(self.remainsWarData).pointsData, self.remainsWarData.northPoint = self.remainsWarData, 0
		next(self.remainsWarData).warStatus = gKingdomWarStatusType.rule
		next(self.remainsWarData).warStartTime = 0
		self.remainsWarData, next(self.remainsWarData).warTotalTime = next(self.remainsWarData), 0
	end
	return self.remainsWarData
end
function remainsWarCtrl:setRemainsWarCampData(warCampData)
