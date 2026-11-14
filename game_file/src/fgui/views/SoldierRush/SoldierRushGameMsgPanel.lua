local soldierRushRead = include("soldierRushRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushGameMsgPanel = class("SoldierRushGameMsgPanel", baseFguiPanel)
function SoldierRushGameMsgPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushGameMsgPanel:ctor", self.viewName)
end
function SoldierRushGameMsgPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushGameMsgPanel:onInit()
	print("=======SoldierRushGameMsgPanel:onInit")
	self.tabIndex = 1
	self.fields.Panel_bg:setString(i18n("soldier_rush_text_47"))
	_ENV = i18n("soldier_rush_text_47")
	_ENV, _ENV, i18n("soldier_rush_text_47").defaultClick = i18n("soldier_rush_text_47")
	i18n("soldier_rush_text_47").title = i18n("soldier_rush_build_1")
	_ENV, self.tabIndex[1], i18n("soldier_rush_text_47").tag = i18n("soldier_rush_text_47")
	i18n("soldier_rush_text_47").title = i18n("soldier_rush_build_2")
	_ENV, self.tabIndex[2], i18n("soldier_rush_text_47").tag = i18n("soldier_rush_text_47")
	i18n("soldier_rush_text_47").title = i18n("soldier_rush_build_3")
	_ENV, self.tabIndex[3], i18n("soldier_rush_text_47").tag = i18n("soldier_rush_text_47")
	i18n("soldier_rush_text_47").title = i18n("recharge_label_003")
	i18n("soldier_rush_text_47").tabsetArray, self.tabIndex[4], i18n("soldier_rush_text_47").tag = self.tabIndex, i18n("soldier_rush_text_47")
	i18n("soldier_rush_text_47").callback = handler(self, self.onClickTab)
	self.fields.Com_Tab:initView(i18n("soldier_rush_text_47"))
	_ENV = self.fields.Com_Tab.initView
	self.fields.Com_Tab.initView[1] = i18n("soldier_rush_text_39")
	self.fields.Com_Tab.initView[2] = i18n("soldier_rush_text_38")
	self.fields.Com_Tab.initView[3] = i18n("soldier_rush_text_40")
	self.tipCfg, self.fields.Com_Tab.initView[4] = self.fields.Com_Tab.initView, i18n("soldier_rush_text_68")
	self.fields.Text_shootRange:setString(i18n("soldier_rush_text_48"))
	self.fields.Text_shootSpeed:setString(i18n("soldier_rush_text_49"))
	self.fields.Text_upCost:setString(i18n("soldier_rush_text_50"))
	self.fields.Text_upCD:setString(i18n("soldier_rush_text_51"))
	self.fields.Text_upCost1:setString(i18n("soldier_rush_text_50"))
	self.fields.Text_upCD1:setString(i18n("soldier_rush_text_51"))
	self.fields.Text_maxLimit:setString(i18n("soldier_rush_text_52"))
	self.fields.Text_atkAdd:setString(i18n("cityeffect_name_02"))
	self.fields.Text_hpAdd:setString(i18n("common_text_2860"))
	self.fields.Text_castleLv:setString(i18n("common_text_4488"))
	self.fields.Text_armyLv:setString(i18n("common_text_2202"))
	self.fields.Text_hp:setString(i18n("common_text_147"))
	self.fields.Text_atk:setString(i18n("common_text_008"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixTarget()
end
function SoldierRushGameMsgPanel:fixTarget()
	self.fields.Text_shootRange:fixPos()
	self.fields.Text_shootSpeed:fixPos()
	self.fields.Text_upCost:fixPos()
	self.fields.Text_upCD:fixPos()
	self.fields.Text_upCost1:fixPos()
	self.fields.Text_upCD1:fixPos()
	self.fields.Text_maxLimit:fixPos()
	self.fields.Text_atkAdd:fixPos()
	self.fields.Text_hpAdd:fixPos()
	self.fields.Text_castleLv:fixPos()
	self.fields.Text_armyLv:fixPos()
	self.fields.Text_hp:fixPos()
	self.fields.Text_atk:fixPos()
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.line3:fixPos()
	self.fields.line4:fixPos()
	self.fields.line5:fixPos()
	self.fields.line6:fixPos()
	self.fields.line7:fixPos()
	self.fields.line8:fixPos()
	self.fields.line9:fixPos()
end
function SoldierRushGameMsgPanel:onItemRenderer(index, obj)
	obj:initData(self.buildList[index + 1], self.tabIndex - 1, index)
end
function SoldierRushGameMsgPanel:onShow()
	print("=======SoldierRushGameMsgPanel:onShow")
	self.buildList = soldierRushRead.getBuildCfgByType(self.tabIndex)
	self.fields.List:setNumItems(#self.buildList)
	self.fields.Text_tip:setString(self.tipCfg[self.tabIndex])
end
function SoldierRushGameMsgPanel:onClickTab(index)
	print("onClickTab=====", self.tabIndex, index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	if self.tabIndex == 4 then
		self.buildList = soldierRushRead.getShowArmyCfg()
		self.fields.List:setLineGap(-38)
	else
		self.buildList = soldierRushRead.getBuildCfgByType(self.tabIndex)
		self.fields.List:setLineGap(0)
	end
	self.fields.List:setNumItems(#self.buildList)
	self.fields.Text_tip:setString(self.tipCfg[self.tabIndex])
end
return SoldierRushGameMsgPanel
