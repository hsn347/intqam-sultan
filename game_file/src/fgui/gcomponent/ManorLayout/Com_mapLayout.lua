local instanceFactory = include("instanceFactory")
local manorCityRead = include("manorCityRead")
local manorCityUtil = include("manorCityUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_mapLayout = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorLayout/Com_mapLayout", Com_mapLayout)
fgui.register_extension("ui://ManorLayout/Com_mapLayout2", Com_mapLayout)
local p0 = cc.p(0, 0)
local w = 10.24
local h = 5.12
function Com_mapLayout:onInit()
	self.tileMap, p0 = nil, nil
	local zeroPos = self.fields.Node_zero:getPosition()
end
function Com_mapLayout:onShow()
end
function Com_mapLayout:initLayoutMap(map)
	local mapData = manorCityUtil.createMapData(map)
	self:initMapData(mapData)
end
function Com_mapLayout:initMapData(mapData)
	self:clearMapData()
	self.mapData = mapData
	for __, data in pairs(mapData) do
		local obj = self:createInstance(data)
		local buildSize = manorCityRead.getBuildSize(data.id)
		local tilesArray = instanceFactory.getTilesArrayByInstace(data, buildSize[1])
		for __, tile in ipairs(tilesArray) do
			self.tileMap[tile] = obj
		end
	end
end
function Com_mapLayout:createInstance(data)
	local instance = fgui.UIPackage:createObject("ManorCity", "ManorCityInstance")
	instance:addTo(self.fields.Group_instance)
	_ENV = nil
	instance:initInstanceData(data, nil, true)
	local tilePos = instance:getTilePos()
	local size = instance:getHoldSize()
	local centerTilePos = self:getBuildCenterTilePos(tilePos, size)
	local centerPos = self:getPointWithTile(centerTilePos)
	instance:setPosition(centerPos)
	instance:updateZOrder()
	instance:setScale(0.08)
	return instance
end
function Com_mapLayout:clearMapData()
	self.tileMap, _UPVALUE0_ = nil, nil
	self.fields.Group_instance:removeAllChildren()
	self.mapData, _UPVALUE0_ = self.fields.Group_instance.removeAllChildren, self.fields.Group_instance.removeAllChildren
end
function Com_mapLayout:getPointWithTile(tilePoint)
	return worldMapDefine.tile2point_fgui(p0, tilePoint, w, h)
end
function Com_mapLayout:getBuildCenterTilePos(tilePos, size)
	return cc.p(tilePos.x + size / 2 - 0.5, tilePos.y + size / 2 - 0.5)
end
function Com_mapLayout:getMapData()
	return self.mapData
end
return Com_mapLayout
