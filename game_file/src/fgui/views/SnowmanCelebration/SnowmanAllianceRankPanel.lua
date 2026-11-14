local allianceMgr = SoraDGetCtrl("allianceMgr")
local publicRead = include("publicRead")
local snowmanCelebrationltCtrl = include("snowmanCelebrationltCtrl")
local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowmanAllianceRankPanel = class("SnowmanAllianceRankPanel", baseFguiPanel)
function SnowmanAllianceRankPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SnowmanAllianceRankPanel:ctor", self.viewName)
end
function SnowmanAllianceRankPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
	end
	return self._packageList
end
function SnowmanAllianceRankPanel:onInit()
	print("=======SnowmanAllianceRankPanel:onInit")
	snowmanCelebrationCtrl:sendAllianceRankMsg()
	if not self.countdown then
		self:refreshTimer()
	else
		SoraDManagerRemoveTimer(self, self.countdown)
	end
	self.fields.Com_title:initData(i18n("Endless_trial_text_04"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("Snowman_Activity_06"))
	self.fields.Text_none:setString(i18n("herobattle_text_05"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onItemRenderer))
	if allianceMgr:hasJoinAlliance() then
		local info = allianceMgr:getAllianceInfo().property
		if not info then
		end
		_ENV = allianceMgr
		allianceMgr.abbr = info.abbr
		allianceMgr.aid = info.aid
		allianceMgr.flag = info.flag
		allianceMgr.name = info.name
		allianceMgr.leader = allianceMgr:getAllianceLeaderName(info.aid)
		self.myAllianceInfo, allianceMgr.rank = allianceMgr, 100
	end
end
function SnowmanAllianceRankPanel:refreshTimer()
	self.countdown = SoraDCreateDelayTimer(self, handler(self, self.createTimer2), 108000)
end
function SnowmanAllianceRankPanel:createTimer2()
	if self.countdown then
		SoraDManagerRemoveTimer(self, self.countdown)
	end
	local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
	snowmanCelebrationCtrl:sendAllianceRankMsg()
	_ENV = snowmanCelebrationCtrl
	snowmanCelebrationCtrl.msg = "MESSAGE_SNOWMAN_CELEBRATION_RANK_TIME"
	SoraDSendMessage(snowmanCelebrationCtrl)
end
function SnowmanAllianceRankPanel:initData(data)
	self.data = data.rankData
	if self.data and table.nums(self.data) > 0 then
		self.fields.List_rank:setNumItems(table.nums(self.data))
		self.controllers.state:setSelectedIndex(0)
	else
		self.controllers.state:setSelectedIndex(1)
	end
	if allianceMgr:hasJoinAlliance() then
		local selfRank = snowmanCelebrationCtrl:getPlayerRank()
		self.myAllianceInfo.score = math.floor(data.selfScore)
		self.myAllianceInfo.rank = selfRank
		self.fields.Com_ownRank:initData(self.myAllianceInfo)
	else
		self.fields.Com_ownRank:initData()
	end
end
function SnowmanAllianceRankPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.data[index + 1], snowmanCelebrationltCtrl.getRankInfo(self.data[index + 1].rank))
	object:setIcon(publicRead.getIcon(snowmanCelebrationCtrl:getSkin() == 1 and 1641 or 1647))
end
function SnowmanAllianceRankPanel:refreshView(data)
	self:initData(data)
end
function SnowmanAllianceRankPanel:onClickHelp()
	SoraDPlaySound()
	local ruleStr = snowmanCelebrationCtrl:getSkin() == 1 and "common_text_828" or "ramadan_starlight_01"
	_ENV = nil
	;(nil).content = i18n(ruleStr)
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SnowmanAllianceRankPanel:onShow()
	print("=======SnowmanAllianceRankPanel:onShow")
end
function SnowmanAllianceRankPanel:onHide()
	if self.countdown then
		SoraDManagerRemoveTimer(self, self.countdown)
	end
	print("=======SnowmanAllianceRankPanel:onHide")
end
function SnowmanAllianceRankPanel:onDispose()
	print("=======SnowmanAllianceRankPanel:onDispose")
end
return SnowmanAllianceRankPanel
