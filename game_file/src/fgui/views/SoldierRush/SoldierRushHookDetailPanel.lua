local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushHookDetailPanel = class("SoldierRushHookDetailPanel", baseFguiPanel)
function SoldierRushHookDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushHookDetailPanel:ctor", self.viewName)
end
function SoldierRushHookDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushHookDetailPanel:onInit()
	print("=======SoldierRushHookDetailPanel:onInit")
	self.curTag = 1
	self.fields.Panel_bg:setString(i18n("soldier_rush_text_112"))
	self.fields.Label_content:setString(i18n("soldier_rush_text_118"))
	self.fields.List_lv:setItemRenderer(handler(self, self.onLvRenderer))
	self.fields.List_extra:setItemRenderer(handler(self, self.onExtraRenderer))
	self.fields.List_gate:setItemRenderer(handler(self, self.onGateRenderer))
	self:setCfgInfo()
	_ENV = handler(self, self.onGateRenderer)
	_ENV, _ENV, handler(self, self.onGateRenderer).defaultClick = handler(self, self.onGateRenderer)
	handler(self, self.onGateRenderer).title = i18n("soldier_rush_text_119")
	_ENV, self.curTag[1], handler(self, self.onGateRenderer).tag = handler(self, self.onGateRenderer)
	handler(self, self.onGateRenderer).title = i18n("soldier_rush_text_115")
	handler(self, self.onGateRenderer).tabsetArray, self.curTag[2], handler(self, self.onGateRenderer).tag = self.curTag, handler(self, self.onGateRenderer)
	handler(self, self.onGateRenderer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onGateRenderer))
end
function SoldierRushHookDetailPanel:onLvRenderer(index, obj)
	obj:initData(self.castleList[index + 1], index + 1)
end
function SoldierRushHookDetailPanel:onExtraRenderer(index, obj)
	obj:initData(self.extraTable[index + 1], self.curLevelID)
end
function SoldierRushHookDetailPanel:onGateRenderer(index, obj)
	obj:initData(self.gateTable[index + 1], index + 1, self.curLevelID)
end
function SoldierRushHookDetailPanel:setCfgInfo()
	self.fields.Text_extra:setString(i18n("soldier_rush_text_121"))
	self.fields.Text_bonus:setString(i18n("soldier_rush_text_123"))
	local cfgList = soldierRushRead.getCastleBonusList()
	self.castleList, _ENV = self.fields.Text_bonus, self.fields.Text_bonus
	local lineNum = math.ceil(#cfgList / 3)
	for i = 1, lineNum do
		if SoraDFIsRA() then
			_ENV, _ENV = i18n("soldier_rush_text_123")
			i18n("soldier_rush_text_123").lv = i
			_ENV, i18n("soldier_rush_text_123").cfg1, i18n("soldier_rush_text_123").bonus = i18n("soldier_rush_text_123")
			i18n("soldier_rush_text_123").lv = i + lineNum
			_ENV, i18n("soldier_rush_text_123").cfg2, i18n("soldier_rush_text_123").bonus = i18n("soldier_rush_text_123")
			i18n("soldier_rush_text_123").lv = i + lineNum * 2
			i18n("soldier_rush_text_123").cfg3, i18n("soldier_rush_text_123").bonus = i18n("soldier_rush_text_123")
			table.insert(self.castleList, i18n("soldier_rush_text_123"))
		else
			_ENV, _ENV = i18n("soldier_rush_text_123")
			i18n("soldier_rush_text_123").lv = i + lineNum * 2
			_ENV, i18n("soldier_rush_text_123").cfg1, i18n("soldier_rush_text_123").bonus = i18n("soldier_rush_text_123")
			i18n("soldier_rush_text_123").lv = i + lineNum
			_ENV, i18n("soldier_rush_text_123").cfg2, i18n("soldier_rush_text_123").bonus = i18n("soldier_rush_text_123")
			i18n("soldier_rush_text_123").lv = i
			i18n("soldier_rush_text_123").cfg3, i18n("soldier_rush_text_123").bonus = i18n("soldier_rush_text_123")
			table.insert(self.castleList, i18n("soldier_rush_text_123"))
		end
	end
	self.fields.List_lv:setNumItems(#self.castleList)
	self.extraList = soldierRushRead.getTerritoryIncomeList()
	self.gateTable, _ENV, self.extraTable, _ENV, self.curLevelID = soldierRushRead.getTerritoryIncomeList(), soldierRushRead.getTerritoryIncomeList(), soldierRushRead.getTerritoryIncomeList(), soldierRushRead.getTerritoryIncomeList(), nil
	for k, v in ipairs(self.extraList) do
		if soldierRushCtrl:getGateRecord(v.LevelID) then
			self.curLevelID = v.LevelID
		end
		if next(v.ResourceShow) then
			table.insert(self.extraTable, v)
		end
		if next(v.RewardShow) then
			table.insert(self.gateTable, v)
		end
	end
	self.fields.List_extra:setNumItems(#self.extraTable)
	self.fields.List_gate:setNumItems(#self.gateTable)
end
function SoldierRushHookDetailPanel:onShow()
	print("=======SoldierRushHookDetailPanel:onShow")
end
function SoldierRushHookDetailPanel:onClickTab(index)
	if self.curTag == index then
		return
	end
	self.curTag = index
	self.controllers.c1:setSelectedIndex(self.curTag - 1)
	self.fields.Text_bonus:setString(self.curTag == 1 and i18n("soldier_rush_text_123") or i18n("soldier_rush_text_126"))
end
return SoldierRushHookDetailPanel
