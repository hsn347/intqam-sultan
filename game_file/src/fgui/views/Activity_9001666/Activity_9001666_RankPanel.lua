local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001666_RankPanel = class("Activity_9001666_RankPanel", baseFguiPanel)
local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
local activity_9001666_Read = include("activity_9001666_Read")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
function Activity_9001666_RankPanel:ctor(...)
	Activity_9001666_RankPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001666_RankPanel:ctor", self.viewName)
end
function Activity_9001666_RankPanel:onInit()
	print("=======Activity_9001666_RankPanel:onInit")
	self.bigTag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.bigTag, self.bigTag
	;(nil).title = i18n("snow_competition_text_13")
	_ENV, self.bigTag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("snow_competition_text_14")
	;(nil).tabsetArray, self.bigTag[2], (nil).tag = self.bigTag, nil, 2
	;(nil).callback = handler(self, self.onTabBigClick)
	self.fields.Com_tab:initView(nil)
	self.fields.Panel_bg:setTitle(i18n("common_text_851"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List_award:setVirtual()
	self.fields.List_award:setItemRenderer(handler(self, self.onRankRewardRenderer))
	self.fields.Text_noRecrod:setString(i18n("herobattle_text_05"))
	self.fields.Text_noAlliance:setString(i18n("tips_place_noUnion"))
	self.fields.Text_name:setString(i18n("snow_competition_text_16"))
	self.rankList, _ENV, self.rankCfgs = activity_9001666_Read.getRankCfgs(), activity_9001666_Read.getRankCfgs(), activity_9001666_Read.getRankCfgs()
end
function Activity_9001666_RankPanel:req4Data()
	if self.bigTag == 2 then
		activity_9001666_Ctrl:reqSnowCompetitionAllianceRank(self.iBegin, self.nCount)
	else
		activity_9001666_Ctrl:reqSnowCompetitionPlayerRank(self.iBegin, self.nCount)
	end
	SoraDShowLoading(self)
end
function Activity_9001666_RankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function Activity_9001666_RankPanel:onTabBigClick(tag)
	self.bigTag = tag
	local _ENV, _ENV, _ENV, tabsetArray
	;(nil).title = i18n("common_text_851")
	_ENV, (nil)[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("soldier_rush_text_11")
	tabsetArray, (nil)[2], (nil).tag = nil, nil, 2
	self.smallTag = 1
	_ENV = i18n("soldier_rush_text_11")
	i18n("soldier_rush_text_11").defaultClick = self.smallTag
	i18n("soldier_rush_text_11").tabsetArray = tabsetArray
	i18n("soldier_rush_text_11").callback = handler(self, self.onTabSmallClick)
	self.fields.com_TabW:initView((i18n("soldier_rush_text_11")))
	self.rankList, _ENV = self.fields.com_TabW.initView, self.fields.com_TabW.initView
	self.iBegin = 1
	self.nCount = 10
	self:req4Data()
	self.fields.List_rank:setNumItems(#self.rankList)
end
function Activity_9001666_RankPanel:onTabSmallClick(tag)
	self.smallTag = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
	if self.smallTag == 2 then
		self.fields.List_award:setNumItems(#self.rankCfgs[self.bigTag])
	end
end
function Activity_9001666_RankPanel:onShow()
	print("=======Activity_9001666_RankPanel:onShow")
end
function Activity_9001666_RankPanel:onRankItemRenderer(index, obj)
	local data = self.rankList[index + 1]
	data.rank = index + 1
	obj:initData(data)
end
function Activity_9001666_RankPanel:onRankRewardRenderer(index, obj)
	local list = self.rankCfgs[self.bigTag]
	obj:initData(list[index + 1])
end
function Activity_9001666_RankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self)
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if self.iBegin == 1 then
		local isVisble = self.bigTag == 1 or allianceMgr:hasJoinAlliance(true) ~= nil
		if isVisble then
			local myInfo = rspdata.myInfo
			local lordInfo = lordInfoCtrl:getLordInfo()
			if self.bigTag == 1 then
				if not myInfo then
					_ENV = self.bigTag
					self.bigTag.name = lordInfo.base.nickName
					myInfo, self.bigTag.kid = self.bigTag, gametop.playertop_:getKingdomID()
				end
				if myInfo then
					myInfo.score = myInfo.score or 0
					myInfo.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or nil
				end
				self.fields.Com_self:initData(myInfo)
			else
				if not myInfo then
					_ENV = self.fields.Com_self.initData
					self.fields.Com_self.initData.name = lordInfo.base.nickName
					myInfo, self.fields.Com_self.initData.kid = self.fields.Com_self.initData, gametop.playertop_:getKingdomID()
				end
				if myInfo then
					myInfo.score = myInfo.score or 0
					myInfo.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or ""
					myInfo.allianceName = allianceMgr:getAllianceProperty("name") or ""
					myInfo.allianceFlag = allianceMgr:getAllianceProperty("flag") or 0
				end
				self.fields.Com_self:initData(myInfo)
			end
		end
		dump(isVisble, "self.fields.Text_noAlliance:setVisible")
		self.fields.Text_noAlliance:setVisible(not isVisble)
		self.fields.Com_self:setVisible(isVisble)
	end
	if not rspdata.rank then
		local _ENV, rankList = rspdata.rank, rspdata.rank
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	self.hasMore = true
	if addCount < self.nCount or #self.rankList >= 500 then
		self.hasMore = false
	end
	dump(self.rankList, "self.rankList")
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noRecrod:setVisible(#self.rankList == 0)
end
return Activity_9001666_RankPanel
