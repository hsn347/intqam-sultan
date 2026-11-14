local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorDressActiveNumPanel = class("ManorDressActiveNumPanel", baseFguiPanel)
function ManorDressActiveNumPanel:ctor(...)
	self.isLRU = true
	ManorDressActiveNumPanel.super.ctor(self, ...)
	print("ManorDressActiveNumPanel:ctor", self.viewName)
end
function ManorDressActiveNumPanel:onInit()
	print("=======ManorDressActiveNumPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("decoration_text_35"))
	local _fields = fguiHelper.get_fields(self.fields.Com_dressActiveTitle)
	_fields.Text_lv:setString(i18n("garden_btn_02"))
	self.dressQualityList = manorCityRead.getDressQualityList()
	for i, quality in ipairs(self.dressQualityList) do
		local Text_quality = _fields["Text_quality" .. i]
		local name = manorCityRead.getDressQualityName(quality)
		Text_quality:setString(name)
	end
	if not SoraDFIsRA() then
		self.fields.Com_dressActiveTitle:fixChildrenPos()
	end
end
function ManorDressActiveNumPanel:endShow()
	print("=======ManorDressActiveNumPanel:endShow")
	local allActiveNumInfo = manorCityRead.getDressActiveNumInfo()
	local gardenBuildLv = manorCityCtrl:getGardenBuildLv()
	local curActiveNumIdx = 1
	for idx, data in ipairs(allActiveNumInfo) do
		if gardenBuildLv < data.buildLv then
			break
		end
		curActiveNumIdx = idx
	end
	self.activeNumInfo, _ENV = ipairs(allActiveNumInfo)
	for idx = 1, math.min(curActiveNumIdx + 1, #allActiveNumInfo) do
		table.insert(self.activeNumInfo, allActiveNumInfo[idx])
	end
	self.curActiveNumIdx = curActiveNumIdx
	self.fields.List:setNumItems(#self.activeNumInfo)
end
function ManorDressActiveNumPanel:itemRenderer_List(index, obj)
	local data = self.activeNumInfo[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.imgWhite:setVisible(index % 2 == 0)
	_fields.imgLight:setVisible(index + 1 == self.curActiveNumIdx)
	_ENV = nil
	;(nil).lv = data.buildLv
	_fields.Text_lv:setString(i18n("common_text_2567", nil))
	local decoration = data.decoration
	for i, quality in ipairs(self.dressQualityList) do
		local Text_quality = _fields["Text_quality" .. i]
		local activeMax = decoration[quality] or 0
		Text_quality:setString(activeMax)
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
return ManorDressActiveNumPanel
