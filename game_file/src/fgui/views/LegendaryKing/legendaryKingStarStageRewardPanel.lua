local gametop = gModuleMgr.getObject("gametop")
local legendRewardRead = include("legendRewardRead")
local legendStageRewardCtrl = gametop.playertop_:getModule("legendStageRewardCtrl")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local legendaryKingStarStageRewardPanel = class("legendaryKingStarStageRewardPanel", baseFguiPanel)
function legendaryKingStarStageRewardPanel:ctor(...)
	self.isLRU = true
	legendaryKingStarStageRewardPanel.super.ctor(self, ...)
	print("legendaryKingStarStageRewardPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.LEGEND_LORD
end
function legendaryKingStarStageRewardPanel:onInit()
	print("=======legendaryKingStarStageRewardPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_3141"), handler(self, self.onClickClose))
	self.fields.btnEnter:setTitle(i18n("common_text_3318"))
	self.fields.btnEnter:addClickListener(handler(self, self.onClick_btnEnter))
	self.fields.btnReceive:setTitle(i18n("ice_carnival_text05"))
	self.fields.btnReceive:addClickListener(handler(self, self.onClick_btnReceive))
	self.fields.txtScore:setString(i18n("text_key"))
	self.fields.btnTip:addClickListener(handler(self, self.onClickTip))
	self.fields.btnLeft:addClickListener(handler(self, self.onClickLeft))
	self.fields.btnRight:addClickListener(handler(self, self.onClickRight))
	self.fields.btnJoin:setTitleText(i18n("common_text_068"))
	self.fields.btnJoin:addClickListener(handler(self, self.onClick_btnJoin))
	self.tag = 1
	_ENV = handler(self, self.onClick_btnJoin)
	_ENV, _ENV, handler(self, self.onClick_btnJoin).defaultClick = handler(self, self.onClick_btnJoin)
	handler(self, self.onClick_btnJoin).title = i18n("legendaryking_text_98")
	_ENV, self.tag[1], handler(self, self.onClick_btnJoin).tag = handler(self, self.onClick_btnJoin)
	handler(self, self.onClick_btnJoin).title = i18n("legendaryking_text_99")
	handler(self, self.onClick_btnJoin).tabsetArray, self.tag[2], handler(self, self.onClick_btnJoin).tag = self.tag, handler(self, self.onClick_btnJoin)
	handler(self, self.onClick_btnJoin).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(handler(self, self.onClick_btnJoin))
	for i = 1, 10 do
		self.fields.comStages:getChild("comStage" .. i):addClickListener(handler(self, self.onClickComStage))
	end
	if SoraDFIsRA() then
		self.fields.comStages:getController("ctrlArab"):setSelectedIndex(1)
	end
end
function legendaryKingStarStageRewardPanel:onMsgRewardInfoBack(target, data)
	SoraDCloseLoading(self)
	local rewardType = self.fields.Com_tab.curTab == 1 and gLegendStageRewardType.PERSONAL or gLegendStageRewardType.ALLIANCE
	local stageType = legendStageRewardCtrl:getStageType(self.mapid)
	self:initData(rewardType, stageType, self.mapid, self.personalType)
end
function legendaryKingStarStageRewardPanel:onMsgTeamUPdate(target, data)
	local stageType = legendStageRewardCtrl:getStageType(self.mapid)
	if self.fields.Com_tab.curTab == 2 then
		self:initData(gLegendStageRewardType.ALLIANCE, stageType, self.mapid, self.personalType)
	end
end
function legendaryKingStarStageRewardPanel:onClickTip(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).rewardType = self.rewardType
	;(nil).stageType = self.stageType
	;(nil).score = self.score
	;(nil).mapid = self.mapid
	;(nil).personalType = self.personalType
	uiManager:show("legendaryKingScoreTip", nil)
end
function legendaryKingStarStageRewardPanel:onClickLeft(...)
	self:initData(gLegendStageRewardType.PERSONAL, self.stageType, self.mapid, math.max(gLegendPersonalStageRewardType.KILL, self.personalType - 1))
end
function legendaryKingStarStageRewardPanel:onClickRight(...)
	self:initData(gLegendStageRewardType.PERSONAL, self.stageType, self.mapid, math.min(gLegendPersonalStageRewardType.NORMAL, self.personalType + 1))
end
function legendaryKingStarStageRewardPanel:endShow()
	print("=======legendaryKingStarStageRewardPanel:endShow")
	self.fields.Com_tab:setTabIndex(self.tag, true)
end
function legendaryKingStarStageRewardPanel:onClick_btnEnter(context)
	SoraDPlaySound()
	local stageType = legendStageRewardCtrl:getStageType(self.mapid)
	if legendStageRewardCtrl:isActivityPrepare(stageType, self.mapid) then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	local isInWar = self:isInWar()
	if not isInWar then
		local stageType = legendStageRewardCtrl:getStageType(self.mapid)
		if stageType == gLegendStageType.KING then
			SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
		elseif stageType == gLegendStageType.KING_STAR then
			SoraDGotoWorldMapPoint(cc.p(150, 150), false, self.mapid)
		elseif stageType == gLegendStageType.HEGEMON then
			local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
			local hegemonRead = include("hegemonRead")
			local bid = hegemonCtrl:getJoinBid()
			local coordinate = hegemonRead.getBuildCoordinate(bid)
			SoraDGotoWorldMapPoint(coordinate, false, worldMapDefine.LEGENDLORD_KINGDOM_ID)
		end
	else
		local sourceKid = gametop.playertop_:getKingdomID()
		if 0 < sourceKid then
			SoraDGotoWorldMapPoint(cc.p(600, 600), false, sourceKid)
		end
	end
	self:close()
	SoraDRemoveAllPanelFromManager()
end
function legendaryKingStarStageRewardPanel:onClick_btnReceive(...)
	SoraDPlaySound()
	local func
	if self.personalType == gLegendPersonalStageRewardType.KILL then
		func = legendStageRewardCtrl.reqKillReward
	elseif self.personalType == gLegendPersonalStageRewardType.LOSE then
		func = legendStageRewardCtrl.reqLoseReward
	end
	if legendStageRewardCtrl:canReceiveReward(self.stageType, self.personalType) then
		if func then
			func(legendStageRewardCtrl)
		end
	else
		SoraDShowMsgTip(i18n("legendaryking_text_109"))
	end
end
function legendaryKingStarStageRewardPanel:isInWar()
	local curKindomID = gametop.playertop_:getKingdomID()
	if worldMapDefine.isInKingStarBattle(curKindomID) and curKindomID == self.mapid then
		return true
	elseif not worldMapDefine.isInKingStarBattle(curKindomID) then
		return worldMapDefine.isInLegendLord()
	end
	return false
end
function legendaryKingStarStageRewardPanel:onClick_btnJoin(context)
	SoraDPlaySound()
	local legendTeamUtil = include("legendTeamUtil")
	legendTeamUtil.openView(self.stageType == gLegendStageType.KING_STAR and worldMapDefine.KINGSTAR_KINGDOM_ID or nil)
end
function legendaryKingStarStageRewardPanel:onClickComStage(context)
	SoraDPlaySound()
	if SoraDGetCtrl("legendTeamCtrl"):isTeamCommander() then
		SoraDShowMsgTip(i18n("legendary_commander_text27"))
		return
	end
	if context.sender.rewardType == gLegendStageRewardType.PERSONAL then
		if context.sender._realRewardType == gLegendStageRewardType.KILL or context.sender._realRewardType == gLegendStageRewardType.LOSE then
			local canReceive = context.sender.receiveStatus == gPersonPalaceReceiveStatus.NO_RECEIVE
			if canReceive then
				if context.sender._realRewardType == gLegendStageRewardType.KILL then
					legendStageRewardCtrl:reqKillReward(context.sender.stage)
				elseif context.sender._realRewardType == gLegendStageRewardType.LOSE then
					legendStageRewardCtrl:reqLoseReward(context.sender.stage)
				else
					dump("unexpected reward type in onClickComStage:", context.sender._realRewardType)
				end
			else
				local panelRewardPreview = SoraDCreatePanel("legendaryStageRewardPreview")
				panelRewardPreview:init(context.sender)
				panelRewardPreview:show()
			end
		else
			local panelRewardPreview = SoraDCreatePanel("legendaryStageRewardPreview")
			panelRewardPreview:init(context.sender)
			panelRewardPreview:show()
		end
	elseif context.sender.rewardType == gLegendStageRewardType.ALLIANCE then
		if self.receiveStatus == gAllianceReceiveStatus.CANNOT_RECEIVE then
			SoraDShowMsgTip(i18n("common_text_3152"))
			return
		end
		local panelRewardPreview = SoraDCreatePanel("legendaryStageRewardPreview")
		panelRewardPreview:init(context.sender)
		panelRewardPreview:show()
	end
end
function legendaryKingStarStageRewardPanel:initData(rewardType, stageType, mapid, personalType)
	self.rewardType = rewardType
	self.stageType = stageType
	self.mapid = mapid
	self.personalType = personalType
	local isInWar = self:isInWar()
	if not isInWar then
		self.fields.btnEnter:setTitleText(i18n("common_text_3318"))
		self.fields.btnEnter.controllers.c1:setSelectedIndex(2)
	else
		self.fields.btnEnter:setTitleText(i18n("common_text_4256"))
		self.fields.btnEnter.controllers.c1:setSelectedIndex(1)
	end
	local stageInfo = legendStageRewardCtrl:getStageInfo()
	local killAndLoseInfo = legendStageRewardCtrl:getKillAndLoseInfo()
	local score, scoreKey, titleKey
	if self.rewardType == gLegendStageRewardType.PERSONAL then
		if not self.personalType then
			self.personalType = gLegendPersonalStageRewardType.KILL
		end
		if self.personalType == gLegendPersonalStageRewardType.NORMAL then
			self.fields.btnRight:setVisible(false)
			self.fields.btnLeft:setVisible(true)
			score = stageInfo.personScore
			titleKey = "common_text_3142"
			self.controllers.ctrlReceive:setSelectedIndex(0)
		elseif self.personalType == gLegendPersonalStageRewardType.KILL then
			self.fields.btnRight:setVisible(true)
			self.fields.btnLeft:setVisible(false)
			score = killAndLoseInfo.personPalaceKillScore
			titleKey = "legendaryking_text_100"
			self.controllers.ctrlReceive:setSelectedIndex(1)
		elseif self.personalType == gLegendPersonalStageRewardType.LOSE then
			self.fields.btnRight:setVisible(true)
			self.fields.btnLeft:setVisible(true)
			score = killAndLoseInfo.personPalaceLoseScore
			titleKey = "legendaryking_text_101"
			self.controllers.ctrlReceive:setSelectedIndex(1)
		end
		scoreKey = "common_text_1256"
	elseif self.rewardType == gLegendStageRewardType.ALLIANCE then
		score = stageInfo.allianceScore
		scoreKey = "free_team_text_68"
		titleKey = "legendaryking_text_99"
		self.fields.btnLeft:setVisible(false)
		self.fields.btnRight:setVisible(false)
		self.fields.Com_tab:setTabIndex(2)
		self.controllers.ctrlReceive:setSelectedIndex(0)
	end
	self.fields.txtTitle:setString(i18n(titleKey))
	_ENV = i18n(titleKey)
	i18n(titleKey).num = string.formatnumberthousands(score)
	self.fields.txtScore:setString(i18n(scoreKey, i18n(titleKey)))
	self.score = score
	if rewardType == gLegendStageRewardType.ALLIANCE and not legendTeamCtrl:isHasTeam() and not kingStarTeamCtrl:isHasTeam() then
		self.fields.txtTip:setString(i18n("free_team_text_67"))
		self.controllers.ctrlTeam:setSelectedIndex(1)
	else
		self.controllers.ctrlTeam:setSelectedIndex(0)
		self:updateStages(rewardType, stageType, personalType)
	end
	self:updateRedDot()
end
function legendaryKingStarStageRewardPanel:onTabClick(tag)
	SoraDShowLoading(self)
	legendStageRewardCtrl:reqReward()
end
function legendaryKingStarStageRewardPanel:updateStages(rewardType, stageType, personalType)
	local _realRewardType
	local stageInfo = legendStageRewardCtrl:getStageInfo()
	local killAndLoseInfo = legendStageRewardCtrl:getKillAndLoseInfo()
	local score
	if rewardType == gLegendStageRewardType.PERSONAL then
		personalType = personalType or gLegendPersonalStageRewardType.KILL
		if personalType == gLegendPersonalStageRewardType.KILL then
			score = killAndLoseInfo.personPalaceKillScore
			_realRewardType = gLegendStageRewardType.KILL
		elseif personalType == gLegendPersonalStageRewardType.LOSE then
			score = killAndLoseInfo.personPalaceLoseScore
			_realRewardType = gLegendStageRewardType.LOSE
		elseif personalType == gLegendPersonalStageRewardType.NORMAL then
			score = stageInfo.personScore
			_realRewardType = rewardType
		end
	elseif rewardType == gLegendStageRewardType.ALLIANCE then
		score = stageInfo.allianceScore
		_realRewardType = rewardType
	end
	local stageRewards = legendRewardRead.getStageRewardByType(stageType, _realRewardType, self.mapid)
	for i = 1, 10 do
		local reward = stageRewards[i]
		if reward then
			self.fields.comStages:getChild("comStage" .. i):initData(i, stageType, rewardType, score, reward.maxScore, reward.needscore, reward.totalPrice, self.mapid, _realRewardType)
			self.fields.comStages:getChild("comStage" .. i):setVisible(true)
		else
			self.fields.comStages:getChild("comStage" .. i):setVisible(false)
		end
	end
end
function legendaryKingStarStageRewardPanel:updateRedDot()
	self.fields.btnLeft:setReddot(false, -1)
	self.fields.btnRight:setReddot(false, -1)
	if not self.personalType then
		return
	end
	for i = self.personalType - 1, gLegendPersonalStageRewardType.KILL, -1 do
		if legendStageRewardCtrl:canReceiveReward(self.stageType, i) then
			self.fields.btnLeft:setReddot(true, -1)
			break
		end
	end
	for i = self.personalType + 1, gLegendPersonalStageRewardType.LOSE do
		if legendStageRewardCtrl:canReceiveReward(self.stageType, i) then
			self.fields.btnRight:setReddot(true, -1)
			break
		end
	end
	local canReceiveAny = legendStageRewardCtrl:hasRed(self.stageType)
	self.fields.Com_tab:setBtnRedDot(1, canReceiveAny, -1)
	self.fields.btnReceive:setReddot(legendStageRewardCtrl:canReceiveReward(self.stageType, self.personalType), -1)
end
return legendaryKingStarStageRewardPanel
