local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
local sinbadTreasureRead = include("sinbadTreasureRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local sinbadTreasureRankRewardViewPanel = class("sinbadTreasureRankRewardViewPanel", baseFguiPanel)
function sinbadTreasureRankRewardViewPanel:ctor(...)
	self.isLRU = true
	sinbadTreasureRankRewardViewPanel.super.ctor(self, ...)
	print("sinbadTreasureRankRewardViewPanel:ctor", self.viewName)
end
function sinbadTreasureRankRewardViewPanel:onInit()
	print("=======sinbadTreasureRankRewardViewPanel:onInit")
	self.rewards, _ENV = print, print
	self.fields.Text_tip:setString(i18n("common_text_2211"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	for rankType = 2, 3 do
		self.rewards[rankType], _ENV = handler(self, self.onItemRenderer)
		local rankData = sinbadTreasureRead.getRankData(rankType, sinbadTreasureCtrl:getClassType())
		for k, v in ipairs(rankData) do
			_ENV = sinbadTreasureCtrl:getClassType()
			sinbadTreasureCtrl:getClassType().rank = v.rank
			sinbadTreasureCtrl = sinbadTreasureCtrl:getClassType()
			sinbadTreasureCtrl:getClassType()[1] = "id"
			sinbadTreasureCtrl:getClassType()[2] = "count"
			sinbadTreasureCtrl:getClassType().reward = serviceFunctions.tableFormat(v.reward, sinbadTreasureCtrl:getClassType())
			table.insert(self.rewards[rankType], sinbadTreasureCtrl:getClassType())
		end
	end
end
function sinbadTreasureRankRewardViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rewards[self.rankType][index + 1])
end
function sinbadTreasureRankRewardViewPanel:endShow()
	print("=======sinbadTreasureRankRewardViewPanel:endShow")
	self._titleStr = self.param and self.param.str or i18n("hero_title_02")
	self._rankType = self.param and self.param.rankType
	self.fields.Panel_bg:setString(self._titleStr)
	_ENV = self._titleStr
	_ENV, _ENV, self._titleStr.defaultClick = nil, self._rankType == 1 and 2 or 1, self._rankType == 1 and 2 or 1
	;(nil).title = i18n("Sinbad_text_23")
	_ENV, (self._rankType == 1 and 2 or 1)[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Sinbad_text_22")
	self._titleStr.tabsetArray, (self._rankType == 1 and 2 or 1)[2], (nil).tag = self._rankType == 1 and 2 or 1, nil, 2
	self._titleStr.callback = handler(self, self.clickTab)
	self.fields.com_TabW:initView(self._titleStr)
end
function sinbadTreasureRankRewardViewPanel:clickTab(tag)
	self.rankType = tag == 1 and 2 or 3
	self.fields.List:setNumItems(#self.rewards[self.rankType])
	self.fields.List:jumpToTop()
end
return sinbadTreasureRankRewardViewPanel
