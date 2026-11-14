local gameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local lordSkillModule = include("lordSkillModule")
local gametop = gModuleMgr.getObject("gametop")
local lordSkillCtrl = class("lordSkillCtrl", gameModule)
local _ENV, REQ = "lordSkillCtrl", "lordSkillCtrl"
local _ENV, RSP = gameModule, gameModule
function lordSkillCtrl:initClientData(data)
	lordSkillModule:initialize(data)
end
function lordSkillCtrl:upgradeSkill(setID, skillID, upgradeLevel)
	print("lordSkillCtrl:upgradeSkill", setID, skillID, upgradeLevel)
	REQ.reqUpgradeSkill(setID, skillID, upgradeLevel)
end
function lordSkillCtrl:resetSkillSet(setID)
	print("lordSkillCtrl:resetSkillSet", setID)
	REQ.reqResetSkillSet(setID)
end
function lordSkillCtrl:switchSkillSet(setID)
	print("lordSkillCtrl:switchSkillSet", setID)
	REQ.reqSwitchSkillSet(setID)
end
function lordSkillCtrl:setSkillSetTitle(setID, title)
	print("lordSkillCtrl:setSkillSetTitle", setID, title)
	REQ.reqSetSkillSetTitle(setID, title)
end
function lordSkillCtrl:useSkill(skillID)
	REQ.reqUseSkill(skillID)
end
function lordSkillCtrl:getSkillSetTitle(setID)
	return lordSkillModule:getSkillSetTitle(setID)
end
function lordSkillCtrl:getActiveSetID()
	return lordSkillModule:getActiveSetID()
end
function lordSkillCtrl:getSkillSetData(setID)
	return lordSkillModule:getSkillSetData(setID)
end
function lordSkillCtrl:isSkillSetUnlock(setID)
	return lordSkillModule:isSkillSetUnlock(setID)
end
function lordSkillCtrl:queryBuff(buffType)
	return lordSkillModule:queryBuff(buffType)
end
function lordSkillCtrl:getSkillDetail(setID, skillID)
	return lordSkillModule:getSkillDetail(setID, skillID)
end
function lordSkillCtrl:getSkillCDData(skillID)
	return lordSkillModule:getSkillCDData(skillID)
end
function lordSkillCtrl:skillInCD(skillID)
	return lordSkillModule:skillInCD(skillID)
end
function lordSkillCtrl:getSkillCDRemainTime(skillID)
	return lordSkillModule:getSkillCDRemainTime(skillID)
end
function lordSkillCtrl:getRemainPoint(setID)
	return lordSkillModule:getRemainPoint(setID)
end
function REQ.reqUpgradeSkill(setID, skillID, upgradeLevel)
	serverproxy = nil
	;(nil).setID = setID
	;(nil).skillID = skillID
	local (nil).upgradeLevel, data = upgradeLevel, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_UPGRADE, data)
end
function REQ.reqResetSkillSet(setID)
	serverproxy = nil
	local (nil).setID, data = setID, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_RESET, data)
end
function REQ.reqSwitchSkillSet(setID)
	serverproxy = nil
	local (nil).setID, data = setID, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_SWITCH, data)
end
function REQ.reqSetSkillSetTitle(setID, title)
	serverproxy = nil
	;(nil).setID = setID
	local (nil).title, data = title, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_SET_TITLE, data)
end
function REQ.reqUseSkill(skillID)
	serverproxy = nil
	local (nil).skillID, data = skillID, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_USE, data)
end
function RSP:upgradeSkillRsp(content)
	dump(content, "lordSkillCtrl.upgradeSkillRsp", 5)
	local rspData = content.data
	if content.err == gErrDef.Err_None then
		local setID = rspData.setID
		local skillID = rspData.skillID
		local upgradeLevel = rspData.upgradeLevel
		lordSkillModule:upgradeSkill(setID, skillID, upgradeLevel)
		_ENV = setID
		setID.name = gEventName.event_skill_update
		self:dispatchEvent(setID)
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_UPDATE_SKILL"
		self.setID = setID
		self.err = gErrDef.Err_None
		self.skillID = skillID
		SoraDSendMessage(self)
	else
		SoraDShowMsgTip(i18n("notice_0026"))
		_ENV = i18n("notice_0026")
		i18n("notice_0026").msg = "MESSAGE_LORDINFO_UPDATE_SKILL"
		i18n("notice_0026").setID = rspData.setID
		i18n("notice_0026").err = gErrDef.Err_None
		i18n("notice_0026").skillID = rspData.skillID
		SoraDSendMessage(i18n("notice_0026"))
	end
end
function RSP:resetSkillSetRsp(content)
	if content.err == gErrDef.Err_None then
		local setID = content.data.setID
		lordSkillModule:resetSkillSet(setID)
		_ENV = setID
		setID.name = gEventName.event_skill_update
		self:dispatchEvent(setID)
		local pointTotal = lordSkillModule:getSkillPointTotal()
		_ENV = setID
		setID.msg = "MESSAGE_LORDINFO_RESET_SKILL"
		setID.setID = setID
		setID.err = gErrDef.Err_None
		setID.point = pointTotal
		SoraDSendMessage(setID)
	end
end
function RSP:useSkillRsp(content)
	dump(content, "lordSkillCtrl.useSkillRsp", 5)
	local rspData = content.data
	if content.err == gErrDef.Err_None then
		local skillID = rspData.skillID
		local beginTime = rspData.beginTime
		local CD = rspData.CD
		lordSkillModule:useSkill(skillID, beginTime, CD)
		_ENV = skillID
		skillID.name = gEventName.event_skill_update
		self:dispatchEvent(skillID)
		if rspData.opType ~= 1 then
			local lordSkillDesRead = include("lordSkillDesRead")
			_ENV = CD
			CD.skill = lordSkillDesRead.getName(skillID)
			SoraDShowMsgTip(i18n("common_text_4051", CD))
		end
		if skillID == lordSkillIDDefine.fullHP then
			_ENV = SoraDShowMsgTip
			SoraDShowMsgTip.msg = "MESSAGE_LORDINFO_HP"
			SoraDShowMsgTip.style = 2
			SoraDSendMessage(SoraDShowMsgTip)
		end
	end
	local extraData = rspData.extraData
	_ENV = rspData.CD
	rspData.CD.msg = "MESSAGE_TRIGGER_SKILLS"
	rspData.CD.skillID = rspData.skillID
	rspData.CD.extraData = extraData
	rspData.CD.err = content.err
	SoraDSendMessage(rspData.CD)
end
function RSP:switchSkillSetRsp(content)
	if content.err == gErrDef.Err_None then
		local setID = content.data.setID
		lordSkillModule:switchSkillSet(setID)
		_ENV = setID
		setID.name = gEventName.event_skill_update
		self:dispatchEvent(setID)
		_ENV = self
		self.msg = "MESSAGE_SERVER_SKILL_SET_ACTIVE_BACK"
		self.setID = setID
		SoraDSendMessage(self)
	end
end
function RSP:setSkillSetTitleRsp(content)
	if content.err == gErrDef.Err_None then
		local setID = content.data.setID
		local title = content.data.title
		lordSkillModule:setSkillSetTitle(setID, title)
		_ENV = lordSkillModule
		lordSkillModule.msg = "MESSAGE_SERVER_SKILL_SET_RENAME_BACK"
		lordSkillModule.err = content.err
		lordSkillModule.setID = setID
		SoraDSendMessage(lordSkillModule)
	end
end
function lordSkillCtrl:ctor(properties)
	lordSkillCtrl.super.ctor(self, properties)
end
function lordSkillCtrl:EnterGame()
	lordSkillCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_UPGRADE, handler(self, RSP.upgradeSkillRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_RESET, handler(self, RSP.resetSkillSetRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_USE, handler(self, RSP.useSkillRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_SWITCH, handler(self, RSP.switchSkillSetRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_SKILL_SET_TITLE, handler(self, RSP.setSkillSetTitleRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.DUEL_IN_COOL_DOWN, handler(self, self.onNotifySyncSkillData))
end
function lordSkillCtrl:onNotifySyncSkillData(event)
	local data = event.data
	if data then
		for _, msg in pairs(data) do
			_ENV = nil
			;(nil).data = msg
			;(nil).err = gErrDef.Err_None
			RSP.useSkillRsp(self, nil)
		end
	end
end
function lordSkillCtrl:Logout()
	lordSkillCtrl.super.Logout(self)
end
return lordSkillCtrl
