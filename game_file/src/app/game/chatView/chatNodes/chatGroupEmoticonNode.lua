local chatGroupBaseNode = include("chatGroupBaseNode")
local chatGroupTextNode = include("chatGroupTextNode")
local chatGroupEmoticonNode = class("chatGroupEmoticonNode", function(target)
	local target = chatGroupBaseNode.new("chatGroupEmoticonNode")
	return target
end)
chatGroupEmoticonNode._childConfig = clone(chatGroupBaseNode._childConfig)
_ENV = chatGroupBaseNode._childConfig
chatGroupBaseNode._childConfig.nodeType = gChatNodeType.emoticon
chatGroupBaseNode._childConfig.zorder = 1
chatGroupEmoticonNode._childConfig.contentNode, chatGroupBaseNode._childConfig.alignFunc = chatGroupBaseNode._childConfig, "alignNode_content"
function chatGroupEmoticonNode:ctor()
	self.isDebug = gChatDebug
	self.isRichTextClick = true
	self._childConfig = chatGroupEmoticonNode._childConfig
end
function chatGroupEmoticonNode:onRichEventHandler(target, event)
	chatGroupTextNode.onRichEventHandler(self, target, event)
end
function chatGroupEmoticonNode:onRichClickHandler(richText, metaInfo)
	return chatGroupTextNode.onRichClickHandler(self, richText, metaInfo)
end
function chatGroupEmoticonNode:onRichLink(richText, metaInfo)
	return chatGroupTextNode.onRichLink(self, richText, metaInfo)
end
function chatGroupEmoticonNode.measureSize(data, target)
	return chatGroupBaseNode.measureSizeWithContent(chatGroupEmoticonNode._childConfig, data, target)
end
return chatGroupEmoticonNode
