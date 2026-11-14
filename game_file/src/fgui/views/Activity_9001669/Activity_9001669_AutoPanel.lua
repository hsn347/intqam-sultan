local constantRead = include("constantRead")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001669_AutoPanel = class("Activity_9001669_AutoPanel", baseFguiPanel)
function Activity_9001669_AutoPanel:ctor(...)
	Activity_9001669_AutoPanel.super.ctor(self, ...)
	print("Activity_9001669_AutoPanel:ctor", self.viewName)
	self:_addPackage("CommonBoxSingle")
end
function Activity_9001669_AutoPanel:onInit()
	print("=======Activity_9001669_AutoPanel:onInit")
	self.fields.Label_food:setString(i18n("octopus_kitchen_text_07"))
	self.fields.List_food:setItemRenderer(handler(self, self.onFoodItemRenderer))
	self.fields.Label_reward:setString(i18n("octopus_kitchen_text_08"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	_ENV = handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer).scrollH = 740
	self.fields.Com_base:initBaseData(handler(self, self.onRewardItemRenderer))
end
function Activity_9001669_AutoPanel:onShow()
	print("=======Activity_9001669_AutoPanel:onShow")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	local activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001669
	if not self.param.data then
		_ENV = self.param.data
	end
	self:initData(activityID, self.param.data)
end
function Activity_9001669_AutoPanel:initData(activityID, data)
	local completeNum = data.completeNum or 0
	_ENV = nil
	;(nil).num = completeNum
	self.fields.Text_complete:setString(i18n("octopus_kitchen_text_05", nil))
	if not data.costItem then
		local _ENV, costItem = data.costItem, data.costItem
	end
	self.costItem = costItem
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001669 then
		local refreshItemID = constantRead.getConstValue("OCTOPUS_KITCHEN_REFRESH_ITEM")
		local itemName = itemDesRead.getName(refreshItemID)
		local costNum = 0
		for i, v in ipairs(self.costItem) do
			if v.id == refreshItemID then
				costNum = v.count
				table.remove(self.costItem, i)
				break
			end
		end
		_ENV = ipairs(self.costItem)
		ipairs(self.costItem).item = itemName
		ipairs(self.costItem).num = costNum
		local costStr = i18n("octopus_kitchen_text_06", ipairs(self.costItem))
		self.fields.Text_cost:setString(costStr)
	else
		self.fields.Text_cost:setVisible(false)
	end
	self.fields.List_food:setNumItems(#self.costItem)
	if not data.rewards then
		_ENV = data.rewards
	end
	self.rewards = data.rewards
	self.fields.List_reward:setNumItems(#self.rewards)
end
function Activity_9001669_AutoPanel:onFoodItemRenderer(index, obj)
	local item = self.costItem[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001669_AutoPanel:onRewardItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001669_AutoPanel:onHide(...)
	SoraDMailGainItems(self.rewards, true)
end
return Activity_9001669_AutoPanel
