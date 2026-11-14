local magicLampRead = include("magicLampRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local magicLampCtrl = class("magicLampCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local worldMapWarDef = include("worldMapWarDef")
local magicLampHatchRead = include("magicLampHatchRead")
function magicLampCtrl:ctor(properties)
	magicLampCtrl.super.ctor(self, properties)
	self:resetData()
end
function magicLampCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_INIT, handler(self, self.reqMagicLampDataRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UNLOCK, handler(self, self.reqMagicLampUnlockRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UPGRADE_LV, handler(self, self.reqMagicLampUpgradeLvRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UPGRADE_STAR, handler(self, self.reqMagicLampUpgradeStarRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UPGRADE_CLASS, handler(self, self.reqMagicLampUpgradeClassRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UPGRADE_BLESS, handler(self, self.reqMagicLampUpgradeBlessRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_WEAR_SKILL, handler(self, self.reqMagicLampWearSkillRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_TAKEOFF_SKILL, handler(self, self.reqMagicLampTakeOffSkillRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_RESET_BLESS_LV, handler(self, self.reqResetBlessLvRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UNLOCK_FIRE_JINN, handler(self, self.reqUnlockFireJinnRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_UNLOCK_INFO_FIRE_JINN, handler(self, self.reqUnlockInfoFireJinnRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_CLIAMED_EXTRA_SLOT_QUEST_REWARD, handler(self, self.reqCliamedExtraSlotQuestRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_GROUP_EDIT, handler(self, self.reqMagicLampSkillGroupEditRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_GROUP_USE, handler(self, self.reqMagicLampSkillGroupUseRsp))
	self:registerNotify()
end
function magicLampCtrl:initClientData()
	_ENV = nil
	;(nil).byUID = true
	self.showingJinnType = SoraDConfigGet("System:magicLampCtrl:showingJinnType~integer", nil) or 1
	self:sendReqInitDataMsg()
end
function magicLampCtrl:Logout()
	magicLampCtrl.super.Logout(self)
	self:resetData()
end
function magicLampCtrl:resetData()
	;(nil).list, _UPVALUE0_, _UPVALUE0_, self.blessSkillSpBuff, _UPVALUE0_, self.blessSkillBaseBuff, _UPVALUE0_, self.blessSkillData, _UPVALUE0_, self.blessAtts, _UPVALUE0_, self.breakAtts, _UPVALUE0_, self.questComponent, _UPVALUE0_, self.msgData = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.skillGroupData, (nil).useGroup = nil, 0
end
function magicLampCtrl:getSkillDataSafe(skillID)
	if skillID == nil then
		return nil
	end
	local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
	return magicLampSkillCtrl:getSkillData(tonumber(skillID))
end
function magicLampCtrl:normalizeWearSkillMap(skillMap)
	local _ENV, normalizedSkillMap
	local _ENV, blessSkillList
	local _ENV, addedSkillMap
	if type(skillMap) ~= "table" then
		return normalizedSkillMap, blessSkillList
	end
	for skillID, blessID in pairs(skillMap) do
		local skillData = self:getSkillDataSafe(skillID)
		local blessSlotID = tonumber(blessID)
		if skillData ~= nil and blessSlotID ~= nil then
			normalizedSkillMap[tostring(skillData.id)] = blessSlotID
			if not addedSkillMap[skillData.id] then
				addedSkillMap[skillData.id] = true
				table.insert(blessSkillList, skillData.id)
			end
		end
	end
	return normalizedSkillMap, blessSkillList
end
function magicLampCtrl:normalizeGroupSkillMap(skillMap)
	local _ENV, normalizedSkillMap
	if type(skillMap) ~= "table" then
		return normalizedSkillMap
	end
	for skillID, blessID in pairs(skillMap) do
		local skillData = self:getSkillDataSafe(skillID)
		local blessSlotID = tonumber(blessID)
		if skillData ~= nil and blessSlotID ~= nil then
			normalizedSkillMap[tostring(blessSlotID)] = skillData.id
		end
	end
	return normalizedSkillMap
end
function magicLampCtrl:serializeGroupSkillMap(skillMap)
	local _ENV, serializedSkillMap
	if type(skillMap) ~= "table" then
		return serializedSkillMap
	end
	for blessID, skillID in pairs(skillMap) do
		local skillData = self:getSkillDataSafe(skillID)
		local blessSlotID = tonumber(blessID)
		if skillData ~= nil and blessSlotID ~= nil then
			serializedSkillMap[tostring(skillData.id)] = blessSlotID
		end
	end
	return serializedSkillMap
end
function magicLampCtrl:normalizeSkillGroup(skillData)
	local _ENV, normalizedSkillData
	if type(skillData) ~= "table" then
		return normalizedSkillData
	end
	for jinnID, jinnSkillData in pairs(skillData) do
		normalizedSkillData[tostring(jinnID)] = self:normalizeGroupSkillMap(jinnSkillData)
	end
	return normalizedSkillData
end
function magicLampCtrl:serializeSkillGroup(skillData)
	local _ENV, serializedSkillData
	if type(skillData) ~= "table" then
		return serializedSkillData
	end
	for jinnID, jinnSkillData in pairs(skillData) do
		serializedSkillData[tostring(jinnID)] = self:serializeGroupSkillMap(jinnSkillData)
	end
	return serializedSkillData
end
function magicLampCtrl:normalizeSkillGroupList(skillGroupData)
	;(nil).list, _ENV, _ENV = nil, nil, nil
	local (nil).useGroup, normalizedGroupData = 0, nil
	if type(skillGroupData) ~= "table" then
		return normalizedGroupData
	end
	local groupList = type(skillGroupData.list) == "table" and skillGroupData.list or skillGroupData
	normalizedGroupData.useGroup = tonumber(skillGroupData.useGroup) or 0
	for groupID, groupData in pairs(groupList) do
		local normalizedGroupID = tonumber(groupID) or groupID
		if type(groupData) == "table" then
			_ENV = groupData
			groupData.name = groupData.name or nil
			normalizedGroupData.list[normalizedGroupID], groupData.skill = groupData, self:normalizeSkillGroup(groupData.skill)
		end
	end
	return normalizedGroupData
end
function magicLampCtrl:serializeSkillGroupList(skillGroupData)
	;(nil).list, _ENV, _ENV = nil, nil, nil
	local (nil).useGroup, serializedGroupData = 0, nil
	if type(skillGroupData) ~= "table" then
		return serializedGroupData
	end
	local groupList = type(skillGroupData.list) == "table" and skillGroupData.list or skillGroupData
	serializedGroupData.useGroup = tonumber(skillGroupData.useGroup) or 0
	for groupID, groupData in pairs(groupList) do
		local normalizedGroupID = tonumber(groupID) or groupID
		if type(groupData) == "table" then
			_ENV = groupData
			groupData.name = groupData.name or nil
			serializedGroupData.list[normalizedGroupID], groupData.skill = groupData, self:serializeSkillGroup(groupData.skill)
		end
	end
	return serializedGroupData
end
function magicLampCtrl:setNormalizedSkillGroupData(skillGroupData)
