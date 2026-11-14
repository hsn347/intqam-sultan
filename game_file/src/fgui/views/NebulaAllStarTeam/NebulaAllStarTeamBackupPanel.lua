local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local NEBULA_ALL_STAR_STATE = nebulaAllStarRead.NEBULA_ALL_STAR_STATE
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarTeamBackupPanel = class("NebulaAllStarTeamBackupPanel", baseFguiPanel)
function NebulaAllStarTeamBackupPanel:ctor(...)
	NebulaAllStarTeamBackupPanel.super.ctor(self, ...)
	print("NebulaAllStarTeamBackupPanel:ctor", self.viewName)
end
function NebulaAllStarTeamBackupPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaAllStar"
	end
	return self._packageList
end
function NebulaAllStarTeamBackupPanel:onInit()
	print("=======NebulaAllStarTeamBackupPanel:onInit")
	local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("backupTeam")
	self.fields.Com_title:initData(i18n("NebulaAllstar_17"), handler(self, self.onClickClose), handlerHelp)
	local areaName, areaIcon = nebulaAllStarUtil.getAreaNameAndBigIcon()
	if areaName and areaIcon then
		self.fields.Load_region:setURL(areaIcon)
		self.fields.Text_region:setString(areaName)
	end
	self.fields.Button_chat:addClickListener(handler(self, self.onClickBtnChat))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.fields.Text_signCD = SoraDCreateTimerLabel(nil, self.fields.Text_signCD)
	self.fields.Text_signCD:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("nebula_war_text_0511", nil)
	end)
	self.fields.Text_signCD:setTimeEndListener(function()
		self.fields.Text_signCD:setVisible(false)
	end)
	self.fields.Button_sign:setString(i18n("remains_btn_09"))
	self.fields.Button_sign:addClickListener(handler(self, self.onClickBtnSign))
	self.fields.Text_sign:setString(i18n("NebulaAllstar_273"))
	local _fields = fguiHelper.get_fields(self.fields.Com_time)
	self.fields.Text_begin = _fields.Text_begin
	self.fields.Text_time = SoraDCreateTimerLabel(nil, _fields.Text_time)
	self.fields.Text_begin:setString(i18n("NebulaAllstar_92"))
	local endTime = nebulaAllStarCtrl:getStateBeginTime(NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM)
	self.fields.Text_time:beginTime(endTime - serviceFunctions.systemTime())
end
function NebulaAllStarTeamBackupPanel:onShow()
	print("=======NebulaAllStarTeamBackupPanel:onShow")
	self:updateBtnState()
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if not myTeamInfo:getIsSuperTeam() then
		myTeamInfo:reqTeamNebulaAllStarTeamInfo(1)
	end
end
function NebulaAllStarTeamBackupPanel:updateBtnState(...)
	local Button_sign = self.fields.Button_sign
	if nebulaAllStarCtrl:getIsSignUpBackupGroup() then
		Button_sign:setString(i18n("nebula_war_text_0395"))
		Button_sign:setBtnColorIndex(0)
	else
		Button_sign:setString(i18n("pyramid_text_109"))
		Button_sign:setBtnColorIndex(2)
	end
	local signCD = nebulaAllStarUtil.getSignUpCDRemainTime()
	if 0 < signCD then
		self.fields.Text_signCD:setVisible(true)
		self.fields.Text_signCD:beginTime(signCD)
	else
		self.fields.Text_signCD:setVisible(false)
	end
end
function NebulaAllStarTeamBackupPanel:onClickBtnChat(...)
	SoraDPlaySound()
	local curState = nebulaAllStarCtrl:getActivityCurState()
	if curState <= NEBULA_ALL_STAR_STATE.BACKUP_GROUP_TEAM then
		SoraDShowMsgTip(i18n("NebulaAllstar_57"))
		return
	end
end
function NebulaAllStarTeamBackupPanel:onClickBtnSearch(...)
	SoraDPlaySound()
	uiManager:show("NebulaAllStarTeamSign")
end
function NebulaAllStarTeamBackupPanel:onClickBtnSign(...)
	SoraDPlaySound()
	if nebulaAllStarCtrl:getIsSignUpBackupGroup() then
		SoraDShowMsgBox(i18n("NebulaAllstar_404"), nil, i18n("common_text_185"), function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				nebulaAllStarCtrl:reqCancelBackup()
				SoraDShowLoading(self:displayObject())
			end
		end)
	else
		local signCD = nebulaAllStarUtil.getSignUpCDRemainTime()
		if 0 < signCD then
			function _ENV(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					nebulaAllStarCtrl:reqCancelBackup()
					SoraDShowLoading(self:displayObject())
				end
			end
			;(function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					nebulaAllStarCtrl:reqCancelBackup()
					SoraDShowLoading(self:displayObject())
				end
			end).time = SoraDConvertSecondToString(signCD)
			SoraDShowMsgTip(i18n("nebula_war_text_0511", function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					nebulaAllStarCtrl:reqCancelBackup()
					SoraDShowLoading(self:displayObject())
				end
			end))
			return
		end
		local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
		if myTeamInfo:getIsSuperTeam() then
			SoraDShowMsgTip(i18n("NebulaAllstar_93"))
			return
		end
		if not nebulaAllStarUtil.checkBuildStarLv() then
			SoraDShowMsgTip(i18n("NebulaAllstar_94"))
			return
		end
		if self.isApplyJoin then
			SoraDShowMsgBox(i18n("NebulaAllstar_95"), nil, nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					nebulaAllStarCtrl:reqSignUpBackup()
					SoraDShowLoading(self:displayObject())
				end
			end)
		else
			nebulaAllStarCtrl:reqSignUpBackup()
			SoraDShowLoading(self:displayObject())
		end
	end
end
function NebulaAllStarTeamBackupPanel:onMsgUpdateSignUp(target, event)
	SoraDCloseLoading(self:displayObject())
	self:updateBtnState()
end
function NebulaAllStarTeamBackupPanel:onMsgReqTeamInfoBack(target, event)
	if not event.teamInfo then
		local _ENV, teamInfo = event.teamInfo, event.teamInfo
	end
	if not teamInfo.applyList then
		local _ENV, applyList = teamInfo.applyList, teamInfo.applyList
	end
	local gametop = gModuleMgr.getObject("gametop")
	local selfUid = gametop.playertop_:getPlayerID()
	if applyList[tostring(selfUid)] then
		self.isApplyJoin = true
	end
end
return NebulaAllStarTeamBackupPanel
