local GameModule = include("GameModule")
local godArmsCtrl = class("godArmsCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local equipDesRead = include("equipDesRead")
local condParser = include("condParser")
local attributeSystem = include("attributeSystem")
function godArmsCtrl:ctor(properties)
	godArmsCtrl.super.ctor(self, properties)
end
function godArmsCtrl:EnterGame()
	godArmsCtrl.super.EnterGame(self)
	godArmsCtrl = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_INIT, handler(self, self.initClientData))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_AMRS_UNLOCK, handler(self, self.reqUnlockRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_REFINE, handler(self, self.reqRefineRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_WAKE, handler(self, self.reqAwakeRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_DEFEND, handler(self, self.reqSaveDefendRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_USE_SKILL, handler(self, self.reqUseSkillRsp))
	msgCtrl.register(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_SHARE, handler(self, self.reqShareRsp))
	self:resetData()
	self:registerNotify()
	godArmsCtrl = handler(self, self.reqShareRsp)
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_INIT, handler(self, self.reqShareRsp))
end
function godArmsCtrl:resetData()
	self.skillList, _UPVALUE0_, self.armsList, _UPVALUE0_ = nil, nil, nil, nil
	self.defendArmID = 0
	self.lastShareTime = 0
end
function godArmsCtrl:initClientData(ret)
	dump(ret, "godArmsCtrl:initClientData====", 10)
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata.initData
		local armsInfo = equipDesRead.getArtifactInfo()
		for i, v in ipairs(armsInfo) do
			self.armsList[i] = v
			if rspdata.armsList[tostring(v.weaponID)] then
				self.armsList[i].isLock = false
				self.armsList[i].info = rspdata.armsList[tostring(v.weaponID)]
			else
				self.armsList[i].isLock = true
			end
		end
		self.defendArmID = rspdata.defendArmID
		self.lastShareTime = rspdata.lastShareTime
		self:initArmsAttrData()
	end
	dump(self.armsList, "self.armsList", 10)
end
function godArmsCtrl:getArmsList()
	return self.armsList
end
function godArmsCtrl:getArmsInfo(id)
	for k, v in ipairs(self.armsList) do
		if tonumber(v.weaponID) == tonumber(id) then
			return v
		end
	end
end
function godArmsCtrl:isWeaponUnlock(id)
	local ret = false
	for k, v in ipairs(self.armsList) do
		if v.weaponID == id and not v.isLock then
			ret = true
			break
		end
	end
	return ret
end
function godArmsCtrl:isCanFreeRefine()
	for i, v in ipairs(self.armsList) do
		if v.info and v.info.normalRefineTimes and v.info.normalRefineTimes < ARMS_FREE_REFINE and (v.info.level ~= ARMS_MAX_LEVEL_NORMAL or v.info.awakeStatus ~= ARMS_AWAKE_STATUS.STATUS_NORMAL) and v.info.level ~= ARMS_MAX_LEVEL_ADVANCE then
			return true, i
		end
	end
	return false
end
function godArmsCtrl:isCanUnlock()
	local condParser = include("condParser")
	local ret = false
	for i, v in ipairs(self.armsList) do
		if v.isLock and v.unlockCondition and #v.unlockCondition > 0 then
			local canUnlock = 0
			for _, data in ipairs(v.unlockCondition) do
				if data.type == ARMS_UNLOCK_TYPE.UNLOCK_CASTLE then
					_ENV = ARMS_UNLOCK_TYPE.UNLOCK_CASTLE
					ARMS_UNLOCK_TYPE.UNLOCK_CASTLE.condtype = gCondType.buildlv
					ARMS_UNLOCK_TYPE.UNLOCK_CASTLE.id = data.id
					ARMS_UNLOCK_TYPE.UNLOCK_CASTLE.condvalue = data.value
					ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_CASTLE)
				elseif data.type == ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL then
					_ENV = ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL
					ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.condtype = gCondType.artifactlv
					ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.id = data.id
					ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL.condvalue = data.value
					ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_ARMS_LEVEL)
				elseif data.type == ARMS_UNLOCK_TYPE.UNLOCK_ITEM then
					_ENV = ARMS_UNLOCK_TYPE.UNLOCK_ITEM
					ARMS_UNLOCK_TYPE.UNLOCK_ITEM.condtype = gCondType.itemcount
					ARMS_UNLOCK_TYPE.UNLOCK_ITEM.id = data.id
					ARMS_UNLOCK_TYPE.UNLOCK_ITEM.condvalue = data.value
					ret = condParser.verify(ARMS_UNLOCK_TYPE.UNLOCK_ITEM)
				end
				if ret then
					canUnlock = canUnlock + 1
				end
			end
			if canUnlock >= #v.unlockCondition then
				return true, i
			end
		end
	end
	return false
end
function godArmsCtrl:getShareCDTime()
	return self.lastShareTime + ARMS_SHARE_CD_TIME - serviceFunctions.systemTime()
end
function godArmsCtrl:getDefend()
	return self.defendArmID
end
function godArmsCtrl:getSkillList()
	local _ENV, unlock
	local index = 1
	for i, v in ipairs(self.armsList) do
		if v.isLock then
			table.insert(unlock, equipDesRead.getArtifactActiveSkill(v.weaponID))
		else
			local data = serviceFunctions.table_copy_table(equipDesRead.getArtifactActiveSkill(v.weaponID))
			for k, v in pairs(v.info.activeSkillList[1]) do
				data[k] = v
			end
			table.insert(unlock, index, data)
			index = index + 1
		end
	end
	return unlock
end
function godArmsCtrl:skillInCD(skillID, cd)
	for i, v in ipairs(self.armsList) do
		if not v.isLock then
			for k, time in pairs(v.info.skillCD) do
				if tonumber(k) == skillID then
					local curTime = serviceFunctions.systemTime()
					if curTime < time + cd then
						return true, time + cd - curTime
					end
					return false
				end
			end
		end
	end
	return false
end
function godArmsCtrl:getArmsListByID(weaponID)
	local _ENV, ret
	for i, v in ipairs(self.armsList) do
		if v.weaponID == weaponID then
			ret = v
			break
		end
	end
	return ret
end
function godArmsCtrl:getArmLvByID(weaponID)
	local ret = 0
	for i, v in ipairs(self.armsList) do
		if v.weaponID == weaponID and v.info and not v.isLock then
			ret = v.info.level
			break
		end
	end
	return ret
end
function godArmsCtrl:isUnlockNeedItem(itemID)
	local weaponID = equipDesRead.Item2UnlockEquipID(itemID)
	print("====", itemID, weaponID)
	if weaponID then
		for _, v in pairs(self.armsList) do
			if v.weaponID == weaponID then
				return v.isLock
			end
		end
	end
	return false
end
function godArmsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOTIFY_GOD_ARMS, handler(self, self.notifyHandler))
end
function godArmsCtrl:notifyHandler(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in pairs(event.data) do
			local notifyData = content.data
			for i, v in ipairs(notifyData) do
				for j, a in ipairs(self.armsList) do
					if a.weaponID == v.armsID then
						self.armsList[j].isLock = false
						self.armsList[j].info = v
						break
					end
				end
			end
			if content.type and content.type == "changeDef" then
				self.defendArmID = notifyData.defendArmID
			end
		end
	end
end
function godArmsCtrl:resetArmsAttrData(reason)
	for _, data in ipairs(self.armsList) do
		if not data.isLock then
			for k, v in pairs(data.info.skillList) do
				local skillType = tonumber(k)
				local bActive = v.isActive
				if bActive then
					if reason == "awake" then
						local lastSKillInfo = equipDesRead.getArtifactAttrInfo(skillType, data.info.level, ARMS_AWAKE_STATUS.STATUS_NORMAL)
						if lastSKillInfo then
							for i, __ in ipairs(lastSKillInfo.activeType) do
								local activeType = lastSKillInfo.activeType[i]
								local attrType = lastSKillInfo.buffType[i]
								local source = gAttributeSourceEnum.GOD_ARMS
								attributeSystem.remove(attrType, lastSKillInfo.weaponID, source)
							end
						end
					end
					local skillInfo = equipDesRead.getArtifactAttrInfo(skillType, data.info.level, data.info.awakeStatus)
					if skillInfo then
						for i, __ in ipairs(skillInfo.activeType) do
							local activeType = skillInfo.activeType[i]
							if activeType == gArmsSkillActiveType.PASSIVE_SKILL or activeType == gArmsSkillActiveType.BATTLE_SKILL then
								local attrType = skillInfo.buffType[i]
								local attrValue = skillInfo.buffValue[i]
								local source = gAttributeSourceEnum.GOD_ARMS
								if reason == "levelup" then
									attributeSystem.remove(attrType, skillInfo.weaponID, source)
								end
								attributeSystem.initAttr(attrType, skillInfo.weaponID, attrValue, source)
							end
						end
					end
				end
			end
		end
	end
end
function godArmsCtrl:initArmsAttrData()
	for _, data in ipairs(self.armsList) do
		if not data.isLock then
			for k, v in pairs(data.info.skillList) do
				local skillType = tonumber(k)
				local bActive = v.isActive
				if bActive then
					local skillInfo = equipDesRead.getArtifactAttrInfo(skillType, data.info.level, data.info.awakeStatus)
					if skillInfo then
						for i, __ in ipairs(skillInfo.activeType) do
							local activeType = skillInfo.activeType[i]
							if activeType == gArmsSkillActiveType.PASSIVE_SKILL or activeType == gArmsSkillActiveType.BATTLE_SKILL then
								local attrType = skillInfo.buffType[i]
								local attrValue = skillInfo.buffValue[i]
								local source = gAttributeSourceEnum.GOD_ARMS
								attributeSystem.initAttr(attrType, skillInfo.weaponID, attrValue, source)
							end
						end
					end
				end
			end
		end
	end
end
function godArmsCtrl:Logout()
	print("godArmsCtrl:Logout()")
	self:resetData()
	if commonCheck.ARTIFACT then
		equipDesRead.artifactInit()
	end
	godArmsCtrl.super.Logout(self)
end
function godArmsCtrl:reqUnlock(weaponID)
	serverproxy = nil
	;(nil).armsID = weaponID
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_AMRS_UNLOCK, nil)
end
function godArmsCtrl:reqRefine(weaponID, refineType, times, useGold)
	serverproxy = nil
	;(nil).armsID = weaponID
	;(nil).refineType = refineType
	;(nil).refineTimes = times
	;(nil).useGold = useGold
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_REFINE, nil)
end
function godArmsCtrl:reqAwake(weaponID)
	serverproxy = nil
	;(nil).armsID = weaponID
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_WAKE, nil)
end
function godArmsCtrl:reqSaveDefend(weaponID)
	serverproxy = nil
	;(nil).armsID = weaponID
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_DEFEND, nil)
end
function godArmsCtrl:reqUseSkill(weaponID, skillID)
	serverproxy = nil
	;(nil).armsID = weaponID
	;(nil).skillID = skillID
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_USE_SKILL, nil)
end
function godArmsCtrl:reqShare(weaponID, channel)
	serverproxy = nil
	;(nil).armsID = weaponID
	;(nil).channel = channel
	serverproxy:Request(gCmd.CMD_GOD_ARMS_MODULE, gCmd.REQ_GOD_ARMS_SHARE, nil)
end
function godArmsCtrl:reqUnlockRsp(ret)
	dump(ret, "reqUnlockRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata
		local weaponInfo = rspdata.armsInfo
		for i, v in ipairs(self.armsList) do
			if v.weaponID == tonumber(weaponInfo.armsID) then
				self.armsList[i].isLock = false
				self.armsList[i].info = weaponInfo
				break
			end
		end
		self:resetArmsAttrData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_GODEQUIP_UNLOCK"
		self.weaponID = weaponInfo.armsID
		SoraDSendMessage(self)
	end
end
function godArmsCtrl:reqRefineRsp(ret)
	dump(ret, "reqActiveRsp ret============", 10)
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata
		local weaponInfo = rspdata.armsInfo
		local critData = rspdata.critData
		for i, v in ipairs(self.armsList) do
			if v.weaponID == tonumber(weaponInfo.armsID) then
				self.armsList[i].info = weaponInfo
				break
			end
		end
		self:resetArmsAttrData("levelup")
		_ENV = self
		self.msg = "MESSAGE_SERVER_GODEQUIP_REFINE_BACK"
		self.weaponID = weaponInfo.armsID
		self.critData = critData
		self.refineType = ret.data.refineType
		SoraDSendMessage(self)
		if weaponInfo.activeSkillList[1].isActive then
			_ENV = self
			self.msg = "MESSAGE_SERVER_GODEQUIP_SKILL_BACK"
			SoraDSendMessage(self)
		end
	end
end
function godArmsCtrl:reqAwakeRsp(ret)
	dump(ret, "reqAwakeRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata
		local weaponInfo = rspdata.armsInfo
		for i, v in ipairs(self.armsList) do
			if v.weaponID == tonumber(weaponInfo.armsID) then
				self.armsList[i].isLock = false
				self.armsList[i].info = weaponInfo
				break
			end
		end
		self:resetArmsAttrData("awake")
		_ENV = self
		self.msg = "MESSAGE_SERVER_GODEQUIP_AWAKE_BACK"
		self.weaponID = weaponInfo.armsID
		SoraDSendMessage(self)
	end
end
function godArmsCtrl:reqSaveDefendRsp(ret)
	dump(ret, "reqSaveRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata
		self.defendArmID = rspdata.defendArmID
	end
end
function godArmsCtrl:reqUseSkillRsp(ret)
	dump(ret, "reqUseSkill ret============")
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata
		local weaponInfo = rspdata.armsInfo
		for i, v in ipairs(self.armsList) do
			if v.weaponID == tonumber(weaponInfo.armsID) then
				self.armsList[i].isLock = false
				self.armsList[i].info = weaponInfo
				break
			end
		end
		_ENV = ipairs(self.armsList)
		ipairs(self.armsList).msg = "MESSAGE_SERVER_GODEQUIP_SKILL_BACK"
		SoraDSendMessage(ipairs(self.armsList))
	end
end
function godArmsCtrl:reqShareRsp(ret)
	dump(ret, "reqShareRsp ret============")
	if ret and ret.err == gErrDef.Err_None then
		local rspdata = ret.rspdata
		self.lastShareTime = rspdata.starttime
	end
end
return godArmsCtrl
