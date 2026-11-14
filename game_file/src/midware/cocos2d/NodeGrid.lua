local NodeGrid = class("NodeGrid", cc.Node)
function NodeGrid:create()
	local nodeGrid = NodeGrid.new()
	nodeGrid:autoRelease()
	nodeGrid:setContentSize(0, 0)
	nodeGrid:setTouchEnabled(false)
	return nodeGrid
end
function NodeGrid:getDesciption()
	return "NodeGrid"
end
function NodeGrid:setGridRect(rect)
end
function NodeGrid:getGrid()
	_UPVALUE0_ = nil
	;(nil).setActive = function(value)
	end
	;(nil).setCullFaceType = function(glType)
	end
	return nil
end
function NodeGrid:setPageTurn3D(pageTurnGridSize)
end
function NodeGrid:setPageTurn3DParam(ayScale, thetaScale)
end
function NodeGrid:updatePageTurn3D(timeScale)
end
return NodeGrid
