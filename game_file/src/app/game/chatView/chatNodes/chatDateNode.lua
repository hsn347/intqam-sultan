local chatDateNode = class("chatDateNode", function(target)
	local target = include("chatBaseNode").new("chatDateNode")
	return target
end)
_ENV = "chatDateNode"
;("chatDateNode").width = 600
;("chatDateNode").height = 90
;("chatDateNode").imgWidth = 180
local ("chatDateNode").imgHeight, _defaultParam = 34, "chatDateNode"
function chatDateNode:ctor()
	self.isDebug = gChatDebug
	self.imgDateBg = display.newSprite("#frame_yjyh_zdbt_01.png")
	self.imgDateBg:setScale(0.8)
	self.imgDateBg:setAnchorPoint(cc.p(1, 0.5))
	self.imgDateBg:setPosition(cc.p(300, 45))
	local anotherImg = self.imgDateBg:clone()
	anotherImg:addTo(self)
	anotherImg:setAnchorPoint(cc.p(0, 0.5))
	anotherImg:setFlippedX(true)
	self.imgDateBg:addTo(self)
	self.text = HtmlRichText:create("", "", 20)
	self.text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.text:setPosition(cc.p(300, 45))
	self.text:addTo(self, 1)
	self.text:setColor(cc.c3b(97, 52, 19))
	self.width = _defaultParam.width
	self.height = _defaultParam.height
	self:setContentSize(cc.size(_defaultParam.width, _defaultParam.height))
end
function chatDateNode:init(data)
	self.data = data
	self.isDebug = data.isDebug
	self.text:setString(data.date)
	self:initDebugView()
end
function chatDateNode.measureSize(data, target)
	return cc.size(_defaultParam.width, _defaultParam.height)
end
function chatDateNode:initDebugView()
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
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 0, 1))
end
function chatDateNode:setIsDebug(isDebug)
	self.isDebug = isDebug
end
return chatDateNode
