local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonDecreeCtrl = class("activityCommonDecreeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonDecreeCtrl:ctor(properties)
	activityCommonDecreeCtrl.super.ctor(self, properties)
	self:resetData()
end
function activityCommonDecreeCtrl:EnterGame()
	_ENV = nil
	_ENV = nil
	;(nil).module = gCmd.CMD_DECORATION_BATTLE_MODULE
	;(nil).init = gCmd.REQ_DECORATION_BATTLE_INIT
	;(nil).questReward = gCmd.REQ_DECORATION_BATTLE_QUEST_REWARD
	;(nil).stageReward = gCmd.REQ_DECORATION_BATTLE_STAGE_REWARD
	self.cmdConfig, (nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001732], (nil).notifyID = nil, nil, gNotifyID.DECORATION_BATTLE
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		if cmdCfg.init then
			msgCtrl.register(cmdCfg.module, cmdCfg.init, handler(self, self.reqInitDataRsp))
		end
		if cmdCfg.questReward then
			msgCtrl.register(cmdCfg.module, cmdCfg.questReward, handler(self, self.reqQuestRewardRsp))
		end
		if cmdCfg.stageReward then
			msgCtrl.register(cmdCfg.module, cmdCfg.stageReward, handler(self, self.reqStageRewardRsp))
		end
	end
	self:registerNotify()
end
function activityCommonDecreeCtrl:Logout()
	activityCommonDecreeCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonDecreeCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function activityCommonDecreeCtrl:initClientData(data)
	dump(data, "activityCommonDecreeCtrl:initClientData===")
end
function activityCommonDecreeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		if cmdCfg.notifyID then
			notifyCtrl:register(cmdCfg.notifyID, handlerEx(self, self.notifyHandler, activityID))
		end
	end
end
function activityCommonDecreeCtrl:notifyHandler(activityID, event)
	dump(event, "activityCommonDecreeCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "refreshData" then
			self:initClientData(activityID, notifyData)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_COMMON_DECREE_UPDATE"
			self.activityID = activityID
			self.subMsg = "init"
			SoraDSendMessage(self)
		elseif notifyType == "buyGift" then
			self:initClientData(activityID, notifyData.initData)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_COMMON_DECREE_UPDATE"
			self.activityID = activityID
			self.subMsg = "buyGift"
			SoraDSendMessage(self)
		end
	end
end
function activityCommonDecreeCtrl:initClientData(activityID, initData)
