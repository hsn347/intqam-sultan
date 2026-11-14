local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local instanceFactory = include("instanceFactory")
_ENV = "instanceFactory"
local ("instanceFactory")[1250101], guideStepConfig = true, "instanceFactory"
local worldMapComFakeInstance = class("worldMapComFakeInstance", include("worldMapCom"))
function worldMapComFakeInstance:ctor()
	worldMapComFakeInstance.super.ctor(self, "worldMapComFakeInstance")
end
function worldMapComFakeInstance:init()
	worldMapComFakeInstance.super.init(self)
	self.worldMapCell = self.target_.currentInMapViewCell
	self.currentShowTilesArray, worldMapComFakeInstance, self.isInFakeInstance = self.target_.currentInMapViewCell, self.target_.currentInMapViewCell, false
	self:initFakeNode()
end
function worldMapComFakeInstance:onMessageListener()
end
function worldMapComFakeInstance:initFakeNode()
	local guideStepIndex = SoraDIsGameGuide()
	dump(guideStepIndex, "worldMapComFakeInstance:initFakeNode")
	if not guideStepIndex then
		return
	end
	if not guideStepConfig[guideStepIndex] then
		return
	end
	self.isInFakeInstance = true
	self.currentGuideStepIndex = guideStepIndex
	self.moveNode = self.worldMapCell:getChildByName("moveNode")
	self.moveNode:setVisible(false)
	local node = display.newNode()
	node:addTo(self.worldMapCell, -1)
	node:setName("Node_GuideFakeNode")
	self.Node_GuideFakeNode = node
	self:refreshNode()
	_ENV = self
	self.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
	self.step = guideStepIndex
	self.reload = false
	SoraDSendMessage(self)
end
function worldMapComFakeInstance:refreshNode()
	local tilePoint = cityCtrl:getCurCityPos()
	if tilePoint.x > self.target_.tileSize.width / 2 then
		tilePoint.x = tilePoint.x - 3
	else
		tilePoint.x = tilePoint.x + 3
	end
	if tilePoint.y > self.target_.tileSize.height / 2 then
		tilePoint.y = tilePoint.y - 3
	else
		tilePoint.y = tilePoint.y + 3
	end
	self.target_.initTilePoint = tilePoint
	self.fakeInsanceTilePoint = tilePoint
	local holdInstace = 3
	local instance = SoraDCreatePanel("worldMapGuideRemains")
	instance:addTo(self.Node_GuideFakeNode, tilePoint.x + tilePoint.y)
	local instancePoint = self.worldMapCell:getPointWithTile(tilePoint, holdInstace)
	instance:setPosition(instancePoint)
	local tilesArray = instanceFactory.getTilesArrayByInstace(tilePoint, holdInstace)
	instance:setTilesArray(tilesArray)
	instance:setTilePoint(tilePoint)
	instance:setHoldInstace(holdInstace)
	instance:toggle3D()
	for _, tile in pairs(tilesArray) do
		self.currentShowTilesArray[tile] = instance
	end
end
function worldMapComFakeInstance:onMsgInitNpc(...)
end
function worldMapComFakeInstance:checkIsShowFakeInstance(instanceData)
	if not self.isInFakeInstance then
		return true
	end
	local tilesArray = instanceFactory.getTilesArrayByInstace(cc.p(instanceData.x, instanceData.y), 3)
	for _, tile in pairs(tilesArray) do
		if self.currentShowTilesArray[tile] then
			return false
		end
	end
	return true
end
function worldMapComFakeInstance:getTilePointFakeInstance(tilePoint)
	if not self.isInFakeInstance then
		return
	end
	local key = tilePoint.x .. "," .. tilePoint.y
	local instance = self.currentShowTilesArray[key]
	if instance and instance.__cname then
		return instance
	end
end
function worldMapComFakeInstance:getGuideFakeInstance(itemName)
	if itemName == "guideRemainsBuilding" then
		for k, v in pairs(self.currentShowTilesArray) do
			if v.guideName == itemName then
				return v
			end
		end
	end
	return nil
end
function worldMapComFakeInstance:getFakeInstanceTilePoint()
	return self.fakeInsanceTilePoint
end
function worldMapComFakeInstance:exportMethods(...)
	_UPVALUE3_ = nil
	;(nil)[1] = "checkIsShowFakeInstance"
	;(nil)[2] = "getTilePointFakeInstance"
	;(nil)[3] = "getGuideFakeInstance"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComFakeInstance
