local _ENV, tracy
local empyt_fun = function()
end
tracy.ZoneBegin = empyt_fun
tracy.ZoneBeginN = empyt_fun
tracy.ZoneBeginS = empyt_fun
tracy.ZoneBeginNS = empyt_fun
tracy.ZoneEnd = empyt_fun
tracy.ZoneText = empyt_fun
tracy.ZoneName = empyt_fun
tracy.Message = empyt_fun
return tracy
