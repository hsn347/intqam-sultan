local activity_9001642_Read = include("activity_9001642_Read")
local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001642_RankPanel = class("Activity_9001642_RankPanel", baseFguiPanel)
function Activity_9001642_RankPanel:ctor(...)
	Activity_9001642_RankPanel.super.ctor(self, ...)
	print("Activity_9001642_RankPanel:ctor", self.viewName)
end
function Activity_9001642_RankPanel:onInit()
	print("=======Activity_9001642_RankPanel:onInit")
	self.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
	self.classType = SoraDGetActivityClassType(self.activityID)
	self.rankList, _ENV, self.tag = SoraDGetActivityClassType(self.activityID), SoraDGetActivityClassType(self.activityID), 1
	self.myInfo = nil
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_none:setString(i18n("Celestial_defense_text_024"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_score:setString(i18n("common_text_3156"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankRenderer))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
end
function Activity_9001642_RankPanel:onRankRenderer(index, obj)
	obj:initData(self.rankList[index + 1], index + 1, self.tag)
end
function Activity_9001642_RankPanel:onShow()
	print("=======Activity_9001642_RankPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("common_text_1153")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Phonex_Challenge_text_20")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(nil)
end
function Activity_9001642_RankPanel:onTabClick(tag)
	self.tag = tag
	if self.tag == 1 then
		self.fields.Text_name:setString(i18n("common_text_069"))
		activity_9001642_Ctrl:sendReqAllianceRankMsg()
	elseif self.tag == 2 then
		self.fields.Text_name:setString(i18n("common_text_1536"))
		activity_9001642_Ctrl:sendReqPlayerRankMsg()
	end
end
function Activity_9001642_RankPanel:updateView(target, data)
	dump(data, "Activity_9001642_RankPanel:updateView data=====", 10)
	if not data.rankList then
		_ENV = data.rankList
	end
	self.rankList = data.rankList
	self.myInfo = data.myInfo
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_none:setVisible(#self.rankList == 0)
	if not self.myInfo then
		if self.tag == 1 then
			local alliance = allianceMgr:getAlliance()
			if alliance then
				_ENV = allianceMgr
				allianceMgr.abbr = alliance:getProperty("abbr")
				allianceMgr.aid = allianceMgr:getOwnAid()
				allianceMgr.flag = alliance:getProperty("flag")
				allianceMgr.kid = lordInfoCtrl:getMapSourceKid()
				allianceMgr.leader = alliance:getProperty("leader")
				allianceMgr.leaderName = allianceMgr:getAllianceLeaderName()
				allianceMgr.name = alliance:getProperty("name")
				allianceMgr.rank = 0
				self.myInfo, allianceMgr.score = allianceMgr, activity_9001642_Ctrl:getAllianceScore()
			else
				_ENV = allianceMgr
				allianceMgr.abbr = nil
				allianceMgr.aid = 0
				allianceMgr.flag = 1
				allianceMgr.kid = lordInfoCtrl:getMapSourceKid()
				allianceMgr.leader = nil
				allianceMgr.leaderName = nil
				allianceMgr.name = nil
				allianceMgr.rank = 0
				self.myInfo, allianceMgr.score = allianceMgr, 0
			end
		else
			local base = lordInfoCtrl:getBaseInfo()
			_ENV = lordInfoCtrl
			lordInfoCtrl.allianceAbbr = allianceMgr:getAllianceProperty("abbr")
			lordInfoCtrl.avatar = base.avatar
			lordInfoCtrl.headid = base.imageId
			lordInfoCtrl.kid = lordInfoCtrl:getMapSourceKid()
			lordInfoCtrl.name = base.nickName
			lordInfoCtrl.rank = 0
			lordInfoCtrl.score = 0
			self.myInfo, lordInfoCtrl.uid = lordInfoCtrl, SoraDGetPlayerID()
		end
	end
	self.fields.Com_ownRank:initData(self.myInfo, self.myInfo.rank, self.tag)
end
function Activity_9001642_RankPanel:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "Activity_9001642_Rank" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function Activity_9001642_RankPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Phonex_Challenge_text_19")
	uiManager:show("RuleView", nil)
end
return Activity_9001642_RankPanel
