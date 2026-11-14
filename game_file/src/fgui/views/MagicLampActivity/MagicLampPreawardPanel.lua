local magicFlipRead = include("magicFlipRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampPreawardPanel = class("MagicLampPreawardPanel", baseFguiPanel)
function MagicLampPreawardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampPreawardPanel:ctor", self.viewName)
end
function MagicLampPreawardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampPreawardPanel:onInit()
	print("=======MagicLampPreawardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_flip_2"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function MagicLampPreawardPanel:onShow()
	print("=======MagicLampPreawardPanel:onShow")
	self.rewardConfig = magicFlipRead.getRewardConfig()
	self.fields.List:setNumItems(#self.rewardConfig)
end
function MagicLampPreawardPanel:onItemRederer(index, target)
	target:initData(self.rewardConfig[index + 1])
end
return MagicLampPreawardPanel
