local nebulaWonderlandRead = include("nebulaWonderlandRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWonderlandRewardPanel = class("NebulaWonderlandRewardPanel", baseFguiPanel)
function NebulaWonderlandRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaWonderlandRewardPanel:ctor", self.viewName)
end
function NebulaWonderlandRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWonderlandRewardPanel:onInit()
	print("=======NebulaWonderlandRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewardCfg = nebulaWonderlandRead.getRewardConfig()
	self.fields.List_reward:setNumItems(table.nums(self.rewardCfg))
end
function NebulaWonderlandRewardPanel:onItemRenderer(index, obj)
	obj:initData(index + 1, self.rewardCfg[index + 1])
end
function NebulaWonderlandRewardPanel:onShow()
	print("=======NebulaWonderlandRewardPanel:onShow")
end
return NebulaWonderlandRewardPanel
