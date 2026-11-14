local GameModule = include("GameModule")
local miraculousWeaponCtrl = class("miraculousWeaponCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local miraculousWeaponltCtrl = include("miraculousWeaponltCtrl")
function miraculousWeaponCtrl:ctor(properties)
	miraculousWeaponCtrl.super.ctor(self, properties)
end
function miraculousWeaponCtrl:EnterGame()
	miraculousWeaponCtrl.super.EnterGame(self)
	miraculousWeaponCtrl = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.miraculous_weapon_unlock), handler(self, self.queueCallback))
	msgCtrl.register(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_UNLOCK_CHIP, handler(self, self.reqUnlockRsp))
	msgCtrl.register(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_ACTIVIE_WEAPON, handler(self, self.reqActiveRsp))
	msgCtrl.register(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_REMAKE, handler(self, self.reqAwakeRsp))
	msgCtrl.register(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_SAVE_PROPERTY, handler(self, self.reqSaveRsp))
	msgCtrl.register(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_CLEAR_PROPERTY, handler(self, self.reqCancelRsp))
	self:resetData()
	self:registerNotify()
end
function miraculousWeaponCtrl:resetData()
	_UPVALUE0_, self.weaponList, _UPVALUE0_, self.userInfo, _UPVALUE0_ = nil, nil, nil, nil, nil
	;(nil).daily_advanced_remake = 0
	;(nil).daily_normal_remake = 0
	;(nil).normal_remake_times = 0
	;(nil).super_remake_times = 0
	;(nil).chipData, _UPVALUE0_, _UPVALUE0_, (nil).weapon_remake_buff, _UPVALUE0_, (nil).weapon_buff, _UPVALUE0_, (nil).total_power = nil, nil, nil, nil, nil, nil, nil, 0
	;(nil).curChip = 0
	;(nil).weapon_chip_data, (nil).unlockChipsNum = nil, 0
	self.weaponDefault, (nil).weapon_state = nil, 0
end
function miraculousWeaponCtrl:initClientData(event)
	dump(event, "miraculousWeaponCtrl:initClientData====", 10)
	if event and next(event) then
		self.userInfo = event.userInfo
		self.weaponList = event.weaponList
	end
end
function miraculousWeaponCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MIRACULOUS_WEAPON, handler(self, self.notifyHandler))
end
function miraculousWeaponCtrl:notifyHandler(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in pairs(event.data) do
			local notifyType = content.type
			local notifyData = content.data
			if notifyType == "weaponInfo" then
				local weaponID = notifyData.weapon_id
				if weaponID then
					self.weaponList[tostring(weaponID)] = notifyData
					print("refreshWeaponData", weaponID)
				end
			elseif notifyType == "refreshUserInfo" and type(notifyData) == "table" then
				self.userInfo = notifyData
				print("refreshUserInfo")
			end
		end
	end
end
function miraculousWeaponCtrl:Logout()
	self:resetData()
	miraculousWeaponCtrl.super.Logout(self)
end
function miraculousWeaponCtrl:queryWeaponCellEffect(weaponInfo, effectType)
	local value = 0
	if type(weaponInfo) == "table" and weaponInfo.weapon_state == gWeapnStatus.STATE_ACTIVE and type(weaponInfo.weapon_buff) == "table" then
		for k, v in pairs(weaponInfo.weapon_buff) do
			if v.buffType == effectType then
				value = value + v.value
			end
		end
	end
	return value
end
function miraculousWeaponCtrl:getBuffEffect(effectType)
	local effect = 0
	if type(self.weaponList) == "table" then
		for k, weaponInstance in pairs(self.weaponList) do
			effect = effect + self:queryWeaponCellEffect(weaponInstance, effectType)
		end
	end
	if type(self.userInfo) == "table" and type(self.userInfo.resonanceBuff) == "table" then
		for k, v in pairs(self.userInfo.resonanceBuff) do
			if effectType == v.buffType then
				effect = effect + v.value
			end
		end
	end
	return effect
end
function miraculousWeaponCtrl:sortPreBuff(buffList, weaponID)
	local _ENV, tbl
	for k, v in pairs(buffList) do
		if not v.key then
			v.key = tonumber(k)
		end
		if not v.weaponID then
			v.weaponID = weaponID
		end
		tbl[tonumber(k)] = v
	end
	return tbl
end
function miraculousWeaponCtrl:reqUnlock(weaponID, chipIndex, opType)
	serverproxy = nil
	;(nil).weaponID = weaponID
	;(nil).chipIndex = chipIndex
	;(nil).opType = opType
	serverproxy:Request(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_UNLOCK_CHIP, nil)
end
function miraculousWeaponCtrl:reqMerge(weaponID)
	serverproxy = nil
	;(nil).weaponID = weaponID
	serverproxy:Request(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_ACTIVIE_WEAPON, nil)
end
function miraculousWeaponCtrl:reqAwake(weaponID, remakeTimes, opType)
	local remakeTimes = remakeTimes or 1
	local opType = opType or 1
	serverproxy = nil
	;(nil).weaponID = weaponID
	;(nil).remakeTimes = remakeTimes
	;(nil).opType = opType
	serverproxy:Request(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_REMAKE, nil)
end
function miraculousWeaponCtrl:reqSave(weaponID, indexArray)
	serverproxy = nil
	;(nil).weaponID = weaponID
	;(nil).indexArray = indexArray
	serverproxy:Request(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_SAVE_PROPERTY, nil)
end
function miraculousWeaponCtrl:reqCancel(weaponID)
	serverproxy = nil
	;(nil).weaponID = weaponID
	serverproxy:Request(gCmd.CMD_MIRACULOUS_WEAPON_MODULE, gCmd.REQ_MIRACULOUS_WEAPON_CLEAR_PROPERTY, nil)
end
function miraculousWeaponCtrl:reqUnlockRsp(ret)
	dump(ret, "reqUnlockRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local data = ret.data
		local weaponInfo = ret.rspdata.weaponInfo
		self.weaponList[tostring(data.weaponID)] = weaponInfo
		if data.opType == gUnlockOpType.NORMAL then
			local queueCtrl = gametop.playertop_:getModule("queueCtrl")
			local chipInfo = miraculousWeaponltCtrl.getChipsInfo(data.weaponID, data.chipIndex)
			_ENV = nil
			;(nil).index = data.chipIndex
			;(nil).weaponID = data.weaponID
			queueCtrl:addQueue(gQueueTypeDef.miraculous_weapon_unlock, serviceFunctions.systemTime(), serviceFunctions.systemTime() + chipInfo.costTime, chipInfo.costTime, nil)
			_ENV = queueCtrl
			queueCtrl.msg = "MESSAGE_ITEM_SPEED_UP_BACK"
			queueCtrl.qtype = gQueueTypeDef.miraculous_weapon_unlock
			queueCtrl.weaponID = data.weaponID
			queueCtrl.chipIndex = data.chipIndex
			SoraDSendMessage(queueCtrl)
		end
		_ENV = miraculousWeaponltCtrl.getChipsInfo(data.weaponID, data.chipIndex)
		miraculousWeaponltCtrl.getChipsInfo(data.weaponID, data.chipIndex).msg = "MESSAGE_SERVER_GODEQUIP_UNLOCK_UPDATE"
		miraculousWeaponltCtrl.getChipsInfo(data.weaponID, data.chipIndex).weaponID = data.weaponID
		miraculousWeaponltCtrl.getChipsInfo(data.weaponID, data.chipIndex).chipIndex = data.chipIndex
		SoraDSendMessage((miraculousWeaponltCtrl.getChipsInfo(data.weaponID, data.chipIndex)))
	end
end
function miraculousWeaponCtrl:reqActiveRsp(ret)
	dump(ret, "reqActiveRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local data = ret.data
		local weaponInfo = ret.rspdata.weaponInfo
		self.weaponList[tostring(data.weaponID)] = weaponInfo
		_ENV = data.weaponID
		data.weaponID.name = gEventName.event_miraculous_weapon_update
		self:dispatchEvent(data.weaponID)
		_ENV = self
		self.msg = "MESSAGE_SERVER_GODEQUIP_MERGE_BACK"
		self.weaponID = data.weaponID
		SoraDSendMessage(self)
	end
end
function miraculousWeaponCtrl:reqAwakeRsp(ret)
	dump(ret, "reqAwakeRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local data = ret.data
		local weaponInfo = ret.rspdata.weaponInfo
		self.weaponList[tostring(data.weaponID)] = weaponInfo
		_ENV = tostring(data.weaponID)
		tostring(data.weaponID).msg = "MESSAGE_SERVER_GODEQUIP_WAKE_BACK"
		tostring(data.weaponID).weaponID = data.weaponID
		tostring(data.weaponID).remakeTimes = data.remakeTimes
		SoraDSendMessage((tostring(data.weaponID)))
		SoraDShowMsgTip("weapon_text_14")
	end
end
function miraculousWeaponCtrl:reqSaveRsp(ret)
	dump(ret, "reqSaveRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local data = ret.data
		local weaponInfo = ret.rspdata.weaponInfo
		self.weaponList[tostring(data.weaponID)] = weaponInfo
		_ENV = data.weaponID
		data.weaponID.name = gEventName.event_miraculous_weapon_update
		self:dispatchEvent(data.weaponID)
		_ENV = self
		self.msg = "MESSAGE_SERVER_GODEQUIP_SAVE_BACK"
		self.weaponID = data.weaponID
		SoraDSendMessage(self)
	end
end
function miraculousWeaponCtrl:reqCancelRsp(ret)
	dump(ret, "reqCancelRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local data = ret.data
		local weaponInfo = ret.rspdata.weaponInfo
		self.weaponList[tostring(data.weaponID)] = weaponInfo
		_ENV = tostring(data.weaponID)
		tostring(data.weaponID).msg = "MESSAGE_SERVER_GODEQUIP_CANCEL_BACK"
		tostring(data.weaponID).weaponID = data.weaponID
		SoraDSendMessage((tostring(data.weaponID)))
	end
end
function miraculousWeaponCtrl:queueCallback(event)
	dump(event, "queueCallback event=====", 10)
	if event and event.data and event.name == tostring(gQueueTypeDef.miraculous_weapon_unlock) then
		self.weaponList[tostring(event.data.weaponID)].weapon_chip_data.curChip = event.data.index
		_ENV = event.data.index
		self.weaponList[tostring(event.data.weaponID)].weapon_chip_data.chipData[tostring(event.data.index)], event.data.index.unlocktime = event.data.index, serviceFunctions.systemTime()
		_ENV = tostring(event.data.index)
		tostring(event.data.index).msg = "MESSAGE_ITEM_SPEED_UP_BACK"
		tostring(event.data.index).qtype = gQueueTypeDef.miraculous_weapon_unlock
		tostring(event.data.index).weaponID = event.data.weaponID
		tostring(event.data.index).chipIndex = event.data.index
		SoraDSendMessage((tostring(event.data.index)))
	end
end
function miraculousWeaponCtrl:getCurWeaponFc()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local playerInfo = lordInfoCtrl:getLordInfo()
	return playerInfo.fcInfo.weaponFc or 0
end
function miraculousWeaponCtrl:getOriMaxWeaponFc()
	return self.userInfo.maxWeaponPower or 0
end
function miraculousWeaponCtrl:getWeaponInfo(weaponID)
	return self.weaponList[tostring(weaponID)] or clone(self.weaponDefault)
end
function miraculousWeaponCtrl:getWakeCountAndCost(weaponID)
	local weaponInfo = self:getWeaponInfo(weaponID)
	return weaponInfo.daily_normal_remake
end
function miraculousWeaponCtrl:getSenorWakeCountAndCost(weaponID)
	local weaponInfo = self:getWeaponInfo(weaponID)
	return weaponInfo.daily_advanced_remake
end
function miraculousWeaponCtrl:isWeaponMerged(weaponID)
	local weaponInfo = self:getWeaponInfo(weaponID)
	return weaponInfo.weapon_state == gWeaponStatus.MERGED
end
function miraculousWeaponCtrl:isWeaponSeniorAwaked(weaponID)
	local ret = false
	local weaponInfo = self:getWeaponInfo(weaponID)
	if next(weaponInfo.weapon_remake_buff) and weaponInfo.superFlag then
		ret = true
	end
	return ret
end
function miraculousWeaponCtrl:isWeaponAwaked(weaponID)
	local ret = false
	local weaponInfo = self:getWeaponInfo(weaponID)
	if next(weaponInfo.weapon_remake_buff) then
		ret = true
	end
	return ret, self:sortPreBuff(weaponInfo.weapon_remake_buff, weaponID)
end
function miraculousWeaponCtrl:getWeaponShowBuffList(weaponID)
	local weaponInfo = self:getWeaponInfo(weaponID)
	if self:isWeaponMerged(weaponID) and next(weaponInfo.weapon_buff) then
		weaponInfo.weapon_remake_buff = self:sortPreBuff(weaponInfo.weapon_remake_buff, weaponID)
		return weaponInfo.weapon_buff, weaponInfo.weapon_remake_buff
	else
		_UPVALUE4_ = weaponID
		weaponID[1] = "buffType"
		weaponID[2] = "mode"
		weaponID[3] = "eType"
		weaponID[4] = "value"
		return serviceFunctions.tableFormat(miraculousWeaponltCtrl.getWeaponInfo(weaponID).init_buff, weaponID), nil, true
	end
end
function miraculousWeaponCtrl:changeSelectedStatus(weaponID, key, isSelected)
	local weaponInfo = self:getWeaponInfo(weaponID)
	if weaponInfo and type(weaponInfo.weapon_remake_buff) == "table" then
		for k, v in ipairs(weaponInfo.weapon_remake_buff) do
			if v.key and v.key == key then
				v.isSelected = isSelected
				break
			end
		end
	end
end
function miraculousWeaponCtrl:getSelectedKeyTab(weaponID)
	local weaponInfo = self:getWeaponInfo(weaponID)
	local _ENV, selTab = self, self
	weaponInfo.weapon_remake_buff = self:sortPreBuff(weaponInfo.weapon_remake_buff, weaponID)
	local remakeBuffNum = 0
	for k, v in ipairs(weaponInfo.weapon_remake_buff) do
		remakeBuffNum = remakeBuffNum + 1
		if v.isSelected then
			table.insert(selTab, v.key)
		end
	end
	if remakeBuffNum == 1 then
		selTab = nil
	end
	return selTab
end
function miraculousWeaponCtrl:getWeapBuffValue(weaponBuff, buffType)
	if type(weaponBuff) == "table" then
		for k, v in pairs(weaponBuff) do
			if v.buffType == buffType then
				return v.value
			end
		end
	end
end
function miraculousWeaponCtrl:getRemakeValuePreShow(weaponID, buffType)
	local difValue = 0
	local preValue = 0
	local curValue = 0
	local weaponBuff, weapon_remake_buff = self:getWeaponShowBuffList(weaponID)
	local maxValue, minValue = miraculousWeaponltCtrl.getWeaponMaxBuffValue(weaponID, buffType)
	if type(weaponBuff) == "table" and type(weapon_remake_buff) == "table" then
		local bSelected = false
		for k, v in ipairs(weapon_remake_buff) do
			if v.isSelected then
				bSelected = true
				for i = 1, 4 do
					if v[i] and v[i].buffType == buffType then
						curValue = v[i].cur
						difValue = difValue + v[i].value - curValue
					end
				end
			end
		end
		preValue = curValue + difValue
		if not bSelected then
			preValue = self:getWeapBuffValue(weaponBuff, buffType)
		end
	end
	if minValue > preValue then
		preValue = minValue
	end
	if maxValue < preValue then
		preValue = maxValue
	end
	return preValue
end
function miraculousWeaponCtrl:getSortRemakeBuff(weaponID)
	local weaponInfo = self:getWeaponInfo(weaponID)
	weaponInfo.weapon_remake_buff = self:sortPreBuff(weaponInfo.weapon_remake_buff, weaponID)
	for k, v in ipairs(weaponInfo.weapon_remake_buff) do
		local isCmd = true
		for _index, _val in ipairs(v) do
			_val.cur = weaponInfo.weapon_buff[_index].value
		end
		for index, val in ipairs(v) do
			if val.value < weaponInfo.weapon_buff[index].value then
				isCmd = false
				break
			end
		end
		v.isCmd = isCmd
		v.prePower = math.floor(self:calcWeaponPower(weaponID, v))
		v.oriPower = math.floor(weaponInfo.total_power)
		if v.isCmd then
			if v.isSelected == false then
				v.isSelected = false
			else
				v.isSelected = true
			end
		else
			v.isSelected = v.isSelected or false
		end
	end
	table.sort(weaponInfo.weapon_remake_buff, function(a, b)
		if a.isCmd and not b.isCmd then
			return true
		elseif not a.isCmd and b.isCmd then
			return false
		else
			return a.prePower - a.oriPower > b.prePower - b.oriPower
		end
	end)
	return weaponInfo.weapon_remake_buff
end
function miraculousWeaponCtrl:getSelectPreBuff(weaponID, indexArray)
	local weaponInfo = self:getWeaponInfo(weaponID)
	local weaponPreBuff = clone(weaponInfo.weapon_buff)
	local _ENV, offsetArray = weaponInfo.weapon_buff, weaponInfo.weapon_buff
	for k, v in pairs(indexArray) do
		local wakeBuff = weaponInfo.weapon_remake_buff[v]
		for index, val in ipairs(weaponPreBuff) do
			offsetArray[index] = wakeBuff[index].value - val.value
		end
	end
	for i, r in ipairs(weaponPreBuff) do
		r.value = r.value + (offsetArray[i] or 0)
	end
	return weaponPreBuff
end
function miraculousWeaponCtrl:getWeaponChipsInfo(weaponID, chipIndex)
	local weaponInfo = self:getWeaponInfo(weaponID)
	if not weaponInfo.weapon_chip_data then
		local _ENV, weaponChipData = weaponInfo.weapon_chip_data, weaponInfo.weapon_chip_data
	end
	if not weaponChipData.chipData then
		local _ENV, chipData = weaponChipData.chipData, weaponChipData.chipData
	end
	if not chipData[tostring(chipIndex)] then
		local _ENV, chipInfo = chipData[tostring(chipIndex)], chipData[tostring(chipIndex)]
	end
	if next(chipInfo) then
		chipInfo.status = gWeaponChipStatus.UNLOCKED
	else
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local unlockQueue = queueCtrl:queryQueue(gQueueTypeDef.miraculous_weapon_unlock)
		if unlockQueue and unlockQueue.data.weaponID == weaponID and unlockQueue.data.index == chipIndex then
			chipInfo.status = gWeaponChipStatus.UNLOCKING
		else
			local chipConfig = miraculousWeaponltCtrl.getChipsInfo(weaponID, chipIndex)
			local unlockCondition = miraculousWeaponltCtrl.getWeaponInfo(weaponID).unlockCondition
			if not chipData[tostring(chipIndex - 1)] then
				local _ENV, preChipData = chipData[tostring(chipIndex - 1)], chipData[tostring(chipIndex - 1)]
			end
			if (unlockCondition == 0 or self:isWeaponMerged(unlockCondition)) and SoraDGetCastleLv() >= chipConfig.cityLevel and (1 < chipIndex and next(preChipData) or chipIndex == 1) then
				chipInfo.status = gWeaponChipStatus.BEUNLOCK
			else
				chipInfo.status = gWeaponChipStatus.LOCKED
				chipInfo.cityLevel = chipConfig.cityLevel
			end
		end
	end
	return chipInfo
end
function miraculousWeaponCtrl:calcWeaponPower(weaponID, weaponBuff)
	local weaponData = self:getWeaponInfo(weaponID)
	local totalPower = 0
	if weaponData then
		local weaponConfig = miraculousWeaponltCtrl.getWeaponInfo(weaponID)
		local basePower = weaponConfig.basePower
		totalPower = totalPower + basePower
		local perExtremePower = weaponConfig.extrePower / 4
		for k, v in pairs(weaponBuff) do
			if type(v) == "table" then
				local max = miraculousWeaponltCtrl.getWeaponMaxBuffValue(weaponID, v.buffType)
				local curPower = math.floor(v.value / max * perExtremePower)
				totalPower = totalPower + curPower
			end
		end
	end
	return totalPower
end
function miraculousWeaponCtrl:hasAnyFreeTimes()
	local weaponList = miraculousWeaponltCtrl.getAllWeapon()
	for weaponID, _ in pairs(weaponList) do
		local wakeCount = self:getWakeCountAndCost(tonumber(weaponID))
		local freeCount = miraculousWeaponltCtrl.getWeaponInfo(tonumber(weaponID)).wakeNum
		local isMerged = self:isWeaponMerged(tonumber(weaponID))
		if isMerged and wakeCount < freeCount then
			return true
		end
	end
	return false
end
function miraculousWeaponCtrl:hasAnyChipsFull()
	local ret = false
	local weaponList = miraculousWeaponltCtrl.getAllWeapon()
	for weaponID, _ in pairs(weaponList) do
		local isChipsFull = true
		local isMerged = self:isWeaponMerged(tonumber(weaponID))
		if isMerged then
			isChipsFull = false
		else
			for j = 1, gWeaponChipNum do
				local chipInfo = self:getWeaponChipsInfo(tonumber(weaponID), j)
				if chipInfo.status ~= gWeaponChipStatus.UNLOCKED then
					isChipsFull = false
					break
				end
			end
		end
		if isChipsFull == true then
			ret = true
			return ret
		end
	end
	return ret
end
return miraculousWeaponCtrl
