local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local militaryRankRead = include("militaryRankRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local militaryRankRewardViewPanel = class("militaryRankRewardViewPanel", baseFguiPanel)
function militaryRankRewardViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("militaryRankRewardViewPanel:ctor", self.viewName)
end
function militaryRankRewardViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function militaryRankRewardViewPanel:onInit()
	print("=======militaryRankRewardViewPanel:onInit")
	self.rewardList, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("common_text_1235"))
	self.fields.List:setItemRenderer(handler(self, self.onRewardRenderer))
end
function militaryRankRewardViewPanel:onRewardRenderer(index, obj)
	obj:initData(self.rewardList[index + 1], index + 1)
end
function militaryRankRewardViewPanel:onShow()
	print("=======militaryRankRewardViewPanel:onShow")
	self.tablePlayerInfo = lordInfoCtrl:getLordInfo()
	local rankStr = militaryRankRead.getRankStr(self.tablePlayerInfo.militaryRankInfo.lastRank, 200)
	_ENV = nil
	;(nil).rank = fguiHelper.getColorString("#FFFFFF", rankStr)
	self.fields.Text_rank:setString(i18n("common_text_2398", nil))
	self.rewardList = militaryRankRead.getRewardList()
	self.fields.List:setNumItems(#self.rewardList)
end
return militaryRankRewardViewPanel
