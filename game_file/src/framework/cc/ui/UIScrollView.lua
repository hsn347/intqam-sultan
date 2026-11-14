local UIScrollView = class("UIScrollView", function()
	return cc.Node:create()
end)
UIScrollView.BG_ZORDER = -100
UIScrollView.TOUCH_ZORDER = -99
UIScrollView.DIRECTION_BOTH = 0
UIScrollView.DIRECTION_VERTICAL = 1
UIScrollView.DIRECTION_HORIZONTAL = 2
function UIScrollView:ctor(params)
	self.bBounce = true
	self.nShakeVal = 5
	UIScrollView, self.direction = UIScrollView.DIRECTION_BOTH, UIScrollView.DIRECTION_BOTH
	UIScrollView.DIRECTION_BOTH.left = 0
	UIScrollView.DIRECTION_BOTH.right = 0
	UIScrollView.DIRECTION_BOTH.top = 0
	UIScrollView, self.layoutPadding, UIScrollView.DIRECTION_BOTH.bottom = UIScrollView.DIRECTION_BOTH, UIScrollView.DIRECTION_BOTH, 0
	UIScrollView.DIRECTION_BOTH.x = 0
	self.speed, UIScrollView.DIRECTION_BOTH.y = UIScrollView.DIRECTION_BOTH, 0
	self.prevX_ = 0
	self.prevY_ = 0
	if not params then
		return
	end
	if params.viewRect then
		self:setViewRect(params.viewRect)
	end
	if params.direction then
		self:setDirection(params.direction)
	end
	if params.scrollbarImgH then
		self.sbH = display.newScale9Sprite(params.scrollbarImgH, 100):addTo(self)
	end
	if params.scrollbarImgV then
		self.sbV = display.newScale9Sprite(params.scrollbarImgV, 100):addTo(self)
	end
	self:setTouchType(params.touchOnContent or true)
	self:addBgColorIf(params)
	self:addBgGradientColorIf(params)
	self:addBgIf(params)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
		self:update_(...)
	end)
	self:scheduleUpdate()
end
function UIScrollView:addBgColorIf(params)
	if not params.bgColor then
		return
	end
	cc.LayerColor:create(params.bgColor):ssize(params.viewRect.width, params.viewRect.height):spos(params.viewRect.x, params.viewRect.y):addTo(self, UIScrollView.BG_ZORDER):setTouchEnabled(false)
end
function UIScrollView:addBgGradientColorIf(params)
	if not params.bgStartColor or not params.bgEndColor then
		return
	end
	local layer = cc.LayerGradient:create(params.bgStartColor, params.bgEndColor):ssize(params.viewRect.width, params.viewRect.height):spos(params.viewRect.x, params.viewRect.y):addTo(self, UIScrollView.BG_ZORDER):setTouchEnabled(false)
	layer:setVector(params.bgVector)
end
function UIScrollView:addBgIf(params)
	if not params.bg then
		return
	end
	local bg
	if params.bgScale9 then
		bg = display.newScale9Sprite(params.bg, nil, nil, nil, params.capInsets)
	else
		bg = display.newSprite(params.bg)
	end
	bg:ssize(params.viewRect.width, params.viewRect.height):spos(params.viewRect.x + params.viewRect.width / 2, params.viewRect.y + params.viewRect.height / 2):addTo(self, UIScrollView.BG_ZORDER):setTouchEnabled(false)
end
function UIScrollView:setViewRect(rect)
	self.viewRect_ = rect
	self.viewRectIsNodeSpace = false
	return self
end
function UIScrollView:getViewRect()
	return self.viewRect_
end
function UIScrollView:setLayoutPadding(top, right, bottom, left)
	if not self.layoutPadding then
		self.layoutPadding, _UPVALUE0_ = self.layoutPadding, self.layoutPadding
	end
	self.layoutPadding.top = top
	self.layoutPadding.right = right
	self.layoutPadding.bottom = bottom
	self.layoutPadding.left = left
	return self
end
function UIScrollView:setActualRect(rect)
	self.actualRect_ = rect
end
function UIScrollView:setDirection(dir)
	self.direction = dir
	return self
end
function UIScrollView:getDirection()
	return self.direction
end
function UIScrollView:setBounceable(bBounceable)
	self.bBounce = bBounceable
	return self
end
function UIScrollView:setTouchType(bTouchOnContent)
	self.touchOnContent = bTouchOnContent
	return self
end
function UIScrollView:resetPosition()
	if UIScrollView.DIRECTION_VERTICAL ~= self.direction then
		return
	end
	local x, y = self.scrollNode:getPosition()
	local bound = self.scrollNode:getCascadeBoundingBox()
	local disY = self.viewRect_.y + self.viewRect_.height - bound.y - bound.height
	y = y + disY
	self.scrollNode:setPosition(x, y)
end
function UIScrollView:isItemInViewRect(item)
	if "userdata" ~= type(item) then
		item = nil
	end
	if not item then
		print("UIScrollView - isItemInViewRect item is not right")
		return
	end
	local bound = item:getCascadeBoundingBox()
	return cc.rectIntersectsRect(self:getViewRectInWorldSpace(), bound)
end
function UIScrollView:setTouchEnabled(bEnabled)
	if not self.scrollNode then
		return
	end
	self.scrollNode:setTouchEnabled(bEnabled)
	return self
end
function UIScrollView:addScrollNode(node)
	self:addChild(node)
	self.scrollNode = node
	if not self.viewRect_ then
		self.viewRect_ = self.scrollNode:getCascadeBoundingBox()
		self:setViewRect(self.viewRect_)
	end
	node:setTouchSwallowEnabled(false)
	node:setTouchEnabled(true)
	node:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
		return self:onTouchCapture_(event)
	end)
	self:addTouchNode()
	return self
end
function UIScrollView:getScrollNode()
	return self.scrollNode
end
function UIScrollView:onScroll(listener)
	self.scrollListener_ = listener
	return self
end
function UIScrollView:calcLayoutPadding()
	local boundBox = self.scrollNode:getCascadeBoundingBox()
	self.layoutPadding.left = boundBox.x - self.actualRect_.x
	self.layoutPadding.right = self.actualRect_.x + self.actualRect_.width - boundBox.x - boundBox.width
	self.layoutPadding.top = boundBox.y - self.actualRect_.y
	self.layoutPadding.bottom = self.actualRect_.y + self.actualRect_.height - boundBox.y - boundBox.height
end
function UIScrollView:update_(dt)
	self:drawScrollBar()
end
function UIScrollView:onTouchCapture_(event)
	if ("began" == event.name or "moved" == event.name or "ended" == event.name) and self:isTouchInViewRect(event) then
		return true
	else
		return false
	end
end
function UIScrollView:onTouch_(event)
	if "began" == event.name and not self:isTouchInViewRect(event) then
		printInfo("UIScrollView - touch didn't in viewRect")
		return false
	end
	if "began" == event.name and self.touchOnContent then
		local cascadeBound = self.scrollNode:getCascadeBoundingBox()
		if not cc.rectContainsPoint(cascadeBound, cc.p(event.x, event.y)) then
			return false
		end
	end
	if "began" == event.name then
		self.prevX_ = event.x
		self.prevY_ = event.y
		self.bDrag_ = false
		local x, y = self.scrollNode:getPosition()
		_ENV = cascadeBound
		cascadeBound.x = x
		self.position_, cascadeBound.y = cascadeBound, y
		transition.stopTarget(self.scrollNode)
		_ENV = cc.p(event.x, event.y)
		cc.p(event.x, event.y).name = "began"
		cc.p(event.x, event.y).x = event.x
		cc.p(event.x, event.y).y = event.y
		self:callListener_(cc.p(event.x, event.y))
		self:enableScrollBar()
		self.scaleToWorldSpace_ = self:scaleToParent_()
		return true
	elseif "moved" == event.name then
		if self:isShake(event) then
			return
		end
		self.bDrag_ = true
		self.speed.x = event.x - event.prevX
		self.speed.y = event.y - event.prevY
		if self.direction == UIScrollView.DIRECTION_VERTICAL then
			self.speed.x = 0
		else
			if self.direction == UIScrollView.DIRECTION_HORIZONTAL then
				self.speed.y = 0
			else
			end
		end
		self:scrollBy(self.speed.x, self.speed.y)
		_ENV = self.speed.x
		self.speed.x.name = "moved"
		self.speed.x.x = event.x
		self.speed.x.y = event.y
		self:callListener_(self.speed.x)
	elseif "ended" == event.name then
		if self.bDrag_ then
			self.bDrag_ = false
			self:scrollAuto()
			_ENV = self.speed.x
			self.speed.x.name = "ended"
			self.speed.x.x = event.x
			self.speed.x.y = event.y
			self:callListener_(self.speed.x)
			self:disableScrollBar()
		else
			_ENV = self.speed.x
			self.speed.x.name = "clicked"
			self.speed.x.x = event.x
			self.speed.x.y = event.y
			self:callListener_(self.speed.x)
		end
	end
end
function UIScrollView:isTouchInViewRect(event)
	local viewRect = self:convertToWorldSpace(cc.p(self.viewRect_.x, self.viewRect_.y))
	_ENV = self
	self.x = viewRect.x
	self.y = viewRect.y
	self.width = self.viewRect_.width
	viewRect, self.height = self, self.viewRect_.height
	return cc.rectContainsPoint(viewRect, cc.p(event.x, event.y))
end
function UIScrollView:isTouchInScrollNode(event)
	local cascadeBound = self:getScrollNodeRect()
	return cc.rectContainsPoint(cascadeBound, cc.p(event.x, event.y))
end
function UIScrollView:scrollTo(p, y)
	local x_, y_
	if "table" == type(p) then
		x_ = p.x or 0
		y_ = p.y or 0
	else
		x_ = p
		y_ = y
	end
	self.position_ = cc.p(x_, y_)
	self.scrollNode:setPosition(self.position_)
end
function UIScrollView:moveXY(orgX, orgY, speedX, speedY)
	if self.bBounce then
		return orgX + speedX, orgY + speedY
	end
	local cascadeBound = self:getScrollNodeRect()
	local viewRect = self:getViewRectInWorldSpace()
	local x, y = orgX, orgY
	local disX, disY
	if 0 < speedX then
		if cascadeBound.x < viewRect.x then
			disX = viewRect.x - cascadeBound.x
			disX = disX / self.scaleToWorldSpace_.x
			x = orgX + math.min(disX, speedX)
		end
	elseif cascadeBound.x + cascadeBound.width > viewRect.x + viewRect.width then
		disX = viewRect.x + viewRect.width - cascadeBound.x - cascadeBound.width
		disX = disX / self.scaleToWorldSpace_.x
		x = orgX + math.max(disX, speedX)
	end
	if 0 < speedY then
		if cascadeBound.y < viewRect.y then
			disY = viewRect.y - cascadeBound.y
			disY = disY / self.scaleToWorldSpace_.y
			y = orgY + math.min(disY, speedY)
		end
	elseif cascadeBound.y + cascadeBound.height > viewRect.y + viewRect.height then
		disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
		disY = disY / self.scaleToWorldSpace_.y
		y = orgY + math.max(disY, speedY)
	end
	return x, y
end
function UIScrollView:scrollBy(x, y)
	self.position_.x, self.position_.y = self:moveXY(self.position_.x, self.position_.y, x, y)
	self.scrollNode:setPosition(self.position_)
	if self.actualRect_ then
		self.actualRect_.x = self.actualRect_.x + x
		self.actualRect_.y = self.actualRect_.y + y
	end
end
function UIScrollView:scrollAuto()
	if self:twiningScroll() then
		return
	end
	self:elasticScroll()
end
function UIScrollView:twiningScroll()
	if self:isSideShow() then
		return false
	end
	if math.abs(self.speed.x) < 10 and 10 > math.abs(self.speed.y) then
		return false
	end
	local disX, disY = self:moveXY(0, 0, self.speed.x * 6, self.speed.y * 6)
	_ENV = self.speed.x * 6
	;(self.speed.x * 6).x = disX
	;(self.speed.x * 6).y = disY
	;(self.speed.x * 6).time = 0.3
	;(self.speed.x * 6).easing = "sineOut"
	;(self.speed.x * 6).onComplete = function()
		self:elasticScroll()
	end
	transition.moveBy(self.scrollNode, self.speed.x * 6)
end
function UIScrollView:elasticScroll()
	local cascadeBound = self:getScrollNodeRect()
	local disX, disY = 0, 0
	local viewRect = self:getViewRectInWorldSpace()
	if cascadeBound.width < viewRect.width then
		disX = viewRect.x - cascadeBound.x
	elseif cascadeBound.x > viewRect.x then
		disX = viewRect.x - cascadeBound.x
	elseif cascadeBound.x + cascadeBound.width < viewRect.x + viewRect.width then
		disX = viewRect.x + viewRect.width - cascadeBound.x - cascadeBound.width
	end
	if cascadeBound.height < viewRect.height then
		disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
	elseif cascadeBound.y > viewRect.y then
		disY = viewRect.y - cascadeBound.y
	elseif cascadeBound.y + cascadeBound.height < viewRect.y + viewRect.height then
		disY = viewRect.y + viewRect.height - cascadeBound.y - cascadeBound.height
	end
	if 0 == disX and 0 == disY then
		return
	end
	_ENV = viewRect.height
	viewRect.height.x = disX
	viewRect.height.y = disY
	viewRect.height.time = 0.3
	viewRect.height.easing = "backout"
	function viewRect.height.onComplete()
		self = nil
		;(nil).name = "scrollEnd"
		self:callListener_(nil)
	end
	transition.moveBy(self.scrollNode, viewRect.height)
end
function UIScrollView:getScrollNodeRect()
	local bound = self.scrollNode:getCascadeBoundingBox()
	return bound
end
function UIScrollView:getViewRectInWorldSpace()
	local rect = self:convertToWorldSpace(cc.p(self.viewRect_.x, self.viewRect_.y))
	_ENV = self
	self.x = rect.x
	self.y = rect.y
	self.width = self.viewRect_.width
	self.height = self.viewRect_.height
	return self
end
function UIScrollView:isSideShow()
	local bound = self.scrollNode:getCascadeBoundingBox()
	if bound.x > self.viewRect_.x or bound.y > self.viewRect_.y or bound.x + bound.width < self.viewRect_.x + self.viewRect_.width or bound.y + bound.height < self.viewRect_.y + self.viewRect_.height then
		return true
	end
	return false
end
function UIScrollView:callListener_(event)
	if not self.scrollListener_ then
		return
	end
	event.scrollView = self
	self.scrollListener_(event)
end
function UIScrollView:enableScrollBar()
	local bound = self.scrollNode:getCascadeBoundingBox()
	if self.sbV then
		self.sbV:setVisible(false)
		transition.stopTarget(self.sbV)
		self.sbV:setOpacity(128)
		local size = self.sbV:getContentSize()
		if self.viewRect_.height < bound.height then
			local barH = self.viewRect_.height * self.viewRect_.height / bound.height
			if barH < size.width then
				barH = size.width
			end
			self.sbV:setContentSize(size.width, barH)
			self.sbV:setPosition(self.viewRect_.x + self.viewRect_.width - size.width / 2, self.viewRect_.y + barH / 2)
		end
	end
	if self.sbH then
		self.sbH:setVisible(false)
		transition.stopTarget(self.sbH)
		self.sbH:setOpacity(128)
		local size = self.sbH:getContentSize()
		if self.viewRect_.width < bound.width then
			local barW = self.viewRect_.width * self.viewRect_.width / bound.width
			if barW < size.height then
				barW = size.height
			end
			self.sbH:setContentSize(barW, size.height)
			self.sbH:setPosition(self.viewRect_.x + barW / 2, self.viewRect_.y + size.height / 2)
		end
	end
end
function UIScrollView:disableScrollBar()
	if self.sbV then
		_ENV = nil
		;(nil).time = 0.3
		;(nil).onComplete = function()
			self.sbV:setOpacity(128)
			self.sbV:setVisible(false)
		end
		transition.fadeOut(self.sbV, nil)
	end
	if self.sbH then
		_ENV = nil
		;(nil).time = 1.5
		;(nil).onComplete = function()
			self.sbH:setOpacity(128)
			self.sbH:setVisible(false)
		end
		transition.fadeOut(self.sbH, nil)
	end
end
function UIScrollView:drawScrollBar()
	if not self.bDrag_ then
		return
	end
	if not self.sbV and not self.sbH then
		return
	end
	local bound = self.scrollNode:getCascadeBoundingBox()
	if self.sbV then
		self.sbV:setVisible(true)
		local size = self.sbV:getContentSize()
		local posY = (self.viewRect_.y - bound.y) * (self.viewRect_.height - size.height) / (bound.height - self.viewRect_.height) + self.viewRect_.y + size.height / 2
		local x, y = self.sbV:getPosition()
		self.sbV:setPosition(x, posY)
	end
	if self.sbH then
		self.sbH:setVisible(true)
		local size = self.sbH:getContentSize()
		local posX = (self.viewRect_.x - bound.x) * (self.viewRect_.width - size.width) / (bound.width - self.viewRect_.width) + self.viewRect_.x + size.width / 2
		local x, y = self.sbH:getPosition()
		self.sbH:setPosition(posX, y)
	end
end
function UIScrollView:addScrollBarIf()
	if not self.sb then
		self.sb = cc.DrawNode:create():addTo(self)
	end
	drawNode = cc.DrawNode:create()
	drawNode:drawSegment(points[1], points[2], radius, borderColor)
end
function UIScrollView:changeViewRectToNodeSpaceIf()
	if self.viewRectIsNodeSpace then
		return
	end
	local posX, posY = self:getPosition()
	local ws = self:convertToWorldSpace(cc.p(posX, posY))
	self.viewRect_.x = self.viewRect_.x + ws.x
	self.viewRect_.y = self.viewRect_.y + ws.y
	self.viewRectIsNodeSpace = true
end
function UIScrollView:isShake(event)
	if math.abs(event.x - self.prevX_) < self.nShakeVal and math.abs(event.y - self.prevY_) < self.nShakeVal then
		return true
	end
end
function UIScrollView:scaleToParent_()
	local parent
	local node = self
	_UPVALUE0_ = nil
	;(nil).x = 1
	local (nil).y, scale = 1, nil
	while true do
		scale.x = scale.x * node:getScaleX()
		scale.y = scale.y * node:getScaleY()
		parent = node:getParent()
		if not parent then
			break
		end
		node = parent
	end
	return scale
end
function UIScrollView:addTouchNode()
	local node
	if self.touchNode_ then
		node = self.touchNode_
	else
		node = display.newNode()
		self.touchNode_ = node
		node:setLocalZOrder(UIScrollView.TOUCH_ZORDER)
		node:setTouchSwallowEnabled(true)
		node:setTouchEnabled(true)
		node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
			return self:onTouch_(event)
		end)
		self:addChild(node)
	end
	node:setContentSize(self.viewRect_.width, self.viewRect_.height)
	node:setPosition(self.viewRect_.x, self.viewRect_.y)
	return self
end
function UIScrollView:fill(nodes, params)
	local extend = function(param1, param2)
		if not param2 then
			return param1
		end
		for k, v in pairs(param2) do
			param1[k] = param2[k]
		end
		return param1
	end
	_ENV = nil
	;(nil).autoGap = true
	;(nil).widthGap = 0
	;(nil).heightGap = 0
	;(nil).autoTable = true
	;(nil).rowCount = 3
	;(nil).cellCount = 3
	;(nil).itemSize = cc.size(50, 50)
	local params = extend(nil, params)
	if #nodes == 0 then
		return nil
	end
	local SIZE = function(node)
		return node:getContentSize()
	end
	local W = function(node)
		return node:getContentSize().width
	end
	local H = function(node)
		return node:getContentSize().height
	end
	local S_SIZE = function(node, w, h)
		return node:setContentSize(cc.size(w, h))
	end
	local S_XY = function(node, x, y)
		node:setPosition(x, y)
	end
	local AX = function(node)
		return node:getAnchorPoint().x
	end
	local AY = function(node)
		return node:getAnchorPoint().y
	end
	local innerContainer = display.newNode()
	S_SIZE(innerContainer, self:getViewRect().width, self:getViewRect().height)
	self:addScrollNode(innerContainer)
	S_XY(innerContainer, self.viewRect_.x, self.viewRect_.y)
	if self.direction == cc.ui.UIScrollView.DIRECTION_VERTICAL then
		if params.autoTable then
			params.cellCount = math.floor(self.viewRect_.width / params.itemSize.width)
		end
		if params.autoGap then
			params.widthGap = (self.viewRect_.width - params.cellCount * params.itemSize.width) / (params.cellCount + 1)
			params.heightGap = params.widthGap
		end
		params.rowCount = math.ceil(#nodes / params.cellCount)
		local v_h = (params.itemSize.height + params.heightGap) * params.rowCount + params.heightGap
		if v_h < self.viewRect_.height then
			v_h = self.viewRect_.height
		end
		S_SIZE(innerContainer, self.viewRect_.width, v_h)
		for i = 1, #nodes do
			local n = nodes[i]
			local x = 0.0
			local y = 0.0
			x = params.widthGap + math.floor((i - 1) % params.cellCount) * (params.widthGap + params.itemSize.width)
			y = H(innerContainer) - (math.floor((i - 1) / params.cellCount) + 1) * (params.heightGap + params.itemSize.height)
			x = x + W(n) * AX(n)
			y = y + H(n) * AY(n)
			S_XY(n, x, y)
			n:addTo(innerContainer)
		end
	else
		if params.autoTable then
			params.rowCount = math.floor(self.viewRect_.height / params.itemSize.height)
		end
		if params.autoGap then
			params.heightGap = (self.viewRect_.height - params.rowCount * params.itemSize.height) / (params.rowCount + 1)
			params.widthGap = params.heightGap
		end
		params.cellCount = math.ceil(#nodes / params.rowCount)
		local v_w = (params.itemSize.width + params.widthGap) * params.cellCount + params.widthGap
		if v_w < self.viewRect_.width then
			v_h = self.viewRect_.width
		end
		S_SIZE(innerContainer, v_w, self.viewRect_.height)
		for i = 1, #nodes do
			local n = nodes[i]
			local x = 0.0
			local y = 0.0
			x = params.widthGap + math.floor((i - 1) / params.rowCount) * (params.widthGap + params.itemSize.width)
			y = H(innerContainer) - (math.floor((i - 1) % params.rowCount) + 1) * (params.heightGap + params.itemSize.height)
			x = x + W(n) * AX(n)
			y = y + H(n) * AY(n)
			S_XY(n, x, y)
			n:addTo(innerContainer)
		end
	end
end
return UIScrollView
