local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001691_Ctrl = class("activity_9001691_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001691_Read = include("activity_9001691_Read")
function activity_9001691_Ctrl:ctor(properties)
	activity_9001691_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001691
	local constantRead = include("constantRead")
	_UPVALUE2_ = nil
	;(nil)[1] = 875601
	;(nil)[2] = 1
	self.itemID = constantRead.getConstValueArray("SURPRISE_BOX_START_COST", nil)[1]
	self:resetData()
end
function activity_9001691_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_DATA, handler(self, self.reqSurpriseBoxDataRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_BEGIN, handler(self, self.reqSurpriseBoxBeginRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_USE_ITEM, handler(self, self.reqSurpriseUseItemRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_OPEN_BOX, handler(self, self.reqSurpriseBoxOpenBoxRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_OPEN_BOX_END, handler(self, self.reqSurpriseBoxOpenBoxEndRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_QUIT, handler(self, self.reqSurpriseBoxGameQuitRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_BUY_GIFT, handler(self, self.reqSurpriseBoxBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_BATTLE_PASS_ALL_REWARD, handler(self, self.reqSurpriseBoxBattlePassAllRewardRsp))
	msgCtrl.register(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_PLAYER_RANK, handler(self, self.reqSurpriseBoxPlayerRankRsp))
	self:registerNotify()
end
function activity_9001691_Ctrl:Logout()
	activity_9001691_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001691_Ctrl:initClientData(data)
	dump(data, "activity_9001691_Ctrl:initClientData", 10)
	self:setData(data)
end
function activity_9001691_Ctrl:resetData()
	self.globalLevelMaxScore, _UPVALUE0_, self.msgData, _UPVALUE0_ = nil, nil, nil, nil
end
function activity_9001691_Ctrl:setData(data, ignoreMsg)
	self.msgData = data
	if not ignoreMsg then
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
		SoraDSendMessage(nil)
	end
end
function activity_9001691_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SURPRISE_BOX, handler(self, self.notifyHandler))
end
function activity_9001691_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001691_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "data" then
			self:setData(notifyData.data)
		elseif notifyType == "gameQuit" then
			self:setData(notifyData.data, true)
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
			_ENV, self.msgType = notifyData.data, "gameQuit"
			notifyData.data.data = notifyData.data
			notifyData.data.rewards = notifyData.rewards
			self.msgData, notifyData.data.scoreMap = notifyData.data, notifyData.scoreMap
			SoraDSendMessage(self)
		elseif notifyType == "aiOpenBox" then
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
			_ENV, self.msgType = notifyData.data, "aiOpenBox"
			notifyData.data.data = notifyData.data
			self.msgData, notifyData.data.openPlayer = notifyData.data, notifyData.openPlayer
			SoraDSendMessage(self)
		elseif notifyType == "aiUseItem" then
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
			_ENV, self.msgType = notifyData.data, "aiUseItem"
			self.msgData, notifyData.data.data = notifyData.data, notifyData.data
			SoraDSendMessage(self)
		end
	end
end
function activity_9001691_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_DATA, nil)
end
function activity_9001691_Ctrl:reqSurpriseBoxDataRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.globalLevelMaxScore = content.rspdata.globalLevelMaxScore
		self:setData(content.rspdata.data)
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxBegin(level)
	SoraDShowLoading(nil, nil, nil, true, 5)
	_ENV = true
	;(true).level = level
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_BEGIN, true)
end
function activity_9001691_Ctrl:reqSurpriseBoxBeginRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxBeginRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
		_ENV, self.msgType = content.rspdata, "begin"
		content.rspdata.data = content.rspdata
		self.msgData, content.rspdata.level = content.rspdata, content.data.level
		SoraDSendMessage(self)
	end
end
function activity_9001691_Ctrl:reqSurpriseUseItem(item)
	serverproxy = nil
	;(nil).item = item
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_USE_ITEM, nil)
end
function activity_9001691_Ctrl:reqSurpriseUseItemRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseUseItemRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
		_ENV, self.msgType = content.rspdata.data, "useItem"
		content.rspdata.data.data = content.rspdata.data
		self.msgData, content.rspdata.data.box = content.rspdata.data, content.rspdata.box
		SoraDSendMessage(self)
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxOpenBox(openPlayer)
	serverproxy = nil
	;(nil).openPlayer = openPlayer
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_OPEN_BOX, nil)
end
function activity_9001691_Ctrl:reqSurpriseBoxOpenBoxRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxOpenBoxRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local msgData = content.rspdata.data
		local isQuit = false
		if msgData.game == nil and content.rspdata.gameQuit then
			msgData.game = content.rspdata.gameQuit
			isQuit = true
		end
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
		_ENV, self.msgType = content.rspdata.data, "openBox"
		content.rspdata.data.data = content.rspdata.data
		self.msgData, content.rspdata.data.openPlayer = content.rspdata.data, content.data.openPlayer
		SoraDSendMessage(self)
		if isQuit then
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
			_ENV, self.msgType = content.rspdata.data, "gameQuit"
			content.rspdata.data.data = content.rspdata.data
			content.rspdata.data.reward = content.rspdata.rewards
			self.msgData, content.rspdata.data.scoreMap = content.rspdata.data, content.rspdata.scoreMap
			SoraDSendMessage(self)
		end
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxOpenBoxEnd()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_OPEN_BOX_END, nil)
end
function activity_9001691_Ctrl:reqSurpriseBoxOpenBoxEndRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxOpenBoxEndRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxGameQuit()
	SoraDShowLoading(nil, nil, nil, true, 5)
	_ENV = true
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_GAME_QUIT, true)
end
function activity_9001691_Ctrl:reqSurpriseBoxGameQuitRsp(content)
	SoraDCloseLoading()
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxGameQuitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data, true)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001691_UPDATE"
		_ENV, self.msgType = content.rspdata.data, "gameQuit"
		content.rspdata.data.data = content.rspdata.data
		content.rspdata.data.reward = content.rspdata.rewards
		self.msgData, content.rspdata.data.scoreMap = content.rspdata.data, content.rspdata.scoreMap
		SoraDSendMessage(self)
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxBuyGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_BUY_GIFT, nil)
end
function activity_9001691_Ctrl:reqSurpriseBoxBuyGiftRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxBattlePassAllReward()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_BATTLE_PASS_ALL_REWARD, nil)
end
function activity_9001691_Ctrl:reqSurpriseBoxBattlePassAllRewardRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxBattlePassAllRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setData(content.rspdata.data)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function activity_9001691_Ctrl:reqSurpriseBoxPlayerRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_SURPRISE_BOX_MODULE, gCmd.REQ_SURPRISE_BOX_PLAYER_RANK, nil)
end
function activity_9001691_Ctrl:reqSurpriseBoxPlayerRankRsp(content)
	dump(content, "activity_9001691_Ctrl:reqSurpriseBoxPlayerRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001691_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		gErrDef.Err_None.isPlayerRank = true
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001691_Ctrl:getReceiveStatusAndNum()
	if next(self.msgData) == nil then
		return false
	end
	local num = 0
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if 1 <= itemNum then
		num = num + 1
	end
	if self:hasAward() then
		num = num + 1
	end
	return 0 < num, -1
end
function activity_9001691_Ctrl:getClassType()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function activity_9001691_Ctrl:getAttScore()
	return self.msgData.attrScore or 0
end
function activity_9001691_Ctrl:getAttValue(name)
	if not self.msgData.attr then
		return 0, 1
	end
	local level = self.msgData.attr[name] or 1
	local levelCfg = activity_9001691_Read.getLevelCfg(level)
	if name == "power" then
		return levelCfg.power, level
	elseif name == "speed" then
		return levelCfg.speed, level
	elseif name == "lucky" then
		return levelCfg.luckyValue, level
	end
	return 0, level
end
function activity_9001691_Ctrl:getIsCanBuyDailyGift()
	return not serviceFunctions.isSameDay(self.msgData.lastBuyDailyGiftTime or 0)
end
function activity_9001691_Ctrl:getCurDay()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local zeroTime1 = serviceFunctions.getTomorrowZeroHourUTC(beginTime)
	local zeroTime2 = serviceFunctions.getTomorrowZeroHourUTC()
	local passTime = zeroTime2 - zeroTime1
	return math.floor(passTime / 86400) + 1
end
function activity_9001691_Ctrl:isActiveGold()
	return self.msgData.isAdvanceBattlePass or false
end
function activity_9001691_Ctrl:getRewardDay()
	return self.msgData.gotNormalBattlePassLv or 0
end
function activity_9001691_Ctrl:getRewardDayGold()
	return self.msgData.gotAdvanceBattlePassLv or 0
end
function activity_9001691_Ctrl:hasAward()
	local curDay = self:getCurDay()
	local rewardDay = self:getRewardDay()
	local cfg
	if curDay > rewardDay then
		for i = rewardDay + 1, curDay do
			cfg = activity_9001691_Read.getLevelReward(i)
			if cfg and #cfg.normalReward > 0 then
				return true
			end
		end
	end
	if self:isActiveGold() then
		local rewardDayGold = self:getRewardDayGold()
		for i = rewardDayGold + 1, curDay do
			cfg = activity_9001691_Read.getLevelReward(i)
			if cfg and 0 < #cfg.advanceReward then
				return true
			end
		end
	end
end
function activity_9001691_Ctrl:getCurLevel()
	return self.msgData.maxLevel + 1
end
function activity_9001691_Ctrl:getMaxLevelScore(level)
	return self.msgData.levelMaxScore and self.msgData.levelMaxScore[level] or 0
end
function activity_9001691_Ctrl:getGlobalMaxLevelScore(level)
	local scoreData = self.globalLevelMaxScore[level]
	return scoreData and scoreData.score or 0
end
function activity_9001691_Ctrl:hasGuided()
	if self.msgData.hasGuided == nil then
		return true
	end
	return self.msgData.hasGuided
end
function activity_9001691_Ctrl:getMyScore()
	if not self.msgData.levelMaxScore then
		return 0
	end
	local score = 0
	for _, v in ipairs(self.msgData.levelMaxScore) do
		score = score + v
	end
	return score
end
return activity_9001691_Ctrl
