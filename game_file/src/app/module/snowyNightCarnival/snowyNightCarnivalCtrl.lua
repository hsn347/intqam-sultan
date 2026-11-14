local constantRead = include("constantRead")
local snowyNightCarnivalltCtrl = include("snowyNightCarnivalltCtrl")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local snowyNightCarnivalCtrl = class("snowNightCarnivalCtrl", GameModule)
function snowyNightCarnivalCtrl:ctor(properties)
	snowyNightCarnivalCtrl.super.ctor(self, properties)
end
function snowyNightCarnivalCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_DONATE, handler(self, self.sendReqDonateRsp))
	msgCtrl.register(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_CLAIM, handler(self, self.sendReqRewardRsp))
	msgCtrl.register(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_FUTHER, handler(self, self.sendOpenFutherRsp))
	msgCtrl.register(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_CLAIMEX, handler(self, self.sendReqRewardRsp))
	self:resetData()
end
function snowyNightCarnivalCtrl:initClientData(data)
	dump(data, "snowyNightCarnivalCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function snowyNightCarnivalCtrl:Logout()
	self:resetData()
	snowyNightCarnivalCtrl.super.Logout(self)
end
function snowyNightCarnivalCtrl:resetData()
	self.bUnlockFurther = false
	self.curLevel = 0
	self.gotGift, _UPVALUE0_, self.gotExtra, _UPVALUE0_, self.curScore = nil, nil, nil, nil, 0
	self.incScore = 0
	self.openCount = 0
end
function snowyNightCarnivalCtrl:setData(data)
	self.bUnlockFurther = data.bUnlockFurther or false
	self.curLevel = data.curLevel or 0
	self.curScore = data.curScore or 0
	if not data.gotExtra then
		_UPVALUE0_ = data.gotExtra
	end
	self.gotExtra = data.gotExtra
	if not data.gotGift then
		_UPVALUE0_ = data.gotGift
	end
	self.gotGift = data.gotGift
	self.openCount = data.openCount or 0
end
function snowyNightCarnivalCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_INIT)
end
function snowyNightCarnivalCtrl:sendDonateMsg()
	serverproxy:Request(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_DONATE)
end
function snowyNightCarnivalCtrl:sendGetRewardAllMsg()
	serverproxy:Request(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_CLAIM)
end
function snowyNightCarnivalCtrl:sendOpenFutherRewardMsg()
	serverproxy:Request(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_FUTHER)
end
function snowyNightCarnivalCtrl:sendGetRewardByLevelMsg(level)
	serverproxy = nil
	;(nil).level = level
	serverproxy:Request(gCmd.CMD_SNOWY_NIGHT_CARNIVAL_MODULE, gCmd.REQ_SNOWY_NIGHT_CARNIVAL_CLAIMEX, nil)
end
function snowyNightCarnivalCtrl:sendReqInfoRsp(content)
	dump(content, "snowNightCarnivalCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
	end
end
function snowyNightCarnivalCtrl:sendReqDonateRsp(content)
	dump(content, "==snowNightCarnivalCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.curLevel = data.curLevel
		self.curScore = data.curScore
		self.incScore = data.score
		_ENV = "==snowNightCarnivalCtrl：sendReqDonateRsp=="
		;("==snowNightCarnivalCtrl：sendReqDonateRsp==").msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		;("==snowNightCarnivalCtrl：sendReqDonateRsp==").subMsg = "donate"
		SoraDSendMessage("==snowNightCarnivalCtrl：sendReqDonateRsp==")
	end
	if content.err == gErrDef.Err_ACTIVITY_NOT_START then
		_ENV = gErrDef.Err_ACTIVITY_NOT_START
		gErrDef.Err_ACTIVITY_NOT_START.msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_ACTIVITY_NOT_START.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_ACTIVITY_NOT_START)
	end
end
function snowyNightCarnivalCtrl:sendOpenFutherRsp(content)
	dump(content, "snowyNightCarnivalCtrl:sendOpenFutherRsp", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.bUnlockFurther = data.bUnlockFurther
		_ENV = "snowyNightCarnivalCtrl:sendOpenFutherRsp"
		;("snowyNightCarnivalCtrl:sendOpenFutherRsp").msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		;("snowyNightCarnivalCtrl:sendOpenFutherRsp").subMsg = "further"
		SoraDSendMessage("snowyNightCarnivalCtrl:sendOpenFutherRsp")
	end
	if content.err == gErrDef.Err_ACTIVITY_NOT_START then
		_ENV = gErrDef.Err_ACTIVITY_NOT_START
		gErrDef.Err_ACTIVITY_NOT_START.msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_ACTIVITY_NOT_START.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_ACTIVITY_NOT_START)
	end
	if content.err == gErrDef.Err_SNOWY_NIGHT_CARNIVAL_UNLOCKED then
		_ENV = gErrDef.Err_SNOWY_NIGHT_CARNIVAL_UNLOCKED
		gErrDef.Err_SNOWY_NIGHT_CARNIVAL_UNLOCKED.msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_SNOWY_NIGHT_CARNIVAL_UNLOCKED.subMsg = "alreadyFurther"
		SoraDSendMessage(gErrDef.Err_SNOWY_NIGHT_CARNIVAL_UNLOCKED)
	end
	if content.err == gErrDef.Err_GOLD_NOT_REACH then
		_ENV = gErrDef.Err_GOLD_NOT_REACH
		gErrDef.Err_GOLD_NOT_REACH.msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_GOLD_NOT_REACH.subMsg = "notEnoughGold"
		SoraDSendMessage(gErrDef.Err_GOLD_NOT_REACH)
	end
end
function snowyNightCarnivalCtrl:sendReqRewardRsp(content)
	dump(content, "==snowNightCarnivalCtrl:sendReqExtraRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gotExtra) do
			self.gotExtra[i] = v
		end
		for i, v in pairs(data.gotGift) do
			self.gotGift[i] = v
		end
		_ENV = pairs(data.gotGift)
		pairs(data.gotGift).msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		pairs(data.gotGift).subMsg = "reward"
		pairs(data.gotGift).reward = data.reward
		SoraDSendMessage(pairs(data.gotGift))
	end
	if content.err == gErrDef.Err_ACTIVITY_NOT_START then
		_ENV = gErrDef.Err_ACTIVITY_NOT_START
		gErrDef.Err_ACTIVITY_NOT_START.msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		gErrDef.Err_ACTIVITY_NOT_START.subMsg = "notOpen"
		SoraDSendMessage(gErrDef.Err_ACTIVITY_NOT_START)
	end
	if content.err == gErrDef.Err_SNOWY_NIGHT_CARNIVAL_NO_REWARD then
		print("fjkdsfjkdfjkdf")
		_ENV = "fjkdsfjkdfjkdf"
		;("fjkdsfjkdfjkdf").msg = "MESSAGE_SNOW_NIGHT_CARNIVAL_REFRESH"
		;("fjkdsfjkdfjkdf").subMsg = "noReward"
		SoraDSendMessage("fjkdsfjkdfjkdf")
	end
end
function snowyNightCarnivalCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemID = constantRead.getConstValue("SNOWY_NIGHT_REQ_ITEM", 1001)
	local count = backpackCtrl:getItemCount(itemID)
	local levelSize = self.bUnlockFurther and snowyNightCarnivalltCtrl.getLevelRewardSize() or snowyNightCarnivalltCtrl.getNormalRewardSize()
	local count2 = self:getCanGetLevel() * levelSize - table.nums(self.gotGift) * snowyNightCarnivalltCtrl.getNormalRewardSize() - table.nums(self.gotExtra) * snowyNightCarnivalltCtrl.getExtraRewardSize()
	if 0 < count + count2 then
		return true, count + count2
	end
	return false
end
function snowyNightCarnivalCtrl:getUnlockFurther()
	return self.bUnlockFurther
end
function snowyNightCarnivalCtrl:getCurScore()
	return self.curScore
end
function snowyNightCarnivalCtrl:getIncScore()
	return self.incScore
end
function snowyNightCarnivalCtrl:getCurLevel()
	if self.curLevel == snowyNightCarnivalltCtrl.getLastLevel() then
		return self.curLevel
	end
	return self.curLevel + 1
end
function snowyNightCarnivalCtrl:getCanGetLevel()
	return self.curLevel
end
function snowyNightCarnivalCtrl:isInGotExtra(index)
	if self.gotExtra and self.gotExtra[tostring(index)] then
		return true
	end
	return false
end
function snowyNightCarnivalCtrl:isInGotNormal(index)
	dump(self.gotGift, "fjskdfjksdfjdk")
	if self.gotGift and self.gotGift[tostring(index)] then
		return true
	end
	return false
end
function snowyNightCarnivalCtrl:getLevelState(level, score)
	if level <= self.curLevel then
		return true
	else
		return false
	end
end
function snowyNightCarnivalCtrl:setRewardGetFlag(rewards)
	for i, v in pairs(rewards) do
		if self.gotTreasure[tostring(v.index)] then
			v.getFlag = true
		else
			v.getFlag = false
		end
	end
	return rewards
end
return snowyNightCarnivalCtrl
