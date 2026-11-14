local EventListenerAcceleration = class("EventListenerAcceleration")
function EventListenerAcceleration:create(callback)
	return self.new()
end
function EventListenerAcceleration:registerScriptHandler(callback, eventType)
	print_warn("EventListenerAcceleration暂不处理", callback, eventType)
end
return EventListenerAcceleration
