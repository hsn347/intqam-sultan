local snapshot = function()
	error("use memory leak checker instead!")
end
local total = function()
	error("use memory leak checker instead!")
end
_ENV = nil
;(nil).snapshot = snapshot
;(nil).total = total
return nil
