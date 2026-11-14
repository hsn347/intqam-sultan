local activity_9001577_Ctrl = SoraDGetCtrl("activity_9001577_Ctrl")
local activity_9001577_Read = include("activity_9001577_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001577_RankPanel = class("Activity_9001577_RankPanel", baseFguiPanel)
function Activity_9001577_RankPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001577_RankPanel:ctor", self.viewName)
	self.stageRankList, _ENV, self.stageRank, _ENV = print, print, print, print
	self.totalRankList, _ENV, self.totalRnak = print, print, false
	self.tabIndex = 1
	self.tabIndex1 = 1
	self.tabStageIndex = 1
	self.totalRankRewardList, _ENV, self.stageRankRewardList, _ENV, self.showStage = print, print, print, print, nil
end
function Activity_9001577_RankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001577_RankPanel:onInit()
	print("=======Activity_9001577_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001577"), handler(self, self.onClickClose))
	self.fields.text_no_rank:setString(i18n("herobattle_text_05"))
	local defaultTab = 1
	_ENV = i18n("herobattle_text_05")
	_ENV, _ENV, i18n("herobattle_text_05").defaultClick = i18n("herobattle_text_05")
	i18n("herobattle_text_05").title = i18n("Nebulaking_title_04")
	_ENV, i18n("herobattle_text_05")[1], i18n("herobattle_text_05").tag = i18n("herobattle_text_05")
	i18n("herobattle_text_05").title = i18n("Nebulaking_title_05")
	i18n("herobattle_text_05").tabsetArray, i18n("herobattle_text_05")[2], i18n("herobattle_text_05").tag = i18n("herobattle_text_05")
	i18n("herobattle_text_05").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(i18n("herobattle_text_05"))
	_ENV = i18n("herobattle_text_05")
	_ENV, _ENV, i18n("herobattle_text_05").defaultClick = self, handler(self, self.onClickTab), 1
	self.title = i18n("Nebulaking_title_06")
	_ENV, handler(self, self.onClickTab)[1], self.tag = self, self, 1
	self.title = i18n("common_text_1875")
	i18n("herobattle_text_05").tabsetArray, handler(self, self.onClickTab)[2], self.tag = handler(self, self.onClickTab), self, 2
	i18n("herobattle_text_05").callback = handler(self, self.onClickTab1)
	self.fields.Com_tab1:initView(i18n("herobattle_text_05"))
	if activity_9001577_Ctrl:isActivityOpen() then
		self.showStage = activity_9001577_Ctrl:getCurrentStage()
	else
		_ENV = i18n("herobattle_text_05")
		_ENV, _ENV, i18n("herobattle_text_05").defaultClick = self, handler(self, self.onClickTab1), 1
		self.title = "1"
		_ENV, handler(self, self.onClickTab1)[1], self.tag = self, self, 1
		self.title = "2"
		_ENV, handler(self, self.onClickTab1)[2], self.tag = self, self, 2
		self.title = "3"
		_ENV, handler(self, self.onClickTab1)[3], self.tag = self, self, 3
		self.title = "4"
		_ENV, handler(self, self.onClickTab1)[4], self.tag = self, self, 4
		self.title = "5"
		_ENV, handler(self, self.onClickTab1)[5], self.tag = self, self, 5
		self.title = "6"
		i18n("herobattle_text_05").tabsetArray, handler(self, self.onClickTab1)[6], self.tag = handler(self, self.onClickTab1), self, 6
		i18n("herobattle_text_05").callback = handler(self, self.onClickTabStage)
		self.fields.Com_tabStage:initView(i18n("herobattle_text_05"))
	end
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardRenderer))
end
function Activity_9001577_RankPanel:onClickTab(index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self:updateUI()
end
function Activity_9001577_RankPanel:onClickTab1(index)
	if self.tabIndex1 == index then
		return
	end
	self.tabIndex1 = index
	self:updateUI()
end
function Activity_9001577_RankPanel:onClickTabStage(index)
	if self.tabStageIndex == index then
		return
	end
	self.tabStageIndex = index
	self:updateUI()
end
function Activity_9001577_RankPanel:isShowRank()
	if self.tabIndex == 1 and activity_9001577_Ctrl:isActivityCalc() then
		return true
	end
	return self.tabIndex1 == 1
end
function Activity_9001577_RankPanel:getShowStage()
	return self.showStage or self.tabStageIndex
end
function Activity_9001577_RankPanel:onRankItemRenderer(index, obj)
	local data
	if self.tabIndex == 1 then
		data = self.stageRankList[index + 1]
	else
		data = self.totalRankList[index + 1]
	end
	obj:initData(data)
end
function Activity_9001577_RankPanel:onRewardRenderer(index, obj)
	if self.tabIndex == 1 then
		local data = self.stageRankRewardList[index + 1]
		obj:initData(data)
	else
		local data = self.totalRankRewardList[index + 1]
		obj:initData(data)
	end
end
function Activity_9001577_RankPanel:onShow()
	print("=======Activity_9001577_RankPanel:onShow")
	self:updateUI()
end
function Activity_9001577_RankPanel:updateUI()
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
		self.controllers.c2:setSelectedIndex(0)
		self:updateRewardList()
	end
end
function Activity_9001577_RankPanel:updateRankList()
	local activity_9001577_Ctrl, myInfo
	local curStage = self:getShowStage()
	if self.tabIndex == 1 then
		if not self.stageRank[curStage] then
			activity_9001577_Ctrl:sendReqStageRank(curStage)
			self.fields.List_rank:setNumItems(0)
			self.fields.text_no_rank:setVisible(true)
		else
			self.stageRankList = activity_9001577_Ctrl:getStageRank(curStage)
			self.fields.List_rank:setNumItems(#self.stageRankList)
			self.fields.text_no_rank:setVisible(#self.stageRankList == 0)
			myInfo = activity_9001577_Ctrl:getMyStageRankInfo(curStage)
		end
	elseif not self.totalRnak then
		self.totalRnak = true
		activity_9001577_Ctrl:sendReqTotalRank()
		self.fields.List_rank:setNumItems(0)
		self.fields.text_no_rank:setVisible(true)
	else
		self.totalRankList = activity_9001577_Ctrl:getTotalRank()
		self.fields.List_rank:setNumItems(#self.totalRankList)
		self.fields.text_no_rank:setVisible(#self.totalRankList == 0)
		myInfo = activity_9001577_Ctrl:getMyTotalRankInfo()
	end
	if myInfo.rank then
		if self.tabIndex == 1 then
			self.fields.Com_stageRanks:setVisible(true)
			self.fields.Com_stageRanks:initData()
		else
			self.fields.Com_stageRanks:setVisible(false)
		end
		if self.tabIndex == 1 then
			self.controllers.c2:setSelectedIndex(1)
		elseif self.tabIndex ~= 1 then
			self.controllers.c2:setSelectedIndex(0)
			self.fields.Com_myRank:setVisible(true)
			self.fields.Com_myRank:initData(myInfo)
		end
	else
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Com_myRank:setVisible(false)
	end
end
function Activity_9001577_RankPanel:updateRewardList()
	self.fields.text_no_rank:setVisible(false)
	print("Activity_9001577_RankPanel:updateRewardList", self.tabIndex, self.tabIndex1)
	if self.tabIndex == 1 then
		self.stageRankRewardList = activity_9001577_Ctrl:getStageRankReward(self:getShowStage())
		self.fields.List_reward:setNumItems(#self.stageRankRewardList)
	else
		self.totalRankRewardList = activity_9001577_Ctrl:getTotalRankReward()
		self.fields.List_reward:setNumItems(#self.totalRankRewardList)
	end
	print("list count", self.fields.List_reward:getNumItems())
end
function Activity_9001577_RankPanel:onStageRank(stage)
	self.stageRank[stage] = true
	if self.tabIndex == 1 and self:isShowRank() and stage == self:getShowStage() then
		self:updateRankList()
	end
end
function Activity_9001577_RankPanel:onTotalRank(data)
	self.totalRnak = true
	if self.tabIndex == 2 and self.tabIndex1 == 1 then
		self:updateRankList()
	end
end
return Activity_9001577_RankPanel
