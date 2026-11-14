local EventListenerKeyboard = class("EventListenerKeyboard")
function EventListenerKeyboard:create()
	return self.new()
end
function EventListenerKeyboard:registerScriptHandler(callback, eventType)
	print_warn("键盘事件暂不处理", callback, eventType)
end
return EventListenerKeyboard
