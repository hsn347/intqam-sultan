local _ENV, M
local isGameBeta = function()
	local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
	local isBeta = CSUserSDKManager:isBeta()
	return isBeta
end
local isGameDevelop = function()
	if cc.UserDefault:getInstance():getBoolForKey("System:GameDevelopMode~bool") then
		return true
	end
	return false
end
local isGameSupportDebug = function()
	return isGameBeta() or isGameDevelop()
end
function M:initCheckNil()
	if isGameSupportDebug() then
		print("withoutchecknil--disable")
	else
		print("withoutchecknil--enable")
		local withoutchecknil = require("withoutchecknil")
		withoutchecknil.enable()
	end
end
return M
