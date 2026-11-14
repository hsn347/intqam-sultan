local m = fgui.GSlider
function m:addEventListener(callback, param2)
	if param2 then
		fgui.GObject.addEventListener(self, callback, param2)
		return
	end
	fgui.GObject.addEventListener(self, fgui.UIEventType.Changed, function()
		callback(self, ccui.SliderEventType.percentChanged)
	end)
end
function m:create(barTextureName, normalBallTextureName, resType)
	local slider = fgui.UIPackage.CreateObject1("Base", "BaseSlider")
	slider:setPosition(0, 0)
	slider:loadBarTexture(barTextureName, resType)
	slider:loadSlidBallTextureNormal(normalBallTextureName, resType)
	return slider
end
function m:getBar()
	return self:getChild("bar") or self:getChild("bar_v")
end
function m:getDescription()
	return "GSlider"
end
function m:getGrip()
	return self:getChild("grip")
end
function m:getPercent()
	return 100 * self:getValue() / self:getMax()
end
function m:getSlidBallRenderer()
	return self
end
function m:getZoomScale()
	return self:getGrip():getZoomScale()
end
function m:loadBarTexture(fileName, resType)
	self:getBar():loadTexture(fileName, resType)
end
function m:loadProgressBarTexture(fileName, resType)
	self:getBar():loadTexture(fileName, resType)
end
function m:loadSlidBallTextures(normal, pressed, disabled, texType)
	self:getGrip():loadTexture(normal, pressed, disabled, texType)
end
function m:setPercent(percent)
	self:setValue(percent / 100 * self:getMax())
end
function m:setZoomScale(scale)
	self:getGrip():setZoomScale(scale)
end
function m:setCapInsetProgressBarRebderer(capInsets)
	self:setCapInsets(capInsets)
end
