local m = fgui.GButton
_ENV = nil
;(nil).SELECTED = 0
m.EventType, (nil).UNSELECTED = nil, 1
function m:addEventListener(callback, param2)
	if param2 then
		fgui.GObject.addEventListener(self, callback, param2)
		return
	end
	fgui.GObject.addEventListener(self, fgui.UIEventType.Changed, function()
		local eventID = self:isSelected() and ccui.CheckBoxEventType.selected or ccui.CheckBoxEventType.unselected
		callback(self, eventID)
	end)
end
function m:create(normalImage, selectedImage, disableImage, texType)
	local button = fgui.UIPackage.CreateObject1("Base", "BaseButton")
	button.isCocos = true
	button:ignoreContentAdaptWithSize(true)
	button:setPosition(0, 0)
	print("GButton:create", normalImage, selectedImage, disableImage, texType)
	button:init(normalImage, selectedImage, disableImage, texType)
	return button
end
function m:init(normalImage, selectedImage, disableImage, texType)
	print("GButton:init", normalImage, selectedImage, disableImage, texType)
	self:loadTextures(normalImage, selectedImage, disableImage, texType)
end
function m:getDescription()
	return "GButton"
end
function m:getTitleRenderer()
	return self:getChild("title")
end
function m:getTitleText()
	return self:getTitle()
end
function m:getVirtualRenderer()
	return self:getChild("icon")
end
function m:getZoomScale()
	print_error("暂未实现GButton:getZoomScale")
end
function m:setTitleText(text)
	self:setTitle(text)
end
function m:setZoomScale(scale)
	self.downEffectValue = 1 + scale
end
function m:setButtonType(buttonType)
end
