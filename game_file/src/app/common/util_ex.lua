if not util then
	_ENV = util
end
util = util
local TAG = "[fw.util_ex]"
local type = type
local ipairs = ipairs
local pairs = pairs
local string_find = string.find
local string_sub = string.sub
local string_format = string.format
local c = cc
local display = display
local device = device
local sharedTextureCache = c.Director:getInstance():getTextureCache()
function display.resetConfig()
	if "FIXED_WIDTH" == CONFIG_SCREEN_AUTOSCALE and (DISPLAY_CONFIG_SCREEN_WIDTH or DISPLAY_CONFIG_SCREEN_HEIGHT) then
		_ENV = DISPLAY_CONFIG_SCREEN_HEIGHT
		DISPLAY_CONFIG_SCREEN_HEIGHT.width = DISPLAY_CONFIG_SCREEN_WIDTH or display.width
		display.size, DISPLAY_CONFIG_SCREEN_HEIGHT.height = DISPLAY_CONFIG_SCREEN_HEIGHT, DISPLAY_CONFIG_SCREEN_HEIGHT or display.height
		display.width = display.size.width
		display.height = display.size.height
		display.cx = display.width / 2
		display.c_left = -display.width / 2
		display.c_right = display.width / 2
		display.c_top = display.height / 2
		display.c_bottom = -display.height / 2
		display.left = 0
		display.right = display.width
		display.top = display.height
		display.bottom = (CONFIG_SCREEN_HEIGHT - display.height) / 2
	end
end
function isandroid()
	return device.platform == "android"
end
local isandroid = isandroid
function isios()
	return device.platform == "ios"
end
function isuserdate(v)
	return type(v) == "userdata"
end
local isuserdate = isuserdate
function CCSizeAdd(size, width, height)
	return c.size(size.width + width, size.height + height)
end
function CCSizeMul(size, width, height)
	return c.size(size.width * width, size.height * height)
end
function util.setDesignResolutionSize(width, height, mode)
	c.Director:getInstance():getOpenGLView():setDesignResolutionSize(width, height, mode or kResolutionShowAll)
end
display.setDesignResolutionSize = util.setDesignResolutionSize
function util.isPointInRect(rect, x, y)
	local point
	if isnumber(x) then
		point = c.p(x, y)
	else
		point = x
	end
	return c.rectContainsPoint(rect, point)
end
util.rectContainsPoint = util.isPointInRect
function util.isPointInNode(node, x, y)
	local point
	if isnumber(x) then
		point = c.p(x, y)
	else
		point = x
	end
	point = node:convertToNodeSpace(point)
	local boundingBox = node:getBoundingBox()
	boundingBox.x = 0
	boundingBox.y = 0
	return c.rectContainsPoint(boundingBox, point)
end
function util.quadContainsPointGL(left, top, right, bottom, point)
	local value = 1
	if point.x >= top.x and point.y <= right.y then
		value = (right.x - point.x) * (top.y - point.y) - (right.y - point.y) * (top.x - point.x)
	elseif point.x < top.x and point.y < left.y then
		value = (top.x - point.x) * (left.y - point.y) - (top.y - point.y) * (left.x - point.x)
	elseif point.x <= bottom.x and point.y >= left.y then
		value = (left.x - point.x) * (bottom.y - point.y) - (left.y - point.y) * (bottom.x - point.x)
	elseif point.x > bottom.x and point.y > right.y then
		value = (bottom.x - point.x) * (right.y - point.y) - (bottom.y - point.y) * (right.x - point.x)
	end
	if value <= 0 then
		return true
	end
	return false
end
function util.centerNode(node)
	if node then
		local size = node:getContentSize()
		return size.width / 2, size.height / 2
	end
	return 0, 0
end
function util.addTextureCache(fileName)
	return sharedTextureCache:addImage(fileName)
end
function util.delayCall(fn, time)
	if time == 0 then
		fn()
		return nil
	else
		return scheduler.performWithDelayGlobal(fn, time or 0.5)
	end
end
function util.delayCallWithArgs(time, fn, ...)
	return scheduler.performWithDelayGlobal(util.callFun(fn, ...), time or 0.5)
end
function util.isNParentVisible(node)
	Log.a(node, TAG, "isNParentVisible() invalid node")
	local result = true
	while node do
		result = node:isVisible()
		if not result then
			return false
		end
		node = node:getParent()
		goto lbl_22
		do break end
		::lbl_22::
	end
	return result
end
function util.alignNode(node, size, anchor, offsetx, offsety)
	Log.a(node, TAG, "alignNode() invalid params: node")
	Log.a(size, TAG, "alignNode() invalid params: size")
	local x, y
	if size.getContentSize then
		size = size:getContentSize()
	end
	local w, h = size.width, size.height
	anchor = anchor or display.CENTER
	offsetx = offsetx or 0
	if anchor == display.CENTER then
		x, y = w / 2 + offsetx, h / 2 + (offsety or 0)
	elseif anchor == display.TOP_LEFT then
		x, y = offsetx, h + (offsety or -offsetx)
	elseif anchor == display.CENTER_LEFT then
		x, y = offsetx, h / 2 + (offsety or 0)
	elseif anchor == display.BOTTOM_LEFT then
		x, y = offsetx, offsety or offsetx
	elseif anchor == display.TOP_CENTER then
		x, y = w / 2 + offsetx, h + (offsety or 0)
	elseif anchor == display.BOTTOM_CENTER then
		x, y = w / 2 + offsetx, offsety or 0
	elseif anchor == display.BOTTOM_RIGHT then
		x, y = w + offsetx, offsety or -offsetx
	elseif anchor == display.CENTER_RIGHT then
		x, y = w + offsetx, h / 2 + (offsety or 0)
	else
		x, y = w + offsetx, h + (offsety or offsetx)
	end
	node:ignoreAnchorPointForPosition(false)
	display.align(node, anchor, x, y)
end
function util.alignRelative(node, relativeNode, anchor, relativeAnchor, offsetx, offsety)
	Log.a(node, TAG, "alignRelative() invalid params: node")
	Log.a(relativeNode, TAG, "alignRelative() invalid params: relativeNode")
	anchor = anchor or display.CENTER
	relativeAnchor = relativeAnchor or anchor
	offsetx = offsetx or 0
	offsety = offsety or 0
	local rectMode = true
	if relativeNode.getContentSize then
		rectMode = false
	end
	local size = rectMode and relativeNode or relativeNode:getContentSize()
	if isnumber(relativeAnchor) then
		relativeAnchor = display.ANCHOR_POINTS[relativeAnchor]
	end
	local x, y = size.width * relativeAnchor.x, size.height * relativeAnchor.y
	local relativeX, relativeY
	if rectMode then
		relativeX, relativeY = relativeNode.x, relativeNode.y
	else
		relativeX, relativeY = relativeNode:getPosition()
	end
	if rectMode then
		_ENV = relativeNode:getPosition()
		if relativeNode:getPosition() then
			goto lbl_67
		end
	end
	local relativeAnchorPointInPoints = relativeNode:getAnchorPointInPoints()
	::lbl_67::
	relativeX = relativeX - (relativeAnchorPointInPoints.x or 0)
	relativeY = relativeY - (relativeAnchorPointInPoints.y or 0)
	x = x + relativeX + offsetx
	y = y + relativeY + offsety
	if not rectMode then
		local nodeParent, relativeNodeParent = node:getParent(), relativeNode:getParent()
		if nodeParent ~= relativeNodeParent and relativeNodeParent then
			local point = relativeNodeParent:convertToWorldSpace(cc.p(x, y))
			point = nodeParent:convertToNodeSpace(point)
			x, y = point.x, point.y
		end
	end
	size = node:getContentSize()
	local nodeAnchorPoint = node:getAnchorPoint()
	if isnumber(anchor) then
		anchor = display.ANCHOR_POINTS[anchor]
	end
	x = x + size.width * (nodeAnchorPoint.x - anchor.x)
	y = y + size.height * (nodeAnchorPoint.y - anchor.y)
	node:spos(x, y)
end
function util.autoFixScrollView(scrollView, bounceable)
	local container = scrollView:getScrollNode()
	container:spos(0, scrollView:getViewRect().height - container:getContentSize().height * container:getScale())
	if scrollView.bBounce ~= ifnil(bounceable, true) then
		scrollView:setBounceable(bounceable)
	end
	return scrollView
end
function util.removeUnusedTextures()
	c.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	sharedTextureCache:removeUnusedTextures()
end
function display.addSpriteFrame(fileName)
	local frameName = fileName
	if string_find(fileName, "/") then
		_, frameName = string.splitlast(fileName, "/")
	end
	local cache = c.SpriteFrameCache:getInstance()
	local frame = cache:getSpriteFrameByName(frameName)
	if not frame then
		local texture = sharedTextureCache:addImage(fileName)
		if texture then
			local size = texture:getContentSizeInPixels()
			frame = c.SpriteFrame:createWithTexture(texture, c.rect(0, 0, size.width, size.height))
			cache:addSpriteFrame(frame, frameName)
		end
	end
	return frame
end
function util.addSearchPaths(paths)
	if isstring(paths) then
		c.FileUtils:getInstance():addSearchPath(paths)
	elseif istable(paths) then
		util.each(function(v, k)
			c.FileUtils:getInstance():addSearchPath(v)
		end, paths)
	end
end
function util.addSpriteFrames(path, handler)
	display.addSpriteFrames(path .. ".plist", path .. ".png", handler)
end
_ENV, util.fullPath = util, function(fileName)
	return c.FileUtils:getInstance():fullPathForFilename(fileName)
end
util.WHITE = display.COLOR_WHITE
util.BLACK = display.COLOR_BLACK
util.RED = display.COLOR_RED
util.GREEN = display.COLOR_GREEN
util.BLUE = display.COLOR_BLUE
util.YELLOW = c.c3b(255, 255, 0)
util.GREE = c.c3b(166, 166, 166)
util.ORANGE = c.c3b(255, 127, 0)
COLOR3, util.MAGENTA = util, c.c3b(255, 0, 255)
COLOR_TRANSPARENT = c.c4b(0, 0, 0, 0)
CCPointZero = c.p(0, 0)
CCSizeZero = c.size(0, 0)
CCRectZero = c.rect(0, 0, 0, 0)
function util.initView(view, params)
	if view and params then
		if params.anchor then
			util.anchor(view, params.anchor)
		end
		if params.x then
			view:spos(params.x, params.y)
		end
		if params.tag then
			view:tag(params.tag)
		end
		if params.zorder then
			view:zorder(params.zorder)
		end
		if params.size then
			view:ssize(params.size)
		end
		if params.width and params.height then
			view:ssize(params.width, params.height)
		end
		if params.parent then
			params.parent:addChild(view)
		end
		if params.visible ~= nil then
			view:setVisible(params.visible)
		end
		if params.enable ~= nil then
			view:setEnabled(params.enable)
		end
		if isstring(params.name) then
			view:setName(params.name)
		end
	end
end
function util.bindNodeTouchEvent(node, params)
	Log.a(node, "[util_ex]", "bindNodeTouchEvent() invalid node")
	if not params then
		params, _ENV = Log.a, Log.a
	end
	local _sound = params.sound
	local _swallows = params.swallows
	local _isMultiTouches = params.isMultiTouches or false
	local _onTouch = params.onTouch
	local _onTouchBegan = params.onTouchBegan
	local _onTouchMoved = params.onTouchMoved
	local _onTouchEnded = params.onTouchEnded
	local _onTouchCancelled = params.onTouchCancelled
	local _clickListener = params.clickListener
	local _moveDistance = params.moveDistance or 10
	local _container = params.container
	local _clickInner = params.clickInner
	local _interval = params.interval
	local _intervalDelay = params.intervalDelay or 0.5
	local _beganX, _beganY, _ismoved, _rect, onTouch, onTouchBegan, onTouchMoved, onTouchEnded, onTouchCancelled, _action_delay_long_click, _action_long_click
	local closeActoinLongClick_ = function()
		if _action_long_click then
			node:stop(_action_long_click)
		end
		if _action_delay_long_click then
			node:stop(_action_delay_long_click)
		end
	end
	function onTouchBegan(x, y, prevX, prevY, points)
		if _rect and not util.rectContainsPoint(_rect, cc.p(x, y)) then
			return false
		end
		y = {}
		if util.isPointInNode(node, x, y) then
			local result = false
			if _onTouchBegan then
				result = _onTouchBegan(x, y, prevX, prevY, points)
			else
				result = true
			end
			if result and _clickListener and isnumber(_interval) and 0 < _interval then
			end
			return result
		else
			return false
		end
	end
	function onTouchMoved(x, y, prevX, prevY, points)
		if not _clickInner and _ismoved ~= true and (math.abs(x - _beganX) > _moveDistance or math.abs(y - _beganY) > _moveDistance) then
		end
		if _onTouchMoved then
			return _onTouchMoved(x, y, prevX, prevY, points)
		else
			local _touchMovedMode
			return _touchMovedMode
		end
	end
	function onTouchEnded(x, y, prevX, prevY, points)
		closeActoinLongClick_()
		if (_clickInner and util.isPointInNode(node, x, y) or _ismoved ~= true) and _clickListener then
			if _sound then
				audio.playSound(_sound)
			end
			_clickListener(node, x, y)
		end
		if _onTouchEnded then
			_onTouchEnded(x, y, prevX, prevY, points)
		end
	end
	function onTouchCancelled(x, y, prevX, prevY, points)
		closeActoinLongClick_()
		if _onTouchCancelled then
			_onTouchCancelled(x, y, prevX, prevY, points)
		end
	end
	function onTouch(event)
		if _onTouch then
			_onTouch(event)
		end
		local eventType, x, y, prevX, prevY, points
		eventType = event.name
		x, y = event.x, event.y
		prevX, prevY = event.prevX, event.prevY
		points = event.points
		if eventType == "began" then
			return onTouchBegan(x, y, prevX, prevY, points)
		elseif eventType == "moved" then
			return onTouchMoved(x, y, prevX, prevY, points)
		elseif eventType == "ended" then
			onTouchEnded(x, y, prevX, prevY, points)
		elseif eventType == "cancelled" then
			onTouchCancelled(x, y, prevX, prevY, points)
		end
	end
	function node:getBeganX()
		return _beganX
	end
	function node:setBeganX(x)
		x = {}
	end
	function node:getBeganY()
		return _beganY
	end
	function node:setBeganY(y)
		y = {}
	end
	function node:isMoved()
		return _ismoved
	end
	function node:setIsMoved(ismoved)
		ismoved = {}
	end
	function node:resetTouchStatus()
	end
	if _container then
		_rect = _container:getBoundingBox()
	end
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT, onTouch)
	node:setTouchEnabled(true)
	if _isMultiTouches then
		node:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
	end
	if _swallows == false then
		node:setTouchSwallowEnabled(false)
	end
end
function util.callStaticMethod(args, params)
	if not params then
		params, isandroid = nil, nil
	end
	local luaBridge, sig, args4Call, className, methodName
	if isandroid() then
		luaBridge = luaj
		sig = params.sig
		if table.isnotempty(args) then
			args4Call, isandroid = table.isnotempty(args), table.isnotempty(args)
			if 0 < #args then
				args4Call = args
			elseif table.nums(args) == 1 then
				for key, value in pairs(args) do
					args4Call[1] = value
				end
			else
				for i, key in ipairs(params.argsOrder) do
					args4Call[i] = args[key]
				end
			end
		end
		className = params.className_android or params.className
		methodName = params.methodName_android or params.methodName
	elseif isios() then
		luaBridge = luaoc
		args4Call = args
		className = params.className_ios or params.className
		methodName = params.methodName_ios or params.methodName
	else
		return false
	end
	return luaBridge.callStaticMethod(className, methodName, args4Call, sig)
end
function util.anchor(node, x, y)
	if istable(x) and isnumber(x.x) and isnumber(x.y) then
		if node:isIgnoreAnchorPointForPosition() then
			node:ignoreAnchorPointForPosition(false)
		end
		node:setAnchorPoint(x)
	elseif isnumber(x) and isnumber(y) then
		if node:isIgnoreAnchorPointForPosition() then
			node:ignoreAnchorPointForPosition(false)
		end
		node:setAnchorPoint(x, y)
	elseif isnumber(x) and not y and 1 <= display.CENTER and x <= display.BOTTOM_CENTER then
		if node:isIgnoreAnchorPointForPosition() then
			node:ignoreAnchorPointForPosition(false)
		end
		node:setAnchorPoint(display.ANCHOR_POINTS[x])
	elseif isboolean(x) then
		node:ignoreAnchorPointForPosition(not x)
	elseif type(x) == "userdata" then
		if node:isIgnoreAnchorPointForPosition() then
			node:ignoreAnchorPointForPosition(false)
		end
		node:setAnchorPoint(x)
	end
	return node
end
function util.scheduleInDuration(node, callback, time, interval, preCallback)
	if not interval or interval <= 0 or time / interval == 1 then
		if preCallback then
			callback(true, 1)
		else
			return node:performWithDelay(function()
				callback(true, 1)
			end, time)
		end
	else
		local totalTimes = math.floor(time / interval)
		local index = 0
		local handle
		local callback_ = function()
			if index >= totalTimes and handle then
				node:stopAction(handle)
			end
			callback(index == totalTimes, index)
		end
		_UPVALUE1_ = nil
		;(nil)[1] = cc.DelayTime:create(interval)
		;(nil)[2] = cc.CallFunc:create(callback_)
		;(nil)[3] = cc.CallFunc:create(callback_)
		;(nil)[4] = cc.CallFunc:create(callback_)
		;(nil)[5] = cc.CallFunc:create(callback_)
		local (nil)[6], actions = cc.CallFunc:create(callback_)
		if preCallback then
			actions[1], actions[2] = actions[2], actions[1]
		end
		handle = node:runAction(cc.RepeatForever:create(transition.sequence(actions)))
		return handle
	end
end
function util.transferTouchEvent2Quick(target, swallows)
	if not target.onTouch_ then
		return
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	if swallows == false then
		listener:setSwallowTouches(false)
	end
	local prevX, prevY
	listener:registerScriptHandler(function(touch, event)
		local point = touch:getLocation()
		prevX = nil
		;(nil).name = "began"
		;(nil).x = point.x
		;(nil).y = point.y
		return target:onTouch_(nil)
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function(touch, event)
		local point = touch:getLocation()
		target = nil
		;(nil).name = "moved"
		;(nil).x = point.x
		;(nil).y = point.y
		;(nil).prevX = prevX
		;(nil).prevY = prevY
		target:onTouch_(nil)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function(touch, event)
		local point = touch:getLocation()
		target = nil
		;(nil).name = "ended"
		;(nil).x = point.x
		;(nil).y = point.y
		target:onTouch_(nil)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(function(touch, event)
		local point = touch:getLocation()
		target = nil
		;(nil).name = "canceled"
		;(nil).x = point.x
		;(nil).y = point.y
		target:onTouch_(nil)
	end, cc.Handler.EVENT_TOUCH_CANCELLED)
	target:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, target)
	target.listener_ = listener
	return listener
end
do
	local USE_CSD_CACHE = false
	if not USE_CSD_CACHE then
		function util.resetCSDCatch()
		end
		function util.dumpCSDCatch()
		end
	else
		cc.uiloader.load_ = cc.uiloader.load_ or cc.uiloader.load
		local _ENV, cache_csd_ = cc.uiloader, cc.uiloader
		local cache_csd_count_ = false
		_ENV = 0
		;(0)["ccsFiles_en/commonView/commonPromptBox.csb"] = true
		local (0)["ccsFiles/commonView/commonPromptBox.csb"], exclude_files_ = true, 0
		function cc.uiloader:load(fileName)
			if not exclude_files_[fileName] then
				return cc.uiloader:load_(fileName)
			end
			if not cache_csd_[fileName] then
				local node = cc.uiloader:load_(fileName)
				node:retain()
				cache_csd_[fileName] = node
				if cache_csd_count_ then
					_UPVALUE4_ = cache_csd_count_
					cache_csd_count_[fileName], cache_csd_count_[1] = cache_csd_count_, 0
					cache_csd_count_[fileName], cache_csd_count_[2] = cache_csd_count_, util.gettime() - starttime
					cache_csd_count_[fileName], cache_csd_count_[3] = cache_csd_count_, 0
					cache_csd_count_[fileName], cache_csd_count_[4] = cache_csd_count_, fileName
				end
			end
			if cache_csd_count_ then
				local starttime = util.gettime()
				local result = cache_csd_[fileName]:clone()
				local time = util.gettime() - starttime
				cache_csd_count_[fileName][1] = cache_csd_count_[fileName][1] + 1
				if time > cache_csd_count_[fileName][3] then
					cache_csd_count_[fileName][3] = time
				end
				return result
			else
				print("返回缓存csb:", fileName)
				return cache_csd_[fileName]:clone()
			end
		end
		function util.resetCSDCatch()
			for k, v in pairs(cache_csd_) do
				v:release()
			end
			pairs = (for generator)
			if cache_csd_count_ then
				pairs = cache_csd_count_
			end
		end
		function util.dumpCSDCatch()
			if cache_csd_count_ then
				local datas = table.values(cache_csd_count_)
				print("==============访问次数排序===============")
				table.sort(datas, function(a, b)
					return a[1] > b[1]
				end)
				for i, v in ipairs(datas) do
					print(i, v[1], v[2], v[3], v[4])
				end
				print("==============load时间排序===============")
				table.sort(datas, function(a, b)
					return a[2] > b[2]
				end)
				for i, v in ipairs(datas) do
					print(i, v[1], v[2], v[3], v[4])
				end
				print("==============clone时间排序===============")
				table.sort(datas, function(a, b)
					return a[3] > b[3]
				end)
				for i, v in ipairs(datas) do
					print(i, v[1], v[2], v[3], v[4])
				end
			end
		end
	end
end
