local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local MagicLampRecountPanel = class("MagicLampRecountPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
function MagicLampRecountPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampRecountPanel:ctor", self.viewName)
end
function MagicLampRecountPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampRecountPanel:onInit()
	print("=======MagicLampRecountPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_title_09"))
	self.fields.list_att:setItemRenderer(handler(self, self.onAttsRender))
	self.fields.list_att:setItemProvider(handler(self, self.onAttsProvider))
	_ENV = self.fields.list_att.setItemProvider
	self.fields.list_att.setItemProvider[7] = i18n("magic_lamp_title_13")
	self.fields.list_att.setItemProvider[8] = i18n("magic_lamp_title_14")
	self.titles, self.fields.list_att.setItemProvider[12] = self.fields.list_att.setItemProvider, i18n("magic_lamp_title_15")
end
function MagicLampRecountPanel:onShow()
	print("=======MagicLampRecountPanel:onShow")
	self:updateView()
end
function MagicLampRecountPanel:updateView()
	self.curType = self.param and self.param.jinnType or nil
	self.jinnDataList = magicLampCtrl:getJinnList()
	local magicLampCtrl, tmpData = magicLampCtrl:getJinnList(), magicLampCtrl:getJinnList()
	for _k, _v in pairs(self.jinnDataList) do
		if self.curType == nil or self.curType == tonumber(_k) then
			local blessData = _v.blessList
			for k, v in pairs(blessData) do
				local blessCfg = magicLampRead.getBlessCfg(tonumber(k) * 100 + v.lv)
				for k1, v1 in pairs(blessCfg.buff) do
					for i2, v2 in ipairs(blessCfg.Battle) do
						if not tmpData[v2] then
							tmpData[v2], magicLampCtrl = tmpData[v2], tmpData[v2]
						end
						if not tmpData[v2][v1.buffType] then
							magicLampCtrl = nil
							;(nil).buffType = v1.buffType
							;(nil).type = v1.type
							;(nil).value = 0
							tmpData[v2][v1.buffType], (nil).sort = nil, magicLampRead.getBuffSort(v1.buffType)
						end
						tmpData[v2][v1.buffType].value = tmpData[v2][v1.buffType].value + v1.value
					end
				end
			end
		end
	end
	self.showList, magicLampCtrl = pairs(self.jinnDataList)
	for k, v in pairs(tmpData) do
		if self.titles[k] == nil then
			for k2, v2 in pairs(v) do
				table.insert(self.showList, v2)
			end
			table.sort(self.showList, function(a, b)
				return a.sort < b.sort
			end)
		end
	end
	for k, v in pairs(self.titles) do
		local list = tmpData[k]
		if list ~= nil then
			local magicLampCtrl, tmpList = self.showList, self.showList
			magicLampCtrl = nil
			;(nil).title = v
			;(nil).showType = "Title"
			table.insert(self.showList, nil)
			for k2, v2 in pairs(list) do
				table.insert(tmpList, v2)
			end
			table.sort(tmpList, function(a, b)
				return a.sort < b.sort
			end)
			for i2, v2 in ipairs(tmpList) do
				table.insert(self.showList, v2)
			end
		end
	end
	magicLampCtrl, self.unlockCount = pairs(self.titles)
	pairs(self.titles).name = i18n("magic_lamp_text_032")
	pairs(self.titles).value = 0
	local pairs(self.titles).showType, skillData = "NameAndValue", pairs(self.titles)
	table.insert(self.showList, skillData)
	for k, _v in pairs(self.jinnDataList) do
		local jinnType = tonumber(k)
		if self.curType == nil or self.curType == jinnType then
			local bigBlessCfgs = magicLampRead.getBigBlessList(jinnType)
			local jinnName = magicLampRead.getJinnName(jinnType)
			for i, v in ipairs(bigBlessCfgs) do
				local blessLv = magicLampCtrl:getBlessLv(jinnType, v.BlessID)
				if 0 < blessLv then
					local name = jinnName .. "-" .. i18n(magicLampRead.getBlessCfg(v.BlessID * 100 + blessLv).BlessName)
					magicLampCtrl = magicLampRead.getBlessCfg(v.BlessID * 100 + blessLv).BlessName
					magicLampRead.getBlessCfg(v.BlessID * 100 + blessLv).BlessName.title = name
					magicLampRead.getBlessCfg(v.BlessID * 100 + blessLv).BlessName.showType = "Title"
					table.insert(self.showList, magicLampRead.getBlessCfg(v.BlessID * 100 + blessLv).BlessName)
					self.unlockCount = self.unlockCount + 1
					local skillId = magicLampCtrl:getBlessSkillId(jinnType, v.BlessID)
					if skillId then
						local _skillData = magicLampSkillCtrl:getSkillData(skillId)
						dump(_skillData, "_skillData")
						magicLampCtrl = "_skillData"
						;("_skillData").showType = "Skill"
						;("_skillData").data = _skillData
						table.insert(self.showList, "_skillData")
					end
				end
			end
			local isJinnStarUnlock, extraSkillSlotNum = magicLampCtrl:getIsStarRiverUnlock(jinnType)
			if self.curType == nil and isJinnStarUnlock then
				local unlockingSlot = magicLampCtrl:getUnlockingSlot(jinnType)
				for i = 1, extraSkillSlotNum do
					if i < unlockingSlot then
						magicLampCtrl = "_skillData"
						;("_skillData").num = #bigBlessCfgs + i
						local name = jinnName .. "-" .. i18n("jinn_gaglxy_text16", "_skillData")
						magicLampCtrl = "jinn_gaglxy_text16"
						;("jinn_gaglxy_text16").title = name
						;("jinn_gaglxy_text16").showType = "Title"
						table.insert(self.showList, "jinn_gaglxy_text16")
						self.unlockCount = self.unlockCount + 1
						local skillId = magicLampCtrl:getBlessSkillId(jinnType, magicLampRead.extraSkillSlotStartIndex + i)
						if skillId then
							local _skillData = magicLampSkillCtrl:getSkillData(skillId)
							magicLampCtrl = #bigBlessCfgs + i
							;(#bigBlessCfgs + i).showType = "Skill"
							;(#bigBlessCfgs + i).data = _skillData
							table.insert(self.showList, #bigBlessCfgs + i)
						end
					end
				end
			end
		end
	end
	skillData.value = self.unlockCount
	if #self.showList == 1 and self.unlockCount == 0 then
		self.fields.list_att:setVisible(false)
		self.fields.txt_notip:setVisible(true)
		self.fields.txt_notip:setString(i18n("magic_lamp_text_159"))
	else
		self.fields.list_att:setVisible(true)
		self.fields.txt_notip:setVisible(false)
	end
	self.fields.list_att:setNumItems(#self.showList)
	self.fields.list_att:setAlignCenter(true)
end
function MagicLampRecountPanel:onAttsRender(index, obj)
	local data = self.showList[index + 1]
	if data.showType == nil then
		obj:initData(data, index)
	elseif data.showType == "Title" then
		obj:setSubTitle(data.title)
	elseif data.showType == "NameAndValue" then
		obj:setNameAndValue(data.name, data.value, index)
	elseif data.showType == "Skill" then
		obj:initData(data.data)
		obj:setAutoHeight(504)
	end
end
function MagicLampRecountPanel:onAttsProvider(index)
	local data = self.showList[index + 1]
	if data.showType == "Skill" then
		return "ui://MagicLampSkill/Com_skillDetail"
	else
		return "ui://MagicLamp/Com_ML_RecountAtt"
	end
end
return MagicLampRecountPanel
