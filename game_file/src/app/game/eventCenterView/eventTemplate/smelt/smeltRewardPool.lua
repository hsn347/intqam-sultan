local smeltCtrl = SoraDGetCtrl("smeltCtrl")
local smeltRead = include("smeltRead")
_ENV = "smeltRead"
;("smeltRead").CUR_REWARDS = 1
local ("smeltRead").ALL_REWARDS, PAGE_TYPE = 2, "smeltRead"
local smeltRewardPool = class("smeltRewardPool", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("smeltRewardPool")
end)
function smeltRewardPool:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("Smelt_text_09"))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self.imageNoReward = SoraDGetChildByName(self, "Image_no_reward")
	self.textNoReward = SoraDGetChildByName(self, "Text_no_reward")
	self.textNoReward:setString(i18n("Smelt_text_38"))
	self.imageRewardTip = SoraDGetChildByName(self, "Image_reward_tip")
	self.textRewardTip = SoraDGetChildByName(self, "Text_reward_tip")
	self.textRewardTip:setString(i18n("Smelt_text_42"))
	self.textRewardTip:setFlippedY(true)
	self.cell = SoraDGetChildByName(self, "Node_pool_1")
	self.curRewardsNode = SoraDGetChildByName(self, "ScrollView_list_1")
	self.allRewardsNode = SoraDGetChildByName(self, "Node_all_reward")
	self.allRewardTitle = SoraDGetChildByName(self, "Text_title")
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
	self.Center_Button_left = SoraDGetChildByName(self, "Center_Button_left")
	self.Center_Button_left:addTouchEventListener(handler(self, self.btnLeftClick))
	self.Center_Button_right = SoraDGetChildByName(self, "Center_Button_right")
	self.Center_Button_right:addTouchEventListener(handler(self, self.btnRightClick))
	self.pageType = PAGE_TYPE.ALL_REWARDS
	self.curPageIndx = 1
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(547, 48))
	self.ccs_tab:setNewStyle(true)
	_ENV = true
	;(true).tabNum = 2
	_ENV, _ENV, (true).defaultClick = cc.size(547, 48)
	cc.size(547, 48).title = i18n("Smelt_text_07")
	_ENV, cc.size(547, 48)[1], cc.size(547, 48).handle = cc.size(547, 48)
	cc.size(547, 48).title = i18n("Smelt_text_08")
	;(true).tabsetArray, cc.size(547, 48)[2], cc.size(547, 48).handle = cc.size(547, 48)
	self.ccs_tab:initView(true)
end
function smeltRewardPool:setItems(nodeAward, rewards)
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
function smeltRewardPool:updateView()
	self.curRewardsNode:setVisible(self.pageType == PAGE_TYPE.CUR_REWARDS)
	self.allRewardsNode:setVisible(self.pageType == PAGE_TYPE.ALL_REWARDS)
	if self.pageType == PAGE_TYPE.CUR_REWARDS then
		self:updateCurRewardPage()
	else
		self:updateAllRewardPage()
	end
end
function smeltRewardPool:updateCurRewardPage()
	if self.curRewardInited then
		self.imageRewardTip:setVisible(table.nums(self.gotRewars) > 0)
		self.imageNoReward:setVisible(table.nums(self.gotRewars) <= 0)
		return
	end
	self.curRewardInited = true
	local gotRewars = smeltCtrl:getAllGotRewards(smeltCtrl:getCurRound(), smeltCtrl:getValue(), smeltCtrl:getIsBuy())
	self.gotRewars = gotRewars
	local lineCount = math.ceil(table.nums(gotRewars) / 5)
	local heightSum = lineCount * 100
	local scrollViewSize = self.curRewardsNode:getContentSize()
	heightSum = heightSum < scrollViewSize.height and scrollViewSize.height or heightSum
	local newNode = display.newNode()
	newNode:setPositionX(scrollViewSize.width / 2)
	newNode:addTo(self.curRewardsNode)
	if lineCount * 100 < scrollViewSize.height then
		newNode:setPositionY(scrollViewSize.height - 100 * lineCount / 2)
	else
		newNode:setPositionY(scrollViewSize.height / 2)
	end
	self:setItems(newNode, gotRewars)
	self.curRewardsNode:setInnerContainerSize(cc.size(scrollViewSize.width, heightSum))
	if SoraDFIsRA() then
		SoraDautoSortPos(newNode, 5, 2, cc.size(100, 95), SoraDFIsRA())
	else
		SoraDautoSortPos(newNode, 5, 0, cc.size(100, 95), SoraDFIsRA())
	end
	self.imageNoReward:setVisible(table.nums(gotRewars) <= 0)
	self.imageRewardTip:setVisible(table.nums(self.gotRewars) > 0)
end
function smeltRewardPool:getCurPageRewards(pageIndex)
	local allRewards = smeltCtrl:getShowRewards()
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
function smeltRewardPool:updateAllRewardPage()
	local curRewards, curRound = self:getCurPageRewards(self.curPageIndx)
	self.imageNoReward:setVisible(false)
	self.imageRewardTip:setVisible(false)
	self.scrollView = SoraDGetChildByName(self.allRewardsNode, "ScrollView_list_2")
	local scrollSize = self.scrollView:getContentSize()
	local heightSum = 0
	local _ENV, heights = "ScrollView_list_2", "ScrollView_list_2"
	local _ENV, heights2
	self.scrollView:removeAllChildren()
	local index = 1
	for k, v in pairs(curRewards) do
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
		local cell1, height = self:createCell(rewards1, self.scrollView, "reward1_" .. k, i18n_html("Smelt_text_13", nil, v.cost), index % 2 == 0)
		_ENV = nil
		_ENV, _ENV, (nil).num = nil, v.cost, v.cost
		v.cost.num, (nil).color = nil, "#00BE1E"
		local cell2, height2 = self:createCell(rewards2, self.scrollView, "reward2_" .. k, i18n_html("Smelt_text_12", nil, v.cost), false)
		heightSum = heightSum + height
		table.insert(heights, heightSum)
		table.insert(heights2, height)
		heightSum = heightSum + height2
		table.insert(heights, heightSum)
		table.insert(heights2, height2)
		index = index + 1
	end
	heightSum = heightSum < scrollSize.height and scrollSize.height or heightSum
	self.scrollView:setInnerContainerSize(cc.size(self.scrollView:getContentSize().width, heightSum))
	for i, v in ipairs(self.scrollView:getChildren()) do
		v:setPosition(scrollSize.width / 2, heightSum - heights[i] + heights2[i] / 2)
	end
	self:updatePageBtn()
	_ENV = self.scrollView:getChildren()
	self.scrollView:getChildren().num = curRound
	self.allRewardTitle:setString(i18n("Smelt_text_10", self.scrollView:getChildren()))
end
function smeltRewardPool:createCell(items, parent, cellName, str, isShowBg)
	local cell = parent:getChildByName(cellName)
	local title
	if not cell then
		cell = self.cell:clone()
		cell:setName(cellName)
		cell:addTo(parent)
		title = SoraDGetChildByName(cell, "Text_Tips_1")
		title = SoraDChangeTextToHtml(title)
	else
		title = SoraDGetChildByName(cell, "Text_Tips_1")
	end
	local num = table.nums(items)
	local height = math.ceil(num / 5) * 120 + 10
	local awardNode = SoraDGetChildByName(cell, "Node_Award")
	self:setItems(awardNode, items)
	title:setString(str)
	title:setPositionY(height / 2)
	local bg = SoraDGetChildByName(cell, "Image_cell_bg")
	bg:setVisible(isShowBg)
	if isShowBg then
		bg:setContentSize(cc.size(bg:getContentSize().width, height * 2))
		bg:setPositionY(-height / 2)
	end
	SoraDautoSortPos(awardNode, 5, 1, cc.size(100, 95), not SoraDFIsRA())
	return cell, height
end
function smeltRewardPool:onCurRewardClick()
	self.pageType = PAGE_TYPE.CUR_REWARDS
	self:updateView()
end
function smeltRewardPool:onAllRewardClick()
	self.pageType = PAGE_TYPE.ALL_REWARDS
	self.curPageIndx = 1
	self:updateView()
end
function smeltRewardPool:btnLeftClick(button, eventType)
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
function smeltRewardPool:btnRightClick(button, eventType)
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
function smeltRewardPool:updatePageBtn()
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
return smeltRewardPool
