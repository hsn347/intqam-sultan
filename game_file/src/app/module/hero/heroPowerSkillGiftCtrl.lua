local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local heroPowerSkillGiftCtrl = class("heroPowerSkillGiftCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function heroPowerSkillGiftCtrl:ctor(properties)
	heroPowerSkillGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function heroPowerSkillGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_POWER_SKILL_GIFT_MODULE, gCmd.REQ_HERO_POWER_SKILL_GIFT_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_HERO_POWER_SKILL_GIFT_MODULE, gCmd.REQ_HERO_POWER_SKILL_GIFT_CLIAM, handler(self, self.reqCliamGiftRsp))
	self:registerNotify()
end
function heroPowerSkillGiftCtrl:initClientData()
end
function heroPowerSkillGiftCtrl:Logout()
	heroPowerSkillGiftCtrl.super.Logout(self)
	self:resetData()
end
function heroPowerSkillGiftCtrl:resetData()
	self.powerSkillGift, _UPVALUE0_, self.powerSkillStage, _UPVALUE0_ = nil, nil, nil, nil
end
function heroPowerSkillGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_POWER_SKILL_GIFT, handler(self, self.notifyHandler))
end
function heroPowerSkillGiftCtrl:notifyHandler(event)
	dump(event.data, "heroPowerSkillGiftCtrl:notifyHandler", 10)
	for _, v in pairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "buyGift" then
			local commonBuyGiftCtrl = SoraDGetCtrl("commonBuyGiftCtrl")
			commonBuyGiftCtrl:notifyBuyGift(notifyData.rechargeInfo)
			self.powerSkillStage = notifyData.initData.powerSkillStage
			self.powerSkillGift = notifyData.initData.powerSkillGift
		end
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_SERVER_HERO_STAGE_GIFT"
	SoraDSendMessage(pairs(event.data))
end
function heroPowerSkillGiftCtrl:initClientData()
end
function heroPowerSkillGiftCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HERO_POWER_SKILL_GIFT_MODULE, gCmd.REQ_HERO_POWER_SKILL_GIFT_INIT, nil)
end
function heroPowerSkillGiftCtrl:reqCliamGift(heroID, stageID)
	serverproxy = nil
	;(nil).heroID = heroID
	;(nil).stageID = stageID
	serverproxy:Request(gCmd.CMD_HERO_POWER_SKILL_GIFT_MODULE, gCmd.REQ_HERO_POWER_SKILL_GIFT_CLIAM, nil)
end
function heroPowerSkillGiftCtrl:reqInitDataRsp(content)
	dump(content, "heroPowerSkillGiftCtrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.powerSkillStage = content.rspdata.powerSkillStage
		self.powerSkillGift = content.rspdata.powerSkillGift
	end
end
function heroPowerSkillGiftCtrl:reqCliamGiftRsp(content)
	dump(content, "heroPowerSkillGiftCtrl:reqCliamGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.powerSkillStage = content.rspdata.powerSkillStage
		self.powerSkillGift = content.rspdata.powerSkillGift
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_SERVER_HERO_STAGE_GIFT"
		SoraDSendMessage(rewards)
	end
end
function heroPowerSkillGiftCtrl:isCliamReward(heroID, stageID)
	return self.powerSkillStage[tostring(heroID)] and self.powerSkillStage[tostring(heroID)][tostring(stageID)] and true or false
end
function heroPowerSkillGiftCtrl:getGiftBuyTimes(rid)
	local ret = false
	local count = 0
	local leftTime = 0
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local giftCfg = heroltCtrl:getHeroStageGiftCfg(rid)
	if self.powerSkillGift[tostring(rid)] then
		leftTime = self.powerSkillGift[tostring(rid)].endTime - serviceFunctions.systemTime()
		if 0 < leftTime then
			count = giftCfg.limitTime - self.powerSkillGift[tostring(rid)].count
			ret = 0 < count
		end
	end
	return ret, count, leftTime
end
function heroPowerSkillGiftCtrl:getCliamRewardNum(heroID)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	if not heroltCtrl:getHeroAwakeStage(heroID) then
		local _ENV, cfg = heroltCtrl:getHeroAwakeStage(heroID), heroltCtrl:getHeroAwakeStage(heroID)
	end
	local value = heroCtrl:getHeroPowerSkillPercent(heroID)
	local num = 0
	for k, v in ipairs(cfg) do
		if value >= v.awakeStage and not self:isCliamReward(heroID, v.stageID) then
			num = num + 1
		end
	end
	return num
end
return heroPowerSkillGiftCtrl
