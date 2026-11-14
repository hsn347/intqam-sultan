local EventListenerTouchOneByOne = class("EventListenerTouchOneByOne")
function EventListenerTouchOneByOne:create()
	return self.new()
end
function EventListenerTouchOneByOne:registerScriptHandler(callback, eventType)
end
return EventListenerTouchOneByOne
