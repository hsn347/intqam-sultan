local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
local activityCommonKitchenRead = include("activityCommonKitchenRead")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001669_TaskPanel = class("Activity_9001669_TaskPanel", baseFguiPanel)
function Activity_9001669_TaskPanel:ctor(...)
	Activity_9001669_TaskPanel.super.ctor(self, ...)
	print("Activity_9001669_TaskPanel:ctor", self.viewName)
end
function Activity_9001669_TaskPanel:onInit()
	print("=======Activity_9001669_TaskPanel:onInit")
	self.fields.Panel_bg:setString(i18n("octopus_kitchen_text_09"))
	local _fields = fguiHelper.get_fields(self.fields.Com_taskInfo)
	self.fields_task = _fields
	_fields.Text_star:setString(i18n("octopus_kitchen_text_22"))
	_fields.Text_tip:setString(i18n("octopus_kitchen_text_10"))
	_fields.List_food:setItemRenderer(handler(self, self.onFoodItemRenderer))
	_fields.Button_submit:setString(i18n("common_text_3628"))
	_fields.Button_submit:addClickListener(handler(self, self.onClickBtnSubmit))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Text_reward:setString(i18n("octopus_kitchen_text_15"))
	if not SoraDFIsRA() then
		_fields.Com_spineCut:fixPos()
		_fields.Text_name:fixPos()
		_fields.Text_star:fixPos()
		_fields.List_star:fixPos()
		_fields.Text_msg:fixPos()
	end
end
function Activity_9001669_TaskPanel:onShow()
	print("=======Activity_9001669_TaskPanel:onShow")
	self.activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	self.taskID = self.param.taskID
	self.taskData = activityCommonKitchenCtrl:getTaskData(self.activityID, self.taskID)
	local roleID = self.taskData.roleID or 1
	local customerName = activityCommonKitchenRead.getCustomerName(self.activityID, roleID)
	self.fields_task.Text_name:setString(customerName)
	local spine = self.fields_task.Com_spineCut:getChild("Spine")
	local cfg = activityCommonKitchenRead:getSpineConfig(self.activityID, roleID)
	local effectPath = cfg.effectPath
	if effectPath then
		spine:setEffectPath(effectPath)
	end
	local offsetY = cfg.offsetY
	spine:setPositionY(260 + offsetY)
	self:initTaskInfo()
	self:initTaskReward()
	_ENV = self.initTaskReward
	_ENV, _ENV, self.initTaskReward.defaultClick = 260 + offsetY, self, 1
	_ENV, self[1], (260 + offsetY).title = 260 + offsetY, 260 + offsetY, i18n("octopus_kitchen_text_09")
	self.initTaskReward.tabsetArray, self[2], (260 + offsetY).title = self, 260 + offsetY, i18n("soldier_rush_text_11")
	local self.initTaskReward.callback, param = handler(self, self.onClickTab), self.initTaskReward
	self.fields.com_TabW:initView(param)
end
function Activity_9001669_TaskPanel:onClickTab(tag)
	self.controllers.c_type:setSelectedIndex(tag - 1)
end
function Activity_9001669_TaskPanel:initTaskInfo(...)
	local data = self.taskData
	local _fields = self.fields_task
	_fields.List_star:setNumItems(data.taskType)
	local likeItemID = data.likeItemID
	local boringItemID = data.boringItemID
	local itemName1 = itemDesRead.getName(likeItemID)
	local itemName2 = itemDesRead.getName(boringItemID)
	itemDesRead = nil
	;(nil).val1 = itemName1
	;(nil).val2 = itemName2
	_fields.Text_msg:setString(i18n("octopus_kitchen_text_17", nil))
	self.foodIDList = activityCommonKitchenRead.getFoodIDList(self.activityID)
	_fields.List_food:setNumItems(#self.foodIDList)
	local itemID = self:getDefaultItemID(data)
	if itemID then
		local index = table.indexof(self.foodIDList, itemID) or 1
		_fields.List_food:setSelectedIndex(index - 1)
	else
		_fields.List_food:setSelectedIndex(0)
	end
end
function Activity_9001669_TaskPanel:getDefaultItemID(data)
	local likeItemID = data.likeItemID
	local boringItemID = data.boringItemID
	local activityCommonKitchenRead, foodIDList
	local specFoodIDList = activityCommonKitchenRead.getSpecFoodIDList(self.activityID)
	for __, itemID in ipairs(specFoodIDList) do
		table.insert(foodIDList, itemID)
	end
	table.insert(foodIDList, likeItemID)
	local normalFoodIDList = activityCommonKitchenRead.getNormalFoodIDList(self.activityID)
	for __, itemID in ipairs(normalFoodIDList) do
		if itemID ~= likeItemID and itemID ~= boringItemID then
			table.insert(foodIDList, itemID)
		end
	end
	table.insert(foodIDList, boringItemID)
	for __, itemID in ipairs(foodIDList) do
		local itemCount = backpackCtrl:getItemCount(itemID)
		if 0 < itemCount then
			return itemID
		end
	end
end
function Activity_9001669_TaskPanel:onFoodItemRenderer(index, obj)
	local itemID = self.foodIDList[index + 1]
	obj:initItemID(itemID)
end
function Activity_9001669_TaskPanel:onClickBtnSubmit(...)
	SoraDPlaySound()
	local _fields = self.fields_task
	local index = _fields.List_food:getSelectedIndex()
	if index < 0 then
		return
	end
	local itemID = self.foodIDList[index + 1]
	local itemCount = backpackCtrl:getItemCount(itemID)
	if itemCount <= 0 then
		local itemName = itemDesRead.getName(itemID)
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgTip(i18n("explore_ore_text7", nil))
		return
	end
	activityCommonKitchenCtrl:reqCompleteTask(self.activityID, self.taskID, itemID)
	SoraDShowLoading()
	self:closePanel()
end
function Activity_9001669_TaskPanel:initTaskReward(...)
	local data = self.taskData
	self.rewardList = activityCommonKitchenRead:getTaskRewardList(self.activityID, data.taskType)
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function Activity_9001669_TaskPanel:onRewardItemRenderer(index, obj)
	local rewardType = index + 1
	local _fields = fguiHelper.get_fields(obj)
	local icon = activityCommonKitchenRead.getRewardTypeIcon(self.activityID, rewardType)
	_fields.Load_state:setURL(icon)
	local text = activityCommonKitchenRead.getRewardTypeText(self.activityID, rewardType)
	_fields.Text_state:setString(text)
	if rewardType ~= 4 then
		_fields.List1:setVisible(true)
		_fields.List2:setVisible(false)
		local reward = self.rewardList[rewardType]
		_fields.List1:setItemRenderer(function(_index, _obj)
			local data = reward[_index + 1]
			_obj:initData(data.id, data.count)
		end)
		_fields.List1:setNumItems(#reward)
	else
		_fields.List1:setVisible(false)
		_fields.List2:setVisible(true)
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
return Activity_9001669_TaskPanel
