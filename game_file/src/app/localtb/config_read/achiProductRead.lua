local achiProductRead = include("aAReadClass").new()
local isInit = false
local defaultKey = ""
local dataKeys
local init = function()
	isInit = nil
	;(nil)[1] = "achievement_postinfo"
	achiProductRead:defineValue("dataList", nil)
	local lang = userSDKManager.getChannel()
	if device.platform == "android" then
		if lang == "ar" then
		else
		end
	elseif device.platform == "ios" then
		if lang == "ar" then
		else
		end
	end
end
init()
local getFatherNum = function(id)
	return math.floor(id / 1000) * 1000
end
function achiProductRead.getPIDbyAID(aid)
	local item = achiProductRead.dataList[aid]
	return item and item[defaultKey] or aid
end
function achiProductRead.getForwardListID(aid, includeSelf)
	local fNum = getFatherNum(aid)
	local dataKeys, totalList = aid, aid
	for i, v in ipairs(dataKeys) do
		if getFatherNum(v) == fNum then
			if includeSelf then
				if v <= aid then
					totalList[v] = achiProductRead.getPIDbyAID(v)
				end
			elseif v < aid then
				totalList[v] = achiProductRead.getPIDbyAID(v)
			end
		end
	end
	return totalList
end
return achiProductRead
