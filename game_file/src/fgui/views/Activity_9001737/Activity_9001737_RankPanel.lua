local activity_9001737_Read = include("activity_9001737_Read")
local activity_9001737_Ctrl = SoraDGetCtrl("activity_9001737_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001737_RankPanel = class("Activity_9001737_RankPanel", baseFguiPanel)
function Activity_9001737_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001737_RankPanel.super.ctor(self, ...)
	print("Activity_9001737_RankPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY
end
function Activity_9001737_RankPanel:onInit()
	print("=======Activity_9001737_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.Text_noData:setString(i18n("fishingmaster_text_07"))
	self.fields.Text_noData:setVisible(false)
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_count:setString(i18n("common_text_1764"))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_count:fixPos()
end
function Activity_9001737_RankPanel:endShow()
	print("=======Activity_9001737_RankPanel:endShow")
	self.isInit = true
	self.rewardList, _ENV, self.rankList, _ENV, self.tabIndex = print, print, print, print, 0
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tabIndex, self.tabIndex
	;(nil).title = i18n("common_text_851")
	_ENV, self.tabIndex[1], (nil).tag = nil, nil, 0
	;(nil).title = i18n("common_text_2194")
	;(nil).tabsetArray, self.tabIndex[2], (nil).tag = self.tabIndex, nil, 1
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(nil)
end
function Activity_9001737_RankPanel:onClickTab(tag)
	self.tabIndex = tag
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function Activity_9001737_RankPanel:updateUI()
	if self.tabIndex == 0 then
		if self.isInit then
			self.isInit = false
			activity_9001737_Ctrl:sendReqInitDataMsg()
			SoraDShowLoading(self)
		else
			self:updateRankView()
		end
	elseif self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		self.rewardList = activity_9001737_Read.getRankCfg()
		self.fields.List_reward:setNumItems(#self.rewardList)
	end
end
function Activity_9001737_RankPanel:updateRankView()
	SoraDCloseLoading(self)
	local campRank = activity_9001737_Ctrl:getCampRank()
	self.rankList = activity_9001737_Ctrl:getCampRankList()
	if 0 < #campRank then
		table.sort(self.rankList, function(a, b)
			return a.rankInfo.rank < b.rankInfo.rank
		end)
	end
	self.fields.List_rank:setNumItems(#campRank)
	self.fields.Text_noData:setVisible(#campRank == 0)
	local myCamp = activity_9001737_Ctrl:getMyCamp()
	local rank, myInfo = activity_9001737_Ctrl:getCampRankInfoByCamp(myCamp)
	local myData
	for _, v in ipairs(self.rankList) do
		if v.campType == myCamp then
			myData = v
			break
		end
	end
	myData.rank = rank or 0
	self.fields.Com_self:initData(myData, true)
end
function Activity_9001737_RankPanel:onRankItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1])
end
function Activity_9001737_RankPanel:onRewardItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1])
end
return Activity_9001737_RankPanel
