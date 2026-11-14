local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_MainPanel = class("RoaringFlame_MainPanel", baseFguiPanel)
function RoaringFlame_MainPanel:ctor(...)
	RoaringFlame_MainPanel.super.ctor(self, ...)
	print("RoaringFlame_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
end
function RoaringFlame_MainPanel:initBtnCheat(...)
	local nebulaWarUtil = include("nebulaWarUtil")
	self.debug = nebulaWarUtil.getIsDebug()
	if self.debug then
		self.fields.Button_cheat:setString("切换状态")
		self.fields.Button_cheat:addClickListener(function()
			local cheatCtrl = SoraDGetCtrl("cheatCtrl")
			_ENV = nil
			;(nil).command = "qhlysczt"
			cheatCtrl:reqCheat(nil, nil)
		end)
	else
		self.fields.Button_cheat:setVisible(false)
	end
end
function RoaringFlame_MainPanel:onInit()
	print("=======RoaringFlame_MainPanel:onInit")
	self:initBtnCheat()
	self.fields.Com_title:initData(i18n("flames_dunes_text1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	fguiHelper.SoraDSetComFields(self)
	self.fields.mv_lg:setAllFrameName("G_9001674_saoguang_%.2d.png", 1)
	self.fields.mv_lg:setVisible(false)
	self.fields.Button_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_milestone:addClickListener(handler(self, self.btnMilestoneClick))
	self.fields.Button_camp:addClickListener(handler(self, self.btnCampClick))
	self.fields.Button_weekCard:addClickListener(handler(self, self.btnWeekCardClick))
	self.fields.Button_decree:setString(i18n("flames_dunes_text14"))
	self.fields.Button_decree:addClickListener(handler(self, self.btnDecreeClick))
	self.fields.Button_skill:setString(i18n("atlantiswar_skill_text_001"))
	self.fields.Button_skill:addClickListener(handler(self, self.btnSkillClick))
	self.fields.Button_honorShop:setString(i18n("flames_dunes_text24"))
	self.fields.Button_honorShop:addClickListener(handler(self, self.btnHonorShopClick))
	self.fields.Button_activity:setString(i18n("flames_dunes_text23"))
	self.fields.Button_activity:addClickListener(handler(self, self.btnActivityClick))
	self.fields.Button_hospital:setString(i18n("flames_dunes_text25"))
	self.fields.Button_hospital:addClickListener(handler(self, self.btnHospitalClick))
	_UPVALUE2_, _UPVALUE5_ = self.fields.Button_hospital, self.fields.Button_hospital.addClickListener
	self.fields.Button_hospital.icon = "icon_9001674_rk_zhenying.png"
	_UPVALUE2_, self.fields.Button_hospital[1] = self.fields.Button_camp, self.fields.Button_camp
	_UPVALUE2_, self.fields.Button_hospital[2] = self.fields.Button_camp, i18n("nebula_war_text_0001")
	self.fields.Button_camp.icon = "frame_qmx_jiangli.png"
	_UPVALUE2_, self.fields.Button_camp[1] = self.fields.Button_reward, self.fields.Button_reward
	_UPVALUE2_, self.fields.Button_camp[2] = self.fields.Button_reward, i18n("atlantiswar_text_0019")
	self.fields.Button_reward.icon = "frame_qmx_phb.png"
	_UPVALUE2_, self.fields.Button_reward[1] = self.fields.Button_rank, self.fields.Button_rank
	_UPVALUE2_, self.fields.Button_reward[2] = self.fields.Button_rank, i18n("pyramid_btn_29")
	self.fields.Button_rank.icon = "icon_9001674_rk_lichengbei.png"
	_UPVALUE2_, self.fields.Button_rank[1] = self.fields.Button_milestone, self.fields.Button_milestone
	_UPVALUE2_, self.fields.Button_rank[2] = self.fields.Button_milestone, i18n("history_text_60")
	self.fields.Button_milestone.icon = "icon_lyzc_zjm_zk.png"
	self.fields.Button_milestone[1] = self.fields.Button_weekCard
	self.fields.Button_milestone[2] = i18n("flames_dunes_text51")
	self.fields.Button_hospital.addClickListener[1] = self.fields.Button_hospital
	self.fields.Button_hospital.addClickListener[2] = self.fields.Button_camp
	self.fields.Button_hospital.addClickListener[3] = self.fields.Button_reward
	self.fields.Button_hospital.addClickListener[4] = self.fields.Button_rank
	local self.fields.Button_hospital.addClickListener[5], config = self.fields.Button_milestone, self.fields.Button_hospital.addClickListener
	for __, cfg in ipairs(config) do
		local widget, title = cfg[1], cfg[2]
		widget:setString(title)
		widget:setIcon(cfg.icon)
	end
end
function RoaringFlame_MainPanel:onShow()
	print("=======RoaringFlame_MainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_UPVALUE3_ = nil
	;(nil)[1] = ffa.delay(1.6666666666666667)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.mv_lg:setVisible(true)
		self.fields.mv_lg:setPlaySettings(0, -1, 1, -1)
	end)
	;(nil)[3] = ffa.delay(0.5)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.mv_lg:setVisible(false)
	end)
	;(nil)[5] = ffa.callFunc(function()
		self.fields.mv_lg:setVisible(false)
	end)
	self.fields.mv_lg:runAction(ffa.seq(nil))
	roaringFlameWarCtrl:reqStateData()
	roaringFlameWarCtrl:reqInitData()
	local state = roaringFlameWarCtrl:getCurState()
	if state == ROARING_FLAME_WAR_STATE.BATTLE then
		roaringFlameWarCtrl:reqCaveData()
	end
	if state > ROARING_FLAME_WAR_STATE.MATCH then
		roaringFlameWarCtrl:reqMatchResult()
	else
		_ENV = ffa.seq(nil)
		ffa.seq(nil).err = gErrDef.Err_FLAME_WAR_STATE_ERR
		self:onMsgMatchResult(self, ffa.seq(nil))
	end
	if state >= ROARING_FLAME_WAR_STATE.SETTLE then
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarPalace)
		roaringFlameWarCtrl:reqBuildingOwnerData(buildIDList[1])
	else
		self.fields.palace:initData()
	end
	self:setRedPoint()
end
function RoaringFlame_MainPanel:setRedPoint()
	local ret1 = roaringFlameWarCtrl:isHaveDecreeReward()
	local ret2 = roaringFlameWarCtrl:isHaveDecreeCampReward()
	local retWeek, retWeekNum = roaringFlameWarCtrl:isHaveDecreeTaskReward(1)
	local retSeason, retSeasonNum = roaringFlameWarCtrl:isHaveDecreeTaskReward(2)
	self.fields.Button_decree:setReddot(ret1 or ret2 or retWeek or retSeason)
	local retWeekCard, retWeekCardNum = roaringFlameWarCtrl:isHaveWeeklyGift()
	self.fields.Button_weekCard:setReddot(retWeekCard)
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	local tmpArmyData = armyCtrl:getWoundedArmy(gKingdomClassType.roaringFlame)
	self.fields.Button_hospital:setReddot(next(tmpArmyData) and true or false)
	local shopNum = roaringFlameWarCtrl:getExchangeShopRedNum()
	self.fields.Button_honorShop:setReddot(0 < shopNum, shopNum)
	self.fields.Button_milestone:setReddot(roaringFlameWarCtrl:isHaveMileStoneReward())
	self.fields.Button_camp:setReddot(roaringFlameWarCtrl:isHaveTechPointReward())
	local state = roaringFlameWarCtrl:getCurState()
	if state == ROARING_FLAME_WAR_STATE.BATTLE then
		local taskRedNum = roaringFlameWarCtrl:getPhoenixTaskRedNum()
		local isShow_zp = roaringFlameWarCtrl:isTurntableShowRed()
		local isShow_cbd = roaringFlameWarCtrl:isTreasureCaveShowRed()
		self.fields.Button_activity:setReddot(0 < taskRedNum or isShow_zp or isShow_cbd)
	else
		self.fields.Button_activity:setReddot(false)
	end
end
function RoaringFlame_MainPanel:onMsgMatchResult(target, data)
	for k, index in pairs(ROARING_FLAME_WAR_AREA) do
		self.fields["k" .. index]:initData(index, data)
	end
end
function RoaringFlame_MainPanel:onMsgBuildingInfo(target, data)
	if data.buildInfo then
		self.fields.palace:initData(data.buildInfo)
	end
end
function RoaringFlame_MainPanel:btnHospitalClick()
	SoraDPlaySound()
	local worldMapWarDef = include("worldMapWarDef")
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local mapClassType = gKingdomClassType.roaringFlame
	local queueType = worldMapWarDef.getHostpitalQueueType(mapClassType)
	if armyCtrl:getCuringArmyCount(queueType) > 0 then
		local itemType = worldMapWarDef.getItemTypeByQueueType(queueType)
		local speedUpItemList = backpackCtrl:getSpeedUpItemList(itemType)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queueType)
		else
			local queue = queueCtrl:queryQueue(queueType)
			SoraDShowSpeedUpBox(queue)
		end
	else
		uiManager:show("HospitalView"):setLV(nil, mapClassType)
	end
end
function RoaringFlame_MainPanel:btnActivityClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlameActivity_Main")
end
function RoaringFlame_MainPanel:btnHonorShopClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE, true) then
		uiManager:show("RoaringFlame_Shop")
	end
end
function RoaringFlame_MainPanel:btnSkillClick()
	SoraDPlaySound()
	local curState = roaringFlameWarCtrl:getCurState()
	if curState >= ROARING_FLAME_WAR_STATE.SETTLE then
		SoraDShowMsgTip(i18n("flames_dunes_push78"))
	elseif curState < ROARING_FLAME_WAR_STATE.BATTLE then
		SoraDShowMsgTip(i18n("flames_dunes_text291"))
	else
		uiManager:show("RoaringFlame_Skill")
	end
end
function RoaringFlame_MainPanel:btnDecreeClick()
	SoraDPlaySound()
	local curState = roaringFlameWarCtrl:getCurState()
	if curState == ROARING_FLAME_WAR_STATE.BATTLE then
		_ENV = nil
		;(nil).tag = 1
		uiManager:show("RoaringFlame_Decree", nil)
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function RoaringFlame_MainPanel:btnRankClick()
	SoraDPlaySound()
	local curState = roaringFlameWarCtrl:getCurState()
	local isEnable = curState >= ROARING_FLAME_WAR_STATE.BATTLE
	if not isEnable then
		SoraDShowMsgTip(i18n("flames_dunes_text291"))
		return
	end
	uiManager:show("RoaringFlame_Rank")
end
function RoaringFlame_MainPanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_RewardView")
end
function RoaringFlame_MainPanel:btnMilestoneClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_MileStone")
end
function RoaringFlame_MainPanel:btnCampClick()
	SoraDPlaySound()
	local curState = roaringFlameWarCtrl:getCurState()
	local isMatch = curState > ROARING_FLAME_WAR_STATE.MATCH
	if not isMatch then
		SoraDShowMsgTip(i18n("flames_dunes_text276"))
		return
	end
	uiManager:show("RoaringFlame_CampManage")
end
function RoaringFlame_MainPanel:btnWeekCardClick()
	SoraDPlaySound()
	local curState = roaringFlameWarCtrl:getCurState()
	if curState == ROARING_FLAME_WAR_STATE.BATTLE then
		uiManager:show("RoaringFlame_WeekCard")
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
function RoaringFlame_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).defaultClick = 1
	uiManager:show("RoaringFlameFAQ", nil)
end
function RoaringFlame_MainPanel:updateWarState(...)
	local curState = roaringFlameWarCtrl:getCurState()
	if self.debug then
		local cheatStr = "切换状态" .. curState
		self.fields.Button_cheat:setString(cheatStr)
	end
	self.fields.Com_status:initData()
	self.fields.Com_boxList:initData()
end
function RoaringFlame_MainPanel:onMsgUpdateStateData(target, event)
	self:updateWarState()
end
function RoaringFlame_MainPanel:checkCloseActivity(target, event)
	if not clientEventMgr.getEventInfoByeid(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return RoaringFlame_MainPanel
