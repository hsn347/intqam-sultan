local lordOfDessertRead = include("lordOfDessertRead")
local lordOfDessertCtrl = SoraDGetCtrl("lordOfDessertCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DessertsKingRankPanel = class("DessertsKingRankPanel", baseFguiPanel)
function DessertsKingRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DessertsKingRankPanel:ctor", self.viewName)
end
function DessertsKingRankPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
	end
	return self._packageList
end
function DessertsKingRankPanel:onInit()
	print("=======DessertsKingRankPanel:onInit")
	self.iBegin = 1
	self.nCount = 20
	self.rankList, _ENV, self.hasMore = print, print, true
	self.fields.Com_title:initData(i18n("Endless_trial_text_04"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("Snowman_Activity_06"))
	self.fields.Text_No:setString(i18n("herobattle_text_05"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	if allianceMgr:hasJoinAlliance() then
		local info = allianceMgr:getAllianceInfo().property
		_ENV = allianceMgr
		allianceMgr.abbr = info.abbr
		allianceMgr.aid = info.aid
		allianceMgr.flag = info.flag
		allianceMgr.name = info.name
		allianceMgr.leader = allianceMgr:getAllianceLeaderName(info.aid)
		self.myAllianceInfo, allianceMgr.score = allianceMgr, 0
	end
end
function DessertsKingRankPanel:req4Data()
	lordOfDessertCtrl:reqLordOfDessertRank(self.iBegin, self.nCount)
	SoraDShowLoading(self)
end
function DessertsKingRankPanel:onShow()
	print("=======DessertsKingRankPanel:onShow")
	self:req4Data()
end
function DessertsKingRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function DessertsKingRankPanel:onItemRenderer(index, object)
	local rank = index + 1
	local data = self.rankList[rank]
	object:initData(rank, data, lordOfDessertRead.getRankRewardByRank(lordOfDessertCtrl:getActivityGroup(), self.rankList[rank].rank))
	object:setIcon("icon_EidalAdha_King.png")
end
function DessertsKingRankPanel:onMsgUpdateRank(rspdata)
	SoraDCloseLoading(self)
	if not rspdata.rankList then
		local _ENV, rankList = rspdata.rankList, rspdata.rankList
	end
	for i, v in ipairs(rankList) do
		_ENV = nil
		;(nil).abbr = v.allianceAbbr
		;(nil).aid = v.aid
		;(nil).flag = v.allianceFlag
		;(nil).name = v.allianceName
		;(nil).rank = v.rank
		;(nil).score = v.ranking
		table.insert(self.rankList, v.rank, nil)
	end
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.controllers.state:setSelectedIndex(#self.rankList == 0 and 1 or 0)
	if allianceMgr:hasJoinAlliance() then
		self.myAllianceInfo.score = math.floor(rspdata.selfRank and rspdata.selfRank.ranking or 0)
		self.myAllianceInfo.rank = rspdata.selfRank and rspdata.selfRank.rank or -1
		self.fields.Com_ownRank:initData(self.myAllianceInfo)
	else
		self.fields.Com_ownRank:initData()
	end
end
return DessertsKingRankPanel
