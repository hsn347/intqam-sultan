local activityCommonRankRead = include("activityCommonRankRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonRankCtrl = class("activityCommonRankCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonRankCtrl:ctor(properties)
	activityCommonRankCtrl.super.ctor(self, properties)
	self:resetData()
end
function activityCommonRankCtrl:EnterGame()
	local constantRead = include("constantRead")
	_ENV = "constantRead"
	_ENV = nil
	;(nil).module = gCmd.CMD_BALL_FIELD_MATCH_MODULE
	;(nil).rank = gCmd.REQ_BALL_FIELD_MATCH_RANKING
	self.cmdConfig, ("constantRead")[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], (nil).rankMax = "constantRead", nil, nil
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		msgCtrl.register(cmdCfg.module, cmdCfg.rank, handler(self, self.reqRankingRsp))
	end
end
function activityCommonRankCtrl:Logout()
	activityCommonRankCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonRankCtrl:resetData()
end
function activityCommonRankCtrl:reqRanking(activityID, iBegin, nCount)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	;(nil).iBegin = iBegin
	serverproxy, (nil).nCount = nil, nCount
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.rank, nil, nil)
end
function activityCommonRankCtrl:reqRankingRsp(content)
	dump(content, "activityCommonRankCtrl:reqRankingRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, rspdata = content.rspdata, content.rspdata
		end
		_ENV = 10
		;(10).msg = "MESSAGE_ACTIVITY_COMMON_RANK_UPDATE"
		;(10).activityID = self.activityID
		;(10).rspdata = rspdata
		SoraDSendMessage(10)
	end
end
function activityCommonRankCtrl:getRankMax(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	local rankMax = cmdCfg.rankMax
	if not rankMax then
		rankMax = activityCommonRankRead.getRankMax(activityID)
		cmdCfg.rankMax = rankMax
	end
	return rankMax
end
return activityCommonRankCtrl
