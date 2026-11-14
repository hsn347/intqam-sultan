if nil == ccs then
	return
end
_ENV = nil
;(nil).start = 0
;(nil).complete = 1
ccs.MovementEventType, (nil).loopComplete = nil, 2
_ENV = nil
;(nil).LoopAction = 0
;(nil).NoLoopAction = 1
ccs.InnerActionType, (nil).SingleFrame = nil, 2
