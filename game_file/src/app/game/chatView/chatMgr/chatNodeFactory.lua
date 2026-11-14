chatNodeFactory, _ENV = nil, nil
local chatNodeCacheMgr = include("chatNodeCacheMgr")
_ENV = "chatNodeCacheMgr"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.text], (nil).class = nil, "chatTextNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.emoticon], (nil).class = nil, "chatEmoticonNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.date], (nil).class = nil, "chatDateNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.systip], (nil).class = nil, "chatSysTipNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.audio], (nil).class = nil, "chatAudioNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.redpacket], (nil).class = nil, "chatRedPacketNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.goldredpacket], (nil).class = nil, "chatRedPacketNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.name], (nil).class = nil, "chatNameNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.head], (nil).class = nil, "chatHeadNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.status], (nil).class = nil, "chatStatusNode"
_ENV = nil
;(nil).class = "chatVipNode"
;("chatNodeCacheMgr")[gChatNodeType.vip], (nil).tagBegin = nil, gChatNodeType.vip_begin
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.textBtn], (nil).class = nil, "chatTextBtnNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_text], (nil).class = nil, "chatGroupTextNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_sys_text], (nil).class = nil, "chatGroupTextNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_emoticon], (nil).class = nil, "chatGroupEmoticonNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_audio], (nil).class = nil, "chatGroupAudioNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_red_packet], (nil).class = nil, "chatGroupRedPacketNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_viewer_gift], (nil).class = nil, "chatGroupViewerGiftNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.group_honor_back_activity], (nil).class = nil, "chatGroupTextBtnNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.korean_chess_room_invite], (nil).class = nil, "chatGroupTextBtnNode"
_ENV = nil
;("chatNodeCacheMgr")[gChatNodeType.dj_text], (nil).class = nil, "djChatTextNode"
local nodeConfig = "chatNodeCacheMgr"
function chatNodeFactory.getNode(nodeType, caches, tag)
	local node, needRelease = chatNodeCacheMgr.get(nodeType, caches, tag)
	if not node then
		return chatNodeFactory.createNode(nodeType), true, needRelease
	end
	return node, false, needRelease
end
function chatNodeFactory.createNode(nodeType)
	assert(nodeType, "nodeType不能为空----")
	local nodeClass = nodeConfig[nodeType].class
	if nodeClass then
		local node = include(nodeClass).new()
		node:setName(nodeClass)
		return node
	else
		assert("chatNodeFactory nodeType = " .. nodeType .. "未定义")
	end
end
function chatNodeFactory.getClass(nodeType)
	return nodeConfig[nodeType].class
end
function chatNodeFactory.addNode(node, nodeType, caches, tag)
	chatNodeCacheMgr.add(node, nodeType, caches, tag)
end
return chatNodeFactory
