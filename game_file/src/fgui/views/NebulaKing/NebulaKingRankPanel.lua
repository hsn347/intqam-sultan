local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
local nebulaKingRead = include("nebulaKingRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaKingRankPanel = class("NebulaKingRankPanel", baseFguiPanel)
function NebulaKingRankPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaKingRankPanel:ctor", self.viewName)
	self.stageRankList, _ENV, self.stageRank, _ENV = print, print, print, print
	self.totalRankList, _ENV, self.totalRnak = print, print, false
	self.tabIndex = 1
	self.tabIndex1 = 1
	self.tabStageIndex = 1
	self.totalRankRewardList, _ENV, self.stageRankRewardList, _ENV, self.showStage = print, print, print, print, nil
end
function NebulaKingRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaKingRankPanel:onInit()
	print("=======NebulaKingRankPanel:onInit")
	self.fields.Com_title:initData(i18n("Nebulaking_title_03"), handler(self, self.onClickClose))
	local defaultTab = 1
	if nebulaKingCtrl:isActivityOpen() then
		self.showStage = nebulaKingCtrl:getCurrentStage()
	else
		_ENV = handler(self, self.onClickClose)
		_ENV, _ENV, handler(self, self.onClickClose).defaultClick = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = "1"
		_ENV, handler(self, self.onClickClose)[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = "2"
		_ENV, handler(self, self.onClickClose)[2], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = "3"
		_ENV, handler(self, self.onClickClose)[3], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = "4"
		_ENV, handler(self, self.onClickClose)[4], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
		handler(self, self.onClickClose).title = "5"
		handler(self, self.onClickClose).tabsetArray, handler(self, self.onClickClose)[5], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
		handler(self, self.onClickClose).callback = handler(self, self.onClickTabStage)
		self.fields.Com_tabStage:initView(handler(self, self.onClickClose))
		defaultTab = 2
	end
	_ENV = handler(self, self.onClickClose)
	_ENV, _ENV, handler(self, self.onClickClose).defaultClick = self, handler(self, self.onClickTabStage), defaultTab
	self.title = i18n("Nebulaking_title_04")
	_ENV, handler(self, self.onClickTabStage)[1], self.tag = self, self, 1
	self.title = i18n("Nebulaking_title_05")
	handler(self, self.onClickClose).tabsetArray, handler(self, self.onClickTabStage)[2], self.tag = handler(self, self.onClickTabStage), self, 2
	handler(self, self.onClickClose).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(handler(self, self.onClickClose))
	_ENV = handler(self, self.onClickClose)
	_ENV, _ENV, handler(self, self.onClickClose).defaultClick = self, handler(self, self.onClickTab), 1
	self.title = i18n("Nebulaking_title_06")
	_ENV, handler(self, self.onClickTab)[1], self.tag = self, self, 1
	self.title = i18n("common_text_1875")
	handler(self, self.onClickClose).tabsetArray, handler(self, self.onClickTab)[2], self.tag = handler(self, self.onClickTab), self, 2
	handler(self, self.onClickClose).callback = handler(self, self.onClickTab1)
	self.fields.Com_tab1:initView(handler(self, self.onClickClose))
	if nebulaKingCtrl:isActivityOpen() then
		self.showStage = nebulaKingCtrl:getCurrentStage()
	else
		_ENV = handler(self, self.onClickClose)
		_ENV, _ENV, handler(self, self.onClickClose).defaultClick = self, handler(self, self.onClickTab1), 1
		self.title = "1"
		_ENV, handler(self, self.onClickTab1)[1], self.tag = self, self, 1
		self.title = "2"
		_ENV, handler(self, self.onClickTab1)[2], self.tag = self, self, 2
		self.title = "3"
		_ENV, handler(self, self.onClickTab1)[3], self.tag = self, self, 3
		self.title = "4"
		_ENV, handler(self, self.onClickTab1)[4], self.tag = self, self, 4
		self.title = "5"
		handler(self, self.onClickClose).tabsetArray, handler(self, self.onClickTab1)[5], self.tag = handler(self, self.onClickTab1), self, 5
		handler(self, self.onClickClose).callback = handler(self, self.onClickTabStage)
		self.fields.Com_tabStage:initView(handler(self, self.onClickClose))
	end
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardRenderer))
end
function NebulaKingRankPanel:onClickTab(index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self:updateUI()
end
function NebulaKingRankPanel:onClickTab1(index)
	if self.tabIndex1 == index then
		return
	end
	self.tabIndex1 = index
	self:updateUI()
end
function NebulaKingRankPanel:onClickTabStage(index)
	if self.tabStageIndex == index then
		return
	end
	self.tabStageIndex = index
	self:updateUI()
end
function NebulaKingRankPanel:isShowRank()
	if self.tabIndex == 1 and nebulaKingCtrl:isActivityCalc() then
		return true
	end
	return self.tabIndex1 == 1
end
function NebulaKingRankPanel:getShowStage()
	return self.showStage or self.tabStageIndex
end
function NebulaKingRankPanel:onRankItemRenderer(index, obj)
	local data
	if self.tabIndex == 1 then
		data = self.stageRankList[index + 1]
	else
		data = self.totalRankList[index + 1]
	end
	obj:initData(data)
end
function NebulaKingRankPanel:onRewardRenderer(index, obj)
	if self.tabIndex == 1 then
		local data = self.stageRankRewardList[index + 1]
		obj:initData(data)
	else
		local data = self.totalRankRewardList[index + 1]
		obj:initData(data)
	end
end
function NebulaKingRankPanel:onShow()
	print("=======NebulaKingRankPanel:onShow")
	self:updateUI()
end
function NebulaKingRankPanel:updateUI()
	self.controllers.c1:setSelectedIndex(self:isShowRank() and 0 or 1)
	if self.tabIndex == 2 or self.showStage then
		self.fields.Com_tab1:setVisible(true)
		self.fields.Com_tabStage:setVisible(false)
	else
		self.fields.Com_tab1:setVisible(false)
		self.fields.Com_tabStage:setVisible(true)
	end
	if self:isShowRank() then
		self:updateRankList()
	else
		self:updateRewardList()
	end
end
function NebulaKingRankPanel:updateRankList()
	local nebulaKingCtrl, myInfo
	local curStage = self:getShowStage()
	if self.tabIndex == 1 then
		if not self.stageRank[curStage] then
			self.stageRank[curStage] = true
			nebulaKingCtrl:sendReqStageRank(curStage)
			self.fields.List_rank:setNumItems(0)
		else
			self.stageRankList = nebulaKingCtrl:getStageRank(curStage)
			self.fields.List_rank:setNumItems(#self.stageRankList)
			myInfo = nebulaKingCtrl:getMyStageRankInfo(curStage)
		end
	elseif not self.totalRnak then
		self.totalRnak = true
		nebulaKingCtrl:sendReqTotalRank()
		self.fields.List_rank:setNumItems(0)
	else
		self.totalRankList = nebulaKingCtrl:getTotalRank()
		self.fields.List_rank:setNumItems(#self.totalRankList)
		myInfo = nebulaKingCtrl:getMyTotalRankInfo()
	end
	if myInfo.rank then
		self.fields.Com_myRank:setVisible(true)
		self.fields.Com_myRank:initData(myInfo)
	else
		self.fields.Com_myRank:setVisible(false)
	end
end
function NebulaKingRankPanel:updateRewardList()
	print("NebulaKingRankPanel:updateRewardList", self.tabIndex, self.tabIndex1)
	if self.tabIndex == 1 then
		self.stageRankRewardList = nebulaKingCtrl:getStageRankReward(self:getShowStage())
		self.fields.List_reward:setNumItems(#self.stageRankRewardList)
	else
		self.totalRankRewardList = nebulaKingCtrl:getTotalRankReward()
		self.fields.List_reward:setNumItems(#self.totalRankRewardList)
	end
	print("list count", self.fields.List_reward:getNumItems())
end
function NebulaKingRankPanel:onStageRank(stage)
	self.stageRank[stage] = true
	if self.tabIndex == 1 and self:isShowRank() and stage == self:getShowStage() then
		self:updateRankList()
	end
end
function NebulaKingRankPanel:onTotalRank(data)
	self.totalRnak = true
	if self.tabIndex == 2 and self.tabIndex1 == 1 then
		self:updateRankList()
	end
end
return NebulaKingRankPanel
