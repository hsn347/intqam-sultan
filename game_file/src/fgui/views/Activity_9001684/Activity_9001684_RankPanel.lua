local activity_9001684_Ctrl = SoraDGetCtrl("activity_9001684_Ctrl")
local activity_9001684_Read = include("activity_9001684_Read")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001684_RankPanel = class("Activity_9001684_RankPanel", baseFguiPanel)
function Activity_9001684_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001684_RankPanel.super.ctor(self, ...)
	print("Activity_9001684_RankPanel:ctor", self.viewName)
end
function Activity_9001684_RankPanel:onInit()
	print("=======Activity_9001684_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("collect_activity_004"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_none:setString(i18n("hero_appoint_14"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_3155"))
	self.fields.Text_score:setString(i18n("common_text_3156"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
end
function Activity_9001684_RankPanel:onRankRenderer(index, obj)
	obj:initData(self.rankList[index + 1], index + 1)
end
function Activity_9001684_RankPanel:onRewardRenderer(index, obj)
	obj:initData(self.rewardRankList[index + 1])
end
function Activity_9001684_RankPanel:endShow()
	print("=======Activity_9001684_RankPanel:endShow")
	self.rankType = self.param and self.param.rankType or 1
	self.fields.Com_title:updateTitle(self.rankType == 1 and i18n("collect_activity_004") or i18n("collect_activity_017"))
	self.fields.Text_score:setString(self.rankType == 1 and i18n("common_text_3156") or i18n("collect_activity_023"))
	self.tag = 1
	_ENV = self.rankType == 1 and i18n("common_text_3156") or i18n("collect_activity_023")
	_ENV, _ENV, (self.rankType == 1 and i18n("common_text_3156") or i18n("collect_activity_023")).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("collect_activity_013")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("collect_activity_014")
	;(self.rankType == 1 and i18n("common_text_3156") or i18n("collect_activity_023")).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(self.rankType == 1 and i18n("common_text_3156") or i18n("collect_activity_023")).callback = handler(self, self.onClickTab)
	self.fields.Com_Tab:initView(self.rankType == 1 and i18n("common_text_3156") or i18n("collect_activity_023"))
end
function Activity_9001684_RankPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.myInfo = nil
	if self.tag == 1 then
		self.rankIndex = 1
		self.rankList, activity_9001684_Ctrl, self.rankCount = self.tag, self.tag, 50
		if self.rankType == 1 then
			activity_9001684_Ctrl:reqNumRank(self.rankIndex, self.rankCount)
		else
			activity_9001684_Ctrl:reqBossDmgRank(self.rankIndex, self.rankCount)
		end
		SoraDShowLoading(self)
	else
		self.fields.Text_none:setVisible(false)
		self.rewardRankList = activity_9001684_Read.getRankRewardCfg(self.rankType)
		self.fields.List_reward:setNumItems(#self.rewardRankList)
	end
end
function Activity_9001684_RankPanel:initView(target, data)
	SoraDCloseLoading(self)
	if data.key == "rank" then
		self.isEndless = #data.rankList < self.rankCount
		for k, v in ipairs(data.rankList) do
			table.insert(self.rankList, v)
		end
		self.fields.List_rank:setNumItems(#self.rankList)
		self.fields.Text_none:setVisible(#self.rankList == 0 and self.tag == 1)
		if self.rankType == 1 then
			self.rankIndex = self.rankIndex + #self.rankList
		end
		self.myInfo = data.myInfo
		if not self.myInfo then
			for k, v in ipairs(self.rankList) do
				if v.uid == SoraDGetPlayerID() then
					self.myInfo = v
					break
				end
			end
		end
		if not self.myInfo then
			local base = lordInfoCtrl:getBaseInfo()
			_ENV = lordInfoCtrl
			lordInfoCtrl.allianceAbbr = allianceMgr:getAllianceProperty("abbr")
			lordInfoCtrl.avatar = base.avatar
			lordInfoCtrl.headid = base.imageId
			lordInfoCtrl.kid = lordInfoCtrl:getMapSourceKid()
			lordInfoCtrl.name = base.nickName
			lordInfoCtrl.rank = 0
			lordInfoCtrl.score = self.rankType == 1 and activity_9001684_Ctrl:getMeterialNum() or activity_9001684_Ctrl:getBossDmg()
			self.myInfo, lordInfoCtrl.uid = lordInfoCtrl, SoraDGetPlayerID()
		end
		self.fields.Com_self:initData(self.myInfo)
	end
end
function Activity_9001684_RankPanel:onPullUpRelease()
	if not self.isEndless then
		if self.rankType == 1 then
			activity_9001684_Ctrl:reqNumRank(self.rankIndex, self.rankCount)
		else
			activity_9001684_Ctrl:reqBossDmgRank(self.rankIndex, self.rankCount)
		end
	end
end
function Activity_9001684_RankPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = self.rankType == 1 and i18n("collect_activity_015") or i18n("collect_activity_038")
	uiManager:show("RuleView", nil)
end
return Activity_9001684_RankPanel
