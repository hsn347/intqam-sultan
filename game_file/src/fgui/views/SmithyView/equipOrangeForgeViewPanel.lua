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
local equipOrangeForgeViewPanel = class("equipOrangeForgeViewPanel", baseFguiPanel)
function equipOrangeForgeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipOrangeForgeViewPanel:ctor", self.viewName)
end
function equipOrangeForgeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipOrangeForgeViewPanel:onInit()
	print("=======equipOrangeForgeViewPanel:onInit")
	self.baseEquip = nil
	self.tableAttrData, _ENV, self.materialList, _ENV, self.factor = IsArClient and 1 or 10, IsArClient and 1 or 10, IsArClient and 1 or 10, IsArClient and 1 or 10, IsArClient and 1 or 10
	self.fields.Com_title:initData(i18n("equip_text_22"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("common_text_1413"))
	self.fields.Text_need:setString(i18n("Weapon_Rune_tips_053"))
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Button_bag:addClickListener(handler(self, self.btnBagClickCallBack))
	self.fields.Button_help:addClickListener(handler(self, self.OnBtnFAQClick))
	self.fields.Button_forge:setString(i18n("common_text_1339"))
	self.fields.Button_forge:addClickListener(handler(self, self.btnForgeCallBack))
	self.fields.Button_forge:setBright(false)
	local nebulaMileStoneRead = include("nebulaMileStoneRead")
	local unlockMileStoneTask = nebulaMileStoneRead.getConfigByUnlockType(gNebulaMileStoneUnlockType.EQUIPMENT_FORGING)
	if unlockMileStoneTask then
		local milestoneName = nebulaMileStoneRead.getName(unlockMileStoneTask.milestoneID)
		_ENV = handler(self, self.btnForgeCallBack)
		handler(self, self.btnForgeCallBack).name = milestoneName
		self.fields.Text_forgeLock:setString(i18n("nebula_milestone_text_01", handler(self, self.btnForgeCallBack)))
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
function equipOrangeForgeViewPanel:onShow()
	print("=======equipOrangeForgeViewPanel:onShow")
	self.tableEquipData = self.param.equipData
	self.baseEquip = self.param.baseEquip
	self:initData()
end
function equipOrangeForgeViewPanel:onItemRenderer(index, obj)
	local data = self.materialList[index + 1]
	local itemCount = backpackCtrl:getItemCount(data.id)
	obj:initData(data.id)
	backpackCtrl = nil
	;(nil).var1 = fguiHelper.getColorString(itemCount >= data.count and "#FFFFFF" or "#FF0000", itemCount)
	;(nil).var2 = data.count
	obj:setNumText(i18n("%{var1}/%{var2}", nil))
	if not obj.clickCallback then
		obj:setClickCallback(function()
			if data.id == NEBULA_ORANGE_BLUEPRINT then
				data = nil
				;(nil).content = i18n("common_text_4619")
				;(nil).title = i18n("common_text_4342")
				;(nil).contentAlignCenter = true
				uiManager:show("RuleView", nil)
				return
			end
			local _data = itemDesRead.getOutput(data.id)
			if next(_data) then
				local needCount = 0
				for k, v in ipairs(self.materialList) do
					if v.id == data.id then
						needCount = needCount + v.count
					end
				end
				local needNum = math.max(0, needCount - backpackCtrl:getItemCount(data.id))
				data = data.id
				data, data.id.itemID = data.id, data.id
				data.id.isOrangItem = true
				data.id.needNum = needNum
				data.id.otherData, data.id.needCount = data.id, needCount
				uiManager:show("commonGetWayView", data.id)
				return
			end
			data = uiManager
			uiManager.materialID = data.id
			uiManager.isOrange = true
			uiManager:show("equipOrangeBuyMorePopView", uiManager)
		end)
	end
end
function equipOrangeForgeViewPanel:onAttrRenderer(index, obj)
	if self.baseEquip then
		obj:initData(self.tableAttrData[index + 1])
	else
		obj:initDataEX(self.tableAttrData[index + 1])
	end
end
function equipOrangeForgeViewPanel:resetBaseEquip()
	self.baseEquip = nil
end
function equipOrangeForgeViewPanel:initData()
	self.fields.Com_equipTo:initDataEX(self.tableEquipData)
	self.partName = equipDesRead.getPartName(self.tableEquipData.eType)
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.forge_equipment)
	if self.queue and self.queue.data.eid == self.tableEquipData.equipmentID then
		self.controllers.c1:setSelectedIndex(1)
		self:showQueue()
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_time:setString(SoraDConvertSecondToString(equipmentCtrl:getForgingTime(self.tableEquipData.equipmentID, self.tableEquipData.suitequipID, gQualityDef.ORANGE)))
		self:updateSteel()
		self:updateEquipBase()
		self:initMaterial()
		self:updateForgeState()
	end
	self:initAttr()
end
function equipOrangeForgeViewPanel:initAttr()
	self.tableAttrData, equipDesRead = nil, nil
	if self.baseEquip then
		local baseProperty = self.baseEquip:getEquipmentBaseProperty()
		local extra = self.baseEquip:getEquipmentExtraProperty()
		for i = 1, #baseProperty - 1, 2 do
			local name, curVal = equipDesRead.getAttrName(baseProperty[i], baseProperty[i + 1], true)
			local name, toVal = equipDesRead.getAttrName(self.tableEquipData.propertyType, self.tableEquipData.propertyValue / self.factor, true)
			equipDesRead = nil
			;(nil).name = name
			;(nil).curVal = curVal
			;(nil).toVal = toVal
			;(nil).color = equipDesRead.getNormalColor()
			table.insert(self.tableAttrData, nil)
		end
		for i = 1, 4 do
			if extra[i] then
				local name, val = equipDesRead.getAttrName(extra[i][1], extra[i][2], true)
				local quality = equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType())
				equipDesRead = extra[i][2]
				extra[i][2].name = name
				extra[i][2].curVal = val
				extra[i][2].toVal = val
				extra[i][2].color = equipDesRead.getAttrColor(quality)
				table.insert(self.tableAttrData, extra[i][2])
			else
				equipDesRead = equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType())
				equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType()).name = i18n("common_text_4741")
				equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType()).curVal = "???"
				equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType()).toVal = "???"
				equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType()).color = cc.c3b(215, 195, 155)
				table.insert(self.tableAttrData, (equipmentltCtrl.getEquipmentExtraPropertyQuality(self.baseEquip:getEquipmentLV(), extra[i][1], extra[i][2], self.baseEquip:getEquipmentType())))
			end
		end
	else
		local equipCell = equipmentCtrl:getEquipment()
		if equipCell and self.queue and self.queue.data.qly == gQualityDef.ORANGE and self.tableEquipData.suitequipID > 0 then
			local baseProperty = equipCell:getEquipmentBaseProperty()
			local extra = equipCell:getEquipmentExtraProperty()
			if not equipCell.property.mainM or not equipCell.property.mainM.extra then
				local equipDesRead, preExtra = equipCell.property.mainM.extra, equipCell.property.mainM.extra
			end
			for i = 1, #baseProperty - 1, 2 do
				local name, curVal = equipDesRead.getAttrName(baseProperty[i], baseProperty[i + 1], true)
				local name, toVal = equipDesRead.getAttrName(self.tableEquipData.propertyType, self.tableEquipData.propertyValue / self.factor, true)
				equipDesRead = self.baseEquip:getEquipmentType()
				self.baseEquip:getEquipmentType().name = name
				self.baseEquip:getEquipmentType().curVal = curVal
				self.baseEquip:getEquipmentType().toVal = toVal
				self.baseEquip:getEquipmentType().color = equipDesRead.getNormalColor()
				table.insert(self.tableAttrData, self.baseEquip:getEquipmentType())
			end
			for i, v in ipairs(extra) do
				v.isRandom = 1
				for k, m in ipairs(preExtra) do
					if v[1] == m[1] then
						v.isRandom = 0
					end
				end
			end
			for i = 1, 4 do
				if extra[i] then
					if extra[i].isRandom == 0 then
						local name, val = equipDesRead.getAttrName(extra[i][1], extra[i][2], true)
						local quality = equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType())
						equipDesRead = extra[i][2]
						extra[i][2].name = name
						extra[i][2].curVal = val
						extra[i][2].toVal = val
						extra[i][2].color = equipDesRead.getAttrColor(quality)
						table.insert(self.tableAttrData, extra[i][2])
					else
						equipDesRead = equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType())
						equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).name = i18n("common_text_4741")
						equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).curVal = "???"
						equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).toVal = "???"
						equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).color = cc.c3b(215, 195, 155)
						table.insert(self.tableAttrData, (equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType())))
					end
				else
					equipDesRead = equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType())
					equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).name = i18n("common_text_4741")
					equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).curVal = "???"
					equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).toVal = "???"
					equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType()).color = cc.c3b(215, 195, 155)
					table.insert(self.tableAttrData, (equipmentltCtrl.getEquipmentExtraPropertyQuality(equipCell:getEquipmentLV(), extra[i][1], extra[i][2], equipCell:getEquipmentType())))
				end
			end
		else
			local name, val = equipDesRead.getAttrName(self.tableEquipData.propertyType, self.tableEquipData.propertyValue / self.factor, true)
			equipDesRead = 4
			;(4).name = name
			;(4).val = val
			;(4).color = equipDesRead.getNormalColor()
			table.insert(self.tableAttrData, 4)
			for i = 1, 4 do
				equipDesRead = self.tableAttrData
				self.tableAttrData.name = i18n("common_text_4741")
				self.tableAttrData.val = "???"
				self.tableAttrData.color = cc.c3b(215, 195, 155)
				table.insert(self.tableAttrData, self.tableAttrData)
			end
		end
	end
	self.fields.List_attr:setNumItems(#self.tableAttrData)
	self.fields.List_attr:setScrollEnable(#self.tableAttrData > 7)
end
function equipOrangeForgeViewPanel:updateSteel()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfForging(self.tableEquipData.equipmentID, gQualityDef.ORANGE)
	self.fields.Com_steel:initData(gIDDef.STEEL, haveSteel, needSteel, handler(self, self.showBuySteel))
end
function equipOrangeForgeViewPanel:selectBack(target, data)
	self.baseEquip = data.baseEquip
	self:updateEquipBase()
	self:initMaterial()
	self:updateForgeState()
	self:initAttr()
end
function equipOrangeForgeViewPanel:updateEquipBase()
	if self.baseEquip then
		self.fields.Com_equipFrom:initData(self.tableEquipData, self.baseEquip)
	else
		local maxlv = self.tableEquipData.level
		local minlv = self.tableEquipData.level - 5
		_ENV = nil
		;(nil).lv1 = minlv
		;(nil).lv2 = maxlv
		;(nil).equip = self.partName
		local str = i18n("equip_text_26", nil)
		if self.tableEquipData.level == 40 then
			_ENV = self.partName
			self.partName.lv2 = maxlv
			self.partName.equip = self.partName
			str = i18n("equip_text_37", self.partName)
		end
		self.fields.Com_equipFrom:initData(self.tableEquipData, nil, str)
	end
end
function equipOrangeForgeViewPanel:initMaterial()
	self.materialList, equipmentltCtrl = nil, nil
	local materialList = equipmentltCtrl.getMaterialOfForgeOrange(self.tableEquipData.equipmentID)
	local bluePrint = equipmentltCtrl.getBluePrintInfo(self.tableEquipData.equipmentID)
	equipmentltCtrl = self.tableEquipData.equipmentID
	self.tableEquipData.equipmentID[1] = 202101
	local self.tableEquipData.equipmentID[2], bluePrint2 = 0, self.tableEquipData.equipmentID
	if self.baseEquip ~= nil and self.baseEquip:getEquipmentQuality() == gQualityDef.ORANGE then
		bluePrint2 = equipmentltCtrl.getBluePrintInfo(self.baseEquip:getEID())
		bluePrint[2] = bluePrint[2] - bluePrint2[2]
	end
	for i, v in ipairs(bluePrint) do
		table.insert(materialList, v)
	end
	_UPVALUE2_ = ipairs(bluePrint)
	ipairs(bluePrint)[1] = "id"
	ipairs(bluePrint)[2] = "count"
	self.materialList = serviceFunctions.tableFormat(materialList, ipairs(bluePrint))
	self.fields.List_need:setNumItems(#self.materialList)
end
function equipOrangeForgeViewPanel:updateForgeState()
	local canForge = false
	canForge = self.baseEquip ~= nil and true or false
	if self.queue then
		self.fields.Button_forge:setBright(false)
	else
		self.fields.Button_forge:setBright(not self:checkMaterialEnough() and canForge)
	end
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local maxLv = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.EQUIPMENT_FORGING, 95)
	if maxLv and maxLv < self.tableEquipData.level then
		self.fields.Button_forge:setVisible(false)
		self.fields.Text_forgeLock:setVisible(true)
	else
		self.fields.Button_forge:setVisible(true)
		self.fields.Text_forgeLock:setVisible(false)
	end
end
function equipOrangeForgeViewPanel:showQueue()
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
function equipOrangeForgeViewPanel:timeUpdate(time)
	self.fields.bar:setValue(time)
	self.fields.Button_speedUp:setCostTitle(string.formatnumberthousands(serviceFunctions.timeConvertToGold(time)))
end
function equipOrangeForgeViewPanel:btnSpeedUpByItemClickCallBack()
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
function equipOrangeForgeViewPanel:btnSpeedUpClickCallBack()
	SoraDPlaySound()
	if self.queue then
		_ENV = "common_text_765"
		;("common_text_765").speedUpName = i18n("common_text_2219")
		SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"), "common_text_765")
	end
end
function equipOrangeForgeViewPanel:OnBtnFAQClick()
	SoraDPlaySound()
	_ENV = "equip_text_25"
	;("equip_text_25").float = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("equip_text_25"), "equip_text_25")
end
function equipOrangeForgeViewPanel:btnBagClickCallBack()
	SoraDPlaySound()
	SoraDRemoveAllAfterPanelFromManager(self, true)
	uiManager:show("storageBoxView")
end
function equipOrangeForgeViewPanel:btnForgeCallBack(button, type)
	SoraDPlaySound()
	if self.baseEquip and self.baseEquip:isWearing() then
		_ENV = nil
		;(nil).content = i18n("common_text_1392")
		;(nil).confirmFunc = function()
			equipmentCtrl:takeOffEquipment(self.baseEquip:getEPID(), self.baseEquip:getEquipmentPart())
		end
		;(nil).confirmString = i18n("common_text_204")
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	else
		self:forgeEquip()
	end
end
function equipOrangeForgeViewPanel:forgeEquip()
	local haveSteel = cityCtrl:getResCount(gIDDef.STEEL)
	local needSteel = equipmentCtrl:getRealSteelNumOfForging(self.tableEquipData.equipmentID)
	local smithyCell = cityCtrl:getBuildCell(BUILDID.BLACK_SMITH, 0)
	if self.queue then
		SoraDShowMsgTip(i18n("equip_text_30"))
		return
	end
	if self:checkMaterialEnough() or self.baseEquip == nil then
		SoraDShowMsgTip(i18n("common_text_1379"))
		return
	end
	if SoraDGetLordLv() < self.tableEquipData.level then
		cityCtrl = i18n("common_text_1379")
		i18n("common_text_1379").lv = self.tableEquipData.level
		SoraDShowMsgTip(i18n("common_text_1393", i18n("common_text_1379")), equipDesRead.getIcon(self.tableEquipData.equipmentID, true), button)
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
				local mainMeterialID = self.baseEquip ~= nil and self.baseEquip:getEPID() or nil
				equipmentCtrl:forgeOrangeEquipment(self.tableEquipData.equipmentID, mainMeterialID)
			end
		end
		doForge(MSGBOX_CALLBACK_YES)
	end
end
function equipOrangeForgeViewPanel:checkMaterialEnough()
	local isLack = false
	for i, v in ipairs(self.materialList) do
		local itemCount = backpackCtrl:getItemCount(v.id)
		local needItemCount = v.count
		if itemCount < needItemCount then
			isLack = true
			break
		end
	end
	return isLack
end
function equipOrangeForgeViewPanel:showBuySteel(showMsg)
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
return equipOrangeForgeViewPanel
