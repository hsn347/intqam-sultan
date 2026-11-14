local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local rankingsCtrl = SoraDGetCtrl("rankingsCtrl")
local cityltCtrl = include("cityltCtrl")
local heroTrialltCtrl = include("heroTrialltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rankingsScrollViewPanel = class("rankingsScrollViewPanel", baseFguiPanel)
function rankingsScrollViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rankingsScrollViewPanel:ctor", self.viewName)
end
function rankingsScrollViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rankingsScrollViewPanel:onInit()
	print("=======rankingsScrollViewPanel:onInit")
	self.tableData, _ENV = print, print
	self.league = 0
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.Text_msg_time = SoraDCreateTimerLabel(self, self.fields.Text_msg_time)
	self.fields.Text_none:setString(i18n("common_text_927"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Button_rankHelp:addClickListener(handler(self, self.onClickBtnRankHelp))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_tip:setString(i18n("common_text_1705"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickListener(handler(self, self.onBtnRewardClick))
	self.fields.Btn_reward:fixPos()
	self.fields.Text_tip:fixPos()
	self.fields.Com_bg:setGradientColor()
end
function rankingsScrollViewPanel:onShow()
	print("=======rankingsScrollViewPanel:onShow")
	self.enum = self.param and self.param.enum or lordRankingsDef.lordPower
	self.isKingdomBattle = self.param and self.param.isKingdomBattle or false
	if RANK_TITLE_CONFIG[self.enum] then
		self.fields.Com_title:updateTitle(i18n(RANK_TITLE_CONFIG[self.enum].title))
	end
	if self.enum == lordRankingsDef.flowerNum then
		self.controllers.c1:setSelectedIndex(1)
	elseif self.enum == lordRankingsDef.htStage or self.enum == lordRankingsDef.htLike then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	if self.isKingdomBattle then
		self.fields.n3:setVisible(false)
		self.fields.Com_self:setVisible(false)
		self.fields.List:setHeight(self.fields.List:getHeight() + 110)
		self.fields.Com_title:setBtnHelpVisible(false)
	end
	if self.enum == lordRankingsDef.alliancePower or self.enum == lordRankingsDef.lordPower then
		self.fields.Text_des:setString(i18n("common_text_090"))
	elseif self.enum == lordRankingsDef.allianceKill or self.enum == lordRankingsDef.lordKill then
		self.fields.Text_des:setString(i18n("common_text_824"))
	elseif self.enum == lordRankingsDef.lordCastle or self.enum == lordRankingsDef.lordLevel or self.enum == lordRankingsDef.lordCastleStarLamp then
		self.fields.Text_des:setString(i18n("common_text_748"))
	elseif self.enum == lordRankingsDef.achieveDoneRatio then
		self.fields.Text_des:setString(i18n("common_text_2022"))
	elseif self.enum == lordRankingsDef.flowerNum then
		self.fields.Text_des:setString(i18n("common_text_2307"))
	elseif self.enum == lordRankingsDef.allianceTerrScore then
		self.fields.Text_des:setString(i18n("common_text_3022"))
	elseif self.enum == lordRankingsDef.militaryRank then
		self.fields.Text_des:setString(i18n("common_text_2429"))
	else
		self.fields.Text_des:setString("")
	end
	_ENV = self.fields.Text_des.setString
	local self.fields.Text_des.setString[lordRankingsDef.militaryRank], config = true, self.fields.Text_des.setString
	local showHelp = config[self.enum] or false
	self.fields.Button_rankHelp:setVisible(showHelp)
	self.fields.Text_rank:fixPos()
	self.fields.Button_rankHelp:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.List:setNumItems(0)
	if self.isKingdomBattle then
		rankingsCtrl:getKingdomRankings(self.enum)
	else
		rankingsCtrl:getRankings(self.enum)
	end
	SoraDShowLoading(self)
end
function rankingsScrollViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableData[index + 1], index + 1, self.enum, self.league, self.isKingdomBattle)
end
function rankingsScrollViewPanel:rankingsBack(target, data)
	SoraDCloseLoading(self)
	if not data.rank.data then
		_ENV = data.rank.data
	end
	self.tableData = data.rank.data
	self.league = data.rank.league or 0
	if data.rank.leftsecs then
		self.Text_msg_time:beginTime(data.rank.leftsecs)
	end
	if 0 >= table.nums(self.tableData) then
		self.fields.Text_none:setVisible(true)
	else
		self.fields.Text_none:setVisible(false)
	end
	self.fields.List:setNumItems(#self.tableData)
	if not (self.league > 0) or not self.tableData[self.league] then
		local _ENV, info = self.tableData[self.league], self.tableData[self.league]
	end
	info.ranking = info.ranking or data.rank.ranking or 0
	info.level = info.level or data.rank.level or 0
	self.fields.Com_self:initSelfData(info, self.enum, self.league)
end
function rankingsScrollViewPanel:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "rankings" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function rankingsScrollViewPanel:onClickHelp(...)
	SoraDPlaySound()
	if self.enum == lordRankingsDef.flowerNum then
		SoraDShowHelpMsgTip(i18n("common_text_2308"))
	elseif self.enum == lordRankingsDef.militaryRank then
		SoraDShowHelpMsgTip(i18n("common_text_4579"))
	else
		SoraDShowHelpMsgTip(i18n("common_text_828"))
	end
end
function rankingsScrollViewPanel:onBtnRewardClick()
	SoraDPlaySound()
	local rankData = self.enum == lordRankingsDef.htStage and heroTrialltCtrl.gePersonaltRankingRewardList() or heroTrialltCtrl.getHTLikeRankingRewardList()
	_ENV = nil
	;(nil).awardList = rankData
	;(nil).title = self.enum == lordRankingsDef.htStage and i18n("common_text_1708") or i18n("common_text_1709")
	uiManager:show("commonRankAwardView", nil)
end
function rankingsScrollViewPanel:onClickBtnRankHelp(...)
	SoraDPlaySound()
	if self.enum == lordRankingsDef.militaryRank then
		local militaryRankRead = include("militaryRankRead")
		local kids = militaryRankRead.getServerGroupKingdomRange()
		local kidStr = table.concat(kids, ",")
		_ENV = nil
		;(nil).kid = kidStr
		SoraDShowHelpMsgTip(i18n("military_rank_text1", nil))
	end
end
return rankingsScrollViewPanel
