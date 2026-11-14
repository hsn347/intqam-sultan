local carrierRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	carrierRead = nil
	;(nil)[1] = "carrier_client_list"
	carrierRead:defineValue("list", nil)
end
init()
function carrierRead.getFullCodeByClass(className)
	local _ENV, reTbl
	for i, v in ipairs(carrierRead.list) do
		if string.find(v.belongClass, className) then
			table.insert(reTbl, tonumber(v.MCC .. v.MNC))
		end
	end
	return reTbl
end
function carrierRead.judgeInCodes(code, _className)
	local result = false
	code = tonumber(code)
	if code then
		local codeList = carrierRead.getFullCodeByClass(_className)
		for i, v in ipairs(codeList) do
			if code == v then
				result = true
				break
			end
		end
	end
	return result
end
return carrierRead
