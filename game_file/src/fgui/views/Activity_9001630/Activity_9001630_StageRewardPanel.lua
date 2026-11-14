local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001630_StageRewardPanel = class("Activity_9001630_StageRewardPanel", baseFguiPanel)
local activity_9001630_Ctrl = SoraDGetCtrl("activity_9001630_Ctrl")
function Activity_9001630_StageRewardPanel:ctor(...)
	Activity_9001630_StageRewardPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001630_StageRewardPanel:ctor", self.viewName)
end
function Activity_9001630_StageRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001630_StageRewardPanel:onInit()
	print("=======Activity_9001630_StageRewardPanel:onInit")
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(self.param.index, self.param.data)
end
function Activity_9001630_StageRewardPanel:initData(index, data)
	self.index = index
	print("=======Activity_9001630_StageRewardPanel:onInit")
	local getStatus = activity_9001630_Ctrl:getBoxRewardDataStatus(self.index, data.point)
	local nowNum = activity_9001630_Ctrl:getScore()
	_ENV = nil
	;(nil).num = data.point
	self.fields.Text_progress:setString(i18n("pet_flip_text_04", nil))
	_ENV = i18n("pet_flip_text_04", nil)
	i18n("pet_flip_text_04", nil).num = nowNum
	self.fields.Text_point:setString(i18n("common_text_2557", i18n("pet_flip_text_04", nil)))
	dump(data, "Activity_9001630_StageRewardPanel:initData")
	self.taskNum = data.point
	self.rewards = data.reward
	if getStatus == gBtnTargetStatusDef.GO then
		self.fields.Button_get:setTitleText(i18n("common_text_2139"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
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
function Activity_9001630_StageRewardPanel:onClickGet()
	SoraDPlaySound()
	activity_9001630_Ctrl:reqStageReward(self.index)
	self:close()
end
function Activity_9001630_StageRewardPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Activity_9001630_StageRewardPanel:onShow()
	print("=======Activity_9001630_StageRewardPanel:onShow")
end
return Activity_9001630_StageRewardPanel
