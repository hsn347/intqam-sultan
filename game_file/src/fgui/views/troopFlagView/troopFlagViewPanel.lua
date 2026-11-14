local armyCtrl = SoraDGetCtrl("armyCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local buildLogic = include("buildLogic")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local troopFlagViewPanel = class("troopFlagViewPanel", baseFguiPanel)
function troopFlagViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("troopFlagViewPanel:ctor", self.viewName)
end
function troopFlagViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function troopFlagViewPanel:onInit()
	print("=======troopFlagViewPanel:onInit")
	self.tArmys, _ENV, self.tBtns, _ENV = print, print, print, print
	self.fields.Com_title:initData(i18n("buildDes_name_109"), handler(self, self.onClickClose))
	self.fields.List_troops:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_army:setString(i18n("common_text_1507"))
	self.fields.Text_march:setString(i18n("common_text_585"))
	self.fields.Text_wound:setString(i18n("common_text_587"))
	self.fields.List:setItemRenderer(handler(self, self.onArmyRenderer))
	self.fields.Text_army:fixPos()
	self.fields.Text_march:fixPos()
	self.fields.Text_wound:fixPos()
end
function troopFlagViewPanel:onShow()
	print("=======troopFlagViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:renameFunc()
	self:initDetail()
	self:initData()
end
function troopFlagViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tBtns[index + 1])
end
function troopFlagViewPanel:onArmyRenderer(index, obj)
	obj:initData(self.tArmys[index + 1])
end
function troopFlagViewPanel:initData()
	self.tArmys, queueCtrl = nil, nil
	self.promoteQueue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	if self.promoteQueue then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.PromoteQueue:initData(self.promoteQueue)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.tArmys[1], queueCtrl = self.controllers.c1, self.controllers.c1
	queueCtrl = nil
	;(nil).have = string.formatnumberthousands(armyCtrl:getInnerCityNormalArmy())
	self.tArmys[1].title = i18n("common_text_1166", nil)
	local armyList = armyCtrl:getArmyList()
	local queueCtrl, armyData = armyCtrl, armyCtrl
	local queueCtrl, armyTypeList = "common_text_1166", "common_text_1166"
	for k, v in pairs(armyList) do
		local aid = tonumber(k) % 1000
		local aType = armyLogic.getArmyTypeByID(aid)
		if not armyTypeList[aType] then
			armyTypeList[aType], queueCtrl = armyTypeList[aType], armyTypeList[aType]
		end
		queueCtrl = armyCtrl:getInnerCityNormalArmy()
		armyCtrl:getInnerCityNormalArmy().id = tonumber(k)
		armyCtrl:getInnerCityNormalArmy().num = v
		table.insert(armyTypeList[aType], armyCtrl:getInnerCityNormalArmy())
	end
	for aType, data in pairs(armyTypeList) do
		queueCtrl = table.insert
		table.insert.aType = aType
		table.insert.list = data
		table.insert(armyData, table.insert)
	end
	table.sort(armyData, function(a, b)
		return a.aType < b.aType
	end)
	self.tArmys[1].data = armyData
	self.tArmys[2], queueCtrl = armyData, armyData
	self.tArmys[2].title = i18n("common_text_1508") .. string.formatnumberthousands(armyCtrl:getTrapTotalCount())
	self.tArmys[2].isTrap = true
	local trapList = armyCtrl:getTrapList()
	local queueCtrl, trapData = armyCtrl, armyCtrl
	local queueCtrl, trapTypeList = string.formatnumberthousands(armyCtrl:getTrapTotalCount()), string.formatnumberthousands(armyCtrl:getTrapTotalCount())
	for k, v in pairs(trapList) do
		local aid = tonumber(k) % 1000
		local aType = armyLogic.getArmyTypeByID(aid)
		if not trapTypeList[aType] then
			trapTypeList[aType], queueCtrl = trapTypeList[aType], trapTypeList[aType]
		end
		queueCtrl = armyCtrl:getTrapTotalCount()
		armyCtrl:getTrapTotalCount().id = tonumber(k)
		armyCtrl:getTrapTotalCount().num = v
		table.insert(trapTypeList[aType], armyCtrl:getTrapTotalCount())
	end
	for aType, data in pairs(trapTypeList) do
		queueCtrl = table.insert
		table.insert.aType = aType
		table.insert.list = data
		table.insert(trapData, table.insert)
	end
	table.sort(trapData, function(a, b)
		return a.aType < b.aType
	end)
	self.tArmys[2].data = trapData
	self.fields.List:setNumItems(#self.tArmys)
end
function troopFlagViewPanel:refreshData()
	self:initDetail()
	self:initData()
end
function troopFlagViewPanel:initDetail()
	self.fields.Text_armyNum:setString(string.formatnumberthousands(armyCtrl:getTotalArmyCount()))
	local totalTroop = buildLogic.getExpQueueCount().total
	local outSideTroop = kingdomMapCtrl:isHasQueue()
	self.fields.Text_marchNum:setString(string.formatnumberthousands(outSideTroop) .. "/" .. string.formatnumberthousands(totalTroop))
	self.fields.Text_woundNum:setString(string.formatnumberthousands(armyCtrl:getTotalWoundedArmyCount()) .. "/" .. string.formatnumberthousands(armyLogic.getHostpitalMaxCapacity().total))
	self.fields.Text_armyNum:fixPos()
	self.fields.Text_marchNum:fixPos()
	self.fields.Text_woundNum:fixPos()
end
function troopFlagViewPanel:renameFunc()
	self.tBtns, _ENV = nil, nil
	for i = 1, 4 do
		table.insert(self.tBtns, i)
	end
	if exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.ARMY_COMPILE_LIMIT) then
		local totalNum = armyCtrl:getArmyCompileCount()
		for i = 5, totalNum do
			table.insert(self.tBtns, i)
		end
	end
	self.fields.List_troops:setNumItems(#self.tBtns)
	self.fields.List_troops:resizeToFit(#self.tBtns)
end
return troopFlagViewPanel
