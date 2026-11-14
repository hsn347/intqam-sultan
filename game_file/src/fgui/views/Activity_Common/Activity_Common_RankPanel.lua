local activityCommonRankRead = include("activityCommonRankRead")
local activityCommonRankCtrl = SoraDGetCtrl("activityCommonRankCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_Common_RankPanel = class("Activity_Common_RankPanel", baseFguiPanel)
function Activity_Common_RankPanel:ctor(...)
	self.isLRU = true
	Activity_Common_RankPanel.super.ctor(self, ...)
	print("Activity_Common_RankPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_
end
function Activity_Common_RankPanel:onInit()
	print("=======Activity_Common_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.itemRenderer_List_rank))
	self.fields.Text_noData:setString(i18n("fishingmaster_text_07"))
	self.fields.Text_noData:setVisible(false)
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
end
function Activity_Common_RankPanel:endShow()
	print("=======Activity_Common_RankPanel:endShow")
	self.rewardList, _ENV, self.rankList, _ENV, self.isInit = print, print, print, print, true
	self.selfRank = 0
	self.selfScore = 0
	self.activityID = self.param.activityID
	local cfg = activityCommonRankRead.getRankViewConfig(self.activityID)
	if cfg then
		if cfg.pkgName then
			fguiHelper.addPackage(self, cfg.pkgName)
		end
		self.fields.Load_rankTitle:setURL(cfg.Com_rankTitle)
		self.fields.List_rank:setDefaultItem(cfg.Com_rankSingle)
		self.fields.Load_own:setURL(cfg.Com_rankSingle)
	end
	self.fields.Com_rankTitle = self.fields.Load_rankTitle:getComponent()
	self.fields.Com_own = self.fields.Load_own:getComponent()
	_ENV = self.fields.Load_own
	_ENV, _ENV, self.fields.Load_own.defaultClick = nil, nil, 1
	_ENV, (nil)[1], (nil).title = nil, nil, i18n("common_text_851")
	self.fields.Load_own.tabsetArray, (nil)[2], (nil).title = nil, nil, i18n("common_text_2194")
	self.fields.Load_own.callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(self.fields.Load_own)
end
function Activity_Common_RankPanel:onClickTab(tag)
	self.tabIndex = tag
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	if self.tabIndex == 1 then
		local nCount = activityCommonRankCtrl:getRankMax(self.activityID)
		activityCommonRankCtrl:reqRanking(self.activityID, 1, nCount)
		SoraDShowLoading(self)
	elseif self.tabIndex == 2 then
		self.fields.Text_noData:setVisible(false)
		self.rewardList = activityCommonRankRead.getRankRewardConfig(self.activityID)
		self.fields.List_reward:setNumItems(#self.rewardList)
	end
end
function Activity_Common_RankPanel:itemRenderer_List_rank(index, obj)
	local data = self.rankList[index + 1]
	_UPVALUE0_ = nil
	;(nil).activityID = self.activityID
	obj:initData(data, nil)
end
function Activity_Common_RankPanel:itemRenderer_List_reward(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data)
end
function Activity_Common_RankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self)
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if not rspdata.rank then
		_ENV = rspdata.rank
	end
	self.rankList = rspdata.rank
	if not rspdata.myInfo then
		_ENV = rspdata.myInfo
	end
	self.myInfo = rspdata.myInfo
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).isOwnRank = true
	self.fields.Com_own:initData(self.myInfo, nil)
end
return Activity_Common_RankPanel
