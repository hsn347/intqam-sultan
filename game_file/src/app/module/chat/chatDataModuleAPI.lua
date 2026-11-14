local _ENV, chatDataModuleAPI
function chatDataModuleAPI:getVersion()
	return self:getChatCtrl():getVersion()
end
function chatDataModuleAPI:load(chatChannel, chatDataSet, requireID, startID, pageSize, direction)
	if 0 == startID then
		startID = nil
	end
	self:getChatCtrl():getChatSetData(chatChannel, chatDataSet, startID, pageSize, direction, requireID)
end
function chatDataModuleAPI:reqPromptInfo(chatChannel)
	self:getChatCtrl():getChatPromptInfo(chatChannel)
end
function chatDataModuleAPI:readChatMsg(chatChannel, msgID)
	self:getChatCtrl():readChatMsg(chatChannel, msgID)
end
function chatDataModuleAPI:getVoiceChatRoomInviteInfo()
	return self:getChatCtrl():getVoiceChatRoomInviteInfo()
end
function chatDataModuleAPI:inviteUsersJoinVoiceRoom(roomID, userList)
	self:getChatCtrl():inviteUsersJoinVoiceRoom(roomID, userList)
end
function chatDataModuleAPI:agreeInvitation(inviter, roomID)
	self:getChatCtrl():agreeInvitation(inviter, roomID)
end
function chatDataModuleAPI:rejectInvitation(inviter, roomID)
	self:getChatCtrl():rejectInvitation(inviter, roomID)
end
function chatDataModuleAPI:getChatCtrl()
	local gametop = gModuleMgr.getObject("gametop")
	return gametop.playertop_:getModule("chatCtrl")
end
return chatDataModuleAPI
