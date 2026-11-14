local kingOfGloryRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "king_glory_reward"
	;(nil)[2] = true
	kingOfGloryRead:defineValue("list", nil)
	kingOfGloryRead.maxLv = 1
	kingOfGloryRead:defineValue("cfgs", function()
		local _ENV, tmpCfgs
		for i, v in ipairs(kingOfGloryRead.list) do
			tmpCfgs[v.index] = v
		end
		kingOfGloryRead.cfgs = tmpCfgs
		return tmpCfgs
	end)
end
init()
function kingOfGloryRead.getCfgs()
	return kingOfGloryRead.cfgs
end
return kingOfGloryRead
