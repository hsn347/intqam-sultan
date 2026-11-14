local worldMapComLodControl = class("worldMapComLodControl", include("worldMapCom"))
function worldMapComLodControl:ctor()
	worldMapComLodControl.super.ctor(self, "worldMapComLodControl")
end
function worldMapComLodControl:init()
	worldMapComLodControl.super.init(self)
end
function worldMapComLodControl:onMessageListener()
	_ENV = nil
	;(nil)[gKingdomClassType.nebula] = true
	;(nil)[gKingdomClassType.nebulaEmperor] = true
	local _ENV, (nil)[gKingdomClassType.nebulaAllStar], waterConfig = gKingdomClassType.nebulaAllStar, true, nil
	gKingdomClassType.nebulaAllStar[gKingdomClassType.roaringFlame] = true
	gKingdomClassType.nebulaAllStar[gKingdomClassType.simulatedDrill] = true
	local gKingdomClassType.nebulaAllStar[gKingdomClassType.garden], water2ControlConfig = true, gKingdomClassType.nebulaAllStar
	local mapClassType = self.target_.mapClassType
	if waterConfig[mapClassType] then
		self.waterLayer = self.target_._tmxview:getLayer("water")
	elseif water2ControlConfig[mapClassType] then
		self.waterLayer2 = self.target_._tmxview:getLayer("water")
	else
		self.waterLayer = self.target_.groundLayer:getLayer("water")
	end
	self.customMapLayer = self.target_._tmxview.customMapLayer
	_ENV, _ENV, self.hideLayerList, _ENV, self.tmxview = self.target_.groundLayer, self.target_._tmxview, self.target_._tmxview, self.target_._tmxview, self.target_._tmxview
	_UPVALUE3_ = nil
	_ENV, self.target_._tmxview.lod_2, self.target_.groundLayer[gKingdomClassType.garden], (nil)[1] = self.target_.groundLayer, self.target_.groundLayer, nil, "combine_land_10"
	_ENV, self.target_._tmxview.lod_2, self.target_.groundLayer[gKingdomClassType.garden], (nil)[2] = self.target_.groundLayer, self.target_.groundLayer, nil, "worldMapObject_11"
	_ENV, self.target_._tmxview.lod_2, self.target_.groundLayer[gKingdomClassType.garden], (nil)[3] = self.target_.groundLayer, self.target_.groundLayer, nil, "worldMapObject_12"
	_UPVALUE5_ = nil
	_ENV, self.target_._tmxview.lod_3, self.target_.groundLayer[gKingdomClassType.roaringFlame], (nil)[1] = self.target_.groundLayer, self.target_.groundLayer, nil, "tile03_10"
	_ENV, self.target_._tmxview.lod_3, self.target_.groundLayer[gKingdomClassType.roaringFlame], (nil)[2] = self.target_.groundLayer, self.target_.groundLayer, nil, "tile03_11"
	_ENV, self.target_._tmxview.lod_3, self.target_.groundLayer[gKingdomClassType.roaringFlame], (nil)[3] = self.target_.groundLayer, self.target_.groundLayer, nil, "combine_land_18"
	_ENV, self.target_._tmxview.lod_3, self.target_.groundLayer[gKingdomClassType.roaringFlame], (nil)[4] = self.target_.groundLayer, self.target_.groundLayer, nil, "worldMapObject_20"
	_ENV, self.target_._tmxview.lod_3, self.target_.groundLayer[gKingdomClassType.roaringFlame], (nil)[5] = self.target_.groundLayer, self.target_.groundLayer, nil, "worldMapObject_21"
	_UPVALUE2_ = nil
	self.target_._tmxview["scale_0.05"], self.target_.groundLayer[gKingdomClassType.garden], (nil)[1] = self.target_.groundLayer, nil, "tile01"
	self.target_._tmxview["scale_0.05"], self.target_.groundLayer[gKingdomClassType.garden], (nil)[2] = self.target_.groundLayer, nil, "tile02"
	local hideLayerConfig = self.target_._tmxview
	for key, hideLayerCfg in pairs(hideLayerConfig) do
		self.hideLayerList[key], _ENV = "worldMapObject_20", "worldMapObject_20"
		if not hideLayerCfg[mapClassType] then
			_ENV = hideLayerCfg[mapClassType]
		end
		for __, layerName in ipairs(hideLayerCfg[mapClassType]) do
			local layer = self.target_._tmxview:getLayer(layerName)
			table.insert(self.hideLayerList[key], layer)
		end
	end
	dump(self.hideLayerList, "==self.hideLayerList==")
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:addEventListener(worldMapEvent.EVENT_CELL_CHANGE, handler(self, self.updateCellChange))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellChange))
end
function worldMapComLodControl:creatMapLod5()
	if self.nodeMapLod5 then
		return
	end
	self:initMapLod5()
end
function worldMapComLodControl:initMapLod5()
	local worldMapUtil = include("worldMapUtil")
	local tmxFile = worldMapUtil.getTileMapTmxForPlatform("tileMaps/WorldMapNew_lod5")
	local tmxview = SoraDTMXTiledMap:create(tmxFile)
	tmxview:setName("tileMapTmx5")
	tmxview:ignoreAnchorPointForPosition(false)
	tmxview:setAnchorPoint(cc.p(0.5, 0.5))
	local curCell = self.target_.currentInMapViewCell
	tmxview:setPosition(curCell:getPosition())
	tmxview:setScale(10.008333333333333)
	self.target_:setTmxCulledRect(tmxview)
	local Z_ORDER = worldMapDefine.Z_ORDER
	tmxview:addTo(self.target_.containerView, Z_ORDER.tmxView)
	tmxview:setCascadeOpacityEnabled(true)
	tmxview:setCascadeColorEnabled(true)
	self.nodeMapLod5 = tmxview
end
function worldMapComLodControl:updateCellChange()
	if self.nodeMapLod5 then
		self.nodeMapLod5:setPosition(cc.p(self.target_.currentInMapViewCell:getPosition()))
	end
end
function worldMapComLodControl:toggle3D()
	if self.nodeMapLod5 then
		self.target_:setTmxCulledRect(self.nodeMapLod5)
	end
end
function worldMapComLodControl:creatMapLod6()
	if self.nodeMapLod6 then
		return
	end
	local mapWidth = self.target_.mapSize.width
	self:initMapLod6(mapWidth)
end
function worldMapComLodControl:initMapLod6(mapWidth)
	local length = mapWidth * 128
	local node = display.newNode()
	local Z_ORDER = worldMapDefine.Z_ORDER
	node:addTo(self.target_.containerView, Z_ORDER.tmxView)
	local containerViewSize = self.target_.containerViewSize
	node:setPosition(containerViewSize.width / 2, containerViewSize.height / 2)
	node:setGroupID(worldMapDefine.GROU_ID.tileEffectBatchNode)
	node:setGroupAuto(true)
	node:setName("lodMap6")
	node:setVisible(false)
	local scale = length / 875
	local addMap = function(config)
		local map = display.newSprite("#lod_map_bigLOD6.png")
		map:setPosition(config.pos)
		map:setAnchorPoint(config.anchorPoint)
		map:setName(config.name)
		map:setScale(scale)
		map:setAutoCull(false)
		node:addChild(map, 1)
	end
	_ENV, _UPVALUE4_ = containerViewSize.height / 2, false
	;(containerViewSize.height / 2).name = "map_left"
	;(containerViewSize.height / 2).pos = cc.p(0.0, 0.0)
	_ENV, (containerViewSize.height / 2).anchorPoint = cc.p(1.0, 0.5), cc.p(1.0, 0.5)
	cc.p(1.0, 0.5).name = "map_right"
	cc.p(1.0, 0.5).pos = cc.p(0.0, 0.0)
	_ENV, cc.p(1.0, 0.5).anchorPoint = cc.p(0.0, 0.5), cc.p(0.0, 0.5)
	cc.p(0.0, 0.5).name = "map_top"
	cc.p(0.0, 0.5).pos = cc.p(0.0, 0.0)
	_ENV, cc.p(0.0, 0.5).anchorPoint = cc.p(0.5, 0.0), cc.p(0.5, 0.0)
	cc.p(0.5, 0.0).name = "map_bottom"
	cc.p(0.5, 0.0).pos = cc.p(0.0, 0.0)
	cc.p(0.5, 0.0).anchorPoint = cc.p(0.5, 1.0)
	;(false)[1] = containerViewSize.height / 2
	;(false)[2] = cc.p(1.0, 0.5)
	;(false)[3] = cc.p(0.0, 0.5)
	local (false)[4], mapCfg = cc.p(0.5, 0.0), false
	for _, v in ipairs(mapCfg) do
		addMap(v)
	end
	self.nodeMapLod6 = node
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapComLodControl:updateLodChange(event)
	local lod = event.lod
	if self.waterLayer then
		local filerEnable = lod <= worldLodDef.LOD2
		self.waterLayer:setIsFilterEnable(filerEnable)
		local show = lod <= worldLodDef.LOD3
		if self.target_.mapClassType == gKingdomClassType.nebula or self.target_.mapClassType == gKingdomClassType.nebulaEmperor or self.target_.mapClassType == gKingdomClassType.nebulaAllStar then
			show = true
		end
		self.waterLayer:setVisible(show)
	end
	if self.customMapLayer then
		local show = lod <= worldLodDef.LOD4
		self.customMapLayer:setVisible(show)
	end
	if self.tmxview then
		local show = lod <= worldLodDef.LOD4
		self.tmxview:setVisible(show)
		if show then
			local v = 255
			self.tmxview:setColor(cc.c3b(v, v, v))
			self.tmxview:setOpacity(v)
		end
	end
	do
		local show = lod >= worldLodDef.LOD5
		if show then
			if not self.nodeMapLod5 then
				self:creatMapLod5()
			end
			self.nodeMapLod5:setVisible(true)
			local v = 255
			self.nodeMapLod5:setColor(cc.c3b(v, v, v))
			self.nodeMapLod5:setOpacity(v)
		elseif self.nodeMapLod5 then
			self.nodeMapLod5:setVisible(false)
		end
	end
	local isShow = lod <= worldLodDef.LOD2
	if not self.hideLayerList.lod_2 then
		local worldLodDef, hideLayerList = self.hideLayerList.lod_2, self.hideLayerList.lod_2
	end
	for __, layer in ipairs(hideLayerList) do
		layer:setVisible(isShow)
	end
	local isShow = lod <= worldLodDef.LOD3
	if not self.hideLayerList.lod_3 then
		local worldLodDef, hideLayerList = self.hideLayerList.lod_3, self.hideLayerList.lod_3
	end
	for __, layer in ipairs(hideLayerList) do
		layer:setVisible(isShow)
	end
end
function worldMapComLodControl:updateScaleZoom(event)
	local lodFade = event.lodFade
	if lodFade and lodFade == worldLodDef.LOD5 then
		if not self.nodeMapLod5 then
			self:creatMapLod5()
		end
		local percent = event.percent
		do
			local v = 255 * percent
			self.nodeMapLod5:setColor(cc.c3b(v, v, v))
			self.nodeMapLod5:setOpacity(v)
		end
		local v = 255 * (1.0 - percent)
		self.tmxview:setColor(cc.c3b(v, v, v))
		self.tmxview:setOpacity(v)
	end
	if self.lodFade ~= lodFade then
		self.lodFade = lodFade
		if self.nodeMapLod5 then
			self.nodeMapLod5:setVisible(self.lodFade == worldLodDef.LOD5 or event.lod >= worldLodDef.LOD5)
		end
	end
	if self.waterLayer2 then
		local zoomScale = event.scale
		local showWater = 0.05 < zoomScale
		self.waterLayer2:setVisible(showWater)
	end
	local isShow = event.scale >= 0.05
	if not self.hideLayerList["scale_0.05"] then
		local worldLodDef, hideLayerList = self.hideLayerList["scale_0.05"], self.hideLayerList["scale_0.05"]
	end
	for __, layer in ipairs(hideLayerList) do
		layer:setVisible(isShow)
	end
end
function worldMapComLodControl:exportMethods()
	return self.target_
end
return worldMapComLodControl
