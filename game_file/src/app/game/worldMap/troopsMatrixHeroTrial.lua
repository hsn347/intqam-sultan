local troopsMatrix = include("troopsMatrix")
local troopsMatrixHeroTrial = class("troopsMatrixPreview", function()
	local view = troopsMatrix.new()
	return view
end)
function troopsMatrixHeroTrial:ctor()
	self.matrixState = gMapMoveLineStatusType.moveLineStatusTypeMoving
end
function troopsMatrixHeroTrial:getSoliderNodeBatch(batchType)
	local node = troopsMatrix.getSoliderNodeBatch(self, batchType)
	node:setGroupID(0)
	return node
end
return troopsMatrixHeroTrial
