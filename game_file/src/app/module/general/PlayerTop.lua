local gamemodulec = include("GameModule")
local PlayerTop = class("PlayerTop", gamemodulec)
local msgCtrl = include("msgCtrl")
PlayerTop.schema = clone(cc.mvc.ModelBase.schema)
_UPVALUE2_ = cc.mvc.ModelBase.schema
_ENV = nil
PlayerTop.schema.modules, cc.mvc.ModelBase.schema[1] = cc.mvc.ModelBase.schema, "table"
PlayerTop.schema.modules, cc.mvc.ModelBase.schema[2] = cc.mvc.ModelBase.schema
PlayerTop.EVENT_HEARTBEAT_TIMEOUT = "HEARTBEAT_TIMEOUT_EVENT"
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function PlayerTop:ctor(properties)
	PlayerTop.super.ctor(self, properties)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.modules_ord, PlayerTop, self.modules_, PlayerTop = cc(self):addComponent("components.behavior.EventProtocol").exportMethods, cc(self):addComponent("components.behavior.EventProtocol").exportMethods, cc(self):addComponent("components.behavior.EventProtocol").exportMethods, cc(self):addComponent("components.behavior.EventProtocol").exportMethods
	local playerTopModule = include("PlayerTopModule")
	if not playerTopModule.ctrls then
		local PlayerTop, ctrlTab = playerTopModule.ctrls, playerTopModule.ctrls
	end
	if not playerTopModule.asynCtrls then
		local PlayerTop, asynCtrls = playerTopModule.asynCtrls, playerTopModule.asynCtrls
	end
	for _, ctrlName in ipairs(ctrlTab) do
		if not asynCtrls[ctrlName] then
			PlayerTop = ctrlName
			ctrlName.id = ctrlName
			local ctrl = include(ctrlName).new(ctrlName)
			self:addModule(ctrlName, ctrl)
		end
	end
end
function PlayerTop:addModule(key, value)
	assert(value, string.format("PlayerTop:addModule - key \"%s\" is nil", tostring(key)))
	assert(self.modules_[key] == nil, string.format("PlayerTop:addModule - key \"%s\" already add", tostring(key)))
	self.modules_[key] = value
	self.modules_ord[#self.modules_ord + 1] = value
end
function PlayerTop:dispatchRsp(rsp)
	local linkCtrl = self:getModule("linkCtrl")
	linkCtrl:onMsgRecive()
	msgCtrl.handle(rsp.data)
end
function PlayerTop:startTimer()
	self:stopTimer()
	self.delta = 0
	self.timerKey = scheduler.scheduleUpdateGlobal(handler(self, self.updateTime))
	local timerList = gModuleMgr.getObject("timerList")
	timerList:initTimer()
end
function PlayerTop:stopTimer()
	if self.timerKey then
		scheduler.unscheduleGlobal(self.timerKey)
		self.timerKey = nil
	end
end
function PlayerTop:updateTime(dttime)
	if not self then
		return
	end
	self.delta = self.delta + dttime
	if self.delta >= 1.0 then
		self.delta = self.delta - 1.0
		self:updateTimeCallback(1.0)
	end
end
function PlayerTop:updateTimeCallback(dttime)
	local timerList = gModuleMgr.getObject("timerList")
	if timerList then
		timerList:update()
	end
	local timeCtrl = self:getModule("timeCtrl")
	if timeCtrl then
		timeCtrl:update(dttime)
	end
	local cityCtrl = self:getModule("cityCtrl")
	if cityCtrl then
		cityCtrl:update(dttime)
	end
	local armyCtrl = self:getModule("armyCtrl")
	if armyCtrl then
		armyCtrl:update(dttime)
	end
	local allianceRank = self:getModule("allianceRank")
	if allianceRank then
		allianceRank:update(dttime)
	end
end
function PlayerTop:EnterGame()
	local curTime = SoraDGetSocketTime()
	userSDKManager.timeInfo.t_gamelogin.tend = curTime
	userSDKManager.timeInfo.t_gamedata.tbegin = curTime
	serviceFunctions.print("PlayerTop:EnterGame module num=", #self.modules_ord)
	local timerList = gModuleMgr.getObject("timerList")
	timerList:cleanTimers()
	msgCtrl.clean()
	for _, modulecell in ipairs(self.modules_ord) do
		modulecell:removeAllEventListeners()
	end
	msgCtrl.register(gCmd.CMD_LOGIN_DATA_INIT, gCmd.REQ_LOGIN_DATA_INIT, handler(self, self.getLoginDataInitRsp))
	local serverproxy = gModuleMgr.getObject("serverproxy")
	local gate = serverproxy.gate_
	if gate.removeEventListenersByEvent then
		gate:removeEventListenersByEvent(gate.GAME_MSG_RESPONSE)
	elseif gate.removeAllEventListenersForEvent then
		gate:removeAllEventListenersForEvent(gate.GAME_MSG_RESPONSE)
	end
	gate:addEventListener(gate.GAME_MSG_RESPONSE, handler(self, self.dispatchRsp))
	local loginDataInitCtrl = self:getModule("loginDataInitCtrl")
	loginDataInitCtrl:getLoginDataInitReq()
	self:startTimer()
end
function PlayerTop:getLoginDataInitRsp(...)
	self.mapID = nil
	self:clearRecordCfg()
	self:moduleLogout()
	self:MouleEnterGame()
	gModuleMgr.getObject("gametop"):registerServeStatus()
	local loginDataInitCtrl = self:getModule("loginDataInitCtrl")
	loginDataInitCtrl:getLoginDataInitRsp(...)
end
function PlayerTop:MouleEnterGame()
	for _, modulecell in ipairs(self.modules_ord) do
		modulecell:EnterGame()
	end
	local linkCtrl = self:getModule("linkCtrl")
	linkCtrl:addEventListener(linkCtrl.EVENT_HEARTBEAT_TIMEOUT, handler(self, self.onHeartbeatTimeOut))
end
function PlayerTop:IsInitDataReady()
	local loginDataInitCtrl = self:getModule("loginDataInitCtrl")
	if loginDataInitCtrl.isDataInit then
		return true
	else
		return false
	end
end
function PlayerTop:Logout()
	PlayerTop.super.Logout(self)
	self:stopTimer()
	local serverproxy = gModuleMgr.getObject("serverproxy")
	serverproxy:Logout()
	local loginDataInitCtrl = self:getModule("loginDataInitCtrl")
	loginDataInitCtrl:resetData()
	local timerList = gModuleMgr.getObject("timerList")
	timerList:cleanTimers()
	local linkCtrl = self:getModule("linkCtrl")
	linkCtrl:Logout()
end
function PlayerTop:moduleLogout()
	for _, modulecell in ipairs(self.modules_ord) do
		modulecell:Logout()
	end
end
function PlayerTop:getModule(id)
	local ret = self.modules_[id]
	if ret then
		return ret
	else
		print("==PlayerTop:getModule==", id)
		local playerTopModule = include("PlayerTopModule")
		if not playerTopModule.asynCtrls then
			local _ENV, config = playerTopModule.asynCtrls, playerTopModule.asynCtrls
		end
		local ctrlName = id
		if config[ctrlName] then
			_ENV = ctrlName
			ctrlName.id = ctrlName
			local ctrl = include(ctrlName).new(ctrlName)
			self:addModule(ctrlName, ctrl)
			ctrl:EnterGame()
			return ctrl
		else
		end
	end
end
function PlayerTop:setPlayerID(uid)
	self.uid = tonumber(uid)
end
function PlayerTop:getPlayerID()
	return self.uid
end
function PlayerTop:setKingdomID(kid)
	self.kid = tonumber(kid)
end
function PlayerTop:getKingdomID()
	return self.kid
end
function PlayerTop:setMapID(mapID)
	self.mapID = tonumber(mapID)
end
function PlayerTop:getMapID()
	if self.mapID and self.mapID > 0 then
		return self.mapID
	end
	return self.kid
end
function PlayerTop:onHeartbeatTimeOut()
	serviceFunctions.print("PlayerTop:onHeartbeatTimeOut()")
	_ENV = nil
	;(nil).name = PlayerTop.EVENT_HEARTBEAT_TIMEOUT
	self:dispatchEvent(nil)
end
function PlayerTop:clearRecordCfg()
	forceInclude("heroltCtrl")
end
return PlayerTop
