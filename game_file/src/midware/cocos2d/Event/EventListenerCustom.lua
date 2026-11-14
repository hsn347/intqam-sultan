local EventListener = require("midware.cocos2d.Event.EventListener")
local EventListenerCustom = class("EventListenerCustom", EventListener)
function EventListenerCustom:create(eventID, callback)
	local listener = self.new()
	return listener
end
return EventListenerCustom
