local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local baseComponent = require("fgui.base.baseComponent")
local List_suitCell = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_suitCell", List_suitCell)
function List_suitCell:onInit()
	self.tableAttrData, _ENV, self.partList, _ENV = nil, nil, nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.text_materialNotEnough:setString(i18n("common_text_1379"))
	self.fields.text_materialNotEnough:setVisible(false)
	self.fields.btn_lookUp:setString(i18n("common_text_1343"))
	self.fields.btn_lookUp:addClickListener(handler(self, self.btnLookUpClick))
	self.fields.List_attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self:fixChildrenPos()
end
function List_suitCell:onShow()
end
function List_suitCell:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_SUIT_CELL_SELECT", handler(self, self.updateIndex))
end
function List_suitCell:updateIndex(target, data)
	self.showIndex = data.index
	if data.equipID == self.data.equipid then
		self.fields.List:setNumItems(#self.partList)
		self:updateNotice()
		self:updateAttr()
	end
end
function List_suitCell:onItemRenderer(index, obj)
	obj:initDataEX(self.partList[index + 1], index + 1, self.showIndex, self.data)
end
function List_suitCell:onAttrRenderer(index, obj)
	local data = self.tableAttrData[index + 1]
	obj:setString(data.name)
	obj:setColor(data.color)
end
function List_suitCell:initData(data, index)
	self.data = data
	self.index = index
	self.partList = equipmentltCtrl.getSuitPartList(self.index, self.data.equipid)
	self.showIndex = #self.partList
	for k, v in ipairs(self.partList) do
		if self:isOwnEquip(v.equipmentID, v.quality) then
			self.showIndex = math.min(#self.partList, k + 1)
		elseif equipmentCtrl:canSuitForge(v.equipmentID, v.quality) then
			self.showIndex = k
		end
	end
	self.fields.List:setNumItems(#self.partList)
	equipmentltCtrl = nil
	;(nil).lv = equipmentltCtrl.getSuitLv(self.data.equipid)
	;(nil).name = equipDesRead.getName(self.data.equipid)
	self.fields.txt_weaponName:setString(i18n("common_text_134", nil))
	self:updateNotice()
	self:updateAttr()
end
function List_suitCell:updateAttr()
	local _ENV, tableHaveAttr
	local totalQuality = self.showIndex
	local factor = IsArClient and 1 or 10
	local propertyType, propertyValue = self.partList[totalQuality].propertyType, self.partList[totalQuality].propertyValue / factor
	local propertyType2, propertyValue2 = self.partList[totalQuality].propertyType2, self.partList[totalQuality].propertyValue2 / factor
	local name1 = equipDesRead.getAttrName(propertyType, propertyValue)
	local name2 = equipDesRead.getAttrName(propertyType2, propertyValue2)
	_ENV = propertyType2
	propertyType2.name = name1
	_ENV, tableHaveAttr[1], propertyType2.color = propertyType2, propertyType2, equipDesRead.getNormalColor()
	propertyType2.name = name2
	tableHaveAttr[2], propertyType2.color = propertyType2, equipDesRead.getNormalColor()
	local labelCount = totalQuality + 1
	self.tableAttrData, _ENV = equipDesRead.getNormalColor(), equipDesRead.getNormalColor()
	for i = 1, labelCount do
		if tableHaveAttr[i] then
			self.tableAttrData[i] = tableHaveAttr[i]
		else
			_ENV = nil
			;(nil).name = i18n("common_text_1344")
			;(nil).color = cc.c3b(255, 210, 200)
			table.insert(self.tableAttrData, nil)
		end
	end
	self.fields.List_attr:setNumItems(#self.tableAttrData)
end
function List_suitCell:updateNotice()
	local part = self.partList[self.showIndex]
	local isForged = self:isOwnEquip(part.equipmentID, part.quality)
	if isForged then
		self.fields.btn_lookUp:setString(i18n("suit_btn_text_01"))
		self.fields.text_materialNotEnough:setVisible(false)
	else
		local isCanForge = equipmentCtrl:canSuitForge(part.equipmentID, part.quality)
		self.fields.text_materialNotEnough:setVisible(not isCanForge)
		self.fields.btn_lookUp:setString(i18n("common_text_1343"))
	end
end
function List_suitCell:isOwnEquip(eid, quality)
	local isOwn = false
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	for k, v in ipairs(tabelBaseList) do
		if v:getEID() == eid and quality <= v:getEquipmentQuality() then
			isOwn = true
			break
		end
	end
	return isOwn
end
function List_suitCell:btnLookUpClick()
	SoraDPlaySound()
	local partList = equipmentltCtrl.getSuitPartList(self.index, self.data.equipid)
	self.tableEquipData = partList[self.showIndex]
	_ENV = nil
	;(nil).equipData = self.tableEquipData
	;(nil).index = self.showIndex
	uiManager:show("equipSuitForgeView", nil)
end
return List_suitCell
