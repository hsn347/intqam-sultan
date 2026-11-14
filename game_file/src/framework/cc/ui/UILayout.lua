local UIStretch = requireLocal(".UIStretch")
local UILayout = class("UILayout")
local nameIndex_ = 1
function UILayout:ctor(name)
	cc(self):addComponent("components.ui.LayoutProtocol"):exportMethods()
	self:setLayoutSizePolicy(display.AUTO_SIZE, display.AUTO_SIZE)
	name = name or string.format("layout-%d", nameIndex_)
	_ENV, self.name_ = {["x"] = 0, ["y"] = 0}, name
	self.position_ = {["x"] = 0, ["y"] = 0}
	self.anchorPoint_ = display.ANCHOR_POINTS[display.CENTER]
	_ENV, self.widgets_, _ENV, self.order_ = display.ANCHOR_POINTS[display.CENTER], display.ANCHOR_POINTS[display.CENTER], display.ANCHOR_POINTS[display.CENTER], 0
	local display.ANCHOR_POINTS[display.CENTER].__mode, m = "k", display.ANCHOR_POINTS[display.CENTER]
	setmetatable(self.widgets_, m)
	self.persistent_, _ENV = setmetatable, setmetatable
end
function UILayout:getName()
	return self.name_
end
function UILayout:addLayout(layout, weight)
	self:addWidget(layout, weight)
	self.persistent_[#self.persistent_ + 1] = layout
	return self
end
function UILayout:addWidget(widget, weight)
	self.order_ = self.order_ + 1
	_UPVALUE0_ = nil
	;(nil).weight = weight or 1
	self.widgets_[widget], (nil).order = nil, self.order_
	return self
end
function UILayout:removeWidget(widget)
	for w, _ in pairs(self.widgets_) do
		if w == widget then
			self.widgets_[w] = nil
			break
		end
	end
	return self
end
function UILayout:addStretch(weight)
	local stretch = UIStretch.new()
	self:addWidget(stretch, weight)
	self.persistent_[#self.persistent_ + 1] = stretch
	return self
end
function UILayout:getPosition()
	return self.position_.x, self.position_.y
end
function UILayout:getPositionX()
	return self.position_.x
end
function UILayout:getPositionY()
	return self.position_.y
end
function UILayout:setPosition(x, y)
	self.position_.x, self.position_.y = x, y
end
function UILayout:setPositionX(x)
	self.position_.x = x
end
function UILayout:setPositionY(y)
	self.position_.y = y
end
function UILayout:getAnchorPoint()
	return self.anchorPoint_
end
function UILayout:setAnchorPoint(ap)
	self.anchorPoint_ = ap
end
function UILayout:apply(container)
end
return UILayout
