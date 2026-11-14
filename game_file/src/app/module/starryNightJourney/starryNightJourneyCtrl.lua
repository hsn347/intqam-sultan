local ramadanAccuRechargeltCtrl = include("ramadanAccuRechargeltCtrl")
local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local starryNightJourneyCtrl = class("starryNightJourneyCtrl", GameModule)
function starryNightJourneyCtrl:ctor(properties)
	starryNightJourneyCtrl.super.ctor(self, properties)
end
function starryNightJourneyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_JOURNEY_MODULE, gCmd.REQ_STARRY_NIGHT_JOURNEY_INIT, handler(self, self.sendReqDataRsp))
	msgCtrl.register(gCmd.CMD_STARRY_NIGHT_JOURNEY_MODULE, gCmd.REQ_STARRY_NIGHT_JOURNEY_CLAIM, handler(self, self.sendReqRewardRsp))
	self:resetData()
	self:registerNotify()
end
function starryNightJourneyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.STARRY_NIGHT_JOURNEY, handler(self, self.notifyHandler))
end
function starryNightJourneyCtrl:notifyHandler(event)
	dump(event.data, "starryNightJourneyCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "updateData" then
			self.curScore = v.curScore or self.curScore
			self.nextRefreshTime = v.nextRefreshTime or self.nextRefreshTime
			self.gotGift = v.gotGift or self.gotGift
			_ENV = nil
			;(nil).msg = "MESSAGE_STARRY_NIGHT_JOURNEY"
			;(nil).subMsg = "init"
			SoraDSendMessage(nil)
		end
	end
end
function starryNightJourneyCtrl:initClientData(data)
	dump(data, "starryNightJourneyCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function starryNightJourneyCtrl:Logout()
	self:resetData()
	starryNightJourneyCtrl.super.Logout(self)
end
function starryNightJourneyCtrl:resetData()
	self.classType = 1
	self.curScore = 0
	self.gotGift, _UPVALUE0_, self.nextRefreshTime = nil, nil, 0
end
function starryNightJourneyCtrl:setData(data)
	self.classType = data.classType
	self.curScore = data.curScore
	self.nextRefreshTime = data.nextRefreshTime
	if data.gotGift then
		for i, v in pairs(data.gotGift) do
			self.gotGift[tonumber(i)] = v
		end
	end
end
function starryNightJourneyCtrl:sendReqInitDataMsg()
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_JOURNEY_MODULE, gCmd.REQ_STARRY_NIGHT_JOURNEY_INIT)
end
function starryNightJourneyCtrl:sendRewardMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_STARRY_NIGHT_JOURNEY_MODULE, gCmd.REQ_STARRY_NIGHT_JOURNEY_CLAIM, nil)
end
function starryNightJourneyCtrl:sendReqDataRsp(content)
	dump(content, "starryNightJourneyCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_STARRY_NIGHT_JOURNEY"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function starryNightJourneyCtrl:sendReqRewardRsp(content)
	dump(content, "==starryNightJourneyCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		for i, v in pairs(data.gotGift) do
			self.gotGift[tonumber(i)] = v
		end
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_STARRY_NIGHT_JOURNEY"
		content.rspdata.reward.subMsg = "reward"
		content.rspdata.reward.reward = content.rspdata.reward
		SoraDSendMessage(content.rspdata.reward)
	end
end
function starryNightJourneyCtrl:getReceiveStatusAndNum()
	if not self.curScore then
		print("starryNightJourneyCtrl:getReceiveStatusAndNum curScore为Nil")
		return false
	end
	if self.curScore == 0 then
		return false
	end
	if not self.configs then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local classType = activityShowCtrl:getParamByID(gActivityTimeActivityID.STARRY_NIGHT_JOURNEY).classtype
		self.configs = ramadanAccuRechargeltCtrl.getStarryNightJourneyReward(classType)
	end
	local num = 0
	for i, v in ipairs(self.configs) do
		if self.curScore >= v.score and not self.gotGift[i] then
			num = num + 1
		end
	end
	if num and 0 < num then
		return true, -1
	end
	return false
end
function starryNightJourneyCtrl:getClassType()
	return self.classType
end
function starryNightJourneyCtrl:getCurScore()
	return self.curScore
end
function starryNightJourneyCtrl:getgotGift()
	return self.gotGift
end
function starryNightJourneyCtrl:hadgotGift(index)
	if self.gotGift[index] and self.gotGift[index] > 0 then
		return true
	end
	return false
end
return starryNightJourneyCtrl
