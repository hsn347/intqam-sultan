local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local legendTitleBuff = include("legendTitleBuff")
local kingStarCtrl = class("kingStarCtrl", gamemodulec)
local _ENV, REQ = "kingStarCtrl", "kingStarCtrl"
local _ENV, RSP = gamemodulec, gamemodulec
function kingStarCtrl:reqLegendKingInfo(activityId)
	local _ENV, data
	if activityId and type(activityId) == "table" then
		_ENV = type(activityId)
		data, type(activityId).activityIdList = type(activityId), activityId
	else
		_ENV = type(activityId)
		data, type(activityId).activityId = type(activityId), activityId
	end
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GET_KING_INFO, data)
end
function kingStarCtrl:reqLegendRewardInfo(activityId)
	local _ENV, data
	if activityId and type(activityId) == "table" then
		_ENV = type(activityId)
		data, type(activityId).activityIdList = type(activityId), activityId
	else
		_ENV = type(activityId)
		data, type(activityId).activityId = type(activityId), activityId
	end
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_REAL_REWARD_INFO, data)
end
function kingStarCtrl:getLegendKingInfo(activityID)
	activityID = activityID or gActivityTimeActivityID.KING_STAR_BATTLE
	if not self.legendKingInfo[activityID] then
		_ENV = self.legendKingInfo[activityID]
	end
	return self.legendKingInfo[activityID]
end
function kingStarCtrl:reqKingdomTitleList(activityId)
	serverproxy = nil
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_KINGDOM_TITLE_LIST, data)
end
function kingStarCtrl:getKingdomTitleList()
	return self.kingdomTitleList
end
function kingStarCtrl:reqLordTitleList(activityId)
	serverproxy = nil
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_LORD_TITLE_LIST, data)
end
function kingStarCtrl:getLordTitleList()
	return self.lordTitleList
end
function kingStarCtrl:reqTitleInfo(activityId)
	local _ENV, data
	if activityId and type(activityId) == "table" then
		_ENV = type(activityId)
		data, type(activityId).activityIdList = type(activityId), activityId
	else
		_ENV = type(activityId)
		data, type(activityId).activityId = type(activityId), activityId
	end
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_TITLE_INFO, data)
end
function kingStarCtrl:reqLordGiftList(activityId)
	serverproxy = nil
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GIFT_LIST, data)
end
function kingStarCtrl:getLordGiftList()
	return self.giftList
end
function kingStarCtrl:reqAwardGift(uid, giftID, nickname, activityId)
	_ENV = nil
	;(nil).uid = uid
	;(nil).nickname = nickname
	;(nil).giftID = giftID
	local (nil).activityId, data = activityId, nil
	dump(data, "赏赐礼包给玩家-----")
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_AWARD_GIFT, data)
end
function kingStarCtrl:reqGiftLog(activityId)
	serverproxy = nil
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GIFT_LOG, data)
end
function kingStarCtrl:getGiftLog()
	return self.giftLog
end
function kingStarCtrl:reqAppointKingdomTitle(kid, titleID, activityId)
	serverproxy = nil
	;(nil).kid = kid
	;(nil).titleID = titleID
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_APPOINT_KINGDOM_TITLE, data)
end
function kingStarCtrl:reqAppointLordTitle(uid, titleID, kid, activityId)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).titleID = titleID
	;(nil).kid = kid
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_APPOINT_LORD_TITLE, data)
end
function kingStarCtrl:reqCancelKingdomTitle(titleID, activityId)
	serverproxy = nil
	;(nil).titleID = titleID
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_CANCEL_KINGDOM_TITLE, data)
end
function kingStarCtrl:reqCancelLordTitle(titleID, uid, activityId)
	serverproxy = nil
	;(nil).titleID = titleID
	;(nil).uid = uid
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_CANCEL_LORD_TITLE, data)
end
function kingStarCtrl:reqLegendKingList(activityId)
	serverproxy = nil
	;(nil).activityId = activityId
	serverproxy:Request(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GET_JOIN_KINGDOM_LIST, nil)
end
function kingStarCtrl:showErrorCode(err)
	SoraDShowMsgTip("error! code = " .. err)
end
function kingStarCtrl:getTitleActivityId(...)
	if self.titleInfo then
		return self.titleInfo.activityId
	end
end
function kingStarCtrl:getLordTitleID()
	if self.titleInfo and self.titleInfo.lordTitleID ~= nil then
		return self.titleInfo.lordTitleID
	end
end
function kingStarCtrl:getKingdomTitleID()
	if self.titleInfo and self.titleInfo.kingdomTitleID ~= nil then
		return self.titleInfo.kingdomTitleID
	end
end
function kingStarCtrl:getLordRank()
	if self.titleInfo and self.titleInfo.rank ~= nil then
		return self.titleInfo.rank
	end
end
function kingStarCtrl:getIsSelfLegendKing()
	local lordTitleID = self:getLordTitleID()
	if lordTitleID and lordTitleID == gLegendOfficialId.KING then
		return true
	end
	return false
end
function kingStarCtrl:getBuff(effectType)
	if not self.titleInfo then
		return
	end
	local lordTitleBuffValue
	if self.titleInfo.lordTitleID then
		local mapid = worldMapDefine.getKingStarMapid(self.titleInfo.activityId)
		lordTitleBuffValue = legendTitleBuff:getTitleBuff(self.titleInfo.lordTitleID, effectType, mapid)
	end
	local kingdomTitleBuffValue
	if self.titleInfo.kingdomTitleID then
		local mapid = worldMapDefine.getKingStarMapid(self.titleInfo.activityId)
		kingdomTitleBuffValue = legendTitleBuff:getTitleBuff(self.titleInfo.kingdomTitleID, effectType, mapid)
	end
	if lordTitleBuffValue and kingdomTitleBuffValue then
		return lordTitleBuffValue + kingdomTitleBuffValue
	end
	return lordTitleBuffValue or kingdomTitleBuffValue
end
function kingStarCtrl:ctor(properties)
	kingStarCtrl.super.ctor(self, properties)
	self:init()
end
function kingStarCtrl:EnterGame()
	kingStarCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_KINGDOM_TITLE_LIST, handler(self, RSP.reqKingdomTitleListRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_LORD_TITLE_LIST, handler(self, RSP.reqLordTitleListRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_TITLE_INFO, handler(self, RSP.reqTitleInfoRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GIFT_LIST, handler(self, RSP.reqLordGiftListRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_AWARD_GIFT, handler(self, RSP.reqAwardGiftRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_APPOINT_KINGDOM_TITLE, handler(self, RSP.reqAppointKingdomTitleRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_APPOINT_LORD_TITLE, handler(self, RSP.reqAppointLordTitleRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_CANCEL_KINGDOM_TITLE, handler(self, RSP.reqCancelKingdomTitleRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_CANCEL_LORD_TITLE, handler(self, RSP.reqCancelLordTitleRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GIFT_LOG, handler(self, RSP.reqGiftLogRsp))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GET_KING_INFO, handler(self, RSP.reqLegendKingInfoRSP))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_REAL_REWARD_INFO, handler(self, RSP.reqLegendRewardInfoRSP))
	msgCtrl.register(gCmd.CMD_SEP_LLW_MODULE, gCmd.REQ_SEP_LLW_GET_JOIN_KINGDOM_LIST, handler(self, RSP.reqLegendKingListRSP))
	self:resetData()
	RSP = self.resetData
	self.resetData[1] = gActivityTimeActivityID.KING_STAR_BATTLE
	self.resetData[2] = gActivityTimeActivityID.LEGEND_LORD_9001646
	local self.resetData[3], activityIDList = gActivityTimeActivityID.LEGEND_LORD_9001647, self.resetData
	self:reqTitleInfo(activityIDList)
	self:reqLegendRewardInfo(activityIDList)
	self:reqLegendKingInfo(activityIDList)
	self:registerNotify()
end
function kingStarCtrl:Logout()
	kingStarCtrl.super.Logout(self)
	self:resetData()
end
function kingStarCtrl:resetData()
	self.lordTitleList, _UPVALUE0_, self.kingdomTitleList, _UPVALUE0_, self.titleInfo, _UPVALUE0_, self.legendKingInfo, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function kingStarCtrl:init()
	self:resetData()
end
function kingStarCtrl:registerNotify()
	print("kingStarCtrl:registerNotify")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LEGEND_LORD_FOR_SEP, handler(self, RSP.noitfyDataRsp))
end
function kingStarCtrl:initClientData(retdata)
	dump(retdata, "kingStarCtrl:initClientData", 10)
end
function RSP:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "kingStarCtrl RSP.noitfyDataRsp(content)@@@", 10)
	for i, notifyMsg in ipairs(notifydata) do
		local notifyType = notifyMsg.notifyType
		local notifyData = notifyMsg.notifyData
		local notifyFunc = "onNotify_" .. notifyType
		if not RSP[notifyFunc] then
			print("kingStarCtrl:" .. notifyFunc .. " not implemented!")
		else
			RSP[notifyFunc](self, notifyData)
		end
	end
end
function RSP:onNotify_refreshReward(notifyData)
	local rewardInfo = notifyData.rewardInfo
	if rewardInfo then
		local legendLordWarltCtrl = include("legendLordWarltCtrl")
		local mapid = worldMapDefine.getKingStarMapid(notifyData.activityId)
		legendLordWarltCtrl.updateLegendReward(rewardInfo, mapid)
	end
end
function RSP:onNotify_appointedKT(notifyData)
	local titleID = notifyData.titleID
	self.titleInfo.kingdomTitleID = titleID
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_AP_KT"
	SoraDSendMessage(nil)
	local mapid = worldMapDefine.getKingStarMapid(notifyData.activityId)
	legendTitleBuff:notifyBuffChange(titleID, mapid)
end
function RSP:onNotify_appointedLT(notifyData)
	local titleID = notifyData.titleID
	self.titleInfo.lordTitleID = titleID
	dump(self.titleInfo, "self.titleInfo", 5)
	local mapid = worldMapDefine.getKingStarMapid(notifyData.activityId)
	legendTitleBuff:notifyBuffChange(titleID, mapid)
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setKingStarTitle(titleID)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_AP_LT"
	SoraDSendMessage(lordCtrl)
end
function RSP:onNotify_canceledKT(notifyData)
	local kingdomTitleID = self.titleInfo.kingdomTitleID
	self.titleInfo.kingdomTitleID = nil
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CL_KT"
	SoraDSendMessage(nil)
	local mapid = worldMapDefine.getKingStarMapid(notifyData.activityId)
	legendTitleBuff:notifyBuffChange(kingdomTitleID, mapid)
end
function RSP:onNotify_canceledLT(notifyData)
	local lordTitleID = self.titleInfo.lordTitleID
	self.titleInfo.lordTitleID = nil
	dump(self.titleInfo, "self.titleInfo", 5)
	local mapid = worldMapDefine.getKingStarMapid(notifyData.activityId)
	legendTitleBuff:notifyBuffChange(lordTitleID, mapid)
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setKingStarTitle(nil)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CL_LT"
	SoraDSendMessage(lordCtrl)
end
function RSP:onNotify_clean(notifyData)
	local kingdomTitleID = self.titleInfo.kingdomTitleID
	local lordTitleID = self.titleInfo.lordTitleID
	self.titleInfo, _ENV = nil, nil
	local mapid = worldMapDefine.getKingStarMapid(notifyData.activityId)
	if kingdomTitleID then
		legendTitleBuff:notifyBuffChange(kingdomTitleID, mapid)
	end
	if lordTitleID then
		legendTitleBuff:notifyBuffChange(lordTitleID, mapid)
	end
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setKingStarTitle(nil)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CLEAN"
	SoraDSendMessage(lordCtrl)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
	SoraDSendMessage(lordCtrl)
end
function RSP:onNotify_setRank(notifyData)
	local rank = notifyData.rank
	self.titleInfo.rank = rank
end
function RSP:reqKingdomTitleListRsp(content)
	dump(content, "kingStarCtrl.reqKingdomTitleListRsp", 5)
	if content.err == gErrDef.Err_None then
		local kingdomTitleList = content.data.kingdomTitleList
		self.kingdomTitleList, _ENV = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(kingdomTitleList) do
			self.kingdomTitleList[v.titleID] = v
		end
		_ENV = ipairs(kingdomTitleList)
		ipairs(kingdomTitleList).msg = "MESSAGE_SERVER_LEGENDLORD_KINGDOM_TITLE_LIST_BACK"
		SoraDSendMessage(ipairs(kingdomTitleList))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqLordTitleListRsp(content)
	dump(content, "kingStarCtrl.reqLordTitleListRsp", 5)
	if content.err == gErrDef.Err_None then
		local lordTitleList = content.data.lordTitleList
		self.lordTitleList, _ENV = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(lordTitleList) do
			self.lordTitleList[v.titleID] = v
		end
		_ENV = ipairs(lordTitleList)
		ipairs(lordTitleList).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_TITLE_LIST_BACK"
		SoraDSendMessage(ipairs(lordTitleList))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqTitleInfoRsp(content)
	dump(content, "kingStarCtrl.reqTitleInfoRsp", 5)
	if content.err == gErrDef.Err_None then
		local activityIdList = content.data.activityIdList
		if activityIdList then
			for __, activityId in ipairs(activityIdList) do
				local titleInfo = content.rspdata and content.rspdata[tostring(activityId)]
				if titleInfo and next(titleInfo) then
					self.titleInfo = titleInfo
					self.titleInfo.activityId = activityId
				end
			end
		elseif next(content.data.titleInfo) then
			self.titleInfo = content.data.titleInfo
			self.titleInfo.activityId = content.data.activityId
		end
		_ENV = content.data.activityId
		content.data.activityId.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_TITLE_INFO_BACK"
		SoraDSendMessage(content.data.activityId)
		_ENV = content.data.activityId
		content.data.activityId.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
		SoraDSendMessage(content.data.activityId)
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqLordGiftListRsp(content)
	dump(content, "kingStarCtrl.reqLordGiftListRsp", 5)
	if content.err == gErrDef.Err_None then
		self.giftList = content.data.giftList
		local activityId = content.data.activityId
		if self.giftList == nil or next(self.giftList) == nil then
			local legendKingRead = include("legendKingRead")
			local packageList = legendKingRead.getPackageList(worldMapDefine.getKingStarMapid(activityId))
			self.giftList, _ENV = worldMapDefine.getKingStarMapid(activityId)
			for i, v in ipairs(packageList) do
				_ENV = worldMapDefine.getKingStarMapid(activityId)
				worldMapDefine.getKingStarMapid(activityId).giftID = v.rewardsType
				worldMapDefine.getKingStarMapid(activityId).total = v.num
				worldMapDefine.getKingStarMapid(activityId).uidList, _ENV, worldMapDefine.getKingStarMapid(activityId).remainCount = v.num, v.num, v.num
				table.insert(self.giftList, worldMapDefine.getKingStarMapid(activityId))
			end
		end
		_ENV = legendKingRead.getPackageList(worldMapDefine.getKingStarMapid(activityId))
		legendKingRead.getPackageList(worldMapDefine.getKingStarMapid(activityId)).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_GIFT_LIST_BACK"
		SoraDSendMessage((legendKingRead.getPackageList(worldMapDefine.getKingStarMapid(activityId))))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqAwardGiftRsp(content)
	dump(content, "kingStarCtrl.reqAwardGiftRsp", 5)
	if content.err == gErrDef.Err_None then
		local giftID = content.data.giftID
		local uid = content.data.uid
		for i, v in pairs(self.giftList) do
			if v.giftID == giftID then
				v.remainCount = v.remainCount - 1
				if not v.uidList then
					v.uidList, _ENV = v.uidList, v.uidList
				end
				table.insert(v.uidList, uid)
				break
			end
		end
		_ENV = pairs(self.giftList)
		pairs(self.giftList).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_AWARD_GIFT_BACK"
		pairs(self.giftList).awardItem = awardItem
		SoraDSendMessage(pairs(self.giftList))
	elseif content.err == gErrDef.Err_LL_ALREADY_AWARD_GIFT then
		local name = content.data.nickName
		if content.data.allianceAbbr then
			_ENV = pairs(self.giftList)
			pairs(self.giftList).abbr = content.data.allianceAbbr
			pairs(self.giftList).name = content.data.nickName
			name = i18n("common_text_186", pairs(self.giftList))
		end
		_ENV = content.data.nickName
		content.data.nickName.name = name
		SoraDShowMsgTip(i18n("common_text_1191", content.data.nickName))
	end
end
function RSP:reqGiftLogRsp(content)
	if content.err == gErrDef.Err_None then
		self.giftLog = content.data.log
		table.sort(self.giftLog, function(v1, v2)
			return v2.time < v1.time
		end)
		_ENV = self.giftLog
		self.giftLog.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_GIFT_LOG_BACK"
		SoraDSendMessage(self.giftLog)
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqAppointKingdomTitleRsp(content)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1431"))
		local kid = content.data.kid
		local titleID = content.data.titleID
		_ENV = i18n("common_text_1431")
		i18n("common_text_1431").kid = kid
		self.kingdomTitleList[titleID], i18n("common_text_1431").titleID = i18n("common_text_1431")
		_ENV = i18n("common_text_1431")
		i18n("common_text_1431").msg = "MESSAGE_SERVER_LEGENDLORD_LORD_APPOINT_KT_BACK"
		i18n("common_text_1431").kingdomTitle = titleID
		SoraDSendMessage(i18n("common_text_1431"))
	else
	end
end
function RSP:reqAppointLordTitleRsp(content)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1431"))
		local lordTitleInfo = content.rspdata
		self.lordTitleList[lordTitleInfo.titleID] = lordTitleInfo
		_ENV = lordTitleInfo.titleID
		lordTitleInfo.titleID.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_APPOINT_LT_BACK"
		lordTitleInfo.titleID.lordTitle = titleID
		SoraDSendMessage(lordTitleInfo.titleID)
	else
	end
end
function RSP:reqCancelKingdomTitleRsp(content)
	if content.err == gErrDef.Err_None then
		local kingdomTitle = content.data.kingdomTitle
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_CANCEL_KT_BACK"
		;(nil).kingdomTitle = kingdomTitle
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
		SoraDSendMessage(nil)
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqCancelLordTitleRsp(content)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_1444"))
		local lordTitle = content.data.titleID
		local uid = content.data.uid
		self.lordTitleList[lordTitle] = nil
		_ENV = i18n("common_text_1444")
		i18n("common_text_1444").msg = "MESSAGE_SERVER_LEGENDLORD_LORD_CANCEL_LT_BACK"
		i18n("common_text_1444").lordTitle = lordTitle
		i18n("common_text_1444").uid = uid
		SoraDSendMessage(i18n("common_text_1444"))
		_ENV = i18n("common_text_1444")
		i18n("common_text_1444").msg = "MESSAGE_LORDINFO_DISMISS_TITLE_BACK"
		i18n("common_text_1444").uid = uid
		i18n("common_text_1444").officialType = gShowOfficialType.KINGSTAR
		SoraDSendMessage(i18n("common_text_1444"))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqLegendKingInfoRSP(content)
	dump(content, "kingStarCtrl:reqLegendKingInfoRSP", 10)
	local fillKingdomInfo = function(legendKingInfo)
		if legendKingInfo and next(legendKingInfo) then
			if legendKingInfo.kingdomInfo then
				local kid = legendKingInfo.kingdomInfo.kid
				local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
				local found, kingdomInfo = kingdomCtrl:isFoundKingdomID(kid)
				if found then
					legendKingInfo.kingdomInfo.kname = kingdomInfo.kname
					legendKingInfo.kingdomInfo.kflag = kingdomInfo.flagid
				end
				return legendKingInfo
			elseif legendKingInfo.forbidEnter then
				return legendKingInfo
			end
		end
	end
	local err = content.err
	if err == gErrDef.Err_None then
		local activityIdList = content.data.activityIdList
		if activityIdList then
			for __, activityId in ipairs(activityIdList) do
				local legendKingInfo = fillKingdomInfo(content.rspdata[tostring(activityId)])
				self.legendKingInfo[activityId] = legendKingInfo
			end
		else
			local activityId = content.data.activityId or gActivityTimeActivityID.KING_STAR_BATTLE
			local legendKingInfo = fillKingdomInfo(content.rspdata)
			self.legendKingInfo[activityId] = legendKingInfo
		end
		_ENV = fillKingdomInfo(content.rspdata)
		fillKingdomInfo(content.rspdata).msg = "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK"
		SoraDSendMessage((fillKingdomInfo(content.rspdata)))
	else
		print("kingStarCtrl:reqLegendKingInfoRSP err code = ", tostring(err))
	end
end
function RSP:reqLegendRewardInfoRSP(content)
	dump(content, "kingStarCtrl:reqLegendRewardInfoRSP", 10)
	local legendLordWarltCtrl = include("legendLordWarltCtrl")
	local err = content.err
	if err == gErrDef.Err_None then
		local activityIdList = content.data.activityIdList
		if activityIdList then
			for __, activityId in ipairs(activityIdList) do
				local rewardInfo = content.rspdata and content.rspdata[tostring(activityId)]
				if rewardInfo then
					local mapid = worldMapDefine.getKingStarMapid(activityId)
					legendLordWarltCtrl.updateLegendReward(rewardInfo, mapid)
				end
			end
		else
			local rewardInfo = content.rspdata and content.rspdata.reward
			if rewardInfo then
				local mapid = worldMapDefine.getKingStarMapid(content.data.activityId)
				legendLordWarltCtrl.updateLegendReward(rewardInfo, mapid)
			end
		end
	else
		print("kingStarCtrl:reqLegendRewardInfoRSP err code = ", tostring(err))
	end
end
function RSP:reqLegendKingListRSP(content)
	dump(content, "kingStarCtrl:reqLegendKingListRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		_ENV = "kingStarCtrl:reqLegendKingListRSP"
		;("kingStarCtrl:reqLegendKingListRSP").msg = "MESSAGE_SERVER_LEGENDM_KINGDOMLIST_BACK"
		;("kingStarCtrl:reqLegendKingListRSP").list = content.rspdata.kingdoms
		SoraDSendMessage("kingStarCtrl:reqLegendKingListRSP")
	else
		print("kingStarCtrl:reqLegendKingListRSP err code = ", tostring(err))
	end
end
return kingStarCtrl
