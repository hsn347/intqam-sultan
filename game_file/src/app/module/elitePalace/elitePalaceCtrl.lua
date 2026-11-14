local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local cityltCtrl = include("cityltCtrl")
local elitePalaceCtrl = class("elitePalaceCtrl", gameModule)
local _ENV, REQ = "elitePalaceCtrl", "elitePalaceCtrl"
local _ENV, RSP = gameModule, gameModule
function elitePalaceCtrl:ctor()
	elitePalaceCtrl.super.ctor(self)
	elitePalaceCtrl = elitePalaceCtrl.super.ctor
	elitePalaceCtrl.super.ctor.elitePointTotal = 0
	elitePalaceCtrl.super.ctor.dailyElitePointResetTime = 0
	self.data, elitePalaceCtrl.super.ctor.dailyElitePoint = elitePalaceCtrl.super.ctor, 0
end
function elitePalaceCtrl:EnterGame()
	elitePalaceCtrl.super.EnterGame(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ELITE_PALACE, handler(self, RSP.notifyDataRsp))
end
function elitePalaceCtrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
end
function elitePalaceCtrl:Logout()
	elitePalaceCtrl.super.Logout(self)
	self:resetData()
end
function elitePalaceCtrl:initClientData(data)
