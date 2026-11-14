local guardianRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "protector_login_config"
	;(nil)[2] = true
	guardianRead:defineValue("config", nil)
end
init()
function guardianRead.getProperty(level, key)
	return guardianRead.config[level] and guardianRead.config[level][key] or nil
end
function guardianRead.getBuffIsNew(level, buffID)
	local buffData
	if guardianRead.config[level] then
		buffData = guardianRead.config[level].buff
	else
		return false
	end
	for i, v in ipairs(buffData) do
		if v == buffID then
			return true
		end
	end
	return false
end
function guardianRead.getPageNum()
	return table.nums(guardianRead.config)
end
return guardianRead
