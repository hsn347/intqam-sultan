local publicRead = include("publicRead")
local activity_9001566_Read = include("activity_9001566_Read")
local activity_9001566_Ctrl = SoraDGetCtrl("activity_9001566_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001566_awardPanel = class("Activity_9001566_awardPanel", baseFguiPanel)
function Activity_9001566_awardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001566_awardPanel:ctor", self.viewName)
end
function Activity_9001566_awardPanel:onInit()
	print("=======Activity_9001566_awardPanel:onInit")
	local activityId = self.param.activityId
	local eventType = self.param.eventType
	local idx = self.param.idx
	local itemName = activity_9001566_Read.getEventTypeNameWithIdx(eventType, idx)
	self.fields.Panel_bg:setString(itemName)
	local state = activity_9001566_Ctrl:getRewardState(self.param)
	local isReceive = state == gBtnTargetStatusDef.GOT
	local boxImage = activity_9001566_Read.getEventTypeBoxImage(eventType, isReceive)
	self.fields.Load_box:setURL(boxImage)
	if state == gBtnTargetStatusDef.GOT then
		self.fields.Text_des:setString(i18n("battleground_rebate_5"))
	elseif state == gBtnTargetStatusDef.GO then
		local desBase = activity_9001566_Read.getEventTypeDesBase(eventType)
		local taskTarget = activity_9001566_Read.getTaskTarget(self.param)
		local progress = activity_9001566_Ctrl:getEventProgress(activityId, eventType)
		local remain = taskTarget - progress
		_ENV = i18n("battleground_rebate_5")
		i18n("battleground_rebate_5").time = string.formatnumberthousands(remain)
		i18n("battleground_rebate_5").item = itemName
		self.fields.Text_des:setString(i18n(desBase, i18n("battleground_rebate_5")))
	end
	self.fields.Com_title:setString(i18n("battleground_rebate_6"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewardList = activity_9001566_Read.getTaskReward(self.param)
	self.fields.List_reward:setNumItems(#self.rewardList)
	if not SoraDFIsRA() then
		self.fields.Load_box:fixPos()
		self.fields.Text_des:fixPos()
	end
end
function Activity_9001566_awardPanel:onShow()
	print("=======Activity_9001566_awardPanel:onShow")
end
function Activity_9001566_awardPanel:onItemRenderer(index, obj)
	local data = self.rewardList[index + 1]
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local _fields = fguiHelper.get_fields(obj)
	_fields.Com_item:initData(data.id, data.count)
	_fields.Text_name:setString(publicRead.getName(data.id))
	_fields.Text_count:setString(string.formatnumberthousands(data.count))
	_fields.Image_light:setVisible(index % 2 == 1)
end
return Activity_9001566_awardPanel
