local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local worldLodDef = worldMapDefine.worldLodDef
local allianceDesRead = include("allianceDesRead")
local worldMapWarDef = include("worldMapWarDef")
local worldMapViewDef = include("worldMapViewDef")
local worldMapComManorlineNew = class("worldMapComManorlineNew", include("worldMapCom"))
function worldMapComManorlineNew:ctor()
	worldMapComManorlineNew.super.ctor(self, "worldMapComManorlineNew")
	self.currentShowLeagueManorLineArrary, worldMapComManorlineNew = worldMapComManorlineNew.super.ctor, worldMapComManorlineNew.super.ctor
	self.tiledBg_x = 0
	self.tiledBg_y = 0
	self.leagueIDArrary, worldMapComManorlineNew, self.isNeedRefresh = worldMapComManorlineNew.super.ctor, worldMapComManorlineNew.super.ctor, false
	self.colorIdArrary, worldMapComManorlineNew, self.curMaxSn = worldMapComManorlineNew.super.ctor, worldMapComManorlineNew.super.ctor, 0
	self.isInNebula = worldMapDefine.isInNebula()
	self.isInRoaringFlame = worldMapDefine.isRoaringFlameKingdomID()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	self.mapRangMaxX = worldMapWarDef.getMapRangMaxX(mapClassType)
end
function worldMapComManorlineNew:init()
end
function worldMapComManorlineNew:onMessageListener()
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_PIXEL_POS, handler(self, self.updateMapPos))
	self:addEventListener(worldMapEvent.EVENT_TOOGLE_3D, handler(self, self.toggle3D))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodLevel))
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE", handler(self, self.updateLeagueManorInstance))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE_RESET", handler(self, self.resetLeagueManorInstance))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_NODEINFO_SELECT_CHANGE", handler(self, self.updateNodeInfoSelect))
	local handlerChange = handler(self, self.updateRelationChange)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", handlerChange)
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", handlerChange)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_QUIT_SUCCESS", handlerChange)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_JOIN_SUCCESS", handlerChange)
end
function worldMapComManorlineNew:test(...)
	self.isTest = true
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local point = cityCtrl:getCurCityPos()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	;(nil).instanceID = string.format("%d-%d-19-6-6", point.x, point.y)
	_ENV, (nil).leagueID = string.format("%d-%d-19-6-6", point.x, point.y), 10
	string.format("%d-%d-19-6-6", point.x, point.y).x = point.x
	;(nil).tilePoint, string.format("%d-%d-19-6-6", point.x, point.y).y = string.format("%d-%d-19-6-6", point.x, point.y), point.y
	;(nil).size = 2
	;(nil).radioation = 5
	;(nil).activityStatus = true
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	;(nil).instanceID = "120-269-19-6-6"
	_ENV, (nil).leagueID = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 1
	worldMapLeagueManorUpdateType.leagueManorInstanceAdd.x = 120
	;(nil).tilePoint, worldMapLeagueManorUpdateType.leagueManorInstanceAdd.y = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 269
	;(nil).size = 2
	;(nil).radioation = 1
	;(nil).activityStatus = true
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	;(nil).instanceID = "119-276-19-6-6"
	_ENV, (nil).leagueID = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 2
	worldMapLeagueManorUpdateType.leagueManorInstanceAdd.x = 119
	;(nil).tilePoint, worldMapLeagueManorUpdateType.leagueManorInstanceAdd.y = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 276
	;(nil).size = 2
	;(nil).radioation = 1
	;(nil).activityStatus = false
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	;(nil).instanceID = "119-283-19-6-6"
	_ENV, (nil).leagueID = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 3
	worldMapLeagueManorUpdateType.leagueManorInstanceAdd.x = 119
	;(nil).tilePoint, worldMapLeagueManorUpdateType.leagueManorInstanceAdd.y = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 283
	;(nil).size = 2
	;(nil).radioation = 1
	;(nil).activityStatus = true
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	;(nil).instanceID = "112-273-19-6-6"
	_ENV, (nil).leagueID = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 4
	worldMapLeagueManorUpdateType.leagueManorInstanceAdd.x = 112
	;(nil).tilePoint, worldMapLeagueManorUpdateType.leagueManorInstanceAdd.y = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 273
	;(nil).size = 2
	;(nil).radioation = 1
	;(nil).activityStatus = false
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	;(nil).instanceID = "113-280-19-6-6"
	_ENV, (nil).leagueID = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 5
	worldMapLeagueManorUpdateType.leagueManorInstanceAdd.x = 113
	;(nil).tilePoint, worldMapLeagueManorUpdateType.leagueManorInstanceAdd.y = worldMapLeagueManorUpdateType.leagueManorInstanceAdd, 280
	;(nil).size = 2
	;(nil).radioation = 1
	;(nil).activityStatus = true
	SoraDSendMessage(nil)
end
function worldMapComManorlineNew:test2(...)
	self.isTest = true
	local center = cc.p(618, 693)
	local leagueID = 110
	local activityStatus = true
	local radioation = 5
	_ENV, _UPVALUE4_ = nil, nil
	_ENV, (nil).offset = cc.p(0, 0), cc.p(0, 0)
	_ENV, cc.p(0, 0).offset = cc.p(11, -5), cc.p(11, -5)
	cc.p(11, -5).offset = cc.p(0, 7)
	cc.p(11, -5).activityStatus = false
	_ENV, cc.p(11, -5).radioation = cc.p(0, 7), 1
	cc.p(0, 7).offset = cc.p(11, 5)
	cc.p(0, 7).leagueID = 2
	;(nil)[1] = nil
	;(nil)[2] = cc.p(0, 0)
	;(nil)[3] = cc.p(11, -5)
	local (nil)[4], config = cc.p(0, 7), nil
	for i, v in ipairs(config) do
		local _activityStatus = activityStatus
		if v.activityStatus ~= nil then
			_activityStatus = v.activityStatus
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
		;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
		;(nil).instanceID = string.format("%d-%d-19-6-%d", center.x, center.y, i)
		_ENV, (nil).leagueID = v.leagueID or leagueID, v.leagueID or leagueID
		;(v.leagueID or leagueID).x = center.x + v.offset.x
		;(nil).tilePoint, (v.leagueID or leagueID).y = v.leagueID or leagueID, center.y + v.offset.y
		;(nil).size = 1
		;(nil).radioation = v.radioation or radioation
		;(nil).activityStatus = _activityStatus
		SoraDSendMessage(nil)
	end
end
function worldMapComManorlineNew:toggle3D()
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
local TileBG_Offset_X = worldMapViewDef.TileBG_Offset_X
local TileBG_Offset_Y = worldMapViewDef.TileBG_Offset_Y
local POINT_ZERO = cc.p(0, 0)
function worldMapComManorlineNew:updateMapPos(event)
	local tile_pos = event.tile_pos
	if self.tiledBg_x ~= tile_pos.x or self.tiledBg_y ~= tile_pos.y then
		self.tiledBg_x = tile_pos.x
		self.tiledBg_y = tile_pos.y
		self:refreshMapPos(tile_pos)
	end
end
function worldMapComManorlineNew:refreshMapPos(tile_pos)
	if not self.tiledBg then
		return
	end
	local zoomScale = self.target_.viewScrollView:getZoomScale()
	local scalex = self.tiledBg:getContentSize().width / TileBG_Size / zoomScale
	local scaley = self.tiledBg:getContentSize().height / TileBG_Size / zoomScale
	TileBG_Size, TileBG_Size = nil, TileBG_Size
	;(nil).attr = "vec4"
	TileBG_Size, (nil).name = nil, "_TexturePos"
	;(nil).x = scalex
	;(nil).y = scaley
	;(nil).z = tile_pos.x
	TileBG_Size[1], (nil).value, (nil).w = nil, nil, tile_pos.y
	local param = TileBG_Size
	SoraDSetProgramStateParam(self.program, self.state, param)
end
function worldMapComManorlineNew:updateLodLevel(event)
	if not self.tiledBg then
		return
	end
	local lodLevel = self.target_:getCurLod()
	_ENV, _ENV = nil, self.target_
	;(nil).attr = "float"
	;(nil).name = "_LodLevel"
	self.target_[1], (nil).value = nil, lodLevel
	local param = self.target_
	SoraDSetProgramStateParam(self.program, self.state, param)
	if lodLevel <= worldLodDef.LOD3 then
		self:showManorline(true)
		if worldMapDefine.curSelectNodeInfo == worldMapViewDef.NODEINFO_TYPE_ALLIANCE then
			self:updateRelationChange()
		end
	else
		self.curSelectNodeInfo = nil
		self:updateNodeInfoSelect()
	end
end
function worldMapComManorlineNew:resetLeagueManorInstance(target, data)
	self.leagueIDArrary, _UPVALUE0_, self.currentShowLeagueManorLineArrary, _UPVALUE0_ = nil, nil, nil, nil
	self.colorIdArrary, _UPVALUE0_, self.isNeedRefresh = nil, nil, true
end
function worldMapComManorlineNew:updateLeagueManorInstance(target, data)
	local instanceID = data.instanceID
	local leagueID = data.leagueID
	local tilePoint = data.tilePoint
	local updateType = data.updateType
	local activiyStatus = data.activityStatus
	local size = data.size or 1
	local radioation = data.radioation or 2
	local radioSize = data.radioSize
	local sn = data.sn or 0
	local colorId = data.colorId or 0
	if instanceID == "leagueManorInstanceID" and data.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		local allianceBuildType = data.buildClassID
		local allianceBuildInfo = worldMapDefine.getAllianceBuildInfo(allianceBuildType)
		if allianceBuildInfo then
			size = allianceBuildInfo.size
			radioation = allianceBuildInfo.radioation
			colorId = allianceMgr:getAllianceProperty("territoryColorId") or 0
		end
	end
	if not self.colorIdArrary[leagueID] or 0 < colorId then
		self.colorIdArrary[leagueID] = colorId
	end
	local manorDataArrary = self.currentShowLeagueManorLineArrary[leagueID]
	if updateType == worldMapLeagueManorUpdateType.leagueManorInstanceAdd then
		local radioW, radioH = radioation, radioation
		if radioSize then
			radioW, radioH = radioSize.width, radioSize.height
		end
		_UPVALUE4_ = radioSize.width
		radioSize.width[1] = tonumber(tilePoint.x) - radioW
		radioSize.width[2] = tonumber(tilePoint.y) - radioH
		radioSize.width[3] = 2 * radioW + size
		local radioSize.width[4], lineData = 2 * radioH + size, radioSize.width
		local curLineArray = self:getLineArray(lineData, sn)
		if not manorDataArrary then
			manorDataArrary[2], _ENV, manorDataArrary[1], _ENV, manorDataArrary, _ENV = self, self, self, self, self, self
		end
		if activiyStatus then
			manorDataArrary[1][instanceID] = curLineArray
		else
			manorDataArrary[2][instanceID] = curLineArray
		end
		self.isNeedRefresh = true
	elseif updateType == worldMapLeagueManorUpdateType.leagueManorInstanceRemove then
		if not manorDataArrary then
			return
		end
		if manorDataArrary then
			if activiyStatus then
				manorDataArrary[1][instanceID] = nil
			else
				manorDataArrary[2][instanceID] = nil
			end
		end
		self.isNeedRefresh = true
	elseif updateType == worldMapLeagueManorUpdateType.leagueManorInstanceActiviy then
		if not manorDataArrary then
			return
		end
		if activiyStatus then
			local radioW, radioH = radioation, radioation
			if radioSize then
				radioW, radioH = radioSize.width, radioSize.height
			end
			_UPVALUE4_ = radioSize.width
			radioSize.width[1] = tonumber(tilePoint.x) - radioW
			radioSize.width[2] = tonumber(tilePoint.y) - radioH
			radioSize.width[3] = 2 * radioW + size
			local radioSize.width[4], lineData = 2 * radioH + size, radioSize.width
			local curLineArray = self:getLineArray(lineData, sn)
			manorDataArrary[1][instanceID] = curLineArray
			manorDataArrary[2][instanceID] = nil
		else
			local manorData = manorDataArrary[1][instanceID]
			if manorData then
				manorDataArrary[2][instanceID] = manorData
				manorDataArrary[1][instanceID] = nil
			end
		end
		self.isNeedRefresh = true
	elseif updateType == worldMapLeagueManorUpdateType.leagueManorRelationChange then
	end
	self.currentShowLeagueManorLineArrary[leagueID] = manorDataArrary
end
function worldMapComManorlineNew:updateInfo()
	if self.isNeedRefresh and self.target_:isVisible() then
		self.isNeedRefresh = false
		self:setAllianceTerritoryColor(self.currentShowLeagueManorLineArrary, self.target_.containerView)
	end
end
function worldMapComManorlineNew:updateRelationChange()
	self.isNeedRefresh = true
end
function worldMapComManorlineNew:getLineArray(lineData, sn)
	_UPVALUE12_ = nil
	;(nil)[1] = lineData[1]
	;(nil)[2] = lineData[2]
	;(nil)[3] = sn
	;(nil)[4] = lineData[1] + lineData[3]
	;(nil)[5] = lineData[2]
	;(nil)[6] = sn
	;(nil)[7] = lineData[1]
	;(nil)[8] = lineData[2] + lineData[4]
	;(nil)[9] = sn
	;(nil)[10] = lineData[1] + lineData[3]
	;(nil)[11] = lineData[2] + lineData[4]
	local (nil)[12], lineArrary = sn, nil
	return lineArrary
end
function worldMapComManorlineNew:getLeagueIDIndex(leagueID, isActivity)
	local leagueIDIndex = table.indexof(self.leagueIDArrary, leagueID)
	if not leagueIDIndex then
		table.insert(self.leagueIDArrary, leagueID)
		leagueIDIndex = #self.leagueIDArrary
	end
	if isActivity then
		leagueIDIndex = leagueIDIndex * 2
	else
		leagueIDIndex = leagueIDIndex * 2 - 1
	end
	return leagueIDIndex
end
function worldMapComManorlineNew:initSnMap(pointsArray, onlyShowSelf)
	local _ENV, snArrary
	local _ENV, snKey
	local num = 0
	for leagueID, manorLineArrary in pairs(pointsArray) do
		if not onlyShowSelf or self.myLeagueID == leagueID then
			for _, v in pairs(manorLineArrary) do
				for _, curLineArray in pairs(v) do
					local sn = curLineArray[3]
					if not snKey[sn] then
						table.insert(snArrary, sn)
						snKey[sn] = true
					end
					num = num + 1
				end
			end
		end
	end
	table.sort(snArrary)
	local _ENV, snMap = table.sort, table.sort
	for i, v in ipairs(snArrary) do
		snMap[v] = i
	end
	return snMap, snArrary[#snArrary], num
end
function worldMapComManorlineNew:getSnIndex(snMap, sn, isActivity)
	local snIndex = snMap[sn] or 0
	if isActivity then
		return snIndex * 0.1 - 1023
	else
		return snIndex * 0.1
	end
end
_UPVALUE6_, worldMapComManorlineNew.getCurMaxSn = function(self)
	return self.curMaxSn
end, function(self)
	return self.curMaxSn
end
;(function(self)
	return self.curMaxSn
end)[1] = 0
;(function(self)
	return self.curMaxSn
end)[2] = 2
;(function(self)
	return self.curMaxSn
end)[3] = 1
;(function(self)
	return self.curMaxSn
end)[4] = 1
;(function(self)
	return self.curMaxSn
end)[5] = 2
local (function(self)
	return self.curMaxSn
end)[6], table_index = 3, function(self)
	return self.curMaxSn
end
function worldMapComManorlineNew:setAllianceTerritoryColor(pointsArray, parent)
	self.myLeagueID = allianceMgr:getOwnAid() or 0
	local onlyShowSelf = self.target_:getCurLod() > worldLodDef.LOD3 and worldMapDefine.curSelectNodeInfo == worldMapViewDef.NODEINFO_TYPE_ALLIANCE
	local snMap, curMaxSn, num = self:initSnMap(pointsArray)
	local vertices = table.new(num * 12)
	local triangles = table.new(num * 6)
	local colors = table.new(num * 16)
	local index = 0
	self.curMaxSn = curMaxSn
	local index_vertices = 1
	local index_colors = 1
	local index_triangles = 1
	for leagueID, manorLineArrary in pairs(pointsArray) do
		if not onlyShowSelf or self.myLeagueID == leagueID then
			local allianceRelationType = gMapAllianceRelationType.NORMAL
			if self.isInNebula then
				allianceRelationType = tonumber(string.sub(leagueID, -1, -1))
			else
				allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID) or gMapAllianceRelationType.NORMAL
				if self.isTest then
					allianceMgr = self.isTest
					self.isTest[1] = gMapAllianceRelationType.ALLY
					self.isTest[2] = gMapAllianceRelationType.FRIENDLY
					self.isTest[3] = gMapAllianceRelationType.ENEMY
					self.isTest[4] = gMapAllianceRelationType.SELF
					local self.isTest[5], config = gMapAllianceRelationType.NORMAL, self.isTest
					allianceRelationType = config[leagueID] or gMapAllianceRelationType.NORMAL
				end
				if self.myLeagueID == leagueID then
					allianceRelationType = gMapAllianceRelationType.SELF
				end
			end
			local cIndex = self.colorIdArrary[leagueID]
			for activiyStatus, v in pairs(manorLineArrary) do
				local as = (activiyStatus - 1) * 20
				local rIndex = allianceRelationType
				if 3.5 < allianceRelationType and allianceRelationType < 5.5 and 0.5 < cIndex then
					rIndex = cIndex + 6
				end
				if self.isInRoaringFlame and 0 < cIndex then
					rIndex = cIndex
				end
				local r = rIndex + as
				local isActivity = activiyStatus == 1
				local leagueIDIndex = self:getLeagueIDIndex(leagueID, isActivity)
				local g = math.floor(leagueIDIndex / 255)
				local b = (leagueIDIndex - 1) % 255 + 1
				allianceRelationCtrl = isActivity
				isActivity[1] = r / 255
				isActivity[2] = g / 255.0
				isActivity[3] = b / 255.0
				local isActivity[4], table_color = 1.0, isActivity
				for _, curLineArray in pairs(v) do
					for i, m in ipairs(curLineArray) do
						if i % 3 == 0 then
							local snIndex = self:getSnIndex(snMap, m, isActivity)
							vertices[index_vertices] = snIndex
							index_vertices = index_vertices + 1
							for _, l in ipairs(table_color) do
								colors[index_colors] = l
								index_colors = index_colors + 1
							end
						else
							vertices[index_vertices] = m
							index_vertices = index_vertices + 1
						end
					end
					for _, j in ipairs(table_index) do
						triangles[index_triangles] = j + index * 4
						index_triangles = index_triangles + 1
					end
					index = index + 1
				end
			end
		end
	end
	_ENV, allianceMgr, allianceMgr = pairs(pointsArray)
	_ENV, pairs(pointsArray).center, pairs(pointsArray)[1] = pairs(pointsArray)
	_ENV, pairs(pointsArray).center, pairs(pointsArray)[2] = pairs(pointsArray)
	_ENV, pairs(pointsArray).size, pairs(pointsArray)[1] = pairs(pointsArray)
	_ENV, pairs(pointsArray).size, pairs(pointsArray)[2] = pairs(pointsArray)
	pairs(pointsArray).bounds, pairs(pointsArray).minPos, pairs(pointsArray)[1] = pairs(pointsArray)
	pairs(pointsArray).bounds, pairs(pointsArray).minPos, pairs(pointsArray)[2] = pairs(pointsArray)
	local pairs(pointsArray).is3d, meshCfg = true, pairs(pointsArray)
	meshCfg.vertices = vertices
	meshCfg.colors = colors
	meshCfg.triangles = triangles
	if not self.meshNode1 then
		local shader = require("app.shader.allianceTerritoryMeshShader")
		local meshNode1 = SoraDCreateMeshNode(meshCfg, meshCfg.bounds.size, shader)
		meshNode1:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
		meshNode1:setDepthTest(true)
		meshNode1:setDepthWrite(true)
		meshNode1:retain()
		self.meshNode1 = meshNode1
	else
		if not meshCfg.colors then
			allianceMgr = meshCfg.colors
		end
		if not meshCfg.normals then
			allianceMgr = meshCfg.normals
		end
		self.meshNode1:setMeshData(meshCfg.vertices, meshCfg.colors, meshCfg.uv, meshCfg.triangles, meshCfg.normals)
	end
	if not self.renderTexture1 then
		self.renderTexture1 = cc.RenderTexture:create(self.mapRangMaxX, self.mapRangMaxX, cc.TEXTURE2_D_PIXEL_FORMAT_RG_B888, 33189)
		if self.renderTexture1 == nil then
			return
		end
		self.renderTexture1:addTo(parent)
		self.renderTexture1:setPosition(cc.p(display.cx, display.cy))
		self.renderTexture1:setProjection(cc.DIRECTOR_PROJECTION2_D)
		if G_IS_UNITY then
			self.renderTexture1:hideSelf()
			self.meshNode1:addTo(self.renderTexture1)
		end
	end
	self.renderTexture1:beginWithClear(0, 0, 0, 0, 1)
	self.meshNode1:visit()
	self.renderTexture1:endToLua()
	if not G_IS_UNITY then
		self.renderTexture1:setVisible(false)
	end
	self.tileTexture = self.renderTexture1:getSprite():getTexture()
	self.tileTexture:setTexParameters(gl.NEAREST, gl.NEAREST, gl.REPEAT, gl.REPEAT)
	self:drawRealAllianceLines(parent)
end
function worldMapComManorlineNew:drawRealAllianceLines(parent)
	_UPVALUE8_, _ENV = nil, nil
	_UPVALUE8_, (nil).vertices, (nil)[1] = nil, nil, 0
	_UPVALUE8_, (nil).vertices, (nil)[2] = nil, nil, 0
	_UPVALUE8_, (nil).vertices, (nil)[3] = nil, nil, 0
	_UPVALUE8_, (nil).vertices, (nil)[4] = nil, nil, self.mapRangMaxX
	_UPVALUE8_, (nil).vertices, (nil)[5] = nil, nil, self.mapRangMaxX
	_UPVALUE8_, (nil).vertices, (nil)[6] = nil, nil, 0
	_UPVALUE8_, (nil).vertices, (nil)[7] = nil, nil, self.mapRangMaxX
	_UPVALUE8_, (nil).vertices, (nil)[8] = nil, nil, self.mapRangMaxX
	_UPVALUE6_, (nil).uv, (nil)[1] = nil, nil, 0
	_UPVALUE6_, (nil).uv, (nil)[2] = nil, nil, 0
	_UPVALUE6_, (nil).uv, (nil)[3] = nil, nil, 0
	_UPVALUE6_, (nil).uv, (nil)[4] = nil, nil, 1
	_UPVALUE6_, (nil).uv, (nil)[5] = nil, nil, 1
	_UPVALUE6_, (nil).uv, (nil)[6] = nil, nil, 0
	_UPVALUE6_, (nil).uv, (nil)[7] = nil, nil, 1
	_UPVALUE6_, (nil).uv, (nil)[8] = nil, nil, 1
	_UPVALUE2_, _ENV, (nil).triangles, (nil)[1] = 0, nil, nil, 0
	_UPVALUE2_, _ENV, (nil).triangles, (nil)[2] = 0, nil, nil, 1
	_UPVALUE2_, _ENV, (nil).triangles, (nil)[3] = 0, nil, nil, 2
	_UPVALUE2_, _ENV, (nil).triangles, (nil)[4] = 0, nil, nil, 1
	_UPVALUE2_, _ENV, (nil).triangles, (nil)[5] = 0, nil, nil, 3
	_UPVALUE2_, _ENV, (nil).triangles, (nil)[6] = 0, nil, nil, 2
	_UPVALUE2_, (nil).center, (0)[1] = 0, 0, 0.0
	_UPVALUE2_, (nil).center, (0)[2] = 0, 0, 0.0
	_UPVALUE2_, (nil).size, (0)[1] = 0, 0, self.mapRangMaxX
	_UPVALUE2_, (nil).size, (0)[2] = 0, 0, self.mapRangMaxX
	_ENV, _ENV, (nil).bounds, (nil).minPos, (0)[1] = 0, nil, nil, 0, 0.0
	_ENV, _ENV, (nil).bounds, (nil).minPos, (0)[2] = 0, nil, nil, 0, 0.0
	local meshCfg
	;(0).attr = "#texture"
	;(0).name = "_MainTex"
	;(0).value = self.tileTexture
	_ENV, (nil)[1], (0).hasMipmap = 0, 0, false
	;(0).attr = "float"
	;(0).name = "step_tile"
	;(nil)[2], (0).value = 0, 1 / self.mapRangMaxX
	local param
	if not self.meshNode2 then
		local shader = require("app.shader.allianceTerritoryDrawShader")
		local meshNode2, shader2, state2 = SoraDCreateMeshNode(meshCfg, meshCfg.bounds.size, shader, param)
		meshNode2:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
		meshNode2:retain()
		self.meshNode2 = meshNode2
		self.shader2 = shader2
		self.state2 = state2
	else
		SoraDSetProgramStateParam(self.shader2, self.state2, param)
	end
	if not self.renderTexture2 then
		self.renderTexture2 = cc.RenderTexture:create(self.mapRangMaxX, self.mapRangMaxX, cc.TEXTURE2_D_PIXEL_FORMAT_RG_B888)
		if self.renderTexture2 == nil then
			return
		end
		self.renderTexture2:addTo(parent)
		self.renderTexture2:setPosition(cc.p(display.cx, display.cy))
		if G_IS_UNITY then
			self.renderTexture2:hideSelf()
			self.meshNode2:addTo(self.renderTexture2)
		end
	end
	self.renderTexture2:beginWithClear(0, 0, 0, 0)
	self.meshNode2:visit()
	self.renderTexture2:endToLua()
	if not G_IS_UNITY then
		self.renderTexture2:setVisible(false)
	end
	self.tileTexture = self.renderTexture2:getSprite():getTexture()
	self.tileTexture:setTexParameters(gl.NEAREST, gl.NEAREST, gl.REPEAT, gl.REPEAT)
	if not self.tiledBg then
		local tiledBg = display.newSprite("SinglePicture/bq_tex3.png")
		local width = display.width + 0.5 * display.height
		local height = display.height * 1.35
		local offsetX = (display.width - width) * 0.5
		tiledBg:setContentSize(width, height)
		tiledBg:setGroupID(worldMapDefine.GROU_ID.tileEffectBatchNode)
		tiledBg:addTo(self.target_, worldMapDefine.Z_ORDER.scrollView)
		tiledBg:setPositionX(offsetX)
		tiledBg:setAnchorPoint(cc.p(0, 0))
		tiledBg:setName("worldMapComManorlineNew")
		_ENV, self.tiledBg = tiledBg.setName, tiledBg
		tiledBg.setName.x = TileBG_Size
		tiledBg.setName.y = TileBG_Size
		tiledBg.setName.z = offsetX / width
		_ENV, self._resolution, tiledBg.setName.w = tiledBg.setName, tiledBg.setName, 0
		tiledBg.setName.x = self.mapRangMaxX
		tiledBg.setName.y = self.mapRangMaxX
		tiledBg.setName.z = 256
		self._tileInfo, tiledBg.setName.w = tiledBg.setName, 128
		self:loadShader()
	end
	_ENV, _ENV = display.width + 0.5 * display.height, tiledBg
	;(display.width + 0.5 * display.height).attr = "#texture"
	;(display.width + 0.5 * display.height).name = "_Texture"
	;(display.width + 0.5 * display.height).value = self.tileTexture
	display.newSprite("SinglePicture/bq_tex3.png")[1], (display.width + 0.5 * display.height).hasMipmap = display.width + 0.5 * display.height, false
	local param = display.newSprite("SinglePicture/bq_tex3.png")
	SoraDSetProgramStateParam(self.program, self.state, param)
	self:toggle3D()
	self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
end
function worldMapComManorlineNew:onExit()
	worldMapComManorlineNew.super.onExit(self)
	if self.meshNode1 then
		self.meshNode1:release()
		self.meshNode1 = nil
	end
	if self.meshNode2 then
		self.meshNode2:release()
		self.meshNode2 = nil
	end
end
function worldMapComManorlineNew:loadShader()
	local areaShader = require("app.shader.allianceTerritoryLineShader")
	_ENV, _ENV = nil, "app.shader.allianceTerritoryLineShader"
	;(nil).attr = "#texture"
	;(nil).name = "_Texture"
	;(nil).value = self.tileTexture
	_ENV, ("app.shader.allianceTerritoryLineShader")[1], (nil).hasMipmap = nil, nil, false
	;(nil).attr = "vec4"
	_ENV, (nil).name = self.tileTexture, "_TexturePos"
	self.tileTexture.x = 1
	self.tileTexture.y = 1
	self.tileTexture.z = 0
	_ENV, ("app.shader.allianceTerritoryLineShader")[2], (nil).value, self.tileTexture.w = nil, nil, self.tileTexture, 0
	;(nil).attr = "vec4"
	;(nil).name = "_Resolution"
	_ENV, ("app.shader.allianceTerritoryLineShader")[3], (nil).value = nil, nil, self._resolution
	;(nil).attr = "vec4"
	;(nil).name = "_TileInfo"
	_ENV, ("app.shader.allianceTerritoryLineShader")[4], (nil).value = nil, nil, self._tileInfo
	;(nil).attr = "float"
	;(nil).name = "_LodLevel"
	_ENV, ("app.shader.allianceTerritoryLineShader")[5], (nil).value = nil, nil, 0.0
	;(nil).attr = "float"
	;(nil).name = "step_tile"
	;("app.shader.allianceTerritoryLineShader")[6], (nil).value = nil, 1 / self.mapRangMaxX
	local allianceAreaParam = "app.shader.allianceTerritoryLineShader"
	local newCorlorArray
	if self.isInRoaringFlame then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		newCorlorArray = roaringFlameWarRead.getManorlineColorArray()
	else
		newCorlorArray = allianceDesRead.getManorlineColorArray()
	end
	_ENV = roaringFlameWarRead.getManorlineColorArray()
	roaringFlameWarRead.getManorlineColorArray().attr = "floatv"
	roaringFlameWarRead.getManorlineColorArray().name = "newCorlorArray"
	allianceAreaParam[#allianceAreaParam + 1], roaringFlameWarRead.getManorlineColorArray().value = roaringFlameWarRead.getManorlineColorArray(), newCorlorArray
	local program = cc.GLProgram:createWithFilenames(areaShader.vertBytes, areaShader.fragBytes)
	local state = cc.GLProgramState:create(program)
	SoraDSetProgramStateParam(program, state, allianceAreaParam)
	self.program = program
	self.state = state
	self.tiledBg:setGLProgramState(state)
	self:updateLodLevel()
end
function worldMapComManorlineNew:reloadShader()
	if not self.tiledBg then
		return
	end
	if cc.GLProgramState.setUniformFloatv then
		package.loaded["app.shader.allianceTerritoryLineShaderUniform"] = nil
	else
		package.loaded["app.shader.allianceTerritoryLineShader"] = nil
	end
	self:loadShader()
	self:refreshMapPos(cc.p(self.tiledBg_x, self.tiledBg_y))
end
function worldMapComManorlineNew:updateNodeInfoSelect(target, event)
	if self.curSelectNodeInfo and self.curSelectNodeInfo == worldMapDefine.curSelectNodeInfo then
		return
	end
	_ENV, self.curSelectNodeInfo = worldMapDefine.curSelectNodeInfo, worldMapDefine.curSelectNodeInfo
	worldMapDefine.curSelectNodeInfo[worldMapViewDef.NODEINFO_TYPE_MANORLINE] = true
	local worldMapDefine.curSelectNodeInfo[worldMapViewDef.NODEINFO_TYPE_ALLIANCE], config = true, worldMapDefine.curSelectNodeInfo
	local isShow = config[worldMapDefine.curSelectNodeInfo] or false
	self:showManorline(isShow)
	self:updateRelationChange()
end
function worldMapComManorlineNew:showManorline(isShow)
	if self.tiledBg then
		self.tiledBg:setVisible(isShow)
	end
end
function worldMapComManorlineNew:isInselfOrAllyLeagueManor(tilePoint, isCheckScore)
	isCheckScore = isCheckScore or false
	local isIn = false
	local isScoreEnough = false
	_ENV = nil
	;(nil).x = 0
	;(nil).y = 0
	;(nil).width = 0
	local (nil).height, rect = 0, nil
	for leagueID, dataArrary in pairs(self.currentShowLeagueManorLineArrary) do
		if isIn then
			break
		end
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
		if self.myLeagueID == leagueID or allianceRelationType == gMapAllianceRelationType.ALLY then
			local data = dataArrary[1]
			for _, v in pairs(data) do
				if isIn then
					break
				end
				local sn = v[3]
				if 0 <= sn then
					local width, height = v[10] - v[1], v[11] - v[2]
					rect.x = v[1]
					rect.y = v[2]
					rect.width = width - 1
					rect.height = height - 1
					if cc.rectContainsPoint(rect, tilePoint) then
						isIn = true
						if isCheckScore then
							if self.myLeagueID == leagueID then
								if allianceRelationCtrl:getTerrScore(self.myLeagueID) > 15000 then
									isScoreEnough = true
								end
								break
							end
							if allianceRelationCtrl:getTerrScore(self.myLeagueID) > 15000 and allianceRelationCtrl:getTerrScore(leagueID) > 15000 then
								isScoreEnough = true
							end
						end
						break
					end
				end
			end
		end
	end
	if isCheckScore then
		return isIn and isScoreEnough
	end
	return isIn
end
function worldMapComManorlineNew:isInSelfLeagueManor(leagueID, selfManorRect)
	_ENV = nil
	;(nil).x = selfManorRect.x - 1
	;(nil).y = selfManorRect.y - 1
	;(nil).width = selfManorRect.width + 2
	local _ENV, (nil).height, selfRect = selfManorRect.height + 2, selfManorRect.height + 2, nil
	;(selfManorRect.height + 2).x = 0
	;(selfManorRect.height + 2).y = 0
	;(selfManorRect.height + 2).width = 0
	local (selfManorRect.height + 2).height, rect = 0, selfManorRect.height + 2
	local selfLeagueManorDataArrary = self.currentShowLeagueManorLineArrary[leagueID]
	if selfLeagueManorDataArrary then
		for k, v in pairs(selfLeagueManorDataArrary[1]) do
			local sn = v[3]
			if 0 <= sn then
				local width, height = v[10] - v[1], v[11] - v[2]
				rect.x = v[1]
				rect.y = v[2]
				rect.width = width - 1
				rect.height = height - 1
				local isIn = SoraDRectIntersectsRect(selfRect, rect, true)
				if isIn then
					return true
				end
			end
		end
	end
	return false
end
function worldMapComManorlineNew:isInSelfHoldManor(leagueID, selfManorRect)
	_ENV = nil
	;(nil).x = selfManorRect.x - 1
	;(nil).y = selfManorRect.y - 1
	;(nil).width = selfManorRect.width + 2
	local _ENV, (nil).height, selfRect = selfManorRect.height + 2, selfManorRect.height + 2, nil
	;(selfManorRect.height + 2).x = 0
	;(selfManorRect.height + 2).y = 0
	;(selfManorRect.height + 2).width = 0
	local (selfManorRect.height + 2).height, rect = 0, selfManorRect.height + 2
	local selfLeagueManorDataArrary = self.currentShowLeagueManorLineArrary[leagueID]
	if selfLeagueManorDataArrary then
		for k, v in pairs(selfLeagueManorDataArrary[1]) do
			local sn = v[3]
			if sn == gManorlineSn.strongHold then
				local width, height = v[10] - v[1], v[11] - v[2]
				rect.x = v[1]
				rect.y = v[2]
				rect.width = width - 1
				rect.height = height - 1
				local isIn = SoraDRectIntersectsRect(selfRect, rect, true)
				if isIn then
					return true
				end
			end
		end
	end
	return false
end
function worldMapComManorlineNew:isFullInOtherLeagueManor(leagueID, selfManorRect, selfBuildRect)
	local data = self.target_:getInstanceMapFromManager()
	_ENV = self.target_
	self.target_.x = 0
	self.target_.y = 0
	self.target_.width = 0
	local self.target_.height, rect = 0, self.target_
	for k, v in pairs(data) do
		if v.leagueID and 0 < v.leagueID and v.leagueID ~= leagueID then
			local tp = v.tilePoint
			rect.x = tp.x
			rect.y = tp.y
			rect.width = v.size - 1
			rect.height = v.size - 1
			local isIn = SoraDRectIntersectsRect(rect, selfManorRect, true)
			if isIn then
				print("isFullInOtherLeagueManor container other build")
				return true
			end
		end
	end
	for k, v in pairs(self.currentShowLeagueManorLineArrary) do
		if k ~= leagueID then
			for _, m in ipairs(v) do
				for _, n in pairs(m) do
					local sn = n[3]
					if 0 <= sn then
						local width, height = n[10] - n[1], n[11] - n[2]
						rect.x = n[1]
						rect.y = n[2]
						rect.width = width - 1
						rect.height = height - 1
						local isIn = SoraDRectIntersectsRect(selfBuildRect, rect, true)
						if isIn then
							print("isFullInOtherLeagueManor container other line")
							return true
						end
					end
				end
			end
		end
	end
	return false
end
function worldMapComManorlineNew:exportMethods()
	_UPVALUE6_ = nil
	;(nil)[1] = "isInselfOrAllyLeagueManor"
	;(nil)[2] = "updateLeagueManorInstance"
	;(nil)[3] = "isInSelfLeagueManor"
	;(nil)[4] = "isInSelfHoldManor"
	;(nil)[5] = "isFullInOtherLeagueManor"
	;(nil)[6] = "getCurMaxSn"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComManorlineNew
