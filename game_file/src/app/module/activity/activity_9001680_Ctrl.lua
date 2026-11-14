local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001680_Ctrl = class("activity_9001680_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001680_Read = include("activity_9001680_Read")
function activity_9001680_Ctrl:ctor(properties)
	activity_9001680_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	local constantRead = include("constantRead")
	self.itemID = 1698
	self.boxMax = constantRead.getConstValue("GLODMINER_BOX_MAXNUM", 10)
	self.itemMax = constantRead.getConstValue("GLODMINER_PICK_MAXNUM", 120)
	self.bossTime = constantRead.getConstValue("GLODMINER_BOSS_TIME", 3600)
	self.useItemID = constantRead.getConstValue("GLODMINER_PICK_PACK_ITEMID")
	self.freeItemID = constantRead.getConstValue("GLODMINER_PICK_PACK_FREE_ITEMID")
	self.needStepLv = constantRead.getConstValue("GLODMINER_OPEN_TARGET", 25)
	self.recordMax = 100
	self:resetData()
end
function activity_9001680_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GOLD_MINER_MODULE, gCmd.REQ_GOLD_MINER_DATA, handler(self, self.reqGoldMinerDataRsp))
	msgCtrl.register(gCmd.CMD_GOLD_MINER_MODULE, gCmd.REQ_GOLD_MINER_PICK, handler(self, self.reqGoldMinerPickRsp))
	msgCtrl.register(gCmd.CMD_GOLD_MINER_MODULE, gCmd.REQ_GOLD_MINER_REFRESH_MAP, handler(self, self.reqGoldMinerResetRsp))
	msgCtrl.register(gCmd.CMD_GOLD_MINER_MODULE, gCmd.REQ_GOLD_MINER_BUY_GIFT, handler(self, self.reqGoldMinerBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_GOLD_MINER_MODULE, gCmd.REQ_GOLD_MINER_BATTLE_PASS_ALL_REWARD, handler(self, self.reqGoldMinerBattlePassAllRewardRsp))
	msgCtrl.register(gCmd.CMD_GOLD_MINER_MODULE, gCmd.REQ_GOLD_MINER_TASK_REWARD, handler(self, self.reqGoldMinerTaskRewardRsp))
	self:registerNotify()
end
function activity_9001680_Ctrl:Logout()
	activity_9001680_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001680_Ctrl:initClientData(data)
	self:setData(data)
end
function activity_9001680_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
	self.records, _UPVALUE0_, self.monsterPosList, _UPVALUE0_, self.bossPos = nil, nil, nil, nil, nil
end
function activity_9001680_Ctrl:setData(data, mapChanged, isMapMerge, ignoreMsg, record)
