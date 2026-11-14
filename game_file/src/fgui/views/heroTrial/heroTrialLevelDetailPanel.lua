local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialLevelDetailPanel = class("heroTrialLevelDetailPanel", baseFguiPanel)
function heroTrialLevelDetailPanel:ctor(...)
	self.isLRU = true
	heroTrialLevelDetailPanel.super.ctor(self, ...)
	print("heroTrialLevelDetailPanel:ctor", self.viewName)
end
function heroTrialLevelDetailPanel:onInit()
	print("=======heroTrialLevelDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_019"))
	self.fields.Text_guards:setString(i18n("common_text_1864"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_guards:fixPos()
	self.fields.Text_guards_num:fixPos()
end
function heroTrialLevelDetailPanel:onItemRenderer(index, obj)
	obj:initData(self.armyList[index + 1])
end
function heroTrialLevelDetailPanel:endShow()
	print("=======heroTrialLevelDetailPanel:endShow")
	self.armyList = self.param.armyList
	local total = 0
	for k, v in ipairs(self.armyList) do
		total = total + v.num
	end
	self.fields.Text_guards_num:setString(total)
	self.fields.List:setNumItems(#self.armyList)
end
return heroTrialLevelDetailPanel
