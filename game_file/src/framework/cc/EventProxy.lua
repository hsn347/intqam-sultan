local EventProxy = class("EventProxy")
function EventProxy:ctor(eventDispatcher, view)
	self.handles_, _ENV, self.eventDispatcher_ = nil, nil, eventDispatcher
	if view then
		cc(view):addNodeEventListener(cc.NODE_EVENT, function(event)
			if event.name == "exit" then
				self:removeAllEventListeners()
			end
		end)
	end
end
function EventProxy:addEventListener(eventName, listener, data)
	local handle = self.eventDispatcher_:addEventListener(eventName, listener, data)
	_UPVALUE2_ = listener
	self.handles_[#self.handles_ + 1], listener[1] = listener, eventName
	self.handles_[#self.handles_ + 1], listener[2] = listener, handle
	return self, handle
end
function EventProxy:removeEventListener(eventHandle)
	self.eventDispatcher_:removeEventListener(eventHandle)
	for index, handle in pairs(self.handles_) do
		if handle[2] == eventHandle then
			table.remove(self.handles_, index)
			break
		end
	end
	return self
end
function EventProxy:removeAllEventListenersForEvent(eventName)
	for key, handle in pairs(self.handles_) do
		if handle[1] == eventName then
			self.eventDispatcher_:removeEventListenersByEvent(eventName)
			self.handles_[key] = nil
		end
	end
	return self
end
function EventProxy:getEventHandle(eventName)
	for key, handle in pairs(self.handles_) do
		if handle[1] == eventName then
			return handle[2]
		end
	end
end
function EventProxy:removeAllEventListeners()
	for _, handle in pairs(self.handles_) do
		self.eventDispatcher_:removeEventListener(handle[2])
	end
	self.handles_, _ENV = pairs(self.handles_)
	return self
end
return EventProxy
