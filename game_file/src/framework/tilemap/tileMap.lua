local m = fgui.SuperTileMap
function m:create(tmxFile)
	local node = m()
	if node then
		node:autoRelease()
		node:setAnchorPoint(0, 0)
		node:setPosition(0, 0)
		node:SetTileMap(tmxFile)
		node:initLayer()
	end
	return node
end
function m:initLayer()
	self.__layer, _ENV = nil, nil
	local superMap = self.superMap
	if superMap then
		local tileH = superMap.m_TileWidth
		local tileW = superMap.m_TileHeight
		local mapH = superMap.m_Width
		local mapW = superMap.m_Height
		self.__tileSize = cc.size(tileH, tileW)
		self.__mapSize = cc.size(mapH, mapW)
	else
		self.__tileSize = cc.size(256, 128)
		self.__mapSize = cc.size(1201, 1201)
	end
	self.__contentSize = cc.size(self.__mapSize.width * self.__tileSize.width, self.__mapSize.height * self.__tileSize.height)
	self:setContentSize(self.__contentSize)
	local w = self.__tileSize.width
	local h = self.__tileSize.height
	local offY = (self.__mapSize.height - 1) * h
	local offX = (self.__mapSize.width - 1) * w / 2
	_UPVALUE16_ = mapH
	mapH[1] = w * 0.5
	mapH[2] = -h * 0.5
	mapH[3] = 0
	mapH[4] = 0
	mapH[5] = -w * 0.5
	mapH[6] = -h * 0.5
	mapH[7] = 0
	mapH[8] = 0
	mapH[9] = 0
	mapH[10] = 0
	mapH[11] = 1
	mapH[12] = 0
	mapH[13] = offX
	mapH[14] = offY
	mapH[15] = 0
	mapH[16] = 1
	self.matTileToNode = cc.mat4.new(mapH)
end
function m:setObjectGroups(groups)
end
function m:setCulledRect(rect)
end
function m:getProperty(propertyName)
end
function m:getObjectGroup(groupName)
end
function m:toggleDebugLayer()
end
function m:getObjectGroup()
end
function m:setTileSize(tileSize)
	self.__tileSize = tileSize
end
function m:getTileSize()
	return self.__tileSize
end
function m:setMapSize(mapSize)
	self.__mapSize = mapSize
end
function m:getMapSize()
	return self.__mapSize
end
function m:getProperties()
end
function m:getPropertiesForGID(GID)
end
function m:setProperties(properties)
end
function m:getLayer(layerName)
	local layer = self.__layer[layerName]
	if not layer then
		local superLayer = self:GetSuperLayer(layerName)
		layer = cc.TileLayer:create(layerName, self, superLayer)
		self.__layer[layerName] = layer
		layer:addTo(self)
	end
	return layer
end
function m:getMapOrientation()
end
function m:setMapOrientation(mapOrientation)
end
function m:createWithXML(tmxString, resourcePath)
end
function m:getDescription()
end
return m
