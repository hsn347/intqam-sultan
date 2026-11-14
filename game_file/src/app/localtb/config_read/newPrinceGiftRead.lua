local newPrinceGiftRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "newplayer_growupgift_config"
	;(nil)[2] = true
	newPrinceGiftRead:defineValue("configData", nil)
end
init()
function newPrinceGiftRead.getGiftData(giftID)
	for k, v in pairs(newPrinceGiftRead.configData) do
		if v.ID == giftID then
			return v
		end
	end
end
return newPrinceGiftRead
