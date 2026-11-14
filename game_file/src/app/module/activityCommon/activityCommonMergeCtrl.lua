local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonMergeCtrl = class("activityCommonMergeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonMergeCtrl:ctor(properties)
	activityCommonMergeCtrl.super.ctor(self, properties)
	self.defaultData, activityCommonMergeCtrl.super.ctor.post, activityCommonMergeCtrl, activityCommonMergeCtrl.super.ctor.compose, activityCommonMergeCtrl, activityCommonMergeCtrl, self.activityData, activityCommonMergeCtrl = activityCommonMergeCtrl.super.ctor, self, self, self, self, activityCommonMergeCtrl.super.ctor, activityCommonMergeCtrl.super.ctor, activityCommonMergeCtrl.super.ctor
	self:resetData()
end
function activityCommonMergeCtrl:EnterGame()
	_ENV = nil
	_ENV = nil
	;(nil).module = gCmd.CMD_COLLECT_RIBBON_MODULE
	;(nil).init = gCmd.REQ_COLLECT_RIBBON_DATA
	;(nil).compose = gCmd.REQ_COLLECT_RIBBON_COMPOSE
	;(nil).exchangeList = gCmd.REQ_COLLECT_RIBBON_EXCHANGE_LIST
	;(nil).exchangeDeal = gCmd.REQ_COLLECT_RIBBON_EXCHANGE_DEAL
	;(nil).exchangePost = gCmd.REQ_COLLECT_RIBBON_EXCHANGE_POST
	;(nil).exchangeCancel = gCmd.REQ_COLLECT_RIBBON_EXCHANGE_CANCEL
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001692], (nil).notifyID = nil, gNotifyID.COLLECT_RIBBON
	_ENV = nil
	;(nil).module = gCmd.CMD_BUBBLE_CARNIVAL_MODULE
	;(nil).init = gCmd.REQ_BUBBLE_CARNIVAL_DATA
	;(nil).compose = gCmd.REQ_BUBBLE_CARNIVAL_COMPOSE
	;(nil).exchangeList = gCmd.REQ_BUBBLE_CARNIVAL_EXCHANGE_LIST
	;(nil).exchangeDeal = gCmd.REQ_BUBBLE_CARNIVAL_EXCHANGE_DEAL
	;(nil).exchangePost = gCmd.REQ_BUBBLE_CARNIVAL_EXCHANGE_POST
	;(nil).exchangeCancel = gCmd.REQ_BUBBLE_CARNIVAL_EXCHANGE_CANCEL
	_ENV, self.cmdConfig, (nil)[gActivityTimeActivityID.BUBBLE_CARNIVAL], (nil).notifyID = nil, nil, nil, gNotifyID.BUBBLE_CARNIVAL
	;(nil).init = handler(self, self.reqInitRsp)
	;(nil).compose = handler(self, self.reqComposeRsp)
	;(nil).exchangeList = handler(self, self.reqExchangeListRsp)
	;(nil).exchangeDeal = handler(self, self.reqExchangeDealRsp)
	;(nil).exchangePost = handler(self, self.reqExchangePostRsp)
	local (nil).exchangeCancel, config = handler(self, self.reqExchangeCancelRsp), nil
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		local cmd_module = cmdCfg.module
		for key, cmd_req in pairs(cmdCfg) do
			if key ~= "module" and config[key] then
				msgCtrl.register(cmd_module, cmd_req, config[key])
			end
		end
	end
	self:registerNotify()
end
function activityCommonMergeCtrl:Logout()
	activityCommonMergeCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonMergeCtrl:resetData(activityID)
	if activityID then
		self.activityData[activityID], _UPVALUE0_ = nil, nil
	else
		self.activityData, _UPVALUE0_ = self.activityData, self.activityData
	end
end
function activityCommonMergeCtrl:initClientData(activityID, data)
	if not data then
		return
	end
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).data = data
	dump(nil, "activityCommonMergeCtrl:initClientData", 10)
	local activityData = self:getActivityData(activityID)
	if not data.compose then
		_ENV = data.compose
	end
	activityData.compose = data.compose
	if not data.post then
		_ENV = data.post
	end
	activityData.post = data.post
end
function activityCommonMergeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		if cmdCfg.notifyID then
			notifyCtrl:register(cmdCfg.notifyID, handlerEx(self, self.notifyHandler, activityID))
		end
	end
end
function activityCommonMergeCtrl:notifyHandler(activityID, event)
	dump(event.data, "activityCommonMergeCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local activityData = self:getActivityData(activityID)
		if not v.compose then
			_ENV = v.compose
		end
		activityData.compose = v.compose
		if not v.post then
			_ENV = v.post
		end
		activityData.post = v.post
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
	ipairs(event.data).activityID = activityID
	ipairs(event.data).subMsg = "notify"
	SoraDSendMessage(ipairs(event.data))
end
function activityCommonMergeCtrl:sendReqInitDataMsg(activityID)
	self:reqInit(activityID)
end
function activityCommonMergeCtrl:reqInit(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.init, nil, nil)
end
function activityCommonMergeCtrl:reqInitRsp(content)
	dump(content, "activityCommonMergeCtrl:reqInitRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err ~= gErrDef.Err_None then
		return
	end
	self.activityData[activityID] = content.rspdata
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
	content.rspdata.activityID = activityID
	content.rspdata.subMsg = "init"
	SoraDSendMessage(content.rspdata)
end
function activityCommonMergeCtrl:reqCompose(activityID, bubbleType)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).bubbleType = nil, bubbleType
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.compose, nil, nil)
end
function activityCommonMergeCtrl:reqComposeRsp(content)
	dump(content, "activityCommonMergeCtrl:reqComposeRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err ~= gErrDef.Err_None then
		return
	end
	local rspdata = content.rspdata
	local activityData = self:getActivityData(activityID)
	if not rspdata.data.compose then
		_ENV = rspdata.data.compose
	end
	activityData.compose = rspdata.data.compose
	if rspdata.reward then
		SoraDMailGainItems(rspdata.reward, true)
	end
	local bubbleType = content.data.bubbleType
	_ENV = true
	;(true).msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
	;(true).activityID = activityID
	;(true).subMsg = "compose"
	;(true).bubbleType = bubbleType
	SoraDSendMessage(true)
end
function activityCommonMergeCtrl:reqExchangeList(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.exchangeList, nil, nil)
end
function activityCommonMergeCtrl:reqExchangeListRsp(content)
	dump(content, "activityCommonMergeCtrl:reqExchangeListRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err ~= gErrDef.Err_None then
		return
	end
	if not content.rspdata then
		local _ENV, exchangeList = content.rspdata, content.rspdata
	end
	_ENV = 10
	;(10).msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
	;(10).activityID = activityID
	;(10).subMsg = "exchangeList"
	;(10).list = exchangeList
	SoraDSendMessage(10)
end
function activityCommonMergeCtrl:reqExchangeDeal(activityID, kid, uid, post)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	;(nil).kid = kid
	;(nil).uid = uid
	local (nil).post, data = post, nil
	serverproxy = nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.exchangeDeal, data, nil)
end
function activityCommonMergeCtrl:reqExchangeDealRsp(content)
	dump(content, "activityCommonMergeCtrl:reqExchangeDealRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("bubble_party_text_26"))
		if not content.rspdata then
			local _ENV, rewards = content.rspdata, content.rspdata
		end
		if 0 < #rewards then
			SoraDMailGainItems(rewards, true)
		end
	else
		SoraDShowMsgTip(i18n("bubble_party_text_19"))
	end
	_ENV = i18n("bubble_party_text_19")
	i18n("bubble_party_text_19").msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
	i18n("bubble_party_text_19").activityID = activityID
	i18n("bubble_party_text_19").subMsg = "exchangeDeal"
	SoraDSendMessage(i18n("bubble_party_text_19"))
end
function activityCommonMergeCtrl:reqExchangePost(activityID, post, isNotifyAlliance, notifyUids)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	;(nil).post = post
	;(nil).isNotifyAlliance = isNotifyAlliance
	local (nil).notifyUids, data = notifyUids, nil
	serverproxy = nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.exchangePost, data, nil)
end
function activityCommonMergeCtrl:reqExchangePostRsp(content)
	dump(content, "activityCommonMergeCtrl:reqExchangePostRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("bubble_party_text_10"))
		local activityData = self:getActivityData(activityID)
		if not content.rspdata.post then
			_ENV = content.rspdata.post
		end
		activityData.post = content.rspdata.post
		_ENV = activityID
		activityID.msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
		activityID.activityID = activityID
		activityID.subMsg = "exchangePost"
		SoraDSendMessage(activityID)
	end
end
function activityCommonMergeCtrl:reqExchangeCancel(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.exchangeCancel, nil, nil)
end
function activityCommonMergeCtrl:reqExchangeCancelRsp(content)
	dump(content, "activityCommonMergeCtrl:reqExchangeCancelRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("bubble_party_text_12"))
		local activityData = self:getActivityData(activityID)
		if not content.rspdata.post then
			_ENV = content.rspdata.post
		end
		activityData.post = content.rspdata.post
		_ENV = activityID
		activityID.msg = "MESSAGE_ACTIVITY_COMMON_MERGE_UPDATE"
		activityID.activityID = activityID
		activityID.subMsg = "exchangeCancel"
		SoraDSendMessage(activityID)
	end
end
function activityCommonMergeCtrl:getActivityData(activityID)
	if not self.activityData[activityID] then
		self.activityData[activityID] = clone(self.defaultData)
	end
	return self.activityData[activityID]
end
function activityCommonMergeCtrl:getCompose(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.compose then
		_UPVALUE0_ = activityData.compose
	end
	return activityData.compose
end
function activityCommonMergeCtrl:getComposeCount(activityID, bubbleType)
	local compose = self:getCompose(activityID)
	return compose[tostring(bubbleType)] or 0
end
function activityCommonMergeCtrl:getPost(activityID)
	local activityData = self:getActivityData(activityID)
	if not activityData.post then
		_UPVALUE0_ = activityData.post
	end
	return activityData.post
end
function activityCommonMergeCtrl:getReceiveStatusAndNum(activityID)
	if not self.cmdConfig[activityID] then
		return false, 0
	end
	local activityCommonMergeRead = include("activityCommonMergeRead")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local cfg = activityCommonMergeRead.getCfg(activityID)
	for k, v in ipairs(cfg) do
		local composeNum = self:getComposeCount(activityID, v.bubbleType)
		if composeNum < v.limit then
			local isEnough = true
			for _, item in ipairs(v.formula) do
				if backpackCtrl:getItemCount(item.id) < item.count then
					isEnough = false
					break
				end
			end
			if isEnough then
				return true, -1
			end
		end
	end
	return false, 0
end
return activityCommonMergeCtrl
