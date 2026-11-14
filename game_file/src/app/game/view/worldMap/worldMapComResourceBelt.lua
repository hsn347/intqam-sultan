local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local worldLodDef = worldMapDefine.worldLodDef
local worldMapViewDef = include("worldMapViewDef")
local worldMapComResourceBelt = class("worldMapComResourceBelt", include("worldMapCom"))
function worldMapComResourceBelt:ctor()
	worldMapComResourceBelt.super.ctor(self, "worldMapComResourceBelt")
	self.tiledBg_x = 0
	self.tiledBg_y = 0
end
function worldMapComResourceBelt:init()
end
function worldMapComResourceBelt:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, function(event)
		if self.tiledBg then
			self.tiledBg:updateMapLod(event)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_NODEINFO_SELECT_CHANGE", handler(self, self.updateNodeInfoSelect))
end
function worldMapComResourceBelt:toggle3D()
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
local TileBG_Size = 1024
function worldMapComResourceBelt:updateMapPos(event)
	local tile_pos = event.tile_pos
	if self.tiledBg_x ~= tile_pos.x or self.tiledBg_y ~= tile_pos.y then
		self.tiledBg_x = tile_pos.x
		self.tiledBg_y = tile_pos.y
		self:refreshMapPos(tile_pos)
	end
end
function worldMapComResourceBelt:refreshMapPos(tile_pos)
	if not self.tiledBg then
		return
	end
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local scalex = self.tiledBg:getContentSize().width / TileBG_Size / zoomScale
	local scaley = self.tiledBg:getContentSize().height / TileBG_Size / zoomScale
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
function worldMapComResourceBelt:getLineArray(lineData)
	local _ENV, lineArrary
	if lineData and next(lineData) then
		table.insert(lineArrary, lineData[1])
		table.insert(lineArrary, lineData[2])
		table.insert(lineArrary, lineData[1] + lineData[3] - 1)
		table.insert(lineArrary, lineData[2])
		table.insert(lineArrary, lineData[1])
		table.insert(lineArrary, lineData[2] + lineData[4] - 1)
		table.insert(lineArrary, lineData[1] + lineData[3] - 1)
		table.insert(lineArrary, lineData[2] + lineData[4] - 1)
	end
	return lineArrary
end
function worldMapComResourceBelt:createResourceBelt(...)
	local parent = self.target_.containerView
	_UPVALUE2_, _ENV, (nil).triangles, _ENV, (nil).vertices, _ENV, _ENV = nil, nil, nil, nil, nil, nil, nil
	_UPVALUE2_, (nil).center, (nil)[1] = nil, nil, 0.0
	_UPVALUE2_, (nil).center, (nil)[2] = nil, nil, 0.0
	_UPVALUE2_, (nil).size, (nil)[1] = nil, nil, 10000.0
	_UPVALUE2_, (nil).size, (nil)[2] = nil, nil, 10000.0
	_UPVALUE4_, _UPVALUE1_, _ENV, (nil).colors, _ENV, (nil).bounds, (nil).minPos, (nil)[1] = 0.0, nil, nil, nil, nil, nil, nil, 0.0
	_UPVALUE4_, _UPVALUE1_, _ENV, (nil).colors, _ENV, (nil).bounds, (nil).minPos, (nil)[2] = 0.0, nil, nil, nil, nil, nil, nil, 0.0
	local meshCfg
	;(0.0)[1] = 0
	;(0.0)[2] = 0
	;(0.0)[3] = 40
	;(0.0)[4] = 40
	_UPVALUE4_, _UPVALUE1_, (nil)[1], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 3
	;(0.0)[2] = 3
	;(0.0)[3] = 34
	;(0.0)[4] = 34
	_UPVALUE4_, _UPVALUE1_, (nil)[2], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 6
	;(0.0)[2] = 6
	;(0.0)[3] = 28
	;(0.0)[4] = 28
	_UPVALUE4_, _UPVALUE1_, (nil)[3], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 9
	;(0.0)[2] = 9
	;(0.0)[3] = 22
	;(0.0)[4] = 22
	_UPVALUE4_, _UPVALUE1_, (nil)[4], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 12
	;(0.0)[2] = 12
	;(0.0)[3] = 16
	;(0.0)[4] = 16
	_UPVALUE4_, _UPVALUE1_, (nil)[5], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 15
	;(0.0)[2] = 15
	;(0.0)[3] = 10
	;(0.0)[4] = 10
	_UPVALUE4_, _UPVALUE1_, (nil)[6], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 18
	;(0.0)[2] = 18
	;(0.0)[3] = 4
	;(0.0)[4] = 4
	_UPVALUE4_, _UPVALUE1_, (nil)[7], (nil)[1] = 0.0, nil, nil, 0.0
	;(0.0)[1] = 19
	;(0.0)[2] = 19
	;(0.0)[3] = 2
	;(0.0)[4] = 2
	_UPVALUE3_, _ENV, (nil)[8], (nil)[1] = 0.0, nil, nil, 0.0
	local config
	_UPVALUE3_, (nil)[1], (0.0)[1] = 0.0, 0.0, 0.7254901960784313
	_UPVALUE3_, (nil)[1], (0.0)[2] = 0.0, 0.0, 0.9098039215686274
	_UPVALUE3_, (nil)[1], (0.0)[3] = 0.0, 0.0, 0.7450980392156863
	_UPVALUE3_, (nil)[2], (0.0)[1] = 0.0, 0.0, 0.5882352941176471
	_UPVALUE3_, (nil)[2], (0.0)[2] = 0.0, 0.0, 0.8313725490196079
	_UPVALUE3_, (nil)[2], (0.0)[3] = 0.0, 0.0, 0.611764705882353
	_UPVALUE3_, (nil)[3], (0.0)[1] = 0.0, 0.0, 0.4549019607843137
	_UPVALUE3_, (nil)[3], (0.0)[2] = 0.0, 0.0, 0.7411764705882353
	_UPVALUE3_, (nil)[3], (0.0)[3] = 0.0, 0.0, 0.49019607843137253
	_UPVALUE3_, (nil)[4], (0.0)[1] = 0.0, 0.0, 0.3137254901960784
	_UPVALUE3_, (nil)[4], (0.0)[2] = 0.0, 0.0, 0.6274509803921569
	_UPVALUE3_, (nil)[4], (0.0)[3] = 0.0, 0.0, 0.35294117647058826
	_UPVALUE3_, (nil)[5], (0.0)[1] = 0.0, 0.0, 0.16470588235294117
	_UPVALUE3_, (nil)[5], (0.0)[2] = 0.0, 0.0, 0.5333333333333333
	_UPVALUE3_, (nil)[5], (0.0)[3] = 0.0, 0.0, 0.21176470588235294
	_UPVALUE3_, (nil)[6], (0.0)[1] = 0.0, 0.0, 0
	_UPVALUE3_, (nil)[6], (0.0)[2] = 0.0, 0.0, 0.4666666666666667
	_UPVALUE3_, (nil)[6], (0.0)[3] = 0.0, 0.0, 0.06274509803921569
	_UPVALUE3_, (nil)[7], (0.0)[1] = 0.0, 0.0, 0
	_UPVALUE3_, (nil)[7], (0.0)[2] = 0.0, 0.0, 0.4666666666666667
	_UPVALUE3_, (nil)[7], (0.0)[3] = 0.0, 0.0, 0.06274509803921569
	;(nil)[8], (0.0)[1] = 0.0, 0
	;(nil)[8], (0.0)[2] = 0.0, 0.4666666666666667
	;(nil)[8], (0.0)[3] = 0.0, 0.06274509803921569
	local colors
	local _ENV, ret = 0.0, 0.0
	for level, v in ipairs(config) do
		for _, w in ipairs(v) do
			for i = w[1], w[1] + w[3] - 1 do
				if not ret[i] then
					_ENV = ret[i]
				end
				ret[i] = ret[i]
				for j = w[2], w[2] + w[4] - 1 do
					ret[i][j] = level
				end
			end
		end
	end
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local ASB = require_data("alliance_stronghold_build", true).data
	for k, v in pairs(ASB) do
		local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(v.x, v.y))
		local point = cc.p(math.floor(clientPos.x / 30), math.floor(clientPos.y / 30))
		local level = ret[point.x][point.y]
		level = math.min(8, level + 1)
		ret[point.x][point.y] = level
		for i = 0, 2 do
			for j = 0, 2 do
				local nextPoit = cc.p(point.x + i - 1, point.y + j - 1)
				local level = ret[nextPoit.x] and ret[nextPoit.x][nextPoit.y] or 1
				level = math.min(8, level + 1)
				if not ret[nextPoit.x] then
					_ENV = ret[nextPoit.x]
				end
				ret[nextPoit.x] = ret[nextPoit.x]
				ret[nextPoit.x][nextPoit.y] = level
			end
		end
	end
	local index = 0
	local str = ""
	for i = 0, 39 do
		for j = 0, 39 do
			local level = ret[i] and ret[i][j] or 1
			str = str .. level
			_UPVALUE4_ = 2
			;(2)[1] = i
			;(2)[2] = j
			;(2)[3] = 2
			;(2)[4] = 2
			local array = self:getLineArray(2)
			for k, w in ipairs(array) do
				table.insert(meshCfg.vertices, w)
				if k % 2 == 0 then
					table.insertto(meshCfg.colors, colors[level])
					table.insert(meshCfg.colors, 1.0)
				end
			end
			_UPVALUE6_ = ipairs(array)
			ipairs(array)[1] = 0
			ipairs(array)[2] = 2
			ipairs(array)[3] = 1
			ipairs(array)[4] = 1
			ipairs(array)[5] = 2
			ipairs(array)[6] = 3
			for _, k in ipairs(ipairs(array)) do
				table.insert(meshCfg.triangles, k + index * 4)
			end
			index = index + 1
		end
		str = str .. "\n"
	end
	local shader = require("app.shader.allianceTerritoryMeshShader")
	local meshNode1 = SoraDCreateMeshNode(meshCfg, meshCfg.bounds.size, shader)
	meshNode1:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	if not self.renderTexture then
		self.renderTexture = cc.RenderTexture:create(40, 40, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
		self.renderTexture:addTo(parent)
		self.renderTexture:setPosition(cc.p(display.cx, display.cy))
	end
	self.renderTexture:beginWithClear(0, 0, 0, 0)
	meshNode1:visit()
	self.renderTexture:endToLua()
	self.renderTexture:saveToFile("resourceBeltControl.png")
	self.renderTexture:setVisible(false)
	self.tileTexture = self.renderTexture:getSprite():getTexture()
	self.tileTexture:setTexParameters(gl.NEAREST, gl.NEAREST, gl.REPEAT, gl.REPEAT)
end
function worldMapComResourceBelt:initResourceBeltBg(...)
	local tiledBg = display.newSprite("SinglePicture/bq_tex3.png")
	local width = display.width + 0.5 * display.height
	local height = display.height * 1.4
	local offsetX = (display.width - width) * 0.5
	tiledBg:setContentSize(width, height)
	tiledBg:setGroupID(worldMapDefine.GROU_ID.tileEffectBatchNode)
	tiledBg:addTo(self.target_, worldMapDefine.Z_ORDER.scrollView)
	tiledBg:setPositionX(offsetX)
	tiledBg:setAnchorPoint(cc.p(0, 0))
	tiledBg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.tiledBg = tiledBg
	self.tiledBg = SoraDCreatePanelByCloneNode(self.tiledBg, "commonLODInstance")
	_ENV = "commonLODInstance"
	;("commonLODInstance").showLodMin = worldLodDef.LOD4
	self.tiledBg:initLODData("commonLODInstance")
	_ENV = self.tiledBg.initLODData
	self.tiledBg.initLODData.x = TileBG_Size
	self.tiledBg.initLODData.y = TileBG_Size
	self.tiledBg.initLODData.z = offsetX / width
	_ENV, self._resolution, self.tiledBg.initLODData.w = self.tiledBg.initLODData, self.tiledBg.initLODData, 0
	self.tiledBg.initLODData.x = 1201
	self.tiledBg.initLODData.y = 1201
	self.tiledBg.initLODData.z = 256
	self._tileInfo, self.tiledBg.initLODData.w = self.tiledBg.initLODData, 128
	self:loadShader()
end
function worldMapComResourceBelt:loadShader()
	local areaShader = require("app.game.worldMap.shader.resourceBelt_shader")
	_ENV, _ENV = nil, "app.game.worldMap.shader.resourceBelt_shader"
	;(nil).attr = "texture"
	;(nil).name = "_TileTexture"
	_UPVALUE4_, (nil).value = nil, "tileMaps/World_png/resourceBeltControl.png"
	;(nil).texParam, (nil)[1] = nil, gl.NEAREST
	;(nil).texParam, (nil)[2] = nil, gl.NEAREST
	;(nil).texParam, (nil)[3] = nil, gl.REPEAT
	;(nil).texParam, (nil)[4] = nil, gl.REPEAT
	_ENV, ("app.game.worldMap.shader.resourceBelt_shader")[1], (nil).texForce = nil, nil, true
	;(nil).attr = "vec4"
	_ENV, (nil).name = nil, "_Texture_ST"
	;(nil).x = 1
	;(nil).y = 1
	;(nil).z = 0
	_ENV, ("app.game.worldMap.shader.resourceBelt_shader")[2], (nil).value, (nil).w = nil, nil, nil, 0
	;(nil).attr = "vec4"
	;(nil).name = "_resolution"
	_ENV, ("app.game.worldMap.shader.resourceBelt_shader")[3], (nil).value = nil, nil, self._resolution
	;(nil).attr = "vec4"
	;(nil).name = "_tileInfo"
	;("app.game.worldMap.shader.resourceBelt_shader")[4], (nil).value = nil, self._tileInfo
	local allianceAreaParam = "app.game.worldMap.shader.resourceBelt_shader"
	local program = cc.GLProgram:createWithByteArrays(areaShader.vertBytes, areaShader.fragBytes)
	local state = cc.GLProgramState:create(program)
	SoraDSetProgramStateParam(program, state, allianceAreaParam)
	self.program = program
	self.state = state
	self.tiledBg:setGLProgramState(state)
end
function worldMapComResourceBelt:reloadShader()
	if not self.tiledBg then
		return
	end
	local shaderName = "app.game.worldMap.shader.resourceBelt_shader"
	package.loaded[shaderName] = nil
	self:loadShader()
	self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
end
function worldMapComResourceBelt:updateNodeInfoSelect(target, event)
	worldMapViewDef = nil
	local (nil)[worldMapViewDef.NODEINFO_TYPE_RESOURCE], config = true, nil
	local isShow = config[worldMapDefine.curSelectNodeInfo] or false
	self:showResourceBelt(isShow)
end
function worldMapComResourceBelt:showResourceBelt(isShow)
	if isShow and not self.tiledBg then
		self:initResourceBeltBg()
		self:toggle3D()
		self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
	end
	if self.tiledBg then
		self.tiledBg:setVisible(isShow)
	end
end
return worldMapComResourceBelt
