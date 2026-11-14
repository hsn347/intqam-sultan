local Component = cc.Component
local BasicLayoutProtocol = class("BasicLayoutProtocol", Component)
local MAX = 999999
function BasicLayoutProtocol:ctor()
	BasicLayoutProtocol.super.ctor(self, "BasicLayoutProtocol")
end
function BasicLayoutProtocol:getLayoutSize()
	if self.layoutSize_ then
		return self.layoutSize_.width, self.layoutSize_.height
	elseif self.target_.getCascadeBoundingBox then
		local size = self.target_:getCascadeBoundingBox().size
		return size.width, size.height
	else
		return 0, 0
	end
end
function BasicLayoutProtocol:setLayoutSize(width, height)
	if width == 0 and height == 0 then
		self.layoutSize_ = nil
	else
		_ENV = nil
		;(nil).width = checknumber(width)
		self.layoutSize_, (nil).height = nil, checknumber(height)
	end
	return self.target_
end
function BasicLayoutProtocol:getLayoutMinSize()
	return self.minSize_.width, self.minSize_.height
end
function BasicLayoutProtocol:setLayoutMinSize(width, height)
	self.minSize_.width = checknumber(width)
	self.minSize_.height = checknumber(height)
	return self.target_
end
function BasicLayoutProtocol:getLayoutMaxSize()
	return self.maxSize_.width, self.maxSize_.height
end
function BasicLayoutProtocol:setLayoutMaxSize(width, height)
	self.maxSize_.width = checknumber(width)
	self.maxSize_.height = checknumber(height)
	return self.target_
end
function BasicLayoutProtocol:getLayoutSizePolicy()
	return self.sizePolicy_.horizontal, self.sizePolicy_.vertical
end
local checkSizePolicy = function(p)
	if p ~= display.AUTO_SIZE and p ~= display.FIXED_SIZE then
		printError("BasicLayoutProtocol - invalid size policy")
		return display.AUTO_SIZE
	else
		return p
	end
end
function BasicLayoutProtocol:setLayoutSizePolicy(horizontal, vertical)
	self.sizePolicy_.horizontal = checkSizePolicy(horizontal)
	self.sizePolicy_.vertical = checkSizePolicy(vertical)
	return self.target_
end
function BasicLayoutProtocol:getLayoutPadding()
	return self.padding_.top, self.padding_.right, self.padding_.bottom, self.padding_.left
end
function BasicLayoutProtocol:setLayoutPadding(top, right, bottom, left)
	self.padding_.top = checknumber(top)
	self.padding_.right = checknumber(right)
	self.padding_.bottom = checknumber(bottom)
	self.padding_.left = checknumber(left)
	return self.target_
end
function BasicLayoutProtocol:getLayoutMargin()
	return self.margin_.top, self.margin_.right, self.margin_.bottom, self.margin_.left
end
function BasicLayoutProtocol:setLayoutMargin(top, right, bottom, left)
	self.margin_.top = checknumber(top)
	self.margin_.right = checknumber(right)
	self.margin_.bottom = checknumber(bottom)
	self.margin_.left = checknumber(left)
	return self.target_
end
function BasicLayoutProtocol:exportMethods()
	_UPVALUE12_ = nil
	;(nil)[1] = "getLayoutSize"
	;(nil)[2] = "setLayoutSize"
	;(nil)[3] = "getLayoutMinSize"
	;(nil)[4] = "setLayoutMinSize"
	;(nil)[5] = "getLayoutMaxSize"
	;(nil)[6] = "setLayoutMaxSize"
	;(nil)[7] = "getLayoutSizePolicy"
	;(nil)[8] = "setLayoutSizePolicy"
	;(nil)[9] = "getLayoutPadding"
	;(nil)[10] = "setLayoutPadding"
	;(nil)[11] = "getLayoutMargin"
	;(nil)[12] = "setLayoutMargin"
	self:exportMethods_(nil)
	return self.target_
end
function BasicLayoutProtocol:onBind_()
	MAX, self.layoutSize_ = nil, nil
	;(nil).width = 0
	MAX, self.minSize_, (nil).height = nil, nil, 0
	;(nil).width = MAX
	MAX, self.maxSize_, (nil).height = nil, nil, MAX
	;(nil).h = display.PREFERRED_SIZE
	MAX, self.sizePolicy_, (nil).v = nil, nil, display.PREFERRED_SIZE
	;(nil).top = 0
	;(nil).right = 0
	;(nil).bottom = 0
	MAX, self.padding_, (nil).left = nil, nil, 0
	;(nil).top = 0
	;(nil).right = 0
	;(nil).bottom = 0
	self.margin_, (nil).left = nil, 0
end
function BasicLayoutProtocol:onUnbind_()
end
return BasicLayoutProtocol
