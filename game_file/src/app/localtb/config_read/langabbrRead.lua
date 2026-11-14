local langAbbrRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	langAbbrRead = nil
	;(nil)[1] = "langabbr"
	langAbbrRead:defineValue("abbrInfo", nil)
end
init()
function langAbbrRead.getAbbrName(abbr)
	for i, v in ipairs(langAbbrRead.abbrInfo) do
		if v.abbr == abbr then
			return v.name
		end
	end
end
function langAbbrRead.getList()
	return langAbbrRead.abbrInfo
end
return langAbbrRead
