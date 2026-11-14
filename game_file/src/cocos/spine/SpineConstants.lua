if nil == sp then
	return
end
_ENV = nil
;(nil).ANIMATION_START = 0
;(nil).ANIMATION_INTERRUPT = 1
;(nil).ANIMATION_END = 2
;(nil).ANIMATION_COMPLETE = 3
;(nil).ANIMATION_DISPOSE = 4
sp.EventType, (nil).ANIMATION_EVENT = nil, 5
