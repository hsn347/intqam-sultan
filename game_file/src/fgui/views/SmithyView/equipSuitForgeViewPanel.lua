local equipmentltCtrl = include("equipmentltCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local itemDesRead = include("itemDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipSuitForgeViewPanel = class("equipSuitForgeViewPanel", baseFguiPanel)
function equipSuitForgeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipSuitForgeViewPanel:ctor", self.viewName)
end
function equipSuitForgeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipSuitForgeViewPanel:onInit()
	print("=======equipSuitForgeViewPanel:onInit")
	self.tableAttrData, _ENV, self.tableNeedData, _ENV = print, print, print, print
	self.forgeQuality = 1
	self.isAuto = false
	self.isCantCloseByReturn = false
	self.fields.Com_title:initData(i18n("suit_title_01"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("common_text_1413"))
	self.fields.Text_need:setString(i18n("Weapon_Rune_tips_053"))
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Button_help:addClickListener(handler(self, self.OnBtnFAQClick))
	self.fields.Button_forge:setString(i18n("common_text_1339"))
	self.fields.Button_forge:addClickListener(handler(self, self.btnClickCallBack))
	local nebulaMileStoneRead = include("nebulaMileStoneRead")
	local unlockMileStoneTask = nebulaMileStoneRead.getConfigByUnlockType(gNebulaMileStoneUnlockType.EQUIPMENT_FORGING)
	if unlockMileStoneTask then
		local milestoneName = nebulaMileStoneRead.getName(unlockMileStoneTask.milestoneID)
		_ENV = handler(self, self.btnClickCallBack)
		handler(self, self.btnClickCallBack).name = milestoneName
		self.fields.Text_forgeLock:setString(i18n("nebula_milestone_text_01", handler(self, self.btnClickCallBack)))
	end
	self.fields.Text_forgeLock:setVisible(false)
	self.fields.Button_speedUpByItem:setString(i18n("common_text_018"))
	self.fields.Button_speedUpByItem:addClickListener(handler(self, self.btnSpeedUpByItemClickCallBack))
	self.fields.Button_speedUp:setString(i18n("common_text_2219"))
	self.fields.Button_speedUp:addClickListener(handler(self, self.btnSpeedUpClickCallBack))
	self.fields.List_need:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function equipSuitForgeViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableNeedData[index + 1], index + 1)
end
function equipSuitForgeViewPanel:onAttrRenderer(index, obj)
	obj:initDataEX(self.tableAttrData[index + 1])
end
function equipSuitForgeViewPanel:onShow()
	print("=======equipSuitForgeViewPanel:onShow")
	self.tableEquipData = self.param.equipData
	self.forgeQuality = self.param.index or 1
	self:initData()
end
function equipSuitForgeViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.fields.Com_equip:initDataEX(self.tableEquipData)
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.forge_equipment)
	if self.queue and self.queue.data.eid == self.tableEquipData.equipmentID and self.queue.data.qly <= gQualityDef.ORANGE then
		self.controllers.c1:setSelectedIndex(1)
		self:showQueue()
		self.fields.List_attr:setVisible(true)
		self.fields.abg:setVisible(true)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_time:setString(SoraDConvertSecondToString(equipmentCtrl:getForgingTime(self.tableEquipData.equipmentID, self.tableEquipData.suitequipID, self.tableEquipData.quality)))
		self:updateSteel()
		self.tableNeedData, _ENV = self.updateSteel, self.updateSteel
		self:initSuitMaterial()
	end
	self:updateForgeState()
end
function equipSuitForgeViewPanel:selectQualityBack(target, data)
	print("selectQualityBack======", data.index)
	self.forgeQuality = data.index
	local curEquipData = equipmentltCtrl.getSuitPartList(self.tableEquipData.eType, self.tableEquipData.equipmentID)
	self.maxQuality = 0
	for k, v in ipairs(curEquipData) do
		self.maxQuality = math.max(self.maxQuality, v.quality)
	end
	self.fields.Com_quality:initData(self.tableEquipData, data.index, self.maxQuality)
	self.tableEquipData = curEquipData[self.forgeQuality]
	self:initData()
end
function equipSuitForgeViewPanel:selectBack(target, data)
	local mid = data.mid
	local tag = data.tag
	local baseEquip = data.baseEquip
	if baseEquip then
		self.baseEquip = baseEquip
	end
	for k, v in ipairs(self.tableNeedData) do
		if v.mode == 1 then
			if baseEquip then
				v.baseEquip = baseEquip
			else
				v.baseEquip = nil
			end
		elseif v.tag == tag then
			v.mid = mid
			break
		end
	end
	dump(self.tableNeedData, "self.tableNeedData====", 20)
	self.fields.List_need:setNumItems(#self.tableNeedData)
	self:updateForgeState()
end
function equipSuitForgeViewPanel:showQueue()
	if self.queue.data.mainM then
		self.baseEquip = self.queue.data.mainM
	end
	if next(backpackCtrl:getSpeedUpItemList(self.queue.qtype)) == nil then
		self.fields.Button_speedUpByItem:setVisible(false)
		self.fields.Button_speedUp:setPositionX(self:getWidth() / 2)
	else
		self.fields.Button_speedUpByItem:setVisible(true)
		self.fields.Button_speedUpByItem:setPositionX(SoraDFPosX(self:getWidth() / 2 - 146, self:getWidth()))
		self.fields.Button_speedUp:setPositionX(SoraDFPosX(self:getWidth() / 2 + 146, self:getWidth()))
	end
	self.fields.bar:setMax(self.queue.totaltime)
	self.fields.Text_time:beginTime(self.queue.timerNode.timer:getRemainTime())
end
function equipSuitForgeViewPanel:initSuitMaterial()
	self.fields.Button_forge:setString(i18n("common_text_1339"))
	local curQuality = self.tableEquipData.quality
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	if curQuality - 1 >= 0 then
		local ownNum = 0
		for i, v in ipairs(tabelBaseList) do
			if tonumber(v:getEID()) == self.tableEquipData.equipmentID and v:getEquipmentQuality() == curQuality - 1 then
				ownNum = 1
				break
			end
		end
		if ownNum <= 0 and 0 < curQuality then
			self.fields.Button_forge:setString(i18n("suit_btn_text_02"))
			self.fields.Button_forge:setBright(false)
			self.fields.Button_forge:setTouchEnabled(true)
		else
			self.fields.Button_forge:setString(i18n("common_text_1339"))
			self.fields.Button_forge:setBright(true)
			self.fields.Button_forge:setTouchEnabled(true)
		end
		_ENV = true
		;(true).mode = 1
		;(true).mid = self.tableEquipData.equipmentID
		;(true).quality = curQuality - 1
		;(true).ownCount = ownNum
		;(true).needCount = 1
		table.insert(self.tableNeedData, true)
	end
	local menu = equipmentltCtrl.getSuitMaterialOfForging(self.tableEquipData.equipmentID, self.tableEquipData.quality)
	local _ENV, tempTable = self.tableEquipData.equipmentID, self.tableEquipData.equipmentID
	local index = 1
	for i, v in ipairs(menu) do
		if i % 2 ~= 0 then
			local count = backpackCtrl:getItemCount(v)
			if not tempTable[index] then
				tempTable[index], _ENV = tempTable[index], tempTable[index]
				tempTable[index].mid = v
				tempTable[index].ownCount = count
				tempTable[index].needCount = menu[i + 1]
				tempTable[index].quality = curQuality
			end
			index = index + 1
		end
	end
	for i = 1, 4 do
		if tempTable and tempTable[i] then
			_ENV = tempTable[index]
			tempTable[index].mode = 0
			tempTable[index].mid = tempTable[i].mid
			tempTable[index].ownCount = tempTable[i].ownCount
			tempTable[index].needCount = tempTable[i].needCount
			tempTable[index].isHave = tempTable[i].ownCount >= tempTable[i].needCount
			tempTable[index].tag = i
			table.insert(self.tableNeedData, tempTable[index])
			if tempTable[i].ownCount < tempTable[i].needCount then
				self.fields.Button_forge:setString(i18n("suit_btn_text_02"))
				self.fields.Button_forge:setBright(false)
				self.fields.Button_forge:setTouchEnabled(true)
			end
		end
	end
	for i, v in ipairs(tabelBaseList) do
		if tonumber(v:getEID()) == self.tableEquipData.equipmentID and curQuality <= v:getEquipmentQuality() then
			self.fields.Button_forge:setString(i18n("suit_btn_text_01"))
			self.fields.Button_forge:setBright(false)
			self.fields.Button_forge:setTouchEnabled(false)
		end
	end
	self.fields.List_need:setNumItems(#self.tableNeedData)
end
function equipSuitForgeViewPanel:updateForgeState()
	local canForge = false
	if equipmentltCtrl.needMainEquipment(self.tableEquipData.equipmentID) and self.baseEquip == nil then
		canForge = false
	else
		canForge = true
	end
	local curEquipData = equipmentltCtrl.getSuitPartList(self.tableEquipData.eType, self.tableEquipData.equipmentID)
	self.maxQuality = 0
	for k, v in ipairs(curEquipData) do
		self.maxQuality = math.max(self.maxQuality, v.quality)
	end
	self.fields.Com_quality:initData(self.tableEquipData, self.forgeQuality, self.maxQuality)
	self:updateQualityAttr(self.forgeQuality)
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local maxLv = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.EQUIPMENT_FORGING, 95)
	if maxLv and maxLv < self.tableEquipData.level then
		self.fields.Text_forgeLock:setVisible(true)
		canForge = false
	else
		self.fields.Text_forgeLock:setVisible(false)
	end
	self.fields.Button_forge:setVisible(not self.queue and canForge)
end
function equipSuitForgeViewPanel:updateQualityAttr(quality)
	local equipmentltCtrl, tableHaveAttr
	local propertyType, propertyValue, propertyType2, propertyValue2 = equipmentltCtrl.getSuitEquipBuffValueByEidAndIndex(self.tableEquipData.eType, self.tableEquipData.equipmentID, quality - 1, 0)
	local name1, val1 = equipDesRead.getAttrName(propertyType, propertyValue, true)
	local name2, val2 = equipDesRead.getAttrName(propertyType2, propertyValue2, true)
	equipmentltCtrl = propertyValue2
	propertyValue2.name = name1
	propertyValue2.val = val1
	equipmentltCtrl, tableHaveAttr[1], propertyValue2.color = propertyValue2, propertyValue2, equipDesRead.getNormalColor()
	propertyValue2.name = name2
	propertyValue2.val = val2
	tableHaveAttr[2], propertyValue2.color = propertyValue2, equipDesRead.getNormalColor()
	if self.baseEquip then
		local equipmentltCtrl, tabelEquipAttr = self.baseEquip, self.baseEquip
		if self.baseEquip ~= nil then
			if self.baseEquip.class then
				tabelEquipAttr = self.baseEquip:getEquipmentExtraProperty()
			elseif self.baseEquip.extra then
				tabelEquipAttr = self.baseEquip.extra
			end
		end
		if tabelEquipAttr then
			for i, v in ipairs(tabelEquipAttr) do
				local name, val = equipDesRead.getAttrName(v[1], v[2], true)
				equipmentltCtrl = nil
				;(nil).name = name
				;(nil).val = val
				;(nil).color = equipDesRead.getNormalColor()
				table.insert(tableHaveAttr, nil)
			end
		end
	end
	local labelCount = quality + 1
	self.tableAttrData, equipmentltCtrl = ipairs(tabelEquipAttr)
	for i = 1, labelCount do
		if tableHaveAttr[i] then
			self.tableAttrData[i] = tableHaveAttr[i]
		else
			equipmentltCtrl = equipDesRead.getAttrName(v[1], v[2], true)
			equipDesRead.getAttrName(v[1], v[2], true).name = i18n("common_text_4741")
			equipDesRead.getAttrName(v[1], v[2], true).val = "???"
			equipDesRead.getAttrName(v[1], v[2], true).color = cc.c3b(215, 195, 155)
			table.insert(self.tableAttrData, equipDesRead.getAttrName(v[1], v[2], true))
		end
	end
	self.fields.List_attr:setNumItems(#self.tableAttrData)
	self.fields.List_attr:setScrollEnable(#self.tableAttrData > 6)
end
function equipSuitForgeViewPanel:updateSteel()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfSuitForging(self.tableEquipData.equipmentID, self.tableEquipData.quality)
	self.fields.Com_steel:initData(gIDDef.STEEL, haveSteel, needSteel, handler(self, self.showBuySteel))
end
function equipSuitForgeViewPanel:showBuySteel(showMsg)
	local resList = backpackltCtrl:getItemArray(gItemType.STEEL)
	local wishCell = cityCtrl:getBuildCell(BUILDID.WISHING_WELL, 0)
	local haveItem = false
	for i, v in ipairs(resList) do
		if 0 < backpackCtrl:getItemCount(v) then
			haveItem = true
			break
		end
	end
	if haveItem then
		local panel = SoraDCreatePanel("steelBuyView")
		panel:show()
	elseif wishCell and tonumber(wishCell.info.state) ~= BUILD_STATE.BUILDING then
		if not SoraDSearchPanelFromManagerByName("TreasureHuntView") then
			if showMsg then
				SoraDShowMsgBox(i18n("common_text_1363"), i18n("common_text_060"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						local panel = uiManager:show("TreasureHuntView")
						panel:setIsJumpFromEquip(true)
					end
				end)
			else
				local panel = uiManager:show("TreasureHuntView")
				panel:setIsJumpFromEquip(true)
			end
		end
	elseif not wishCell or tonumber(wellCell.info.state) == BUILD_STATE.BUILDING then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		function backpackltCtrl(type)
			if type == MSGBOX_CALLBACK_YES then
				local panel = uiManager:show("TreasureHuntView")
				panel:setIsJumpFromEquip(true)
			end
		end
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, function(type)
			if type == MSGBOX_CALLBACK_YES then
				local panel = uiManager:show("TreasureHuntView")
				panel:setIsJumpFromEquip(true)
			end
		end)
		SoraDRemoveAllPanelFromManager()
	else
		SoraDShowMsgBox(i18n("common_text_1363"), i18n("common_text_204"))
	end
end
function equipSuitForgeViewPanel:initAutoData(equip)
	self.isAuto = true
	self.baseEquip = equip.singleData
	self.tableEquipData = equip.equipment
	self:initData()
end
function equipSuitForgeViewPanel:timeUpdate(time)
	self.fields.bar:setValue(time)
	self.fields.Button_speedUp:setCostTitle(string.formatnumberthousands(serviceFunctions.timeConvertToGold(time)))
end
function equipSuitForgeViewPanel:btnBagClickCallBack()
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	uiManager:show("storageBoxView")
end
function equipSuitForgeViewPanel:OnBtnFAQClick()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.EQUIPMENT_SUIT)
	else
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.SUIT_FORGE)
	end
end
function equipSuitForgeViewPanel:btnSpeedUpByItemClickCallBack()
	SoraDPlaySound()
	if self.queue then
		local itemList = backpackCtrl:getSpeedUpItemList(self.queue.qtype)
		if next(itemList) ~= nil then
			SoraDShowSpeedUpByItemBox(self.queue.qtype)
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	end
end
function equipSuitForgeViewPanel:btnSpeedUpClickCallBack()
	SoraDPlaySound()
	if self.queue then
		_ENV = "common_text_765"
		;("common_text_765").speedUpName = i18n("common_text_2219")
		SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"), "common_text_765")
	end
end
function equipSuitForgeViewPanel:btnClickCallBack()
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	if self.baseEquip and self.baseEquip.isWearing and self.baseEquip:isWearing() then
		equipmentCtrl:takeOffEquipment(self.baseEquip:getEPID(), self.baseEquip:getEquipmentPart())
	else
		self:forgeEquip()
	end
end
function equipSuitForgeViewPanel:forgeEquip()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfSuitForging(self.tableEquipData.equipmentID, self.tableEquipData.quality)
	local smithyCell = cityCtrl:getBuildCell(BUILDID.BLACK_SMITH, 0)
	if SoraDGetLordLv() < self.tableEquipData.level then
		cityCtrl = nil
		;(nil).lv = self.tableEquipData.level
		SoraDShowMsgTip(i18n("common_text_1393", nil), equipDesRead.getIcon(self.tableEquipData.equipmentID, true), button)
	elseif smithyCell == nil or tonumber(smithyCell.info.state) ~= BUILD_STATE.NORMAL then
		SoraDShowMsgBox(i18n("common_text_1414"), i18n("common_text_204"))
	elseif self.queue then
		SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"))
	elseif haveSteel < needSteel then
		self:showBuySteel(true)
	elseif equipmentMgr.isFull() then
		SoraDShowMsgTip(i18n("common_text_1664"), equipDesRead.getIcon(self.tableEquipData.equipmentID, true))
	else
		local tabelBaseList = equipmentMgr:getEquipmentArray()
		local doForge = function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				local _ENV, meterialArray = MSGBOX_CALLBACK_YES, MSGBOX_CALLBACK_YES
				local mainMeterialID = self.baseEquip ~= nil and self.baseEquip.getEPID and self.baseEquip:getEPID() or nil
				if self.tableEquipData.quality > 0 then
					for i, v in ipairs(tabelBaseList) do
						if self.tableEquipData.equipmentID == v:getEID() then
							mainMeterialID = v:getEPID()
							break
						end
					end
				end
				for i, v in ipairs(self.tableNeedData) do
					if v.mid then
						table.insert(meterialArray, v.mid)
					end
				end
				equipmentCtrl:forgeEquipment(self.tableEquipData.equipmentID, meterialArray, mainMeterialID)
				SoraDShowLoading(self)
			end
		end
		local curQuality = self.tableEquipData.quality
		local ownNum = 0
		for i, v in ipairs(tabelBaseList) do
			if tonumber(v:getEID()) == self.tableEquipData.equipmentID and v:getEquipmentQuality() == curQuality - 1 then
				ownNum = 1
				break
			end
		end
		if ownNum <= 0 and 0 < curQuality then
			SoraDShowMsgTip(i18n("common_text_1379"))
			return
		end
		local menu = equipmentltCtrl.getSuitMaterialOfForging(self.tableEquipData.equipmentID, self.tableEquipData.quality)
		local cityCtrl, tempTable = self.tableEquipData.equipmentID, self.tableEquipData.equipmentID
		for i, v in ipairs(menu) do
			if i % 2 ~= 0 then
				local ownCount = backpackCtrl:getItemCount(v)
				local needCount = menu[i + 1]
				if ownCount < needCount then
					SoraDShowMsgTip(i18n("common_text_1379"))
					return
				end
			end
		end
		for i, v in ipairs(tabelBaseList) do
			if tonumber(v:getEID()) == self.tableEquipData.equipmentID and v:getEquipmentQuality() == curQuality - 1 and v:isWearing() then
				SoraDShowMsgBox(i18n("common_text_1392"), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						self.baseEquip = v
						equipmentCtrl:takeOffEquipment(self.baseEquip:getEPID(), self.baseEquip:getEquipmentPart())
						self:updateForgeState()
					end
				end)
				return
			end
		end
		doForge(MSGBOX_CALLBACK_YES)
	end
end
return equipSuitForgeViewPanel
