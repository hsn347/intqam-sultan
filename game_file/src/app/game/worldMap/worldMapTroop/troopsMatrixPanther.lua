local troopsMatrixNormal = include("troopsMatrixNormal")
local troopsMatrixPanther = class("troopsMatrixPanther", function(troopInstance)
	local target = troopsMatrixNormal.new(troopInstance)
	return target
end)
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local MatrixWidth = 400
local MatrixHeight = 140
function troopsMatrixPanther:ctor(troopInstance)
end
_ENV, _UPVALUE16_, troopsMatrixPanther.getMatrixType = nil, function(self)
	return MatrixType.MatrixType_Panther
end, function(self)
	return MatrixType.MatrixType_Panther
end
;(nil).soldier = worldMapDefine.soldierType_Panther
_ENV, (nil).pos = cc.p(358.7572, 77.9604), cc.p(358.7572, 77.9604)
cc.p(358.7572, 77.9604).soldier = worldMapDefine.soldierType_PantherGongjian
_ENV, cc.p(358.7572, 77.9604).pos = cc.p(327.8755, 69.9441), cc.p(327.8755, 69.9441)
cc.p(327.8755, 69.9441).soldier = worldMapDefine.soldierType_PantherQi
_ENV, cc.p(327.8755, 69.9441).pos = cc.p(286.4028, 90.11), cc.p(286.4028, 90.11)
cc.p(286.4028, 90.11).soldier = worldMapDefine.soldierType_PantherGongjian
_ENV, cc.p(286.4028, 90.11).pos = cc.p(270.3266, 51.6152), cc.p(270.3266, 51.6152)
cc.p(270.3266, 51.6152).soldier = worldMapDefine.soldierType_PantherQi
_ENV, cc.p(270.3266, 51.6152).pos = cc.p(245.7446, 72.4467), cc.p(245.7446, 72.4467)
cc.p(245.7446, 72.4467).soldier = worldMapDefine.soldierType_PantherGongjian
_ENV, cc.p(245.7446, 72.4467).pos = cc.p(213.1343, 108.9154), cc.p(213.1343, 108.9154)
cc.p(213.1343, 108.9154).soldier = worldMapDefine.soldierType_PantherGongjian
_ENV, cc.p(213.1343, 108.9154).pos = cc.p(222.8818, 36.0449), cc.p(222.8818, 36.0449)
cc.p(222.8818, 36.0449).soldier = worldMapDefine.soldierType_Panther
_ENV, cc.p(222.8818, 36.0449).pos = cc.p(195.6226, 56.718), cc.p(195.6226, 56.718)
cc.p(195.6226, 56.718).soldier = worldMapDefine.soldierType_PantherQi
_ENV, cc.p(195.6226, 56.718).pos = cc.p(168.5102, 110.6547), cc.p(168.5102, 110.6547)
cc.p(168.5102, 110.6547).soldier = worldMapDefine.soldierType_PantherQi
_ENV, cc.p(168.5102, 110.6547).pos = cc.p(144.2174, 123.1599), cc.p(144.2174, 123.1599)
cc.p(144.2174, 123.1599).soldier = worldMapDefine.soldierType_PantherQi
_ENV, cc.p(144.2174, 123.1599).pos = cc.p(133.3723, 34.8983), cc.p(133.3723, 34.8983)
cc.p(133.3723, 34.8983).soldier = worldMapDefine.soldierType_Panther
_ENV, cc.p(133.3723, 34.8983).pos = cc.p(134.0271, 79.9903), cc.p(134.0271, 79.9903)
cc.p(134.0271, 79.9903).soldier = worldMapDefine.soldierType_PantherGongjian
_ENV, cc.p(134.0271, 79.9903).pos = cc.p(111.3996, 62.5588), cc.p(111.3996, 62.5588)
cc.p(111.3996, 62.5588).soldier = worldMapDefine.soldierType_PantherQi
_ENV, cc.p(111.3996, 62.5588).pos = cc.p(71.199, 111.5301), cc.p(71.199, 111.5301)
cc.p(71.199, 111.5301).soldier = worldMapDefine.soldierType_PantherGongjian
_ENV, cc.p(71.199, 111.5301).pos = cc.p(52.2762, 48.3483), cc.p(52.2762, 48.3483)
cc.p(52.2762, 48.3483).soldier = worldMapDefine.soldierType_PantherGongjian
cc.p(52.2762, 48.3483).pos = cc.p(49.1127, 108.8336)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[1] = nil
;(function(self)
	return MatrixType.MatrixType_Panther
end)[2] = cc.p(358.7572, 77.9604)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[3] = cc.p(327.8755, 69.9441)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[4] = cc.p(286.4028, 90.11)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[5] = cc.p(270.3266, 51.6152)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[6] = cc.p(245.7446, 72.4467)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[7] = cc.p(213.1343, 108.9154)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[8] = cc.p(222.8818, 36.0449)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[9] = cc.p(195.6226, 56.718)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[10] = cc.p(168.5102, 110.6547)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[11] = cc.p(144.2174, 123.1599)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[12] = cc.p(133.3723, 34.8983)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[13] = cc.p(134.0271, 79.9903)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[14] = cc.p(111.3996, 62.5588)
;(function(self)
	return MatrixType.MatrixType_Panther
end)[15] = cc.p(71.199, 111.5301)
local (function(self)
	return MatrixType.MatrixType_Panther
end)[16], armyConfig = cc.p(52.2762, 48.3483), function(self)
	return MatrixType.MatrixType_Panther
end
function troopsMatrixPanther:createMatrixData()
	local armyData = armyConfig
	local soliderModelNum_bubing = 0
	local soliderModelNum_gongbing = 0
	for _, v in ipairs(armyData) do
		if v.soldier == worldMapDefine.soldierType_PantherGongjian then
			soliderModelNum_gongbing = soliderModelNum_gongbing + 1
		else
			soliderModelNum_bubing = soliderModelNum_bubing + 1
		end
	end
	self.halfRoundNum = soliderModelNum_bubing
	self.gongjianNum = soliderModelNum_gongbing
	return armyData
end
function troopsMatrixPanther:initSolider(isInit)
	local armyData = self:createMatrixData()
	self.troopInstance:setMatrixSize(MatrixWidth, MatrixHeight)
	for j, v in ipairs(armyData) do
		local soldierName = v.soldier
		local soldier
		soldier = self:createSolider(soldierName, j, isInit)
		soldier:setSoldierPos(v.pos)
		if isInit then
			local MatrixWidth, rankSoldierArray = soldier.setSoldierPos, soldier.setSoldierPos
			rankSoldierArray[#rankSoldierArray + 1] = soldier
			local length = MatrixWidth - v.pos.x - 50
			MatrixWidth = v.pos.x
			v.pos.x.length = length
			local v.pos.x.soldierArray, rankSoldiers = rankSoldierArray, v.pos.x
			self:addShowRankSoldier(rankSoldiers)
		end
	end
	self:createDivineBeast(isInit, #armyData)
end
return troopsMatrixPanther
