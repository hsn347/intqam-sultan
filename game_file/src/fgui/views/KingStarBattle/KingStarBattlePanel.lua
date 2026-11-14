local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local lordLocalData = include("lordLocalData")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local nationalFlagRead = include("nationalFlagRead")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local KingStarBattlePanel = class("KingStarBattlePanel", baseFguiPanel)
_ENV = "KingStarBattlePanel"
;("KingStarBattlePanel").activity = 1
local ("KingStarBattlePanel").lord, LEGENDLORD_VIEW_TYPE = 2, "KingStarBattlePanel"
function KingStarBattlePanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("KingStarBattlePanel:ctor", self.viewName)
end
function KingStarBattlePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function KingStarBattlePanel:onInit()
	print("=======KingStarBattlePanel:onInit")
	self.fields.Com_title:initData(i18n("kingstarbattle_text_24"), handler(self, self.onBackClick), handler(self, self.onClickHelp))
	self.fields.Button_War_Rank:setTitle(i18n("common_text_4232"))
	self.fields.btn_king_reward:setTitle(i18n("kingstarbattle_text_33"))
	self.fields.btn_exchange_shop:setTitle(i18n("kingstarbattle_text_47"))
	self.fields.Top_Button_Reward:setTitle(i18n("common_text_4218"))
	self.fields.Top_Button_Reward:addClickEventListener(handler(self, self.onClick_Button_Reward))
	self.fields.Button_War_Rank:addClickEventListener(handler(self, self.onClick_Button_War_Rank))
	self.fields.opReward:addClickEventListener(handler(self, self.onBtnClickOpReward))
	self.fields.opKingom:addClickEventListener(handler(self, self.onBtnClickOpKingdom))
	self.fields.opWorld:addClickEventListener(handler(self, self.onBtnClickOpWorld))
	self.fields.opGift:addClickEventListener(handler(self, self.onBtnClickOpGift))
	self.fields.opHistory:addClickEventListener(handler(self, self.onBtnClickOpHistory))
	self.fields.opArmy:addClickEventListener(handler(self, self.onBtnClickOpArmy))
	self.fields.Op_warRank:addClickEventListener(handler(self, self.onBtnClickOpWarRank))
	self.fields.Op_manage:addClickEventListener(handler(self, self.onBtnClickOpManage))
	self.fields.Op_History:addClickEventListener(handler(self, self.onBtnClickOpHistory))
	self.fields.Op_land:addClickEventListener(handler(self, self.onBtnClickOpLand))
	self.fields.opReward:setTitle(i18n("kingstarbattle_text_30"))
	self.fields.opKingom:setTitle(i18n("common_text_4216"))
	self.fields.opWorld:setTitle(i18n("common_text_4217"))
	self.fields.opGift:setTitle(i18n("kingstarbattle_text_31"))
	self.fields.opHistory:setTitle(i18n("kingstarbattle_text_27"))
	self.fields.opArmy:setTitle(i18n("kingstarbattle_text_32"))
	self.fields.Op_warRank:setTitle(i18n("common_text_4232"))
	self.fields.Op_manage:setTitle(i18n("kingstarbattle_text_28"))
	self.fields.Op_History:setTitle(i18n("kingstarbattle_text_27"))
	self.fields.Op_land:setTitle(i18n("heroicSouls_text_1"))
	self.remainTime = SoraDCreateTimerLabel(self, self.fields.txtTime)
	self.remainTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.fields.Top_Btn_King:addClickEventListener(handler(self, self.onClickBtnKing))
	self.fields.Image_flag:addTouchEventListener(handler(self, self.onClickBtnAlliance))
	self.fields.btn_king_reward:addTouchEventListener(handler(self, self.onClick_btn_king_reward))
	self.fields.btn_exchange_shop:addTouchEventListener(handler(self, self.onClick_btn_exchange_shop))
	self.fields.Button_hospital:setWarType(gKingdomClassType.legendLord)
	self.fields.Button_hospital:setVisible(false)
end
function KingStarBattlePanel:onShow()
	print("=======KingStarBattlePanel:onShow")
	self.viewType = self.param.viewType
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.KING_STAR_BATTLE
	self.mapid = self.param and self.param.mapid or worldMapDefine.getKingStarMapid(self.activityID)
	if self.mapid then
		self.activityID = worldMapDefine.getKingStarActivityID(self.mapid)
	end
	print("self.activityID======", self.activityID, self.mapid)
	self.remainTime:setTimeEndListener(function()
		self.remainTime:setVisible(false)
		self = self.remainTime
		self.remainTime.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self.remainTime)
		self = self.remainTime
		self.remainTime.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.remainTime.eventID = self.activityID
		SoraDSendMessage(self.remainTime)
	end)
	self.kingReward = legendLordWarltCtrl.getLegendLordWarRankReward(1, self.mapid)
	self:initData()
end
function KingStarBattlePanel:updateTitleStr()
	if self.viewType == LEGENDLORD_VIEW_TYPE.activity then
		LEGENDLORD_VIEW_TYPE = self.viewType
		self.viewType[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_24")
		LEGENDLORD_VIEW_TYPE = nil
		;(nil).ranklist = i18n("remains_name_01")
		self.viewType[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text4", nil)
		LEGENDLORD_VIEW_TYPE = nil
		;(nil).ranklist = i18n("king_star_rank_text3")
		local self.viewType[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text4", nil), self.viewType
		self.fields.Com_title:updateTitle(self.activityID and titleCfg[self.activityID] or i18n("kingstarbattle_text_24"))
	elseif self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		LEGENDLORD_VIEW_TYPE = self.viewType
		self.viewType[gActivityTimeActivityID.KING_STAR_BATTLE] = i18n("kingstarbattle_text_19")
		LEGENDLORD_VIEW_TYPE = "kingstarbattle_text_24"
		;("kingstarbattle_text_24").ranklist = i18n("remains_name_01")
		self.viewType[gActivityTimeActivityID.LEGEND_LORD_9001646] = i18n("king_star_rank_text1", "kingstarbattle_text_24")
		LEGENDLORD_VIEW_TYPE = "kingstarbattle_text_24"
		;("kingstarbattle_text_24").ranklist = i18n("king_star_rank_text3")
		local self.viewType[gActivityTimeActivityID.LEGEND_LORD_9001647], titleCfg = i18n("king_star_rank_text1", "kingstarbattle_text_24"), self.viewType
		self.fields.Com_title:updateTitle(self.activityID and titleCfg[self.activityID] or i18n("kingstarbattle_text_19"))
	end
end
function KingStarBattlePanel:initData()
	if self.viewType == LEGENDLORD_VIEW_TYPE.activity then
		self:initWithActivity()
	elseif self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		self:initWithLord()
	end
end
function KingStarBattlePanel:initView()
	self.legendKingInfo = kingStarCtrl:getLegendKingInfo(self.activityID)
	self.fields.btn_king_reward:setVisible(true)
	self.fields.btn_exchange_shop:setVisible(true)
	if self.viewType == LEGENDLORD_VIEW_TYPE.activity then
		self.controllers.c1:setSelectedIndex(3)
		self.fields.Usm_1:setEffectPath("sp_xwzb01_002.usm", true)
		self.fields.Usm_1:play(true)
		self:updateExchangeNum()
		self:updateTitleStr()
		self:updateLegendKingInfo()
		local strName = self:getLegendKingName()
		if next(self.legendKingInfo) ~= nil and (not next(self.legendKingInfo) or self.legendKingInfo.playerInfo) or not i18n("kingstarbattle_text_80") then
			kingStarCtrl = nil
			;(nil).name = strName
		end
		self.fields.rewards:initData(i18n("kingstarbattle_text_26", nil), self.kingReward)
	elseif self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		self:updateTitleStr()
		self:updateExchangeNum()
		local legendLordActivityStatus = activityShowCtrl:getStateByID(self.activityID)
		if legendLordActivityStatus == gActivityState.OPEN then
			local param = activityShowCtrl:getParamByID(self.activityID)
			local legendLordState = param.curState
			local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				self:initViewLordBattle()
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
				self:initViewLordSettle()
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
			self:initViewLordPrepare()
		elseif legendLordActivityStatus == gActivityState.CLOSE then
			self:initViewLordSettle()
			self.fields.btn_king_reward:setVisible(false)
			self.fields.btn_exchange_shop:setVisible(false)
		end
	end
end
function KingStarBattlePanel:initWithActivity()
	SoraDShowLoading(self)
	kingStarCtrl:reqLegendKingInfo(self.activityID)
	landOfSoulCtrl:reqDeadArmyList(self.activityID)
	legendLordWarCtrl:reqLegendLordData(self.mapid)
end
function KingStarBattlePanel:initWithLord()
	local legendLordActivityStatus = activityShowCtrl:getStateByID(self.activityID)
	if legendLordActivityStatus == gActivityState.OPEN then
		local param = activityShowCtrl:getParamByID(self.activityID)
		local legendLordState = param.curState
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if legendLordState == ACTIVITY_STATE.ACTIVE then
			self:initViewLordBattle()
		elseif legendLordState == ACTIVITY_STATE.SETTLE then
			kingStarCtrl:reqLegendKingInfo(self.activityID)
		end
	elseif legendLordActivityStatus == gActivityState.PREPARE then
		local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		self:initViewLordPrepare()
	elseif legendLordActivityStatus == gActivityState.CLOSE then
		kingStarCtrl:reqLegendKingInfo(self.activityID)
	end
end
function KingStarBattlePanel:initViewLordPrepare()
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Usm_1:setEffectPath("sp_xwzb01_001.usm", true)
	self.fields.Usm_1:play(true)
	self:updateTitleStr()
	self.fields.opArmy:setVisible(false)
	self.fields.text_war_status:setString(i18n("common_text_4210"))
	self:beginTime()
end
function KingStarBattlePanel:initViewLordBattle()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.Usm_1:setEffectPath("sp_xwzb01_001.usm", true)
	self.fields.Usm_1:play(true)
	self:updateTitleStr()
	self.fields.opArmy:setVisible(false)
	self.fields.Button_War_Rank:setTitle(i18n("common_text_4232"))
	self.fields.text_war_status:setString(i18n("common_text_1446"))
	self:beginTime()
	self:reqOccupierInfo()
end
function KingStarBattlePanel:reqOccupierInfo()
	SoraDShowLoading(self)
	self.occupier = nil
	legendLordWarCtrl:getOccupyInfo(self.buildID, self.mapid)
end
function KingStarBattlePanel:showOccupierInfo(target, data)
	SoraDCloseLoading(self)
	self.occupier = data.occupier
	self.fields.occupier:initData(data)
end
function KingStarBattlePanel:updateLegendKingInfo()
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	dump(kingdomInfo, "kingdomInfo===")
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		self.fields.text_king_name:setTitle(i18n("common_text_480"))
		return
	end
	local strKingdomInfo = kingdomInfo.kname
	self.fields.text_kingdom_name:setString(strKingdomInfo)
	local flagImg = nationalFlagRead.getImgByID(kingdomInfo.kflag)
	if flagImg then
		self.fields.sprite_kingdom_icon:setURL(flagImg)
	end
	local playerInfo = self.legendKingInfo.playerInfo
	local strPlayerInfo = playerInfo.nickName
	_ENV = i18n("common_text_480")
	i18n("common_text_480").name = strPlayerInfo
	self.fields.text_king_name:setTitle(i18n("kingstarbattle_text_79", i18n("common_text_480")))
	local portrait = lordLocalData.getPortrait(playerInfo.imageId)
	self.fields.Top_Sprite_king_nor:setVisible(true)
	self.fields.Top_Sprite_king_nor:setURL(portrait)
	local allianceInfo = self.legendKingInfo.allianceInfo
	lordLocalData = self.fields.Top_Sprite_king_nor
	self.fields.Top_Sprite_king_nor[1] = self.fields.Image_flag
	local self.fields.Top_Sprite_king_nor[2], tbNodeAlliance = self.fields.node_alliance, self.fields.Top_Sprite_king_nor
	if allianceInfo and next(allianceInfo) ~= nil and allianceInfo.aid ~= 0 then
		_ENV = i18n("kingstarbattle_text_79", i18n("common_text_480"))
		i18n("kingstarbattle_text_79", i18n("common_text_480")).abbr = allianceInfo.abbr
		i18n("kingstarbattle_text_79", i18n("common_text_480")).name = allianceInfo.alliance
		local strAllianceInfo = i18n("common_text_186", i18n("kingstarbattle_text_79", i18n("common_text_480")))
		self.fields.Image_flag:setTitle(strAllianceInfo)
		self.fields.node_alliance:clearContent()
		local flag = allianceInfo.flag
		if flag then
			local nodeFlag = SoraDGetAllianceFlagByFid(flag)
			if nodeFlag then
				nodeFlag:setScale(0.5)
				self.fields.node_alliance:setContent(nodeFlag)
			end
		end
	else
		SoraDSetNodeArrayVisible(tbNodeAlliance, false)
	end
end
function KingStarBattlePanel:initViewLordSettle()
	self.controllers.c1:setSelectedIndex(2)
	self.fields.Usm_1:setEffectPath("sp_xwzb01_004.usm", true)
	self.fields.Usm_1:play(true)
	self.fields.opArmy:setVisible(true)
	self:updateLegendKingInfo()
	local strName = self:getLegendKingName()
	self:updateTitleStr()
	_ENV = nil
	;(nil).name = strName
	self.fields.rewards:initData(i18n("common_text_4214", nil), self.kingReward)
end
function KingStarBattlePanel:getLegendKingName()
	if next(self.legendKingInfo) == nil or next(self.legendKingInfo) and not self.legendKingInfo.playerInfo then
		return i18n("common_text_480")
	end
	local playerInfo = self.legendKingInfo.playerInfo
	local allianceInfo = self.legendKingInfo.allianceInfo
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	local strInfo = ""
	if allianceInfo and allianceInfo.abbr then
		_ENV = nil
		;(nil).abbr = allianceInfo.abbr
		;(nil).name = playerInfo.nickName
		strInfo = i18n("common_text_186", nil)
	elseif playerInfo then
		strInfo = playerInfo.nickName
	end
	if kingdomInfo then
		strInfo = strInfo .. "#" .. kingdomInfo.kid
	end
	return strInfo
end
function KingStarBattlePanel:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function KingStarBattlePanel:updateTime()
	if self.viewType == LEGENDLORD_VIEW_TYPE.lord then
		local legendLordActivityStatus = activityShowCtrl:getStateByID(self.activityID)
		local textTarget
		local textKey = ""
		if legendLordActivityStatus == gActivityState.OPEN then
			local param = activityShowCtrl:getParamByID(self.activityID)
			local legendLordState = param.curState
			local _eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
			if legendLordState == ACTIVITY_STATE.ACTIVE then
				textTarget = self.fields.text_war_time
				textKey = "common_text_607"
			elseif legendLordState == ACTIVITY_STATE.SETTLE then
			end
		elseif legendLordActivityStatus == gActivityState.PREPARE then
			textTarget = self.fields.text_peace_time
			textKey = "common_text_606"
		end
		local eid = self.activityID
		local eventLeftTime = activityShowCtrl:getTimeInfoByID(eid)
		if eventLeftTime then
			local timerNode = eventLeftTime.timerNode
			if textTarget and timerNode then
				LEGENDLORD_VIEW_TYPE = nil
				;(nil).time = SoraDConvertSecondToString(timerNode.timer:getRemainTime())
				textTarget:setString(i18n(textKey, nil))
			end
		end
	end
end
function KingStarBattlePanel:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function KingStarBattlePanel:onClick_Button_Reward(sender, event)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
	panel:show()
	_ENV = nil
	;(nil).viewType = 5
	panel:init(nil, self.mapid)
end
function KingStarBattlePanel:onClick_Button_War_Rank(sender, event)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("legendaryKingRank")
	panel:init(gLegendBuildID, self.mapid, self.activityID)
	panel:show()
end
function KingStarBattlePanel:onClickBtnKing(sender, event)
	if not self.legendKingInfo then
		return
	end
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		return
	end
	SoraDPlaySound()
	local playerInfo = self.legendKingInfo.playerInfo
	local kid = kingdomInfo.kid
	local uid = playerInfo.uid
	self:reqPlayerInfo(uid, kid)
end
function KingStarBattlePanel:onClickBtnOccupier(sender, event)
	if not self.occupier then
		return
	end
	local playerInfo = self.occupier.playerInfo
	if playerInfo == nil or next(playerInfo) == nil then
		return
	end
	local kingdomInfo = self.occupier.kingdomInfo
	SoraDPlaySound()
	local kid = kingdomInfo and kingdomInfo.kid or playerInfo.kid
	local uid = playerInfo.uid
	self:reqPlayerInfo(uid, kid)
end
function KingStarBattlePanel:reqPlayerInfo(uid, kid)
	SoraDShowLoading(self)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local key = "fromLegendaryKingView_" .. self.viewType
	_ENV = nil
	;(nil)[key] = true
	;(nil).targetName = self.__cname
	lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
end
function KingStarBattlePanel:onClickBtnAlliance(sender, event)
	local kingdomInfo = self.legendKingInfo.kingdomInfo
	if kingdomInfo == nil or next(kingdomInfo) == nil then
		return
	end
	SoraDPlaySound()
	SoraDShowLoading(self)
	local kid = kingdomInfo.kid
	local allianceInfo = self.legendKingInfo.allianceInfo
	local aid = allianceInfo.aid
	local gametop = gModuleMgr.getObject("gametop")
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	print("请求联盟信息, kid = ", kid, ", aid = ", aid)
	_ENV = aid
	aid.from = "KingStarBattlePanel"
	allianceQuery:reqAllianceInfo(kid, aid, aid)
end
function KingStarBattlePanel:onClick_btn_king_reward(sender, event)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("legendaryKingAwardView")
	panel:setWarType(gKingdomClassType.legendLord, self.mapid)
	panel:show()
end
function KingStarBattlePanel:onClick_btn_exchange_shop(sender, event)
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
function KingStarBattlePanel:onClickHelp(sender, event)
	SoraDPlaySound()
	userSDKManager.showFAQSection(_G.gSDKDef.FAQSingleType.KING_STAR_BATTLE)
end
function KingStarBattlePanel:refreshIcon()
	local isSatisfy, num = landOfSoulCtrl:getReceiveStatusAndNum()
	self.fields.Op_land:setReddot(isSatisfy, num)
	local remainTime = landOfSoulCtrl:getSoulRemainTime()
	print("remainTime", remainTime)
	if 0 < remainTime then
		self.remainTime:setVisible(true)
		self.remainTime:setString(SoraDConvertSecondToString(remainTime))
		self.remainTime:beginTime(remainTime)
	else
		self.remainTime:setVisible(false)
	end
end
function KingStarBattlePanel:updateExchangeNum()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local retShop, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.btn_exchange_shop:setReddot(retShop, num)
end
function KingStarBattlePanel:onBtnClickOpReward(sender)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("legendaryKingReward")
	panel:init(self.mapid)
	panel:show()
end
function KingStarBattlePanel:onBtnClickOpKingdom(sender)
	SoraDPlaySound()
	local kingStarGrantViewLayer = SoraDCreatePanel("kingStarGrantView")
	_ENV = nil
	;(nil).grantType = 1
	kingStarGrantViewLayer:init(nil, nil, self.activityID)
	kingStarGrantViewLayer:show()
end
function KingStarBattlePanel:onBtnClickOpWorld(sender)
	SoraDPlaySound()
	local kingStarGrantViewLayer = SoraDCreatePanel("kingStarGrantView")
	_ENV = nil
	;(nil).grantType = 2
	kingStarGrantViewLayer:init(nil, nil, self.activityID)
	kingStarGrantViewLayer:show()
end
function KingStarBattlePanel:onBtnClickOpGift(sender)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
	panel:show()
	_ENV = nil
	;(nil).viewType = 5
	panel:init(nil, self.mapid)
end
function KingStarBattlePanel:onBtnClickOpWarRank(sender)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("legendaryKingRank")
	panel:init(gLegendBuildID, self.mapid, self.activityID)
	panel:show()
end
function KingStarBattlePanel:onBtnClickOpManage(sender)
	SoraDPlaySound()
	self.isCanBack = true
	self.viewType = LEGENDLORD_VIEW_TYPE.lord
	self:initData()
end
function KingStarBattlePanel:onBtnClickOpHistory(sender)
	SoraDPlaySound()
	local panel = SoraDCreatePanelByFixName("kingStarHistory")
	panel:init(gLegendBuildID, self.mapid, self.activityID)
	panel:show()
end
function KingStarBattlePanel:onBtnClickOpLand(sender)
	SoraDPlaySound()
	local remainTime = landOfSoulCtrl:getSoulRemainTime()
	if remainTime <= 0 then
		SoraDShowMsgTip(i18n("heroicSouls_text_20"))
		return
	end
	local deadArmyList = landOfSoulCtrl:getDeadArmyList()
	if not next(deadArmyList) then
		SoraDShowMsgTip(i18n("kingstarbattle_text_29"))
		return
	end
	local panel = SoraDCreatePanel("heroicLandView")
	panel:initData(deadArmyList, self.activityID)
	panel:show()
end
function KingStarBattlePanel:onBtnClickOpArmy(sender)
	SoraDPlaySound()
	local panel = SoraDCreatePanelByFixName("kingStarAlliance")
	panel:init(gLegendBuildID, worldMapDefine.getKingStarMapid(self.activityID))
	panel:show()
end
function KingStarBattlePanel:onBackClick()
	SoraDPlaySound()
	if self.isCanBack then
		self.isCanBack = false
		self.viewType = LEGENDLORD_VIEW_TYPE.activity
		self:initData()
	else
		self:close()
	end
end
function KingStarBattlePanel:onMsgUpdateLegendData(target, event)
	if self.viewType ~= LEGENDLORD_VIEW_TYPE.activity then
		return
	end
	self.fields.Button_hospital:onMsgUpdateWarData()
end
return KingStarBattlePanel
