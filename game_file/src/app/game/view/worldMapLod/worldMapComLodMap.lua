local worldMapComLodMap = class("worldMapComLodMap", function(target)
	return target
end)
function worldMapComLodMap:ctor()
	self:initWidget()
end
function worldMapComLodMap:initWidget(...)
	SoraDGetAllChildFromWidget(self, self)
	self:initWarLodMapUI()
	self.Image_rect:setScale(2.0)
	if G_IS_UNITY then
		self.Image_rect:setScale9Enabled(false)
	end
	self:addTouchEventListener(handler(self, self.panelMapClick))
	local containerViewSize = self:getContentSize()
	local offsetX = 0
	local offsetY = 0
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	local maxNum = worldMapDefine.getMaxCoordinateByKid() + 1
	self.zeroPoint = cc.p(containerViewSize.width / 2, containerViewSize.height)
	self.tileW = self.mapwidth / maxNum
	self.tileH = self.mapheight / maxNum
	if SoraDFIsRA() then
		self:setPositionY(display.height - 140)
	else
		self:setPositionY(display.height - 165)
	end
end
function worldMapComLodMap:initNebulaWarUI(...)
	self.Sprite_map:setSpriteFrame("lod_nebula_map.png")
	local mapSize = self.Sprite_map:getContentSize()
	self.Sprite_map:setScale(240 / mapSize.width)
end
function worldMapComLodMap:initAtlantisWarUI(...)
	local atlantisWarUtil = include("atlantisWarUtil")
	if atlantisWarUtil.isNewMap() then
		self.Sprite_map:setSpriteFrame("frame_shmc_xdt.png")
	else
		self.Sprite_map:setSpriteFrame("frame_shmc_xdt_ROS.png")
	end
	local mapSize = self.Sprite_map:getContentSize()
	self.Sprite_map:setScale(240 / mapSize.width)
	self.Sprite_map:setPositionY(-4)
end
function worldMapComLodMap:initPyramidWarUI(...)
	self.Sprite_map:setSpriteFrame("lod_pyramid_map.png")
	local mapSize = self.Sprite_map:getContentSize()
	self.Sprite_map:setScale(240 / mapSize.width)
end
function worldMapComLodMap:initWarLodMapUI()
	if worldMapDefine.isNebulaKingdomID() then
		self:initNebulaWarUI()
	elseif worldMapDefine.isAtlantisKingdomID() then
		self:initAtlantisWarUI()
	elseif worldMapDefine.isPyramidKingdomID() then
		self:initPyramidWarUI()
	else
		local worldMapWarDef = include("worldMapWarDef")
		local mapName = worldMapWarDef.getWarLodMapName()
		if mapName then
			self.Sprite_map:setSpriteFrame(mapName)
			local mapSize = self.Sprite_map:getContentSize()
			self.Sprite_map:setScale(240 / mapSize.width)
			self.Image_north:setVisible(false)
			self.Image_south:setVisible(false)
		end
	end
end
function worldMapComLodMap:setWorldMapView(worldMapView)
	self.worldMapView = worldMapView
	self.mapSize = worldMapView.mapSize
end
function worldMapComLodMap:tilePos2MapPos(tilePos)
	local tileX = tilePos.x + 0.5
	local tileY = tilePos.y + 0.5
	return worldMapDefine.tile2point(self.zeroPoint, cc.p(tileX, tileY), self.tileW, self.tileH)
end
function worldMapComLodMap:mapPos2TilePos(point)
	local tilePos = worldMapDefine.point2tile(point, self.zeroPoint, self.tileW, self.tileH)
	tilePos.x = math.max(0, math.min(self.mapSize.width - 1, tilePos.x))
	tilePos.y = math.max(0, math.min(self.mapSize.height - 1, tilePos.y))
	return tilePos
end
function worldMapComLodMap:updateData(data)
	if data.centerTilePoint then
		local pos = self:tilePos2MapPos(data.centerTilePoint)
		self.Image_rect:setPosition(pos)
	end
	if data.myCityTilePoint then
		local pos = self:tilePos2MapPos(data.myCityTilePoint)
		self.Sprite_self:setPosition(pos)
	end
end
function worldMapComLodMap:panelMapClick(target, event)
	if event == ccui.TouchEventType.began then
		SoraDPlaySound()
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchPoint = self:convertToNodeSpace(touchBeganPoint)
		local tilePos = self:mapPos2TilePos(touchPoint)
		_ENV = nil
		;(nil).toTilePos = tilePos
		;(nil).kingdomID = worldMapDefine.currentMapKindomID
		self.worldMapView:gotoTilePointNew(nil, nil)
	elseif event == ccui.TouchEventType.moved then
		local touchMovePoint = target:getTouchMovePosition()
		local touchPoint = self:convertToNodeSpace(touchMovePoint)
		local tilePos = self:mapPos2TilePos(touchPoint)
		_ENV = nil
		;(nil).toTilePos = tilePos
		;(nil).kingdomID = worldMapDefine.currentMapKindomID
		self.worldMapView:gotoTilePointNew(nil, nil)
	end
end
function worldMapComLodMap:setSpriteSelfVisible(isVisible)
	self.Sprite_self:setVisible(isVisible)
end
return worldMapComLodMap
