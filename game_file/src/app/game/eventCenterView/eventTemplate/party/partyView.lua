local gametop = gModuleMgr.getObject("gametop")
local partyCtrl = SoraDGetCtrl("partyCtrl", gametop)
local partyltCtrl = include("partyltCtrl")
local timeCtrl = gametop.playertop_:getModule("timeCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local partyView = class("partyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("partyView")
	end
	return target
end)
function partyView:ctor()
	self.isHideCurrentSceneView = true
	self:initView()
	self:initEvent()
	self:initTimer()
	self:update()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTY_OPENBACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_PARTYDATA_REFRESH", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.setRank))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function partyView:initView()
	local root = self._ccsView
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_banquet")
	SoraDGetChildByName(self, "faqBtn"):addTouchEventListener(handler(self, partyView.clickFAQBtn))
	SoraDGetChildByName(self, "Top_Size_Tile_Image_bg"):setFillType(1)
	partyCtrl = 1
	;(1)[1] = "Top_node"
	;(1)[2] = "text_activity_lefttime"
	self.activity_lefttime = SoraDGetChildByFullPath(root, 1)
	partyCtrl = 1
	;(1)[1] = "Top_node"
	;(1)[2] = "spt_rank"
	self.rank = SoraDGetChildByFullPath(root, 1)
	self.text_rank = self.rank:getChildByName("text_rank")
	partyCtrl = "text_rank"
	;("text_rank")[1] = "Top_node"
	;("text_rank")[2] = "spt_rankreward"
	self.rankreward = SoraDGetChildByFullPath(root, "text_rank")
	self.text_rankreward = self.rankreward:getChildByName("text_rankreward")
	partyCtrl = "text_rankreward"
	;("text_rankreward")[1] = "Top_node"
	;("text_rankreward")[2] = "text_integral"
	self.text_integral = SoraDGetChildByFullPath(root, "text_rankreward")
	partyCtrl = "text_rankreward"
	;("text_rankreward")[1] = "Top_node"
	;("text_rankreward")[2] = "text_tips"
	self.text_tip_1 = SoraDGetChildByFullPath(root, "text_rankreward")
	print("self:getPanelOffsetHeight()", self:getPanelOffsetHeight())
	local maxPartSize = math.max(self:getPanelOffsetHeight() - 1190, 0) + 759
	local minBtnOffset = math.max(960 - self:getPanelOffsetHeight(), 0)
	partyCtrl = self:getPanelOffsetHeight()
	self:getPanelOffsetHeight()[1] = "Top_node"
	self:getPanelOffsetHeight()[2] = "bg_left"
	self.left_part = SoraDGetChildByFullPath(root, self:getPanelOffsetHeight())
	self.left_part:setContentSize(cc.size(320, maxPartSize))
	local posNodeL = self.left_part:getChildByName("pos_node")
	posNodeL:setPositionY(maxPartSize)
	self.btn_open_party = posNodeL:getChildByName("btn_open_party")
	self.btn_open_party:setPositionY(self.btn_open_party:getPositionY() + minBtnOffset)
	self.text_today_open_left = SoraDGetChildByName(posNodeL, "text_today_open_left")
	partyCtrl = "text_today_open_left"
	;("text_today_open_left")[1] = "Top_node"
	;("text_today_open_left")[2] = "bg_right"
	self.right_part = SoraDGetChildByFullPath(root, "text_today_open_left")
	self.right_part:setContentSize(cc.size(320, maxPartSize))
	local posNodeR = self.right_part:getChildByName("pos_node")
	posNodeR:setPositionY(maxPartSize)
	self.btn_join_party = posNodeR:getChildByName("btn_join_party")
	self.btn_join_party:setPositionY(self.btn_join_party:getPositionY() + minBtnOffset)
	self.icon_event = self.btn_join_party:getChildByName("icon_feast")
	self.text_today_join_left = SoraDGetChildByName(posNodeR, "text_today_join_left")
	self.bigbox = posNodeR:getChildByName("box")
	self.btn_box_reward = self.bigbox:getChildByName("btn_box_reward")
	SoraDSetTextWidthHeight(self.text_today_open_left, cc.size(320, 60))
	SoraDSetTextWidthHeight(self.text_today_join_left, cc.size(320, 60))
	partyCtrl = cc.size(320, 60)
	cc.size(320, 60)[1] = "Top_node"
	cc.size(320, 60)[2] = "reward_info_node"
	self.rewardInfoNode = SoraDGetChildByFullPath(root, cc.size(320, 60))
	self.rewardNodeList, _ENV, self.progress_bar = SoraDGetChildByName(self.rewardInfoNode, "LoadingBar_progress"), SoraDGetChildByName(self.rewardInfoNode, "LoadingBar_progress"), SoraDGetChildByName(self.rewardInfoNode, "LoadingBar_progress")
	self.reward_box = self.rewardInfoNode:getChildByName("reward_box")
	local PFPRD = require_data("party_feast_point_reward_data")
	local max_num = #PFPRD.data[2]
	for i = 1, max_num do
		local _ENV, nodeInfo = cc.size(320, 60)
		nodeInfo.boxNode = self.reward_box:clone()
		nodeInfo.boxNode:setSpriteFrame("icon_Daily_reward_treasure_S_close.png")
		nodeInfo.boxNode:addTo(self.rewardInfoNode)
		nodeInfo.boxNode:setPosition(cc.p(120 * i, 637))
		nodeInfo.numLabel = nodeInfo.boxNode:getChildByName("scoreNum")
		local PFPRD = require_data("party_feast_point_reward_data")
		nodeInfo.numLabel:setString(PFPRD.data[2][i].point)
		self.rewardNodeList[i] = nodeInfo
	end
	self.rankEffectNode = SoraDCreatAnimationEx("partyRankEffectNode", nil, true)
	self.rankEffectNode:addTo(self.rank)
	self.rankEffectNode:setPosition(60, 60)
	self.rankEffectNode:getChildByName("Particle_1"):setBlendFunc(gl.ONE, gl.ONE)
	SoraDMixtureGLONE(self.rankEffectNode:getChildByName("Sprite_2"))
	SoraDMixtureGLONE(self.rankEffectNode:getChildByName("dh_ganenjie_06_3"))
	self.title:setTitle(i18n("feast_title_01"))
	self.text_tip_1:setString(i18n("feast_text_45"))
	self.text_rankreward:setString(i18n("common_text_2194"))
	self.btn_join_party:setTitleText(i18n("feast_text_43"))
	SoraDGetChildByName(self.left_part, "text_open_party"):setString(i18n("feast_btn_03"))
	SoraDGetChildByName(self.right_part, "text_join_party"):setString(i18n("feast_text_43"))
	partyCtrl:sendCheckPartyCenter()
	partyCtrl:sendPartyUserList()
end
function partyView:initEvent()
	for i, v in ipairs(self.rewardNodeList) do
		local btnNode = v.boxNode:getChildByName("eventBtn")
		btnNode:addTouchEventListener(handlerEx(self, partyView.clickRewardNode, i))
	end
	self.rank:getChildByName("btn_rank"):addTouchEventListener(handler(self, partyView.clickRankBtn))
	self.rankreward:getChildByName("btn_rankreward"):addTouchEventListener(handler(self, partyView.clickRankRuleBtn))
	self.btn_open_party:addTouchEventListener(handler(self, partyView.clickMyPartyBtn))
	self.btn_join_party:addTouchEventListener(handler(self, partyView.clickJoinPartyBtn))
	self.btn_box_reward:addTouchEventListener(handler(self, partyView.clickBoxRewardBtn))
end
function partyView:initTimer()
	self.activity_lefttime = SoraDCreateTimerLabel(self, self.activity_lefttime)
	self.activity_lefttime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.activity_lefttime:setTimeEndListener(function()
		self:removeFromParent()
	end)
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PARTY_ACTIVITY)
	if activityTime then
		self.activity_lefttime:beginTime(activityTime.timerNode.timer:getRemainTime())
	end
end
function partyView:update()
	rankingsCtrl:getRankings(lordRankingsDef.partyRank)
	self.text_today_open_left:setString(i18n("feast_text_01") .. partyltCtrl.getLeftInviteNum())
	self.text_today_join_left:setString(i18n("feast_text_02") .. partyltCtrl.getLeftFeastNum())
	self.btn_open_party:setTitleText(i18n("feast_text_06"))
	self.isInInvited = false
	self.isReward = false
	self.isInEvent = false
	local data = partyltCtrl:getPartyData()
	if data.myOpenParty then
		if data.myOpenParty.uidListInfo then
			local isAllDone = true
			for k, v in pairs(data.myOpenParty.uidListInfo) do
				if not v.rStatus2 then
					isAllDone = false
					break
				end
			end
			if isAllDone then
				self.isReward = true
				self.btn_open_party:setTitleText(i18n("common_text_854"))
			end
		end
		if not data.myOpenParty.isEnd then
			self.isReward = false
			self.isInInvited = true
			self.btn_open_party:setTitleText(i18n("feast_title_02"))
		end
		if data.myOpenParty.isEnd and not data.myOpenParty.isReward then
			self.isReward = true
			self.isInInvited = false
			self.btn_open_party:setTitleText(i18n("common_text_854"))
		end
	end
	self.icon_event:setVisible(false)
	self.bigbox:setVisible(false)
	local canClaimNum = 0
	local taskNum = 0
	local ownUUID = lordInfoCtrl:getLordInfo().base.uid
	if data.myAttendPartyList then
		for i, v in ipairs(data.myAttendPartyList) do
			if v.uidListInfo[tostring(ownUUID)] and 0 < v.uidListInfo[tostring(ownUUID)].sEvent and v.uidListInfo[tostring(ownUUID)].sEvent ~= gSpecialEventType.EVENT_TIRED then
				if not v.uidListInfo[tostring(ownUUID)].rStatus2 then
					taskNum = taskNum + 1
				elseif not v.isReward then
					canClaimNum = canClaimNum + 1
				end
				self.isInEvent = true
			end
			if v.uidListInfo[tostring(ownUUID)] and (v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_TIRED or v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.NO_EVENT) and not v.isReward then
				canClaimNum = canClaimNum + 1
			end
		end
		self.icon_event:setVisible(0 < taskNum)
		self.bigbox:setVisible(0 < canClaimNum)
	end
	self:updateScoreView()
end
function partyView:updateScoreView()
	local partyData = partyltCtrl:getPartyData()
	local PFPRD = require_data("party_feast_point_reward_data")
	local maxScore = 0
	local index = 0
	partyltCtrl = nil
	;(nil).num = tonumber(partyData.totalPoint)
	self.text_integral:setString(i18n("common_text_2556", nil))
	for k, v in ipairs(PFPRD.data[2]) do
		self.rewardNodeList[k].numLabel:setString(tostring(v.point))
		local isReceive = partyltCtrl.isScoreBoxReceive(v.point)
		local isUnEnough = tonumber(partyData.totalPoint) < v.point
		SoraDSetGray(self.rewardNodeList[k].boxNode, isUnEnough)
		maxScore = math.max(maxScore, v.point)
		if isReceive then
			self.rewardNodeList[k].boxNode:setSpriteFrame("icon_Daily_reward_treasure_S_open.png")
		end
		if tonumber(partyData.totalPoint) > v.point then
			index = index + 1
		end
	end
	local pastPercent = index / #PFPRD.data[2]
	local notPastPercent = 0
	if index >= #PFPRD.data[2] then
		self.progress_bar:setPercent((pastPercent + notPastPercent) * 100)
	elseif index == 0 then
		notPastPercent = tonumber(partyData.totalPoint) / PFPRD.data[2][1].point / #PFPRD.data[2]
		self.progress_bar:setPercent((pastPercent + notPastPercent) * 100)
	else
		notPastPercent = (tonumber(partyData.totalPoint) - PFPRD.data[2][index].point) / (PFPRD.data[2][index + 1].point - PFPRD.data[2][index].point) / #PFPRD.data[2]
		self.progress_bar:setPercent((pastPercent + notPastPercent) * 100)
	end
end
function partyView:clickRewardNode(index, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local PFPRD = require_data("party_feast_point_reward_data")
		local FPR = require_data("feast_point_reward", true)
		local scoreInfo = PFPRD.data[2][index]
		local rewardInfo = FPR.data[scoreInfo.Index]
		local isReceive = partyltCtrl.isScoreBoxReceive(scoreInfo.point)
		local partyData = partyltCtrl:getPartyData()
		local state = gCommonScoreType.NOT_ENOUGH
		if isReceive then
			state = gCommonScoreType.RECEIVED
		elseif tonumber(partyData.totalPoint) >= scoreInfo.point then
			state = gCommonScoreType.ACTIVE
		end
		SoraDShowCommonScoreView(state, function(target)
			if state == gCommonScoreType.ACTIVE then
				partyCtrl:sendReceivePointReward(scoreInfo.point)
				return true
			end
			return false
		end, rewardInfo.PointReward, true)
	end
end
function partyView:clickRankBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).enum = lordRankingsDef.partyRank
		uiManager:show("rankingsScrollView", nil)
	end
end
function partyView:clickRankRuleBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("partyRankRuleView")
		panel:show()
	end
end
function partyView:clickJoinPartyBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local partyData = partyCtrl:getPartyData()
		if partyData.isTired and timeCtrl:getServerTime() < partyData.tiredEndtime then
			_ENV = partyData.tiredEndtime
			_ENV = "feast_text_40"
			;("feast_text_40").timeHandler = partyltCtrl.getLeftTiredTime
			;("feast_text_40").goldHandler = partyltCtrl.getLeftTiredGold
			;("feast_text_40").isBySelf = false
			SoraDShowSpeedUpBox(partyData.tiredEndtime, function(exitType)
				if exitType == MSGBOX_CALLBACK_SPEEDUP then
					partyCtrl:sendRemoveTired()
				end
			end, i18n("feast_text_40"), "feast_text_40")
			return
		end
		local panel = SoraDCreatePanel("partyListView")
		panel:show()
		if self.isInEvent then
			panel:showOrHideDown(false)
			return
		end
		panel:showOrHideDown(true)
	end
end
function partyView:clickMyPartyBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isReward then
			local rewardsData = partyltCtrl:getPartyData()
			local panel = SoraDCreatePanel("partyOpenRewardView")
			panel:initData(rewardsData.myOpenParty)
			panel:show()
			return
		end
		if self.isInInvited then
			local feastPanel = SoraDCreatePanel("partyFeastListView")
			local partyData = partyltCtrl:getPartyData()
			feastPanel:initData(partyData.myOpenParty.partyID)
			feastPanel:show()
			return
		end
		SoraDCreatePanel("partyCreateView"):show()
	end
end
function partyView:clickBoxRewardBtn(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("partyListView")
		panel:showOrHideDown(false)
		panel:show()
	end
end
function partyView:clickFAQBtn(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PARTY_ACTIVITY)
	end
end
function partyView:setRank(target, data)
	if data.rank.league then
		if data.rank.league == 0 then
			self.text_rank:setString(i18n("common_text_827"))
		else
			self.text_rank:setString(i18n("legendaryking_title_03") .. data.rank.league)
		end
	end
end
function partyView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PARTY_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return partyView
