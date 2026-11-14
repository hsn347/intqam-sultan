local worldMapEvent = include("worldMapEvent")
local worldMapComTmxTerrainBg = class("worldMapComTmxTerrainBg", include("worldMapCom"))
local DEFAULT_TERRAIN_DIR = "tileMaps/commonMap/%s.%s"
local DEFAULT_TERRAIN_CONTROL = "tileMaps/World_png/worldTileControl.png"
function worldMapComTmxTerrainBg:ctor()
	worldMapComTmxTerrainBg.super.ctor(self, "worldMapComTmxTerrainBg")
end
function worldMapComTmxTerrainBg:init()
	self.config = self.target_.config
	self.lodControl = 0.0
	self:initMapTiledBg()
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
end
function worldMapComTmxTerrainBg:onMessageListener()
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
end
function worldMapComTmxTerrainBg:toggle3D()
	if gEnableWorldMap3D then
		self.tiledBg:setRotation3D(gWorldMapRotation3D)
		if self.lowCfg then
			self.lowCfg.tiledBg:setRotation3D(gWorldMapRotation3D)
		end
	else
		self.tiledBg:setRotation3D(gWorldMapRotation2D)
		if self.lowCfg then
			self.lowCfg.tiledBg:setRotation3D(gWorldMapRotation2D)
		end
	end
end
local TileBG_Size = 1024
function worldMapComTmxTerrainBg:initMapTiledBg()
	if self.target_.config.terrainDir then
		self.terrainDir = self.target_.config.terrainDir .. "_png/%s.%s"
	else
		self.terrainDir = DEFAULT_TERRAIN_DIR
	end
	local width = display.width + 0.5 * display.height
	local height = display.height * 1.4
	local offsetX = (display.width - width) * 0.5
	local mapSize = self.target_.mapSize
	local tileSize = self.target_.tileSize
	self.tiledBg_x = 0
	DEFAULT_TERRAIN_DIR, self.tiledBg_y = nil, 0
	;(nil).x = TileBG_Size
	;(nil).y = TileBG_Size
	;(nil).z = offsetX / width
	DEFAULT_TERRAIN_DIR, self._resolution, (nil).w = nil, nil, 0
	;(nil).x = mapSize.width
	;(nil).y = mapSize.height
	;(nil).z = 1 / tileSize.width
	self._tileInfo, (nil).w = nil, 1 / tileSize.height
	self.curTileControl = self:getTileControl()
	self.normalCfg = self:createTerrainBg("terrain_shader")
	self.normalCfg.tiledBg:setName("tiledBg")
	self.tiledBg = self.normalCfg.tiledBg
	local waterControl = self.config.waterControl
	if waterControl then
		self.lowCfg = self:createTerrainBg("terrain_shader_low", true)
		self.lowCfg.tiledBg:setName("lowTiledBg")
		self.waterCfg = self:createTerrainBg("terrain_water_shader", false, waterControl)
		self.waterCfg.tiledBg:setName("waterBg")
	end
end
function worldMapComTmxTerrainBg:createTerrainBg(shaderName, isLow, tileControl)
	local width = display.width + 0.5 * display.height
	local height = display.height * 1.4
	local tiledBg = display.newSprite("SinglePicture/bq_tex3.png")
	tiledBg:setContentSize(width, height)
	tiledBg:setAnchorPoint(0, 0)
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local scalex = width / TileBG_Size / zoomScale
	local scaley = height / TileBG_Size / zoomScale
	_ENV, _ENV = nil, 0
	;(nil).attr = "texture"
	;(nil).name = "_Texture"
	_UPVALUE4_, (nil).value = self:getTerrainTextureByPlatform("combine1"), self:getTerrainTextureByPlatform("combine1")
	_ENV, (0)[1], (nil).texParam, self:getTerrainTextureByPlatform("combine1")[1] = nil, nil, self:getTerrainTextureByPlatform("combine1"), gl.LINEAR
	_ENV, (0)[1], (nil).texParam, self:getTerrainTextureByPlatform("combine1")[2] = nil, nil, self:getTerrainTextureByPlatform("combine1"), gl.LINEAR
	_ENV, (0)[1], (nil).texParam, self:getTerrainTextureByPlatform("combine1")[3] = nil, nil, self:getTerrainTextureByPlatform("combine1"), gl.REPEAT
	_ENV, (0)[1], (nil).texParam, self:getTerrainTextureByPlatform("combine1")[4] = nil, nil, self:getTerrainTextureByPlatform("combine1"), gl.REPEAT
	;(nil).attr = "texture"
	;(nil).name = "_TileTexture"
	_UPVALUE4_, (nil).value = tileControl or self.curTileControl, tileControl or self.curTileControl
	;(nil).texParam, (tileControl or self.curTileControl)[1] = tileControl or self.curTileControl, gl.NEAREST
	;(nil).texParam, (tileControl or self.curTileControl)[2] = tileControl or self.curTileControl, gl.NEAREST
	;(nil).texParam, (tileControl or self.curTileControl)[3] = tileControl or self.curTileControl, gl.REPEAT
	;(nil).texParam, (tileControl or self.curTileControl)[4] = tileControl or self.curTileControl, gl.REPEAT
	_ENV, (0)[2], (nil).texForce = nil, nil, true
	;(nil).attr = "vec4"
	_ENV, (nil).name = tileControl or self.curTileControl, "_TexturePos"
	;(tileControl or self.curTileControl).x = scalex
	;(tileControl or self.curTileControl).y = scaley
	;(tileControl or self.curTileControl).z = self.tiledBg_x
	_ENV, (0)[3], (nil).value, (tileControl or self.curTileControl).w = nil, nil, tileControl or self.curTileControl, self.tiledBg_y
	;(nil).attr = "vec4"
	;(nil).name = "_Resolution"
	_ENV, (0)[4], (nil).value = nil, nil, self._resolution
	;(nil).attr = "vec4"
	;(nil).name = "_TileInfo"
	_ENV, (0)[5], (nil).value = nil, nil, self._tileInfo
	;(nil).attr = "float"
	;(nil).name = "_LodLevel"
	_ENV, (0)[6], (nil).value = nil, nil, 0.0
	;(nil).attr = "float"
	;(nil).name = "_Fade"
	;(0)[7], (nil).value = nil, 0.0
	local param = 0
	if isLow then
		_ENV = self._tileInfo
		self._tileInfo.attr = "texture"
		self._tileInfo.name = "_TileTextureLod"
		_UPVALUE4_, self._tileInfo.value = self:getTileControl(true), self:getTileControl(true)
		self._tileInfo.texParam, self:getTileControl(true)[1] = self:getTileControl(true), gl.NEAREST
		self._tileInfo.texParam, self:getTileControl(true)[2] = self:getTileControl(true), gl.NEAREST
		self._tileInfo.texParam, self:getTileControl(true)[3] = self:getTileControl(true), gl.REPEAT
		self._tileInfo.texParam, self:getTileControl(true)[4] = self:getTileControl(true), gl.REPEAT
		param[#param + 1], self._tileInfo.texForce = self._tileInfo, true
	end
	local offsetX = (display.width - width) * 0.5
	local _shader = include(shaderName)
	local defined
	local worldMapUtil = include("worldMapUtil")
	if worldMapUtil.isLodOpen() then
		defined = "LOD_FADE"
	end
	local program = cc.GLProgram:createWithFilenames(_shader.vertBytes, _shader.fragBytes, defined)
	local state = cc.GLProgramState:create(program)
	SoraDSetProgramStateParam(program, state, param, nil, tiledBg)
	tiledBg:setGLProgramState(state)
	tiledBg:addTo(self.target_, worldMapDefine.Z_ORDER.scrollView - 1)
	tiledBg:setPositionX(offsetX)
	_ENV = tiledBg.setPositionX
	tiledBg.setPositionX.tiledBg = tiledBg
	tiledBg.setPositionX.state = state
	tiledBg.setPositionX.shader = program
	local tiledBg.setPositionX.isLow, cfg = isLow, tiledBg.setPositionX
	return cfg
end
function worldMapComTmxTerrainBg:updateMapPos(event)
	local tile_pos = event.tile_pos
	if self.tiledBg_x ~= tile_pos.x or self.tiledBg_y ~= tile_pos.y then
		self.tiledBg_x = tile_pos.x
		self.tiledBg_y = tile_pos.y
		self:updateTerrain(self.normalCfg)
		if self.lowCfg then
			self:updateTerrain(self.lowCfg)
		end
		if self.waterCfg then
			self:updateTerrain(self.waterCfg)
		end
	end
end
function worldMapComTmxTerrainBg:updateTerrain(cfg)
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local scalex = cfg.tiledBg:getContentSize().width / TileBG_Size / zoomScale
	local scaley = cfg.tiledBg:getContentSize().height / TileBG_Size / zoomScale
	local lodLevel, lodFade = self:getLodLevel(zoomScale)
	local worldLod = self.target_:getCurLod()
	TileBG_Size, TileBG_Size = nil, self.target_
	;(nil).attr = "vec4"
	TileBG_Size, (nil).name = nil, "_TexturePos"
	;(nil).x = scalex
	;(nil).y = scaley
	;(nil).z = self.tiledBg_x
	TileBG_Size, self.target_[1], (nil).value, (nil).w = nil, nil, nil, self.tiledBg_y
	;(nil).attr = "float"
	;(nil).name = "_LodLevel"
	TileBG_Size, self.target_[2], (nil).value = nil, nil, lodLevel
	;(nil).attr = "float"
	;(nil).name = "_Fade"
	self.target_[3], (nil).value = nil, lodFade
	local param = self.target_
	SoraDSetProgramStateParam(cfg.shader, cfg.state, param)
end
function worldMapComTmxTerrainBg:getLodLevel(zoomScale)
	local level = 0
	local fade = 0
	_ENV, _UPVALUE4_ = nil, nil
	;(nil).level = 0
	;(nil).rangeMin = 0.5
	_ENV, (nil).rangeMax = nil, 1.0
	;(nil).level = 1
	;(nil).rangeMin = 0.2
	;(nil).rangeMax = 0.5
	_ENV, (nil).fadeEnd = nil, 0.4
	;(nil).level = 2
	;(nil).rangeMin = 0.1
	;(nil).rangeMax = 0.2
	_ENV, (nil).fadeEnd = nil, 0.15
	;(nil).level = 3
	;(nil).rangeMin = 0.05
	;(nil).rangeMax = 0.1
	;(nil).fadeEnd = 0.08
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = nil
	local (nil)[4], zoomCfg
	for _, v in ipairs(zoomCfg) do
		if zoomScale > v.rangeMin and zoomScale <= v.rangeMax then
			level = v.level
			if v.fadeEnd ~= nil and zoomScale > v.fadeEnd then
				fade = math.max(math.min((zoomScale - v.fadeEnd) / (v.rangeMax - v.fadeEnd), 1.0), 0.0)
				break
			end
		end
	end
	return level, fade
end
function worldMapComTmxTerrainBg:reloadTmxBgShader()
	local shaderName = getfullname("terrain_shader_low")
	package.loaded[shaderName] = nil
	local _shader = require(shaderName)
	local program = cc.GLProgram:createWithFilenames(_shader.vertBytes, _shader.fragBytes)
	local state = cc.GLProgramState:create(program)
	_ENV, _ENV = program, cc.GLProgramState
	program.attr = "texture"
	program.name = "_Texture"
	_UPVALUE4_, program.value = self:getTerrainTextureByPlatform("combine1"), self:getTerrainTextureByPlatform("combine1")
	_ENV, cc.GLProgramState[1], program.texParam, self:getTerrainTextureByPlatform("combine1")[1] = program, program, self:getTerrainTextureByPlatform("combine1"), gl.LINEAR
	_ENV, cc.GLProgramState[1], program.texParam, self:getTerrainTextureByPlatform("combine1")[2] = program, program, self:getTerrainTextureByPlatform("combine1"), gl.LINEAR
	_ENV, cc.GLProgramState[1], program.texParam, self:getTerrainTextureByPlatform("combine1")[3] = program, program, self:getTerrainTextureByPlatform("combine1"), gl.REPEAT
	_ENV, cc.GLProgramState[1], program.texParam, self:getTerrainTextureByPlatform("combine1")[4] = program, program, self:getTerrainTextureByPlatform("combine1"), gl.REPEAT
	program.attr = "texture"
	program.name = "_TileTexture"
	_UPVALUE4_, program.value = self:getTileControl(), self:getTileControl()
	program.texParam, self:getTileControl()[1] = self:getTileControl(), gl.NEAREST
	program.texParam, self:getTileControl()[2] = self:getTileControl(), gl.NEAREST
	program.texParam, self:getTileControl()[3] = self:getTileControl(), gl.REPEAT
	program.texParam, self:getTileControl()[4] = self:getTileControl(), gl.REPEAT
	_ENV, cc.GLProgramState[2], program.texForce = program, program, true
	program.attr = "vec4"
	_ENV, program.name = self:getTileControl(), "_TexturePos"
	self:getTileControl().x = 1
	self:getTileControl().y = 1
	self:getTileControl().z = 0
	_ENV, cc.GLProgramState[3], program.value, self:getTileControl().w = program, program, self:getTileControl(), 0
	program.attr = "vec4"
	program.name = "_Resolution"
	_ENV, cc.GLProgramState[4], program.value = program, program, self._resolution
	program.attr = "vec4"
	program.name = "_TileInfo"
	_ENV, cc.GLProgramState[5], program.value = program, program, self._tileInfo
	program.attr = "float"
	program.name = "_LodLevel"
	cc.GLProgramState[6], program.value = program, 0.0
	local param = cc.GLProgramState
	if self.config.terrainControlLod then
		_ENV = self._tileInfo
		self._tileInfo.attr = "texture"
		self._tileInfo.name = "_TileTextureLod"
		_UPVALUE4_, self._tileInfo.value = self:getTileControl(true), self:getTileControl(true)
		self._tileInfo.texParam, self:getTileControl(true)[1] = self:getTileControl(true), gl.NEAREST
		self._tileInfo.texParam, self:getTileControl(true)[2] = self:getTileControl(true), gl.NEAREST
		self._tileInfo.texParam, self:getTileControl(true)[3] = self:getTileControl(true), gl.REPEAT
		self._tileInfo.texParam, self:getTileControl(true)[4] = self:getTileControl(true), gl.REPEAT
		param[#param + 1], self._tileInfo.texForce = self._tileInfo, true
	end
	SoraDSetProgramStateParam(program, state, param)
	self.lowCfg.tiledBg:setGLProgramState(state)
	self.lowCfg.state = state
	self.lowCfg.shader = program
end
function worldMapComTmxTerrainBg:getTerrainTextureByPlatform(texName, format)
	local vFormat = format
	if self.config.vFormat then
		vFormat = self.config.vFormat
	end
	vFormat = vFormat or getASTCFormatOrPlatform()
	if self.config.terrainTextureKey then
		texName = self.config.terrainTextureKey
	end
	return string.format(self.terrainDir, texName, vFormat)
end
function worldMapComTmxTerrainBg:getTileControl(lod)
	if lod and self.config.terrainControlLod then
		return self.config.terrainControlLod
	else
		return self.config.terrainControl or DEFAULT_TERRAIN_CONTROL
	end
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapComTmxTerrainBg:updateScaleZoom(event)
	self:udpateTileVisible(event)
end
function worldMapComTmxTerrainBg:updateLodChange(event)
end
function worldMapComTmxTerrainBg:udpateTileVisible(event)
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local worldLod = self.target_:getCurLod()
	local showNormal = 0.1 < zoomScale
	self.normalCfg.tiledBg:setVisible(showNormal)
	if not showNormal and not self.lowCfg then
		self.lowCfg = self:createTerrainBg("terrain_shader_low", true)
		self.lowCfg.tiledBg:setName("lowTiledBg")
		self:toggle3D()
	end
	if self.lowCfg then
		self.lowCfg.tiledBg:setVisible(not showNormal)
	end
	if self.waterCfg then
		local showNormal = zoomScale < 0.05
		self.waterCfg.tiledBg:setVisible(showNormal)
	end
end
function worldMapComTmxTerrainBg:dumpTerrain()
end
return worldMapComTmxTerrainBg
