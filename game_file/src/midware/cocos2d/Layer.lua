local Layer = class("Layer", cc.Node)
function Layer:create()
	local layer = Layer.new()
	layer:autoRelease()
	layer:setContentSize(fgui.GRoot:getInstance():getSize())
	layer:setAnchorPoint(0.5, 0.5)
	layer:setTouchEnabled(false)
	return layer
end
function Layer:getDesciption()
	return "Layer"
end
return Layer
