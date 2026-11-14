local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentMgr = include("equipmentMgr")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local suitInfoViewPanel = class("suitInfoViewPanel", baseFguiPanel)
function suitInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("suitInfoViewPanel:ctor", self.viewName)
end
function suitInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function suitInfoViewPanel:onInit()
	print("=======suitInfoViewPanel:onInit")
	self.attrList, _ENV, self.suitList, _ENV = print, print, print, print
	self.fields.Com_title:initData(i18n("suit_title_01"), handler(self, self.onClickClose))
	self.fields.btn_detail:addClickListener(handler(self, self.btnDetailClick))
	self.fields.List_show:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_suitAttr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onSuitRenderer))
end
function suitInfoViewPanel:onItemRenderer(index, obj)
	obj:initData(self.suitList[index + 1], true)
end
function suitInfoViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrList[index + 1])
end
function suitInfoViewPanel:onSuitRenderer(index, obj)
	obj:initData(self.suitList[index + 1], index + 1)
end
function suitInfoViewPanel:onShow()
	print("=======suitInfoViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.suitTag = self.param.suitTag
	local suitName, propertyName = equipDesRead.getSuitTendencyByID(self.suitTag)
	self.fields.txt_suitTitle:setString(i18n(suitName))
	local suitList = equipDesRead.getSuitInfoList()
	self.suitList = suitList[self.suitTag]
	self:initData()
end
function suitInfoViewPanel:initData()
	self.fields.List_show:setNumItems(#self.suitList)
	self.attrList, equipmentltCtrl = self.fields.List_show.setNumItems, self.fields.List_show.setNumItems
	local suitResultInfo = equipmentltCtrl.getSuitsResultInfoByID(self.suitTag)
	local equipmentltCtrl, valueTable = self.suitTag, self.suitTag
	local equipNum = 0
	for i, v in ipairs(self.suitList) do
		local partList = equipmentltCtrl.getSuitPartList(i, v.equipid)
		equipNum = #partList
	end
	for i = 1, 3 do
		local equipmentltCtrl, varList
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
	equipmentltCtrl = 3
	;(3).name = string.format("%s %s", i18n("suit_text_02"), equipDesRead.getAttrName(suitResultInfo.SuitpropertyType1))
	self.attrList[1], (3).value = 3, valueTable[1]
	equipmentltCtrl = 3
	;(3).name = string.format("%s %s", i18n("suit_text_03"), equipDesRead.getAttrName(suitResultInfo.SuitpropertyType2))
	self.attrList[2], (3).value = 3, valueTable[2]
	equipmentltCtrl = 3
	;(3).name = string.format("%s %s", i18n("suit_text_04"), equipDesRead.getAttrName(suitResultInfo.SuitpropertyType3))
	self.attrList[3], (3).value = 3, valueTable[3]
	self.fields.List_suitAttr:setNumItems(#self.attrList)
	self.fields.List:setNumItems(#self.suitList)
end
function suitInfoViewPanel:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).suitTag = self.suitTag
	uiManager:show("suitDetailPopView", nil)
end
return suitInfoViewPanel
