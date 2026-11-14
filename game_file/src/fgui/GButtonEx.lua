local m = fgui.GButton
function m:setTitleText(s)
	self:setTitle(s)
end
function m:setString(s)
	self:setTitle(s)
end
function m:setEnabled(value)
	self:setTouchEnabled(value)
	self:setGrayed(not value)
end
local addTouchEventListener_ = m.addTouchEventListener
function m:addTouchEventListener(callback)
	if self.isCocos then
		if self._isIgnorTrainsGuide then
			addTouchEventListener_(self, onTouch_)
			return
		end
		local onTouch_ = function(...)
			if self.mildGuideCallBack then
				self.mildGuideCallBack(...)
			end
			if self._touchEventListener_ then
				self._touchEventListener_(...)
			end
		end
		if not self._touchEventListener_ then
			addTouchEventListener_(self, onTouch_)
		end
		self._touchEventListener_ = callback
	else
		self:addClickListener(function(eventContext)
			callback(eventContext:getSender(), ccui.TouchEventType.ended)
		end)
	end
end
function m:loadTextureBackGround(url)
	local childBg = self:getChildByName("__bg")
	if childBg and childBg.setURL then
		childBg:setURL(url)
	end
end
