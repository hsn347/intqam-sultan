local gametop = gModuleMgr.getObject("gametop")
local mailCtrl = gametop.playertop_:getModule("mailCtrl")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local mailFunctions = include("mailFunctions")
local chatConst = include("chatConst")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local lordLocalData = include("lordLocalData")
local chatFunctions = include("chatFunctions")
local baseComponent = require("fgui.base.baseComponent")
local chatRoomPlayersScroll = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://chatView/chatRoomPlayersScroll", chatRoomPlayersScroll)
function chatRoomPlayersScroll:onInit()
	self.itemsData, _ENV, self.recycledOpList, _ENV, self.recycledList, _ENV, self.reload = nil, nil, nil, nil, nil, nil, false
	self.scrollView = SoraDGetChildByName(self, "list")
	self.scrollView:setItemRenderer(handler(self, self.onItemRenderer))
	self.isInDelMode = false
end
function chatRoomPlayersScroll:onShow()
end
function chatRoomPlayersScroll:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_ENTER_DEL_PLAYERS_MODE", handler(self, self.msgEnterDelMode))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_LEAVE_DEL_PLAYERS_MODE", handler(self, self.msgLeaveDelMode))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_DEL_MEMBER_SUCCESS", handler(self, self.msgDelMemberSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_SERVER_DEL_MEMBER_FAILURE", handler(self, self.msgDelMemberFailure))
	SoraDAddMessage(self, "MESSAGE_CHAT_ROOM_REFRESH_MEMBERS", handler(self, self.msgRefreshMembers))
end
function chatRoomPlayersScroll:initWithData(data)
	self.itemData = data
	self.maxScrollHeight = data.maxScrollHeight
	self.crid = data.crid
	print("=======----------chatRoomPlayersScroll: initWithData(data), maxScrollHeight, ", maxScrollHeight, ", crid = ", crid)
	self.itemsData = self:getDatas(self.crid)
	self:delayUpdateScrollView()
end
function chatRoomPlayersScroll:getDatas(crid)
	local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(crid)
	if not chatRoom then
		chatroomCtrl = chatroomCtrl.chatroomMgr
		return chatroomCtrl.chatroomMgr
	end
	local chatroomCtrl, itemsData = chatroomCtrl.chatroomMgr, chatroomCtrl.chatroomMgr
	local selfId = chatFunctions:getSelfId()
	for i, v in ipairs(chatRoom.members) do
		local chatroomCtrl, item
		item.dataType = chatConst.memberListDataType.dt_member
		item.playerId = v.uid
		item.imgPlayer = lordLocalData.getHead(v.imageId)
		item.imageId = v.imageId
		item.avatar = v.avatar
		item.nickName = v.nickName
		if item.playerId == chatRoom.ownerUid then
			item.isowner = true
			table.insert(itemsData, 1, item)
		else
			table.insert(itemsData, #itemsData + 1, item)
		end
	end
	chatroomCtrl = nil
	;(nil).dataType = chatConst.memberListDataType.dt_op
	;(nil).opType = chatConst.memberListOpType.op_add
	;(nil).isOp = true
	table.insert(itemsData, #itemsData + 1, nil)
	if selfId == chatRoom.ownerUid then
		local isActive = self.isInDelMode
		chatroomCtrl = chatConst.memberListOpType.op_add
		chatConst.memberListOpType.op_add.dataType = chatConst.memberListDataType.dt_op
		chatConst.memberListOpType.op_add.opType = chatConst.memberListOpType.op_del
		chatConst.memberListOpType.op_add.isActive = isActive
		chatConst.memberListOpType.op_add.isOp = true
		table.insert(itemsData, #itemsData + 1, chatConst.memberListOpType.op_add)
	end
	return itemsData
end
function chatRoomPlayersScroll:getChatRoomMembersData()
	return self:getTestData().members
end
function chatRoomPlayersScroll:delayUpdateScrollView()
	self:updateScrollView()
end
function chatRoomPlayersScroll:mailHistoryEnd(target, data)
end
function chatRoomPlayersScroll:onItemRenderer(index, obj)
	local isInDelMode = self:getIsInDelMode()
	local data = self.itemsData[index + 1]
	if not data.isowner and not data.isOp then
		data.isInDelMode = isInDelMode
	end
	_UPVALUE2_ = nil
	;(nil)[1] = data.isInDelMode
	;(nil)[2] = isInDelMode
	dump(nil, "data.isInDelMode")
	data.isMember = data.dataType == chatConst.memberListDataType.dt_member
	obj:initWithData(data)
	obj:setScrollView(self)
end
function chatRoomPlayersScroll:updateScrollView()
	local totalNumber = #self.itemsData
	self.scrollView:setNumItems(totalNumber)
	self:resizeScrollSize()
end
function chatRoomPlayersScroll:reSizeScrollContent(width)
	self.scrollView:setContentSize(cc.size(width, self.scrollView:getInnerContainerSize().height))
end
function chatRoomPlayersScroll:reSizeScrollContentHeight()
	local width = self.scrollView:getContentSize().width
	self:reSizeScrollContent(width)
end
function chatRoomPlayersScroll:resizeScrollSize()
	self:reSizeScrollContentHeight()
end
function chatRoomPlayersScroll:msgEnterDelMode()
	self.isInDelMode = true
	self:updateScrollView()
end
function chatRoomPlayersScroll:msgLeaveDelMode()
	self.isInDelMode = false
	self:updateScrollView()
end
function chatRoomPlayersScroll:getIsInDelMode()
	return self.isInDelMode
end
function chatRoomPlayersScroll:msgDelMemberSuccess(target, data)
	self.itemsData = self:getDatas(self.crid)
	self:updateScrollView()
end
function chatRoomPlayersScroll:msgDelMemberFailure(target, data)
	print("删除失败------------------")
end
function chatRoomPlayersScroll:msgRefreshMembers(target, data)
	if data.crid ~= nil and data.crid ~= self.crid then
		print("聊天室id不一致，直接返回")
		return
	end
	self.itemsData = self:getDatas(self.crid)
	self:updateScrollView()
end
return chatRoomPlayersScroll
