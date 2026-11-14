local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastRead = include("divineBeastRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local buffDesRead = include("buffDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local divineBeastMarkRead = include("divineBeastMarkRead")
local MythicalCreaturesDispatchPanel = class("MythicalCreaturesDispatchPanel", baseFguiPanel)
function MythicalCreaturesDispatchPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MythicalCreaturesDispatchPanel:ctor", self.viewName)
end
function MythicalCreaturesDispatchPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MythicalCreaturesDispatchPanel:onInit()
	print("=======MythicalCreaturesDispatchPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_text_34"))
	self.fields.txt_empty:setString(i18n("Divine_beast_text_59"))
	self.curInDispatchDivineID = self.param and self.param.divineID or nil
	self.onDispatchCallback = self.param and self.param.onDispatchCallback or nil
	self.fields.list:setItemProvider(handler(self, self.onItemProvider))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.beastlist:setItemRenderer(handler(self, self.onBeastItemRenderer))
	self.fields.button_sure:addClickEventListener(handler(self, self.onBtnClick))
	self.showDivineIDList, _ENV = self.fields.button_sure.addClickEventListener, self.fields.button_sure.addClickEventListener
end
function MythicalCreaturesDispatchPanel:onClickTab(tag)
	self.curTag = tag
	self:updateView()
end
function MythicalCreaturesDispatchPanel:onShow()
	print("=======MythicalCreaturesDispatchPanel:onShow")
	local divineIDList = divineBeastCtrl:getUnlockBeastIDList()
	self.showDivineIDList, _ENV = divineBeastCtrl, divineBeastCtrl
	_ENV, self.mode = self.param and self.param.mode or gHeroSelectBannerStyle.inner, self.param and self.param.mode or gHeroSelectBannerStyle.inner
	;(self.param and self.param.mode or gHeroSelectBannerStyle.inner)[gHeroSelectBannerStyle.inner] = true
	;(self.param and self.param.mode or gHeroSelectBannerStyle.inner)[gHeroSelectBannerStyle.defend] = true
	;(self.param and self.param.mode or gHeroSelectBannerStyle.inner)[gHeroSelectBannerStyle.setteam] = true
	;(self.param and self.param.mode or gHeroSelectBannerStyle.inner)[gHeroSelectBannerStyle.arena] = true
	local (self.param and self.param.mode or gHeroSelectBannerStyle.inner)[gHeroSelectBannerStyle.walldefteam], igoneModes = true, self.param and self.param.mode or gHeroSelectBannerStyle.inner
	for i, v in ipairs(divineIDList) do
		local beastData = divineBeastCtrl:getBeastData(v)
		if not divineBeastCtrl:getIsCanDisaptch(self.mode, v) or not igoneModes[self.mode] and (beastData.state == DIVINE_BEAST_STATE.ATTACK or beastData.state == DIVINE_BEAST_STATE.ATTACK_DEFEND) then
		else
			table.insert(self.showDivineIDList, v)
		end
	end
	if #self.showDivineIDList == 0 then
		self.controllers.c1:setSelectedIndex(1)
		return
	end
	self.curIndex = 1
	self.fields.beastlist:setNumItems(#self.showDivineIDList)
	self:onBeastItemClick(self.showDivineIDList[1])
end
function MythicalCreaturesDispatchPanel:updateView()
	self.divineID = self.showDivineIDList[self.curIndex]
	if self.divineID == nil then
		self.controllers.c1:setSelectedIndex(1)
		return
	end
	self.beastCfg = divineBeastRead.getDbCfg(self.divineID)
	dump(self.beastCfg, "self.beastCfg")
	self.fields.beastlist:setVisible(#self.showDivineIDList > 1)
	self.fields.beastlist:setNumItems(#self.showDivineIDList)
	self.beastData = divineBeastCtrl:getBeastData(self.divineID)
	self.usmData = divineBeastRead.getUsmData(self.divineID)
	self.stepLv = self.beastData.stepLv or 0
	self.stepLv = self.beastData.stepLv or 0
	self.starLv = self.beastData.starLv or 0
	if not self.beastData.growLv then
		_UPVALUE3_ = self.beastData.growLv
		self.beastData.growLv[1] = 0
		self.beastData.growLv[2] = 0
		self.beastData.growLv[3] = 0
	end
	self.growLv = self.beastData.growLv
	self.controllers.c1:setSelectedIndex(0)
	self.stepCfg = divineBeastRead.getStepCfg(self.divineID, self.stepLv)
	self.starCfg = divineBeastRead.getStarCfg(self.divineID, self.starLv)
	self.attBuffData = divineBeastCtrl:getAttBuffData(self.divineID)
	if self.curInDispatchDivineID == self.divineID then
		self.fields.button_sure:setTitle(i18n("common_text_184"))
	else
		self.fields.button_sure:setTitle(i18n("Divine_beast_text_35"))
	end
	for i = 1, 4 do
		local idx = i
		if not SoraDFIsRA() then
			idx = 4 - i + 1
		end
		self.fields["Com_MC_skillIcon" .. idx]:initData(self.beastCfg, self.beastData, i, true, self.mode)
	end
	local usmFileData = self.usmData.star[self.starLv] or self.usmData.star.default
	self.fields.beastUsm:getChild("bg"):setURL(usmFileData.bg)
	local usm_1 = self.fields.beastUsm:getChild("Usm_1")
	if usm_1.effectPath ~= usmFileData.daiji then
		self.fields.beastUsm:getChild("Usm_1"):clearEffect()
		self.fields.beastUsm:getChild("Usm_1"):setEffectPath(usmFileData.daiji, true)
	end
	self:updateAtt()
end
function MythicalCreaturesDispatchPanel:updateAtt()
	self.attDatas, _ENV = nil, nil
	if self.curTag == 1 then
		_ENV = nil
		;(nil).title = i18n("Divine_beast_text_44")
		;(nil).value = lordInfoCtrl:getDivineBeastFc()
		table.insert(self.attDatas, nil)
		for i = 1, 3 do
			if self.attBuffData[i] then
				local titleStr = buffDesRead.getTitleBase(self.attBuffData[i].buffType, false, true)
				local valueStr = buffDesRead.getTitleValueWithValue(self.attBuffData[i].buffType, SoraDPreciseDecimal(self.attBuffData[i].value, 2), false)
				_ENV = false
				;(false).title = titleStr
				;(false).value = valueStr
				table.insert(self.attDatas, false)
			end
		end
	else
		self.beastMarkData = divineBeastMarkCtrl:getBeastMarkData(self.divineID)
		if not self.beastMarkData then
			local _ENV, beastMarkData = self.beastMarkData, self.beastMarkData
		end
		local _ENV, baseBuffMap = divineBeastMarkCtrl, divineBeastMarkCtrl
		local _ENV, specialList = self.divineID, self.divineID
		local _ENV, elementsList = lordInfoCtrl:getDivineBeastFc(), lordInfoCtrl:getDivineBeastFc()
		local self.qualityLvsCount, _ENV, self.elementLvsCount, _ENV, _ENV, qualityLvsBuffMap = buffDesRead.getTitleValueWithValue(self.attBuffData[i].buffType, SoraDPreciseDecimal(self.attBuffData[i].value, 2), false), buffDesRead.getTitleValueWithValue(self.attBuffData[i].buffType, SoraDPreciseDecimal(self.attBuffData[i].value, 2), false), buffDesRead.getTitleValueWithValue(self.attBuffData[i].buffType, SoraDPreciseDecimal(self.attBuffData[i].value, 2), false), buffDesRead.getTitleValueWithValue(self.attBuffData[i].buffType, SoraDPreciseDecimal(self.attBuffData[i].value, 2), false), buffDesRead.getTitleBase(self.attBuffData[i].buffType, false, true), buffDesRead.getTitleBase(self.attBuffData[i].buffType, false, true)
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
			local elementEffectCfg = divineBeastMarkRead.getElementsEffect(self.divineID, k2, v2)
			if elementEffectCfg ~= nil then
				_ENV = v2
				v2.desc = i18n(elementEffectCfg.introduce)
				v2.showType = "Desc"
				table.insert(elementsList, v2)
			end
		end
		for k2, v2 in pairs(self.qualityLvsCount) do
			local suitBuffCfgList = divineBeastMarkRead.getSuitBuffList(k2, v2, self.divineID)
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
			table.insert(self.attDatas, pairs(baseBuffMap))
			table.sort(buffList, function(a, b)
				return a.id < b.id
			end)
			for k, v in ipairs(buffList) do
				_ENV = ipairs(suitBuffCfgList)
				ipairs(suitBuffCfgList).buffType = v.id
				ipairs(suitBuffCfgList).type = 1
				ipairs(suitBuffCfgList).value = v.val
				ipairs(suitBuffCfgList).sort = 0
				table.insert(self.attDatas, ipairs(suitBuffCfgList))
			end
		end
		dump(specialList, "specialList")
		if 0 < #specialList then
			_ENV = "specialList"
			;("specialList").title = i18n("Divine_beast_mark_text_25")
			;("specialList").showType = "Title"
			table.insert(self.attDatas, "specialList")
			for k, v in ipairs(specialList) do
				table.insert(self.attDatas, v)
			end
		end
		if 0 < #elementsList then
			_ENV = ipairs(specialList)
			ipairs(specialList).title = i18n("Divine_beast_mark_text_56")
			ipairs(specialList).showType = "Title"
			table.insert(self.attDatas, ipairs(specialList))
			for k, v in ipairs(elementsList) do
				table.insert(self.attDatas, v)
			end
		end
		local _ENV, qualityLvsBuffList = (for generator), ipairs(elementsList)
		if 0 < table.nums(qualityLvsBuffMap) then
			_ENV = i18n("Divine_beast_mark_text_56")
			i18n("Divine_beast_mark_text_56").title = i18n("divine_beast_mark_suit_02")
			i18n("Divine_beast_mark_text_56").showType = "Title"
			table.insert(self.attDatas, (i18n("Divine_beast_mark_text_56")))
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
				table.insert(self.attDatas, v.val)
			end
		end
	end
	self.fields.list:setNumItems(0)
	self.fields.list:removeChildrenToPool()
	self.fields.list:setNumItems(#self.attDatas)
	self.fields.txt_empty2:setVisible(#self.attDatas == 0)
	self.fields.txt_empty2:setString(i18n("skin_text_04"))
end
function MythicalCreaturesDispatchPanel:onItemProvider(index)
	dump(self.curTag, "self.curTag")
	if self.curTag == 1 then
		return "ui://MythicalCreatures/Com_MC_att"
	else
		return "ui://MythicalCreatures/Com_MC_RecountAtt"
	end
end
function MythicalCreaturesDispatchPanel:onItemRenderer(index, obj)
	if self.curTag == 1 then
		obj:initData(self.attDatas[index + 1], index)
	else
		local data = self.attDatas[index + 1]
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
end
function MythicalCreaturesDispatchPanel:onBeastItemRenderer(index, obj)
	obj:initData(self.showDivineIDList[index + 1])
	obj:setSelected(self.curIndex == index + 1)
	obj:setClickCallback(handler(self, self.onBeastItemClick))
end
function MythicalCreaturesDispatchPanel:onBeastItemClick(divineID)
	for i, v in ipairs(self.showDivineIDList) do
		if v == divineID then
			self.curIndex = i
			break
		end
	end
	if self.divineID ~= divineID then
		self.divineID = divineID
		if divineBeastMarkCtrl:getIsFuncOpen(self.divineID) then
			self.controllers.c2:setSelectedIndex(1)
			_ENV, self.ccs_tab = self.fields.com_Tab, self.fields.com_Tab
			self.fields.com_Tab.tabNum = 2
			_ENV, _ENV, self.fields.com_Tab.defaultClick = 1, self.controllers.c2, 1
			;(1).title = i18n("Divine_beast_text_02")
			_ENV, self.controllers.c2[1], (1).tag = 1, 1, 1
			;(1).title = i18n("Divine_beast_mark_text_54")
			self.fields.com_Tab.tabsetArray, self.controllers.c2[2], (1).tag = self.controllers.c2, 1, 2
			self.fields.com_Tab.callback = handler(self, self.onClickTab)
			local self.fields.com_Tab.unDefaultClick, param = true, self.fields.com_Tab
			self.ccs_tab:initView(param)
		else
			self.controllers.c2:setSelectedIndex(0)
		end
		self:onClickTab(1)
	end
end
function MythicalCreaturesDispatchPanel:onBtnClick()
	SoraDPlaySound()
	if self.onDispatchCallback then
		self.onDispatchCallback(self.curInDispatchDivineID ~= self.divineID and self.divineID or 0)
	end
	_ENV = self.curInDispatchDivineID ~= self.divineID and self.divineID or 0
	;(self.curInDispatchDivineID ~= self.divineID and self.divineID or 0).msg = "MESSAGE_SERVER_DIVINEBEAST_SELECT"
	;(self.curInDispatchDivineID ~= self.divineID and self.divineID or 0).divineID = self.curInDispatchDivineID ~= self.divineID and self.divineID or 0
	SoraDSendMessage(self.curInDispatchDivineID ~= self.divineID and self.divineID or 0)
	self:close()
end
return MythicalCreaturesDispatchPanel
