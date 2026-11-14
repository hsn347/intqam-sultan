local m = CS.Sultan.Game.UIWebView
local _oldSetPosition = m.setPosition
function m:create()
	local ret = CS.Sultan.Game.UIWebView.CreateFGUIWebView()
	ret.isCocos = true
	ret.onAddedToStage:Add1(handler(ret, ret._updateFrame))
	return ret
end
function m:setContentSize(size)
	self._size = size
	self:_updateFrame()
end
function m:setPosition(x, y)
	self._posX = x
	self._posY = y
	self:_updateFrame()
end
function m:_updateFrame()
	self._posX = self._posX or 0
	self._posY = self._posY or 0
	self._size = self._size or cc.size(0, 0)
	if self:getParent() == nil then
		return
	end
	_oldSetPosition(self, self._posX, self._posY)
	self:SetSize(self._size.width, self._size.height)
	dump(self:getBoundingBox(), "_updateFrame1")
	_UPVALUE2_ = self:getBoundingBox()
	self:getBoundingBox()[1] = self._posX
	self:getBoundingBox()[2] = self._posY
	dump(self:getBoundingBox(), "_updateFrame2")
end
return m
