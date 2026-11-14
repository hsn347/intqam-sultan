local worldMapViewDef = include("worldMapViewDef")
local mapSyncUtilClient = include("mapSyncUtilClient")
local worldMapViewSingle = class("worldMapViewSingle", function(target)
	return target
end)
local GROU_ID = worldMapDefine.GROU_ID
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
function worldMapViewSingle:ctor()
	self.isSingleMapCell = true
end
function worldMapViewSingle:initMapCell_imp()
	local width = math.max(display.width, math.floor(display.width / worldMapViewDef.MIN_SCALE))
	local height = math.max(display.height, math.floor(display.height / worldMapViewDef.MIN_SCALE))
	self.containerViewSize = cc.size(self.mapViewSize.width + width, self.mapViewSize.height + height)
	local pos = cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2)
	local mapViewCell = self:createOneMapCell()
	mapViewCell:setPosition(pos)
	mapViewCell:setName("mapViewCell")
	worldMapViewDef = mapViewCell.setName
	self.mapViewCellArray, mapViewCell.setName[1] = mapViewCell.setName, mapViewCell
	self.currentInMapViewCell = mapViewCell
	self.selfInMapView = mapViewCell
	self.containerView:setContentSize(self.containerViewSize)
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.showWorldMapViewColorLayer() then
		self:initColorLayer()
		self:setLightMapcell(self.currentInMapViewCell)
	end
	self.mapViewTan = self.mapViewSize.height / self.mapViewSize.width
	self.totalWidth = self.containerViewSize.width * 0.5
	self.totalHeight = self.containerViewSize.height * 0.5
	self.totalHeightTouch = self.mapViewSize.height * 0.5
	self.totalWidthTouch = self.mapViewSize.width * 0.5
	self.screenWidth = display.width * 0.5
	self.screenHeight = display.height * 0.5
end
function worldMapViewSingle:initColorLayer()
	local colorLayerSize = self.containerViewSize
	local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 128))
	colorLayer:setContentSize(colorLayerSize)
	colorLayer:ignoreAnchorPointForPosition(false)
	colorLayer:setAnchorPoint(cc.p(0.5, 0.5))
	colorLayer:setPosition(cc.p(self.containerViewSize.width / 2, self.containerViewSize.height / 2))
	self.mapViewcliperNode = cc.ClippingNode:create()
	self.mapViewcliperNode:addChild(colorLayer)
	self.mapViewcliperNode:setInverted(true)
	self.mapViewcliperNode:addTo(self.containerView, Z_ORDER_CELL.objView)
	self.mapViewcliperNode:setName("mapViewcliperNode")
	_ENV = self.mapViewcliperNode.setName
	self.mapViewcliperNode.setName.fillColor = cc.c4f(1, 1, 1, 0.5)
	self.mapViewcliperNode.setName.borderColor = cc.c4f(0, 1, 0, 0)
	local _UPVALUE2_, _UPVALUE4_, self.mapViewcliperNode.setName.borderWidth, params = 0, cc.c4f(0, 1, 0, 0), 0, self.mapViewcliperNode.setName
	_UPVALUE2_, (0)[1] = -200, -200
	_UPVALUE2_, (0)[2] = -200, 0
	_UPVALUE2_, (-200)[1] = 0, 0
	_UPVALUE2_, (-200)[2] = 0, 100
	_UPVALUE2_, (0)[1] = 200, 200
	_UPVALUE2_, (0)[2] = 200, 0
	;(200)[1] = 0
	;(200)[2] = -100
	cc.c4f(0, 1, 0, 0)[1] = 0
	cc.c4f(0, 1, 0, 0)[2] = -200
	cc.c4f(0, 1, 0, 0)[3] = 0
	local cc.c4f(0, 1, 0, 0)[4], points = 200, cc.c4f(0, 1, 0, 0)
	local shapNode = display.newPolygon(points, params)
	shapNode:setName("shapNode")
	shapNode:setScale(self.mapViewSize.width / 400)
	shapNode:ignoreAnchorPointForPosition(false)
	shapNode:setAnchorPoint(cc.p(0.5, 0.5))
	self.mapViewcliperNode:setStencil(shapNode)
	self.shapNode = shapNode
end
function worldMapViewSingle:setLightMapcell(mapViewCell)
	if mapViewCell then
		self.shapNode:setVisible(true)
		local posx, posy = mapViewCell:getPosition()
		local posViewX, posViewY = self.mapViewcliperNode:getPosition()
		self.shapNode:setPosition(cc.p((posx - posViewX) * 1.0, (posy - posViewY) * 1.0))
	else
		self.shapNode:setVisible(false)
	end
end
function worldMapViewSingle:getWorldMapCell()
	return self.currentInMapViewCell
end
function worldMapViewSingle:updateCheckSetMapViewCellPoint()
end
function worldMapViewSingle:getMapTilesData_imp()
	local reqcenterTilePos = self.reqcenterTilePos
	local kid = self.currentInMapViewCell.kingdomID
	local lod = self:getCurLod()
	local sendMsg = mapSyncUtilClient.reqMapSync(self, kid, reqcenterTilePos, true, self.mapClassType, lod)
	self.currentInMapViewCell.currentShowRect = mapSyncUtilClient.getViewRect(reqcenterTilePos, self.mapClassType, lod)
	return sendMsg
end
function worldMapViewSingle:scrollFromBorder()
	local zoomScale = self.viewScrollView:getZoomScale()
	local totalWidth = self.totalWidth * zoomScale
	local totalHeight = self.totalHeight * zoomScale
	local totalHeightTouch = self.totalHeightTouch * zoomScale
	local scrollPos = self.viewScrollView:getContainer():getPosition()
	local scrollX = scrollPos.x
	local scrollY = scrollPos.y
	local posX = -totalWidth - scrollX + self.screenWidth
	local posY = -totalHeight - scrollY + self.screenHeight
	local needPosY = math.max(0, math.abs(posX) * -self.mapViewTan + totalHeightTouch)
	if needPosY < math.abs(posY) then
		posY = 0 < posY and needPosY or -needPosY
		local scrollXNew = -posX - totalWidth + self.screenWidth
		local scrollYNew = -posY - totalHeight + self.screenHeight
		if scrollX ~= scrollXNew or scrollY ~= scrollYNew then
			self.viewScrollView:getContainer():setPosition(scrollXNew, scrollYNew)
		end
	end
	local totalWidthTouch = self.totalWidthTouch * zoomScale
	local needPosX = math.max(0, math.abs(posY) / -self.mapViewTan + totalWidthTouch)
	if needPosX < math.abs(posX) then
		posX = 0 < posX and needPosX or -needPosX
		local scrollXNew = -posX - totalWidth + self.screenWidth
		local scrollYNew = -posY - totalHeight + self.screenHeight
		if scrollX ~= scrollXNew or scrollY ~= scrollYNew then
			self.viewScrollView:getContainer():setPosition(scrollXNew, scrollYNew)
		end
	end
end
return worldMapViewSingle
