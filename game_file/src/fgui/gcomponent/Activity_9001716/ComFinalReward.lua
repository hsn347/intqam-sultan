local activity_9001716_Read = include("activity_9001716_Read")
local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local ComFinalReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001716/ComFinalReward", ComFinalReward)
function ComFinalReward:onInit()
	self.fields.List_items:setItemRenderer(handler(self, self.itemRenderer_List_items))
	self.fields.btnGet:setTitle(i18n("cavalryrise_text_06"))
	self.fields.btnGet:addClickListener(handler(self, self.onClickBubbleGold))
	self:fixChildrenPos()
end
function ComFinalReward:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001716_GET_REWARD", handler(self, self.onMsgGetReward))
end
function ComFinalReward:onShow()
end
function ComFinalReward:onMsgGetReward(...)
	SoraDCloseLoading(self)
	self:initData(self.baseTask)
end
function ComFinalReward:itemRenderer_List_items(index, obj)
	obj:initData(self.finalRewardItems[index + 1].id, self.finalRewardItems[index + 1].count)
end
function ComFinalReward:onClickBubbleGold(context)
	SoraDPlaySound()
	local finalReward = activity_9001716_Read.getFinalReward(activity_9001716_Ctrl:getClassType())
	_ENV = activity_9001716_Ctrl:getClassType()
	activity_9001716_Ctrl:getClassType().index = finalReward.boxIndex
	activity_9001716_Ctrl:reqGetReward(activity_9001716_Ctrl:getClassType())
	SoraDShowLoading(self)
end
function ComFinalReward:initData()
	self.tasks = activity_9001716_Read.getTasks(activity_9001716_Ctrl:getClassType())
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
	self.fields.btnGet:setVisible(not activity_9001716_Ctrl:checkCurBoxOpen(baseReward.boxIndex) and activity_9001716_Ctrl:checkAllTaskComplete(baseReward.boxIndex))
end
return ComFinalReward
