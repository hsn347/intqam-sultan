local buildMoreInfoRead = include("buildMoreInfoRead")
local cityltCtrl = include("cityltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuildStatueBraveNextLvInfoPanel = class("BuildStatueBraveNextLvInfoPanel", baseFguiPanel)
function BuildStatueBraveNextLvInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BuildStatueBraveNextLvInfoPanel:ctor", self.viewName)
end
function BuildStatueBraveNextLvInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BuildStatueBraveNextLvInfoPanel:onInit()
	print("=======BuildStatueBraveNextLvInfoPanel:onInit")
	local bid = self.proxy.param.bid
	self.bid = bid
	local starlv = SoraDGetBuildStarLv(bid)
	self.fields.Panel_bg:setString(cityltCtrl.getStarBraveStatueLvStr(starlv + 1))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self:initUpgradeDes()
end
function BuildStatueBraveNextLvInfoPanel:onShow()
	print("=======BuildStatueBraveNextLvInfoPanel:onShow")
end
function BuildStatueBraveNextLvInfoPanel:initUpgradeDes()
	self.tableUpData = buildMoreInfoRead.getUpgradeStatueBraveInfoData(self.bid, 0)
	self.fields.List:setNumItems(#self.tableUpData)
end
function BuildStatueBraveNextLvInfoPanel:onItemRederer(index, target)
	target:initData(self.tableUpData[index + 1])
end
return BuildStatueBraveNextLvInfoPanel
