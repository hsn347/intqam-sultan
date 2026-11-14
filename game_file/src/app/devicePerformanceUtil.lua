local util = CS.Sultan.Game.DevicePerformanceUtil
local _ENV, devicePerformanceUtil
_ENV, devicePerformanceUtil.isSetFirstTimes = nil, false
;(nil).Low = 0
;(nil).Mid = 1
local (nil).High, devicePerformanceLevel = 2, nil
local _ENV, deviceModelMap
devicePerformanceUtil.curLevel = devicePerformanceLevel.Mid
devicePerformanceUtil.memoryLevel = devicePerformanceLevel.Mid
function devicePerformanceUtil.getDevicePerformanceLevel()
	local level = SoraDConfigGet("System:GameOptionsView:grapicsQuality~integer")
	if level then
		devicePerformanceUtil.isSetFirstTimes = false
		return level
	end
	devicePerformanceUtil.isSetFirstTimes = true
	if device.platform == "window" or device.platform == "mac" then
		return devicePerformanceLevel.High
	end
	local deviceModel = util.GetDeviceModel()
	if deviceModelMap[deviceModel] ~= nil then
		return deviceModelMap[deviceModel]
	end
	local processorCount = util.GetProcessorCount()
	local memorySize = util.GetMemorySize()
	local graphicsMemorySize = util.GetGraphicsMemorySize()
	local graphicsDeviceVendorID = util.GetGraphicsDeviceVendorID()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	if graphicsDeviceVendorID == 32902 then
		return devicePerformanceLevel.Low
	end
	if device.platform == "ios" and processorCount < 2 then
		return devicePerformanceLevel.Low
	end
	if device.platform == "android" and processorCount <= 4 then
		return devicePerformanceLevel.Low
	end
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 3200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
end
function devicePerformanceUtil.getCurMemoryLevel()
	return devicePerformanceUtil.memoryLevel
end
function devicePerformanceUtil.setQualitySetting()
	local level = devicePerformanceLevel.Mid
	xpcall(function()
	end, function()
		_G.sendTraceBackLog("Error = devicePerformanceUtil.setQualitySetting\n" .. debug.traceback(), nil, nil, true)
	end)
	devicePerformanceUtil.setQualityLevel(level, true)
	devicePerformanceUtil.memoryLevel = devicePerformanceUtil.getMemoryLevel()
end
function devicePerformanceUtil.setQualityLevel(level, isFromInit)
	util = nil
	;(nil)[1] = level
	;(nil)[2] = devicePerformanceLevel.High
	dump(nil, "devicePerformanceUtil.getDevicePerformanceLevel")
	if level == devicePerformanceLevel.Low then
		if device.platform == "ios" then
			util.SetTargetFrameRate(30)
		elseif device.platform == "mac" then
			util.SetTargetFrameRate(30)
		else
			util.SetTargetFrameRate(60)
		end
		util.SetTotalParticleScale(0.33)
		util.SetUrpRenderScale(0.75)
	elseif level == devicePerformanceLevel.Mid then
		if device.platform == "ios" then
			util.SetTargetFrameRate(30)
		else
			util.SetTargetFrameRate(60)
		end
		util.SetTotalParticleScale(0.66)
		util.SetUrpRenderScale(1.0)
	elseif level == devicePerformanceLevel.High then
		util.SetTargetFrameRate(60)
		util.SetTotalParticleScale(1.0)
		util.SetUrpRenderScale(1.0)
	else
		util.SetTargetFrameRate(60)
		util.SetTotalParticleScale(0.66)
		util.SetUrpRenderScale(1.0)
	end
	devicePerformanceUtil.curLevel = level
	if not isFromInit then
		_ENV = "devicePerformanceUtil.getDevicePerformanceLevel"
		;("devicePerformanceUtil.getDevicePerformanceLevel").choose = level + 1
		userSDKManager.logEvent(gSDKDef.TDonEvent.image_quality_selection, "devicePerformanceUtil.getDevicePerformanceLevel")
	end
end
function devicePerformanceUtil.getCurQualityLevel()
	return devicePerformanceUtil.curLevel
end
_ENV, devicePerformanceUtil.getMemoryLevel = function()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	local memorySize = util.GetMemorySize()
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 4200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	return devicePerformanceLevel.High
end, function()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	local memorySize = util.GetMemorySize()
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 4200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	return devicePerformanceLevel.High
end
;(function()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	local memorySize = util.GetMemorySize()
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 4200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	return devicePerformanceLevel.High
end)[devicePerformanceLevel.Low] = 20
;(function()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	local memorySize = util.GetMemorySize()
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 4200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	return devicePerformanceLevel.High
end)[devicePerformanceLevel.Mid] = 30
local (function()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	local memorySize = util.GetMemorySize()
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 4200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	return devicePerformanceLevel.High
end)[devicePerformanceLevel.High], moveLineLimit = 40, function()
	local is32Bits = util.GetIs32Bits()
	if is32Bits then
		return devicePerformanceLevel.Low
	end
	local isGooglePlayGamePC = util.GetIsGooglePlayGamePC()
	if isGooglePlayGamePC then
		return devicePerformanceLevel.High
	end
	local memorySize = util.GetMemorySize()
	if device.platform == "ios" then
		if 3600 <= memorySize then
			return devicePerformanceLevel.High
		elseif 2100 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	if device.platform == "android" then
		if 7000 <= memorySize then
			return devicePerformanceLevel.High
		elseif 4200 <= memorySize then
			return devicePerformanceLevel.Mid
		else
			return devicePerformanceLevel.Low
		end
	end
	return devicePerformanceLevel.High
end
_ENV, devicePerformanceUtil.getLimitLineNum = function()
	return moveLineLimit[devicePerformanceUtil.curLevel]
end, function()
	return moveLineLimit[devicePerformanceUtil.curLevel]
end
;(function()
	return moveLineLimit[devicePerformanceUtil.curLevel]
end)[devicePerformanceLevel.Low] = 10
;(function()
	return moveLineLimit[devicePerformanceUtil.curLevel]
end)[devicePerformanceLevel.Mid] = 15
local (function()
	return moveLineLimit[devicePerformanceUtil.curLevel]
end)[devicePerformanceLevel.High], buildingLimit = 50, function()
	return moveLineLimit[devicePerformanceUtil.curLevel]
end
function devicePerformanceUtil.getLimitBuildingNum()
	return buildingLimit[devicePerformanceUtil.curLevel]
end
function devicePerformanceUtil.resetQuality()
	local level = devicePerformanceUtil.curLevel
	devicePerformanceUtil.setQualityLevel(level, false)
end
function devicePerformanceUtil.setFPS(fps)
	util.SetTargetFrameRate(fps)
end
function devicePerformanceUtil.dump()
	local str = "设备信息"
	local resolution = util.GetResolution()
	str = str .. "\n当前设备评级：" .. devicePerformanceUtil.curLevel
	str = str .. "\n当前设备帧率：" .. util.GetTargetFrameRate()
	str = str .. "\n当前设备粒子缩放：" .. util.GetTotalParticleScale()
	str = str .. "\n当前设备URP缩放：" .. util.GetUrpRenderScale()
	str = str .. "\n设备分辨率：" .. resolution.x .. "x" .. resolution.y
	str = str .. "\n当前设备帧率：" .. util.GetTargetFrameRate()
	str = str .. "\n屏幕dpi：" .. util.GetScreenDpi()
	str = str .. "\n设备型号：" .. util.GetDeviceModel()
	str = str .. "\n设备核心数：" .. util.GetProcessorCount()
	str = str .. "\n设备内存：" .. util.GetMemorySize()
	str = str .. "\n设备显存：" .. util.GetGraphicsMemorySize()
	str = str .. "\n设备显卡：" .. util.GetGraphicsDeviceVendorID()
	str = str .. "\nCPU架构：" .. util.GetProcessorType()
	str = str .. "\n系统：" .. (util.GetIs32Bits() and "32" or "64") .. "位"
	str = str .. "\n是否是GooglePlayGamePC:" .. (util.GetIsGooglePlayGamePC() and "是" or "否")
	SoraDShowMsgBox(str)
end
function devicePerformanceUtil.sendSdkLog()
	print("devicePerformanceUtil.sendSdkLog true")
	_ENV = nil
	;(nil).choose = devicePerformanceUtil.curLevel + 1
	userSDKManager.logEvent(gSDKDef.TDonEvent.image_quality_selection, nil)
end
function devicePerformanceUtil.isGooglePlayGamePC()
	return util.GetIsGooglePlayGamePC()
end
return devicePerformanceUtil
