local activity_9001703_Read = include("activity_9001703_Read")
local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local MAX_RANK_NUM = 200
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001703_RankPanel = class("Activity_9001703_RankPanel", baseFguiPanel)
function Activity_9001703_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001703_RankPanel.super.ctor(self, ...)
	print("Activity_9001703_RankPanel:ctor", self.viewName)
end
function Activity_9001703_RankPanel:onInit()
	print("=======Activity_9001703_RankPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("surprise_box_003"), handler(self, self.onClickClose))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
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
function Activity_9001703_RankPanel:onRankItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1])
end
function Activity_9001703_RankPanel:onRewardItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1])
end
function Activity_9001703_RankPanel:endShow()
	print("=======Activity_9001703_RankPanel:endShow")
	self.tabIndex = 0
	self.rankList, _ENV, self.isInit = print, print, true
	self.selfRank = 0
	self.selfScore = 0
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tabIndex, self.tabIndex
	;(nil).title = i18n("Nebulaking_title_06")
	_ENV, self.tabIndex[1], (nil).tag = nil, nil, 0
	;(nil).title = i18n("snowwolf_text_10")
	;(nil).tabsetArray, self.tabIndex[2], (nil).tag = self.tabIndex, nil, 1
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(nil)
end
function Activity_9001703_RankPanel:onClickTab(tag)
	self.tabIndex = tag
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function Activity_9001703_RankPanel:updateUI()
	if self.tabIndex == 0 then
		if self.isInit then
			self.isInit = false
			activity_9001703_Ctrl:reqScoreRank()
			SoraDShowLoading(self)
		else
			self:updateRankView()
		end
	elseif self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		self.rewardList = activity_9001703_Read.getRankCfg()
		self.fields.List_reward:setNumItems(#self.rewardList)
	end
end
function Activity_9001703_RankPanel:rankMsgBack(target, data)
	SoraDCloseLoading(self)
	if not data.rspdata.rank then
		_ENV = data.rspdata.rank
	end
	self.rankList = data.rspdata.rank
	self.selfRank = data.rspdata.selfRank or 0
	self.selfScore = data.rspdata.selfScore or 0
	self:updateRankView()
end
function Activity_9001703_RankPanel:updateRankView()
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
	local MAX_RANK_NUM, myData = self.fields.Text_noData.setVisible, self.fields.Text_noData.setVisible
	if self.selfRank == 0 or self.selfRank > MAX_RANK_NUM then
		myData.rank = self.selfRank
		myData.score = self.selfScore
	else
		myData.rank = self.selfRank
		myData.score = self.selfScore
	end
	myData.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or ""
	local info = lordInfoCtrl:getBaseInfo()
	myData.nickName = info.nickName
	myData.uid = SoraDGetPlayerID()
	self.fields.Com_self:initData(myData)
end
return Activity_9001703_RankPanel
