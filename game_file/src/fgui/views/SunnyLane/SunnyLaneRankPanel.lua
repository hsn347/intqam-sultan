local monsterInvasionCtrl = SoraDGetCtrl("monsterInvasionCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local monsterInvasionRead = include("monsterInvasionRead")
local constantRead = include("constantRead")
local gametop = gModuleMgr.getObject("gametop")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SunnyLaneRankPanel = class("SunnyLaneRankPanel", baseFguiPanel)
function SunnyLaneRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SunnyLaneRankPanel:ctor", self.viewName)
	self.iBegin = 1
	self.nCount = 10
	self.rankList, _ENV, self.hasMore = print, print, true
	self.selfUid = gametop.playertop_:getPlayerID()
end
function SunnyLaneRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SunnyLaneRankPanel:onInit()
	print("=======SunnyLaneRankPanel:onInit")
	self.tabIndex = 0
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tabIndex, self.tabIndex
	;(nil).title = i18n("Nebulaking_title_06")
	_ENV, self.tabIndex[1], (nil).tag = nil, nil, 0
	;(nil).title = i18n("snowwolf_text_10")
	;(nil).tabsetArray, self.tabIndex[2], (nil).tag = self.tabIndex, nil, 1
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
	self.needNum = constantRead.getConstValue("MONSTER_INVASION_RANK_UNLOCK")
	print(self.needNum, "self.needNum")
	self.fields.Com_title:initData(i18n("MonsterInvade_04"), handler(self, self.onClickClose))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRederer))
end
function SunnyLaneRankPanel:onShow()
	print("=======SunnyLaneRankPanel:onShow")
	self.fields.Usm_1:setScale(self.fields.n7:getSize().width / 640)
	self:req4Data()
end
function SunnyLaneRankPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("camp_integral_28"))
end
function SunnyLaneRankPanel:updateUI()
	if self.tabIndex == 0 then
		self:req4Data()
	elseif self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		self.awardList = monsterInvasionRead.getRewardCfg()
		self.fields.List_award:setNumItems(#self.awardList)
		monsterInvasionRead = nil
		;(nil).num = self.needNum
		self.fields.Text_tips:setString(i18n("MonsterInvade_05", nil))
	end
end
function SunnyLaneRankPanel:req4Data()
	monsterInvasionCtrl:reqMonsterInvasionRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function SunnyLaneRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function SunnyLaneRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function SunnyLaneRankPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function SunnyLaneRankPanel:onMsgUpdateRank(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if self.iBegin == 1 then
		if not rspdata.myInfo then
			local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
		end
		local lordInfo = lordInfoCtrl:getLordInfo()
		_ENV = lordInfoCtrl
		lordInfoCtrl.nickName = lordInfo.base.nickName
		local lordInfoCtrl.kid, data = gametop.playertop_:getKingdomID(), lordInfoCtrl
		if myInfo then
			data.score = myInfo.score or 0
			data.allianceAbbr = allianceMgr:getAllianceProperty("abbr") or nil
		end
		_ENV = self:displayObject()
		self:displayObject().index = myInfo.rank or 0
		self:displayObject().bootom = 1
		self:displayObject().kid = data.kid
		self.fields.Com_ownRank:initData(data, self:displayObject())
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
function SunnyLaneRankPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
return SunnyLaneRankPanel
