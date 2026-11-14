local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordSkillDesRead = include("lordSkillDesRead")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local skillViewPanel = class("skillViewPanel", baseFguiPanel)
function skillViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("skillViewPanel:ctor", self.viewName)
end
function skillViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function skillViewPanel:onInit()
	print("=======skillViewPanel:onInit")
	self.itemID = gIDDef.GOLD
	self.itemNeed = gConstValue.LORD_RESET_SKILL_POINT
	self.selIndex = 1
	self.tabelSkillData, _ENV, self.setID = tostring(lordSkillModuleAPI:getActiveSetID()), tostring(lordSkillModuleAPI:getActiveSetID()), tostring(lordSkillModuleAPI:getActiveSetID())
	self.fields.Com_title:initData(i18n("common_title_03"), handler(self, self.onClickClose))
	self.fields.Button_combat:setTag(1)
	self.fields.Button_combat:addClickListener(handler(self, self.changeBtnClick))
	self.fields.Button_develop:setTag(2)
	self.fields.Button_develop:addClickListener(handler(self, self.changeBtnClick))
	self.fields.Button_support:setTag(3)
	self.fields.Button_support:addClickListener(handler(self, self.changeBtnClick))
	self.fields.btn_equip:setString(i18n("common_btn_05"))
	self.fields.btn_equip:setGoldColor(cc.c3b(255, 251, 213))
	self.fields.btn_equip:addClickListener(handler(self, self.onClick_btn_equip))
	self.fields.btn_reset:setString(i18n("common_text_4152"))
	self.fields.btn_reset:addClickListener(handler(self, self.onClick_btn_reset))
	self.fields.btnReset:setString(i18n("common_text_369"))
	self.fields.btnReset:setGoldColor(cc.c3b(255, 251, 213))
	self.fields.btnReset:addClickListener(handler(self, self.resetBtnClick))
	self.fields.Button_combat:fixPos()
	self.fields.Button_develop:fixPos()
	self.fields.Button_support:fixPos()
end
function skillViewPanel:onShow()
	print("=======skillViewPanel:onShow")
	self.skillID = self.param and self.param.skillID
	self:updateTitle()
	self:updateReset()
	if self.skillID then
		local selIndex = self.selIndex
		for index = 1, 3 do
			local skillData = lordSkillModuleAPI:getSkillSetData(tostring(index))
			if skillData.battle[tostring(self.skillID)] then
				selIndex = 1
				break
			end
			if skillData.develop[tostring(self.skillID)] then
				selIndex = 2
				break
			end
			if skillData.auxiliary[tostring(self.skillID)] then
				selIndex = 3
				break
			end
		end
		self.selIndex = selIndex
	end
	local curActiveSetID = lordSkillModuleAPI:getActiveSetID()
	if curActiveSetID then
		self.setID = tonumber(curActiveSetID)
	end
	self:didSelectTab(self.setID)
end
function skillViewPanel:endShow()
	if self.tabelSkillData.skillPoints > 0 then
		SoraDGetCtrl("guideCtrl"):updateGuideModule(gGuideModule.LORD_SKILL_GUIDE)
	end
	if self.skillID and not SoraDIsGameGuide() then
		self:jumpToSkill(self.skillID)
		self.skillID = nil
	end
end
function skillViewPanel:updateTitle()
	local ctype = combinationCtrl.COMBINATION_TYPE.LORDSKILL
	local skillTitle = combinationCtrl:getSetName(ctype, self.setID)
	self.fields.Com_title:updateTitle(skillTitle)
	combinationCtrl = skillTitle
	skillTitle.setID = self.setID
	skillTitle.ctype = combinationCtrl.COMBINATION_TYPE.LORDSKILL
	skillTitle.rtype = 2
	function skillTitle.handle(selectID)
		self:didSelectTab(selectID)
	end
	self.fields.Com_setTitle:initData(skillTitle)
end
function skillViewPanel:didSelectTab(index)
	print("skillViewPanel:didSelectTab(index) = ", index)
	self.setID = tostring(index)
	self.fields.Com_setTitle:setTitleName(combinationCtrl:getSetName(combinationCtrl.COMBINATION_TYPE.LORDSKILL, self.setID))
	self:updateView()
end
function skillViewPanel:updateView()
	SoraDCloseLoading(self)
	self:updateSome()
	self:updateSkillScroll()
	self:updateBottomBtn()
	self:updateReset()
end
function skillViewPanel:updateReset()
	self.isEnoughReset = false
	local toolNum = backpackCtrl:getItemCount(501301)
	if 0 < toolNum then
		self.itemID = 501301
		self.itemNeed = 1
		self.fields.btn_equip:setCostTitle(toolNum .. "/" .. self.itemNeed)
		self.fields.btnReset:setCostTitle(toolNum .. "/" .. self.itemNeed)
		self.isEnoughReset = true
	else
		self.itemID = gIDDef.GOLD
		self.itemNeed = gConstValue.LORD_RESET_SKILL_POINT
		self.fields.btn_equip:setCostTitle(self.itemNeed)
		self.fields.btnReset:setCostTitle(self.itemNeed)
		self.isEnoughReset = SoraDEnoughGold(self.itemNeed, true)
	end
	self.fields.btn_equip:setCostIcon(publicRead.getIcon(self.itemID))
	self.fields.btnReset:setCostIcon(publicRead.getIcon(self.itemID))
end
function skillViewPanel:updateSome()
	self.tabelSkillData = lordSkillModuleAPI:getSkillSetData(self.setID)
	self.controllers.c1:setSelectedIndex(self.selIndex - 1)
	self.fields.Button_combat:initData(1, self.tabelSkillData.battlePoints, self.selIndex == 1)
	self.fields.Button_develop:initData(2, self.tabelSkillData.developPoints, self.selIndex == 2)
	self.fields.Button_support:initData(3, self.tabelSkillData.auxiliaryPoints, self.selIndex == 3)
	lordSkillModuleAPI = self.selIndex == 3
	;(self.selIndex == 3).point = fguiHelper.getColorString("#FFFFFF", self.tabelSkillData.skillPoints)
	self.fields.Lab_skillPoint:setString(i18n("common_text_373", self.selIndex == 3))
end
function skillViewPanel:jumpToSkill(skillID)
	skillID = tostring(skillID)
	local obj
	local curSetID = lordSkillModuleAPI:getActiveSetID()
	self.setID = tostring(curSetID)
	if self.tabelSkillData.battle[skillID] then
		self.selIndex = 1
		self:updateSome()
		obj = self.fields.skillCombatScroll:jumpToSkillID(skillID)
	elseif self.tabelSkillData.develop[skillID] then
		self.selIndex = 2
		self:updateSome()
		obj = self.fields.skillDevelopScroll:jumpToSkillID(skillID)
	elseif self.tabelSkillData.auxiliary[skillID] then
		self.selIndex = 3
		self:updateSome()
		obj = self.fields.skillSupportScroll:jumpToSkillID(skillID)
	end
	self:updateBottomBtn()
	return obj
end
function skillViewPanel:updateSkillScroll()
	if self.selIndex == 1 then
		self.fields.skillCombatScroll:initData(self.tabelSkillData.battle, self.setID)
	elseif self.selIndex == 2 then
		self.fields.skillDevelopScroll:initData(self.tabelSkillData.develop, self.setID)
	elseif self.selIndex == 3 then
		self.fields.skillSupportScroll:initData(self.tabelSkillData.auxiliary, self.setID)
	end
end
function skillViewPanel:sMsgRenameSkillBack(target, data)
	local err = data.err
	if err == gErrDef.Err_None then
		self:updateTitle()
	else
		local isOK, needVipLv = lordSkillModuleAPI:isSkillSetUnlock(tostring(self.setID))
		if not isOK then
			_ENV = tostring(self.setID)
			tostring(self.setID).lv = needVipLv
			SoraDShowMsgTip(i18n("common_text_3242", tostring(self.setID)))
		end
	end
end
function skillViewPanel:sMsgSkillSetActiveBack(target, data)
	SoraDCloseLoading(self)
	local ctype = combinationCtrl.COMBINATION_TYPE.LORDSKILL
	local curSetName = combinationCtrl:getSetName(ctype, data.setID)
	_ENV = nil
	;(nil).name = curSetName
	SoraDShowMsgTip(i18n("lordskill_text_05", nil))
	self:updateBottomBtn()
end
function skillViewPanel:updateBottomBtn()
	local curActiveSetID = lordSkillModuleAPI:getActiveSetID()
	if self.setID == curActiveSetID then
		self.fields.btn_equip:setVisible(false)
		self.fields.btnReset:setPositionX(self:getWidth() / 2)
		self.fields.btnReset:setVisible(true)
		self.fields.btn_reset:setVisible(false)
	else
		self.fields.btnReset:setVisible(false)
		self.fields.btn_reset:setVisible(true)
		self.fields.btn_equip:setVisible(true)
		self.fields.btn_reset:setPositionX(SoraDFPosX(160, self:getWidth()))
		self.fields.btn_equip:setPositionX(SoraDFPosX(490, self:getWidth()))
	end
	local numOfUsed = self:getNumOfUsed()
	self.fields.btn_reset:setBright(0 < numOfUsed)
	self.fields.btnReset:setEnabled(0 < numOfUsed)
	self.fields.btn_equip:setEnabled(0 < numOfUsed)
end
function skillViewPanel:checkVipActive(needShowTip)
	local isOK, needVipLv = lordSkillModuleAPI:isSkillSetUnlock(tostring(self.setID))
	if needShowTip and not isOK then
		lordSkillModuleAPI = tostring(self.setID)
		tostring(self.setID).lv = needVipLv
		SoraDShowMsgTip(i18n("lordequip_text_11", tostring(self.setID)))
	end
	return isOK
end
function skillViewPanel:getNumOfUsed()
	local numOfused = 0
	local battlePoints = self.tabelSkillData.battlePoints
	local supportPoints = self.tabelSkillData.auxiliaryPoints
	local developPoints = self.tabelSkillData.developPoints
	numOfused = battlePoints + supportPoints + developPoints
	return numOfused
end
function skillViewPanel:changeBtnClick(context)
	SoraDPlaySound()
	local tag = context:getSender():getTag()
	if self.selIndex ~= tag then
		self.selIndex = tag
		self:updateView()
	end
end
function skillViewPanel:onClick_btn_equip()
	SoraDPlaySound()
	if not self:checkVipActive(true) then
		return
	end
	local showMsg = ""
	if self.tabelSkillData.skillPoints > 0 then
		showMsg = i18n("lordskill_text_01")
	else
		showMsg = i18n("lordskill_text_02")
	end
	_ENV = self.equipSure
	self.equipSure.itemID = self.itemID
	SoraDShowBuyBox(showMsg, gConstValue.LORD_RESET_SKILL_POINT, i18n("common_text_054"), handler(self, self.equipSure), true, self.equipSure)
end
function skillViewPanel:equipSure(event)
	if event == MSGBOX_CALLBACK_YES then
		lordSkillModuleAPI:switchSkillSet(self.setID)
		SoraDShowLoading(self)
	end
end
function skillViewPanel:onClick_btn_reset()
	SoraDPlaySound()
	if not self:checkVipActive(true) then
		return
	end
	local numOfUsed = self:getNumOfUsed()
	if numOfUsed == 0 then
		SoraDShowMsgTip(i18n("lordskill_text_04"))
		return
	end
	print("发起重置技能")
	SoraDShowMsgBox(i18n("lordskill_text_06"), i18n("common_text_054"), i18n("common_text_185"), function(event)
		if event == MSGBOX_CALLBACK_YES then
			if self.isEnoughReset then
				lordSkillModuleAPI:resetSkillSet(self.setID)
				SoraDShowLoading(self)
			else
				SoraDShowMsgTip(i18n("artifact_text_20"))
			end
		end
	end)
end
function skillViewPanel:resetBtnClick()
	if not self:checkVipActive(true) then
		SoraDPlaySound()
		return
	end
	local numOfUsed = self:getNumOfUsed()
	if numOfUsed == 0 then
		SoraDShowMsgTip(i18n("lordskill_text_04"))
		SoraDPlaySound()
		return
	end
	SoraDPlaySound("uicontrol", 55)
	local notice = i18n("common_text_712")
	for i, v in ipairs(lordInfoCtrl:getInitiativeSKill()) do
		local buffid = lordSkillDesRead.getBuffID(v.skillID)
		local isOpen, buff = buffCtrl:isBuffOpen(buffid)
		if isOpen then
			notice = i18n("common_text_1874")
			break
		end
	end
	_ENV = self.resetSure
	self.resetSure.itemID = self.itemID
	SoraDShowBuyBox(notice, gConstValue.LORD_RESET_SKILL_POINT, i18n("common_text_369"), handler(self, self.resetSure), true, self.resetSure)
end
function skillViewPanel:resetSure(event)
	if event == MSGBOX_CALLBACK_YES then
		if self.isEnoughReset then
			lordSkillModuleAPI:resetSkillSet(self.setID)
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("artifact_text_20"))
		end
	end
end
function skillViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "skillIcon" then
		local obj = self:jumpToSkill(parameters.skillID)
		return obj:getBtnIcon()
	else
		return self.fields[itemName]
	end
end
return skillViewPanel
