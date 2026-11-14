local gametop = gModuleMgr.getObject("gametop")
local worldMapEvent = include("worldMapEvent")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local worldMapLodCfg = include("worldMapLodCfg")
local worldMapComNormalFog = class("worldMapComNormalFog", include("worldMapCom"))
function worldMapComNormalFog:ctor()
	worldMapComNormalFog.super.ctor(self, "worldMapComNormalFog")
	self.tiledBg_x = 0
	self.tiledBg_y = 0
	self.fogData, worldMapComNormalFog, self.tiledBg = worldMapComNormalFog.super.ctor, worldMapComNormalFog.super.ctor, nil
end
function worldMapComNormalFog:init()
	print("==worldMapComNormalFog:init==")
	self.myKindomID = gametop.playertop_:getMapID()
	self:updateCellSwap()
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
end
function worldMapComNormalFog:onMessageListener()
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellSwap))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	SoraDAddMessage(self, "MESSAGE_WORLDMAP_UNLOCK_NORMAL_FOG", handler(self, self.unLockWarFog))
	SoraDAddMessage(self, "MESSAGE_WORLDMAP_REFRESH_OTHER_KINGDOMINFO", handler(self, self.refreshOtherKingdominfo))
end
function worldMapComNormalFog:toggle3D()
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
function worldMapComNormalFog:updateCellSwap(event)
	dump(event, "==worldMapComNormalFog:updateCellSwap==")
	local currentInMapViewCell = self.target_.currentInMapViewCell
	local curMapID = currentInMapViewCell.kingdomID
	if self.myKindomID == curMapID then
		self.fogData = kingdomMapCtrl:getNormalFogData()
	else
		self.fogData, _ENV = kingdomMapCtrl:getNormalFogData(), kingdomMapCtrl:getNormalFogData()
		if kingdomCtrl:isFoundKingdomID(curMapID) then
			kingdomMapCtrl:onSwitchWorldMap(gSwitchWorldMapTypeDef.switchWorldMapType_in, curMapID)
		end
	end
	self:refreshWarFog()
end
function worldMapComNormalFog:unLockWarFog(...)
	local currentInMapViewCell = self.target_.currentInMapViewCell
	local curMapID = currentInMapViewCell.kingdomID
	if self.myKindomID ~= curMapID then
		return
	end
	self.fogData = kingdomMapCtrl:getNormalFogData()
	self:refreshWarFog()
end
function worldMapComNormalFog:refreshWarFog(...)
	if self.fogData and next(self.fogData) then
		if not self.tiledBg then
			self:initWarFog()
			self:toggle3D()
			self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
		else
			local rect = self.fogData.rect
			_ENV, _ENV = cc.p(self.tiledBg_x, self.tiledBg_y)
			cc.p(self.tiledBg_x, self.tiledBg_y).attr = "vec4"
			_ENV, cc.p(self.tiledBg_x, self.tiledBg_y).name = cc.p(self.tiledBg_x, self.tiledBg_y)
			cc.p(self.tiledBg_x, self.tiledBg_y).x = rect.ltX - 1
			cc.p(self.tiledBg_x, self.tiledBg_y).y = rect.ltY - 1
			cc.p(self.tiledBg_x, self.tiledBg_y).z = rect.rbX - 1
			self[1], cc.p(self.tiledBg_x, self.tiledBg_y).value, cc.p(self.tiledBg_x, self.tiledBg_y).w = cc.p(self.tiledBg_x, self.tiledBg_y)
			local param = self
			SoraDSetProgramStateParam(self.program, self.state, param)
		end
	elseif self.tiledBg then
		self.tiledBg:removeFromParent()
		self.tiledBg = nil
	end
end
function worldMapComNormalFog:refreshOtherKingdominfo(...)
	local info = kingdomMapCtrl:getOtherKingdomInfo()
	self.fogData = info.fog
	self:refreshWarFog()
end
local TileBG_Size = 1024
function worldMapComNormalFog:initWarFog()
	local tiledBg = display.newSprite("SinglePicture/bq_tex3.png")
	local width = display.width + 0.5 * display.height
	local height = display.height * 1.35
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
	tiledBg.setAnchorPoint.x = 1201
	tiledBg.setAnchorPoint.y = 1201
	tiledBg.setAnchorPoint.z = 256
	self._tileInfo, tiledBg.setAnchorPoint.w = tiledBg.setAnchorPoint, 128
	tiledBg:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	tiledBg:setName("tiledFog")
	self.tiledBg = tiledBg
	self:reloadTmxFogShader()
	self:updateScaleZoom()
end
function worldMapComNormalFog:updateMapPos(event)
	local tile_pos = event.tile_pos
	if self.tiledBg_x ~= tile_pos.x or self.tiledBg_y ~= tile_pos.y then
		self.tiledBg_x = tile_pos.x
		self.tiledBg_y = tile_pos.y
		self:refreshMapPos(tile_pos)
	end
end
function worldMapComNormalFog:refreshMapPos(tile_pos)
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
function worldMapComNormalFog:updateScaleZoom(event)
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
function worldMapComNormalFog:reloadTmxFogShader()
	if not self.tiledBg then
		return
	end
	local shaderName = getfullname("fog_normal_shader")
	package.loaded[shaderName] = nil
	local _shader = require(shaderName)
	local program = cc.GLProgram:createWithByteArrays(_shader.vertBytes, _shader.fragBytes)
	local state = cc.GLProgramState:create(program)
	_ENV, _ENV = program, cc.GLProgramState
	program.attr = "texture"
	program.name = "_Texture"
	_UPVALUE4_, program.value = nil, "tileMaps/atlantis_png/fog_normal.png"
	_ENV, cc.GLProgramState[1], program.texParam, (nil)[1] = program, program, nil, gl.LINEAR
	_ENV, cc.GLProgramState[1], program.texParam, (nil)[2] = program, program, nil, gl.LINEAR
	_ENV, cc.GLProgramState[1], program.texParam, (nil)[3] = program, program, nil, gl.REPEAT
	_ENV, cc.GLProgramState[1], program.texParam, (nil)[4] = program, program, nil, gl.REPEAT
	program.attr = "vec4"
	_ENV, program.name = nil, "_Texture_ST"
	;(nil).x = 1
	;(nil).y = 1
	;(nil).z = 0
	_ENV, cc.GLProgramState[2], program.value, (nil).w = program, program, nil, 0
	program.attr = "vec4"
	program.name = "_resolution"
	_ENV, cc.GLProgramState[3], program.value = program, program, self._resolution
	program.attr = "vec4"
	program.name = "_tileInfo"
	cc.GLProgramState[4], program.value = program, self._tileInfo
	local param = cc.GLProgramState
	local rect = self.fogData.rect
	_ENV = gl.LINEAR
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.REPEAT, "_fogRect"
	gl.REPEAT.x = rect.ltX - 1
	gl.REPEAT.y = rect.ltY - 1
	gl.REPEAT.z = rect.rbX - 1
	gl.LINEAR.value, gl.REPEAT.w = gl.REPEAT, rect.rbY - 1
	table.insert(param, gl.LINEAR)
	SoraDSetProgramStateParam(program, state, param)
	self.program = program
	self.state = state
	self.tiledBg:setGLProgramState(state)
end
return worldMapComNormalFog
