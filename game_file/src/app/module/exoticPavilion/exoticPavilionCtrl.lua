local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local exoticPavilionCtrl = class("exoticPavilionCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
local constantRead = include("constantRead")
function exoticPavilionCtrl:ctor(properties)
	exoticPavilionCtrl.super.ctor(self, properties)
	self.chatPointCount = constantRead.getConstValue("EXOTIC_PAVILION_TALK_COUNT") or 10
	self.gameCount = constantRead.getConstValue("EXOTIC_PAVILION_GAME_COUNT") or 5
	self:resetData()
end
function exoticPavilionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_DATA, handler(self, self.reqEPDataRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_FINISH_STEP, handler(self, self.reqEPFinshStepRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_PLAY_GAME_TO_INCR_INTIMACY, handler(self, self.reqEPPlayGameToIncrIntimacyRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_CHAT_TO_INCR_INTIMACY, handler(self, self.reqEPCatIncrIntimacyRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_SEND_GIFT_TO_INCR_INTIMACY, handler(self, self.reqEpSendGiftToIncrIntimacyRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_UPGRADE_INTIMACY_LV, handler(self, self.reqEPUpgradeIntimacyLvRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_CHANGE_DRESS, handler(self, self.reqEPChangeDressRsp))
	msgCtrl.register(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_GET_DAILY_REWARD, handler(self, self.reqGetDaliyRewardRsp))
end
function exoticPavilionCtrl:getReceiveStatusAndNum()
	return false, 0
end
function exoticPavilionCtrl:initClientData(data)
	if not data then
		return
	end
	if self.data then
		self.oldDressLv = self.data.dressLv
	else
		self.oldDressLv = data.dressLv
	end
	self.data = data
	if self.data.stage == 2 and self.data.state == gActivityState.OPEN then
		self.buffList = foreignPavilionRead:getAllBuff(self.data.intimacyLv)
	end
end
function exoticPavilionCtrl:Logout()
	exoticPavilionCtrl.super.Logout(self)
	self:resetData()
end
function exoticPavilionCtrl:resetData()
	self.chatNoPointCount = 0
	self.data = nil
	self.buffList = nil
end
function exoticPavilionCtrl:registerNotify()
end
function exoticPavilionCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content)
		end
	end
end
function exoticPavilionCtrl:reqEPData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_DATA, nil)
end
function exoticPavilionCtrl:reqEPFinshStep()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_FINISH_STEP, nil)
end
function exoticPavilionCtrl:reqEPPlayGameToIncrIntimacy(gameType, isWin)
	serverproxy = nil
	;(nil).gameType = gameType
	;(nil).isWin = isWin
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_PLAY_GAME_TO_INCR_INTIMACY, nil)
end
function exoticPavilionCtrl:reqEPCatIncrIntimacy()
	if not self:getIsChatCanAdd() then
		return
	end
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_CHAT_TO_INCR_INTIMACY, nil)
end
function exoticPavilionCtrl:reqEpSendGiftToIncrIntimacy(giftId, giftIdx, giftCount)
	self.lastGiftIdx = giftIdx
	serverproxy = nil
	;(nil).giftId = giftId
	;(nil).giftIdx = giftIdx
	;(nil).giftCount = giftCount
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_SEND_GIFT_TO_INCR_INTIMACY, nil)
end
function exoticPavilionCtrl:reqEPUpgradeIntimacyLv()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_UPGRADE_INTIMACY_LV, nil)
end
function exoticPavilionCtrl:reqEPChangeDress(dressLv)
	serverproxy = nil
	;(nil).dressLv = dressLv
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_CHANGE_DRESS, nil)
end
function exoticPavilionCtrl:reqGetDaliyReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EXOTIC_PAVILION_MODULE, gCmd.REQ_EXOTIC_PAVILION_GET_DAILY_REWARD, nil)
end
function exoticPavilionCtrl:reqEPDataRsp(content)
	dump(content, "exoticPavilionCtrl:reqEPDataRsp")
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_DATA"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqEPFinshStepRsp(content)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_FINISH_STEP"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqEPPlayGameToIncrIntimacyRsp(content)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_PLAY_GAME_TO_INCR_INTIMACY"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqEPCatIncrIntimacyRsp(content)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_CHAT_TO_INCR_INTIMACY"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqEpSendGiftToIncrIntimacyRsp(content)
	dump(content, "exoticPavilionCtrl:reqEpSendGiftToIncrIntimacyRsp")
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_SEND_GIFT_TO_INCR_INTIMACY"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqEPUpgradeIntimacyLvRsp(content)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_UPGRADE_INTIMACY_LV"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqEPChangeDressRsp(content)
	dump(content, "exoticPavilionCtrl:reqEPChangeDressRsp")
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_CHANGE_DRESS"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:reqGetDaliyRewardRsp(content)
	dump(content, "exoticPavilionCtrl:reqGetDaliyRewardRsp")
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_EXOTIC_PAVILION_GET_DAILY_REWARD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_PAVILION_UPDATE_TIP"
		SoraDSendMessage(self)
	end
end
function exoticPavilionCtrl:getOpenCount()
	return self.data and self.data.opencount
end
function exoticPavilionCtrl:getCurStage()
	return self.data and self.data.stage
end
function exoticPavilionCtrl:getCurStep()
	return self.data and self.data.step
end
function exoticPavilionCtrl:getCurIntimacyLv()
	return self.data and self.data.intimacyLv
end
function exoticPavilionCtrl:getCurIntimacyValue()
	return self.data and self.data.intimacy
end
function exoticPavilionCtrl:getIsGetDailyReward()
	return self.data and serviceFunctions.isSameDay(self.data.getDailyRewardTime)
end
function exoticPavilionCtrl:getIsGetChatPoint()
	local intimacyValue = foreignPavilionRead:getIntimacyValue(3, self.data.intimacyLv)
	if math.random(1000) < intimacyValue.probability then
		self:resetGetChatPointCount()
		return true
	end
	if self.chatNoPointCount >= 4 then
		self:resetGetChatPointCount()
		return true
	else
		self.chatNoPointCount = self.chatNoPointCount + 1
	end
	return false
end
function exoticPavilionCtrl:getIsChatCanAdd()
	if self.data and self.data.chatIntimacyCount >= self.chatPointCount and serviceFunctions.isSameDay(self.data.chatIntimacyTime) then
		return false
	end
	return true
end
function exoticPavilionCtrl:resetGetChatPointCount()
	self.chatNoPointCount = 0
end
function exoticPavilionCtrl:getLastGameCount()
	if not self.data then
		return 0
	end
	local playedCount = serviceFunctions.isSameDay(self.data.playGameTime) and self.data.playGameCount or 0
	return self.gameCount - playedCount
end
function exoticPavilionCtrl:getGiftNum(giftID)
	if not self.data then
		return 0
	end
	if giftID == nil then
		local num = 0
		for key, value in pairs(self.data.giftBag) do
			num = num + value
		end
		return num
	end
	local num = self.data.giftBag[tostring(giftID)]
	if num then
		return num
	else
		return 0
	end
end
function exoticPavilionCtrl:getCurDressLv()
	return self.data and self.data.dressLv or 0
end
function exoticPavilionCtrl:getOldDressLv()
	return self.oldDressLv
end
function exoticPavilionCtrl:getBuffByType(type)
	if not self.buffList or not self.buffList[type] then
		return 0
	end
	return self.buffList[type]
end
function exoticPavilionCtrl:getLastGiftIdx()
	return self.lastGiftIdx
end
return exoticPavilionCtrl
