local coffeeCraftsmanRead = include("coffeeCraftsmanRead")
local LONG_EVENT_TIME = 0.4
local baseComponent = require("fgui.base.baseComponent")
local Com_coffee = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CoffeeCraftsman/Com_coffee", Com_coffee)
function Com_coffee:onInit()
	self:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchBegin))
	self:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	self:addClickListener(function()
		if self.isLong then
			return
		end
		SoraDPlaySound()
	end)
end
function Com_coffee:onTouchBegin(context)
	self._touchStartPos = context:getInput():getPosition()
	self._input = context:getInput()
	self.target = self._input:getTarget()
	_ENV = self._input
	self._input.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	SoraDSendMessage(self._input)
	self.isLong = false
	local longTime = 0
	self:removeTouchTimer()
	self.showTimer = SoradCreateTimer(self, function(dt)
		if longTime >= LONG_EVENT_TIME then
			SoraDPlaySound()
			if self._input and self.target == self._input:getTarget() then
				local pos = self._input:getPosition()
				local distance = cc.pGetDistance(self._touchStartPos, pos)
				if tonumber(distance) <= TOUCH_MOVED_ERROR_VALUE then
					self.isLong = true
					longTime = TOUCH_MOVED_ERROR_VALUE
					TOUCH_MOVED_ERROR_VALUE.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
					TOUCH_MOVED_ERROR_VALUE.pos = self._touchStartPos
					TOUCH_MOVED_ERROR_VALUE.customName = i18n(coffeeCraftsmanRead:getCoffeeName(self.id))
					TOUCH_MOVED_ERROR_VALUE.customTip = i18n(coffeeCraftsmanRead:getCoffeeTip(self.id))
					SoraDSendMessage(TOUCH_MOVED_ERROR_VALUE)
				end
			end
			self:removeTouchTimer()
			return
		end
	end, true)
end
function Com_coffee:onTouchEnd()
	self:removeTouchTimer()
end
function Com_coffee:removeTouchTimer()
	if self.showTimer then
		SoraDManagerRemoveTimer(self, self.showTimer)
		self.showTimer = nil
	end
end
function Com_coffee:initData(id)
	self.id = id
	self.fields.Icon:setURL(coffeeCraftsmanRead:getCoffeeIcon(self.id))
end
