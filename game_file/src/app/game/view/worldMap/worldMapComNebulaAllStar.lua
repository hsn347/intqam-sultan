local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local worldLodDef = worldMapDefine.worldLodDef
local worldMapComNebulaAllStar = class("worldMapComNebulaAllStar", include("worldMapCom"))
function worldMapComNebulaAllStar:ctor()
	worldMapComNebulaAllStar.super.ctor(self, "worldMapComNebulaAllStar")
end
function worldMapComNebulaAllStar:init()
	self.worldMapCell = self.target_.currentInMapViewCell
	self:initWidget()
	self:initParticleEffect()
	self:initDrawNode()
	self:initRegionNode()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:toggle3D()
end
function worldMapComNebulaAllStar:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_WARDATA", handler(self, self.refreshWarData))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.refreshRelogin))
	self:doReqestData()
end
function worldMapComNebulaAllStar:initWidget(...)
	self.Node_war = SoraDGetChildByName(self.target_, "Node_war")
	self.Node_war:setPositionY(display.iPhoneXBottom - 30)
	self.Node_war:setVisible(false)
	local node = display.newNode()
	node:addTo(self.worldMapCell)
	node:setName("nebulaAllStarNode")
	self.nebulaAllStarNode = node
	local fitScale = math.min(1, display.height / 1136)
	_ENV = display.height / 1136
	;(display.height / 1136).text = ""
	;(display.height / 1136).size = 20
	;(display.height / 1136).align = cc.TEXT_ALIGNMENT_CENTER
	;(display.height / 1136).valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	;(display.height / 1136).color = cc.c3b(240, 230, 210)
	;(display.height / 1136).x = 320
	;(display.height / 1136).y = (display.iPhoneXBottom + 200) * fitScale
	local Text_area = SoraDCreateLabel(display.height / 1136)
	Text_area:addTo(self.Node_war:getParent())
	Text_area:setScale(fitScale)
	Text_area:setGroupID(worldMapDefine.GROU_ID.group_text)
	SoraDSetTextWidthHeight(Text_area, cc.size(200, 30))
	Text_area:setName("Text_area")
	self.Text_area = Text_area
end
function worldMapComNebulaAllStar:doReqestData(...)
	if nebulaAllStarCtrl:getIsViewer() then
		return
	end
	local mapId = worldMapDefine.currentMapKindomID
	nebulaAllStarCtrl:reqWarData(mapId)
end
function worldMapComNebulaAllStar:refreshWarData(...)
	self:createMapTip()
end
function worldMapComNebulaAllStar:refreshRelogin(...)
	print("==worldMapComNebulaAllStar:refreshRelogin==")
	if not nebulaAllStarCtrl:getMyTeamInfo():isHasTeam() and not nebulaAllStarCtrl:getIsViewer() then
		nebulaAllStarCtrl:reqViewerStopSync()
		if SoraDCurrentSceneShowView("worldMapView") then
			SoraDGotoWorldMapPoint(nil, nil, nil, nil, nil, true)
		end
	end
end
function worldMapComNebulaAllStar:createMapTip()
	if self.pyramidTip then
		return
	end
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	self.pyramidTip = pyramidTip
end
function worldMapComNebulaAllStar:getNodeWar()
	return self.Node_war
end
function worldMapComNebulaAllStar:initParticleEffect(...)
	local Z_ORDER = worldMapDefine.Z_ORDER
	_ENV = nil
	;(nil).plist = "Particle/xyzc_bg_par.plist"
	local particle = util.createParticle(nil)
	particle:addTo(self.target_.containerView, Z_ORDER.tmxView - 1)
	particle:setName("xyzc_bg_par")
	particle:setAutoCull(false)
	self.particle = particle
	self.particle_x = 0
	self.particle_y = 0
end
function worldMapComNebulaAllStar:initDrawNode(...)
	self.drawNodeConfig, _ENV, self.borderWidth = nil, nil, 1
	local fillColor = cc.c4f(1, 1, 1, 0)
	local borderColor = cc.c4f(1, 1, 1, 0.5)
	local config = nebulaAllStarUtil.getDrawNodeAreaConfig()
	for __, cfg in ipairs(config) do
		local _ENV, tbPoints
		for __, tile in ipairs(cfg) do
			local point = self.worldMapCell:getPointWithTile(tile)
			table.insert(tbPoints, cc.p(point.x, point.y))
		end
		nebulaAllStarUtil = (for generator)
		ipairs(cfg).fillColor = fillColor
		ipairs(cfg).borderWidth = self.borderWidth
		ipairs(cfg).borderColor = borderColor
		local ipairs(cfg)[1], params = #tbPoints, ipairs(cfg)
		_ENV = nil
		;(nil).tbPoints = tbPoints
		;(nil).params = params
		table.insert(self.drawNodeConfig, nil)
	end
	local drawNode = cc.DrawNode:create()
	drawNode:addTo(self.nebulaAllStarNode)
	self.drawNode = drawNode
	self:updateDrawNode()
end
function worldMapComNebulaAllStar:updateDrawNode(...)
	self.drawNode:clear()
	for __, cfg in ipairs(self.drawNodeConfig) do
		cfg.params.borderWidth = self.borderWidth
		self.drawNode:drawPolygon(cfg.tbPoints, cfg.params)
	end
end
function worldMapComNebulaAllStar:initRegionNode(...)
	local createRegionNode = function(cfg)
		local regionNode = display.newNode()
		local point = self.worldMapCell:getPointWithTile(cfg.tilePos)
		regionNode:setPosition(point)
		local Sprite_arrow = display.newSprite("#frame_xljc_xxjt.png")
		Sprite_arrow:addTo(regionNode)
		Sprite_arrow:setPosition(cc.p(0, -30))
		Sprite_arrow:setScale(0.64)
		local Sprite_arrow = display.newSprite("#frame_xljc_xxjt.png")
		Sprite_arrow:addTo(regionNode)
		Sprite_arrow:setPosition(cc.p(0, -38))
		Sprite_arrow:setScale(0.64)
		Sprite_arrow:setOpacity(127.5)
		local Sprite_bg = display.newSprite("#frame_xykp_tsbg.png")
		Sprite_bg:addTo(regionNode)
		Sprite_bg:setScale(0.8)
		_ENV = Sprite_bg
		Sprite_bg.text = cfg.name or ""
		Sprite_bg.size = 20
		Sprite_bg.align = cc.TEXT_ALIGNMENT_CENTER
		Sprite_bg.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
		Sprite_bg.color = cc.c3b(240, 230, 210)
		local Text_name = SoraDCreateLabel(Sprite_bg)
		Text_name:addTo(regionNode)
		Text_name:setGroupID(worldMapDefine.GROU_ID.group_text)
		SoraDSetTextWidthHeight(Text_name, cc.size(220, 30))
		return regionNode
	end
	_ENV, _ENV, self.regionNodes, _ENV = nil, nil, nil, nil
	;(nil).tilePos = cc.p(150, 110)
	_ENV, (nil)[1], (nil).name = nil, nil, i18n("NebulaAllstar_rule_msg36")
	;(nil).tilePos = cc.p(150, 60)
	_ENV, (nil)[2], (nil).name = nil, nil, i18n("NebulaAllstar_rule_msg42")
	;(nil).tilePos = cc.p(150, 20)
	;(nil)[3], (nil).name = nil, i18n("NebulaAllstar_399")
	local config
	for __, cfg in ipairs(config) do
		local regionNode = createRegionNode(cfg)
		regionNode:addTo(self.nebulaAllStarNode)
		table.insert(self.regionNodes, regionNode)
	end
end
local POINT_ZERO = cc.p(0, 0)
local particle_size = 1024
function worldMapComNebulaAllStar:updateMapPos(event)
	local _tilePoint = self.target_:getDisplayCenterTilePoint()
	if not self.tilePoint or self.tilePoint.x ~= _tilePoint.x or self.tilePoint.y ~= _tilePoint.y then
		self.tilePoint = _tilePoint
		local isBuild = nebulaAllStarRead.checkIsBuildInPos(self.tilePoint)
		local areaName = nebulaAllStarUtil.getAreanNameByPoint(self.tilePoint, isBuild)
		self.Text_area:setString(areaName)
	end
	local tile_pos = self.target_.containerView:convertToNodeSpace(POINT_ZERO)
	local posxTile = math.floor(tile_pos.x / particle_size)
	local posyTile = math.floor(tile_pos.y / particle_size)
	if self.particle_x ~= posxTile or self.particle_y ~= posyTile then
		self.particle_x = posxTile
		self.particle_y = posyTile
		local posxTileNew = posxTile * particle_size
		local posyTileNew = posyTile * particle_size
		local point = self.target_.reqMapCenterPoint
		self.particle:setPosition(cc.p(posxTileNew + point.x, posyTileNew + point.y))
	end
end
function worldMapComNebulaAllStar:updateScaleZoom(event)
	local lod = event.lod
	local revertScale = event.revertScale or 1
	local drawVisivle = lod >= worldLodDef.LOD2
	if drawVisivle then
		local width = math.ceil(1 * revertScale)
		if self.borderWidth ~= width then
			self.borderWidth = width
			self:updateDrawNode()
		end
	end
	local regionVisible = lod >= worldLodDef.LOD4
	if regionVisible then
		for __, regionNode in ipairs(self.regionNodes) do
			regionNode:setScale(revertScale)
		end
	end
end
function worldMapComNebulaAllStar:updateLodChange(event)
	local lod = event.lod
	local regionVisible = lod >= worldLodDef.LOD4
	for __, regionNode in ipairs(self.regionNodes) do
		regionNode:setVisible(regionVisible)
	end
	local drawVisivle = lod >= worldLodDef.LOD2
	self.drawNode:setVisible(drawVisivle)
end
function worldMapComNebulaAllStar:toggle3D(...)
	for __, regionNode in ipairs(self.regionNodes) do
		if gEnableWorldMap3D then
			regionNode:setRotation3D(gWorldMapRotation3DBack)
		else
			regionNode:setRotation3D(gWorldMapRotation2D)
		end
	end
end
function worldMapComNebulaAllStar:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getNodeWar"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComNebulaAllStar
