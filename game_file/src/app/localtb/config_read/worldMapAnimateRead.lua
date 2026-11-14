local worldMapAnimateRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	worldMapAnimateRead = nil
	;(nil)[1] = "animation"
	worldMapAnimateRead:defineValue("config", nil)
end
function worldMapAnimateRead.getAnimatePage(pageID)
	if worldMapAnimateRead.config[pageID] then
		return worldMapAnimateRead.config[pageID]
	end
end
init()
return worldMapAnimateRead
