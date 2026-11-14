local gametop = gModuleMgr.getObject("gametop")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceDinnerCtrl = SoraDGetCtrl("allianceDinnerCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local AllianceDinnerRankPanel = class("AllianceDinnerRankPanel", baseFguiPanel)
function AllianceDinnerRankPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceDinnerRankPanel:ctor", self.viewName)
	_ENV = print
	print[gAllianceDinnerRankType.PERSON] = 1
	_ENV, self.iBegins, print[gAllianceDinnerRankType.ALLIANCE] = print, print, 1
	print[gAllianceDinnerRankType.PERSON] = true
	self.hasMores, print[gAllianceDinnerRankType.ALLIANCE] = print, true
	_ENV, self.nCount = print, 50
	print[gAllianceDinnerRankType.PERSON], _ENV = self.viewName, self.viewName
	_ENV, self.rankLists, print[gAllianceDinnerRankType.ALLIANCE], _ENV = print, print, self.viewName, self.viewName
	print[gAllianceDinnerRankType.PERSON], _ENV = self.viewName, self.viewName
	self.selfInfos, print[gAllianceDinnerRankType.ALLIANCE], _ENV = print, self.viewName, self.viewName
end
function AllianceDinnerRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceDinnerRankPanel:onInit()
	print("=======AllianceDinnerRankPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.mail_tip:setString(i18n("Snowman_Activity_06"))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List_rank2:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank2:setVirtual()
	self.fields.List_rank2:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	_ENV = self.fields.List_rank2.addEventListener
	self.fields.List_rank2.addEventListener[gAllianceDinnerRankType.PERSON] = self.fields.List_rank
	self.ListRanks, self.fields.List_rank2.addEventListener[gAllianceDinnerRankType.ALLIANCE] = self.fields.List_rank2.addEventListener, self.fields.List_rank2
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.rankType = gAllianceDinnerRankType.PERSON
	_ENV = i18n("herobattle_text_05")
	_ENV, _ENV, i18n("herobattle_text_05").defaultClick = i18n("herobattle_text_05")
	i18n("herobattle_text_05").title = i18n("rides_title_01")
	_ENV, self.rankType[1], i18n("herobattle_text_05").tag = i18n("herobattle_text_05")
	i18n("herobattle_text_05").title = i18n("rides_title_02")
	i18n("herobattle_text_05").tabsetArray, self.rankType[2], i18n("herobattle_text_05").tag = self.rankType, i18n("herobattle_text_05")
	i18n("herobattle_text_05").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(i18n("herobattle_text_05"))
	self.awardLists = allianceDinnerCtrl:getAwardLists()
	self.iBegin = self.iBegins[self.rankType]
	self.hasMore = self.hasMores[self.rankType]
	self.rankList = self.rankLists[self.rankType]
	self.awardList = self.awardLists[self.rankType]
	self.cur_ListRank = self.ListRanks[self.rankType]
end
function AllianceDinnerRankPanel:onShow()
	print("=======AllianceDinnerRankPanel:onShow")
	self:req4Data()
end
function AllianceDinnerRankPanel:req4Data()
	allianceDinnerCtrl:reqAllianceDinnerRank(self.rankType, self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function AllianceDinnerRankPanel:updateUI()
	self:req4Data()
end
function AllianceDinnerRankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if self.iBegin == 1 then
		local myInfo = rspdata.selfInfo
		local lordInfo = lordInfoCtrl:getLordInfo()
		_ENV = lordInfoCtrl
		lordInfoCtrl.nickName = lordInfo.base.nickName
		local lordInfoCtrl.kid, data = gametop.playertop_:getKingdomID(), lordInfoCtrl
		if myInfo then
			data.point = myInfo.point or 0
			data.allianceAbbr = myInfo.allianceAbbr
			data.allianceName = myInfo.allianceName
			data.rank = myInfo.rank
		end
		self.selfInfos[self.rankType] = data
	end
	local selfInfo = self.selfInfos[self.rankType]
	_ENV = self.rankType
	self.rankType.index = selfInfo.rank or 0
	self.rankType.bootom = 1
	self.rankType.kid = selfInfo.kid
	self.rankType.rankType = self.rankType
	self.rankType.rewards = self:getRewards(selfInfo.rank)
	self.fields.Com_ownRank:initData(selfInfo, self.rankType)
	if not rspdata.rankInfo then
		local _ENV, rankList = rspdata.rankInfo, rspdata.rankInfo
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	self.iBegins[self.rankType] = self.iBegin
	if addCount < self.nCount then
		self.hasMore = false
		self.hasMores[self.rankType] = self.hasMore
	end
	self.cur_ListRank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function AllianceDinnerRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function AllianceDinnerRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	if data == nil then
		return
	end
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	;(nil).rankType = self.rankType
	;(nil).rewards = self:getRewards(rank)
	obj:initData(data, nil)
end
function AllianceDinnerRankPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function AllianceDinnerRankPanel:onClickTab(index)
	print("index====", index)
	if self.rankType == index then
		return
	end
	self.controllers.c1:setSelectedIndex(index - 1)
	self.rankType = index
	self.iBegin = self.iBegins[self.rankType]
	self.hasMore = self.hasMores[self.rankType]
	self.rankList = self.rankLists[self.rankType]
	self.awardList = self.awardLists[self.rankType]
	self.cur_ListRank = self.ListRanks[self.rankType]
	if next(self.rankList) == nil then
		self:updateUI()
	else
		local selfInfo = self.selfInfos[self.rankType]
		_ENV = nil
		;(nil).index = selfInfo.rank or 0
		;(nil).bootom = 1
		;(nil).kid = selfInfo.kid
		;(nil).rankType = self.rankType
		;(nil).rewards = self:getRewards(selfInfo.rank)
		self.fields.Com_ownRank:initData(selfInfo, nil)
	end
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function AllianceDinnerRankPanel:getRewards(rank)
	for i, v in ipairs(self.awardList) do
		if rank <= v.rank[2] and rank >= v.rank[1] then
			return v.reward
		end
	end
	_ENV = (for generator)
	return ipairs(self.awardList)
end
return AllianceDinnerRankPanel
