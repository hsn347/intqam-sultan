local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local legendTitleBuff = include("legendTitleBuff")
local legendLordCtrl = class("legendLordCtrl", gamemodulec)
local _ENV, REQ = "legendLordCtrl", "legendLordCtrl"
local _ENV, RSP = gamemodulec, gamemodulec
function legendLordCtrl:reqLegendKingInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GET_KING_INFO, data)
end
function legendLordCtrl:reqLegendRewardInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_REAL_REWARD_INFO, data)
end
function legendLordCtrl:getLegendKingInfo()
	return self.legendKingInfo
end
function legendLordCtrl:reqKingdomTitleList()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_KINGDOM_TITLE_LIST, data)
end
function legendLordCtrl:getKingdomTitleList()
	return self.kingdomTitleList
end
function legendLordCtrl:reqLordTitleList()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_LORD_TITLE_LIST, data)
end
function legendLordCtrl:getLordTitleList()
	return self.lordTitleList
end
function legendLordCtrl:reqTitleInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_TITLE_INFO, data)
end
function legendLordCtrl:reqLordGiftList()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GIFT_LIST, data)
end
function legendLordCtrl:getLordGiftList()
	return self.giftList
end
function legendLordCtrl:reqAwardGift(uid, giftID, nickname)
	_ENV = nil
	;(nil).uid = uid
	;(nil).nickname = nickname
	local (nil).giftID, data = giftID, nil
	dump(data, "赏赐礼包给玩家-----")
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_AWARD_GIFT, data)
end
function legendLordCtrl:reqGiftLog()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GIFT_LOG, data)
end
function legendLordCtrl:getGiftLog()
	return self.giftLog
end
function legendLordCtrl:reqAppointKingdomTitle(kid, titleID)
	serverproxy = nil
	;(nil).kid = kid
	local (nil).titleID, data = titleID, nil
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_APPOINT_KINGDOM_TITLE, data)
end
function legendLordCtrl:reqAppointLordTitle(uid, titleID, kid)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).titleID = titleID
	local (nil).kid, data = kid, nil
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_APPOINT_LORD_TITLE, data)
end
function legendLordCtrl:reqCancelKingdomTitle(titleID)
	serverproxy = nil
	local (nil).titleID, data = titleID, nil
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_CANCEL_KINGDOM_TITLE, data)
end
function legendLordCtrl:reqCancelLordTitle(titleID, uid)
	serverproxy = nil
	;(nil).titleID = titleID
	local (nil).uid, data = uid, nil
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_CANCEL_LORD_TITLE, data)
end
function legendLordCtrl:reqLegendKingList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GET_JOIN_KINGDOM_LIST, nil)
end
function legendLordCtrl:showErrorCode(err)
	SoraDShowMsgTip("error! code = " .. err)
end
function legendLordCtrl:getLordTitleID(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return SoraDGetCtrl("kingStarCtrl"):getLordTitleID()
	end
	if self.titleInfo and self.titleInfo.lordTitleID ~= nil then
		return self.titleInfo.lordTitleID
	end
end
function legendLordCtrl:getKingdomTitleID(mapid)
	if worldMapDefine.isKingStarMapId(mapid) then
		return SoraDGetCtrl("kingStarCtrl"):getKingdomTitleID()
	end
	if self.titleInfo and self.titleInfo.kingdomTitleID ~= nil then
		return self.titleInfo.kingdomTitleID
	end
end
function legendLordCtrl:getLordRank()
	if self.titleInfo and self.titleInfo.rank ~= nil then
		return self.titleInfo.rank
	end
end
function legendLordCtrl:getIsSelfLegendKing()
	local lordTitleID = self:getLordTitleID()
	if lordTitleID and lordTitleID == gLegendOfficialId.KING then
		return true
	end
	return false
end
function legendLordCtrl:getBuff(effectType)
	if not self.titleInfo then
		return
	end
	local lordTitleBuffValue
	if self.titleInfo.lordTitleID then
		lordTitleBuffValue = legendTitleBuff:getTitleBuff(self.titleInfo.lordTitleID, effectType)
	end
	local kingdomTitleBuffValue
	if self.titleInfo.kingdomTitleID then
		kingdomTitleBuffValue = legendTitleBuff:getTitleBuff(self.titleInfo.kingdomTitleID, effectType)
	end
	if lordTitleBuffValue and kingdomTitleBuffValue then
		return lordTitleBuffValue + kingdomTitleBuffValue
	end
	return lordTitleBuffValue or kingdomTitleBuffValue
end
function legendLordCtrl:ctor(properties)
	legendLordCtrl.super.ctor(self, properties)
	self:init()
end
function legendLordCtrl:EnterGame()
	legendLordCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_KINGDOM_TITLE_LIST, handler(self, RSP.reqKingdomTitleListRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_LORD_TITLE_LIST, handler(self, RSP.reqLordTitleListRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_TITLE_INFO, handler(self, RSP.reqTitleInfoRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GIFT_LIST, handler(self, RSP.reqLordGiftListRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_AWARD_GIFT, handler(self, RSP.reqAwardGiftRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_APPOINT_KINGDOM_TITLE, handler(self, RSP.reqAppointKingdomTitleRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_APPOINT_LORD_TITLE, handler(self, RSP.reqAppointLordTitleRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_CANCEL_KINGDOM_TITLE, handler(self, RSP.reqCancelKingdomTitleRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_CANCEL_LORD_TITLE, handler(self, RSP.reqCancelLordTitleRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GIFT_LOG, handler(self, RSP.reqGiftLogRsp))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GET_KING_INFO, handler(self, RSP.reqLegendKingInfoRSP))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_REAL_REWARD_INFO, handler(self, RSP.reqLegendRewardInfoRSP))
	msgCtrl.register(gCmd.CMD_LLW_MODULE, gCmd.REQ_LLW_GET_JOIN_KINGDOM_LIST, handler(self, RSP.reqLegendKingListRSP))
	self:resetData()
	self:reqTitleInfo()
	self:reqLegendRewardInfo()
	self:registerNotify()
end
function legendLordCtrl:Logout()
	legendLordCtrl.super.Logout(self)
	self:resetData()
end
function legendLordCtrl:resetData()
	self.lordTitleList, _UPVALUE0_, self.kingdomTitleList, _UPVALUE0_, self.titleInfo, _UPVALUE0_, self.legendKingInfo, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function legendLordCtrl:init()
	self:resetData()
end
function legendLordCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LEGEND_LORD, handler(self, RSP.noitfyDataRsp))
end
function legendLordCtrl:initClientData(retdata)
	dump(retdata, "legendLordCtrl:initClientData", 10)
end
function RSP:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "legendLordCtrl RSP.noitfyDataRsp(content)@@@", 10)
	for i, notifyMsg in ipairs(notifydata) do
		local notifyType = notifyMsg.notifyType
		local notifyData = notifyMsg.notifyData
		local notifyFunc = "onNotify_" .. notifyType
		if not RSP[notifyFunc] then
			print("legendLordCtrl:" .. notifyFunc .. " not implemented!")
		else
			RSP[notifyFunc](self, notifyData)
		end
	end
end
function RSP:onNotify_refreshReward(notifyData)
	local rewardInfo = notifyData.rewardInfo
	if rewardInfo then
		local legendLordWarltCtrl = include("legendLordWarltCtrl")
		legendLordWarltCtrl.updateLegendReward(rewardInfo)
	end
end
function RSP:onNotify_appointedKT(notifyData)
	local titleID = notifyData.titleID
	self.titleInfo.kingdomTitleID = titleID
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_AP_KT"
	SoraDSendMessage(nil)
	legendTitleBuff:notifyBuffChange(titleID)
end
function RSP:onNotify_appointedLT(notifyData)
	local titleID = notifyData.titleID
	self.titleInfo.lordTitleID = titleID
	dump(self.titleInfo, "self.titleInfo", 5)
	legendTitleBuff:notifyBuffChange(titleID)
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setLegendLordTitle(titleID)
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
	legendTitleBuff:notifyBuffChange(kingdomTitleID)
end
function RSP:onNotify_canceledLT(notifyData)
	local lordTitleID = self.titleInfo.lordTitleID
	self.titleInfo.lordTitleID = nil
	dump(self.titleInfo, "self.titleInfo", 5)
	legendTitleBuff:notifyBuffChange(lordTitleID)
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setLegendLordTitle(nil)
	_ENV = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CL_LT"
	SoraDSendMessage(lordCtrl)
end
function RSP:onNotify_clean(notifyData)
	local kingdomTitleID = self.titleInfo.kingdomTitleID
	local lordTitleID = self.titleInfo.lordTitleID
	self.titleInfo, legendTitleBuff = nil, nil
	if kingdomTitleID then
		legendTitleBuff:notifyBuffChange(kingdomTitleID)
	end
	if lordTitleID then
		legendTitleBuff:notifyBuffChange(lordTitleID)
	end
	local lordCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	lordCtrl:setLegendLordTitle(nil)
	legendTitleBuff = lordCtrl
	lordCtrl.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CLEAN"
	SoraDSendMessage(lordCtrl)
	legendTitleBuff = lordCtrl
	lordCtrl.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
	SoraDSendMessage(lordCtrl)
end
function RSP:onNotify_setRank(notifyData)
	local rank = notifyData.rank
	self.titleInfo.rank = rank
end
function RSP:reqKingdomTitleListRsp(content)
	dump(content, "legendLordCtrl.reqKingdomTitleListRsp", 5)
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
	dump(content, "legendLordCtrl.reqLordTitleListRsp", 5)
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
	dump(content, "legendLordCtrl.reqTitleInfoRsp", 5)
	if content.err == gErrDef.Err_None then
		self.titleInfo = content.data.titleInfo
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDLORD_LORD_TITLE_INFO_BACK"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR"
		SoraDSendMessage(gErrDef.Err_None)
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqLordGiftListRsp(content)
	dump(content, "legendLordCtrl.reqLordGiftListRsp", 5)
	if content.err == gErrDef.Err_None then
		self.giftList = content.data.giftList
		if self.giftList == nil or next(self.giftList) == nil then
			local legendKingRead = include("legendKingRead")
			local packageList = legendKingRead.getPackageList()
			self.giftList, _ENV = "legendLordCtrl.reqLordGiftListRsp", "legendLordCtrl.reqLordGiftListRsp"
			for i, v in ipairs(packageList) do
				_ENV = nil
				;(nil).giftID = v.rewardsType
				;(nil).total = v.num
				;(nil).uidList, _ENV, (nil).remainCount = v.num, v.num, v.num
				table.insert(self.giftList, nil)
			end
		end
		_ENV = legendKingRead.getPackageList()
		legendKingRead.getPackageList().msg = "MESSAGE_SERVER_LEGENDLORD_LORD_GIFT_LIST_BACK"
		SoraDSendMessage((legendKingRead.getPackageList()))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqAwardGiftRsp(content)
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
		i18n("common_text_1444").officialType = gShowOfficialType.LEGEND
		SoraDSendMessage(i18n("common_text_1444"))
	else
		self:showErrorCode(content.err)
	end
end
function RSP:reqLegendKingInfoRSP(content)
	local err = content.err
	if err == gErrDef.Err_None then
		self.legendKingInfo = content.rspdata
		if next(self.legendKingInfo) then
			local kid = self.legendKingInfo.kingdomInfo.kid
			local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
			local found, kingdomInfo = kingdomCtrl:isFoundKingdomID(kid)
			if found then
				self.legendKingInfo.kingdomInfo.kname = kingdomInfo.kname
				self.legendKingInfo.kingdomInfo.kflag = kingdomInfo.flagid
			end
		end
		_ENV = gametop.playertop_:getModule("kingdomCtrl")
		gametop.playertop_:getModule("kingdomCtrl").msg = "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK"
		SoraDSendMessage((gametop.playertop_:getModule("kingdomCtrl")))
	else
		print("legendLordCtrl:reqLegendKingInfoRSP err code = ", tostring(err))
	end
end
function RSP:reqLegendRewardInfoRSP(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.rspdata then
			local rewardInfo = content.rspdata.reward
			if rewardInfo then
				local legendLordWarltCtrl = include("legendLordWarltCtrl")
				legendLordWarltCtrl.updateLegendReward(rewardInfo)
			end
		end
	else
		print("legendLordCtrl:reqLegendRewardInfoRSP err code = ", tostring(err))
	end
end
function RSP:reqLegendKingListRSP(content)
	dump(content.rspdata, "legendLordCtrl:reqLegendKingListRSP", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		_ENV = "legendLordCtrl:reqLegendKingListRSP"
		;("legendLordCtrl:reqLegendKingListRSP").msg = "MESSAGE_SERVER_LEGENDM_KINGDOMLIST_BACK"
		;("legendLordCtrl:reqLegendKingListRSP").list = content.rspdata.kingdoms
		SoraDSendMessage("legendLordCtrl:reqLegendKingListRSP")
	else
		print("legendLordCtrl:reqLegendKingListRSP err code = ", tostring(err))
	end
end
return legendLordCtrl
