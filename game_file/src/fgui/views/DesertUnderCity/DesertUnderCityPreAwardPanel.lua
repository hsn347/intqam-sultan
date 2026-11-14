local desertUnderCityCtrl = SoraDGetCtrl("desertUnderCityCtrl")
local flameSecretOrderRead = include("flameSecretOrderRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertUnderCityPreAwardPanel = class("DesertUnderCityPreAwardPanel", baseFguiPanel)
function DesertUnderCityPreAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertUnderCityPreAwardPanel:ctor", self.viewName)
end
function DesertUnderCityPreAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertUnderCityPreAwardPanel:onInit()
	print("=======DesertUnderCityPreAwardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setVirtual()
end
function DesertUnderCityPreAwardPanel:onItemRenderer(index, obj)
	obj:initData_Imp(self.rewardCfg[index + 1])
end
function DesertUnderCityPreAwardPanel:onShow()
	print("=======DesertUnderCityPreAwardPanel:onShow", desertUnderCityCtrl:getFloor())
	local totalNum = flameSecretOrderRead.getTotalFloorNum(true)
	self.rewardCfg, _ENV = true, true
	for floor = 1, totalNum do
		local rewardList = flameSecretOrderRead.getBaseRewardsByFloor(floor, true)
		flameSecretOrderRead = desertUnderCityCtrl:getFloor()
		desertUnderCityCtrl:getFloor()[1] = "id"
		desertUnderCityCtrl:getFloor()[2] = "count"
		rewardList = serviceFunctions.tableFormat(rewardList, desertUnderCityCtrl:getFloor())
		_ENV = desertUnderCityCtrl:getFloor()
		desertUnderCityCtrl:getFloor().award = rewardList
		desertUnderCityCtrl:getFloor().lv = floor
		table.insert(self.rewardCfg, desertUnderCityCtrl:getFloor())
	end
	self.fields.List_reward:setNumItems(table.nums(self.rewardCfg))
	self.fields.List_reward:scrollToView(desertUnderCityCtrl:getFloor() - 1)
end
return DesertUnderCityPreAwardPanel
