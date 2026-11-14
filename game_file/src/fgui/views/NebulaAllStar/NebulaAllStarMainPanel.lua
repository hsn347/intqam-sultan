local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local NEBULA_ALL_STAR_STATE = nebulaAllStarRead.NEBULA_ALL_STAR_STATE
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarMainPanel = class("NebulaAllStarMainPanel", baseFguiPanel)
function NebulaAllStarMainPanel:ctor(...)
	NebulaAllStarMainPanel.super.ctor(self, ...)
	print("NebulaAllStarMainPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY
end
function NebulaAllStarMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaEmperor"
	end
	return self._packageList
end
function NebulaAllStarMainPanel:initBtnCheat(...)
	self.debug = nebulaAllStarUtil.getIsDebug()
	nebulaAllStarUtil.initCheatBtn(self.fields.Button_cheat)
end
function NebulaAllStarMainPanel:onInit()
	print("=======NebulaAllStarMainPanel:onInit")
	self:initBtnCheat()
	local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("NebulaAllStarMain")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handlerHelp)
	self.fields.Label_testTip:setVisible(false)
	if nebulaAllStarUtil.isWarTest() then
		self.fields.Com_title:setTitle(i18n("NebulaAllstar_283"))
		self.fields.Label_testTip:setVisible(true)
		self.fields.Label_testTip:setString(i18n("NebulaAllstar_284"))
	end
	local areaName, areaIcon = nebulaAllStarUtil.getAreaNameAndIcon()
	if areaName and areaIcon then
		self.fields.Load_region:setURL(areaIcon)
		_ENV = i18n("NebulaAllstar_284")
		i18n("NebulaAllstar_284").name = areaName
		self.fields.Text_region:setString(i18n("emperorannounce_text_1", i18n("NebulaAllstar_284")))
	end
	nebulaAllStarUtil, _UPVALUE9_ = self.fields.Text_region, self.fields.Text_region.setString
	nebulaAllStarUtil, self.fields.Text_region[1] = self.fields.Button_rank, self.fields.Button_rank
	nebulaAllStarUtil, self.fields.Text_region[2] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[3] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[4] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[5] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[6] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[7] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[8] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[9] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[10] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Text_region[11] = self.fields.Button_rank, i18n("pyramid_btn_29")
	nebulaAllStarUtil, self.fields.Button_rank[1] = self.fields.Button_team, self.fields.Button_team
	nebulaAllStarUtil, self.fields.Button_rank[2] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[3] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[4] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[5] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[6] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[7] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[8] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[9] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_rank[10] = self.fields.Button_team, i18n("NebulaAllstar_16")
	nebulaAllStarUtil, self.fields.Button_team[1] = self.fields.Button_backup, self.fields.Button_backup
	nebulaAllStarUtil, self.fields.Button_team[2] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[3] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[4] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[5] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[6] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[7] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[8] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_team[9] = self.fields.Button_backup, i18n("NebulaAllstar_17")
	nebulaAllStarUtil, self.fields.Button_backup[1] = self.fields.Button_donate, self.fields.Button_donate
	nebulaAllStarUtil, self.fields.Button_backup[2] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_backup[3] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_backup[4] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_backup[5] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_backup[6] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_backup[7] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_backup[8] = self.fields.Button_donate, i18n("common_text_284")
	nebulaAllStarUtil, self.fields.Button_donate[1] = self.fields.Button_reward, self.fields.Button_reward
	nebulaAllStarUtil, self.fields.Button_donate[2] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaAllStarUtil, self.fields.Button_donate[3] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaAllStarUtil, self.fields.Button_donate[4] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaAllStarUtil, self.fields.Button_donate[5] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaAllStarUtil, self.fields.Button_donate[6] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaAllStarUtil, self.fields.Button_donate[7] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaAllStarUtil, self.fields.Button_reward[1] = self.fields.Button_gift, self.fields.Button_gift
	nebulaAllStarUtil, self.fields.Button_reward[2] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaAllStarUtil, self.fields.Button_reward[3] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaAllStarUtil, self.fields.Button_reward[4] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaAllStarUtil, self.fields.Button_reward[5] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaAllStarUtil, self.fields.Button_reward[6] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaAllStarUtil, self.fields.Button_gift[1] = self.fields.Button_enter, self.fields.Button_enter
	nebulaAllStarUtil, self.fields.Button_gift[2] = self.fields.Button_enter, i18n("common_text_3318")
	nebulaAllStarUtil, self.fields.Button_gift[3] = self.fields.Button_enter, i18n("common_text_3318")
	nebulaAllStarUtil, self.fields.Button_gift[4] = self.fields.Button_enter, i18n("common_text_3318")
	nebulaAllStarUtil, self.fields.Button_gift[5] = self.fields.Button_enter, i18n("common_text_3318")
	nebulaAllStarUtil, self.fields.Button_enter[1] = self.fields.Button_return, self.fields.Button_return
	nebulaAllStarUtil, self.fields.Button_enter[2] = self.fields.Button_return, i18n("NebulaAllstar_25")
	nebulaAllStarUtil, self.fields.Button_enter[3] = self.fields.Button_return, i18n("NebulaAllstar_25")
	nebulaAllStarUtil, self.fields.Button_enter[4] = self.fields.Button_return, i18n("NebulaAllstar_25")
	self.fields.Button_return[1] = self.fields.Button_quit
	self.fields.Button_return[2] = i18n("common_text_3351")
	self.fields.Button_return[3] = i18n("common_text_3351")
	self.fields.Text_region.setString[1] = self.fields.Text_region
	self.fields.Text_region.setString[2] = self.fields.Button_rank
	self.fields.Text_region.setString[3] = self.fields.Button_team
	self.fields.Text_region.setString[4] = self.fields.Button_backup
	self.fields.Text_region.setString[5] = self.fields.Button_donate
	self.fields.Text_region.setString[6] = self.fields.Button_reward
	self.fields.Text_region.setString[7] = self.fields.Button_gift
	self.fields.Text_region.setString[8] = self.fields.Button_enter
	local self.fields.Text_region.setString[9], config = self.fields.Button_return, self.fields.Text_region.setString
	for __, cfg in ipairs(config) do
		local widget = cfg[1]
		local title = cfg[2]
		if title then
			widget:setString(title)
		end
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
	self.fields.Button_team = SoraDCreateTimerLabel(self, self.fields.Button_team)
	self.fields.Button_team:setTimeLast(function(timeStr)
		return i18n("NebulaAllstar_16") .. "\n" .. timeStr
	end)
	self.fields.Button_team:setTimeEndListener(function(timeStr)
		self.fields.Button_team:setString(i18n("NebulaAllstar_16"))
	end)
	self.fields.Button_backup = SoraDCreateTimerLabel(self, self.fields.Button_backup)
	self.fields.Button_backup:setTimeLast(function(timeStr)
		return i18n("NebulaAllstar_17") .. "\n" .. timeStr
	end)
	self.fields.Button_backup:setTimeEndListener(function(timeStr)
		self.fields.Button_backup:setString(i18n("NebulaAllstar_17"))
	end)
	self.fields.Text_enterCD = SoraDCreateTimerLabel(self, self.fields.Text_enterCD)
	self.fields.Text_enterCD:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("NebulaAllstar_27", nil)
	end)
	self.fields.Text_enterCD:setTimeEndListener(function(timeStr)
		self.fields.Text_enterCD:setVisible(false)
	end)
	self.fields.Text_enterCD:setVisible(false)
	self.fields.Button_enter:setVisible(false)
	self.fields.Button_return:setVisible(false)
	self.fields.Button_quit:setVisible(false)
	local _fields = fguiHelper.get_fields(self.fields.Com_time)
	self.fields.Text_begin = _fields.Text_begin
	self.fields.Text_time = SoraDCreateTimerLabel(nil, _fields.Text_time)
	_fields.Button_help:addClickListener(handler(self, self.onClickBtnStageHelp))
end
function NebulaAllStarMainPanel:onShow()
	print("=======NebulaAllStarMainPanel:onShow")
	self:updateActivityState()
	local showEnter = nebulaAllStarUtil.checkShowEnterBtn()
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if showEnter and myTeamInfo:isHasTeam() then
		local gametop = gModuleMgr.getObject("gametop")
		local selfUid = gametop.playertop_:getPlayerID()
		nebulaAllStarCtrl:reqPlayerData(selfUid, "NebulaAllStarMainPanel")
	end
end
function NebulaAllStarMainPanel:onMsgUpdateQuitTime(...)
	local showEnter = nebulaAllStarUtil.checkShowEnterBtn()
	if showEnter then
		local remainTime = nebulaAllStarCtrl:getQuitRemainTime()
		if 0 < remainTime then
			self.fields.Text_enterCD:beginTime(remainTime)
		end
	end
end
function NebulaAllStarMainPanel:updateActivityState(...)
	local curState = nebulaAllStarCtrl:getActivityCurState()
	if self.debug then
		local cheatStr = "切换状态" .. curState
		self.fields.Button_cheat:setString(cheatStr)
	end
	if curState == NEBULA_ALL_STAR_STATE.ENTER_ROOM or curState == NEBULA_ALL_STAR_STATE.BATTLE then
		self.controllers.c_state:setSelectedIndex(1)
		local showEnter = nebulaAllStarUtil.checkShowEnterBtn()
		self.fields.Button_enter:setVisible(showEnter)
		self.fields.Text_enterCD:setVisible(showEnter)
		self.fields.Button_return:setVisible(not showEnter)
		self.fields.Button_quit:setVisible(not showEnter)
		local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
		if showEnter and not myTeamInfo:isHasTeam() then
			self.fields.Button_enter:setString(i18n("Anchor_btn_09"))
			self.fields.Text_enterCD:setVisible(false)
		end
	else
		self.controllers.c_state:setSelectedIndex(0)
	end
	local stateName = nebulaAllStarUtil.getStateName(curState)
	self.fields.Text_begin:setString(stateName)
	local endTime = nebulaAllStarUtil.getStateEndTime(curState)
	self.fields.Text_time:beginTime(endTime - serviceFunctions.systemTime())
	self:updateTeamBtn()
	self.fields.Button_team:endTime()
	if curState < NEBULA_ALL_STAR_STATE.ALL_STAR_TEAM then
		local beginTime = nebulaAllStarCtrl:getStateBeginTime(NEBULA_ALL_STAR_STATE.ALL_STAR_TEAM)
		local remain = beginTime - serviceFunctions.systemTime()
		if 0 < remain then
			self.fields.Button_team:beginTime(remain)
		end
	end
	self.fields.Button_backup:endTime()
	if curState < NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM then
		local beginTime = nebulaAllStarCtrl:getStateBeginTime(NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM)
		local remain = beginTime - serviceFunctions.systemTime()
		if 0 < remain then
			self.fields.Button_backup:beginTime(remain)
		end
	end
	self:updateBtnDonateState()
end
function NebulaAllStarMainPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_rank then
		nebulaAllStarUtil.openRankView()
	elseif sender == self.fields.Button_team then
		_ENV = nil
		;(nil).isSuperTeam = true
		uiManager:show("NebulaAllStarTeam", nil)
	elseif sender == self.fields.Button_backup then
		nebulaAllStarUtil.openBackupTeamView()
	elseif sender == self.fields.Button_donate then
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("NebulaEmperorDonate", nil)
	elseif sender == self.fields.Button_reward then
		uiManager:show("NebulaAllStarReward")
	elseif sender == self.fields.Button_gift then
		nebulaAllStarUtil.openGiftView()
	elseif sender == self.fields.Button_enter then
		self:onClickBtnEnter()
	elseif sender == self.fields.Button_return then
		self:onClickBtnReturn()
	elseif sender == self.fields.Button_quit then
		self:onClickBtnQuit()
	end
end
function NebulaAllStarMainPanel:onClickBtnEnter(...)
	if worldMapDefine.isInNebulaAllStar() then
		return
	end
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if not myTeamInfo:isHasTeam() then
		local starLv = nebulaAllStarRead.getViewerNeedLv()
		if starLv > SoraDGetBuildStarLv() then
			_ENV = nil
			;(nil).num = starLv
			SoraDShowMsgTip(i18n("NebulaAllstar_340", nil))
		else
			nebulaAllStarCtrl:reqViewerSync()
			SoraDShowLoading(self:displayObject())
		end
		return
	end
	nebulaAllStarUtil.checkEnterBattleField(function()
		nebulaAllStarCtrl:reqEnterRoom()
		SoraDShowLoading(self:displayObject())
	end)
end
function NebulaAllStarMainPanel:onClickBtnReturn(...)
	SoraDRemoveAllPanelFromManager()
	if SoraDCurrentSceneShowView("worldMapView") then
		return
	end
	if nebulaAllStarCtrl:getIsViewer() then
		nebulaAllStarUtil.gotoViewerWorldMap()
	else
		SoraDGotoWorldMapPoint()
	end
end
function NebulaAllStarMainPanel:onClickBtnQuit(...)
	if nebulaAllStarCtrl:getIsViewer() then
		SoraDRemoveAllPanelFromManager()
		if SoraDCurrentSceneShowView("worldMapView") then
			SoraDGotoWorldMapPoint(nil, nil, gametop.playertop_:getMapID())
		else
			nebulaAllStarCtrl:reqViewerStopSync()
		end
		return
	end
	if not worldMapDefine.isInNebulaAllStar() then
		return
	end
	uiManager:show("NebulaAllStarQuitRoom")
end
function NebulaAllStarMainPanel:onClickBtnStageHelp(...)
	SoraDPlaySound()
	uiManager:show("NebulaAllStarStageHelp")
end
function NebulaAllStarMainPanel:updateTeamBtn(...)
	if nebulaAllStarUtil.checkTeamHasApproval() then
		self.fields.Button_team:setReddot(true)
	else
		self.fields.Button_team:setReddot(false)
	end
end
function NebulaAllStarMainPanel:updateBtnDonateState(...)
	local red = nebulaAllStarCtrl:getDonateStatusAndNum()
	self.fields.Button_donate:setReddot(red)
end
return NebulaAllStarMainPanel
