local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local _ENV, mapSyncUtilClient = gametop.playertop_, gametop.playertop_
local ClientTOServer = 1
local ServerTOClient = -1
local ClientTOServerPos = function(pos)
	return cc.p(pos.x + ClientTOServer, pos.y + ClientTOServer)
end
local ServerTOClientPos = function(pos)
	return cc.p(pos.x + ServerTOClient, pos.y + ServerTOClient)
end
function mapSyncUtilClient.clientTOServerPos(pos)
	return ClientTOServerPos(pos)
end
function mapSyncUtilClient.serverTOClientPos(pos)
	return ServerTOClientPos(pos)
end
local _ENV, mapSyncCfg = function(pos)
	return ServerTOClientPos(pos)
end, function(pos)
	return ServerTOClientPos(pos)
end
local getMapSyncUtil = function(kingdomClass, lod)
	kingdomClass = kingdomClass or gKingdomClassType.normal
	lod = lod or 1
	local id = kingdomClass * 100 + lod
	local cfg = mapSyncCfg[id]
	if cfg then
		return cfg
	end
	local mapSyncUtil = include("mapSyncUtil")
	cfg = mapSyncUtil.new(kingdomClass, lod)
	mapSyncCfg[id] = cfg
	return cfg
end
mapSyncUtilClient.getMapSyncUtil = getMapSyncUtil
function mapSyncUtilClient.isViewInSingleMap(centerPoint, kingdomClass, lod)
	local centerServer = ClientTOServerPos(centerPoint)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	return mapSyncUtil:isViewInSingleMap(centerServer.x, centerServer.y)
end
function mapSyncUtilClient.getViewPieceIds(centerX, centerY, kingdomClass, lod)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	return mapSyncUtil:getViewPieceIds(centerX, centerY)
end
function mapSyncUtilClient.reqMapSync(worldMapView, centerKid, centerPoint, isSingleMapCell, kingdomClass, lod)
	if isSingleMapCell or kingdomCtrl:isFoundKingdomID(centerKid) then
		kingdomMapCtrl:reqMapSync(centerKid, centerPoint.x, centerPoint.y, lod)
		local centerServer = ClientTOServerPos(centerPoint)
		local kingdomCtrl, pieceIds = centerPoint, centerPoint
		local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
		pieceIds[tostring(centerKid)] = mapSyncUtil:getViewPieceIds(centerServer.x, centerServer.y)
		kingdomMapCtrl:setViewPieceIds(pieceIds, lod)
		worldMapView:setViewPieceIds(pieceIds, lod)
		return true
	else
		kingdomMapCtrl:reqMapSync(centerKid, centerPoint.x, centerPoint.y, lod)
		kingdomCtrl = centerKid
		worldMapView:setViewPieceIds(centerKid, lod)
	end
end
local getKingdomID = function(kid)
	return kingdomCtrl:isFoundKingdomID(kid) and kid or nil
end
function mapSyncUtilClient.reqMapSyncBorder(worldMapView, centerKid, centerPoint, ltKid, lbKid, rbKid, rtKid, kingdomClass, lod)
	local ltKidReal = getKingdomID(ltKid)
	local lbKidReal = getKingdomID(lbKid)
	local rbKidReal = getKingdomID(rbKid)
	local rtKidReal = getKingdomID(rtKid)
	if not ltKidReal and not lbKidReal and not rbKidReal and not rtKidReal then
		print("error kid")
		return false
	end
	local kid = getKingdomID(centerKid)
	if not kid then
		if ltKid == centerKid then
			ltKidReal = ltKid
		elseif lbKid == centerKid then
			lbKidReal = lbKid
		elseif rbKid == centerKid then
			rbKidReal = rbKid
		elseif rtKid == centerKid then
			rtKidReal = rtKid
		end
	end
	local centerServer = ClientTOServerPos(centerPoint)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	if not mapSyncUtil:getCrossKingdomPieceIds(centerKid, centerServer.x, centerServer.y, ltKidReal, lbKidReal, rbKidReal, rtKidReal) then
		local getKingdomID, viewPieceIDs = mapSyncUtil:getCrossKingdomPieceIds(centerKid, centerServer.x, centerServer.y, ltKidReal, lbKidReal, rbKidReal, rtKidReal), mapSyncUtil:getCrossKingdomPieceIds(centerKid, centerServer.x, centerServer.y, ltKidReal, lbKidReal, rbKidReal, rtKidReal)
	end
	if not kid then
		viewPieceIDs[tostring(centerKid)] = nil
	end
	if not kid and not next(viewPieceIDs) then
		print("error kid and viewPieceIDs")
		return false
	end
	kingdomMapCtrl:reqMapSync(kid, centerPoint.x, centerPoint.y, lod, viewPieceIDs)
	if viewPieceIDs then
		kingdomMapCtrl:setViewPieceIds(viewPieceIDs, lod)
		worldMapView:setViewPieceIds(viewPieceIDs, lod)
	else
		local getKingdomID, pieceIds = worldMapView.setViewPieceIds, worldMapView.setViewPieceIds
		pieceIds[tostring(centerKid)] = mapSyncUtil:getViewPieceIds(centerServer.x, centerServer.y)
		kingdomMapCtrl:setViewPieceIds(pieceIds, lod)
		worldMapView:setViewPieceIds(pieceIds, lod)
	end
	return true
end
local RECT_ZERO = cc.rect(0, 0, 0, 0)
local translateRect = function(rect)
	if rect.ltX >= rect.rbX or rect.ltY >= rect.rbY then
		return RECT_ZERO
	end
	return cc.rect(rect.ltX - ClientTOServer, rect.ltY - ClientTOServer, rect.rbX - rect.ltX, rect.rbY - rect.ltY)
end
function mapSyncUtilClient.getViewRect(centerPoint, kingdomClass, lod)
	local centerServer = ClientTOServerPos(centerPoint)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	local rect = mapSyncUtil:getViewRect(centerServer.x, centerServer.y)
	return translateRect(rect)
end
function mapSyncUtilClient.getViewRectBorder(centerKid, centerPoint, ltKid, lbKid, rbKid, rtKid, kingdomClass, lod)
	local centerServer = ClientTOServerPos(centerPoint)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	local rectArry = mapSyncUtil:getCrossKingdomViewRect(centerKid, centerServer.x, centerServer.y, ltKid, lbKid, rbKid, rtKid)
	local ClientTOServerPos, rectBorder = mapSyncUtil, mapSyncUtil
	for kid, rect in pairs(rectArry) do
		rectBorder[kid] = translateRect(rect)
	end
	return rectBorder
end
function mapSyncUtilClient.getPieceId(pos, kingdomClass, lod)
	local centerServer = ClientTOServerPos(pos)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	return mapSyncUtil:getPieceId(centerServer.x, centerServer.y)
end
function mapSyncUtilClient.getLineCrossPieceIds(fromX, fromY, toX, toY, kingdomClass, lod)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	return mapSyncUtil:getLineCrossPieceIds(fromX, fromY, toX, toY)
end
function mapSyncUtilClient.isLineCrossPieces(piecePosList, pos1, pos2, kingdomClass, lod)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	return mapSyncUtil:isLineCrossPieces(piecePosList, pos1.x + ClientTOServer, pos1.y + ClientTOServer, pos2.x + ClientTOServer, pos2.y + ClientTOServer)
end
function mapSyncUtilClient.isLineOutRect(piecePosList, pos1, pos2, kingdomClass, lod)
	local mapSyncUtil = getMapSyncUtil(kingdomClass, lod)
	return not mapSyncUtil:isLineCrossPieces(piecePosList, pos1.x + ClientTOServer, pos1.y + ClientTOServer, pos2.x + ClientTOServer, pos2.y + ClientTOServer)
end
return mapSyncUtilClient
