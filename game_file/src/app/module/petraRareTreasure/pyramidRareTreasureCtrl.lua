local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local pyramidRareTreasureCtrl = class("pyramidRareTreasureCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function pyramidRareTreasureCtrl:getUnLockLuckyCoin()
	return self.activityData.unlockedLuckyCoin or 0
end
function pyramidRareTreasureCtrl:getLockLuckyCoin()
	return self.activityData.lockedLuckyCoin or 0
end
function pyramidRareTreasureCtrl:getBestTreasureID()
	return self.activityData.bestTreasureId or 0
end
function pyramidRareTreasureCtrl:hasBestTreasureID()
	return self:getBestTreasureID() ~= 0
end
function pyramidRareTreasureCtrl:getBestTreasureTimes()
	return self.activityData.bestTreasureTimes or 0
end
function pyramidRareTreasureCtrl:getLotternTimes()
	return (self.activityData.freeTimes or 0) + (self.activityData.reffleTicket or 0)
end
function pyramidRareTreasureCtrl:getGroupType()
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(gActivityTimeActivityID.PYRAMID_TREASURE_ACTIVITY)
	return param and param.classtype or 1
end
function pyramidRareTreasureCtrl:reqTreasureLottory()
	print("pyramidRareTreasureCtrl:reqTreasureLottory")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_TREASURE_LOTTORY)
end
function pyramidRareTreasureCtrl:reqLuckyCoinRecord()
	print("pyramidRareTreasureCtrl:reqLuckyCoinRecord")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_LUCKY_COIN_RECORD)
end
function pyramidRareTreasureCtrl:reqSelectBestTreasure(index)
	print("pyramidRareTreasureCtrl:reqSelectBestTreasure", index)
	_ENV = nil
	;(nil).bestTreasureId = index
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_SELECT_BEST_TREASURE, nil)
end
function pyramidRareTreasureCtrl:reqTreasureLottoryTen()
	print("pyramidRareTreasureCtrl:reqTreasureLottoryTen")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_TREASURE_LOTTORY_TEN)
end
function pyramidRareTreasureCtrl:reqTreasureAllLog(data)
	print("pyramidRareTreasureCtrl:reqTreasureAllLog")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_BEST_TREASURE_RECORD, data)
end
function pyramidRareTreasureCtrl:reqTreasureMyLog()
	print("pyramidRareTreasureCtrl:reqTreasureMyLog")
	serverproxy:Request(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_MY_BEST_TREASURE_RECORD)
end
function pyramidRareTreasureCtrl:ctor(properties)
	pyramidRareTreasureCtrl.super.ctor(self, properties)
end
function pyramidRareTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_SELECT_BEST_TREASURE, handler(self, self.selectBestTreasureRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_TREASURE_LOTTORY, handler(self, self.treasureLottoryRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_TREASURE_LOTTORY_TEN, handler(self, self.treasureLottoryTenRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_LUCKY_COIN_RECORD, handler(self, self.luckyCoinRecordRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_BEST_TREASURE_RECORD, handler(self, self.treasureAllLogRSP))
	msgCtrl.register(gCmd.CMD_PETRA_RARE_TREASURE_MODULE, gCmd.REQ_PYRAMID_MY_BEST_TREASURE_RECORD, handler(self, self.treasureMyLogRSP))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.PETRA_RARE_TREASURE, handler(self, self.onMsg))
	self:resetData()
end
function pyramidRareTreasureCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function pyramidRareTreasureCtrl:Logout()
	pyramidRareTreasureCtrl.super.Logout(self)
	self:resetData()
end
function pyramidRareTreasureCtrl:setActivityData(data)
