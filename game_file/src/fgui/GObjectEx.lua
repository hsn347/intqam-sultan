local m = fgui.GObject
local setSize_old = tolua.getcfunction(m, "setSize")
local setScale_old = tolua.getcfunction(m, "setScale")
local getScale_old = tolua.getcfunction(m, "getScale")
function m:setString(value)
	self:setText(value)
end
function m:getCacheName()
	return self.__cacheName
end
function m:setCacheName(name)
	self.__cacheName = name
end
function m:setSize(wv, hv, ignorePivot)
	if hv then
		self:SetSize(wv, hv, ignorePivot and true or false)
	else
		self:SetSize(wv.width, wv.height, ignorePivot and true or false)
	end
end
function m:setAnchorPoint(x, y)
	if y then
		self:setPivot(x, 1 - y, true)
	else
		self:setPivot(x.x, 1 - x.y, true)
	end
end
function m:addTo(parent, zorder)
	parent:addChild(self, zorder)
end
function m:setScale(x, y)
	if y then
		return setScale_old(self, x, y)
	else
		return setScale_old(self, x, x)
	end
end
function m:getScale()
	local scale = getScale_old(self)
	assert(scale.x == scale.y, "GObject#scale. ScaleX != ScaleY. Don't know which one to return")
	return scale.x
end
function m:getBlendMode()
	return self.blendMode
end
function m:setOpacity(opacity)
	return self:setAlpha(opacity / 255)
end
function m:addLongPressListener(callback, time, distance)
	time = time or 0.4
	distance = distance or TOUCH_MOVED_ERROR_VALUE
	self:addEventListener1(fgui.UIEventType.TouchBegin, function(context)
		self.isLong = false
		print("touchBegin")
		self.___touchStartPos = context:getInput():getPosition()
		self.___input = context:getInput()
		self.___target = self.___input:getTarget()
		if not self.___action then
			self.___action = ffa.seq(ffa.delay(time), ffa.callFunc(function()
				if self.___input and self.___target == self.___input:getTarget() then
					local pos = self.___input:getPosition()
					local dis = cc.pGetDistance(self.___touchStartPos, pos)
					if tonumber(dis) <= distance then
						self.isLong = true
						if callback then
							callback(self, self.___touchStartPos, pos)
						end
						self.___touchStartPos = nil
						self.___input = nil
						self.___target = nil
					end
				end
				if self.___action then
					self:stopAction(self.___action)
					self.___action = nil
				end
			end))
		end
		self:runAction(self.___action)
	end)
	self:addEventListener(fgui.UIEventType.TouchEnd, function(context)
		if self.___action then
			self:stopAction(self.___action)
			self.___action = nil
		end
	end)
end
