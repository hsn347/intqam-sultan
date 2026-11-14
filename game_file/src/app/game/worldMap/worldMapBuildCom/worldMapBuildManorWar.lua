local worldMapBuildManorWar = class("worldMapBuildManorWar", function(target)
	return target
end)
local worldMapInstance = include("worldMapInstance")
function worldMapBuildManorWar:ctor()
	self.size = 1
	self.radioation = 1
	self.buildManorID = 0
	self.buildKingdomID = 0
	self.buildColor = nil
end
function worldMapBuildManorWar:showInstance(show, delayTime)
	if not show then
		if self.buildManorID and self.buildManorID > 0 then
			local updateType = worldMapLeagueManorUpdateType.leagueManorInstanceRemove
			self:sendUpdateMsg(updateType)
		end
		self:sendUpdateBuildMsg(false)
	end
	worldMapInstance.showInstance(self, show, delayTime)
end
function worldMapBuildManorWar:resetBuildManor()
	self.buildManorID = 0
end
function worldMapBuildManorWar:setBuildSize(size, radioation, radioationY)
	self.size = size
	self.radioation = radioation
	self.radioationY = radioationY
end
function worldMapBuildManorWar:updateBuildManor(data)
	if self.leagueID and (self.leagueID ~= self.buildManorID or self.buildColor ~= self.relationType) then
		if self.buildManorID and self.buildManorID > 0 then
			self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
			self.buildManorID = 0
			self.buildKingdomID = 0
			self.buildColor = nil
		end
		local buildManorID = self.leagueID
		if buildManorID and 0 < buildManorID and self:isOccupCompleted() then
			self.buildManorID = buildManorID
			self.buildKingdomID = self.sourceID
			self.buildColor = self.relationType
			self:sendUpdateMsg(worldMapLeagueManorUpdateType.leagueManorInstanceAdd)
		end
	end
	self:sendUpdateBuildMsg(self.buildManorID <= 0)
end
function worldMapBuildManorWar:sendUpdateMsg(updateType, leagueID)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).updateType = updateType
	;(nil).leagueID = self.buildManorID
	;(nil).instanceID = self.instanceID
	;(nil).lineColor = self.lineColor
	;(nil).tilePoint = self.tilePoint
	;(nil).size = self.size
	;(nil).radioation = self.radioation
	local (nil).radioationY, data = self.radioationY, nil
	SoraDSendMessage(data)
end
local lineColor = cc.c4b(244, 216, 154, 127.5)
function worldMapBuildManorWar:sendUpdateBuildMsg(show)
	if self.showBuildLine == show then
		return
	end
	self.showBuildLine = show
	local updateType
	if show then
		updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	else
		updateType = worldMapLeagueManorUpdateType.leagueManorInstanceRemove
	end
	_ENV = worldMapLeagueManorUpdateType
	worldMapLeagueManorUpdateType.msg = "MESSAGE_WORLD_MAP_UPDATE_BUILD_INSTANCE"
	worldMapLeagueManorUpdateType.updateType = updateType
	worldMapLeagueManorUpdateType.instanceID = self.instanceID
	worldMapLeagueManorUpdateType.lineColor = lineColor
	worldMapLeagueManorUpdateType.tilePoint = self.tilePoint
	worldMapLeagueManorUpdateType.size = self.size
	worldMapLeagueManorUpdateType.radioation = self.radioation
	local worldMapLeagueManorUpdateType.radioationY, data = self.radioationY, worldMapLeagueManorUpdateType
	SoraDSendMessage(data)
end
return worldMapBuildManorWar
