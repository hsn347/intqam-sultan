local instanceBuilder = class("instanceBuilder")
local instanceFactory = include("instanceFactory")
local worldMapDefine = include("worldMapDefine")
function instanceBuilder:ctor()
end
function instanceBuilder:init(cellArray)
	for _, mapViewCell in ipairs(cellArray) do
		self:initMapCell(mapViewCell)
	end
	self.mapViewCellArray = cellArray
end
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
function instanceBuilder:initMapCell(worldMapCell)
	local node = display.newNode()
	node:addTo(worldMapCell, Z_ORDER_CELL.objView)
	node:setName(self._layerName)
	worldMapCell[self._layerName] = node
end
function instanceBuilder:updateLodFocusChange(focus)
	for _, mapViewCell in ipairs(self.mapViewCellArray) do
		local node = mapViewCell[self._layerName]
		if node then
			node:setVisible(focus)
		end
	end
end
function instanceBuilder:updateLodChange(lod)
	self.lod = lod
end
function instanceBuilder:checkInstanceShow(data)
	return true
end
function instanceBuilder:checkInstanceShowLod(instance)
	return true
end
function instanceBuilder:addMapInstance(config, worldMapCell, worldInstanceData)
end
function instanceBuilder:addWorldInstance(worldMapCell, worldInstance)
	if worldInstance then
		worldMapCell[self._layerName]:addChild(worldInstance)
	end
end
function instanceBuilder:createMapInstance(worldMapCell, instanceData)
	local pos = cc.p(instanceData.x, instanceData.y)
	if not worldMapCell:checkVisibleByPos(pos) then
		return
	end
	return self:createMapInstance_imp(worldMapCell, instanceData)
end
function instanceBuilder:createMapInstance_imp(worldMapCell, instanceData)
	local worldMapInstance = instanceFactory.createMapInstance(self, worldMapCell, instanceData)
	if worldMapInstance then
		local delayTime = instanceData.delayTime
		worldMapInstance:showInstance(true, delayTime)
	end
	return worldMapInstance
end
function instanceBuilder:createMapInstanceConfig(worldMapCell, instanceData, worldInstanceData, config)
	local worldInstance = self:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldInstance then
		worldInstance:setLod(self.lod)
		worldInstance:initInstanceData(worldInstanceData.objData, worldInstanceData, instanceData)
	end
	return worldInstance
end
return instanceBuilder
