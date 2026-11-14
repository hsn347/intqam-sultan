local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local activity_9001615_Read = include("activity_9001615_Read")
_ENV = "activity_9001615_Read"
;("activity_9001615_Read").CUR_REWARDS = 1
local ("activity_9001615_Read").ALL_REWARDS, PAGE_TYPE = 2, "activity_9001615_Read"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001615_RewardPoolPanel = class("Activity_9001615_RewardPoolPanel", baseFguiPanel)
function Activity_9001615_RewardPoolPanel:ctor(...)
	Activity_9001615_RewardPoolPanel.super.ctor(self, ...)
	print("Activity_9001615_RewardPoolPanel:ctor", self.viewName)
end
function Activity_9001615_RewardPoolPanel:onInit()
	print("=======Activity_9001615_RewardPoolPanel:onInit")
	self.nodeCommonPopBox = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitle(i18n("Smelt_text_09"))
	self.imageNoReward = SoraDGetChildByName(self, "Image_no_reward")
	self.textNoReward = SoraDGetChildByName(self, "Text_no_reward")
	self.textNoReward:setString(i18n("Smelt_text_38"))
	self.imageRewardTip = SoraDGetChildByName(self, "Image_reward_tip")
	self.textRewardTip = SoraDGetChildByName(self, "Text_reward_tip")
	self.textRewardTip:setString(i18n("Smelt_text_42"))
	self.cell = SoraDGetChildByName(self, "Node_pool_1")
	self.curRewardsNode = SoraDGetChildByName(self, "ScrollView_list_1")
	self.allRewardsNode = SoraDGetChildByName(self, "Node_all_reward")
	self.curRewardsNode:setVirtual()
	self.curRewardsNode:setItemRenderer(handler(self, self.onItemRenderer2))
	self.allRewardTitle = SoraDGetChildByName(self, "Text_title")
	self.Center_Button_left = SoraDGetChildByName(self, "Center_Button_left")
	self.Center_Button_left:addTouchEventListener(handler(self, self.btnLeftClick))
	self.Center_Button_right = SoraDGetChildByName(self, "Center_Button_right")
	self.Center_Button_right:addTouchEventListener(handler(self, self.btnRightClick))
	self.pageType = PAGE_TYPE.ALL_REWARDS
	self.curPageIndx = 1
	_ENV, self.ccs_tab = SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab"), SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab")
	SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab").tabNum = 2
	_ENV, _ENV, SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab").defaultClick = "CCS_commonTabBtnEX_tab", self, 1
	;("CCS_commonTabBtnEX_tab").title = i18n("Smelt_text_07")
	_ENV, self[1], ("CCS_commonTabBtnEX_tab").tag = "CCS_commonTabBtnEX_tab", "CCS_commonTabBtnEX_tab", 1
	;("CCS_commonTabBtnEX_tab").title = i18n("Smelt_text_08")
	SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab").tabsetArray, self[2], ("CCS_commonTabBtnEX_tab").tag = self, "CCS_commonTabBtnEX_tab", 2
	local SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab").callback, param = handler(self, self.onClickTab), SoraDGetChildByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:initView(param)
	self.scrollView = SoraDGetChildByName(self.allRewardsNode, "ScrollView_list_2")
	self.scrollView:setVirtual()
	self.scrollView:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001615_RewardPoolPanel:onShow()
	print("=======Activity_9001615_RewardPoolPanel:onShow")
end
function Activity_9001615_RewardPoolPanel:setItems(nodeAward, rewards)
	local index = 1
	for k, v in pairs(rewards) do
		local newItem = nodeAward:getChildByName("item" .. index)
		local item
		if newItem == nil then
			newItem = self.tmpItem:clone()
			newItem:setScale(0.77)
			item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
			item:setBaseScale(1)
			item:setOwnView(self)
			newItem:addTo(nodeAward)
		else
			item = SoraDGetChildByName(newItem, "Item")
		end
		index = index + 1
		item:initData(v.id, v.count)
	end
	nodeAward:setAnchorPoint(cc.p(0.5, 1))
end
function Activity_9001615_RewardPoolPanel:updateView()
	self.curRewardsNode:setVisible(self.pageType == PAGE_TYPE.CUR_REWARDS)
	self.allRewardsNode:setVisible(self.pageType == PAGE_TYPE.ALL_REWARDS)
	if self.pageType == PAGE_TYPE.CUR_REWARDS then
		self:updateCurRewardPage()
	else
		self:updateAllRewardPage()
	end
end
function Activity_9001615_RewardPoolPanel:updateCurRewardPage()
	if self.curRewardInited then
		self.imageRewardTip:setVisible(table.nums(self.gotRewars) > 0)
		self.imageNoReward:setVisible(table.nums(self.gotRewars) <= 0)
		return
	end
	self.curRewardInited = true
	local gotRewars = activity_9001615_Ctrl:getAllGotRewards(activity_9001615_Ctrl:getCurRound(), activity_9001615_Ctrl:getValue(), activity_9001615_Ctrl:getIsBuy())
	self.gotRewars = gotRewars
	self.curRewardsNode:setNumItems(#self.gotRewars)
	self.imageNoReward:setVisible(table.nums(gotRewars) <= 0)
	self.imageRewardTip:setVisible(table.nums(self.gotRewars) > 0)
end
function Activity_9001615_RewardPoolPanel:onItemRenderer2(index, obj)
	local data = self.gotRewars[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001615_RewardPoolPanel:getCurPageRewards(pageIndex)
	local allRewards = activity_9001615_Ctrl:getShowRewards()
	self.maxPages = table.nums(allRewards)
	local index = 1
	for k, v in pairs(allRewards) do
		if index == pageIndex then
			return v, k
		end
		index = index + 1
	end
	return nil
end
function Activity_9001615_RewardPoolPanel:updateAllRewardPage()
	local curRewards, curRound = self:getCurPageRewards(self.curPageIndx)
	self.imageNoReward:setVisible(false)
	self.imageRewardTip:setVisible(false)
	self.rewards, _ENV = self.imageRewardTip.setVisible, self.imageRewardTip.setVisible
	dump(curRewards, "curRewards")
	for k, v in ipairs(curRewards) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local rewards1 = serviceFunctions.tableFormat(v.reward1, nil)
		_UPVALUE2_ = "id"
		;("id")[1] = "id"
		;("id")[2] = "count"
		local rewards2 = serviceFunctions.tableFormat(v.reward2, "id")
		_ENV = nil
		_ENV, _ENV, (nil).num = nil, v.cost, v.cost
		v.cost.num, (nil).color = nil, "#00BE1E"
		self:createCell(rewards1, self.scrollView, "reward1_" .. k, i18n_html("Smelt_text_13", nil, v.cost), k % 2 == 0)
		_ENV = nil
		_ENV, _ENV, (nil).num = nil, v.cost, v.cost
		v.cost.num, (nil).color = nil, "#00BE1E"
		self:createCell(rewards2, self.scrollView, "reward2_" .. k, i18n_html("Smelt_text_12", nil, v.cost), false)
	end
	self.scrollView:setNumItems(#self.rewards)
	self:updatePageBtn()
	_ENV = nil
	;(nil).num = curRound
	self.allRewardTitle:setString(i18n("Smelt_text_10", nil))
end
function Activity_9001615_RewardPoolPanel:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	local cell = obj
	local title = SoraDGetChildByName(cell, "Text_Tips_1")
	local num = table.nums(data.items)
	local height = math.ceil(num / 5) * 120 + 10
	local awardNode = SoraDGetChildByName(cell, "Node_Award")
	awardNode:setItemRenderer(function(index2, obj2)
		local itemData = data.items[index2 + 1]
		obj2:initData(itemData.id, itemData.count)
	end)
	awardNode:setNumItems(num)
	title:setString(data.str)
	local bg = SoraDGetChildByName(cell, "Image_cell_bg")
	bg:setVisible(data.isShowBg)
	if isShowBg then
		fguiHelper.get_controllers(obj).c1:setSelectedIndex(1)
	else
		fguiHelper.get_controllers(obj).c1:setSelectedIndex(0)
	end
end
function Activity_9001615_RewardPoolPanel:createCell(items, parent, cellName, str, isShowBg)
	_ENV = nil
	;(nil).items = items
	;(nil).str = str
	;(nil).isShowBg = isShowBg
	table.insert(self.rewards, nil)
end
function Activity_9001615_RewardPoolPanel:onClickTab(tag)
	if tag == 1 then
		self:onCurRewardClick()
	else
		self:onAllRewardClick()
	end
end
function Activity_9001615_RewardPoolPanel:onCurRewardClick()
	self.pageType = PAGE_TYPE.CUR_REWARDS
	self:updateView()
end
function Activity_9001615_RewardPoolPanel:onAllRewardClick()
	self.pageType = PAGE_TYPE.ALL_REWARDS
	self.curPageIndx = 1
	self:updateView()
end
function Activity_9001615_RewardPoolPanel:btnLeftClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("向左")
		local pageIndex = SoraDFIsRA() and self.curPageIndx + 1 or self.curPageIndx - 1
		pageIndex = pageIndex > self.maxPages and 1 or pageIndex
		pageIndex = pageIndex < 1 and self.maxPages or pageIndex
		self.curPageIndx = pageIndex
		self:updateAllRewardPage()
	end
end
function Activity_9001615_RewardPoolPanel:btnRightClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("向右")
		local pageIndex = SoraDFIsRA() and self.curPageIndx - 1 or self.curPageIndx + 1
		pageIndex = pageIndex > self.maxPages and 1 or pageIndex
		pageIndex = pageIndex < 1 and self.maxPages or pageIndex
		self.curPageIndx = pageIndex
		self:updateAllRewardPage()
	end
end
function Activity_9001615_RewardPoolPanel:updatePageBtn()
	do return end
	self.Center_Button_right:setVisible(true)
	local nextpageIndex = SoraDFIsRA() and self.curPageIndx - 1 or self.curPageIndx + 1
	local rewards = self:getCurPageRewards(nextpageIndex)
	if SoraDFIsRA() and nextpageIndex < 0 or not rewards then
		self.Center_Button_right:setVisible(false)
	end
	self.Center_Button_left:setVisible(true)
	nextpageIndex = SoraDFIsRA() and self.curPageIndx + 1 or self.curPageIndx - 1
	rewards = self:getCurPageRewards(nextpageIndex)
	if SoraDFIsRA() and nextpageIndex < 0 or not rewards then
		self.Center_Button_left:setVisible(false)
	end
end
return Activity_9001615_RewardPoolPanel
