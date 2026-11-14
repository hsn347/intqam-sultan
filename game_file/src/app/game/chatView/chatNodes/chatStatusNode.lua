local chatStatusNode = class("chatStatusNode", function(target)
	local target = include("chatBaseNode").new("chatStatusNode")
	return target
end)
_ENV = "chatStatusNode"
;("chatStatusNode").scale_normal = 1.0
;("chatStatusNode").scale_loading = 1.0
;("chatStatusNode").scale_warn = 1.0
;("chatStatusNode").scale_translating = 1.0
;("chatStatusNode").scale_unread = 1.0
;("chatStatusNode").width = 65
local ("chatStatusNode").height, _defaultParam = 65, "chatStatusNode"
function chatStatusNode:ctor()
	self.width = _defaultParam.width
	self.height = _defaultParam.height
	self:setContentSize(cc.size(self.width, self.height))
	self.spriteIcon = display.newSprite("SinglePicture/loading1.png")
	self.spriteIcon:addTo(self)
	self.spriteIcon:setScale(_defaultParam.scale_loading)
	self.spriteIcon:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
	self.readIcon = display.newSprite("#icon_liaotian_dot.png")
	self.readIcon:addTo(self)
	self.readIcon:setScale(_defaultParam.scale_unread)
	self.readIcon:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
	self.readIcon:setColor(cc.c3b(255, 0, 0))
	self.btn = ccui.Button:create()
	self.btn:setSwallowTouches(false)
	self.btn:setTouchEnabled(true)
	self.btn:loadTextures("bg_transparent.png", "bg_transparent.png", "", ccui.TextureResType.plistType)
	self.btn:ignoreContentAdaptWithSize(false)
	self.btn:setContentSize(cc.size(self.width, self.height))
	self.btn:setAnchorPoint(cc.p(0.5, 0.5))
	self.btn:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
	self.btn:setPressedActionEnabled(false)
	self.btn:addTouchEventListener(handler(self, self.btnEvent))
	self:addChild(self.btn, 1)
end
function chatStatusNode:init(data)
	self.isDebug = gChatDebug
	if data.isDebug ~= nil then
		self.isDebug = data.isDebug
	end
	self.data = data
	self.netStatus = self.data.netStatus or gChatNetStatus.normal
	self.nodeStatus = gChatNetStatus2NodeStatus[self.netStatus]
	self.readStatus = self.data.readStatus or gChatReadStatus.normal
	self:initContent(self.data)
	self:initDebugView()
end
function chatStatusNode:setHandle(handle)
	self.handle = handle
end
function chatStatusNode:getHandle()
	return self.handle
end
function chatStatusNode:setNetStaus(netStatus)
	self.netStatus = netStatus or gChatNetStatus.normal
	self.nodeStatus = gChatNetStatus2NodeStatus[self.netStatus]
	self:updateStatus()
end
function chatStatusNode:setReadStatus(readStatus)
	self.readStatus = readStatus
	self:updateReadStatus()
end
function chatStatusNode:initContent(data)
	self:updateStatus()
	self:updateReadStatus()
end
function chatStatusNode:updateStatus()
	local nodeStatus = self.nodeStatus
	local funcName = "initStatus_" .. nodeStatus
	if self[funcName] then
		self[funcName](self)
	end
end
function chatStatusNode:updateReadStatus()
	local readStatus = self.readStatus
	local funcName = "initReadStatus_" .. readStatus
	if self[funcName] then
		self[funcName](self)
	end
end
chatStatusNode["initStatus_" .. gChatNodeStatus.normal] = function(self)
	self.spriteIcon:stopAllActions()
	self.spriteIcon:setRotation(0)
	self.spriteIcon:setVisible(false)
	self.btn:setVisible(false)
end
chatStatusNode["initStatus_" .. gChatNodeStatus.loading] = function(self)
	self.spriteIcon:stopAllActions()
	self.spriteIcon:setRotation(0)
	self.spriteIcon:setSpriteFrame("icon_circle_small.png")
	local actionRotateBy = cc.RotateBy:create(1.0, 360)
	local repeatForever = cca.repeatForever(actionRotateBy)
	self.spriteIcon:runAction(repeatForever)
	self.btn:setVisible(false)
	self.spriteIcon:setVisible(true)
end
chatStatusNode["initStatus_" .. gChatNodeStatus.warning] = function(self)
	self.spriteIcon:stopAllActions()
	self.spriteIcon:setRotation(0)
	self.spriteIcon:setSpriteFrame("icon_warning_small.png")
	self.spriteIcon:setScale(_defaultParam.scale_warn)
	self.btn:setVisible(true)
	self.spriteIcon:setVisible(true)
end
chatStatusNode["initStatus_" .. gChatNodeStatus.translating] = function(self)
	self.spriteIcon:stopAllActions()
	self.spriteIcon:setRotation(0)
	self.spriteIcon:setSpriteFrame("icon_translation_ar.png")
	self.spriteIcon:setScale(_defaultParam.scale_translating)
	self.btn:setVisible(false)
	local _defaultParam, frames = self.btn.setVisible, self.btn.setVisible
	local frame1 = display.newSpriteFrame("icon_translation_ar.png")
	local frame2 = display.newSpriteFrame("icon_translation_en.png")
	table.insert(frames, frame1)
	table.insert(frames, frame2)
	local animation = display.newAnimation(frames, 0.25)
	self.spriteIcon:playAnimationForever(animation)
	self.spriteIcon:setVisible(true)
end
chatStatusNode["initReadStatus_" .. gChatReadStatus.normal] = function(self)
	self.readIcon:setVisible(false)
end
chatStatusNode["initReadStatus_" .. gChatReadStatus.unread] = function(self)
	self.readIcon:setVisible(true)
	if self.data.direction == gChatDirection.right then
		self.readIcon:setPositionX(_defaultParam.width - self.readIcon:getContentSize().width / 2 * _defaultParam.scale_unread)
	else
		self.readIcon:setPositionX(self.readIcon:getContentSize().width / 2 * _defaultParam.scale_unread)
	end
end
function chatStatusNode.measureSize(data, target)
	return cc.size(_defaultParam.width, _defaultParam.height)
end
function chatStatusNode:initDebugView()
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
end
function chatStatusNode:btnEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		print("状态按钮点击回调----")
		if self.handle then
			self.handle()
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return chatStatusNode
