local packageManager = require("fgui.base.packageManager")
local baseView = class("baseView", function(size, isColor, target)
	if target then
		return target
	end
	local view = ccui.Layout:create()
	view:setContentSize(size)
	if isColor == true then
		view:setBackGroundColorType(1)
		view:setBackGroundColor(cc.c3b(255, 0, 0))
		view:setBackGroundColorOpacity(100)
	end
	view:setAnchorPoint(0.5, 0.5)
	view:setPosition(display.cx, display.cy)
	view:setTouchEnabled(true)
	view:setSwallowTouches(true)
	return view
end)
function baseView:ctor()
	self:setNodeEventEnabled(true)
	self.freeImagesOnExit = true
	_UPVALUE0_, self.arrayImagesPath = self.setNodeEventEnabled, nil
	self.setNodeEventEnabled.ADType = false
	self.isADShow, self.setNodeEventEnabled.menuID = self.setNodeEventEnabled, 0
end
function baseView:setBackGround(opacity, color)
	if not self or tolua.isnull(self) then
		return
	end
	if not (self.setBackGroundColorType and self.setBackGroundColor) or not self.setBackGroundColorOpacity then
		return
	end
	color = color or cc.c3b(0, 0, 0)
	self:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	self:setBackGroundColor(color)
	self:setBackGroundColorOpacity(opacity)
end
function baseView:openTestType()
	self:setBackGround(204.0, cc.c3b(100, 100, 100))
end
function baseView:getPanelOffsetHeight()
	if self.isADShow.ADType then
		return display.height - RECHARGE_AD_HEIGHT
	else
		return display.height
	end
end
function baseView:onMessageListener()
end
function baseView:loadImages(array, callFunc)
	if array then
		local index = 0
		for k, v in pairs(array) do
			if not self.arrayImagesPath then
				_ENV = self.arrayImagesPath
			end
			self.arrayImagesPath = self.arrayImagesPath
			table.insert(self.arrayImagesPath, v)
			local plistName = v.name .. ".plist"
			local imageName = getImageFileNameByPlatform(v.name, v.format)
			display.addSpriteFrames(plistName, imageName, function(plist, image)
				imageManager.useImage(imageName)
				imageManager.usePlist(plistName)
				if not self.__cname or tolua.isnull(self) then
					print("对象已经被释放")
					imageManager.unuseImage(imageName)
					imageManager.unusePlist(plistName)
					if device.platform == "android" then
						imageManager.unuseImage(v.name .. "_alpha.pkm")
					end
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
end
function baseView:isImageLoad(fileName)
	if self.arrayImagesPath then
		for i, v in ipairs(self.arrayImagesPath) do
			if v.name == fileName then
				return true
			end
		end
	end
	return false
end
function baseView:freeImages()
	if not self.freeImagesOnExit then
		return
	end
	if self.arrayImagesPath then
		for k, v in pairs(self.arrayImagesPath) do
			local plistName = v.name .. ".plist"
			local imageName = getImageFileNameByPlatform(v.name, v.format)
			if v.isLoadOK then
				imageManager.unuseImage(imageName)
				imageManager.unusePlist(plistName)
				if device.platform == "android" then
					imageManager.unuseImage(v.name .. "_alpha.pkm")
				end
			end
		end
	end
end
function baseView:onEnterOther()
end
function baseView:onExitOther()
end
function baseView:onEnter()
	self:onMessageListener()
	self:onEnterOther()
end
function baseView:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
	self:freeImages()
	self:onExitOther()
end
return baseView
