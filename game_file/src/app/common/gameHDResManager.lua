_ENV = nil
;(nil).waitLoad, _ENV, (nil).waitDownload, _ENV, (nil).isInit = nil, nil, nil, nil, false
;(nil).transparentPoint = nil
;(nil).curFile = ""
;(nil).isWiFi = nil
SoraDHDResManager, (nil).preTime = nil, 0
function SoraDIsFileExistByFileName(fileName, isSingle)
	isSingle = isSingle and isSingle or false
	if SoraDHDResManager.isInit then
		return fileName, BgAssetsManager:getInstance():isFileExistByFileName(fileName, isSingle)
	else
		return fileName, false
	end
end
function SoraDIsFileExistByKey(key)
	if SoraDHDResManager.isInit then
		return BgAssetsManager:getInstance():isFileExistByKey(key)
	else
		return false
	end
end
function SoraDInitHDResManager()
	SoraDHDResManager.isInit = false
	local url = "http://kohupdate.onemtservers.com/hd_res/res/"
	local storagePath = ""
	local resourceDataPath = ""
	local resourceDeleteDataPath = ""
	local key = device.platform
	local urlOtherName = "koh"
	if key == "windows" then
		key = "mac"
	end
	if userSDKManager.isBeta() then
		url = "http://10.0.0.194/" .. urlOtherName .. "/hd_res/res/" .. key .. "/"
	elseif key == "astc" then
		url = url .. "astc/"
	elseif key == "android" then
		url = url .. "android/"
	elseif key == "ios" then
		url = url .. "ios/"
	elseif key == "mac" then
		url = "http://10.0.0.194/" .. urlOtherName .. "/hd_res/res/" .. key .. "/"
	end
	storagePath = cc.FileUtils:getInstance():getWritablePath() .. "hd_res/"
	local nameKey = "Sultan"
	resourceDataPath = string.format("bgResource_%s_%s.data", key, nameKey)
	resourceDeleteDataPath = cc.FileUtils:getInstance():getWritablePath() .. "updatePackage/res/bgResource_" .. key .. "_delete.data"
	BgAssetsManager:getInstance():initData(url, storagePath, resourceDataPath, resourceDeleteDataPath, 3)
	BgAssetsManager:getInstance():setListener(function(state, fileName, errorMessage)
		print("state : " .. state .. " fileName : " .. fileName)
		if state == "download_progress" then
			_ENV = "state : " .. state .. " fileName : " .. fileName
			;("state : " .. state .. " fileName : " .. fileName).msg = "MESSAGE_FILE_DOWNLOAD_PROGRESS"
			;("state : " .. state .. " fileName : " .. fileName).file = fileName
			SoraDSendMessage("state : " .. state .. " fileName : " .. fileName)
			SoraDHDResManager.curFile = fileName
		elseif state == "download_file_success" then
			_ENV = "state : " .. state .. " fileName : " .. fileName
			;("state : " .. state .. " fileName : " .. fileName).msg = "MESSAGE_FILE_DOWNLOAD_SUCCESS"
			;("state : " .. state .. " fileName : " .. fileName).file = fileName
			SoraDSendMessage("state : " .. state .. " fileName : " .. fileName)
		elseif state == "download_key_success" then
			_ENV = "state : " .. state .. " fileName : " .. fileName
			;("state : " .. state .. " fileName : " .. fileName).msg = "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY"
			;("state : " .. state .. " fileName : " .. fileName).key = fileName
			SoraDSendMessage("state : " .. state .. " fileName : " .. fileName)
		elseif state == "download_fileCfg_error" then
			local msg = string.format("check [%s] ,Error:%s", fileName, errorMessage)
			print(msg)
			_G.sendTraceBackLog("[download_fileCfg_error]", nil, msg)
		elseif state == "download_finish" then
			if SoraDHDResManager.isWiFi and SoraDIsGameGuide() == nil then
				SoraDHDResManager.preTime = serviceFunctions.systemTime()
			end
		elseif state == "download_file_fail" then
			print("url = " .. url)
		end
	end)
	SoraDHDResManager.isWiFi = network.getInternetConnectionStatus() == gCCNetworkStatusReachableViaWiFi
	SoraDHDResManager.isInit = true
end
function SoraHDResDownloadByWIFIManager()
end
function SoraDCleanHDResManager()
	if SoraDHDResManager.isInit then
		BgAssetsManager:getInstance():clean()
	end
end
function SoraDHasActivieyBg(imgName)
	local fileext
	if device.platform == "android" then
		fileext = ".pkm"
	else
		fileext = ".png"
	end
	local imgFullName = imgName .. fileext
	return SoraDHasBg(imgFullName)
end
function SoraDHasBg(imgName)
	local imgFullName = "hd_res/singleTextures/" .. imgName
	local imageDanFullPath = cc.FileUtils:getInstance():getWritablePath() .. imgFullName
	if cc.FileUtils:getInstance():isFileExist(imageDanFullPath) then
		return true
	end
	return false
end
