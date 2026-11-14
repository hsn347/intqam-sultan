local gametop = gModuleMgr.getObject("gametop")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarTeamPanel = class("NebulaAllStarTeamPanel", baseFguiPanel)
function NebulaAllStarTeamPanel:ctor(...)
	NebulaAllStarTeamPanel.super.ctor(self, ...)
	print("NebulaAllStarTeamPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.selfUid = gametop.playertop_:getPlayerID()
	self.isApplyJoin = false
	self.showOnline = false
end
function NebulaAllStarTeamPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaWarTeam"
		self._packageList, self._packageList[2] = self._packageList, "NebulaEmperorTeam"
	end
	return self._packageList
end
function NebulaAllStarTeamPanel:onInit()
	print("=======NebulaAllStarTeamPanel:onInit")
	self.teamType = teamAreaEnum.NEBULA_ALL_STAR
	self.myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	local isSuperTeam = self.param and self.param.isSuperTeam
	self.isSuperTeam = isSuperTeam ~= false
	if self.isSuperTeam then
		local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("allStarTeam")
		self.fields.Com_title:initData(i18n("NebulaAllstar_16"), handler(self, self.onClickClose), handlerHelp)
	else
		local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("backupTeam")
		self.fields.Com_title:initData(i18n("NebulaAllstar_17"), handler(self, self.onClickClose), handlerHelp)
	end
	local areaName, areaIcon = nebulaAllStarUtil.getAreaNameAndBigIcon()
	if areaName then
		self.fields.Com_teamBase:setString(areaName)
		self.fields.Com_teamBase:setIcon(areaIcon)
	end
	self.fields.List_member:setItemRenderer(handler(self, self.onMemberItemRederer))
	self.fields.List_member:setVirtual()
	self.fields.Com_searchMember:setTeamType(self.teamType)
	self.fields.Com_searchMember:setSearchHandler(handler(self, self.onMsgSearchBack))
	teamAreaEnum, _UPVALUE6_ = self.fields.Com_searchMember, self.fields.Com_searchMember.setSearchHandler
	teamAreaEnum, self.fields.Com_searchMember[1] = self.fields.Button_join, self.fields.Button_join
	teamAreaEnum, self.fields.Com_searchMember[2] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[3] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[4] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[5] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[6] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[7] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[8] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[9] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[10] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Com_searchMember[11] = self.fields.Button_join, i18n("common_text_182")
	teamAreaEnum, self.fields.Button_join[1] = self.fields.Button_commander, self.fields.Button_commander
	teamAreaEnum, self.fields.Button_join[2] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[3] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[4] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[5] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[6] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[7] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[8] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[9] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_join[10] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	teamAreaEnum, self.fields.Button_commander[1] = self.fields.Button_apply, self.fields.Button_apply
	teamAreaEnum, self.fields.Button_commander[2] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[3] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[4] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[5] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[6] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[7] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[8] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_commander[9] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_apply[1] = self.fields.Button_invite, self.fields.Button_invite
	teamAreaEnum, self.fields.Button_apply[2] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[3] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[4] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[5] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[6] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[7] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[8] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_invite[1] = self.fields.Button_quit, self.fields.Button_quit
	teamAreaEnum, self.fields.Button_invite[2] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_invite[3] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_invite[4] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_invite[5] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_invite[6] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_invite[7] = self.fields.Button_quit, i18n("remains_btn_09")
	self.fields.Button_quit[1] = self.fields.Button_chat
	self.fields.Com_searchMember.setSearchHandler[1] = self.fields.Com_searchMember
	self.fields.Com_searchMember.setSearchHandler[2] = self.fields.Button_join
	self.fields.Com_searchMember.setSearchHandler[3] = self.fields.Button_commander
	self.fields.Com_searchMember.setSearchHandler[4] = self.fields.Button_apply
	self.fields.Com_searchMember.setSearchHandler[5] = self.fields.Button_invite
	local self.fields.Com_searchMember.setSearchHandler[6], config = self.fields.Button_quit, self.fields.Com_searchMember.setSearchHandler
	for __, cfg in ipairs(config) do
		local widget = cfg[1]
		local title = cfg[2]
		if title then
			widget:setString(title)
		end
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
	self.Sprite_RedPoint = self.fields.Button_chat:getChild("Sprite_RedPoint")
	self.Sprite_RedPoint:setVisible(false)
	if worldMapDefine.isInNebulaAllStar() then
		self.fields.Button_chat:setVisible(false)
	end
end
function NebulaAllStarTeamPanel:onShow()
	print("=======NebulaAllStarTeamPanel:onShow")
	self:updateMyTeamInfo()
	self:updateActivityState()
end
function NebulaAllStarTeamPanel:updateMyTeamInfo(...)
	if self:isHasTeam() then
		self.controllers.c1:setSelectedIndex(1)
		self:refreshTeamInfo()
		self.myTeamInfo:reqTeamGetTeamMemberInfo()
		self:updateApplyBtn()
		self:updateNewTeamMsg()
	else
		self.controllers.c1:setSelectedIndex(0)
		self:refreshInviteBtn()
		if self.isSuperTeam then
			self.myTeamInfo:reqTeamNebulaAllStarTeamInfo(1)
		else
			self.myTeamInfo:reqTeamNebulaAllStarTeamInfo(2)
		end
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaAllStarTeamPanel:onMemberItemRederer(index, obj)
	local memberData = self.tableMemberList[index + 1]
	_UPVALUE0_ = nil
	;(nil).teamType = self.teamType
	;(nil).showOnline = self.showOnline
	;(nil).isInSameTeam = self.isInSameTeam
	obj:initMemberData(memberData, nil)
end
function NebulaAllStarTeamPanel:onMsgSearchBack(memberList)
	self:updateMemberList(memberList)
end
function NebulaAllStarTeamPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_join then
		if self.myTeamInfo:isHasInvitedInfo() then
			nebulaAllStarUtil.agreeOrRejectTeamInvite(function()
				SoraDShowLoading(self:displayObject())
			end)
		elseif nebulaAllStarUtil.checkJoinTeam() then
			if nebulaAllStarCtrl:getIsSignUpBackupGroup() then
				SoraDShowMsgBox(i18n("NebulaAllstar_65"), nil, nil, function(callBack)
					if callBack == MSGBOX_CALLBACK_YES and self.targetTeamId then
						self.myTeamInfo:reqTeamApplyJoin(self.targetTeamId)
					end
				end)
			elseif self.targetTeamId then
				self.myTeamInfo:reqTeamApplyJoin(self.targetTeamId)
			end
		end
	elseif sender == self.fields.Button_apply then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaAllStarTeamApply", nil)
	elseif sender == self.fields.Button_invite then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaAllStarTeamInvite", nil)
	elseif sender == self.fields.Button_quit then
		if not nebulaAllStarUtil.checkQuitTeamState() then
			SoraDShowMsgTip(i18n("NebulaAllstar_250"))
			return
		end
		SoraDShowMsgBox(i18n("NebulaAllstar_63"), nil, nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				self.myTeamInfo:reqTeamQuit()
				SoraDShowLoading(self:displayObject())
			end
		end)
	elseif sender == self.fields.Button_chat then
		self:setNewTeamMsg(false)
		_ENV = self.setNewTeamMsg
		self.setNewTeamMsg.teamId = self.myTeamInfo:getTeamID()
		self.setNewTeamMsg.teamType = self.myTeamInfo:getTeamType()
		local self.setNewTeamMsg.myTeamInfo, data = self.myTeamInfo, self.setNewTeamMsg
		local panel = SoraDCreatePanel("teamChatView")
		panel:initWithData(data)
		panel:show()
	elseif sender == self.fields.Button_commander then
		local _ENV, ret = self.fields.Button_commander, self.fields.Button_commander
		if self.teamInfo and not self.myTeamInfo:getIsSuperTeam() then
			ret = teamDef.getLeaderCommanderList(self.teamInfo)
		end
		_ENV = data
		data.memberList = ret
		uiManager:show("NebulaAllStarTeamCommander", data)
	end
end
function NebulaAllStarTeamPanel:refreshTeamInfo(...)
	self:refreshLeader()
	self:refreshMemberInfo()
end
function NebulaAllStarTeamPanel:refreshLeader(...)
	self:updateBtnState()
	if self:isHasTeam() and (self.myTeamInfo:isTeamLeader() or self.myTeamInfo:isTeamCommander()) then
		self.showOnline = true
	else
		self.showOnline = false
	end
end
function NebulaAllStarTeamPanel:sortMemberList(memberList)
	local _ENV, ret
	for i, member in ipairs(memberList) do
		local playerID = member.uid
		_ENV = playerID
		playerID.isLeader = member.isLeader or self.myTeamInfo:isTeamLeader(playerID)
		playerID.isCommander = member.isCommander or self.myTeamInfo:isTeamCommander(playerID)
		ret[tostring(playerID)], playerID.isSelf = playerID, self.selfUid == playerID
	end
	table.sort(memberList, function(a, b)
		local dataA = ret[tostring(a.uid)]
		local dataB = ret[tostring(b.uid)]
		if dataA.isLeader ~= dataB.isLeader then
			return dataA.isLeader
		end
		if dataA.isCommander ~= dataB.isCommander then
			return dataA.isCommander
		end
		if dataA.isSelf ~= dataB.isSelf then
			return dataA.isSelf
		end
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.uid < b.uid
	end)
end
function NebulaAllStarTeamPanel:refreshMemberInfo(...)
	self.memberList = self.myTeamInfo:getTeamMemberList()
	self:sortMemberList(self.memberList)
	self:updateTextMember(#self.memberList)
	self.fields.Com_searchMember:setMemberList(self.memberList)
	local memberList = self.fields.Com_searchMember:getTableMemberList()
	self:updateMemberList(memberList)
	for i, member in ipairs(self.tableMemberList) do
		if self.selfUid == member.uid then
			self.fields.List_member:scrollToView(i - 1)
			break
		end
	end
end
function NebulaAllStarTeamPanel:updateMemberList(memberList)
	self.tableMemberList = memberList
	self.isInSameTeam = self:isHasTeam()
	self.fields.List_member:setNumItems(#self.tableMemberList)
end
function NebulaAllStarTeamPanel:updateTextMember(memberCount)
	local total = nebulaAllStarRead.getTeamNumMax(self.isSuperTeam)
	local nebulaAllStarRead, style = self.isSuperTeam, self.isSuperTeam
	if memberCount >= total then
		nebulaAllStarRead, nebulaAllStarRead = nil, nil
		style, (nil).num, (nil).color = nil, nil, "#FF0000"
	end
	if self.isSuperTeam then
		nebulaAllStarRead = nil
		;(nil).num = memberCount
		;(nil).max = total
		self.fields.Text_member:setString(i18n_html("nebulaemperor_text_32", nil, style))
	else
		nebulaAllStarRead = i18n_html("nebulaemperor_text_32", nil, style)
		i18n_html("nebulaemperor_text_32", nil, style).num = memberCount
		i18n_html("nebulaemperor_text_32", nil, style).num2 = total
		self.fields.Text_member:setString(i18n_html("NebulaAllstar_58", i18n_html("nebulaemperor_text_32", nil, style)))
	end
end
function NebulaAllStarTeamPanel:refreshInviteBtn(...)
	local Button_join = self.fields.Button_join
	if self.myTeamInfo:isHasInvitedInfo() then
		Button_join:setEnabled(true)
		Button_join:setString(i18n("NebulaAllstar_279"))
	elseif self.isApplyJoin then
		Button_join:setEnabled(false)
		Button_join:setString(i18n("alliance_office_btn_02"))
	else
		Button_join:setEnabled(true)
		Button_join:setString(i18n("common_text_182"))
	end
end
function NebulaAllStarTeamPanel:updateApplyBtn(...)
	if nebulaAllStarUtil.checkTeamHasApproval() then
		self.fields.Button_apply:setReddot(true)
	else
		self.fields.Button_apply:setReddot(false)
	end
end
function NebulaAllStarTeamPanel:onMsgMemberInfoBack(...)
	SoraDCloseLoading(self:displayObject())
	self:refreshMemberInfo()
end
function NebulaAllStarTeamPanel:setNewTeamMsg(new)
	if self.hasNewTeamMsg == new then
		return
	end
	self.hasNewTeamMsg = new
	self:showNewEffect(self.hasNewTeamMsg)
end
function NebulaAllStarTeamPanel:updateNewTeamMsg()
	local new = self.myTeamInfo:isHasNewTeamMsg()
	self:setNewTeamMsg(new)
end
function NebulaAllStarTeamPanel:showNewEffect(show)
	self.Sprite_RedPoint:setVisible(show)
end
function NebulaAllStarTeamPanel:onMsgReqTeamInfoBack(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.teamInfo then
		local _ENV, teamInfo = event.teamInfo, event.teamInfo
	end
	self.teamInfo = teamInfo
	self.targetTeamId = teamInfo.tid
	local memberCount = teamInfo.memberCount or 0
	self:updateTextMember(memberCount)
	self.memberList = teamDef.transMemberList(teamInfo.memberList)
	if teamDef.getIsSuperTeam(teamInfo) then
		for __, member in ipairs(self.memberList) do
			member.isLeader = teamDef.isTeamLeader(teamInfo, member.uid)
			member.isCommander = teamDef.isTeamCommander(teamInfo, member.uid)
		end
	end
	self:sortMemberList(self.memberList)
	self.fields.Com_searchMember:setMemberList(self.memberList)
	local memberList = self.fields.Com_searchMember:getTableMemberList()
	self:updateMemberList(memberList)
	if not teamInfo.applyList then
		local _ENV, applyList = teamInfo.applyList, teamInfo.applyList
	end
	if applyList[tostring(self.selfUid)] then
		self.isApplyJoin = true
		self:refreshInviteBtn()
	end
end
function NebulaAllStarTeamPanel:onMsgApplyJoinBack(target, event)
	if event.err == gErrDef.Err_None then
		self.isApplyJoin = true
		self:refreshInviteBtn()
	end
end
function NebulaAllStarTeamPanel:onMsgRejectApply(...)
	self.isApplyJoin = false
	self:refreshInviteBtn()
end
function NebulaAllStarTeamPanel:updateActivityState(...)
	self:updateBtnState()
end
function NebulaAllStarTeamPanel:updateBtnState(...)
	_UPVALUE5_ = nil
	;(nil)[1] = self.fields.Button_join
	;(nil)[2] = self.fields.Button_commander
	;(nil)[3] = self.fields.Button_invite
	;(nil)[4] = self.fields.Button_quit
	local (nil)[5], confg = self.fields.Button_apply, nil
	for __, button in ipairs(confg) do
		button:setVisible(false)
	end
	local btnList = self:getBtnList()
	local btnCount = #btnList
	if btnCount == 0 then
		self.controllers.c_button:setSelectedIndex(1)
		return
	end
	self.controllers.c_button:setSelectedIndex(0)
	local totalWidth = self:getSize().width
	local btnWidth = btnList[1]:getWidth()
	local space = (640 - btnWidth * btnCount) / (btnCount + 1)
	local beginX = totalWidth - (totalWidth - 640) / 2 - space - btnWidth
	if not SoraDFIsRA() then
		beginX = beginX + btnWidth
	end
	for i, button in ipairs(btnList) do
		button:setVisible(true)
		local posX = beginX - (i - 1) * (btnWidth + space)
		button:setPositionX(SoraDFPosX(posX, totalWidth))
	end
end
function NebulaAllStarTeamPanel:getBtnList(...)
	local nebulaAllStarUtil, btnList
	if not self.isSuperTeam then
		return btnList
	end
	if not nebulaAllStarUtil.checkQuitTeamState() then
		table.insert(btnList, self.fields.Button_commander)
	elseif self:isHasTeam() then
		if self.myTeamInfo:isTeamLeader() then
			table.insert(btnList, self.fields.Button_apply)
			table.insert(btnList, self.fields.Button_invite)
			table.insert(btnList, self.fields.Button_commander)
		elseif self.myTeamInfo:isTeamCommander() then
			table.insert(btnList, self.fields.Button_apply)
			table.insert(btnList, self.fields.Button_quit)
			table.insert(btnList, self.fields.Button_commander)
		else
			table.insert(btnList, self.fields.Button_quit)
			table.insert(btnList, self.fields.Button_commander)
		end
	else
		table.insert(btnList, self.fields.Button_join)
		table.insert(btnList, self.fields.Button_commander)
	end
	return btnList
end
function NebulaAllStarTeamPanel:isHasTeam(...)
	return self.isSuperTeam and self.myTeamInfo:getIsSuperTeam() or not self.isSuperTeam and self.myTeamInfo:getIsBackupTeam()
end
return NebulaAllStarTeamPanel
