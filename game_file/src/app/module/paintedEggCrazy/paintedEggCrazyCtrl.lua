local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local paintedEggCrazyCtrl = class("paintedEggCrazyCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local eggCarnivalRead = include("eggCarnivalRead")
local msgCtrl = include("msgCtrl")
function paintedEggCrazyCtrl:ctor(properties)
	paintedEggCrazyCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY
	self:resetData()
end
function paintedEggCrazyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_INIT, handler(self, self.reqPaintedEggCrazyShareInitRsp))
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_MERGE, handler(self, self.reqPaintedEggCrazyShareMergeRsp))
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_ACTIVITY_SHARE, handler(self, self.reqPaintedEggCrazyActivityShareRsp))
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_GIVE, handler(self, self.reqPaintedEggCrazyShareGiveRsp))
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_RECEIVE_POINT_REWARD, handler(self, self.reqPaintedEggCrazyShareReceivePointRewardRsp))
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_RANK_DATA, handler(self, self.reqPaintedEggCrazyShareRankDataRsp))
	msgCtrl.register(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_DONEE_RECORD, handler(self, self.reqPaintedEggCrazyShareDoneeRecordRsp))
	self:registerNotify()
end
function paintedEggCrazyCtrl:Logout()
	paintedEggCrazyCtrl.super.Logout(self)
	self:resetData()
end
function paintedEggCrazyCtrl:resetData()
	self.happinessPoint = 0
	self.receiveRecord, _UPVALUE0_, self.isCanShare = nil, nil, false
	self.sharePoint = 0
	self.happinessRank = 0
	self.reward, _UPVALUE0_, self.shareRank = nil, nil, 0
	self.activityItemID = 0
end
function paintedEggCrazyCtrl:initClientData(content)
	dump(content, "--paintedEggCrazyCtrl--", 20)
	if content then
		self.happinessPoint = content.happinessPoint
		self.isCanShare = content.isCanShare
		self.receiveRecord = content.receiveRecord
		self.sharePoint = content.sharePoint
		self.happinessRank = content.happinessRank
		self.shareRank = content.shareRank
		self.activityItemID = content.activityItemID
	end
end
function paintedEggCrazyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DINNER_SHARE, handler(self, self.notifyHandler))
end
function paintedEggCrazyCtrl:notifyHandler(event)
	dump(event.data, "paintedEggCrazyCtrl:notifyHandler", 10)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			if content.activityID == self.activityID then
				self:initClientData(content)
				_ENV = self
				self.msg = "MESSAGE_SERVER_MADELE_UPDATE"
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
				SoraDSendMessage(self)
			end
		end
	end
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_INIT, nil)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareMerge(data)
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_MERGE, data)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyActivityShare(data)
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_ACTIVITY_SHARE, data)
end
function paintedEggCrazyCtrl:sendReqGive(data)
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_GIVE, data)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareReceivePointReward(data)
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_RECEIVE_POINT_REWARD, data)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareRankData(data)
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_RANK_DATA, data)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DINNER_SHARE_MODULE, gCmd.REQ_PAINTED_EGG_CRAZY_SHARE_DONEE_RECORD, nil)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareInitRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyShareInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata and content.rspdata.dinnerShareData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_MADELE_UPDATE"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
		SoraDSendMessage(self)
	end
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareMergeRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyShareMergeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local infoData = content.rspdata
		local reward = infoData.reward
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_MADELE_MAKEBACK"
		;(10).reward = reward
		SoraDSendMessage(10)
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_MADELE_UPDATE"
		SoraDSendMessage(10)
		_ENV = 10
		;(10).msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
		SoraDSendMessage(10)
	end
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyActivityShareRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyActivityShareRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata and content.rspdata.dinnerShareData)
		self.reward = content.rspdata.reward
		_ENV = self
		self.msg = "MESSAGE_SERVER_MADELE_SHAREBACK"
		self.reward = self.reward
		SoraDSendMessage(self)
	elseif content.err == gErrDef.Err_DINNER_SHARE_ALREADY_SHARE then
		_ENV = gErrDef.Err_DINNER_SHARE_ALREADY_SHARE
		gErrDef.Err_DINNER_SHARE_ALREADY_SHARE.msg = "MESSAGE_SERVER_MADELE_SHAREBACK"
		gErrDef.Err_DINNER_SHARE_ALREADY_SHARE.reward = nil
		SoraDSendMessage(gErrDef.Err_DINNER_SHARE_ALREADY_SHARE)
	end
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareGiveRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyShareGiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata and content.rspdata.dinnerShareData)
		SoraDShowMsgTip(i18n("madeleine_feast_text_09"))
		_ENV = i18n("madeleine_feast_text_09")
		i18n("madeleine_feast_text_09").msg = "MESSAGE_SERVER_MADELE_UPDATE"
		SoraDSendMessage(i18n("madeleine_feast_text_09"))
		_ENV = i18n("madeleine_feast_text_09")
		i18n("madeleine_feast_text_09").msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
		SoraDSendMessage(i18n("madeleine_feast_text_09"))
	elseif content.err == gErrDef.Err_DINNER_SHARE_NOT_ENOUGH_LV then
		SoraDShowMsgTip(i18n("madeleine_feast_text_16"))
	end
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareReceivePointRewardRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyShareReceivePointRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata and content.rspdata.dinnerShareData)
		local reward = content.rspdata.reward
		_ENV = content.rspdata and content.rspdata.dinnerShareData
		;(content.rspdata and content.rspdata.dinnerShareData).msg = "MESSAGE_SERVER_MADELE_GETPOINT"
		;(content.rspdata and content.rspdata.dinnerShareData).reward = reward
		;(content.rspdata and content.rspdata.dinnerShareData).info = content.data
		SoraDSendMessage(content.rspdata and content.rspdata.dinnerShareData)
		_ENV = content.rspdata and content.rspdata.dinnerShareData
		;(content.rspdata and content.rspdata.dinnerShareData).msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
		SoraDSendMessage(content.rspdata and content.rspdata.dinnerShareData)
	end
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareRankDataRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyShareRankDataRsp(content)", 10)
	local _ENV, infoData = dump, dump
	if content.err == gErrDef.Err_None then
		infoData = content.rspdata
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_MADELE_RANKINGS_SUCCESS"
	gErrDef.Err_None.data = infoData
	SoraDSendMessage(gErrDef.Err_None)
end
function paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecordRsp(content)
	dump(content, "paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecordRsp(content)", 10)
	local infoData
	if content.rspdata and content.rspdata.doneeRecord then
		infoData = content.rspdata.doneeRecord
	end
	_ENV = "paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecordRsp(content)"
	;("paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecordRsp(content)").msg = "MESSAGE_MADELE_LOG_SUCCESS"
	;("paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecordRsp(content)").data = infoData
	SoraDSendMessage("paintedEggCrazyCtrl:reqPaintedEggCrazyShareDoneeRecordRsp(content)")
end
function paintedEggCrazyCtrl:getReceiveReward()
	if not self.receiveRecord then
		_UPVALUE0_ = self.receiveRecord
	end
	return self.receiveRecord
end
function paintedEggCrazyCtrl:getCanShare()
	return self.isCanShare
end
function paintedEggCrazyCtrl:getHappyRank()
	return self.happinessRank or 0
end
function paintedEggCrazyCtrl:getShareRank()
	return self.shareRank or 0
end
function paintedEggCrazyCtrl:getShareReward()
	if not self.reward then
		_UPVALUE0_ = self.reward
	end
	return self.reward
end
function paintedEggCrazyCtrl:getActivityItemID()
	return self.activityItemID or 0
end
function paintedEggCrazyCtrl:getMyPoints(type)
	if type == 1 then
		return self.sharePoint or 0
	elseif type == 2 then
		return self.happinessPoint or 0
	end
end
function paintedEggCrazyCtrl:isPointsGet(key)
	if self.receiveRecord and self.receiveRecord[key] then
		return true
	else
		return false
	end
end
function paintedEggCrazyCtrl:getPointeRewardNum()
	local numBack = 0
	local ret = false
	for scrollType = 1, 2 do
		local infoData = eggCarnivalRead.getRankOrPointRewardData(scrollType, false)
		local num = infoData and table.nums(infoData) or 0
		local myPoint = self:getMyPoints(scrollType)
		for i = 1, num do
			if myPoint >= infoData[i].score and not self:isPointsGet(scrollType .. "_" .. infoData[i].score) then
				numBack = numBack + 1
				ret = true
			end
		end
	end
	return ret, numBack
end
function paintedEggCrazyCtrl:getMergeNum()
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local isCanMerge = true
	local minHave = 0
	for i, v in ipairs(backpackltCtrl:getMaterialOfMergeItem(838301)) do
		local have = backpackCtrl:getItemCount(v.id)
		if have < v.count then
			isCanMerge = false
		end
		if i == 1 then
			minHave = math.ceil(have / v.count)
		else
			minHave = math.min(minHave, have / v.count)
		end
	end
	return isCanMerge, minHave
end
function paintedEggCrazyCtrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY) then
		return false, 0
	end
	local ret, numBack = self:getPointeRewardNum()
	local isCanMerge, minHave = self:getMergeNum()
	return ret or isCanMerge, numBack + minHave
end
return paintedEggCrazyCtrl
