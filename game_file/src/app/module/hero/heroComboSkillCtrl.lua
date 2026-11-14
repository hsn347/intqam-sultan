local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local heroComboSkillCtrl = class("heroComboSkillCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
function heroComboSkillCtrl:ctor(properties)
	heroComboSkillCtrl.super.ctor(self, properties)
	self:resetData()
end
function heroComboSkillCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_COMBO_SKILL_MODULE, gCmd.REQ_HERO_COMBO_SKILL_INIT, handler(self, self.reqHeroComboSkillInitRsp))
	msgCtrl.register(gCmd.CMD_HERO_COMBO_SKILL_MODULE, gCmd.REQ_HERO_COMBO_SKILL_USE, handler(self, self.reqHeroComboSkillUseRsp))
	self:registerNotify()
end
function heroComboSkillCtrl:Logout()
	heroComboSkillCtrl.super.Logout(self)
	self:resetData()
end
function heroComboSkillCtrl:resetData()
	self.skillGroupInfo, _UPVALUE0_ = nil, nil
end
function heroComboSkillCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_COMBO_SKILL, handler(self, self.notifyHandler))
end
function heroComboSkillCtrl:notifyHandler(event)
	dump(event.data, "heroComboSkillCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.skillGroupInfo = v.skillData
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_HERO_COMBO_SKILL"
		;(nil).notify = true
		SoraDSendMessage(nil)
	end
end
function heroComboSkillCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HERO_COMBO_SKILL_MODULE, gCmd.REQ_HERO_COMBO_SKILL_INIT, nil)
end
function heroComboSkillCtrl:reqHeroComboSkillUse(skillGroup)
	serverproxy = nil
	;(nil).skillGroup = skillGroup
	serverproxy:Request(gCmd.CMD_HERO_COMBO_SKILL_MODULE, gCmd.REQ_HERO_COMBO_SKILL_USE, nil)
end
function heroComboSkillCtrl:reqHeroComboSkillInitRsp(content)
	dump(content, "heroComboSkillCtrl:reqHeroComboSkillInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.skillGroupInfo = content.rspdata.skillData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HERO_COMBO_SKILL"
		gErrDef.Err_None.notify = true
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function heroComboSkillCtrl:reqHeroComboSkillUseRsp(content)
	dump(content, "heroComboSkillCtrl:reqHeroComboSkillUseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.skillGroupInfo = content.rspdata.skillData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HERO_COMBO_SKILL"
		gErrDef.Err_None.notify = true
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function heroComboSkillCtrl:getSkillInfo(skillID)
	local skillGroup = math.floor(skillID / 100)
	return self.skillGroupInfo[tostring(skillGroup)]
end
function heroComboSkillCtrl:getLeftUseNum(skillID)
	local skillInfo = heroltCtrl:getCombosSkillInfo(skillID)
	local skillGroup = math.floor(skillID / 100)
	local useNum = self.skillGroupInfo[tostring(skillGroup)] and self.skillGroupInfo[tostring(skillGroup)].useNum or 0
	return skillInfo.dailyNum - useNum
end
function heroComboSkillCtrl:isInCD(skillID)
	local curTime = serviceFunctions.systemTime()
	local skillData = self:getSkillInfo(skillID)
	if skillData and curTime < skillData.cd + skillData.beginTime then
		print("isInCD", skillData.beginTime, curTime)
		return true, skillData.cd + skillData.beginTime - curTime
	end
	return false, 0
end
function heroComboSkillCtrl:checkCanUseSkill(skillID, heroID, dressID)
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local cfg = heroltCtrl:getDressSerSkilCfg(skillID)
	if not heroCtrl:getHeroInfoByID(cfg.heroID) or cfg.lieutenant == 0 or not heroCtrl:getHeroInfoByID(cfg.lieutenant) then
		_ENV = nil
		;(nil).name1 = i18n(heroltCtrl.getHeroName(cfg.heroID))
		;(nil).name2 = i18n(heroltCtrl.getHeroName(cfg.lieutenant))
		SoraDShowMsgTip(i18n("lieutenant_text_25", nil))
		return false
	end
	local leftNum = self:getLeftUseNum(skillID)
	if leftNum <= 0 then
		SoraDShowMsgTip(i18n("lieutenant_text_20"))
		return false
	end
	if not SoraDGetCtrl("kingdomMapCtrl"):getMyMassQueueMap() then
		local _ENV, allMyMassQueue = SoraDGetCtrl("kingdomMapCtrl"):getMyMassQueueMap(), SoraDGetCtrl("kingdomMapCtrl"):getMyMassQueueMap()
	end
	if not next(allMyMassQueue) then
		SoraDShowMsgTip(i18n("lieutenant_text_22"))
		return false
	end
	local isInHeroList = false
	for _, queue in pairs(allMyMassQueue) do
		local heroList = queue:getFromHero()
		for _, heroInfo in pairs(heroList) do
			if heroInfo.slaveInfo then
				local lieutenantID = heroltCtrl:getDressLieutenant(dressID)
				if 0 < lieutenantID and heroltCtrl.getHeroType(heroInfo.slaveInfo.heroID) == heroltCtrl.getHeroType(lieutenantID) and heroltCtrl.getHeroType(heroInfo.heroID) == heroltCtrl.getHeroType(heroID) then
					isInHeroList = true
					break
				end
			end
		end
	end
	if not isInHeroList then
		SoraDShowMsgTip(i18n("lieutenant_text_13"))
		return false
	end
	if self:isInCD(skillID) then
		SoraDShowMsgTip(i18n("lieutenant_text_14"))
		return false
	end
	return true
end
function heroComboSkillCtrl:getSkillRemainTime(skillID)
	local skillGroup = math.floor(skillID / 100)
	if self.skillGroupInfo[tostring(skillGroup)] then
		local endTime = self.skillGroupInfo[tostring(skillGroup)].endTime or 0
		return endTime - serviceFunctions.systemTime()
	else
		return 0
	end
end
return heroComboSkillCtrl
