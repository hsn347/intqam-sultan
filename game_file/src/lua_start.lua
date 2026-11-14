UnityEngine = CS.UnityEngine
FairyGUI = CS.FairyGUI
G_IS_UNITY = true
G_IS_Editor = false
if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor then
	G_IS_Editor = true
end
local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
if G_IS_Editor or CSUserSDKManager:isBeta() or CS.Sultan.Middleware.UserDefault:getInstance():getBoolForKey("System:GameDevelopMode~bool~isDefault") then
	CS.LuaManager.AddLuaLoaderTest()
end
require("log")
require("utils")
print("lua_start.lua========================")
require("cocos.cocos2d.extern")
require("framework.timer.timerManager")
require("midware.midware")
require("main")
