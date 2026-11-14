local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local memberMgr = SoraDGetCtrl("memberMgr")
local chatroomCtrl = SoraDGetCtrl("chatroomCtrl")
local allianceDesRead = include("allianceDesRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ChatAtSelectPanel = class("ChatAtSelectPanel", baseFguiPanel)
function ChatAtSelectPanel:ctor(...)
	ChatAtSelectPanel.super.ctor(self, ...)
	print("ChatAtSelectPanel:ctor", self.viewName)
	self.selfUid = gametop.playertop_:getPlayerID()
end
function ChatAtSelectPanel:onInit()
	print("=======ChatAtSelectPanel:onInit")
	self.callback = self.param and self.param.callback
	local _fields = fguiHelper.get_fields(self.fields.Com_input)
	self.input = _fields.input
	self.input:setPrompt(i18n("chat_text_87"))
	self.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:setVirtual()
	self.fields.Com_all:setString(i18n("alliance_office_title_04"))
	self.fields.Com_all:addClickListener(handler(self, self.onClickBtnAll))
	if not SoraDFIsRA() then
		self.fields.Com_input:fixChildrenPos()
		self.fields.Com_all:fixChildrenPos()
	end
end
function ChatAtSelectPanel:onShow()
	print("=======ChatAtSelectPanel:onShow")
	SoraDShowLoading(self:displayObject())
	self.controllers.c1:setSelectedIndex(1)
	self.chatChannel = self.param and self.param.chatChannel
	if self.chatChannel == gChatChannel.ALLIANCE then
		allianceQuery:reqMemberList(allianceMgr:getOwnAid())
	elseif self.chatChannel == gChatChannel.CHATROOM then
		local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
		local curChatChannelInfo = chatDataMgr:getChatChannelInfo()
		self.crid = curChatChannelInfo.target
		chatroomCtrl:reqChatRoomGetMembers(self.crid)
	elseif self.chatChannel == gChatChannel.TEAM then
		if worldMapDefine.isInNebulaAllStar() then
			self:initNebulaAllStarTeam()
		elseif worldMapDefine.isInRoaringFlame() then
			self:initRoaringFlameInfo()
		end
	elseif self.chatChannel == gChatChannel.CAMP and worldMapDefine.isInNebulaAllStar() then
		local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
		if myTeamInfo:getIsSuperTeam() then
			myTeamInfo:reqTeamNebulaAllStarTeamInfo(2)
		elseif myTeamInfo:getIsBackupTeam() then
			myTeamInfo:reqTeamNebulaAllStarTeamInfo(1)
		end
	end
end
function ChatAtSelectPanel:onInputChanged(...)
	local searchName = self.input:getText()
	if string.utf8len(searchName) <= 0 then
		self.tableMemberList = self.memberList
	else
		local _ENV, ret = self.memberList, self.memberList
		for i, v in ipairs(self.memberList) do
			if string.find(string.lower(v.nickName), string.lower(searchName), 1, true) then
				table.insert(ret, v)
			end
		end
		self.tableMemberList = ret
	end
	self.fields.List:setNumItems(#self.tableMemberList)
end
function ChatAtSelectPanel:onItemRender(index, obj)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj:addClickListener(handler(self, self.onClickItem))
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	obj:setTag(index)
	local _fields = obj._fields
	local data = self.tableMemberList[index + 1]
	_fields.Text_name:setString(data.nickName)
	_fields.Com_head:setHeadSprite(data.iconID or data.imageId or data.headid, data.avatar)
end
function ChatAtSelectPanel:onClickBtnAll(EventContext)
	if self.callback then
		_UPVALUE0_ = self.callback
		local self.callback.isAtAll, param = true, self.callback
		self.callback(param)
	end
	self:removeFromParent()
end
function ChatAtSelectPanel:onClickItem(EventContext)
	local index = EventContext:getSender():getTag()
	if self.callback then
		local data = self.tableMemberList[index + 1]
		_UPVALUE0_ = index + 1
		;(index + 1).uid = data.uid
		local (index + 1).nickName, param = data.nickName, index + 1
		self.callback(param)
	end
	self:removeFromParent()
end
function ChatAtSelectPanel:onMsgUpdateMemberList(...)
	SoraDCloseLoading(self:displayObject())
	if allianceDesRead.checkRank(gAllianceRank.R4) then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	local _ENV, ret = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	local memberList = allianceMgr:getAllianceProperty("memberlist")
	for __, uid in ipairs(memberList) do
		if uid ~= self.selfUid then
			local member = memberMgr:getMember(uid)
			local uinfo = member:getProperty("uinfo")
			local data = clone(uinfo)
			data.uid = uid
			table.insert(ret, data)
		end
	end
	self:updateMemberList(ret)
end
function ChatAtSelectPanel:msgGetMembersSuccess(target, event)
	if event.crid ~= self.crid then
		return
	end
	SoraDCloseLoading(self:displayObject())
	local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(self.crid)
	if chatRoom.ownerUid == self.selfUid then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	local _ENV, ret = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	for i, v in ipairs(chatRoom.members) do
		if v.uid ~= self.selfUid and v.sourceKid == 0 then
			table.insert(ret, v)
		end
	end
	self:updateMemberList(ret)
end
function ChatAtSelectPanel:initNebulaAllStarTeam(...)
	SoraDCloseLoading(self:displayObject())
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if myTeamInfo:getIsBackupTeam() then
		self.controllers.c1:setSelectedIndex(1)
	elseif myTeamInfo:isTeamLeader() or myTeamInfo:isTeamCommander() then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	local _ENV, ret = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
	local memberList = myTeamInfo:getTeamMemberList()
	self:mergeMemberList(ret, memberList)
	self:updateMemberList(ret)
end
function ChatAtSelectPanel:onMsgNebulaAllStarTeamInfo(target, event)
	SoraDCloseLoading(self:displayObject())
	local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
	if myTeamInfo:getIsBackupTeam() then
		self.controllers.c1:setSelectedIndex(1)
	elseif myTeamInfo:isTeamLeader() or myTeamInfo:isTeamCommander() then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	local teamDef = include("teamDef")
	if not event.teamInfo then
		local _ENV, teamInfo = event.teamInfo, event.teamInfo
	end
	local memberList1 = teamDef.transMemberList(teamInfo.memberList)
	local memberList2 = myTeamInfo:getTeamMemberList()
	local _ENV, ret = myTeamInfo, myTeamInfo
	if teamDef.getIsSuperTeam(teamInfo) then
		ret = memberList1
		self:mergeMemberList(ret, memberList2)
	else
		self:mergeMemberList(ret, memberList2)
		table.insertto(ret, memberList1)
	end
	self:updateMemberList(ret)
end
function ChatAtSelectPanel:initRoaringFlameInfo(...)
	SoraDCloseLoading(self:displayObject())
	local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
	local memberClass = roaringFlameWarCtrl:getPlayerMemberClass()
	if memberClass >= ROARING_FLAME_WAR_MEMBER_CLASS.MANAGER then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	local teamData = chatDataMgr:getTeamData(gChatSet.TOTAL)
	local _ENV, ret = chatDataMgr, chatDataMgr
	local _ENV, map = gChatSet.TOTAL, gChatSet.TOTAL
	map[self.selfUid] = true
	for __, v in ipairs(teamData) do
		if v.playerId and not map[v.playerId] then
			_ENV = map[v.playerId]
			map[v.playerId].uid = v.playerId
			map[v.playerId].nickName = v.nickName
			map[v.playerId].imageId = v.imageId
			local map[v.playerId].avatar, data = v.avatarUrl, map[v.playerId]
			table.insert(ret, data)
			map[v.playerId] = true
		end
	end
	self:updateMemberList(ret)
end
function ChatAtSelectPanel:mergeMemberList(ret, memberList)
	for __, data in ipairs(memberList) do
		if data.uid ~= self.selfUid then
			table.insert(ret, data)
		end
	end
end
function ChatAtSelectPanel:updateMemberList(memberList)
	dump(memberList, "==ChatAtSelectPanel:updateMemberList==")
	self.memberList = memberList
	self.tableMemberList = self.memberList
	self.fields.List:setNumItems(#self.tableMemberList)
end
return ChatAtSelectPanel
