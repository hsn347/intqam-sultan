local worldMapComViewPiece = class("worldMapComViewPiece", include("worldMapCom"))
local worldMapEvent = include("worldMapEvent")
function worldMapComViewPiece:ctor()
	worldMapComViewPiece.super.ctor(self, "worldMapComViewPiece")
end
function worldMapComViewPiece:onMessageListener()
	self:addEventListener(worldMapEvent.EVENT_UPDATE_PIECE, handler(self, self.setViewPieceIds))
end
_ENV, worldMapComViewPiece.resetData = function(self)
	self.viewPieceIDs, _UPVALUE0_ = nil, nil
	self.lod = nil
end, function(self)
	self.viewPieceIDs, _UPVALUE0_ = nil, nil
	self.lod = nil
end
local (function(self)
	self.viewPieceIDs, _UPVALUE0_ = nil, nil
	self.lod = nil
end).name, event_piece = worldMapEvent.EVENT_UPDATE_PIECE_DEL, function(self)
	self.viewPieceIDs, _UPVALUE0_ = nil, nil
	self.lod = nil
end
function worldMapComViewPiece:setViewPieceIds(event)
	local viewPieceIDs = event.viewPieceIDs
	local _ENV, curviewPieceIDs
	for kingdomId, v in pairs(viewPieceIDs) do
		if v then
			for _, id in pairs(v) do
				local strkey = kingdomId .. "-" .. tostring(id)
				curviewPieceIDs[strkey] = true
			end
		end
	end
	local curPieceIDS = self.viewPieceIDs
	local _ENV, delPieceIDS = pairs(viewPieceIDs)
	for k in pairs(curPieceIDS) do
		if not curviewPieceIDs[k] then
			delPieceIDS[k] = true
		end
	end
	self.viewPieceIDs = curviewPieceIDs
	local lodChange = self.lod ~= event.lod
	event_piece.delPieceIDS = delPieceIDS
	event_piece.curPieceIDS = curviewPieceIDs
	event_piece.lod = event.lod
	event_piece.oldLod = self.lod
	event_piece.lodChange = lodChange
	if lodChange then
		self.lod = event.lod
	end
	self:dispatchEvent(event_piece)
end
return worldMapComViewPiece
