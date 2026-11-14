local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local endlessTreasureCtrl = class("endlessTreasureCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function endlessTreasureCtrl:ctor(properties)
	endlessTreasureCtrl.super.ctor(self, properties)
	self:resetData()
end
function endlessTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ENDLESS_TREASURE_MODULE, gCmd.REQ_ENDLESS_TREASURE_REMOVE, handler(self, self.reqRemoveRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TREASURE_MODULE, gCmd.REQ_ENDLESS_TREASURE_EXCAVATE, handler(self, self.reqExcavateRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TREASURE_MODULE, gCmd.REQ_ENDLESS_TREASURE_PUSH_EXCAVATE_WAIT, handler(self, self.reqJoinRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TREASURE_MODULE, gCmd.REQ_ENDLESS_TREASURE_CANCEL_EXCAVATE_WAIT, handler(self, self.reqCancelRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TREASURE_MODULE, gCmd.REQ_ENDLESS_TREASURE_RECEIVE_TREASURE_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_ENDLESS_TREASURE_MODULE, gCmd.REQ_ENDLESS_TREASURE_STOP_EXCAVATE, handler(self, self.reqStopDigRsp))
end
function endlessTreasureCtrl:Logout()
	endlessTreasureCtrl.super.Logout(self)
	self:resetData()
end
function endlessTreasureCtrl:resetData()
	self.treasureData, _UPVALUE0_ = nil, nil
end
function endlessTreasureCtrl:initClientData(data)
