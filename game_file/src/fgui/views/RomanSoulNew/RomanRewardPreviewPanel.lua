local romeActivityltCtrl = include("romeActivityltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RomanRewardPreviewPanel = class("RomanRewardPreviewPanel", baseFguiPanel)
function RomanRewardPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.isHideCurrentSceneView = true
	print("RomanRewardPreviewPanel:ctor", self.viewName)
end
function RomanRewardPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RomanSoulNew"
		self._packageList, self._packageList[2] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[3] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function RomanRewardPreviewPanel:onInit()
	self.fields.Text_point:fixPos()
	self.fields.Button_help:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Usm_beijing:setBlendFunc(gl.ONE, gl.ONE)
	print("=======RomanRewardPreviewPanel:onInit")
	self.fields.Text_tip:setString(i18n("common_text_1233"))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Com_title:initData(i18n("decrypt_text_03"), handler(self, self.close))
	_ENV, _UPVALUE3_, self.onClickTab = self.fields.Com_title, function(index)
		self:setTab(index)
	end, function(index)
		self:setTab(index)
	end
	self.fields.Com_title.tag = 1
	self.fields.Com_title.title = i18n("common_text_1469")
	_ENV, self.fields.Com_title.handle = self.onClickTab, self.onClickTab
	self.onClickTab.tag = 2
	self.onClickTab.title = i18n("common_text_1231")
	_ENV, self.onClickTab.handle = self.onClickTab, self.onClickTab
	self.onClickTab.tag = 3
	self.onClickTab.title = i18n("common_text_2713")
	self.onClickTab.handle = self.onClickTab
	self.tabTitle, (function(index)
		self:setTab(index)
	end)[1] = function(index)
		self:setTab(index)
	end, self.fields.Com_title
	self.tabTitle, (function(index)
		self:setTab(index)
	end)[2] = function(index)
		self:setTab(index)
	end, self.onClickTab
	self.tabTitle, (function(index)
		self:setTab(index)
	end)[3] = function(index)
		self:setTab(index)
	end, self.onClickTab
	self.fields.List_tab:setItemRenderer(handler(self, self.onItemRendererTab))
	self.fields.List_tab:setNumItems(table.nums(self.tabTitle))
	self:initData()
end
function RomanRewardPreviewPanel:initData()
	self:setTab(1)
end
function RomanRewardPreviewPanel:setTab(index)
	self.controllers.state:setSelectedIndex(index - 1)
	for i = 1, 3 do
		if i == index then
			self.fields.List_tab:getChildAt(i - 1):setMask(false)
			self.fields.List_tab:getChildAt(i - 1):setTitleColor(cc.c3b(255, 245, 175))
		else
			self.fields.List_tab:getChildAt(i - 1):setMask(true)
			self.fields.List_tab:getChildAt(i - 1):setTitleColor(cc.c3b(144, 132, 97))
		end
	end
	self.rankData, _ENV, self.isAlliance = index == 2 and true or false, index == 2 and true or false, index == 2 and true or false
	if self.isAlliance then
		self.rankData = romeActivityltCtrl.getWholeRomeActivityAllRankReward(romeActivityCtrl.serverLv)
		self.fields.Com_alliance:initData(self.rankData)
		self:setLordInfo(self.isAlliance)
	else
		if index == 1 then
			self.rankData = romeActivityltCtrl.getWholeRomeActivityMemRankReward(romeActivityCtrl.serverLv)
			self.fields.List_rank:setItemRenderer(handler(self, self.onItemRendererPersonal))
			self.fields.List_rank:setNumItems(table.nums(self.rankData))
			self.fields.List_rank:scrollToView(0)
		else
			self.fields.Com_history:initData()
		end
		self:setLordInfo(self.isAlliance)
	end
end
function RomanRewardPreviewPanel:setLordInfo(isAlliance)
	if isAlliance then
		_ENV = nil
		;(nil).num = romeActivityCtrl.score
		self.fields.Text_point:setString(i18n("common_text_1492", nil))
		self.fields.Text_rank:setString(romeActivityCtrl.allianceRank == 0 and i18n("common_text_827") or romeActivityCtrl.allianceRank)
	else
		_ENV = i18n("common_text_1492", nil)
		i18n("common_text_1492", nil).num = romeActivityCtrl.memberscore
		self.fields.Text_point:setString(i18n("common_text_1256", i18n("common_text_1492", nil)))
		self.fields.Text_rank:setString(romeActivityCtrl.memberRank == 0 and i18n("common_text_827") or romeActivityCtrl.memberRank)
	end
end
function RomanRewardPreviewPanel:onItemRendererPersonal(index, object)
	object:initData(index + 1, self.rankData[index + 1], "person")
end
function RomanRewardPreviewPanel:onItemRendererTab(index, object)
	object:initData(index + 1, self.tabTitle[index + 1])
end
function RomanRewardPreviewPanel:setStageData(target, data)
	self:setLordInfo(false)
	self.fields.Com_history:setStageData(target, data)
end
function RomanRewardPreviewPanel:setTotalData(target, data)
	self:setLordInfo(true)
	self.fields.Com_history:setTotalData(target, data)
end
function RomanRewardPreviewPanel:allianceScollEnd(flag)
	if self.fields then
		self.fields.Com_alliance:showScrollIcon(flag)
	end
end
function RomanRewardPreviewPanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("RomanPointExplain"):setOwnerKey(self)
end
function RomanRewardPreviewPanel:onShow()
	print("=======RomanRewardPreviewPanel:onShow")
end
function RomanRewardPreviewPanel:onHide()
	print("=======RomanRewardPreviewPanel:onHide")
end
function RomanRewardPreviewPanel:onDispose()
	print("=======RomanRewardPreviewPanel:onDispose")
end
return RomanRewardPreviewPanel
