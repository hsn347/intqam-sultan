local funUnlockRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local getConfig = function(name)
		local _ENV, config
		local _ENV, opCfg
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.new_function_config")
		for k, v in ipairs(cfg) do
			config[v.functionId] = v
			if v.OpName and v.OpName ~= "" then
				opCfg[v.OpName] = lordInfoCtrl:isNewLord() and v.unlockLevel or v.oldUnlockLevel
			end
		end
		funUnlockRead.config = config
		funUnlockRead.opCfg = opCfg
		if name == "config" then
			return config
		elseif name == "opCfg" then
			return opCfg
		end
	end
	funUnlockRead:defineValue("config", getConfig)
	funUnlockRead:defineValue("opCfg", getConfig)
end
init()
function funUnlockRead.getUnlockLevel(fid)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	if lordInfoCtrl:isNewLord() then
		return funUnlockRead.config[fid].unlockLevel
	else
		return funUnlockRead.config[fid].oldUnlockLevel
	end
end
function funUnlockRead.getShowLevel(fid)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	if lordInfoCtrl:isNewLord() then
		return funUnlockRead.config[fid].showLevel
	else
		return funUnlockRead.config[fid].oldShowLevel
	end
end
function funUnlockRead.getLvByOpName(OpName)
	return funUnlockRead.opCfg[OpName]
end
return funUnlockRead
