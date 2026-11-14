local appendTools = class("appendTools", function(target)
	return target
end)
function appendTools:ctor()
end
function appendTools.drawRedPoint(r)
	function drawPoint(_r, _color, _name)
		local drawNode = cc.DrawNode:create()
		drawNode:setName(_name)
		drawNode:drawSolidCircle(cc.p(0, 0), _r, 0, 40, _color)
		drawNode:ignoreAnchorPointForPosition(false)
		drawNode:setAnchorPoint(cc.p(0.5, 0.5))
		drawNode:setPosition(0, 0)
		return drawNode
	end
	local parent = cc.Node:create()
	parent:addChild(drawPoint(r + 0.5, cc.c4f(0 / 255, 0 / 255, 0 / 255, 1.0), "Point_bg"))
	parent:addChild(drawPoint(r, cc.c4f(0.8235294117647058, 0.043137254901960784, 0.043137254901960784, 1.0), "Point_body"))
	function parent.clearDrawNode(_parent)
		_parent:getChildByName("Point_bg"):clear()
		_parent:getChildByName("Point_body"):clear()
	end
	return parent
end
return appendTools
