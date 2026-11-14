local EventListener = class("EventListener")
function EventListener:create()
	return self.new()
end
function EventListener:registerScriptHandler(callback, eventID)
	return 0
end
return EventListener
