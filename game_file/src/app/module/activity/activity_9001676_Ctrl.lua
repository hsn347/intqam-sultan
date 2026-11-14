local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001676_Ctrl = class("activity_9001676_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001676_Read = include("activity_9001676_Read")
function activity_9001676_Ctrl:ctor(properties)
	activity_9001676_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001676
	local constantRead = include("constantRead")
	self.itemID = constantRead.getConstValue("KOREAN_CHESS_TICKET", 874501)
	self:resetData()
end
function activity_9001676_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_DATA, handler(self, self.reqKoreanChessDataRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_BUY_GIFT, handler(self, self.reqKoreanChessBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_BATTLE_PASS_ALL_REWARD, handler(self, self.reqKoreanChessBattlePassAllRewardRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_SINGLE_MODE, handler(self, self.reqKoreanChessSingleRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_MATCH_MODE, handler(self, self.reqKoreanChessMatchRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_MATCH_CANCEL, handler(self, self.reqKoreanChessMatchCancelRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_MODE, handler(self, self.reqKoreanChessRoomModeRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_ENTER, handler(self, self.reqKoreanChessRoomEnterRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_READY, handler(self, self.reqKoreanChessRoomReadyRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_START, handler(self, self.reqKoreanChessRoomStartRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_KICK, handler(self, self.reqKoreanChessRoomKickRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_QUIT, handler(self, self.reqKoreanChessRoomQuitRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_SHOT, handler(self, self.reqKoreanChessShotRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_SHOT_END, handler(self, self.reqKoreanChessShotEndRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_FREE_GIFT, handler(self, self.reqKoreanChessFreeGiftRsp))
	msgCtrl.register(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_PLAYER_SPEED_RANK, handler(self, self.reqKoreanChessPlayerSpeedRankRsp))
	self:registerNotify()
end
function activity_9001676_Ctrl:Logout()
	activity_9001676_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001676_Ctrl:initClientData(data)
	dump(data, "activity_9001676_Ctrl:initClientData")
	self:setData(data)
end
function activity_9001676_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
	self.monsterPosList, _UPVALUE0_, self.bossPos = nil, nil, nil
end
function activity_9001676_Ctrl:setData(data, ignoreMsg)
	self.msgData = data
	if not ignoreMsg then
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		SoraDSendMessage(nil)
	end
end
_ENV, activity_9001676_Ctrl.registerNotify = function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end, function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).match = "MatchResult"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).roomEnter = "RoomEnter"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).roomReady = "RoomReady"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).roomStart = "RoomStart"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).roomKick = "RoomKick"
;(function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).roomQuit = "RoomQuit"
local (function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end).matchCancel, notifyMatch = "MatchCancel", function(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOREAN_CHESS, handler(self, self.notifyHandler))
end
function activity_9001676_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001676_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		if notifyType == "shot" then
			self:setData(v.notifyData.data, true)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
			self.msgType = "Shot"
			self.data = v.notifyData.shot
			self.isNotify = true
			SoraDSendMessage(self)
		elseif notifyType == "shotEnd" then
			self:setData(v.notifyData.data, true)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
			self.msgType = "ShotEnd"
			self.data = v.notifyData.result
			self.isNotify = true
			SoraDSendMessage(self)
		elseif notifyMatch[notifyType] then
			self:setData(v.notifyData.data, true)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
			self.msgType = notifyMatch[notifyType]
			self.isNotify = true
			SoraDSendMessage(self)
		elseif notifyType == "data" then
			self:setData(v.notifyData.data)
		end
	end
end
function activity_9001676_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_DATA, nil)
end
function activity_9001676_Ctrl:reqKoreanChessDataRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata)
	end
end
function activity_9001676_Ctrl:reqKoreanChessBuyGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_BUY_GIFT, nil)
end
function activity_9001676_Ctrl:reqKoreanChessBuyGiftRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001676_Ctrl:reqKoreanChessBattlePassAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_BATTLE_PASS_ALL_REWARD, nil)
end
function activity_9001676_Ctrl:reqKoreanChessBattlePassAllRewardRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessBattlePassAllRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001676_Ctrl:reqKoreanChessSingle(betCount)
	SoraDShowLoading()
	_ENV = nil
	;(nil).betCount = betCount
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_SINGLE_MODE, nil)
end
function activity_9001676_Ctrl:reqKoreanChessSingleRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessSingleRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "Single"
		self.betCount = content.data.betCount
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessMatch()
	SoraDShowLoading()
	_ENV = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_MATCH_MODE, nil)
end
function activity_9001676_Ctrl:reqKoreanChessMatchRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessMatchRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "Match"
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessMatchCancel()
	SoraDShowLoading()
	_ENV = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_MATCH_CANCEL, nil)
end
function activity_9001676_Ctrl:reqKoreanChessMatchCancelRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessMatchCancelRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "MatchCancel"
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessRoomMode(sendData)
	SoraDShowLoading()
	_ENV = nil
	;(nil).toUids = sendData.toUids
	;(nil).toAlliance = sendData.toAlliance
	;(nil).toKingdom = sendData.toKingdom
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_MODE, nil)
end
function activity_9001676_Ctrl:reqKoreanChessRoomModeRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessRoomModeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "RoomMode"
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessRoomEnter(data)
	SoraDShowLoading()
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_ENTER, data)
end
function activity_9001676_Ctrl:reqKoreanChessRoomEnterRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessRoomEnterRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		clientEventMgr.singleClickEvent(self.activityID)
	else
		SoraDShowMsgTip(i18n("krone_text_08"))
	end
end
function activity_9001676_Ctrl:reqKoreanChessRoomReady(isReady)
	SoraDShowLoading()
	_ENV = nil
	;(nil).isReady = isReady
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_READY, nil)
end
function activity_9001676_Ctrl:reqKoreanChessRoomReadyRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessRoomReadyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "RoomReady"
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessRoomStart()
	SoraDShowLoading()
	_ENV = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_START, nil)
end
function activity_9001676_Ctrl:reqKoreanChessRoomStartRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessRoomStartRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "RoomStart"
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessRoomKick()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_KICK, nil)
end
function activity_9001676_Ctrl:reqKoreanChessRoomKickRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessRoomKickRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "RoomKick"
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessRoomQuit()
	SoraDShowLoading()
	_ENV = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_ROOM_QUIT, nil)
end
function activity_9001676_Ctrl:reqKoreanChessRoomQuitRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001676_Ctrl:reqKoreanChessRoomQuitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "RoomQuit"
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessShot(shot)
	serverproxy = nil
	;(nil).shot = shot
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_SHOT, nil)
end
function activity_9001676_Ctrl:reqKoreanChessShotRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessShotRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "Shot"
		self.data = content.data.shot
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessShotEnd(result)
	serverproxy = nil
	;(nil).result = result
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_SHOT_END, nil)
end
function activity_9001676_Ctrl:reqKoreanChessShotEndRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessShotEndRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "ShotEnd"
		self.data = content.data.result
		self.reward = content.rspdata.reward
		SoraDSendMessage(self)
	end
end
function activity_9001676_Ctrl:reqKoreanChessFreeGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_FREE_GIFT, nil)
end
function activity_9001676_Ctrl:reqKoreanChessFreeGiftRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessFreeGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		self.msgType = "FreeGift"
		SoraDSendMessage(self)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001676_Ctrl:reqKoreanChessPlayerSpeedRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_KOREAN_CHESS_MODULE, gCmd.REQ_KOREAN_CHESS_PLAYER_SPEED_RANK, nil)
end
function activity_9001676_Ctrl:reqKoreanChessPlayerSpeedRankRsp(content)
	dump(content, "activity_9001676_Ctrl:reqKoreanChessPlayerSpeedRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rankList = content.rspdata.rank
		local myInfo = content.rspdata.myInfo
		_ENV = 10
		;(10).msg = "MESSAGE_ACTIVITY_9001676_UPDATE"
		;(10).msgType = "PlayerSpeedRank"
		;(10).rankList = rankList
		;(10).myInfo = myInfo
		SoraDSendMessage(10)
	end
	local proxy = uiManager:getProxy("Activity_9001676_Rank")
	if proxy then
		SoraDCloseLoading(proxy.view)
	end
end
function activity_9001676_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	num = num + (0 < itemCount and 1 or 0)
	num = num + (self:getIsGetFreeReward() and 0 or 1)
	if self:hasAward() then
		num = num + 1
	end
	return 0 < num, -1
end
function activity_9001676_Ctrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function activity_9001676_Ctrl:getCurDay()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local zeroTime1 = serviceFunctions.getTomorrowZeroHourUTC(beginTime)
	local zeroTime2 = serviceFunctions.getTomorrowZeroHourUTC()
	local passTime = zeroTime2 - zeroTime1
	return math.floor(passTime / 86400) + 1
end
function activity_9001676_Ctrl:isActiveGold()
	return self.msgData and self.msgData.isAdvanceBattlePass or false
end
function activity_9001676_Ctrl:getRewardDay()
	return self.msgData and self.msgData.gotNormalBattlePassLv or 0
end
function activity_9001676_Ctrl:getRewardDayGold()
	return self.msgData and self.msgData.gotAdvanceBattlePassLv or 0
end
function activity_9001676_Ctrl:hasAward()
	local curDay = self:getCurDay()
	local rewardDay = self:getRewardDay()
	local cfg
	if curDay > rewardDay then
		for i = rewardDay + 1, curDay do
			cfg = activity_9001676_Read.getLevelReward(i)
			if cfg and #cfg.normalReward > 0 then
				return true
			end
		end
	end
	if self:isActiveGold() then
		local rewardDayGold = self:getRewardDayGold()
		for i = rewardDayGold + 1, curDay do
			cfg = activity_9001676_Read.getLevelReward(i)
			if cfg and 0 < #cfg.advanceReward then
				return true
			end
		end
	end
	return false
end
function activity_9001676_Ctrl:getRoomData()
	return self.msgData and self.msgData.room
end
function activity_9001676_Ctrl:getGiftDayBuyNum(rid)
	if not self.msgData.recharge then
		return 0
	end
	local data = self.msgData.recharge[tostring(rid)]
	if not data or not serviceFunctions.isSameDay(data.t) then
		return 0
	end
	return data.n
end
function activity_9001676_Ctrl:getIsGetFreeReward()
	if self.msgData == nil or next(self.msgData) == nil then
		return true
	end
	local lastFreeGiftTime = self.msgData.lastFreeGiftTime
	if lastFreeGiftTime ~= nil and serviceFunctions.isSameDay(lastFreeGiftTime) then
		return true
	end
	return false
end
function activity_9001676_Ctrl:getLastRoomModeTime()
	return self.msgData and self.msgData.lastRoomModeTime or 0
end
function activity_9001676_Ctrl:getLastMatchModeTime()
	return self.msgData and self.msgData.lastMatchModeTime or 0
end
function activity_9001676_Ctrl:getIsOneShotClear()
	return self.msgData and self.msgData.oneShotClear or false
end
return activity_9001676_Ctrl
