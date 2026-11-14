local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local nationalFlagRead = include("nationalFlagRead")
local worldMapComBorder = class("worldMapComBorder", include("worldMapCom"))
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
function worldMapComBorder:ctor(param)
	worldMapComBorder.super.ctor(self, "worldMapComBorder")
	if param then
		self.lodCfgScale = param.borderLodScale
	end
end
function worldMapComBorder:init()
	self.lodConfig = nil
	self.curCell = self.target_.currentInMapViewCell
	local mapWidth = self.target_.mapSize.width
	self:createGrayBorder(mapWidth)
	self:initNeighbourKingdom()
end
function worldMapComBorder:onMessageListener()
	worldMapComBorder.super.onMessageListener(self)
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	self:addEventListener(worldMapEvent.EVENT_TILE_POS, handler(self, self.updateTilePos))
end
function worldMapComBorder:updateBorderPosition()
	self.nodeNeighbour:setPosition(self.curCell:getPosition())
	local kp1 = self.curCell:getKingdomPoint()
	local kp2 = self.target_.currentInMapViewCell:getKingdomPoint()
	if kp1.x == kp2.x and kp1.y == kp2.y then
		return
	end
	self.curCell = self.target_.currentInMapViewCell
	self:refreshNeighbourKingdom()
end
local scaleborder = 4.0
local worldMapUtil = include("worldMapUtil")
function worldMapComBorder:updateScaleZoom(event)
	local scale = event.scale
	local config = worldMapUtil.getLodByScale(scale, self.lodConfig or self.lodCfgScale[1])
	if config ~= self.lodConfig then
		self.lodConfig = config
		self:updateBorderCfg(config)
	end
	local nodeScale = math.min(100, 1 / scale * 2)
	for _, node in ipairs(self.nodeNeighbour.Node_kingdomList) do
		node:setScale(nodeScale)
	end
end
function worldMapComBorder:updateTilePos(...)
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local bottomPointNode = self.target_:getBottomPointNode()
	local tilePoint = bottomPointNode.tilePoint
	local tileMin = math.min(100, 1 / zoomScale * 2)
	local tileMax = 1200 - tileMin
	local tileX = util.clampf(tilePoint.x, tileMin, tileMax)
	local tileY = util.clampf(tilePoint.y, tileMin, tileMax)
	_UPVALUE3_ = tilePoint.y
	tilePoint.y[1] = cc.p(tileX, 1200.5)
	tilePoint.y[2] = cc.p(tileX, -0.5)
	tilePoint.y[3] = cc.p(-0.5, tileY)
	tilePoint.y[4] = cc.p(1200.5, tileY)
	tilePoint.y[5] = cc.p(1200.5, tileY)
	tilePoint.y[6] = cc.p(1200.5, tileY)
	tilePoint.y[7] = cc.p(1200.5, tileY)
	tilePoint.y[8] = cc.p(1200.5, tileY)
	tilePoint.y[9] = cc.p(1200.5, tileY)
	tilePoint.y[10] = cc.p(1200.5, tileY)
	tilePoint.y[11] = cc.p(1200.5, tileY)
	tilePoint.y[12] = cc.p(1200.5, tileY)
	local tilePoint.y[13], tilePointList = cc.p(1200.5, tileY)
	local _ENV, posList = cc.p(tileX, 1200.5), cc.p(tileX, 1200.5)
	for i, v in ipairs(tilePointList) do
		local point = self.target_:getPointWithTile(v)
		table.insert(posList, cc.p(point.x - self.target_.mapViewSize.width / 2, point.y - self.target_.mapViewSize.height / 2))
	end
	for index, node in ipairs(self.nodeNeighbour.Node_kingdomList) do
		node:setPosition(posList[index])
	end
end
function worldMapComBorder:updateBorderCfg(info)
	local state = self.borderGrayState
	if state then
		state:setUniformFloat("_BorderHeight", info.borderHeight * scaleborder)
		state:setUniformFloat("_BorderRatio", info.borderRatio / scaleborder)
	end
end
function worldMapComBorder:createCurCellBorder(mapWidth)
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
	_UPVALUE20_, meshData.normals, (0)[1] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[2] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[3] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[4] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[5] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[6] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[7] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[8] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[9] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[10] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[11] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[12] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[13] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[14] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[15] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[16] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[17] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[18] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[19] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[20] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[21] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[22] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[23] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[24] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[25] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[26] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[27] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[28] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[29] = 0, 0, -1
	_UPVALUE20_, meshData.normals, (0)[30] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[31] = 0, 0, 1
	_UPVALUE20_, meshData.normals, (0)[32] = 0, 0, 1
	_ENV, meshData.triangles, (0)[1] = 0, 0, 0
	_ENV, meshData.triangles, (0)[2] = 0, 0, 1
	_ENV, meshData.triangles, (0)[3] = 0, 0, 2
	_ENV, meshData.triangles, (0)[4] = 0, 0, 2
	_ENV, meshData.triangles, (0)[5] = 0, 0, 3
	_ENV, meshData.triangles, (0)[6] = 0, 0, 0
	_ENV, meshData.triangles, (0)[7] = 0, 0, 4
	_ENV, meshData.triangles, (0)[8] = 0, 0, 5
	_ENV, meshData.triangles, (0)[9] = 0, 0, 6
	_ENV, meshData.triangles, (0)[10] = 0, 0, 6
	_ENV, meshData.triangles, (0)[11] = 0, 0, 7
	_ENV, meshData.triangles, (0)[12] = 0, 0, 4
	_ENV, meshData.triangles, (0)[13] = 0, 0, 8
	_ENV, meshData.triangles, (0)[14] = 0, 0, 9
	_ENV, meshData.triangles, (0)[15] = 0, 0, 10
	_ENV, meshData.triangles, (0)[16] = 0, 0, 10
	_ENV, meshData.triangles, (0)[17] = 0, 0, 11
	_ENV, meshData.triangles, (0)[18] = 0, 0, 8
	_ENV, meshData.triangles, (0)[19] = 0, 0, 12
	_ENV, meshData.triangles, (0)[20] = 0, 0, 13
	_ENV, meshData.triangles, (0)[21] = 0, 0, 14
	_ENV, meshData.triangles, (0)[22] = 0, 0, 14
	_ENV, meshData.triangles, (0)[23] = 0, 0, 15
	_ENV, meshData.triangles, (0)[24] = 0, 0, 12
	;(0).vert = "Shaders/worldBorder.vsh"
	local _ENV, _UPVALUE4_, (0).frag, shader = 1, 0, "Shaders/worldBorder.fsh", 0
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
	self.border = mesh
	self.borderState = mesh:getGLProgramState()
end
function worldMapComBorder:createGrayBorder(mapWidth)
	local texWidth = 32
	local length = mapWidth * 128
	local maxU = length / texWidth
	local tempIndex = 0
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
	;(nil)[14] = length
	;(nil)[15] = 0
	local (nil)[16], mat = 1, nil
	local _ENV, vertices = 1, 1
	local _ENV, uv = -0.5, -0.5
	local _ENV, normals = 0, 0
	local _ENV, triangles = 0, 0
	for x = 1, 4 do
		for y = 1, 4 do
			local tempX = x - 2
			local tempY = y - 2
			local verticesIndex = #vertices
			local uvIndex = #uv
			local normalIndex = #normals
			local trianglesInex = #triangles
			local beginX = tempX * length
			local beginY = tempY * length
			local endX = (tempX + 1) * length
			local endY = (tempY + 1) * length
			vertices[verticesIndex + 1] = beginX
			vertices[verticesIndex + 2] = beginY
			vertices[verticesIndex + 3] = beginX
			vertices[verticesIndex + 4] = beginY
			vertices[verticesIndex + 5] = endX
			vertices[verticesIndex + 6] = beginY
			vertices[verticesIndex + 7] = endX
			vertices[verticesIndex + 8] = beginY
			vertices[verticesIndex + 9] = beginX
			vertices[verticesIndex + 10] = beginY
			vertices[verticesIndex + 11] = beginX
			vertices[verticesIndex + 12] = beginY
			vertices[verticesIndex + 13] = beginX
			vertices[verticesIndex + 14] = endY
			vertices[verticesIndex + 15] = beginX
			vertices[verticesIndex + 16] = endY
			for tempUvIndex = 0, 1 do
				uv[uvIndex + tempUvIndex * 8 + 1] = 0
				uv[uvIndex + tempUvIndex * 8 + 2] = 0
				uv[uvIndex + tempUvIndex * 8 + 3] = 0
				uv[uvIndex + tempUvIndex * 8 + 4] = 1
				uv[uvIndex + tempUvIndex * 8 + 5] = maxU
				uv[uvIndex + tempUvIndex * 8 + 6] = 1
				uv[uvIndex + tempUvIndex * 8 + 7] = maxU
				uv[uvIndex + tempUvIndex * 8 + 8] = 0
			end
			normals[normalIndex + 1] = -1
			normals[normalIndex + 2] = -1
			normals[normalIndex + 3] = -1
			normals[normalIndex + 4] = 1
			normals[normalIndex + 5] = 1
			normals[normalIndex + 6] = 1
			normals[normalIndex + 7] = 1
			normals[normalIndex + 8] = -1
			normals[normalIndex + 9] = 1
			normals[normalIndex + 10] = -1
			normals[normalIndex + 11] = -1
			normals[normalIndex + 12] = -1
			normals[normalIndex + 13] = -1
			normals[normalIndex + 14] = 1
			normals[normalIndex + 15] = 1
			normals[normalIndex + 16] = 1
			triangles[trianglesInex + 1] = tempIndex * 8 + 0
			triangles[trianglesInex + 2] = tempIndex * 8 + 1
			triangles[trianglesInex + 3] = tempIndex * 8 + 2
			triangles[trianglesInex + 4] = tempIndex * 8 + 2
			triangles[trianglesInex + 5] = tempIndex * 8 + 3
			triangles[trianglesInex + 6] = tempIndex * 8 + 0
			triangles[trianglesInex + 7] = tempIndex * 8 + 4
			triangles[trianglesInex + 8] = tempIndex * 8 + 5
			triangles[trianglesInex + 9] = tempIndex * 8 + 6
			triangles[trianglesInex + 10] = tempIndex * 8 + 6
			triangles[trianglesInex + 11] = tempIndex * 8 + 7
			triangles[trianglesInex + 12] = tempIndex * 8 + 4
			tempIndex = tempIndex + 1
		end
	end
	local _ENV, meshData = (for index), 1
	meshData.vertices = vertices
	meshData.uv = uv
	meshData.normals = normals
	meshData.triangles = triangles
	local containerViewSize = self.target_.containerViewSize
	_UPVALUE3_, _ENV = 0, 1
	_UPVALUE3_, (1).center, (0)[1] = 0, 0, 0
	_UPVALUE3_, (1).center, (0)[2] = 0, 0, 0
	_UPVALUE3_, (1).center, (0)[3] = 0, 0, 0
	_UPVALUE3_, (1).anchorPoint, (0)[1] = 0, 0, 0
	_UPVALUE3_, (1).anchorPoint, (0)[2] = 0, 0, -1
	_UPVALUE3_, (1).anchorPoint, (0)[3] = 0, 0, 0
	_UPVALUE3_, (1).size, (0)[1] = 0, 0, containerViewSize.width
	_UPVALUE3_, (1).size, (0)[2] = 0, 0, containerViewSize.height
	_UPVALUE3_, (1).size, (0)[3] = 0, 0, 0
	_UPVALUE3_, (1).minPos, (0)[1] = 0, 0, -containerViewSize.width / 2
	_UPVALUE3_, (1).minPos, (0)[2] = 0, 0, -containerViewSize.height / 2
	_UPVALUE3_, (1).minPos, (0)[3] = 0, 0, 0
	_ENV, meshData.bounds, (1).maxPos, (0)[1] = 1, 1, 0, containerViewSize.width / 2
	_ENV, meshData.bounds, (1).maxPos, (0)[2] = 1, 1, 0, containerViewSize.height / 2
	_ENV, meshData.bounds, (1).maxPos, (0)[3] = 1, 1, 0, 0
	;(1).vert = "Shaders/worldBorder.vsh"
	local _ENV, _UPVALUE4_, (1).frag, shader = containerViewSize.width / 2, 0, "Shaders/worldBorder.fsh", 1
	;(containerViewSize.width / 2).attr = "texture"
	;(containerViewSize.width / 2).value = "SinglePicture/worldmap_border.png"
	_UPVALUE4_, (containerViewSize.width / 2).name = containerViewSize.height / 2, "_MainTex"
	;(containerViewSize.width / 2).texParam, (containerViewSize.height / 2)[1] = containerViewSize.height / 2, gl.LINEAR
	;(containerViewSize.width / 2).texParam, (containerViewSize.height / 2)[2] = containerViewSize.height / 2, gl.LINEAR
	;(containerViewSize.width / 2).texParam, (containerViewSize.height / 2)[3] = containerViewSize.height / 2, gl.REPEAT
	;(containerViewSize.width / 2).texParam, (containerViewSize.height / 2)[4] = containerViewSize.height / 2, gl.REPEAT
	_ENV, (containerViewSize.width / 2).texForce = containerViewSize.height / 2, true
	;(containerViewSize.height / 2).attr = "float"
	;(containerViewSize.height / 2).value = 2.0 * scaleborder
	_ENV, (containerViewSize.height / 2).name = 2.0 * scaleborder, "_BorderHeight"
	;(2.0 * scaleborder).attr = "float"
	;(2.0 * scaleborder).value = 1.0 / scaleborder
	_ENV, (2.0 * scaleborder).name = 1.0 / scaleborder, "BorderRatio"
	_ENV, (1.0 / scaleborder).attr = gl.REPEAT, "vec4"
	gl.REPEAT.x = 1.0
	gl.REPEAT.y = 0.9490196078431372
	gl.REPEAT.z = 0.8156862745098039
	;(1.0 / scaleborder).value, gl.REPEAT.w = gl.REPEAT, 1
	;(1.0 / scaleborder).name = "_BorderColor"
	;(0)[1] = containerViewSize.width / 2
	;(0)[2] = containerViewSize.height / 2
	;(0)[3] = 2.0 * scaleborder
	local (0)[4], params = 1.0 / scaleborder, 0
	local mesh = SoraDCreateMeshNode(meshData, nil, shader, params)
	mesh:setName("borderGray")
	local Z_ORDER = worldMapDefine.Z_ORDER
	mesh:addTo(self.target_.containerView, Z_ORDER.tmxView + 1)
	mesh:setAdditionalTransform(mat)
	mesh:setGroupID(worldMapDefine.GROU_ID.group_border)
	mesh:setPosition(containerViewSize.width / 2, containerViewSize.height / 2)
	self.borderGray = mesh
	self.borderGrayState = mesh:getGLProgramState()
end
function worldMapComBorder:initNeighbourKingdom(...)
	local mapViewCell = self.target_.currentInMapViewCell
	local kingdomID = mapViewCell.kingdomID
	self.nodeNeighbour = self:createNeighbourKingdomView(mapViewCell, kingdomID)
	self.nodeNeighbour:setPosition(self.curCell:getPosition())
	self:refreshNeighbourKingdom()
end
function worldMapComBorder:createNeighbourKingdomView(parent, kingdomID)
	_UPVALUE3_ = nil
	;(nil)[1] = cc.p(-76800, -38400)
	;(nil)[2] = cc.p(76800, 38400)
	;(nil)[3] = cc.p(-76800, 38400)
	;(nil)[4] = cc.p(76800, -38400)
	;(nil)[5] = cc.p(76800, -38400)
	;(nil)[6] = cc.p(76800, -38400)
	;(nil)[7] = cc.p(76800, -38400)
	;(nil)[8] = cc.p(76800, -38400)
	;(nil)[9] = cc.p(76800, -38400)
	local (nil)[10], posList = cc.p(76800, -38400)
	local worldMapNeighbour = SoraDCreateCSBNode("worldMapNeighbour")
	worldMapNeighbour:addTo(self.target_.containerView, Z_ORDER_CELL.objView + 1)
	local _ENV, Node_kingdomList = worldMapNeighbour.addTo, worldMapNeighbour.addTo
	for index = 1, 4 do
		local Node_kingdom = SoraDGetChildByName(worldMapNeighbour, "Node_kingdom" .. index)
		Node_kingdom:setScale(100)
		Node_kingdom:setPosition(posList[index])
		SoraDGetAllChildFromWidget(Node_kingdom, Node_kingdom)
		table.insert(Node_kingdomList, Node_kingdom)
	end
	worldMapNeighbour.Node_kingdomList = Node_kingdomList
	return worldMapNeighbour
end
function worldMapComBorder:refreshNeighbourKingdom(...)
	local upID, downID, leftID, rightID = kingdomPointDefine.getNeighbourKingdomsByPoint(self.curCell:getKingdomPoint(), self.curCell:getRegionId())
	_UPVALUE4_ = self.curCell:getRegionId()
	self.curCell:getRegionId()[1] = downID
	self.curCell:getRegionId()[2] = upID
	self.curCell:getRegionId()[3] = leftID
	local self.curCell:getRegionId()[4], kindomList = rightID, self.curCell:getRegionId()
	for index, node in ipairs(self.nodeNeighbour.Node_kingdomList) do
		self:refreshNeighbourSingle(node, kindomList[index])
	end
end
function worldMapComBorder:refreshNeighbourSingle(Node_kingdom, kingdomID)
	local Text_name = Node_kingdom.Text_name
	local Sprite_flag = Node_kingdom.Sprite_flag
	local Sprite_arrow = Node_kingdom.Sprite_arrow
	local isK, kInfo = kingdomCtrl:isFoundKingdomID(kingdomID)
	if kInfo then
		Text_name:setString(kInfo.kname)
	else
		local kingdomName = serviceFunctions.getKingdomFormatName(nil, 0)
		Text_name:setString(kingdomName)
	end
	Sprite_flag:setVisible(false)
	local flagImg = nationalFlagRead.getImgByID(kInfo and kInfo.flagid)
	if flagImg then
		Sprite_flag:setSpriteFrame(flagImg)
		Sprite_flag:setVisible(true)
	end
	SoraDToCenter(Node_kingdom.Node_info, 10)
end
function worldMapComBorder:getNeighbourKingdomNode(...)
	return self.nodeNeighbour
end
function worldMapComBorder:exportMethods()
	_UPVALUE2_ = nil
	;(nil)[1] = "updateBorderPosition"
	;(nil)[2] = "getNeighbourKingdomNode"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComBorder
