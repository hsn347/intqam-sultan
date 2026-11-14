local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local starTreasureHuntCtrl = class("starTreasureHuntCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function starTreasureHuntCtrl:ctor(properties)
	starTreasureHuntCtrl.super.ctor(self, properties)
	self:resetData()
end
function starTreasureHuntCtrl:EnterGame()
	msgCtrl.register(gCmd.REQ_STAR_MOON_TREASURE_MODULE, gCmd.REQ_STAR_MOON_TREASURE_INIT, handler(self, self.reqStarMoonTreasureInitRsp))
	msgCtrl.register(gCmd.REQ_STAR_MOON_TREASURE_MODULE, gCmd.REQ_STAR_MOON_TREASURE_SEARCH, handler(self, self.reqStarMoonTreasureSearchRsp))
	self:registerNotify()
end
function starTreasureHuntCtrl:Logout()
	starTreasureHuntCtrl.super.Logout(self)
	self:resetData()
end
function starTreasureHuntCtrl:resetData()
	self.history, _UPVALUE0_, self.count = nil, nil, 1
end
function starTreasureHuntCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STAR_MOON_ACTIVITY, handler(self, self.notifyHandler))
end
function starTreasureHuntCtrl:notifyHandler(event)
	dump(event.data, "starTreasureHuntCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.count = v.data.count
		self.history = v.data.history
		_ENV = nil
		;(nil).msg = "MESSAGE_STARSTREASUREHUNT_REFRESH"
		SoraDSendMessage(nil)
	end
end
function starTreasureHuntCtrl:reqStarMoonTreasureInit()
	serverproxy = nil
	serverproxy:Request(gCmd.REQ_STAR_MOON_TREASURE_MODULE, gCmd.REQ_STAR_MOON_TREASURE_INIT, nil)
end
function starTreasureHuntCtrl:reqStarMoonTreasureSearch()
	serverproxy = nil
	serverproxy:Request(gCmd.REQ_STAR_MOON_TREASURE_MODULE, gCmd.REQ_STAR_MOON_TREASURE_SEARCH, nil)
end
function starTreasureHuntCtrl:reqStarMoonTreasureInitRsp(content)
	dump(content, "starTreasureHuntCtrl:reqStarMoonTreasureInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.count = content.rspdata.data.count
		self.history = content.rspdata.data.history
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_STARSTREASUREHUNT_REFRESH"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function starTreasureHuntCtrl:reqStarMoonTreasureSearchRsp(content)
	dump(content, "starTreasureHuntCtrl:reqStarMoonTreasureSearchRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.count = content.rspdata.data.count
		self.history = content.rspdata.data.history
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_STARSTREASUREHUNT_REFRESH"
		gErrDef.Err_None.reward = content.rspdata.rewards
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function starTreasureHuntCtrl:getNowRound()
	return self.count + 1 or 1
end
function starTreasureHuntCtrl:itemIsLock(itemId)
	for i, v in ipairs(self.history) do
		if v == itemId then
			return true
		end
	end
end
function starTreasureHuntCtrl:canSearch()
	local starTreasureHuntRead = include("starTreasureHuntRead")
	return self.count < starTreasureHuntRead.getConfigNum()
end
return starTreasureHuntCtrl
