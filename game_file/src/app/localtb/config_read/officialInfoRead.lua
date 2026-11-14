local officialInfoRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	officialInfoRead = nil
	;(nil)[1] = "kingofficialconfig"
	officialInfoRead:defineValue("infoTable", nil)
end
init()
function officialInfoRead.getInfoByType(type)
	return officialInfoRead.infoTable[type]
end
function officialInfoRead.getInfoByName(type)
	local info = officialInfoRead.getInfoByType(type)
	if info then
		return i18n(info.name)
	end
end
function officialInfoRead.judgeGoodOrBad(type)
	return officialInfoRead.infoTable[type] and officialInfoRead.infoTable[type].class ~= 2
end
function officialInfoRead.getGoodPerson(...)
	local _ENV, reTbl
	for i, v in ipairs(officialInfoRead.infoTable) do
		if v.class == 1 then
			reTbl[i] = v
		end
	end
	return reTbl
end
function officialInfoRead.getBadPerson(...)
	local _ENV, reTbl
	for i, v in ipairs(officialInfoRead.infoTable) do
		if v.class == 2 then
			reTbl[i] = v
		end
	end
	return reTbl
end
return officialInfoRead
