local nationalFlagRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local lang = userSDKManager.getChannel()
	if lang == "ar" then
		_ENV = nil
		;(nil)[1] = "nationalconfig"
		nationalFlagRead:defineValue("flagInfo", nil)
	else
		_ENV = nil
		;(nil)[1] = "nationalconfig_en"
		nationalFlagRead:defineValue("flagInfo", nil)
	end
end
init()
function nationalFlagRead.getDataByShort(shortcut)
	local redata
	for _, v in pairs(nationalFlagRead.flagInfo) do
		if v.shortcut == shortcut then
			redata = v
		end
	end
	return redata
end
function nationalFlagRead.getImgByID(id)
	return nationalFlagRead.flagInfo[id] and nationalFlagRead.flagInfo[id].image or nil
end
function nationalFlagRead.getAcrossListImageByID(id)
	return nationalFlagRead.flagInfo[id] and nationalFlagRead.flagInfo[id].across_listImage or nil
end
function nationalFlagRead.getAcrossPopupImageByID(id)
	return nationalFlagRead.flagInfo[id] and nationalFlagRead.flagInfo[id].across_popupImage or nil
end
function nationalFlagRead.getAcrossBgImageByID(id)
	return nationalFlagRead.flagInfo[id] and nationalFlagRead.flagInfo[id].across_bgImage or nil
end
function nationalFlagRead.getList(...)
	return nationalFlagRead.flagInfo
end
return nationalFlagRead
