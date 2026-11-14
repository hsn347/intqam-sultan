local Component = requireLocal("..Component")
local EventProtocol = class("EventProtocol", Component)
function EventProtocol:ctor()
	EventProtocol.super.ctor(self, "EventProtocol")
	self.listeners_, EventProtocol = EventProtocol.super.ctor, EventProtocol.super.ctor
	self.nextListenerHandleIndex_ = 0
end
function EventProtocol:addEventListener(eventName, listener, tag)
	assert(type(eventName) == "string" and eventName ~= "", "EventProtocol:addEventListener() - invalid eventName")
	eventName = string.upper(eventName)
	if self.listeners_[eventName] == nil then
		self.listeners_[eventName], _ENV = eventName, eventName
	end
	local ttag = type(tag)
	if ttag == "table" or ttag == "userdata" then
		PRINT_DEPRECATED("EventProtocol:addEventListener(eventName, listener, target) is deprecated, please use EventProtocol:addEventListener(eventName, handler(target, listener), tag)")
		listener = handler(tag, listener)
		tag = ""
	end
	self.nextListenerHandleIndex_ = self.nextListenerHandleIndex_ + 1
	local handle = tostring(self.nextListenerHandleIndex_)
	tag = tag or ""
	_UPVALUE2_ = listener
	self.listeners_[eventName][handle], listener[1] = listener, listener
	self.listeners_[eventName][handle], listener[2] = listener, tag
	if 1 < DEBUG then
		printInfo("%s [EventProtocol] addEventListener() - event: %s, handle: %s, tag: %s", tostring(self.target_), eventName, handle, tostring(tag))
	end
	return handle
end
function EventProtocol:dispatchEvent(event)
	event.name = string.upper(tostring(event.name))
	local eventName = event.name
	if DEBUG > 1 then
		printInfo("%s [EventProtocol] dispatchEvent() - event %s", tostring(self.target_), eventName)
	end
	if self.listeners_[eventName] == nil then
		return
	end
	event.target = self.target_
	event.stop_ = false
	function event:stop()
		self.stop_ = true
	end
	for handle, listener in pairs(self.listeners_[eventName]) do
		if DEBUG > 1 then
			printInfo("%s [EventProtocol] dispatchEvent() - dispatching event %s to listener %s", tostring(self.target_), eventName, handle)
		end
		event.tag = listener[2]
		if listener[1] then
			listener[1](event)
		end
		if event.stop_ then
			if DEBUG > 1 then
				printInfo("%s [EventProtocol] dispatchEvent() - break dispatching for event %s", tostring(self.target_), eventName)
			end
			break
		end
	end
	return self.target_
end
function EventProtocol:removeEventListener(handleToRemove)
	for eventName, listenersForEvent in pairs(self.listeners_) do
		for handle, _ in pairs(listenersForEvent) do
			if handle == handleToRemove then
				listenersForEvent[handle] = nil
				if DEBUG > 1 then
					printInfo("%s [EventProtocol] removeEventListener() - remove listener [%s] for event %s", tostring(self.target_), handle, eventName)
				end
				return self.target_
			end
		end
	end
	return self.target_
end
function EventProtocol:removeEventListenersByTag(tagToRemove)
	for eventName, listenersForEvent in pairs(self.listeners_) do
		for handle, listener in pairs(listenersForEvent) do
			if listener[2] == tagToRemove then
				listenersForEvent[handle] = nil
				if DEBUG > 1 then
					printInfo("%s [EventProtocol] removeEventListener() - remove listener [%s] for event %s", tostring(self.target_), handle, eventName)
				end
			end
		end
	end
	return self.target_
end
function EventProtocol:removeEventListenersByEvent(eventName)
	self.listeners_[string.upper(eventName)] = nil
	if DEBUG > 1 then
		printInfo("%s [EventProtocol] removeAllEventListenersForEvent() - remove all listeners for event %s", tostring(self.target_), eventName)
	end
	return self.target_
end
function EventProtocol:removeAllEventListeners()
	self.listeners_, _ENV = nil, nil
	if DEBUG > 1 then
		printInfo("%s [EventProtocol] removeAllEventListeners() - remove all listeners", tostring(self.target_))
	end
	return self.target_
end
function EventProtocol:hasEventListener(eventName)
	eventName = string.upper(tostring(eventName))
	local t = self.listeners_[eventName]
	if not t then
		return false
	end
	for _, __ in pairs(t) do
		return true
	end
	return false
end
function EventProtocol:dumpAllEventListeners()
	print("---- EventProtocol:dumpAllEventListeners() ----")
	for name, listeners in pairs(self.listeners_) do
		printf("-- event: %s", name)
		for handle, listener in pairs(listeners) do
			printf("--     listener: %s, handle: %s", tostring(listener[1]), tostring(handle))
		end
	end
	return self.target_
end
function EventProtocol:exportMethods(force)
	_UPVALUE9_ = nil
	;(nil)[1] = "addEventListener"
	;(nil)[2] = "dispatchEvent"
	;(nil)[3] = "removeEventListener"
	;(nil)[4] = "removeEventListenersByTag"
	;(nil)[5] = "removeEventListenersByEvent"
	;(nil)[6] = "removeAllEventListenersForEvent"
	;(nil)[7] = "removeAllEventListeners"
	;(nil)[8] = "hasEventListener"
	;(nil)[9] = "dumpAllEventListeners"
	self:exportMethods_(nil, force)
	return self.target_
end
function EventProtocol:onBind_()
end
function EventProtocol:onUnbind_()
end
return EventProtocol
