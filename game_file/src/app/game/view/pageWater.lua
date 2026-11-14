local pageObject = include("pageObject")
local pageWater = class("pageWater", pageObject)
local worldMapUtil = include("worldMapUtil")
local instanceCacheMgr = include("instanceCacheMgr")
local BEGIN_TYPE = instanceCacheMgr.BEGIN_TYPE.WATER_BEGIN_TYPE
function pageWater:ctor(worldMapCell)
	pageWater.super.ctor(self)
	self.worldMapCell = worldMapCell
end
function pageWater:createObjectByPage(pageID)
	local minX, maxX, minY, maxY = worldMapUtil.getPosByPage(pageID, self.worldMapCell.mapSize)
	if maxX <= minX or maxY <= minY then
		return
	end
	local lenX = maxX - minX
	local lenY = maxY - minY
	local mapLayer = self.worldMapCell.mapLayer
	local worldMapUtil, mergeVertices
	local worldMapUtil, mergeUVs
	local worldMapUtil, mergeColors
	local worldMapUtil, mergeTriangles
	local beginPos = cc.p(minX, minY)
	local tileSize = self.worldMapCell.tileSize
	local scaleWater = 1.543
	local waterTileSize = cc.size(tileSize.width / scaleWater, tileSize.height / scaleWater)
	local beginPoint = self.worldMapCell:getPointWithTile(beginPos)
	local waterNode = instanceCacheMgr.getInstance(BEGIN_TYPE + 1)
	local isFirstInit = false
	if not waterNode then
		waterNode = gl.glNodeCreate()
		waterNode:setTag(BEGIN_TYPE + 1)
		waterNode:addTo(self.worldMapCell, 10)
		isFirstInit = true
	else
		waterNode:setAutoClean(true)
		waterNode:addTo(self.worldMapCell, 10)
		waterNode:release()
		isFirstInit = false
	end
	waterNode:setPosition(beginPoint)
	self:addObjectByPage(pageID, waterNode)
	local numTris = 0
	for i = 0, lenX do
		for j = 0, lenY do
			local x = minX + i
			local y = minY + j
			local pos = cc.p(x, y)
			local tileGID = mapLayer:getTileGIDAt(pos)
			if 5 <= tileGID and tileGID <= 23 then
				local id = tileGID - 4
				local point = self.worldMapCell:getPointWithTile(pos)
				local meshData = self:getCityWaterMeshData(id)
				local num = #meshData.vertices / 2
				local scaleOffset = self:getScaleOffset(id)
				for index = 1, num do
					table.insert(mergeVertices, meshData.vertices[(index - 1) * 2 + 1] * scaleOffset.scale + i * waterTileSize.width / 2 - j * waterTileSize.width / 2 + scaleOffset.offsetx)
					table.insert(mergeVertices, meshData.vertices[(index - 1) * 2 + 2] * scaleOffset.scale - i * waterTileSize.height / 2 - j * waterTileSize.height / 2 + scaleOffset.offsety)
					table.insert(mergeUVs, meshData.uv[(index - 1) * 2 + 1])
					table.insert(mergeUVs, meshData.uv[(index - 1) * 2 + 2])
					table.insert(mergeColors, meshData.colors[(index - 1) * 4 + 1])
					table.insert(mergeColors, meshData.colors[(index - 1) * 4 + 2])
					table.insert(mergeColors, meshData.colors[(index - 1) * 4 + 3])
					table.insert(mergeColors, meshData.colors[(index - 1) * 4 + 4])
				end
				local newNumTris = num
				for index = 1, #meshData.triangles do
					table.insert(mergeTriangles, meshData.triangles[index] + numTris)
				end
				numTris = numTris + newNumTris
			end
		end
	end
	if isFirstInit then
		worldMapUtil = 0
		;(0).vertices = mergeVertices
		;(0).uv = mergeUVs
		;(0).colors = mergeColors
		local (0).triangles, mergedMesh = mergeTriangles, 0
		local waterShader = require("app.game.mainCity.shader.cityWater2")
		if not self.waterParam then
			worldMapUtil, _UPVALUE19_ = nil, self.waterParam
			;(nil).type = "texture"
			;(nil).name = "_texture11"
			;(nil).value = "MainCity/citywater3.png"
			_UPVALUE4_, (nil).hasMipmap = 0, false
			worldMapUtil, (nil).texParam, (0)[1] = 0, 0, gl.LINEAR
			worldMapUtil, (nil).texParam, (0)[2] = 0, 0, gl.LINEAR
			worldMapUtil, (nil).texParam, (0)[3] = 0, 0, gl.REPEAT
			worldMapUtil, (nil).texParam, (0)[4] = 0, 0, gl.REPEAT
			;(0).type = "texture"
			;(0).name = "_texture12"
			;(0).value = "MainCity/citywater3.png"
			_UPVALUE4_, (0).hasMipmap = gl.LINEAR, false
			worldMapUtil, (0).texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR, gl.LINEAR
			worldMapUtil, (0).texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR, gl.LINEAR
			worldMapUtil, (0).texParam, gl.LINEAR[3] = gl.LINEAR, gl.LINEAR, gl.REPEAT
			worldMapUtil, (0).texParam, gl.LINEAR[4] = gl.LINEAR, gl.LINEAR, gl.REPEAT
			gl.LINEAR.type = "texture"
			gl.LINEAR.name = "_textureall"
			gl.LINEAR.value = "MainCity/citywater5.png"
			_UPVALUE4_, gl.LINEAR.hasMipmap = gl.LINEAR, false
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR, gl.LINEAR
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR, gl.LINEAR
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[3] = gl.LINEAR, gl.LINEAR, gl.REPEAT
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[4] = gl.LINEAR, gl.LINEAR, gl.REPEAT
			gl.LINEAR.type = "texture"
			gl.LINEAR.name = "_zhezhao"
			gl.LINEAR.value = "MainCity/citywater4.png"
			_UPVALUE4_, gl.LINEAR.hasMipmap = gl.LINEAR, false
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR, gl.LINEAR
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR, gl.LINEAR
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[3] = gl.LINEAR, gl.LINEAR, gl.REPEAT
			worldMapUtil, gl.LINEAR.texParam, gl.LINEAR[4] = gl.LINEAR, gl.LINEAR, gl.REPEAT
			gl.LINEAR.type = "float"
			gl.LINEAR.name = "_niuqu_qd"
			worldMapUtil, gl.LINEAR.value = gl.LINEAR, -0.01
			gl.LINEAR.type = "float"
			gl.LINEAR.name = "_niuqu1_qd"
			worldMapUtil, gl.LINEAR.value = gl.LINEAR, 0.15
			gl.LINEAR.type = "float"
			gl.LINEAR.name = "_niuqu2_qd"
			worldMapUtil, gl.LINEAR.value = gl.REPEAT, 0.03
			gl.REPEAT.type = "float"
			gl.REPEAT.name = "_niuqu3_qd"
			worldMapUtil, gl.REPEAT.value = gl.REPEAT, -0.33
			gl.REPEAT.type = "float"
			gl.REPEAT.name = "_swater_ld"
			worldMapUtil, gl.REPEAT.value = tileGID - 4, 5
			;(tileGID - 4).type = "float"
			;(tileGID - 4).name = "_u"
			worldMapUtil, (tileGID - 4).value = self.worldMapCell:getPointWithTile(pos), -0.008
			self.worldMapCell:getPointWithTile(pos).type = "float"
			self.worldMapCell:getPointWithTile(pos).name = "_v"
			worldMapUtil, self.worldMapCell:getPointWithTile(pos).value = self:getCityWaterMeshData(id), 0.004
			self:getCityWaterMeshData(id).type = "float"
			self:getCityWaterMeshData(id).name = "_u2"
			worldMapUtil, self:getCityWaterMeshData(id).value = #meshData.vertices / 2, -0.005
			;(#meshData.vertices / 2).type = "float"
			;(#meshData.vertices / 2).name = "_v2"
			worldMapUtil, (#meshData.vertices / 2).value = self:getScaleOffset(id), 0.005
			self:getScaleOffset(id).type = "float"
			self:getScaleOffset(id).name = "_u3"
			worldMapUtil, self:getScaleOffset(id).value = num, -0.04
			num.type = "float"
			num.name = "_v3"
			worldMapUtil, num.value = 1, 0.005
			;(1).type = "vec4"
			worldMapUtil, (1).name = #meshData.triangles, "_texture11_ST"
			;(#meshData.triangles).x = 5.0
			;(#meshData.triangles).y = 10
			;(#meshData.triangles).z = 0.0
			worldMapUtil, (1).value, (#meshData.triangles).w = #meshData.triangles, #meshData.triangles, 0.0
			;(#meshData.triangles).type = "vec4"
			worldMapUtil, (#meshData.triangles).name = 1, "_texture12_ST"
			;(1).x = 12.2
			;(1).y = 15.0
			;(1).z = 2.92
			worldMapUtil, (#meshData.triangles).value, (1).w = 1, 1, 0.0
			;(1).type = "vec4"
			worldMapUtil, (1).name = table.insert, "_textureall_ST"
			table.insert.x = 5.66
			table.insert.y = 4.77
			table.insert.z = 0.0
			worldMapUtil, (1).value, table.insert.w = table.insert, table.insert, 0.0
			table.insert.type = "vec4"
			worldMapUtil, table.insert.name = table.insert, "_zhezhao_ST"
			table.insert.x = 2.0
			table.insert.y = 1.73
			table.insert.z = 0.81
			worldMapUtil, table.insert.value, table.insert.w = table.insert, table.insert, 0.0
			table.insert.type = "vec4"
			worldMapUtil, table.insert.name = mergeTriangles, "_water_color"
			mergeTriangles.x = 0.596078431372549
			mergeTriangles.y = 0.8823529411764706
			mergeTriangles.z = 1.0
			worldMapUtil, table.insert.value, mergeTriangles.w = mergeTriangles, mergeTriangles, 1.0
			mergeTriangles.type = "vec4"
			worldMapUtil, mergeTriangles.name = meshData.triangles[index] + numTris, "_swater2_color"
			;(meshData.triangles[index] + numTris).x = 0.03529411764705882
			;(meshData.triangles[index] + numTris).y = 0.03529411764705882
			;(meshData.triangles[index] + numTris).z = 0.03529411764705882
			worldMapUtil, mergeTriangles.value, (meshData.triangles[index] + numTris).w = meshData.triangles[index] + numTris, meshData.triangles[index] + numTris, 1.0
			;(meshData.triangles[index] + numTris).type = "vec4"
			worldMapUtil, (meshData.triangles[index] + numTris).name = nil, "_swater3_color"
			;(nil).x = 0.0
			;(nil).y = 0.1803921568627451
			;(nil).z = 0.22745098039215686
			;(meshData.triangles[index] + numTris).value, (nil).w = nil, 1.0
			self.waterParam, self.waterParam[1] = self.waterParam
			self.waterParam, self.waterParam[2] = self.waterParam, 0
			self.waterParam, self.waterParam[3] = self.waterParam, gl.LINEAR
			self.waterParam, self.waterParam[4] = self.waterParam, gl.LINEAR
			self.waterParam, self.waterParam[5] = self.waterParam, gl.LINEAR
			self.waterParam, self.waterParam[6] = self.waterParam, gl.LINEAR
			self.waterParam, self.waterParam[7] = self.waterParam, gl.LINEAR
			self.waterParam, self.waterParam[8] = self.waterParam, gl.REPEAT
			self.waterParam, self.waterParam[9] = self.waterParam, gl.REPEAT
			self.waterParam, self.waterParam[10] = self.waterParam, tileGID - 4
			self.waterParam, self.waterParam[11] = self.waterParam, self.worldMapCell:getPointWithTile(pos)
			self.waterParam, self.waterParam[12] = self.waterParam, self:getCityWaterMeshData(id)
			self.waterParam, self.waterParam[13] = self.waterParam, #meshData.vertices / 2
			self.waterParam, self.waterParam[14] = self.waterParam, self:getScaleOffset(id)
			self.waterParam, self.waterParam[15] = self.waterParam, num
			self.waterParam, self.waterParam[16] = self.waterParam, 1
			self.waterParam, self.waterParam[17] = self.waterParam, #meshData.triangles
			self.waterParam, self.waterParam[18] = self.waterParam, 1
			self.waterParam, self.waterParam[19] = self.waterParam, table.insert
			self.waterParam, self.waterParam[20] = self.waterParam, table.insert
			self.waterParam, self.waterParam[21] = self.waterParam, mergeTriangles
			self.waterParam, self.waterParam[22] = self.waterParam, meshData.triangles[index] + numTris
		end
		worldMapUtil = 1
		;(1).vertBytes = waterShader.vertBytes
		;(1).fragBytes = waterShader.fragBytes
		SoraDCreateMeshNode(mergedMesh, cc.size(1, 1), 1, self.waterParam, waterNode)
		waterNode:setScale(scaleWater)
	else
		worldMapUtil = 0
		;(0).vertices = mergeVertices
		;(0).uv = mergeUVs
		;(0).colors = mergeColors
		local (0).triangles, mergedMesh = mergeTriangles, 0
		waterNode:updateData(mergedMesh)
	end
end
function pageWater:getScaleOffset(id)
	if not self.scaleOffset then
		_UPVALUE0_, _UPVALUE0_ = nil, self.scaleOffset
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[1], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = -0.65
		_UPVALUE0_, self.scaleOffset[2], (nil).offsety = nil, nil, -0.15
		;(nil).scale = 1.0
		;(nil).offsetx = 0
		_UPVALUE0_, self.scaleOffset[3], (nil).offsety = nil, nil, -0.1
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[4], (nil).offsety = nil, nil, 0.15
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[5], (nil).offsety = nil, nil, 0.15
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[6], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[7], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.35
		_UPVALUE0_, self.scaleOffset[8], (nil).offsety = nil, nil, 0.05
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[9], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[10], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[11], (nil).offsety = nil, nil, -0.1
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[12], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[13], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[14], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[15], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = -0.25
		_UPVALUE0_, self.scaleOffset[16], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 0.997
		;(nil).offsetx = 0.1
		_UPVALUE0_, self.scaleOffset[17], (nil).offsety = nil, nil, -0.15
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		_UPVALUE0_, self.scaleOffset[18], (nil).offsety = nil, nil, 0.0
		;(nil).scale = 1.0
		;(nil).offsetx = 0.0
		self.scaleOffset, self.scaleOffset[19], (nil).offsety = self.scaleOffset, nil, 0.0
	end
	return self.scaleOffset[id]
end
function pageWater:delObject(object)
	if object then
		if object:getTag() > BEGIN_TYPE then
			instanceCacheMgr.addWater(object)
			object:setAutoClean(false)
			object:removeFromParent(false)
		else
			object:removeFromParent()
		end
	end
end
function pageObject:getCityWaterMeshData(id)
	if not self.waterIdTb then
		_ENV = self.waterIdTb
		self.waterIdTb[1] = 1
		self.waterIdTb[2] = 2
		self.waterIdTb[3] = 3
		self.waterIdTb[4] = 4
		self.waterIdTb[5] = 5
		self.waterIdTb[6] = 6
		self.waterIdTb[7] = 7
		self.waterIdTb[8] = 8
		self.waterIdTb[9] = 9
		self.waterIdTb[10] = 10
		self.waterIdTb[11] = 11
		self.waterIdTb[12] = 12
		self.waterIdTb[13] = 13
		self.waterIdTb[14] = 14
		self.waterIdTb[15] = 15
		self.waterIdTb[16] = 16
		self.waterIdTb[17] = 17
		self.waterIdTb[18] = 18
		self.waterIdTb, self.waterIdTb[19] = self.waterIdTb, 19
	end
	local waterIndex = self.waterIdTb[id]
	if waterIndex then
		local waterMeshName = "cw" .. waterIndex .. "_meshData"
		local waterMesh = require("app.game.worldMap.meshData." .. waterMeshName)
		return waterMesh
	end
end
return pageWater
