local sharedApplication = cc.Application:getInstance()
local target = sharedApplication:getTargetPlatform()
CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
if target == 2 then
	require("LuaDebugger.LuaPanda").start("127.0.0.1", 8818)
end
if jit then
	jit.off()
	jit.flush()
end
collectgarbage("setpause", 140)
collectgarbage("setstepmul", 10000)
require("gameTargetCfg")
USE_SEND_ERROR_TO_DINGTALK = false
local STP
local __G__TRACKBACK__PALL = function(errorMessage, level)
	level = level or 2
	level = level + 2
	print("__G__TRACKBACK__")
	print("----------------------------------------")
	print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
	local errorMsg, isAlert
	local stpMsg = STP.stacktrace("", level, 1)
	if device and device.platform == "mac" or userSDKManager and (userSDKManager.isBeta() or userSDKManager.isReportError() or userSDKManager.isGameDevelop()) then
		isAlert = true
		errorMsg = debug.traceback("", level)
	else
		errorMsg = debug.traceback("", level)
	end
	print(errorMsg)
	print("----------------------------------------")
	if isAlert then
		if USE_SEND_ERROR_TO_DINGTALK then
			sendToDingTalk(errorMessage)
		end
		STP = "\n"
		;("\n")[1] = "确定"
		device.showAlert("出错了,测试使用,请截图", tostring(errorMessage) .. "\n" .. tostring(errorMsg .. stpMsg), "\n")
		if _G.fabric then
			local errorStr = tostring(errorMessage)
			_G.fabric:getInstance():allSet(errorStr, errorMsg, stpMsg)
		end
	else
		send_trackback("commonError", tostring(errorMessage), errorMsg, stpMsg)
	end
end
function __G__TRACKBACK__(errorMessage, level)
	pcall(__G__TRACKBACK__PALL, errorMessage, level)
end
if G_IS_UNITY then
	CS.LuaManager.setLuaError(__G__TRACKBACK__)
	CS.FairyGUI.FontManager.PrepareLoadFont(400)
end
function sendReviewLog(msg)
	if gSvrConfig.isReview and device.platform == "ios" then
		lastSendTime = nil
		print("[review] " .. msg)
	elseif device.platform == "mac" then
		print("[review] " .. msg)
	end
end
function sendTraceBackLog(msg, trackback, stpMsg, force)
	if _G.fabric then
		trackback = trackback or debug.traceback("", 2)
		local errorStr = tostring(msg)
		_G.fabric:getInstance():allSet(errorStr, trackback, stpMsg, force)
	end
end
lastSendTime = nil
lastErrorStr = nil
function send_trackback(errorType, errorStr, trackback, stpMsg)
	if device and device.platform == "mac" then
		return
	end
	if _G.fabric then
		_G.fabric:getInstance():allSet(errorStr, trackback, stpMsg)
	end
	local currentTime = os.time()
	if lastSendTime ~= nil and currentTime - lastSendTime < 10 then
		return
	end
	if errorStr == lastErrorStr then
		print("报错", errorStr)
		return
	end
	lastSendTime = currentTime
	lastErrorStr = errorStr
end
cc.FileUtils:getInstance():setPopupNotify(false)
local checknil = require("checknil")
checknil:initCheckNil()
require("config")
require("app.tracy.tracyInit")
require("cocos.init")
require("framework.init")
local checkIsEmulatorPlay = function()
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android and CSUserSDKManager.isEmulatorPlay then
		return CSUserSDKManager:isEmulatorPlay()
	end
	return false
end
function main_runMyApp()
	cc.Image:setPVRImagesHavePremultipliedAlpha(true)
	local app = require("app.MyApp").new()
	app:run()
	if _G.fabric then
		_G.fabric:getInstance():reportDeviceInfo()
	end
	if G_IS_Editor then
		require("LuaDebugger.CheckGlobalValue")
	end
end
local isAndroidOrIsIPhone = UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer
if isAndroidOrIsIPhone then
	local ret = CS.Sultan.Init.GameIniter:isGranted()
	if ret then
		main_runMyApp()
	else
		CS.Sultan.Init.GameIniter:waittingToGrant()
	end
else
	main_runMyApp()
end
