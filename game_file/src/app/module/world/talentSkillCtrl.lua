local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local talentSkillCtrl = class("talentSkillCtrl", GameModule)
local attributeSystem = include("attributeSystem")
function talentSkillCtrl:ctor(properties)
	talentSkillCtrl.super.ctor(self, properties)
end
function talentSkillCtrl:EnterGame()
	talentSkillCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALENT_SKILL_MODULE, gCmd.REQ_TALENT_SKILL_INIT, handler(self, self.initSkillRsp))
	msgCtrl.register(gCmd.CMD_ALENT_SKILL_MODULE, gCmd.REQ_TALENT_SKILL_SELECT, handler(self, self.selectSkillRsp))
	self:resetData()
	self.talent_skill_config = require_data("talent_skill_config", true).data
	self.talent_skill_des = require_data("talent_skill_des").data
end
function talentSkillCtrl:resetData()
	self.skillData, _UPVALUE0_ = nil, nil
end
function talentSkillCtrl:Logout()
	self:resetData()
	talentSkillCtrl.super.Logout(self)
end
function talentSkillCtrl:initAttrData()
	for _, talentSkillId in ipairs(self:getSkillData()) do
		local talentSkillConfig = self:getSkillConfig(talentSkillId)
		if talentSkillConfig then
			local buffList = self:getBuffList(talentSkillId)
			for _, attrInfo in ipairs(buffList) do
				attributeSystem.initAttr(attrInfo.attrId, talentSkillConfig.id, attrInfo.attrValue, gAttributeSourceEnum.TALENT_SKILL)
			end
		end
	end
end
function talentSkillCtrl:reqInitSkill()
	serverproxy:Request(gCmd.CMD_ALENT_SKILL_MODULE, gCmd.REQ_TALENT_SKILL_INIT)
end
function talentSkillCtrl:reqSelectSkill(talentSkillId)
	serverproxy = nil
	local (nil).talentSkillId, data = talentSkillId, nil
	serverproxy:Request(gCmd.CMD_ALENT_SKILL_MODULE, gCmd.REQ_TALENT_SKILL_SELECT, data)
end
function talentSkillCtrl:initSkillRsp(content)
	dump(content, "talentSkillCtrl:initSkillRsp", 5)
	if content.err == gErrDef.Err_None then
		self.skillData = content.rspdata
		self:initAttrData()
		_ENV = self
		self.msg = "MESSAGE_WORLD_MAP_TALENTSKILL_REFRESH"
		SoraDSendMessage(self)
	end
end
function talentSkillCtrl:selectSkillRsp(content)
	dump(content, "talentSkillCtrl:selectSkillRsp", 5)
	if content.err == gErrDef.Err_None then
		self.skillData = content.rspdata
		self:initAttrData()
		_ENV = self
		self.msg = "MESSAGE_WORLD_MAP_TALENTSKILL_REFRESH"
		SoraDSendMessage(self)
		local skillId = content.data.talentSkillId
		_ENV = nil
		;(nil).name = i18n(self:getSkillName(skillId))
		SoraDShowMsgTip(i18n("talSkill_text_06", nil))
	end
end
function talentSkillCtrl:getSkillData(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	if not self.skillData[tostring(mapClassType)] then
		_ENV = self.skillData[tostring(mapClassType)]
	end
	return self.skillData[tostring(mapClassType)]
end
function talentSkillCtrl:checkSkillActived(skillID)
	local skillData = self:getSkillData()
	for k, v in pairs(skillData) do
		if v == skillID then
			return true
		end
	end
end
function talentSkillCtrl:getSkillConfig(id)
	if not self.talent_skill_config[id] then
		_UPVALUE0_ = self.talent_skill_config[id]
	end
	return self.talent_skill_config[id]
end
function talentSkillCtrl:getBuffList(id)
	local config = self:getSkillConfig(id)
	if config then
		_UPVALUE2_ = nil
		;(nil)[1] = "attrId"
		;(nil)[2] = "attrValue"
		if serviceFunctions.tableFormat(config.buffList, nil) then
			goto lbl_17
		end
	end
	_ENV = serviceFunctions.tableFormat(config.buffList, nil)
	::lbl_17::
	return (serviceFunctions.tableFormat(config.buffList, nil))
end
function talentSkillCtrl:getSkillAttr(id, key)
	return self.talent_skill_des[id] and self.talent_skill_des[id][key]
end
function talentSkillCtrl:getSkillName(id)
	return self:getSkillAttr(id, "name") or "???"
end
function talentSkillCtrl:getSkillDes(id)
	return self:getSkillAttr(id, "des") or "???"
end
function talentSkillCtrl:getSkillIcon(id)
	return self:getSkillAttr(id, "icon")
end
function talentSkillCtrl:getSkillNum()
	return #self.talent_skill_des
end
return talentSkillCtrl
