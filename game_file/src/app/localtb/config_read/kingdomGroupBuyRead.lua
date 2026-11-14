local kingdomGroupBuyRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	kingdomGroupBuyRead = nil
	;(nil)[1] = "kinggroupbuy_box_config"
	kingdomGroupBuyRead:defineValue("boxConfig", nil)
end
function kingdomGroupBuyRead.getBoxConfig(index)
	return kingdomGroupBuyRead.boxConfig[index]
end
init()
return kingdomGroupBuyRead
