local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkRecountPanel = class("DivineBeastMarkRecountPanel", baseFguiPanel)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastMarkRead = include("divineBeastMarkRead")
local divineBeastRead = include("divineBeastRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local buffDesRead = include("buffDesRead")
function DivineBeastMarkRecountPanel:ctor(...)
	DivineBeastMarkRecountPanel.super.ctor(self, ...)
	print("DivineBeastMarkRecountPanel:ctor", self.viewName)
end
function DivineBeastMarkRecountPanel:onInit()
	print("=======DivineBeastMarkRecountPanel:onInit")
	self.fields.list_att:setItemRenderer(handler(self, self.onAttsRender))
	self.beastId = self.param.beastId
	self.mailData = self.param.mailData
	self.uiType = self.param.uiType
	self.mark = self.param.mark
	if self.beastId ~= nil then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Panel_bg:setTitle(i18n("hero_title_01"))
		self.beastMarkData = divineBeastMarkCtrl:getBeastMarkData(self.beastId)
		self:updateMarkAtt()
	elseif self.mailData ~= nil then
		local beastCfg = divineBeastRead.getDbCfg(self.mailData.beastData.beastId)
		local beastName = beastCfg and i18n(beastCfg.divineName) or ""
		self.fields.Panel_bg:setTitle(beastName)
		if divineBeastMarkCtrl:getIsFuncOpen(self.mailData.beastData.beastId) then
			self.controllers.c1:setSelectedIndex(1)
			_ENV, self.ccs_tab = self.fields.com_Tab, self.fields.com_Tab
			self.fields.com_Tab.tabNum = 2
			_ENV, _ENV, self.fields.com_Tab.defaultClick = 1, self.controllers.c1, 1
			;(1).title = i18n("Divine_beast_text_02")
			_ENV, self.controllers.c1[1], (1).tag = 1, 1, 1
			;(1).title = i18n("Divine_beast_mark_text_54")
			self.fields.com_Tab.tabsetArray, self.controllers.c1[2], (1).tag = self.controllers.c1, 1, 2
			local self.fields.com_Tab.callback, param = handler(self, self.onClickTab), self.fields.com_Tab
			self.ccs_tab:initView(param)
		else
			self.controllers.c1:setSelectedIndex(0)
			self:onClickTab(1)
		end
		dump(self.mailData, "self.mailData")
	elseif self.mark ~= nil then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_text_57"))
		self.fields.btn_max:setTitle(i18n("Divine_beast_mark_text_87"))
		self.fields.btn_max:addClickEventListener(handler(self, self.onMaxClick))
		self.fields.btn_modify:setTitle(i18n("Divine_beast_mark_text_80"))
		self.fields.btn_modify:addClickEventListener(handler(self, self.onModifyClick))
		self:updateMarkRandomAtt()
	end
end
function DivineBeastMarkRecountPanel:onShow()
	print("=======DivineBeastMarkRecountPanel:onShow")
end
function DivineBeastMarkRecountPanel:onClickTab(tag)
	dump(tag, "DivineBeastMarkRecountPanel:onClickTab")
	self.beastId = self.mailData.beastData.beastId
	self.stepLv = self.mailData.beastData.stepLv or 0
	self.starLv = self.mailData.beastData.starLv or 0
	if not self.mailData.beastData.growLv then
		_ENV = self.mailData.beastData.growLv
	end
	self.growLv = self.mailData.beastData.growLv
	if not self.mailData.markList then
		_ENV = self.mailData.markList
	end
	self.markList = self.mailData.markList
	if tag == 2 then
		if self.beastMarkData == nil then
			self.beastMarkData, _ENV = self.beastMarkData, self.beastMarkData
			for i, v2 in ipairs(self.markList) do
				local mark = divineBeastMarkRead.sSplitKey(v2)
				self.beastMarkData[i] = mark
			end
		end
		self:updateMarkAtt()
	else
		self:updateDivineBeastAtt()
	end
end
function DivineBeastMarkRecountPanel:updateMarkAtt()
	self.showList, _ENV = nil, nil
	if not self.beastMarkData then
		local _ENV, beastMarkData = self.beastMarkData, self.beastMarkData
	end
	local _ENV, baseBuffMap
	local _ENV, specialList
	local _ENV, elementsList
	local self.qualityLvsCount, _ENV, self.elementLvsCount, _ENV, _ENV, qualityLvsBuffMap
	for _, mark in pairs(beastMarkData) do
		if mark.lvCfg ~= nil then
			local lvCfg = mark.lvCfg
			for _, v3 in pairs(lvCfg.buff) do
				local specialBuffCfg = divineBeastMarkRead:getSpecialBuffCfg(v3.buffType)
				if specialBuffCfg then
					if specialBuffCfg.filter_buff == 0 then
						_ENV = nil
						;(nil).desc = i18n(lvCfg.introduce)
						;(nil).showType = "Desc"
						table.insert(specialList, nil)
					end
				else
					baseBuffMap[v3.buffType] = (baseBuffMap[v3.buffType] or 0) + v3.value
				end
			end
			if mark.randomBuff1 and mark.randomBuff1 ~= 0 then
				baseBuffMap[mark.randomBuff1] = (baseBuffMap[mark.randomBuff1] or 0) + mark.randomBuffCfg1.value[mark.markCfg.randombuff_type]
			end
			if mark.randomBuff2 and mark.randomBuff2 ~= 0 then
				baseBuffMap[mark.randomBuff2] = (baseBuffMap[mark.randomBuff2] or 0) + mark.randomBuffCfg2.value[mark.markCfg.randombuff_type]
			end
			local markCfg = mark.markCfg
			for i, v3 in ipairs(markCfg.elements) do
				if markCfg.elements_lv[i] <= mark.lv then
					local element = v3 == 5 and mark.randomElem or v3
					self.elementLvsCount[element] = (self.elementLvsCount[element] or 0) + 1
				end
			end
			self.qualityLvsCount[markCfg.quality] = (self.qualityLvsCount[markCfg.quality] or 0) + mark.lv
		end
	end
	for k2, v2 in pairs(self.elementLvsCount) do
		local elementEffectCfg = divineBeastMarkRead.getElementsEffect(self.beastId, k2, v2)
		if elementEffectCfg ~= nil then
			_ENV = v2
			v2.desc = i18n(elementEffectCfg.introduce)
			v2.showType = "Desc"
			table.insert(elementsList, v2)
		end
	end
	for k2, v2 in pairs(self.qualityLvsCount) do
		local suitBuffCfgList = divineBeastMarkRead.getSuitBuffList(k2, v2, self.beastId)
		for _, v3 in ipairs(suitBuffCfgList) do
			for _, v4 in ipairs(v3.buff) do
				qualityLvsBuffMap[v4.buffType] = (qualityLvsBuffMap[v4.buffType] or 0) + v4.value
			end
		end
	end
	dump(baseBuffMap, "baseBuffMap")
	local _ENV, buffList = dump, dump
	for k, v in pairs(baseBuffMap) do
		_ENV = ipairs(suitBuffCfgList)
		ipairs(suitBuffCfgList).id = k
		ipairs(suitBuffCfgList).val = v
		ipairs(suitBuffCfgList).mode = 1
		table.insert(buffList, ipairs(suitBuffCfgList))
	end
	if 0 < #buffList then
		_ENV = pairs(baseBuffMap)
		pairs(baseBuffMap).title = i18n("Divine_beast_mark_text_24")
		pairs(baseBuffMap).showType = "Title"
		table.insert(self.showList, pairs(baseBuffMap))
		table.sort(buffList, function(a, b)
			return a.id < b.id
		end)
		for k, v in ipairs(buffList) do
			_ENV = ipairs(suitBuffCfgList)
			ipairs(suitBuffCfgList).buffType = v.id
			ipairs(suitBuffCfgList).type = 1
			ipairs(suitBuffCfgList).value = v.val
			ipairs(suitBuffCfgList).sort = 0
			table.insert(self.showList, ipairs(suitBuffCfgList))
		end
	end
	dump(specialList, "specialList")
	if 0 < #specialList then
		_ENV = "specialList"
		;("specialList").title = i18n("Divine_beast_mark_text_25")
		;("specialList").showType = "Title"
		table.insert(self.showList, "specialList")
		for k, v in ipairs(specialList) do
			table.insert(self.showList, v)
		end
	end
	if 0 < #elementsList then
		_ENV = ipairs(specialList)
		ipairs(specialList).title = i18n("Divine_beast_mark_text_56")
		ipairs(specialList).showType = "Title"
		table.insert(self.showList, ipairs(specialList))
		for k, v in ipairs(elementsList) do
			table.insert(self.showList, v)
		end
	end
	local _ENV, qualityLvsBuffList = (for generator), ipairs(elementsList)
	if 0 < table.nums(qualityLvsBuffMap) then
		_ENV = i18n("Divine_beast_mark_text_56")
		i18n("Divine_beast_mark_text_56").title = i18n("divine_beast_mark_suit_02")
		i18n("Divine_beast_mark_text_56").showType = "Title"
		table.insert(self.showList, (i18n("Divine_beast_mark_text_56")))
		for k, v in pairs(qualityLvsBuffMap) do
			_ENV = v.val
			v.val.id = k
			v.val.val = v
			v.val.mode = 1
			table.insert(qualityLvsBuffList, v.val)
		end
		table.sort(qualityLvsBuffList, function(a, b)
			return a.id < b.id
		end)
		for k, v in ipairs(qualityLvsBuffList) do
			_ENV = v.val
			v.val.buffType = v.id
			v.val.type = 1
			v.val.value = v.val
			v.val.sort = 0
			table.insert(self.showList, v.val)
		end
	end
	if #self.showList <= 1 then
		self.fields.list_att:setVisible(false)
		self.fields.txt_notip:setVisible(true)
		self.fields.txt_notip:setString(i18n("skin_text_04"))
	else
		self.fields.list_att:setVisible(true)
		self.fields.txt_notip:setVisible(false)
	end
	self.fields.list_att:setNumItems(#self.showList)
end
function DivineBeastMarkRecountPanel:updateDivineBeastAtt()
	self.showList, divineBeastCtrl = nil, nil
	local divineBeastCtrl, baseBuffMap
	local divineBeastCtrl, skillMap
	local attBuffData = divineBeastCtrl:getGrowAttData(self.beastId, self.stepLv, self.growLv)
	for i2, v2 in ipairs(attBuffData) do
		baseBuffMap[v2.buffType] = baseBuffMap[v2.buffType] or 0
		baseBuffMap[v2.buffType] = baseBuffMap[v2.buffType] + v2.value * 10
	end
	local cfg = divineBeastRead.getDbCfg(self.beastId)
	local starCfg = divineBeastRead.getStarCfg(self.beastId, self.starLv or 0)
	for i2, v2 in ipairs(cfg.divineSkill) do
		if cfg.unlockStar[i2] <= self.starLv then
			local skillLv = starCfg.skillLevel[i2]
			local skillCfg = divineBeastRead.getSkillCfg(v2)[skillLv]
			divineBeastCtrl = nil
			;(nil).desc = i18n(skillCfg.skillDes)
			;(nil).showType = "Desc"
			table.insert(skillMap, nil)
		end
	end
	local divineBeastCtrl, buffList = (for generator), ipairs(cfg.divineSkill)
	for k, v in pairs(baseBuffMap) do
		if not divineBeastMarkRead:getSpecialBuffCfg(k) then
			divineBeastCtrl = k
			k.id = k
			k.val = v
			k.mode = 1
			table.insert(buffList, k)
		end
	end
	if 0 < #buffList then
		divineBeastCtrl = pairs(baseBuffMap)
		pairs(baseBuffMap).title = i18n("Divine_beast_mark_text_24")
		pairs(baseBuffMap).showType = "Title"
		table.insert(self.showList, pairs(baseBuffMap))
		table.sort(buffList, function(a, b)
			return a.id < b.id
		end)
		for k, v in ipairs(buffList) do
			divineBeastCtrl = k
			k.buffType = v.id
			k.type = 1
			k.value = v.val
			k.sort = 0
			table.insert(self.showList, k)
		end
		buffList, divineBeastCtrl = ipairs(buffList)
		for k, v in pairs(baseBuffMap) do
			local specialBuffCfg = divineBeastMarkRead:getSpecialBuffCfg(k)
			if specialBuffCfg and specialBuffCfg.filter_buff == 0 then
				divineBeastCtrl = v.val
				v.val.id = k
				v.val.val = v
				v.val.mode = 1
				table.insert(buffList, v.val)
			end
		end
	end
	if 0 < #skillMap then
		divineBeastCtrl = pairs(baseBuffMap)
		pairs(baseBuffMap).title = i18n("Divine_beast_mark_text_25")
		pairs(baseBuffMap).showType = "Title"
		table.insert(self.showList, pairs(baseBuffMap))
		for k, v in ipairs(skillMap) do
			table.insert(self.showList, v)
		end
	end
	if #self.showList <= 1 then
		self.fields.list_att:setVisible(false)
		self.fields.txt_notip:setVisible(true)
		self.fields.txt_notip:setString(i18n("skin_text_04"))
	else
		self.fields.list_att:setVisible(true)
		self.fields.txt_notip:setVisible(false)
	end
	self.fields.list_att:setNumItems(#self.showList)
end
function DivineBeastMarkRecountPanel:updateMarkRandomAtt()
	self.showList, _ENV = nil, nil
	_ENV = nil
	;(nil).name = i18n(self.mark.markCfg.name)
	self.fields.txt_title:setString(i18n("Divine_beast_mark_text_58", nil))
	buffDesRead = i18n("Divine_beast_mark_text_58", nil)
	i18n("Divine_beast_mark_text_58", nil)[1] = "count"
	i18n("Divine_beast_mark_text_58", nil)[2] = "id"
	local poolList = serviceFunctions.tableFormat(self.mark.markCfg.random_pool1, i18n("Divine_beast_mark_text_58", nil))
	local _ENV, pool = self.mark.markCfg.random_pool1, self.mark.markCfg.random_pool1
	local _ENV, poolMapBuff = i18n("Divine_beast_mark_text_58", nil)
	for i, v in ipairs(poolList) do
		local poolCfg = divineBeastMarkRead.getRandomPool(v.id)
		for i, v2 in ipairs(poolCfg.pool) do
			if not poolMapBuff[v2.buffType] then
				table.insert(pool, v2)
				poolMapBuff[v2.buffType] = true
			end
		end
	end
	local lv = self.mark.lv or 1
	local showLv = math.max(lv, 20)
	local _ENV, mapBuff = lv, lv
	for i, v in ipairs(pool) do
		if not mapBuff[v.buffType] then
			local randomBuffCfg = self.isMax and divineBeastMarkRead.getRandomEffect(v.buffType, self.mark.markCfg.quality) or divineBeastMarkRead.getRandomEffect(v.buffType, self.mark.markCfg.quality, showLv)
			local value = buffDesRead.getTitleValueWithValue(v.buffType, SoraDPreciseDecimal(randomBuffCfg.value[self.mark.markCfg.randombuff_type] / 10, 2), false)
			_ENV = false
			;(false).name = buffDesRead.getTitleBase(v.buffType, true, true)
			;(false).value = value
			;(false).showType = "NameAndValue"
			table.insert(self.showList, false)
			mapBuff[v.buffType] = true
		end
	end
	self.fields.list_att:setNumItems(#self.showList)
	dump(self.mark.randomBuff1, " self.mark.randomBuff1")
	local isModifyVisible = not self.param.isOnlyMaxLv and (self.mark.randomBuff1 ~= nil and self.mark.randomBuff1 ~= 0 or self.mark.randomBuff2 ~= nil and self.mark.randomBuff2 ~= 0)
	self.fields.btn_modify:setVisible(isModifyVisible)
	local viewSize = self:getSize()
	if not isModifyVisible then
		self.fields.btn_max:setPositionX(display.width / 2)
	else
		self.fields.btn_max:setPositionX(display.width / 2 + (SoraDFIsRA() and 143 or -143))
		self.fields.btn_modify:setPositionX(display.width / 2 + (SoraDFIsRA() and -143 or 143))
	end
end
function DivineBeastMarkRecountPanel:onAttsRender(index, obj)
	local data = self.showList[index + 1]
	if data.showType == nil then
		obj:initData(data, index)
	elseif data.showType == "Desc" then
		obj:setDesc(data.desc, index)
	elseif data.showType == "Title" then
		obj:setSubTitle(data.title)
	elseif data.showType == "NameAndValue" then
		obj:setNameAndValue(data.name, data.value, index)
	end
end
function DivineBeastMarkRecountPanel:onMaxClick()
	SoraDPlaySound()
	self.isMax = not self.isMax
	self.fields.btn_max:setTitle(self.isMax and i18n("Divine_beast_mark_text_105") or i18n("Divine_beast_mark_text_87"))
	self:updateMarkRandomAtt()
end
function DivineBeastMarkRecountPanel:onModifyClick(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).mark = self.mark
	uiManager:show("DivineBeastMarkModifyChoose", nil)
end
return DivineBeastMarkRecountPanel
