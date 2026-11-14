local worldMapViewDef = include("worldMapViewDef")
local worldMapEvent = include("worldMapEvent")
local worldMapLodCfg = include("worldMapLodCfg")
local worldMapComTmxFog = class("worldMapComTmxFog", include("worldMapCom"))
function worldMapComTmxFog:ctor()
	worldMapComTmxFog.super.ctor(self, "worldMapComTmxFog")
	self.tiledBg_x = 0
	self.tiledBg_y = 0
	self.tiledBg = nil
end
function worldMapComTmxFog:init()
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_WARDATA", handler(self, self.refreshWarFog))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_STAGE", handler(self, self.refreshWarFog))
	if worldMapDefine.isNebulaEmperorKingdomID() then
		self:initNebulaEmperorWarFog()
	end
end
function worldMapComTmxFog:onMessageListener()
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
end
function worldMapComTmxFog:toggle3D()
	print(gEnableWorldMap3D, "gEnableWorldMap3D")
	if not self.tiledBg then
		return
	end
	if gEnableWorldMap3D then
		self.tiledBg:setRotation3D(gWorldMapRotation3D)
	else
		self.tiledBg:setRotation3D(gWorldMapRotation2D)
	end
end
function worldMapComTmxFog:refreshWarFog(...)
	local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
	local stage = atlantisWarCtrl:getWarStage()
	print("==worldMapComTmxFog:refreshWarFog==", stage)
	if stage >= gAtlantisWarStageType.warAreaIng then
		if self.tiledBg then
			self.tiledBg:removeFromParent()
			self.tiledBg = nil
		end
	elseif not self.tiledBg then
		self:initWarFog()
		self:toggle3D()
		self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
	end
end
function worldMapComTmxFog:initNebulaEmperorWarFog(...)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
	if 10 <= #hegemonyRegion then
		return
	end
	if not self.tiledBg then
		self:initWarFog()
		self:toggle3D()
		self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
	end
end
local TileBG_Size = 1024
function worldMapComTmxFog:initWarFog()
	local tiledBg = display.newSprite("SinglePicture/bq_tex3.png")
	local width = display.width + 0.5 * display.height
	local height = display.height * 1.2
	local offsetX = (display.width - width) * 0.5
	tiledBg:setContentSize(width, height)
	tiledBg:addTo(self.target_, worldMapDefine.Z_ORDER.scrollView)
	tiledBg:setPositionX(offsetX)
	tiledBg:setAnchorPoint(cc.p(0, 0))
	_ENV, self.tiledBg = tiledBg.setAnchorPoint, tiledBg
	tiledBg.setAnchorPoint.x = TileBG_Size
	tiledBg.setAnchorPoint.y = TileBG_Size
	tiledBg.setAnchorPoint.z = offsetX / width
	_ENV, self._resolution, tiledBg.setAnchorPoint.w = tiledBg.setAnchorPoint, tiledBg.setAnchorPoint, 0
	tiledBg.setAnchorPoint.x = 400
	tiledBg.setAnchorPoint.y = 400
	tiledBg.setAnchorPoint.z = 256
	self._tileInfo, tiledBg.setAnchorPoint.w = tiledBg.setAnchorPoint, 128
	if worldMapDefine.isNebulaEmperorKingdomID() then
		_ENV = worldMapDefine.isNebulaEmperorKingdomID()
		worldMapDefine.isNebulaEmperorKingdomID().x = 300
		worldMapDefine.isNebulaEmperorKingdomID().y = 300
		worldMapDefine.isNebulaEmperorKingdomID().z = 256
		self._tileInfo, worldMapDefine.isNebulaEmperorKingdomID().w = worldMapDefine.isNebulaEmperorKingdomID(), 128
	end
	tiledBg:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	tiledBg:setName("tiledFog")
	self.tiledBg = tiledBg
	self:reloadTmxFogShader()
	self:updateScaleZoom()
end
function worldMapComTmxFog:updateMapPos(event)
	local tile_pos = event.tile_pos
	if self.tiledBg_x ~= tile_pos.x or self.tiledBg_y ~= tile_pos.y then
		self.tiledBg_x = tile_pos.x
		self.tiledBg_y = tile_pos.y
		self:refreshMapPos(tile_pos)
	end
end
function worldMapComTmxFog:refreshMapPos(tile_pos)
	if not self.tiledBg then
		return
	end
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local scalex = self.tiledBg:getContentSize().width / TileBG_Size / zoomScale
	local scaley = self.tiledBg:getContentSize().height / TileBG_Size / zoomScale
	local posx = tile_pos.x % TileBG_Size / TileBG_Size
	local posy = tile_pos.y % TileBG_Size / TileBG_Size
	TileBG_Size, TileBG_Size = nil, TileBG_Size
	;(nil).attr = "vec4"
	TileBG_Size, (nil).name = nil, "_Texture_ST"
	;(nil).x = scalex
	;(nil).y = scaley
	;(nil).z = tile_pos.x
	TileBG_Size[1], (nil).value, (nil).w = nil, nil, tile_pos.y
	local param = TileBG_Size
	SoraDSetProgramStateParam(self.program, self.state, param)
end
function worldMapComTmxFog:updateScaleZoom(event)
	if not self.tiledBg then
		return
	end
	local zoomScale = event and event.scale or self.target_.viewScrollView:getZoomScale()
	local level, scale, scaleNext = worldMapLodCfg.getFogMapScale(zoomScale)
	worldMapLodCfg, worldMapLodCfg = nil, nil
	;(nil).attr = "float"
	;(nil).name = "_mapScale"
	worldMapLodCfg, (nil)[1], (nil).value = nil, nil, scale
	;(nil).attr = "float"
	;(nil).name = "_mapScale_next"
	worldMapLodCfg, (nil)[2], (nil).value = nil, nil, scaleNext
	;(nil).attr = "float"
	;(nil).name = "_mapLevel"
	;(nil)[3], (nil).value = nil, level
	local param
	SoraDSetProgramStateParam(self.program, self.state, param)
end
function worldMapComTmxFog:reloadTmxFogShader()
	if not self.tiledBg then
		return
	end
	local shaderName = getfullname("fog_shader")
	if worldMapDefine.isNebulaEmperorKingdomID() then
		shaderName = getfullname("fog_emperor_shader")
	end
	package.loaded[shaderName] = nil
	local _shader = require(shaderName)
	local program = cc.GLProgram:createWithByteArrays(_shader.vertBytes, _shader.fragBytes)
	local state = cc.GLProgramState:create(program)
	local _ENV, param = cc.GLProgramState, cc.GLProgramState
	if worldMapDefine.isNebulaEmperorKingdomID() then
		_ENV, _ENV = nil, worldMapDefine.isNebulaEmperorKingdomID()
		;(nil).attr = "texture"
		;(nil).name = "_Texture"
		_UPVALUE4_, (nil).value = nil, "tileMaps/atlantis_png/fog_normal.png"
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[1], (nil).texParam, (nil)[1] = nil, nil, nil, gl.LINEAR
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[1], (nil).texParam, (nil)[2] = nil, nil, nil, gl.LINEAR
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[1], (nil).texParam, (nil)[3] = nil, nil, nil, gl.REPEAT
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[1], (nil).texParam, (nil)[4] = nil, nil, nil, gl.REPEAT
		;(nil).attr = "texture"
		;(nil).name = "_TileTexture"
		_UPVALUE4_, (nil).value = nil, "tileMaps/nebulaEmperor/fogControl.png"
		;(nil).texParam, (nil)[1] = nil, gl.NEAREST
		;(nil).texParam, (nil)[2] = nil, gl.NEAREST
		;(nil).texParam, (nil)[3] = nil, gl.REPEAT
		;(nil).texParam, (nil)[4] = nil, gl.REPEAT
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[2], (nil).texForce = nil, nil, true
		;(nil).attr = "vec4"
		_ENV, (nil).name = nil, "_Texture_ST"
		;(nil).x = 1
		;(nil).y = 1
		;(nil).z = 0
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[3], (nil).value, (nil).w = nil, nil, nil, 0
		;(nil).attr = "vec4"
		;(nil).name = "_resolution"
		_ENV, worldMapDefine.isNebulaEmperorKingdomID()[4], (nil).value = nil, nil, self._resolution
		;(nil).attr = "vec4"
		;(nil).name = "_tileInfo"
		param, worldMapDefine.isNebulaEmperorKingdomID()[5], (nil).value = worldMapDefine.isNebulaEmperorKingdomID(), nil, self._tileInfo
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local hegemonyRegion = nebulaActivityCtrl:getHegemonyRegionData()
		_ENV = gl.NEAREST
		gl.NEAREST.attr = "float"
		gl.NEAREST.name = "_regionID"
		gl.NEAREST.value = #hegemonyRegion
		table.insert(param, gl.NEAREST)
	else
		_ENV, _ENV = nebulaActivityCtrl:getHegemonyRegionData(), SoraDGetCtrl("nebulaActivityCtrl")
		nebulaActivityCtrl:getHegemonyRegionData().attr = "texture"
		nebulaActivityCtrl:getHegemonyRegionData().name = "_Texture"
		_UPVALUE4_, nebulaActivityCtrl:getHegemonyRegionData().value = table.insert, "tileMaps/atlantis_png/fog_battlefield.png"
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[1], nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[1] = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), table.insert, gl.LINEAR
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[1], nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[2] = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), table.insert, gl.LINEAR
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[1], nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[3] = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), table.insert, gl.REPEAT
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[1], nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[4] = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), table.insert, gl.REPEAT
		nebulaActivityCtrl:getHegemonyRegionData().attr = "texture"
		nebulaActivityCtrl:getHegemonyRegionData().name = "_TileTexture"
		_UPVALUE4_, nebulaActivityCtrl:getHegemonyRegionData().value = table.insert, "tileMaps/atlantis_png/tileControl.png"
		nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[1] = table.insert, gl.NEAREST
		nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[2] = table.insert, gl.NEAREST
		nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[3] = table.insert, gl.REPEAT
		nebulaActivityCtrl:getHegemonyRegionData().texParam, table.insert[4] = table.insert, gl.REPEAT
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[2], nebulaActivityCtrl:getHegemonyRegionData().texForce = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), true
		nebulaActivityCtrl:getHegemonyRegionData().attr = "vec4"
		_ENV, nebulaActivityCtrl:getHegemonyRegionData().name = table.insert, "_Texture_ST"
		table.insert.x = 1
		table.insert.y = 1
		table.insert.z = 0
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[3], nebulaActivityCtrl:getHegemonyRegionData().value, table.insert.w = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), table.insert, 0
		nebulaActivityCtrl:getHegemonyRegionData().attr = "vec4"
		nebulaActivityCtrl:getHegemonyRegionData().name = "_resolution"
		_ENV, SoraDGetCtrl("nebulaActivityCtrl")[4], nebulaActivityCtrl:getHegemonyRegionData().value = nebulaActivityCtrl:getHegemonyRegionData(), nebulaActivityCtrl:getHegemonyRegionData(), self._resolution
		nebulaActivityCtrl:getHegemonyRegionData().attr = "vec4"
		nebulaActivityCtrl:getHegemonyRegionData().name = "_tileInfo"
		param, SoraDGetCtrl("nebulaActivityCtrl")[5], nebulaActivityCtrl:getHegemonyRegionData().value = SoraDGetCtrl("nebulaActivityCtrl"), nebulaActivityCtrl:getHegemonyRegionData(), self._tileInfo
	end
	SoraDSetProgramStateParam(program, state, param)
	self.program = program
	self.state = state
	self.tiledBg:setGLProgramState(state)
end
return worldMapComTmxFog
