_ENV = nil
;(nil).waitAvatar, _ENV, (nil).queueCount = nil, nil, 0
;(nil).isAvatarInit = false
_ENV, SoraDPlayerHeadManager, (nil).isHead = nil, nil, true
;(nil).success = 1
local (nil).fail, DOWNLOAD_EVENT = 2, nil
local _ENV, downloadList
function SoraDGetPictureFromManager(target, picUrl)
	local isBig
	if picUrl ~= "" then
		if SoraDPlayerHeadManager[picUrl] == nil then
			SoraDPlayerHeadManager[picUrl], (nil).target, _ENV, _ENV = nil, nil, nil, nil
		end
		SoraDPlayerHeadManager.isHead = false
		target.curlKey = picUrl
		table.insert(SoraDPlayerHeadManager[picUrl].target, target)
		if SoraDPlayerHeadManager.queueCount < 1 then
			SoraDPlayerHeadManager.queueCount = SoraDPlayerHeadManager.queueCount + 1
		else
			_ENV = target
			target.avatar = picUrl
			target.isBig = isBig
			table.insert(SoraDPlayerHeadManager.waitAvatar, target)
		end
		SoraDPlayerHeadDownload(picUrl, nil, false)
	else
		target.curlKey = nil
	end
end
function SoraDGetHeadFromManager(target, headID, avatar, isBig)
	avatar = avatar or ""
	local lordLocalData = include("lordLocalData")
	local headImg = ""
	SoraDPlayerHeadManager.isHead = true
	if SoraDPlayerHeadManager[avatar] and (not (not SoraDPlayerHeadManager[avatar].curl or isBig) or isBig and SoraDPlayerHeadManager[avatar].bigCurl) then
		if isBig then
			headImg = SoraDPlayerHeadManager[avatar].bigCurl
		else
			headImg = SoraDPlayerHeadManager[avatar].curl
		end
		if target.curlKey then
			target.curlKey = nil
		end
		SoraDUpdateHeadFromManager(target, headImg, true, isBig)
	else
		headImg = lordLocalData.getHead(headID)
		SoraDUpdateHeadFromManager(target, headImg)
		if avatar ~= "" then
			if SoraDPlayerHeadManager[avatar] == nil then
				SoraDPlayerHeadManager[avatar], target.target, _ENV, _ENV = target, headImg, headImg, target
			end
			target.curlKey = avatar
			table.insert(SoraDPlayerHeadManager[avatar].target, target)
			if SoraDPlayerHeadManager.queueCount < 1 then
				SoraDPlayerHeadManager.queueCount = SoraDPlayerHeadManager.queueCount + 1
				SoraDPlayerHeadDownload(avatar, isBig, true)
			else
				_ENV = isBig
				isBig.avatar = avatar
				isBig.isBig = isBig
				table.insert(SoraDPlayerHeadManager.waitAvatar, isBig)
			end
		else
			target.curlKey = nil
		end
	end
end
function SoraDHasHeadFromManager(avatar, isBig)
	local ret = false
	if SoraDPlayerHeadManager[avatar] then
		if isBig and SoraDPlayerHeadManager[avatar].bigCurl then
			ret = true
		elseif SoraDPlayerHeadManager[avatar].curl and not isBig then
			ret = true
		end
	end
	return ret
end
function SoraDUpdateHeadFromManager(target, headImg, frmoSDK, isBig)
	local targetType = tolua.type(target)
	if frmoSDK and cc.SpriteFrameCache:getInstance():getSpriteFrame(headImg):isDefault() then
		local oriWidth = isBig and 300 or 100
		local texture = cc.Director:getInstance():getTextureCache():addImage(headImg)
		if texture == nil then
			return
		end
		print("slkdjfsljfsdkljf", SoraDPlayerHeadManager.isHead)
		local rect = cc.rect(0.5 * math.max(0, texture:getContentSize().width - oriWidth), 0.5 * math.max(0, texture:getContentSize().height - oriWidth), math.min(oriWidth, texture:getContentSize().width), math.min(oriWidth, texture:getContentSize().height))
		if not SoraDPlayerHeadManager.isHead then
			oriWidth = texture:getContentSize().width
			oriHeight = texture:getContentSize().height
			rect = cc.rect(0.5 * math.max(0, texture:getContentSize().width - oriWidth), 0.5 * math.max(0, texture:getContentSize().height - oriHeight), texture:getContentSize().width, texture:getContentSize().height)
		end
		local frame = cc.SpriteFrame:createWithTexture(texture, rect)
		cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, headImg)
	end
	print("targetType,headImg=======", targetType, headImg)
	if targetType == "cc.Sprite" or targetType == "FairyGUI.GLabel" or targetType == "FairyGUI.GSprite" then
		target:setSpriteFrame(headImg)
	elseif targetType == "ccui.ImageView" then
		target:loadTexture(headImg, ccui.TextureResType.plistType)
	elseif targetType == "fgui.GLoader" or targetType == "FairyGUI.GLoader" then
		target:setURL(headImg)
	elseif targetType == "fgui.GLabel" then
		target:setIcon(headImg)
	else
		print("不支持的类型：" .. targetType)
	end
end
function SoraDSetHeadToManager(avatar, curl, isBig)
	print("SoraDSetHeadToManager " .. avatar .. "     " .. curl)
	SoraDPlayerHeadManager.queueCount = math.max(SoraDPlayerHeadManager.queueCount - 1, 0)
	if SoraDPlayerHeadManager[avatar] == nil then
		if isBig then
			math.max(SoraDPlayerHeadManager.queueCount - 1, 0).target, _ENV, _ENV = SoraDPlayerHeadManager.queueCount - 1, SoraDPlayerHeadManager.queueCount - 1, math.max(SoraDPlayerHeadManager.queueCount - 1, 0)
			SoraDPlayerHeadManager[avatar], math.max(SoraDPlayerHeadManager.queueCount - 1, 0).bigCurl = math.max(SoraDPlayerHeadManager.queueCount - 1, 0), curl
		else
			math.max(SoraDPlayerHeadManager.queueCount - 1, 0).target, _ENV, _ENV = SoraDPlayerHeadManager.queueCount - 1, SoraDPlayerHeadManager.queueCount - 1, math.max(SoraDPlayerHeadManager.queueCount - 1, 0)
			SoraDPlayerHeadManager[avatar], math.max(SoraDPlayerHeadManager.queueCount - 1, 0).curl = math.max(SoraDPlayerHeadManager.queueCount - 1, 0), curl
		end
	elseif isBig then
		SoraDPlayerHeadManager[avatar].bigCurl = curl
	else
		SoraDPlayerHeadManager[avatar].curl = curl
		for i, v in ipairs(SoraDPlayerHeadManager[avatar].target) do
			if not tolua.isnull(v) then
				if v.curlKey == avatar then
					SoraDUpdateHeadFromManager(v, curl, true)
				end
				if v.curlKey then
					v.curlKey = nil
				end
			end
		end
		SoraDPlayerHeadManager[avatar].target, _ENV = ipairs(SoraDPlayerHeadManager[avatar].target)
	end
	if 0 < #SoraDPlayerHeadManager.waitAvatar then
		local waitAvatar = table.remove(SoraDPlayerHeadManager.waitAvatar)
		if not SoraDPlayerHeadManager[avatar] or not SoraDPlayerHeadManager[avatar].curl then
			SoraDPlayerHeadManager.queueCount = SoraDPlayerHeadManager.queueCount + 1
			SoraDPlayerHeadDownload(waitAvatar.avatar, waitAvatar.isBig)
		end
	end
end
function SoraDCleanHeadManager()
	local isAvatarInit = SoraDPlayerHeadManager.isAvatarInit
	_ENV = nil
	;(nil).waitAvatar, _ENV, (nil).queueCount = nil, nil, 0
	SoraDPlayerHeadManager, (nil).isAvatarInit = nil, isAvatarInit
end
function SoraDPlayerHeadExist(avatar, isBig)
	local writabelPath = cc.FileUtils:getInstance():getWritablePath()
	local storagePath = string.gsub(writabelPath .. avatar, "//", "/")
	if isBig then
		storagePath = string.gsub(storagePath, "[0-9]+x[0-9]+_", "")
	end
	if cc.FileUtils:getInstance():isFileExist(storagePath) then
		SoraDSetHeadToManager(avatar, storagePath, isBig)
		if isBig then
			SoraDDelayCallOnce(avatar, function()
				_ENV = nil
				;(nil).msg = "MESSAGE_LORDINFO_BIG_HEAD"
				;(nil).avatar = avatar
				;(nil).ret = true
				SoraDSendMessage(nil)
			end)
		end
		return true
	end
	return false
end
function SoraDPlayerHeadDownload(avatar, isBig, isHead)
	if SoraDPlayerHeadExist(avatar, isBig) then
		return
	end
	if isBig then
		avatar = string.gsub(avatar, "[0-9]+x[0-9]+_", "")
	end
	if downloadList[avatar] then
		return
	else
		downloadList[avatar] = true
	end
	local url = avatar
	if isHead then
		url = userSDKManager.getAvatarURL(avatar)
	end
	if not SoraDPlayerHeadManager.isAvatarInit then
		SoraDInitAvatarDownloadHandle()
	end
	DownloadManager:getInstance():downloadHead(url, avatar)
end
function SoraDInitAvatarDownloadHandle()
	SoraDPlayerHeadManager.isAvatarInit = true
	DownloadManager:getInstance():setAvatarListener(function(event, avatar, localPath)
		if event == DOWNLOAD_EVENT.success and SoraDSetHeadToManager then
			local subValue, num = string.gsub(avatar, "[0-9]+x[0-9]+_", "")
			local isBig = false
			local avatar = avatar
			local localPath = localPath
			local oriUrl = "/"
			if num == 0 then
				isBig = true
				local urlTbl = SoraDStringsSplit(avatar, "/")
				for i, v in ipairs(urlTbl) do
					if v ~= "" then
						if i == #urlTbl then
							oriUrl = oriUrl .. "108x108_" .. v
						else
							oriUrl = oriUrl .. v .. "/"
						end
					end
				end
				avatar = oriUrl
			end
			SoraDSetHeadToManager(avatar, localPath, isBig)
			if isBig then
				SoraDDelayCallOnce(oriUrl, function()
					_ENV = nil
					;(nil).msg = "MESSAGE_LORDINFO_BIG_HEAD"
					;(nil).avatar = oriUrl
					;(nil).ret = true
					SoraDSendMessage(nil)
				end)
			end
		elseif event == DOWNLOAD_EVENT.fail then
			print("download avatar error", avatar)
		end
	end)
end
