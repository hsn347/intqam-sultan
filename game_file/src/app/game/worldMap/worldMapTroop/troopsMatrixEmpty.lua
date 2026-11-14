local troopsMatrixBase = include("troopsMatrixBase")
local troopsMatrixEmpty = class("troopsMatrixEmpty", function(troopInstance)
	local target = troopsMatrixBase.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
function troopsMatrixEmpty:ctor(troopInstance)
end
function troopsMatrixEmpty:getMatrixType()
	return MatrixType.MatrixType_Empty
end
function troopsMatrixEmpty:showMatrix(isInit, moveing)
end
function troopsMatrixEmpty:isSwitchMatrixOnShow()
	return true
end
function troopsMatrixEmpty:marchEffect(effectId, showNow)
end
function troopsMatrixEmpty:showTroopEffectType(effectType, isPreview)
end
function troopsMatrixEmpty:hideTroopEffectType(effectType)
end
return troopsMatrixEmpty
