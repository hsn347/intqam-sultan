local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local starEnergyCubeRead = include("starEnergyCubeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubeAccuRewardPanel = class("StarEnergyCubeAccuRewardPanel", baseFguiPanel)
function StarEnergyCubeAccuRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyCubeAccuRewardPanel:ctor", self.viewName)
end
function StarEnergyCubeAccuRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "RamadanAccuRecharge"
		self._packageList, self._packageList[2] = self._packageList, "TowerDefend"
	end
	return self._packageList
end
function StarEnergyCubeAccuRewardPanel:onInit()
	print("=======StarEnergyCubeAccuRewardPanel:onInit")
	self:fixChildrenPos()
	self.fields.Com_progressBar:fixPos()
	self.fields.List_reward:fixPos()
	self.fields.Panel_bg:setTitle(i18n("STAR_CUBE_16"))
	self.fields.Text_tip:setString(i18n("STAR_CUBE_18"))
	_ENV = i18n("STAR_CUBE_18")
	i18n("STAR_CUBE_18").num = fguiHelper.getColorString("#FED24B", starCubeCtrl:getTotalOpenTimes())
	self.fields.Text_time:setString(i18n("STAR_CUBE_17", i18n("STAR_CUBE_18")))
	self.rewardConfig = starEnergyCubeRead:getAccuRewardInfo()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function StarEnergyCubeAccuRewardPanel:initData()
	self.fields.List_reward:setNumItems(table.nums(self.rewardConfig))
	self.fields.Com_progressBar:setValue(starCubeCtrl:getTotalOpenTimes(), starEnergyCubeRead:getAccuRewardMaxNum())
end
function StarEnergyCubeAccuRewardPanel:showReward(data)
	_ENV = nil
	;(nil).reward = data.reward
	uiManager:show("StarEnergyCubeOpenReward", nil):setOwnerKey(self)
	self:initData()
end
function StarEnergyCubeAccuRewardPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.rewardConfig[index + 1])
end
function StarEnergyCubeAccuRewardPanel:onShow()
	print("=======StarEnergyCubeAccuRewardPanel:onShow")
end
return StarEnergyCubeAccuRewardPanel
