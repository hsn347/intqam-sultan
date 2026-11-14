local worldMapComPage = class("worldMapComPage", include("worldMapCom"))
local worldMapUtil = include("worldMapUtil")
function worldMapComPage:ctor()
	worldMapComPage.super.ctor(self, "worldMapComPage")
end
function worldMapComPage:init()
	worldMapComPage.super.init(self)
	self.centerTilePos = cc.p(-1, -1)
	self.centerPage = -1
	self.curPages, worldMapComPage, self.pageObjectMgr = include("pageObjectMgr").new(self), include("pageObjectMgr").new(self), include("pageObjectMgr").new(self)
	self.stop = false
	self.animateLayer = display.newNode()
	self.animateLayer:setName("animateLayer")
	local Z_ORDER = worldMapDefine.Z_ORDER
	self.animateLayer:addTo(self.target_.containerView, Z_ORDER.containerView - 1)
end
function worldMapComPage:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_CELL_CHANGE, handler(self, self.updateCellChange))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:updateCellChange()
end
function worldMapComPage:updateCellChange()
	local posx, posy = self.target_.currentInMapViewCell:getPosition()
	local size = self.target_.currentInMapViewCell:getContentSize()
	self.animateLayer:setPosition(cc.p(posx - size.width / 2, posy - size.height / 2))
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapComPage:updateLodChange(event)
	local lod = event.lod
	self.stop = lod >= worldLodDef.LOD2
	self.animateLayer:setVisible(not self.stop)
	if lod >= worldLodDef.LOD3 and next(self.curPages) then
		self:updatePage()
	end
end
function worldMapComPage:addAnimateNode(animateNode, pos)
	local beginPoint = self.target_.currentInMapViewCell:getPointWithTile(pos)
	animateNode:addTo(self.animateLayer)
	animateNode:setPosition(beginPoint)
end
function worldMapComPage:updatePage(pageShow)
	if not pageShow then
		pageShow, _ENV = nil, nil
	end
	local curPages = self.curPages
	local _ENV, addPages
	for k in pairs(pageShow) do
		if not curPages[k] then
			table.insert(addPages, k)
		end
	end
	local _ENV, delPages = (for generator), pairs(pageShow)
	for k in pairs(curPages) do
		if not pageShow[k] then
			table.insert(delPages, k)
		end
	end
	self.curPages = pageShow
	if self.pageObjectMgr then
		self.pageObjectMgr:delPages(delPages)
		self.pageObjectMgr:addPages(addPages)
	end
end
function worldMapComPage:setDisplayCenterTilePoint(pos)
	if self.stop then
		return
	end
	if pos.x == self.centerTilePos.x and pos.y == self.centerTilePos.y then
		return
	end
	self.centerTilePos = pos
	local pageID = worldMapUtil.getPageIDByPos(self.centerTilePos)
	if pageID == self.centerPage then
		return
	end
	self.centerPage = pageID
	local target_ = self.target_
	local scale = target_.viewScrollView:getZoomScale()
	local tilesRectWidth = 1.5 * display.width / scale
	local tilesRectHeight = 1.5 * display.height / scale
	local centerPoint = target_.containerView:convertToNodeSpace(target_.reqMapCenterPoint)
	local mapViewCell = target_.currentInMapViewCell
	local covertCenterPoint = SoraDCoverToPoint2DOr3D(target_.containerView, centerPoint, mapViewCell)
	local leftBottomPointX = covertCenterPoint.x - tilesRectWidth / 2
	local leftBottomPointY = covertCenterPoint.y - tilesRectHeight / 2
	local tilesArray = target_.mapLayer:getRectRegionTiles(cc.rect(leftBottomPointX, leftBottomPointY, tilesRectWidth, tilesRectHeight))
	if 2 <= #tilesArray then
		local rectBeginPointTable = SoraDStringSplit(tilesArray[1], ",")
		local rectEndPointTable = SoraDStringSplit(tilesArray[2], ",")
		local minX = tonumber(rectBeginPointTable[1])
		local minY = tonumber(rectBeginPointTable[2])
		local maxX = tonumber(rectEndPointTable[1])
		local maxY = tonumber(rectEndPointTable[2])
		local pageShow = worldMapUtil.getShowPageByRect(minX, maxX, minY, maxY)
		self:updatePage(pageShow)
	else
		self:updatePage()
	end
end
function worldMapComPage:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "setDisplayCenterTilePoint"
	self:exportMethods_(nil, true)
	return self.target_
end
return worldMapComPage
