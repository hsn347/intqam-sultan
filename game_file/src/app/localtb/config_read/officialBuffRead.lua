local officialBuffRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	officialBuffRead = nil
	;(nil)[1] = "official_buff_des"
	officialBuffRead:defineValue("buffTable", nil)
end
init()
function officialBuffRead.getItem(id)
	return officialBuffRead.buffTable[id]
end
return officialBuffRead
