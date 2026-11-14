local baseFguiPanel = require("fgui.base.baseFguiPanel")
local useDownloadImagePanel = class("useDownloadImagePanel", baseFguiPanel)
function useDownloadImagePanel:ctor(...)
	useDownloadImagePanel.super.ctor(self, ...)
	self.freeImagesOnExit = true
	self.arrayImagesPath = nil
	SoraDAddMessage(self.proxy, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.onKeyFileDownloadSuccess))
end
function useDownloadImagePanel:onExit(...)
	self:freeImages()
	useDownloadImagePanel.super.onExit(self, ...)
end
function useDownloadImagePanel:beforeLoadImages(imgArray, callFunc)
	if not imgArray or not next(imgArray) then
		return
	end
	self.loadImgArray = imgArray
	self.loadCallFunc = callFunc
	local canLoad = true
	self.fileExistList, _ENV = imgArray, imgArray
	for _, v in ipairs(imgArray) do
		local ret = SoraDIsFileExistByKey(v.key)
		print(v.name .. " ret = ", ret)
		if not ret then
			canLoad = false
		end
		self.fileExistList[v.key] = ret or false
	end
	if canLoad then
		self:loadImages(imgArray, callFunc)
	end
end
function useDownloadImagePanel:loadImages(array, callFunc)
	if not array or not next(array) then
		return
	end
	local index = 0
	for k, v in pairs(array) do
		if not self.arrayImagesPath then
			_ENV = self.arrayImagesPath
		end
		self.arrayImagesPath = self.arrayImagesPath
		table.insert(self.arrayImagesPath, v)
		local plistName = v.name .. ".plist"
		display.addSpriteFrames(plistName, imageName, function(plist)
			if not self.__cname then
				print("对象已经被释放")
				return
			end
			print("加载资源: " .. plistName)
			v.isLoadOK = true
			if index >= #array and callFunc then
				callFunc()
			end
		end)
	end
end
function useDownloadImagePanel:freeImages()
	if not self.freeImagesOnExit then
		return
	end
	if not self.arrayImagesPath then
		return
	end
	print("==useDownloadImagePanel:freeImages==")
	dump(self.arrayImagesPath, "==self.arrayImagesPath==")
	for k, v in pairs(self.arrayImagesPath) do
		if v.isLoadOK then
			local plistName = v.name .. ".plist"
			local imageName = getImageFileNameByPlatform(v.name, v.format)
			imageManager.unuseImage(imageName)
			imageManager.unusePlist(plistName)
			if device.platform == "android" then
				imageManager.unuseImage(v.name .. "_alpha.pkm")
			end
		end
	end
end
function useDownloadImagePanel:onKeyFileDownloadSuccess(target, data)
	print("==useDownloadImagePanel:onKeyFileDownloadSuccess==", data.key)
	if self.fileExistList[data.key] == false then
		self.fileExistList[data.key] = true
		local canLoad = true
		for k, v in pairs(self.fileExistList) do
			if not v then
				canLoad = false
				break
			end
		end
		if canLoad then
			self:loadImages(self.loadImgArray, self.loadCallFunc)
		end
	end
end
return useDownloadImagePanel
