local chatAuxiliary = class("chatAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
function chatAuxiliary:ctor()
end
function chatAuxiliary:sendMessageByType(chatType, content, contentType)
	if "table" == type(content) then
		content.text = gModuleMgr.sharedMgr("shieldedWordsltCtrl"):replaceShieldedWords(content.text)
		local chatDataParser = include("chatDataParser")
		chatDataParser.wrapOfficialData(content)
	end
	_ENV = chatDataParser
	include("chatDataParser").cmd = gCmd.CMD_CHAT_MODULE
	_ENV, include("chatDataParser").subcmd = gCmd.REQ_SEND_MESSAGE, gCmd.REQ_SEND_MESSAGE
	gCmd.REQ_SEND_MESSAGE.chatType = chatType
	gCmd.REQ_SEND_MESSAGE.content = content
	include("chatDataParser").data, gCmd.REQ_SEND_MESSAGE.contentType = gCmd.REQ_SEND_MESSAGE, contentType
	local msg = include("chatDataParser")
	return msg
end
function chatAuxiliary:requestChatDataByType(chatType, number)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CHAT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_CHAT_DATA, gCmd.REQ_CHAT_DATA
	gCmd.REQ_CHAT_DATA.chatType = chatType
	;(nil).data, gCmd.REQ_CHAT_DATA.number = gCmd.REQ_CHAT_DATA, number
	local msg
	return msg
end
function chatAuxiliary:shieldUserByType(uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CHAT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SHIELD_USER, gCmd.REQ_SHIELD_USER
	;(nil).data, gCmd.REQ_SHIELD_USER.uid = gCmd.REQ_SHIELD_USER, uid
	local msg
	return msg
end
function chatAuxiliary:unShieldUserByType(uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CHAT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_UNSHIELD_USER, gCmd.REQ_UNSHIELD_USER
	;(nil).data, gCmd.REQ_UNSHIELD_USER.uid = gCmd.REQ_UNSHIELD_USER, uid
	local msg
	return msg
end
function chatAuxiliary:validateMessage(message)
	if string.len(message) > 500 then
		return gErrDef.Err_CHARACTER_LIMIT
	end
	return gErrDef.Err_None
end
function chatAuxiliary:validateNumber(number)
	if type(number) ~= "number" then
		return gErrDef.Err_CHAT_DATA_NOT_NUMBER
	end
	return gErrDef.Err_None
end
function chatAuxiliary:sendServiceMessage(consumeType, message)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CHAT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SEND_SERVICE_MESSAGE, gCmd.REQ_SEND_SERVICE_MESSAGE
	gCmd.REQ_SEND_SERVICE_MESSAGE.consumeType = consumeType
	;(nil).data, gCmd.REQ_SEND_SERVICE_MESSAGE.content = gCmd.REQ_SEND_SERVICE_MESSAGE, message
	local msg
	return msg
end
function chatAuxiliary:mosaicChatData(data)
end
function chatAuxiliary:initBehaviour()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_BEHAVIOUR_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_GET_BEHAVIOUR_DATA, gCmd.REQ_GET_BEHAVIOUR_DATA
	;(nil).data, gCmd.REQ_GET_BEHAVIOUR_DATA.key = gCmd.REQ_GET_BEHAVIOUR_DATA, "chatChannel"
	local msg
	return msg
end
function chatAuxiliary:setChatChannel(chatChannel)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_BEHAVIOUR_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SET_BEHAVIOUR_DATA, gCmd.REQ_SET_BEHAVIOUR_DATA
	gCmd.REQ_SET_BEHAVIOUR_DATA.key = "chatChannel"
	;(nil).data, gCmd.REQ_SET_BEHAVIOUR_DATA.chatChannel = gCmd.REQ_SET_BEHAVIOUR_DATA, chatChannel
	local msg
	return msg
end
return chatAuxiliary
