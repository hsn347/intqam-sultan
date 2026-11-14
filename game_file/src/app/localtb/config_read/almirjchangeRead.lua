local almirjchangeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "almirjchangebox"
	;(nil)[2] = true
	almirjchangeRead:defineValue("boxCfg", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "almirjchange"
	;(nil)[2] = true
	almirjchangeRead:defineValue("changeCfg", nil)
end
init()
function almirjchangeRead.getChangeCfg(classtype)
	return almirjchangeRead.changeCfg[classtype]
end
function almirjchangeRead.getBoxCfg(classtype)
	local _ENV, tb
	for k, v in ipairs(almirjchangeRead.boxCfg) do
		if v.grade == classtype then
			table.insert(tb, v)
		end
	end
	return tb
end
return almirjchangeRead
