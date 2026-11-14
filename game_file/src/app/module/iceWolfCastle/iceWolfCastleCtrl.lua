local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local iceWolfCastleCtrl = class("iceWolfCastleCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function iceWolfCastleCtrl:ctor(properties)
	iceWolfCastleCtrl.super.ctor(self, properties)
	self:resetData()
end
function iceWolfCastleCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_SHINING_CASTLE_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SHINING_CASTLE_ACTIVITY_DATA_5, handler(self, self.reqRamadanShiningCastleActivityData4Rsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_SHINING_CASTLE_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SHINING_CASTLE_ACTIVITY_RANK_5, handler(self, self.reqRamadanShiningCastleActivityRank4Rsp))
	self:registerNotify()
end
function iceWolfCastleCtrl:Logout()
	iceWolfCastleCtrl.super.Logout(self)
	self:resetData()
end
function iceWolfCastleCtrl:resetData()
	self.myInfo, _UPVALUE0_ = nil, nil
end
function iceWolfCastleCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_SHINING_CASTLE_ACTIVITY, handler(self, self.notifyHandler))
end
function iceWolfCastleCtrl:notifyHandler(event)
	dump(event.data, "iceWolfCastleCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.data.shiningNum then
			self.myInfo.shiningNum = v.data.shiningNum
		end
		if v.data.shiningRank then
			self.myInfo.shiningRank = v.data.shiningRank
		end
		if v.data.giveNum then
			self.myInfo.giveNum = v.data.giveNum
		end
		if v.data.giveRank then
			self.myInfo.giveRank = v.data.giveRank
		end
		_ENV = v.data.giveRank
		v.data.giveRank.msg = "MESSAGE_ICE_WOLF_CASTLE_REFRESH"
		v.data.giveRank.subMsg = "refresh"
		SoraDSendMessage(v.data.giveRank)
	end
end
function iceWolfCastleCtrl:reqRamadanShiningCastleActivityData4()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RAMADAN_SHINING_CASTLE_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SHINING_CASTLE_ACTIVITY_DATA_5, nil)
end
function iceWolfCastleCtrl:reqRamadanShiningCastleActivityRank4(data)
	serverproxy:Request(gCmd.CMD_RAMADAN_SHINING_CASTLE_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_SHINING_CASTLE_ACTIVITY_RANK_5, data)
end
function iceWolfCastleCtrl:reqRamadanShiningCastleActivityData4Rsp(content)
	dump(content, "iceWolfCastleCtrl:reqRamadanShiningCastleActivityData4Rsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.myInfo = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ICE_WOLF_CASTLE_REFRESH"
		gErrDef.Err_None.subMsg = "refresh"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function iceWolfCastleCtrl:reqRamadanShiningCastleActivityRank4Rsp(content)
	dump(content, "iceWolfCastleCtrl:reqRamadanShiningCastleActivityRank4Rsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ICE_WOLF_CASTLE_REFRESH"
		gErrDef.Err_None.rankList = content.rspdata.rankList
		gErrDef.Err_None.myInfo = content.rspdata.myInfo
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function iceWolfCastleCtrl:getGiveNum()
	return self.myInfo.giveNum or 0
end
function iceWolfCastleCtrl:getGiveRank()
	return self.myInfo.giveRank or 0
end
function iceWolfCastleCtrl:getShiningNum()
	return self.myInfo.shiningNum or 0
end
function iceWolfCastleCtrl:getShiningRank()
	return self.myInfo.shiningRank or 0
end
return iceWolfCastleCtrl
