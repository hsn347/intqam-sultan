local equipmentMgr = include("equipmentMgr")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local itemDesRead = include("itemDesRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipLegendRefineViewPanel = class("equipLegendRefineViewPanel", baseFguiPanel)
function equipLegendRefineViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipLegendRefineViewPanel:ctor", self.viewName)
end
function equipLegendRefineViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipLegendRefineViewPanel:onInit()
	print("=======equipLegendRefineViewPanel:onInit")
	self.selectEquip = nil
	self.kingEquipList, _ENV, self.materialID = print, print, nil
	self.attrList, _ENV, self.curIndex = print, print, 3
	self.fields.Com_title:initData(i18n("equip_text_40"), handler(self, self.onClickClose))
	self.fields.et_lj:setAllFrameName("dh_zbjl_lj_%.2d.png", 1)
	self.fields.Button_refine:setString(i18n("equip_btn_01"))
	self.fields.Button_refine:addClickListener(handler(self, self.onRefineClick))
	self.fields.List_cell:setItemRenderer(handler(self, self.onEquipRender))
	self.fields.List_cell:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.List_cell:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRender))
	self.fields.Btn_left:addClickListener(handler(self, self.onLeftClick))
	self.fields.Btn_right:addClickListener(handler(self, self.onRightClick))
	self.fields.Text_tip:setString(i18n("equip_text_48"))
	self.fields.Text_artribute:setString(i18n("equip_text_47"))
	self.fields.Button_overdue:setString(i18n("legend_equip_return_009"))
	self.fields.Button_overdue:addClickListener(handler(self, self.onOverdueClick))
	self.fields.Button_overdue:setVisible(false)
end
function equipLegendRefineViewPanel:onEquipRender(index, obj)
	obj:initData(self.kingEquipList[index + 1], index + 1, self.curIndex)
end
function equipLegendRefineViewPanel:onAttrRender(index, obj)
	obj:initData(self.attrList[index + 1])
end
function equipLegendRefineViewPanel:onScrollItem()
	local offsetX = self.fields.List_cell:getScrollPane():getPositionX()
	local listW = self.fields.List_cell:getContentSize().width
	local scrollW = self.fields.List_cell:getInnerContainerSize().width
	local centerX = offsetX + listW / 2
	for i = 1, self.fields.List_cell:getNumItems() do
		local objW = self.fields.List_cell:getChildAt(i - 1):getContentSize().width
		local objOffsetX = self.fields.List_cell:getChildAt(i - 1):getX() + objW / 2 - offsetX - listW / 2
		self.fields.List_cell:getChildAt(i - 1):setRatio((scrollW - math.abs(objOffsetX)) / scrollW)
	end
end
function equipLegendRefineViewPanel:onScrollEndItem()
	local midIndex = 0
	local ratio = 0
	for i = 1, self.fields.List_cell:getNumItems() do
		if ratio <= self.fields.List_cell:getChildAt(i - 1):getRatio() and not self.fields.List_cell:getChildAt(i - 1):isEmptyCom() then
			ratio = self.fields.List_cell:getChildAt(i - 1):getRatio()
			midIndex = i
		end
	end
	self.curIndex = midIndex
	print("self.curIndex=====", self.curIndex)
	self.selectEquip = self.kingEquipList[self.curIndex]
	if self.selectEquip and not self.selectEquip.isEmpty then
		self.materialID = equipDesRead.getKingEquipMaterialID(self.selectEquip:getEID())
		self.fields.Com_newEquip:initData(self.selectEquip, true)
		_ENV = self.selectEquip:getEID()
		self.selectEquip:getEID().lv = self.selectEquip:getEquipmentLV()
		self.selectEquip:getEID().name = equipDesRead.getName(self.selectEquip:getEID())
		self.fields.Text_equipName:setString(i18n("common_text_134", self.selectEquip:getEID()))
		self.fields.Text_equipName:setColor(equipDesRead.getAttrColor(self.selectEquip:getEquipmentQuality()))
		self:updateView()
	else
		self:close()
		return
	end
end
function equipLegendRefineViewPanel:updateView()
	self:updateItemCount()
	self.fields.List_cell:setNumItems(#self.kingEquipList)
	local equip = self.kingEquipList[self.curIndex]
	_ENV = nil
	;(nil).lv = equip:getEquipmentLV()
	;(nil).name = equipDesRead.getName(equip:getEID())
	self.fields.Text_equipName:setString(i18n("common_text_134", nil))
	self.fields.Text_equipName:setColor(equipDesRead.getAttrColor(equip:getEquipmentQuality()))
	local cfg = equipmentltCtrl.getLegendEquipReturnCfg(equip:getEID())
	local isOpen = serviceFunctions.systemTime() >= constantRead.getConstValue("LEGEND_EQUIP_RETURN_OPEN_TIME")
	self.fields.Button_overdue:setVisible(isOpen and cfg and true or false)
	self:updateBtnLeftRight()
	self:updateAttr()
end
function equipLegendRefineViewPanel:onShow()
	print("=======equipLegendRefineViewPanel:onShow")
	self.selectEquip = self.param.selectEquip
	self.materialID = equipDesRead.getKingEquipMaterialID(self.selectEquip:getEID())
	self:initData()
end
function equipLegendRefineViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.kingEquipList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	local equipList = equipmentMgr.getEquipmentList()
	for k, v in pairs(equipList) do
		if equipDesRead.getKingEquipConfig(v:getEID()) then
			table.insert(self.kingEquipList, v)
		end
	end
	_ENV = nil
	;(nil).isEmpty = true
	table.insert(self.kingEquipList, 1, nil)
	_ENV = nil
	;(nil).isEmpty = true
	table.insert(self.kingEquipList, 1, nil)
	_ENV = 1
	;(1).isEmpty = true
	table.insert(self.kingEquipList, 1)
	_ENV = 1
	;(1).isEmpty = true
	table.insert(self.kingEquipList, 1)
	self.fields.List_cell:setNumItems(#self.kingEquipList)
	if self.selectEquip then
		for k, v in ipairs(self.kingEquipList) do
			if not v.isEmpty and v:getEID() == self.selectEquip:getEID() then
				self.curIndex = k
				break
			end
		end
	end
	self.fields.List_cell:scrollToCenter(self.fields.List_cell:getChildAt(self.curIndex - 1), true)
	self:onScrollItem()
	self:onScrollEndItem()
end
function equipLegendRefineViewPanel:updateItemCount()
	local count = backpackCtrl:getItemCount(self.materialID)
	self.materialCount = equipDesRead.getKingEquipMaterial(self.selectEquip:getEID())
	print("updateItemCount=====", self.materialID, self.selectEquip:getEID(), self.materialCount)
	self.fields.Com_item:initData(self.materialID, count, self.materialCount)
	local endTime = self.selectEquip:getEquipmentEndTimeProperty() or 0
	local leftTime = endTime - serviceFunctions.systemTime()
	self.fields.Button_refine:setTouchEnabled(true)
	self.fields.Button_refine:setBright(false)
	if count < self.materialCount then
		self.fields.Button_refine:setTouchEnabled(false)
	elseif 0 < leftTime and leftTime < 7200 then
		self.fields.Button_refine:setBright(false)
	else
		self.fields.Button_refine:setBright(true)
	end
end
function equipLegendRefineViewPanel:updateAttr()
	self.attrList, equipDesRead = nil, nil
	local base = self.selectEquip:getEquipmentBaseProperty()
	local extra = self.selectEquip:getEquipmentExtraProperty()
	local toEquip = equipDesRead.getKingEquipConfig(self.selectEquip:getEID())
	local newEquipConfig = equipmentltCtrl.getEquipCfg(toEquip.equipmentID)
	_ENV = toEquip.equipmentID
	toEquip.equipmentID[1] = newEquipConfig.propertyType
	local toEquip.equipmentID[2], newProTb = newEquipConfig.propertyValue, toEquip.equipmentID
	local factor = IsArClient and 1 or 10
	for i = 2, 4 do
		if newEquipConfig["propertyType" .. i] and newEquipConfig["propertyType" .. i] ~= 0 and newEquipConfig["propertyValue" .. i] and newEquipConfig["propertyValue" .. i] ~= 0 then
			table.insert(newProTb, newEquipConfig["propertyType" .. i])
			table.insert(newProTb, newEquipConfig["propertyValue" .. i] / factor)
		end
	end
	local propertyCfg = equipmentltCtrl.getEquipmentBasePropertyEx(toEquip.equipmentID, newEquipConfig.quality, self.selectEquip:getEquipmentSLV())
	for i = 1, #base - 1, 2 do
		local name, val = equipDesRead.getAttrName(base[i], base[i + 1], true)
		local _name, _val = equipDesRead.getAttrName(propertyCfg[i], propertyCfg[i + 1], true)
		equipDesRead = self.selectEquip:getEquipmentSLV()
		self.selectEquip:getEquipmentSLV().name = name
		self.selectEquip:getEquipmentSLV().curVal = val
		self.selectEquip:getEquipmentSLV().toVal = _val
		self.selectEquip:getEquipmentSLV().color = equipDesRead.getNormalColor()
		table.insert(self.attrList, self.selectEquip:getEquipmentSLV())
	end
	if #newProTb > #base then
		for i = #base + 1, #newProTb - 1, 2 do
			local name, val = equipDesRead.getAttrName(newProTb[i], 0, true)
			local _, _val = equipDesRead.getAttrName(newProTb[i], newProTb[i + 1], true)
			equipDesRead = self.selectEquip:getEquipmentSLV()
			self.selectEquip:getEquipmentSLV().name = name
			self.selectEquip:getEquipmentSLV().curVal = val
			self.selectEquip:getEquipmentSLV().toVal = _val
			self.selectEquip:getEquipmentSLV().color = equipDesRead.getNormalColor()
			table.insert(self.attrList, self.selectEquip:getEquipmentSLV())
		end
	end
	for k, v in ipairs(extra) do
		local quality = equipmentltCtrl.getEquipmentExtraPropertyQuality(self.selectEquip:getEquipmentLV(), v[1], v[2], self.selectEquip:getEquipmentType())
		local exName, exVal = equipDesRead.getAttrName(v[1], v[2], true)
		equipDesRead = self.selectEquip:getEquipmentType()
		self.selectEquip:getEquipmentType().name = exName
		self.selectEquip:getEquipmentType().curVal = exVal
		self.selectEquip:getEquipmentType().toVal = exVal
		self.selectEquip:getEquipmentType().color = equipDesRead.getAttrColor(quality)
		table.insert(self.attrList, self.selectEquip:getEquipmentType())
	end
	self.fields.List_attr:setNumItems(#self.attrList)
	self.fields.List_attr:setScrollEnable(#self.attrList > 7)
end
function equipLegendRefineViewPanel:updateBtnLeftRight()
	if #self.kingEquipList <= 5 then
		self.fields.Btn_left:setVisible(false)
		self.fields.Btn_right:setVisible(false)
	else
		self.fields.Btn_left:setVisible(self.curIndex > 3)
		self.fields.Btn_right:setVisible(self.curIndex < #self.kingEquipList - 2)
	end
end
function equipLegendRefineViewPanel:onLeftClick()
	SoraDPlaySound()
	self.curIndex = math.max(3, self.curIndex - 1)
	self.fields.List_cell:scrollToCenter(self.fields.List_cell:getChildAt(self.curIndex - 1), true)
end
function equipLegendRefineViewPanel:onRightClick()
	SoraDPlaySound()
	self.curIndex = math.min(self.curIndex + 1, #self.kingEquipList - 2)
	self.fields.List_cell:scrollToCenter(self.fields.List_cell:getChildAt(self.curIndex - 1), true)
end
function equipLegendRefineViewPanel:onRefineClick()
	SoraDPlaySound()
	if equipmentCtrl:isEquipmentLocked(self.selectEquip:getEPID()) then
		SoraDShowMsgTip(i18n("Safety_lock_text_37"))
		return
	end
	local toEquip = equipDesRead.getKingEquipConfig(self.selectEquip:getEID())
	if toEquip and toEquip.level > SoraDGetLordLv() then
		_ENV = self.selectEquip:getEID()
		self.selectEquip:getEID().lv = toEquip.level
		SoraDShowMsgTip(i18n("equip_text_52", self.selectEquip:getEID()))
		return
	end
	local levelUp = function()
		SoraDShowLoading(self)
		equipmentCtrl:legendEquipLevelUp(self.selectEquip:getEPID())
	end
	if self.selectEquip:isWearing() then
		SoraDShowMsgBox(i18n("equip_text_44"), i18n("common_text_204"), nil, function(event)
			if event == MSGBOX_CALLBACK_YES then
				equipmentCtrl:takeOffEquipment(self.selectEquip:getEPID(), self.selectEquip:getEquipmentPart())
			end
		end)
	else
		local endTime = self.selectEquip:getEquipmentEndTimeProperty() or 0
		local leftTime = endTime - serviceFunctions.systemTime()
		if 0 < leftTime then
			if leftTime < 7200 then
				SoraDShowMsgTip(i18n("equip_text_42"))
			else
				_ENV = i18n("equip_text_42")
				i18n("equip_text_42").time = SoraDConvertSecondToString(leftTime)
				SoraDShowMsgBox(i18n("equip_text_43", i18n("equip_text_42")), i18n("common_text_204"), nil, function(event)
					if event == MSGBOX_CALLBACK_YES then
						levelUp()
					end
				end)
			end
		else
			levelUp()
		end
	end
end
function equipLegendRefineViewPanel:onOverdueClick()
	SoraDPlaySound()
	uiManager:show("equipOverduePreView")
end
return equipLegendRefineViewPanel
