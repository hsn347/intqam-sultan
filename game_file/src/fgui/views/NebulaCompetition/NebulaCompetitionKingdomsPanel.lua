local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCompetitionKingdomsPanel = class("NebulaCompetitionKingdomsPanel", baseFguiPanel)
function NebulaCompetitionKingdomsPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCompetitionKingdomsPanel:ctor", self.viewName)
end
function NebulaCompetitionKingdomsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaCompetitionKingdomsPanel:onInit()
	print("=======NebulaCompetitionKingdomsPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Nebula_Competition_text_04"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaCompetitionKingdomsPanel:onShow()
	print("=======NebulaCompetitionKingdomsPanel:onShow")
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY)
	self.kingdoms = param.kidlist
	dump(param, "param")
	self.fields.List:setNumItems(#self.kingdoms)
end
function NebulaCompetitionKingdomsPanel:onItemRenderer(index, obj)
	local data = self.kingdoms[index + 1]
	obj:initData(index, data)
end
return NebulaCompetitionKingdomsPanel
