local starGiftRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "celebrationgift"
;(nil)[2] = true
starGiftRead:defineValue("celebrationgift", nil)
function starGiftRead.getGiftConfig(type, lv)
	local _ENV, data
	for i, v in ipairs(starGiftRead.celebrationgift) do
		if v.type == type and lv >= v.lv then
			data[v.order] = v
		end
	end
	return data
end
return starGiftRead
