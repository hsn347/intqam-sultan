local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local combinationCtrl = class("combinationCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function combinationCtrl:ctor(properties)
	combinationCtrl.super.ctor(self, properties)
	self:resetData()
	combinationCtrl = self.resetData
	self.resetData.WARGEM = 1
	self.resetData.LORDSKILL = 2
	self.resetData.EQUIPMENT = 3
	self.resetData.TEAMEDIT = 4
	self.resetData.COMBINATION = 5
	self.resetData.ARMRUNE = 6
	self.resetData.MAGICLAMP = 7
	self.COMBINATION_TYPE, self.resetData.DIVINEBEASTMARK = self.resetData, 100
end
function combinationCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COMBINATION_MODULE, gCmd.REQ_COMBINATION_INIT_DATA, handler(self, self.reqCombinationInitDataRsp))
	msgCtrl.register(gCmd.CMD_COMBINATION_MODULE, gCmd.REQ_COMBINATION_SET, handler(self, self.reqCombinationSetRsp))
	msgCtrl.register(gCmd.CMD_COMBINATION_MODULE, gCmd.REQ_COMBINATION_USE, handler(self, self.reqCombinationUseRsp))
end
function combinationCtrl:Logout()
	combinationCtrl.super.Logout(self)
	self:resetData()
end
function combinationCtrl:resetData()
	self.combinationPreData, _UPVALUE0_, self.combinationData, _UPVALUE0_ = nil, nil, nil, nil
	self.curSetId = 0
end
function combinationCtrl:setCombinationData(data, setId)
	if setId then
		local combData = self:getCombinationData(setId)
		if combData then
			for k, v in pairs(data) do
				combData[k] = v
			end
		else
			combData = data
		end
		self.combinationData[tostring(setId)] = combData
	else
		self.combinationData = data
	end
end
function combinationCtrl:setCombinationPreData(data, setId)
	if setId then
		local combData = self:getCombinationPreData(setId)
		if combData then
			for k, v in pairs(data) do
				combData[k] = v
			end
		else
			combData = data
		end
		self.combinationPreData[tostring(setId)] = combData
	else
		self.combinationPreData = data
	end
end
function combinationCtrl:isMagicLampCombinationOpen()
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if magicLampCtrl == nil or magicLampCtrl.getIsJinnUnlock == nil then
		return false
	end
	if (CONST_VALUE.MAGIC_SKILL_COMBINATION or 0) ~= 1 then
		return false
	end
	return magicLampCtrl:getIsJinnUnlock(gJinnType.JINN_ONE) == true
end
function combinationCtrl:getMagicLampGroupIDList()
	local _ENV, groupIDList
	if not self:isMagicLampCombinationOpen() then
		return groupIDList
	end
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if magicLampCtrl == nil or magicLampCtrl.getSkillGroupList == nil then
		return groupIDList
	end
	local _ENV, existed = magicLampCtrl.getSkillGroupList, magicLampCtrl.getSkillGroupList
	if not magicLampCtrl:getSkillGroupList() then
		_ENV = magicLampCtrl:getSkillGroupList()
	end
	for groupID, _ in pairs((magicLampCtrl:getSkillGroupList())) do
		local normalizedGroupID = tonumber(groupID)
		if normalizedGroupID and 0 < normalizedGroupID and not existed[normalizedGroupID] then
			table.insert(groupIDList, normalizedGroupID)
			existed[normalizedGroupID] = true
		end
	end
	table.sort(groupIDList)
	return groupIDList
end
function combinationCtrl:getBaseCombinationSlotList()
	_ENV, _UPVALUE4_ = nil, nil
	;(nil).ctype = self.COMBINATION_TYPE.WARGEM
	;(nil).fieldKey = "warGemSetId"
	;(nil).iconFrame = "icon_zxtq_01.png"
	_ENV, (nil).bgFrame = self.COMBINATION_TYPE.WARGEM, "frame_zxtq_bg_zi_01.png"
	self.COMBINATION_TYPE.WARGEM.ctype = self.COMBINATION_TYPE.LORDSKILL
	self.COMBINATION_TYPE.WARGEM.fieldKey = "lordSkillSetId"
	self.COMBINATION_TYPE.WARGEM.iconFrame = "icon_zxtq_02.png"
	_ENV, self.COMBINATION_TYPE.WARGEM.bgFrame = self.COMBINATION_TYPE.LORDSKILL, "frame_zxtq_bg_h_01.png"
	self.COMBINATION_TYPE.LORDSKILL.ctype = self.COMBINATION_TYPE.EQUIPMENT
	self.COMBINATION_TYPE.LORDSKILL.fieldKey = "equipmentSetId"
	self.COMBINATION_TYPE.LORDSKILL.iconFrame = "icon_zxtq_03.png"
	_ENV, self.COMBINATION_TYPE.LORDSKILL.bgFrame = self.COMBINATION_TYPE.EQUIPMENT, "frame_zxtq_bg_g_01.png"
	self.COMBINATION_TYPE.EQUIPMENT.ctype = self.COMBINATION_TYPE.TEAMEDIT
	self.COMBINATION_TYPE.EQUIPMENT.fieldKey = "defendSetId"
	self.COMBINATION_TYPE.EQUIPMENT.iconFrame = "icon_zxtq_04.png"
	self.COMBINATION_TYPE.EQUIPMENT.bgFrame = "frame_zxtq_bg_r_01.png"
	;(nil)[1] = nil
	;(nil)[2] = self.COMBINATION_TYPE.WARGEM
	;(nil)[3] = self.COMBINATION_TYPE.LORDSKILL
	local (nil)[4], slotList = self.COMBINATION_TYPE.EQUIPMENT, nil
	if self:isMagicLampCombinationOpen() then
		_ENV = self.COMBINATION_TYPE.LORDSKILL
		self.COMBINATION_TYPE.LORDSKILL.ctype = self.COMBINATION_TYPE.MAGICLAMP
		self.COMBINATION_TYPE.LORDSKILL.fieldKey = "magicLampSkillSetId"
		self.COMBINATION_TYPE.LORDSKILL.iconFrame = "icon_common_shenlizuhe.png"
		self.COMBINATION_TYPE.LORDSKILL.bgFrame = "frame_zxtq_bg_r_01.png"
		table.insert(slotList, self.COMBINATION_TYPE.LORDSKILL)
	end
	return slotList
end
function combinationCtrl:getBaseCombinationSlotInfo(ctype)
	for _, slotInfo in ipairs(self:getBaseCombinationSlotList()) do
		if slotInfo.ctype == ctype then
			return slotInfo
		end
	end
	return nil
end
function combinationCtrl:getSetIDListForType(ctype)
	if ctype == self.COMBINATION_TYPE.MAGICLAMP then
		return self:getMagicLampGroupIDList()
	end
	local warGemltCtrl = include("warGemltCtrl")
	_ENV = "warGemltCtrl"
	;("warGemltCtrl")[self.COMBINATION_TYPE.WARGEM] = warGemltCtrl:getGemSwitchCount()
	;("warGemltCtrl")[self.COMBINATION_TYPE.LORDSKILL] = 6
	;("warGemltCtrl")[self.COMBINATION_TYPE.EQUIPMENT] = 8
	local ("warGemltCtrl")[self.COMBINATION_TYPE.TEAMEDIT], maxNumMap = 6, "warGemltCtrl"
	local _ENV, setIDList = self.COMBINATION_TYPE.TEAMEDIT, self.COMBINATION_TYPE.TEAMEDIT
	local maxNum = maxNumMap[ctype] or 0
	for i = 1, maxNum do
		local setID = tostring(i)
		if self:checkSetUnLock(ctype, setID) then
			table.insert(setIDList, setID)
		end
	end
	return setIDList
end
function combinationCtrl:hasConfiguredSet(combData)
	if type(combData) ~= "table" then
		return false
	end
	for _, slotInfo in ipairs(self:getBaseCombinationSlotList()) do
		if 0 < (tonumber(combData[slotInfo.fieldKey]) or 0) then
			return true
		end
	end
	if type(combData.godArmsRunes) == "table" and next(combData.godArmsRunes) ~= nil then
		return true
	end
	if type(combData.divineBeastMarkSet) == "table" and next(combData.divineBeastMarkSet) ~= nil then
		return true
	end
	return false
end
function combinationCtrl:reqCombinatioInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COMBINATION_MODULE, gCmd.REQ_COMBINATION_INIT_DATA, nil)
end
function combinationCtrl:reqCombinationSet(data, setId, isUse)
	dump(data, "reqCombinationSet=====111", 10)
	if data.godArmsRunes then
		local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
		for id, group in pairs(data.godArmsRunes) do
			local armsInfo = godArmsCtrl:getArmsInfo(id)
			if not armsInfo or armsInfo and armsInfo.isLock then
				data.godArmsRunes[id] = nil
			end
		end
	end
	if data.isUsing then
		self:setCombinationPreData(data, setId)
		_ENV = self
		self.msg = "MESSAGE_REFRESH_COMBINATION"
		self.isUsing = data.isUsing
		SoraDSendMessage(self)
	else
		SoraDShowLoading()
		serverproxy:Request(gCmd.CMD_COMBINATION_MODULE, gCmd.REQ_COMBINATION_SET, data)
	end
end
function combinationCtrl:reqCombinationUse(setId)
	SoraDShowLoading()
	_ENV = nil
	;(nil).setId = setId
	serverproxy:Request(gCmd.CMD_COMBINATION_MODULE, gCmd.REQ_COMBINATION_USE, nil)
end
function combinationCtrl:reqCombinationInitDataRsp(content)
	dump(content, "combinationCtrl:reqCombinationInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setCombinationData(content.rspdata.combinationSet)
		self.curSetId = content.rspdata.setId
	end
end
function combinationCtrl:reqCombinationSetRsp(content)
	dump(content, "combinationCtrl:reqCombinationSetRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		if not content.data.isUsing then
			SoraDShowMsgTip(i18n("privilege_text_105"))
		end
		self:setCombinationData(content.data, content.data.setId)
		if content.data.isUse then
			self:reqCombinationUse(content.data.setId)
		end
		_ENV = self
		self.msg = "MESSAGE_REFRESH_COMBINATION"
		self.isUsing = content.data.isUsing
		SoraDSendMessage(self)
	end
end
function combinationCtrl:reqCombinationUseRsp(content)
	dump(content, "combinationCtrl:reqCombinationUseRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("epicbattle_text_51"))
		self.curSetId = content.data.setId
		local data = self:getCombinationData(content.data.setId)
		dump(data, "==data==")
		if not data.warGemSetId or data.warGemSetId > 0 then
		end
		if data.lordSkillSetId and 0 < data.lordSkillSetId then
			local msgCtrl = include("msgCtrl")
			_ENV, _ENV = i18n("epicbattle_text_51")
			i18n("epicbattle_text_51").cmd = gCmd.CMD_LORD_MODULE
			i18n("epicbattle_text_51").subcmd = gCmd.REQ_LORD_SKILL_SWITCH
			_ENV, i18n("epicbattle_text_51").err = gErrDef.Err_None, gErrDef.Err_None
			;("==data==").content, i18n("epicbattle_text_51").data, gErrDef.Err_None.setID = i18n("epicbattle_text_51")
			msgCtrl.handle("==data==")
		end
		if data.equipmentSetId and 0 < data.equipmentSetId then
			_G.buff_noDispathchAll = true
			local msgCtrl = include("msgCtrl")
			_ENV, _ENV = i18n("epicbattle_text_51")
			i18n("epicbattle_text_51").cmd = gCmd.CMD_EQUIPMENT_MODULE
			i18n("epicbattle_text_51").subcmd = gCmd.REQ_ACTIVE_EQUIPMENTSET
			_ENV, i18n("epicbattle_text_51").err = gErrDef.Err_None, gErrDef.Err_None
			;("==data==").content, i18n("epicbattle_text_51").data, gErrDef.Err_None.setID = i18n("epicbattle_text_51")
			msgCtrl.handle("==data==")
			_G.buff_noDispathchAll = false
			_ENV = i18n("epicbattle_text_51")
			i18n("epicbattle_text_51").name = gEventName.event_buff_update
			SoraDGetCtrl("buffCtrl"):dispatchEvent(i18n("epicbattle_text_51"))
		end
		if data.defendSetId and 0 < data.defendSetId then
			local armyCtrl = SoraDGetCtrl("armyCtrl")
			if armyCtrl.armyInfo then
				armyCtrl.armyInfo.activeDefCompile = data.defendSetId
			end
		end
		if data.godArmsRunes and next(data.godArmsRunes) then
			for godArmsID, group in pairs(data.godArmsRunes) do
				SoraDGetCtrl("godArmsRuneCtrl"):setUseGroup(tonumber(godArmsID), group)
			end
		end
		if not data.divineBeastMarkSetId or 0 < data.divineBeastMarkSetId then
		end
		local magicLampSkillSetId = tonumber(data.magicLampSkillSetId) or 0
		if 0 < magicLampSkillSetId then
			local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
			if magicLampCtrl and magicLampCtrl.applySkillGroup then
				magicLampCtrl:applySkillGroup(magicLampSkillSetId)
				magicLampCtrl:finishGuideActive()
				_ENV = magicLampCtrl
				magicLampCtrl.msg = "MESSAGE_MAGICLAMP_UPDATE"
				SoraDSendMessage(magicLampCtrl)
			end
		end
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_REFRESH_COMBINATION"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function combinationCtrl:getCombinationData(setId)
	if setId then
		return self.combinationData[tostring(setId)]
	else
		return self.combinationData
	end
end
function combinationCtrl:getCombinationPreData(setId)
	if setId then
		return self.combinationPreData[tostring(setId)]
	else
		return self.combinationPreData
	end
end
function combinationCtrl:getSetName(ctype, setID)
	local tabName
	if ctype == self.COMBINATION_TYPE.LORDSKILL then
		local lordSkillModuleAPI = include("lordSkillModuleAPI")
		tabName = lordSkillModuleAPI:getSkillSetTitle(tostring(setID))
		if tabName == "" or tabName == nil then
			_ENV = tostring(setID)
			tostring(setID).name = setID
			tabName = i18n("lordskill_page_01", tostring(setID))
		end
	elseif ctype == self.COMBINATION_TYPE.EQUIPMENT then
		local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
		tabName = equipmentCtrl:getSetTitle(tostring(setID))
		if tabName == "" then
			_ENV = tostring(setID)
			tostring(setID).num = setID
			tabName = i18n("lordequip_text_08", tostring(setID))
		end
	elseif ctype == self.COMBINATION_TYPE.WARGEM then
		local warGemCtrl = SoraDGetCtrl("warGemCtrl")
		tabName = warGemCtrl:getGemPanelName(tostring(setID))
		if tabName == "" or tabName == nil then
			_ENV = tostring(setID)
			tostring(setID).name = setID
			tabName = i18n("lordskill_page_01", tostring(setID))
		end
	elseif ctype == self.COMBINATION_TYPE.TEAMEDIT then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		_ENV = tostring(setID)
		tostring(setID).var = setID
		local default = i18n("Soldiers_armor_text_86", tostring(setID))
		tabName = armyCtrl:getDefendCompileName(setID, default)
	elseif ctype == self.COMBINATION_TYPE.MAGICLAMP then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		tabName = magicLampCtrl and magicLampCtrl.getSkillGroupName and magicLampCtrl:getSkillGroupName(setID) or nil
		if tabName == "" or tabName == nil then
			_ENV = setID
			setID.name = setID
			tabName = i18n("lordskill_page_01", setID)
		end
	elseif ctype == self.COMBINATION_TYPE.COMBINATION then
		local combData = self:getCombinationData(setID)
		if not combData or not combData.name then
			_ENV = setID
			setID.num = setID
		end
		return (i18n("privilege_text_101", setID))
	elseif ctype == self.COMBINATION_TYPE.DIVINEBEASTMARK then
		local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
		return divineBeastMarkCtrl:getGroupName(setID)
	end
	return tabName
end
function combinationCtrl:checkSetUnLock(ctype, setID, needShowTip)
	setID = tostring(setID)
	local unlock, condValue, condKey
	if ctype == self.COMBINATION_TYPE.LORDSKILL then
		local lordSkillModuleAPI = include("lordSkillModuleAPI")
		unlock, condValue, condKey = lordSkillModuleAPI:isSkillSetUnlock(setID)
	elseif ctype == self.COMBINATION_TYPE.EQUIPMENT then
		local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
		unlock, condValue, condKey = equipmentCtrl:isEquipmentSetUnlock(setID)
	elseif ctype == self.COMBINATION_TYPE.WARGEM then
		local ret = SoraDGetCtrl("cityCtrl"):getBuildCell(BUILDID.MIRACLE, 0)
		if not ret then
			return
		end
		local warGemCtrl = SoraDGetCtrl("warGemCtrl")
		unlock, condValue, condKey = warGemCtrl:checkVip(setID)
	elseif ctype == self.COMBINATION_TYPE.TEAMEDIT then
		if tonumber(setID) <= 4 then
			unlock = true
		end
	elseif ctype == self.COMBINATION_TYPE.MAGICLAMP then
		unlock = self:isMagicLampCombinationOpen()
	elseif ctype == self.COMBINATION_TYPE.DIVINEBEASTMARK then
		unlock = true
	end
	if not unlock and needShowTip then
		if gConditionType.VIP_LEVEL_AND_ACTIVE == condKey then
			if condValue > VIP_SVIP_LV then
				_ENV = warGemCtrl:checkVip(setID)
				warGemCtrl:checkVip(setID).lv = condValue - VIP_SVIP_LV
				SoraDShowMsgTip(i18n("common_text_4335", warGemCtrl:checkVip(setID)))
			else
				_ENV = i18n("common_text_4335", warGemCtrl:checkVip(setID))
				i18n("common_text_4335", warGemCtrl:checkVip(setID)).lv = condValue
				SoraDShowMsgTip(i18n("common_text_3242", i18n("common_text_4335", warGemCtrl:checkVip(setID))))
			end
		elseif gConditionType.EXALTED_PRIVILEGE == condKey then
			SoraDShowMsgTip(i18n("privilege_text_100"))
		end
	end
	return unlock, condValue, condKey
end
function combinationCtrl:getCurSetId(...)
	return self.curSetId
end
return combinationCtrl
