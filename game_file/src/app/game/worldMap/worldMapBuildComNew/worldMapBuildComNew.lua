local worldMapBuildComNew = class("worldMapBuildComNew")
function worldMapBuildComNew:ctor(target)
	self.target_ = target
	self:setCenterPoint(self.target_.centerPoint)
end
function worldMapBuildComNew:_initData(...)
end
function worldMapBuildComNew:setCenterPoint(centerPoint)
	self.centerPoint = centerPoint
end
function worldMapBuildComNew:_initUI(...)
end
function worldMapBuildComNew:addCacheBefore(...)
end
function worldMapBuildComNew:onMessageListener(...)
end
function worldMapBuildComNew:setBatchNodeGroupID(groupID)
end
function worldMapBuildComNew:updateData(data)
end
function worldMapBuildComNew:sendTileEffectMessage(...)
	self.target_:sendTileEffectMessage(...)
end
return worldMapBuildComNew
