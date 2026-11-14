local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonRankStageViewPanel = class("CommonRankStageViewPanel", baseFguiPanel)
function CommonRankStageViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonRankStageViewPanel:ctor", self.viewName)
end
function CommonRankStageViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CommonRankStageViewPanel:onInit()
	print("=======CommonRankStageViewPanel:onInit")
	self.awardList, _ENV = print, print
	self.fields.List_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
end
function CommonRankStageViewPanel:onShow()
	print("=======CommonRankStageViewPanel:onShow")
	self.title = self.param.title or i18n("hero_title_02")
	self.awardList = self.param.awardList
	self.fields.Panel_bg:setString(self.title)
	self.fields.List_Award:setNumItems(#self.awardList)
end
function CommonRankStageViewPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
return CommonRankStageViewPanel
