local chatBaseMgr = include("chatBaseMgr")
local chatMgrs = class("chatMgrs", chatBaseMgr)
_UPVALUE12_ = "chatMgrs"
;("chatMgrs")[1] = "chatResMgr"
;("chatMgrs")[2] = "chatDataMgr"
;("chatMgrs")[3] = "chatTranslateMgr"
;("chatMgrs")[4] = "chatSendMgr"
;("chatMgrs")[5] = "chatMsgMgr"
;("chatMgrs")[6] = "chatAudioMgr"
;("chatMgrs")[7] = "chatRedPacketMgr"
;("chatMgrs")[8] = "chatMenuMgr"
;("chatMgrs")[9] = "chatMenuHandlerMgr"
;("chatMgrs")[10] = "chatThemeMgr"
;("chatMgrs")[11] = "chatUnReadMgr"
local ("chatMgrs")[12], _cfgMgrComponents = "chatCoverMgr", "chatMgrs"
function chatMgrs:ctor()
end
function chatMgrs:init()
	self.mgrComponents, _ENV = nil, nil
	for _, mgrname in ipairs(_cfgMgrComponents) do
		self.mgrComponents[mgrname] = include(mgrname).new()
	end
	for _, v in pairs(self.mgrComponents) do
		v:init()
	end
end
function chatMgrs:reset()
	for _, v in pairs(self.mgrComponents) do
		v:reset()
	end
end
function chatMgrs:clean()
	self:reset()
	for _, v in pairs(self.mgrComponents) do
		v:clean()
	end
end
function chatMgrs:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
	for _, v in pairs(self.mgrComponents) do
		v:removeMessageListener()
	end
end
function chatMgrs:registerMessageListener()
	self:removeMessageListener()
	for _, v in pairs(self.mgrComponents) do
		v:registerMessageListener()
	end
end
function chatMgrs:getMgr(mgrName)
	return self.mgrComponents[mgrName]
end
gChatMgrs = chatMgrs.new()
gChatMgrs:init()
return gChatMgrs
