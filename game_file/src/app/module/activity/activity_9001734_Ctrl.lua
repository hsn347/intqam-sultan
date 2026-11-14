local gamemodulec = include("GameModule")
local activity_9001734_Ctrl = class("activity_9001734_Ctrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local GREEN_GRASS_PREDICT_SYS_ID = 9999
local getRspData = function(content)
	if not content then
		_UPVALUE0_ = nil
		return nil
	end
	if not content.rspdata and (not content.data or not content.data.retdata) then
		_UPVALUE0_ = content.data.retdata
	end
	return content.data.retdata
end
local getMapValue = function(map, key)
	if not map or key == nil then
		return
	end
	return map[key] or map[tostring(key)]
end
local findPredictByTitle = function(predictlist, title)
	if not predictlist or title == nil then
		return
	end
	for _, v in pairs(predictlist) do
		if v.title == title then
			return v
		end
	end
end
local hasAnyPredictResult = function(matchData)
	if not matchData or not matchData.predictlist then
		return false
	end
	for _, predictItem in pairs(matchData.predictlist) do
		if predictItem.title and predictItem.resultid ~= nil then
			return true
		end
	end
	return false
end
local isMatchIdInReadList = function(matchId, matchIds)
	if matchId == nil or not matchIds then
		return false
	end
	for _, id in ipairs(matchIds) do
		if tonumber(id) == tonumber(matchId) then
			return true
		end
	end
	return false
end
function activity_9001734_Ctrl:ctor(properties)
	activity_9001734_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY
	self:resetData()
end
function activity_9001734_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_SIGN, handler(self, self.reqSignRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_LIST, handler(self, self.reqListRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_BET, handler(self, self.reqBetRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_CANCEL, handler(self, self.reqCancelRsp))
	msgCtrl.register(gCmd.CMD_GREEN_GRASS_PREDICT_MODULE, gCmd.REQ_GREEN_GRASS_PREDICT_ACHI, handler(self, self.reqAchiRsp))
	self:registerNotify()
end
function activity_9001734_Ctrl:Logout()
	activity_9001734_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001734_Ctrl:resetData()
	;(nil).achievementReward, _UPVALUE0_, _UPVALUE0_, self.predictListMap, _UPVALUE0_ = nil, nil, nil, nil, nil
	;(nil).championTimes = 0
	;(nil).dailyGift, _UPVALUE0_, (nil).classType = nil, nil, 1
	;(nil).dailyGiftResetTime = 0
	;(nil).getRewardNum = 0
	;(nil).isAdvanceRewardUnlock = false
	;(nil).predictDetial, _UPVALUE0_, (nil).isSeniorRewardUnlock = nil, nil, false
	;(nil).predictTimes = 0
	;(nil).round = 1
	;(nil).seniorRewardLv = 0
	;(nil).signRewardLv = 0
	;(nil).signRewardLvPay = 0
	self.initData, (nil).winTimes = nil, 0
	self.localPredictSelectMap, _UPVALUE0_, self.championSelect = nil, nil, 0
end
function activity_9001734_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GREEN_GRASS_PREDICT, handler(self, self.notifyHandler))
end
function activity_9001734_Ctrl:notifyHandler(event)
	dump(event, "activity_9001734_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyData = v.notifyData
		local notifyType = v.notifyType
		if notifyType == "refreshData" then
			self.initData = notifyData
		elseif notifyType == "buyGift" then
			local initData = notifyData.initData or notifyData
			if initData and initData.dailyGift ~= nil then
				self:initClientData(initData)
			elseif notifyData.success then
				self:recordGiftBuy(notifyData.rid or notifyData.rechargeID)
			end
			_ENV = self
			self.msg = "MESSAGE_ACTIVITY_9001734_BUYGIFT"
			SoraDSendMessage(self)
		elseif notifyType == "updateGreenGrassPredict" then
			self.predictListMap = notifyData
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001734_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001734_Ctrl:initClientData(data)
