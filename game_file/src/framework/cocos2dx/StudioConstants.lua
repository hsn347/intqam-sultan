if not ccs then
	_ENV = ccs
end
ccs = ccs
_ENV = nil
;(nil).start = 0
;(nil).complete = 1
ccs.MovementEventType, (nil).loopComplete = nil, 2
