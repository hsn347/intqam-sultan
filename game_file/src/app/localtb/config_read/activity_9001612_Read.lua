local activity_9001612_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "return_store"
;(nil)[2] = true
activity_9001612_Read:defineValue("return_store", nil)
function activity_9001612_Read.getShopList(page, backStarLv)
	local _ENV, ret
	for k, v in ipairs(activity_9001612_Read.return_store) do
		if v.page == page and backStarLv >= v.gloriousLv[1] and backStarLv <= v.gloriousLv[2] then
			table.insert(ret, v)
		end
	end
	return ret
end
return activity_9001612_Read
