local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activity_9001624_Read = include("activity_9001624_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001624_MainPanel = class("Activity_9001624_MainPanel", baseFguiPanel)
function Activity_9001624_MainPanel:ctor(...)
	Activity_9001624_MainPanel.super.ctor(self, ...)
	print("Activity_9001624_MainPanel:ctor", self.viewName)
	self.debug = true
	self.tabIndex = 0
end
function Activity_9001624_MainPanel:onInit()
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001624
	self.activity_Ctrl = activity_9001624_Read.getActivityCtrl(self.activityID)
	self.tabIndex = self.param and self.param.tabIndex or 0
	print("=======Activity_9001624_MainPanel:onInit")
	self.fields.Label_time = self.fields.Com_9001624_SingleSp:getChild("Label_time")
	self.fields.text_time_des = self.fields.Com_9001624_SingleSp:getChild("text_time_des")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTime(self.activityID)
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.list:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScroll))
	self:initActivityBg()
	self.fields.list_bg:setVirtual()
	self.fields.list_bg:setItemRenderer(handler(self, self.onBgItemRenderer))
	self.fields.list_task:setVirtual()
	self.fields.list_task:setItemRenderer(handler(self, self.onTaskItemRenderer))
	self.fields.Button_get:setTitle(i18n("ice_carnival_text05"))
	self.fields.Button_get:addClickEventListener(handler(self, self.onGetAllReward))
	self.fields.Button_get2:setTitle(i18n("ice_carnival_text05"))
	self.fields.Button_get2:addClickEventListener(handler(self, self.onGetAllReward))
	self.fields.Button_unlock:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_unlock:addClickEventListener(handler(self, self.onUnlockReward))
	self.fields.text_tip:setString(i18n("eidalfitr_market_text_07"))
	self.fields.text_time_des:setString(i18n("common_text_2669"))
	self.rewards = activity_9001624_Read.getRewards(self.activityID)
	self.maxPoint = 0
	for i, v in ipairs(self.rewards) do
		if v.showType ~= 2 then
			self.maxPoint = v.point
		else
			break
		end
	end
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		_ENV = ipairs(self.rewards)
		_ENV, _ENV, ipairs(self.rewards).defaultClick = i18n("common_text_2669")
		i18n("common_text_2669").title = i18n("anniversary_cross_text_03")
		_ENV, self.tabIndex[1], i18n("common_text_2669").tag = i18n("common_text_2669")
		i18n("common_text_2669").title = i18n("eidTycoon2024_text_03")
		_ENV, self.tabIndex[2], i18n("common_text_2669").tag = i18n("common_text_2669")
		_ENV = i18n("common_text_2669")
		i18n("common_text_2669").item = ""
		i18n("common_text_2669").title = i18n("Elitebeastcanyon_text_4", i18n("common_text_2669"))
		ipairs(self.rewards).tabsetArray, self.tabIndex[3], i18n("common_text_2669").tag = self.tabIndex, i18n("common_text_2669")
		ipairs(self.rewards).callback = handler(self, self.onClickTab)
		self.fields.Com_tab:initView(ipairs(self.rewards))
	else
		_ENV = ipairs(self.rewards)
		_ENV, _ENV, ipairs(self.rewards).defaultClick = self, self.tabIndex, self.tabIndex
		self.title = i18n("anniversary_cross_text_03")
		_ENV, self.tabIndex[1], self.tag = self, self, 0
		self.title = i18n("common_text_4498")
		ipairs(self.rewards).tabsetArray, self.tabIndex[2], self.tag = self.tabIndex, self, 1
		ipairs(self.rewards).callback = handler(self, self.onClickTab)
		self.fields.Com_tab:initView(ipairs(self.rewards))
	end
	self.fields.Button_get:fixPos()
	self.fields.Button_unlock:fixPos()
end
function Activity_9001624_MainPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN and self.tabIndex == 2 then
		local activityID = self.activityID
		self:closePanel()
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("BeastCanyonExchange", nil)
		return
	end
	self:updateView()
	if self.tabIndex == 0 then
		self.fields.list:playListAction()
	elseif self.tabIndex == 1 then
		self.fields.list_task:playListAction()
	end
end
function Activity_9001624_MainPanel:onScroll()
	local posY = self.fields.list:getScrollPane():getPosY()
	self.fields.list_bg:getScrollPane():setPosY(posY, false)
	local firstChild = self.fields.list:getFirstChildInView() + 1
	self.nexSpReward = nil
	if self.rewardList == nil or #self.rewardList == 0 then
		return
	end
	for i = #self.rewardList - firstChild, #self.rewardList do
		local v = self.rewards[i]
		if v.showType ~= 0 then
			self.nexSpReward = v
			break
		end
	end
	self.fields.Com_9001624_SingleSp:initData(self.activityID, self.nexSpReward)
end
function Activity_9001624_MainPanel:onShow()
	print("=======Activity_9001624_MainPanel:onShow")
	self:updateView(true)
end
function Activity_9001624_MainPanel:updateView(isInit)
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self.taskList = self.activity_Ctrl:getTaskList()
	if self.tabIndex == 0 then
		self.rewardList = self:getRewardList()
		self.fields.list:setNumItems(#self.rewardList)
		self.controllers.c2:setSelectedIndex(self.activity_Ctrl:getIsAdvanceRewardUnlock() and 1 or 0)
		local listSize = self.fields.list:getScrollPane():getContentSize()
		_ENV = self.fields.list:getScrollPane()
		self.fields.list:getScrollPane()[gActivityTimeActivityID.NORMAL_ACTIVITY_9001624] = 1002
		local self.fields.list:getScrollPane()[gActivityTimeActivityID.CELEBRATE_CORBAN], config = 1064, self.fields.list:getScrollPane()
		local bgH = config[self.activityID] or 1002
		local bgNum = math.ceil((listSize.height + 250) / bgH)
		self.fields.list_bg:setNumItems(bgNum)
		if isInit or self.oldIndex ~= self.curIndex then
			local listViewSize = self.fields.list:getContentSize()
			self.fields.list:scrollToView(math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1))
		end
		self.oldIndex = self.curIndex
		if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
			_ENV = math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1)
			math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1).num = string.formatnumberthousands(self.point)
			self.fields.text_point:setString(i18n("eidTycoon2024_text_02", math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1)))
		else
			_ENV = i18n("eidTycoon2024_text_02", math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1))
			i18n("eidTycoon2024_text_02", math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1)).num = string.formatnumberthousands(self.point) .. "M"
			self.fields.text_point:setString(i18n("eidalfitr_market_text_03", i18n("eidTycoon2024_text_02", math.min(math.max(#self.rewardList - self.curIndex - math.floor(listViewSize.height / 130) + 1, 0), #self.rewardList - 1))))
		end
	else
		self.fields.list_task:setNumItems(#self.taskList)
	end
	local rewardRedNum = self.activity_Ctrl:getUnGetRewardNum()
	self.fields.Com_tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Button_get:setEnabled(0 < rewardRedNum)
	self.fields.Button_get2:setEnabled(0 < rewardRedNum)
	local taskRedPoint = self.activity_Ctrl:getTaskRedNum()
	self.fields.Com_tab:setBtnRedDot(2, 0 < taskRedPoint, taskRedPoint)
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		local exchangeRedNum = self.activity_Ctrl:getExchangeRedNum()
		self.fields.Com_tab:setBtnRedDot(3, 0 < exchangeRedNum, exchangeRedNum)
	end
end
function Activity_9001624_MainPanel:getRewardList()
	local _ENV, rewardList
	_ENV = nil
	table.insert(rewardList, nil)
	self.point = self.activity_Ctrl:getPoint()
	self.nexSpReward = nil
	self.curIndex = 1
	local loopShowCount = 0
	for i, v in ipairs(self.rewards) do
		if v.point <= self.maxPoint or v.point <= self.point then
			table.insert(rewardList, v)
		end
		if v.point <= self.point then
			self.curIndex = self.curIndex + 1
		elseif v.showType ~= 0 and self.nexSpReward == nil then
			self.nexSpReward = v
		end
	end
	for i = self.curIndex, self.curIndex + 1 do
		if self.rewards[i] ~= nil and self.rewards[i].showType == 2 then
			table.insert(rewardList, self.rewards[i])
		end
	end
	return rewardList
end
function Activity_9001624_MainPanel:onItemRenderer(index, obj)
	local curIndex = #self.rewardList - index
	local reward = self.rewardList[curIndex]
	obj:initData(self.activityID, reward, self.curIndex == curIndex, self.oldIndex ~= nil and self.curIndex ~= self.oldIndex)
end
function Activity_9001624_MainPanel:onBgItemRenderer(index, obj)
end
function Activity_9001624_MainPanel:onTaskItemRenderer(index, obj)
	obj:initData(self.activityID, self.taskList[index + 1])
	obj:setHandler(handler(self, self.onGetReward))
end
function Activity_9001624_MainPanel:onClickHelp()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		_ENV = nil
		;(nil).content = i18n("eidTycoon2024_text_01")
		uiManager:show("RuleView", nil)
	else
		_ENV = nil
		;(nil).content = i18n("eidalfitr_market_text_01")
		uiManager:show("RuleView", nil)
	end
end
function Activity_9001624_MainPanel:onGetReward(taskID)
	SoraDPlaySound()
	local taskComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	local taskStatus = taskComponent:getTaskState(taskID)
	if taskStatus == gBtnTargetStatusDef.GOT and not self.activity_Ctrl:getIsAdvanceRewardUnlock() then
		self:openBuyGiftView()
		return
	end
	self.activity_Ctrl:reqReward(taskID)
end
function Activity_9001624_MainPanel:onGetAllReward()
	SoraDPlaySound()
	self.activity_Ctrl:reqStageReward()
end
function Activity_9001624_MainPanel:onUnlockReward()
	SoraDPlaySound()
	self:openBuyGiftView()
end
function Activity_9001624_MainPanel:initActivityBg(...)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001624] = "ui://Activity_9001624/activity_bg_9001624"
	local (nil)[gActivityTimeActivityID.CELEBRATE_CORBAN], config = "ui://Activity_9001624/activity_bg_9001637", nil
	local defaultItem = config[self.activityID]
	self.fields.list_bg:setDefaultItem(defaultItem)
end
function Activity_9001624_MainPanel:openBuyGiftView(...)
	if self.activityID == gActivityTimeActivityID.CELEBRATE_CORBAN then
		uiManager:show("Activity_9001637_BuyGift")
	else
		uiManager:show("Activity_9001624_BuyGift")
	end
end
return Activity_9001624_MainPanel
