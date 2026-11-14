local rectUtil = include("rectUtil")
local mapSyncUtil = class("mapSyncUtil")
function mapSyncUtil:ctor(kingdomClassType, lod)
	self.kingdomClassType = kingdomClassType or gKingdomClassType.normal
	self.lod = lod or 0
	self.pieceSize = gMapCfg[self.kingdomClassType].lod[self.lod] or 10
	self.pieceMax = math.floor(gMapCfg[self.kingdomClassType].rect.rbX / self.pieceSize)
	self.viewPieceRange = 1
end
function mapSyncUtil:getPieceUnit(x)
	if 1201 <= x then
		x = 1200
	end
	return math.ceil(x / self.pieceSize)
end
function mapSyncUtil:getMaxInPiece(pX)
	local x = pX * self.pieceSize
	if 1200 <= x then
		x = 1201
	end
	return x
end
function mapSyncUtil:getMinInPiece(pX)
	return (pX - 1) * self.pieceSize + 1
end
function mapSyncUtil:getPiecePos(x, y)
	return self:getPieceUnit(x), self:getPieceUnit(y)
end
function mapSyncUtil:getPieceId(x, y)
	return self:getPieceIdByPiecePos(self:getPiecePos(x, y))
end
function mapSyncUtil:getPieceIdByPiecePos(pX, pY)
	return pX * 10000 + pY
end
function mapSyncUtil:getPiecePosFromPieceId(pieceId)
	return math.floor(pieceId / 10000), pieceId % 10000
end
function mapSyncUtil:isPosInView(x, y, centerX, centerY)
	local pX, pY = self:getPiecePos(x, y)
	return self:isPieceInView(pX, pY, centerX, centerY)
end
function mapSyncUtil:isPieceInView(pX, pY, centerX, centerY)
	local centerPX, centerPY = self:getPiecePos(centerX, centerY)
	return pX >= centerPX - self.viewPieceRange and pX <= centerPX + self.viewPieceRange and pY >= centerPY - self.viewPieceRange and pY <= centerPY + self.viewPieceRange
end
function mapSyncUtil:isViewInSingleMap(centerX, centerY)
	local centerPX, centerPY = self:getPiecePos(centerX, centerY)
	return centerPX - self.viewPieceRange > 0 and centerPX + self.viewPieceRange <= self.pieceMax and centerPY - self.viewPieceRange > 0 and centerPY + self.viewPieceRange <= self.pieceMax
end
function mapSyncUtil:getViewPiecePosByCenterPiecePos(centerPX, centerPY)
	local _ENV, posList
	for x = -self.viewPieceRange, self.viewPieceRange do
		if 0 < centerPX + x and centerPX + x <= self.pieceMax then
			for y = -self.viewPieceRange, self.viewPieceRange do
				if 0 < centerPY + y and centerPY + y <= self.pieceMax then
					_UPVALUE2_ = nil
					;(nil)[1] = centerPX + x
					;(nil)[2] = centerPY + y
					table.insert(posList, nil)
				end
			end
		end
	end
	return posList
end
function mapSyncUtil:getViewPiecePos(centerX, centerY)
	local centerPX, centerPY = self:getPiecePos(centerX, centerY)
	return self:getViewPiecePosByCenterPiecePos(centerPX, centerPY)
end
function mapSyncUtil:getViewPieceIdsByCenterPiecePos(centerPX, centerPY)
	local _ENV, pieceIds
	local posList = self:getViewPiecePosByCenterPiecePos(centerPX, centerPY)
	for _, v in ipairs(posList) do
		local pieceId = self:getPieceIdByPiecePos(v[1], v[2])
		table.insert(pieceIds, pieceId)
	end
	return pieceIds
end
function mapSyncUtil:getViewPieceIds(centerX, centerY)
	local centerPX, centerPY = self:getPiecePos(centerX, centerY)
	return self:getViewPieceIdsByCenterPiecePos(centerPX, centerPY)
end
function mapSyncUtil:getViewRect(centerX, centerY)
	return self:getPieceRect(centerX, centerY, self.viewPieceRange)
end
function mapSyncUtil:getPieceRect(x, y, nExtRange)
	local pX, pY = self:getPiecePos(x, y)
	return self:getPieceRectByPiecePos(pX, pY, nExtRange)
end
function mapSyncUtil:getPieceRectByPiecePos(pX, pY, nExtRange)
	nExtRange = nExtRange or 0
	local ltX = (pX - nExtRange - 1) * self.pieceSize + 1
	local ltY = (pY - nExtRange - 1) * self.pieceSize + 1
	local rbX = (pX + nExtRange) * self.pieceSize
	local rbY = (pY + nExtRange) * self.pieceSize
	ltX = math.max(ltX, 1)
	ltY = math.max(ltY, 1)
	if pX + nExtRange >= self.pieceMax then
		rbX = gMapCfg[self.kingdomClassType].rect.rbX
	end
	if pY + nExtRange >= self.pieceMax then
		rbY = gMapCfg[self.kingdomClassType].rect.rbY
	end
	return rectUtil.rect(ltX, ltY, rbX, rbY)
end
function mapSyncUtil:getCrossKingdomPieceIds(centerKid, centerX, centerY, ltKid, lbKid, rbKid, rtKid)
	if self:isViewInSingleMap(centerX, centerY) or not ltKid and not lbKid and not rbKid and not rtKid then
		return
	end
	local centerPX, centerPY = self:getPiecePos(centerX, centerY)
	local _ENV, pieceIds = centerX, centerX
	pieceIds[tostring(centerKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX, centerPY)
	if centerKid == ltKid and (centerPX + self.viewPieceRange > self.pieceMax or centerPY + self.viewPieceRange > self.pieceMax) then
		if lbKid and lbKid ~= ltKid then
			pieceIds[tostring(lbKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX, centerPY - self.pieceMax)
		end
		if rbKid and rbKid ~= ltKid and rbKid ~= lbKid then
			pieceIds[tostring(rbKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX - self.pieceMax, centerPY - self.pieceMax)
		end
		if rtKid and rtKid ~= ltKid and rtKid ~= lbKid and rtKid ~= rbKid then
			pieceIds[tostring(rtKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX - self.pieceMax, centerPY)
		end
	elseif centerKid == lbKid and (centerPX + self.viewPieceRange > self.pieceMax or centerPY - self.viewPieceRange < 1) then
		if ltKid and ltKid ~= lbKid then
			pieceIds[tostring(ltKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX, centerPY + self.pieceMax)
		end
		if rbKid and rbKid ~= lbKid and rbKid ~= ltKid then
			pieceIds[tostring(rbKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX - self.pieceMax, centerPY)
		end
		if rtKid and rtKid ~= lbKid and rtKid ~= ltKid and rtKid ~= rbKid then
			pieceIds[tostring(rtKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX - self.pieceMax, centerPY + self.pieceMax)
		end
	elseif centerKid == rbKid and (centerPX - self.viewPieceRange < 1 or centerPY - self.viewPieceRange < 1) then
		if ltKid and ltKid ~= rbKid then
			pieceIds[tostring(ltKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX + self.pieceMax, centerPY + self.pieceMax)
		end
		if lbKid and lbKid ~= rbKid and lbKid ~= ltKid then
			pieceIds[tostring(lbKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX + self.pieceMax, centerPY)
		end
		if rtKid and rtKid ~= rbKid and rtKid ~= ltKid and rtKid ~= lbKid then
			pieceIds[tostring(rtKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX, centerPY + self.pieceMax)
		end
	elseif centerKid == rtKid and (centerPX - self.viewPieceRange < 1 or centerPY + self.viewPieceRange > self.pieceMax) then
		if ltKid and ltKid ~= rtKid then
			pieceIds[tostring(ltKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX + self.pieceMax, centerPY)
		end
		if lbKid and lbKid ~= rtKid and lbKid ~= ltKid then
			pieceIds[tostring(lbKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX + self.pieceMax, centerPY - self.pieceMax)
		end
		if rbKid and rbKid ~= rtKid and rbKid ~= ltKid and rbKid ~= lbKid then
			pieceIds[tostring(rbKid)] = self:getViewPieceIdsByCenterPiecePos(centerPX, centerPY - self.pieceMax)
		end
	else
		_ENV = tostring(rbKid)
		return (tostring(rbKid))
	end
	return pieceIds
end
function mapSyncUtil:getCrossKingdomViewRect(centerKid, centerX, centerY, ltKid, lbKid, rbKid, rtKid)
	local centerPX, centerPY = self:getPiecePos(centerX, centerY)
	local _UPVALUE0_, pieceIds = centerX, centerX
	pieceIds[centerKid] = self:getPieceRectByPiecePos(centerPX, centerPY, self.viewPieceRange)
	if centerKid == ltKid and (centerPX + self.viewPieceRange > self.pieceMax or centerPY + self.viewPieceRange > self.pieceMax) then
		if lbKid and lbKid ~= ltKid then
			pieceIds[lbKid] = self:getPieceRectByPiecePos(centerPX, centerPY - self.pieceMax, self.viewPieceRange)
		end
		if rbKid and rbKid ~= ltKid and rbKid ~= lbKid then
			pieceIds[rbKid] = self:getPieceRectByPiecePos(centerPX - self.pieceMax, centerPY - self.pieceMax, self.viewPieceRange)
		end
		if rtKid and rtKid ~= ltKid and rtKid ~= lbKid and rtKid ~= rbKid then
			pieceIds[rtKid] = self:getPieceRectByPiecePos(centerPX - self.pieceMax, centerPY, self.viewPieceRange)
		end
	elseif centerKid == lbKid and (centerPX + self.viewPieceRange > self.pieceMax or centerPY - self.viewPieceRange < 1) then
		if ltKid and ltKid ~= lbKid then
			pieceIds[ltKid] = self:getPieceRectByPiecePos(centerPX, centerPY + self.pieceMax, self.viewPieceRange)
		end
		if rbKid and rbKid ~= lbKid and rbKid ~= ltKid then
			pieceIds[rbKid] = self:getPieceRectByPiecePos(centerPX - self.pieceMax, centerPY, self.viewPieceRange)
		end
		if rtKid and rtKid ~= lbKid and rtKid ~= ltKid and rtKid ~= rbKid then
			pieceIds[rtKid] = self:getPieceRectByPiecePos(centerPX - self.pieceMax, centerPY + self.pieceMax, self.viewPieceRange)
		end
	elseif centerKid == rbKid and (centerPX - self.viewPieceRange < 1 or centerPY - self.viewPieceRange < 1) then
		if ltKid and ltKid ~= rbKid then
			pieceIds[ltKid] = self:getPieceRectByPiecePos(centerPX + self.pieceMax, centerPY + self.pieceMax, self.viewPieceRange)
		end
		if lbKid and lbKid ~= rbKid and lbKid ~= ltKid then
			pieceIds[lbKid] = self:getPieceRectByPiecePos(centerPX + self.pieceMax, centerPY, self.viewPieceRange)
		end
		if rtKid and rtKid ~= rbKid and rtKid ~= ltKid and rtKid ~= lbKid then
			pieceIds[rtKid] = self:getPieceRectByPiecePos(centerPX, centerPY + self.pieceMax, self.viewPieceRange)
		end
	elseif centerKid == rtKid and (centerPX - self.viewPieceRange < 1 or centerPY + self.viewPieceRange > self.pieceMax) then
		if ltKid and ltKid ~= rtKid then
			pieceIds[ltKid] = self:getPieceRectByPiecePos(centerPX + self.pieceMax, centerPY, self.viewPieceRange)
		end
		if lbKid and lbKid ~= rtKid and lbKid ~= ltKid then
			pieceIds[lbKid] = self:getPieceRectByPiecePos(centerPX + self.pieceMax, centerPY - self.pieceMax, self.viewPieceRange)
		end
		if rbKid and rbKid ~= rtKid and rbKid ~= ltKid and rbKid ~= lbKid then
			pieceIds[rbKid] = self:getPieceRectByPiecePos(centerPX, centerPY - self.pieceMax, self.viewPieceRange)
		end
	else
		_UPVALUE0_ = self:getPieceRectByPiecePos(centerPX, centerPY - self.pieceMax, self.viewPieceRange)
		return (self:getPieceRectByPiecePos(centerPX, centerPY - self.pieceMax, self.viewPieceRange))
	end
	return pieceIds
end
function mapSyncUtil:getLineCrossPieceIds(fromX, fromY, toX, toY)
	local _ENV, pieceIds
	local fromPX, fromPY = self:getPiecePos(fromX, fromY)
	local toPX, toPY = self:getPiecePos(toX, toY)
	local minPX = math.min(fromPX, toPX)
	local maxPX = math.max(fromPX, toPX)
	local minPY = math.min(fromPY, toPY)
	local maxPY = math.max(fromPY, toPY)
	local getLineRows = function(getY)
		for pX = minPX, maxPX do
			local pY = getY(pX)
			if pY >= minPY and pY <= maxPY then
				local pieceId = self:getPieceIdByPiecePos(pX, pY)
				pieceIds[pieceId] = pieceId
			end
		end
	end
	local getLineColumns = function(getX)
		for pY = minPY, maxPY do
			local pX = getX(pY)
			if pX >= minPX and pX <= maxPX then
				local pieceId = self:getPieceIdByPiecePos(pX, pY)
				pieceIds[pieceId] = pieceId
			end
		end
	end
	if fromPY == toPY and fromPX == toPX then
		getLineRows(function(x)
			return fromPY
		end)
	elseif fromPY == toPY then
		getLineRows(function(x)
			return fromPY
		end)
	elseif fromPX == toPX then
		getLineColumns(function(y)
			return fromPX
		end)
	else
		local k = (toY - fromY) / (toX - fromX)
		local b = fromY - k * fromX
		getLineRows(function(PX)
			return self:getPieceUnit(k * self:getMinInPiece(PX) + b)
		end)
		getLineRows(function(PX)
			return self:getPieceUnit(k * self:getMaxInPiece(PX) + b)
		end)
		getLineColumns(function(PY)
			return self:getPieceUnit((self:getMinInPiece(PY) - b) / k)
		end)
		getLineColumns(function(PY)
			return self:getPieceUnit((self:getMaxInPiece(PY) - b) / k)
		end)
	end
	return pieceIds
end
function mapSyncUtil:isLineCrossPieces(piecePosList, fromX, fromY, toX, toY)
	local fromPX, fromPY = self:getPiecePos(fromX, fromY)
	local toPX, toPY = self:getPiecePos(toX, toY)
	local minPX = math.min(fromPX, toPX)
	local maxPX = math.max(fromPX, toPX)
	local minPY = math.min(fromPY, toPY)
	local maxPY = math.max(fromPY, toPY)
	if fromPY == toPY and fromPX == toPX then
		for _, pos in ipairs(piecePosList) do
			if pos[1] == fromPX and pos[2] == fromPY then
				return true
			end
		end
	elseif fromPY == toPY then
		local minRow = math.min(fromPX, toPX)
		local maxRow = math.max(fromPX, toPX)
		for _, pos in ipairs(piecePosList) do
			if pos[2] == fromPY and minRow <= pos[1] and maxRow >= pos[1] then
				return true
			end
		end
	elseif fromPX == toPX then
		local minColumn = math.min(fromPY, toPY)
		local maxColumn = math.max(fromPY, toPY)
		for _, pos in ipairs(piecePosList) do
			if pos[1] == fromPX and minColumn <= pos[2] and maxColumn >= pos[2] then
				return true
			end
		end
	else
		local k = (toY - fromY) / (toX - fromX)
		local b = fromY - k * fromX
		for _, pos in ipairs(piecePosList) do
			local pX, pY = pos[1], pos[2]
			if minPX <= pX and maxPX >= pX and minPY <= pY and maxPY >= pY and (pY == self:getPieceUnit(k * self:getMinInPiece(pX) + b) or pY == self:getPieceUnit(k * self:getMaxInPiece(pX) + b) or pX == self:getPieceUnit((self:getMinInPiece(pY) - b) / k) or pX == self:getPieceUnit((self:getMaxInPiece(pY) - b) / k)) then
				return true
			end
		end
	end
	return false
end
function mapSyncUtil:isLineCrossView(centerX, centerY, fromX, fromY, toX, toY)
	local piecePosList = self:getViewPiecePos(centerX, centerY)
	return self:isLineCrossPieces(piecePosList, fromX, fromY, toX, toY)
end
return mapSyncUtil
