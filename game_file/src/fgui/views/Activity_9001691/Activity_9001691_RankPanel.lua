local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001691_RankPanel = class("Activity_9001691_RankPanel", baseFguiPanel)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001691_Read = include("activity_9001691_Read")
local activity_9001691_Ctrl = SoraDGetCtrl("activity_9001691_Ctrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
function Activity_9001691_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001691_RankPanel.super.ctor(self, ...)
	self.iBegin = 1
	self.nCount = 10
	self.rankList, Activity_9001691_RankPanel, self.hasMore = Activity_9001691_RankPanel.super.ctor, Activity_9001691_RankPanel.super.ctor, true
end
function Activity_9001691_RankPanel:onInit()
	print("=======Activity_9001691_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("pyramid_btn_29"), handler(self, self.onClickClose))
	self.tabIndex = 1
	_ENV = i18n("pyramid_btn_29")
	_ENV, _ENV, i18n("pyramid_btn_29").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_851")
	_ENV, handler(self, self.onClickClose)[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_1875")
	i18n("pyramid_btn_29").tabsetArray, handler(self, self.onClickClose)[2], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	i18n("pyramid_btn_29").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((i18n("pyramid_btn_29")))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.List_award:setVirtual()
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.Text_score:setString(i18n("common_text_1764"))
	self.fields.Text_stage:setString(i18n("surprise_box_019"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_score:fixPos()
	self.fields.Text_stage:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_rank:fixPos()
end
function Activity_9001691_RankPanel:onShow()
	print("=======Activity_9001691_RankPanel:onShow")
	self.iBegin = 1
	self.nCount = 10
	self.rankList, _ENV, self.hasMore = print, print, true
	self.fields.Com_tab:setDefaultClick(1)
	self:req4Data()
end
function Activity_9001691_RankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function Activity_9001691_RankPanel:req4Data()
	activity_9001691_Ctrl:reqSurpriseBoxPlayerRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001691_RankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function Activity_9001691_RankPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function Activity_9001691_RankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if self.iBegin == 1 then
		local lordInfo = lordInfoCtrl:getLordInfo()
		if not rspdata.myInfo then
			_ENV = rspdata.myInfo
			local rspdata.myInfo.kid, myInfo = gametop.playertop_:getKingdomID(), rspdata.myInfo
		end
		if myInfo then
			myInfo.score = myInfo.score or 0
			myInfo.name = lordInfo.base.nickName
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
	dump(#self.rankList, "self.rankList")
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function Activity_9001691_RankPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function Activity_9001691_RankPanel:updateUI()
	if self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		if self.awardList == nil then
			self.awardList = activity_9001691_Read.getRankCfgs()
		end
		self.fields.List_award:setNumItems(#self.awardList)
	end
end
return Activity_9001691_RankPanel
