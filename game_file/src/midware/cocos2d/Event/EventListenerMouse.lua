local EventListenerMouse = class("EventListenerMouse")
function EventListenerMouse:create()
	return self.new()
end
function EventListenerMouse:registerScriptHandler(callback, type)
	print_warn("EventListenerMouse:registerScriptHandler暂 不支持的类型", type)
end
return EventListenerMouse
