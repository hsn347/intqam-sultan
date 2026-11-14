local GameModule = include("GameModule")
local geocentricAdventureCtrl = class("geocentricAdventureCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function geocentricAdventureCtrl:ctor(properties)
	geocentricAdventureCtrl.super.ctor(self, properties)
end
function geocentricAdventureCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_ADVENTURE_MODULE, gCmd.REQ_GEOCENTRIC_ADVENTURE_INIT, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_ADVENTURE_MODULE, gCmd.REQ_GEOCENTRIC_ADVENTURE_REFRESH, handler(self, self.getRefreshResp))
	msgCtrl.register(gCmd.CMD_GEOCENTRIC_ADVENTURE_MODULE, gCmd.REQ_GEOCENTRIC_ADVENTURE_BUY, handler(self, self.getBuyResp))
	self:resetData()
end
function geocentricAdventureCtrl:initClientData(data)
	if not data then
		return
	end
	self.geocentricData = data
	self:registerNotify()
end
function geocentricAdventureCtrl:dump()
end
function geocentricAdventureCtrl:addGeocentricData(data)
	if data and next(data) then
		if not self.geocentricData then
			_ENV = self.geocentricData
		end
		self.geocentricData = self.geocentricData
		for activityID, value in pairs(data) do
			self.geocentricData[tostring(activityID)] = value
		end
	end
end
function geocentricAdventureCtrl:resetData()
	self.handle_notify = nil
	self.geocentricData = nil
end
function geocentricAdventureCtrl:Logout()
	self:resetData()
	geocentricAdventureCtrl.super.Logout(self)
end
function geocentricAdventureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GEOCENTRIC_ADVENTURE, handler(self, self.notifyHandler))
end
function geocentricAdventureCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			self:addGeocentricData(content)
			_ENV = self
			self.msg = "MESSAGE_GEOCENTRIC_ADVENTURE_NEXT_DAY_REFRESH"
			SoraDSendMessage(self)
		end
	end
end
function geocentricAdventureCtrl:sendInitMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_ADVENTURE_MODULE, gCmd.REQ_GEOCENTRIC_ADVENTURE_INIT, data)
end
function geocentricAdventureCtrl:sendRefreshMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_ADVENTURE_MODULE, gCmd.REQ_GEOCENTRIC_ADVENTURE_REFRESH, data)
end
function geocentricAdventureCtrl:sendBuyMsg(index)
	local serverproxy, data
	data.index = index
	serverproxy:Request(gCmd.CMD_GEOCENTRIC_ADVENTURE_MODULE, gCmd.REQ_GEOCENTRIC_ADVENTURE_BUY, data)
end
function geocentricAdventureCtrl:getInitResp(ret)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self:addGeocentricData(ret.rspdata)
	end
end
function geocentricAdventureCtrl:getRefreshResp(ret)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self:addGeocentricData(ret.rspdata)
		_ENV = self
		self.msg = "MESSAGE_GEOCENTRIC_ADVENTURE_REFRESH"
		SoraDSendMessage(self)
	end
end
function geocentricAdventureCtrl:getBuyResp(ret)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.geocentricData.buyInfo = ret.rspdata.buyInfo
		local reward = ret.rspdata.reward
		SoraDPopGainItem(reward[1], reward[2])
		_ENV = reward[1]
		reward[1].msg = "MESSAGE_GEOCENTRIC_ADVENTURE_BUY_SUCCESS"
		SoraDSendMessage(reward[1])
	end
end
function geocentricAdventureCtrl:getSellInfo()
	local _ENV, ret
	if self.geocentricData and self.geocentricData.sellInfo then
		for k, v in pairs(self.geocentricData.sellInfo) do
			if tonumber(k) then
				table.insert(ret, v)
			end
		end
		table.sort(ret, function(a, b)
			return a[1].stage < b[1].stage
		end)
	end
	return ret
end
function geocentricAdventureCtrl:getRefreshLimitAndCostGold()
	local refreshLimit = false
	local costGold = 0
	if self.geocentricData then
		for k, v in pairs(self.geocentricData) do
			refreshLimit = self.geocentricData.reachRefreshLimit
			costGold = self.geocentricData.refreshCostGold
			break
		end
	end
	return refreshLimit, costGold
end
function geocentricAdventureCtrl:getHaveBoughtInfo()
	local _ENV, ret
	if self.geocentricData and self.geocentricData.buyInfo then
		for k, v in pairs(self.geocentricData.buyInfo) do
			if tonumber(k) then
				table.insert(ret, v)
			end
		end
	end
	return ret
end
return geocentricAdventureCtrl
