local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001597_RankPanel = class("Activity_9001597_RankPanel", baseFguiPanel)
local activity_9001597_Read = include("activity_9001597_Read")
local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
function Activity_9001597_RankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001597_RankPanel:ctor", self.viewName)
	self.debug = true
	self.iBegin = 1
	self.nCount = 10
	self.rankList, _ENV, self.hasMore = print, print, true
end
function Activity_9001597_RankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001597_RankPanel:onInit()
	print("=======Activity_9001597_RankPanel:onInit")
	self.activityID = gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597
	self.fields.Com_title:initData(i18n("activity_name_9001597"), handler(self, self.onClickClose))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.tabIndex = 0
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_851")
	_ENV, self.tabIndex[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("common_text_1875")
	self.activityID.tabsetArray, self.tabIndex[2], handler(self, self.onClickClose).tag = self.tabIndex, handler(self, self.onClickClose)
	self.activityID.callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(self.activityID)
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.btn_rule:setTitle(i18n("Ramadan_2024_text31"))
	self.fields.btn_rule:addClickEventListener(handler(self, self.onRuleClick))
	self.fields.txt_score:setString(i18n("common_text_3156"))
	self.fields.txt_name:setString(i18n("common_text_264"))
	self.fields.txt_rank:setString(i18n("common_text_2193"))
	self.fields.btn_rule:fixPos()
end
function Activity_9001597_RankPanel:onShow()
	print("=======Activity_9001597_RankPanel:onShow")
	self:req4Data()
end
function Activity_9001597_RankPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("Ramadan_2024_text27"))
end
function Activity_9001597_RankPanel:updateUI()
	if self.tabIndex == 0 then
		self:req4Data()
	elseif self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		self.awardList = activity_9001597_Read.getRankRewards()
		self.fields.List_award:setNumItems(#self.awardList)
	end
end
function Activity_9001597_RankPanel:req4Data()
	activity_9001597_Ctrl:reqRank(self.iBegin, self.nCount)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001597_RankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function Activity_9001597_RankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	_UPVALUE0_ = nil
	;(nil).index = rank
	;(nil).kid = data.kid
	obj:initData(data, nil)
end
function Activity_9001597_RankPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function Activity_9001597_RankPanel:onMsgUpdateRank(target, event)
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
		self.fields.Com_myRank:initData(data, self:displayObject())
	end
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
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
function Activity_9001597_RankPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function Activity_9001597_RankPanel:onRuleClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("Ramadan_2024_text30"))
end
return Activity_9001597_RankPanel
