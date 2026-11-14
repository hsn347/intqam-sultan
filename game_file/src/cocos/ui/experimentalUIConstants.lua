if nil == ccexp then
	return
end
_ENV = nil
;(nil).PLAYING = 0
;(nil).PAUSED = 1
;(nil).STOPPED = 2
;(nil).COMPLETED = 3
ccexp.VideoPlayerEvent, (nil).SKIPED = nil, 4
