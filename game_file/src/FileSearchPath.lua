local _ENV, M
local PLATFORM_OS_WINDOWS = 0
local PLATFORM_OS_LINUX = 1
local PLATFORM_OS_MAC = 2
local PLATFORM_OS_ANDROID = 3
local PLATFORM_OS_IPHONE = 4
local PLATFORM_OS_IPAD = 5
local PLATFORM_OS_BLACKBERRY = 6
local PLATFORM_OS_NACL = 7
local PLATFORM_OS_EMSCRIPTEN = 8
local PLATFORM_OS_TIZEN = 9
local PLATFORM_OS_WINRT = 10
local PLATFORM_OS_WP8 = 11
local isGameBeta = function()
	local isBeta = false
	local sharedApplication = cc.Application:getInstance()
	local target = sharedApplication:getTargetPlatform()
	if target == PLATFORM_OS_IPHONE or target == PLATFORM_OS_IPAD then
		local ok, ret = LuaObjcBridge.callStaticMethod("TargetConfigure", "isBeta", nil)
		if ok then
			isBeta = ret
		end
	elseif target == PLATFORM_OS_ANDROID then
		local javaClassName = "org/cocos2dx/lua/TargetConfigure"
		local javaMethodName = "isBeta"
		local javaMethodSig = "()Z"
		_ENV = nil
		local ok, ret = LuaJavaBridge.callStaticMethod(javaClassName, javaMethodName, nil, javaMethodSig)
		if ok then
			isBeta = ret
		end
	elseif target == PLATFORM_OS_MAC then
		isBeta = true
	elseif target == PLATFORM_OS_WINDOWS then
		isBeta = true
	end
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
local _isSupportAAB
local isSupportAAB = function()
	if _isSupportAAB ~= nil then
		return _isSupportAAB
	end
	local javaClassName2 = "org/cocos2dx/lua/AppActivity"
	local javaMethodName2 = "isSupportAAB"
	local javaMethodSig2 = "()Z"
	local ok, ret = luaj.callStaticMethod(javaClassName2, javaMethodName2, nil, javaMethodSig2)
	print("isSupportAAB", ok, ret)
	ret = {}
	return ret
end
M.isSupportAAB = isSupportAAB
local getAABPath = function()
	local javaClassName = "org/cocos2dx/lua/AppActivity"
	local javaMethodName = "getAABFileName"
	local javaMethodSig = "()Ljava/lang/String;"
	print("getAABPath ")
	local ok, ret = luaj.callStaticMethod(javaClassName, javaMethodName, nil, javaMethodSig)
	if ok and string.len(ret) > 0 then
		return ret
	end
end
local getSearchPathsDefault = function(supportaab)
	local _ENV, tempTabel
	local writablePath = cc.FileUtils:getInstance():getWritablePath()
	if isGameSupportDebug() then
		if cc.Application:getInstance():getTargetPlatform() == PLATFORM_OS_ANDROID and cc.FileUtils:getInstance().getSDCardPath then
			local sdCardPath = cc.FileUtils:getInstance():getSDCardPath()
			print("sdCardPath ", sdCardPath)
			table.insert(tempTabel, sdCardPath .. "/src")
			table.insert(tempTabel, sdCardPath .. "/res/")
		end
		table.insert(tempTabel, writablePath .. "updatePersion")
		table.insert(tempTabel, writablePath .. "updatePersion/res/")
		table.insert(tempTabel, writablePath .. "updatePersion/src")
		table.insert(tempTabel, writablePath .. "updateTest/")
		table.insert(tempTabel, writablePath .. "updateTest/res/")
		table.insert(tempTabel, writablePath .. "updateTest/src")
	end
	table.insert(tempTabel, writablePath .. "updatePackage/res/")
	table.insert(tempTabel, writablePath .. "updatePackage/src")
	table.insert(tempTabel, writablePath .. "updatePackage/")
	table.insert(tempTabel, writablePath .. "hd_res/")
	table.insert(tempTabel, writablePath .. "hd_res/singleTextures/")
	table.insert(tempTabel, "src/")
	table.insert(tempTabel, "res/")
	if supportaab then
		local aabPath = getAABPath()
		if aabPath then
			table.insert(tempTabel, aabPath .. "/res/")
		end
	end
	table.insert(tempTabel, "")
	return tempTabel
end
M.getSearchPathsDefault = getSearchPathsDefault
function M:setSearchDefaultPaths(supportaab)
	local tempTabel = getSearchPathsDefault(supportaab)
	cc.FileUtils:getInstance():setSearchPaths(tempTabel)
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
function M:initAppExpansionPackage()
	local fileInstance = cc.FileUtils:getInstance()
	if fileInstance.initAppExpansionPackage then
		if isSupportAAB() then
			self:setSearchDefaultPaths(true)
		else
			fileInstance:initAppExpansionPackage()
		end
	end
end
return M
