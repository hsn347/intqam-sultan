local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertMiningPreawardPanel = class("DesertMiningPreawardPanel", baseFguiPanel)
function DesertMiningPreawardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertMiningPreawardPanel:ctor", self.viewName)
end
function DesertMiningPreawardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertMiningPreawardPanel:onInit()
	print("=======DesertMiningPreawardPanel:onInit")
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.config = newLotteryRead.getPreAwardByActivityID(self.activityID, SoraDGetCtrl("DesertMiningCtrl"):getClassType())
	dump(self.config, "config")
	self.fields.List:setNumItems(#self.config)
end
function DesertMiningPreawardPanel:onShow()
	print("=======DesertMiningPreawardPanel:onShow")
end
function DesertMiningPreawardPanel:onItemRederer(index, target)
	target:initData(self.config[index + 1])
end
return DesertMiningPreawardPanel
