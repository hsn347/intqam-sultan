local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local rankingsCtrl = class("rankingsCtrl", GameModule)
function rankingsCtrl:ctor(properties)
	rankingsCtrl.super.ctor(self, properties)
end
function rankingsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RANKINGS_MODULE, gCmd.REQ_GET_RANKINGS_DATA, handler(self, self.getRankingsDataRsp))
	msgCtrl.register(gCmd.CMD_RANKINGS_MODULE, gCmd.REQ_GET_MATCH_KINGDOM_RANKINGS_DATA, handler(self, self.getKingdomRankingsDataRsp))
end
function rankingsCtrl:resetData()
	self.rankRewardData, _UPVALUE0_ = nil, nil
end
function rankingsCtrl:initClientData(data)
	if not data then
		return
	end
	self.rankRewardData = data
	self:registerNotify()
end
function rankingsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.RANK_REWARD, handler(self, self.notifyHandler))
end
function rankingsCtrl:notifyHandler(event)
	if event and type(event.data) == "table" then
		for _, data in pairs(event.data) do
			if data.rankRewardData then
				self.rankRewardData = data.rankRewardData
			end
		end
	end
end
function rankingsCtrl:getRankRewardData(ranktype)
	if not self.rankRewardData or not self.rankRewardData[tostring(ranktype)] then
		_ENV = self.rankRewardData[tostring(ranktype)]
	end
	return self.rankRewardData[tostring(ranktype)]
end
function rankingsCtrl:getRankings(rtype, ...)
	if rtype == lordRankingsDef.partyRank then
		SoraDGetCtrl("partyCtrl"):sendPointRank(...)
	else
		_ENV = ...
		....type = rtype
		serverproxy:Request(gCmd.CMD_RANKINGS_MODULE, gCmd.REQ_GET_RANKINGS_DATA, ...)
	end
end
function rankingsCtrl:getRankingsDataRsp(respone)
	if respone.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RANKINGS_SUCCESS"
		gErrDef.Err_None.rank = respone.data
		gErrDef.Err_None.type = respone.type
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function rankingsCtrl:getKingdomRankings(rtype, ...)
	serverproxy = nil
	;(nil).type = rtype
	serverproxy:Request(gCmd.CMD_RANKINGS_MODULE, gCmd.REQ_GET_MATCH_KINGDOM_RANKINGS_DATA, nil, ...)
end
function rankingsCtrl:getKingdomRankingsDataRsp(respone)
	if respone.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_RANKINGS_SUCCESS"
		gErrDef.Err_None.rank = respone.data
		gErrDef.Err_None.type = respone.type
		gErrDef.Err_None.isKingdomBattle = true
		SoraDSendMessage(gErrDef.Err_None)
	end
end
return rankingsCtrl
