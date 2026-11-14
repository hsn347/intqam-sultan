local DrawNode1 = class("DrawNode1", cc.Node)
function DrawNode1:create(lineWidth)
	local drawNode = cc.DrawNode:create(lineWidth)
	drawNode:setName("_drawNode")
	drawNode:setContentSize(0, 0)
	drawNode:setPosition(0, 0)
	drawNode:autoRelease()
	return drawNode
end
return DrawNode1
