_ENV = nil
;(nil).scrollDirLeft = -1
local _ENV, (nil).scrollDirRight, scrollDir = nil, 1, nil
;(nil).scrollBeginPosLeft = 1
;(nil).scrollBeginPosRight = 2
local _ENV, (nil).scrollBeginPosCenter, scrollBeginPos = nil, 3, nil
;(nil).scrollTypeRepeat = 1
;(nil).scrollTypeRepeatReverse = 2
local (nil).scrollTypeRepeatReset, scrollType = 3, nil
local scrollLabel = class("scrollLabel", function(textLabel)
	if textLabel == nil then
		_ENV = nil
		;(nil).UILabelType = 2
		;(nil).text = ""
		;(nil).size = 20
		textLabel = cc.ui.UILabel.new(nil)
	end
	return textLabel
end)
function scrollLabel:ctor(target, width, speed)
	self.maxContentWidth = width or 120
	self.scrollSpeed = speed or 10
	if not self.rawsetString then
		self.rawsetString = self.setString
		function self.setString(target, text)
			target.rawsetString(target, text)
			target:beginScroll()
		end
		self.oriX = self:getPositionX()
	end
	self.scrollType = scrollType.scrollTypeRepeatReverse
	self.dir = self:getScrollDir()
	self.beginPosType = self:getScrollBeginPosType()
	self:beginScroll()
end
function scrollLabel:getScrollDir()
	local horizontalAlignment = self:getTextHorizontalAlignment()
	local dir = scrollDir.scrollDirLeft
	if cc.TEXT_ALIGNMENT_LEFT == horizontalAlignment then
		dir = scrollDir.scrollDirLeft
	elseif cc.TEXT_ALIGNMENT_RIGHT == horizontalAlignment then
		dir = scrollDir.scrollDirRight
	elseif SoraDFIsRA() then
		dir = scrollDir.scrollDirRight
	end
	return dir
end
function scrollLabel:getScrollBeginPosType()
	local horizontalAlignment = self:getTextHorizontalAlignment()
	local posType = scrollBeginPos.scrollBeginPosLeft
	if cc.TEXT_ALIGNMENT_LEFT == horizontalAlignment then
		posType = scrollBeginPos.scrollBeginPosLeft
	elseif cc.TEXT_ALIGNMENT_RIGHT == horizontalAlignment then
		posType = scrollBeginPos.scrollBeginPosRight
	elseif SoraDFIsRA() then
		posType = scrollBeginPos.scrollBeginPosRight
	end
	return posType
end
function scrollLabel:setScrollType(scrollType)
	if self.scrollType ~= scrollType then
		self.scrollType = scrollType
		self:beginScroll()
	end
end
function scrollLabel:beginScroll()
	self:stopAllActions()
	if self:getContentSize().width > self.maxContentWidth then
		if self.scrollType == scrollType.scrollTypeRepeat then
			self:beginScrollRepeat()
		elseif self.scrollType == scrollType.scrollTypeRepeatReverse then
			self:beginScrollRepeatReverse()
		elseif self.scrollType == scrollType.scrollTypeRepeatReset then
			self:beginScrollRepeatReset()
		end
	end
end
function scrollLabel:getPosAndLen()
	local x = self.oriX
	local anchorPointX = self:getAnchorPoint().x
	local contentWidth = self:getContentSize().width
	local posX = x
	local offset = contentWidth - self.maxContentWidth
	local len = 0
	print(posX, len)
	if self.beginPosType == scrollBeginPos.scrollBeginPosLeft then
		posX = x + offset * anchorPointX
		len = offset
	elseif self.beginPosType == scrollBeginPos.scrollBeginPosRight then
		posX = x - offset * anchorPointX
		len = offset
	elseif self.beginPosType == scrollBeginPos.scrollBeginPosCenter then
		posX = x - self.dir * contentWidth / 2
		len = contentWidth - self.maxContentWidth / 2
	end
	print(posX, len)
	return posX, len
end
function scrollLabel:beginScrollRepeat()
end
function scrollLabel:beginScrollRepeatReverse()
	local posX, len = self:getPosAndLen()
	local time = len / self.scrollSpeed
	self:setPositionX(posX)
	local dir = self.dir
	_UPVALUE3_ = posX
	posX[1] = cca.delay(1.0)
	posX[2] = cca.moveBy(time, self.dir * len, 0)
	posX[3] = cca.delay(1.0)
	posX[4] = cca.moveBy(time, -1 * self.dir * len, 0)
	posX[5] = cca.moveBy(time, -1 * self.dir * len, 0)
	posX[6] = cca.moveBy(time, -1 * self.dir * len, 0)
	posX[7] = cca.moveBy(time, -1 * self.dir * len, 0)
	local seq = cca.seq(posX)
	self:runAction(cc.RepeatForever:create(seq))
end
function scrollLabel:beginScrollRepeatReset()
	local posX, len = self:getPosAndLen()
	local time = len / self.scrollSpeed
	_UPVALUE1_ = nil
	;(nil)[1] = cca.callFunc(function()
		self:setPositionX(posX)
	end)
	;(nil)[2] = cca.moveBy(time, self.dir * len, 0)
	;(nil)[3] = cca.moveBy(time, self.dir * len, 0)
	;(nil)[4] = cca.moveBy(time, self.dir * len, 0)
	;(nil)[5] = cca.moveBy(time, self.dir * len, 0)
	local seq = cca.seq(nil)
	self:runAction(cc.RepeatForever:create(seq))
end
return scrollLabel
