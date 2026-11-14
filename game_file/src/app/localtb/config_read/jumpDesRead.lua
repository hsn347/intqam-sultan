local jumpDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	jumpDesRead = nil
	;(nil)[1] = "source_config"
	jumpDesRead:defineValue("source_config", nil)
end
init()
function jumpDesRead.getCfg(sourceId)
	return jumpDesRead.source_config[sourceId]
end
function jumpDesRead.getIcon(sourceId)
	local cfg = jumpDesRead.getCfg(sourceId)
	return cfg.icon
end
function jumpDesRead.getDes(sourceId)
	local cfg = jumpDesRead.getCfg(sourceId)
	return i18n(cfg.des)
end
function jumpDesRead.hasJump(sourceId)
	local cfg = jumpDesRead.getCfg(sourceId)
	local hasJump = cfg.hasJump
	if hasJump == 0 then
		return false
	else
		return true
	end
end
function jumpDesRead.getGuide(sourceId)
	local cfg = jumpDesRead.getCfg(sourceId)
	return cfg and cfg.guide
end
return jumpDesRead
