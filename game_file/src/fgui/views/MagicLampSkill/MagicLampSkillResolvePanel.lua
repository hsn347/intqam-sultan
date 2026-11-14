local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillResolvePanel = class("MagicLampSkillResolvePanel", baseFguiPanel)
function MagicLampSkillResolvePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillResolvePanel:ctor", self.viewName)
	self.selectMap, _ENV, self.skillList, _ENV = print, print, print, print
	self.hasUpgrade = false
	self.hasAdvance = false
	self.showQuality = 2
end
function MagicLampSkillResolvePanel:onInit()
	print("=======MagicLampSkillResolvePanel:onInit")
	self.is3SSwitchOpen = constantRead.getConstValue("MAGIC_SKILL_3S_SWITCH", 0) == 1
	self.fields.Com_title:initData(i18n("jinn_skill_48"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_choose:setString(i18n("jinn_skill_37"))
	self.fields.Button_upgrade:setString(i18n("jinn_skill_53"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Button_advance:setString(i18n("jinn_skill_54"))
	self.fields.Button_advance:addClickListener(handler(self, self.onClickBtnAdvance))
	_ENV = self.fields.Button_advance.addClickListener
	local self.fields.Button_advance.addClickListener[1], config = i18n("jinn_skill_51"), self.fields.Button_advance.addClickListener
	local maxQuality = 5
	if not self.is3SSwitchOpen then
		maxQuality = 4
	end
	for quality = 2, maxQuality do
		_ENV = handler(self, self.onClickBtnAdvance)
		handler(self, self.onClickBtnAdvance).quality = magicLampSkillRead.getQualityName(quality)
		table.insert(config, i18n("jinn_skill_52", handler(self, self.onClickBtnAdvance)))
	end
	_ENV = handler(self, self.onClickBtnAdvance)
	handler(self, self.onClickBtnAdvance).items = config
	handler(self, self.onClickBtnAdvance).selectedIndex = self.showQuality - 1
	handler(self, self.onClickBtnAdvance).changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox_quality, handler(self, self.onClickBtnAdvance))
	self.fields.ComboBox_quality:addEventListener(fgui.UIEventType.Click, function()
		SoraDPlaySound()
	end)
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRenderer))
	self.fields.List_skill:setVirtual()
	self.fields.Text_noData:setString(i18n("jinn_skill_55"))
	self.fields.Button_noData:setString(i18n("starlight_btn_01"))
	self.fields.Button_noData:addClickListener(handler(self, self.onClickBtnNoData))
	local rate = magicLampSkillCtrl:getSkillResolvePro()
	_ENV = handler(self, self.onClickBtnNoData)
	handler(self, self.onClickBtnNoData).num = rate * 100 .. "%"
	self.fields.Text_des:setString(i18n("jinn_skill_42") .. "\n" .. i18n("jinn_skill_80", handler(self, self.onClickBtnNoData)))
	self.fields.Button_all:setString(i18n("common_text_404"))
	self.fields.Button_all:addClickListener(handler(self, self.onClickBtnAll))
	self.fields.Button_ok:setString(i18n("common_text_1378"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickBtnOk))
	_ENV, _ENV = self.fields.Button_ok, self.fields.Button_ok.addClickListener
	_ENV, self.fields.Button_ok.addClickListener[1], self.fields.Button_ok.itemID = self.fields.Button_ok, self.fields.Button_ok, gIDDef.MAGIC_LAMP_SKILL_ENERGY
	self.fields.Button_ok.addClickListener[2], self.fields.Button_ok.itemID = self.fields.Button_ok, 208001
	local config = self.fields.Button_ok.addClickListener
	self.config = config
	if self.is3SSwitchOpen then
		self.controllers.item:setSelectedIndex(1)
		_ENV = 1
		;(1).itemID = gIDDef.MAGIC_LAMP_SKILL_ENERGY_SSS
		table.insert(config, 1)
	end
	for i, v in ipairs(config) do
		local itemID = v.itemID
		local fields = fguiHelper.get_fields(self.fields["Com_item" .. i])
		fields.icon:setURL(publicRead.getIcon(itemID))
		fields.title:setString(publicRead.getName(itemID))
	end
	self.fields.Usm_ef1:setCompleteCallback(function()
		self.fields.Usm_ef1:setVisible(false)
	end)
	if not SoraDFIsRA() then
		_UPVALUE8_ = self.fields.Usm_ef1
		self.fields.Usm_ef1[1] = self.fields.Text_skill
		self.fields.Usm_ef1[2] = self.fields.Text_chooseCount
		self.fields.Usm_ef1[3] = self.fields.Button_advance
		self.fields.Usm_ef1[4] = self.fields.Button_upgrade
		self.fields.Usm_ef1[5] = self.fields.Text_choose
		self.fields.Usm_ef1[6] = self.fields.ComboBox_quality
		self.fields.Usm_ef1[7] = self.fields.Button_all
		self.fields.Usm_ef1[8] = self.fields.Text_des
		for i, v in ipairs(self.fields.Usm_ef1) do
			v:fixPos()
		end
		_UPVALUE5_ = ipairs(self.fields.Usm_ef1)
		ipairs(self.fields.Usm_ef1)[1] = self.fields.Com_item1
		ipairs(self.fields.Usm_ef1)[2] = self.fields.Com_item2
		ipairs(self.fields.Usm_ef1)[3] = self.fields.Button_advance
		ipairs(self.fields.Usm_ef1)[4] = self.fields.Button_upgrade
		ipairs(self.fields.Usm_ef1)[5] = self.fields.Button_all
		for i, v in ipairs(ipairs(self.fields.Usm_ef1)) do
			v:fixChildrenPos()
		end
	end
end
function MagicLampSkillResolvePanel:onShow()
	print("=======MagicLampSkillResolvePanel:onShow")
	self:updateBaseSkillList()
end
function MagicLampSkillResolvePanel:onClickHelp(...)
	SoraDPlaySound()
	local rate = magicLampSkillCtrl:getSkillResolvePro()
	_ENV = nil
	;(nil).num = rate * 100 .. "%"
	SoraDShowHelpMsgTip(i18n("jinn_skill_49", nil))
end
function MagicLampSkillResolvePanel:onSkillItemRenderer(index, obj)
	local _index = index + 1
	local data = self.skillList[_index]
	obj:setSelectViewData(data)
	local skillID = data.id
	if self.selectMap[skillID] then
		obj:setIsSelect(true)
	else
		obj:setIsSelect(false)
	end
	obj:setClickHandle(function(target)
		if self.selectMap[skillID] then
			self.selectMap[skillID] = nil
			obj:setIsSelect(false)
		else
			if magicLampCtrl:getIsUsing(data.id) then
				SoraDShowMsgTip(i18n("jinn_skill_41"))
				return
			end
			if data.lock then
				SoraDShowMsgTip(i18n("jinn_skill_69"))
				return
			end
			self.selectMap[skillID] = true
			obj:setIsSelect(true)
		end
		self:updateTextDes()
	end)
	obj:setLongPressHandle(function(target)
		_ENV = nil
		;(nil).data = data
		uiManager:show("MagicLampSkillDetailsLook", nil)
	end)
end
function MagicLampSkillResolvePanel:onClickBtnUpgrade(...)
	SoraDPlaySound()
	self.hasUpgrade = not self.hasUpgrade
	self:updateSkillList()
end
function MagicLampSkillResolvePanel:onClickBtnAdvance(...)
	SoraDPlaySound()
	self.hasAdvance = not self.hasAdvance
	self:updateSkillList()
end
function MagicLampSkillResolvePanel:onComboBoxChanged(...)
	local index = self.fields.ComboBox_quality:getSelectedIndex()
	self.showQuality = index + 1
	self:updateSkillList()
end
function MagicLampSkillResolvePanel:onClickBtnNoData(...)
	SoraDPlaySound()
	if #self.skillList == 0 then
		SoraDRemoveAllPanelFromManager()
		uiManager:show("MagicLampMaigcPowerMain")
	end
end
function MagicLampSkillResolvePanel:onClickBtnAll(...)
	SoraDPlaySound()
	if self.fields.Button_all:isSelected() then
		for i, v in ipairs(self.skillList) do
			if not v.lock and not magicLampCtrl:getIsUsing(v.id) then
				self.selectMap[v.id] = true
			end
		end
	else
		self.selectMap, _ENV = ipairs(self.skillList)
	end
	self.fields.List_skill:setNumItems(#self.skillList)
	self:updateTextDes()
end
function MagicLampSkillResolvePanel:onClickBtnOk(...)
	SoraDPlaySound()
	if #self.skillList == 0 then
		return
	end
	local chooseList = table.keys(self.selectMap)
	if #chooseList == 0 then
		SoraDShowMsgTip(i18n("jinn_skill_77"))
		return
	end
	if magicLampSkillRead.checkLvAndClassLv(chooseList) then
		SoraDShowMsgBox(i18n("jinn_skill_84"), i18n("common_text_204"), i18n("common_text_185"), function(exitType)
			if MSGBOX_CALLBACK_YES == exitType then
				magicLampSkillCtrl:reqResolve(chooseList)
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif magicLampSkillRead.checkQualityNeedNote(chooseList) then
		SoraDShowMsgBox(i18n("jinn_skill_56"), i18n("common_text_204"), i18n("common_text_185"), function(exitType)
			if MSGBOX_CALLBACK_YES == exitType then
				magicLampSkillCtrl:reqResolve(chooseList)
				SoraDShowLoading(self:displayObject())
			end
		end)
	else
		magicLampSkillCtrl:reqResolve(chooseList)
		SoraDShowLoading(self:displayObject())
	end
end
function MagicLampSkillResolvePanel:updateTextDes(...)
	local chooseList = table.keys(self.selectMap)
	local __, returnMap = magicLampSkillRead.getLvReturnNum(chooseList)
	for i, v in ipairs(self.config) do
		v.addCount = returnMap[v.itemID] or 0
	end
	local config = self.config
	local _ENV, ret = ipairs(self.config)
	for skillID, __ in pairs(self.selectMap) do
		local data = magicLampSkillCtrl:getSkillData(skillID)
		local stageGroup = magicLampSkillRead.getSkillStageGroup(data.skillType)
		local items = magicLampSkillRead.getSkillResolve(stageGroup, data.classLv)
		for i, v in ipairs(config) do
			v.addCount = (v.addCount or 0) + (items[v.itemID] or 0)
		end
	end
	for i, v in ipairs(config) do
		local itemID = v.itemID
		local addCount = v.addCount
		local fields = fguiHelper.get_fields(self.fields["Com_item" .. i])
		_ENV = nil
		;(nil).num = magicLampSkillCtrl:getItemCount(itemID)
		fields.Text_count:setString(i18n("common_text_531", nil))
		if 0 < addCount then
			fields.Text_add:setString("+" .. addCount)
		else
			fields.Text_add:setString("")
		end
	end
	local count = table.nums(self.selectMap)
	_ENV = v.itemID
	v.itemID.num = count
	v.itemID.max = #self.skillList
	self.fields.Text_chooseCount:setString(i18n("jinn_skill_8", v.itemID))
	if 0 < count then
		self.fields.Usm_ef2:setVisible(true)
	else
		self.fields.Usm_ef2:setVisible(false)
	end
end
function MagicLampSkillResolvePanel:updateBaseSkillList(...)
	local skillList = magicLampSkillCtrl:getSkillList()
	magicLampSkillRead.sortResolveSkillList(skillList)
	self.baseSkillList = skillList
	self:updateSkillList()
	local max = magicLampSkillCtrl:getSkillStorageMax()
	magicLampSkillCtrl = nil
	;(nil).num = #self.baseSkillList
	;(nil).max = max
	self.fields.Text_skill:setString(i18n("jinn_skill_8", nil))
end
function MagicLampSkillResolvePanel:updateSkillList(...)
	self.selectMap, _ENV = nil, nil
	self.fields.Button_all:setSelected(false)
	if self.hasUpgrade and self.hasAdvance and self.showQuality >= 4 then
		self.skillList = self.baseSkillList
	else
		local _ENV, ret = self.baseSkillList, self.baseSkillList
		for i, v in ipairs(self.baseSkillList) do
			local quality = magicLampSkillRead.getSkillQuality(v.skillType)
			if (self.hasUpgrade or v.lv == 1) and (self.hasAdvance or v.classLv == 0) and quality <= self.showQuality then
				table.insert(ret, v)
			end
		end
		self.skillList = ret
	end
	self.fields.List_skill:setNumItems(#self.skillList)
	local noData = #self.skillList == 0
	if not noData then
		self.fields.List_skill:scrollToView(0)
	end
	self.fields.Text_noData:setVisible(noData)
	self.fields.Button_noData:setVisible(noData)
	self.fields.Button_ok:setVisible(not noData)
	self:updateTextDes()
end
function MagicLampSkillResolvePanel:onMsgResolveBack(...)
	SoraDCloseLoading(self:displayObject())
	self:updateBaseSkillList()
	self.fields.Usm_ef1:play(false)
end
return MagicLampSkillResolvePanel
