local GameModule = include("GameModule")
local everydayTaskCtrl = class("everydayTaskCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local everydayTaskRead = include("everydayTaskRead")
function everydayTaskCtrl:ctor(properties)
	everydayTaskCtrl.super.ctor(self, properties)
end
function everydayTaskCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_INIT, handler(self, self.everydayTaskInitResp))
	msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_NORMAL, handler(self, self.everydayTaskReceiveNormalResp))
	msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_REFRESH, handler(self, self.everydayTaskRefreshResp))
	msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_CHEST, handler(self, self.everydayTaskReceiveChestResp))
	msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_USE_FAST_PASS, handler(self, self.useFastPassResp))
	self:resetData()
end
function everydayTaskCtrl:resetData()
	print("everydayTaskCtrl:resetData")
	self.serverLv = -1
	self.tomorrowZeroUT = 0
	self.localGoalArray = nil
	self.eventInfo = nil
	self.normalRecord = nil
	self.chestReward = nil
	self.chestRecord = nil
	self.handle_notify = nil
end
function everydayTaskCtrl:Logout()
	self:resetData()
	everydayTaskCtrl.super.Logout(self)
end
function everydayTaskCtrl:initClientData(data)
	if not data then
		return
	end
	self.tomorrowZeroUTC = tonumber(data.tomorrowZeroUTC)
	if data.eventInfo then
		self.eventInfo = data.eventInfo
	end
	if data.normalRecord then
		self.normalRecord = data.normalRecord
	end
	if data.chestRecord then
		self.chestRecord = data.chestRecord
	end
	if data.chestReward then
		self.chestReward = data.chestReward
	end
	self:initLocalData()
	self:registerNotify()
	self:sendInitMsg()
end
function everydayTaskCtrl:initLocalData()
	if not everydayTaskRead.getEverydayRewardPointConfig() then
		everydayTaskRead = everydayTaskRead.getEverydayRewardPointConfig()
	end
	self.localRewardPoint = everydayTaskRead.getEverydayRewardPointConfig()
	if not everydayTaskRead.getEverydayRewardItemsConfig() then
		everydayTaskRead = everydayTaskRead.getEverydayRewardItemsConfig()
	end
	self.localRewardItems = everydayTaskRead.getEverydayRewardItemsConfig()
	local everydayTaskRead, temp = everydayTaskRead.getEverydayRewardItemsConfig(), everydayTaskRead.getEverydayRewardItemsConfig()
	for _, value in pairs(self.localRewardItems) do
		temp[tostring(value.goal)] = value.goal
	end
	self.localGoalArray, everydayTaskRead = pairs(self.localRewardItems)
	for _, goal in pairs(temp) do
		table.insert(self.localGoalArray, goal)
	end
	table.sort(self.localGoalArray, function(a, b)
		return a < b
	end)
end
function everydayTaskCtrl:getNormalRewardGoalByIndex(index)
	local ret = -1
	if self.localGoalArray and self.localGoalArray[index] then
		ret = self.localGoalArray[index]
	end
	return ret
end
function everydayTaskCtrl:dump()
end
function everydayTaskCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EVERYDAY_TASK, handler(self, self.notifyHandler))
end
function everydayTaskCtrl:notifyHandler(event)
	local content = event.data[1]
	dump(content, "everydayTaskCtrl:notifyHandler")
	if content then
		local isChange = false
		if tonumber(content.tomorrowZeroUTC) then
			self.tomorrowZeroUTC = tonumber(content.tomorrowZeroUTC)
		end
		if content.eventInfo then
			self.eventInfo = content.eventInfo
			isChange = true
		end
		if content.normalRecord then
			self.normalRecord = content.normalRecord
		end
		if content.chestRecord then
			self.chestRecord = content.chestRecord
		end
		if content.chestReward then
			self.chestReward = content.chestReward
		end
		if content.isNewDay then
			isChange = true
		end
		if content.serverLv then
			self.serverLv = content.serverLv
			isChange = true
			print("self.serverLv", self.serverLv)
		end
		if isChange == true then
			print("如果有改变，那么刷新下所有内容", self.serverLv)
			_ENV = "如果有改变，那么刷新下所有内容"
			;("如果有改变，那么刷新下所有内容").msg = "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW"
			SoraDSendMessage("如果有改变，那么刷新下所有内容")
		end
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
	SoraDSendMessage(SoraDSendMessage)
end
function everydayTaskCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_INIT)
end
function everydayTaskCtrl:sendReceiveNormalMsg(index)
	local serverproxy, data
	data.index = index
	serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_NORMAL, data)
end
function everydayTaskCtrl:sendRefreshMsg(index)
	local serverproxy, data
	data.index = index
	serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_REFRESH, data)
end
function everydayTaskCtrl:sendReceiveChestMsg(index)
	local serverproxy, data
	data.index = index
	serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_CHEST, data)
end
function everydayTaskCtrl:sendUseFastPassMsg(index, shopItemID)
	local serverproxy, data
	data.index = index
	data.shopItemID = shopItemID
	serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_USE_FAST_PASS, data)
end
function everydayTaskCtrl:everydayTaskInitResp(ret)
	if ret and ret.data then
		self.eventInfo = ret.data.eventInfo
		self.normalRecord = ret.data.normalRecord
		self.chestRecord = ret.data.chestRecord
		self.chestReward = ret.data.chestReward
		self.serverLv = ret.data.serverLv or -1
	end
end
function everydayTaskCtrl:everydayTaskReceiveNormalResp(ret)
	local _ENV, rewardList
	if ret.err == gErrDef.Err_None then
		if ret.data and ret.data.normalRecord then
			self.normalRecord = ret.data.normalRecord
			if ret.data.reward then
				for key, value in pairs(ret.data.reward) do
					rewardList[value.itemid] = value.count
				end
			end
			SoraDMailGainItems(rewardList)
		end
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_INDEX_ILLEGAL then
		SoraDShowMsgTip(i18n("common_text_2700"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_POINT_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("common_text_2700"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_ALREADY_RECEIVE then
		SoraDShowMsgTip(i18n("common_text_2701"))
	end
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_SERVER_DAILYAWARD_REVEIVE_NORMAL"
	i18n("common_text_2701").err = ret.err
	i18n("common_text_2701").data = ret.data
	SoraDSendMessage(i18n("common_text_2701"))
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_UI_DAILYAWARD_REFRESH_BOXES"
	SoraDSendMessage(i18n("common_text_2701"))
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
	SoraDSendMessage(i18n("common_text_2701"))
end
function everydayTaskCtrl:everydayTaskRefreshResp(ret)
	if ret.err == gErrDef.Err_None then
		local index = ret.data.index
		if ret.data and ret.data.updateRefreshData then
			self.chestReward[tostring(index)] = ret.data.updateRefreshData
		end
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_INDEX_ILLEGAL then
		SoraDShowMsgTip(i18n("common_text_2700"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_POINT_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("common_text_2700"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_GOLD_NOT_ENOUGH then
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_REFRESH_FAIL then
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_ALREADY_RECEIVE then
		SoraDShowMsgTip(i18n("common_text_2701"))
	end
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_SERVER_DAILYAWARD_REFRESH_TREASURE"
	SoraDSendMessage(i18n("common_text_2701"))
end
function everydayTaskCtrl:everydayTaskReceiveChestResp(ret)
	local _ENV, rewardList
	if ret.err == gErrDef.Err_None then
		if ret.data and ret.data.chestRecord then
			self.chestRecord = ret.data.chestRecord
			if ret.data.reward then
				for key, value in pairs(ret.data.reward) do
					SoraDPopGainItem(value.itemid, value.count)
				end
			end
		end
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_INDEX_ILLEGAL then
		SoraDShowMsgTip(i18n("common_text_2700"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_POINT_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("common_text_2700"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_ALREADY_RECEIVE then
		SoraDShowMsgTip(i18n("common_text_2701"))
	end
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW"
	SoraDSendMessage(i18n("common_text_2701"))
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_SERVER_DAILYAWARD_GET_TREASURE"
	i18n("common_text_2701").err = ret.err
	i18n("common_text_2701").data = ret.data
	SoraDSendMessage(i18n("common_text_2701"))
	_ENV = i18n("common_text_2701")
	i18n("common_text_2701").msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
	SoraDSendMessage(i18n("common_text_2701"))
end
function everydayTaskCtrl:useFastPassResp(ret)
	dump(ret, "everydayTaskCtrl:useFastPassResp===", 10)
	if ret.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("Actpass_text_06"))
		if ret.rspdata.eventInfo then
			self.eventInfo = ret.rspdata.eventInfo
		end
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_CAN_NOT_USE then
		SoraDShowMsgTip(i18n("Actpass_text_03"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_ALREADY_FINISH then
		SoraDShowMsgTip(i18n("Actpass_text_07"))
	elseif ret.err == gErrDef.Err_EVERYDAY_TASK_NOT_ENOUGH_ITEM then
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	end
	_ENV = i18n("gemEnchant_text_48")
	i18n("gemEnchant_text_48").msg = "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW"
	SoraDSendMessage(i18n("gemEnchant_text_48"))
	_ENV = i18n("gemEnchant_text_48")
	i18n("gemEnchant_text_48").msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
	SoraDSendMessage(i18n("gemEnchant_text_48"))
	_ENV = i18n("gemEnchant_text_48")
	i18n("gemEnchant_text_48").msg = "MESSAGE_UI_DAILYAWARD_REFRESH_BOXES"
	SoraDSendMessage(i18n("gemEnchant_text_48"))
end
function everydayTaskCtrl:getLeftTime()
	if self.tomorrowZeroUTC and self.tomorrowZeroUTC - serviceFunctions.systemTime() > 0 then
		return self.tomorrowZeroUTC - serviceFunctions.systemTime()
	end
	return 0
end
function everydayTaskCtrl:getTomorrowZeroUTC()
	return self.tomorrowZeroUTC or 0
end
function everydayTaskCtrl:calCurPoint()
	local ret = 0
	if not self.eventInfo then
		_ENV = self.eventInfo
	end
	self.eventInfo = self.eventInfo
	for everydayTaskID, tmpCount in pairs(self.eventInfo) do
		local tempConfig = self.localRewardPoint[tonumber(everydayTaskID)]
		if tempConfig and tempConfig.point and tempConfig.limitTime then
			local point = tempConfig.point
			local count = math.min(tmpCount, tempConfig.limitTime)
			ret = ret + point * count
		end
	end
	return ret
end
function everydayTaskCtrl:getCurTaskIDS()
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local gametop, tmp = cityCtrl, cityCtrl
	for key, value in pairs(self.localRewardPoint) do
		local everydayTaskID = value.type
		if castleLv < CASTLE_MAXLV_NOWAR and everydayTaskID == gEverydayTaskType.BADGEEXCHANGE then
		else
			local info = self:getEventInfoByTaskID(everydayTaskID)
			local complete = 0
			if info.per and info.per >= 1 then
				complete = 1
			end
			gametop = nil
			;(nil).everydayTaskID = everydayTaskID
			;(nil).complete = complete
			table.insert(tmp, nil)
		end
	end
	table.sort(tmp, function(a, b)
		if a.complete == b.complete then
			return a.everydayTaskID < b.everydayTaskID
		else
			return a.complete < b.complete
		end
	end)
	local gametop, ret = table.sort, table.sort
	for i = 1, #tmp do
		table.insert(ret, tmp[i].everydayTaskID)
	end
	return ret
end
function everydayTaskCtrl:getEventInfoByTaskID(everydayTaskID)
	local _ENV, ret
	if self.eventInfo then
		local count = self.eventInfo[tostring(everydayTaskID)] or 0
		local tempConfig = self.localRewardPoint[tonumber(everydayTaskID)]
		ret.everydayTaskID = everydayTaskID
		ret.point = tempConfig.point
		ret.limitTime = tempConfig.limitTime
		ret.rank = tempConfig.rank
		ret.count = math.min(count, tempConfig.limitTime)
		ret.per = ret.count / ret.limitTime
		ret.isCanPass = tempConfig.fastpass == 1
		ret.passNum = tempConfig.num
		ret.type = tempConfig.type
	end
	return ret
end
function everydayTaskCtrl:isTaskCompleted(index)
	local ret = false
	if self.eventInfo and self.eventInfo[tostring(index)] then
		local tempConfig = self.localRewardPoint[tonumber(index)]
		ret = self.eventInfo[tostring(index)] >= tempConfig.limitTime
	end
	return ret
end
function everydayTaskCtrl:getIndexById(everydayTaskID)
	local tempConfig = self.localRewardPoint[tonumber(everydayTaskID)]
	if tempConfig then
		return tempConfig.picIndex
	end
end
function everydayTaskCtrl:getMaxPoint()
	return self.localGoalArray[#self.localGoalArray]
end
function everydayTaskCtrl:getGoalArray()
	if not self.localGoalArray then
		_UPVALUE0_ = self.localGoalArray
	end
	return self.localGoalArray
end
function everydayTaskCtrl:getNormalRewardByIndex(index)
	local buildLogic = include("buildLogic")
	local castleLv = SoraDGetCastleLv()
	local starLv = SoraDGetBuildStarLv()
	local getCount = function(lv, nType, num)
		if nType == 1 then
			return math.floor(lv * num)
		elseif nType == 2 then
			return math.floor(lv / num)
		elseif nType == 3 then
			return math.floor(num)
		end
	end
	local countMultiple = 1
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffEffect = buffCtrl:getBuffEffect(gBuffEffect.DAILY_QUEST_BOOST)
	if buffEffect then
		countMultiple = (1000 + buffEffect) / 1000
	end
	local jinnLv = SoraDGetCtrl("magicLampCtrl"):getSumJinnLevel()
	local _ENV, ret = SoraDGetCtrl("magicLampCtrl"), SoraDGetCtrl("magicLampCtrl")
	for _, value in ipairs(self.localRewardItems) do
		if value.goal == self:getNormalRewardGoalByIndex(index) and value.reward then
			local min = value.serverPhase[1]
			local max = value.serverPhase[2]
			local itemid = value.reward[1]
			local validLv = value.reward[2]
			local minJinnLv = value.lampLevel[1]
			local maxJinnLv = value.lampLevel[2]
			if min <= self.serverLv and max >= self.serverLv and itemid and validLv then
				local lv = 0
				if value.effect == 2 and starLv >= validLv then
					lv = starLv
				elseif value.effect == 1 and castleLv >= validLv then
					lv = castleLv
					if 30 < lv then
						local wlv = buildLogic.transformBuildLvToWarLv(lv)
						lv = 30 + wlv
					end
				end
				local isLamp = jinnLv >= minJinnLv and (jinnLv <= maxJinnLv or maxJinnLv == -1)
				_UPVALUE2_ = nil
				;(nil)[1] = isLamp
				;(nil)[2] = lv
				dump(nil, "isLamp,lv")
				dump(value, "getNormalRewardGoalByIndex")
				if 0 < lv and isLamp then
					local count = getCount(lv, value.type, value.num)
					if count ~= nil then
						if count <= 1 then
							count = 1
						end
						print("count,countMultiple======", count, countMultiple)
						count = math.floor(count * countMultiple)
						_ENV = count
						count.id = itemid
						count.count = count
						table.insert(ret, count)
					end
				end
			end
		end
	end
	return ret
end
function everydayTaskCtrl:isReceiveNormalReward(index)
	local ret = false
	if self.normalRecord and type(self.normalRecord) == "table" and self.normalRecord[tostring(index)] then
		ret = true
	end
	return ret
end
function everydayTaskCtrl:getReceiveNormalRewardCount()
	local ret = 0
	local curPoint = self:calCurPoint()
	local chestGoalArray = self:getChestGoalArray()
	local goalArray = self:getGoalArray()
	if goalArray then
		for index = 1, #goalArray do
			if curPoint >= goalArray[index] and false == self:isReceiveNormalReward(index) then
				ret = ret + 1
			end
		end
	end
	return ret
end
function everydayTaskCtrl:getChestGoalArray()
	local _ENV, ret
	if self.chestReward and type(self.chestReward) == "table" then
		for _, value in pairs(self.chestReward) do
			table.insert(ret, value.goal)
		end
	end
	table.sort(ret, function(a, b)
		return a < b
	end)
	return ret
end
function everydayTaskCtrl:getChestRewardByIndex(index)
	local _ENV, ret
	if self.chestReward and type(self.chestReward) == "table" then
		ret = self.chestReward[tostring(index)]
	end
	return ret
end
function everydayTaskCtrl:isReceiveChestReward(index)
	local ret = false
	if self.chestRecord and type(self.chestRecord) == "table" and self.chestRecord[tostring(index)] then
		ret = true
	end
	return ret
end
function everydayTaskCtrl:isHaveNoReceiveReward()
	local curPoint = self:calCurPoint()
	local chestGoalArray = self:getChestGoalArray()
	local goalArray = self:getGoalArray()
	for index = 1, #goalArray do
		if curPoint >= goalArray[index] and false == self:isReceiveNormalReward(index) then
			return true
		end
	end
	return false
end
return everydayTaskCtrl
