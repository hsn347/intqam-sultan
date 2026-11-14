local starryNightCarnivalltCtrl = include("starryNightCarnivalltCtrl")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local starryNightCarnivalCtrl = class("starryNightCarnivalCtrl", GameModule)
function starryNightCarnivalCtrl:ctor(properties)
	starryNightCarnivalCtrl.super.ctor(self, properties)
end
function starryNightCarnivalCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_DONATE, handler(self, self.sendReqDonateRsp))
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_CLAIM, handler(self, self.sendReqRewardRsp))
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_BUY_GIFT, handler(self, self.sendOpenFutherRsp))
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_CLAIM_ALL, handler(self, self.sendReqAllRewardRsp))
	self:resetData()
	self:registerNotify()
end
function starryNightCarnivalCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STARRY_NIGHT_CARNIVAL, handler(self, self.notifyHandler))
end
function starryNightCarnivalCtrl:notifyHandler(event)
	dump(event.data, "starryNightCarnivalCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.type == "buyGift" then
			if v.success then
				self:popRechargeSuccessView(v)
			end
		elseif v.type == "unlockFurther" then
			self.bUnlockFurther = true
			_ENV = self
			self.msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
			self.subMsg = "further"
			SoraDSendMessage(self)
		elseif v.type == "unlockFurtherEx" then
			self.bUnlockFurtherEx = true
			_ENV = self
			self.msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
			self.subMsg = "furtherEx"
			SoraDSendMessage(self)
		elseif v.type == "updateExp" then
			self.curLevel = v.curLevel
			self.curScore = v.curExp
			_ENV = self
			self.msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
			self.subMsg = "init"
			SoraDSendMessage(self)
		end
	end
end
function starryNightCarnivalCtrl:popRechargeSuccessView(v)
	local rechargePopMsg = function(goods, mid, rid)
		if goods and next(goods) ~= nil then
			_ENV = nil
			;(nil).itemList = goods
			;(nil).mailID = mid
			;(nil).rid = rid
			uiManager:show("gemGoodsBuyGiftSuccess", nil)
		end
	end
	local _rid = v.rid
	local goods = v.reward
	local mailID = v.mailID
	rechargePopMsg(goods, mailID, _rid)
end
function starryNightCarnivalCtrl:initClientData(data)
	dump(data, "starryNightCarnivalCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function starryNightCarnivalCtrl:Logout()
	self:resetData()
	starryNightCarnivalCtrl.super.Logout(self)
end
function starryNightCarnivalCtrl:resetData()
	self.bUnlockFurther = false
	self.bUnlockFurtherEx = false
	self.curLevel = 0
	self.gotGift, _UPVALUE0_, self.gotExtra, _UPVALUE0_, self.curScore = nil, nil, nil, nil, 0
	self.incScore = 0
	self.openCount = 0
	self.rewardLevel = 0
	self.furtherRewardLevel = 0
	self.furtherExRewardLevel = 0
	self.classType = 0
end
function starryNightCarnivalCtrl:setData(data)
	self.bUnlockFurther = data.bUnlockFurther or false
	self.bUnlockFurtherEx = data.bUnlockFurtherEx or false
	self.curLevel = data.curLevel or 0
	self.curScore = data.curExp or 0
	self.rewardLevel = data.rewardLevel or 0
	self.furtherRewardLevel = data.furtherRewardLevel or 0
	self.furtherExRewardLevel = data.furtherExRewardLevel or 0
	self.classType = data.classType or 1
	self.openCount = data.openCount or 0
end
function starryNightCarnivalCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_INIT)
end
function starryNightCarnivalCtrl:sendDonateMsg()
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_DONATE)
end
function starryNightCarnivalCtrl:sendGetRewardByLevelMsg(level)
	serverproxy = nil
	;(nil).level = level
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_CLAIM, nil)
end
function starryNightCarnivalCtrl:sendOpenFutherRewardMsg(giftType)
	serverproxy = nil
	;(nil).giftType = giftType
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_BUY_GIFT, nil)
end
function starryNightCarnivalCtrl:sendGetAllRewardMsg()
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_STARRY_NIGHT_CARNIVAL_CLAIM_ALL)
end
function starryNightCarnivalCtrl:sendReqInfoRsp(content)
	dump(content, "starryNightCarnivalCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function starryNightCarnivalCtrl:sendReqDonateRsp(content)
	dump(content, "==starryNightCarnivalCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.curLevel = data.curLevel
		self.curScore = data.curScore
		self.incScore = data.score
		_ENV = "==starryNightCarnivalCtrl：sendReqDonateRsp=="
		;("==starryNightCarnivalCtrl：sendReqDonateRsp==").msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
		;("==starryNightCarnivalCtrl：sendReqDonateRsp==").subMsg = "donate"
		SoraDSendMessage("==starryNightCarnivalCtrl：sendReqDonateRsp==")
	end
end
function starryNightCarnivalCtrl:sendOpenFutherRsp(content)
	dump(content, "starryNightCarnivalCtrl:sendOpenFutherRsp", 20)
	if content.err == gErrDef.Err_None then
		local rechargeID = starryNightCarnivalltCtrl.getRechargeCfg(content.data.giftType == 2).rechargeID
		local orderID = content.rspdata.orderID
		paymentManager.purchase(rechargeID, orderID)
	end
end
function starryNightCarnivalCtrl:sendReqRewardRsp(content)
	dump(content, "==starryNightCarnivalCtrl:sendReqExtraRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		_ENV = "==starryNightCarnivalCtrl:sendReqExtraRewardRsp=="
		;("==starryNightCarnivalCtrl:sendReqExtraRewardRsp==").msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
		;("==starryNightCarnivalCtrl:sendReqExtraRewardRsp==").subMsg = "reward"
		;("==starryNightCarnivalCtrl:sendReqExtraRewardRsp==").reward = data.reward
		SoraDSendMessage("==starryNightCarnivalCtrl:sendReqExtraRewardRsp==")
	end
	if content.err == gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD then
		_ENV = gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD
		gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD.msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD.subMsg = "noReward"
		SoraDSendMessage(gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD)
	end
end
function starryNightCarnivalCtrl:sendReqAllRewardRsp(content)
	dump(content, "==starryNightCarnivalCtrl:sendReqExtraRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.rewardLevel = data.rewardLevel
		self.furtherRewardLevel = data.furtherRewardLevel
		self.furtherExRewardLevel = data.furtherExRewardLevel
		local _ENV, reward = data.furtherExRewardLevel, data.furtherExRewardLevel
		for i, v in ipairs(data.reward) do
			table.insert(reward, v)
		end
		_ENV = ipairs(data.reward)
		ipairs(data.reward).msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
		ipairs(data.reward).subMsg = "reward"
		ipairs(data.reward).reward = reward
		SoraDSendMessage(ipairs(data.reward))
	end
	if content.err == gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD then
		_ENV = gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD
		gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD.msg = "MESSAGE_STARRY_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD.subMsg = "noReward"
		SoraDSendMessage(gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD)
	end
end
function starryNightCarnivalCtrl:getReceiveStatusAndNum()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamByID(gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL).classtype
	local rewardSize = starryNightCarnivalltCtrl.getRewardDataSize(classType)
	if self.curLevel > self.rewardLevel then
		return true, -1
	end
	if self.bUnlockFurther and self.furtherRewardLevel < self.curLevel then
		return true, -1
	end
	if self.bUnlockFurtherEx and self.furtherExRewardLevel < self.curLevel then
		return true, -1
	end
	if rewardSize < self:getCanGetLevel() and num == 0 then
		return false, -1
	end
	return false
end
function starryNightCarnivalCtrl:getUnlockFurther()
	return self.bUnlockFurther
end
function starryNightCarnivalCtrl:getUnlockFurtherEx()
	return self.bUnlockFurtherEx
end
function starryNightCarnivalCtrl:getCurScore()
	return self.curScore
end
function starryNightCarnivalCtrl:getIncScore()
	return self.incScore
end
function starryNightCarnivalCtrl:getCurLevel()
	return self.curLevel + 1
end
function starryNightCarnivalCtrl:getCanGetLevel()
	return self.curLevel
end
function starryNightCarnivalCtrl:isInGotExtra(index)
	if index <= self.furtherRewardLevel then
		return true
	end
	return false
end
function starryNightCarnivalCtrl:isInGotNormal(index)
	if index <= self.rewardLevel then
		return true
	end
	return false
end
function starryNightCarnivalCtrl:isInGotExtra2(index)
	if index <= self.furtherExRewardLevel then
		return true
	end
	return false
end
function starryNightCarnivalCtrl:getLevelState(level, score)
	if level <= self.curLevel then
		return true
	else
		return false
	end
end
function starryNightCarnivalCtrl:setRewardGetFlag(rewards)
	for i, v in pairs(rewards) do
		if self.gotTreasure[tostring(v.index)] then
			v.getFlag = true
		else
			v.getFlag = false
		end
	end
	return rewards
end
function starryNightCarnivalCtrl:haveRewardNotGot()
	if self.curLevel == 0 then
		return false
	end
	print("self.curLevel < self.rewardLevel", self.curLevel, self.rewardLevel)
	if self.curLevel > self.rewardLevel then
		return true
	end
	if self.bUnlockFurther and self.furtherRewardLevel < self.curLevel then
		return true
	end
	if self.bUnlockFurtherEx and self.furtherExRewardLevel < self.curLevel then
		return true
	end
	return false
end
function starryNightCarnivalCtrl:getAviRewardLevel()
	if self.curLevel == 0 then
		return 0
	end
	if not self:haveRewardNotGot() then
		return self:getCurLevel() - 1
	end
	return self.rewardLevel
end
return starryNightCarnivalCtrl
