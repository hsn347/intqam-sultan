local gametop = gModuleMgr.getObject("gametop")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatConst = include("chatConst")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local chatRoomPlayerAvatar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://chatView/chatRoomPlayerAvatar", chatRoomPlayerAvatar)
function chatRoomPlayerAvatar:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function chatRoomPlayerAvatar:onShow()
end
function chatRoomPlayerAvatar:initWithData(data)
	self.itemData = data
	local playerId = data.playerId
	local imgPlayer = data.imgPlayer
	local nickName = data.nickName or ""
	local imageId = data.imageId
	local avatar = data.avatar
	self.opType = data.opType
	if data.dataType == chatConst.memberListDataType.dt_member then
		self.controllers.c1:setSelectedIndex(0)
		self.playerId = playerId
		self.chatType = data.chatType
		print("imageId = ", imageId, ", avatar = ", avatar)
		self.fields.Com_head:setHeadSprite(imageId, avatar)
		self.fields.text_name:setString(nickName)
		if self.fields.imgDel then
			self.fields.imgDel:setVisible(false)
		end
		if self.itemData.isInDelMode == true then
			self:enterDelMode()
		else
			self:leaveDelMode()
		end
	elseif self.opType == chatConst.memberListOpType.op_del then
		self.controllers.c1:setSelectedIndex(self.itemData.isActive and 3 or 2)
	elseif self.opType == chatConst.memberListOpType.op_add then
		self.controllers.c1:setSelectedIndex(1)
	end
end
function chatRoomPlayerAvatar:setScrollView(scrollView)
	self.scrollView = scrollView
end
function chatRoomPlayerAvatar:enterDelMode()
	self.fields.imgDel:setVisible(true)
	self.isInDelMode = true
end
function chatRoomPlayerAvatar:leaveDelMode()
	self.fields.imgDel:setVisible(false)
	self.isInDelMode = false
end
function chatRoomPlayerAvatar:onClick()
	SoraDPlaySound()
	if self.opType == chatConst.memberListOpType.op_add then
		_ENV = chatConst.memberListOpType.op_add
		chatConst.memberListOpType.op_add.msg = "MESSAGE_CHAT_ROOM_OPEN_SEL_PLAYERS"
		SoraDSendMessage(chatConst.memberListOpType.op_add)
	elseif self.opType == chatConst.memberListOpType.op_del then
		if not self.itemData.isActive then
			self.itemData.isActive = true
			_ENV = chatConst.memberListOpType.op_del
			chatConst.memberListOpType.op_del.msg = "MESSAGE_CHAT_ROOM_ENTER_DEL_PLAYERS_MODE"
			SoraDSendMessage(chatConst.memberListOpType.op_del)
			self.controllers.c1:setSelectedIndex(self.itemData.isActive and 3 or 2)
		else
			self.itemData.isActive = false
			_ENV = self.controllers.c1
			self.controllers.c1.msg = "MESSAGE_CHAT_ROOM_LEAVE_DEL_PLAYERS_MODE"
			SoraDSendMessage(self.controllers.c1)
			self.controllers.c1:setSelectedIndex(self.itemData.isActive and 3 or 2)
		end
	elseif self.itemData.dataType == chatConst.memberListDataType.dt_member then
		if self.isInDelMode == true then
			dump(self.scrollView.itemsData, "self.scrollView.itemsData<")
			if #self.scrollView.itemsData <= 5 then
				SoraDShowMsgBox(i18n("common_text_4594"), i18n("common_text_204"), nil, function(msgType)
					if MSGBOX_CALLBACK_YES == msgType then
						_ENV = nil
						;(nil).crid = self.scrollView.itemData.crid
						chatroomCtrl:reqDismissChat(nil)
					end
				end)
				return
			end
			print("删除某个成员出聊天室, id = ", self.playerId)
			local crid = self.scrollView.itemData.crid
			_ENV, chatConst = self.playerId, "删除某个成员出聊天室, id = "
			self.playerId.uid = self.playerId
			local ("删除某个成员出聊天室, id = ")[1], members = self.playerId, "删除某个成员出聊天室, id = "
			chatroomCtrl:reqChatRoomDelMembers(crid, members)
		else
			print("不做任何操作")
		end
	end
end
return chatRoomPlayerAvatar
