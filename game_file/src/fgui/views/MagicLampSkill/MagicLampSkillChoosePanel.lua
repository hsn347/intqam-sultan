local magicLampSkillRead = include("magicLampSkillRead")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillChoosePanel = class("MagicLampSkillChoosePanel", baseFguiPanel)
function MagicLampSkillChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillChoosePanel:ctor", self.viewName)
	self.selectMap, _ENV, self.skillList, _ENV = print, print, print, print
	self.isHidePrePanel = true
end
function MagicLampSkillChoosePanel:onInit()
	print("=======MagicLampSkillChoosePanel:onInit")
	self.fields.Com_title:setString(i18n("jinn_skill_37"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRenderer))
	self.fields.List_skill:setVirtual()
	self.fields.Text_noData:setString(i18n("jinn_skill_55"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickBtnOk))
end
function MagicLampSkillChoosePanel:onShow()
	print("=======MagicLampSkillChoosePanel:onShow")
	self.selectMap, _ENV = print, print
	self.returnData = nil
	self.classLv = self.param.classLv or 0
	self.needCount = self.param.needCount or 1
	self.skillType = self.param.skillType
	self.quality = self.param.quality
	self.allSkills = self.param.allSkills == true
	if not self.param.chooseList then
		local _ENV, chooseList = self.param.chooseList, self.param.chooseList
	end
	for i, skillID in ipairs(chooseList) do
		self.selectMap[skillID] = true
	end
	if self.allSkills then
		self.skillList = self:getAllSkillList(self.param)
	else
		self.skillList = magicLampSkillCtrl:getSkillListFilter(self.param)
		magicLampSkillRead.sortChooseSkillList(self.skillList, self.selectMap)
	end
	self.fields.List_skill:setNumItems(#self.skillList)
	self.fields.Text_noData:setVisible(#self.skillList == 0)
	if #self.skillList == 0 then
		if self.allSkills then
			self.fields.Button_ok:setString(i18n("common_text_204"))
		else
			self.fields.Button_ok:setString(i18n("starlight_btn_01"))
		end
	else
		self.fields.Button_ok:setString(i18n("common_text_204"))
	end
	self:updateTextDes()
end
function MagicLampSkillChoosePanel:getAllSkillList(filter)
	local _ENV, otherMap
	if not filter.otherList then
		_ENV = filter.otherList
	end
	for __, skillID in ipairs(filter.otherList) do
		otherMap[tonumber(skillID) or skillID] = true
	end
	local _ENV, skillList = (for generator), ipairs(filter.otherList)
	if not magicLampSkillCtrl:getSkillList() then
		_ENV = magicLampSkillCtrl:getSkillList()
	end
	for __, data in ipairs((magicLampSkillCtrl:getSkillList())) do
		if not otherMap[data.id] then
			table.insert(skillList, data)
		end
	end
	table.sort(skillList, function(a, b)
		local isUsingA = magicLampCtrl:getIsUsing(a.id)
		local isUsingB = magicLampCtrl:getIsUsing(b.id)
		if isUsingA ~= isUsingB then
			return isUsingA
		end
		local qualityA = magicLampSkillRead.getSkillQuality(a.skillType)
		local qualityB = magicLampSkillRead.getSkillQuality(b.skillType)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		end
		if a.classLv ~= b.classLv then
			return a.classLv > b.classLv
		end
		if a.lv ~= b.lv then
			return a.lv > b.lv
		end
		if a.skillType ~= b.skillType then
			return a.skillType < b.skillType
		end
		return a.id < b.id
	end)
	return skillList
end
function MagicLampSkillChoosePanel:onSkillItemRenderer(index, obj)
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
			self:updateTextDes()
		else
			if self.param.canChooseFunc then
				local canChoose, tip = self.param.canChooseFunc(data, table.keys(self.selectMap))
				if canChoose == false then
					if tip then
						SoraDShowMsgTip(tip)
					end
					return
				end
			end
			if not self.param.ignoreUsingCheck and magicLampCtrl:getIsUsing(data.id) then
				SoraDShowMsgTip(i18n("jinn_skill_41"))
				return
			end
			if not self.param.ignoreLockCheck and data.lock then
				SoraDShowMsgTip(i18n("jinn_skill_69"))
				return
			end
			if table.nums(self.selectMap) >= self.needCount then
				if self.param.singleChoose or self.needCount == 1 then
					self = self.needCount
					self.selectMap, self.needCount[skillID] = self.needCount, true
					self.fields.List_skill:setNumItems(#self.skillList)
					self:updateTextDes()
				else
					SoraDShowMsgTip(i18n("jinn_skill_40"))
				end
			else
				self.selectMap[skillID] = true
				obj:setIsSelect(true)
				self:updateTextDes()
			end
		end
	end)
	obj:setLongPressHandle(function(target)
		_ENV = nil
		;(nil).data = data
		uiManager:show("MagicLampSkillDetailsLook", nil)
	end)
end
function MagicLampSkillChoosePanel:updateTextDes(...)
	if self.allSkills then
		self.returnData = nil
		self.fields.Text_des1:setString("")
		self.fields.Text_des2:setString("")
		return
	end
	_ENV = self.fields.Text_des2.setString
	self.fields.Text_des2.setString.num1 = self.needCount
	local self.fields.Text_des2.setString.num2, _data = table.nums(self.selectMap), self.fields.Text_des2.setString
	if self.skillType then
		_data.type = i18n("jinn_skill_39")
	elseif self.quality then
		_data.type = magicLampSkillRead.getQualityName(self.quality)
	end
	if self.classLv > 0 then
		_data.lv = self.classLv
		self.fields.Text_des1:setString(i18n("jinn_skill_38", _data))
	else
		self.fields.Text_des1:setString(i18n("jinn_skill_64", _data))
	end
	local desStr = i18n("jinn_skill_42")
	local chooseList = table.keys(self.selectMap)
	local returnNum, returnMap = magicLampSkillRead.getLvReturnNum(chooseList)
	if 0 < returnNum then
		local _ENV, itemStr = i18n("jinn_skill_64", _data)
		for itemID, count in pairs(returnMap) do
			if 0 < count then
				local itemName = publicRead.getName(itemID)
				table.insert(itemStr, string.format("%s×%d", itemName, count))
			end
		end
		_ENV = (for generator)
		self.returnData, pairs(returnMap).item = pairs(returnMap)
		desStr = desStr .. "\n" .. i18n("jinn_skill_63", self.returnData)
	else
		self.returnData = nil
	end
	self.fields.Text_des2:setString(desStr)
end
function MagicLampSkillChoosePanel:onClickBtnOk(...)
	SoraDPlaySound()
	if #self.skillList == 0 then
		if self.allSkills then
			local chooseHandle = self.param.chooseHandle
			if chooseHandle then
				_ENV = nil
				chooseHandle(self.param.index, nil)
			end
			self:closePanel()
			return
		end
		SoraDRemoveAllPanelFromManager()
		uiManager:show("MagicLampMaigcPowerMain")
		return
	end
	local dispatch = function(...)
		local chooseHandle = self.param.chooseHandle
		if chooseHandle then
			local chooseList = table.keys(self.selectMap)
			chooseHandle(self.param.index, chooseList)
		end
		self:closePanel()
	end
	if self.returnData then
		SoraDShowMsgBox(i18n("jinn_skill_68", self.returnData), nil, nil, function(exitType)
			if exitType == MSGBOX_CALLBACK_YES then
				dispatch()
			end
		end)
	else
		dispatch()
	end
end
return MagicLampSkillChoosePanel
