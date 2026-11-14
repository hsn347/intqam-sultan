local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local mapBuffData = include("mapBuffData")
local mapBuffCtrl = class("mapBuffCtrl", GameModule)
function mapBuffCtrl:ctor(properties)
	mapBuffCtrl.super.ctor(self, properties)
end
function mapBuffCtrl:EnterGame()
	mapBuffCtrl.super.EnterGame(self)
	self.mapBuffData = mapBuffData.new()
	self:reqUpdateData()
end
function mapBuffCtrl:Logout()
	mapBuffCtrl.super.Logout(self)
	self.mapBuffData = nil
end
function mapBuffCtrl:initClientData(data)
	if not data then
		return
	end
	if not data.mapBuff then
		_UPVALUE0_ = data.mapBuff
	end
	self.mapBuffData.mapBuff = data.mapBuff
end
function mapBuffCtrl:reqUpdateData()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.MAP_BUFF, handler(self, self.onNotifyMsg))
end
function mapBuffCtrl:onNotifyMsg(notification)
	for _, msg in ipairs(notification.data) do
		if msg.type == gMapBuffMsgType.ADD then
			self.mapBuffData:addBuff(msg.mapId, msg.data)
		elseif msg.type == gMapBuffMsgType.DEL then
			self.mapBuffData:delBuff(msg.mapId, msg.data)
		elseif msg.type == gMapBuffMsgType.SET_ALL then
			self.mapBuffData:setMapBuff(msg.mapId, msg.data)
		end
	end
end
function mapBuffCtrl:getMaxBuff(mapId, buffId, teamId)
	return self.mapBuffData:getMaxBuff(mapId, buffId, teamId)
end
function mapBuffCtrl:getMapBuff(mapId)
	return self.mapBuffData:getMapBuff(mapId)
end
function mapBuffCtrl:getBuffEffect(buffId)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local mapId = gametop.playertop_:getMapID()
	local teamId = allianceMgr:getOwnTeamID() or 0
	if not self:getMaxBuff(mapId, buffId, teamId) then
		local _ENV, maxBuff = self:getMaxBuff(mapId, buffId, teamId), self:getMaxBuff(mapId, buffId, teamId)
	end
	return maxBuff.plus or 0
end
return mapBuffCtrl
