local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001665_RankPanel = class("Activity_9001665_RankPanel", baseFguiPanel)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001665_Read = include("activity_9001665_Read")
local activity_9001665_Ctrl = SoraDGetCtrl("activity_9001665_Ctrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
function Activity_9001665_RankPanel:ctor(...)
	Activity_9001665_RankPanel.super.ctor(self, ...)
	print("Activity_9001665_RankPanel:ctor", self.viewName)
	self.debug = true
	self.iBegin = 1
	self.nCount = 10
	self.rankList, Activity_9001665_RankPanel, self.hasMore = print, print, true
end
function Activity_9001665_RankPanel:onInit()
	print("=======Activity_9001665_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("pyramid_btn_29"), handler(self, self.onClickClose))
	self.tabIndex = 0
	_ENV = i18n("pyramid_btn_29")
	_ENV, _ENV, i18n("pyramid_btn_29").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_851")
	_ENV, self.tabIndex[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_1875")
	i18n("pyramid_btn_29").tabsetArray, self.tabIndex[2], handler(self, self.onClickClose).tag = self.tabIndex, handler(self, self.onClickClose)
	i18n("pyramid_btn_29").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((i18n("pyramid_btn_29")))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.List_award:setVirtual()
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.Text_reward:setString(i18n("common_text_3156"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_reward:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_rank:fixPos()
end
function Activity_9001665_RankPanel:onShow()
	print("=======Activity_9001665_RankPanel:onShow")
	self:req4Data()
end
function Activity_9001665_RankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function Activity_9001665_RankPanel:req4Data()
	activity_9001665_Ctrl:reqRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001665_RankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function Activity_9001665_RankPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function Activity_9001665_RankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if self.iBegin == 1 then
		local lordInfo = lordInfoCtrl:getLordInfo()
		if not rspdata.myInfo then
			_ENV = rspdata.myInfo
			rspdata.myInfo.name = lordInfo.base.nickName
			local rspdata.myInfo.kid, myInfo = gametop.playertop_:getKingdomID(), rspdata.myInfo
		end
		if myInfo then
			myInfo.score = myInfo.score or activity_9001665_Ctrl:getMaxScore()
			myInfo.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or nil
		end
		myInfo.isOwnRank = true
		_ENV = self:displayObject()
		self:displayObject().index = myInfo.rank or 0
		self:displayObject().bottom = 1
		self:displayObject().kid = myInfo.kid
		self.fields.Com_ownRank:initData(myInfo, self:displayObject())
		self.fields.Com_ownRank:setVisible(true)
	end
	if not rspdata.rank then
		local _ENV, rankList = rspdata.rank, rspdata.rank
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount or #self.rankList >= 500 then
		self.hasMore = false
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function Activity_9001665_RankPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function Activity_9001665_RankPanel:updateUI()
	if self.tabIndex == 0 then
		self:req4Data()
	elseif self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		self.awardList = activity_9001665_Read.getRankRewards()
		self.fields.List_award:setNumItems(#self.awardList)
	end
end
return Activity_9001665_RankPanel
