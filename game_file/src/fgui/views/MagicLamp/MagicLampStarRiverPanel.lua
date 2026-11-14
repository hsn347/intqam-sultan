local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampStarRiverPanel = class("MagicLampStarRiverPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local eventQuestRead = include("eventQuestRead")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
function MagicLampStarRiverPanel:ctor(...)
	self.isLRU = true
	MagicLampStarRiverPanel.super.ctor(self, ...)
	print("MagicLampStarRiverPanel:ctor", self.viewName)
end
function MagicLampStarRiverPanel:onInit()
	print("=======MagicLampStarRiverPanel:onInit")
	self.fields.Com_title:initData(i18n("jinn_gaglxy_text01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.list_slot:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list_task:setItemRenderer(handler(self, self.onTaskRenderer))
	self.fields.txt_unlock2:setString(i18n("jinn_gaglxy_text11"))
	self.fields.btn_light:setTitle(i18n("Shine_text_05"))
	self.fields.btn_light:addClickEventListener(handler(self, self.onLightClick))
	self.curSelectedSlot = nil
end
function MagicLampStarRiverPanel:endShow()
	print("=======MagicLampStarRiverPanel:endShow")
	self.curType = self.param.jinnType
	self.jinnGalaxyCfgs = magicLampRead.getJinnGalaxyCfgs(self.curType)
	self.unlockingSlot = nil
	self.newUnlockedSlot, _ENV, self.selectedStarIndex = magicLampRead.getJinnGalaxyCfgs(self.curType), magicLampRead.getJinnGalaxyCfgs(self.curType), nil
	self.isFromOpen = true
	self:updateView()
	self.isFromOpen = false
end
function MagicLampStarRiverPanel:onHide()
	self.transitions.unlock:play(1, 0, 0, 0)
	_ENV = self.transitions.unlock
	self.transitions.unlock.msg = "MESSAGE_MAGICLAMP_UNLOCK_EXTRASLOT"
	self.transitions.unlock.newSlots = self.newUnlockedSlot
	SoraDSendMessage(self.transitions.unlock)
end
function MagicLampStarRiverPanel:updateUnlockingSlot()
	self.unlockingSlot = magicLampCtrl:getUnlockingSlot(self.curType)
end
function MagicLampStarRiverPanel:updateView(slot)
	if not self.isFromOpen then
		self.transitions.unlock:play(1, 0, 0, 0)
	end
	self.curJinnLv = magicLampCtrl:getJinnLv(self.curType)
	self:updateUnlockingSlot()
	slot = slot or math.min(self.unlockingSlot, #self.jinnGalaxyCfgs)
	if self.curSelectedSlot ~= slot then
		self.selectedStarIndex = nil
	end
	self.curSelectedSlot = slot
	self.fields.list_slot:setNumItems(#self.jinnGalaxyCfgs)
	local isExtraSlotUnlocked = slot < self.unlockingSlot
	local isNeedShowUnlockAni = self.lastUnlockingSlot ~= self.unlockingSlot and self.curSelectedSlot == self.lastUnlockingSlot
	if isNeedShowUnlockAni then
		table.insert(self.newUnlockedSlot, slot)
	end
	self.lastUnlockingSlot = self.unlockingSlot
	if isExtraSlotUnlocked and not isNeedShowUnlockAni then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.txt_unlock:setString(i18n("jinn_gaglxy_text12"))
		self.fields.txt_unlock:setVisible(true)
		if self.isFromOpen then
			self.fields.Usm_1:setEffectPath("ccxh_bg_unlock.usm,ccxh_bg_unlock_loop.usm")
		else
			self.fields.Usm_1:setEffectPath("ccxh_bg_unlock_loop.usm")
		end
		local extraSlotID = magicLampRead.extraSkillSlotStartIndex + slot
		self.fields.Com_ML_JinnSkill:initExtraSkillData(self.curType, slot, extraSlotID)
		self.fields.Com_ML_JinnSkill:setClickCallback(handler(self, self.onJinnExtraSkillClick))
		return
	end
	self.curSlotCfgs = self.jinnGalaxyCfgs[slot]
	self.controllers.c1:setSelectedIndex(self.selectedStarIndex ~= nil and 1 or 0)
	local showStarRiverName = string.format("ui://MagicLamp/Com_ML_SRRiver%d_%d", self.curType, slot)
	print(showStarRiverName, "showStarRiverName")
	if self.curshowStarRiverName ~= showStarRiverName then
		self.fields.Com_ML_StarRiver:setURL(showStarRiverName)
		self.Com_ML_SRRiver = self.fields.Com_ML_StarRiver:getComponent()
		self.Com_ML_SRRiver:initData(self.curType, slot, self.curSlotCfgs)
		self.Com_ML_SRRiver:setStarClickCallback(handler(self, self.onTaskClick))
	end
	self.slotUnlockedLv = nil
	local unlocked = self.curSlotCfgs[1].open_lv <= self.curJinnLv
	self.fields.txt_unlock:setVisible(not unlocked)
	if not unlocked then
		self.slotUnlockedLv = self.curSlotCfgs[1].open_lv
		magicLampCtrl = handler(self, self.onTaskClick)
		handler(self, self.onTaskClick).lv = self.slotUnlockedLv
		self.fields.txt_unlock:setString(i18n("jinn_gaglxy_text10", handler(self, self.onTaskClick)))
	end
	self:updateTask()
	self.Com_ML_SRRiver:updateView(unlocked, isNeedShowUnlockAni)
	if isNeedShowUnlockAni then
		SoraDShowLoading(nil, nil, nil, true, 3.2)
		self.fields.Usm_1:runAction(ffa.seq(ffa.delay(1.5), ffa.callFunc(function()
			self.fields.Usm_1:setEffectPath("ccxh_unlock.usm,ccxh_bg_unlock_loop.usm")
			self.transitions.unlock:play()
		end), ffa.delay(1.7), ffa.callFunc(function()
			self.controllers.c1:setSelectedIndex(2)
			self.fields.txt_unlock:setString(i18n("jinn_gaglxy_text12"))
			self.fields.txt_unlock:setVisible(true)
			local extraSlotID = magicLampRead.extraSkillSlotStartIndex + slot
			self.fields.Com_ML_JinnSkill:initExtraSkillData(self.curType, slot, extraSlotID)
			self.fields.Com_ML_JinnSkill:setClickCallback(handler(self, self.onJinnExtraSkillClick))
			SoraDCloseLoading()
		end)))
	elseif self.isFromOpen then
		self.fields.Usm_1:setEffectPath("ccxh_bg.usm,ccxh_bg_loop.usm")
	else
		self.fields.Usm_1:setEffectPath("ccxh_bg_loop.usm")
	end
end
function MagicLampStarRiverPanel:onItemRenderer(index, obj)
	local slot = index + 1
	obj:initData(self.curType, slot, slot < self.unlockingSlot, self.unlockingSlot == slot, self.curSelectedSlot == slot)
	obj:setCallback(handler(self, self.onSlotSelected))
end
function MagicLampStarRiverPanel:onSlotSelected(slot)
	self:updateView(slot)
end
function MagicLampStarRiverPanel:onTaskClick(starIndex)
	self.selectedStarIndex = starIndex
	self.controllers.c1:setSelectedIndex(self.selectedStarIndex == nil and 0 or 1)
	self:updateTask()
end
function MagicLampStarRiverPanel:updateTask()
	if self.Com_ML_SRRiver then
		self.Com_ML_SRRiver:setSelectedStarIndex(self.selectedStarIndex)
	end
	if self.selectedStarIndex == nil then
		return
	end
	self.curJinnGalaxyCfg = self.jinnGalaxyCfgs[self.curSelectedSlot][self.selectedStarIndex]
	dump(self.curJinnGalaxyCfg, "self.curJinnGalaxyCfg")
	self.preJinnGalaxyCfg = self.jinnGalaxyCfgs[self.curSelectedSlot][self.selectedStarIndex - 1]
	local curJinnTaskState = magicLampCtrl:getTaskState(self.curType, self.curJinnGalaxyCfg.quest)
	self.curJinnTaskState = curJinnTaskState
	local preJinnTaskState = self.preJinnGalaxyCfg and magicLampCtrl:getTaskState(self.curType, self.preJinnGalaxyCfg.quest) or gBtnTargetStatusDef.GOT
	self.preJinnTaskState = preJinnTaskState
	self.lightBtnTip = nil
	self.fields.Label_title:setTitle(i18n(self.curJinnGalaxyCfg.name_key))
	local slotPlusValue = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT)
	nebulaMileStoneCtrl = gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT
	gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT[1] = gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT
	gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT[2] = slotPlusValue
	dump(gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT, "slotPlusValue")
	local taskName = self:getMilStoneTaskName(self.curSelectedSlot)
	if preJinnTaskState == nil and self.slotUnlockedLv ~= nil or self.curJinnGalaxyCfg.open_lv > self.curJinnLv then
		_ENV = slotPlusValue
		slotPlusValue.lv = self.curJinnGalaxyCfg.open_lv
		self.lightBtnTip = i18n("jinn_gaglxy_text06", slotPlusValue)
		_ENV = i18n(self.curJinnGalaxyCfg.name_key)
		i18n(self.curJinnGalaxyCfg.name_key).lv = self.curJinnGalaxyCfg.open_lv
		self.fields.txt_taskState:setString(i18n("jinn_gaglxy_text13", i18n(self.curJinnGalaxyCfg.name_key)))
		self.controllers.c2:setSelectedIndex(0)
	elseif curJinnTaskState == gBtnTargetStatusDef.GOT then
		self.lightBtnTip = i18n("jinn_gaglxy_text07")
		self.fields.txt_taskState:setString(i18n("jinn_gaglxy_text14"))
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(2)
		dump(curJinnTaskState, "curJinnTaskState")
		if slotPlusValue < self.curSelectedSlot or curJinnTaskState ~= gBtnTargetStatusDef.GET then
			self.lightBtnTip = i18n("jinn_gaglxy_text05")
		elseif preJinnTaskState ~= gBtnTargetStatusDef.GOT then
			self.lightBtnTip = i18n("jinn_gaglxy_text08")
		end
		self.fields.btn_light:setGrayed(self.lightBtnTip ~= nil)
	end
	self.questShowData, _ENV = self.fields.btn_light.setGrayed, self.fields.btn_light.setGrayed
	local questID = self.curJinnGalaxyCfg.quest
	_ENV = i18n("jinn_gaglxy_text14")
	i18n("jinn_gaglxy_text14").desc = eventQuestRead.getDesEx(questID)
	i18n("jinn_gaglxy_text14").num = magicLampCtrl:getTaskProgress(self.curType, questID)
	i18n("jinn_gaglxy_text14").max = eventQuestRead.getAim(questID)
	i18n("jinn_gaglxy_text14").guideID = eventQuestRead.getGuideId(questID)
	table.insert(self.questShowData, i18n("jinn_gaglxy_text14"))
	if self.preJinnGalaxyCfg then
		_ENV = i18n("jinn_gaglxy_text14")
		i18n("jinn_gaglxy_text14").desc = i18n(self.preJinnGalaxyCfg.name_key)
		i18n("jinn_gaglxy_text14").num = preJinnTaskState == gBtnTargetStatusDef.GOT and 1 or 0
		i18n("jinn_gaglxy_text14").max = 1
		table.insert(self.questShowData, i18n("jinn_gaglxy_text14"))
	end
	if taskName then
		_ENV = i18n("jinn_gaglxy_text14")
		_ENV = self.curType
		self.curType.name = taskName
		i18n("jinn_gaglxy_text14").desc = i18n("common_text_4778", self.curType)
		i18n("jinn_gaglxy_text14").num = slotPlusValue < self.curSelectedSlot and 0 or 1
		i18n("jinn_gaglxy_text14").max = 1
		table.insert(self.questShowData, i18n("jinn_gaglxy_text14"))
	elseif slotPlusValue < self.curSelectedSlot then
		_ENV = i18n("jinn_gaglxy_text14")
		i18n("jinn_gaglxy_text14").desc = i18n("jinn_gaglxy_text15")
		i18n("jinn_gaglxy_text14").num = 0
		i18n("jinn_gaglxy_text14").max = 1
		table.insert(self.questShowData, i18n("jinn_gaglxy_text14"))
	end
	self.fields.list_task:setNumItems(#self.questShowData)
end
function MagicLampStarRiverPanel:getMilStoneTaskName(slot)
	if self.curType == gJinnType.JINN_TWO then
		local nebulaMileStoneRead = include("nebulaMileStoneRead")
		local unlockMileStoneTask = nebulaMileStoneRead.getConfigByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_JINN_TWO_EXTRASLOT, slot)
		return unlockMileStoneTask and nebulaMileStoneRead.getName(unlockMileStoneTask.milestoneID) or nil
	else
		return nil
	end
end
function MagicLampStarRiverPanel:onTaskRenderer(index, obj)
	local showData = self.questShowData[index + 1]
	obj:initData(showData)
end
function MagicLampStarRiverPanel:onLightClick()
	SoraDPlaySound()
	if self.lightBtnTip then
		SoraDShowMsgTip(self.lightBtnTip)
		return
	end
	magicLampCtrl:reqCliamedExtraSlotQuest(self.curType, self.curJinnGalaxyCfg.quest)
end
function MagicLampStarRiverPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("jinn_gaglxy_text17")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MagicLampStarRiverPanel:onJinnExtraSkillClick(extraSlotID)
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	;(nil).blessID = extraSlotID
	uiManager:show("MagicLampPower", nil)
end
return MagicLampStarRiverPanel
