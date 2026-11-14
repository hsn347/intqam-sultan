local m = class("tileLayer", function(name, tileMap, superLayer)
	local target = display.newNode()
	return target
end)
function m:ctor(name, tileMap, superLayer)
	self.__tileSize = tileMap:getTileSize()
	self.__mapSize = tileMap:getMapSize()
	self.__superLayer = superLayer
	self:setName(name)
	self:setContentSize(tileMap.__contentSize)
	self.matTileToNode = tileMap.matTileToNode
	self.setVisible_old = self.setVisible
	function self.setVisible(_, visible)
		self.setVisible_old(self, visible)
		if self.__superLayer then
			self.__superLayer:SetActive(visible)
		end
	end
	self.comSuperTileLayer = tileMap:GetComSuperTileLayer(self.__superLayer)
	self.comTileMap = tileMap:GetComTileMap(self.__superLayer)
	if self.comSuperTileLayer then
		self.firstGID = self.comSuperTileLayer.m_FirstGID
	else
		self.firstGID = 0
	end
end
function m:getTileGIDAt(tileCoordinate, flags)
	if self.comTileMap then
		local baseID = self.comTileMap:getTiledId(tileCoordinate.x, tileCoordinate.y)
		if 0 < baseID then
			return baseID + self.firstGID
		end
	end
	return 0
end
function m:getPositionAt(tilePos)
	_UPVALUE2_ = nil
	;(nil)[1] = tilePos.x
	;(nil)[2] = tilePos.y
	local pos = self.matTileToNode:multiplyMat4WithPos2(nil)
	return pos
end
function m:getTileIndexByPos(x, y)
end
function m:setLayerOrientation(orientation)
end
function m:setFilterGID(filterGIDs)
end
function m:setupTileAt(gid, tileCoordinate)
end
local _ENV, emptyRect = function(self, gid, tileCoordinate)
end, function(self, gid, tileCoordinate)
end
function m:getRectRegionTiles(rect)
	return emptyRect
end
function m:getLayerSize()
end
function m:getVertexZForPos(pos)
end
function m:setMapTileSize(size)
end
function m:getLayerOrientation()
end
function m:setProperties(properties)
end
function m:setLayerName(layerName)
end
function m:removeTileAt(tileCoordinate)
end
function m:getPropertie()
end
function m:setupTiles()
end
function m:setFlaggedTileGIDByIndex(index, gid)
end
function m:setBeginShowGid(gid)
end
function m:setIsFilterEnable(enable)
end
function m:initFilterLayer(filterGIDs, state)
end
function m:setFilterBlendFunc(blendFunc)
end
function m:getMapTileSize()
end
function m:getProperty(propertyName)
end
function m:setLayerSize(size)
end
function m:getLayerName()
end
function m:setTileSet(info)
end
function m:setCulledRect(rect)
end
function m:getTileSet()
end
function m:getTileAt(tileCoordinate)
end
function m:create(name, tileMap, superLayer)
	local node = m.new(name, tileMap, superLayer)
	return node
end
function m:getDescription()
end
return m
