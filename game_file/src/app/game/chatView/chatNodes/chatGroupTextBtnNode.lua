local chatGroupBaseNode = include("chatGroupBaseNode")
local chatGroupTextBtnNode = class("chatGroupTextBtnNode", function(target)
	local target = chatGroupBaseNode.new("chatGroupTextBtnNode")
	return target
end)
chatGroupTextBtnNode._childConfig = clone(chatGroupBaseNode._childConfig)
_ENV = chatGroupBaseNode._childConfig
chatGroupBaseNode._childConfig.nodeType = gChatNodeType.textBtn
chatGroupBaseNode._childConfig.zorder = 1
chatGroupTextBtnNode._childConfig.contentNode, chatGroupBaseNode._childConfig.alignFunc = chatGroupBaseNode._childConfig, "alignNode_content"
function chatGroupTextBtnNode:ctor()
	self.isDebug = gChatDebug
	self._childConfig = chatGroupTextBtnNode._childConfig
end
function chatGroupTextBtnNode.measureSize(data, target)
	return chatGroupBaseNode.measureSizeWithContent(chatGroupTextBtnNode._childConfig, data, target)
end
return chatGroupTextBtnNode
