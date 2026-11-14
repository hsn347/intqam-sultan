local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001597_RewardPanel = class("Activity_9001597_RewardPanel", baseFguiPanel)
local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
function Activity_9001597_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001597_RewardPanel:ctor", self.viewName)
end
function Activity_9001597_RewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001597_RewardPanel:onInit()
	print("=======Activity_9001597_RewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.isJoinAlliance = activity_9001597_Ctrl:getIsJoinAlliance()
	self:initData(self.param.index, self.param.data)
end
function Activity_9001597_RewardPanel:initData(index, data)
	print("=======Activity_9001597_RewardPanel:onInit")
	local getStatus = activity_9001597_Ctrl:getBoxRewardDataStatus(index, data.score)
	_ENV = nil
	;(nil).num = data.score
	self.fields.Text_progress:setString(i18n("Ramadan_2024_text38", nil))
	dump(data, "Activity_9001597_RewardPanel:initData")
	self.index = index
	self.taskNum = data.score
	self.rewards = data.reward
	if getStatus == gBtnTargetStatusDef.GO or not self.isJoinAlliance and getStatus ~= gBtnTargetStatusDef.GOT then
		self.fields.Button_get:setTitleText(i18n("common_text_2139"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(not self.isJoinAlliance)
	elseif getStatus == gBtnTargetStatusDef.GET then
		self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		self.fields.Button_get:setGrayed(false)
		self.fields.Button_get:setTouchable(true)
	else
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	end
	self.fields.List_reward:setNumItems(table.nums(self.rewards))
end
function Activity_9001597_RewardPanel:onClickGet()
	SoraDPlaySound()
	if not self.isJoinAlliance then
		SoraDShowMsgTip(i18n("notice_0066"))
		return
	end
	activity_9001597_Ctrl:reqReceive(self.index)
	self:close()
end
function Activity_9001597_RewardPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Activity_9001597_RewardPanel:onShow()
	print("=======Activity_9001597_RewardPanel:onShow")
end
return Activity_9001597_RewardPanel
