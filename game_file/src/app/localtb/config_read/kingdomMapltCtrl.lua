local kingdomMapltCtrl = class("kingdomMapltCtrl", include("aAReadClass").new())
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingdomMapltCtrl.map, isInited = {}, {}
	_UPVALUE2_ = nil
	;(nil)[1] = "resource"
	;(nil)[2] = true
	kingdomMapltCtrl:defineValue("res", nil)
end
init()
function kingdomMapltCtrl:getResData()
	return kingdomMapltCtrl.res
end
return kingdomMapltCtrl
