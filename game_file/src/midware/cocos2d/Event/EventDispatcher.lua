local EventDispatcher = class("EventDispatcher")
function EventDispatcher:addEventListenerWithFixedPriority(listener, target)
end
function EventDispatcher:addEventListenerWithSceneGraphPriority(listener, target)
end
function EventDispatcher:removeEventListener(listener)
end
return EventDispatcher
