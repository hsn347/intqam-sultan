local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local hegemonTitleBuff = include("hegemonTitleBuff")
local hegemonCtrl = class("hegemonCtrl", gamemodulec)
local ACTIVITY_STATE = _G.ACTIVITY_STATE
local _ENV, REQ = gamemodulec, gamemodulec
local _ENV, RSP
function hegemonCtrl:isHegemonTeamOpen()
	if self.joinActivityID then
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(self.joinActivityID)
		if param then
			local curState = param.curState
			if curState == ACTIVITY_STATE.ACTIVE or curState == ACTIVITY_STATE.PREPARE then
				return true
			end
		end
	end
	return false
end
function hegemonCtrl:isKingdomJoinActivity()
	local _, timeTbInfo = self:getHegemonActivityStatus()
	if timeTbInfo then
		local curState = timeTbInfo.curState
		return curState == ACTIVITY_STATE.ACTIVE
	end
	return false
end
function hegemonCtrl:isHegemonActivityOpen()
	local _, timeTbInfo = self:getHegemonActivityStatus()
	if timeTbInfo then
		local curState = timeTbInfo.curState
		return curState == ACTIVITY_STATE.ACTIVE
	end
	return false
end
function hegemonCtrl:isHegemonKingdomActivityOpen()
	local hegemonRead = include("hegemonRead")
	local activityID = hegemonRead.getActivityIdByBuildID(self.joinBid)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(activityID)
	if param then
		local curState = param.curState
		return curState == ACTIVITY_STATE.ACTIVE
	end
end
function hegemonCtrl:isHegemonActivityOpenOrSetTitle()
	local _, timeTbInfo = self:getHegemonActivityStatus()
	if timeTbInfo then
		local curState = timeTbInfo.curState
		if curState == ACTIVITY_STATE.ACTIVE or curState == ACTIVITY_STATE.SETTLE then
			return true
		end
	end
	return false
end
function hegemonCtrl:isPlayerMoveToHegemonWar(targetKid)
	if self:isHegemonActivityOpen() and not worldMapDefine.isInLegendLord() and targetKid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and targetKid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return true
	end
	return false
end
function hegemonCtrl:isPlayerReturnSourceKingdom(targetKid)
	if self:isHegemonActivityOpenOrSetTitle() then
		local kid = gametop.playertop_:getKingdomID()
		if targetKid == kid then
			return true
		end
	end
	return false
end
function hegemonCtrl:getHegemonActivityStatus()
	local hegemonState = gActivityState.CLOSE
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local isClose = true
	local isAllPrepare = true
	local isAllSettle = true
	local isAnySettle = false
	local isAnyActive = false
	print("serviceFunctions.systemTime() =", serviceFunctions.systemTime())
	for i = gActivityTimeActivityID.LEGEND_HEGEMON_1, gActivityTimeActivityID.LEGEND_HEGEMON_6 do
		local param = activityShowCtrl:getParamByID(i)
		if activityShowCtrl:getStateByID(i) ~= gActivityState.CLOSE then
			isClose = false
		end
		if param and param.curState ~= ACTIVITY_STATE.PREPARE then
			isAllPrepare = false
		end
		if param and param.curState ~= ACTIVITY_STATE.SETTLE then
			isAllSettle = false
		end
		if param and param.curState == ACTIVITY_STATE.SETTLE then
			isAnySettle = true
		end
		if param and (param.curState == ACTIVITY_STATE.ACTIVE or param.curState == ACTIVITY_STATE.PREPARE or param.curState == ACTIVITY_STATE.SETTLE) then
			isAnyActive = true
		end
	end
	if isClose == true then
		print("活动处于关闭状态----")
		return hegemonState
	end
	local min_preparetime = 0
	local min_preparetimeId = 0
	local min_activetime = 0
	local min_activetimeId = 0
	local max_settletime = 0
	local max_settletimeId = 0
	local max_finishtime = 0
	local max_finishtimeId = 0
	local _ENV, timeTbInfo = serviceFunctions.systemTime()
	local flag = 0
	local isEndBattleEarly = true
	for i = gActivityTimeActivityID.LEGEND_HEGEMON_1, gActivityTimeActivityID.LEGEND_HEGEMON_6 do
		if activityShowCtrl:getStateByID(i) ~= gActivityState.CLOSE then
			print("传奇霸主：getStateByID(i)", i, " = ", activityShowCtrl:getStateByID(i))
			local param = activityShowCtrl:getParamByID(i)
			if param.curState ~= ACTIVITY_STATE.SETTLE then
				isEndBattleEarly = false
			end
			if flag == 0 then
				min_preparetime = param.timeConfig.prepareTime
				min_activetime = param.timeConfig.activeTime
				max_settletime = param.timeConfig.settleTime
				max_finishtime = param.timeConfig.finishTime
				min_preparetimeId = i
				min_activetimeId = i
				max_settletimeId = i
				max_finishtimeId = i
				flag = 1
				dump(param, "param", 10)
			else
				if min_preparetime > param.timeConfig.prepareTime then
					min_preparetime = param.timeConfig.prepareTime
					min_preparetimeId = i
				end
				if min_activetime > param.timeConfig.activeTime then
					min_activetime = param.timeConfig.activeTime
					min_activetimeId = i
				end
				if max_settletime < param.timeConfig.settleTime then
					max_settletime = param.timeConfig.settleTime
					max_settletimeId = i
				end
				if max_finishtime < param.timeConfig.finishTime then
					max_finishtime = param.timeConfig.finishTime
					max_finishtimeId = i
				end
			end
		end
	end
	timeTbInfo.min_preparetime = min_preparetime
	timeTbInfo.min_preparetimeId = min_preparetimeId
	timeTbInfo.min_activetime = min_activetime
	timeTbInfo.min_activetimeId = min_activetimeId
	timeTbInfo.max_settletime = max_settletime
	timeTbInfo.max_settletimeId = max_settletimeId
	timeTbInfo.max_finishtime = max_finishtime
	timeTbInfo.max_finishtimeId = max_finishtimeId
	timeTbInfo.curState = ACTIVITY_STATE.NONE
	local curSystemTime = serviceFunctions.systemTime()
	print("检测传奇霸主状态------------------------", ", curSystemTime = ", curSystemTime)
	if isAllPrepare and min_activetime > curSystemTime then
		print("传奇霸主处于准备状态--------------")
		if min_preparetime > curSystemTime then
			print("检测到有误差------", curSystemTime, ",", min_preparetime)
		end
		local curId = min_preparetimeId
		local leftTime = min_activetime - curSystemTime
		timeTbInfo.leftTime = leftTime
		clientEventMgr.addEventTimer(gActivityCenterUIEnum.LEGEND_HEGEMON, leftTime)
		hegemonState = gActivityState.PREPARE
		timeTbInfo.curState = ACTIVITY_STATE.PREPARE
		return hegemonState, timeTbInfo
	elseif isAnyActive and max_settletime > curSystemTime then
		print("传奇霸主处于争夺状态--------------")
		local leftTime = max_settletime - curSystemTime
		timeTbInfo.leftTime = leftTime
		clientEventMgr.addEventTimer(gActivityCenterUIEnum.LEGEND_HEGEMON, leftTime)
		hegemonState = gActivityState.OPEN
		if not isEndBattleEarly then
			timeTbInfo.curState = ACTIVITY_STATE.ACTIVE
		else
			local leftTime = max_finishtime - curSystemTime
			timeTbInfo.leftTime = leftTime
			timeTbInfo.curState = ACTIVITY_STATE.SETTLE
		end
		return hegemonState, timeTbInfo
	elseif isAllSettle and max_finishtime > curSystemTime then
		print("传奇霸主处于结算状态--------------")
		local leftTime = max_finishtime - curSystemTime
		timeTbInfo.leftTime = leftTime
		clientEventMgr.addEventTimer(gActivityCenterUIEnum.LEGEND_HEGEMON, leftTime)
		hegemonState = gActivityState.OPEN
		timeTbInfo.curState = ACTIVITY_STATE.SETTLE
		return hegemonState, timeTbInfo
	else
		print("传奇霸主活动状态出错")
		print("curTime = ", curSystemTime, ",min_activetime = ", min_activetime, ", min_preparetime = ", min_preparetime, ", max_settletime = ", max_settletime, ", max_finishtime = ", max_finishtime)
		return hegemonState
	end
end
function hegemonCtrl:reqHegemonInfo(bid)
	serverproxy = nil
	local (nil).bid, data = bid, nil
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_GET_HEGEMON_INFO, data)
end
function hegemonCtrl:reqLegendRewardInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_REAL_REWARD_INFO, data)
end
function hegemonCtrl:getLegendKingInfo()
	if not self.legendKingInfo then
		self:reqLegendKingInfo()
	end
	return self.legendKingInfo
end
function hegemonCtrl:reqLordTitleList(bid)
	print("hegemoNCtrl:reqLordTitleList", bid)
	_ENV = print
	local print.bid, data = bid, print
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_LORD_TITLE_LIST, data)
end
function hegemonCtrl:getLordTitleList(bid)
	return self.lordTitleList[bid]
end
function hegemonCtrl:reqTitleInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_TITLE_INFO, data)
end
function hegemonCtrl:reqLordGiftList(bid)
	serverproxy = nil
	local (nil).bid, data = bid, nil
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_GIFT_LIST, data)
end
function hegemonCtrl:getLordGiftList(bid)
	return self.giftList[bid]
end
function hegemonCtrl:getHegemonInfoByBid(bid)
	if not self.buildInfoList[bid] then
		_UPVALUE0_ = self.buildInfoList[bid]
	end
	return self.buildInfoList[bid]
end
function hegemonCtrl:reqAwardGift(uid, giftID, nickname)
	_ENV = nil
	;(nil).uid = uid
	;(nil).nickname = nickname
	local (nil).giftID, data = giftID, nil
	dump(data, "赏赐礼包给玩家-----")
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_AWARD_GIFT, data)
end
function hegemonCtrl:reqGiftLog(bid)
	serverproxy = nil
	local (nil).bid, data = bid, nil
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_GIFT_LOG, data)
end
function hegemonCtrl:getGiftLog(bid)
	return self.giftLog[bid]
end
function hegemonCtrl:reqAppointLordTitle(uid, titleID, kid)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).titleID = titleID
	local (nil).kid, data = kid, nil
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_APPOINT_HEGEMON_TITLE, data)
end
function hegemonCtrl:reqCancelLordTitle(titleID, uid)
	serverproxy = nil
	;(nil).titleID = titleID
	local (nil).uid, data = uid, nil
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_CANCEL_HEGEMON_TITLE, data)
end
function hegemonCtrl:showErrorCode(err)
	SoraDShowMsgTip("error! code = " .. err)
end
function hegemonCtrl:reqBuildInfoList()
	print("发起建筑列表请求-----")
	local _ENV, data = print, print
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_BUILD_INFO_LIST, data)
end
function hegemonCtrl:reqBuildKingdomList()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_BUILD_KINGDM_LIST, data)
end
function hegemonCtrl:getLordTitleID()
	if self.titleInfo and self.titleInfo.lordTitleID ~= nil then
		return self.titleInfo.lordTitleID
	end
end
function hegemonCtrl:getLordRank()
	if self.titleInfo and self.titleInfo.rank ~= nil then
		return self.titleInfo.rank
	end
end
function hegemonCtrl:getIsSelfHegemon()
	local lordTitleID = self:getLordTitleID()
	if lordTitleID and lordTitleID == gHegemonOfficialId.HEGEMON then
		return true
	end
	return false
end
function hegemonCtrl:getBuff(effectType)
	if not self.titleInfo then
		return
	end
	local lordTitleBuffValue
	if self.titleInfo.lordTitleID then
		lordTitleBuffValue = hegemonTitleBuff:getTitleBuff(self.titleInfo.lordTitleID, effectType)
	end
	return lordTitleBuffValue
end
function hegemonCtrl:getJoinBid()
	return self.joinBid
end
function hegemonCtrl:getJoinActivity()
	return self.joinActivityID
end
function hegemonCtrl:getBuildKingdomList(bid)
	return self.buildKingdomList[bid]
end
function hegemonCtrl:setJoinActivity(activityID)
	print("设置了参与过的活动ID", activityID)
	self.joinActivityID = activityID
	local hegemonRead = include("hegemonRead")
	local bid = hegemonRead.getBuildIdByActivityID(self.joinActivityID)
	self.joinBid = bid
end
function hegemonCtrl:ctor(properties)
	hegemonCtrl.super.ctor(self, properties)
	self:init()
end
function hegemonCtrl:EnterGame()
	hegemonCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_LORD_TITLE_LIST, handler(self, RSP.reqLordTitleListRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_TITLE_INFO, handler(self, RSP.reqTitleInfoRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_GIFT_LIST, handler(self, RSP.reqLordGiftListRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_AWARD_GIFT, handler(self, RSP.reqAwardGiftRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_APPOINT_HEGEMON_TITLE, handler(self, RSP.reqAppointLordTitleRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_CANCEL_HEGEMON_TITLE, handler(self, RSP.reqCancelLordTitleRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_GIFT_LOG, handler(self, RSP.reqGiftLogRsp))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_GET_HEGEMON_INFO, handler(self, RSP.reqHegemonInfoRSP))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_REAL_REWARD_INFO, handler(self, RSP.reqLegendRewardInfoRSP))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_BUILD_INFO_LIST, handler(self, RSP.reqBuildInfoListRSP))
	msgCtrl.register(gCmd.CMD_LHW_MODULE, gCmd.REQ_LHW_BUILD_KINGDM_LIST, handler(self, RSP.reqBuildKingdomListRSP))
	self:resetData()
	self:reqTitleInfo()
	self:reqLegendRewardInfo()
	self:registerNotify()
end
function hegemonCtrl:Logout()
	hegemonCtrl.super.Logout(self)
	self:resetData()
end
function hegemonCtrl:resetData()
	self.buildInfoList, _UPVALUE0_, self.buildKingdomList, _UPVALUE0_, self.lordTitleList, _UPVALUE0_, self.kingdomTitleList, _UPVALUE0_, self.titleInfo, _UPVALUE0_, self.legendKingInfo, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.giftLog, _UPVALUE0_, self.giftList, _UPVALUE0_, self.joinBid = nil, nil, nil, nil, 0
end
function hegemonCtrl:init()
	self:resetData()
end
function hegemonCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LEGEND_HEGEMON, handler(self, RSP.noitfyDataRsp))
end
function hegemonCtrl:initClientData(retdata)
	dump(retdata, "hegemonCtrl:initClientData", 10)
end
function RSP:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "hegemonCtrl RSP.noitfyDataRsp(content)@@@", 10)
	for i, notifyMsg in ipairs(notifydata) do
		local notifyType = notifyMsg.notifyType
		local notifyData = notifyMsg.notifyData
		local notifyFunc = "onNotify_" .. notifyType
		if not RSP[notifyFunc] then
			print("hegemonCtrl:" .. notifyFunc .. " not implemented!")
		else
			RSP[notifyFunc](self, notifyData)
		end
	end
end
function RSP:onNotify_refreshReward(notifyData)
	local rewardInfo = notifyData.rewardInfo
	if rewardInfo then
		local hegemonRead = include("hegemonRead")
		hegemonRead.updateLegendReward(rewardInfo)
	end
end
function RSP:onNotify_appointedHT(notifyData)
	local titleID = notifyData.titleID
	self.titleInfo.lordTitleID = titleID
	dump(self.titleInfo, "self.titleInfo", 5)
	hegemonTitleBuff:notifyBuffChange(titleID)
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setHegemonLorldTitle(self.joinBid, titleID)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_AP_LT"
	SoraDSendMessage(lordCtrl)
	_ENV = self.joinBid
	self.joinBid.name = gEventName.event_buff_update
	self:dispatchEvent(self.joinBid)
end
function RSP:onNotify_canceledHT(notifyData)
	local lordTitleID = self.titleInfo.lordTitleID
	print("lordTitleID = ", lordTitleID)
	self.titleInfo.lordTitleID = nil
	dump(self.titleInfo, "self.titleInfo", 5)
	hegemonTitleBuff:notifyBuffChange(lordTitleID)
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setHegemonLorldTitle(nil)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_CL_LT"
	SoraDSendMessage(lordCtrl)
	_ENV = nil
	;(nil).name = gEventName.event_buff_update
	self:dispatchEvent(nil)
end
function RSP:onNotify_clean(notifyData)
	local lordTitleID = self.titleInfo.lordTitleID
	self.titleInfo, hegemonTitleBuff = nil, nil
	if lordTitleID then
		hegemonTitleBuff:notifyBuffChange(lordTitleID)
	end
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setHegemonLorldTitle(self.joinBid, nil)
	hegemonTitleBuff = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_CLEAN"
	SoraDSendMessage(lordCtrl)
	hegemonTitleBuff = lordCtrl
	lordCtrl.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
	SoraDSendMessage(lordCtrl)
end
function RSP:onNotify_setHegemonRank(notifyData)
	local rank = notifyData.rank
	self.titleInfo.rank = rank
end
function RSP:reqLordTitleListRsp(content)
	dump(content, "hegemonCtrl.reqLordTitleListRsp", 5)
	if content.err == gErrDef.Err_None then
		local bid = content.rspdata.bid
		local lordTitleList = content.rspdata.lordTitleList
		self.lordTitleList[bid], _ENV = 5, 5
		for i, v in ipairs(lordTitleList) do
			self.lordTitleList[bid][v.titleID] = v
		end
		_ENV = ipairs(lordTitleList)
		ipairs(lordTitleList).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_TITLE_LIST_BACK"
		SoraDSendMessage(ipairs(lordTitleList))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqTitleInfoRsp(content)
	dump(content, "hegemonCtrl.reqTitleInfoRsp", 5)
	if content.err == gErrDef.Err_None and content.rspdata then
		self.titleInfo = content.rspdata.titleInfo
		if self.titleInfo and self.titleInfo.bid then
			self.joinBid = tonumber(self.titleInfo.bid)
		end
		_ENV = self.titleInfo.bid
		self.titleInfo.bid.msg = "MESSAGE_SERVER_HEGEMON_LORD_TITLE_INFO_BACK"
		SoraDSendMessage(self.titleInfo.bid)
		_ENV = self.titleInfo.bid
		self.titleInfo.bid.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
		SoraDSendMessage(self.titleInfo.bid)
		_ENV = "hegemonCtrl.reqTitleInfoRsp"
		;("hegemonCtrl.reqTitleInfoRsp").name = gEventName.event_buff_update
		self:dispatchEvent("hegemonCtrl.reqTitleInfoRsp")
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqLordGiftListRsp(content)
	dump(content, "hegemonCtrl.reqLordGiftListRsp", 5)
	if content.err == gErrDef.Err_None then
		local bid = content.rspdata.bid
		if not self.giftList then
			self.giftList, _ENV = self.giftList, self.giftList
		end
		self.giftList[bid] = content.rspdata.giftList
		if self.giftList[bid] == nil or next(self.giftList[bid]) == nil then
			local hegemonRead = include("hegemonRead")
			local packageList = hegemonRead.getPackageList(bid)
			self.giftList[bid], _ENV = nil, nil
			for i, v in ipairs(packageList) do
				_ENV = nil
				;(nil).giftID = v.rewardsType
				;(nil).total = v.num
				;(nil).uidList, _ENV, (nil).remainCount = v.num, v.num, v.num
				table.insert(self.giftList[bid], nil)
			end
		end
		_ENV = hegemonRead.getPackageList(bid)
		hegemonRead.getPackageList(bid).msg = "MESSAGE_SERVER_HEGEMON_LORD_GIFT_LIST_BACK"
		SoraDSendMessage((hegemonRead.getPackageList(bid)))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqAwardGiftRsp(content)
	dump(content, "hegemonCtrl.reqAwardGiftRsp", 5)
	if content.err == gErrDef.Err_None then
		local giftID = content.rspdata.giftID
		local uid = content.rspdata.uid
		local bid = content.rspdata.bid
		for i, v in pairs(self.giftList[bid]) do
			if v.giftID == giftID then
				v.remainCount = v.remainCount - 1
				if not v.uidList then
					v.uidList, _ENV = v.uidList, v.uidList
				end
				table.insert(v.uidList, uid)
				break
			end
		end
		_ENV = pairs(self.giftList[bid])
		pairs(self.giftList[bid]).msg = "MESSAGE_SERVER_HEGEMON_LORD_AWARD_GIFT_BACK"
		pairs(self.giftList[bid]).awardItem = awardItem
		SoraDSendMessage(pairs(self.giftList[bid]))
	elseif content.err == gErrDef.Err_LH_ALREADY_AWARD_GIFT then
		local name = content.data.nickName
		if content.data.allianceAbbr then
			_ENV = SoraDSendMessage
			SoraDSendMessage.abbr = content.data.allianceAbbr
			SoraDSendMessage.name = content.data.nickName
			name = i18n("common_text_186", SoraDSendMessage)
		end
		_ENV = content.data.nickName
		content.data.nickName.name = name
		SoraDShowMsgTip(i18n("common_text_1191", content.data.nickName))
	end
end
function RSP:reqGiftLogRsp(content)
	dump(content, "hegemonCtrl.reqGiftLogRsp", 5)
	if content.err == gErrDef.Err_None then
		local bid = content.rspdata.bid
		if not self.giftLog then
			self.giftLog, _ENV = self.giftLog, self.giftLog
		end
		self.giftLog[bid] = content.rspdata.log
		if not self.giftLog[bid] then
			self.giftLog[bid], _ENV = content.rspdata.log, content.rspdata.log
		end
		table.sort(self.giftLog[bid], function(v1, v2)
			return v2.time < v1.time
		end)
		_ENV = self.giftLog[bid]
		self.giftLog[bid].msg = "MESSAGE_SERVER_HEGEMON_LORD_GIFT_LOG_BACK"
		SoraDSendMessage(self.giftLog[bid])
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqAppointLordTitleRsp(content)
	dump(content, "hegemonCtrl.reqAppointLordTitleRsp", 5)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1431"))
		local lordTitleInfo = content.rspdata
		local bid = lordTitleInfo.bid
		if not self.lordTitleList[bid] then
			self.lordTitleList[bid], _ENV = i18n("common_text_1431")
		end
		self.lordTitleList[bid][lordTitleInfo.titleID] = lordTitleInfo
		_ENV = lordTitleInfo.titleID
		lordTitleInfo.titleID.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_APPOINT_LT_BACK"
		lordTitleInfo.titleID.lordTitle = titleID
		lordTitleInfo.titleID.bid = bid
		SoraDSendMessage(lordTitleInfo.titleID)
	else
	end
end
function RSP:reqCancelLordTitleRsp(content)
	dump(content, "hegemonCtrl.reqCancelLordTitleRsp", 5)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1444"))
		local lordTitle = content.rspdata.titleID
		local uid = content.data.uid
		local bid = content.rspdata.bid
		if not self.lordTitleList[bid] then
			self.lordTitleList[bid], _ENV = i18n("common_text_1444")
		end
		self.lordTitleList[bid][lordTitle] = nil
		_ENV = i18n("common_text_1444")
		i18n("common_text_1444").msg = "MESSAGE_SERVER_LEGENDLORD_LORD_CANCEL_LT_BACK"
		i18n("common_text_1444").lordTitle = lordTitle
		i18n("common_text_1444").bid = bid
		SoraDSendMessage(i18n("common_text_1444"))
		_ENV = i18n("common_text_1444")
		i18n("common_text_1444").msg = "MESSAGE_LORDINFO_DISMISS_TITLE_BACK"
		i18n("common_text_1444").uid = uid
		i18n("common_text_1444").bid = bid
		i18n("common_text_1444").officialType = gShowOfficialType.HEGEMON
		SoraDSendMessage(i18n("common_text_1444"))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqHegemonInfoRSP(content)
	dump(content.rspdata, "hegemonCtrl:reqHegemonInfoRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local hegemonInfo = content.rspdata
		if hegemonInfo and hegemonInfo.bid then
			self.buildInfoList[tonumber(hegemonInfo.bid)], _ENV = hegemonInfo.bid, hegemonInfo.bid
		end
		if next(hegemonInfo) and hegemonInfo.kingdomInfo then
			local bid = hegemonInfo.bid
			local kid = hegemonInfo.kingdomInfo.kid
			local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
			local found, kingdomInfo = kingdomCtrl:isFoundKingdomID(kid)
			if found then
				hegemonInfo.kingdomInfo.kname = kingdomInfo.kname
				hegemonInfo.kingdomInfo.kflag = kingdomInfo.flagid
			end
			self.buildInfoList[bid] = hegemonInfo
		end
		_ENV = hegemonInfo.kingdomInfo.kid
		hegemonInfo.kingdomInfo.kid.msg = "MESSAGE_SERVER_HEGEMON_KING_DATA_BACK"
		SoraDSendMessage(hegemonInfo.kingdomInfo.kid)
	else
		print("hegemonCtrl:reqHegemonInfoRSP err code = ", tostring(err))
		SoraDShowMsgTip("error! code = " .. tostring(err))
	end
end
function RSP:reqLegendRewardInfoRSP(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.rspdata then
			local rewardInfo = content.rspdata.reward
			if rewardInfo then
				local hegemonRead = include("hegemonRead")
				hegemonRead.updateLegendReward(rewardInfo)
			end
		end
	else
		print("hegemonCtrl:reqLegendRewardInfoRSP err code = ", tostring(err))
	end
end
function RSP:reqBuildInfoListRSP(content)
	dump(content.rspdata, "hegemonCtrl:reqBuildInfoListRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.rspdata then
			self.joinBid = content.rspdata.joinBid
			if content.rspdata.buildList then
				for k, v in pairs(content.rspdata.buildList) do
					local hegemonInfo = v
					if hegemonInfo and hegemonInfo.bid then
						self.buildInfoList[tonumber(hegemonInfo.bid)], _ENV = hegemonInfo.bid, hegemonInfo.bid
					end
					if next(hegemonInfo) and hegemonInfo.kingdomInfo then
						local bid = tonumber(k)
						local kid = hegemonInfo.kingdomInfo.kid
						local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
						local found, kingdomInfo = kingdomCtrl:isFoundKingdomID(kid)
						if found then
							hegemoInfo.kingdomInfo.kname = kingdomInfo.kname
							hegemonInfo.kingdomInfo.kflag = kingdomInfo.flagid
						end
						self.buildInfoList[bid] = hegemonInfo
					end
				end
			end
		end
		_ENV = pairs(content.rspdata.buildList)
		pairs(content.rspdata.buildList).msg = "MESSAGE_SERVER_HEGEMON_BUILD_INFO_LIST_BACK"
		SoraDSendMessage(pairs(content.rspdata.buildList))
	else
		print("hegemonCtrl:reqLegendRewardInfoRSP err code = ", tostring(err))
	end
end
function RSP:reqBuildKingdomListRSP(content)
	dump(content.rspdata, "hegemonCtrl:reqBuildKingdomListRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.rspdata then
			local buildKingdomList = content.rspdata
			for k, v in pairs(buildKingdomList) do
				self.buildKingdomList[tonumber(k)] = v
			end
		end
		_ENV = pairs(buildKingdomList)
		pairs(buildKingdomList).msg = "MESSAGE_SERVER_HEGEMON_BUILD_KINGDOM_LIST_BACK"
		SoraDSendMessage(pairs(buildKingdomList))
	else
		print("hegemonCtrl:reqLegendRewardInfoRSP err code = ", tostring(err))
	end
end
return hegemonCtrl
