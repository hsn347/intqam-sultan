local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local collegeDesRead = include("collegeDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorTechPandectPanel = class("ManorTechPandectPanel", baseFguiPanel)
function ManorTechPandectPanel:ctor(...)
	self.isLRU = true
	ManorTechPandectPanel.super.ctor(self, ...)
	print("ManorTechPandectPanel:ctor", self.viewName)
end
function ManorTechPandectPanel:onInit()
	print("=======ManorTechPandectPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("magic_lamp_title_09"))
	self.fields.Text_none:setString(i18n("hero_appoint_11"))
	self.fields.Text_none:setVisible(false)
end
function ManorTechPandectPanel:endShow()
	print("=======ManorTechPandectPanel:endShow")
	local techData = technologyCtrl:getTechnologyDataByType("manor")
	local _ENV, ret = technologyCtrl, technologyCtrl
	for _, v in pairs(techData) do
		if v.isOpened and v.currentLevel > 0 then
			local cfg = collegeDesRead.getTechBuffCfg(tonumber(v.technologyID), v.currentLevel)
			if not ret[cfg.buffType] then
				ret[cfg.buffType] = cfg
			else
				ret[cfg.buffType].powerNum = ret[cfg.buffType].powerNum + cfg.powerNum
			end
		end
	end
	dump(ret, "ret==========")
	self.attrData, _ENV = dump, dump
	local _ENV, attrList1 = dump, dump
	for _, v in pairs(ret) do
		if SoraDisInList(1, v.battle) then
			table.insert(attrList1, v)
		end
	end
	table.sort(attrList1, function(a, b)
		return a.buffType < b.buffType
	end)
	function _ENV(a, b)
		return a.buffType < b.buffType
	end
	;(function(a, b)
		return a.buffType < b.buffType
	end).attrList = attrList1
	table.insert(self.attrData, function(a, b)
		return a.buffType < b.buffType
	end)
	self.fields.List:setNumItems(#self.attrData)
	self.fields.Text_none:setVisible(table.nums(ret) == 0)
end
function ManorTechPandectPanel:itemRenderer_List(index, obj)
	obj:initData(self.attrData[index + 1])
end
return ManorTechPandectPanel
