local activity_9001487_Ctrl = SoraDGetCtrl("activity_9001487_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001487_RewardPanel = class("Activity_9001487_RewardPanel", baseFguiPanel)
function Activity_9001487_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001487_RewardPanel:ctor", self.viewName)
end
function Activity_9001487_RewardPanel:onInit()
	print("=======Activity_9001487_RewardPanel:onInit")
	local activityID = self.proxy.param and self.proxy.param.activityID or gActivityTimeActivityID.GREAT_ARMOR_ACTIVITY_1
	self.rewardList = activity_9001487_Ctrl:getRewardList(activityID)
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function Activity_9001487_RewardPanel:onShow()
	print("=======Activity_9001487_RewardPanel:onShow")
end
function Activity_9001487_RewardPanel:onRewardItemRenderer(index, obj)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
	end
	local fields = obj.fields
	local data = self.rewardList[index + 1]
	_ENV = nil
	;(nil).num1 = data.days
	;(nil).num2 = "$" .. data.amount
	fields.title:setString(i18n("great_armor_03", nil))
	_UPVALUE2_ = i18n("great_armor_03", nil)
	i18n("great_armor_03", nil)[1] = "id"
	i18n("great_armor_03", nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(data.reward, i18n("great_armor_03", nil))
	fields.List_reward:setItemRenderer(function(_index, _obj)
		local _data = rewards[_index + 1]
		_obj:initData(_data.id, _data.count)
	end)
	fields.List_reward:setNumItems(#rewards)
end
return Activity_9001487_RewardPanel
