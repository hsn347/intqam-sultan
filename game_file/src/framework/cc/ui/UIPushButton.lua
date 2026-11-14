local UIButton = requireLocal(".UIButton")
local UIPushButton = class("UIPushButton", UIButton)
UIPushButton.NORMAL = "normal"
UIPushButton.PRESSED = "pressed"
UIPushButton.DISABLED = "disabled"
function UIPushButton:ctor(images, options)
	UIPushButton, _UPVALUE4_ = nil, nil
	_UPVALUE2_, (nil).name = nil, "disable"
	;(nil).from, (nil)[1] = nil, "normal"
	;(nil).from, (nil)[2] = nil, "pressed"
	UIPushButton, (nil).to = nil, "disabled"
	_ENV, (nil).name = "normal", "enable"
	;(nil).from, ("normal")[1] = "normal", "disabled"
	UIPushButton, (nil).to = "normal", "normal"
	;("normal").name = "press"
	;("normal").from = "normal"
	UIPushButton, ("normal").to = "disabled", "pressed"
	;("disabled").name = "release"
	;("disabled").from = "pressed"
	;("disabled").to = "normal"
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = "normal"
	;(nil)[4] = "disabled"
	UIPushButton.super.ctor(self, nil, "normal", options)
	if type(images) ~= "table" then
		UIPushButton = type(images)
		images, type(images).normal = type(images), images
	end
	self:setButtonImage(UIPushButton.NORMAL, images.normal, true)
	self:setButtonImage(UIPushButton.PRESSED, images.pressed, true)
	self:setButtonImage(UIPushButton.DISABLED, images.disabled, true)
end
function UIPushButton:setButtonImage(state, image, ignoreEmpty)
	assert(state == UIPushButton.NORMAL or state == UIPushButton.PRESSED or state == UIPushButton.DISABLED, string.format("UIPushButton:setButtonImage() - invalid state %s", tostring(state)))
	UIPushButton.super.setButtonImage(self, state, image, ignoreEmpty)
	if state == UIPushButton.NORMAL then
		if not self.images_[UIPushButton.PRESSED] then
			self.images_[UIPushButton.PRESSED] = image
		end
		if not self.images_[UIPushButton.DISABLED] then
			self.images_[UIPushButton.DISABLED] = image
		end
	end
	return self
end
function UIPushButton:onTouch_(event)
	local name, x, y = event.name, event.x, event.y
	if name == "began" then
		self.touchBeganX = x
		self.touchBeganY = y
		if not self:checkTouchInSprite_(x, y) then
			return false
		end
		self.fsm_:doEvent("press")
		UIButton = "press"
		;("press").name = UIButton.PRESSED_EVENT
		;("press").x = x
		;("press").y = y
		;("press").touchInTarget = true
		self:dispatchEvent("press")
		return true
	end
	local touchInTarget = self:checkTouchInSprite_(self.touchBeganX, self.touchBeganY) and self:checkTouchInSprite_(x, y)
	if name == "moved" then
		if touchInTarget and self.fsm_:canDoEvent("press") then
			self.fsm_:doEvent("press")
			UIButton = "press"
			;("press").name = UIButton.PRESSED_EVENT
			;("press").x = x
			;("press").y = y
			;("press").touchInTarget = true
			self:dispatchEvent("press")
		elseif not touchInTarget and self.fsm_:canDoEvent("release") then
			self.fsm_:doEvent("release")
			UIButton = "release"
			;("release").name = UIButton.RELEASE_EVENT
			;("release").x = x
			;("release").y = y
			;("release").touchInTarget = false
			self:dispatchEvent("release")
		end
	else
		if self.fsm_:canDoEvent("release") then
			self.fsm_:doEvent("release")
			UIButton = "release"
			;("release").name = UIButton.RELEASE_EVENT
			;("release").x = x
			;("release").y = y
			;("release").touchInTarget = touchInTarget
			self:dispatchEvent("release")
		end
		if name == "ended" and touchInTarget then
			UIButton = "release"
			;("release").name = UIButton.CLICKED_EVENT
			;("release").x = x
			;("release").y = y
			;("release").touchInTarget = true
			self:dispatchEvent("release")
		end
	end
end
return UIPushButton
