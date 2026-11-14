local baseProxy = require("fgui.base.baseProxy")
local WorldMapTroopsDetailsProxy = class("WorldMapTroopsDetailsProxy", baseProxy)
function WorldMapTroopsDetailsProxy:onRegisterEvent()
	print("=======WorldMapTroopsDetailsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQBACKQUEUE", handler(self, self.requestInstanceInfo))
end
function WorldMapTroopsDetailsProxy:requestInstanceInfo()
	local mapInstance = self.view.otherData and self.view.otherData.mapInstance
	if not tolua.isnull(mapInstance) then
		local tilePoint = mapInstance:getTilePoint()
		local instanceID = mapInstance:getInstanceID()
		local kingdomID = mapInstance:getWorldMapCell().kingdomID
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID, kingdomID)
	end
end
function WorldMapTroopsDetailsProxy:serverMessage_RequestMapInstaceInfo(target, data)
	dump(data, "WorldMapTroopsDetailsView:serverMessage_RequestMapInstaceInfo===", 10)
	if not (data and data.data) or not next(data.data) then
		return
	end
	local mapInstance = self.view.otherData and self.view.otherData.mapInstance
	if not mapInstance or not mapInstance.__cname then
		return
	end
	local _ENV, tipButtonData = mapInstance.__cname, mapInstance.__cname
	local instanceType = mapInstance:getInstanceType()
	local instanceFactory = include("instanceFactory")
	local dataKey = instanceFactory.getInstanceDataKey(instanceType)
	if dataKey then
		tipButtonData, _ENV = data.data[dataKey], data.data[dataKey]
		tipButtonData = data.data[dataKey] or mapInstance.__cname
		dump(tipButtonData, "tipButtonData", 10)
	end
	local troopsData = tipButtonData.army
	if troopsData then
		self.view:initData(troopsData, self.view.allianceName, self.view.otherData)
	end
end
return WorldMapTroopsDetailsProxy
