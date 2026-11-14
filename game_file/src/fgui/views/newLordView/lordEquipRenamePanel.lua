local MAX_EQUIP_NAME_LEN = 15
local MAX_SKILL_NAME_LEN = 10
local MAX_WARGEM_NAME_LEN = 10
local MAX_MAGIC_LAMP_GROUP_NAME_LEN = 10
local MAX_EQUIP_BAPTIZESET_LEN = 20
local MAX_TEAMS_NAME_LEN = 5
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
_ENV = "magicLampCtrl"
;("magicLampCtrl").LORD_EQUIP = 1
;("magicLampCtrl").SKILL_VIEW = 2
;("magicLampCtrl").WARGEM_VIEW = 3
;("magicLampCtrl").COMBINATION_VIEW = 4
;("magicLampCtrl").METEOR_MAGIC_VIEW = 5
;("magicLampCtrl").EQUIP_BAPTIZE_SET = 6
;("magicLampCtrl").TROOP_FLAG_TEAMS = 7
;("magicLampCtrl").MARK_GROUP_TEAMS = 8
;("magicLampCtrl").DEFEND_COMPILE = 9
local ("magicLampCtrl").MAGIC_LAMP_GROUP, renameType = 10, "magicLampCtrl"
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local lordEquipRenamePanel = class("lordEquipRenamePanel", baseFguiPanel)
function lordEquipRenamePanel:ctor(...)
	self.super.ctor(self, ...)
	print("lordEquipRenamePanel:ctor", self.viewName)
end
function lordEquipRenamePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function lordEquipRenamePanel:onInit()
	print("=======lordEquipRenamePanel:onInit")
	self.isHaveTextField = true
	self.maxTextLen = MAX_EQUIP_NAME_LEN
	self.fields.Panel_bg:setString(i18n("lordequip_text_09"))
	self.fields.Text_tip:setString(i18n("lordequip_text_04"))
	_ENV = i18n("lordequip_text_04")
	i18n("lordequip_text_04").count = MAX_NICKNAME_LEN
	self.fields.Text_warn:setString(i18n("common_text_364", i18n("lordequip_text_04")))
	self.fields.Button_rename:setString(i18n("common_text_204"))
	self.fields.Button_rename:addClickListener(handler(self, self.btnRenameClickCallBack))
	self.fields.TextField_rename:setMaxLength(self.maxTextLen)
	self.fields.TextField_rename:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.TextField_rename:setAlign(SoraDFLabelR())
	self.fields.TextField_rename:setPrompt(fguiHelper.getColorString("#746e65", i18n("lordequip_text_05")))
	self.fields.status:setVisible(false)
	self.fields.status:fixPos()
end
function lordEquipRenamePanel:onShow()
	print("=======lordEquipRenamePanel:onShow")
	self.setID = self.param and self.param.setID
	self.renameType = self.param and self.param.renameType or renameType.LORD_EQUIP
	self.quality = self.param and self.param.quality
	self.data = self.param and self.param.data
	self.troopID = self.param and self.param.troopID
	self.magicLampSkillGroup = self.param and self.param.magicLampSkillGroup
	self:initData()
	if self.renameType == renameType.MAGIC_LAMP_GROUP then
		local setID = tonumber(self.setID) or self.setID
		if not magicLampCtrl:getSkillGroupName(setID) then
			_ENV = setID
			setID.name = setID
		end
		self.fields.TextField_rename:setPrompt((i18n("lordskill_page_01", setID)))
	end
end
function lordEquipRenamePanel:nickNameErr(target, data)
	if data.content.err == gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER and data.content.data.nickName == self.tfdRename:getString() then
		self.fields.Text_warn:setString(i18n("common_text_366"))
		self.fields.Text_warn:setColor(display.COLOR_RED)
		self.fields.status:setSpriteFrame("icon_no.png")
		self:setBtnState(false)
	end
end
function lordEquipRenamePanel:setBtnState(canUse)
	self.fields.Button_rename:setEnabled(canUse)
end
function lordEquipRenamePanel:initData()
	if not self.renameType then
		self.renameType = renameType.LORD_EQUIP
	elseif self.renameType == renameType.SKILL_VIEW then
		self.fields.Panel_bg:setString(i18n("lordskill_title_01"))
		self.maxTextLen = MAX_SKILL_NAME_LEN
		renameType = i18n("lordskill_title_01")
		i18n("lordskill_title_01").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("lordskill_title_01")))
	elseif self.renameType == renameType.WARGEM_VIEW or self.renameType == renameType.COMBINATION_VIEW then
		self.fields.Panel_bg:setString(i18n("lordskill_title_01"))
		self.maxTextLen = MAX_WARGEM_NAME_LEN
		renameType = i18n("lordskill_title_01")
		i18n("lordskill_title_01").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("lordskill_title_01")))
	elseif self.renameType == renameType.MAGIC_LAMP_GROUP then
		self.fields.Panel_bg:setString(i18n("lordskill_title_01"))
		self.maxTextLen = MAX_MAGIC_LAMP_GROUP_NAME_LEN
		renameType = i18n("lordskill_title_01")
		i18n("lordskill_title_01").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("lordskill_title_01")))
	elseif self.renameType == renameType.METEOR_MAGIC_VIEW then
		self.fields.Panel_bg:setString(i18n("meteoritesmagic_text_13"))
		self.maxTextLen = MAX_SKILL_NAME_LEN
		renameType = i18n("meteoritesmagic_text_13")
		i18n("meteoritesmagic_text_13").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("meteoritesmagic_text_13")))
		self.fields.Text_tip:setString(i18n("meteoritesmagic_text_14"))
	elseif self.renameType == renameType.EQUIP_BAPTIZE_SET then
		self.fields.Panel_bg:setString(i18n("lordskill_title_01"))
		self.maxTextLen = MAX_EQUIP_BAPTIZESET_LEN
		renameType = i18n("lordskill_title_01")
		i18n("lordskill_title_01").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("lordskill_title_01")))
	elseif self.renameType == renameType.TROOP_FLAG_TEAMS then
		self.fields.Panel_bg:setString(i18n("common_text_2148"))
		self.maxTextLen = MAX_TEAMS_NAME_LEN
		renameType = i18n("common_text_2148")
		i18n("common_text_2148").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("common_text_2148")))
		self.fields.Text_tip:setString(i18n("rename_limit_text1"))
		self.fields.TextField_rename:setPrompt(armyCtrl:getArmyCompileName(self.troopID))
	elseif self.renameType == renameType.MARK_GROUP_TEAMS then
		self.fields.Panel_bg:setString(i18n("lordskill_title_01"))
		self.maxTextLen = MAX_TEAMS_NAME_LEN
		renameType = i18n("lordskill_title_01")
		i18n("lordskill_title_01").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("lordskill_title_01")))
	elseif self.renameType == renameType.DEFEND_COMPILE then
		self.fields.Panel_bg:setString(i18n("common_text_2148"))
		self.maxTextLen = MAX_TEAMS_NAME_LEN
		renameType = i18n("common_text_2148")
		i18n("common_text_2148").count = self.maxTextLen
		self.fields.Text_warn:setString(i18n("common_text_364", i18n("common_text_2148")))
		self.fields.Text_tip:setString(i18n("rename_limit_text1"))
		self.fields.TextField_rename:setPrompt(armyCtrl:getDefendCompileName(self.setID))
	end
	self.fields.TextField_rename:setMaxLength(self.maxTextLen)
	self:setBtnState(false)
end
function lordEquipRenamePanel:updateView()
	local returnName = self.fields.TextField_rename:getText()
	local nameLen = string.utf8len(returnName)
	self.fields.status:setVisible(true)
	local isLegal = equipmentCtrl:isTitleLegal(returnName)
	if isLegal then
		self.fields.status:setSpriteFrame("icon_yes.png")
		_ENV = nil
		;(nil).count = self.maxTextLen - nameLen
		self.fields.Text_warn:setString(i18n("common_text_364", nil))
		self.fields.Text_warn:setColor(cc.c3b(215, 195, 155))
		self:setBtnState(true)
	else
		local strTip = i18n(i18n("notice_0071"))
		if nameLen == 0 then
			_ENV = i18n("notice_0071")
			i18n("notice_0071").num = 1
			strTip = i18n("common_text_1442", i18n("notice_0071"))
		end
		self.fields.Text_warn:setString(strTip)
		self.fields.Text_warn:setColor(display.COLOR_RED)
		self.fields.status:setSpriteFrame("icon_no.png")
		self:setBtnState(false)
	end
end
function lordEquipRenamePanel:updateLegalView()
	local returnName = self.fields.TextField_rename:getText()
	local nameLen = string.utf8len(returnName)
	local judgeExistName = function(str)
		if self.renameType == renameType.TROOP_FLAG_TEAMS then
			return armyCtrl:checkArmyCompileName(str)
		elseif self.renameType == renameType.DEFEND_COMPILE then
			return armyCtrl:checkDefendCompileName(str)
		end
		return false
	end
	local namkVailidCheck = function(nickName)
		local __err
		if nickName then
			if string.utf8len(nickName) > self.maxTextLen then
				__err = gErrDef.Err_NICKNAME
			elseif string.utf8len(nickName) < 1 then
				__err = gErrDef.Err_NICKNAME_MIN_SIZE
			elseif string.sub(nickName, 1, 1) == "(" then
				__err = gErrDef.Err_NICKNAME_BRACKET
			elseif not serviceFunctions.isMatchEnNumAndArPerfectly(nickName) then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif judgeExistName(nickName) then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			elseif not SoraDIsUtf8String(nickName) then
				__err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
			else
				__err = gErrDef.Err_None
			end
		else
			__err = gErrDef.Err_NICKNAME
		end
		return __err
	end
	local err = namkVailidCheck(returnName)
	if returnName ~= "" and gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(returnName) then
		err = gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER
	end
	if err == gErrDef.Err_None then
		self.fields.status:setSpriteFrame("icon_yes.png")
		_ENV = nil
		;(nil).count = self.maxTextLen - nameLen
		self.fields.Text_warn:setString(i18n("common_text_364", nil))
		self.fields.Text_warn:setColor(cc.c3b(215, 195, 155))
		self:setBtnState(true)
	else
		if err == gErrDef.Err_NICKNAME_MIN_SIZE then
			_ENV = cc.c3b(215, 195, 155)
			cc.c3b(215, 195, 155).num = MIN_FLAGTEAM_NAME_LEN
			self.fields.Text_warn:setString(i18n("common_text_1442", cc.c3b(215, 195, 155)))
		elseif err == gErrDef.Err_NICKNAME then
			self.fields.Text_warn:setString(i18n("common_text_4575"))
		elseif err == gErrDef.Err_NICKNAME_BRACKET then
			self.fields.Text_warn:setString(i18n("common_text_367"))
		elseif err == gErrDef.Err_NICKNAME_IIIEGAL_CHARACTER then
			self.fields.Text_warn:setString(i18n("common_text_366"))
		end
		self.fields.Text_warn:setColor(display.COLOR_RED)
		self.fields.status:setSpriteFrame("icon_no.png")
		self:setBtnState(false)
	end
end
function lordEquipRenamePanel:onChanged()
	self.fields.Text_warn:setColor(cc.c3b(50, 20, 0))
	self.fields.status:setVisible(false)
	local returnName = self.fields.TextField_rename:getText()
	local nameLen = string.utf8len(returnName)
	if self.renameType == renameType.LORD_EQUIP or self.renameType == renameType.TROOP_FLAG_TEAMS then
		_ENV = cc.c3b(50, 20, 0)
		cc.c3b(50, 20, 0).count = self.maxTextLen - nameLen
		self.fields.Text_warn:setString(i18n("common_text_364", cc.c3b(50, 20, 0)))
	elseif self.renameType == renameType.SKILL_VIEW or self.renameType == renameType.WARGEM_VIEW or self.renameType == renameType.COMBINATION_VIEW or self.renameType == renameType.MARK_GROUP_TEAMS or self.renameType == renameType.MAGIC_LAMP_GROUP then
		_ENV = i18n("common_text_364", cc.c3b(50, 20, 0))
		i18n("common_text_364", cc.c3b(50, 20, 0)).count = self.maxTextLen - nameLen
		self.fields.Text_warn:setString(i18n("lordequip_text_04", i18n("common_text_364", cc.c3b(50, 20, 0))))
	end
	if self.renameType == renameType.TROOP_FLAG_TEAMS or self.renameType == renameType.DEFEND_COMPILE then
		self:updateLegalView()
	else
		self:updateView()
	end
end
function lordEquipRenamePanel:btnRenameClickCallBack(button, type)
	SoraDPlaySound()
	local name = self.fields.TextField_rename:getText()
	if self.renameType == renameType.LORD_EQUIP then
		equipmentCtrl:setEquipmentSetTitle(self.setID, name)
	elseif self.renameType == renameType.SKILL_VIEW then
		local lordSkillModuleAPI = include("lordSkillModuleAPI")
		lordSkillModuleAPI:setSkillSetTitle(self.setID, name)
	elseif self.renameType == renameType.WARGEM_VIEW then
		local warGemCtrl = SoraDGetCtrl("warGemCtrl")
		warGemCtrl:reqRenamePanel(tonumber(self.setID), name)
	elseif self.renameType == renameType.COMBINATION_VIEW then
		local combinationCtrl = SoraDGetCtrl("combinationCtrl")
		_ENV = tonumber(self.setID)
		tonumber(self.setID).setId = self.setID
		tonumber(self.setID).name = name
		combinationCtrl:reqCombinationSet((tonumber(self.setID)))
	elseif self.renameType == renameType.METEOR_MAGIC_VIEW then
		local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
		meteorMagicCtrl:modifyName(tonumber(self.setID), name)
	elseif self.renameType == renameType.EQUIP_BAPTIZE_SET then
		equipmentCtrl:setAttributeGroupInfo(1, self.quality, self.data.position, self.data.info, name)
	elseif self.renameType == renameType.TROOP_FLAG_TEAMS then
		armyCtrl:setArmyCompileName(self.troopID, name)
	elseif self.renameType == renameType.MARK_GROUP_TEAMS then
		divineBeastMarkCtrl:sendRename(self.setID, name)
	elseif self.renameType == renameType.DEFEND_COMPILE then
		armyCtrl:setDefendCompileName(self.setID, name)
	elseif self.renameType == renameType.MAGIC_LAMP_GROUP then
		local groupID = tonumber(self.setID) or self.setID
		local skillGroup = self.magicLampSkillGroup and clone(self.magicLampSkillGroup) or nil
		if skillGroup == nil then
			if not magicLampCtrl:getSkillGroup(groupID) then
				local _ENV, groupData = magicLampCtrl:getSkillGroup(groupID), magicLampCtrl:getSkillGroup(groupID)
			end
			skillGroup, _ENV = groupData.skill, groupData.skill
			skillGroup = groupData.skill or nil
		end
		magicLampCtrl:reqMagicLampSkillGroupEdit(groupID, name, skillGroup)
	end
	self:close()
end
return lordEquipRenamePanel
