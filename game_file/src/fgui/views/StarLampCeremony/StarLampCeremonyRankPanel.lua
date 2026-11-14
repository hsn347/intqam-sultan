local baseFguiPanel = require("fgui.base.baseFguiPanel")
local starLampCeremonyCtrl = SoraDGetCtrl("starLampCeremonyCtrl")
local starLampCeremonyRead = include("starLampCeremonyRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local StarLampCeremonyRankPanel = class("StarLampCeremonyRankPanel", baseFguiPanel)
function StarLampCeremonyRankPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	self.iBegin = 1
	self.nCount = 10
	self.rankList, _ENV, self.hasMore = self.super.ctor, self.super.ctor, true
	print("StarLampCeremonyRankPanel:ctor", self.viewName)
end
function StarLampCeremonyRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarLampCeremonyRankPanel:onInit()
	print("=======StarLampCeremonyRankPanel:onInit")
	self.tabIndex = 0
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tabIndex, self.tabIndex
	;(nil).title = i18n("Nebulaking_title_06")
	_ENV, self.tabIndex[1], (nil).tag = nil, nil, 0
	;(nil).title = i18n("snowwolf_text_10")
	;(nil).tabsetArray, self.tabIndex[2], (nil).tag = self.tabIndex, nil, 1
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.text_no_rank:setString(i18n("herobattle_text_05"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onAwardItemRederer))
end
function StarLampCeremonyRankPanel:onShow()
	print("=======StarLampCeremonyRankPanel:onShow")
	self:req4Data()
end
function StarLampCeremonyRankPanel:req4Data()
	starLampCeremonyCtrl:reqStarLampCeremonyRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function StarLampCeremonyRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function StarLampCeremonyRankPanel:updateView()
	SoraDCloseLoading(self:displayObject())
	if self.tabIndex == 0 then
		self:req4Data()
	elseif self.tabIndex == 1 then
		self.fields.text_no_rank:setVisible(false)
		self.awardList = starLampCeremonyRead.getRankCfg()
		self.fields.List_reward:setNumItems(#self.awardList)
	end
end
function StarLampCeremonyRankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	self.rankData = starLampCeremonyCtrl:getRankData()
	local _ENV, myInfo = starLampCeremonyCtrl:getRankData(), starLampCeremonyCtrl:getRankData()
	local lordInfo = lordInfoCtrl:getLordInfo()
	_ENV = lordInfoCtrl
	lordInfoCtrl.nickName = lordInfo.base.nickName
	local lordInfoCtrl.kid, data = gametop.playertop_:getKingdomID(), lordInfoCtrl
	data.score = starLampCeremonyCtrl:getMySocre()
	data.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or nil
	_ENV = self:displayObject()
	self:displayObject().index = self.rankData.selfRank or 0
	self:displayObject().bootom = 1
	self:displayObject().kid = data.kid
	self.fields.Com_myRank:initData(data, self:displayObject())
	if not rspdata.rankList then
		local _ENV, rankList = rspdata.rankList, rspdata.rankList
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount or #self.rankList >= 500 then
		self.hasMore = false
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.text_no_rank:setVisible(#self.rankList == 0)
end
function StarLampCeremonyRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function StarLampCeremonyRankPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function StarLampCeremonyRankPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateView()
end
return StarLampCeremonyRankPanel
