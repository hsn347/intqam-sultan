local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local achievementctrl = class("achievementctrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local achiDesRead = include("achiDesRead")
function achievementctrl:ctor(properties)
	achievementctrl.super.ctor(self, properties)
	self.handle_achievement_notify = nil
	self.handle_achievement_buff_notify = nil
	achievementctrl, self.dataTable, achievementctrl, self.achievementInfo = achievementctrl.super.ctor, achievementctrl.super.ctor, achievementctrl.super.ctor, nil
	achievementctrl.super.ctor[gBuffEffect.TROOP_ATTACK_BOOST] = gAchieveProperty.SOLDIER_ATTACK
	achievementctrl.super.ctor[gBuffEffect.TROOP_DEFENSE_BOOST] = gAchieveProperty.SOLDIER_DEFENSE
	achievementctrl.super.ctor[gBuffEffect.TRAIN_SPEED_BOOST] = gAchieveProperty.SOLDIER_TRAIN_SPEED
	achievementctrl.super.ctor[gBuffEffect.MARCH_SPEED_BOOST] = gAchieveProperty.MARCH_SPEED
	achievementctrl.super.ctor[gBuffEffect.BUILD_SPEED_BOOST] = gAchieveProperty.BUILD_BUILDING_SPEED
	achievementctrl.super.ctor[gBuffEffect.RESOURCE_OUTPUT_BOOST] = gAchieveProperty.RESOURCE_OUTPUT
	achievementctrl.super.ctor[gBuffEffect.MARCH_MONSTER_SPEED_BOOST] = gAchieveProperty.MARCH_MONSTER_SPEED
	achievementctrl.super.ctor[gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST] = gAchieveProperty.WOUNDED_SOLDIER_LIMIT
	achievementctrl.super.ctor[gBuffEffect.FORGE_EQUIPMENT_SPEED_BOOST] = gAchieveProperty.FORGE_EQUIPMENT_SPEED
	achievementctrl.super.ctor[gBuffEffect.TROOP_HP_BOOST] = gAchieveProperty.SOLDIER_HP
	achievementctrl.super.ctor[gBuffEffect.RESOURCE_PROTECT_BOOST] = gAchieveProperty.RESOURCE_PROTECT_BOOST
	achievementctrl.super.ctor[gBuffEffect.SOLDIER_LOAD_BOOST] = gAchieveProperty.SOLDIER_LOAD
	achievementctrl.super.ctor[gBuffEffect.CURE_SOLDIER_SPEED_BOOST] = gAchieveProperty.CURE_SOLDIER_SPEED
	achievementctrl.super.ctor[gBuffEffect.MARCH_LIMIT_BOOST] = gAchieveProperty.MARCH_LIMIT_BOOST
	achievementctrl.super.ctor[gBuffEffect.WISH_RESOURCE_BOOST] = gAchieveProperty.WISH_RESOURCE_BOOST
	achievementctrl.super.ctor[gBuffEffect.LORD_NAME_DRESS_UP] = gAchieveProperty.LORD_NAME_DRESS_UP
	achievementctrl.super.ctor[gBuffEffect.MARCH_EFFECT] = gAchieveProperty.MARCH_EFFECT
	achievementctrl.super.ctor[gBuffEffect.HERO_UPGRADE_SPEED] = gAchieveProperty.HERO_UPGRADE_SPEED
	achievementctrl.super.ctor[gBuffEffect.EXECUTE_WAITING_TIME] = gAchieveProperty.EXECUTE_WAITING_TIME
	achievementctrl.super.ctor[gBuffEffect.HERO_CAPTURE_PRO] = gAchieveProperty.HERO_CAPTURE_PRO
	achievementctrl.super.ctor[gBuffEffect.HERO_NOT_CAPTURED_PRO] = gAchieveProperty.HERO_NOT_CAPTURED_PRO
	achievementctrl.super.ctor[gBuffEffect.REINFORCEMENTS_MAX_COUNT] = gAchieveProperty.REINFORCEMENTS_MAX_COUNT
	achievementctrl.super.ctor[gBuffEffect.TRANDFORM_WOUNDED] = gAchieveProperty.TRANDFORM_WOUNDED
	achievementctrl.super.ctor[gBuffEffect.BRIGHT_STRENGTHEN_TIME_REDUCE] = gAchieveProperty.BRIGHT_STRENGTHEN_TIME_REDUCE
	achievementctrl.super.ctor[gBuffEffect.BEACON_TOWER_OCCUPY_NEED_TIME_REDUCE] = gAchieveProperty.BEACON_TOWER_OCCUPY_NEED_TIME_REDUCE
	achievementctrl.super.ctor[gBuffEffect.CHECKPOINT_LIST_AMBER_EXTRA_GET] = gAchieveProperty.CHECKPOINT_LIST_AMBER_EXTRA_GET
	achievementctrl.super.ctor[gBuffEffect.PALACE_LIST_AMBER_EXTRA_GET] = gAchieveProperty.PALACE_LIST_AMBER_EXTRA_GET
	achievementctrl.super.ctor[gBuffEffect.EXPLOITS_CALCULATION_RATE_ADD] = gAchieveProperty.EXPLOITS_CALCULATION_RATE_ADD
	achievementctrl.super.ctor[gBuffEffect.RADIANCE_WAR_STAR_SHINE_YIELD] = gAchieveProperty.RADIANCE_WAR_STAR_SHINE_YIELD
	self.buffVsAchieve, achievementctrl.super.ctor[gBuffEffect.RADIANCE_WAR_AMBER_YIELD] = achievementctrl.super.ctor, gAchieveProperty.RADIANCE_WAR_AMBER_YIELD
end
function achievementctrl:getAchievementData()
	return self.dataTable
end
function achievementctrl:getAchievementInfo()
	return self.achievementInfo
end
function achievementctrl:packAchievementInfo()
	local _ENV, ret
	local data = self.achievementInfo
	if data and data.isShow then
		ret.isShow = data.isShow
		ret.showMetalID = data.showMetalID
		ret.showAchieveID = data.showAchieveID
	else
		ret.isShow = false
		ret.showMetalID = 0
		ret.showAchieveID = 0
	end
	if data then
		if nil == data.totalStar or 0 == data.totalStar then
			ret.doneRatio = 0
		else
			local constantRead = include("constantRead")
			local maxStar = constantRead.getConstValue("ACHIEVE_SHOW_PERCENTAGE_MAX_STAR", MEDAL_TOTAL_STAR)
			ret.doneRatio = SoraDPreciseDecimal(tonumber(data.mystar) / maxStar * 100, 2)
		end
		ret.metalNum = data.metalNum
	end
	return ret
end
function achievementctrl:updateAchieveInfoInLordInfo()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if lordInfoCtrl then
		lordInfoCtrl:updateAchieveInfo(self:packAchievementInfo())
	end
end
function achievementctrl:getTipNum()
	if nil ~= self.achievementInfo then
		return self.achievementInfo.tipNum
	end
	return 0
end
function achievementctrl:getIsShowMetal()
	if nil ~= self.achievementInfo then
		return self.achievementInfo.isShow
	end
	return false
end
function achievementctrl:getCurUnlockID()
	if nil ~= self.achievementInfo then
		return self.achievementInfo.curUnlockID
	end
	return 0
end
function achievementctrl:getBuffValue(mEffectType)
	local tmpBuffType = self.buffVsAchieve[mEffectType]
	if not tmpBuffType then
		return nil
	end
	local tmpBuffValue
	for k, v in pairs(self.dataTable) do
		local maxAchieveID = v.maxDoneID
		local tmpCfg = achiDesRead.getInfoById(maxAchieveID)
		if tmpCfg and tmpCfg.medalBuff and #tmpCfg.medalBuff > 0 then
			local tmpAchieveEffectType = tmpCfg.medalBuff[1]
			if tmpAchieveEffectType == tmpBuffType then
				if nil == tmpBuffValue then
					tmpBuffValue = 0
				end
				if self:isInitiativeBuff(tmpBuffType) then
					if 1 == v.hasBuff then
						tmpBuffValue = tonumber(tmpCfg.medalBuff[2])
					end
					break
				end
				tmpBuffValue = tmpBuffValue + tmpCfg.medalBuff[2]
			end
		end
	end
	return tmpBuffValue
end
function achievementctrl:isInitiativeBuff(mType)
	mType = tonumber(mType)
	if mType and (gAchieveProperty.LORD_NAME_DRESS_UP == mType or gAchieveProperty.MARCH_EFFECT == mType) then
		return true
	end
	return false
end
function achievementctrl:initClientData(data)
	self:checkRetData(data)
	self:updateAchievementInfo()
end
function achievementctrl:checkRetData(data)
	self.dataTable, _ENV, self.achievementInfo = nil, nil, data
	if nil ~= data then
		local tmpList = self.achievementInfo.list
		for k, v in pairs(tmpList) do
			local _ENV, tmpItem
			tmpItem.id = v.curID
			tmpItem.cur = v.cur
			tmpItem.total = v.total
			tmpItem.star = v.star
			tmpItem.bingo = v.bingo
			tmpItem.medalID = v.medalID
			tmpItem.maxDoneID = v.maxDoneID
			tmpItem.hasBuff = v.hasBuff
			table.insert(self.dataTable, tmpItem)
		end
	end
	local curUnlockID = self:getCurUnlockID()
	if curUnlockID ~= 0 then
		local achiProductRead = include("achiProductRead")
		local pid = achiProductRead.getPIDbyAID(curUnlockID)
	end
	self:updateAchieveInfoInLordInfo()
	print("achievementctrl:curUnlockID:", curUnlockID)
end
function achievementctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_REWARD, handler(self, self.getRewardRsp))
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_REFRESH, handler(self, self.getRefreshRsp))
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_OPEN_BUFF, handler(self, self.getOpenBuffRsp))
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_CLOSE_BUFF, handler(self, self.getCloseBuffRsp))
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_SWITCH_METAL, handler(self, self.getSwitchMetalRsp))
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_SET_METAL, handler(self, self.getSetMetalRsp))
	msgCtrl.register(gCmd.CMD_ACHIEVEMENT_MODULE, gCmd.REQ_ACHIEVEMENT_METAL_INFO, handler(self, self.getOtherLordMetalInfoRsp))
end
function achievementctrl:sendReward(mID)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_ACHIEVEMENT_REWARD, gCmd.REQ_ACHIEVEMENT_REWARD
		;(nil).data, gCmd.REQ_ACHIEVEMENT_REWARD.id = gCmd.REQ_ACHIEVEMENT_REWARD, mID
		local msg
		serverproxy:SendMsg(msg)
	end
end
function achievementctrl:sendRefresh()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
	local (nil).subcmd, msg = gCmd.REQ_ACHIEVEMENT_REFRESH, nil
	serverproxy:SendMsg(msg)
end
function achievementctrl:sendOpenBuff(mID)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_ACHIEVEMENT_OPEN_BUFF, gCmd.REQ_ACHIEVEMENT_OPEN_BUFF
		;(nil).data, gCmd.REQ_ACHIEVEMENT_OPEN_BUFF.id = gCmd.REQ_ACHIEVEMENT_OPEN_BUFF, mID
		local msg
		serverproxy:SendMsg(msg)
	end
end
function achievementctrl:sendCloseBuff(mID)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_ACHIEVEMENT_CLOSE_BUFF, gCmd.REQ_ACHIEVEMENT_CLOSE_BUFF
		;(nil).data, gCmd.REQ_ACHIEVEMENT_CLOSE_BUFF.id = gCmd.REQ_ACHIEVEMENT_CLOSE_BUFF, mID
		local msg
		serverproxy:SendMsg(msg)
	end
end
function achievementctrl:sendOtherLordMetalInfo(mKid, mUID)
	if mUID and mKid then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_ACHIEVEMENT_METAL_INFO, gCmd.REQ_ACHIEVEMENT_METAL_INFO
		gCmd.REQ_ACHIEVEMENT_METAL_INFO.uid = mUID
		;(nil).data, gCmd.REQ_ACHIEVEMENT_METAL_INFO.kid = gCmd.REQ_ACHIEVEMENT_METAL_INFO, mKid
		local msg
		serverproxy:SendMsg(msg)
	end
end
function achievementctrl:sendSwitchMetal(mSwitch)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_ACHIEVEMENT_SWITCH_METAL, gCmd.REQ_ACHIEVEMENT_SWITCH_METAL
	;(nil).data, gCmd.REQ_ACHIEVEMENT_SWITCH_METAL.switch = gCmd.REQ_ACHIEVEMENT_SWITCH_METAL, mSwitch
	local msg
	serverproxy:SendMsg(msg)
end
function achievementctrl:sendSetMetal(mID)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_ACHIEVEMENT_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_ACHIEVEMENT_SET_METAL, gCmd.REQ_ACHIEVEMENT_SET_METAL
		;(nil).data, gCmd.REQ_ACHIEVEMENT_SET_METAL.id = gCmd.REQ_ACHIEVEMENT_SET_METAL, mID
		local msg
		serverproxy:SendMsg(msg)
	end
end
function achievementctrl:resetData()
	self.dataTable, _UPVALUE0_, self.achievementInfo = nil, nil, nil
end
function achievementctrl:Logout()
	achievementctrl.super.Logout(self)
	self:resetData()
end
function achievementctrl:getRefreshRsp(content)
	dump(content, "achievementctrl:getRefreshRsp====")
	if nil ~= content and nil ~= content.result then
		self:checkRetData(content.result)
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT"
		SoraDSendMessage(self)
	end
end
function achievementctrl:getRewardRsp(content)
	if nil ~= content and gErrDef.Err_None == content.err then
		local tmpData = content.result
		self.achievementInfo.point = tmpData.point
		self.achievementInfo.tipNum = tmpData.tipNum
		self.achievementInfo.mystar = tmpData.mystar
		self.achievementInfo.totalStar = tmpData.totalStar
		self.achievementInfo.curUnlockID = tmpData.curUnlockID
		self.achievementInfo.showMetalID = tmpData.showMetalID
		self.achievementInfo.showAchieveID = tmpData.showAchieveID
		self.achievementInfo.isShow = tmpData.isShow
		self.achievementInfo.metalNum = tmpData.metalNum
		local tmpList = tmpData.list
		for k, v in pairs(tmpList) do
			self.achievementInfo.list[k] = v
		end
	end
	self:updateAchieveInfoInLordInfo()
	self.dataTable, _ENV = self.updateAchieveInfoInLordInfo, self.updateAchieveInfoInLordInfo
	if nil ~= self.achievementInfo then
		local tmpList = self.achievementInfo.list
		for k, v in pairs(tmpList) do
			v.id = v.curID
			table.insert(self.dataTable, v)
		end
	end
	if gErrDef.Err_None == content.err then
		_ENV = content.err
		_ENV, content.err.msg = pairs(tmpList)
		content.err.redata, pairs(tmpList).id = pairs(tmpList)
		SoraDSendMessage(content.err)
	else
		_ENV = content.err
		content.err.msg = "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT"
		SoraDSendMessage(content.err)
	end
end
function achievementctrl:getOpenBuffRsp(content)
	if gErrDef.Err_None == content.err then
		local achieveType = tostring(content.result.achievetype)
		local achieveBuff = content.result.buff
		if self.achievementInfo.list[achieveType] and table.nums(achieveBuff) > 0 then
			self.achievementInfo.list[achieveType].hasBuff = 1
			for k, v in pairs(self.dataTable) do
				if v.maxDoneID == tonumber(content.data.id) then
					v.hasBuff = self.achievementInfo.list[achieveType].hasBuff
					break
				end
			end
		end
		_ENV = pairs(self.dataTable)
		_ENV, pairs(self.dataTable).msg = pairs(self.dataTable)
		pairs(self.dataTable).redata, pairs(self.dataTable).id = pairs(self.dataTable)
		SoraDSendMessage(pairs(self.dataTable))
	else
	end
end
function achievementctrl:getCloseBuffRsp(content)
	if gErrDef.Err_None == content.err then
		local achieveType = tostring(content.result.achievetype)
		if self.achievementInfo.list[achieveType] then
			self.achievementInfo.list[achieveType].hasBuff = 0
			for k, v in pairs(self.dataTable) do
				if v.maxDoneID == tonumber(content.data.id) then
					v.hasBuff = 0
					break
				end
			end
		end
		_ENV = pairs(self.dataTable)
		pairs(self.dataTable).msg = "MESSAGE_LORDINFO_HONOUR_MEDALREFRESH"
		SoraDSendMessage(pairs(self.dataTable))
	else
	end
end
function achievementctrl:getSwitchMetalRsp(content)
	if gErrDef.Err_None == content.err then
		self.achievementInfo.isShow = content.result
		self.achievementInfo.showMetalID = content.showMetalID
		self.achievementInfo.showAchieveID = content.showAchieveID
		self:updateAchieveInfoInLordInfo()
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_HONOUR_MEDALONSHOW"
		self.isShow = self.achievementInfo.isShow
		self.medalID = self.achievementInfo.showMetalID
		SoraDSendMessage(self)
	else
	end
end
function achievementctrl:getSetMetalRsp(content)
	if gErrDef.Err_None == content.err then
		self.achievementInfo.isShow = content.result.isShow
		self.achievementInfo.showMetalID = content.result.showMetalID
		self.achievementInfo.showAchieveID = content.result.showAchieveID
		self:updateAchieveInfoInLordInfo()
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_HONOUR_MEDALONSHOW"
		self.isShow = self.achievementInfo.isShow
		self.medalID = self.achievementInfo.showMetalID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_HONOUR_MEDALREFRESH"
		SoraDSendMessage(self)
	else
	end
end
function achievementctrl:getOtherLordMetalInfoRsp(content)
	if gErrDef.Err_None == content.err then
		local _ENV, metalInfoData = gErrDef.Err_None, gErrDef.Err_None
		if nil ~= content.result then
			local tmpList = content.result.list
			for k, v in pairs(tmpList) do
				v.id = v.curID
				table.insert(metalInfoData, v)
			end
			_ENV = pairs(tmpList)
			pairs(tmpList).msg = "MESSAGE_LORDINFO_HONOUR_BY_UID"
			pairs(tmpList).err = content.err
			pairs(tmpList).data = metalInfoData
			SoraDSendMessage(pairs(tmpList))
		end
	else
	end
end
function achievementctrl:updateAchievementInfo()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_achievement_notify = notifyCtrl:register(gNotifyID.ACHIEVEMENT_INFO, handler(self, self.notifyAchievementData))
	self.handle_achievement_buff_notify = notifyCtrl:register(gNotifyID.ACHIEVEMENT_BUFF_INFO, handler(self, self.notifyAchievementBuffChangeData))
end
function achievementctrl:notifyAchievementData(respone)
	self:checkRetData(respone.data[1])
	_ENV = self
	self.msg = "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT"
	SoraDSendMessage(self)
end
function achievementctrl:notifyAchievementBuffChangeData(respone)
	local gametop = gModuleMgr.getObject("gametop")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	for k, v in pairs(self.buffVsAchieve) do
		local effectType = tonumber(k)
		local buffType = tonumber(v)
		if buffType == tonumber(respone.data[1].buffType) then
			buffCtrl:dispatchBuffEvent(effectType, gBuffSource.ACHIEVEMENT)
			break
		end
	end
end
return achievementctrl
