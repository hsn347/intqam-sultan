local gametop = gModuleMgr.getObject("gametop")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local nebulaEmperorRead = include("nebulaEmperorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorTeamPanel = class("NebulaEmperorTeamPanel", baseFguiPanel)
function NebulaEmperorTeamPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorTeamPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaEmperorTeamPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaWarTeam"
	end
	return self._packageList
end
function NebulaEmperorTeamPanel:onInit()
	print("=======NebulaEmperorTeamPanel:onInit")
	self.teamType = teamAreaEnum.NEBULA_EMPEROR
	self.myTeamInfo = nebulaEmperorCtrl:getMyTeamInfo()
	self.fields.Com_title:initData(i18n("nebulaemperor_text_30"), handler(self, self.onClickClose))
	local teamName = nebulaEmperorUtil.getTeamName()
	self.fields.Com_teamBase:setString(teamName)
	local areaIcon = nebulaEmperorUtil.getAreaBigIcon()
	self.fields.Com_teamBase:setIcon(areaIcon)
	self.fields.List_member:setItemRenderer(handler(self, self.onMemberItemRederer))
	self.fields.List_member:setVirtual()
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
	teamAreaEnum, self.fields.Button_join[1] = self.fields.Button_apply, self.fields.Button_apply
	teamAreaEnum, self.fields.Button_join[2] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[3] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[4] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[5] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[6] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[7] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[8] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[9] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_join[10] = self.fields.Button_apply, i18n("remains_btn_11")
	teamAreaEnum, self.fields.Button_apply[1] = self.fields.Button_invite, self.fields.Button_invite
	teamAreaEnum, self.fields.Button_apply[2] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[3] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[4] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[5] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[6] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[7] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[8] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_apply[9] = self.fields.Button_invite, i18n("remains_btn_10")
	teamAreaEnum, self.fields.Button_invite[1] = self.fields.Button_war, self.fields.Button_war
	teamAreaEnum, self.fields.Button_invite[2] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_invite[3] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_invite[4] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_invite[5] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_invite[6] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_invite[7] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_invite[8] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	teamAreaEnum, self.fields.Button_war[1] = self.fields.Button_quit, self.fields.Button_quit
	teamAreaEnum, self.fields.Button_war[2] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_war[3] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_war[4] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_war[5] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_war[6] = self.fields.Button_quit, i18n("remains_btn_09")
	teamAreaEnum, self.fields.Button_war[7] = self.fields.Button_quit, i18n("remains_btn_09")
	self.fields.Button_quit[1] = self.fields.Button_chat
	self.fields.Com_searchMember.setSearchHandler[1] = self.fields.Com_searchMember
	self.fields.Com_searchMember.setSearchHandler[2] = self.fields.Button_join
	self.fields.Com_searchMember.setSearchHandler[3] = self.fields.Button_apply
	self.fields.Com_searchMember.setSearchHandler[4] = self.fields.Button_invite
	self.fields.Com_searchMember.setSearchHandler[5] = self.fields.Button_war
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
	self.Sprite_chat = self.fields.Button_chat:getChild("icon")
	if worldMapDefine.isInNebulaEmperor() then
		self.fields.Button_chat:setVisible(false)
	end
end
function NebulaEmperorTeamPanel:onShow()
	print("=======NebulaEmperorTeamPanel:onShow")
	self:updateMyTeamInfo()
end
function NebulaEmperorTeamPanel:updateMyTeamInfo(...)
	if self.myTeamInfo:isHasTeam() then
		self.controllers.c1:setSelectedIndex(1)
		self:refreshTeamInfo()
		self.myTeamInfo:reqTeamGetTeamMemberInfo()
		self:updateApplyBtn()
		self:updateNewTeamMsg()
		self:updateButtonWar()
	else
		self.controllers.c1:setSelectedIndex(0)
		self:refreshInviteBtn()
		self.myTeamInfo:reqTeamNebulaEmperorTeamInfo()
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaEmperorTeamPanel:onMemberItemRederer(index, obj)
	local memberData = self.tableMemberList[index + 1]
	_UPVALUE0_ = nil
	;(nil).teamType = self.teamType
	obj:initMemberData(memberData, nil)
end
function NebulaEmperorTeamPanel:onMsgSearchBack(memberList)
	self:updateMemberList(memberList)
end
function NebulaEmperorTeamPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_join then
		if self.myTeamInfo:isHasInvitedInfo() then
			_ENV = nil
			;(nil).teamType = self.teamType
			uiManager:show("NebulaWarTeamBeInvite", nil)
		elseif nebulaEmperorUtil.checkJoinTeam() and self.targetTeamId then
			self.myTeamInfo:reqTeamApplyJoin(self.targetTeamId)
		end
	elseif sender == self.fields.Button_apply then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaEmperorTeamApply", nil)
	elseif sender == self.fields.Button_invite then
		_ENV = nil
		;(nil).teamType = self.teamType
		uiManager:show("NebulaEmperorTeamInvite", nil)
	elseif sender == self.fields.Button_war then
		if worldMapDefine.isInNebulaEmperor() then
			uiManager:show("AllianceWarView")
		else
			SoraDShowMsgTip(i18n("nebulaemperor_text_34"))
		end
	elseif sender == self.fields.Button_quit then
		if not nebulaEmperorUtil.checkQuitTeamState() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_35"))
			return
		end
		SoraDShowMsgBox(i18n("nebulaemperor_text_38"), nil, nil, function(callBack)
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
	end
end
function NebulaEmperorTeamPanel:refreshTeamInfo(...)
	self:refreshLeader()
	self:refreshMemberInfo()
end
function NebulaEmperorTeamPanel:refreshLeader(...)
	if self.myTeamInfo:isTeamLeader() then
		self.controllers.c2:setSelectedIndex(0)
	elseif self.myTeamInfo:isTeamCommander() then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(2)
	end
end
function NebulaEmperorTeamPanel:sortMemberList(memberList)
	local _ENV, ret
	for i, member in ipairs(memberList) do
		local playerID = member.uid
		_ENV = playerID
		playerID.isLeader = self.myTeamInfo:isTeamLeader(playerID)
		playerID.isCommander = self.myTeamInfo:isTeamCommander(playerID)
		ret[tostring(playerID)], playerID.isAssembler = playerID, self.myTeamInfo:isTeamAssembler(playerID)
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
		if dataA.isAssembler ~= dataB.isAssembler then
			return dataA.isAssembler
		end
		if a.inBattleField ~= b.inBattleField then
			return a.inBattleField
		end
		if a.totalFc ~= b.totalFc then
			return a.totalFc > b.totalFc
		end
		return a.uid < b.uid
	end)
end
function NebulaEmperorTeamPanel:refreshMemberInfo(...)
	self.memberList = self.myTeamInfo:getTeamMemberList()
	self:sortMemberList(self.memberList)
	self:updateTextMember(#self.memberList)
	self.fields.Com_searchMember:setMemberList(self.memberList)
	local memberList = self.fields.Com_searchMember:getTableMemberList()
	self:updateMemberList(memberList)
	local ownUid = gametop.playertop_:getPlayerID()
	for i, member in ipairs(self.tableMemberList) do
		if ownUid == member.uid then
			self.fields.List_member:scrollToView(i - 1)
			break
		end
	end
end
function NebulaEmperorTeamPanel:updateMemberList(memberList)
	self.tableMemberList = memberList
	self.fields.List_member:setNumItems(#self.tableMemberList)
end
function NebulaEmperorTeamPanel:updateTextMember(memberCount)
	local total = nebulaEmperorRead.getTeamNumMax()
	local nebulaEmperorRead, style
	if memberCount < total then
		nebulaEmperorRead, nebulaEmperorRead = nil, nil
		style, (nil).num, (nil).color = nil, nil, "#FF0000"
	end
	nebulaEmperorRead = nil
	;(nil).num = memberCount
	;(nil).max = total
	self.fields.Text_member:setString(i18n_html("nebulaemperor_text_32", nil, style))
end
function NebulaEmperorTeamPanel:refreshInviteBtn(...)
	if self.myTeamInfo:isHasInvitedInfo() then
		self.fields.Button_join:setString(i18n("nebulaemperor_text_48"))
	else
		self.fields.Button_join:setString(i18n("common_text_182"))
	end
end
function NebulaEmperorTeamPanel:updateApplyBtn(...)
	if nebulaEmperorUtil.getTeamRemainNum() > 0 and self.myTeamInfo:isTeamHasApproval() then
		self.fields.Button_apply:setReddot(true)
	else
		self.fields.Button_apply:setReddot(false)
	end
end
function NebulaEmperorTeamPanel:onMsgMemberInfoBack(...)
	SoraDCloseLoading(self:displayObject())
	self:refreshMemberInfo()
end
function NebulaEmperorTeamPanel:setNewTeamMsg(new)
	if self.hasNewTeamMsg == new then
		return
	end
	self.hasNewTeamMsg = new
	self:showNewEffect(self.hasNewTeamMsg)
end
function NebulaEmperorTeamPanel:updateNewTeamMsg()
	local new = self.myTeamInfo:isHasNewTeamMsg()
	self:setNewTeamMsg(new)
end
function NebulaEmperorTeamPanel:showNewEffect(show)
	self.Sprite_chat:stopAllActions()
	if show then
		local action = nebulaEmperorUtil.getTeamChatAction()
		self.Sprite_chat:runAction(action)
	else
		self.Sprite_chat:setRotation(0)
	end
	self.Sprite_RedPoint:setVisible(show)
end
function NebulaEmperorTeamPanel:onMsgReqTeamInfoBack(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.teamInfo then
		local _ENV, teamInfo = event.teamInfo, event.teamInfo
	end
	self.targetTeamId = teamInfo.tid
	local memberCount = teamInfo.memberCount or 0
	self:updateTextMember(memberCount)
	self.memberList = teamDef.transMemberList(teamInfo.memberList)
	self:sortMemberList(self.memberList)
	self.fields.Com_searchMember:setMemberList(self.memberList)
	local memberList = self.fields.Com_searchMember:getTableMemberList()
	self:updateMemberList(memberList)
end
function NebulaEmperorTeamPanel:updateButtonWar(...)
	if worldMapDefine.isInNebulaEmperor() then
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local warCount = kingdomMapCtrl:getHallWarCount()
		self.fields.Button_war:setReddot(0 < warCount, warCount)
	end
end
return NebulaEmperorTeamPanel
