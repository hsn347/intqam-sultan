local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local worldMapDefine = include("worldMapDefine")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local ua = include("utilAlign")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local KingStarActivityPanel = class("KingStarActivityPanel", baseFguiPanel)
function KingStarActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("KingStarActivityPanel:ctor", self.viewName)
end
function KingStarActivityPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function KingStarActivityPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======KingStarActivityPanel:onInit")
	self.fields.btn_rank_view:addClickEventListener(handler(self, self.onClick_btn_rank_view))
	self.fields.btn_rank_view:setVisible(false)
	self.fields.btn_team:addClickEventListener(handler(self, self.onClick_btn_team))
	self.fields.btn_enter_battle_active:addClickEventListener(handler(self, self.onClick_btn_enter_battle_active))
	self.fields.btn_enter_battle_prepare:addClickEventListener(handler(self, self.onClick_btn_enter_battle_prepare))
	self.fields.Button_KingAward:addClickEventListener(handler(self, self.onClick_btn_king_reward))
	self.fields.Button_ExchangeShop:addClickEventListener(handler(self, self.onClick_btn_exchange_shop))
	self.fields.btn_stage_reward:addClickEventListener(handler(self, self.onClickBtnStageReward))
	self.fields.text_more:addClickEventListener(handler(self, self.onClickReardMore))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_rank_view:setTitle(i18n("common_text_4232"))
	if kingStarTeamCtrl:isHasTeam() then
		self.fields.btn_team:setTitle(i18n("remains_title_05"))
	else
		self.fields.btn_team:setTitle(i18n("complete_text_03"))
	end
	self.fields.Button_KingAward:setTitle(i18n("kingstarbattle_text_33"))
	self.fields.Button_ExchangeShop:setTitle(i18n("kingstarbattle_text_47"))
	self.fields.btn_enter_battle_prepare:setTitle(i18n("common_text_3318"))
	self.fields.Com_title:initData(i18n("kingstarbattle_text_19"), handler(self, self.onClickClose), handler(self, self.onClick_Button_help))
	self.fields.btn_stage_reward:setTitle(i18n("common_text_3141"))
	self.fields.text_more:setTitle(i18n("common_text_486"))
	self.fields.text_des:setString(i18n("kingstarbattle_text_21"))
	self.fields.text_reward_title:setString(i18n("kingstarbattle_text_23"))
	_UPVALUE6_ = self.fields.text_reward_title.setString
	self.timePadding, self.fields.text_reward_title.setString[1] = self.fields.text_reward_title.setString, 52
	self.timePadding, self.fields.text_reward_title.setString[2] = self.fields.text_reward_title.setString, 56
	self.timePadding, self.fields.text_reward_title.setString[3] = self.fields.text_reward_title.setString, 83
	self.timePadding, self.fields.text_reward_title.setString[4] = self.fields.text_reward_title.setString, 52
	self.timePadding, self.fields.text_reward_title.setString[5] = self.fields.text_reward_title.setString, 86
	self.timePadding, self.fields.text_reward_title.setString[6] = self.fields.text_reward_title.setString, 50
	self.activity_time = self:createTimeNode(7, 259200, self.timePadding)
	self.fields.time_node_cooling:setContent(self.activity_time)
	self.activity_time:setLocalZOrder(10)
	self.fields.Btn_areaTip:addClickListener(handler(self, self.btnAreaTipClick))
	self.fields.Button_hospital:setWarType(gKingdomClassType.legendLord)
end
function KingStarActivityPanel:onItemRenderer(index, obj)
	local reward = self.kingReward[index + 1]
	obj:initData(reward.id, reward.count)
end
function KingStarActivityPanel:onShow()
	print("=======KingStarActivityPanel:onShow")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.KING_STAR_BATTLE
	self.fields.Com_title:updateTitle(clientEventMgr.getEventNameById(self.activityID))
	self.mapID = worldMapDefine.getKingStarMapid(self.activityID)
	self.kingReward = legendLordWarltCtrl.getLegendLordWarRankReward(1, self.mapID)
	self.fields.scroll:setNumItems(#self.kingReward)
	self:init()
end
function KingStarActivityPanel:beginTime()
	self:endTime()
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function KingStarActivityPanel:updateTime()
	local eventLeftTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventLeftTime then
		local timerNode = eventLeftTime.timerNode
		if timerNode then
			self.activity_time:setTime(timerNode.timer:getRemainTime())
		end
	end
end
function KingStarActivityPanel:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
end
function KingStarActivityPanel:init()
	local param = activityShowCtrl:getParamByID(self.activityID)
	self.legendState = param.curState
	if self.legendState == ACTIVITY_STATE.PREPARE then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.text_war_status:setString(i18n("common_text_4210"))
		self.fields.text_time_title:setString(i18n("common_text_608"))
		self:beginTime()
		self.fields.btn_enter_battle_prepare:setBright(false)
	elseif self.legendState == ACTIVITY_STATE.ACTIVE then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.text_time_num:setVisible(self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE)
		self.fields.n18:setVisible(self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE)
		self:beginTime()
		local isInWar = worldMapDefine.isInLegendLord()
		if not isInWar then
			self.fields.btn_enter_battle_active:setTitle(i18n("common_text_3318"))
		else
			self.fields.btn_enter_battle_active:setTitle(i18n("common_text_4256"))
		end
		self.fields.text_war_status:setString(i18n("common_text_1446"))
		self.fields.text_time_title:setString(i18n("common_text_2669"))
		local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
		legendLordWarCtrl:reqLegendLordData(self.mapID)
		self:updateWatchingNum()
		self:updateExchangeNum()
	elseif self.legendState == ACTIVITY_STATE.SETTLE then
	else
		print("kingStarActivity state error! ")
	end
end
function KingStarActivityPanel:updateWatchingNum()
	local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
	local num = legendLordWarCtrl:getWatchingNum()
	if 0 <= num then
		local str = string.formatnumberthousands(num)
		gametop = nil
		;(nil).num = str
		self.fields.text_time_num:setString(i18n("legendaryking_text_32", nil))
	end
end
function KingStarActivityPanel:updateExchangeNum()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local retShop, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.Button_ExchangeShop:setReddot(retShop, num)
end
function KingStarActivityPanel:onClick_Button_help(sender, event)
	SoraDPlaySound()
	userSDKManager.showFAQSection(gSDKDef.FAQSectionType.LEGGEND_LORD)
end
function KingStarActivityPanel:onClickBtnStageReward(sender, event)
	SoraDPlaySound()
	local panel = SoraDCreatePanelByFixName("kingStarStageReward")
	panel:initData(self.mapID)
	panel:show()
end
function KingStarActivityPanel:onClick_btn_rank_view(sender, event)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("legendaryKingRank")
	panel:init(gLegendBuildID, self.mapID, self.activityID)
	panel:show()
end
function KingStarActivityPanel:onClick_btn_enter_battle_active(sender, event)
	SoraDPlaySound()
	local isInWar = worldMapDefine.isInLegendLord()
	if not isInWar then
		SoraDGotoWorldMapPoint(cc.p(150, 150), false, worldMapDefine.getKingStarMapid(self.activityID))
	else
		local sourceKid = gametop.playertop_:getKingdomID()
		if 0 < sourceKid then
			SoraDGotoWorldMapPoint(cc.p(600, 600), false, sourceKid)
		end
	end
	self:close()
	SoraDRemoveAllPanelFromManager()
end
function KingStarActivityPanel:onClick_btn_enter_battle_prepare(sender, event)
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("common_text_2486"))
end
function KingStarActivityPanel:onClick_btn_king_reward(sender, event)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("legendaryKingAwardView")
	panel:setWarType(gKingdomClassType.legendLord, self.mapID)
	panel:show()
end
function KingStarActivityPanel:onClick_btn_exchange_shop(sender, event)
	SoraDPlaySound()
	local legendTeamUtil = include("legendTeamUtil")
	if not legendTeamUtil.isWarTest() then
		local panel = SoraDCreatePanel("legendaryExchangeShopView")
		panel:setActivityID(self.activityID)
		panel:show()
	else
		SoraDShowMsgTip(i18n("Battlefield_queue_text_005"))
	end
end
function KingStarActivityPanel:onClick_btn_team(sender, event)
	SoraDPlaySound()
	local legendTeamUtil = include("legendTeamUtil")
	legendTeamUtil.openView(self.mapID)
end
function KingStarActivityPanel:onClickReardMore()
	SoraDPlaySound()
	local panel = SoraDCreatePanelByFixName("kingStarRewardDetail")
	panel:init(self.mapID)
	panel:show()
end
function KingStarActivityPanel:sMsgTeamUPdate(target, data)
	if kingStarTeamCtrl:isHasTeam() then
		self.fields.btn_team:setTitle(i18n("remains_title_05"))
	else
		self.fields.btn_team:setTitle(i18n("complete_text_03"))
	end
end
function KingStarActivityPanel:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if not data.activityID or type(data.activityID) ~= "table" then
		return
	end
	for i, v in ipairs(data.activityID) do
		if tonumber(v) == self.activityID then
			local activityState = activityShowCtrl:getStateByID(self.activityID)
			print("activityState = ", activityState)
			if activityState == gActivityState.CLOSE then
				self:close()
			elseif activityState == gActivityState.OPEN then
				local param = activityShowCtrl:getParamByID(self.activityID)
				local legendState = param.curState
				if legendState == ACTIVITY_STATE.PREPARE then
					self:init()
				elseif legendState == ACTIVITY_STATE.ACTIVE then
					self:init()
				elseif legendState == ACTIVITY_STATE.SETTLE then
					self:close()
				end
			end
			return
		end
	end
end
function KingStarActivityPanel:createTimeNode(numOfChar, initTime, paddingArray)
	local nodeParent = display.newNode()
	local getCharNode = function()
		local numChar = cc.Label:createWithCharMap("fonts/icon_acitivity_num.png", 35, 46, 48)
		numChar:setAnchorPoint(cc.p(0, 0))
		numChar:setPosition(0, 0)
		return numChar
	end
	local _ENV, numArray
	for i = 1, numOfChar do
		local numChar = getCharNode()
		numChar:addTo(nodeParent)
		numChar:setContentSize(cc.size(35, 46))
		numChar:setFontSize(46)
		numArray[i] = numChar
	end
	SoraDAlignNodeArray(numArray, false, paddingArray)
	local time_node_cooling = self.fields.time_node_cooling
	function nodeParent:setTime(secTime)
		local timeStr = SoraDConvertSecondToStringNoDay(secTime)
		local splitTime = string.split(timeStr, ":")
		if string.len(splitTime[1]) >= 3 then
			if tonumber(splitTime[1]) > 999 then
				splitTime[1] = tostring(999)
			end
			_UPVALUE6_ = tostring(999)
			tostring(999)[1] = string.sub(timeStr, 1, 1)
			tostring(999)[2] = string.sub(timeStr, 2, 2)
			tostring(999)[3] = string.sub(timeStr, 3, 3)
			tostring(999)[4] = string.sub(timeStr, 5, 5)
			tostring(999)[5] = string.sub(timeStr, 6, 6)
			tostring(999)[6] = string.sub(timeStr, 8, 8)
			tostring(999)[7] = string.sub(timeStr, 9, 9)
			tostring(999)[8] = string.sub(timeStr, 9, 9)
			tostring(999)[9] = string.sub(timeStr, 9, 9)
			local tostring(999)[10], strArray = string.sub(timeStr, 9, 9)
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		else
			print("timeStr = ", timeStr)
			_UPVALUE6_ = print
			print[1] = tostring(0)
			print[2] = string.sub(timeStr, 1, 1)
			print[3] = string.sub(timeStr, 2, 2)
			print[4] = string.sub(timeStr, 4, 4)
			print[5] = string.sub(timeStr, 5, 5)
			print[6] = string.sub(timeStr, 7, 7)
			print[7] = string.sub(timeStr, 8, 8)
			print[8] = string.sub(timeStr, 8, 8)
			print[9] = string.sub(timeStr, 8, 8)
			local print[10], strArray = string.sub(timeStr, 8, 8)
			for i = 1, #strArray do
				if numArray[i] then
					numArray[i]:setString(strArray[i])
				end
			end
		end
	end
	nodeParent:setScale(0.9)
	nodeParent:setPositionX(-282)
	if initTime then
		nodeParent:setTime(initTime)
	end
	return nodeParent
end
function KingStarActivityPanel:btnAreaTipClick()
	SoraDPlaySound()
	uiManager:show("KingStarAreaDetail")
end
return KingStarActivityPanel
