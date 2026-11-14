notificationManager, _ENV = nil, nil
notificationManager.notificationKeys, _ENV = nil, nil
notificationManager._pushAuthGranted = nil
function notificationManager.refreshPushPermission()
	notificationManager._pushAuthGranted = nil
end
function notificationManager.hasPushPermission()
	if notificationManager._pushAuthGranted == nil then
		local state = userSDKManager.getPushNotificationState()
		notificationManager._pushAuthGranted = type(state) == "number" and state == 1
		print("notificationManager.hasPushPermission query:", tostring(notificationManager._pushAuthGranted), "state=", tostring(state))
	end
	return notificationManager._pushAuthGranted
end
function notificationManager.registerNotification()
	print("notificationManager.registerNotification")
	if device.platform == "android" then
	elseif device.platform == "ios" then
	elseif device.platform == "mac" then
	end
end
function notificationManager.addNotification(fireData, key, message, isCoverOld, isReaptUnitDay)
	local notificationKey = getNotificationByDefine(key)
	if not notificationKey then
		return
	end
	if not notificationManager.hasPushPermission() then
		print("notificationManager.addNotification skip: no push permission, key=" .. tostring(notificationKey))
		return
	end
	print("notificationKey:" .. notificationKey)
	isCoverOld = isCoverOld and true
	if isCoverOld then
		notificationManager.removeNotification(key)
	end
	table.insert(notificationManager.notificationKeys, notificationKey)
	isReaptUnitDay = isReaptUnitDay or false
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:addNotify(message, fireData, notificationKey, 0, isReaptUnitDay)
	end
end
function notificationManager.removeNotification(key)
	local notificationKey = getNotificationByDefine(key)
	if not notificationKey then
		return
	end
	print("notificationKey:" .. notificationKey)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:removeNotify(notificationKey)
	end
end
function notificationManager.removeAllNotification()
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		if next(notificationManager.notificationKeys) then
			local jsonKeys = json.encode(notificationManager.notificationKeys)
			CSUserSDKManager:removeAllNotify(jsonKeys)
		else
			local jsonKeys = json.encode(getNotificationKeys())
			CSUserSDKManager:removeAllNotify(jsonKeys)
		end
	end
end
