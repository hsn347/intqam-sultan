local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local mailFunctions = include("mailFunctions")
local chatFunctions = include("chatFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatConst = include("chatConst")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local chatRoomSelPlayers = class("chatRoomSelPlayers", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRoomSelPlayers")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatRoomSelPlayers:ctor()
	self.needCallBack2SDK = true
	self.btn_confirm = SoraDGetChildByName(self, "Button_confirm")
	if self.btn_confirm ~= nil then
		self.btn_confirm:addTouchEventListener(handler(self, self.onBtnConfirm))
		self.btn_confirm:setPressedActionEnabled(true)
	end
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	self.btn_confirm:setEnabled(false)
	self.btn_confirm:setBright(false)
	self.btn_confirm:getVirtualRenderer():setState(1)
	self.chatRoomSelPlayersScrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatRoomSelPlayersScroll_node", true)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	_ENV = i18n("common_text_204")
	i18n("common_text_204").number = 1
	self.title:setTitle(i18n("common_text_2040", i18n("common_text_204")))
	self.inRoomNumber = 1
	self.playerSearch = SoraDGetExtendChildFromCCSByName(self, "CCS_chatRoomPlayerSearch_node")
	self.chatRoomSelPlayersScrollView:setSearchWidget(self.playerSearch)
end
function chatRoomSelPlayers:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_ADD_MEMBER_SUCCESS", handler(self, self.sMsgChatRoomAddMemberSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_ADD_MEMBER_FAILURE", handler(self, self.sMsgChatRoomAddMemberError))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_UPDATE_SELMEMBERS", handler(self, self.msgUpdateSelMembers))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_CREATE_SUCCESS", handler(self, self.sMsgChatRoomCreateSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_CREATE_FAILURE", handler(self, self.sMsgChatRoomCreateFailure))
end
function chatRoomSelPlayers:initWithData(data)
	self.roomData = data
	if self.roomData.members then
		local number = #self.roomData.members
		self.inRoomNumber = number
		_ENV = nil
		;(nil).number = number
		self.title:setTitle(i18n("common_text_2040", nil))
	end
	if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice then
		local number = 0
		if self.roomData.members then
			number = #self.roomData.members
		end
		local total = voiceRoomCtrl:getMaxMemCount()
		_ENV = i18n("common_text_2040", nil)
		i18n("common_text_2040", nil).member = number
		i18n("common_text_2040", nil).total = total
		self.title:setTitle(i18n("common_text_3978") .. "(" .. i18n("common_text_155", i18n("common_text_2040", nil)) .. ")")
	end
	self.chatRoomSelPlayersScrollView:initWithData(self.roomData)
end
function chatRoomSelPlayers:setHandle(handle)
	self.handle = handle
end
function chatRoomSelPlayers:updateTime()
	do return end
	local strName = self.textField_playerName:getString()
	local strContent = self.textField_Content:getString()
	if strName == self.oldStrName and self.oldStrContent == strContent then
		return
	end
	self.oldStrName = strName
	self.oldStrContent = strContent
	if string.len(strName) > 0 and string.len(strContent) > 0 then
		self.btn_confirm:setEnabled(true)
		self.btn_confirm:setBright(true)
	else
		self.btn_confirm:setEnabled(false)
		self.btn_confirm:setBright(false)
	end
end
function chatRoomSelPlayers:onExitPanel()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function chatRoomSelPlayers:onBtnConfirm(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local selItems, selPlayerIds, selNames = self.chatRoomSelPlayersScrollView:getSelPlayerList()
		local selPlayerOpType = self.roomData.selPlayerOpType
		if selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnly then
			if selItems and 1 < #selItems then
				self.selPlayerIds = selPlayerIds
				self.selItems = selItems
				self.selNames = selNames
				local nameStr = table.concat(selNames, ",")
				local selPlayerOpType = self.roomData.selPlayerOpType
				if selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnly then
					nameStr = chatFunctions:getSelfNickName() .. "," .. nameStr
				end
				nameStr = SoraDConvertOmissionText(1520, nameStr, 22)
				if string.sub(nameStr, -3, -1) == "..." then
					local pre, post = string.match(nameStr, "(.*),(.*)")
					if pre ~= nil then
						nameStr = pre .. "..."
					end
				end
				_ENV = pre
				pre.name = nameStr
				nameStr = i18n("common_text_2159", pre)
				SoraDShowMsgBox(nameStr, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmJoin))
			else
				print("选择了一个人物-------------------------------, 进入私聊模式")
				self.selPlayerIds = selPlayerIds
				self.selItems = selItems
				self.selNames = selNames
				_ENV = "选择了一个人物-------------------------------, 进入私聊模式"
				;("选择了一个人物-------------------------------, 进入私聊模式").msg = "MESSAGE_CHAT_ROOM_SEL_PLAYERS_CONFIRM"
				;("选择了一个人物-------------------------------, 进入私聊模式").selItems = self.selItems
				SoraDSendMessage("选择了一个人物-------------------------------, 进入私聊模式")
				self:close(nil, ccui.TouchEventType.ended)
			end
		elseif selPlayerOpType == chatConst.selPlayerOpType.selPlayerJoinChatRoom then
			if selItems and 1 <= #selItems then
				self.selPlayerIds = selPlayerIds
				self.selItems = selItems
				self.selNames = selNames
				local nameStr = table.concat(selNames, ",")
				local selPlayerOpType = self.roomData.selPlayerOpType
				if selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnly then
					nameStr = chatFunctions:getSelfNickName() .. "," .. nameStr
				end
				nameStr = SoraDConvertOmissionText(1520, nameStr, 22)
				print("nameStr", nameStr)
				if string.sub(nameStr, -3, -1) == "..." then
					local pre, post = string.match(nameStr, "(.*),(.*)")
					if pre ~= nil then
						nameStr = pre .. "..."
					end
				end
				_ENV = pre
				pre.name = nameStr
				nameStr = i18n("common_text_2159", pre)
				SoraDShowMsgBox(nameStr, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmJoin))
			else
			end
		elseif selPlayerOpType == chatConst.selPlayerOpType.selPlayerCreateChatRoom then
			if selItems and 1 < #selItems then
				if worldMapDefine.isInKingdomBattle() then
					SoraDShowMsgTip(i18n("chat_text_99"))
					return
				end
				self.selPlayerIds = selPlayerIds
				self.selItems = selItems
				self.selNames = selNames
				local nameStr = table.concat(selNames, ",")
				local selPlayerOpType = self.roomData.selPlayerOpType
				if selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnly then
					nameStr = chatFunctions:getSelfNickName() .. "," .. nameStr
				end
				nameStr = SoraDConvertOmissionText(1520, nameStr, 22)
				if string.sub(nameStr, -3, -1) == "..." then
					local pre, post = string.match(nameStr, "(.*),(.*)")
					if pre ~= nil then
						nameStr = pre .. "..."
					end
				end
				_ENV = pre
				pre.name = nameStr
				nameStr = i18n("common_text_2159", pre)
				SoraDShowMsgBox(nameStr, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmJoin))
			else
				print("选择了一个人物-------------------------------, 进入私聊模式")
				self.selPlayerIds = selPlayerIds
				self.selItems = selItems
				self.selNames = selNames
				_ENV = "选择了一个人物-------------------------------, 进入私聊模式"
				;("选择了一个人物-------------------------------, 进入私聊模式").msg = "MESSAGE_CHAT_ROOM_SEL_PLAYERS_CONFIRM"
				;("选择了一个人物-------------------------------, 进入私聊模式").selItems = self.selItems
				SoraDSendMessage("选择了一个人物-------------------------------, 进入私聊模式")
				self:close(nil, ccui.TouchEventType.ended)
			end
		elseif selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice then
			dump(selItems, "选择人物------")
			if self.handle then
				self.handle(selItems, self.roomData.otherData)
			end
			self:close(nil, ccui.TouchEventType.ended)
		end
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.began then
	end
end
function chatRoomSelPlayers:confirmJoin(type)
	if type == MSGBOX_CALLBACK_YES then
		print("确认将xxx加入聊天室:")
		dump(self.selItems, "selItems")
		if not self.roomData or not self.roomData.selPlayerOpType then
			return
		end
		SoraDPlaySound()
		local selPlayerOpType = self.roomData.selPlayerOpType
		if selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnly then
			_ENV = "selItems"
			;("selItems").msg = "MESSAGE_CHAT_ROOM_SEL_PLAYERS_CONFIRM"
			;("selItems").selItems = self.selItems
			SoraDSendMessage("selItems")
			self:close(nil, ccui.TouchEventType.ended)
			return
		elseif selPlayerOpType == chatConst.selPlayerOpType.selPlayerJoinChatRoom then
			local loading = SoraDShowLoading(self.btn_confirm, self.btn_confirm:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(self.btn_confirm:getContentSize().width / 2, self.btn_confirm:getContentSize().height / 2))
			local crid = self.roomData.crid
			local aid = allianceMgr:getOwnAid()
			local _ENV, members = allianceMgr, allianceMgr
			local _ENV, membersInRoom = cc.p(self.btn_confirm:getContentSize().width / 2, self.btn_confirm:getContentSize().height / 2)
			if self.roomData and self.roomData.members and #self.roomData.members > 0 then
				for _, v in ipairs(self.roomData.members) do
					membersInRoom[v] = true
				end
			end
			for _, v in ipairs(self.selPlayerIds) do
				if not membersInRoom[v] then
					_ENV = membersInRoom[v]
					local membersInRoom[v].uid, item = v, membersInRoom[v]
					table.insert(members, #members + 1, item)
				end
			end
			chatroomCtrl:reqChatRoomAddMembers(crid, aid, members)
			return
		elseif selPlayerOpType == chatConst.selPlayerOpType.selPlayerCreateChatRoom then
			local crName = i18n("common_text_2033")
			if i18n.getLocale() == "zh_cn" then
				crName = "ChatRoom"
			end
			local aid = allianceMgr:getOwnAid()
			local _ENV, members = allianceMgr, allianceMgr
			local chatType = gChatRoomChatType.TEXT
			for i, v in ipairs(self.selPlayerIds) do
				_ENV = members
				local members.uid, item = v, members
				table.insert(members, #members + 1, item)
			end
			local loading = SoraDShowLoading(self.btn_confirm, self.btn_confirm:getContentSize())
			if loading.loadingImg then
				loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
			end
			loading:setPosition(cc.p(self.btn_confirm:getContentSize().width / 2, self.btn_confirm:getContentSize().height / 2))
			print("请求创建聊天室")
			print("crName = ", crName, ", aid = ", aid)
			dump(members, "成员", 10)
			chatroomCtrl:reqChatRoomCreate(crName, aid, members)
		end
	end
end
function chatRoomSelPlayers:sMsgChatRoomAddMemberSuccess(target, data)
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_ROOM_CLOSE_INFOVIEW"
	SoraDSendMessage(nil)
	self:close(nil, ccui.TouchEventType.ended)
end
function chatRoomSelPlayers:sMsgChatRoomAddMemberError(target, data)
	SoraDCloseLoading(self.btn_confirm)
end
function chatRoomSelPlayers:msgUpdateSelMembers(target, data)
	local total = voiceRoomCtrl:getMaxMemCount()
	local selItems, selPlayerIds, selNames = self.chatRoomSelPlayersScrollView:getSelPlayerList()
	if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice and selItems then
		local number = #selItems
		number = self.inRoomNumber + number
		local curItem = data.curItem
		if curItem and curItem.btn_check:isSelected() and total < number then
			SoraDShowMsgTip(i18n("common_text_3977"))
			curItem:setSelected(false)
			return
		end
	end
	if not selItems then
		self.btn_confirm:setEnabled(false)
		self.btn_confirm:setBright(false)
		self.btn_confirm:getVirtualRenderer():setState(1)
	else
		self.btn_confirm:setEnabled(true)
		self.btn_confirm:setBright(true)
		self.btn_confirm:getVirtualRenderer():setState(0)
	end
	if selItems then
		local number = #selItems or 0
		number = self.inRoomNumber + number
		if self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice then
			voiceRoomCtrl = i18n("common_text_3977")
			i18n("common_text_3977").member = number
			i18n("common_text_3977").total = total
			self.title:setTitle(i18n("common_text_3978") .. "(" .. i18n("common_text_155", i18n("common_text_3977")) .. ")")
		else
			voiceRoomCtrl = i18n("common_text_155", i18n("common_text_3977"))
			i18n("common_text_155", i18n("common_text_3977")).number = number
			self.title:setTitle(i18n("common_text_2040", (i18n("common_text_155", i18n("common_text_3977")))))
		end
	elseif self.roomData.selPlayerOpType == chatConst.selPlayerOpType.selPlayerOnlineVoice then
		local number = self.inRoomNumber
		voiceRoomCtrl = i18n("common_text_2040", (i18n("common_text_155", i18n("common_text_3977"))))
		i18n("common_text_2040", (i18n("common_text_155", i18n("common_text_3977")))).member = number
		i18n("common_text_2040", (i18n("common_text_155", i18n("common_text_3977")))).total = total
		self.title:setTitle(i18n("common_text_3978") .. "(" .. i18n("common_text_155", i18n("common_text_2040", (i18n("common_text_155", i18n("common_text_3977"))))) .. ")")
	else
		voiceRoomCtrl = "("
		;("(").number = self.inRoomNumber
		self.title:setTitle(i18n("common_text_2040", "("))
	end
end
function chatRoomSelPlayers:sMsgChatRoomCreateSuccess(target, data)
	_ENV = nil
	;(nil).crid = data.crid
	;(nil).crname = data.crName
	SoraDCreateChatRoom(nil)
	self:close(nil, ccui.TouchEventType.ended)
end
function chatRoomSelPlayers:sMsgChatRoomCreateFailure(target, data)
	print("创建聊天室失败-------------------------")
	SoraDCloseLoading(self.btn_confirm)
	self.chatRoomSelPlayersScrollView:initWithData(self.roomData)
end
return chatRoomSelPlayers
