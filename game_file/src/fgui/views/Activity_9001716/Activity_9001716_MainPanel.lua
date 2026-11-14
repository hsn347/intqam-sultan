local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local activity_9001716_Read = include("activity_9001716_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001716_MainPanel = class("Activity_9001716_MainPanel", baseFguiPanel)
function Activity_9001716_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001716_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.BUBBLEPUZZLE_ACTIVITY_9001716
	self.isLRU = true
end
function Activity_9001716_MainPanel:onInit()
	print("=======Activity_9001716_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.listQuest:setItemRenderer(handler(self, self.itemRenderer_quests))
	self.fields.listQuest:setNeedAutoFix(false)
	self.fields.bubble1:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble2:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble3:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble4:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble5:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble6:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble7:addClickListener(handler(self, self.onClickBubble))
	self.fields.bubble8:addClickListener(handler(self, self.onClickBubble))
end
function Activity_9001716_MainPanel:endShow()
	print("=======Activity_9001716_MainPanel:endShow")
	self:initData()
end
function Activity_9001716_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("bubble_puzzle_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001716_MainPanel:onClickBubble(context)
	SoraDPlaySound()
	local bubble = context.sender
	local bubbleReward = bubble.bubbleReward
	if not bubbleReward then
		return
	end
	if activity_9001716_Ctrl:checkCurBoxOpen(bubbleReward.boxIndex) then
		_ENV = nil
		;(nil).rewardData = bubbleReward
		uiManager:show("Activity_9001716_Reward", nil)
	elseif activity_9001716_Ctrl:checkBubbleCanReceive(bubbleReward.boxIndex) then
		_ENV = bubbleReward.boxIndex
		bubbleReward.boxIndex.index = bubbleReward.boxIndex
		activity_9001716_Ctrl:reqGetReward(bubbleReward.boxIndex)
		SoraDShowLoading(self)
	else
		_ENV = bubbleReward.boxIndex
		bubbleReward.boxIndex.rewardData = bubbleReward
		uiManager:show("Activity_9001716_Reward", bubbleReward.boxIndex)
	end
end
function Activity_9001716_MainPanel:onClickBubbleGold(context)
	local finalReward = activity_9001716_Read.getFinalReward(activity_9001716_Ctrl:getClassType())
	activity_9001716_Read = activity_9001716_Ctrl:getClassType()
	activity_9001716_Ctrl:getClassType().index = finalReward.boxIndex
	activity_9001716_Ctrl:reqGetReward(activity_9001716_Ctrl:getClassType())
	SoraDShowLoading(self)
end
function Activity_9001716_MainPanel:itemRenderer_quests(index, obj)
	obj:initData(self.tasks[index + 1])
end
function Activity_9001716_MainPanel:itemRenderer_List_items(index, obj)
	obj:initData(self.finalRewardItems[index + 1].id, self.finalRewardItems[index + 1].count)
end
function Activity_9001716_MainPanel:initData()
	self.tasks = activity_9001716_Read.getTasks(activity_9001716_Ctrl:getClassType())
	self.fields.listQuest:setNumItems(#self.tasks)
	self:UpdateBubbles()
	self.fields.comReward:initData()
end
function Activity_9001716_MainPanel:UpdateBubbles()
	local receivedRewards = activity_9001716_Ctrl:getRewardData()
	_UPVALUE8_ = activity_9001716_Ctrl
	activity_9001716_Ctrl[1] = self.fields.bubble1
	activity_9001716_Ctrl[2] = self.fields.bubble2
	activity_9001716_Ctrl[3] = self.fields.bubble3
	activity_9001716_Ctrl[4] = self.fields.bubble4
	activity_9001716_Ctrl[5] = self.fields.bubble5
	activity_9001716_Ctrl[6] = self.fields.bubble6
	activity_9001716_Ctrl[7] = self.fields.bubble7
	local activity_9001716_Ctrl[8], bubbleList = self.fields.bubble8, activity_9001716_Ctrl
	for i, bubble in ipairs(bubbleList) do
		local bubbleReward = activity_9001716_Read.getBubbleReward(activity_9001716_Ctrl:getClassType(), i)
		if not bubbleReward then
			print_error(string.format("泡泡迷阵 类型%d boxIndex = %d 没有奖励数据", activity_9001716_Ctrl:getClassType(), i))
		end
		bubble:initData(bubbleReward)
	end
	local bubbleReward = activity_9001716_Read.getFinalReward((activity_9001716_Ctrl:getClassType()))
	self.fields.bubble9:initData(bubbleReward)
end
function Activity_9001716_MainPanel:UpdateRewardInfo()
	local baseReward = activity_9001716_Read.getFinalReward(activity_9001716_Ctrl:getClassType())
	self.finalRewardItems, activity_9001716_Read = activity_9001716_Ctrl:getClassType()
	for i = 1, #baseReward.reward, 2 do
		activity_9001716_Read = activity_9001716_Ctrl:getClassType()
		activity_9001716_Ctrl:getClassType().id = baseReward.reward[i]
		activity_9001716_Ctrl:getClassType().count = baseReward.reward[i + 1]
		table.insert(self.finalRewardItems, activity_9001716_Ctrl:getClassType())
	end
	self.fields.List_items:setNumItems(#self.finalRewardItems)
	local finishedTaskNum = activity_9001716_Ctrl:getTaskTotalProgress()
	activity_9001716_Read = self.finalRewardItems
	self.finalRewardItems.num1 = finishedTaskNum
	self.finalRewardItems.num2 = #self.tasks
	self.fields.txtDesc:setText(i18n("bubble_puzzle_text_02", self.finalRewardItems))
	self.fields.btnGet:setVisible(finishedTaskNum >= #self.tasks)
end
return Activity_9001716_MainPanel
