local gametop = gModuleMgr.getObject("gametop")
local gamemodulec = include("GameModule")
local starRhapsodyCtrl = class("starRhapsodyCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local starRhapsodyDef = include("starRhapsodyDef")
function starRhapsodyCtrl:getStarLampData(x, y)
	local lampsData = self.starLampData.lampsData
	if lampsData then
		local lampsData_x = lampsData[x]
		if lampsData_x then
			if not lampsData_x[y] then
				_UPVALUE0_ = lampsData_x[y]
			end
			return lampsData_x[y]
		end
	end
	_UPVALUE0_ = lampsData_x
	return lampsData[x]
end
function starRhapsodyCtrl:getStarLampDataByIndex(index)
	local x, y = starRhapsodyDef.indexToXY(index)
	return self:getStarLampData(x, y)
end
function starRhapsodyCtrl:getStarLampStatus(index)
	local lampsData = self:getStarLampDataByIndex(index)
	if lampsData then
		return lampsData.bright, lampsData.color
	end
	return false, 0
end
function starRhapsodyCtrl:setStarLampBright(x, y, color)
	local lampsData = self:getStarLampData(x, y)
	lampsData.bright = true
	lampsData.color = color or lampsData.color or 1
end
function starRhapsodyCtrl:isStarLampAllLight(index)
	local lampsData = self.starLampData.lampsData
	if lampsData then
		for _, row in ipairs(lampsData) do
			for _, v in ipairs(row) do
				if not v.bright then
					return false
				end
			end
		end
		return true
	end
	return false
end
function starRhapsodyCtrl:getStarLampCanLight(index)
	local num = 0
	local lampsData = self.starLampData.lampsData
	if lampsData then
		for _, row in ipairs(lampsData) do
			for _, v in ipairs(row) do
				if not v.bright then
					num = num + 1
				end
			end
		end
	end
	return num
end
function starRhapsodyCtrl:getResetTimes()
	local num = self.starLampData.payResetCount or 0
	return math.max(0, starRhapsodyDef.GOLD_RESET_MAX_NUM - num)
end
function starRhapsodyCtrl:resetResetTimes()
	self.starLampData.payResetCount = 0
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_STAR_RHAPSODY_REFRESH"
	SoraDSendMessage(nil)
end
function starRhapsodyCtrl:isHasGoldResetNum()
	local num = self:getResetTimes()
	return 0 < num
end
function starRhapsodyCtrl:getResetCost()
	local num = (self.starLampData.payResetCount or 0) + 1
	local starRhapsodyRead = include("starRhapsodyRead")
	return starRhapsodyRead:getResetGold(num)
end
function starRhapsodyCtrl:isCombAppearRound()
	local round = self.starLampData.specialCombNotAppearRound or 1
	return round == 0
end
function starRhapsodyCtrl:hasGetReward(combID)
	local rewardStatus = self.starLampData.rewardStatus
	if rewardStatus then
		return rewardStatus[combID]
	end
	return false
end
function starRhapsodyCtrl:addRewardStatus(data)
	local rewardStatus = self.starLampData.rewardStatus
	if rewardStatus then
		for i, v in pairs(data) do
			rewardStatus[i] = v
		end
	end
end
function starRhapsodyCtrl:getRewardStatus(data)
	if not self.starLampData.rewardStatus then
		local _UPVALUE0_, rewardStatus = self.starLampData.rewardStatus, self.starLampData.rewardStatus
	end
	return rewardStatus
end
function starRhapsodyCtrl:setStarLampRewardStatus(data)
	for _, combArray in pairs(data) do
		for _, v in pairs(combArray) do
			local lampsData = self:getStarLampData(v.x, v.y)
			lampsData.reward = true
		end
	end
end
function starRhapsodyCtrl:reqLightUpInStarLamp(index)
	local x, y = starRhapsodyDef.indexToXY(index)
	if 0 < x and 0 < y then
		print("starRhapsodyCtrl:reqlightUpInStarLamp", x, y)
		starRhapsodyDef = nil
		;(nil).x = x
		;(nil).y = y
		serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LIGHT_UP_IN_STAR_LAMP, nil)
	end
end
function starRhapsodyCtrl:reqResetInStarLamp()
	print("starRhapsodyCtrl:reqResetInStarLamp")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RESET_IN_STAR_LAMP)
end
function starRhapsodyCtrl:getItemMoonCount()
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(starRhapsodyDef.MOON_ITEM_ID)
	return itemCount
end
function starRhapsodyCtrl:getTaskAwardNum()
	local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
	local _, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	return num or 0
end
function starRhapsodyCtrl:getReceiveStatusAndNum()
	local item = self:getItemMoonCount()
	local light = self:getStarLampCanLight()
	local num = math.min(item, light) + self:getTaskAwardNum()
	return 0 < num, num
end
function starRhapsodyCtrl:ctor(properties)
	starRhapsodyCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.STAR_RHAPSODY
end
function starRhapsodyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_LIGHT_UP_IN_STAR_LAMP, handler(self, self.lightUpInStarLampRSP))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RESET_IN_STAR_LAMP, handler(self, self.resetInStarLampRSP))
	self:resetData()
end
function starRhapsodyCtrl:resetData()
	_UPVALUE0_, _UPVALUE3_, _UPVALUE3_, _UPVALUE0_ = nil, nil, nil, nil
	;(nil).bright = false
	_UPVALUE0_, (nil).color = nil, 0
	;(nil).bright = false
	_UPVALUE0_, (nil).color = nil, 0
	;(nil).bright = false
	;(nil).color = 0
	_UPVALUE0_, _UPVALUE3_, (nil)[1] = nil, nil, nil
	_UPVALUE0_, _UPVALUE3_, (nil)[2] = nil, nil, nil
	_UPVALUE0_, _UPVALUE3_, (nil)[3] = nil, nil, nil
	;(nil).bright = false
	_UPVALUE0_, (nil).color = nil, 0
	;(nil).bright = false
	_UPVALUE0_, (nil).color = nil, 0
	;(nil).bright = false
	;(nil).color = 0
	_UPVALUE0_, _UPVALUE3_, (nil)[1] = nil, nil, nil
	_UPVALUE0_, _UPVALUE3_, (nil)[2] = nil, nil, nil
	_UPVALUE0_, _UPVALUE3_, (nil)[3] = nil, nil, nil
	;(nil).bright = false
	_UPVALUE0_, (nil).color = nil, 0
	;(nil).bright = false
	_UPVALUE0_, (nil).color = nil, 0
	;(nil).bright = false
	;(nil).color = 0
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = nil
	;(nil).lampsData, (nil)[1] = nil, nil
	;(nil).lampsData, (nil)[2] = nil, nil
	;(nil).lampsData, (nil)[3] = nil, nil
	;(nil).payResetCount = 0
	self.starLampData, (nil).rewardStatus, _UPVALUE0_, (nil).specialCombNotAppearRound = nil, nil, nil, 1
end
function starRhapsodyCtrl:Logout()
	starRhapsodyCtrl.super.Logout(self)
	self:resetData()
end
function starRhapsodyCtrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	if userActivityModule then
		local activityData = userActivityModule[tostring(self.activityID)]
		if activityData then
			if not activityData.starLampData then
				local _ENV, starLampData = activityData.starLampData, activityData.starLampData
			end
			if starLampData then
				self.starLampData = starLampData
			end
		end
	end
end
function starRhapsodyCtrl:lightUpInStarLampRSP(event)
	dump(event, "starRhapsodyCtrl:lightUpInStarLampRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		if rspdata and rspdata.x and rspdata.y then
			self:setStarLampBright(rspdata.x, rspdata.y, rspdata.color)
			if rspdata.combs and next(rspdata.combs) then
				self:setStarLampRewardStatus(rspdata.combs)
				local _ENV, combArray = self.setStarLampRewardStatus, self.setStarLampRewardStatus
				for k, _ in pairs(rspdata.combs) do
					combArray[#combArray + 1] = tonumber(k)
				end
				self:addRewardStatus(rspdata.combs)
				local panel = SoraDCreatePanel("starRhapsodyAwardView")
				panel:initData(combArray)
				panel:show()
				_ENV = panel
				panel.msg = "MESSAGE_SERVER_STAR_RHAPSODY_LINE"
				panel.rewardStatus = rspdata.combs
				SoraDSendMessage(panel)
			end
			_ENV = SoraDCreatePanel("starRhapsodyAwardView")
			SoraDCreatePanel("starRhapsodyAwardView").msg = "MESSAGE_SERVER_STAR_RHAPSODY_REFRESH"
			SoraDSendMessage((SoraDCreatePanel("starRhapsodyAwardView")))
			local index = starRhapsodyDef.xyToIndex(rspdata.x, rspdata.y)
			_ENV = rspdata.y
			rspdata.y.msg = "MESSAGE_SERVER_STAR_RHAPSODY_EFFECT"
			rspdata.y.index = index
			SoraDSendMessage(rspdata.y)
		end
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage.eventID = self.activityID
		SoraDSendMessage(SoraDSendMessage)
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_STAR_RHAPSODY_REQ"
	SoraDSendMessage.err = event.err
	SoraDSendMessage(SoraDSendMessage)
end
function starRhapsodyCtrl:resetInStarLampRSP(event)
	dump(event, "starRhapsodyCtrl:resetInStarLampRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		local rspdata = event.rspdata
		if rspdata.starLampData then
			self.starLampData = rspdata.starLampData
			_ENV = 10
			;(10).msg = "MESSAGE_SERVER_STAR_RHAPSODY_REFRESH"
			SoraDSendMessage(10)
			_ENV = 10
			;(10).msg = "MESSAGE_SERVER_STAR_RHAPSODY_RESET"
			SoraDSendMessage(10)
		end
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(10).eventID = self.activityID
		SoraDSendMessage(10)
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_STAR_RHAPSODY_REQ"
	SoraDSendMessage.err = event.err
	SoraDSendMessage(SoraDSendMessage)
end
function starRhapsodyCtrl:getGroupID()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID) or 1
end
return starRhapsodyCtrl
