local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailFunctions = include("mailFunctions")
local chatFunctions = include("chatFunctions")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatConst = include("chatConst")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ChatRoomInfoViewPanel = class("ChatRoomInfoViewPanel", baseFguiPanel)
function ChatRoomInfoViewPanel:ctor(...)
	ChatRoomInfoViewPanel.super.ctor(self, ...)
	self.debug = true
	print("ChatRoomInfoViewPanel:ctor", self.viewName)
end
function ChatRoomInfoViewPanel:onInit()
	print("=======ChatRoomInfoViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2033"), handler(self, self.onClickClose))
	self.chatRoomPlayersScrollView = SoraDGetChildByName(self, "CCS_chatRoomPlayersScroll_Node")
	self.btnPanelExit = SoraDGetChildByName(self, "BtnPanelExit")
	self.btnPanelExit:addTouchEventListener(handler(self, self.onBtnPanelExit))
	self.btnPanelExit:setTitle(i18n("soldier_rush_text_24"))
	self.text_room_exit = SoraDGetChildByName(self, "Text_RoomExit")
	self.textDesc = SoraDGetChildByName(self, "Text_Desc")
	self.text_room_tip = SoraDGetChildByName(self.panelName, "Text_RoomNameTip")
	self.text_room_exit:setString(i18n("common_text_2036"))
	self.textDesc:setString(i18n("common_text_2035"))
	if self.param and self.param.chatRoom then
		self:initWithData(self.param.chatRoom)
	end
end
function ChatRoomInfoViewPanel:onShow()
	print("=======ChatRoomInfoViewPanel:onShow")
end
function ChatRoomInfoViewPanel:initWithData(data)
	self.itemData = data
	if not self.itemData then
		return
	end
	self.crid = self.itemData.crid
	SoraDShowLoading(self, cc.size(display.size.width, display.size.height - 106))
	chatroomCtrl:getChatRoomMembers(self.crid)
end
function ChatRoomInfoViewPanel:onBtnPanelExit(sender, event)
	SoraDPlaySound()
	print("退出了聊天室--------------------------------")
	SoraDShowMsgBox(i18n("common_text_2034"), i18n("common_text_204"), i18n("common_text_185"), handler(self, self.confirmExit))
end
function ChatRoomInfoViewPanel:confirmExit(type)
	if type == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
		print("TODO: ------exit room")
		self:showLoading()
		chatroomCtrl:reqChatRoomQuit(self.crid)
	end
end
function ChatRoomInfoViewPanel:msgOpenSelPlayers(target, data)
	print("打开聊天---------------------------")
	if not allianceMgr:hasJoinAlliance() then
		_ENV = allianceMgr
		allianceMgr.msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
		allianceMgr.info = "From CHATROOM"
		SoraDSendMessage(allianceMgr)
		return
	end
	local chatRoomSelPlayers = SoraDCreatePanel("chatRoomSelPlayers")
	chatRoomSelPlayers:show()
	local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(self.itemData.crid)
	if not chatRoom then
		return
	end
	local _ENV, members = chatroomCtrl.chatroomMgr, chatroomCtrl.chatroomMgr
	local _ENV, memberMap = self.itemData.crid, self.itemData.crid
	for i, v in ipairs(chatRoom.members) do
		table.insert(members, #members + 1, v.uid)
		memberMap[v.uid] = v
	end
	local ownerId = chatRoom.ownerUid
	_ENV = ipairs(chatRoom.members)
	ipairs(chatRoom.members).selPlayerOpType = chatConst.selPlayerOpType.selPlayerJoinChatRoom
	ipairs(chatRoom.members).members = members
	ipairs(chatRoom.members).owner = ownerId
	ipairs(chatRoom.members).crid = self.itemData.crid
	local ipairs(chatRoom.members).memberMap, data = memberMap, ipairs(chatRoom.members)
	chatRoomSelPlayers:initWithData(data)
end
function ChatRoomInfoViewPanel:msgGetMembersSuccess(target, data)
	SoraDCloseLoading(self)
	_ENV = SoraDCloseLoading
	SoraDCloseLoading.maxScrollHeight = self.maxScrollHeight
	local SoraDCloseLoading.crid, data = self.itemData.crid, SoraDCloseLoading
	self.chatRoomPlayersScrollView:initWithData(data)
end
function ChatRoomInfoViewPanel:msgCloseInfoView(target, data)
	self:closeLoading()
	self:close()
end
function ChatRoomInfoViewPanel:showLoading()
	SoraDShowLoading(self)
end
function ChatRoomInfoViewPanel:closeLoading()
	SoraDCloseLoading(self)
end
function ChatRoomInfoViewPanel:msgShowLoading(target, data)
	self:showLoading()
end
function ChatRoomInfoViewPanel:msgCloseLoading(target, data)
	self:closeLoading()
end
function ChatRoomInfoViewPanel:sMsgQuitSuccess(target, data)
	local delCrid = data.crid
	self:closeLoading()
	if self.itemData.crid == delCrid then
		self:close()
	end
end
function ChatRoomInfoViewPanel:sMsgModifyNameFailed(target, data)
end
function ChatRoomInfoViewPanel:msgUpdateLayout(target, data)
end
function ChatRoomInfoViewPanel:sMsgQuitFailed(target, data)
	self:closeLoading()
end
return ChatRoomInfoViewPanel
