local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local teamCtrl = SoraDGetCtrl("teamCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamApplyPanel = class("NebulaWarTeamApplyPanel", baseFguiPanel)
function NebulaWarTeamApplyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamApplyPanel:ctor", self.viewName)
end
function NebulaWarTeamApplyPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaWarTeam"
	end
	return self._packageList
end
function NebulaWarTeamApplyPanel:onInit()
	print("=======NebulaWarTeamApplyPanel:onInit")
	self.teamType = self.proxy.param and self.proxy.param.teamType or teamAreaEnum.NEBULA_WAR
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
		self.fields.Com_title:initData(i18n("remains_btn_11"), handler(self, self.onClickClose), handlerHelp)
		self.fields.Button_invite:setString(i18n("remains_btn_10"))
		self.fields.Button_invite:addClickListener(handler(self, self.onClickBtnInvite))
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		self.fields.Com_title:initData(i18n("remains_btn_11"), handler(self, self.onClickClose))
		self.fields.Button_invite:setString(i18n("remains_btn_10"))
		self.fields.Button_invite:addClickListener(handler(self, self.onClickBtnInvite))
		local myTeamInfo = teamCtrl:getTeamData(self.teamType)
		if myTeamInfo:isTeamLeader() then
			self.fields.Text_notice:setString(i18n("NebulaAllstar_91"))
		else
			self.fields.Button_invite:setVisible(false)
			self.fields.Text_notice:setString(i18n("NebulaAllstar_373"))
		end
		self.fields.Text_remind:setString(i18n("NebulaAllstar_89"))
		local notRemind = nebulaAllStarUtil.getApprovalNotRemind()
		if notRemind then
			self.fields.Check_remind:setSelected(false)
		else
			self.fields.Check_remind:setSelected(true)
		end
	else
		self.fields.Com_title:initData(i18n("remains_title_02"), handler(self, self.onClickClose))
	end
	self.fields.List_player:setItemRenderer(handler(self, self.onPlayerItemRederer))
	self.fields.List_player:setVirtual()
	self.fields.Button_refresh:setString(i18n("common_text_911"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClickBtnRefresh))
	self:refreshTextRemain()
end
function NebulaWarTeamApplyPanel:onShow()
	print("=======NebulaWarTeamApplyPanel:onShow")
	self:req4Data()
end
function NebulaWarTeamApplyPanel:req4Data(...)
	local myTeamInfo = teamCtrl:getTeamData(self.teamType or teamAreaEnum.NEBULA_WAR)
	myTeamInfo:reqTeamGetTeamApplyInfo()
	SoraDShowLoading(self:displayObject())
end
function NebulaWarTeamApplyPanel:onPlayerItemRederer(index, obj)
	local memberData = self.memberList[index + 1]
	_UPVALUE0_ = nil
	;(nil).teamType = self.teamType
	obj:initApplyData(memberData, nil)
end
function NebulaWarTeamApplyPanel:onClickBtnRefresh(...)
	SoraDPlaySound()
	self:req4Data()
end
function NebulaWarTeamApplyPanel:refreshTextRemain(...)
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local remain = nebulaEmperorUtil.getTeamRemainNum()
		teamAreaEnum = nil
		;(nil).num = remain
		self.fields.Text_num:setString(i18n("nebulaemperor_text_43", nil))
		if 0 < remain then
			self.fields.Text_notice:setString(i18n("nebulaemperor_text_47"))
			self.fields.Button_invite:setVisible(true)
		else
			self.fields.Text_notice:setString(i18n("nebulaemperor_text_40"))
			self.fields.Button_invite:setVisible(false)
		end
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local myTeamInfo = teamCtrl:getTeamData(self.teamType)
		local memberNum = myTeamInfo:getTeamMemberNum()
		local numMax = nebulaAllStarRead.getTeamNumMax()
		teamAreaEnum = i18n("nebulaemperor_text_40")
		i18n("nebulaemperor_text_40").num = memberNum
		i18n("nebulaemperor_text_40").num2 = numMax
		self.fields.Text_num:setString(i18n("NebulaAllstar_58", i18n("nebulaemperor_text_40")))
	else
		local remain = nebulaWarUtil.getTeamRemainNum()
		teamAreaEnum = i18n("NebulaAllstar_58", i18n("nebulaemperor_text_40"))
		i18n("NebulaAllstar_58", i18n("nebulaemperor_text_40")).num = remain
		self.fields.Text_num:setString(i18n("nebula_war_text_0035", i18n("NebulaAllstar_58", i18n("nebulaemperor_text_40"))))
		if 0 < remain then
			self.fields.Text_notice:setString(i18n("nebula_war_text_0040"))
		else
			self.fields.Text_notice:setString(i18n("nebula_war_text_0039"))
		end
	end
end
function NebulaWarTeamApplyPanel:onMsgApplyListBack(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.memberList then
		_ENV = event.memberList
	end
	self.memberList = event.memberList
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		_UPVALUE2_, _UPVALUE2_ = self:displayObject()
		_UPVALUE2_, self:displayObject()[1] = "totalFc", "totalFc"
		_UPVALUE2_, self:displayObject()[2] = "totalFc", ">"
		;("totalFc")[1] = "uid"
		;("totalFc")[2] = "<"
		self:displayObject()[1] = self:displayObject()
		self:displayObject()[2] = "totalFc"
		serviceFunctions.sort(self.memberList, self:displayObject())
	end
	self:refreshMemberList()
end
function NebulaWarTeamApplyPanel:refreshMemberList(...)
	self.fields.List_player:setNumItems(#self.memberList)
	self.fields.Text_notice:setVisible(#self.memberList == 0)
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		self.fields.Button_invite:setVisible(#self.memberList == 0)
	end
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local myTeamInfo = teamCtrl:getTeamData(self.teamType)
		if myTeamInfo:isTeamLeader() then
			self.fields.Button_invite:setVisible(#self.memberList == 0)
		end
	end
end
function NebulaWarTeamApplyPanel:onMsgAgreeApplyBack(target, event)
	if event.err == gErrDef.Err_None then
		local uid = event.uid
		for i, v in ipairs(self.memberList) do
			if v.uid == uid then
				table.remove(self.memberList, i)
				break
			end
		end
		self:refreshMemberList()
	elseif event.err == gErrDef.Err_NEBULA_WAR_SIGN_UP then
		SoraDShowMsgTip(i18n("nebula_war_text_0447"))
	elseif event.err == gErrDef.Err_TEAM_NO_PERMISSION then
		SoraDShowMsgTip(i18n("nebulaemperor_text_46"))
		self:closePanel()
	else
		self:req4Data()
		if event.err == gErrDef.Err_IN_TEAM then
			SoraDShowMsgTip(i18n("nebula_war_text_0041"))
		end
	end
end
function NebulaWarTeamApplyPanel:onClickBtnInvite(...)
	SoraDPlaySound()
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaEmperorTeamInvite", nil)
	elseif self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaAllStarTeamInvite", nil)
	end
	self:closePanel()
end
function NebulaWarTeamApplyPanel:onHide(...)
	if self.teamType ~= teamAreaEnum.NEBULA_ALL_STAR then
		return
	end
	local notRemind = not self.fields.Check_remind:isSelected()
	nebulaAllStarUtil.setApprovalNotRemind(notRemind)
	teamAreaEnum = notRemind
	notRemind.msg = "MESSAGE_NEBULA_ALLSTAR_APPLY_REMIND"
	SoraDSendMessage(notRemind)
end
return NebulaWarTeamApplyPanel
