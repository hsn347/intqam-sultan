local GameModule = include("GameModule")
local allianceTreasureCtrl = class("allianceTreasureCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function allianceTreasureCtrl:ctor(properties)
	allianceTreasureCtrl.super.ctor(self, properties)
end
function allianceTreasureCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_INIT, handler(self, self.initData))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_MANUAL_REFRESH, handler(self, self.reqReFreshRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_DIG, handler(self, self.reqDigRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_REQUEST_HELP, handler(self, self.reqRequeHelpRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_HELP_OTHER, handler(self, self.reqHelpOtherRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_RECEIVE, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_SPEED, handler(self, self.reqSpeedRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_RECORDS, handler(self, self.reqRecordRsp))
	self:resetData()
end
function allianceTreasureCtrl:resetData()
	self.reqedHelpDigList, _UPVALUE0_, self.treasureInfoList, _UPVALUE0_, self.otherInfo, _UPVALUE0_, self.digListInfo, _UPVALUE0_, self.helpedList, _UPVALUE0_, self.canHelpList, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function allianceTreasureCtrl:Logout()
	self:resetData()
	allianceTreasureCtrl.super.Logout(self)
end
function allianceTreasureCtrl:initClientData(data)
	if not data then
		return
	end
	self:reqInitData()
	self:registerNotify()
end
function allianceTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ALLIANCE_TREASURE, handler(self, self.notifyHandler))
end
function allianceTreasureCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content and next(content) then
			self:initAllData(content)
		end
	end
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH"
	SoraDSendMessage(pairs(event.data))
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH"
	SoraDSendMessage(pairs(event.data))
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
	SoraDSendMessage(pairs(event.data))
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_GREEN_POINT_UPDATE"
	SoraDSendMessage(pairs(event.data))
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_MAINCITYVIEW_ADD_WAREHOUSE_GIFT_TOP_TIP"
	SoraDSendMessage(pairs(event.data))
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
	SoraDSendMessage(pairs(event.data))
	_ENV = pairs(event.data)
	pairs(event.data).msg = "MESSAGE_UI_PANDECT_ALLIANCE"
	SoraDSendMessage(pairs(event.data))
end
function allianceTreasureCtrl:reqInitData()
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_INIT)
end
function allianceTreasureCtrl:reqReFresh()
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_MANUAL_REFRESH)
end
function allianceTreasureCtrl:reqDig(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_DIG, nil)
end
function allianceTreasureCtrl:reqCallHelp(index)
	table.insert(self.reqedHelpDigList, index)
	local key, value = self:checkTreasureData(self.digListInfo, index)
	if key and value then
		self.digListInfo[key].canCallHelp = false
	end
	_ENV = index
	index.msg = "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH"
	SoraDSendMessage(index)
	if value and not value.isHelped then
		SoraDShowMsgTip(i18n("allitreas_text_17"))
		_ENV = i18n("allitreas_text_17")
		i18n("allitreas_text_17").index = index
		serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_REQUEST_HELP, i18n("allitreas_text_17"))
	end
end
function allianceTreasureCtrl:reqHelpAlies(helpedUid, helpedIndex)
	serverproxy = nil
	;(nil).helpedUid = helpedUid
	;(nil).helpedIndex = helpedIndex
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_HELP_OTHER, nil)
end
function allianceTreasureCtrl:reqHelpAliesByGold(ownUid, index)
	serverproxy = nil
	;(nil).ownUid = ownUid
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_SPEED, nil)
end
function allianceTreasureCtrl:reqReceive(receiveType, ownUid, index)
	serverproxy = nil
	;(nil).receiveType = receiveType
	;(nil).ownUid = ownUid
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_RECEIVE, nil)
end
function allianceTreasureCtrl:reqRecord(nType)
	serverproxy = nil
	local (nil).nType, data = nType, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_TREASURE_MODULE, gCmd.REQ_ALLIANCE_TREASURE_RECORDS, data)
end
function allianceTreasureCtrl:initData(ret)
	if ret.err == gErrDef.Err_None then
		if not ret.rspdata then
			local _ENV, data = ret.rspdata, ret.rspdata
		end
		self:initAllData(data)
	end
	_ENV = self.initAllData
	self.initAllData.msg = "MESSAGE_ALLIANCE_TREASURE_INIT_BACK"
	SoraDSendMessage(self.initAllData)
	_ENV = self.initAllData
	self.initAllData.msg = "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH"
	SoraDSendMessage(self.initAllData)
	_ENV = self.initAllData
	self.initAllData.msg = "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH"
	SoraDSendMessage(self.initAllData)
	_ENV = self.initAllData
	self.initAllData.msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
	SoraDSendMessage(self.initAllData)
	_ENV = self.initAllData
	self.initAllData.msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
	SoraDSendMessage(self.initAllData)
end
function allianceTreasureCtrl:reqRequeHelpRsp()
end
function allianceTreasureCtrl:reqReFreshRsp(ret)
	if ret.err == gErrDef.Err_None then
		if not ret.rspdata then
			local _ENV, data = ret.rspdata, ret.rspdata
		end
		self.otherInfo = data.otherInfo
		self.treasureInfoList = data.treasureInfo
	end
	_ENV = data.treasureInfo
	data.treasureInfo.msg = "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH"
	data.treasureInfo.isRefresh = true
	SoraDSendMessage(data.treasureInfo)
end
function allianceTreasureCtrl:reqDigRsp(ret)
	if ret.err == gErrDef.Err_None then
		if not ret.rspdata then
			local _ENV, data = ret.rspdata, ret.rspdata
		end
		if data.removeIndex then
			self.treasureInfoList = self:delTreasureData(self.treasureInfoList, data.removeIndex)
		end
		if data.newDigInfo and next(data.newDigInfo) then
			self.digListInfo = self:addTreasureData(self.digListInfo, data.newDigInfo)
		end
		self.otherInfo = data.otherInfo
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_WAREHOUSE_GIFT_TOP_TIP"
		SoraDSendMessage(self)
	elseif ret.err == gErrDef.Err_ALLIANCE_TREASURE_PLEASE_RECEIVE_FIRST then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_01"))
	end
	_ENV = i18n("alliance_treasure_tip_01")
	i18n("alliance_treasure_tip_01").msg = "MESSAGE_ALLIANCE_TREASURE_LIST_REFRESH"
	SoraDSendMessage(i18n("alliance_treasure_tip_01"))
end
function allianceTreasureCtrl:reqHelpOtherRsp(ret)
	if not ret.rspdata then
		local _ENV, data = ret.rspdata, ret.rspdata
	end
	if ret.err == gErrDef.Err_None then
		if data.newHelpInfo and next(data.newHelpInfo) then
			self.canHelpList = self:updateHelpData(self.canHelpList, data.newHelpInfo)
			self.helpedList = self:addHelpData(self.helpedList, data.newHelpInfo)
		end
		if data.otherInfo and next(data.otherInfo) then
			self.otherInfo = data.otherInfo
		end
		_ENV = data.otherInfo
		data.otherInfo.msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
		SoraDSendMessage(data.otherInfo)
	elseif ret.err == gErrDef.Err_ALLIANCE_TREASURE_ALREADY_HELPED then
		SoraDShowMsgTip(i18n("allitreas_text_05"))
		if data.canHelpList then
			self.canHelpList = data.canHelpList
			self:sortHelpList(true)
		end
	elseif ret.err == gErrDef.Err_ALLIANCE_TREASURE_PLEASE_RECEIVE_FIRST then
		SoraDShowMsgTip(i18n("alliance_treasure_tip_02"))
	end
	_ENV = i18n("alliance_treasure_tip_02")
	i18n("alliance_treasure_tip_02").msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
	SoraDSendMessage(i18n("alliance_treasure_tip_02"))
end
function allianceTreasureCtrl:reqReceiveRsp(ret)
	if ret.err == gErrDef.Err_None then
		if not ret.rspdata then
			local _ENV, data = ret.rspdata, ret.rspdata
		end
		local award = data.award
		local _ENV, listItem
		for i = 1, #award - 1, 2 do
			listItem[tostring(award[i])] = award[i + 1]
		end
		SoraDMailGainItems(listItem)
		if data.removeReceiveType == 1 then
			self.digListInfo = self:delTreasureData(self.digListInfo, data.removeIndex)
			_ENV = self
			self.msg = "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH"
			SoraDSendMessage(self)
		elseif data.removeReceiveType == 2 then
			self.helpedList = self:delHelpData(self.helpedList, data.removeOwnUid, data.removeIndex)
			self.canHelpList = self:delHelpData(self.canHelpList, data.removeOwnUid, data.removeIndex)
			_ENV = self
			self.msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
			SoraDSendMessage(self)
		end
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_WAREHOUSE_GIFT_TOP_TIP"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_GREEN_POINT_UPDATE"
		SoraDSendMessage(self)
	end
	if ret.err == gErrDef.Err_ITEM_COUNT_IS_LIMIT then
		_ENV = gErrDef.Err_ITEM_COUNT_IS_LIMIT
		gErrDef.Err_ITEM_COUNT_IS_LIMIT.msg = "MESSAGE_ALLIANCE_TREASURE_DIGLIST_REFRESH"
		SoraDSendMessage(gErrDef.Err_ITEM_COUNT_IS_LIMIT)
	end
end
function allianceTreasureCtrl:reqSpeedRsp(ret)
	if ret.err == gErrDef.Err_None then
		if not ret.rspdata then
			local _ENV, data = ret.rspdata, ret.rspdata
		end
		if data.updateHelpInfo and next(data.updateHelpInfo) then
			self.canHelpList = self:updateHelpData(self.canHelpList, data.updateHelpInfo)
			self.helpedList = self:updateHelpData(self.helpedList, data.updateHelpInfo)
		end
	end
	_ENV = self:updateHelpData(self.helpedList, data.updateHelpInfo)
	self:updateHelpData(self.helpedList, data.updateHelpInfo).msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
	SoraDSendMessage((self:updateHelpData(self.helpedList, data.updateHelpInfo)))
	_ENV = self:updateHelpData(self.helpedList, data.updateHelpInfo)
	self:updateHelpData(self.helpedList, data.updateHelpInfo).msg = "MESSAGE_GREEN_POINT_UPDATE"
	SoraDSendMessage((self:updateHelpData(self.helpedList, data.updateHelpInfo)))
end
function allianceTreasureCtrl:reqRecordRsp(ret)
	if ret.err == gErrDef.Err_None then
		local nData = ret.rspdata
		local nType = ret.data.nType
		_ENV = nil
		;(nil).msg = "MESSAGE_ALLIANCE_TREASURE_REQ_INFO_BACK"
		;(nil).nData = nData
		;(nil).nType = nType
		SoraDSendMessage(nil)
	end
end
function allianceTreasureCtrl:initAllData(data)
	if data.helpInfo then
		self.helpedList = data.helpInfo
	end
	if data.canHelpList then
		self.canHelpList = data.canHelpList
		self:sortHelpList(true)
	end
	if data.digListInfo then
		self.digListInfo = data.digListInfo
		for k, v in pairs(self.digListInfo) do
			if v and SoraDisInList(v.index, self.reqedHelpDigList) then
				self.digListInfo[k].canCallHelp = false
			end
		end
	end
	if data.treasureInfo and next(data.treasureInfo) then
		self.treasureInfoList = data.treasureInfo
	end
	if data.otherInfo then
		self.otherInfo = data.otherInfo
	end
end
function allianceTreasureCtrl:addTreasureData(data, newData)
	data[table.nums(data) + 1] = newData
	return data
end
function allianceTreasureCtrl:delTreasureData(data, index)
	local key, value = self:checkTreasureData(data, index)
	if key and value then
		data[key] = nil
	end
	return SoraDSortMessTable(data)
end
function allianceTreasureCtrl:updateTreasureData(data, newData)
	local key, value = self:checkTreasureData(data, newData.index)
	if key and value then
		data[key] = newData
	end
end
function allianceTreasureCtrl:checkTreasureData(data, index)
	local key, value
	for k, v in ipairs(data) do
		if v.index == index then
			key = k
			value = data[k]
			break
		end
	end
	return key, value
end
function allianceTreasureCtrl:addHelpData(data, newData)
	data[table.nums(data) + 1] = newData
	return data
end
function allianceTreasureCtrl:delHelpData(data, ownUid, index)
	local key, value = self:checkHelpData(data, ownUid, index)
	if key and value then
		data[key] = nil
	end
	return SoraDSortMessTable(data)
end
function allianceTreasureCtrl:updateHelpData(data, newData)
	local key, value = self:checkHelpData(data, newData.ownUid, newData.index)
	if key and value then
		data[key] = newData
	end
	return data
end
function allianceTreasureCtrl:checkHelpData(data, ownUid, index)
	local key, value
	for k, v in ipairs(data) do
		if v.ownUid == ownUid and v.index == index then
			key = k
			value = data[k]
			break
		end
	end
	return key, value
end
function allianceTreasureCtrl:sortHelpList(isInit)
	local gametop, data
	local index = 1
	local playerid = gametop.playertop_:getPlayerID()
	if isInit then
		for k, v in pairs(self.canHelpList) do
			for ki, vi in pairs(v) do
				if vi.ownUid ~= playerid then
					data[index] = vi
					index = index + 1
				end
			end
		end
		for k, v in pairs(self.helpedList) do
			if v then
				data[index] = v
				index = index + 1
			end
		end
	else
		for k, v in pairs(self.canHelpList) do
			if v.ownUid ~= playerid then
				data[index] = v
				index = index + 1
			end
		end
	end
	self.canHelpList = data
end
function allianceTreasureCtrl:addHelpListData(newData)
	self.canHelpList = self:addHelpData(self.canHelpList, newData)
	self:sortHelpList()
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
	SoraDSendMessage(self)
end
function allianceTreasureCtrl:delHelpListData(newData)
	self.canHelpList = self:delHelpData(self.canHelpList, newData)
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_TREASURE_HELPLIST_REFRESH"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
	SoraDSendMessage(self)
end
function allianceTreasureCtrl:getDigList()
	table.sort(self.digListInfo, function(a, b)
		if a and b then
			a.status = self:getDigedBtnStatus(a.index)
			b.status = self:getDigedBtnStatus(b.index)
			if a.status ~= b.status then
				return a.status > b.status
			else
				return a.quality > b.quality
			end
		end
	end)
	return self.digListInfo
end
function allianceTreasureCtrl:isHaveHelpBox()
	local ret = false
	for k, v in ipairs(self.canHelpList) do
		if v and not v.canReceive then
			ret = true
			break
		end
	end
	return ret
end
function allianceTreasureCtrl:getHelpList()
	table.sort(self.canHelpList, function(a, b)
		if a and b then
			a.status = self:getHelpDigStatus(a.ownUid, a.index)
			b.status = self:getHelpDigStatus(b.ownUid, b.index)
			if a.status ~= b.status then
				return a.status > b.status
			else
				return a.quality > b.quality
			end
		end
	end)
	return self.canHelpList
end
function allianceTreasureCtrl:getOtherInfo()
	return self.otherInfo
end
function allianceTreasureCtrl:getLeftChance()
	local chance = 0
	if self.otherInfo and next(self.otherInfo) then
		chance = math.max(0, self.otherInfo.maxDigCount - self.otherInfo.digCount)
	end
	return chance
end
function allianceTreasureCtrl:getHelpCount()
	local helpCount = 0
	if self.otherInfo and next(self.otherInfo) then
		helpCount = math.max(0, self.otherInfo.maxHelpCount - self.otherInfo.helpCount)
	end
	return helpCount
end
function allianceTreasureCtrl:getDigGold()
	local gold = 0
	if self.otherInfo and next(self.otherInfo) then
		gold = self.otherInfo.digCostGold
	end
	return gold
end
function allianceTreasureCtrl:getNextAutoRefreshTime()
	local time = 0
	if self.otherInfo and next(self.otherInfo) then
		time = math.max(0, self.otherInfo.nextAutoRefreshTime - serviceFunctions.systemTime())
	end
	return time
end
function allianceTreasureCtrl:getNextFreeTime()
	local time = 0
	if self.otherInfo and next(self.otherInfo) and self.otherInfo.nextFreeDigTime then
		time = math.max(0, self.otherInfo.nextFreeDigTime - serviceFunctions.systemTime())
	end
	return time
end
function allianceTreasureCtrl:getJoin1hourTime()
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local minJoinAlliance = self.otherInfo and self.otherInfo.minJoinAlliance or 3600
	local leftTime = math.max(0, jointime + minJoinAlliance - serviceFunctions.systemTime())
	return leftTime, minJoinAlliance
end
function allianceTreasureCtrl:getTreasureList()
	table.sort(self.treasureInfoList, function(a, b)
		if a and b then
			return a.quality > b.quality
		end
	end)
	return self.treasureInfoList
end
function allianceTreasureCtrl:getRefreshCostGold()
	return self.otherInfo.refreshCostGold
end
function allianceTreasureCtrl:getDigRewardCount()
	local num = 0
	for k, v in ipairs(self.digListInfo) do
		if v.canReceive then
			num = num + 1
		end
	end
	return num
end
function allianceTreasureCtrl:getMyHelpedDig()
	local num = 0
	for k, v in ipairs(self.digListInfo) do
		if v.assistNickName then
			num = num + 1
		end
	end
	return num
end
function allianceTreasureCtrl:getHelpRewardCount()
	local num = 0
	for k, v in ipairs(self.helpedList) do
		if v.canReceive then
			num = num + 1
		end
	end
	return num
end
function allianceTreasureCtrl:isDigging()
	local dig = false
	for k, v in pairs(self.digListInfo) do
		if v and not v.canReceive then
			dig = true
			break
		end
	end
	return dig
end
function allianceTreasureCtrl:isHelping()
	local isHelping = false
	local time = 0
	for k, v in pairs(self.helpedList) do
		if v and not v.canReceive and v.isHelped then
			isHelping = true
			time = math.max(0, v.endtime - serviceFunctions.systemTime())
			break
		end
	end
	return isHelping, time
end
function allianceTreasureCtrl:getDigBtnStatus()
	local status = gTreasureBtnStatus.UNDIG
	local gold = 0
	local chance = self:getLeftChance()
	if 0 < chance then
		if 0 < self:getNextFreeTime() then
			status = gTreasureBtnStatus.COST_GOLD
			gold = self.otherInfo.digCostGold
		else
			status = gTreasureBtnStatus.FREE
		end
	end
	return status, gold
end
function allianceTreasureCtrl:getDigedBtnStatus(index)
	local status = gTreasureDigStatus.CALL_HELP
	local leftTime = 0
	if next(self.digListInfo) then
		local key, value = self:checkTreasureData(self.digListInfo, index)
		if value and next(value) then
			leftTime = math.max(0, value.endtime - serviceFunctions.systemTime())
			if value.canReceive then
				status = gTreasureDigStatus.REWARD
			elseif value.isHelped then
				status = gTreasureDigStatus.BE_HELPED
			elseif not value.canCallHelp then
				status = gTreasureDigStatus.CALLED_HELP
			end
		end
	end
	return status, leftTime
end
function allianceTreasureCtrl:getHelpDigStatus(ownuid, index)
	local status = gTreasureHelpStatus.CANNOT_HELP
	local leftHelpCount = self:getHelpCount()
	local gold = 0
	local time = 0
	local openTime = 0
	local key, value = self:checkHelpData(self.canHelpList, ownuid, index)
	if value and next(value) then
		if not value.canReceive then
			if value.isHelped then
				status = gTreasureHelpStatus.HELPED
				gold = value.consumeGold
				time = math.max(0, value.endtime - serviceFunctions.systemTime())
				openTime = value.openTime
			else
				local isHelping = self:isHelping()
				if isHelping or leftHelpCount <= 0 then
					status = gTreasureHelpStatus.CANNOT_HELP
				else
					status = gTreasureHelpStatus.CAN_HELP
				end
			end
		else
			status = gTreasureHelpStatus.REWARD
		end
	end
	return status, gold, time, openTime
end
return allianceTreasureCtrl
