local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local nebulaWarRead = include("nebulaWarRead")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarActivityPanel = class("NebulaWarActivityPanel", baseFguiPanel)
function NebulaWarActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarActivityPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaWarActivityPanel:initBtnCheat(...)
	self.debug = nebulaWarUtil.getIsDebug()
	if self.debug then
		self.fields.Button_cheat:setString("切换状态")
		self.fields.Button_cheat:addClickListener(function()
			local cheatCtrl = SoraDGetCtrl("cheatCtrl")
			_ENV = nil
			;(nil).command = "qhxyzzzt"
			cheatCtrl:reqCheat(nil, nil)
		end)
	else
		self.fields.Button_cheat:setVisible(false)
	end
end
function NebulaWarActivityPanel:onInit()
	print("=======NebulaWarActivityPanel:onInit")
	self.exchangeActID = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
	self.fieldsGroup = fguiHelper.get_fields(self.fields.Com_groupInfo)
	self.fieldsGroup.Button_other:setString(i18n("nebula_war_text_0613"))
	self.fieldsGroup.Button_other:addClickListener(handler(self, self.onClickOperateBtn))
	self.fieldsGroup2 = fguiHelper.get_fields(self.fields.Com_groupInfo2)
	self.fieldsGroup2.Button_other:setString(i18n("nebula_war_text_0615"))
	self.fieldsGroup2.Button_other:addClickListener(handler(self, self.onClickOperateBtn))
	self.fieldsVs = fguiHelper.get_fields(self.fields.Com_vsInfo)
	self.fields.Usm_bg:updateUsmColor(self.fields.Image_bg:getColor())
	self.fields.Com_title:initData(i18n("nebula_war_text_0143"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:initBtnCheat()
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Button_team:setString(i18n("remains_text_85"))
	self.fields.Button_milepost:setString(i18n("alliance_stronghold_text_068"))
	self.fields.Button_score:setString(i18n("common_text_2195"))
	self.fields.Button_reward:setString(i18n("atlantiswar_text_0019"))
	self.fields.Button_superTeam:setString(i18n("nebula_war_text_0310"))
	self.fields.Button_shop:setString(i18n("common_text_1809"))
	self.fields.Button_rank:setString(i18n("nebula_war_text_0342"))
	self.fields.Button_schedule:setString(i18n("nebula_war_text_0628"))
	_UPVALUE9_ = self.fields.Button_schedule.setString
	self.fields.Button_schedule.setString[1] = self.fields.Button_detail
	self.fields.Button_schedule.setString[2] = self.fields.Button_team
	self.fields.Button_schedule.setString[3] = self.fields.Button_milepost
	self.fields.Button_schedule.setString[4] = self.fields.Button_score
	self.fields.Button_schedule.setString[5] = self.fields.Button_reward
	self.fields.Button_schedule.setString[6] = self.fields.Button_rank
	self.fields.Button_schedule.setString[7] = self.fields.Button_superTeam
	self.fields.Button_schedule.setString[8] = self.fields.Button_tower
	local self.fields.Button_schedule.setString[9], config = self.fields.Button_schedule, self.fields.Button_schedule.setString
	for i, v in ipairs(config) do
		v:addClickListener(handler(self, self.onClickOperateBtn))
	end
	if worldMapDefine.isInNebula() then
		self.fields.Button_enter:setString(i18n("remains_btn_09"))
	else
		self.fields.Button_enter:setString(i18n("common_text_4413"))
	end
	self.fields.Button_enter:addClickListener(handler(self, self.onClickBtnEnter))
	self.fields.Button_enter:setVisible(false)
	self.fields.Button_shop:addClickListener(handler(self, self.onClickExchangeShop))
	self:openExchangeShop()
end
function NebulaWarActivityPanel:adjustBtnPos()
	local posy = self.fields.Button_tower:getPositionY()
	_UPVALUE5_ = self.fields.Button_tower
	self.fields.Button_tower[1] = self.fields.Button_tower
	self.fields.Button_tower[2] = self.fields.Button_superTeam
	self.fields.Button_tower[3] = self.fields.Button_shop
	self.fields.Button_tower[4] = self.fields.Button_rank
	local self.fields.Button_tower[5], btnList = self.fields.Button_schedule, self.fields.Button_tower
	for i, v in ipairs(btnList) do
		if v:isVisible() then
			v:setPositionY(posy)
			posy = posy + 100
		end
	end
end
function NebulaWarActivityPanel:openExchangeShop()
	if nebulaActivityCtrl:isExchangeShopOpen() then
		self.fields.Button_shop:setVisible(true)
		self:updateBtnShopReddot()
	else
		self.fields.Button_shop:setVisible(false)
	end
	self:adjustBtnPos()
end
function NebulaWarActivityPanel:onClickExchangeShop()
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV110_LIMITED then
		local buildLogic = include("buildLogic")
		_ENV = nil
		;(nil).num = buildLogic.getBuildLvStr(CASTLE_LV110_LIMITED)
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if not nebulaActivityCtrl:isExchangeShopOpen() then
		self:openExchangeShop()
		SoraDShowMsgTip(i18n("notice_0026"))
		return
	end
	_ENV = i18n("notice_0026")
	i18n("notice_0026").id = self.exchangeActID
	uiManager:show("ActExchangePage", i18n("notice_0026")):setOwnerKey(self)
end
function NebulaWarActivityPanel:updateBtnShopReddot()
	local state = activityShowCtrl:getStateByID(self.exchangeActID)
	if state == gActivityState.OPEN then
		local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.exchangeActID)
		self.fields.Button_shop:getChild("Label_reddot"):initData(ret, num)
	end
end
function NebulaWarActivityPanel:onShow()
	print("=======NebulaWarActivityPanel:onShow")
	nebulaActivityCtrl:reqStateData()
	self:refreshView()
	self:updateBtnScore()
end
function NebulaWarActivityPanel:onClickHelp(...)
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEBULA_AREA_ROS)
	end
end
function NebulaWarActivityPanel:refreshView(...)
	local curState = nebulaActivityCtrl:getActivityCurState()
	local stateStr = nebulaWarUtil.getStateName(curState)
	self.fields.Text_begin:setString(stateStr)
	local endTime = nebulaWarUtil.getStateEndTime(curState)
	self.fields.Text_time:beginTime(endTime - serviceFunctions.systemTime())
	local _show = nebulaWarUtil.checkShowEnterBtn() or false
	self.fields.Button_enter:setVisible(_show)
	self.fields.Button_rank:setVisible(nebulaWarUtil.checkShowLastRoundRankBtn())
	self.fields.Button_superTeam:setVisible(nebulaWarUtil.checkShowSuperTeamBtn())
	self.fields.Button_tower:setVisible(nebulaWarUtil.checkNebulaTowerState())
	if nebulaWarUtil.checkSuperTeamSignUpState() then
		self.fields.Button_superTeam:setString(i18n("nebula_war_text_0505"))
	else
		self.fields.Button_superTeam:setString(i18n("nebula_war_text_0371"))
	end
	self:updateBtnSuperTeam()
	local showSchedule = nebulaWarUtil.checkShowScheduleBtn()
	self.fields.Button_schedule:setVisible(showSchedule)
	self.fieldsGroup.Button_other:setVisible(not showSchedule)
	self.fieldsGroup2.Button_other:setVisible(not showSchedule)
	self:updateWarState()
	self:refreshRedDot()
	self:openExchangeShop()
end
function NebulaWarActivityPanel:refreshRedDot()
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local num = nebulaMileStoneCtrl:getCanGetRewardNum()
	dump(num, "NebulaWarActivityPanel:refreshRedDot")
	self.fields.Button_milepost:setReddot(0 < num, num)
end
function NebulaWarActivityPanel:updateWarState(...)
	local stateData = nebulaActivityCtrl:getStateData()
	local curState = nebulaActivityCtrl:getActivityCurState()
	if self.debug then
		local cheatStr = "切换状态" .. curState
		if nebulaWarUtil.IsStateNoUse(curState) then
			cheatStr = cheatStr .. "\n" .. "这是预留状态,继续切"
		end
		self.fields.Button_cheat:setString(cheatStr)
	end
	if stateData.activeTime and stateData.finishTime then
		local timeStr = string.format("%s -- %s", os.date("!%Y.%m.%d", stateData.activeTime), os.date("!%Y.%m.%d", stateData.finishTime - 1))
		self.fields.Text_title1:setString(timeStr)
		self.fields.Text_title2:setString(timeStr)
	end
	if curState == NEBULA_REGION_STATE.SCREEN_SEED_KINGDOM then
		self.controllers.c_state:setSelectedIndex(0)
		self.fields.Text_tip:setString(i18n("nebula_war_text_0497"))
		return
	end
	self.selfGroupId = nebulaActivityCtrl:getSelfGroupId()
	local groupName = nebulaWarRead.getWarGroupName(self.selfGroupId)
	self.selfReginId = nebulaWarUtil.getRegionId()
	local areaName = nebulaWarRead.getAreaName(self.selfReginId)
	nebulaActivityCtrl = i18n("nebula_war_text_0497")
	i18n("nebula_war_text_0497").area = areaName
	self.fields.Text_area:setString(i18n("nebula_war_text_0498", i18n("nebula_war_text_0497")))
	local towerLv = nebulaActivityCtrl:getTowerLv()
	self:updateTowerLv(towerLv)
	if curState >= NEBULA_REGION_STATE.REGION_SHOW and curState <= NEBULA_REGION_STATE.ROUND4END then
		nebulaActivityCtrl = i18n("nebula_war_text_0498", i18n("nebula_war_text_0497"))
		i18n("nebula_war_text_0498", i18n("nebula_war_text_0497")).camp = groupName
		self.fields.Text_group:setString(i18n("nebula_war_text_0499", i18n("nebula_war_text_0498", i18n("nebula_war_text_0497"))))
		if nebulaWarUtil.checkShowEnterBtn() then
			self.controllers.c_state:setSelectedIndex(3)
			nebulaActivityCtrl:reqCampScore()
			SoraDShowLoading(self:displayObject())
			self.fields.Com_vsInfo:setVisible(false)
			nebulaActivityCtrl = self:displayObject()
			self:displayObject().area = areaName
			self.fieldsVs.Text_area:setString(i18n("nebula_war_text_0498", self:displayObject()))
			nebulaActivityCtrl = i18n("nebula_war_text_0498", self:displayObject())
			i18n("nebula_war_text_0498", self:displayObject()).camp = groupName
			self.fieldsVs.Text_group:setString(i18n("nebula_war_text_0499", i18n("nebula_war_text_0498", self:displayObject())))
		elseif nebulaWarUtil.checkIsInWarReady() then
			self.controllers.c_state:setSelectedIndex(2)
			if nebulaWarRead.checkCampType1(self.selfReginId) then
				local c1 = self.fields.Com_groupInfo2:getController("c1")
				c1:setSelectedIndex(1)
			end
			local groupId = nebulaWarUtil.getFightGroupId()
			_ENV = c1.setSelectedIndex
			c1.setSelectedIndex[1] = self.selfGroupId
			local c1.setSelectedIndex[2], groupIdList = groupId, c1.setSelectedIndex
			if not nebulaWarRead.checkCampType1(self.selfReginId) then
				for groupId = 1, 4 do
					if not table.indexof(groupIdList, groupId) then
						table.insert(groupIdList, groupId)
					end
				end
			end
			for index, groupId in ipairs(groupIdList) do
				local Com_group = self.fieldsGroup2["Com_group" .. index]
				self:onGroupItemRenderer(groupId, Com_group)
			end
		else
			self.controllers.c_state:setSelectedIndex(1)
			if nebulaWarRead.checkCampType1(self.selfReginId) then
				local c1 = self.fields.Com_groupInfo:getController("c1")
				c1:setSelectedIndex(1)
			end
			nebulaWarUtil = c1
			local self.fields.Com_groupInfo:getController("c1")[1], groupIdList = self.selfGroupId, self.fields.Com_groupInfo:getController("c1")
			if not nebulaWarRead.checkCampType1(self.selfReginId) then
				for groupId = 1, 4 do
					if not table.indexof(groupIdList, groupId) then
						table.insert(groupIdList, groupId)
					end
				end
			end
			for index, groupId in ipairs(groupIdList) do
				local Com_group = self.fieldsGroup["Com_group" .. index]
				self:onGroupItemRenderer(groupId, Com_group)
			end
		end
	elseif curState >= NEBULA_REGION_STATE.SETTLE then
		self.controllers.c_state:setSelectedIndex(4)
		local rank = nebulaActivityCtrl:getSelfGroupRank()
		nebulaActivityCtrl = table.insert
		table.insert.camp = groupName
		table.insert.num = rank
		self.fields.Text_group:setString(i18n("nebula_war_text_0580", table.insert))
		self.fields.Com_settleInfo:initView()
	end
end
function NebulaWarActivityPanel:updateCampScore(campScoreInfo)
