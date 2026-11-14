local Widget = class("Widget", cc.Node)
function Widget:create()
	local widget = Widget.new()
	widget:setAnchorPoint(cc.p(0.5, 0.5))
	widget:autoRelease()
	return widget
end
function Widget:getDesciption()
	return "Widget"
end
return Widget
