local GameModule = include("GameModule")
local partyCtrl = class("partyCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function partyCtrl:ctor(properties)
	partyCtrl.super.ctor(self, properties)
end
function partyCtrl:EnterGame()
	partyCtrl = nil
	;(nil).REQ_PARTY_OPEN_PARTY = "1"
	;(nil).REQ_PARTY_INVITE = "2"
	;(nil).REQ_PARTY_ATTEND_PARTY = "3"
	;(nil).REQ_PARTY_FINISH_PARTY = "4"
	;(nil).REQ_PARTY_RECEIVE_OPEN_REWARD = "5"
	;(nil).REQ_PARTY_RECEIVE_ATTEND_REWARD = "6"
	;(nil).REQ_PARTY_CHECK_PARTY_CENTER = "7"
	;(nil).REQ_PARTY_COMMIT_MATERIAL = "8"
	;(nil).REQ_PARTY_ATTACK_BANDIT = "9"
	;(nil).REQ_PARTY_REMOVE_TIRED = "10"
	;(nil).REQ_PARTY_RECEIVE_POINT_REWARD = "11"
	;(nil).REQ_PARTY_POINT_RANK = "12"
	;(nil).REQ_PARTY_GET_ONE_PARTY_INFO = "13"
	local (nil).REQ_PARTY_GET_USER_PARTY_LIST, cmdList = "14", nil
	partyCtrl.super.autoRegister(self, gCmd.CMD_PARTY_MODULE, cmdList)
	self:registerNotify()
end
function partyCtrl:initClientData(data)
	self.partyData = data
	dump(data, "initpartyData", 5)
end
function partyCtrl:resetData()
end
function partyCtrl:clearAlonePartyData()
	self.alonePartyInfo = nil
end
function partyCtrl:getAlonePartyData()
	return self.alonePartyInfo
end
function partyCtrl:getPartyData()
	return self.partyData
end
function partyCtrl:getPartyCenterData()
	if not self.partyCenterData then
		_UPVALUE0_ = self.partyCenterData
	end
	return self.partyCenterData
end
function partyCtrl:getPartyUserData()
	if not self.partyUserData then
		_UPVALUE0_ = self.partyUserData
	end
	return self.partyUserData
end
function partyCtrl:removePartyCenter(partyID)
	local isFind = false
	if self.alonePartyInfo and self.alonePartyInfo.partyID == partyID then
		self.alonePartyInfo = nil
		isFind = true
	end
	local _ENV, newData = self.alonePartyInfo.partyID, self.alonePartyInfo.partyID
	if self.partyCenterData and next(self.partyCenterData) then
		for k, v in pairs(self.partyCenterData) do
			if v.partyID ~= partyID then
				table.insert(newData, v)
			else
				self.partyCenterData[k] = nil
				isFind = true
			end
		end
	end
	if isFind then
		self.partyCenterData = newData
		_ENV = pairs(self.partyCenterData)
		pairs(self.partyCenterData).msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
		pairs(self.partyCenterData).isAlready = false
		SoraDSendMessage(pairs(self.partyCenterData))
	end
end
function partyCtrl:updatePartyUserData(attendPartyInfo, isAlone)
	local isAlone = isAlone or false
	local isFind = false
	if isAlone then
		self.alonePartyInfo = attendPartyInfo
		isFind = true
	end
	if self.partyUserData and next(self.partyUserData) then
		for k, v in pairs(self.partyUserData) do
			if v.partyID == attendPartyInfo.partyID then
				self.partyUserData[k] = attendPartyInfo
				isFind = true
				break
			end
		end
	end
	if isFind then
		_ENV = pairs(self.partyUserData)
		pairs(self.partyUserData).msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
		pairs(self.partyUserData).isAlready = true
		SoraDSendMessage(pairs(self.partyUserData))
	end
end
function partyCtrl:updatePartyCenterData(attendPartyInfo, isAlone)
	local isAlone = isAlone or false
	local isFind = false
	if isAlone then
		self.alonePartyInfo = attendPartyInfo
		isFind = true
	end
	if self.partyCenterData and next(self.partyCenterData) then
		for k, v in pairs(self.partyCenterData) do
			if v.partyID == attendPartyInfo.partyID then
				self.partyCenterData[k] = attendPartyInfo
				isFind = true
				break
			end
		end
	end
	if isFind then
		_ENV = pairs(self.partyCenterData)
		pairs(self.partyCenterData).msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
		pairs(self.partyCenterData).isAlready = false
		SoraDSendMessage(pairs(self.partyCenterData))
	end
end
function partyCtrl:Logout()
	self:resetData()
	partyCtrl.super.Logout(self)
end
function partyCtrl:notifyCallback(event)
	dump(event.data, "partyCtrl:notifyCallback", 10)
	local content = event.data[1]
	self:setPartyData(content)
end
function partyCtrl:checkPartyEventTirger(newData)
	if self.partyData.isTired == false and newData.isTired == true then
		return true
	end
	if newData.myAttendPartyList and not self.partyData.myAttendPartyList then
		return true
	end
	return false
end
function partyCtrl:setPartyData(partyData)
	self.partyData = partyData
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_PARTYDATA_REFRESH"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
	SoraDSendMessage(nil)
end
function partyCtrl:onReceiveRewardData(rspdata)
	if rspdata.commonReward then
		local partyInfo = rspdata.attendPartyInfo
		_ENV = nil
		;(nil).commonReward = rspdata.commonReward
		;(nil).eventReward = rspdata.eventReward
		;(nil).feastInfo = partyInfo
		local (nil).attackBanditResult, info = rspdata.attackBanditResult, nil
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_PARTY_SHOWREWARD"
		;(nil).reward = info
		SoraDSendMessage(nil)
	end
end
function partyCtrl:sendOpenParty(partyLv)
	print("sendOpenParty", partyLv)
	_ENV = nil
	;(nil).partyLv = partyLv
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_OPEN_PARTY, nil)
end
function partyCtrl:sendGetOpenPartyRewards(partyID)
	print("sendGetOpenPartyRewards", partyID)
	_ENV = nil
	;(nil).partyID = partyID
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_RECEIVE_OPEN_REWARD, nil)
end
function partyCtrl:sendGetAttendPartyRewards(partyID)
	print("sendGetAttendPartyRewards", partyID)
	_ENV = nil
	;(nil).partyID = partyID
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_RECEIVE_ATTEND_REWARD, nil)
end
function partyCtrl:sendAttendParty(partyId, location)
	print("sendAttendParty", partyId, location)
	_ENV = nil
	;(nil).partyID = partyId
	;(nil).location = location
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_ATTEND_PARTY, nil)
end
function partyCtrl:sendCheckPartyCenter()
	print("sendCheckPartyCenter")
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_CHECK_PARTY_CENTER)
end
function partyCtrl:sendReceivePointReward(point)
	print("sendReceivePointReward", point)
	_ENV = nil
	;(nil).point = point
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_RECEIVE_POINT_REWARD, nil)
end
function partyCtrl:sendFinishParty()
	print("sendFinishParty")
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_FINISH_PARTY)
end
function partyCtrl:sendCommitMaterial(reject, partyID)
	print("sendCommitMaterial")
	_ENV = nil
	;(nil).reject = reject
	;(nil).partyID = partyID
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_COMMIT_MATERIAL, nil)
end
function partyCtrl:sendAttackBandit(reject, partyID, soldiers, heroInfo, armsInfo, divineBeastInfo)
	if reject then
		serverproxy = nil
		;(nil).reject = reject
		;(nil).partyID = partyID
		serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_ATTACK_BANDIT, nil)
		return
	end
	print("sendAttackBandit")
	local hero
	if next(heroInfo) then
		hero, serverproxy = next(heroInfo), next(heroInfo)
		for k, v in ipairs(heroInfo) do
			serverproxy = nil
			;(nil).heroID = v
			table.insert(hero, nil)
		end
	end
	serverproxy = nil
	;(nil).reject = reject
	;(nil).partyID = partyID
	;(nil).soldiers = soldiers
	;(nil).heroInfo = hero
	;(nil).armsInfo = armsInfo
	;(nil).divineBeastInfo = divineBeastInfo
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_ATTACK_BANDIT, nil)
end
function partyCtrl:sendRemoveTired()
	print("sendRemoveTired")
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_REMOVE_TIRED)
end
function partyCtrl:sendGetOnePartyInfo(partyID)
	print("sendGetOnePartyInfo")
	_ENV = nil
	;(nil).partyID = tostring(partyID)
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_GET_ONE_PARTY_INFO, nil)
end
function partyCtrl:sendPartyUserList()
	print("sendPartyUserList")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_GET_USER_PARTY_LIST, nil)
end
function partyCtrl:sendInviteParty(shareKingdom, shareAlliance)
	print("sendInviteParty", shareKingdom, shareAlliance)
	local shareType
	if shareKingdom and shareAlliance then
		shareType = gPartyShareType.SHARE_ALL_CHAT
	elseif shareAlliance then
		shareType = gPartyShareType.SHARE_ALLIANCE_CHAT
	elseif shareKingdom then
		shareType = gPartyShareType.SHARE_KINGDOM_CHAT
	end
	_ENV = nil
	;(nil).inviteShareType = shareType
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_INVITE, nil)
end
function partyCtrl:sendPointRank(index, ...)
	local startIndex = index or 1
	serverproxy = nil
	;(nil).startIndex = startIndex
	serverproxy:Request(gCmd.CMD_PARTY_MODULE, gCmd.REQ_PARTY_POINT_RANK, nil)
end
function partyCtrl:sendReqPartyInvite(content)
	if gErrDef.Err_None == content.err then
		SoraDShowMsgTip(i18n("notice_0103"))
	end
end
function partyCtrl:sendReqPartyOpenParty(content)
	if gErrDef.Err_None == content.err then
		self:setPartyData(content.rspdata.partyData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_PARTY_OPENBACK"
		SoraDSendMessage(self)
	else
		if gErrDef.Err_PARTY_CAN_NOT_SEAT == content.err then
		else
		end
	end
end
function partyCtrl:sendReqPartyReceiveOpenReward(content)
	if gErrDef.Err_None == content.err then
		local _ENV, tTbl = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(content.rspdata.reward) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
		if self.partyData.myOpenParty then
			self.partyData.myOpenParty = nil
		end
	end
	_ENV = self.partyData
	self.partyData.msg = "MESSAGE_SERVER_EVENTCENTER_PARTYDATA_REFRESH"
	SoraDSendMessage(self.partyData)
end
function partyCtrl:sendReqPartyReceiveAttendReward(content)
	dump(content, "sendReqPartyReceiveAttendReward", 5)
	if gErrDef.Err_None == content.err then
		local _ENV, tTbl = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(content.rspdata.reward) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_EVENTCENTER_PARTYDATA_REFRESH"
	SoraDSendMessage(SoraDMailGainItems)
end
function partyCtrl:sendReqPartyCheckPartyCenter(content)
	dump(content, "sendReqPartyCheckPartyCenter", 5)
	if gErrDef.Err_None == content.err then
		self.partyCenterData = content.rspdata.partyCenterData
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
		content.err.isAlready = false
		SoraDSendMessage(content.err)
	end
end
function partyCtrl:sendReqPartyAttendParty(content)
	dump(content, "sendReqPartyAttendParty", 20)
	local partyChange
	if gErrDef.Err_None == content.err then
		if content.rspdata.partyData then
			for i, v in ipairs(content.rspdata.partyData.myAttendPartyList) do
				if v.partyID == content.data.partyID then
					partyChange = v
					break
				end
			end
			self:setPartyData(content.rspdata.partyData)
			local partyInfo = content.rspdata.attendPartyInfo
			_ENV = self
			self.commonReward = content.rspdata.commonReward
			self.eventReward = content.rspdata.eventReward
			self.feastInfo = partyInfo
			local self.attackBanditResult, info = content.rspdata.attackBanditResult, self
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_PARTY_EVENT_TRIGGER"
			;(nil).totalInfo = info
			SoraDSendMessage(nil)
		end
	elseif gErrDef.Err_PARTY_LIMIT_COUNT == content.err or gErrDef.Err_PARTY_PARTY_IS_END == content.err then
	elseif gErrDef.Err_PARTY_IN_TIRED == content.err then
		SoraDShowMsgTip(i18n("feast_tips_15"))
	elseif gErrDef.Err_PARTY_OPEN_PARTY_SPECIAL_NOT_END == content.err then
		SoraDShowMsgTip(i18n("feast_tips_17"))
	elseif gErrDef.Err_PARTY_NOT_ENOUGH_COUNT == content.err then
		SoraDShowMsgTip(i18n("feast_tips_02"))
	end
	if partyChange then
		self:updatePartyCenterData(partyChange)
		self:updatePartyUserData(partyChange)
	end
end
function partyCtrl:sendReqPartyPointRank(content)
	if gErrDef.Err_None == content.err then
		local _ENV, data = gErrDef.Err_None, gErrDef.Err_None
		data.data = content.rspdata.rankData
		if content.rspdata.myRankInfo then
			data.league = content.rspdata.myRankInfo.rank or 0
			data.ranking = content.rspdata.myRankInfo.score or 0
		end
		data.newStartIndex = content.rspdata.newStartIndex or 0
		data.bCanContinueGet = content.rspdata.bCanContinueGet or false
		data.requestRepeat = true
		_ENV = nil
		;(nil).msg = "MESSAGE_RANKINGS_SUCCESS"
		;(nil).rank = data
		SoraDSendMessage(nil)
	end
end
function partyCtrl:sendReqPartyFinishParty(content)
	if gErrDef.Err_None == content.err then
		_ENV = content.err
		content.err.msg = "MESSAGE_SERVER_EVENTCENTER_PARTYDATA_REFRESH"
		SoraDSendMessage(content.err)
	end
end
function partyCtrl:sendReqPartyCommitMaterial(content)
	dump(content, "sendReqPartyCommitMaterial", 20)
	if gErrDef.Err_None == content.err then
		self:setPartyData(content.rspdata.partyData)
		self:onReceiveRewardData(content.rspdata)
		if content.rspdata.attendPartyInfo then
			self:updatePartyCenterData(content.rspdata.attendPartyInfo)
		end
	elseif gErrDef.Err_PARTY_MATERIAL_NOT_ENOUGH == content.err then
		SoraDShowMsgTip(i18n("common_text_1379"))
	end
end
function partyCtrl:sendReqPartyAttackBandit(content)
	dump(content, "sendReqPartyAttackBandit", 20)
	if gErrDef.Err_None == content.err then
		self:setPartyData(content.rspdata.partyData)
		self:onReceiveRewardData(content.rspdata)
		if content.rspdata.attendPartyInfo then
			self:updatePartyCenterData(content.rspdata.attendPartyInfo)
		end
	end
end
function partyCtrl:sendReqPartyReceivePointReward(content)
	if gErrDef.Err_None == content.err then
		self:setPartyData(content.rspdata.partyData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_CLOSE_SCORETIPS"
		SoraDSendMessage(self)
		local reward = content.rspdata.reward
		local _ENV, itemList = self, self
		for _, v in ipairs(reward) do
			itemList[v.id] = v.count
		end
		SoraDMailGainItems(itemList)
	end
end
function partyCtrl:sendReqPartyGetOnePartyInfo(content)
	dump(content, "sendReqPartyGetOnePartyInfo", 5)
	SoraDCloseLoading()
	if gErrDef.Err_None == content.err then
		local partyData = self:getPartyData()
		local timeCtrl = gametop.playertop_:getModule("timeCtrl")
		local partyltCtrl = include("partyltCtrl")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local ownUUID = lordInfoCtrl:getLordInfo().base.uid
		if ownUUID ~= content.rspdata.onePartyData.hostUid and partyData.isTired and timeCtrl:getServerTime() < partyData.tiredEndtime then
			_ENV = partyData.tiredEndtime
			_ENV = "feast_text_33"
			;("feast_text_33").timeHandler = partyltCtrl.getLeftTiredTime
			;("feast_text_33").goldHandler = partyltCtrl.getLeftTiredGold
			;("feast_text_33").isBySelf = false
			SoraDShowSpeedUpBox(partyData.tiredEndtime, function(exitType)
				if exitType == MSGBOX_CALLBACK_SPEEDUP then
					self:sendRemoveTired()
				end
			end, i18n("feast_text_33"), "feast_text_33")
			return
		end
		self:updatePartyCenterData(content.rspdata.onePartyData, true)
		local panel = SoraDCreatePanel("partyFeastListView")
		panel:initData(content.rspdata.onePartyData.partyID)
		panel:show()
	end
end
function partyCtrl:sendReqPartyGetUserPartyList(content)
	if gErrDef.Err_None == content.err then
		local _ENV, userData = gErrDef.Err_None, gErrDef.Err_None
		local timeCtrl = gametop.playertop_:getModule("timeCtrl")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local ownUUID = lordInfoCtrl:getLordInfo().base.uid
		for i, v in ipairs(content.rspdata.partyList) do
			if ownUUID ~= v.hostUid then
				v.state = 0
				if not v.isReward and not v.isEnd then
					if v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_MATERIAL or v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_BANDIT then
						v.state = 1
					elseif v.uidListInfo[tostring(ownUUID)].sEvent > 3 or v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_TIRED then
						v.state = 2
					elseif v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.NO_EVENT then
						v.state = 3
					end
				elseif not v.isReward and v.isEnd then
					v.state = 4
				elseif v.isReward and not v.isEnd then
					if v.uidListInfo[tostring(ownUUID)].sEvent > 3 or v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.EVENT_TIRED then
						v.state = 5
					elseif v.uidListInfo[tostring(ownUUID)].sEvent == gSpecialEventType.NO_EVENT then
						v.state = 6
					end
				elseif v.isReward and v.isEnd then
					v.state = 7
				end
				table.insert(userData, v)
			end
		end
		table.sort(userData, function(l, r)
			return l.state < r.state
		end)
		self.partyUserData = userData
		_ENV = userData
		userData.msg = "MESSAGE_SERVER_EVENTCENTER_PARTYCENTER_REFRESH"
		userData.isAlready = true
		SoraDSendMessage(userData)
	end
end
function partyCtrl:sendReqPartyRemoveTired(content)
	dump(content, "sendReqPartyRemoveTired", 5)
	if gErrDef.Err_None == content.err then
		SoraDShowMsgTip(i18n("feast_tips_18"))
		self:setPartyData(content.rspdata.partyData)
	elseif err == gErrDef.Err_PARTY_PARTY_IS_END then
		SoraDShowMsgTip(i18n("feast_tips_13"))
	end
end
function partyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PARTY_INFO, handler(self, self.notifyCallback))
end
return partyCtrl
