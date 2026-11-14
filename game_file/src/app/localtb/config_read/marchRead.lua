local marchRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	marchRead = nil
	;(nil)[1] = "march_effect"
	marchRead:defineValue("effect", nil)
end
init()
function marchRead.getEffectName(eid)
	eid = tonumber(eid)
	if marchRead.effect[eid] then
		return marchRead.effect[eid].name
	else
		return ""
	end
end
return marchRead
