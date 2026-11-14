local GameModule = include("GameModule")
local pyramidCtrl = class("pyramidCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl")[800101] = 1
;("msgCtrl")[803201] = 2
;("msgCtrl")[803501] = 3
;("msgCtrl")[803301] = 5
local _ENV, ("msgCtrl")[803401], touZiArray = nil, 10, "msgCtrl"
;(nil).NOT_BEGIN_GAME = 0
;(nil).ALREADY_BEGIN_GAME = 1
local (nil).ALREADY_THROW_AGAIN, localState = 2, nil
function pyramidCtrl:ctor(properties)
	pyramidCtrl.super.ctor(self, properties)
end
function pyramidCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_INIT_DATA, handler(self, self.getInitPyramid))
	msgCtrl.register(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_REFRESH_DATA, handler(self, self.getRefresh))
	msgCtrl.register(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_START_THROW, handler(self, self.getStartThrow))
	msgCtrl.register(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_ONEKEY_THROW, handler(self, self.getOnekeyThrow))
	msgCtrl.register(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_RECEIVE_REWARD, handler(self, self.getReceiveReward))
	msgCtrl.register(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_THROW_AGAIN, handler(self, self.getThrowAgain))
	self:initPyramid()
	self:registerNotify()
end
function pyramidCtrl:initPyramid(...)
	self:initData()
end
function pyramidCtrl:initData()
	self.pyramidData, _UPVALUE0_ = nil, nil
	self.pyramidData.cost, _UPVALUE0_ = nil, nil
end
function pyramidCtrl:resetData()
	self.pyramidData, _UPVALUE0_ = nil, nil
	self.handle_notify = nil
	self.throwData = nil
end
function pyramidCtrl:Logout()
	pyramidCtrl.super.Logout(self)
	self:resetData()
end
function pyramidCtrl:setFloor()
	local score = self.pyramidData.score
	for i = 1, 6 do
		local minMax = self:getScoreByFloor(i)
		if minMax and score >= minMax.min and score <= minMax.max then
			self.pyramidData.floor = i
			return
		end
	end
end
function pyramidCtrl:initClientData(content)
	if not content then
		return
	end
	self.pyramidData = content.data
	self:setFloor()
	_ENV = self
	self.msg = "MESSAGE_SERVER_PYRAMID_INIT_DATA_BACK"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW"
	SoraDSendMessage(self)
end
function pyramidCtrl:getInitPyramid(content)
	self.pyramidData = content.data
	self:setFloor()
	_ENV = self
	self.msg = "MESSAGE_SERVER_PYRAMID_INIT_DATA_BACK"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW"
	SoraDSendMessage(self)
end
function pyramidCtrl:getRefresh(content)
	if gErrDef.Err_None == content.err then
		for i = 1, 6 do
			self.pyramidData["floorItem0" .. i] = content.data["floorItem0" .. i]
		end
		self.pyramidData.copper = content.data.copper
		_ENV = content.data.copper
		content.data.copper.msg = "MESSAGE_SERVER_PYRAMID_REFRESH_ITEMS_SUCCESS"
		SoraDSendMessage(content.data.copper)
		_ENV = content.data.copper
		content.data.copper.msg = "MESSAGE_UI_PYRAMID_UPDATE_COPPER"
		SoraDSendMessage(content.data.copper)
	elseif gErrDef.Err_PYRAMID_NOT_OPEN == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_ENOUGH_COPPER == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_RECEIVE == content.err then
	end
end
function pyramidCtrl:getStartThrow(content)
	if gErrDef.Err_None == content.err then
		self.throwData = content.data
		local throwData = content.data
		self.pyramidData.floor = throwData.floor
		self.pyramidData.award = throwData.award
		if throwData.score then
			self.pyramidData.score = throwData.score
		end
		if throwData.state then
			self.pyramidData.state = throwData.state
		end
		if throwData.record then
			self.pyramidData.record = throwData.record
		end
		if throwData.todayPlayInfo then
			self.pyramidData.todayPlayInfo = throwData.todayPlayInfo
		end
		self.pyramidData.isOneKey = 0
		_ENV = throwData.todayPlayInfo
		throwData.todayPlayInfo.msg = "MESSAGE_SERVER_PYRAMID_DICE_SUCCESS"
		SoraDSendMessage(throwData.todayPlayInfo)
		_ENV = nil
		;(nil).byUID = true
		local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", nil) or false
		if switch then
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_PYRAMID_SCORE_TO"
			SoraDSendMessage(nil)
		end
	elseif gErrDef.Err_PYRAMID_NOT_OPEN == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_ENOUGH_COPPER == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_RECEIVE == content.err then
	elseif gErrDef.Err_PYRAMID_MORE_THAN_LIMIT == content.err then
	end
end
function pyramidCtrl:getOnekeyThrow(content)
	dump(content, "pyramidCtrl:getOnekeyThrow", 10)
	if gErrDef.Err_None == content.err then
		self.pyramidData = content.rspdata.data
		self:setFloor()
		_ENV = self
		self.msg = "MESSAGE_UI_PYRAMID_UPDATE_COPPER"
		SoraDSendMessage(self)
		local pyramidData = include("pyramidData")
		pyramidData:setIsOneKey(true)
		_ENV = pyramidData
		pyramidData.msg = "MESSAGE_SERVER_PYRAMID_ONEKEY_THROW_BACK"
		SoraDSendMessage(pyramidData)
		if not content.rspdata.reward then
			local _ENV, rewardList = content.rspdata.reward, content.rspdata.reward
		end
		if 0 < #rewardList then
			for k, v in ipairs(rewardList) do
				v.index = k
			end
			local panel = SoraDCreatePanel("pyramidOneKeyRewardView")
			panel:initData(rewardList)
			panel:show()
		end
	elseif gErrDef.Err_PYRAMID_NOT_OPEN == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_ENOUGH_COPPER == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_RECEIVE == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP == content.err then
	elseif gErrDef.Err_PYRAMID_MORE_THAN_LIMIT == content.err then
	end
end
function pyramidCtrl:getThrowAgain(content)
	if gErrDef.Err_None == content.err then
		self.throwData = content.data
		local throwData = content.data
		self.pyramidData.floor = throwData.floor
		self.pyramidData.award = throwData.award
		if throwData.score then
			self.pyramidData.score = throwData.score
		end
		if throwData.state then
			self.pyramidData.state = throwData.state
		end
		if throwData.record then
			self.pyramidData.record = throwData.record
		end
		local pyramidData = include("pyramidData")
		if self:getIsOneKey() then
			_ENV = self
			self.msg = "MESSAGE_SERVER_PYRAMID_ONEKEY_THROW_BACK"
			SoraDSendMessage(self)
		else
			_ENV = self
			self.msg = "MESSAGE_SERVER_PYRAMID_DICE_SUCCESS"
			SoraDSendMessage(self)
		end
		_ENV = nil
		;(nil).byUID = true
		local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", nil) or false
		if switch then
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_PYRAMID_SCORE_TO"
			SoraDSendMessage(nil)
		end
	elseif gErrDef.Err_PYRAMID_NOT_OPEN == content.err then
	elseif gErrDef.Err_PYRAMID_NOT_ENOUGH_GOLD == content.err then
	elseif gErrDef.Err_PYRAMID_CANNOT_THROW == content.err then
	elseif gErrDef.Err_PYRAMID_IN_HIGHEST == content.err then
	end
end
function pyramidCtrl:getReceiveReward(content)
	if gErrDef.Err_None == content.err then
		if content.data.score then
			self.pyramidData.score = content.data.score
		end
		if content.data.state then
			self.pyramidData.state = content.data.state
		end
		if content.data.record then
			self.pyramidData.record = content.data.record
		end
		if content.data.pyramidData and content.data.pyramidData.data then
			self.pyramidData = content.data.pyramidData.data
		end
		print("self:getAwardState()", self:getAwardState())
		_ENV = "self:getAwardState()"
		;("self:getAwardState()").msg = "MESSAGE_SERVER_PYRAMID_GET_REWARD_SUCCESS"
		;("self:getAwardState()").award = content.data.award
		SoraDSendMessage("self:getAwardState()")
		_ENV = "self:getAwardState()"
		;("self:getAwardState()").msg = "MESSAGE_SERVER_PYRAMID_INIT_DATA_BACK"
		SoraDSendMessage("self:getAwardState()")
		_ENV = "self:getAwardState()"
		;("self:getAwardState()").msg = "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW"
		SoraDSendMessage("self:getAwardState()")
	elseif gErrDef.Err_BACKPACK_IS_FULL == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL"
		SoraDSendMessage(content.err)
	elseif gErrDef.Err_ITEM_COUNT_IS_LIMIT == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL"
		SoraDSendMessage(content.err)
	elseif gErrDef.Err_PYRAMID_NOT_OPEN == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL"
		SoraDSendMessage(content.err)
	elseif gErrDef.Err_PYRAMID_CANNOT_RECEIVE == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL"
		SoraDSendMessage(content.err)
	else
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_PYRAMID_BACKPACK_IS_FULL"
		SoraDSendMessage(content.err)
	end
end
function pyramidCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PYRAMID, handler(self, self.notifyPyramid))
end
function pyramidCtrl:notifyPyramid(event)
	for _, content in pairs(event.data) do
		self.pyramidData = content.data
		self:setFloor()
		local cityBuildConstDef = include("cityBuildConstDef")
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_PYRAMID_UPDATE_BTNS_AND_COPPER"
		;(nil).bid = cityBuildConstDef.fixedBuildDef.LeisureCenter
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_PANDECT_PYRAMID"
		;(nil).bid = cityBuildConstDef.fixedBuildDef.LeisureCenter
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_PYRAMID_UPDATE_COPPER"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_PYRAMID_UPDATE_LIMIT"
		SoraDSendMessage(nil)
	end
end
function pyramidCtrl:getFreeTime()
	return self.pyramidData.free
end
function pyramidCtrl:getCopperNum()
	return self.pyramidData.copper or 0
end
function pyramidCtrl:getAwardItemIDAndNum()
	return self.pyramidData.award
end
function pyramidCtrl:getScore()
	return self.pyramidData.score
end
function pyramidCtrl:getState()
	return self.pyramidData.state
end
function pyramidCtrl:getFloor()
	return self.pyramidData.floor or 1
end
function pyramidCtrl:getThrowData()
	return self.throwData
end
function pyramidCtrl:getAwardState()
	local award = self.pyramidData.award
	if nil == award or table.nums(award) <= 0 then
		return gPyramidState.NOT_BEGIN
	elseif touZiArray[award.itemid] then
		return gPyramidState.BE_CONTINUE
	elseif 6 == self.pyramidData.floor or localState.ALREADY_THROW_AGAIN == self:getState() then
		return gPyramidState.AWARD_WITH_CANNOT_THROW
	else
		return gPyramidState.AWARD_WITH_CAN_THROW
	end
end
function pyramidCtrl:getItemByFloor(floor)
	if floor < 1 or 6 < floor then
		return nil
	end
	dump(self.pyramidData, "self.pyramidData======", 10)
	return self.pyramidData["floorItem0" .. tostring(floor)]
end
function pyramidCtrl:getScoreByFloor(floor)
	if floor < 1 or 6 < floor then
		return nil
	end
	return self.pyramidData["score" .. tostring(floor)]
end
function pyramidCtrl:getGoldByFloor(floor)
	if floor < 1 or 6 < floor then
		return nil
	end
	return self.pyramidData.gold["gold" .. tostring(floor)]
end
function pyramidCtrl:getCostRefresh()
	return self.pyramidData.cost.costRefresh
end
function pyramidCtrl:getCostStart()
	return self.pyramidData.cost.costStart
end
function pyramidCtrl:getCostOneKey()
	return self.pyramidData.cost.costOneKey
end
function pyramidCtrl:getIsOneKey()
	if self.pyramidData.isOneKey == 1 then
		return true
	end
end
function pyramidCtrl:getRecord()
	return self.pyramidData.record
end
function pyramidCtrl:isNeedShowCoolSquare(itemID)
	if self.pyramidData.record then
		for k, v in pairs(self.pyramidData.record) do
			if itemID == v then
				return true
			end
		end
	end
	return false
end
function pyramidCtrl:getMoreThanLimit()
	return self.pyramidData.isMoreThanLimit
end
function pyramidCtrl:getTodayPlayInfo()
	if not self.pyramidData.todayPlayInfo then
		_UPVALUE0_ = self.pyramidData.todayPlayInfo
	end
	return self.pyramidData.todayPlayInfo
end
function pyramidCtrl:sendInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_INIT_DATA, nil)
end
function pyramidCtrl:sendRefreshItem()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_REFRESH_DATA, nil)
end
function pyramidCtrl:sendStartThrow()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_START_THROW, nil)
end
function pyramidCtrl:sendOneKeyThrow()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_ONEKEY_THROW, nil)
end
function pyramidCtrl:sendThrowAgain(receiveType)
	local serverproxy, data
	data.receiveType = receiveType
	serverproxy:Request(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_THROW_AGAIN, data)
end
function pyramidCtrl:sendReceiveReward(receiveType)
	local serverproxy, data
	data.receiveType = receiveType
	serverproxy:Request(gCmd.CMD_PYRAMID_MODULE, gCmd.REQ_PYRAMID_RECEIVE_REWARD, data)
end
return pyramidCtrl
