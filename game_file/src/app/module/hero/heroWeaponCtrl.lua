local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local heroWeaponCtrl = class("heroWeaponCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function heroWeaponCtrl:ctor(properties)
	heroWeaponCtrl.super.ctor(self, properties)
end
function heroWeaponCtrl:Logout()
	heroWeaponCtrl.super.Logout(self)
	self:resetData()
end
function heroWeaponCtrl:resetData()
	self.wearMap, _UPVALUE0_, self.weaponMap, _UPVALUE0_ = nil, nil, nil, nil
end
function heroWeaponCtrl:initClientData(data)
	dump(data, "heroWeaponCtrl:initClientData", 5)
	if data then
		if not data.weaponMap then
			_ENV = data.weaponMap
		end
		self.weaponMap = data.weaponMap
		if not data.wearMap then
			_ENV = data.wearMap
		end
		self.wearMap = data.wearMap
	end
	self:registerNotify()
end
function heroWeaponCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_INIT, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_UPGRADE_LV, handler(self, self.upgradeLvRsp))
	msgCtrl.register(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_UPGRADE_STAGE, handler(self, self.upgradeStageRsp))
	msgCtrl.register(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_SELL, handler(self, self.sellRsp))
	msgCtrl.register(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_REBIRTH, handler(self, self.rebirthRsp))
	msgCtrl.register(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_MERGE, handler(self, self.mergeRsp))
	self:reqInit()
end
function heroWeaponCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_WEAPON, handler(self, self.notifyHandler))
end
function heroWeaponCtrl:notifyHandler(event)
	dump(event, "heroWeaponCtrl:notifyHandler", 5)
	for _, content in ipairs(event.data) do
		if content.type == "wear" then
			self.wearMap = content.wearMap
		end
		if content.type == "addWeapon" then
			local _ENV, itemList = content.type, content.type
			for k, v in pairs(content.addWeaponMap) do
				self.weaponMap[k] = v
				_ENV = nil
				;(nil).id = v.weaponID
				;(nil).count = 1
				table.insert(itemList, nil)
			end
			SoraDMailGainItems(itemList, true)
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_HERO_WEAPON_SERVER_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function heroWeaponCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_INIT, nil)
end
function heroWeaponCtrl:reqUpgradeLv(weaponUid, itemCount)
	serverproxy = nil
	;(nil).weaponUid = weaponUid
	;(nil).itemCount = itemCount
	serverproxy:Request(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_UPGRADE_LV, nil)
end
function heroWeaponCtrl:reqUpgradeStage(weaponUid, weaponUidList)
	serverproxy = nil
	;(nil).weaponUid = weaponUid
	;(nil).weaponUidList = weaponUidList
	serverproxy:Request(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_UPGRADE_STAGE, nil)
end
function heroWeaponCtrl:reqSell(weaponUidList)
	serverproxy = nil
	;(nil).weaponUidList = weaponUidList
	serverproxy:Request(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_SELL, nil)
end
function heroWeaponCtrl:reqRebirth(weaponUid)
	serverproxy = nil
	;(nil).weaponUid = weaponUid
	serverproxy:Request(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_REBIRTH, nil)
end
function heroWeaponCtrl:reqMerge(weaponID, count)
	serverproxy = nil
	;(nil).weaponID = weaponID
	;(nil).count = count or 1
	serverproxy:Request(gCmd.CMD_HERO_WEAPON_MODULE, gCmd.REQ_HERO_WEAPON_MERGE, nil)
end
function heroWeaponCtrl:initRsp(content)
	dump(content, "heroWeaponCtrl:initRsp", 5)
	if gErrDef.Err_None == content.err then
		self.weaponMap = content.rspdata.weaponMap
		self.wearMap = content.rspdata.wearMap
	end
end
function heroWeaponCtrl:upgradeLvRsp(content)
	dump(content, "heroWeaponCtrl:upgradeLvRsp", 5)
	if gErrDef.Err_None == content.err then
		local info = content.rspdata.info
		self.weaponMap[tostring(info.id)] = info
	end
	_ENV = self.weaponMap
	self.weaponMap.msg = "MESSAGE_HERO_WEAPON_SERVER_UPDATE"
	SoraDSendMessage(self.weaponMap)
end
function heroWeaponCtrl:upgradeStageRsp(content)
	dump(content, "heroWeaponCtrl:upgradeStageRsp", 5)
	if gErrDef.Err_None == content.err then
		local info = content.rspdata.info
		self.weaponMap[tostring(info.id)] = info
		for k, v in ipairs(content.data.weaponUidList) do
			self.weaponMap[tostring(v)] = nil
		end
	end
	_ENV = ipairs(content.data.weaponUidList)
	ipairs(content.data.weaponUidList).msg = "MESSAGE_HERO_WEAPON_SERVER_UPDATE"
	SoraDSendMessage(ipairs(content.data.weaponUidList))
end
function heroWeaponCtrl:sellRsp(content)
	dump(content, "heroWeaponCtrl:sellRsp", 5)
	if gErrDef.Err_None == content.err then
		if not content.rspdata.rewards then
			local _ENV, rewards = content.rspdata.rewards, content.rspdata.rewards
		end
		if 0 < #rewards then
			SoraDMailGainItems(rewards, true)
		end
		for k, v in ipairs(content.data.weaponUidList) do
			self.weaponMap[tostring(v)] = nil
		end
	end
	_ENV = ipairs(content.data.weaponUidList)
	ipairs(content.data.weaponUidList).msg = "MESSAGE_HERO_WEAPON_SERVER_UPDATE"
	SoraDSendMessage(ipairs(content.data.weaponUidList))
end
function heroWeaponCtrl:rebirthRsp(content)
	dump(content, "heroWeaponCtrl:rebirthRsp", 5)
	if gErrDef.Err_None == content.err then
		local weaponUid = content.data.weaponUid
		self.weaponMap[tostring(weaponUid)].stage = 0
		self.weaponMap[tostring(weaponUid)].lv = 0
		self.weaponMap[tostring(weaponUid)].exp = 0
		if not content.rspdata.rewards then
			local _ENV, rewards = content.rspdata.rewards, content.rspdata.rewards
		end
		if 0 < #rewards then
			SoraDMailGainItems(rewards, true)
		end
	end
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_HERO_WEAPON_SERVER_REBIRTH"
	SoraDSendMessage(content.rspdata.rewards)
	_ENV = content.rspdata.rewards
	content.rspdata.rewards.msg = "MESSAGE_HERO_WEAPON_SERVER_UPDATE"
	SoraDSendMessage(content.rspdata.rewards)
end
function heroWeaponCtrl:mergeRsp(content)
	dump(content, "heroWeaponCtrl:mergeRsp", 5)
	if gErrDef.Err_None == content.err then
	end
end
function heroWeaponCtrl:getWeaponMap()
	return self.weaponMap
end
function heroWeaponCtrl:getWeaponByUid(weaponUid)
	return self.weaponMap[tostring(weaponUid)]
end
function heroWeaponCtrl:getWeaponListByID(weaponId, exUidList)
	local _ENV, ret
	for k, v in pairs(self.weaponMap) do
		if v.weaponID == weaponId and not self:getWearHeroId(v.id) and v.stage == 0 and (not exUidList or exUidList and not SoraDisInList(v.id, exUidList)) then
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(a, b)
		if a.stage == b.stage then
			if a.lv == b.lv then
				return a.exp < b.exp
			else
				return a.lv < b.lv
			end
		else
			return a.stage < b.stage
		end
	end)
	return ret
end
function heroWeaponCtrl:getWeaponByID(weaponId)
	local ret
	for k, v in pairs(self.weaponMap) do
		if v.weaponID == weaponId then
			ret = v
			break
		end
	end
	return ret
end
function heroWeaponCtrl:getWeaponMaxStage(weaponId)
	local stage = 0
	for k, v in pairs(self.weaponMap) do
		if v.weaponID == weaponId then
			stage = math.max(stage, v.stage)
		end
	end
	return stage
end
function heroWeaponCtrl:getWearHeroId(weaponUid)
	return self.wearMap[tostring(weaponUid)]
end
function heroWeaponCtrl:isHaveMergeEnable()
	local ret = false
	local _ENV, map
	local heroWeaponRead = include("heroWeaponRead")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local cfg = heroWeaponRead.getWeaponMapCfg()
	for k, v in ipairs(cfg) do
		if next(v.synthesis) then
			local chipID = v.synthesis[1]
			local need = v.synthesis[2]
			local num = backpackCtrl:getItemCount(chipID)
			if need <= num then
				ret = true
				map[tostring(v.weaponId)] = true
			end
		end
	end
	return ret, map
end
function heroWeaponCtrl:getToMaxNeed(weaponId, chipMergeNum)
	local heroWeaponRead = include("heroWeaponRead")
	local curNum = chipMergeNum
	local needNum = heroWeaponRead.getWeaponStageToMaxNeed(weaponId, self:getWeaponMaxStage(weaponId))
	for k, v in pairs(self.weaponMap) do
		if v.weaponID == weaponId then
			curNum = curNum + 1
		end
	end
	curNum = curNum - 1
	return curNum, needNum
end
return heroWeaponCtrl
