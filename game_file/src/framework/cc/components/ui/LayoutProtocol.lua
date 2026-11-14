local BasicLayoutProtocol = requireLocal(".BasicLayoutProtocol")
local LayoutProtocol = class("LayoutProtocol", BasicLayoutProtocol)
function LayoutProtocol:ctor()
	LayoutProtocol.super.ctor(self, "LayoutProtocol")
end
function LayoutProtocol:setLayoutSize(width, height)
	LayoutProtocol.super.setLayoutSize(self, width, height)
	self:setLayout(self.layout_)
	return self.target_
end
function LayoutProtocol:setLayout(layout)
	self.layout_ = layout
	if layout then
		layout:apply(self.target_)
	end
	return self.target_
end
function LayoutProtocol:getLayout()
	return self.layout_
end
function LayoutProtocol:exportMethods()
	LayoutProtocol.super.exportMethods(self)
	_UPVALUE2_ = nil
	;(nil)[1] = "setLayout"
	;(nil)[2] = "getLayout"
	self:exportMethods_(nil)
	return self.target_
end
return LayoutProtocol
