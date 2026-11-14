local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local wallsCtrl = class("wallsCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local wallsAuxiliary = include("wallsAuxiliary")
local cityWallConfig = include("cityWallConfig")
function wallsCtrl:ctor(properties)
	wallsCtrl.super.ctor(self, properties)
	self:resetData()
end
function wallsCtrl:resetData()
	self.wallsData = nil
	self.maxDefence = nil
end
function wallsCtrl:Logout()
	wallsCtrl.super.Logout(self)
	self:resetData()
	self:closeTimer()
end
function wallsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WALLS_MODULE, gCmd.REQ_INIT_WALLSDATA, handler(self, self.getWallsDataRsp))
	msgCtrl.register(gCmd.CMD_WALLS_MODULE, gCmd.REQ_WALLS_FIRE, handler(self, self.getWallsFireRsp))
	msgCtrl.register(gCmd.CMD_WALLS_MODULE, gCmd.REQ_ADD_DEFENCE, handler(self, self.getaddDefenceRsp))
	msgCtrl.register(gCmd.CMD_WALLS_MODULE, gCmd.REQ_REBUILD_WALL, handler(self, self.rebuildRsp))
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local eventName = string.format(gEventName.event_city_build_level_up, BUILDID.WALLS)
	self.handle_wall_level_up = cityCtrl:addEventListener(eventName, handler(self, self.updateMaxDefence))
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local defenceTechEventName = string.format(gEventName.event_tech_level_up, gTechnologyType.DEFENSE_ADD)
	self.handle_tech_level_up = technologyCtrl:addEventListener(defenceTechEventName, handler(self, self.updateMaxDefence))
end
function wallsCtrl:openTimer()
	self.lastTrialWarningTime = 0
	if not self.timer_handle then
		self.timer_handle = SoradCreateTimer(self, handler(self, self.update))
		print("城墙计时器开始了")
	end
end
function wallsCtrl:closeTimer()
	self.lastTrialWarningTime = 0
	if self.timer_handle then
		SoraDManagerRemoveTimer(self, self.timer_handle)
		self.timer_handle = nil
		print("城墙计时器关闭了")
	end
end
function wallsCtrl:update()
	local maxDefence = self:getMaxDefence()
	local defence = maxDefence - self.wallsData.defence
	local curDefence = self:getCurDefence()
	if defence ~= curDefence then
		_ENV = nil
		;(nil).msg = "MESSAGE_WALLS_NOTIFY_UPDATE"
		;(nil).data = self.wallsData
		SoraDSendMessage(nil)
	end
	if worldMapDefine.isInNewTrial() and self.wallsData.isBurning then
		local curTime = serviceFunctions.systemTime()
		if maxDefence > curDefence * 2 and curTime - self.lastTrialWarningTime > 30 then
			self.lastTrialWarningTime = curTime
			_ENV = self.wallsData
			self.wallsData.msg = "MESSAGE_WALLS_NOTIFY_TRIAL_WARNING"
			self.wallsData.data = self.wallsData
			SoraDSendMessage(self.wallsData)
		end
	end
end
function wallsCtrl:updateWallsData(data)
	if self.wallsData then
		for k, v in pairs(data) do
			self.wallsData[k] = v
		end
	else
		self.wallsData = data
	end
	if self.wallsData.isBurning then
		self:openTimer()
	else
		self:closeTimer()
	end
	if self.wallsData.status == gCityWallStatus.DESTRUCTION then
		print("城墙毁灭了")
		_ENV = "城墙毁灭了"
		;("城墙毁灭了").msg = "MESSAGE_WALLS_DEFENCE_DESTROY"
		SoraDSendMessage("城墙毁灭了")
	end
	print("刷新下城墙的破损状态")
	_ENV = "刷新下城墙的破损状态"
	;("刷新下城墙的破损状态").msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_EFFECT"
	SoraDSendMessage("刷新下城墙的破损状态")
end
function wallsCtrl:initWallsData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WALLS_MODULE, gCmd.REQ_INIT_WALLSDATA, nil, ...)
end
function wallsCtrl:getWallsDataRsp(respone)
	local data = respone.data
	self:updateWallsData(data)
	self:updateBurningQueue()
	self:updateRecoveryCDQueue()
end
function wallsCtrl:notifyWallsData(respone)
	local data = respone.data
	for i, notifyData in ipairs(data) do
		local notifyType = notifyData.notifyType
		local data = notifyData.notifyData
		self:updateWallsData(data)
		self:updateBurningQueue()
		self:updateRecoveryCDQueue()
		_ENV = self
		self.msg = "MESSAGE_WALLS_NOTIFY_SUCCESS"
		self.data = self.wallsData
		SoraDSendMessage(self)
	end
end
function wallsCtrl:getCurDefence()
	local curDefence = self:getMaxDefence() - self.wallsData.defence
	if self.wallsData.isBurning then
		local beginBurnTime = self.wallsData.beginBurnTime
		local burningTime = self.wallsData.burningTime
		local curTime = serviceFunctions.systemTime()
		local passTime = curTime - beginBurnTime
		local subDefence = math.floor(passTime / cityWallConfig.getIntervalOfDefence())
		local curDefence = curDefence - subDefence
		return 0 < curDefence and curDefence or 0
	else
		return 0 < curDefence and curDefence or 0
	end
end
function wallsCtrl:updateMaxDefence()
	print("wallsCtrl:updateMaxDefence")
	local buildLogic = include("buildLogic")
	local data = buildLogic.getWallsDef()
	if data and data.total then
		self.maxDefence = data.total
	else
		self.maxDefence = 0
	end
	return self.maxDefence
end
function wallsCtrl:getWallsFireRsp(respone)
	local data = respone.data
	local err = respone.err
	if gErrDef.Err_None == err then
		self:updateWallsData(data)
		self:updateBurningQueue()
		_ENV = self
		self.msg = "MESSAGE_WALLS_NOTIFY_SUCCESS"
		self.data = self.wallsData
		SoraDSendMessage(self)
	end
end
function wallsCtrl:getaddDefenceRsp(respone)
	local data = respone.data
	local err = respone.err
	if err == gErrDef.Err_None then
		self:updateWallsData(data)
		self:updateRecoveryCDQueue()
		_ENV = self
		self.msg = "MESSAGE_WALLS_NOTIFY_SUCCESS"
		self.queueType = gQueueTypeDef.walls_defence
		self.data = self.wallsData
		SoraDSendMessage(self)
	end
end
function wallsCtrl:rebuildRsp(respone)
	local data = respone.data
	local err = respone.err
	if err == gErrDef.Err_None then
		SoraDGotoWorldMapPoint()
	end
end
function wallsCtrl:updateBurningQueue()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.walls_burn)
	if self.wallsData.isBurning then
		local startTime = self.wallsData.beginBurnTime
		local burningTime = self.wallsData.burningTime
		local curTime = serviceFunctions.systemTime()
		local remainTime = burningTime - (curTime - startTime)
		if queue then
			local curRemainTime = queue.timerNode.timer:getRemainTime()
			local addTime = remainTime - curRemainTime
			if addTime ~= 0 then
				queueCtrl:updateLeftTime(gQueueTypeDef.walls_burn, addTime)
			end
		elseif remainTime and 0 < remainTime then
			queueCtrl:addQueue(gQueueTypeDef.walls_burn, startTime, burningTime, remainTime)
		end
	elseif queue then
		queueCtrl:removeQueue(gQueueTypeDef.walls_burn)
	end
end
function wallsCtrl:updateRecoveryCDQueue()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.walls_defence)
	if self.wallsData.isInRecoveryCD then
		if queue then
		else
			local startTime = self.wallsData.lastRecoveryTime
			local totalTime = cityWallConfig.getRecovertyCD()
			local curTime = serviceFunctions.systemTime()
			local remainTime = totalTime - (curTime - startTime)
			local queueCtrl = gametop.playertop_:getModule("queueCtrl")
			queueCtrl:addQueue(gQueueTypeDef.walls_defence, startTime, totalTime, remainTime)
			gametop = queueCtrl
			queueCtrl.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_EFFECT"
			SoraDSendMessage(queueCtrl)
		end
	elseif queue then
		queueCtrl:removeQueue(gQueueTypeDef.walls_defence)
		gametop = queueCtrl
		queueCtrl.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_EFFECT"
		SoraDSendMessage(queueCtrl)
	end
end
function wallsCtrl:getWallsData()
	if self.wallsData then
		return self.wallsData
	end
end
function wallsCtrl:getMaxDefence()
	if not self.maxDefence then
		self.maxDefence = self:updateMaxDefence()
	end
	return self.maxDefence
end
function wallsCtrl:getBurningTime()
	local startTime = self.wallsData.beginBurnTime
	local burningTime = self.wallsData.burningTime
	local curTime = serviceFunctions.systemTime()
	local remainTime = burningTime - (curTime - startTime)
	if remainTime < 0 then
		remainTime = 0
	end
	return remainTime
end
function wallsCtrl:wallsFire(...)
	print("wallsCtrl:wallsFire")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_WALLS_MODULE, gCmd.REQ_WALLS_FIRE, nil, ...)
end
function wallsCtrl:addDefence(...)
	print("wallsCtrl:addDefence")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_WALLS_MODULE, gCmd.REQ_ADD_DEFENCE, nil, ...)
end
function wallsCtrl:reqRebuildWall()
	print("wallsCtrl:reqRebuildWall")
	serverproxy:Request(gCmd.CMD_WALLS_MODULE, gCmd.REQ_REBUILD_WALL)
end
function wallsCtrl:isDestruction()
	return self.wallsData and self.wallsData.status == gCityWallStatus.DESTRUCTION
end
function wallsCtrl:isDamage()
	return self.wallsData and self.wallsData.status == gCityWallStatus.DAMAGE
end
function wallsCtrl:isInRecoveryCD()
	return self.wallsData.isInRecoveryCD
end
function wallsCtrl:initClientData(data)
	self:updateWallsData(data)
	self:updateBurningQueue()
	self:updateRecoveryCDQueue()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.WALLS, handler(self, self.notifyWallsData))
end
return wallsCtrl
