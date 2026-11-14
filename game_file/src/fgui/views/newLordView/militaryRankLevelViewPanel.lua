local militaryRankRead = include("militaryRankRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local militaryRankLevelViewPanel = class("militaryRankLevelViewPanel", baseFguiPanel)
function militaryRankLevelViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("militaryRankLevelViewPanel:ctor", self.viewName)
end
function militaryRankLevelViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function militaryRankLevelViewPanel:onInit()
	print("=======militaryRankLevelViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2429"))
	self.fields.List:setItemRenderer(handler(self, self.onRankRenderer))
end
function militaryRankLevelViewPanel:onRankRenderer(index, obj)
	local data = self.rankList[index + 1]
	local height = 42 + math.max(#data.effect - 1, 0) * 26
	obj:setHeight(height)
	obj:initData(data, index + 1, self.curRankLv)
end
function militaryRankLevelViewPanel:onShow()
	print("=======militaryRankLevelViewPanel:onShow")
	self.curRankLv = self.param and self.param.level
	self.rankList = militaryRankRead.getRankList()
	self.fields.List:setNumItems(#self.rankList)
end
return militaryRankLevelViewPanel
