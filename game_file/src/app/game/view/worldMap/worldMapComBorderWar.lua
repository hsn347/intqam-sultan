local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local nationalFlagRead = include("nationalFlagRead")
local worldMapComBorderWar = class("worldMapComBorderWar", include("worldMapCom"))
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
function worldMapComBorderWar:ctor(param)
	worldMapComBorderWar.super.ctor(self, "worldMapComBorderWar")
	if param and param.borderLodScale then
		self.lodCfgScale = param.borderLodScale
	else
		local worldMapLodCfg = include("worldMapLodCfg")
		self.lodCfgScale = worldMapLodCfg.borderLodScale
	end
end
function worldMapComBorderWar:init()
	self.lodConfig = nil
	self.curCell = self.target_.currentInMapViewCell
	local mapWidth = self.target_.mapSize.width
	self:createCurCellBorder(mapWidth)
end
function worldMapComBorderWar:onMessageListener()
	worldMapComBorderWar.super.onMessageListener(self)
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
end
local scaleborder = 4.0
local worldMapUtil = include("worldMapUtil")
function worldMapComBorderWar:updateScaleZoom(event)
	local scale = event.scale
	local config = worldMapUtil.getLodByScale(scale, self.lodConfig or self.lodCfgScale[1])
	if config ~= self.lodConfig then
		self.lodConfig = config
		self:updateBorderCfg(config)
	end
end
function worldMapComBorderWar:updateBorderCfg(info)
	local state = self.borderState
	if state then
		state:setUniformFloat("_BorderHeight", info.borderHeight * scaleborder)
		state:setUniformFloat("_BorderRatio", info.borderRatio / scaleborder)
	end
end
function worldMapComBorderWar:createCurCellBorder(mapWidth)
	local texWidth = 32
	local length = mapWidth * 128
	_UPVALUE16_ = nil
	;(nil)[1] = 1
	;(nil)[2] = -0.5
	;(nil)[3] = 0
	;(nil)[4] = 0
	;(nil)[5] = -1
	;(nil)[6] = -0.5
	;(nil)[7] = 0
	;(nil)[8] = 0
	;(nil)[9] = 0
	;(nil)[10] = 0
	;(nil)[11] = 1
	;(nil)[12] = 0
	;(nil)[13] = 0
	;(nil)[14] = length * 0.5
	;(nil)[15] = 0
	local (nil)[16], mat = 1, nil
	local _UPVALUE24_, _ENV, meshData = -0.5, 1, 1
	meshData.vertices, (-0.5)[1] = -0.5, 0
	meshData.vertices, (-0.5)[2] = -0.5, 0
	meshData.vertices, (-0.5)[3] = -0.5, 0
	meshData.vertices, (-0.5)[4] = -0.5, 0
	meshData.vertices, (-0.5)[5] = -0.5, length
	meshData.vertices, (-0.5)[6] = -0.5, 0
	meshData.vertices, (-0.5)[7] = -0.5, length
	meshData.vertices, (-0.5)[8] = -0.5, 0
	meshData.vertices, (-0.5)[9] = -0.5, 0
	meshData.vertices, (-0.5)[10] = -0.5, 0
	meshData.vertices, (-0.5)[11] = -0.5, 0
	meshData.vertices, (-0.5)[12] = -0.5, 0
	meshData.vertices, (-0.5)[13] = -0.5, 0
	meshData.vertices, (-0.5)[14] = -0.5, length
	meshData.vertices, (-0.5)[15] = -0.5, 0
	meshData.vertices, (-0.5)[16] = -0.5, length
	meshData.vertices, (-0.5)[17] = -0.5, 0
	meshData.vertices, (-0.5)[18] = -0.5, length
	meshData.vertices, (-0.5)[19] = -0.5, 0
	meshData.vertices, (-0.5)[20] = -0.5, length
	meshData.vertices, (-0.5)[21] = -0.5, length
	meshData.vertices, (-0.5)[22] = -0.5, length
	meshData.vertices, (-0.5)[23] = -0.5, length
	meshData.vertices, (-0.5)[24] = -0.5, length
	meshData.vertices, (-0.5)[25] = -0.5, length
	meshData.vertices, (-0.5)[26] = -0.5, 0
	meshData.vertices, (-0.5)[27] = -0.5, length
	meshData.vertices, (-0.5)[28] = -0.5, 0
	meshData.vertices, (-0.5)[29] = -0.5, length
	meshData.vertices, (-0.5)[30] = -0.5, length
	meshData.vertices, (-0.5)[31] = -0.5, length
	meshData.vertices, (-0.5)[32] = -0.5, length
	local maxU = length / texWidth
	_UPVALUE24_ = 0
	_UPVALUE24_, meshData.uv, (0)[1] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[2] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[3] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[4] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[5] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[6] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[7] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[8] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[9] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[10] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[11] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[12] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[13] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[14] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[15] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[16] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[17] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[18] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[19] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[20] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[21] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[22] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[23] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[24] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[25] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[26] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[27] = 0, 0, 0
	_UPVALUE24_, meshData.uv, (0)[28] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[29] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[30] = 0, 0, 1
	_UPVALUE24_, meshData.uv, (0)[31] = 0, 0, maxU
	_UPVALUE24_, meshData.uv, (0)[32] = 0, 0, 0
	meshData.normals, (0)[1] = 0, -1
	meshData.normals, (0)[2] = 0, -1
	meshData.normals, (0)[3] = 0, -1
	meshData.normals, (0)[4] = 0, 1
	meshData.normals, (0)[5] = 0, 1
	meshData.normals, (0)[6] = 0, 1
	meshData.normals, (0)[7] = 0, 1
	meshData.normals, (0)[8] = 0, -1
	meshData.normals, (0)[9] = 0, 1
	meshData.normals, (0)[10] = 0, -1
	meshData.normals, (0)[11] = 0, -1
	meshData.normals, (0)[12] = 0, -1
	meshData.normals, (0)[13] = 0, -1
	meshData.normals, (0)[14] = 0, 1
	meshData.normals, (0)[15] = 0, 1
	meshData.normals, (0)[16] = 0, 1
	meshData.normals, (0)[17] = 0, -1
	meshData.normals, (0)[18] = 0, -1
	meshData.normals, (0)[19] = 0, -1
	meshData.normals, (0)[20] = 0, 1
	meshData.normals, (0)[21] = 0, 1
	meshData.normals, (0)[22] = 0, 1
	meshData.normals, (0)[23] = 0, 1
	meshData.normals, (0)[24] = 0, -1
	meshData.normals, (0)[25] = 0, 1
	meshData.normals, (0)[26] = 0, -1
	meshData.normals, (0)[27] = 0, -1
	meshData.normals, (0)[28] = 0, -1
	meshData.normals, (0)[29] = 0, -1
	meshData.normals, (0)[30] = 0, 1
	meshData.normals, (0)[31] = 0, 1
	meshData.normals, (0)[32] = 0, 1
	local containerViewSize = self.target_.containerViewSize
	_UPVALUE3_, _ENV = -1, -1
	_UPVALUE3_, (-1).center, (-1)[1] = -1, -1, 0
	_UPVALUE3_, (-1).center, (-1)[2] = -1, -1, 0
	_UPVALUE3_, (-1).center, (-1)[3] = -1, -1, 0
	_UPVALUE3_, (-1).anchorPoint, (-1)[1] = -1, -1, 0
	_UPVALUE3_, (-1).anchorPoint, (-1)[2] = -1, -1, -1
	_UPVALUE3_, (-1).anchorPoint, (-1)[3] = -1, -1, 0
	_UPVALUE3_, (-1).size, (-1)[1] = -1, -1, containerViewSize.width
	_UPVALUE3_, (-1).size, (-1)[2] = -1, -1, containerViewSize.height
	_UPVALUE3_, (-1).size, (-1)[3] = -1, -1, 0
	_UPVALUE3_, (-1).minPos, (-1)[1] = -1, -1, -containerViewSize.width / 2
	_UPVALUE3_, (-1).minPos, (-1)[2] = -1, -1, -containerViewSize.height / 2
	_UPVALUE3_, (-1).minPos, (-1)[3] = -1, -1, 0
	_UPVALUE20_, meshData.bounds, (-1).maxPos, (-1)[1] = -1, -1, -1, containerViewSize.width / 2
	_UPVALUE20_, meshData.bounds, (-1).maxPos, (-1)[2] = -1, -1, -1, containerViewSize.height / 2
	_UPVALUE20_, meshData.bounds, (-1).maxPos, (-1)[3] = -1, -1, -1, 0
	_ENV, meshData.triangles, (-1)[1] = -1, -1, 0
	_ENV, meshData.triangles, (-1)[2] = -1, -1, 1
	_ENV, meshData.triangles, (-1)[3] = -1, -1, 2
	_ENV, meshData.triangles, (-1)[4] = -1, -1, 2
	_ENV, meshData.triangles, (-1)[5] = -1, -1, 3
	_ENV, meshData.triangles, (-1)[6] = -1, -1, 0
	_ENV, meshData.triangles, (-1)[7] = -1, -1, 4
	_ENV, meshData.triangles, (-1)[8] = -1, -1, 5
	_ENV, meshData.triangles, (-1)[9] = -1, -1, 6
	_ENV, meshData.triangles, (-1)[10] = -1, -1, 6
	_ENV, meshData.triangles, (-1)[11] = -1, -1, 7
	_ENV, meshData.triangles, (-1)[12] = -1, -1, 4
	_ENV, meshData.triangles, (-1)[13] = -1, -1, 8
	_ENV, meshData.triangles, (-1)[14] = -1, -1, 9
	_ENV, meshData.triangles, (-1)[15] = -1, -1, 10
	_ENV, meshData.triangles, (-1)[16] = -1, -1, 10
	_ENV, meshData.triangles, (-1)[17] = -1, -1, 11
	_ENV, meshData.triangles, (-1)[18] = -1, -1, 8
	_ENV, meshData.triangles, (-1)[19] = -1, -1, 12
	_ENV, meshData.triangles, (-1)[20] = -1, -1, 13
	_ENV, meshData.triangles, (-1)[21] = -1, -1, 14
	_ENV, meshData.triangles, (-1)[22] = -1, -1, 14
	_ENV, meshData.triangles, (-1)[23] = -1, -1, 15
	_ENV, meshData.triangles, (-1)[24] = -1, -1, 12
	;(-1).vert = "Shaders/worldBorder.vsh"
	local _ENV, _UPVALUE4_, (-1).frag, shader = 1, 0, "Shaders/worldBorder.fsh", -1
	;(1).attr = "texture"
	;(1).value = "SinglePicture/worldmap_border.png"
	_UPVALUE4_, (1).name = 2, "_MainTex"
	;(1).texParam, (2)[1] = 2, gl.LINEAR
	;(1).texParam, (2)[2] = 2, gl.LINEAR
	;(1).texParam, (2)[3] = 2, gl.REPEAT
	;(1).texParam, (2)[4] = 2, gl.REPEAT
	_ENV, (1).texForce = 2, true
	;(2).attr = "float"
	;(2).value = 2.0 * scaleborder
	_ENV, (2).name = 2.0 * scaleborder, "_BorderHeight"
	;(2.0 * scaleborder).attr = "float"
	;(2.0 * scaleborder).value = 1.0 / scaleborder
	_ENV, (2.0 * scaleborder).name = 1.0 / scaleborder, "_BorderRatio"
	_ENV, (1.0 / scaleborder).attr = gl.REPEAT, "vec4"
	gl.REPEAT.x = 1.0
	gl.REPEAT.y = 0.9490196078431372
	gl.REPEAT.z = 0.8156862745098039
	;(1.0 / scaleborder).value, gl.REPEAT.w = gl.REPEAT, 1
	;(1.0 / scaleborder).name = "_BorderColor"
	;(0)[1] = 1
	;(0)[2] = 2
	;(0)[3] = 2.0 * scaleborder
	local (0)[4], params = 1.0 / scaleborder, 0
	local mesh = SoraDCreateMeshNode(meshData, nil, shader, params)
	local Z_ORDER = worldMapDefine.Z_ORDER
	mesh:addTo(self.target_.containerView, Z_ORDER.tmxView + 1)
	mesh:setName("border")
	mesh:setAdditionalTransform(mat)
	mesh:setGroupID(worldMapDefine.GROU_ID.group_border)
	mesh:setPosition(containerViewSize.width / 2, containerViewSize.height / 2)
	self.border = mesh
	self.borderState = mesh:getGLProgramState()
end
function worldMapComBorderWar:exportMethods()
	_UPVALUE0_ = nil
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComBorderWar
