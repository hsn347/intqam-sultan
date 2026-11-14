local castleSkinRead = include("castleSkinRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CastleChangeviewScreenPanel = class("CastleChangeviewScreenPanel", baseFguiPanel)
function CastleChangeviewScreenPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CastleChangeviewScreenPanel:ctor", self.viewName)
end
function CastleChangeviewScreenPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CastleChangeviewScreenPanel:onInit()
	print("=======CastleChangeviewScreenPanel:onInit")
	self.fields.title:setString(i18n("skin_text_25"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function CastleChangeviewScreenPanel:onShow()
	print("=======CastleChangeviewScreenPanel:onShow")
	self.curGroupId = self.param.groupId
	self.cfgList, _ENV, self.curTableData = self.param.curTableData, self.param.curTableData, self.param.curTableData
	local cfgList = castleSkinRead.getGroupCfg(self.param.tab)
	local _ENV, tmpCfgList = self.param.tab, self.param.tab
	for k, v in ipairs(cfgList) do
		if self:isHaveData(v.groupId) then
			table.insert(tmpCfgList, v)
		end
	end
	_ENV = nil
	;(nil).type = self.param.tab
	;(nil).Index = 0
	;(nil).groupId = 0
	;(nil).groupName = "common_text_635"
	table.insert(tmpCfgList, 1, nil)
	table.sort(tmpCfgList, function(a, b)
		return a.Index < b.Index
	end)
	for i = 1, #tmpCfgList, 2 do
		_ENV = tmpCfgList
		tmpCfgList.choose1 = tmpCfgList[i]
		tmpCfgList.choose2 = tmpCfgList[i + 1]
		table.insert(self.cfgList, tmpCfgList)
	end
	self.fields.list:setNumItems(#self.cfgList)
end
function CastleChangeviewScreenPanel:isHaveData(groupId)
	local ret = false
	for k, v in ipairs(self.curTableData) do
		local group = castleSkinRead.getDressGroupBySubType(v.subType)
		if group == groupId then
			ret = true
			break
		end
	end
	return ret
end
function CastleChangeviewScreenPanel:onItemRenderer(index, obj)
	obj:initData(self.cfgList[index + 1], self.curGroupId)
end
function CastleChangeviewScreenPanel:updateView(target, data)
	self.curGroupId = data.groupId
	self.fields.list:setNumItems(#self.cfgList)
end
return CastleChangeviewScreenPanel
