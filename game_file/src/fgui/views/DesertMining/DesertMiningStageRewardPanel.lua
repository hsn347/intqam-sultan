local DesertMiningCtrl = SoraDGetCtrl("DesertMiningCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertMiningStageRewardPanel = class("DesertMiningStageRewardPanel", baseFguiPanel)
function DesertMiningStageRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertMiningStageRewardPanel:ctor", self.viewName)
end
function DesertMiningStageRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertMiningStageRewardPanel:onInit()
	print("=======DesertMiningStageRewardPanel:onInit")
	self.fields.bg:setString(i18n("Desertmining_05"))
	self.data = self.proxy.param
	_ENV = i18n("Desertmining_05")
	i18n("Desertmining_05").num = self.data.num
	self.fields.Text_des:setString(i18n("Desertmining_06", i18n("Desertmining_05")))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickListener(handler(self, self.onClickReward))
end
function DesertMiningStageRewardPanel:onShow()
	print("=======DesertMiningStageRewardPanel:onShow")
	self.fields.List_award:setNumItems(#self.data.reward)
	self.buttonStatus = DesertMiningCtrl:getStageStatus(self.data.stage, self.data.num)
	if self.buttonStatus == gBtnTargetStatusDef.GET then
		self.fields.Btn_reward:setString(i18n("common_text_1146"))
		self.fields.Btn_reward:setEnabled(true)
	elseif self.buttonStatus == gBtnTargetStatusDef.GOT then
		self.fields.Btn_reward:setString(i18n("common_text_1892"))
		self.fields.Btn_reward:setEnabled(false)
	else
		self.fields.Btn_reward:setString(i18n("PrideRebate_text_13"))
		self.fields.Btn_reward:setEnabled(false)
	end
end
function DesertMiningStageRewardPanel:onItemRenderer(index, obj)
	local item = self.data.reward[index + 1]
	obj:initData(item.id, item.count)
end
function DesertMiningStageRewardPanel:onClickReward()
	SoraDPlaySound()
	if self.buttonStatus == gBtnTargetStatusDef.GET then
		DesertMiningCtrl:reqCommonLottery9001545StageReward(self.data.stage)
		self:close()
	end
end
return DesertMiningStageRewardPanel
