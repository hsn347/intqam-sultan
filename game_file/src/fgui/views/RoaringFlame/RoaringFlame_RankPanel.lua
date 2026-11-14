local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_RankPanel = class("RoaringFlame_RankPanel", baseFguiPanel)
function RoaringFlame_RankPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_RankPanel.super.ctor(self, ...)
	print("RoaringFlame_RankPanel:ctor", self.viewName)
end
function RoaringFlame_RankPanel:onInit()
	print("=======RoaringFlame_RankPanel:onInit")
	_ENV, _ENV = "=======RoaringFlame_RankPanel:onInit", print
	;("=======RoaringFlame_RankPanel:onInit").png = "icon_shmc_title_01.png"
	;("=======RoaringFlame_RankPanel:onInit").title = i18n("flames_dunes_text35")
	_ENV, print[1], ("=======RoaringFlame_RankPanel:onInit").tag = "=======RoaringFlame_RankPanel:onInit", "=======RoaringFlame_RankPanel:onInit", 1
	;("=======RoaringFlame_RankPanel:onInit").png = "icon_shmc_title_03.png"
	;("=======RoaringFlame_RankPanel:onInit").title = i18n("flames_dunes_text34")
	_ENV, print[2], ("=======RoaringFlame_RankPanel:onInit").tag = "=======RoaringFlame_RankPanel:onInit", "=======RoaringFlame_RankPanel:onInit", 2
	;("=======RoaringFlame_RankPanel:onInit").png = "icon_shmc_title_02.png"
	;("=======RoaringFlame_RankPanel:onInit").title = i18n("flames_dunes_text338")
	self.exTypeSeasonCfg, print[3], ("=======RoaringFlame_RankPanel:onInit").tag = print, "=======RoaringFlame_RankPanel:onInit", 3
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("flames_dunes_text20"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_none:setString(i18n("common_text_927"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_score:setString(i18n("common_text_1764"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Button_reward:setString(i18n("atlantiswar_text_0019"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_set:addClickListener(handler(self, self.btnSetClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_exType:setItemRenderer(handler(self, self.onExTypeRenderer))
	self.fields.Button_set:fixPos()
	self.fields.Text_score:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Button_reward:fixPos()
end
function RoaringFlame_RankPanel:onItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1], index + 1, self.tag == 1)
end
function RoaringFlame_RankPanel:onExTypeRenderer(index, obj)
	obj:initData(self.exListCfg[index + 1], index + 1, self.extype, handlerEx(self, self.btnExTypeClick, index + 1))
end
function RoaringFlame_RankPanel:btnExTypeClick(index)
	self.extype = index
	self:updateSetBtn()
	self:reqRankMsg()
end
function RoaringFlame_RankPanel:endShow()
	print("=======RoaringFlame_RankPanel:endShow")
	self.tag = self.param and self.param.tag or 1
	self.week = nil
	self.selfCamp = false
	self.extype = self.param and self.param.extype or 1
	self.exListCfg = self.exTypeSeasonCfg
	self:updateSetBtn()
	self.fields.List_exType:setNumItems(#self.exListCfg)
	self.rankList, _ENV = self.fields.List_exType.setNumItems, self.fields.List_exType.setNumItems
	self.fields.List:setNumItems(0)
	_ENV = 0
	;(0).var1 = i18n("common_text_2193")
	;(0).var2 = i18n("flames_dunes_text32")
	local rankStr = i18n("%{var1}:%{var2}", 0)
	if self.selfCamp then
		_ENV = i18n("flames_dunes_text32")
		i18n("flames_dunes_text32").var1 = i18n("common_text_2193")
		i18n("flames_dunes_text32").var2 = i18n("flames_dunes_text33")
		rankStr = i18n("%{var1}:%{var2}", (i18n("flames_dunes_text32")))
	end
	self.fields.Text_rank:setString(rankStr)
	_ENV = rankStr
	_ENV, _ENV, rankStr.defaultClick = "flames_dunes_text33", self.tag, self.tag
	;("flames_dunes_text33").title = i18n("flames_dunes_text21")
	_ENV, self.tag[1], ("flames_dunes_text33").tag = "flames_dunes_text33", "flames_dunes_text33", 1
	;("flames_dunes_text33").title = i18n("flames_dunes_text36")
	_ENV, self.tag[2], ("flames_dunes_text33").tag = "flames_dunes_text33", "flames_dunes_text33", 2
	;("flames_dunes_text33").title = i18n("flames_dunes_text339")
	rankStr.tabsetArray, self.tag[3], ("flames_dunes_text33").tag = self.tag, "flames_dunes_text33", 3
	rankStr.callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(rankStr)
end
function RoaringFlame_RankPanel:onTabClick(tag)
	self.tag = tag
	if #self.rankList > 0 then
		self.fields.List:scrollToView(0)
	end
	self.controllers.c1:setSelectedIndex(self.tag == 3 and 1 or 0)
	self:updateSetBtn()
	self:reqRankMsg()
end
function RoaringFlame_RankPanel:updateSetBtn()
	self.fields.Button_set:setVisible(self.tag ~= 3 or self.extype ~= 3)
end
function RoaringFlame_RankPanel:reqRankMsg()
	if self.tag == 1 then
		if self.week then
			roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.WEEK_CAMP_SCORE, self.week)
		else
			roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.SEASON_CAMP_SCORE)
		end
	elseif self.tag == 2 then
		if self.week then
			roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.WEEK_HONOR, self.week)
		else
			roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.SEASON_HONOR)
		end
	elseif self.tag == 3 then
		if self.extype == 1 then
			if self.week then
				roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.WEEK_KILL_SCORE, self.week)
			else
				roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.SEASON_KILL_SCORE)
			end
		elseif self.extype == 2 then
			if self.week then
				roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.WEEK_PHOENIX_DAMAGE, self.week)
			else
				roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.SEASON_PHOENIX_DAMAGE)
			end
		elseif self.extype == 3 then
			roaringFlameWarCtrl:reqRankList(gRoaringFlameWarRankEnum.SEASON_CAMP_PLAYER_HONOR)
		end
	end
	SoraDShowLoading(self)
end
function RoaringFlame_RankPanel:selectBack(target, data)
	self.week = data.week - 1
	if self.week == 0 then
		self.week = nil
	end
	self.selfCamp = data.camp == 2 and self.tag ~= 1
	_ENV = nil
	;(nil).var1 = i18n("common_text_2193")
	;(nil).var2 = i18n("flames_dunes_text32")
	local rankStr = i18n("%{var1}:%{var2}", nil)
	if self.selfCamp then
		_ENV = i18n("flames_dunes_text32")
		i18n("flames_dunes_text32").var1 = i18n("common_text_2193")
		i18n("flames_dunes_text32").var2 = i18n("flames_dunes_text33")
		rankStr = i18n("%{var1}:%{var2}", (i18n("flames_dunes_text32")))
	end
	self.fields.Text_rank:setString(rankStr)
	self.exListCfg = self.exTypeSeasonCfg
	if self.extype > #self.exListCfg then
		self.extype = 1
	end
	self:updateSetBtn()
	self.fields.List_exType:setNumItems(#self.exListCfg)
	self:reqRankMsg()
end
function RoaringFlame_RankPanel:initView(target, data)
	SoraDCloseLoading(self)
	self.myInfo = data.myInfo
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	if not next(self.myInfo) then
		if self.tag == 1 then
			self.myInfo.member = selfCamp
			self.myInfo.rank = 0
			self.myInfo.score = 0
		else
			local info = lordInfoCtrl:getBaseInfo()
			self.myInfo.allianceAbbr = allianceMgr:getAllianceProperty("abbr")
			self.myInfo.allianceName = allianceMgr:getAllianceProperty("name")
			self.myInfo.avatar = info.avatar
			self.myInfo.headid = info.imageId
			self.myInfo.member = SoraDGetPlayerID()
			self.myInfo.playerName = info.nickName
			self.myInfo.score = 0
			self.myInfo.rank = 0
			self.myInfo.campId = selfCamp
			self.myInfo.kid = lordInfoCtrl:getMapSourceKid()
		end
	end
	self.rankList = data.rankList
	if not self.myInfo.kid then
		self.myInfo.kid = lordInfoCtrl:getMapSourceKid()
	end
	if self.selfCamp and (self.tag ~= 3 or self.extype ~= 3) and self.tag ~= 1 then
		for i = #self.rankList, 1, -1 do
			if self.rankList[i].campId ~= selfCamp then
				table.remove(self.rankList, i)
			end
		end
	end
	for i, v in ipairs(self.rankList) do
		if self.selfCamp and v.member == SoraDGetPlayerID() then
			self.myInfo.rank = i
		end
	end
	self.fields.Com_self:initData(self.myInfo, self.myInfo.rank, self.tag == 1)
	self.fields.List:setNumItems(#self.rankList)
	self.fields.Text_none:setVisible(#self.rankList == 0)
end
function RoaringFlame_RankPanel:btnRewardClick()
	SoraDPlaySound()
	local seasonTag = self.tag
	if seasonTag == 3 then
		seasonTag = self.extype + 2
	end
	_ENV = nil
	;(nil).tag = self.week and 1 or 2
	;(nil).seasonTag = seasonTag
	;(nil).weekTag = 4 < seasonTag and 1 or seasonTag
	uiManager:show("RoaringFlame_RewardView", nil)
end
function RoaringFlame_RankPanel:btnSetClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).week = self.week
	;(nil).camp = self.selfCamp
	;(nil).isCamp = self.tag == 1
	uiManager:show("RoaringFlame_RankSelect", nil)
end
function RoaringFlame_RankPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule03")
	;(nil).content = i18n("flames_dunes_second_rule04")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_RankPanel
