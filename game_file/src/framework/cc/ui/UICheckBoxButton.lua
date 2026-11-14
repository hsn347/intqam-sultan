local UIButton = requireLocal(".UIButton")
local UICheckBoxButton = class("UICheckBoxButton", UIButton)
UICheckBoxButton.OFF = "off"
UICheckBoxButton.OFF_PRESSED = "off_pressed"
UICheckBoxButton.OFF_DISABLED = "off_disabled"
UICheckBoxButton.ON = "on"
UICheckBoxButton.ON_PRESSED = "on_pressed"
UICheckBoxButton.ON_DISABLED = "on_disabled"
function UICheckBoxButton:ctor(images, options)
	UICheckBoxButton, _UPVALUE12_ = nil, nil
	_UPVALUE2_, (nil).name = nil, "disable"
	;(nil).from, (nil)[1] = nil, "off"
	;(nil).from, (nil)[2] = nil, "off_pressed"
	UICheckBoxButton, (nil).to = nil, "off_disabled"
	_UPVALUE2_, (nil).name = "off", "disable"
	;(nil).from, ("off")[1] = "off", "on"
	;(nil).from, ("off")[2] = "off", "on_pressed"
	UICheckBoxButton, (nil).to = "off", "on_disabled"
	_ENV, ("off").name = "on", "enable"
	;("off").from, ("on")[1] = "on", "off_disabled"
	UICheckBoxButton, ("off").to = "on", "off"
	_ENV, ("on").name = "off_disabled", "enable"
	;("on").from, ("off_disabled")[1] = "off_disabled", "on_disabled"
	UICheckBoxButton, ("on").to = "off_disabled", "on"
	;("off_disabled").name = "press"
	;("off_disabled").from = "off"
	UICheckBoxButton, ("off_disabled").to = "on_disabled", "off_pressed"
	;("on_disabled").name = "press"
	;("on_disabled").from = "on"
	UICheckBoxButton, ("on_disabled").to = nil, "on_pressed"
	;(nil).name = "release"
	;(nil).from = "off_pressed"
	UICheckBoxButton, (nil).to = nil, "off"
	;(nil).name = "release"
	;(nil).from = "on_pressed"
	UICheckBoxButton, (nil).to = nil, "on"
	;(nil).name = "select"
	;(nil).from = "off"
	UICheckBoxButton, (nil).to = nil, "on"
	;(nil).name = "select"
	;(nil).from = "off_disabled"
	UICheckBoxButton, (nil).to = nil, "on_disabled"
	;(nil).name = "unselect"
	;(nil).from = "on"
	UICheckBoxButton, (nil).to = nil, "off"
	;(nil).name = "unselect"
	;(nil).from = "on_disabled"
	;(nil).to = "off_disabled"
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = "off"
	;(nil)[4] = "on"
	;(nil)[5] = "off_disabled"
	;(nil)[6] = "on_disabled"
	;(nil)[7] = nil
	;(nil)[8] = nil
	;(nil)[9] = nil
	;(nil)[10] = nil
	;(nil)[11] = nil
	;(nil)[12] = nil
	UICheckBoxButton.super.ctor(self, nil, "off", options)
	self:setButtonImage(UICheckBoxButton.OFF, images.off, true)
	self:setButtonImage(UICheckBoxButton.OFF_PRESSED, images.off_pressed, true)
	self:setButtonImage(UICheckBoxButton.OFF_DISABLED, images.off_disabled, true)
	self:setButtonImage(UICheckBoxButton.ON, images.on, true)
	self:setButtonImage(UICheckBoxButton.ON_PRESSED, images.on_pressed, true)
	self:setButtonImage(UICheckBoxButton.ON_DISABLED, images.on_disabled, true)
	self.labelAlign_ = display.LEFT_CENTER
end
function UICheckBoxButton:setButtonImage(state, image, ignoreEmpty)
	assert(state == UICheckBoxButton.OFF or state == UICheckBoxButton.OFF_PRESSED or state == UICheckBoxButton.OFF_DISABLED or state == UICheckBoxButton.ON or state == UICheckBoxButton.ON_PRESSED or state == UICheckBoxButton.ON_DISABLED, string.format("UICheckBoxButton:setButtonImage() - invalid state %s", tostring(state)))
	UICheckBoxButton.super.setButtonImage(self, state, image, ignoreEmpty)
	if state == UICheckBoxButton.OFF then
		if not self.images_[UICheckBoxButton.OFF_PRESSED] then
			self.images_[UICheckBoxButton.OFF_PRESSED] = image
		end
		if not self.images_[UICheckBoxButton.OFF_DISABLED] then
			self.images_[UICheckBoxButton.OFF_DISABLED] = image
		end
	elseif state == UICheckBoxButton.ON then
		if not self.images_[UICheckBoxButton.ON_PRESSED] then
			self.images_[UICheckBoxButton.ON_PRESSED] = image
		end
		if not self.images_[UICheckBoxButton.ON_DISABLED] then
			self.images_[UICheckBoxButton.ON_DISABLED] = image
		end
	end
	return self
end
function UICheckBoxButton:isButtonSelected()
	return self.fsm_:canDoEvent("unselect")
end
function UICheckBoxButton:setButtonSelected(selected)
	if self:isButtonSelected() ~= selected then
		if selected then
			self.fsm_:doEventForce("select")
		else
			self.fsm_:doEventForce("unselect")
		end
		UIButton = "unselect"
		;("unselect").name = UIButton.STATE_CHANGED_EVENT
		;("unselect").state = self.fsm_:getState()
		self:dispatchEvent("unselect")
	end
	return self
end
function UICheckBoxButton:onTouch_(event)
	local name, x, y = event.name, event.x, event.y
	if name == "began" then
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
	local touchInTarget = self:checkTouchInSprite_(x, y)
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
			self:setButtonSelected(self.fsm_:canDoEvent("select"))
			UIButton = self.fsm_:canDoEvent("select")
			self.fsm_:canDoEvent("select").name = UIButton.CLICKED_EVENT
			self.fsm_:canDoEvent("select").x = x
			self.fsm_:canDoEvent("select").y = y
			self.fsm_:canDoEvent("select").touchInTarget = true
			self:dispatchEvent(self.fsm_:canDoEvent("select"))
		end
	end
end
function UICheckBoxButton:getDefaultState_()
	local state = self.fsm_:getState()
	if state == UICheckBoxButton.ON or state == UICheckBoxButton.ON_DISABLED or state == UICheckBoxButton.ON_PRESSED then
		_UPVALUE2_ = UICheckBoxButton.ON_PRESSED
		UICheckBoxButton.ON_PRESSED[1] = UICheckBoxButton.ON
		UICheckBoxButton.ON_PRESSED[2] = UICheckBoxButton.OFF
		return UICheckBoxButton.ON_PRESSED
	else
		_UPVALUE2_ = UICheckBoxButton.ON_PRESSED
		UICheckBoxButton.ON_PRESSED[1] = UICheckBoxButton.OFF
		UICheckBoxButton.ON_PRESSED[2] = UICheckBoxButton.ON
		return UICheckBoxButton.ON_PRESSED
	end
end
return UICheckBoxButton
