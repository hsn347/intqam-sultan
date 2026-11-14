local nebulaExplorationRead = include("nebulaExplorationRead")
local nebulaExplorationCtrl = SoraDGetCtrl("nebulaExplorationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasureRewardPanel = class("NebulaTreasureRewardPanel", baseFguiPanel)
function NebulaTreasureRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaTreasureRewardPanel:ctor", self.viewName)
end
function NebulaTreasureRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasureRewardPanel:onInit()
	print("=======NebulaTreasureRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewardCfg = nebulaExplorationRead:getPreAwardConfig()
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setNumItems(table.nums(self.rewardCfg))
	self.fields.List_reward:scrollToView(nebulaExplorationCtrl:getCurLevel() - 1)
end
function NebulaTreasureRewardPanel:onItemRenderer(index, obj)
	obj:initData_Imp(self.rewardCfg[index + 1])
end
function NebulaTreasureRewardPanel:onShow()
	print("=======NebulaTreasureRewardPanel:onShow")
end
return NebulaTreasureRewardPanel
