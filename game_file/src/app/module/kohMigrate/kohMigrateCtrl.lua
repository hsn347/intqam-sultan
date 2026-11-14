local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = class("kohMigrateCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local kohMigrateRead = include("kohMigrateRead")
function kohMigrateCtrl:ctor(properties)
	kohMigrateCtrl.super.ctor(self, properties)
	kohMigrateCtrl, self.activityID = gActivityTimeActivityID.KOH_MIGRATE, gActivityTimeActivityID.KOH_MIGRATE
	gActivityTimeActivityID.KOH_MIGRATE[1] = 729001
	self.notifyData, kohMigrateCtrl, self.itemIDList, gActivityTimeActivityID.KOH_MIGRATE[2] = gActivityTimeActivityID.KOH_MIGRATE, gActivityTimeActivityID.KOH_MIGRATE, gActivityTimeActivityID.KOH_MIGRATE, 729701
	self:resetData()
end
function kohMigrateCtrl:getItemCount(...)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local count = 0
	for i, v in ipairs(self.itemIDList) do
		count = count + (backpackCtrl:getItemCount(v) or 0)
	end
	return count
end
function kohMigrateCtrl:getItemIDList(...)
	return self.itemIDList
end
function kohMigrateCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_LIST, handler(self, self.reqKingdomListRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_MOVE_CITY, handler(self, self.reqMoveCityRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_RECORDS, handler(self, self.reqRecordsRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SETUP, handler(self, self.reqSetupRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_DATA, handler(self, self.reqKingdomDataRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SEND_EXTRA_APPLY, handler(self, self.reqSendExtraApplyRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_ACCEPT_EXTRA_APPLY, handler(self, self.reqAcceptExtraApplyRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_REJECT_EXTRA_APPLY, handler(self, self.reqRejectExtraApplyRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_PLAYER_EXTRA_APPLY_LIST, handler(self, self.reqPlayerExtraApplyListRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_EXTRA_APPLY_LIST, handler(self, self.reqKingdomExtraApplyListRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SEARCH_PLAYER, handler(self, self.reqSearchPlayerRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SEND_SPEC_INVITE, handler(self, self.reqSendSpecInviteRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_CANCEL_SPEC_INVITE, handler(self, self.reqCancelSpecInviteRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_SPEC_INVITE_LIST, handler(self, self.reqKingdomSpecInviteListRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_GROUP_LIST, handler(self, self.reqGroupListRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_ENTER_CHAT_ROOM, handler(self, self.reqEnterChatRoomRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_T1_PLAYER_RANK, handler(self, self.reqT1PlayerRankRsp))
	if IsArClient then
		self:reqKingdomData()
	end
end
function kohMigrateCtrl:Logout()
	kohMigrateCtrl.super.Logout(self)
	self:resetData()
end
function kohMigrateCtrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
	self.data.kingdomList, _UPVALUE0_ = nil, nil
	self.data.kingdomListMap, _UPVALUE0_ = nil, nil
	self.data.selfKingdomData, _UPVALUE0_ = nil, nil
	self.data.selfApplyList, _UPVALUE0_ = nil, nil
	self.data.selfApplyListMap, _UPVALUE0_ = nil, nil
	self.data.mobilityList, _UPVALUE0_ = nil, nil
	self.data.extraApplyList, _UPVALUE0_ = nil, nil
	self.data.privilegeInviteData, _UPVALUE0_ = nil, nil
	self.channelID = 0
	self.groupKidMap = nil
end
function kohMigrateCtrl:initClientData(content)
	dump(content, "==kohMigrateCtrl:initClientData==", 10)
	if content then
		self.notifyData = content
	end
	self:registerNotify()
end
function kohMigrateCtrl:getKingPrivilegeRed(...)
	local dailyRemindManager = include("dailyRemindManager")
	if dailyRemindManager.checkNeedRemindOnce(self.activityID, self.activityID) then
		return true
	else
		return false
	end
end
function kohMigrateCtrl:setKingPrivilegeRed(...)
	local dailyRemindManager = include("dailyRemindManager")
	dailyRemindManager.addRemindOnceToManager(self.activityID, self.activityID)
end
function kohMigrateCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOH_MIGRATE, handler(self, self.notifyHandler))
end
function kohMigrateCtrl:notifyHandler(event)
	dump(event.data, "kohMigrateCtrl:notifyHandler event.data", 10)
	local notifyType
	local isNeedNotify = false
	for _, content in pairs(event.data) do
		notifyType = content.notifyType
		if notifyType == gKohMigrateMsgType.data then
			self.notifyData = content.notifyData
			isNeedNotify = true
		elseif notifyType == gKohMigrateMsgType.updateKingdomSpecInvite then
			local invite = content.notifyData
			local index = self:checkPlayerHasInvite(invite.uid)
			if index then
				table.merge(self.data.privilegeInviteData[index], invite)
			end
			isNeedNotify = true
		elseif notifyType == gKohMigrateMsgType.removeKingdomSpecInvite then
			local invite = content.notifyData
			local index = self:checkPlayerHasInvite(invite.uid)
			if index then
				table.remove(self.data.privilegeInviteData, index)
			end
			self:setRecvSpecInviteUnRead(false)
			isNeedNotify = true
		elseif notifyType == gKohMigrateMsgType.isRecvSpecInviteUnRead then
			self:setRecvSpecInviteUnRead(true)
			_ENV = self
			self.msg = "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST"
			SoraDSendMessage(self)
			isNeedNotify = true
		elseif notifyType == gKohMigrateMsgType.removeRecvSpecInvite then
			self:setRecvSpecInviteUnRead(false)
			local kingdomId = content.notifyData.kid
			local kingdomData = self:getKingdomDataByID(kingdomId)
			if kingdomData then
				kingdomData.isSpecInvited = false
			end
			_ENV = kingdomId
			kingdomId.msg = "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST"
			SoraDSendMessage(kingdomId)
			isNeedNotify = true
		elseif notifyType == gKohMigrateMsgType.isRecvApplyUnRead and not self:getRecvApplyUnRead() then
			self:setRecvApplyUnRead(true)
			isNeedNotify = true
		elseif notifyType == gKohMigrateMsgType.isSendApplyUnRead and not self:getSendApplyUnRead() then
			self:setSendApplyUnRead(true)
			isNeedNotify = true
		end
	end
	if isNeedNotify then
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_KOHMIGRATE_REFRESH_REDPOINT"
		pairs(event.data).notifyType = notifyType
		SoraDSendMessage(pairs(event.data))
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		pairs(event.data).eventID = self.activityID
		SoraDSendMessage(pairs(event.data))
	end
end
function kohMigrateCtrl:getRecvSpecInviteUnRead(...)
	return self.notifyData.isRecvSpecInviteUnRead
end
function kohMigrateCtrl:setRecvSpecInviteUnRead(unRead)
	self.notifyData.isRecvSpecInviteUnRead = unRead
end
function kohMigrateCtrl:getRecvApplyUnRead(...)
	return self.notifyData.isRecvApplyUnRead
end
function kohMigrateCtrl:isKingPrivilegeRead()
	local ret = false
	if self:isShowPrivilegeBtn() and self:isPrivilegeOpen() then
		if self:getKingPrivilegeRed() then
			ret = true
		else
			ret = false
		end
	end
	return ret
end
function kohMigrateCtrl:getBePrivilegeInviteData()
	local _ENV, tbList
	for k, v in pairs(self.data.kingdomList) do
		if v.isSpecInvited then
			table.insert(tbList, v)
		end
	end
	return tbList
end
function kohMigrateCtrl:setRecvApplyUnRead(unRead)
	self.notifyData.isRecvApplyUnRead = unRead
end
function kohMigrateCtrl:getSendApplyUnRead(...)
	return self.notifyData.isSendApplyUnRead
end
function kohMigrateCtrl:setSendApplyUnRead(unRead)
	self.notifyData.isSendApplyUnRead = unRead
end
function kohMigrateCtrl:getLastMigrateTime(...)
	return self.notifyData.lastMigrateTime
end
function kohMigrateCtrl:getBeginStrength(...)
	return self.notifyData.beginStrength
end
function kohMigrateCtrl:getReceiveStatusAndNum(...)
	if self:getRecvSpecInviteUnRead() then
		return true, -1
	end
	if self:isShowPrivilegeBtn() and self:getRecvApplyUnRead() then
		return true, -1
	end
	if self:getSendApplyUnRead() then
		return true, -1
	end
	if self:isKingPrivilegeRead() then
		return true, -1
	end
	return false, 0
end
function kohMigrateCtrl:reqKingdomList(isSpecInvited)
	local serverproxy, data
	if isSpecInvited then
		data.isRecvSpecInviteUnRead = false
	else
		local isRecvSpecInviteUnRead = self:getRecvSpecInviteUnRead()
		data.isRecvSpecInviteUnRead = isRecvSpecInviteUnRead
	end
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_LIST, data)
end
function kohMigrateCtrl:reqKingdomListRsp(content)
	dump(content, "kohMigrateCtrl:reqKingdomListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local _ENV, kingdomList = content.err, content.err
		for __, v in ipairs(content.rspdata) do
			if not kohMigrateRead.checkIsNewkingdom(v.kid) then
				table.insert(kingdomList, v)
			end
		end
		self.data.kingdomList = kingdomList
		table.sort(self.data.kingdomList, function(a, b)
			return a.kid < b.kid
		end)
		self.data.kingdomListMap, _ENV = self.data.kingdomList, self.data.kingdomList
		for i, v in ipairs(self.data.kingdomList) do
			self.data.kingdomListMap[v.kid] = i
		end
	end
	_ENV = ipairs(self.data.kingdomList)
	ipairs(self.data.kingdomList).msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST"
	SoraDSendMessage(ipairs(self.data.kingdomList))
end
function kohMigrateCtrl:reqMoveCity(kingdomId, isInvitedMove, isExtraMove, isSpecInvitedMove, x, y)
	serverproxy = nil
	;(nil).kingdomId = kingdomId
	;(nil).isInvitedMove = isInvitedMove
	;(nil).isExtraMove = isExtraMove
	;(nil).x = x
	;(nil).y = y
	local (nil).isSpecInvitedMove, data = isSpecInvitedMove, nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_MOVE_CITY, data)
end
function kohMigrateCtrl:reqMoveCityRsp(content)
	dump(content, "kohMigrateCtrl:reqMoveCityRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KINGDOM_LEVEL_LIMIT then
		SoraDShowMsgTip(i18n("tips_across_serverLvLimit"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KINGDOM_MOVE_COUNT_LIMIT then
		_ENV = content.err
		content.err[gKohMigratePlayerType.T1] = i18n("migrant_move_text36")
		content.err[gKohMigratePlayerType.T2] = i18n("migrant_move_text38")
		local content.err[gKohMigratePlayerType.T3], config = i18n("migrant_move_text39"), content.err
		local playerType = self:getMyPlayerType()
		SoraDShowMsgTip(config[playerType])
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KINGDOM_MOVE_STRENGTH_LIMIT then
		_ENV = content.err
		content.err[gKohMigratePlayerType.T1] = i18n("migrant_move_text35")
		local content.err[gKohMigratePlayerType.T2], config = i18n("migrant_move_text37"), content.err
		local playerType = self:getMyPlayerType()
		SoraDShowMsgTip(config[playerType])
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KING_CANT_GO then
		SoraDShowMsgTip(i18n("tips_acs_move_KingLimit"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_INVITED_MOVE_LIMIT then
		SoraDShowMsgTip(i18n("tips_invitation_numLimit"))
	elseif content.err == gErrDef.ERR_CASTLE_LV_NOT_ENOUGH then
		local buildLogic = include("buildLogic")
		local checkCastleLv = self:getLvLimit()
		_ENV = i18n("tips_invitation_numLimit")
		i18n("tips_invitation_numLimit").num = buildLogic.getBuildLvStr(checkCastleLv)
		SoraDShowMsgTip(i18n("common_text_1795", i18n("tips_invitation_numLimit")))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_NOT_OPEN_SPEC_INVITE then
		SoraDShowMsgTip(i18n("tips_across_kingPower_notOpen"))
		_ENV = i18n("tips_across_kingPower_notOpen")
		i18n("tips_across_kingPower_notOpen").msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST_PRIVILEGE_CLOSE"
		SoraDSendMessage(i18n("tips_across_kingPower_notOpen"))
		local kingdomId = content.data.kingdomId
		local kingdomData = self:getKingdomDataByID(kingdomId)
		if kingdomData then
			kingdomData.isSpecInvited = false
		end
		_ENV = kingdomId
		kingdomId.msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST"
		SoraDSendMessage(kingdomId)
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_NOT_INVITED then
		_ENV = kingdomId
		kingdomId.var1 = content.data.kingdomId
		SoraDShowMsgTip(i18n("tips_across_kingPower_revoke", kingdomId))
		_ENV = i18n("tips_across_kingPower_revoke", kingdomId)
		i18n("tips_across_kingPower_revoke", kingdomId).msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST_PRIVILEGE_CLOSE"
		SoraDSendMessage(i18n("tips_across_kingPower_revoke", kingdomId))
	elseif content.err == gErrDef.Err_ACTIVITY_CLOSED or content.err == gErrDef.Err_ACTIVITY_NOT_START then
		SoraDShowMsgTip(i18n("tips_acrossMove_activity_notOpen"))
		_ENV = i18n("tips_acrossMove_activity_notOpen")
		i18n("tips_acrossMove_activity_notOpen").msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST_PRIVILEGE_CLOSE"
		SoraDSendMessage(i18n("tips_acrossMove_activity_notOpen"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_LEGEND_WAR_GIFT then
		local legendKingRead = include("legendKingRead")
		local boxName = legendKingRead.getPackageName(content.otherinfo)
		_ENV = i18n("tips_acrossMove_activity_notOpen")
		i18n("tips_acrossMove_activity_notOpen").var1 = boxName
		SoraDShowMsgTip(i18n("arossDesc_text_010", i18n("tips_acrossMove_activity_notOpen")))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KING_STAR_GIFT then
		local legendKingRead = include("legendKingRead")
		local boxName = ""
		local otherinfo = content.otherinfo
		if type(otherinfo) == "table" then
			local activityId = otherinfo.activityId
			local mapid = worldMapDefine.getKingStarMapid(activityId)
			boxName = legendKingRead.getPackageName(otherinfo.giftid, mapid)
		else
			boxName = legendKingRead.getPackageName(content.otherinfo, worldMapDefine.KINGSTAR_KINGDOM_ID)
		end
		_ENV = otherinfo.giftid
		otherinfo.giftid.var1 = boxName
		SoraDShowMsgTip(i18n("arossDesc_text_010", otherinfo.giftid))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_HEGEMON_WAR_GIFT then
		local hegemonRead = include("hegemonRead")
		local boxName = hegemonRead.getPackageName(content.otherinfo)
		_ENV = i18n("arossDesc_text_010", otherinfo.giftid)
		i18n("arossDesc_text_010", otherinfo.giftid).var1 = boxName
		SoraDShowMsgTip(i18n("arossDesc_text_010", i18n("arossDesc_text_010", otherinfo.giftid)))
	end
end
function kohMigrateCtrl:reqRecords(kingdomId, iBegin, nCount)
	serverproxy = nil
	;(nil).kingdomId = kingdomId
	;(nil).iBegin = iBegin
	local (nil).nCount, data = nCount, nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_RECORDS, data)
end
function kohMigrateCtrl:reqRecordsRsp(content)
	dump(content, "kohMigrateCtrl:reqRecordsRsp(content)", 10)
	local hasMore = false
	if content.err == gErrDef.Err_None then
		local data = content.data
		local rspdata = content.rspdata
		if #rspdata >= data.nCount then
			hasMore = true
		end
		if data.iBegin == 1 then
			self.data.mobilityList = rspdata
		else
			for i, v in ipairs(rspdata) do
				self.data.mobilityList[#self.data.mobilityList + 1] = v
			end
		end
	end
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_KOHMIGRATE_REFRESH_RECORD"
	content.rspdata.hasMore = hasMore
	SoraDSendMessage(content.rspdata)
end
function kohMigrateCtrl:reqSetup(isCloseMoveIn, playerStrengthLimit)
	serverproxy = nil
	;(nil).isCloseMoveIn = isCloseMoveIn
	local (nil).playerStrengthLimit, data = playerStrengthLimit, nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SETUP, data)
end
function kohMigrateCtrl:reqSetupRsp(content)
	dump(content, "kohMigrateCtrl:reqSetupRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.selfKingdomData.setup = content.rspdata
		SoraDShowMsgTip(i18n("common_text_4131"))
	end
	_ENV = i18n("common_text_4131")
	i18n("common_text_4131").msg = "MESSAGE_KOHMIGRATE_REFRESH_SETTING"
	SoraDSendMessage(i18n("common_text_4131"))
end
function kohMigrateCtrl:reqKingdomData(kingdomId)
	kingdomId = kingdomId or gametop.playertop_:getKingdomID()
	gametop = nil
	;(nil).kingdomId = kingdomId
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_DATA, nil)
end
function kohMigrateCtrl:reqKingdomDataRsp(content)
	dump(content, "kohMigrateCtrl:reqKingdomDataRsp(content)", 10)
	local kingdomId = content.data.kingdomId
	local isSelfKingdom = gametop.playertop_:getKingdomID() == kingdomId
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		local kingdomData = rspdata.kingdomData
		if isSelfKingdom then
			self.data.selfKingdomData = kingdomData
		else
			local index = self.data.kingdomListMap[kingdomId]
			if index and self.data.kingdomList[index] then
				table.merge(self.data.kingdomList[index], kingdomData)
			end
			local apply = rspdata.apply
			if apply then
				local index = self.data.selfApplyListMap[kingdomId]
				if index and self.data.selfApplyList[index] then
					table.merge(self.data.selfApplyList[index], apply)
				else
					table.insert(self.data.selfApplyList, apply)
					self.data.selfApplyListMap[kingdomId] = #self.data.selfApplyList
				end
			end
		end
	end
	_ENV = rspdata.kingdomData
	rspdata.kingdomData.msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA"
	SoraDSendMessage(rspdata.kingdomData)
	if not isSelfKingdom then
		_ENV = rspdata.kingdomData
		rspdata.kingdomData.msg = "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST"
		SoraDSendMessage(rspdata.kingdomData)
	end
	_ENV = rspdata.kingdomData
	rspdata.kingdomData.msg = "MESSAGE_KOHMIGRATE_PLAYER_APPLYLIST"
	SoraDSendMessage(rspdata.kingdomData)
end
function kohMigrateCtrl:reqSendExtraApply(kingdomId)
	serverproxy = nil
	;(nil).kingdomId = kingdomId
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SEND_EXTRA_APPLY, nil)
end
function kohMigrateCtrl:reqSendExtraApplyRsp(content)
	dump(content, "kohMigrateCtrl:reqSendExtraApplyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local kingdomId = content.data.kingdomId
		local index = self.data.selfApplyListMap[kingdomId]
		if index and self.data.selfApplyList[index] then
			table.merge(self.data.selfApplyList[index], content.rspdata)
		else
			table.insert(self.data.selfApplyList, content.rspdata)
			self.data.selfApplyListMap[kingdomId] = #self.data.selfApplyList
		end
		SoraDShowMsgTip(i18n("remains_text_25"))
		_ENV = i18n("remains_text_25")
		i18n("remains_text_25").msg = "MESSAGE_KOHMIGRATE_REFRESH_APPLYSTATUS"
		SoraDSendMessage(i18n("remains_text_25"))
		_ENV = i18n("remains_text_25")
		i18n("remains_text_25").msg = "MESSAGE_KOHMIGRATE_PLAYER_APPLYLIST"
		SoraDSendMessage(i18n("remains_text_25"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KINGDOM_LEVEL_LIMIT then
		SoraDShowMsgTip(i18n("tips_across_serverLvLimit"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KINGDOM_MOVE_COUNT_LIMIT then
		_ENV = content.err
		content.err[gKohMigratePlayerType.T1] = i18n("migrant_move_text36")
		content.err[gKohMigratePlayerType.T2] = i18n("migrant_move_text38")
		local content.err[gKohMigratePlayerType.T3], config = i18n("migrant_move_text39"), content.err
		local playerType = self:getMyPlayerType()
		SoraDShowMsgTip(config[playerType])
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KINGDOM_MOVE_STRENGTH_LIMIT then
		_ENV = content.err
		content.err[gKohMigratePlayerType.T1] = i18n("migrant_move_text35")
		local content.err[gKohMigratePlayerType.T2], config = i18n("migrant_move_text37"), content.err
		local playerType = self:getMyPlayerType()
		SoraDShowMsgTip(config[playerType])
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KING_CANT_GO then
		SoraDShowMsgTip(i18n("tips_acs_move_KingLimit"))
	elseif content.err == gErrDef.ERR_CASTLE_LV_NOT_ENOUGH then
		local buildLogic = include("buildLogic")
		local checkCastleLv = self:getLvLimit()
		_ENV = i18n("tips_acs_move_KingLimit")
		i18n("tips_acs_move_KingLimit").num = buildLogic.getBuildLvStr(checkCastleLv)
		SoraDShowMsgTip(i18n("common_text_1795", i18n("tips_acs_move_KingLimit")))
	end
end
function kohMigrateCtrl:reqAcceptExtraApply(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_ACCEPT_EXTRA_APPLY, nil)
end
function kohMigrateCtrl:reqAcceptExtraApplyRsp(content)
	dump(content, "kohMigrateCtrl:reqAcceptExtraApplyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		for i, v in ipairs(self.data.extraApplyList) do
			if v.uid == content.data.uid then
				table.merge(v, content.rspdata)
				break
			end
		end
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_PLAYER_ALREADY_MOVE then
		for i, v in ipairs(self.data.extraApplyList) do
			if v.uid == content.data.uid then
				table.remove(self.data.extraApplyList, i)
				break
			end
		end
	end
	_ENV = ipairs(self.data.extraApplyList)
	ipairs(self.data.extraApplyList).msg = "MESSAGE_KOHMIGRATE_KINGDOM_APPLYLIST"
	SoraDSendMessage(ipairs(self.data.extraApplyList))
end
function kohMigrateCtrl:reqRejectExtraApply(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_REJECT_EXTRA_APPLY, nil)
end
function kohMigrateCtrl:reqRejectExtraApplyRsp(content)
	dump(content, "kohMigrateCtrl:reqRejectExtraApplyRsp(content)", 10)
	if content.err == gErrDef.Err_None or content.err == gErrDef.ERR_KOH_MIGRATE_PLAYER_ALREADY_MOVE then
		for i, v in ipairs(self.data.extraApplyList) do
			if v.uid == content.data.uid then
				table.remove(self.data.extraApplyList, i)
				break
			end
		end
	end
	_ENV = ipairs(self.data.extraApplyList)
	ipairs(self.data.extraApplyList).msg = "MESSAGE_KOHMIGRATE_KINGDOM_APPLYLIST"
	SoraDSendMessage(ipairs(self.data.extraApplyList))
end
function kohMigrateCtrl:reqPlayerExtraApplyList()
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_PLAYER_EXTRA_APPLY_LIST)
end
function kohMigrateCtrl:reqPlayerExtraApplyListRsp(content)
	dump(content, "kohMigrateCtrl:reqPlayerExtraApplyListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data.selfApplyList = content.rspdata
		self.data.selfApplyListMap, _ENV = content.rspdata, content.rspdata
		for i, v in ipairs(self.data.selfApplyList) do
			self.data.selfApplyListMap[v.kid] = i
		end
	end
	_ENV = ipairs(self.data.selfApplyList)
	ipairs(self.data.selfApplyList).msg = "MESSAGE_KOHMIGRATE_PLAYER_APPLYLIST"
	SoraDSendMessage(ipairs(self.data.selfApplyList))
end
function kohMigrateCtrl:reqKingdomExtraApplyList(iBegin, nCount, sortType)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	local (nil).sortType, data = sortType, nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_EXTRA_APPLY_LIST, data)
end
function kohMigrateCtrl:reqKingdomExtraApplyListRsp(content)
	dump(content, "kohMigrateCtrl:reqKingdomExtraApplyListRsp(content)", 10)
	local hasMore = false
	local hasNew = false
	local addCount = 0
	if content.err == gErrDef.Err_None then
		local data = content.data
		local rspdata = content.rspdata
		addCount = #rspdata
		if addCount >= data.nCount then
			hasMore = true
		end
		if 0 < addCount then
			hasNew = true
		end
		if data.iBegin == 1 then
			self.data.extraApplyList = rspdata
		else
			for i, v in ipairs(rspdata) do
				self.data.extraApplyList[#self.data.extraApplyList + 1] = v
			end
		end
	end
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_KOHMIGRATE_KINGDOM_APPLYLIST"
	content.rspdata.hasMore = hasMore
	content.rspdata.hasNew = hasNew
	content.rspdata.addCount = addCount
	SoraDSendMessage(content.rspdata)
end
function kohMigrateCtrl:reqSearchPlayer(name, isSearchOtherGroup, pid)
	serverproxy = nil
	;(nil).name = name
	;(nil).isSearchOtherGroup = isSearchOtherGroup or false
	;(nil).pid = pid
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SEARCH_PLAYER, nil)
end
function kohMigrateCtrl:reqSearchPlayerRsp(content)
	dump(content, "kohMigrateCtrl:reqSearchPlayerRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_KOHMIGRATE_SEARCH_BACK"
		gErrDef.Err_None.result = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function kohMigrateCtrl:reqSendSpecInvite(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_SEND_SPEC_INVITE, nil)
end
function kohMigrateCtrl:reqSendSpecInviteRsp(content)
	dump(content, "kohMigrateCtrl:reqSendSpecInviteRsp(content)", 10)
	SoraDCloseLoading()
	local uid = content.data.uid
	if content.err == gErrDef.Err_None then
		local index = self:checkPlayerHasInvite(uid)
		if index then
			self.data.privilegeInviteData[index] = content.rspdata
		else
			table.insert(self.data.privilegeInviteData, content.rspdata)
		end
		SoraDShowMsgTip(i18n("togetherTeam_text_44"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_KING_CANT_GO then
		SoraDShowMsgTip(i18n("tips_unableInvitationTheKing"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_INVALID_TARGET_KINGDOM then
		SoraDShowMsgTip(i18n("tips_across_targetActivityNotOpen"))
	elseif content.err == gErrDef.ERR_KOH_MIGRATE_NEBULA_REGION_SEASON_LIMIT then
		SoraDShowMsgTip(i18n("migrant_move_text50"))
	end
	_ENV = i18n("migrant_move_text50")
	i18n("migrant_move_text50").msg = "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST"
	i18n("migrant_move_text50").uid = uid
	i18n("migrant_move_text50").err = content.err
	SoraDSendMessage(i18n("migrant_move_text50"))
end
function kohMigrateCtrl:reqCancelSpecInvite(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_CANCEL_SPEC_INVITE, nil)
end
function kohMigrateCtrl:reqCancelSpecInviteRsp(content)
	dump(content, "kohMigrateCtrl:reqCancelSpecInviteRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local index = self:checkPlayerHasInvite(content.data.uid)
		if index then
			table.remove(self.data.privilegeInviteData, index)
		end
		SoraDShowMsgTip(i18n("Tips_kingPower_recallSuccess"))
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.msg = "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST"
	SoraDSendMessage(SoraDShowMsgTip)
end
function kohMigrateCtrl:reqKingdomSpecInviteList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_KINGDOM_SPEC_INVITE_LIST, nil)
end
function kohMigrateCtrl:reqKingdomSpecInviteListRsp(content)
	dump(content, "kohMigrateCtrl:reqKingdomSpecInviteListRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None and content.rspdata and next(content.rspdata) then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.data.privilegeInviteData = content.rspdata
	end
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST"
	SoraDSendMessage(content.rspdata)
end
function kohMigrateCtrl:reqGroupList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_GROUP_LIST, nil)
end
function kohMigrateCtrl:reqGroupListRsp(content)
	dump(content, "kohMigrateCtrl:reqGroupListRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, groupList = content.rspdata, content.rspdata
		end
		local _ENV, groupKidMap = gErrDef.Err_None, gErrDef.Err_None
		for __, kidList in ipairs(groupList) do
			for __, kid in ipairs(kidList) do
				groupKidMap[kid] = true
			end
		end
		self.groupKidMap = groupKidMap
		_ENV = ipairs(groupList)
		ipairs(groupList).msg = "MESSAGE_KOHMIGRATE_GROUPLIST"
		ipairs(groupList).data = content.rspdata
		SoraDSendMessage(ipairs(groupList))
	end
end
function kohMigrateCtrl:isGroupKidMapExist(...)
	return self.groupKidMap ~= nil
end
function kohMigrateCtrl:isGroupKid(kid)
	return self.groupKidMap and self.groupKidMap[kid]
end
function kohMigrateCtrl:reqEnterChatRoom()
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_ENTER_CHAT_ROOM)
end
function kohMigrateCtrl:reqEnterChatRoomRsp(content)
	dump(content, "kohMigrateCtrl:reqEnterChatRoomRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.channelID = content.rspdata.channelID
		self.notifyData.isEnterChatRoom = true
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_KOHMIGRATE_ENTER_CHATROOM"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function kohMigrateCtrl:reqT1PlayerRank(iBegin, nCount, kingdomId)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	local (nil).kingdomId, data = kingdomId, nil
	serverproxy:Request(gCmd.CMD_KOH_MIGRATE_MODULE, gCmd.REQ_KOH_MIGRATE_T1_PLAYER_RANK, data)
end
function kohMigrateCtrl:reqT1PlayerRankRsp(content)
	dump(content, "kohMigrateCtrl:reqT1PlayerRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_KOHMIGRATE_PLAYER_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function kohMigrateCtrl:getTodayApplySendCount()
	local n = 0
	for _, apply in ipairs(self.data.selfApplyList) do
		n = n + apply.sendCount
	end
	return n
end
function kohMigrateCtrl:getSelfApplyInfo(kid)
	local index = self.data.selfApplyListMap[kid]
	if index then
		return self.data.selfApplyList[index]
	end
end
function kohMigrateCtrl:checkApplySendTimeCD(kid)
	local apply = self:getSelfApplyInfo(kid)
	if apply then
		local constValue = self:getAcrossParam("across_applyCoolDown")
		local lefttime = constValue - (serviceFunctions.systemTime() - apply.sendTime)
		return lefttime <= 0
	end
	return true
end
function kohMigrateCtrl:checkApplyRejected(kid)
	local apply = self:getSelfApplyInfo(kid)
	if apply then
		return apply.status == gKohMigrateApplyMsgStatus.REJECTED
	end
end
function kohMigrateCtrl:checkApplyAccepted(kid)
	local apply = self:getSelfApplyInfo(kid)
	if apply then
		return apply.status == gKohMigrateApplyMsgStatus.ACCEPTED
	end
end
function kohMigrateCtrl:getKingdomDataByID(kingdomId)
	if not kingdomId then
		return self.data.selfKingdomData
	end
	local index = self.data.kingdomListMap[kingdomId]
	if index then
		return self.data.kingdomList[index]
	end
end
function kohMigrateCtrl:getInviteCDLeftTime(uid, isKingPrivilege)
	local time = 0
	if isKingPrivilege then
		local statusTime = 0
		for i, v in ipairs(self.data.privilegeInviteData) do
			if v.status and v.status == gKohMigrateInviteMsgStatus.WAIT and statusTime < v.statusTime then
				statusTime = v.statusTime
			end
		end
		if 0 < statusTime then
			local constValue = self:getAcrossParam("kingpower_invitation_CD")
			local lefttime = constValue - (serviceFunctions.systemTime() - statusTime)
			if 0 < lefttime then
				time = lefttime
			end
		end
		return time
	end
	return time
end
function kohMigrateCtrl:checkKingdomInviteTime(uid, isKingPrivilege)
	return self:getInviteCDLeftTime(uid, isKingPrivilege) <= 0
end
function kohMigrateCtrl:getMigrateCDLeftTime(...)
	local lastMigrateTime = self:getLastMigrateTime()
	if lastMigrateTime and 0 < lastMigrateTime then
		local constValue = self:getAcrossParam("across_move_cd")
		local lefttime = constValue - (serviceFunctions.systemTime() - lastMigrateTime)
		if 0 < lefttime then
			return lefttime
		end
	end
	return 0
end
function kohMigrateCtrl:getTodayApplySendCountLeft(...)
	local constValue = self:getAcrossParam("across_applydailyTimes")
	local leftcount = constValue - self:getTodayApplySendCount()
	return math.max(0, leftcount)
end
function kohMigrateCtrl:checkFlagPoint(data, isPrivilege)
	if data.setup.isCloseMoveIn then
		return false
	end
	local playerType = self:getMyPlayerType()
	if playerType == gKohMigratePlayerType.T1 then
		local canMoveInLegend = self:getCanMoveInLegend(data)
		local legend = self:getMyLegend() or 0
		if canMoveInLegend < legend then
			return false
		end
	elseif playerType == gKohMigratePlayerType.T2 then
		local canMoveInStrength = self:getCanMoveInStrength(data)
		local beginStrength = self:getBeginStrength()
		if canMoveInStrength < beginStrength then
			return false
		end
	elseif playerType == gKohMigratePlayerType.T3 then
	end
	if not isPrivilege and not data.isSpecInvited then
		local canMoveInCount = self:getCanMoveInCount(data, playerType)
		if canMoveInCount <= 0 then
			return false
		end
	end
	return true
end
function kohMigrateCtrl:getCurKingdomStrength(data)
	if not data.tier[2] then
		_UPVALUE0_ = data.tier[2]
		data.tier[2].moveInStrength = 0
		local data.tier[2].moveOutStrength, tier = 0, data.tier[2]
	end
	local curkingdomStrength = data.beginKingdomStrength + tier.moveInStrength - tier.moveOutStrength
	return curkingdomStrength
end
function kohMigrateCtrl:getCanMoveInStrength(data)
	local kid = data.kid
	local kingdomStrengthLimit = kohMigrateRead.getKingdom_powerlimit(kid)
	local curkingdomStrength = self:getCurKingdomStrength(data)
	local canMoveInStrength = math.max(0, kingdomStrengthLimit - curkingdomStrength)
	return canMoveInStrength
end
function kohMigrateCtrl:getCurKingdomLegend(data)
	if not data.tier[1] then
		kohMigrateRead = data.tier[1]
		data.tier[1].moveInLegend = 0
		local data.tier[1].moveOutLegend, tier = 0, data.tier[1]
	end
	local kid = data.kid
	local beginLegend = kohMigrateRead.getKingdmBeginLegend(kid)
	local curkingdomLegend = beginLegend + tier.moveInLegend - tier.moveOutLegend
	return curkingdomLegend
end
function kohMigrateCtrl:getCanMoveInLegend(data)
	local kid = data.kid
	local legendlimit = kohMigrateRead.getKingdom_legendlimit(kid)
	local curkingdomLegend = self:getCurKingdomLegend(data)
	local canMoveInLegend = math.max(0, legendlimit - curkingdomLegend)
	return canMoveInLegend
end
function kohMigrateCtrl:getCanMoveInCount(data, playerType)
	if playerType == gKohMigratePlayerType.T1 then
		return self:getCanMoveInCountT1(data)
	elseif playerType == gKohMigratePlayerType.T2 then
		return self:getCanMoveInCountT2(data)
	elseif playerType == gKohMigratePlayerType.T3 then
		return self:getCanMoveInCountT3(data)
	end
	return 0
end
function kohMigrateCtrl:getCanMoveInCountT1(data)
	local kid = data.kid
	local maxNum = kohMigrateRead.getKingdom_legendplayer(data.kid)
	if not data.tier[gKohMigratePlayerType.T1] then
		kohMigrateRead = data.tier[gKohMigratePlayerType.T1]
		data.tier[gKohMigratePlayerType.T1].moveInCount = 0
		local data.tier[gKohMigratePlayerType.T1].moveOutCount, tier = 0, data.tier[gKohMigratePlayerType.T1]
	end
	local num = maxNum - tier.moveInCount
	return math.max(0, num)
end
function kohMigrateCtrl:getCanMoveInCountT2(data)
	local kid = data.kid
	local maxNum = kohMigrateRead.getKingdom_highplayer(data.kid)
	if not data.tier[gKohMigratePlayerType.T2] then
		kohMigrateRead = data.tier[gKohMigratePlayerType.T2]
		data.tier[gKohMigratePlayerType.T2].moveInCount = 0
		local data.tier[gKohMigratePlayerType.T2].moveOutCount, tier = 0, data.tier[gKohMigratePlayerType.T2]
	end
	local num = maxNum - tier.moveInCount
	return math.max(0, num)
end
function kohMigrateCtrl:getCanMoveInCountT3(data)
	local kid = data.kid
	local maxNum = kohMigrateRead.getKingdom_lowplayer(data.kid)
	if not data.tier[gKohMigratePlayerType.T3] then
		kohMigrateRead = data.tier[gKohMigratePlayerType.T3]
		data.tier[gKohMigratePlayerType.T3].moveInCount = 0
		local data.tier[gKohMigratePlayerType.T3].moveOutCount, tier = 0, data.tier[gKohMigratePlayerType.T3]
	end
	local num = maxNum - tier.moveInCount
	return math.max(0, num)
end
function kohMigrateCtrl:isShowPrivilegeBtn(...)
	local lastKingUid = worldMapDefine.lastKingUid
	if lastKingUid then
		local selfPlayerID = gametop.playertop_:getPlayerID()
		return lastKingUid == selfPlayerID
	end
end
function kohMigrateCtrl:getAcrossParam(key, defaultValue)
	return kohMigrateRead.getConstValue(key, defaultValue)
end
function kohMigrateCtrl:getAcrossConstantArray(key, defaultValue)
	return kohMigrateRead.getConstArray(key, defaultValue)
end
function kohMigrateCtrl:getLvLimit(...)
	return self:getAcrossParam("across_move_lv")
end
function kohMigrateCtrl:getKingInviteNumMax(...)
	local selfKid = gametop.playertop_:getKingdomID()
	local inviteplayer = kohMigrateRead.getKingdom_inviteplayer(selfKid)
	return inviteplayer
end
function kohMigrateCtrl:getKingInviteNum(...)
	return #self.data.privilegeInviteData
end
function kohMigrateCtrl:checkKingInviteNum(...)
	return self:getKingInviteNum() < self:getKingInviteNumMax()
end
function kohMigrateCtrl:isPrivilegeOpen()
	return self:getKingInviteNumMax() > 0
end
function kohMigrateCtrl:getSetup(...)
	return self.data.selfKingdomData.setup
end
function kohMigrateCtrl:getPrivilegeInviteData()
	return self.data.privilegeInviteData
end
function kohMigrateCtrl:checkPlayerHasInvite(uid)
	for i, v in ipairs(self.data.privilegeInviteData) do
		if v.uid == uid then
			return i
		end
	end
end
function kohMigrateCtrl:getExtraApplyList()
	return self.data.extraApplyList
end
function kohMigrateCtrl:getMobilityList()
	return self.data.mobilityList
end
function kohMigrateCtrl:getKingdomList()
	return self.data.kingdomList
end
function kohMigrateCtrl:getSelfApplyList()
	return self.data.selfApplyList
end
function kohMigrateCtrl:getItemCost()
	local strength = self:getBeginStrength()
	local consume_min_num = self:getAcrossParam("consume_min_num")
	local consume_max_num = self:getAcrossParam("consume_max_num")
	local costNum = kohMigrateRead.getMigrateCost(strength, self:getKingdomClassType())
	local special_uid = self:getAcrossParam("legendary_king_special_uid")
	if special_uid and special_uid == gametop.playertop_:getPlayerID() then
		local special_cost = self:getAcrossParam("legendary_king_special_cost")
		if special_cost then
			costNum = special_cost
		end
	end
	if consume_min_num > costNum then
		costNum = consume_min_num
	end
	if consume_max_num < costNum then
		costNum = consume_max_num
	end
	return costNum
end
function kohMigrateCtrl:getChannelID(...)
	return self.channelID or 0
end
function kohMigrateCtrl:getIsEnterChatRoom(...)
	return self.notifyData.isEnterChatRoom
end
function kohMigrateCtrl:getHighStrength(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(self.activityID)
	return param.highStrength or 0
end
function kohMigrateCtrl:getMyLegend(...)
	local selfUid = gametop.playertop_:getPlayerID()
	local legend = kohMigrateRead.getPlayerLegend(selfUid)
	return legend
end
function kohMigrateCtrl:getMyPlayerType(...)
	if self:getMyLegend() then
		return gKohMigratePlayerType.T1
	end
	local beginStrength = self:getBeginStrength()
	local highStrength = self:getHighStrength()
	if beginStrength > highStrength then
		return gKohMigratePlayerType.T2
	else
		return gKohMigratePlayerType.T3
	end
end
function kohMigrateCtrl:getKingdomClassType(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(self.activityID)
	return classType
end
function kohMigrateCtrl:getKingdomListState(index)
	return self.kingdomListState and self.kingdomListState[index] or false
end
function kohMigrateCtrl:setKingdomListState(index, state)
	if not self.kingdomListState then
		self.kingdomListState, _UPVALUE0_ = self.kingdomListState, self.kingdomListState
	end
	self.kingdomListState[index] = state
end
function kohMigrateCtrl:getKingdomClassMax()
	if not self:getAcrossConstantArray("kingdom_group") then
		local _UPVALUE0_, kingdom_group = self:getAcrossConstantArray("kingdom_group"), self:getAcrossConstantArray("kingdom_group")
	end
	return #kingdom_group
end
return kohMigrateCtrl
