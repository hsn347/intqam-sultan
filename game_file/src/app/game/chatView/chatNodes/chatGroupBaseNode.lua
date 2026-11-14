local chatNodeFactory = include("chatNodeFactory")
local chatGroupBaseNode = class("chatGroupBaseNode", function(target)
	local target = include("chatBaseNode").new("chatGroupBaseNode")
	return target
end)
_ENV = "chatGroupBaseNode"
;("chatGroupBaseNode").paddingContentH = 0
;("chatGroupBaseNode").paddingNameH = 0
;("chatGroupBaseNode").paddingNameT = 20
local _ENV, _ENV, ("chatGroupBaseNode").paddingNameB, _defaultParam = nil, function(target)
	local target = include("chatBaseNode").new("chatGroupBaseNode")
	return target
end, 0, "chatGroupBaseNode"
;(nil).nodeType = gChatNodeType.head
;(nil).zorder = 1
_ENV, (function(target)
	local target = include("chatBaseNode").new("chatGroupBaseNode")
	return target
end).headNode, (nil).alignFunc = nil, nil, "alignNode_head"
;(nil).nodeType = gChatNodeType.name
;(nil).zorder = 1
_ENV, (function(target)
	local target = include("chatBaseNode").new("chatGroupBaseNode")
	return target
end).nameNode, (nil).alignFunc = nil, nil, "alignNode_name"
;(nil).nodeType = gChatNodeType.status
;(nil).zorder = 1
chatGroupBaseNode._childConfig, (function(target)
	local target = include("chatBaseNode").new("chatGroupBaseNode")
	return target
end).statusNode, (nil).alignFunc = function(target)
	local target = include("chatBaseNode").new("chatGroupBaseNode")
	return target
end, nil, "alignNode_status"
function chatGroupBaseNode:ctor()
	self.isClick = true
	self.isLongClick = false
	self.isRichTextClick = false
	self.isClickOnRichText = false
	self.isDebug = gChatDebug
	local _childConfig
	self._childConfig = _childConfig
end
function chatGroupBaseNode:init(data)
	if data.isDebug ~= nil then
		self.isDebug = data.isDebug
	end
	self.data = data
	self:onBeforeInit()
	self:onBeforeInitCustom()
	self:initContent(data)
	self:alignContent()
	self:initDebugView()
	self:onAfterInit()
	self:onAfterInitCustom()
end
function chatGroupBaseNode:setScroll(parentScroll)
	self.scroll = parentScroll
	for k, _ in pairs(self._childConfig) do
		if self[k] and self[k].setScroll then
			self[k]:setScroll(self.scroll)
		end
	end
end
function chatGroupBaseNode:onBeforeInit()
end
function chatGroupBaseNode:onBeforeInitCustom()
end
function chatGroupBaseNode:onAfterInit()
	self:registerClickHandler()
	self:registerLongClickHandler()
	self:registerStatusHandler()
	self:registerRichTextHandler()
end
function chatGroupBaseNode:onAfterInitCustom()
end
function chatGroupBaseNode:registerClickHandler()
	if not self.isClick then
		return
	end
	local contentNode = self.contentNode
	local bubble = contentNode.bubble
	if bubble and not bubble:getClickHandle() then
		bubble:setClickHandle(handler(self, self.onClickHandler))
	end
end
function chatGroupBaseNode:registerLongClickHandler()
	if not self.isLongClick then
		return
	end
	local contentNode = self.contentNode
	local bubble = contentNode.bubble
	if bubble and not bubble:getLongClickHandle() then
		bubble:setLongClickHandle(handler(self, self.onLongClickHandler))
	end
end
function chatGroupBaseNode:registerStatusHandler()
	local statusNode = self.statusNode
	if statusNode and not statusNode:getHandle() then
		statusNode:setHandle(handler(self, self.onStatusClickHandler))
	end
end
function chatGroupBaseNode:registerRichTextHandler()
	if not self.isRichTextClick then
		return
	end
	local contentNode = self.contentNode
	if contentNode and not contentNode:getRichHandle() then
		contentNode:setRichHandle(handler(self, self.onRichEventHandler))
	end
end
function chatGroupBaseNode:onClickHandler()
	SoraDPlaySound()
	self:showMenu()
end
function chatGroupBaseNode:onLongClickHandler()
	SoraDPlaySound()
	print("todo:chatGroupBaseNode:onLongClickHandler")
end
function chatGroupBaseNode:onStatusClickHandler()
	SoraDPlaySound()
	local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
	chatSendMgr:handleNodeStatusClick(self.data)
end
function chatGroupBaseNode:onRichEventHandler()
	SoraDPlaySound()
	print("todo:chatGroupBaseNode:onRichEventHandler")
end
function chatGroupBaseNode:showMenu()
	local chatMenuMgr = gChatMgrs:getMgr("chatMenuMgr")
	local menus, menuData = chatMenuMgr:getMenus(self.data)
	if next(menus) == nil then
		return
	end
	local chatMenu = include("chatMenu")
	local menuNode = chatMenu.new()
	menuNode:show()
	local contentNode = self.contentNode
	local bubble = contentNode.bubble
	local worldPos, alignv = bubble:getMenuWorldPos()
	_ENV = nil
	;(nil).menus = menus
	;(nil).menuData = menuData
	;(nil).worldPos = worldPos
	;(nil).alignv = alignv
	local (nil).customData, data = self.data, nil
	menuNode:init(data)
end
function chatGroupBaseNode:initContent(data)
	self:initChildNodes(data)
	self:onAfterInitContent(data)
end
function chatGroupBaseNode:onAfterInitContent(data)
	local headNode = self.headNode
	local headSize = cc.size(headNode.width, headNode.height)
	headSize.addedH = headNode.addedH
	local nameNode = self.nameNode
	local nameSize = cc.size(nameNode.width, nameNode.height)
	local contentSize = cc.size(0, 0)
	if self.contentNode then
		local contentNode = self.contentNode
		contentSize = cc.size(contentNode.width, contentNode.height)
	end
	local width1 = headSize.width + nameSize.width + _defaultParam.paddingNameH
	local width2 = headSize.width + contentSize.width + _defaultParam.paddingNameB
	local maxWidth = math.max(width1, width2)
	local height = headSize.addedH + nameSize.height + _defaultParam.paddingNameT + _defaultParam.paddingNameB + contentSize.height
	local maxHeight = math.max(headSize.height, height)
	self.width = maxWidth
	self.height = maxHeight
end
function chatGroupBaseNode:initChildNodes(data)
	for name, v in pairs(self._childConfig) do
		if not self[name] then
			self[name] = chatNodeFactory.createNode(v.nodeType)
			if self[name].setScroll and self.scroll then
				self[name]:setScroll(self.scroll)
			end
			self[name]:addTo(self, v.zorder or 1)
			self[name]:init(data)
			local onCreateFunc = "onCreate_" .. name
			if self[onCreateFunc] then
				self[onCreateFunc](self, self[name])
			end
		else
			self[name]:init(data)
		end
	end
end
function chatGroupBaseNode:alignContent()
	for k, v in pairs(self._childConfig) do
		if self[k] then
			local alignFunc = self[v.alignFunc]
			alignFunc(self, self[k])
		end
	end
end
function chatGroupBaseNode:alignNode_name(node)
	local headNode = self.headNode
	local deltaY = 0
	local headSize = cc.size(0, 0)
	if headNode then
		deltaY = headNode.addedH
		headSize = cc.size(headNode.width, headNode.height)
	end
	local posy = self.height - deltaY - node.height - _defaultParam.paddingNameT
	node:setPositionY(posy)
	if self.data.direction == gChatDirection.right then
		local posx = self.width - headSize.width - node.width - _defaultParam.paddingNameH
		node:setPositionX(posx)
	else
		local posx = headSize.width + _defaultParam.paddingNameH
		node:setPositionX(posx)
	end
end
function chatGroupBaseNode:alignNode_head(node)
	node:setPositionY(self.height - node.height)
	if self.data.direction == gChatDirection.right then
		node:setPositionX(self.width - node.width)
	else
		node:setPositionX(0)
	end
end
function chatGroupBaseNode:alignNode_content(node)
	local headNode = self.headNode
	local nameNode = self.nameNode
	local headSize = cc.size(headNode.width, headNode.height)
	local nameSize = cc.size(nameNode.width, nameNode.height)
	local nodeSize = cc.size(node.width, node.height)
	node:setPositionY(self.height - headNode.addedH - nameSize.height - _defaultParam.paddingNameT - _defaultParam.paddingNameB - nodeSize.height)
	if self.data.direction == gChatDirection.right then
		node:setPositionX(self.width - headSize.width - node.width - _defaultParam.paddingContentH)
	else
		node:setPositionX(headSize.width + _defaultParam.paddingContentH)
	end
end
function chatGroupBaseNode:alignNode_status(node)
	local headNode = self.headNode
	local contentNode = self.contentNode
	local nameNode = self.nameNode
	local headSize = cc.size(headNode.width, headNode.height)
	local nameSize = cc.size(nameNode.width, nameNode.height)
	if self.data.direction == gChatDirection.right then
		node:setPositionX(self.width - headSize.width - contentNode.width - _defaultParam.paddingContentH - node.width)
	else
		node:setPositionX(headSize.width + _defaultParam.paddingContentH + contentNode.width)
	end
	node:setPositionY(self.height - headNode.addedH - nameSize.height - _defaultParam.paddingNameT - _defaultParam.paddingNameB - contentNode.height / 2 - node.height / 2)
end
function chatGroupBaseNode:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
	end
	self._debugNode:clear()
	local lb = cc.p(0, 0)
	local lt = cc.p(0, self.height)
	local rt = cc.p(self.width, self.height)
	local rb = cc.p(self.width, 0)
	_UPVALUE4_ = self.width
	self.width[1] = lb
	self.width[2] = lt
	self.width[3] = rt
	local self.width[4], tbPoints = rb, self.width
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 1, 1))
	if not self.debugText then
		self.debugText = HtmlRichText:create("", "", 20)
		self.debugText:setIsHtml(false)
		self.debugText:addTo(self, 1)
		self.debugText:setTextColor(cc.c3b(255, 0, 0))
		local str = self:getDebugInfo()
		self.debugText:setString(str)
		self.debugText:setAnchorPoint(cc.p(0.5, 0.5))
	else
		local str = self:getDebugInfo()
		self.debugText:setString(str)
	end
	if self.data.direction == gChatDirection.left then
		self.debugText:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
		self.debugText:setPosition(cc.p(self.width + self.debugText:getContentSize().width / 2, self.height / 2))
	else
		self.debugText:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.debugText:setPosition(cc.p(-self.debugText:getContentSize().width / 2, self.height / 2))
	end
end
function chatGroupBaseNode:getDebugInfo()
	local str = string.format([[
chatId:%d,
type:%d
dir:%d
bubbleId:%d,%d,%d
a,hId:%d,%d
]], self.data.chatId or 0, self.data.nodeType, self.data.direction, self.data.bubbleId or 0, self.data.showBubbleId or 0, self.data.oriBubbleId or 0, self.data.avatarFrameId or 0, self.data.headWearId or 0)
	return str
end
function chatGroupBaseNode.measureSize(data, target)
	return chatGroupBaseNode.measureSizeWithContent(chatGroupBaseNode._childConfig, data, target)
end
function chatGroupBaseNode.measureNodeSize(nodeConfig, nodeName, data, target)
	local cfg = nodeConfig[nodeName]
	local nodeClass = include(chatNodeFactory.getClass(cfg.nodeType))
	local nodeSize = nodeClass.measureSize(data, target)
	return nodeSize
end
function chatGroupBaseNode.measureSizeWithContent(nodeConfig, data, target)
	local headSize = chatGroupBaseNode.measureNodeSize(nodeConfig, "headNode", data, target)
	local nameSize = chatGroupBaseNode.measureNodeSize(nodeConfig, "nameNode", data, target)
	local contentSize = chatGroupBaseNode.measureNodeSize(nodeConfig, "contentNode", data, target)
	local width1 = headSize.width + nameSize.width + _defaultParam.paddingNameH
	local width2 = headSize.width + contentSize.width + _defaultParam.paddingContentH
	local maxWidth = math.max(width1, width2)
	local height = headSize.addedH + nameSize.height + _defaultParam.paddingNameT + _defaultParam.paddingNameB + contentSize.height
	local maxHeight = math.max(headSize.height, height)
	return cc.size(maxWidth, maxHeight)
end
function chatGroupBaseNode:reInit(ignoreUpdateScroll)
	self.data.itemWidth = 0
	self.data.itemHeight = 0
	self.data.contentSize = nil
	self.data.textContentSize = nil
	self.data.bottomTipSize = nil
	self.data.topSize = nil
	self.data.topTextSize = nil
	self.data.bottomSize = nil
	local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	if chatDataMgr and chatDataMgr.resetMetaInfo then
		chatDataMgr:resetMetaInfo(self.data)
	end
	self:init(self.data)
	self.data.itemWidth = self.width
	self.data.itemHeight = self.height
	local chatChannel = self.data.chatChannel
	local chatSet = self.data.chatSet
	local key = self.data.key
	if not ignoreUpdateScroll then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		;(nil).chatChannel = chatChannel
		;(nil).chatSet = chatSet
		;(nil).key = key
		SoraDSendMessage(nil)
	end
end
function chatGroupBaseNode:updateNetStatus()
	local statusNode = self.statusNode
	statusNode:setNetStaus(self.data.netStatus)
end
function chatGroupBaseNode:updateReadStatus()
	local statusNode = self.statusNode
	statusNode:setReadStatus(self.data.readStatus)
end
function chatGroupBaseNode:onNotifyFileDownloaded(file, fileType)
	local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	chatDataMgr:resetMetaInfo(self.data)
	self.data.itemWidth = 0
	self.data.itemHeight = 0
	self.data.contentSize = nil
	self.data.bottomTipSize = nil
	self.data.markDirty = true
end
function chatGroupBaseNode:onNotifyKeyFileDownloaded(file, fileType)
	local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	chatDataMgr:resetMetaInfo(self.data)
	self.data.itemWidth = 0
	self.data.itemHeight = 0
	self.data.contentSize = nil
	self.data.bottomTipSize = nil
	self.data.markDirty = true
end
function chatGroupBaseNode:onThemeUpdate()
	for k, v in pairs(self._childConfig) do
		if self[k] then
			local node = self[k]
			if node.onThemeUpdate then
				node:onThemeUpdate()
			end
		end
	end
end
return chatGroupBaseNode
