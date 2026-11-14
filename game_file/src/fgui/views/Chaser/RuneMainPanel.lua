local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneMainPanel = class("RuneMainPanel", baseFguiPanel)
function RuneMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneMainPanel:ctor", self.viewName)
end
function RuneMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneMainPanel:onInit()
	print("=======RuneMainPanel:onInit")
	self.fields.Button_replace:fixPos()
	self.fields.Button_reName:fixPos()
	self.fields.n52:fixPos()
	self.fields.Button_attr:fixPos()
	self.fields.Button_reset:fixPos()
	self.fields.Button_use:fixPos()
	self.curData = self.proxy.param
	self.runePreArray, _ENV, self.groupSwitch = self.proxy.param, self.proxy.param, false
	self.fields.Com_title:initData(i18n("Weapon_Rune_title_001"), handler(self, self.onClickClose), handler(self, self.btnHelpClickCallBack))
	self.fields.Text_powerTitle:setString(i18n("common_text_090"))
	self.fields.Label_load:setString(i18n("common_text_3853"))
	self.fields.Label_attrTitle:setString(i18n("Weapon_suit_skill_title_001"))
	self.fields.List_attr:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_attr:setString(i18n("Weapon_Rune_button_001"))
	self.fields.Button_attr:addClickListener(handler(self, self.btnAttrClick))
	self.fields.Button_runeBag:setString(i18n("Weapon_Rune_button_002"))
	self.fields.Button_runeBag:addTouchEventListener(handler(self, self.btnBagClick))
	self.fields.Button_inherit:setVisible(false)
	self.fields.Button_inherit:setString(i18n("Weapon_Rune_inherit_001"))
	self.fields.Button_inherit:addClickListener(handler(self, self.btnInheritClick))
	self.fields.Button_shop:setVisible(false)
	self.fields.Button_shop:setString(i18n("activity_name_9001532"))
	self.fields.Button_shop:addClickListener(handler(self, self.btnShopClick))
	self.fields.Button_replace:setVisible(false)
	self.fields.Button_reName:setVisible(false)
	self.fields.Button_replace:addClickListener(handler(self, self.btnReplaceClick))
	self.fields.Button_reName:addClickListener(handler(self, self.btnRenameClick))
	self.fields.Button_use:setString(i18n("Weapon_Rune_tips_084"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseClick))
	self.fields.Button_save:setString(i18n("common_text_195"))
	self.fields.Button_save:addClickListener(handler(self, self.btnSaveClick))
	self.fields.Button_reset:setString(i18n("common_text_4152"))
	self.fields.Button_reset:addClickListener(handler(self, self.btnResetClick))
	if not godArmsRuneCtrl:getArmCfg(self.curData.weaponID) then
		local _ENV, godArmsCfg = godArmsRuneCtrl:getArmCfg(self.curData.weaponID), godArmsRuneCtrl:getArmCfg(self.curData.weaponID)
	end
	local group
	self.chooseGroup = group or godArmsCfg.usingGroup or 1
	self.curGroup = godArmsCfg.usingGroup or 1
	local items, values = self:getComboItems()
	_ENV = handler(self, self.btnResetClick)
	handler(self, self.btnResetClick).items = items
	handler(self, self.btnResetClick).values = values
	handler(self, self.btnResetClick).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_menu, handler(self, self.btnResetClick))
	local dropdown = self.fields.ComboBox_menu:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.comboBoxList:setItemRenderer(handler(self, self.onItemMenuRederer))
	self.fields.ComboBox_menu:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.chooseGroup - 1)
	end)
	self.fields.ComboBox_menu:fixChildrenPos()
	self.fields.Label_name:setString(i18n(self.curData.name))
	self.fields.Label_name:setIcon(self.curData.typeIcon)
end
function RuneMainPanel:onShow()
	print("=======RuneMainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:checkInherit()
	self:checkShop()
	self:updateArtifactAction()
	self.fields.Com_RuneSlot:initData(self.curData.weaponID)
	local list = godArmsRuneCtrl:getArmGroupList(self.curData.weaponID)
	for i, _ in ipairs(list) do
		local target = self.comboBoxList:getChildAt(#list - i)
		local icon_lock = target:getChildByName("icon_lock")
		icon_lock:setVisible(1 < i and artifactRuneRead.isRuneSetLock(i - 1))
	end
	self:updateGroupChoose()
	self:updatePower()
end
function RuneMainPanel:checkInherit()
	local value, ret = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_RUNE_INHERIT_FUNCTION)
	if ret then
		self.fields.Button_inherit:setVisible(true)
		return
	end
	local season = nebulaActivityCtrl:getCurSeason() or 1
	local state = nebulaActivityCtrl:getActivityCurState()
	local cfgSeason = constantRead.getConstValue("UNLOCK_RUNE_HERITCOST_SEASON")
	local cfgState = constantRead.getConstValue("UNLOCK_RUNE_HERITCOST_STAGE")
	if season > cfgSeason or season == cfgSeason and state >= cfgState then
		self.fields.Button_inherit:setVisible(true)
		nebulaMileStoneCtrl = true
		;(true).byUID = true
		local isGuided = SoraDConfigGet("Game:artifactRuneView:isGuide~bool", true)
		if not isGuided then
			nebulaMileStoneCtrl = true
			;(true).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			;(true).step = 91003
			SoraDSendMessage(true)
			nebulaMileStoneCtrl = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:artifactRuneView:isGuide~bool", true, nil)
		end
	else
		self.fields.Button_inherit:setVisible(false)
	end
end
function RuneMainPanel:checkShop()
	local value, ret = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_RUNE_MALL_FUNCTION)
	if ret then
		self.fields.Button_shop:setVisible(true)
		return
	end
	local season = nebulaActivityCtrl:getCurSeason() or 1
	local state = nebulaActivityCtrl:getActivityCurState()
	local cfgSeason = constantRead.getConstValue("UNLOCK_RUNE_EXCHANGERUNE_SEASON")
	local cfgState = constantRead.getConstValue("UNLOCK_RUNE_EXCHANGERUNE_STAGE")
	if season > cfgSeason or season == cfgSeason and state >= cfgState then
		self.fields.Button_shop:setVisible(true)
	else
		self.fields.Button_shop:setVisible(false)
	end
end
function RuneMainPanel:updateArtifactAction()
	local _, isExist = SoraDIsFileExistByFileName(self.curData.actionNode.png, true)
	if isExist then
		self.fields.Load_artifact:setURL(string.format("ui://ArtifactView/Com_%s", self.curData.weaponID))
		self.fields.Load_artifact:getComponent():getTransition("t0"):play(-1, 0, 0, -1)
		self.fields.Load_artifact:setVisible(true)
		self.fields.Label_load:setVisible(false)
	else
		self.fields.Load_artifact:setVisible(false)
		self.fields.Label_load:setVisible(true)
	end
end
function RuneMainPanel:showRuneSetPreview(group)
	self.runePreArray, godArmsRuneCtrl = nil, nil
	local groupList = godArmsRuneCtrl:getArmGroupList(self.curData.weaponID)
	self.runePreArray = clone(groupList[group].detail)
	self:setSlotInfo(nil, group)
	self:setSuitSkill(group)
end
function RuneMainPanel:updateSaveBtn()
	local ret = false
	local serDetail = clone(godArmsRuneCtrl:getArmDetailList(self.curData.weaponID, self.chooseGroup))
	dump(serDetail, "serDetail===")
	dump(self.runePreArray, "self.runePreArray===")
	if table.nums(serDetail) ~= table.nums(self.runePreArray) then
		ret = true
	else
		for k, v in pairs(serDetail) do
			if not self.runePreArray[k] or self.runePreArray[k] ~= v then
				ret = true
				break
			end
		end
	end
	self.fields.Button_save:setEnabled(ret)
end
function RuneMainPanel:updatePower()
	local power_weapon = equipDesRead.getArtifactPower(self.curData.weaponID, self.curData.info.level)
	local power_rune = godArmsRuneCtrl:getRunePower(self.curData.weaponID)
	local showPower = power_weapon + power_rune
	if self.oriPower then
		SoraDCreateScoreLabel(self.fields.Text_power, true):runScoreAnimation(self.oriPower, showPower, 1)
		self.oriPower = showPower
	else
		self.fields.Text_power:setString(string.formatnumberthousands(showPower))
		self.oriPower = showPower
	end
end
function RuneMainPanel:initMenu(preview, group)
	print("initMenu=====preview,group===", preview, group)
	if not godArmsRuneCtrl:getArmCfg(self.curData.weaponID) then
		local _ENV, godArmsCfg = godArmsRuneCtrl:getArmCfg(self.curData.weaponID), godArmsRuneCtrl:getArmCfg(self.curData.weaponID)
	end
	dump(godArmsCfg, "godArmsCfg")
	self.chooseGroup = group or godArmsCfg.usingGroup or 1
	self.curGroup = godArmsCfg.usingGroup
	self:updateMenuScroll()
	self:updateGroupChoose()
end
function RuneMainPanel:updateMenuScroll()
	local items, values = self:getComboItems()
	_ENV = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_menu, nil)
	self.fields.ComboBox_menu:refresh()
end
function RuneMainPanel:setSuitSkill(group)
	local group = group or 1
	local cfg = artifactRuneRead.getSuitInfo(self.curData.weaponID)
	local self.attrArray, artifactRuneRead, totalLv = godArmsRuneCtrl, godArmsRuneCtrl, group == 1 and godArmsRuneCtrl:getArmTotalLevel(self.curData.weaponID, group) or godArmsRuneCtrl:getArmTotalLevelSp(self.runePreArray)
	for k, v in ipairs(cfg) do
		local skillInfo = artifactRuneRead.getSuitSkillInfo(v.skill)
		artifactRuneRead = nil
		artifactRuneRead = nil
		;(nil).num = v.lv
		;(nil).des = i18n("Weapon_Rune_tips_004", nil) .. " " .. i18n(skillInfo.SkillIDes)
		;(nil).color = totalLv >= v.lv and cc.c3b(255, 235, 185) or cc.c3b(116, 110, 101)
		table.insert(self.attrArray, nil)
	end
	self.fields.List_attr:setNumItems(#self.attrArray)
end
function RuneMainPanel:setSlotInfo(updateUid, group)
	group = group or self.chooseGroup or 1
	self.fields.Com_RuneSlot:updateView(updateUid, group, self.runePreArray)
end
function RuneMainPanel:onComboBoxClick()
	SoraDPlaySound()
	local tag = tonumber(self.fields.ComboBox_menu:getValue())
	print("tag", tag)
	if 1 < tag and artifactRuneRead.isRuneSetLock(tag - 1) then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_086"))
		self.fields.ComboBox_menu:setSelectedIndex(self.chooseGroup - 1)
		self.controllers.c1:setSelectedIndex(0)
		return
	end
	self.chooseGroup = tag
	self:updateGroupChoose()
end
function RuneMainPanel:updateGroupChoose()
	self.fields.Button_replace:setVisible(self.chooseGroup > 1)
	self.controllers.c1:setSelectedIndex(self.chooseGroup > 1 and 1 or 0)
	self:showRuneSetPreview(self.chooseGroup)
	self:updateSaveBtn()
	self.fields.Button_reName:setVisible(self.chooseGroup ~= 1)
end
function RuneMainPanel:btnUseClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Weapon_Rune_tips_085")
	;(nil).confirmFunc = function()
		local wearTb = godArmsRuneCtrl:getWearRuneInArm(self.curData.weaponID, self.chooseGroup)
		if next(wearTb) then
			godArmsRuneCtrl = nil
			;(nil).content = i18n("Weapon_Rune_tips_102")
			;(nil).confirmFunc = function()
				godArmsRuneCtrl:sendGroupUse(self.curData.weaponID, self.chooseGroup)
			end
			;(nil).cancelString = i18n("common_text_185")
			uiManager:show("MessageBox", nil)
		else
			godArmsRuneCtrl:sendGroupUse(self.curData.weaponID, self.chooseGroup)
		end
	end
	uiManager:show("MessageBox", nil)
end
function RuneMainPanel:btnSaveClick()
	if self.fields.Button_save:isBright() then
		SoraDPlaySound()
		local detail = self.fields.Com_RuneSlot:getDetailUids()
		_ENV = nil
		;(nil).content = i18n("Weapon_Rune_tips_103")
		;(nil).confirmFunc = function()
			godArmsRuneCtrl:sendGroupSave(self.curData.weaponID, self.chooseGroup, detail)
		end
		uiManager:show("MessageBox", nil)
	end
end
function RuneMainPanel:btnResetClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Weapon_Rune_tips_094")
	;(nil).confirmFunc = function()
		godArmsRuneCtrl = nil
		godArmsRuneCtrl:sendGroupSave(self.curData.weaponID, self.chooseGroup, nil)
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_109"))
	end
	uiManager:show("MessageBox", nil)
end
function RuneMainPanel:btnReplaceClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.curData
	;(nil).group = self.chooseGroup
	uiManager:show("RuneQuickSet", nil)
end
function RuneMainPanel:btnRenameClick()
	SoraDPlaySound()
	if self.chooseGroup == 1 then
		return
	end
	if artifactRuneRead.isRuneSetLock(self.chooseGroup - 1) then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
	else
		_ENV = i18n("Weapon_Rune_tips_095")
		i18n("Weapon_Rune_tips_095").data = self.curData
		i18n("Weapon_Rune_tips_095").group = self.chooseGroup
		uiManager:show("RuneRenamePop", i18n("Weapon_Rune_tips_095"))
	end
end
function RuneMainPanel:btnInheritClick()
	SoraDPlaySound()
	uiManager:show("RuneInheritView")
end
function RuneMainPanel:btnShopClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RUNE_EXCHANGE_MALL, true) then
		_ENV = nil
		;(nil).id = gActivityTimeActivityID.RUNE_EXCHANGE_MALL
		uiManager:show("ExchangeRunePage", nil)
	end
end
function RuneMainPanel:btnBagClick()
	SoraDPlaySound()
	uiManager:show("RuneBackpack")
end
function RuneMainPanel:btnAttrClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.curData
	uiManager:show("RunePandectAttr", nil)
end
function RuneMainPanel:btnHelpClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Weapon_Rune_rule_001")
	;(nil).title = i18n("Weapon_Rune_title_001")
	uiManager:show("RuleView", nil)
end
function RuneMainPanel:onItemRederer(index, target)
	local data = self.attrArray[index + 1]
	target:setString(data.des)
	target:getChildByName("title"):setColor(data.color)
end
function RuneMainPanel:onItemMenuRederer(index, target)
	group = index + 1
	local icon_lock = target:getChildByName("icon_lock")
	icon_lock:setVisible(false)
end
function RuneMainPanel:getComboItems()
	local cfgList = godArmsRuneCtrl:getArmGroupList(self.curData.weaponID)
	local godArmsRuneCtrl, items = godArmsRuneCtrl, godArmsRuneCtrl
	local godArmsRuneCtrl, values = self.curData.weaponID, self.curData.weaponID
	for i, v in ipairs(cfgList) do
		table.insert(values, i)
		if i == 1 then
			table.insert(items, i18n("common_text_4345"))
		else
			table.insert(items, godArmsRuneCtrl:getArmGroupName(self.curData.weaponID, i))
		end
	end
	return items, values
end
return RuneMainPanel
