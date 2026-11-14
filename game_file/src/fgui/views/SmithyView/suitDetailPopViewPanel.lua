local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local suitDetailPopViewPanel = class("suitDetailPopViewPanel", baseFguiPanel)
function suitDetailPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("suitDetailPopViewPanel:ctor", self.viewName)
end
function suitDetailPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function suitDetailPopViewPanel:onInit()
	print("=======suitDetailPopViewPanel:onInit")
	_ENV, self.attrList, _ENV, self.suitList, _ENV, self.cellList, _ENV = print, print, print, print, print, print, print
	print[1] = "suit_text_02"
	print[2] = "suit_text_03"
	self.suitLangCfg, print[3] = print, "suit_text_04"
	self.fields.Panel_bg:setString(i18n("common_text_059"))
	self.fields.txt_curTitle:setString(i18n("common_text_4345"))
	self.fields.txt_attrTitle:setString(string.format("%s %s", i18n("suit_title_01"), i18n("common_btn_07")))
	self.fields.List_suitCell:setItemRenderer(handler(self, self.onCellRenderer))
	self.fields.List_suitInfo:setItemRenderer(handler(self, self.onSuitRenderer))
	self.fields.List_suitAttr:setItemRenderer(handler(self, self.onAttrRenderer))
end
function suitDetailPopViewPanel:onShow()
	print("=======suitDetailPopViewPanel:onShow")
	self.suitTag = self.param.suitTag
	self.eid = self.param.eid
	if self.eid then
		local equipInfo = equipmentltCtrl.getEquipCfg(self.eid)
		if equipInfo then
			self.suitTag = equipInfo.suitequipID
			self:initData()
		end
	else
		self:initData()
	end
end
function suitDetailPopViewPanel:initData()
	local suitList = equipDesRead.getSuitInfoList()
	self.tabelBaseList = equipmentMgr:getEquipmentArray()
	self.cellList = suitList[self.suitTag]
	self.fields.List_suitCell:setNumItems(#self.cellList)
	local equipDesRead, qualityTable = self.fields.List_suitCell.setNumItems, self.fields.List_suitCell.setNumItems
	for i = 1, #self.cellList do
		for j = 1, #self.tabelBaseList do
			if self.tabelBaseList[j]:getEID() == self.cellList[i].equipid and self.tabelBaseList[j]:isWearing() then
				local quality = 0
				if quality < self.tabelBaseList[j]:getEquipmentQuality() then
					quality = self.tabelBaseList[j]:getEquipmentQuality()
				end
				table.insert(qualityTable, quality)
			end
		end
	end
	table.sort(qualityTable, function(a, b)
		return b < a
	end)
	self.suitList, equipDesRead = table.sort, table.sort
	local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(self.suitTag)
	for i = 1, 3 do
		if qualityTable[i * 2] then
			local showStr = equipDesRead.getSuitpropertyDes(suitResultInfo["SuitpropertyType" .. i], suitResultInfo["SuitpropertyValue" .. i][qualityTable[i * 2] + 1])
			equipDesRead = qualityTable[i * 2] + 1
			;(qualityTable[i * 2] + 1).title = string.format("%s %s +%s", i18n(self.suitLangCfg[i]), equipDesRead.getAttrName(suitResultInfo["SuitpropertyType" .. i]), showStr)
			;(qualityTable[i * 2] + 1).icon = equipDesRead.getBg(qualityTable[i * 2])
			;(qualityTable[i * 2] + 1).color = gQualityTextColorDef[qualityTable[i * 2]]
			table.insert(self.suitList, qualityTable[i * 2] + 1)
		else
			equipDesRead = self.suitList
			self.suitList.title = string.format("%s %s", i18n(self.suitLangCfg[i]), equipDesRead.getAttrName(suitResultInfo["SuitpropertyType" .. i]))
			self.suitList.color = cc.c3b(120, 120, 120)
			table.insert(self.suitList, self.suitList)
		end
	end
	self.fields.List_suitInfo:setNumItems(#self.suitList)
	self.attrList, equipDesRead = self.fields.List_suitInfo.setNumItems, self.fields.List_suitInfo.setNumItems
	local equipDesRead, valueTable = self.fields.List_suitInfo.setNumItems, self.fields.List_suitInfo.setNumItems
	local equipNum = 0
	for i, v in ipairs(self.cellList) do
		local partList = equipmentltCtrl.getSuitPartList(i, v.equipid)
		equipNum = #partList
	end
	for i = 1, 3 do
		local equipDesRead, varList = self.suitList, self.suitList
		for j = 1, equipNum do
			local val = equipDesRead.getSuitpropertyDes(suitResultInfo["SuitpropertyType" .. i], suitResultInfo["SuitpropertyValue" .. i][j])
			if SoraDFIsRA() then
				varList[equipNum - j + 1] = fguiHelper.getColorString(SoraDRGB2HtmlColor(gQualityTextColorDef[j - 1]), val)
			else
				varList[j] = fguiHelper.getColorString(SoraDRGB2HtmlColor(gQualityTextColorDef[j - 1]), val)
			end
		end
		if SoraDFIsRA() then
			valueTable[i] = table.concat(varList, "/") .. "+"
		else
			valueTable[i] = "+" .. table.concat(varList, "/")
		end
	end
	for i = 1, 3 do
		equipDesRead = table.concat(varList, "/")
		table.concat(varList, "/").name = string.format("%s %s", i18n(self.suitLangCfg[i]), equipDesRead.getAttrName(suitResultInfo["SuitpropertyType" .. i]))
		table.concat(varList, "/").value = valueTable[i]
		table.insert(self.attrList, (table.concat(varList, "/")))
	end
	self.fields.List_suitAttr:setNumItems(#self.attrList)
end
function suitDetailPopViewPanel:onCellRenderer(index, obj)
	local isMatch = false
	for j = 1, #self.tabelBaseList do
		if self.tabelBaseList[j]:getEID() == self.cellList[index + 1].equipid and self.tabelBaseList[j]:isWearing() then
			local quality = 0
			if quality < self.tabelBaseList[j]:getEquipmentQuality() then
				quality = self.tabelBaseList[j]:getEquipmentQuality()
			end
			isMatch = true
		end
	end
	obj:initDataSp(self.cellList[index + 1], isMatch)
end
function suitDetailPopViewPanel:onSuitRenderer(index, obj)
	obj:initData(self.suitList[index + 1])
end
function suitDetailPopViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
return suitDetailPopViewPanel
