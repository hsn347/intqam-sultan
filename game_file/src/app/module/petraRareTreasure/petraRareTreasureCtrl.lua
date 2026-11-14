local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local petraRareTreasureCtrl = class("petraRareTreasureCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function petraRareTreasureCtrl:getUnLockLuckyCoin()
	return self.activityData.unlockedLuckyCoin or 0
end
function petraRareTreasureCtrl:getLockLuckyCoin()
	return self.activityData.lockedLuckyCoin or 0
end
function petraRareTreasureCtrl:getBestTreasureID()
	return self.activityData.bestTreasureId or 0
end
function petraRareTreasureCtrl:hasBestTreasureID()
	return self:getBestTreasureID() ~= 0
end
function petraRareTreasureCtrl:getBestTreasureTimes()
	return self.activityData.bestTreasureTimes or 0
end
function petraRareTreasureCtrl:getLotternTimes()
	return (self.activityData.freeTimes or 0) + (self.activityData.reffleTicket or 0)
end
function petraRareTreasureCtrl:reqTreasureLottory()
	print("petraRareTreasureCtrl:reqTreasureLottory")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_TREASURE_LOTTORY)
end
function petraRareTreasureCtrl:reqLuckyCoinRecord()
	print("petraRareTreasureCtrl:reqLuckyCoinRecord")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_LUCKY_COIN_RECORD)
end
function petraRareTreasureCtrl:reqSelectBestTreasure(index)
	print("petraRareTreasureCtrl:reqSelectBestTreasure", index)
	_ENV = nil
	;(nil).bestTreasureId = index
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_SELECT_BEST_TREASURE, nil)
end
function petraRareTreasureCtrl:reqTreasureLottoryTen()
	print("petraRareTreasureCtrl:reqTreasureLottoryTen")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_TREASURE_LOTTORY_TEN)
end
function petraRareTreasureCtrl:reqTreasureAllLog(data)
	print("petraRareTreasureCtrl:reqTreasureAllLog")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_BEST_TREASURE_RECORD, data)
end
function petraRareTreasureCtrl:reqTreasureMyLog()
	print("petraRareTreasureCtrl:reqTreasureMyLog")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_MY_BEST_TREASURE_RECORD)
end
function petraRareTreasureCtrl:ctor(properties)
	petraRareTreasureCtrl.super.ctor(self, properties)
end
function petraRareTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_LUCKY_COIN_RECORD, handler(self, self.luckyCoinRecordRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_SELECT_BEST_TREASURE, handler(self, self.selectBestTreasureRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_TREASURE_LOTTORY, handler(self, self.treasureLottoryRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_TREASURE_LOTTORY_TEN, handler(self, self.treasureLottoryTenRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_BEST_TREASURE_RECORD, handler(self, self.treasureAllLogRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_MY_BEST_TREASURE_RECORD, handler(self, self.treasureMyLogRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.PETRA_RARE_TREASURE, handler(self, self.onMsg))
	self:resetData()
end
function petraRareTreasureCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function petraRareTreasureCtrl:Logout()
	petraRareTreasureCtrl.super.Logout(self)
	self:resetData()
end
function petraRareTreasureCtrl:setActivityData(data)
