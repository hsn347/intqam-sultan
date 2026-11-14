local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballKingRewardPanel = class("FootballKingRewardPanel", baseFguiPanel)
local footballKingCtrl = SoraDGetCtrl("footballKingCtrl")
function FootballKingRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("FootballKingRewardPanel:ctor", self.viewName)
end
function FootballKingRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballKingRewardPanel:onInit()
	print("=======FootballKingRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData(self.param.index, self.param.data)
end
function FootballKingRewardPanel:initData(index, data)
	print("=======FootballKingRewardPanel:onInit")
	local getStatus = footballKingCtrl:getBoxRewardDataStatus(data.num)
	dump(data, "FootballKingRewardPanel:initData")
	self.index = index
	self.taskNum = data.num
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
function FootballKingRewardPanel:onClickGet()
	SoraDPlaySound()
	footballKingCtrl:reqFootballKingStageReward(self.taskNum)
	self:close()
end
function FootballKingRewardPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function FootballKingRewardPanel:onShow()
	print("=======FootballKingRewardPanel:onShow")
end
return FootballKingRewardPanel
