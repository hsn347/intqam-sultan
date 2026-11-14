local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorBuffPandectPanel = class("ManorBuffPandectPanel", baseFguiPanel)
function ManorBuffPandectPanel:ctor(...)
	self.isLRU = true
	ManorBuffPandectPanel.super.ctor(self, ...)
	print("ManorBuffPandectPanel:ctor", self.viewName)
end
function ManorBuffPandectPanel:onInit()
	print("=======ManorBuffPandectPanel:onInit")
	self.fields.Panel_bg:setString(i18n("magic_lamp_title_09"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function ManorBuffPandectPanel:endShow()
	print("=======ManorBuffPandectPanel:endShow")
	local buffDesRead = include("buffDesRead")
	local _ENV, ret = "buffDesRead", "buffDesRead"
	local _ENV, tableData
	local buildBuffMap = manorCityCtrl:getBuildBuffMap()
	local farmBookBuffMap = manorCityCtrl:getFarmBookBuffMap()
	local _ENV, _buffMap = manorCityCtrl, manorCityCtrl
	for buffId, buffValue in pairs(buildBuffMap) do
		_buffMap[buffId] = (_buffMap[buffId] or 0) + buffValue
	end
	for buffId, buffValue in pairs(farmBookBuffMap) do
		_buffMap[buffId] = (_buffMap[buffId] or 0) + buffValue
	end
	for buffId, buffValue in pairs(_buffMap) do
		_ENV = (_buffMap[buffId] or 0) + buffValue
		;(_buffMap[buffId] or 0) + buffValue.buffId = buffId
		;(_buffMap[buffId] or 0) + buffValue.title = buffDesRead.getTitleBase(buffId)
		local (_buffMap[buffId] or 0) + buffValue.value, data = buffDesRead.getTitleValueWithValue(buffId, buffValue), (_buffMap[buffId] or 0) + buffValue
		table.insert(tableData, data)
	end
	table.sort(tableData, function(a, b)
		return a.buffId < b.buffId
	end)
	function _ENV(a, b)
		return a.buffId < b.buffId
	end
	;(function(a, b)
		return a.buffId < b.buffId
	end).title = i18n("NebulaAllstar_136")
	;(function(a, b)
		return a.buffId < b.buffId
	end).power = manorCityCtrl:getBuildPower()
	;(function(a, b)
		return a.buffId < b.buffId
	end).tableData = tableData
	table.insert(ret, function(a, b)
		return a.buffId < b.buffId
	end)
	local collegeDesRead = include("collegeDesRead")
	local _ENV, tableData = "collegeDesRead", "collegeDesRead"
	local techBuffMap = manorCityCtrl:getGardenTechBuffMap()
	for __, cfg in pairs(techBuffMap) do
		local buffId = cfg.buffType
		_ENV = nil
		;(nil).buffId = buffId
		;(nil).title = collegeDesRead.getTechBuffDes(buffId)
		local (nil).value, data = collegeDesRead.getTechBuffValue(buffId, cfg.powerNum), nil
		table.insert(tableData, data)
	end
	table.sort(tableData, function(a, b)
		return a.buffId < b.buffId
	end)
	function _ENV(a, b)
		return a.buffId < b.buffId
	end
	;(function(a, b)
		return a.buffId < b.buffId
	end).title = i18n("garden_text_50")
	;(function(a, b)
		return a.buffId < b.buffId
	end).power = manorCityCtrl:getGardenTechPower()
	;(function(a, b)
		return a.buffId < b.buffId
	end).tableData = tableData
	table.insert(ret, function(a, b)
		return a.buffId < b.buffId
	end)
	local _ENV, tableData = table.insert, table.insert
	local dressBuffMap = manorCityCtrl:getDressBuffMap()
	for buffId, buffValue in pairs(dressBuffMap) do
		_ENV = table.insert
		table.insert.buffId = buffId
		table.insert.title = buffDesRead.getTitleBase(buffId)
		local table.insert.value, data = buffDesRead.getTitleValueWithValue(buffId, buffValue), table.insert
		table.insert(tableData, data)
	end
	table.sort(tableData, function(a, b)
		return a.buffId < b.buffId
	end)
	function _ENV(a, b)
		return a.buffId < b.buffId
	end
	;(function(a, b)
		return a.buffId < b.buffId
	end).title = i18n("garden_text_51")
	;(function(a, b)
		return a.buffId < b.buffId
	end).power = manorCityCtrl:getDressPower()
	;(function(a, b)
		return a.buffId < b.buffId
	end).tableData = tableData
	table.insert(ret, function(a, b)
		return a.buffId < b.buffId
	end)
	self.buffListData = ret
	self.fields.List:setNumItems(#self.buffListData)
end
function ManorBuffPandectPanel:itemRenderer_List(index, obj)
	local data = self.buffListData[index + 1]
	obj:initData(data)
end
return ManorBuffPandectPanel
