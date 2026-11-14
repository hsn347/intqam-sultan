local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buildLogic = include("buildLogic")
local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroJailListPanel = class("HeroJailListPanel", baseFguiPanel)
function HeroJailListPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroJailListPanel:ctor", self.viewName)
end
_ENV, HeroJailListPanel.getPackageList = function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).RUN_TIME = 1
local (function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).QUALITY, sortTypeDef = 2, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroJailListPanel:onInit()
	print("=======HeroJailListPanel:onInit")
	self.fields.Com_title:initData(i18n("buildDes_name_125"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_noRecord:setString(i18n("hero_text_83"))
	self.curSortType = sortTypeDef.RUN_TIME
	sortTypeDef, _ENV = i18n("hero_text_83")
	i18n("hero_text_83").items, i18n("hero_text_83")[1] = i18n("hero_text_83")
	i18n("hero_text_83").items, i18n("hero_text_83")[2] = i18n("hero_text_83")
	i18n("hero_text_83").items, i18n("hero_text_83")[3] = i18n("hero_text_83")
	i18n("hero_text_83").selectedIndex = self.curSortType - 1
	i18n("hero_text_83").changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox, i18n("hero_text_83"))
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType - 1)
	end)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function HeroJailListPanel:onShow()
	print("=======HeroJailListPanel:onShow")
	self:initData()
end
function HeroJailListPanel:initData(...)
	self.heroInMyJail = heroJailCtrl:getHerosInMyPrison()
	dump(self.heroInMyJail, "self.heroInMyJail")
	self:initPrisonNum()
	self:initReduceSpeedTime()
	self:initAddAttack()
	self:updateList()
end
function HeroJailListPanel:initPrisonNum(...)
	local totalNum = buildLogic.getHeroJailCapacity().total
	local curNum = table.nums(self.heroInMyJail)
	buildLogic = nil
	;(nil).num1 = curNum
	;(nil).num2 = totalNum
	self.fields.Text_imprisonNum:setString(i18n("prison_text_02", nil))
end
function HeroJailListPanel:initReduceSpeedTime(...)
	local reduceTime = buildLogic.getHeroJailReduceSpeedTime().total
	buildLogic = nil
	;(nil).time = SoraDConvertSecondToString(reduceTime)
	self.fields.Text_speedExecuteWait:setString(i18n("prison_text_03", nil))
end
function HeroJailListPanel:initAddAttack(...)
	local canAddNum = buildLogic.getHeroJailAddAttack()
	if 0 < canAddNum then
		self.fields.Text_troopAttackForce:setVisible(true)
		self.fields.Text_highestLevel:setVisible(true)
		if next(self.heroInMyJail) then
			local buildLogic, lvs = next(self.heroInMyJail), next(self.heroInMyJail)
			for k, v in pairs(self.heroInMyJail) do
				local tmp = heroJailCtrl:getHerosInMyPrisonByID(v)
				table.insert(lvs, tmp.level)
			end
			table.sort(lvs, function(l, r)
				return r < l
			end)
			local attackValue = 0
			for i = 1, canAddNum do
				if lvs[i] then
					attackValue = attackValue + heroltCtrl.getJailAttackBuffByLevel(lvs[i])
				end
			end
			buildLogic = heroltCtrl.getJailAttackBuffByLevel(lvs[i])
			heroltCtrl.getJailAttackBuffByLevel(lvs[i]).name = i18n("prison_columntext_02")
			buildLogic, buildLogic, heroltCtrl.getJailAttackBuffByLevel(lvs[i]).num = "%d%%", string.format("%d%%", attackValue / 10), string.format("%d%%", attackValue / 10)
			string.format("%d%%", attackValue / 10).num, ("%d%%").color = "%d%%", "#70C723"
			self.fields.Text_troopAttackForce:setString(i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10))))
			buildLogic = i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10)))
			i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10))).lv = lvs[1]
			self.fields.Text_highestLevel:setString(i18n("prison_text_05", i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10)))))
		else
			buildLogic = i18n("prison_text_05", i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10))))
			i18n("prison_text_05", i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10)))).name = i18n("prison_columntext_02")
			buildLogic, buildLogic, i18n("prison_text_05", i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10)))).num = "%d%%", string.format("%d%%", 0), string.format("%d%%", 0)
			string.format("%d%%", 0).num, ("%d%%").color = "%d%%", "#70C723"
			self.fields.Text_troopAttackForce:setString(i18n_html("disassemble_fast_9", i18n("prison_text_05", i18n_html("disassemble_fast_9", heroltCtrl.getJailAttackBuffByLevel(lvs[i]), (string.format("%d%%", attackValue / 10))))))
			self.fields.Text_highestLevel:setString("")
		end
	else
		self.fields.Text_troopAttackForce:setVisible(false)
		self.fields.Text_highestLevel:setVisible(false)
	end
end
function HeroJailListPanel:updateList()
	local funcRunTime = function(info)
		return info.captureTime + info.killTime + info.executeTime
	end
	local funcStateScore = function(state)
		if state == gHeroJailState.escape then
			return 0
		end
		return state + 1
	end
	local _ENV, sortFunc
	sortFunc[sortTypeDef.QUALITY] = function(l, r)
		local lInfo = heroJailCtrl:getHerosInMyPrisonByID(l)
		local rInfo = heroJailCtrl:getHerosInMyPrisonByID(r)
		if lInfo.isAwake == rInfo.isAwake then
			if lInfo.quality == rInfo.quality then
				return funcRunTime(lInfo.extraData) < funcRunTime(rInfo.extraData)
			else
				return lInfo.quality > rInfo.quality
			end
		else
			return lInfo.isAwake or false
		end
	end
	sortFunc[sortTypeDef.RUN_TIME] = function(l, r)
		local lInfo = heroJailCtrl:getHerosInMyPrisonByID(l)
		local rInfo = heroJailCtrl:getHerosInMyPrisonByID(r)
		return funcRunTime(lInfo.extraData) < funcRunTime(rInfo.extraData)
	end
	table.sort(self.heroInMyJail, sortFunc[self.curSortType])
	self.fields.List:setNumItems(#self.heroInMyJail)
	if next(self.heroInMyJail) then
		self.fields.Text_noRecord:setVisible(false)
	else
		self.fields.Text_noRecord:setVisible(true)
	end
end
function HeroJailListPanel:onItemRederer(index, target)
	target:initData(self.heroInMyJail[index + 1])
end
function HeroJailListPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_JAIL)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.HERO_JAIL)
	end
end
function HeroJailListPanel:onComboBoxChanged()
	local index = self.fields.ComboBox:getSelectedIndex()
	self.curSortType = index + 1
	self:updateList()
end
return HeroJailListPanel
