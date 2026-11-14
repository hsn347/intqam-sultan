local _ENV, device
device.platform = "unknown"
device.model = "unknown"
local sharedApplication = cc.Application:getInstance()
local target = sharedApplication:getTargetPlatform()
if target == cc.PLATFORM_OS_WINDOWS then
	device.platform = "windows"
	device.platform = "mac"
elseif target == cc.PLATFORM_OS_MAC then
	device.platform = "mac"
elseif target == cc.PLATFORM_OS_ANDROID then
	device.platform = "android"
elseif target == cc.PLATFORM_OS_IPHONE or target == cc.PLATFORM_OS_IPAD then
	device.platform = "ios"
	local director = cc.Director:getInstance()
	local view = director:getOpenGLView()
	local framesize = view:getFrameSize()
	local w, h = framesize.width, framesize.height
	print("framesize.width ", framesize.width)
	print("framesize.height ", framesize.height)
	if w == 640 and h == 960 then
		device.model = "iphone 4"
	elseif w == 640 and h == 1136 then
		device.model = "iphone 5"
	elseif w == 750 and h == 1334 then
		device.model = "iphone 6"
	elseif w == 1242 and h == 2208 then
		device.model = "iphone 6 plus"
	elseif w == 1125 and h == 2436 then
		device.model = "iphone X"
	elseif w == 768 and h == 1024 then
		device.model = "ipad"
	elseif w == 1536 and h == 2048 then
		device.model = "ipad retina"
	elseif w == 750 and h == 1624 then
		device.model = "iphone XR"
	elseif w == 1125 and h == 2436 then
		device.model = "iphone XS"
	elseif w == 1242 and h == 2688 then
		device.model = "iphone XS Max"
	elseif w == 828 and h == 1792 then
		device.model = "iphone 11"
	elseif w == 1170 and h == 2532 then
		device.model = "iphone 12"
	elseif w == 1284 and h == 2778 then
		device.model = "iphone 12 pro max"
	elseif w == 1080 and h == 2340 then
		device.model = "iphone 12 mini"
	end
elseif target == cc.PLATFORM_OS_WINRT then
	device.platform = "winrt"
elseif target == cc.PLATFORM_OS_WP8 then
	device.platform = "wp8"
end
local language_ = sharedApplication:getCurrentLanguage()
if language_ == cc.LANGUAGE_CHINESE then
	language_ = "cn"
elseif language_ == cc.LANGUAGE_FRENCH then
	language_ = "fr"
elseif language_ == cc.LANGUAGE_ITALIAN then
	language_ = "it"
elseif language_ == cc.LANGUAGE_GERMAN then
	language_ = "gr"
elseif language_ == cc.LANGUAGE_SPANISH then
	language_ = "sp"
elseif language_ == cc.LANGUAGE_RUSSIAN then
	language_ = "ru"
elseif language_ == cc.LANGUAGE_KOREAN then
	language_ = "kr"
elseif language_ == cc.LANGUAGE_JAPANESE then
	language_ = "ja"
elseif language_ == cc.LANGUAGE_HUNGARIAN then
	language_ = "hu"
elseif language_ == cc.LANGUAGE_PORTUGUESE then
	language_ = "pt"
elseif language_ == cc.LANGUAGE_ARABIC then
	language_ = "ar"
else
	language_ = "en"
end
_ENV = cc.LANGUAGE_ARABIC
cc.LANGUAGE_ARABIC.ipad = true
device.iPadModeList, cc.LANGUAGE_ARABIC["ipad retina"] = cc.LANGUAGE_ARABIC, true
local specialLangTrans = function(code)
	code = tostring(code)
	if code == "in" then
		code = "id"
	elseif code == "zh" then
		code = "zh-CN"
	end
	return code
end
device.language = specialLangTrans(sharedApplication:getCurrentLanguageCode())
device.writablePath = cc.FileUtils:getInstance():getWritablePath()
device.directorySeparator = "/"
device.pathSeparator = ":"
if target == cc.PLATFORM_OS_WINDOWS then
	device.directorySeparator = "\\"
	device.pathSeparator = ";"
end
printInfo("# device.platform              = " .. device.platform)
printInfo("# device.model                 = " .. device.model)
print("device.language = ", device.language)
printInfo("# device.language              = " .. device.language)
printInfo("# device.writablePath          = " .. device.writablePath)
printInfo("# device.directorySeparator    = " .. device.directorySeparator)
printInfo("# device.pathSeparator         = " .. device.pathSeparator)
printInfo("#")
function device.showActivityIndicator()
	if DEBUG > 1 then
		printInfo("device.showActivityIndicator()")
	end
	cc.Native:showActivityIndicator()
end
function device.hideActivityIndicator()
	if DEBUG > 1 then
		printInfo("device.hideActivityIndicator()")
	end
	cc.Native:hideActivityIndicator()
end
function device.showAlert(title, message, buttonLabels, listener)
	if type(buttonLabels) ~= "table" then
		_ENV = type(buttonLabels)
		buttonLabels, type(buttonLabels)[1] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[2] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[3] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[4] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[5] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[6] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[7] = type(buttonLabels), tostring(buttonLabels)
		buttonLabels, type(buttonLabels)[8] = type(buttonLabels), tostring(buttonLabels)
	else
		table.map(buttonLabels, function(v)
			return tostring(v)
		end)
	end
	print("device.showAlert")
	if DEBUG > 1 then
		printInfo("device.showAlert() - title: %s", title)
		printInfo("    message: %s", message)
		printInfo("    buttonLabels: %s", table.concat(buttonLabels, ", "))
	end
	if device.platform == "android" then
		local tempListner = function(event)
			if type(event) == "string" then
				event = require("framework.json").decode(event)
				event.buttonIndex = tonumber(event.buttonIndex)
			end
			if listener then
				listener(event)
			end
		end
		_UPVALUE4_ = table.concat(buttonLabels, ", ")
		table.concat(buttonLabels, ", ")[1] = title
		table.concat(buttonLabels, ", ")[2] = message
		table.concat(buttonLabels, ", ")[3] = buttonLabels
		table.concat(buttonLabels, ", ")[4] = tempListner
		luaj.callStaticMethod("org/cocos2dx/utils/PSNative", "createAlert", table.concat(buttonLabels, ", "))
	else
		local defaultLabel = ""
		if 0 < #buttonLabels then
			defaultLabel = buttonLabels[1]
			table.remove(buttonLabels, 1)
		end
		cc.Native:createAlert(title, message, defaultLabel)
		for i, label in ipairs(buttonLabels) do
			cc.Native:addAlertButton(label)
		end
		if type(listener) ~= "function" then
			function listener()
			end
		end
		cc.Native:showAlert(listener)
	end
end
function device.cancelAlert()
	if DEBUG > 1 then
		printInfo("device.cancelAlert()")
	end
	cc.Native:cancelAlert()
end
function device.getOpenUDID()
	local ret = cc.Native:getOpenUDID()
	if DEBUG > 1 then
		printInfo("device.getOpenUDID() - Open UDID: %s", tostring(ret))
	end
	return ret
end
function device.openURL(url)
	if not url then
		printInfo("can not open a nil url")
		return
	end
	if DEBUG > 1 then
		printInfo("device.openURL() - url: %s", tostring(url))
	end
	local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
	CSUserSDKManager:openSDKWebLink(url)
end
function device.showInputBox(title, message, defaultValue)
	title = tostring(title or "INPUT TEXT")
	message = tostring(message or "INPUT TEXT, CLICK OK BUTTON")
	defaultValue = tostring(defaultValue or "")
	if DEBUG > 1 then
		printInfo("device.showInputBox() - title: %s", tostring(title))
		printInfo("    message: %s", tostring(message))
		printInfo("    defaultValue: %s", tostring(defaultValue))
	end
	return cc.Native:getInputText(title, message, defaultValue)
end
function device.isIpadMode()
	if device.platform ~= "ios" then
		return false
	end
	return false
end
local sharedDirector = cc.Director:getInstance()
local winSize = sharedDirector:getWinSize()
local safeArea = CS.UnityEngine.Screen.safeArea
local isHaveSaveArea = safeArea.height ~= CS.UnityEngine.Screen.height
local _isIPhoneNotchScreen
function device.isIphoneXMode()
	if _isIPhoneNotchScreen ~= nil then
		return _isIPhoneNotchScreen
	end
	if device.platform == "ios" then
		local CSUserSDKManager = CS.Sultan.Manager.UserSDKManager.GetInstance()
	elseif winSize.width / winSize.height >= 0.75 then
	else
		print("isHaveSaveArea", isHaveSaveArea, winSize.width / winSize.height, 0.46176046176046176, winSize.width / winSize.height < 0.46176046176046176)
		if isHaveSaveArea or winSize.width / winSize.height < 0.46176046176046176 then
		else
		end
	end
	return _isIPhoneNotchScreen
end
return device
