local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local heroSecretCtrl = class("heroSecretCtrl", GameModule)
function heroSecretCtrl:ctor(properties)
	heroSecretCtrl.super.ctor(self, properties)
end
function heroSecretCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_SECRET_MODULE, gCmd.REQ_HERO_SECRET_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_HERO_SECRET_MODULE, gCmd.REQ_HERO_SECRET_DRAW, handler(self, self.sendReqExtractRsp))
	msgCtrl.register(gCmd.CMD_HERO_SECRET_MODULE, gCmd.REQ_HERO_SECRET_STAGE_REWARD, handler(self, self.sendReqStageRewardRsp))
	self:resetData()
	self:registerNotify()
end
function heroSecretCtrl:Logout()
	self:resetData()
	heroSecretCtrl.super.Logout(self)
end
function heroSecretCtrl:initClientData(content)
	if not content then
		return
	end
	self.allUnLocked = content.allUnLocked
	self.cost = content.cost
	self.group = content.group
	self.exTractRecord = content.drawRecord
	self.stageRecord = content.stageRecord
	self.luckPoint = content.luckPoint or 0
end
function heroSecretCtrl:resetData()
	self.allUnLocked = false
	self.cost = 0
	self.stageRecord, _UPVALUE0_, self.exTractRecord, _UPVALUE0_, self.group = nil, nil, nil, nil, 1
	self.luckPoint = 0
end
function heroSecretCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_SECRET, handler(self, self.notifyCallback))
end
function heroSecretCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_HERO_SECRET_MODULE, gCmd.REQ_HERO_SECRET_INIT)
end
function heroSecretCtrl:sendExtractMsg()
	serverproxy:Request(gCmd.CMD_HERO_SECRET_MODULE, gCmd.REQ_HERO_SECRET_DRAW)
end
function heroSecretCtrl:sendGetStageMsg(lotteryTime)
	serverproxy = nil
	;(nil).lotteryTime = lotteryTime
	serverproxy:Request(gCmd.CMD_HERO_SECRET_MODULE, gCmd.REQ_HERO_SECRET_STAGE_REWARD, nil)
end
function heroSecretCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			local data = content
			self.allUnLocked = data.allUnLocked
			self.cost = data.cost
			self.group = data.group
			self.exTractRecord = data.drawRecord
			self.stageRecord = data.stageRecord
			self.luckPoint = data.luckPoint
			_ENV = nil
			;(nil).msg = "MESSAGE_HEROSECRET_REFRESH"
			;(nil).subMsg = "init"
			SoraDSendMessage(nil)
		end
	end
end
function heroSecretCtrl:sendReqInfoRsp(content)
	dump(content, "==heroSecretCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.heroSecretData
		self.allUnLocked = data.allUnLocked
		self.cost = data.cost
		self.group = data.group
		self.exTractRecord = data.drawRecord
		self.stageRecord = data.stageRecord
		self.luckPoint = data.luckPoint
		_ENV = "==heroSecretCtrl:sendReqInfoRsp=="
		;("==heroSecretCtrl:sendReqInfoRsp==").msg = "MESSAGE_HEROSECRET_REFRESH"
		;("==heroSecretCtrl:sendReqInfoRsp==").subMsg = "init"
		SoraDSendMessage("==heroSecretCtrl:sendReqInfoRsp==")
	end
end
function heroSecretCtrl:sendReqExtractRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.heroSecretData
		self.allUnLocked = data.allUnLocked
		self.cost = data.cost
		self.group = data.group
		self.exTractRecord = data.drawRecord
		self.stageRecord = data.stageRecord
		self.luckPoint = data.luckPoint
		_ENV = nil
		;(nil).msg = "MESSAGE_HEROSECRET_REFRESH"
		;(nil).subMsg = "extract"
		;(nil).reward = content.rspdata.reward
		SoraDSendMessage(nil)
	end
end
function heroSecretCtrl:sendReqStageRewardRsp(content)
	dump(content, "==heroSecretCtrl:sendReqStageRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.heroSecretData
		self.allUnLocked = data.allUnLocked
		self.cost = data.cost
		self.group = data.group
		self.exTractRecord = data.drawRecord
		self.stageRecord = data.stageRecord
		self.luckPoint = data.luckPoint
		_ENV = "==heroSecretCtrl:sendReqStageRewardRsp=="
		;("==heroSecretCtrl:sendReqStageRewardRsp==").msg = "MESSAGE_HEROSECRET_REFRESH"
		;("==heroSecretCtrl:sendReqStageRewardRsp==").subMsg = "stageReward"
		;("==heroSecretCtrl:sendReqStageRewardRsp==").reward = content.rspdata.reward
		SoraDSendMessage("==heroSecretCtrl:sendReqStageRewardRsp==")
	end
end
function heroSecretCtrl:getLuckyPoint()
	return self.luckPoint
end
function heroSecretCtrl:isCanExtract()
	return not self.allUnLocked
end
function heroSecretCtrl:getNowCost()
	return self.cost or 0
end
function heroSecretCtrl:getGroup()
	return self.group or 1
end
function heroSecretCtrl:getStageReward()
	if not self.stageRecord then
		_UPVALUE0_ = self.stageRecord
	end
	return self.stageRecord
end
function heroSecretCtrl:getNowRound()
	return table.nums(self.exTractRecord) + 1
end
function heroSecretCtrl:itemIsLock(index)
	return self.exTractRecord[tostring(index)]
end
function heroSecretCtrl:getItemNum()
	return table.nums(self.exTractRecord)
end
return heroSecretCtrl
