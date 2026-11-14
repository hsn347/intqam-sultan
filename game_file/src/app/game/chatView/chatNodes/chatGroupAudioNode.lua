local chatGroupBaseNode = include("chatGroupBaseNode")
local chatGroupAudioNode = class("chatGroupAudioNode", function(target)
	local target = chatGroupBaseNode.new("chatGroupAudioNode")
	return target
end)
chatGroupAudioNode._childConfig = clone(chatGroupBaseNode._childConfig)
_ENV = chatGroupBaseNode._childConfig
chatGroupBaseNode._childConfig.nodeType = gChatNodeType.audio
chatGroupBaseNode._childConfig.zorder = 1
chatGroupAudioNode._childConfig.contentNode, chatGroupBaseNode._childConfig.alignFunc = chatGroupBaseNode._childConfig, "alignNode_content"
function chatGroupAudioNode:ctor()
	self.isDebug = gChatDebug
	self.isLongClick = true
	self._childConfig = chatGroupAudioNode._childConfig
end
function chatGroupAudioNode.measureSize(data, target)
	return chatGroupBaseNode.measureSizeWithContent(chatGroupAudioNode._childConfig, data, target)
end
function chatGroupAudioNode:onClickHandler()
	SoraDPlaySound()
	local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
	chatAudioMgr:playOrStop(self.data)
end
function chatGroupAudioNode:onLongClickHandler()
	SoraDPlaySound()
	self:showMenu()
end
function chatGroupAudioNode:updatePlayStatus()
	local contentNode = self.contentNode
	contentNode:setPlayStatus(self.data.playStatus)
end
return chatGroupAudioNode
