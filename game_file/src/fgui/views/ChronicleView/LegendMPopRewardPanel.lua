local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendMPopRewardPanel = class("LegendMPopRewardPanel", baseFguiPanel)
function LegendMPopRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LegendMPopRewardPanel:ctor", self.viewName)
end
function LegendMPopRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LegendMPopRewardPanel:onInit()
	print("=======LegendMPopRewardPanel:onInit")
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(self.proxy.param.rewards, nil)
	self.fields.Panel_bg:setString(i18n("history_text_06"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setNumItems(#self.rewardList)
end
function LegendMPopRewardPanel:onShow()
	print("=======LegendMPopRewardPanel:onShow")
end
function LegendMPopRewardPanel:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
	target:setString(include("publicRead").getName(self.rewardList[index + 1].id))
end
return LegendMPopRewardPanel
