achievementModule, _ENV = nil, nil
achievementModule.ios, _ENV = nil, nil
achievementModule.android, _ENV = nil, nil
achievementModule.isGoogleBinding = false
achievementModule.isAppleIDBinding = false
function achievementModule.init(...)
	print("开始请求安卓-------")
	if device.platform == "android" then
		achievementModule.android.init()
	elseif device.platform == "ios" then
		achievementModule.ios.init()
	end
end
function achievementModule.unlockAchi(...)
	print("开始解锁成就-------")
	if device.platform == "android" then
		achievementModule.android.unlockAchi(...)
	elseif device.platform == "ios" then
		achievementModule.ios.unlockAchi(...)
	end
end
function achievementModule.showAchiBoard(...)
	print("弹出成就---------")
	if device.platform == "android" then
	elseif device.platform == "ios" then
		achievementModule.ios.showAchiBoard(...)
	end
end
function achievementModule.upLoadList(...)
	print("上传老成就---------")
	function getNeedUnlcokAchiList(...)
		local gametop = gModuleMgr.getObject("gametop")
		local achievementctrl = gametop.playertop_:getModule("achievementctrl")
		local serverList = achievementctrl:getAchievementData()
		local achiProductRead = include("achiProductRead")
		local _ENV, reqList = "achiProductRead", "achiProductRead"
		for i, v in ipairs(serverList) do
			if v.id then
				local tmpList = achiProductRead.getForwardListID(v.id, v.cur >= v.total)
				for k, v in pairs(tmpList) do
					reqList[k] = v
				end
			end
		end
		return reqList
	end
	if device.platform == "android" then
		achievementModule.android.upLoadList(getNeedUnlcokAchiList())
	elseif device.platform == "ios" then
		achievementModule.ios.upLoadList(getNeedUnlcokAchiList())
	end
end
function achievementModule.android.init(...)
end
function achievementModule.android.unlockAchi(...)
	local AchiID = (...)
	CSUserSDKManager:unlockAchi(tostring(AchiID), 0)
end
function achievementModule.android.showAchiBoard(...)
	CSUserSDKManager:showGoogleAchi()
end
function achievementModule.android.upLoadList(reqList)
	if table.nums(reqList) >= 1 then
		local paraList = ""
		for k, v in pairs(reqList) do
			print("android自动解锁成就:", v)
			paraList = paraList .. v .. ","
		end
		paraList = string.sub(paraList, 1, -2)
		print("paraList:", paraList)
		CSUserSDKManager:upLoadList(tostring(paraList))
	end
end
function achievementModule.ios.init(...)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:judgeNSConnect()
	end
end
function achievementModule.ios.unlockAchi(...)
	local aid = (...)
	CSUserSDKManager:unlockAchi(tostring(aid), 100)
end
function achievementModule.ios.showAchiBoard(...)
	CSUserSDKManager:showGoogleAchi()
end
function achievementModule.ios.upLoadList(reqList)
	for k, v in pairs(reqList) do
		print("自动解锁成就:", v)
		achievementModule.ios.unlockAchi(v)
	end
end
function achievementModule_adnroid_callBackisConnect(arg)
	if arg == "true" then
		achievementModule.isGoogleBinding = true
	else
		achievementModule.isGoogleBinding = false
	end
end
function achievementModule_ios_callBackisConnect(arg)
	if arg then
		achievementModule.isAppleIDBinding = true
	else
		achievementModule.isAppleIDBinding = false
	end
end
