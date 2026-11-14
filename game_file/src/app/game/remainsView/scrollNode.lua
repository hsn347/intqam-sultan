local scrollNode = class("scrollNode", function(target)
	return target
end)
local TOUCH_MOVED_ERROR_VALUE = _G.TOUCH_MOVED_ERROR_VALUE
function scrollNode:ctor()
	self.scroll = nil
	self._handle = nil
	self._singleIsMoved = false
	self._init = false
	self._addTouchEventListener = self.addTouchEventListener
	self.addTouchEventListener = self.setHandle
end
function scrollNode:btnJoinClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function scrollNode:btnClickCallBack(button, type)
	if self.scroll then
		if type == ccui.TouchEventType.ended then
			if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
				print("node is not on view")
				return
			end
			if self._singleIsMoved then
				self._singleIsMoved = false
				return
			end
			if self._handle then
				self._handle(button, type)
			end
		elseif type == ccui.TouchEventType.moved then
			local touchBeganPoint = button:getTouchBeganPosition()
			local touchmovePoint = button:getTouchMovePosition()
			local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
			if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
				self._singleIsMoved = true
			end
		elseif type == ccui.TouchEventType.canceled then
			self._singleIsMoved = false
		end
	elseif self._handle then
		self._handle(button, type)
	end
end
function scrollNode:setScroll(scroll)
	self.scroll = scroll
end
function scrollNode:setHandle(handle)
	self._handle = handle
	if not self._init then
		self._init = true
		self._addTouchEventListener(self, handler(self, self.btnClickCallBack))
	end
end
return scrollNode
