local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampRead = include("magicLampRead")
local MagicLampSkillGroupPanel = class("MagicLampSkillGroupPanel", baseFguiPanel)
local CURRENT_GROUP_ID = 0
local MAGIC_LAMP_GROUP_RENAME_TYPE = 10
_ENV = nil
;(nil).BLESS = 1
local _ENV, (nil).EXTRA, SLOT_TYPE = nil, 2, nil
;(nil).LOCK = 0
;(nil).EMPTY = 1
;(nil).HIDE = 2
local (nil).HAS_SKILL, GROUP_ITEM_C1_STATE = 3, nil
function MagicLampSkillGroupPanel:ctor(...)
	self.isLRU = true
	MagicLampSkillGroupPanel.super.ctor(self, ...)
	print("MagicLampSkillGroupPanel:ctor", self.viewName)
	self.slotDefs, MagicLampSkillGroupPanel, self.listSkillData, MagicLampSkillGroupPanel, self.selectedGroupID = CURRENT_GROUP_ID, CURRENT_GROUP_ID, CURRENT_GROUP_ID, CURRENT_GROUP_ID, CURRENT_GROUP_ID
	self.editGroupID = nil
	self.editSkillMap = nil
	self.hasLocalDraft = false
	self.syncDraft = true
	self.pendingSync = false
	self.pendingUseAfterSave = false
	self.pendingSwitchToCurrent = false
end
function MagicLampSkillGroupPanel:onInit()
	print("=======MagicLampSkillGroupPanel:onInit")
	self.fields.listSkill:setItemRenderer(handler(self, self.itemRenderer_listSkill))
	self.fields.Panel_bg:setString(i18n("magic_lamp_text_168"))
	self.fields.btnSave:setTitle(i18n("common_text_195"))
	self.fields.btnSave:addClickListener(handler(self, self.onClick_btnSave))
	self.fields.btnUse:setTitle(i18n("common_text_314"))
	self.fields.btnUse:addClickListener(handler(self, self.onClick_btnUse))
	self.fields.btnReset:setTitle(i18n("common_text_4152"))
	self.fields.btnReset:addClickListener(handler(self, self.onClick_btnReset))
	handler(self, self.onClick_btnReset).values, _ENV, handler(self, self.onClick_btnReset).items, _ENV, _ENV = handler(self, self.onClick_btnReset)
	handler(self, self.onClick_btnReset).changedCallback = handler(self, self.onComboBoxClick)
	handler(self, self.onClick_btnReset).showCurSelect = true
	self:setComboBox(self.fields.ComboBox_menu, handler(self, self.onClick_btnReset))
	self.fields.Button_edit:addClickListener(handler(self, self.onClick_btnCombine))
	self.fields.Button_rename:addClickListener(handler(self, self.onClick_btnRename))
	self.fields.ComboBox_menu:addClickListener(function()
		SoraDPlaySound()
	end)
	self.fields.btnReset:fixPos()
	self.fields.btnUse:fixPos()
	self.fields.ComboBox_menu:fixChildrenPos()
	self.fields.Button_edit:fixPos()
	self.fields.Button_rename:fixPos()
end
function MagicLampSkillGroupPanel:endShow()
	print("=======MagicLampSkillGroupPanel:endShow")
	self.selectedGroupID = self.param and tonumber(self.param.groupID) or CURRENT_GROUP_ID
	self.syncDraft = true
	self:updateView()
end
function MagicLampSkillGroupPanel:onMagicLampUpdate()
	if self.pendingUseAfterSave then
		self.pendingUseAfterSave = false
		self.pendingSwitchToCurrent = true
		magicLampCtrl:reqMagicLampSkillGroupUse(self.selectedGroupID)
		return
	end
	if self.pendingSync then
		self.syncDraft = true
		self.pendingSync = false
	end
	if self.pendingSwitchToCurrent then
		self.selectedGroupID = CURRENT_GROUP_ID
		self.syncDraft = true
		self.pendingSwitchToCurrent = false
	end
	if not self.syncDraft then
		self:syncDraftSkillMap()
	end
	self:updateView()
end
function MagicLampSkillGroupPanel:isViewingCurrentGroup()
	return self.selectedGroupID == CURRENT_GROUP_ID
end
function MagicLampSkillGroupPanel:getUsingGroupID()
	if not magicLampCtrl.skillGroupData then
		local magicLampCtrl, skillGroupData = magicLampCtrl.skillGroupData, magicLampCtrl.skillGroupData
	end
	return tonumber(skillGroupData.useGroup) or 0
end
function MagicLampSkillGroupPanel:cloneSkillMap(skillMap)
	if type(skillMap) ~= "table" then
		_ENV = type(skillMap)
		return (type(skillMap))
	end
	return clone(skillMap)
end
function MagicLampSkillGroupPanel:setSkillIdToMap(skillMap, jinnType, blessID, skillID)
	if not skillMap[tostring(jinnType)] then
		_ENV = skillMap[tostring(jinnType)]
	end
	skillMap[tostring(jinnType)] = skillMap[tostring(jinnType)]
	skillMap[tostring(jinnType)][tostring(blessID)] = skillID
end
function MagicLampSkillGroupPanel:removeSkillIdFromMap(skillMap, jinnType, blessID)
	local jinnMap = skillMap[tostring(jinnType)] or skillMap[tonumber(jinnType)]
	if type(jinnMap) ~= "table" then
		return
	end
	jinnMap[tostring(blessID)] = nil
	jinnMap[tonumber(blessID)] = nil
	if next(jinnMap) == nil then
		skillMap[tostring(jinnType)] = nil
		skillMap[tonumber(jinnType)] = nil
	end
end
function MagicLampSkillGroupPanel:getSkillIdFromMap(skillMap, jinnType, blessID)
	if type(skillMap) ~= "table" then
		return nil
	end
	local jinnMap = skillMap[tostring(jinnType)] or skillMap[tonumber(jinnType)]
	if type(jinnMap) ~= "table" then
		return nil
	end
	return jinnMap[tostring(blessID)] or jinnMap[tonumber(blessID)]
end
function MagicLampSkillGroupPanel:getGroupDisplayName(groupID)
	if groupID == CURRENT_GROUP_ID then
		return i18n("common_text_4345")
	end
	local groupName = magicLampCtrl:getSkillGroupName(groupID)
	if groupName == nil or groupName == "" then
		CURRENT_GROUP_ID = nil
		;(nil).name = groupID
		return i18n("lordskill_page_01", nil)
	end
	return groupName
end
function MagicLampSkillGroupPanel:getCurrentSkillMap()
	local _ENV, skillMap
	for __, slotDef in ipairs(self.slotDefs) do
		local skillID = magicLampCtrl:getBlessSkillId(slotDef.jinnType, slotDef.blessID)
		if skillID ~= nil then
			self:setSkillIdToMap(skillMap, slotDef.jinnType, slotDef.blessID, skillID)
		end
	end
	return skillMap
end
function MagicLampSkillGroupPanel:getSavedGroupSkillMap(groupID)
	local groupData = magicLampCtrl:getSkillGroup(groupID)
	if not groupData or not groupData.skill then
		magicLampCtrl = groupData.skill
	end
	return self:cloneSkillMap(groupData.skill)
end
function MagicLampSkillGroupPanel:getSkillMapByID(groupID)
	if groupID == CURRENT_GROUP_ID then
		return self:getCurrentSkillMap()
	end
	return self:getSavedGroupSkillMap(groupID)
end
function MagicLampSkillGroupPanel:buildSlotDefs()
	self.slotDefs, _ENV = nil, nil
	magicLampRead = nil
	;(nil)[1] = gJinnType.JINN_ONE
	;(nil)[2] = gJinnType.JINN_TWO
	for __, jinnType in ipairs(nil) do
		local jinnData = magicLampCtrl:getJinnByType(jinnType)
		local jinnUnlocked = magicLampCtrl:getIsJinnUnlock(jinnType)
		local starLv = jinnData and jinnData.starLv or 0
		local breakCfg = jinnData and magicLampRead.getBreakThroughCfg(jinnType, starLv) or nil
		local nowMaxLv = breakCfg and breakCfg.MaxLv or 0
		if not magicLampRead.getBigBlessList(jinnType) then
			_ENV = magicLampRead.getBigBlessList(jinnType)
		end
		for __, blessCfg in ipairs((magicLampRead.getBigBlessList(jinnType))) do
			local blessLv = magicLampCtrl:getBlessLv(jinnType, blessCfg.BlessID)
			_ENV = blessCfg.BlessID
			blessCfg.BlessID.slotType = SLOT_TYPE.BLESS
			blessCfg.BlessID.jinnType = jinnType
			blessCfg.BlessID.blessID = blessCfg.BlessID
			blessCfg.BlessID.currentClickable = jinnUnlocked and nowMaxLv >= blessCfg.PreJinnLv
			blessCfg.BlessID.canConfig = jinnUnlocked and 0 < blessLv
			table.insert(self.slotDefs, blessCfg.BlessID)
		end
		if jinnType == gJinnType.JINN_TWO then
			if not magicLampRead.getJinnGalaxyCfgs(jinnType) then
				local _ENV, jinnGalaxyCfgs = magicLampRead.getJinnGalaxyCfgs(jinnType), magicLampRead.getJinnGalaxyCfgs(jinnType)
			end
			local unlockingSlot = magicLampCtrl:getUnlockingSlot(jinnType)
			for slot = 1, #jinnGalaxyCfgs do
				local extraSkillData = magicLampCtrl:getExtraSkillData(jinnType, slot)
				local isUnlockingSlot = slot == unlockingSlot
				_ENV = nil
				;(nil).slotType = SLOT_TYPE.EXTRA
				;(nil).jinnType = jinnType
				;(nil).slotIndex = slot
				;(nil).blessID = magicLampRead.extraSkillSlotStartIndex + slot
				;(nil).currentClickable = jinnUnlocked and (extraSkillData ~= nil or isUnlockingSlot)
				;(nil).canConfig = jinnUnlocked and extraSkillData ~= nil
				;(nil).isUnlockingSlot = isUnlockingSlot
				table.insert(self.slotDefs, nil)
			end
		end
	end
end
function MagicLampSkillGroupPanel:getGroupIDList()
	local _ENV, groupIDList
	if not magicLampCtrl:getSkillGroupList() then
		_ENV = magicLampCtrl:getSkillGroupList()
	end
	for groupID, __ in pairs((magicLampCtrl:getSkillGroupList())) do
		groupID = tonumber(groupID)
		if groupID and 0 < groupID then
			table.insert(groupIDList, groupID)
		end
	end
	table.sort(groupIDList)
	return groupIDList
end
function MagicLampSkillGroupPanel:updateComboBox(groupIDList)
	_ENV = nil
	_ENV, (nil)[1] = i18n("common_text_4345")
	_ENV, (nil)[2] = i18n("common_text_4345")
	_ENV, (nil)[3] = i18n("common_text_4345")
	_ENV, (nil)[4] = i18n("common_text_4345")
	_ENV, (nil)[5] = i18n("common_text_4345")
	_ENV, (nil)[6] = i18n("common_text_4345")
	_ENV, (nil)[7] = i18n("common_text_4345")
	_ENV, (nil)[8] = i18n("common_text_4345")
	_ENV, (nil)[9] = i18n("common_text_4345")
	_ENV, (nil)[10] = i18n("common_text_4345")
	local _ENV, (nil)[11], items = i18n("common_text_4345")
	i18n("common_text_4345")[1] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[2] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[3] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[4] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[5] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[6] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[7] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[8] = tostring(CURRENT_GROUP_ID)
	i18n("common_text_4345")[9] = tostring(CURRENT_GROUP_ID)
	local i18n("common_text_4345")[10], values = tostring(CURRENT_GROUP_ID)
	for __, groupID in ipairs(groupIDList) do
		table.insert(items, self:getGroupDisplayName(groupID))
		table.insert(values, tostring(groupID))
	end
	_ENV = tostring(CURRENT_GROUP_ID)
	tostring(CURRENT_GROUP_ID).items = items
	tostring(CURRENT_GROUP_ID).values = values
	tostring(CURRENT_GROUP_ID).selectedValue = tostring(self.selectedGroupID)
	tostring(CURRENT_GROUP_ID).changedCallback = handler(self, self.onComboBoxClick)
	tostring(CURRENT_GROUP_ID).showCurSelect = true
	self:setComboBox(self.fields.ComboBox_menu, tostring(CURRENT_GROUP_ID))
	if self.fields.ComboBox_menu.refresh then
		self.fields.ComboBox_menu:refresh()
	end
end
function MagicLampSkillGroupPanel:ensureDraftData()
	if self:isViewingCurrentGroup() then
		self.editGroupID = nil
		self.editSkillMap = nil
		self.hasLocalDraft = false
		self.syncDraft = false
		return
	end
	if self.syncDraft or self.editGroupID ~= self.selectedGroupID or self.editSkillMap == nil then
		self.editGroupID = self.selectedGroupID
		self.editSkillMap = self:getSavedGroupSkillMap(self.selectedGroupID)
		self.hasLocalDraft = false
		self.syncDraft = false
	end
end
function MagicLampSkillGroupPanel:syncDraftSkillMap()
	if self:isViewingCurrentGroup() or self.editSkillMap == nil then
		return
	end
	self.editSkillMap = magicLampCtrl:normalizeSkillGroup(self.editSkillMap)
end
function MagicLampSkillGroupPanel:isSameSlot(slotDataA, slotDataB)
	return slotDataA ~= nil and slotDataB ~= nil and slotDataA.jinnType == slotDataB.jinnType and slotDataA.blessID == slotDataB.blessID
end
function MagicLampSkillGroupPanel:isSkillMapEmpty(skillMap)
	for __, slotDef in ipairs(self.slotDefs) do
		if self:getSkillIdFromMap(skillMap, slotDef.jinnType, slotDef.blessID) ~= nil then
			return false
		end
	end
	return true
end
function MagicLampSkillGroupPanel:isDraftDirty()
	if self:isViewingCurrentGroup() then
		return false
	end
	local serverMap = self:getSavedGroupSkillMap(self.selectedGroupID)
	for __, slotDef in ipairs(self.slotDefs) do
		local draftSkillID = self:getSkillIdFromMap(self.editSkillMap, slotDef.jinnType, slotDef.blessID)
		local serverSkillID = self:getSkillIdFromMap(serverMap, slotDef.jinnType, slotDef.blessID)
		if draftSkillID ~= serverSkillID then
			return true
		end
	end
	return false
end
function MagicLampSkillGroupPanel:getOtherSkillIdList(slotData)
	local _ENV, otherList
	for __, otherSlot in ipairs(self.slotDefs) do
		if not self:isSameSlot(slotData, otherSlot) then
			local skillID = self:getSkillIdFromMap(self.editSkillMap, otherSlot.jinnType, otherSlot.blessID)
			if skillID ~= nil then
				table.insert(otherList, skillID)
			end
		end
	end
	return otherList
end
function MagicLampSkillGroupPanel:hasSelectableSkill(slotDef, skillMap)
	if not slotDef.canConfig then
		return false
	end
	local _ENV, usedSkillTypeMap = false, false
	local _ENV, usedSkillIdMap
	for __, otherSlot in ipairs(self.slotDefs) do
		if not self:isSameSlot(slotDef, otherSlot) then
			local skillID = self:getSkillIdFromMap(skillMap, otherSlot.jinnType, otherSlot.blessID)
			if skillID ~= nil then
				usedSkillIdMap[skillID] = true
				local skillData = magicLampSkillCtrl:getSkillData(skillID)
				if skillData then
					usedSkillTypeMap[skillData.skillType] = true
				end
			end
		end
	end
	if not magicLampSkillCtrl:getSkillList() then
		_ENV = magicLampSkillCtrl:getSkillList()
	end
	for __, skillData in ipairs((magicLampSkillCtrl:getSkillList())) do
		if not skillData.lock and not usedSkillIdMap[skillData.id] and not usedSkillTypeMap[skillData.skillType] then
			return true
		end
	end
	return false
end
function MagicLampSkillGroupPanel:buildSlotViewData(slotDef, skillMap)
	local skillID = self:getSkillIdFromMap(skillMap, slotDef.jinnType, slotDef.blessID)
	magicLampSkillCtrl = self
	self.slotType = slotDef.slotType
	self.jinnType = slotDef.jinnType
	self.blessID = slotDef.blessID
	self.slotIndex = slotDef.slotIndex
	self.isUnlockingSlot = slotDef.isUnlockingSlot
	self.skillID = skillID
	local self.canEdit, slotData = not self:isViewingCurrentGroup() and slotDef.canConfig, self
	slotData.skillData = skillID and magicLampSkillCtrl:getSkillData(skillID) or nil
	if slotData.skillData ~= nil then
		slotData.stateIndex = GROUP_ITEM_C1_STATE.HAS_SKILL
	elseif slotDef.canConfig then
		slotData.stateIndex = GROUP_ITEM_C1_STATE.EMPTY
	elseif slotDef.currentClickable then
		slotData.stateIndex = GROUP_ITEM_C1_STATE.LOCK
	else
		slotData.stateIndex = GROUP_ITEM_C1_STATE.HIDE
	end
	if self:isViewingCurrentGroup() then
		slotData.canClick = slotDef.currentClickable
		slotData.showAdd = slotData.skillData == nil and slotDef.canConfig
		slotData.showReddot = slotData.skillData == nil and slotDef.canConfig and magicLampCtrl:getUnUsedSkill() ~= nil
	else
		slotData.canClick = slotDef.canConfig
		slotData.showAdd = slotData.skillData == nil and slotDef.canConfig
		slotData.showReddot = slotData.skillData == nil and self:hasSelectableSkill(slotDef, skillMap)
	end
	return slotData
end
function MagicLampSkillGroupPanel:updateListData()
	if (not self:isViewingCurrentGroup() or not self:getCurrentSkillMap()) and not self.editSkillMap then
		local _ENV, skillMap = self.editSkillMap, self.editSkillMap
	end
	self.listSkillData, _ENV = self, self
	for __, slotDef in ipairs(self.slotDefs) do
		table.insert(self.listSkillData, self:buildSlotViewData(slotDef, skillMap))
	end
	self.fields.listSkill:setNumItems(#self.listSkillData)
end
function MagicLampSkillGroupPanel:getQuickAdjustSourceGroupIDs()
	local _ENV, groupIDList
	for __, groupID in ipairs(self:getGroupIDList()) do
		if groupID ~= self.selectedGroupID then
			table.insert(groupIDList, groupID)
		end
	end
	return groupIDList
end
function MagicLampSkillGroupPanel:updateButtonState()
	local isCurrentGroup = self:isViewingCurrentGroup()
	local sourceGroupIDs = self:getQuickAdjustSourceGroupIDs()
	self.controllers.ctrlCur:setSelectedIndex(isCurrentGroup and 0 or 1)
	self.fields.btnReset:setVisible(not isCurrentGroup)
	self.fields.btnReset:setEnabled(true)
	self.fields.Button_rename:setVisible(not isCurrentGroup)
	self.fields.Button_rename:setEnabled(not isCurrentGroup)
	self.fields.Button_edit:setVisible(not isCurrentGroup)
	self.fields.Button_edit:setEnabled(not isCurrentGroup and 0 < #sourceGroupIDs)
	self.fields.btnSave:setEnabled(self.hasLocalDraft == true)
	self.fields.btnUse:setEnabled(true)
end
function MagicLampSkillGroupPanel:updateView()
	self:buildSlotDefs()
	local groupIDList = self:getGroupIDList()
	local isValidGroup = self.selectedGroupID == CURRENT_GROUP_ID
	for __, groupID in ipairs(groupIDList) do
		if groupID == self.selectedGroupID then
			isValidGroup = true
			break
		end
	end
	if not isValidGroup then
		self.selectedGroupID = CURRENT_GROUP_ID
		self.syncDraft = true
	end
	self:updateComboBox(groupIDList)
	self:ensureDraftData()
	self:updateListData()
	self:updateButtonState()
end
function MagicLampSkillGroupPanel:itemRenderer_listSkill(index, obj)
	local data = self.listSkillData[index + 1]
	obj:initData(data, handler(self, self.onClickSkillSlot))
end
function MagicLampSkillGroupPanel:onComboBoxClick()
	local groupID = tonumber(self.fields.ComboBox_menu:getValue()) or CURRENT_GROUP_ID
	if groupID == self.selectedGroupID then
		return
	end
	SoraDPlaySound()
	self.selectedGroupID = groupID
	self.syncDraft = true
	self:updateView()
end
function MagicLampSkillGroupPanel:onClickSkillSlot(slotData)
	if slotData == nil or not slotData.canClick then
		return
	end
	SoraDPlaySound()
	if self:isViewingCurrentGroup() then
		self:onClickCurrentSkillSlot(slotData)
	else
		self:onClickDraftSkillSlot(slotData)
	end
end
function MagicLampSkillGroupPanel:onClickCurrentSkillSlot(slotData)
	if slotData.slotType == SLOT_TYPE.EXTRA and not slotData.canEdit then
		SLOT_TYPE = nil
		;(nil).jinnType = slotData.jinnType
		uiManager:show("MagicLampStarRiver", nil)
		return
	end
	SLOT_TYPE = nil
	;(nil).jinnType = slotData.jinnType
	;(nil).blessID = slotData.blessID
	uiManager:show("MagicLampPower", nil)
end
function MagicLampSkillGroupPanel:canChooseSkillForSlot(slotData, skillData)
	for __, otherSlot in ipairs(self.slotDefs) do
		if not self:isSameSlot(slotData, otherSlot) then
			local otherSkillID = self:getSkillIdFromMap(self.editSkillMap, otherSlot.jinnType, otherSlot.blessID)
			if otherSkillID ~= nil then
				local otherSkillData = magicLampSkillCtrl:getSkillData(otherSkillID)
				if otherSkillID == skillData.id or otherSkillData and otherSkillData.skillType == skillData.skillType then
					_ENV = nil
					;(nil).name = magicLampRead.getJinnName(otherSlot.jinnType)
					return false, i18n("magic_lamp_tips_012", nil)
				end
			end
		end
	end
	return true
end
function MagicLampSkillGroupPanel:onClickDraftSkillSlot(slotData)
	local skillID = self:getSkillIdFromMap(self.editSkillMap, slotData.jinnType, slotData.blessID)
	_ENV = slotData.blessID
	slotData.blessID.allSkills = true
	slotData.blessID.singleChoose = true
	slotData.blessID.needCount = 1
	slotData.blessID.ignoreUsingCheck = true
	if skillID then
		_UPVALUE1_ = nil
		;(nil)[1] = skillID
		if nil then
			goto lbl_22
		end
	end
	slotData.blessID.chooseList, _ENV = nil, nil
	::lbl_22::
	slotData.blessID.otherList = self:getOtherSkillIdList(slotData)
	slotData.blessID.index = slotData
	slotData.blessID.chooseHandle = handler(self, self.onChooseSkillBack)
	function slotData.blessID.canChooseFunc(curSkillData)
		return self:canChooseSkillForSlot(slotData, curSkillData)
	end
	uiManager:show("MagicLampSkillChoose", slotData.blessID)
end
function MagicLampSkillGroupPanel:onChooseSkillBack(slotData, chooseList)
	if self:isViewingCurrentGroup() then
		return
	end
	local skillID = chooseList and chooseList[1] or nil
	if not self.editSkillMap then
		_UPVALUE0_ = self.editSkillMap
	end
	self.editSkillMap = self.editSkillMap
	if skillID ~= nil then
		self:setSkillIdToMap(self.editSkillMap, slotData.jinnType, slotData.blessID, skillID)
	else
		self:removeSkillIdFromMap(self.editSkillMap, slotData.jinnType, slotData.blessID)
	end
	self.hasLocalDraft = true
	self.syncDraft = false
	self:updateView()
end
function MagicLampSkillGroupPanel:onCopySkillGroup(sourceGroupID)
	local sourceSkillMap = self:getSkillMapByID(sourceGroupID)
	self.editSkillMap = self:cloneSkillMap(sourceSkillMap)
	self.editGroupID = self.selectedGroupID
	self.hasLocalDraft = false
	self.syncDraft = false
	self.pendingSync = true
	self:updateView()
	if not self.editSkillMap then
		magicLampCtrl = self.editSkillMap
	end
	magicLampCtrl:reqMagicLampSkillGroupEdit(self.selectedGroupID, magicLampCtrl:getSkillGroupName(self.selectedGroupID) or "", self.editSkillMap)
end
function MagicLampSkillGroupPanel:onClick_btnCombine(context)
	if self:isViewingCurrentGroup() then
		return
	end
	local sourceGroupIDs = self:getQuickAdjustSourceGroupIDs()
	if #sourceGroupIDs == 0 then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).groupID = self.selectedGroupID
	;(nil).groupName = self:getGroupDisplayName(self.selectedGroupID)
	;(nil).groupIDList = sourceGroupIDs
	;(nil).slotDefs = clone(self.slotDefs)
	;(nil).getGroupDisplayName = handler(self, self.getGroupDisplayName)
	;(nil).getSkillMap = handler(self, self.getSkillMapByID)
	;(nil).copyCallback = handler(self, self.onCopySkillGroup)
	uiManager:show("MagicLampSkillGroupSwitch", nil)
end
function MagicLampSkillGroupPanel:onClick_btnSave(context)
	if self:isViewingCurrentGroup() or self.hasLocalDraft ~= true then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_lamp_text_170")
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		self.pendingSync = true
		if not self.editSkillMap then
			self = self.editSkillMap
		end
		magicLampCtrl:reqMagicLampSkillGroupEdit(self.selectedGroupID, magicLampCtrl:getSkillGroupName(self.selectedGroupID) or "", self.editSkillMap)
	end
	uiManager:show("MessageBox", nil)
end
function MagicLampSkillGroupPanel:onClick_btnUse(context)
	if self:isViewingCurrentGroup() then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).name1 = self:getGroupDisplayName(self.selectedGroupID)
	;(nil).name2 = self:getGroupDisplayName(CURRENT_GROUP_ID)
	;(nil).content = i18n("magic_lamp_text_173", nil)
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		self.pendingSync = true
		if self.hasLocalDraft == true then
			self.pendingUseAfterSave = true
			if not self.editSkillMap then
				self = self.editSkillMap
			end
			magicLampCtrl:reqMagicLampSkillGroupEdit(self.selectedGroupID, magicLampCtrl:getSkillGroupName(self.selectedGroupID) or "", self.editSkillMap)
		else
			self.pendingSwitchToCurrent = true
			magicLampCtrl:reqMagicLampSkillGroupUse(self.selectedGroupID)
		end
	end
	uiManager:show("MessageBox", nil)
end
function MagicLampSkillGroupPanel:onClick_btnReset()
	if not self:isViewingCurrentGroup() then
		if not self.editSkillMap then
			_ENV = self.editSkillMap
		end
		if not self:isSkillMapEmpty(self.editSkillMap) then
			goto lbl_14
		end
	end
	do return end
	::lbl_14::
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_lamp_text_169")
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		self.editSkillMap, self = nil, nil
		self.editGroupID = self.selectedGroupID
		self.hasLocalDraft = false
		self.syncDraft = false
		self.pendingSync = true
		self:updateView()
		if not self.editSkillMap then
			self = self.editSkillMap
		end
		magicLampCtrl:reqMagicLampSkillGroupEdit(self.selectedGroupID, magicLampCtrl:getSkillGroupName(self.selectedGroupID) or "", self.editSkillMap)
	end
	uiManager:show("MessageBox", nil)
end
function MagicLampSkillGroupPanel:onClick_btnRename()
	if self:isViewingCurrentGroup() then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).setID = self.selectedGroupID
	;(nil).renameType = MAGIC_LAMP_GROUP_RENAME_TYPE
	;(nil).magicLampSkillGroup = self:cloneSkillMap(self.editSkillMap or self:getSavedGroupSkillMap(self.selectedGroupID))
	uiManager:show("lordEquipRename", nil)
end
return MagicLampSkillGroupPanel
