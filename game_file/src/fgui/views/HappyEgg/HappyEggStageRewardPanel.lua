local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HappyEggStageRewardPanel = class("HappyEggStageRewardPanel", baseFguiPanel)
function HappyEggStageRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HappyEggStageRewardPanel:ctor", self.viewName)
end
function HappyEggStageRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HappyEggStageRewardPanel:onInit()
	print("=======HappyEggStageRewardPanel:onInit")
	self.fields.bg:setString(i18n("common_text_2078"))
	self.data = self.proxy.param
	_ENV = i18n("common_text_2078")
	i18n("common_text_2078").num = self.data.num
	self.fields.Text_des:setString(i18n("happyegg_10", i18n("common_text_2078")))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickListener(handler(self, self.onClickReward))
end
function HappyEggStageRewardPanel:onShow()
	print("=======HappyEggStageRewardPanel:onShow")
	self.fields.List_award:setNumItems(#self.data.reward)
	self.buttonStatus = happyEggCtrl:getStageStatus(self.data.stage, self.data.num)
	_ENV = nil
	;(nil).num = happyEggCtrl:getLotteryCount()
	self.fields.Text_Num:setString(i18n("happyegg_08", nil))
	if self.buttonStatus == gBtnTargetStatusDef.GET then
		self.fields.Btn_reward:setString(i18n("common_text_1146"))
		self.fields.Btn_reward:setEnabled(true)
	elseif self.buttonStatus == gBtnTargetStatusDef.GOT then
		self.fields.Btn_reward:setString(i18n("common_text_1892"))
		self.fields.Btn_reward:setEnabled(false)
	else
		self.fields.Btn_reward:setString(i18n("common_text_4120"))
		self.fields.Btn_reward:setEnabled(false)
	end
end
function HappyEggStageRewardPanel:onItemRenderer(index, obj)
	local item = self.data.reward[index + 1]
	obj:initData(item.id, item.count)
end
function HappyEggStageRewardPanel:onClickReward()
	SoraDPlaySound()
	if self.buttonStatus == gBtnTargetStatusDef.GET then
		happyEggCtrl:reqCommonLottery9001544StageReward(self.data.stage)
		self:close()
	end
end
return HappyEggStageRewardPanel
