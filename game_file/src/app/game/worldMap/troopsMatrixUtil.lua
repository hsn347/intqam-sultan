local _ENV, _ENV, troopsMatrixUtil
;(nil).MatrixType_Normal = 0
;(nil).MatrixType_Jack = 1
;(nil).MatrixType_Panther = 2
;(nil).MatrixType_Snow = 3
;(nil).MatrixType_Lion = 4
;(nil).MatrixType_Tiger = 5
;(nil).MatrixType_Charge = 6
;(nil).MatrixType_Sniper = 7
;(nil).MatrixType_Trick = 8
;(nil).MatrixType_Worldcup = 9
;(nil).MatrixType_Icedragon = 10
;(nil).MatrixType_Laoji = 11
;(nil).MatrixType_HTJC = 12
;(nil).MatrixType_HYFL = 13
;(nil).MatrixType_PJSS = 14
;(nil).MatrixType_BlueDragon = 15
;(nil).MatrixType_StarShip = 16
;(nil).MatrixType_KZP = 17
;(nil).MatrixType_FHXJ = 18
;(nil).MatrixType_Empty = 19
;(nil).MatrixType_Bubble = 20
;(nil).MatrixType_SoulWolf = 21
;(nil).MatrixType_HuaChe = 22
;(nil).MatrixType_Balloon = 23
;(nil).MatrixType_Train = 24
;(nil).MatrixType_Whale = 25
;(nil).MatrixType_Zyxj = 26
;(nil).MatrixType_26zyxj = 27
_ENV, troopsMatrixUtil.MatrixType, (nil).MatrixType_znqxj2026 = nil, nil, 28
;(nil).EffectType_None = 0
;(nil).EffectType_Skin = 1
;(nil).EffectType_Hegemon = 2
;(nil).EffectType_King = 3
;(nil).EffectType_Medal = 4
;(nil).EffectType_Panther = 5
;(nil).EffectType_Lion = 6
;(nil).EffectType_Tiger = 7
;(nil).EffectType_Charge = 8
;(nil).EffectType_Sniper = 9
;(nil).EffectType_Trick = 10
;(nil).EffectType_Worldcup = 11
;(nil).EffectType_Icedragon = 12
;(nil).EffectType_Laoji = 13
;(nil).EffectType_HTJC = 14
;(nil).EffectType_HYFL = 15
;(nil).EffectType_PJSS = 16
;(nil).EffectType_BlueDragon = 17
;(nil).EffectType_StarShip = 18
;(nil).EffectType_KZP = 19
;(nil).EffectType_FHXJ = 20
;(nil).EffectType_Bubble = 21
;(nil).EffectType_SoulWolf = 22
;(nil).EffectType_HuaChe = 23
;(nil).EffectType_Balloon = 24
;(nil).EffectType_Train = 25
;(nil).EffectType_Whale = 26
;(nil).EffectType_Zyxj = 27
;(nil).EffectType_26zyxj = 28
_ENV, troopsMatrixUtil.EffectType, (nil).EffectType_znqxj2026 = nil, nil, 29
;(nil).SoldierBatchType_Normal = 0
;(nil).SoldierBatchType_Panther = 1
;(nil).SoldierBatchType_Fighting = 2
;(nil).SoldierBatchType_Lion = 3
;(nil).SoldierBatchType_WhiteTiger = 4
;(nil).SoldierBatchType_Sniper = 5
;(nil).SoldierBatchType_Dictator = 6
;(nil).SoldierBatchType_Trick = 7
;(nil).SoldierBatchType_Worldcup = 8
;(nil).SoldierBatchType_Icedragon = 9
;(nil).SoldierBatchType_Laoji = 10
;(nil).SoldierBatchType_HTJC = 11
;(nil).SoldierBatchType_DivineBast = 12
;(nil).SoldierBatchType_HYFL = 13
;(nil).SoldierBatchType_PJSS = 14
;(nil).SoldierBatchType_BlueDragon = 15
;(nil).SoldierBatchType_StarShip = 16
;(nil).SoldierBatchType_KZP = 17
;(nil).SoldierBatchType_FHXJ = 18
;(nil).SoldierBatchType_Bubble = 19
;(nil).SoldierBatchType_SoulWolf = 20
;(nil).SoldierBatchType_HuaChe = 21
;(nil).SoldierBatchType_Balloon = 22
;(nil).SoldierBatchType_Train = 23
;(nil).SoldierBatchType_Whale = 24
;(nil).SoldierBatchType_Zyxj = 25
;(nil).SoldierBatchType_26zyxj = 26
;(nil).SoldierBatchType_znqxj2026 = 27
troopsMatrixUtil.SoldierBatchType, (nil).SoldierBatchType_Node = nil, 100
local SoldierBatchType = troopsMatrixUtil.SoldierBatchType
local SpriteBatchNodeEx = _G.SpriteBatchNodeEx
function troopsMatrixUtil.getSoldierWidth(soldierName)
	local cellWidth = worldMapDefine.armySize[soldierName] or 20
	return cellWidth
end
function troopsMatrixUtil.getSoldierBatchType(soliderType, isFighting)
	local batchType = include("troopsHelper").getBatchType(soliderType)
	if batchType then
		return batchType
	end
	if isFighting then
		return SoldierBatchType.SoldierBatchType_Fighting
	end
	return SoldierBatchType.SoldierBatchType_Normal
end
function troopsMatrixUtil.createSoliderNodeBatch(batchType)
	local soliderNodeBatch = include("troopsHelper").getSoliderNodeBatch(batchType)
	if soliderNodeBatch then
		return soliderNodeBatch
	end
	if batchType == SoldierBatchType.SoldierBatchType_DivineBast then
		local soliderNodeBatch = display.newNode()
		soliderNodeBatch:setGroupID(worldMapDefine.GROU_ID.group_moveline_divinebeast)
		soliderNodeBatch:setGroupAuto(true)
		return soliderNodeBatch
	end
	if batchType == SoldierBatchType.SoldierBatchType_Node then
		return display.newNode()
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		local soliderNodeBatch = SpriteBatchNodeEx:create(getImageFileNameByPlatform("FrameAnimation/worldMapSoliderFighting"), 30)
		soliderNodeBatch:setGroupID(worldMapDefine.GROU_ID.group_moveline_fighting)
		return soliderNodeBatch
	end
	return SpriteBatchNodeEx:create(getImageFileNameByPlatform("FrameAnimation/worldMapSolider"), 30)
end
_ENV, troopsMatrixUtil.getEffectImageName = function(batchType, name)
	if batchType == SoldierBatchType.SoldierBatchType_Panther then
		return string.format("#%s_panther.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Lion then
		return string.format("#%s_lion.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		return string.format("#%s_fight.png", name)
	end
	return string.format("#%s.png", name)
end, function(batchType, name)
	if batchType == SoldierBatchType.SoldierBatchType_Panther then
		return string.format("#%s_panther.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Lion then
		return string.format("#%s_lion.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		return string.format("#%s_fight.png", name)
	end
	return string.format("#%s.png", name)
end
;(function(batchType, name)
	if batchType == SoldierBatchType.SoldierBatchType_Panther then
		return string.format("#%s_panther.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Lion then
		return string.format("#%s_lion.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		return string.format("#%s_fight.png", name)
	end
	return string.format("#%s.png", name)
end).w = true
;(function(batchType, name)
	if batchType == SoldierBatchType.SoldierBatchType_Panther then
		return string.format("#%s_panther.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Lion then
		return string.format("#%s_lion.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		return string.format("#%s_fight.png", name)
	end
	return string.format("#%s.png", name)
end).wn = true
local (function(batchType, name)
	if batchType == SoldierBatchType.SoldierBatchType_Panther then
		return string.format("#%s_panther.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Lion then
		return string.format("#%s_lion.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		return string.format("#%s_fight.png", name)
	end
	return string.format("#%s.png", name)
end).ws, DIR_HAS_FLIP_PAIR = true, function(batchType, name)
	if batchType == SoldierBatchType.SoldierBatchType_Panther then
		return string.format("#%s_panther.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Lion then
		return string.format("#%s_lion.png", name)
	end
	if batchType == SoldierBatchType.SoldierBatchType_Fighting then
		return string.format("#%s_fight.png", name)
	end
	return string.format("#%s.png", name)
end
local resolveDirVisualOffset = function(off, imgNameAngle, isFlipX)
	if not off then
		return 0, 0
	end
	if off.normal or off.flip then
		if isFlipX then
			if off.flip then
				return off.flip.x, off.flip.y
			end
			local n = off.normal
			return n.x, -n.y
		end
		local n = off.normal or off.flip
		return n.x, n.y
	end
	if isFlipX and DIR_HAS_FLIP_PAIR[imgNameAngle] then
		return off.x, -off.y
	end
	return off.x, off.y
end
function troopsMatrixUtil.applySoldierDirVisualOffset(soldier, basePos, troopDir, visualOffsetByAngle, rotTweakByAngle)
	local imgNameAngle = troopDir.imgNameAngle
	local isFlipX = troopDir.isFlipX
	local moveAngle = troopDir.moveAngle or 0
	local off = visualOffsetByAngle and visualOffsetByAngle[imgNameAngle]
	local ox, oy = resolveDirVisualOffset(off, imgNameAngle, isFlipX)
	soldier:setSoldierPos(cc.p(basePos.x + ox, basePos.y + oy))
	local rotTweak = rotTweakByAngle and rotTweakByAngle[imgNameAngle] or 0
	if rotTweak ~= 0 then
		if isFlipX and DIR_HAS_FLIP_PAIR[imgNameAngle] then
			rotTweak = -rotTweak
		end
		local soliderImg = soldier:getSoliderImg()
		if soliderImg then
			soliderImg:setRotation(-moveAngle + rotTweak)
		end
	end
end
return troopsMatrixUtil
