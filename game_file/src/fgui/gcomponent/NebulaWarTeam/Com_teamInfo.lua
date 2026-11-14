local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local baseComponent = require("fgui.base.baseComponent")
local Com_teamInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWarTeam/Com_teamInfo", Com_teamInfo)
function Com_teamInfo:onInit()
	self.myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
	self.isSuperTeam = self.myTeamInfo:getIsSuperTeam()
	self.hasNewTeamMsg = false
	self.fields.List_member:setItemRenderer(handler(self, self.onMemberItemRederer))
	self.fields.List_member:setVirtual()
	self.fields.Button_invite:setString(i18n("remains_btn_10"))
	self.fields.Button_invite:addClickListener(handler(self, self.onClickOperateBtn))
	self.fields.Button_apply:setString(i18n("remains_btn_11"))
	self.fields.Button_apply:addClickListener(handler(self, self.onClickOperateBtn))
	self.fields.Button_chat:addClickListener(handler(self, self.onClickOperateBtn))
	self.Sprite_RedPoint = self.fields.Button_chat:getChild("Sprite_RedPoint")
	self.Sprite_RedPoint:setVisible(false)
	self.Sprite_chat = self.fields.Button_chat:getChild("icon")
	if worldMapDefine.isInNebula() then
		self.fields.Button_chat:setVisible(false)
	end
	self.fields.Button_search:addClickListener(handler(self, self.onClickOperateBtn))
	self:updateName()
	self:updateFlag()
	self:updateApplyBtn()
	self:refreshTeamInfo()
	self:updateNewTeamMsg()
	self:initSearchView()
	self.fields.Com_teamBase:setIsSuperTeam(self.isSuperTeam)
end
function Com_teamInfo:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_MEMBER_INFO_BACK", handler(self, self.onMsgMemberInfoBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.updateNewTeamMsg))
end
function Com_teamInfo:onShow()
	self.myTeamInfo:reqTeamGetTeamMemberInfo()
	SoraDShowLoading(self:displayObject())
end
function Com_teamInfo:onMemberItemRederer(index, obj)
	local memberData = self.tableMemberList[index + 1]
	_UPVALUE0_ = nil
	;(nil).isSuperTeam = self.isSuperTeam
	obj:initMemberData(memberData, nil)
end
function Com_teamInfo:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_invite then
		uiManager:show("NebulaWarTeamInvite")
	elseif sender == self.fields.Button_apply then
		uiManager:show("NebulaWarTeamApply")
	elseif sender == self.fields.Button_chat then
		self:setNewTeamMsg(false)
		_ENV = self.setNewTeamMsg
		self.setNewTeamMsg.teamId = self.myTeamInfo:getTeamID()
		self.setNewTeamMsg.teamType = self.myTeamInfo:getTeamType()
		local self.setNewTeamMsg.myTeamInfo, data = self.myTeamInfo, self.setNewTeamMsg
		local panel = SoraDCreatePanel("teamChatView")
		panel:initWithData(data)
		panel:show()
	elseif sender == self.fields.Button_search then
		_ENV = panel
		panel.justLook = true
		uiManager:show("NebulaWarTeamJoin", panel)
	end
end
function Com_teamInfo:onMsgMemberInfoBack(...)
	SoraDCloseLoading(self:displayObject())
	self:refreshMemberInfo()
end
function Com_teamInfo:refreshMemberInfo(...)
	self.memberList = self.myTeamInfo:getTeamMemberList()
	if self.isSuperTeam then
		local _ENV, ret = self.isSuperTeam, self.isSuperTeam
		for i, member in ipairs(self.memberList) do
			_ENV = member.uid
			member.uid.isOnline = member.online == 0
			ret[tostring(member.uid)], member.uid.isLeader = member.uid, self.myTeamInfo:isTeamLeader(member.uid)
		end
		table.sort(self.memberList, function(a, b)
			local dataA = ret[tostring(a.uid)]
			local dataB = ret[tostring(b.uid)]
			if dataA.isOnline ~= dataB.isOnline then
				return dataA.isOnline
			end
			if dataA.isLeader ~= dataB.isLeader then
				return dataA.isLeader
			end
			if a.totalFc ~= b.totalFc then
				return a.totalFc > b.totalFc
			end
			return a.uid < b.uid
		end)
	else
		table.sort(self.memberList, function(a, b)
			local onlineA = a.online == 0
			local onlineB = b.online == 0
			if onlineA ~= onlineB then
				return onlineA
			end
			if a.totalFc ~= b.totalFc then
				return a.totalFc > b.totalFc
			end
			return a.uid < b.uid
		end)
	end
	local nebulaWarUtil = include("nebulaWarUtil")
	local total = nebulaWarUtil.getTeamMerberMax(self.isSuperTeam)
	_ENV = tostring(member.uid)
	tostring(member.uid).num = #self.memberList
	tostring(member.uid).num1 = total
	self.fields.Text_member:setString(i18n("nebula_war_text_0026", (tostring(member.uid))))
	local searchData = self:getSearchData()
	if 0 < #searchData then
		self.tableMemberList = searchData
	else
		self.searchName = nil
		self.tableMemberList = self.memberList
	end
	self.fields.List_member:setNumItems(#self.tableMemberList)
	local ownUid = gametop.playertop_:getPlayerID()
	for i, member in ipairs(self.memberList) do
		if ownUid == member.uid then
			self.fields.List_member:scrollToView(i - 1)
			break
		end
	end
end
function Com_teamInfo:refreshTeamInfo()
	self:refreshLeader()
	self:refreshMemberInfo()
end
function Com_teamInfo:refreshLeader(...)
	if self.myTeamInfo:isTeamLeader() then
		self.controllers.c_isLeader:setSelectedIndex(0)
	else
		self.controllers.c_isLeader:setSelectedIndex(1)
	end
end
function Com_teamInfo:updateFlag(...)
	self.fields.Loader3D_flag:clearContent()
	local __, nodeFlag = allianceDesRead.getFlagWithParticle(self.myTeamInfo:getTeamFlag())
	self.fields.Loader3D_flag:setContent(nodeFlag)
end
function Com_teamInfo:updateName(...)
	self.fields.Com_teamBase:setString(self.myTeamInfo:getTeamName())
end
function Com_teamInfo:updateApplyBtn(...)
	self.fields.Button_apply:setReddot(self.myTeamInfo:isTeamHasApproval())
end
function Com_teamInfo:onMsgTeamInfoNotify(target, event)
	if event.teamType and event.teamType ~= self.teamType then
		return
	end
	local notifyType = event.notifyType
	_UPVALUE0_ = self.teamType
	self.teamType.JOIN = true
	local self.teamType.QUIT, config = true, self.teamType
	if config[notifyType] then
		self:refreshMemberInfo()
	elseif notifyType == "UPDATE_LEADER" then
		self:refreshTeamInfo()
	elseif notifyType == "UPDATE_SETTING" then
		local notifyKey = event.key
		if notifyKey == "commanders" then
			self:refreshTeamInfo()
		elseif notifyKey == "assemblers" then
			self:refreshMemberInfo()
		else
			self:updateFlag()
		end
	elseif notifyType == "UPDATE_NAME" or notifyType == "UPDATE_ABBR" then
		self:updateName()
	elseif notifyType == "APPLY_JOIN" or notifyType == "HAS_APPLY" then
		self:updateApplyBtn()
	end
end
function Com_teamInfo:setNewTeamMsg(new)
	if self.hasNewTeamMsg == new then
		return
	end
	if new and SoraDSearchPanelFromManagerByName("teamChatView") then
		return
	end
	self.hasNewTeamMsg = new
	self:showNewEffect(self.hasNewTeamMsg)
end
function Com_teamInfo:updateNewTeamMsg()
	print("==Com_teamInfo:updateNewTeamMsg==", self.myTeamInfo:isHasNewTeamMsg())
	local new = self.myTeamInfo:isHasNewTeamMsg()
	self:setNewTeamMsg(new)
end
function Com_teamInfo:showNewEffect(show)
	self.Sprite_chat:stopAllActions()
	if show then
		_UPVALUE7_ = self.Sprite_chat
		self.Sprite_chat[1] = ffa.delay(1.0)
		self.Sprite_chat[2] = ffa.rotateTo(0.25, 10)
		self.Sprite_chat[3] = ffa.rotateTo(0.21666666666666667, -10)
		self.Sprite_chat[4] = ffa.rotateTo(0.2, 8)
		self.Sprite_chat[5] = ffa.rotateTo(0.16666666666666666, -5)
		self.Sprite_chat[6] = ffa.rotateTo(0.15, 2)
		self.Sprite_chat[7] = ffa.rotateTo(0.15, 0)
		self.Sprite_chat[8] = ffa.delay(1.0)
		self.Sprite_chat[9] = ffa.delay(1.0)
		local seq = ffa.seq(self.Sprite_chat)
		self.Sprite_chat:runAction(ffa.repeatForever(seq))
	else
		self.Sprite_chat:setRotation(0)
	end
	self.Sprite_RedPoint:setVisible(show)
end
function Com_teamInfo:initSearchView(...)
	self.fields.Button_searchMember:setString(i18n("common_text_166"))
	self.fields.Button_searchMember:addClickListener(handler(self, self.onClickBtnSearchMember))
	local inputFields = fguiHelper.get_fields(self.fields.Label_input)
	self.Button_all = inputFields.Button_all
	self.Button_all:addClickListener(handler(self, self.onClickBtnAll))
	self.Button_all:setVisible(false)
	self.Text_input = inputFields.input
	self.Text_input:setMaxLength(ALLIANCE_NAME_MAX)
	self.Text_input:setPrompt(i18n("nebula_war_text_0372"))
	self.Text_input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	self.fields.Label_input:fixPos()
	self.fields.Label_input:fixChildrenPos()
	self.fields.Button_searchMember:fixPos()
end
function Com_teamInfo:onClickBtnSearchMember(...)
	SoraDPlaySound()
	local searchName = self.Text_input:getText()
	if string.utf8len(searchName) <= 0 then
		return
	end
	self.searchName = searchName
	local searchData = self:getSearchData()
	if 0 < #searchData then
		self.tableMemberList = searchData
	else
		SoraDShowMsgTip(i18n("common_text_963"))
		self.Text_input:setString("")
		self.searchName = nil
		self.tableMemberList = self.memberList
	end
	self.fields.List_member:setNumItems(#self.tableMemberList)
end
function Com_teamInfo:getSearchData(...)
	if not self.searchName then
		return self.memberList
	end
	local _ENV, searchData = self.memberList, self.memberList
	for i, member in ipairs(self.memberList) do
		if string.find(string.lower(member.nickName), string.lower(self.searchName), 1, true) then
			table.insert(searchData, member)
		end
	end
	return searchData
end
function Com_teamInfo:onClickBtnAll(...)
	SoraDPlaySound()
	self.Text_input:setString("")
	self:onInputChanged()
end
function Com_teamInfo:onInputChanged(...)
	local searchName = self.Text_input:getText()
	if string.utf8len(searchName) <= 0 then
		self:resetTableMemberList()
		self.Button_all:setVisible(false)
	else
		self.Button_all:setVisible(true)
	end
end
function Com_teamInfo:resetTableMemberList(...)
	if self.searchName then
		self.searchName = nil
		self.tableMemberList = self.memberList
		self.fields.List_member:setNumItems(#self.tableMemberList)
	end
end
return Com_teamInfo
