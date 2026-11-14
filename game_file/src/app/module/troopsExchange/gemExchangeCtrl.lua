local armyChangeRead = include("armyChangeRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local gemExchangeCtrl = class("gemExchangeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function gemExchangeCtrl:ctor(properties)
	gemExchangeCtrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY
end
function gemExchangeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_INIT, handler(self, self.reqGemExchangeInitRsp))
	msgCtrl.register(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_BUY, handler(self, self.reqGemExchangeBuyRsp))
	msgCtrl.register(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_RECORD, handler(self, self.reqGemExchangeRecordRsp))
	msgCtrl.register(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_REMIND, handler(self, self.reqGemExchangeRemindRsp))
	self:registerNotify()
end
function gemExchangeCtrl:Logout()
	gemExchangeCtrl.super.Logout(self)
	self:resetData()
end
function gemExchangeCtrl:resetData()
	self.chooseIndex, _UPVALUE0_, self.historysRecord, _UPVALUE0_, self.remindArray, _UPVALUE0_, self.gemBuyRecord, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function gemExchangeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GEM_EXCHANGE, handler(self, self.notifyHandler))
end
function gemExchangeCtrl:notifyHandler(event)
	dump(event.data, "gemExchangeCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		self.gemBuyRecord = v.gemBuyRecord
		self.remindArray = v.remindArray
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		;(nil).activityID = self.activityID
		SoraDSendMessage(nil)
	end
end
function gemExchangeCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_INIT, nil)
end
function gemExchangeCtrl:reqGemExchangeBuy(costID, index)
	serverproxy = nil
	;(nil).costID = costID
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_BUY, nil)
end
function gemExchangeCtrl:reqGemExchangeRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_RECORD, nil)
end
function gemExchangeCtrl:reqGemExchangeRemind(index, remindStatus)
	serverproxy = nil
	;(nil).index = index
	;(nil).remindStatus = remindStatus
	serverproxy:Request(gCmd.CMD_GEM_EXCHANGE_MODULE, gCmd.REQ_GEM_EXCHANGE_REMIND, nil)
end
function gemExchangeCtrl:reqGemExchangeInitRsp(content)
	dump(content, "gemExchangeCtrl:reqGemExchangeInitRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.gemBuyRecord = content.rspdata.initData.gemBuyRecord
		self.remindArray = content.rspdata.initData.remindArray
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		gErrDef.Err_None.activityID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_TROOPS_EXCHANGE_REFRESH"
		gErrDef.Err_None.activityID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function gemExchangeCtrl:reqGemExchangeBuyRsp(content)
	dump(content, "gemExchangeCtrl:reqGemExchangeBuyRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		self.gemBuyRecord = content.rspdata.initData.gemBuyRecord
		SoraDPlaySound("uicontrol", 4)
		SoraDShowMsgTip(i18n("tips_exchange_success"))
		_ENV = i18n("tips_exchange_success")
		i18n("tips_exchange_success").msg = "MESSAGE_TROOPS_EXCHANGE_REFRESH"
		i18n("tips_exchange_success").activityID = self.activityID
		SoraDSendMessage(i18n("tips_exchange_success"))
		_ENV = i18n("tips_exchange_success")
		i18n("tips_exchange_success").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		i18n("tips_exchange_success").eventID = self.activityID
		SoraDSendMessage(i18n("tips_exchange_success"))
	end
end
function gemExchangeCtrl:reqGemExchangeRecordRsp(content)
	dump(content, "gemExchangeCtrl:reqGemExchangeRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.historysRecord = content.rspdata.record
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_TROOPS_EXCHANGE_HISTORY"
	SoraDSendMessage(gErrDef.Err_None)
end
function gemExchangeCtrl:reqGemExchangeRemindRsp(content)
	dump(content, "gemExchangeCtrl:reqGemExchangeRemindRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.remindArray = content.rspdata.initData.remindArray
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function gemExchangeCtrl:getHistoryList()
	if not self.historysRecord then
		_UPVALUE0_ = self.historysRecord
	end
	return self.historysRecord
end
function gemExchangeCtrl:setChooseIndex(index_, index)
	self.chooseIndex[index_] = index
end
function gemExchangeCtrl:getChooseIndex(index)
	return self.chooseIndex[index]
end
function gemExchangeCtrl:reSetChooseIndex()
	self.chooseIndex, _UPVALUE0_ = nil, nil
end
function gemExchangeCtrl:getExchangeNum(index)
	return self.gemBuyRecord and self.gemBuyRecord[tostring(index)] or 0
end
function gemExchangeCtrl:getRemindStatus(index)
	return self.remindArray and self.remindArray[tostring(index)] or 1
end
function gemExchangeCtrl:getReceiveStatusAndNum(type)
	local num = 0
	if type and type ~= self.activityID then
		num = self:getRedNumByType(type)
	else
		for listType1, v in ipairs(armyChangeRead.getStoneExchangeList()) do
			for listType2, _ in ipairs(v) do
				num = num + self:getRedNumByType(listType1, listType2)
			end
		end
	end
	return 0 < num, num
end
function gemExchangeCtrl:getRedNumByType(type, type2)
	local num = 0
	if type2 then
		for _, index in ipairs(armyChangeRead.getStoneExchangeList(type, type2)) do
			num = num + self:getRedNumByIndex(index)
		end
	else
		for _type2, _ in ipairs(armyChangeRead.getStoneExchangeList(type)) do
			for _, index in ipairs(armyChangeRead.getStoneExchangeList(type, _type2)) do
				num = num + self:getRedNumByIndex(index)
			end
		end
	end
	return num
end
function gemExchangeCtrl:getRedNumByIndex(index)
	local info = armyChangeRead.getStoneExchangeInfo(index)
	local remindStatus = self:getRemindStatus(index)
	local exchangeNum = self:getExchangeNum(index)
	if remindStatus == 1 and exchangeNum < info.rate then
		local ownCont = include("publicUtil").getCount(info.cost1[1].id)
		local exchangeTwo = false
		for _, v in ipairs(info.cost2) do
			local ownCont2 = include("publicUtil").getCount(v.id)
			if ownCont2 >= v.count then
				exchangeTwo = true
				break
			end
		end
		if ownCont >= info.cost1[1].count and exchangeTwo then
			return 1
		end
	end
	return 0
end
function gemExchangeCtrl:getStoneExchangeList(type, type2)
	local indexList = armyChangeRead.getStoneExchangeList(type, type2)
	table.sort(indexList, function(l, r)
		local infoL = armyChangeRead.getStoneExchangeInfo(l)
		local infoR = armyChangeRead.getStoneExchangeInfo(r)
		local exchangeNumL = self:getExchangeNum(l)
		local exchangeNumR = self:getExchangeNum(r)
		local leftCountL = infoL.rate - exchangeNumL
		local leftCountR = infoR.rate - exchangeNumR
		if leftCountL <= 0 and leftCountR <= 0 or 0 < leftCountL and 0 < leftCountR then
			return l < r
		elseif leftCountR <= 0 then
			return true
		else
			return false
		end
	end)
	return indexList
end
return gemExchangeCtrl
