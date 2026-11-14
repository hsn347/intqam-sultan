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
local equipForgeViewPanel = class("equipForgeViewPanel", baseFguiPanel)
function equipForgeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipForgeViewPanel:ctor", self.viewName)
end
function equipForgeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipForgeViewPanel:onInit()
	print("=======equipForgeViewPanel:onInit")
	self.tableAttrData, _ENV, self.tableNeedData, _ENV = print, print, print, print
	self.maxQuality = 1
	self.qualityData, _ENV, self.isAuto = print, print, false
	self.isCantCloseByReturn = false
	self.fields.Com_title:initData(i18n("common_text_1345"), handler(self, self.onClickClose))
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
	self.fields.List_attr:setVisible(false)
	self.fields.abg:setVisible(false)
	for i = 1, 4 do
		self.fields["Button_quality_" .. i]:addClickListener(handler(self, self.btnAttrClickCallBack))
		self.fields["Button_quality_" .. i]:setTag(i)
		self.fields["Button_quality_" .. i]:setVisible(false)
		self.fields["Button_quality_" .. i]:fixPos()
	end
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function equipForgeViewPanel:onShow()
	print("=======equipForgeViewPanel:onShow")
	self.tableEquipData = self.param.equipData
	self.isAuto = self.param.isAuto or false
	if self.isAuto then
		self:initAutoData(self.param.equip)
	else
		self:initData()
	end
end
function equipForgeViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.fields.Com_equip:initDataEX(self.tableEquipData)
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.forge_equipment)
	if self.queue and self.queue.data.eid == self.tableEquipData.equipmentID and self.queue.data.qly ~= gQualityDef.ORANGE then
		self.controllers.c1:setSelectedIndex(1)
		self:showQueue()
		self:updateQualityBtn()
		self.fields.List_attr:setVisible(true)
		self.fields.abg:setVisible(true)
		for i = 1, 4 do
			self.fields["Button_quality_" .. i]:setVisible(true)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_time:setString(SoraDConvertSecondToString(equipmentCtrl:getForgingTime(self.tableEquipData.equipmentID, self.tableEquipData.suitequipID, self.tableEquipData.quality)))
		self:updateSteel()
		self.tableNeedData, _ENV = self.updateSteel, self.updateSteel
		if target then
			self.baseEquip = nil
		end
		self:initMaterial()
		self:updateForgeState()
	end
end
function equipForgeViewPanel:selectBack(target, data)
	local mid = data.mid
	local tag = data.tag
	local baseEquip = data.baseEquip
	if baseEquip then
		self.baseEquip = baseEquip
	end
	for k, v in ipairs(self.tableNeedData) do
		if v.mode ~= 0 then
			if baseEquip then
				v.baseEquip = baseEquip
				v.mode = 2
			end
		elseif v.tag == tag then
			v.mid = mid
			break
		end
	end
	self.fields.List_need:setNumItems(#self.tableNeedData)
	self:updateForgeState()
end
function equipForgeViewPanel:updateForgeState()
	local canForge = false
	self.forgeNotice = nil
	if equipmentltCtrl.needMainEquipment(self.tableEquipData.equipmentID) and self.baseEquip == nil and self.tableEquipData.suitequipID == 0 then
		canForge = false
		local maxlv = self.tableEquipData.level
		local minlv = self.tableEquipData.level - 5
		equipmentltCtrl = nil
		;(nil).lv1 = math.max(1, minlv)
		;(nil).lv2 = maxlv
		self.forgeNotice = i18n("common_text_1410", nil)
	else
		canForge = true
	end
	for k, v in ipairs(self.tableNeedData) do
		if v.mode == 0 and not v.isHave then
			canForge = false
			self.forgeNotice = self.forgeNotice or i18n("common_text_1379")
			break
		end
	end
	if canForge or self.queue and self.queue.data.eid == self.tableEquipData.equipmentID then
		self:updateQualityBtn()
		self.fields.List_attr:setVisible(true)
		self.fields.abg:setVisible(true)
		for i = 1, 4 do
			self.fields["Button_quality_" .. i]:setVisible(true)
		end
	else
		self.fields.List_attr:setVisible(false)
		self.fields.abg:setVisible(false)
		for i = 1, 4 do
			self.fields["Button_quality_" .. i]:setVisible(false)
		end
	end
	self.fields.Button_forge:setBright(canForge)
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local maxLv = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.EQUIPMENT_FORGING, 95)
	if maxLv ~= 0 and maxLv and maxLv < self.tableEquipData.level then
		self.fields.Button_forge:setVisible(false)
		self.fields.Text_forgeLock:setVisible(true)
	else
		self.fields.Button_forge:setVisible(true)
		self.fields.Text_forgeLock:setVisible(false)
	end
end
function equipForgeViewPanel:initMaterial()
	if equipmentltCtrl.needMainEquipment(self.tableEquipData.equipmentID) then
		if self.isAuto and self.baseEquip then
			equipmentltCtrl = nil
			;(nil).mode = 2
			;(nil).baseEquip = self.baseEquip
			table.insert(self.tableNeedData, nil)
		else
			equipmentltCtrl = nil
			;(nil).mode = 1
			;(nil).baseEquip = self.baseEquip
			table.insert(self.tableNeedData, nil)
		end
	end
	local menu = equipmentltCtrl.getMaterialOfForging(self.tableEquipData.equipmentID)
	local equipmentltCtrl, list = self.tableEquipData.equipmentID, self.tableEquipData.equipmentID
	for i, v in ipairs(menu) do
		for k, id in ipairs(v) do
			local itemQuality = itemDesRead.getQuality(id)
			if itemQuality ~= gQualityDef.ORANGE then
				local count = backpackCtrl:getItemCount(id)
				list[id] = count
			end
		end
	end
	for i = 1, 4 do
		if menu[i] then
			for j = #menu[i], 1, -1 do
				local mid = menu[i][j]
				if list[mid] and 0 < list[mid] then
					equipmentltCtrl = backpackCtrl:getItemCount(id)
					backpackCtrl:getItemCount(id).mode = 0
					backpackCtrl:getItemCount(id).mid = mid
					backpackCtrl:getItemCount(id).isHave = true
					backpackCtrl:getItemCount(id).tag = i
					table.insert(self.tableNeedData, (backpackCtrl:getItemCount(id)))
					list[mid] = list[mid] - 1
					break
				end
				if j == 1 then
					equipmentltCtrl = backpackCtrl:getItemCount(id)
					backpackCtrl:getItemCount(id).mode = 0
					backpackCtrl:getItemCount(id).mid = mid
					backpackCtrl:getItemCount(id).isHave = false
					backpackCtrl:getItemCount(id).tag = i
					table.insert(self.tableNeedData, (backpackCtrl:getItemCount(id)))
				end
			end
		end
	end
	self.fields.List_need:setNumItems(#self.tableNeedData)
end
function equipForgeViewPanel:showQueue()
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
function equipForgeViewPanel:timeUpdate(time)
	self.fields.bar:setValue(time)
	self.fields.Button_speedUp:setCostTitle(string.formatnumberthousands(serviceFunctions.timeConvertToGold(time)))
end
function equipForgeViewPanel:initAutoData(equip)
	self.isAuto = true
	self.baseEquip = equip.singleData
	self.tableEquipData = equip.equipment
	self:initData()
end
function equipForgeViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableNeedData[index + 1], self.tableEquipData, self.baseEquip, self.tableNeedData)
end
function equipForgeViewPanel:onAttrRenderer(index, obj)
	obj:initDataEX(self.tableAttrData[index + 1])
end
function equipForgeViewPanel:updateSteel()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfForging(self.tableEquipData.equipmentID)
	self.fields.Com_steel:initData(gIDDef.STEEL, haveSteel, needSteel, handler(self, self.showBuySteel))
end
function equipForgeViewPanel:updateQualityBtn()
	local equipmentltCtrl, materialArray
	local mainMaterialQuality
	local isNeedEquip = equipmentltCtrl.needMainEquipment(self.tableEquipData.equipmentID)
	if self.baseEquip ~= nil then
		if self.baseEquip.class then
			mainMaterialQuality = self.baseEquip:getEquipmentQuality()
		elseif self.baseEquip.qly then
			mainMaterialQuality = self.baseEquip.qly
		end
	end
	if self.queue and self.queue.data.eid == self.tableEquipData.equipmentID and self.queue.data.qly ~= gQualityDef.ORANGE then
		materialArray, equipmentltCtrl = self.queue.data.subM, self.queue.data.subM
		materialArray = self.queue.data.subM or nil
	else
		for i, v in ipairs(self.tableNeedData) do
			if v.mid then
				table.insert(materialArray, v.mid)
			end
		end
	end
	local qualityRate = equipmentltCtrl.getForgeQuality(mainMaterialQuality, materialArray)
	self.maxQuality = 1
	local maxRate = 0
	for i = 1, 4 do
		self.fields["Button_quality_" .. i]:setString(qualityRate[i - 1] .. "%")
		local qRate = qualityRate[i - 1]
		if maxRate <= qRate then
			maxRate = qRate
			self.maxQuality = i
		end
		if 0 < qRate then
			equipmentltCtrl = self.fields["Button_quality_" .. i]
			self.fields["Button_quality_" .. i].topRate = qRate
			self.qualityData, self.fields["Button_quality_" .. i].topI = self.fields["Button_quality_" .. i], i - 1
		end
	end
	self:updateQualityAttr(self.maxQuality)
end
function equipForgeViewPanel:updateQualityAttr(quality)
	for i = 1, 4 do
		self.fields["Button_quality_" .. i]:setSelected(i == quality)
	end
	local equipmentltCtrl, tableHaveAttr = (for index), 1
	local propertyType, propertyValue = equipmentltCtrl.getEquipmentBaseProperty(self.tableEquipData.equipmentID, quality - 1, 0)
	local name, val = equipDesRead.getAttrName(propertyType, propertyValue, true)
	equipmentltCtrl = propertyValue
	propertyValue.name = name
	propertyValue.val = val
	tableHaveAttr[1], propertyValue.color = propertyValue, equipDesRead.getNormalColor()
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
	local labelCount = quality
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
	self.fields.List_attr:setScrollEnable(#self.tableAttrData > 7)
end
function equipForgeViewPanel:btnAttrClickCallBack(content)
	SoraDPlaySound()
	local tag = content:getSender():getTag()
	self:updateQualityAttr(tag)
end
function equipForgeViewPanel:btnClickCallBack()
	SoraDPlaySound()
	if self.forgeNotice then
		SoraDShowMsgTip(self.forgeNotice)
		return
	end
	SoraDRemoveAllAfterPanelFromManager(self, true)
	if self.baseEquip and self.baseEquip.isWearing and self.baseEquip:isWearing() then
		equipmentCtrl:takeOffEquipment(self.baseEquip:getEPID(), self.baseEquip:getEquipmentPart())
	else
		self:forgeEquip()
	end
end
function equipForgeViewPanel:showBuySteel(showMsg)
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
function equipForgeViewPanel:forgeEquip()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfForging(self.tableEquipData.equipmentID)
	local smithyCell = cityCtrl:getBuildCell(BUILDID.BLACK_SMITH, 0)
	local button
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
		SoraDShowMsgTip(i18n("common_text_1664"), equipDesRead.getIcon(self.tableEquipData.equipmentID, true), button)
	else
		local tabelBaseList = equipmentMgr:getEquipmentArray()
		local doForge = function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				local _ENV, meterialArray = MSGBOX_CALLBACK_YES, MSGBOX_CALLBACK_YES
				local mainMeterialID = self.baseEquip ~= nil and self.baseEquip.getEPID and self.baseEquip:getEPID() or nil
				for i, v in ipairs(self.tableNeedData) do
					if v.mid then
						table.insert(meterialArray, v.mid)
					end
				end
				equipmentCtrl:forgeEquipment(self.tableEquipData.equipmentID, meterialArray, mainMeterialID)
				self.isAuto = false
				self.baseEquip = nil
				self:updateForgeState()
				SoraDShowLoading(self)
			end
		end
		if self.qualityData.topRate and self.qualityData.topRate < 100 then
			local qName = equipDesRead.getQualityName(self.qualityData.topI)
			cityCtrl = i18n("common_text_765")
			i18n("common_text_765").rate = self.qualityData.topRate
			i18n("common_text_765").quality = qName
			i18n("common_text_765").mustQuality = qName
			i18n("common_text_765").maxQuality = qName
			SoraDShowMsgBox(i18n("common_text_1899", i18n("common_text_765")), i18n("common_text_204"), nil, doForge)
		else
			doForge(MSGBOX_CALLBACK_YES)
		end
	end
end
function equipForgeViewPanel:btnSpeedUpByItemClickCallBack()
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
function equipForgeViewPanel:btnSpeedUpClickCallBack()
	SoraDPlaySound()
	if self.queue then
		_ENV = "common_text_765"
		;("common_text_765").speedUpName = i18n("common_text_2219")
		SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"), "common_text_765")
	end
end
function equipForgeViewPanel:OnBtnFAQClick()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.EQUIP_FORGE)
end
function equipForgeViewPanel:btnBagClickCallBack()
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	uiManager:show("storageBoxView")
end
return equipForgeViewPanel
