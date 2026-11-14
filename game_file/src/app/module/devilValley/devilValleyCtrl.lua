local GameModule = include("GameModule")
local devilValleyCtrl = class("devilValleyCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local activityID = gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY
_ENV = nil
;(nil).WAR_DATA = 1
;(nil).OCCUPY_ALLIANCE_CHANGE = 2
local _ENV, (nil).PLAYER_QUIT, DVW_MSG_TYPE = nil, 3, nil
;(nil).END_TIME = 1
;(nil).MANUAL_QUIT = 2
local (nil).CITY_WALL_DF_ZERO, DVW_PLAYER_QUIT_REASON = 3, nil
function devilValleyCtrl:ctor(properties)
	devilValleyCtrl.super.ctor(self, properties)
end
function devilValleyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_CREATE_TEAM, handler(self, self.sendReqCreateTeamRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_JOIN_TEAM, handler(self, self.sendReqJoinTeamRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_LEAVE_TEAM, handler(self, self.sendReqLeaveTeamRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_KICKOUT_TEAM, handler(self, self.sendReqKickoutTeamRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_DISBAND_TEAM, handler(self, self.sendReqDissolveTeamRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_TEAM_LIST, handler(self, self.sendReqTeamListRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_FAST_JOIN, handler(self, self.sendReqFastJoinRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_START_CHALLENGE, handler(self, self.sendReqStartChallengeRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_EXCHANGE, handler(self, self.sendReqExchangeRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_SHARE_CHAT, handler(self, self.sendReqShareChatRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_SEND_CHAT_CHANNEL, handler(self, self.sendReqSendChatRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_GET_CHAT_MESSAGE, handler(self, self.sendReqGetChatRsp))
	msgCtrl.register(gCmd.CMD_RANKINGS_MODULE, gCmd.REQ_DVWAR_RANK_LIST, handler(self, self.sendReqRankListRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_END_CHALLENGE, handler(self, self.sendReqEndChallengeRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_INIT_INFO, handler(self, self.sendReqInitInfoRsp))
	msgCtrl.register(gCmd.CMD_DEVIL_VALLEY_MODULE, gCmd.REQ_DEVIL_VALLEY_RECEIVE, handler(self, self.sendReqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_DVW_MGR_MODULE, gCmd.REQ_DVW_DATA, handler(self, self.sendDevilValleyWarDataRsp))
	self:resetData()
end
function devilValleyCtrl:resetData()
	self.handle_notify1 = nil
	self.challengeLv = 1
	self.teamInfo = nil
	self.todayRecords = nil
	self.teamListInfo, _ENV, self.todayReceive = nil, nil, nil
	self.shopInfo, _ENV, self.isJoinTooLate = nil, nil, false
	self.selfRankInfo, _ENV, self.rankInfoList, _ENV, self.chatContent, _ENV, self.point = nil, nil, nil, nil, nil, nil, 0
	self.showStart = false
	self.showCountDown = false
	self.showResult = false
	self.beginHour = 0
	self.endHour = 0
	self.warStatus = gKingdomWarStatusType.rule
	self.warTotalTime = 0
	self.warStartTime = 0
end
function devilValleyCtrl:Logout()
	self:resetData()
	devilValleyCtrl.super.Logout(self)
end
function devilValleyCtrl:initClientData(data)
	if not data then
		return
	end
	self:registerNotify()
	self:setDevilValleyData(data, true)
	if worldMapDefine.isInNewTrial() then
		self:sendDevilValleyWarData()
	end
end
function devilValleyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify1 = notifyCtrl:register(gNotifyID.TEAM_UPDATE, handler(self, self.notifyHandler))
	notifyCtrl:register(gNotifyID.DVW, handler(self, self.onMsg))
end
function devilValleyCtrl:onMsg(event)
	local data = event.data
	dump(data, "devilValleyCtrl:onMsg", 10)
	if data then
		for _, msg in pairs(data) do
			local msgType = msg.msgType
			if msgType == DVW_MSG_TYPE.WAR_DATA then
				self:onUpdateNpc(msg)
			elseif msgType == DVW_MSG_TYPE.OCCUPY_ALLIANCE_CHANGE then
				self:onPlaceOccupyAllianceChange(msg)
			elseif msgType == DVW_MSG_TYPE.PLAYER_QUIT then
				self:onPlayerQuit(msg)
			end
		end
	end
end
function devilValleyCtrl:notifyHandler(event)
	if event and event.data then
		dump(event.data, "devilValleyCtrl:notifyHandler")
		local beforeStart = self.teamInfo and self.teamInfo.start
		for _, content in ipairs(event.data) do
			local pointAdd = 0
			local teamInfo = content.teamInfo
			if teamInfo and teamInfo.teamWin then
				local point = content.point or 0
				pointAdd = math.max(point - self.point, 0)
			end
			self:setDevilValleyData(content)
			if content.selfLose or teamInfo and teamInfo.teamWin ~= nil then
				self.showResult = true
				local data = self:getResultData(content, pointAdd)
				_ENV = content
				content.msg = "MESSAGE_NEWTRIAL_END_REFRESH"
				content.data = data
				SoraDSendMessage(content)
			end
		end
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_NEWTRIAL_REFRESH_AWARD"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_NEWTRIAL_TEAM_REFRESH"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_UI_NEWTRIALMAINUI"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_NEWTRIAL_STORE_REFRESH"
		SoraDSendMessage(ipairs(event.data))
		if beforeStart == false and self.teamInfo.start == true then
			_ENV = ipairs(event.data)
			ipairs(event.data).msg = "MESSAGE_NEWTRIAL_BEGIN_REFRESH"
			SoraDSendMessage(ipairs(event.data))
		end
	end
end
function devilValleyCtrl:getReceiveStatusAndNum()
	local num = 0
	for i = 1, self.challengeLv do
		local isLock = not self:checkIsUnLock(i)
		local isGet = self:checkIsGet(i)
		local isGetAward = self:checkIsGetAward(i)
		if not isLock and isGet and not isGetAward then
			num = num + 1
		end
	end
	return 0 < num, num
end
function devilValleyCtrl:getResultData(content, pointAdd)
	local teamInfo = content.teamInfo
	local rtype
	if content.selfLose or teamInfo.teamWin == false then
		rtype = 2
	else
		rtype = 1
	end
	_ENV = teamInfo.teamWin
	teamInfo.teamWin.rtype = rtype
	local teamInfo.teamWin.costTime, data = teamInfo.costTime, teamInfo.teamWin
	if teamInfo and next(teamInfo) then
		local _ENV, players = next(teamInfo), next(teamInfo)
		local mvp = 1
		local mvpKill = 0
		if not teamInfo.challengeMember then
			_ENV = teamInfo.challengeMember
		end
		for i, uid in ipairs(teamInfo.challengeMember) do
			local _ENV, kill = tostring(uid), teamInfo.memberDevInfo[tostring(uid)] and teamInfo.memberDevInfo[tostring(uid)].totalKillCount or 0
			tostring(uid).name = teamInfo.playerInfo[tostring(uid)] and teamInfo.playerInfo[tostring(uid)].nickname or ""
			local tostring(uid).kill, player = kill, tostring(uid)
			table.insert(players, player)
			if mvpKill < kill then
				mvpKill = kill
				mvp = i
			end
		end
		_ENV = (for generator)
		ipairs(teamInfo.challengeMember).rtype = rtype
		ipairs(teamInfo.challengeMember).costTime = teamInfo.costTime
		ipairs(teamInfo.challengeMember).score = pointAdd
		ipairs(teamInfo.challengeMember).players = players
		data, ipairs(teamInfo.challengeMember).challengeLv = ipairs(teamInfo.challengeMember)
		if mvp and 0 < mvpKill then
			data.mvp = mvp
		end
	end
	return data
end
function devilValleyCtrl:setDevilValleyData(devilValleyData, isInit)
	if devilValleyData then
		if devilValleyData.teamInfo then
			self.teamInfo = devilValleyData.teamInfo
			self:updateKingdomClass()
		end
		if devilValleyData.challengeLv then
			self.challengeLv = devilValleyData.challengeLv
		end
		if devilValleyData.todayRecords then
			self.todayRecords = devilValleyData.todayRecords
			if not isInit then
				_ENV = self
				self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				self.eventID = activityID
				SoraDSendMessage(self)
			end
		end
		if devilValleyData.todayReceive then
			self.todayReceive = devilValleyData.todayReceive
			if not isInit then
				_ENV = self
				self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				self.eventID = activityID
				SoraDSendMessage(self)
			end
		end
		if devilValleyData.shopInfo then
			self.shopInfo = devilValleyData.shopInfo
			self:sortShopInfo()
		end
		if devilValleyData.point then
			self.point = devilValleyData.point
		end
		if devilValleyData.beginHour and devilValleyData.endHour then
			self.beginHour = devilValleyData.beginHour
			self.endHour = devilValleyData.endHour
		end
	end
end
function devilValleyCtrl:updateKingdomClass()
	print("updateKingdomClass")
end
function devilValleyCtrl:getWarStatus()
	return self.warStatus
end
function devilValleyCtrl:isOpen()
	return self.warStatus ~= gKingdomWarStatusType.rule
end
function devilValleyCtrl:isInClose()
	return self.warStatus == gKingdomWarStatusType.close
end
function devilValleyCtrl:isInWar()
	return self.warStatus == gKingdomWarStatusType.inWar
end
function devilValleyCtrl:getWarBeginTime()
	local sysTime = serviceFunctions.systemTime()
	if sysTime > self.warStartTime then
		return sysTime - self.warStartTime
	end
	return 0
end
function devilValleyCtrl:getStatusTime()
	if self.warStatus == gKingdomWarStatusType.inWar then
		local sysTime = serviceFunctions.systemTime()
		local endTime = self.warStartTime + self.warTotalTime
		if sysTime < endTime then
			return endTime - sysTime
		end
	elseif self.warStatus == gKingdomWarStatusType.close then
		local sysTime = serviceFunctions.systemTime()
		if sysTime < self.warStartTime then
			return self.warStartTime - sysTime
		end
	end
	return 0
end
function devilValleyCtrl:getDevilValleyWarData()
	if not self.devilValleyWarData or not next(self.devilValleyWarData) then
		_ENV = next(self.devilValleyWarData)
		next(self.devilValleyWarData).dvwCastleHP = 0
		self.devilValleyWarData, next(self.devilValleyWarData).dvwCastleDF = next(self.devilValleyWarData), 0
	end
	return self.devilValleyWarData
end
function devilValleyCtrl:onPlaceOccupyAllianceChange(msg)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onPlaceOccupyAllianceChange(msg)
	gametop = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED"
	SoraDSendMessage(kingdomMapCtrl)
end
function devilValleyCtrl:onPlayerQuit(msg)
	if msg.reason then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local playerId = lordInfoCtrl:getLordInfo().base.uid
		if playerId ~= msg.uid then
			if msg.reason == DVW_PLAYER_QUIT_REASON.MANUAL_QUIT then
				gametop = nil
				;(nil).string = msg.name
				gametop = msg.name
				msg.name.mulit = true
				SoraDShowMsgTip(i18n("devilvalley_text_52", nil), nil, nil, msg.name)
			elseif msg.reason == DVW_PLAYER_QUIT_REASON.CITY_WALL_DF_ZERO then
				gametop = nil
				;(nil).string = msg.name
				gametop = msg.name
				msg.name.mulit = true
				SoraDShowMsgTip(i18n("devilvalley_text_53", nil), nil, nil, msg.name)
			end
		end
	end
end
function devilValleyCtrl:onUpdateNpc(msg)
	dump(msg, "devilValleyCtrl:onUpdatePoints(msg)", 10)
	local npcData = msg.data
	self:onUpdateNpcData(npcData)
end
function devilValleyCtrl:onUpdateNpcData(npcData)
