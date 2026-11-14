local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local lordInfoCtrl = class("lordInfoCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local lordAuxiliary = include("lordAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
local vipDailyGiftltCtrl = include("vipDailyGiftltCtrl")
local worldMapDefine = include("worldMapDefine")
local lordLocalData = include("lordLocalData")
lordInfoCtrl.UPDATE_PHYSICAL = "UPDATE_PHYSICAL"
lordInfoCtrl.UPDATE_EXP = "UPDATE_EXP"
lordInfoCtrl.UPDATE_IMAGEID = "UPDATE_IMAGEID"
lordInfoCtrl.UPDATE_NICKNAME = "UPDATE_NICKNAME"
lordInfoCtrl.UPDATE_SKILL = "UPDATE_SKILL"
_ENV, lordInfoCtrl.EXITS_NICKNAME = "lordLocalData", "EXITS_NICKNAME"
;("lordLocalData").NOT_EXIT_NICKNAME = 1
lordInfoCtrl.rsp_code, ("lordLocalData").EXIT_NICKNAME = "lordLocalData", 0
function lordInfoCtrl:ctor(properties)
	lordInfoCtrl.super.ctor(self, properties)
	self:resetData()
end
function lordInfoCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_INIT_LORDDATA, handler(self, self.getLordInfoData))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_CHANGE_NICKNAME, handler(self, self.getUpdateBaseRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_CHANGE_IMAGEID, handler(self, self.getUpdateBaseRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_SKILL, handler(self, self.getUpdateSkillRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_NICKNAMELEGALITY, handler(self, self.getNickNameLegalityRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_RESET_SKILL, handler(self, self.getResetSkillRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_INFO_UID, handler(self, self.getLordInfoByIdRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SPARK_INITIATIVE, handler(self, self.getSparkInitiativeRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_VALUE_UID, handler(self, self.getLordValueByIdRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_BATTLE_INFO, handler(self, self.getLordBattleInfoRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_IN_KINGDOM, handler(self, self.searchLordInKingdomRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_ALL_WORLD, handler(self, self.searchLordAllWorldRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_ALL_JOIN, handler(self, self.searchLordAllJoinRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_JOIN_BY_UID, handler(self, self.searchLordAllJoinRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_VIP_GET_DAILY_GIFT, handler(self, self.getVipDailyGiftRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_CHECK_USER_AGREEMENT, handler(self, self.checkUserAgreementRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_USER_DEBUGDATA_UPLOAD, handler(self, self.checkCrashlyticsRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_GET_BIND_ACCOUNT_REWARD, handler(self, self.getBindAccountRewardRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SNEAK_INTO, handler(self, self.sneakIntoRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_UPGRADE_POP_LV, handler(self, self.setUpgradePopLvRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_SHOW_OFFCIAL_TYPE, handler(self, self.setShowOfficialTypeRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_QUERY_BETRAY_STATUS, handler(self, self.checkBetrayByUidRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_GET_CUR_CATCH_UP_DATA, handler(self, self.getCatchUpLvRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_HIDE_BATTLE_LEV, handler(self, self.setHideWarLvRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_RECEIVE_COMMUNITY_REWARD, handler(self, self.getCommunityRewardRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_CHANGE_SIGNATURE, handler(self, self.changeSignatureRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_NPC_KILL_INFO, handler(self, self.killSemlukRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SWITCH_SIGNATURE, handler(self, self.switchSignatureRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_ROS_KO_CHOICE, handler(self, self.checkROSKOChoiceRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_ROS_KO_STATUS, handler(self, self.syncROSKOChoiceRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_COMMON_SEARCH_LORD, handler(self, self.searchLordInKingdomRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SHIELD_STRANGER, handler(self, self.shieldStrangerRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_RECEIVE_BIND_PHONE_REWARD, handler(self, self.receiveBindPhoneRewardRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_SIGNATURE_BOX, handler(self, self.setSignatureBoxRsp))
	msgCtrl.register(gCmd.CMD_LORD_MODULE, gCmd.REQ_COMPLETE_MERGE_GUIDE, handler(self, self.reqCompleteMergeRsp))
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	buffCtrl:addEventListener(tostring(gBuffEffect.TROOP_PROTECT), handler(self, self.troopProtectBuffCallback))
	buffCtrl:addEventListener(tostring(gBuffEffect.SNEAK_INTO), handler(self, self.sneakIntoCallback))
end
function lordInfoCtrl:troopProtectBuffCallback(event)
	if event.eventType == "open" then
	elseif event.eventType == "close" then
		_ENV = event.eventType
		event.eventType.queueType = gQueueTypeDef.skill_help
		local event.eventType.skillId, data = 1102801, event.eventType
		self.lordAuxiliary:openQueue(data)
	end
end
function lordInfoCtrl:sneakIntoCallback(event)
	if event.eventType == "open" then
	elseif event.eventType == "close" then
		_ENV = event.eventType
		event.eventType.queueType = gQueueTypeDef.skill_sneak_into
		local event.eventType.skillId, data = 1303201, event.eventType
		self.lordAuxiliary:openQueue(data)
	end
end
function lordInfoCtrl:resetData()
	self.isUpdateArmyCostFood = false
	self.lordAuxiliary = nil
	self.skillData = nil
	self.lordInfo = nil
	self.lordAuxiliary = lordAuxiliary.new()
	self.showOfficialTypeArray, lordAuxiliary, self.userDebugdataUpload = lordAuxiliary.new(), lordAuxiliary.new(), true
	self.killSemlukNum = 0
	self.secondaryLockData, lordAuxiliary, self.killSnowMansNum = lordAuxiliary.new(), lordAuxiliary.new(), 0
end
function lordInfoCtrl:Logout()
	lordInfoCtrl.super.Logout(self)
	self.handle_lord_notify = nil
	self:resetData()
end
function lordInfoCtrl:shieldStranger(data)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).subcmd = gCmd.REQ_SHIELD_STRANGER
	local (nil).data, msg = data, nil
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:initLordInfo()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_INIT_LORDDATA, gCmd.REQ_INIT_LORDDATA, gCmd.REQ_INIT_LORDDATA
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:shieldStrangerRsp(content)
	dump(content, "shieldStrangerRsp======")
	if content.err == gErrDef.Err_None then
		self.lordInfo.shiledStranger = content.data.shiledStranger
		SoraDShowMsgTip(i18n("common_text_4131"))
	end
end
function lordInfoCtrl:receiveBindPhoneRewardRsp(content)
	dump(content, "receiveBindPhoneRewardRsp======")
	if content.err == gErrDef.Err_None then
		self.lordInfo.base.receiveBindPhone = true
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_LORDINFO_BIND_AWARD"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function lordInfoCtrl:getShiledStranger()
	print("self.lordInfo.shiledStranger", self.lordInfo.shiledStranger)
	return self.lordInfo.shiledStranger or false
end
function lordInfoCtrl:getLordInfoData(content)
	self.lordInfo = content.data
	self.skillData = self.lordAuxiliary:handleSkill(self.lordInfo.skill)
	dump(self.lordInfo, "玩家数据初始化返回======")
	self:updateLordInfo()
end
function lordInfoCtrl:updateLordInfo()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_lord_notify = notifyCtrl:register(gNotifyID.LORD, handler(self, self.notifyLordData))
end
function lordInfoCtrl:notifyLordData(respone)
	local data = respone.data
	dump(data, "data========", 10)
	if data and next(data) ~= nil then
		for _, var in pairs(data) do
			local key = var.key
			if key == "updateOfficial" then
				local playerid = gametop.playertop_:getPlayerID()
				if var.uid == playerid then
					if var.optype == 2 then
						self.lordInfo.official = nil
					elseif var.optype == 1 then
						self.lordInfo.official = var.official
					end
				end
				if var.isMoveCity then
					local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
					KWKingdomCtrl:dismissOfficialByUid(var.uid, var.official)
				end
				_ENV = KWKingdomCtrl.dismissOfficialByUid
				KWKingdomCtrl.dismissOfficialByUid.msg = "MESSAGE_LORDINFO_UPDATE_BASE"
				SoraDSendMessage(KWKingdomCtrl.dismissOfficialByUid)
				_ENV = KWKingdomCtrl.dismissOfficialByUid
				KWKingdomCtrl.dismissOfficialByUid.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED"
				SoraDSendMessage(KWKingdomCtrl.dismissOfficialByUid)
			elseif key == "fcInfo" then
				local oriTotalFc = self.lordInfo.fcInfo.totalFc
				local armyFc = self.lordInfo.fcInfo.armyFc
				local fcInfo = self.lordAuxiliary:updateLordBaseInfo(var, self.lordInfo[key])
				fcInfo.key = nil
				self.lordInfo.fcInfo = fcInfo
				if armyFc ~= self.lordInfo.fcInfo.armyFc and not self.isUpdateArmyCostFood then
					self.isUpdateArmyCostFood = true
					SoraDDelayCallOnce("updateArmyCostFood", function()
						self.isUpdateArmyCostFood = false
						local cityCtrl = gametop.playertop_:getModule("cityCtrl")
						local resCalculate = cityCtrl.resCalculate
						resCalculate:initArmyCostFood()
					end, 0.1)
				end
				local curTotalFc = self.lordInfo.fcInfo.totalFc
				function _ENV()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end
				;(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end).msg = "MESSAGE_MAINSCEN_POWER_UPDATE"
				;(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end).oriPower = oriTotalFc
				;(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end).curPower = curTotalFc
				SoraDSendMessage(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end)
				function _ENV()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end
				;(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end).msg = "MESSAGE_LORDINFO_UPDATE_BASE"
				;(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end).fcInfo = fcInfo
				SoraDSendMessage(function()
					self.isUpdateArmyCostFood = false
					local cityCtrl = gametop.playertop_:getModule("cityCtrl")
					local resCalculate = cityCtrl.resCalculate
					resCalculate:initArmyCostFood()
				end)
			elseif key == "vip" then
				local curVIPLevel = self.lordInfo.vip.level
				self.lordInfo.vip.vipPoint = var.vipPoint
				self.lordInfo.vip.level = var.level
				self.lordInfo.vip.svipFlag = var.svipFlag or false
				self.lordInfo.vip.vipSkillPoint = var.vipSkillPoint or self.lordInfo.vip.vipSkillPoint
				_ENV = var.vipSkillPoint or self.lordInfo.vip.vipSkillPoint
				;(var.vipSkillPoint or self.lordInfo.vip.vipSkillPoint).msg = "MESSAGE_LORDVALUE_VIP"
				;(var.vipSkillPoint or self.lordInfo.vip.vipSkillPoint).level = self.lordInfo.vip.level
				SoraDSendMessage(var.vipSkillPoint or self.lordInfo.vip.vipSkillPoint)
				_ENV = self.lordInfo.vip.level
				self.lordInfo.vip.level.name = gEventName.event_vip_update
				self:dispatchEvent(self.lordInfo.vip.level)
				_ENV = self
				self.msg = "MESSAGE_VIP_UPDATE"
				SoraDSendMessage(self)
				if curVIPLevel ~= self.lordInfo.vip.level then
					_ENV = self.lordInfo.vip.level
					self.lordInfo.vip.level.name = gEventName.event_vip_upgrade
					self.lordInfo.vip.level.level = self.lordInfo.vip.level
					self:dispatchEvent(self.lordInfo.vip.level)
				end
			elseif key == "updateLoginDay" then
				self.lordInfo.vip.loginDay = var.loginDay
				_ENV = var.loginDay
				var.loginDay.msg = "MESSAGE_LORDVALUE_VIP"
				SoraDSendMessage(var.loginDay)
				_ENV = self
				self.name = gEventName.event_vip_update
				self:dispatchEvent(self)
			elseif key == "closeVIP" then
				local vipEndTime = 0
				self.lordInfo.vip.vipEndTime = vipEndTime
				_ENV = self
				self.msg = "MESSAGE_LORDVALUE_VIP"
				self.data = gQueueTypeDef.vip_time
				SoraDSendMessage(self)
				_ENV = gQueueTypeDef.vip_time
				gQueueTypeDef.vip_time.name = gEventName.event_vip_update
				self:dispatchEvent(gQueueTypeDef.vip_time)
				local queueCtrl = gametop.playertop_:getModule("queueCtrl")
				queueCtrl:removeQueue(gQueueTypeDef.vip_time)
				_ENV = queueCtrl
				queueCtrl.msg = "MESSAGE_UI_PANDECT_ALLREFRESH"
				SoraDSendMessage(queueCtrl)
			elseif key == "activate" then
				local time = var.time
				local vipEndTime = var.vipEndTime
				self.lordAuxiliary:updateVipQueue(time)
				self.lordInfo.vip.vipEndTime = vipEndTime
				_ENV = self.lordAuxiliary
				self.lordAuxiliary.msg = "MESSAGE_LORDVALUE_VIP"
				self.lordAuxiliary.data = gQueueTypeDef.vip_time
				SoraDSendMessage(self.lordAuxiliary)
				_ENV = gQueueTypeDef.vip_time
				gQueueTypeDef.vip_time.name = gEventName.event_vip_update
				self:dispatchEvent(gQueueTypeDef.vip_time)
				_ENV = self
				self.msg = "MESSAGE_VIP_UPDATE"
				SoraDSendMessage(self)
			elseif key == "skill" then
				self.lordInfo.skill.skillPoints = var.skillPoints
				self.skillData = self.lordAuxiliary:handleSkill(self.lordInfo.skill)
				_ENV = self.lordAuxiliary
				self.lordAuxiliary.msg = "MESSAGE_LORDINFO_UPGRADE_SKILL"
				self.lordAuxiliary.data = var.skillPoints
				SoraDSendMessage(self.lordAuxiliary)
			elseif key == "physical" then
				local time = var.time
				local queueCtrl = gametop.playertop_:getModule("queueCtrl")
				if tonumber(time) == -1 then
					queueCtrl:removeQueue(gQueueTypeDef.physical_recovery)
					_ENV = queueCtrl
					queueCtrl.msg = "MESSAGE_LORDINFO_PHYSICAL_RECOVERY"
					queueCtrl.queueType = gQueueTypeDef.physical_recovery
					queueCtrl.operation = "remove"
					SoraDSendMessage(queueCtrl)
				else
					queueCtrl:removeQueue(gQueueTypeDef.physical_recovery)
					_ENV = nil
					queueCtrl:addQueue(gQueueTypeDef.physical_recovery, serviceFunctions.systemTime(), time, time, nil)
					_ENV = queueCtrl
					queueCtrl.msg = "MESSAGE_LORDINFO_PHYSICAL_RECOVERY"
					queueCtrl.queueType = gQueueTypeDef.physical_recovery
					queueCtrl.operation = "add"
					SoraDSendMessage(queueCtrl)
				end
			elseif key == "vipDailyGift" then
				self:resetVipDailyGiftGetStatus()
			elseif key == "avatar" then
				local success = var.success
				if success then
					local avatar = var.avatar
					self:setAvatar(avatar)
					if userSDKManager.avatarDiyCfg then
						userSDKManager.avatarDiyCfg.status = 20
					end
					userSDKManager.reportGameUserInfo()
					_ENV = self
					self.msg = "MESSAGE_LORDINFO_UPDATE_BASE"
					SoraDSendMessage(self)
				else
					userSDKManager.avatarDiyCfg = nil
					_ENV = SoraDSendMessage
					SoraDSendMessage.msg = "MESSAGE_LORDINFO_AVATAR_UPDATE"
					SoraDSendMessage(SoraDSendMessage)
				end
			elseif key == "signature" then
				self.lordInfo.base.signature = var.signature
				self.lordInfo.base.signatureTime = var.signatureTime
				self.lordInfo.base.signatureByGm = var.signatureByGm
			elseif key == "passwdVerify" then
				if self.lordInfo and self.lordInfo.base then
					self.lordInfo.base.passwdVerify = var.passwdVerify
				end
			elseif key == "merge_history" then
				if self.lordInfo and self.lordInfo.base then
					self.lordInfo.base.merge_history = var.merge_history
				end
			elseif key == "mergeGuideFlag" then
				if self.lordInfo and self.lordInfo.base then
					self.lordInfo.base.mergeGuideFlag = var.mergeGuideFlag
				end
			elseif key == "npc" then
				local npc = self.lordInfo.npc
				npc.killWastelandNpcCount = var.killWastelandNpcCount
				npc.killWastelandNpcTime = var.killWastelandNpcTime
			else
				self.oriHP = self.lordInfo[key].health
				self.isSrcKingWarEnabled = self.lordInfo[key].isSrcKingWarEnabled
				local lordBaseInfo, currentLevel, currentEXP = self.lordAuxiliary:updateLordBaseInfo(var, self.lordInfo[key])
				self.lordInfo[key] = lordBaseInfo
				self.castleReward = self.lordInfo[key].castleReward
				if lordBaseInfo.level ~= currentLevel then
					local rank = include("rank")
					currentEXP = currentEXP - rank[currentLevel].Exp
					_ENV = serviceFunctions.systemTime()
					serviceFunctions.systemTime().msg = "MESSAGE_LORDINFO_UPGRADE_LEVEL"
					SoraDSendMessage((serviceFunctions.systemTime()))
					self.lordInfo.onlineInfo.lastLogoutLevel = nil
					_ENV = time
					time.name = gEventName.event_update_lord_upgrade
					time.level = lordBaseInfo.level
					self:dispatchEvent(time)
				end
				self.curHP = self.lordInfo[key].health
				if 0 > self.curHP - self.oriHP then
					_ENV = self.oriHP
					self.oriHP.msg = "MESSAGE_LORDINFO_HP"
					self.oriHP.hp = self.oriHP - self.curHP
					SoraDSendMessage(self.oriHP)
					self.oriHP = self.curHP
				end
				if self.isSrcKingWarEnabled ~= self.lordInfo[key].isSrcKingWarEnabled then
					_ENV = self.lordInfo[key].isSrcKingWarEnabled
					self.lordInfo[key].isSrcKingWarEnabled.msg = "MESSAGE_MAINCITYVIEW_UPDATE_RESURRECTION_HALL_VIEW"
					SoraDSendMessage(self.lordInfo[key].isSrcKingWarEnabled)
				end
				if self.oriGold > lordBaseInfo.gold then
					local deValue = self.oriGold - lordBaseInfo.gold
					_ENV = self.curHP
					self.curHP.value = deValue
					userSDKManager.report2firebase("consumerGold", self.curHP)
				end
				local isReachFullExp = self.lordInfo.base.isReachFullExp
				local addEXP = self.lordInfo.base.exp - currentEXP
				if not isReachFullExp and 0 < addEXP then
					_ENV = self.curHP
					self.curHP.msg = "MESSAGE_MAINSCEN_EXP_UPDATE"
					self.curHP.addEXP = addEXP
					SoraDSendMessage(self.curHP)
				end
				_ENV = self.curHP
				self.curHP.msg = "MESSAGE_LORDINFO_UPDATE_BASE"
				self.curHP.err = gErrDef.Err_None
				self.curHP.base = lordBaseInfo
				self.curHP.oriEXP = currentEXP
				SoraDSendMessage(self.curHP)
			end
		end
	end
end
function lordInfoCtrl:getUpdateBaseRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local lordBaseInfo = self.lordAuxiliary:updateLordBaseInfo(data, self.lordInfo.base)
		_ENV = data
		data.msg = "MESSAGE_LORDINFO_UPDATE_BASE"
		data.err = err
		data.base = lordBaseInfo
		SoraDSendMessage(data, content)
		userSDKManager.reportGameUserInfo()
	elseif err == gErrDef.Err_EXALTED_PRIVILEGE_NULL_REWARD then
		SoraDShowMsgTip(i18n("privilege_text_153"))
	else
		print("lordInfoCtrl:getUpdateBaseRsp err", err)
	end
end
function lordInfoCtrl:getLordInfoByIdRsp(respone)
	dump(respone, "lordInfoCtrl:getLordInfoByIdRsp")
	local err = respone.err
	if err == gErrDef.Err_None then
		local data = lordAuxiliary:getUpperValue(respone.data)
		if not data.eInfo then
			local _ENV, eInfo = data.eInfo, data.eInfo
		end
		local _ENV, temp = respone.data, respone.data
		temp.allowShow = eInfo.isShow or false
		if "table" == type(eInfo.wear) and next(eInfo.wear) then
			local equipmentCell = include("equipmentCell")
			for k, v in pairs(eInfo.wear) do
				local equipment = equipmentCell.new(v)
				local part = equipment:getEquipmentPart()
				temp[part] = equipment
			end
		end
		data.eInfo = temp
		data.isKingdomBattle = respone.clientData and respone.clientData.isKingdomBattle or false
		if data.base.isUnreg then
			data.base.pid = "******"
			SoraDShowMsgTip(i18n("common_text_2870"))
			_ENV = i18n("common_text_2870")
			i18n("common_text_2870").msg = "MESSAGE_LORDINFO_BY_UID"
			i18n("common_text_2870").err = gErrDef.Err_CLIENT_EXCEPTION
			i18n("common_text_2870").fromView = respone.clientData and respone.clientData.targetName or ""
			SoraDSendMessage(i18n("common_text_2870"))
		else
			_ENV = i18n("common_text_2870")
			i18n("common_text_2870").msg = "MESSAGE_LORDINFO_BY_UID"
			i18n("common_text_2870").err = err
			i18n("common_text_2870").lord = data
			i18n("common_text_2870").fromView = respone.clientData and respone.clientData.targetName or ""
			SoraDSendMessage(i18n("common_text_2870"))
		end
	else
		_ENV = data.eInfo
		data.eInfo.msg = "MESSAGE_LORDINFO_BY_UID"
		data.eInfo.err = err
		data.eInfo.fromView = respone.clientData and respone.clientData.targetName or ""
		SoraDSendMessage(data.eInfo)
	end
end
function lordInfoCtrl:getLordValueByIdRsp(respone)
	local err = respone.err
	if err == gErrDef.Err_None then
		local data = respone.data
		data = self.lordAuxiliary:setMaxExp(data)
		_ENV = self.lordAuxiliary
		self.lordAuxiliary.msg = "MESSAGE_LORDVALUE_BY_UID"
		self.lordAuxiliary.err = err
		self.lordAuxiliary.lord = data
		SoraDSendMessage(self.lordAuxiliary, respone)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_LORDVALUE_BY_UID"
		SoraDSendMessage.err = err
		SoraDSendMessage(SoraDSendMessage)
	end
end
function lordInfoCtrl:getUpdateSkillRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local curskill = content.clientData
		local data = content.data
		local rs = self.lordAuxiliary:handleSkill(data)
		self.skillData = rs
		local rsUpdate = self.lordAuxiliary:handleSkillUpdate(data, data.modifySkill)
		self.lordInfo.skill.skillPoints = data.skillPoints
		self.lordInfo.skill.skillBasic = data.skillBasic
		_ENV = data.modifySkill
		data.modifySkill.name = gEventName.event_skill_update
		self:dispatchEvent(data.modifySkill)
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_UPDATE_SKILL"
		self.err = gErrDef.Err_None
		self.skillID = curskill
		SoraDSendMessage(self)
	else
		print("lordInfoCtrl:getUpdateSkillRsp err=", err)
	end
end
function lordInfoCtrl:killSemlukRsp(content)
	dump(content, "lordInfoCtrl:killSemlukRsp")
	local err = content.err
	if err == gErrDef.Err_None then
		if content.data.type == gMapObjTypeDef.mapTypeHuntFair then
			self.killSnowMansNum = content.rspdata.count
			_ENV = gMapObjTypeDef.mapTypeHuntFair
			gMapObjTypeDef.mapTypeHuntFair.msg = "MESSAGE_SERVER_ICE_HUNTING_MARKECT_REFRESH"
			SoraDSendMessage(gMapObjTypeDef.mapTypeHuntFair)
		else
			self.killSemlukNum = content.rspdata.count
			_ENV = gMapObjTypeDef.mapTypeHuntFair
			gMapObjTypeDef.mapTypeHuntFair.msg = "MESSAGE_SERVER_SEMLUK_BALL_REFRESH"
			SoraDSendMessage(gMapObjTypeDef.mapTypeHuntFair)
		end
	end
end
function lordInfoCtrl:switchSignatureRsp(content)
	dump(content, "lordInfoCtrl:switchSignatureRsp")
	local err = content.err
	if err == gErrDef.Err_None then
		self.lordInfo.base.switchSignature = content.rspdata.switchSignature
		_ENV = content.rspdata.switchSignature
		content.rspdata.switchSignature.msg = "MESSAGE_SERVER_SWITCH_SIGNATURE"
		SoraDSendMessage(content.rspdata.switchSignature)
	end
end
function lordInfoCtrl:getNickNameLegalityRsp(content)
	_ENV = nil
	;(nil).msg = "MESSAGE_LORDINFO_NICKNAME_LEGALITY"
	;(nil).content = content
	SoraDSendMessage(nil)
end
function lordInfoCtrl:getResetSkillRsp(content)
	local data = content.data
	local rs = self.lordAuxiliary:getResetSkillData(data)
	self.skillData = rs
	_ENV = data
	data.msg = "MESSAGE_LORDINFO_RESET_SKILL"
	data.err = gErrDef.Err_None
	data.point = data.skillPoints
	SoraDSendMessage(data, content)
	self.lordInfo.skill.skillPoints = data.skillPoints
	self.lordInfo.skill.skillBasic, _ENV = data.skillPoints, data.skillPoints
	_ENV = content
	content.name = gEventName.event_skill_update
	self:dispatchEvent(content)
end
function lordInfoCtrl:getSparkInitiativeRsp(respone)
	local data = respone.data
	local _ENV, rs
	local err = respone.err
	if err == gErrDef.Err_None then
		local extraData = data.extraData
		local queueType = data.queueType
		if queueType ~= gQueueTypeDef.skill_help and queueType ~= gQueueTypeDef.skill_sneak_into then
			rs = self.lordAuxiliary:openQueue(data)
		end
		local lordSkillDesRead = include("lordSkillDesRead")
		_ENV = nil
		;(nil).skill = lordSkillDesRead.getName(data.skillID)
		SoraDShowMsgTip(i18n("common_text_4051", nil))
		if data.skillID == lordSkillIDDefine.fullHP then
			_ENV = lordSkillIDDefine.fullHP
			lordSkillIDDefine.fullHP.msg = "MESSAGE_LORDINFO_HP"
			lordSkillIDDefine.fullHP.style = 2
			SoraDSendMessage(lordSkillIDDefine.fullHP)
		end
	end
	_ENV = data.queueType
	data.queueType.msg = "MESSAGE_TRIGGER_SKILLS"
	data.queueType.skillID = data.skillID
	data.queueType.extraData = data.extraData
	data.queueType.err = respone.err
	SoraDSendMessage(data.queueType)
end
function lordInfoCtrl:getAvatar()
	return self.lordInfo.base.avatar or ""
end
function lordInfoCtrl:setAvatar(avatar)
	self.lordInfo.base.avatar = avatar
end
function lordInfoCtrl:getUserAgreementPop()
	return self.userAgreementPop or false
end
function lordInfoCtrl:getUserCrashlyticsPop()
	return self.userDebugdataUpload
end
function lordInfoCtrl:getSignatureFlag()
	return self.lordInfo.base.switchSignature or false
end
function lordInfoCtrl:getBackStarLv()
	return self.lordInfo.base.backStarLv or 0
end
function lordInfoCtrl:checkROSKOChoice(choice)
	serverproxy = nil
	local (nil).choice, data = choice, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_ROS_KO_CHOICE, data)
end
function lordInfoCtrl:getROSKOChoiceState()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_ROS_KO_STATUS, nil)
end
function lordInfoCtrl:checkROSKOChoiceRsp(rsp)
	local ret = rsp.err
	if gErrDef.Err_None == ret then
	end
end
function lordInfoCtrl:updateLordNickName(nickName)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_CHANGE_NICKNAME, gCmd.REQ_CHANGE_NICKNAME
	;(nil).data, gCmd.REQ_CHANGE_NICKNAME.nickName = gCmd.REQ_CHANGE_NICKNAME, nickName
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:getKillSemlukNum()
	return self.killSemlukNum
end
function lordInfoCtrl:getKillSnowMansNum()
	return self.killSnowMansNum
end
function lordInfoCtrl:updateImageId(imageId)
	local err = self.lordAuxiliary:validateImageId(imageId)
	if err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.cmd = gCmd.CMD_LORD_MODULE
		_ENV, gErrDef.Err_None.subcmd = gCmd.REQ_CHANGE_IMAGEID, gCmd.REQ_CHANGE_IMAGEID
		gErrDef.Err_None.data, gCmd.REQ_CHANGE_IMAGEID.imageId = gCmd.REQ_CHANGE_IMAGEID, imageId
		local msg = gErrDef.Err_None
		serverproxy:SendMsg(msg)
	end
end
function lordInfoCtrl:getBaseInfo()
	return self.lordAuxiliary:getLordBaseInfo(self.lordInfo)
end
function lordInfoCtrl:getLordInfo()
	if self.lordInfo then
		return self.lordAuxiliary:getUpperValue(self.lordInfo)
	end
end
function lordInfoCtrl:isNewAccount()
	if self.lordInfo then
		return 0 > serviceFunctions.systemTime() - (self.lordInfo.base.createTime or 0) - 604800
	else
		return false
	end
end
function lordInfoCtrl:isNewLord()
	if self.lordInfo then
		local constantRead = include("constantRead")
		local oldKid = constantRead.getConstValue("COMPLIANT_SEVER_ID")
		return oldKid < self:getMapSourceKid()
	else
		return true
	end
end
function lordInfoCtrl:getLordSkillData()
	if self.skillData then
		return self.skillData
	end
end
function lordInfoCtrl:getSkillDataByType(attr)
	return self.lordAuxiliary:getSkillDataByType(self.skillData, attr)
end
function lordInfoCtrl:setLordSkill(skill)
	serverproxy = nil
	local (nil).skill, data = skill, nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_SKILL, data, skill[1])
end
function lordInfoCtrl:nickNameLegality(nickName)
	local err, __err = self.lordAuxiliary:validateNickNameLegality(nickName)
	if err == gErrDef.Err_None and nickName then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.cmd = gCmd.CMD_LORD_MODULE
		_ENV, gErrDef.Err_None.subcmd = gCmd.REQ_NICKNAMELEGALITY, gCmd.REQ_NICKNAMELEGALITY
		gErrDef.Err_None.data, gCmd.REQ_NICKNAMELEGALITY.nickName = gCmd.REQ_NICKNAMELEGALITY, nickName
		local msg = gErrDef.Err_None
		serverproxy:SendMsg(msg)
	end
	return err, __err
end
function lordInfoCtrl:resetSkill()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_RESET_SKILL, gCmd.REQ_RESET_SKILL, gCmd.REQ_RESET_SKILL
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:checkBetrayByUidReq(uid)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_LORD_QUERY_BETRAY_STATUS, gCmd.REQ_LORD_QUERY_BETRAY_STATUS
	;(nil).data, gCmd.REQ_LORD_QUERY_BETRAY_STATUS.uid = gCmd.REQ_LORD_QUERY_BETRAY_STATUS, uid
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:getSkillCD(skillID, currentLevel)
	return self.lordAuxiliary:getSkillCD(skillID, currentLevel)
end
function lordInfoCtrl:getSkillPower(skillID, currentLevel)
	return self.lordAuxiliary:getSkillPower(skillID, currentLevel)
end
function lordInfoCtrl:getSkillPowerText(skillID, currentLevel)
	local labelCur, labelPlus
	local tableCur = self:getSkillPower(skillID, currentLevel)
	local tablePlus
	if currentLevel < self.lordAuxiliary:getSkillDetail(skillID, self.skillData).maxLevel then
		tablePlus = self:getSkillPower(skillID, currentLevel + 1)
	end
	if currentLevel == 0 then
		tableCur.type = tablePlus.type
		tableCur.pid = tablePlus.pid
		tableCur.value = 0
	end
	if tablePlus then
		if tablePlus.type == 1 then
			labelPlus = tostring((tonumber(tablePlus.value) - tonumber(tableCur.value)) / 10) .. "%"
		else
			labelPlus = tostring(tonumber(tablePlus.value) - tonumber(tableCur.value))
		end
	end
	if tableCur.type == 1 then
		labelCur = tostring(tonumber(tableCur.value) / 10) .. "%"
	else
		labelCur = tostring(tonumber(tableCur.value))
	end
	return labelCur, labelPlus
end
function lordInfoCtrl:getSkillPost(skillID)
	return self.lordAuxiliary:getSkillPost(skillID)
end
function lordInfoCtrl:getSkillFont(skillID)
	return self.lordAuxiliary:getSkillFont(skillID)
end
function lordInfoCtrl:getSkillType(skillID)
	return self.lordAuxiliary:getSkillType(skillID)
end
function lordInfoCtrl:getSkillDetail(skillID)
	return self.lordAuxiliary:getSkillDetail(skillID, self.skillData)
end
function lordInfoCtrl:getLordInfoByUid(uid, kid, ...)
	print("lordInfoCtrl:getLordInfoByUid", uid, kid)
	if uid and 0 < uid then
		_ENV = nil
		;(nil).uid = uid
		;(nil).kid = kid
		serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_INFO_UID, nil, ...)
	end
end
function lordInfoCtrl:getInitiativeSKill()
	local rs = self.lordAuxiliary:getInitiativeSKill(self.lordInfo)
	return rs
end
function lordInfoCtrl:getInitiativeSKillByID(rid)
	local rs = self.lordAuxiliary:getInitiativeSKill(self.lordInfo)
	for _, v in ipairs(rs) do
		if tonumber(v.skillID) == tonumber(rid) then
			return v
		end
	end
	return nil
end
function lordInfoCtrl:sparkInitiative(skillID, ...)
	skillID = tonumber(skillID)
	if skillID and type(skillID) == "number" then
		_ENV = nil
		;(nil).skillID = skillID
		serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SPARK_INITIATIVE, nil, ...)
	end
end
function lordInfoCtrl:getLordValueByUid(uid, key, ...)
	serverproxy = nil
	;(nil).uid = uid
	;(nil).key = key
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_VALUE_UID, nil, ...)
end
function lordInfoCtrl:getVip()
	if self.lordInfo and next(self.lordInfo) ~= nil then
		return self.lordAuxiliary:getVip(self.lordInfo)
	end
end
function lordInfoCtrl:getVipDetails()
	if self.lordInfo and next(self.lordInfo) ~= nil then
		return self.lordAuxiliary:getVipDetails(self.lordInfo)
	end
end
function lordInfoCtrl:updateAchieveInfo(mAchieveInfo)
	if self.lordInfo then
		self.lordInfo.achieveInfo = clone(mAchieveInfo)
		_ENV = clone(mAchieveInfo)
		clone(mAchieveInfo).msg = "MESSAGE_LORDINFO_UPDATE_FCINFO"
		SoraDSendMessage((clone(mAchieveInfo)))
	end
end
function lordInfoCtrl:updateMilitaryRankInfo(mMilitaryRankInfo)
	if self.lordInfo then
		self.lordInfo.militaryRankInfo = clone(mMilitaryRankInfo)
		_ENV = clone(mMilitaryRankInfo)
		clone(mMilitaryRankInfo).msg = "MESSAGE_LORDMILITARY_UPDATE"
		SoraDSendMessage((clone(mMilitaryRankInfo)))
	end
end
function lordInfoCtrl:getMilitaryRankInfo()
	if self.lordInfo then
		return self.lordInfo.militaryRankInfo
	end
end
function lordInfoCtrl:updateFlowerInfo(mNums, mCurRank, mPreRank)
	if self.lordInfo then
		self.lordInfo.flowerSysInfo.giftednums = mNums
		self.lordInfo.flowerSysInfo.curRank = mCurRank
		self.lordInfo.flowerSysInfo.preRank = mPreRank
	end
end
function lordInfoCtrl:getVipBuffDetails(level1, level2)
	return self.lordAuxiliary:getVipBuffDetails(level1, level2)
end
function lordInfoCtrl:getTechnologyPower(tType)
	local lordSkillCtrl = gametop.playertop_:getModule("lordSkillCtrl")
	return lordSkillCtrl:queryBuff(tType) or 0
end
function lordInfoCtrl:getLevel()
	return self.lordInfo.base.level
end
function lordInfoCtrl:getGold()
	if self.lordInfo and next(self.lordInfo) then
		return self.lordInfo.base.gold
	end
	return 0
end
function lordInfoCtrl:getHeadInfo(...)
	local _ENV, rs
	local data = self.lordInfo
	if data and next(data) then
		local imageId = data.base.imageId
		local avatar = data.base.avatar
		rs.imageId = imageId
		rs.avatar = avatar
	end
	return rs
end
function lordInfoCtrl:getNickName(...)
	return self.lordInfo.base.nickName
end
function lordInfoCtrl:physicalRecInt()
	return self.lordAuxiliary:physicalRecInt(self.lordInfo)
end
function lordInfoCtrl:getLordBattleInfoReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_LORD_BATTLE_INFO, nil, ...)
end
function lordInfoCtrl:getLordBattleInfoRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data
		self.lordInfo.fcInfo.dVictoryTimes = data.dVictoryTimes
		self.lordInfo.fcInfo.aVictoryTimes = data.aVictoryTimes
		self.lordInfo.fcInfo.aLoseTimes = data.aLoseTimes
		self.lordInfo.fcInfo.victoryTimes = data.victoryTimes
		self.lordInfo.fcInfo.loseTimes = data.loseTimes
		self.lordInfo.fcInfo.scoutTimes = data.scoutTimes
		self.lordInfo.fcInfo.loseCount = data.loseCount
		self.lordInfo.fcInfo.treatCount = data.treatCount
		self.lordInfo.fcInfo.killCount = data.killCount
		self.lordInfo.fcInfo.winning = data.winning
		_ENV = data.winning
		data.winning.msg = "MESSAGE_LORDINFO_UPDATE_FCINFO"
		SoraDSendMessage(data.winning)
	else
	end
end
function lordInfoCtrl:syncROSKOChoiceRsp(content)
	dump(content, "syncROSKOChoiceRsp", 5)
	if content.err == gErrDef.Err_None then
		local status = content.rspdata.koStatus
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:MainCityView:ROSKOChoiceInit~integer", status, nil)
		if status ~= 0 then
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:MainCityView:ROSKOChoice~bool", status == 1, nil)
			_ENV = "Game:MainCityView:ROSKOChoice~bool"
			;("Game:MainCityView:ROSKOChoice~bool").msg = "MESSAGE_KOCHOICE_REFRESH"
			SoraDSendMessage("Game:MainCityView:ROSKOChoice~bool")
		end
	end
end
function lordInfoCtrl:searchLordInKingdomReq(name, index, searchType, count, ...)
	serverproxy = nil
	;(nil).name = name
	;(nil).index = index
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_IN_KINGDOM, nil, searchType)
end
function lordInfoCtrl:searchLordInThisKingdomReq(name, index, kingdomid, pid, searchType, count, ...)
	serverproxy = nil
	;(nil).name = name
	;(nil).index = index
	;(nil).kingdomid = tonumber(kingdomid)
	;(nil).pid = pid
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_IN_KINGDOM, nil, searchType)
end
function lordInfoCtrl:searchLordInThisKingdomsReq(name, kingdomid, pid, ...)
	serverproxy = nil
	;(nil).name = name
	;(nil).kids = kingdomid
	;(nil).pid = pid
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_COMMON_SEARCH_LORD, nil, ...)
end
function lordInfoCtrl:searchLordInKingdomRsp(content)
	dump(content, "lordInfoCtrl:searchLordInKingdomRsp", 10)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local clientData = content.clientData
		if clientData == lordSearchType.ACCURATE_SEARCH then
			local player
			local pid = content.data.pid
			local name = content.data.name
			if pid and retdata.uinfolist then
				player = retdata.uinfolist[1]
			end
			if name then
				for __, v in ipairs(retdata.uinfolist) do
					if v.nickName == name then
						player = v
						break
					end
				end
			end
			_ENV = ipairs(retdata.uinfolist)
			ipairs(retdata.uinfolist).msg = "MESSAGE_ITEM_LORD_ACCURATE_SEARCH_BACK"
			ipairs(retdata.uinfolist).data = player
			SoraDSendMessage(ipairs(retdata.uinfolist))
			return
		end
		_ENV = SoraDSendMessage
		SoraDSendMessage.searchType = clientData
		self:uinfolistSort(retdata.uinfolist, SoraDSendMessage)
		if clientData == lordSearchType.PIGEON then
			_ENV = self
			self.msg = "MESSAGE_ITEM_LORD_SEARCH_BACK"
			self.data = retdata
			SoraDSendMessage(self)
		elseif clientData == lordSearchType.OFFICIAL_APPOINT then
			_ENV = self
			self.msg = "MESSAGE_SERVER_KINGDOMWAR_APPOINTSEARCH_BACK"
			self.data = retdata
			SoraDSendMessage(self)
		elseif clientData == lordSearchType.ALLIANCE_MEMBER then
			_ENV = self
			self.msg = "MESSAGE_SERVER_KINGDOMWAR_PLAYERGIFTSEARCH_BACK"
			self.data = retdata
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_ITEM_LORD_SEARCH_BACK"
			self.data = retdata
			SoraDSendMessage(self)
		else
			_ENV = self
			self.msg = "MESSAGE_ITEM_LORD_SEARCH_BACK"
			self.data = retdata
			SoraDSendMessage(self)
		end
	else
	end
end
function lordInfoCtrl:uinfolistSort(uinfolist, param)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local ownAid = allianceMgr:getOwnAid()
	if not param then
		param, _ENV = allianceMgr, allianceMgr
	end
	local searchType = param.searchType
	local searchName = param.searchName
	local searchUinfo
	if searchName then
		local uinfo = uinfolist[1]
		if uinfo and uinfo.nickName == searchName then
			searchUinfo = table.remove(uinfolist, 1)
		end
	end
	table.sort(uinfolist, function(a, b)
		if searchType == lordSearchType.ALLIANCE_MEMBER and a.alliance == b.alliance and a.alliance == ownAid and a.rank ~= b.rank then
			if a.rank == 5 then
				return true
			end
			if b.rank == 5 then
				return false
			end
			return a.rank > b.rank
		end
		if a.alliance ~= b.alliance then
			local self_a = a.alliance == ownAid
			local self_b = b.alliance == ownAid
			if self_a ~= self_b then
				return self_a
			end
		end
		if a.totalFc ~= b.totalFc then
			return (a.totalFc or 0) > (b.totalFc or 0)
		end
		return a.uid < b.uid
	end)
	if searchUinfo then
		table.insert(uinfolist, 1, searchUinfo)
	end
end
function lordInfoCtrl:searchLordAllWorld(name, needLv, kids, ...)
	serverproxy = nil
	;(nil).name = name
	;(nil).needLv = needLv
	;(nil).kids = kids
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_ALL_WORLD, nil, ...)
end
function lordInfoCtrl:searchLordAllWorldRsp(content)
	dump(content, "lordInfoCtrl:searchLordAllWorldRsp", 10)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local uinfolist = retdata.uinfolist
		_ENV = nil
		;(nil).searchName = content.data.name
		self:uinfolistSort(uinfolist, nil)
		local isMax = retdata.isMax
		_ENV = uinfolist
		uinfolist.msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
		uinfolist.data = uinfolist
		uinfolist.isMax = isMax
		SoraDSendMessage(uinfolist)
	else
		_ENV = retdata.uinfolist
		retdata.uinfolist.data, _ENV, retdata.uinfolist.msg = retdata.isMax, retdata.isMax, "MESSAGE_SERVER_OPTION_SEARCH_LORD"
		retdata.uinfolist.isMax = false
		SoraDSendMessage(retdata.uinfolist)
	end
end
function lordInfoCtrl:searchLordAllJoin(bid, name, kid, ...)
	print("发起请求：lordInfoCtrl:searchLordAllJoin", bid, name, kid)
	_ENV = kid
	kid.bid = bid
	kid.name = name
	kid.kid = kid
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_ALL_JOIN, kid, ...)
end
function lordInfoCtrl:searchLordAllJoinByUid(bid, pid, mapId, ...)
	print("发起请求：lordInfoCtrl:searchLordAllJoinByUid", bid, pid)
	_ENV = nil
	;(nil).bid = bid
	;(nil).pid = pid
	;(nil).mapId = mapId
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SEARCH_LORD_JOIN_BY_UID, nil, ...)
end
function lordInfoCtrl:searchLordAllJoinRsp(content)
	dump(content, "lordInfoCtrl:searchLordAllJoinRsp", 10)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		if not retdata or not retdata.uinfolist then
			local _ENV, uinfolist = retdata.uinfolist, retdata.uinfolist
		end
		self:uinfolistSort(uinfolist)
		local isMax = retdata and retdata.isMax or false
		_ENV = uinfolist
		uinfolist.msg = "MESSAGE_SERVER_OPTION_SEARCH_LORD"
		uinfolist.data = uinfolist
		uinfolist.isMax = isMax
		SoraDSendMessage(uinfolist)
	else
		_ENV = retdata.uinfolist
		retdata.uinfolist.data, _ENV, retdata.uinfolist.msg = false, false, "MESSAGE_SERVER_OPTION_SEARCH_LORD"
		retdata.uinfolist.isMax = false
		SoraDSendMessage(retdata.uinfolist)
	end
end
function lordInfoCtrl:getRegisterDays()
	local createTime = self.lordInfo.base.createTime
	if createTime then
		return (serviceFunctions.systemTime() - createTime) / 86400
	else
		return 0
	end
end
function lordInfoCtrl:initClientData(data)
	self.lordInfo = data
	dump(self.lordInfo, "lordInfoCtrl:initClientData", 10)
	local vipEndTime = self.lordInfo.vip.vipEndTime
	local serverSysTime = serviceFunctions.systemTime()
	if vipEndTime < serverSysTime then
		self.lordInfo.vip.vipEndTime = 0
	end
	if not self.lordInfo.vipDailyGift then
		_ENV = self.lordInfo.vipDailyGift
	end
	self.lordInfo.vipDailyGift = self.lordInfo.vipDailyGift
	if self.lordInfo.base.castleReward then
		self.castleReward = self.lordInfo.base.castleReward
	end
	self.skillData = self.lordAuxiliary:handleSkill(self.lordInfo.skill)
	self.userAgreementPop = data.userAgreementPop
	self.userDebugdataUpload = data.userDebugdataUpload
	if not self.userDebugdataUpload then
		_ENV = self.lordInfo.skill
		_ENV, self.lordInfo.skill.isAgree = nil, true
		;(nil).byUID = true
		SoraDConfigSet("Game:GetCrashlytics:track~table", self.lordInfo.skill, nil)
	end
	self.oriGold = self.lordInfo.base.gold
	self:updateLordInfo()
end
function lordInfoCtrl:getLordMilitaryBuffKey(buffID)
	_ENV = nil
	local (nil)[gBuffEffect.INFANTRY_HP_BOOST], cfg = "infantryHpAddPercent", nil
	return cfg[buffID]
end
function lordInfoCtrl:getLordMilitaryInfo(noHero)
	local buildLogic = include("buildLogic")
	local armyLogic = include("armyLogic")
	local _ENV, ret = "armyLogic", "armyLogic"
	ret.totalTroop = buildLogic.getExpQueueCount().total
	ret.expArmyCount = buildLogic.getExpArmyCount().total
	ret.trainCount = armyLogic.getMaxTrainCount().total
	ret.trainTimeAddPercent = armyLogic.getTrainTimeAddPercent()
	ret.moveSpeedAddPercent = include("queueTimeUtil").getSpeedPlusShow()
	local warPlus = include("warUtil").getWarPlus(noHero)
	ret.infantryAkAddPercent = (warPlus.akPlus[gArmyClassRefId.infantry] or 0) / 1000
	ret.infantryDfAddPercent = (warPlus.dfPlus[gArmyClassRefId.infantry] or 0) / 1000
	ret.infantryHpAddPercent = (warPlus.hpPlus[gArmyClassRefId.infantry] or 0) / 1000
	ret.infantrySelfDmgRedPercent = (warPlus.reduceSelfDmgPlus[gArmyClassRefId.infantry] or 0) / 1000
	ret.infantryDmgAddPercent = (warPlus.dmgPlus[gArmyClassRefId.infantry] or 0) / 1000
	ret.cavalryAkAddPercent = (warPlus.akPlus[gArmyClassRefId.cavalry] or 0) / 1000
	ret.cavalryDfAddPercent = (warPlus.dfPlus[gArmyClassRefId.cavalry] or 0) / 1000
	ret.cavalryHpAddPercent = (warPlus.hpPlus[gArmyClassRefId.cavalry] or 0) / 1000
	ret.cavalryChargeDmgAddPercent = (warPlus.chargeDmgPlus[gArmyClassRefId.cavalry] or 0) / 1000
	ret.cavalryDmgAddPercent = (warPlus.dmgPlus[gArmyClassRefId.cavalry] or 0) / 1000
	ret.archerAkAddPercent = (warPlus.akPlus[gArmyClassRefId.archer] or 0) / 1000
	ret.archerDfAddPercent = (warPlus.dfPlus[gArmyClassRefId.archer] or 0) / 1000
	ret.archerHpAddPercent = (warPlus.hpPlus[gArmyClassRefId.archer] or 0) / 1000
	ret.archerDmgAddPercent = (warPlus.dmgPlus[gArmyClassRefId.archer] or 0) / 1000
	ret.charistsAkAddPercent = (warPlus.akPlus[gArmyClassRefId.charists] or 0) / 1000
	ret.charistsDfAddPercent = (warPlus.dfPlus[gArmyClassRefId.charists] or 0) / 1000
	ret.charistsHpAddPercent = (warPlus.hpPlus[gArmyClassRefId.charists] or 0) / 1000
	ret.charistsCastleWarDmgAddPercent = (warPlus.castleWarDmgPlus[gArmyClassRefId.charists] or 0) / 1000
	ret.robAddPercent = (warPlus.robPlus or 0) / 1000
	ret.cityWarAkAddPercent = (warPlus.cityWarAkPlus or 0) / 1000
	ret.cityWarDfAddPercent = (warPlus.cityWarDfPlus or 0) / 1000
	ret.woundAddPercent = (warPlus.woundPlus or 0) / 1000
	ret.killWoundAddPercent = (warPlus.killWoundPlus or 0) / 1000
	ret.eliteAkAddPercent = (warPlus.akPlus[gArmyClassRefId.elite] or 0) / 1000
	ret.eliteDfAddPercent = (warPlus.dfPlus[gArmyClassRefId.elite] or 0) / 1000
	ret.eliteHpAddPercent = (warPlus.hpPlus[gArmyClassRefId.elite] or 0) / 1000
	ret.allAbility = 0
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local blv = cityCtrl:getBuildMaxLv(BUILDID.ELITE_PALACE)
	if 0 < blv then
		ret.allAbility = include("armyltCtrl").getEliteAllAbility(blv)
	end
	return ret
end
function lordInfoCtrl:getLordResourceInfo()
	local buildLogic = include("buildLogic")
	local _ENV, ret = "buildLogic", "buildLogic"
	ret.woodOutputAddPercent = buildLogic.getResOutputHourAddPercent(BUILDID.SAWMILL)
	ret.foodOutputAddPercent = buildLogic.getResOutputHourAddPercent(BUILDID.FARM)
	ret.ironOutputAddPercent = buildLogic.getResOutputHourAddPercent(BUILDID.IRON_MINE)
	ret.mithrilOutputAddPercent = buildLogic.getResOutputHourAddPercent(BUILDID.STEEL)
	ret.crystalOutputAddPercent = buildLogic.getResOutputHourAddPercent(BUILDID.CRYSTAL_MINE)
	ret.warehouseAddCount = buildLogic.getWarehouseProtectCount()["1002"].add
	local collPlus = include("warUtil").getCollPlus()
	ret.woodGatherAddPercent = (collPlus[gIDDef.WOOD] or 0) / 1000
	ret.foodGatherAddPercent = (collPlus[gIDDef.FOOD] or 0) / 1000
	ret.ironGatherAddPercent = (collPlus[gIDDef.IRON] or 0) / 1000
	ret.mithrilGatherAddPercent = (collPlus[gIDDef.MITHRIL] or 0) / 1000
	ret.goldGatherAddPercent = (collPlus[gIDDef.GOLD] or 0) / 1000
	ret.crystalGatherAddPercent = buildLogic.getCrystalGatherSpeed(collPlus[gIDDef.CRYSTAL])
	return ret
end
function lordInfoCtrl:getLordCityDevelopInfo(noHero)
	local buildLogic = include("buildLogic")
	local armyLogic = include("armyLogic")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local _ENV, ret = gametop.playertop_, gametop.playertop_
	ret.buildTimeAddPercent = buildLogic.getUpgradeTimeAddPercent()
	ret.techTimeAddPercent = technologyCtrl:getResearchTimeAddPercent()
	ret.armyCostFoodDescAddPercent = math.floor((1 - armyLogic.getArmyCostFoodAddPercent()) * 1000) / 1000
	ret.hostpitalCapacity = armyLogic.getHostpitalMaxCapacity().total
	ret.cureTimeAddPercent = armyLogic.getArmyCureTimeAddPercent()
	ret.physicalRecAddPercent = self.lordAuxiliary:getPhysicalRecAddPercent()
	ret.armyWeightAddPercent = (include("warUtil").getArmyWeightPlus() or 0) / 1000
	ret.killNpcSpeedAddPercent = (include("queueTimeUtil").getKillNpcSpeedPlusShow(noHero) or 0) / 1000
	return ret
end
function lordInfoCtrl:getLordCityDefInfo()
	local armyLogic = include("armyLogic")
	local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
	local _ENV, ret = gametop.playertop_, gametop.playertop_
	ret.wallCurDef = wallsCtrl:getCurDefence()
	ret.trapBuildTimeAddPercent = armyLogic.getTrapBuildTimeAddPercent()
	ret.totalTrapCount = armyLogic.getTotalTrapCapacity().total
	local otherPlus = include("warUtil").getOtherWarPlus()
	ret.trapAkAddPercent = (otherPlus.trapAkPlus or 0) / 1000
	ret.trapDmg2InfantryAddPercent = (otherPlus.trapDmgPlus2Infantry or 0) / 1000
	ret.trapDmg2CavalryAddPercent = (otherPlus.trapDmgPlus2Cavalry or 0) / 1000
	ret.trapDmg2ArcherAddPercent = (otherPlus.trapDmgPlus2Archer or 0) / 1000
	ret.ak4DfAddPercent = (otherPlus.akPlus4Df or 0) / 1000
	ret.df4DfAddPercent = (otherPlus.dfPlus4Df or 0) / 1000
	ret.towerAkAddPercent = otherPlus.towerAkPlus
	ret.towerInvRedPercent = (otherPlus.towerInvReducePlus or 0) / 1000
	ret.towerAkAddPercent2 = otherPlus.towerAkPlus2
	ret.towerInvRedPercent2 = (otherPlus.towerInvReducePlus2 or 0) / 1000
	return ret
end
function lordInfoCtrl:getSourceKid()
	local sourceKid = self.lordInfo and self.lordInfo.base.sourceKid or 0
	return sourceKid
end
function lordInfoCtrl:getMapSourceKid()
	local sourceKid = self:getSourceKid()
	if sourceKid == 0 then
		sourceKid = self.lordInfo.base.partition
	end
	return sourceKid
end
function lordInfoCtrl:isInSelfKid()
	return self.lordInfo.base.sourceKid == 0
end
function lordInfoCtrl:getPlayerBattleGround()
	local worldMapWarDef = include("worldMapWarDef")
	local ret = worldMapWarDef.getPlayerBattleGround()
	return ret
end
lordInfoCtrl.getPlayerBattleGround = SoraDCacheByFrame(lordInfoCtrl.getPlayerBattleGround)
function lordInfoCtrl:getLordSkillCDTime(basetime)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local pet_add = buffCtrl:getBuffEffect(gBuffEffect.SKILL_CDTIME_REDUCE, gBuffSource.PET) or 0
	pet_add = pet_add / 1000
	local ret = basetime * (1 / (1 + pet_add))
	return ret
end
function lordInfoCtrl:vipDailyGiftBeGot()
	return self.lordInfo.vipDailyGift.vipDailyGiftBeGot
end
function lordInfoCtrl:resetVipDailyGiftGetStatus()
	self.lordInfo.vipDailyGift.vipDailyGiftBeGot = false
end
function lordInfoCtrl:getVipDailyGiftInfo(vipLevel)
	return vipDailyGiftltCtrl:getGift(vipLevel)
end
function lordInfoCtrl:getFriendsCastleData(num)
	local nums = 0
	if self.castleReward and self.castleReward[tostring(num)] then
		nums = self.castleReward[tostring(num)]
	end
	return nums
end
function lordInfoCtrl:canGetGift()
	if self:vipDailyGiftBeGot() then
		print("已领取")
		return gErrDef.Err_VIP_DAILY_GIFT_ALREADY_BE_GOT
	end
	local vipInfo = self:getVip()
	if not vipInfo or not vipInfo[2] then
		print("VIP 未激活")
		return gErrDef.Err_VIP_NO_ACTIVATING
	end
	local vipLevel = vipInfo[1]
	local giftInfo = self:getVipDailyGiftInfo(vipLevel)
	if not giftInfo or not next(giftInfo) then
		print("VIP 等级未达到")
		return gErrDef.Err_VIP_LEVEL_NOT_REACHED
	end
	return gErrDef.Err_None
end
function lordInfoCtrl:getVipDailyGift()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_VIP_GET_DAILY_GIFT, gCmd.REQ_VIP_GET_DAILY_GIFT, gCmd.REQ_VIP_GET_DAILY_GIFT
	local msg
	serverproxy:SendMsg(msg)
	return gErrDef.Err_None
end
function lordInfoCtrl:getVipDailyGiftRsp(rsp)
	local ret = rsp.err
	if gErrDef.Err_None == ret then
		local rspData = rsp.data
		local giftInfo = rspData.gift
		self.lordInfo.vipDailyGift.vipDailyGiftBeGot = true
		_ENV = nil
		;(nil).msg = "MESSAGE_LORDVALUE_VIP_GIFTREFRESH"
		;(nil).result = true
		;(nil).giftInfo = giftInfo
		SoraDSendMessage(nil)
	else
		_ENV = rspData.gift
		rspData.gift.msg = "MESSAGE_LORDVALUE_VIP_GIFTREFRESH"
		rspData.gift.result = false
		SoraDSendMessage(rspData.gift)
	end
end
function lordInfoCtrl:sendCheckUserAgreement()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	local (nil).subcmd, msg = gCmd.REQ_CHECK_USER_AGREEMENT, nil
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:sendUserCrashlyticsSure()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SET_USER_DEBUGDATA_UPLOAD, gCmd.REQ_SET_USER_DEBUGDATA_UPLOAD
	;(nil).data, gCmd.REQ_SET_USER_DEBUGDATA_UPLOAD.confirm = gCmd.REQ_SET_USER_DEBUGDATA_UPLOAD, 1
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:checkCrashlyticsRsp(rsp)
	self.userDebugdataUpload = true
end
function lordInfoCtrl:checkUserAgreementRsp(rsp)
	self.userAgreementPop = false
end
function lordInfoCtrl:sendGetBindAccountReward(req)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_GET_BIND_ACCOUNT_REWARD, gCmd.REQ_GET_BIND_ACCOUNT_REWARD, gCmd.REQ_GET_BIND_ACCOUNT_REWARD
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:sendGetBindPhoneAccountReward(req)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_RECEIVE_BIND_PHONE_REWARD, gCmd.REQ_RECEIVE_BIND_PHONE_REWARD, gCmd.REQ_RECEIVE_BIND_PHONE_REWARD
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:sendGetCommunityReward(req)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).subcmd = gCmd.REQ_RECEIVE_COMMUNITY_REWARD
	local (nil).data, msg = req, nil
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:setIsHideWarLvEffect(ret)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_SET_HIDE_BATTLE_LEV, gCmd.REQ_SET_HIDE_BATTLE_LEV
	;(nil).data, gCmd.REQ_SET_HIDE_BATTLE_LEV.hideBattleLev = gCmd.REQ_SET_HIDE_BATTLE_LEV, ret
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:sendGetCatchUpLv(...)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_GET_CUR_CATCH_UP_DATA, gCmd.REQ_GET_CUR_CATCH_UP_DATA, gCmd.REQ_GET_CUR_CATCH_UP_DATA
	local msg
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:getBindAccountRewardRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		print("lordInfoCtrl:getBindAccountRewardRsp succeed!")
		self.lordInfo.base.hasBindAccountReward = true
		SoraDMailGainItems(rsp.rspdata.reward, true)
	else
		print("lordInfoCtrl:getBindAccountRewardRsp failed!")
	end
	_ENV = "lordInfoCtrl:getBindAccountRewardRsp failed!"
	;("lordInfoCtrl:getBindAccountRewardRsp failed!").msg = "MESSAGE_LORDINFO_BIND_AWARD"
	;("lordInfoCtrl:getBindAccountRewardRsp failed!").err = rsp.err
	SoraDSendMessage("lordInfoCtrl:getBindAccountRewardRsp failed!")
end
function lordInfoCtrl:getCommunityRewardRsp(rsp)
	dump(rsp, "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD", 10)
	if rsp.err == gErrDef.Err_None then
		print("lordInfoCtrl:getCommunityRewardRsp succeed!")
		self.lordInfo.base.receiveCommunity = rsp.rspdata.receiveCommunity
		_ENV = rsp.rspdata.receiveCommunity
		rsp.rspdata.receiveCommunity.msg = "MESSAGE_SERVER_OPTION_FACEBOOK_REWARD"
		rsp.rspdata.receiveCommunity.err = rsp.err
		SoraDSendMessage(rsp.rspdata.receiveCommunity)
		_ENV = rsp.rspdata.receiveCommunity
		rsp.rspdata.receiveCommunity.msg = "MESSAGE_UI_EVENTCENTER_REFRESHISNEW"
		SoraDSendMessage(rsp.rspdata.receiveCommunity)
		_ENV = rsp.rspdata.receiveCommunity
		rsp.rspdata.receiveCommunity.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		rsp.rspdata.receiveCommunity.eventID = gActivityTimeActivityID.COMMUNITY_CENTER
		SoraDSendMessage(rsp.rspdata.receiveCommunity)
	elseif rsp.err == gErrDef.Err_LORD_INS_FAN_NOT_OPEN or rsp.err == gErrDef.Err_LORD_INS_FAN_ALREADY_RECEIVE then
		print("lordInfoCtrl:getCommunityRewardRsp failed!")
	end
end
function lordInfoCtrl:setHideWarLvRsp(rsp)
	dump(rsp, "lordInfoCtrl:setHideWarLvRsp", 10)
	if rsp.err == gErrDef.Err_None then
		self.lordInfo.base.hideBattleLev = rsp.data.hideBattleLev
		local messag = self.lordInfo.base.hideBattleLev and i18n("set_text_03") or i18n("set_text_04")
		SoraDShowMsgTip(messag)
		_ENV = messag
		messag.msg = "MESSAGE_WORLD_MAP_CASTLE_WAR_LV_EFFECT"
		SoraDSendMessage(messag)
	end
end
function lordInfoCtrl:getCatchUpLvRsp(rsp)
	if rsp.err == gErrDef.Err_None then
		local maxLv = rsp.rspdata.levelMax
		local avLv = rsp.rspdata.averageLevel
		local curTime = rsp.rspdata.curTime
		local addExp = rsp.rspdata.addUp
		_ENV = nil
		;(nil).msg = "MESSAGE_LORDINFO_CATCHUPLV"
		;(nil).addExp = addExp
		SoraDSendMessage(nil)
	else
		print("lordInfoCtrl:getCatchUpLvRsp failed!")
	end
end
function lordInfoCtrl:reqSneakInto(kid, uid)
	local _ENV, data
	data.uid = uid
	_ENV, data.kid = nil, kid
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).subcmd = gCmd.REQ_SNEAK_INTO
	local (nil).data, msg = data, nil
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:sneakIntoRsp(rsp)
	dump(rsp, "lordInfoCtrl:sneakIntoRsp(rsp)", 10)
	if rsp.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_4043"))
	else
		print("lordInfoCtrl:sneakIntoRsp failed!")
	end
end
function lordInfoCtrl:reqChangeSignature(signature)
	serverproxy = nil
	;(nil).signature = signature
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_CHANGE_SIGNATURE, nil)
end
function lordInfoCtrl:reqkillSemlukNum(monsterType)
	serverproxy = nil
	;(nil).type = monsterType
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_NPC_KILL_INFO, nil)
end
function lordInfoCtrl:reqSwitchSignature()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SWITCH_SIGNATURE, nil)
end
function lordInfoCtrl:changeSignatureRsp(rsp)
	dump(rsp, "lordInfoCtrl:changeSignatureRsp(rsp)", 10)
	if rsp.err == gErrDef.Err_None then
	end
end
function lordInfoCtrl:setLegendLordTitle(title)
	if self.lordInfo then
		self.lordInfo.legendTitle = title
	end
end
function lordInfoCtrl:setKingStarTitle(title)
	if self.lordInfo then
		self.lordInfo.legendForSepTitle = title
	end
end
function lordInfoCtrl:setHegemonLorldTitle(bid, title)
	if self.lordInfo then
		self.lordInfo.hegemonTitle = title
		self.lordInfo.hegemonBid = bid
	end
end
function lordInfoCtrl:setAtlantisLordTitle(title)
	if self.lordInfo then
		self.lordInfo.atlantisOfficialType = title
	end
end
function lordInfoCtrl:setNebulaLordTitle(title)
	if self.lordInfo then
		local ids = table.keys(title)
		table.sort(ids)
		self.lordInfo.nebulaOfficialID = ids[1] or 0
		self.lordInfo.nebulaOfficialID2 = ids[2] or 0
	end
end
function lordInfoCtrl:setEmperorTitle(title)
	if self.lordInfo then
		self.lordInfo.emperorOfficial = title
	end
end
function lordInfoCtrl:calcExpShow(addExp)
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local maxLordLev = lordLocalData.getMaxLordLev(kingdomLev)
	local levelMax = maxLordLev
	local currentLevel = self:getLevel()
	local rankData = lordLocalData.getLordRankLevData()
	local curExp = self.lordInfo.base.exp
	local maxLoopCount = lordLocalData.getMaxLordLv()
	levelMax = math.min(maxLoopCount, levelMax)
	local expTotal = curExp + addExp
	local expMax
	local bMaxLev = false
	for i = 1, maxLoopCount do
		expMax = rankData[currentLevel].Exp
		if currentLevel >= levelMax then
			bMaxLev = true
			expTotal = 0
			break
		end
		if expMax > expTotal then
			break
		end
		currentLevel = currentLevel + 1
		expTotal = expTotal - expMax
	end
	local percent = expTotal / expMax
	if bMaxLev then
		percent = 1
	end
	return currentLevel, percent
end
function lordInfoCtrl:calcNewVipLev(addType, addPoint)
	local vipLocalData = include("vipLocalData")
	local curVipLev, bActive = self:getVip()
	local vip15Point = 3000000
	local addPoint = addPoint
	local curPoint = self.lordInfo.vip.vipPoint
	local bNeedChange = false
	if vip15Point <= curPoint then
		bNeedChange = true
	else
		local difPoint = vip15Point - curPoint
		if addType == gItemType.S_VIP_POINT then
			return VIP_SVIP_LV, 0
		end
		if addPoint > difPoint then
			curPoint = vip15Point
			addPoint = addPoint - difPoint
			bNeedChange = true
		end
	end
	if bNeedChange and addType == gItemType.VIP_POINT then
		addPoint = math.floor(addPoint / 3)
	end
	local newpoint = curPoint + addPoint
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local maxVipLevel = vipLocalData.getMaxVipLev(kingdomLev)
	local vipData = vipLocalData.getVipLocalData()
	local beginPoint = 0
	local endPoint = 0
	local vipLevel = 0
	local totalPoint = 0
	local completePoint = 0
	for k, v in pairs(vipData) do
		if newpoint >= v.point and vipLevel <= v.level and maxVipLevel >= v.level then
			vipLevel = v.level
			beginPoint = v.point
			if vipLocalData.vipData[v.level + 1] then
				endPoint = vipLocalData.vipData[v.level + 1].point
				totalPoint = endPoint
			else
				endPoint = v.point + v.point - vipLocalData.vipData[v.level - 1].point
				totalPoint = endPoint
			end
			completePoint = newpoint - beginPoint
		end
	end
	local percent = math.min(1, completePoint / (endPoint - beginPoint))
	return vipLevel, percent
end
function lordInfoCtrl:getExpPointToMaxLV()
	local curLv = self:getLevel()
	local rankData = lordLocalData.getLordRankLevData()
	local levelMax = lordLocalData.getMaxLordLv()
	local curExp = self.lordInfo.base.exp
	local exp = rankData[curLv].Exp - curExp
	if curLv == levelMax then
		return 0
	end
	for i = curLv + 1, levelMax - 1 do
		if i <= levelMax - 1 then
			local expMax = rankData[i].Exp
			exp = exp + expMax
		end
	end
	return exp
end
function lordInfoCtrl:getVIPPointToMaxLV(isSVIP)
	local vipLocalData = include("vipLocalData")
	local curVipLev, bActive = self:getVip()
	local vip15Point = 3000000
	local curPoint = self.lordInfo.vip.vipPoint
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local maxVipLevel = vipLocalData.getMaxVipLev(kingdomLev)
	local maxPoint = vipLocalData.getVipMaxPoint(maxVipLevel)
	local sPoint = 0
	local point = 0
	local bSVip = false
	if vip15Point < curPoint then
		bSVip = true
		sPoint = math.max(0, maxPoint - curPoint)
	else
		point = math.max(0, vip15Point - curPoint + (maxPoint - vip15Point) * 3)
	end
	local ret = 0
	if isSVIP then
		if bSVip then
			ret = sPoint
		else
			ret = math.floor(point / 3)
		end
	elseif bSVip then
		ret = sPoint * 3
	else
		ret = point
	end
	return math.max(0, ret)
end
function lordInfoCtrl:getLordLevel()
	return self.lordInfo and self.lordInfo.base.level
end
function lordInfoCtrl:getVIPSkillPoints()
	return self.lordInfo.vip.vipSkillPoint
end
function lordInfoCtrl:isReceiveInsReward()
	return self.lordInfo and self.lordInfo.base.receiveInsFan
end
function lordInfoCtrl:isReceiveCommunityReward(activityID)
	dump(self.lordInfo.base.receiveCommunity, "self.lordInfo.base.receiveCommunity", 10)
	if not self.lordInfo or not self.lordInfo.base.receiveCommunity then
		local _ENV, info = self.lordInfo.base.receiveCommunity, self.lordInfo.base.receiveCommunity
	end
	return info[tostring(activityID)]
end
function lordInfoCtrl:getReceiveStatusAndNum(activityID)
	local ret = false
	local retNum = 0
	if activityID == gActivityTimeActivityID.COMMUNITY_CENTER then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.COMMUNITY_CENTER) then
			local h5ActivityCtrl = SoraDGetCtrl("h5ActivityCtrl")
			local communityData = h5ActivityCtrl:getCommunityCenterData()
			if next(communityData) then
				if IsArClient then
					for i, v in ipairs(communityData.info) do
						if v.markFlag then
							retNum = retNum + 1
						end
					end
				else
					for i, v in ipairs(communityData.info) do
						if v.markFlag and v.type == 1 then
							retNum = retNum + 1
						end
					end
				end
			end
		end
		return 0 < retNum, retNum
	end
end
function lordInfoCtrl:sendUpgradePopLvMsg()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SET_UPGRADE_POP_LV, nil
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:setUpgradePopLvRsp(rsp)
	dump(rsp, "lordInfoCtrl:setUpgradePopLvRsp")
	if rsp and rsp.rspdata and rsp.rspdata.upgradePopLv and self.lordInfo and self.lordInfo.base then
		self.lordInfo.base.upgradePopLv = rsp.rspdata.upgradePopLv
	end
end
function lordInfoCtrl:checkBetrayByUidRsp(rsp)
	dump(rsp, "lordInfoCtrl:checkBetrayByUidRsp")
	if rsp and rsp.data then
		print("rsp.data.retdata,", rsp.data.retdata)
		_ENV = "rsp.data.retdata,"
		;("rsp.data.retdata,").msg = "MESSAGE_LORDINFO_ISBETRAYBYUID"
		;("rsp.data.retdata,").result = rsp.data.retdata
		SoraDSendMessage("rsp.data.retdata,")
	end
end
function lordInfoCtrl:getAnchorStatus()
	if self.lordInfo and self.lordInfo.base then
		local isAnchor = self.lordInfo.base.isAnchor or 0
		local systemTime = serviceFunctions.systemTime()
		local anchorEndTime = self.lordInfo.base.anchorEndTime or 0
		if systemTime > anchorEndTime then
			print("getAnchorStatus", 0, anchorEndTime, isAnchor)
			return 0
		end
		print("getAnchorStatus", isAnchor, anchorEndTime, isAnchor)
		return isAnchor
	end
	return 0
end
function lordInfoCtrl:isHideWarLvEffect()
	return self.lordInfo.base.hideBattleLev
end
function lordInfoCtrl:getIsTraitor()
	local isTraitor = false
	if self.lordInfo and self.lordInfo.base then
		local endTime = self.lordInfo.base.betrayStatusTime or 0
		local systemTime = serviceFunctions.systemTime()
		if endTime > systemTime then
			isTraitor = true
		end
	end
	return isTraitor
end
function lordInfoCtrl:getLordUpgradePopStatus()
	if self.lordInfo and self.lordInfo.base then
		local baseLevel = self.lordInfo.base.level
		local upgradePopLv = self.lordInfo.base.upgradePopLv
		if baseLevel and upgradePopLv then
			return baseLevel > upgradePopLv and baseLevel % 5 == 0
		end
	end
end
function lordInfoCtrl:getLocation()
	if self.lordInfo and self.lordInfo.base then
		return self.lordInfo.base.location
	end
end
function lordInfoCtrl:reqSetShowOfficialType(showOfficialType)
	local _ENV, data
	_ENV, data.showOfficialType = nil, showOfficialType
	;(nil).cmd = gCmd.CMD_LORD_MODULE
	;(nil).subcmd = gCmd.REQ_SET_SHOW_OFFCIAL_TYPE
	local (nil).data, msg = data, nil
	serverproxy:SendMsg(msg)
end
function lordInfoCtrl:setShowOfficialTypeRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.data then
			self.lordInfo.showOfficialType = content.data.showOfficialType
		end
		_ENV = content.data.showOfficialType
		content.data.showOfficialType.msg = "MESSAGE_LORDINFO_TITLE_SHOW"
		SoraDSendMessage(content.data.showOfficialType)
	else
		print("lordInfoCtrl:setShowOfficialTypeRsp err=", err)
	end
end
function lordInfoCtrl:getShowOfficialType()
	return self:getShowOfficialTypeForLord(self.lordInfo)
end
function lordInfoCtrl:getShowOfficialTypeForLord(tbLordInfo)
	if tbLordInfo.showOfficialType and self:validShowOfficialType(tbLordInfo.showOfficialType, tbLordInfo) then
		return tbLordInfo.showOfficialType
	else
		local tbOfficialArray = self:getShowOfficialTypeArrayForLord(tbLordInfo)
		if next(tbOfficialArray) then
			return tbOfficialArray[1].officialType
		end
	end
end
function lordInfoCtrl:validShowOfficialType(showOfficialType, lordInfo)
	local tbOfficialArray = self:getShowOfficialTypeArrayForLord(lordInfo)
	if tbOfficialArray[1] and tbOfficialArray[1].officialType ~= showOfficialType then
		local lordOfficialRead = include("lordOfficialRead")
		local isGood = lordOfficialRead.judgeIsGood(tbOfficialArray[1].officialType, tbOfficialArray[1].officialId)
		if not isGood then
			return false
		end
	end
	if showOfficialType == gShowOfficialType.KING then
		return lordInfo.official ~= nil and lordInfo.official ~= 0
	elseif showOfficialType == gShowOfficialType.HEGEMON then
		return lordInfo.hegemonTitle ~= nil and lordInfo.hegemonTitle ~= 0
	elseif showOfficialType == gShowOfficialType.LEGEND then
		return lordInfo.legendTitle ~= nil and lordInfo.legendTitle ~= 0
	elseif showOfficialType == gShowOfficialType.KINGSTAR then
		return lordInfo.legendForSepTitle ~= nil and lordInfo.legendForSepTitle ~= 0
	elseif showOfficialType == gShowOfficialType.ATLANTIS then
		return lordInfo.atlantisOfficialType ~= nil and lordInfo.atlantisOfficialType ~= 0
	elseif showOfficialType == gShowOfficialType.NEBULA then
		return lordInfo.nebulaOfficialID ~= nil and lordInfo.nebulaOfficialID ~= 0
	elseif showOfficialType == gShowOfficialType.NEBULA2 then
		return lordInfo.nebulaOfficialID2 ~= nil and lordInfo.nebulaOfficialID2 ~= 0
	elseif showOfficialType == gShowOfficialType.NEBULA_EMPEROR then
		return lordInfo.emperorOfficial ~= nil and lordInfo.emperorOfficial ~= 0
	end
end
function lordInfoCtrl:getShowOfficialTypeArray()
	return self:getShowOfficialTypeArrayForLord(self.lordInfo)
end
function lordInfoCtrl:getShowOfficialTypeArrayForLord(tbLordInfo)
	local _ENV, tbOfficialArray
	if tbLordInfo.legendTitle and tbLordInfo.legendTitle ~= 0 then
		local officialType = gShowOfficialType.LEGEND
		local officialId = tbLordInfo.legendTitle
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	if tbLordInfo.legendForSepTitle and tbLordInfo.legendForSepTitle ~= 0 then
		local officialType = gShowOfficialType.KINGSTAR
		local officialId = tbLordInfo.legendForSepTitle
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		local activityId = tbLordInfo.legendForSepActivityId
		local mapid = worldMapDefine.getKingStarMapid(activityId)
		_ENV = nil
		;(nil).officialType = officialType
		;(nil).officialId = officialId
		;(nil).sortIndex = sortIndex
		;(nil).mapid = mapid
		table.insert(tbOfficialArray, nil)
	end
	if tbLordInfo.hegemonTitle and tbLordInfo.hegemonTitle ~= 0 then
		local officialType = gShowOfficialType.HEGEMON
		local officialId = tbLordInfo.hegemonTitle
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	if tbLordInfo.official and tbLordInfo.official ~= 0 then
		local officialType = gShowOfficialType.KING
		local officialId = tbLordInfo.official
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	if tbLordInfo.atlantisOfficialType and tbLordInfo.atlantisOfficialType ~= 0 then
		local officialType = gShowOfficialType.ATLANTIS
		local officialId = tbLordInfo.atlantisOfficialType
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	if tbLordInfo.nebulaOfficialID and tbLordInfo.nebulaOfficialID ~= 0 then
		local officialType = gShowOfficialType.NEBULA
		local officialId = tbLordInfo.nebulaOfficialID
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	if tbLordInfo.nebulaOfficialID2 and tbLordInfo.nebulaOfficialID2 ~= 0 then
		local officialType = gShowOfficialType.NEBULA2
		local officialId = tbLordInfo.nebulaOfficialID2
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	if tbLordInfo.emperorOfficial and tbLordInfo.emperorOfficial ~= 0 then
		local officialType = gShowOfficialType.NEBULA_EMPEROR
		local officialId = tbLordInfo.emperorOfficial
		local sortIndex = self:getOfficialSortIndex(officialType, officialId)
		_ENV = officialId
		officialId.officialType = officialType
		officialId.officialId = officialId
		officialId.sortIndex = sortIndex
		table.insert(tbOfficialArray, officialId)
	end
	table.sort(tbOfficialArray, function(a, b)
		return a.sortIndex > b.sortIndex
	end)
	return tbOfficialArray
end
function lordInfoCtrl:getOfficialSortIndex(officialType, officialId)
	local sortIndex = 0
	local weightTb = gShowOfficialTypeWeight[officialType]
	if officialId == 1 then
		sortIndex = weightTb[gShowOfficialRank.BIG] + officialId
	else
		local lordOfficialRead = include("lordOfficialRead")
		local isGood = lordOfficialRead.judgeIsGood(officialType, officialId)
		if isGood then
			sortIndex = weightTb[gShowOfficialRank.SMALL] + officialId
		else
			sortIndex = weightTb[gShowOfficialRank.BAD] + officialId
		end
	end
	return sortIndex
end
function lordInfoCtrl:canChangeShowOfficialType()
	local tbOfficialArray = self:getShowOfficialTypeArray()
	if tbOfficialArray[1] then
		local lordOfficialRead = include("lordOfficialRead")
		local isGood = lordOfficialRead.judgeIsGood(tbOfficialArray[1].officialType, tbOfficialArray[1].officialId)
		print("isGood = ", isGood)
		if not isGood then
			print("是debuff-------")
			return false
		end
		return true
	end
	return false
end
function lordInfoCtrl:getSelfOfficial()
	return self.lordInfo and self.lordInfo.official
end
function lordInfoCtrl:getSplitName(...)
	return self.lordAuxiliary:getSplitName(...)
end
function lordInfoCtrl:setCastleLv(...)
	return self.lordAuxiliary:setCastleLv(...)
end
function lordInfoCtrl:getSignatureCDTime(...)
	local time = 259200
	if self:getSignatureByGm() then
		time = 604800
	end
	if self.lordInfo.base.signatureTime then
		return self.lordInfo.base.signatureTime + time - serviceFunctions.systemTime()
	else
		return 0
	end
end
function lordInfoCtrl:getSignatureByGm(...)
	return self.lordInfo.base.signatureByGm
end
function lordInfoCtrl:getSignature()
	return self.lordInfo.base.signature
end
function lordInfoCtrl:getHistMaxFc(...)
	return self.lordInfo.fcInfo.histMaxFc or 0
end
function lordInfoCtrl:getHistMaxArmyFc(...)
	return self.lordInfo.fcInfo.histMaxArmyFc or 0
end
function lordInfoCtrl:getDivineBeastFc(...)
	return self.lordInfo.fcInfo.divineBeastFc or 0
end
function lordInfoCtrl:getMergeHistory()
	if not self.lordInfo.base.merge_history then
		_UPVALUE0_ = self.lordInfo.base.merge_history
	end
	return self.lordInfo.base.merge_history
end
function lordInfoCtrl:getMergeGuideFlag()
	return self.lordInfo.base.mergeGuideFlag
end
function lordInfoCtrl:getNewMergeGuideFlag()
	return self.lordInfo.base.newMergeGuideFlag
end
function lordInfoCtrl:getShowOfficialTypeAndId()
	local officialType = self:getShowOfficialTypeForLord(self.lordInfo)
	if officialType then
		local officialId = self:getOfficialIdByType(officialType, self.lordInfo)
		return officialType, officialId
	end
end
function lordInfoCtrl:getOfficialIdByType(officialType, lordInfo)
	if officialType == gShowOfficialType.KING then
		return lordInfo.official
	elseif officialType == gShowOfficialType.HEGEMON then
		return lordInfo.hegemonTitle
	elseif officialType == gShowOfficialType.LEGEND then
		return lordInfo.legendTitle
	elseif officialType == gShowOfficialType.KINGSTAR then
		return lordInfo.legendForSepTitle
	elseif officialType == gShowOfficialType.ATLANTIS then
		return lordInfo.atlantisOfficialType
	elseif officialType == gShowOfficialType.NEBULA then
		return lordInfo.nebulaOfficialID
	elseif officialType == gShowOfficialType.NEBULA2 then
		return lordInfo.nebulaOfficialID2
	elseif officialType == gShowOfficialType.NEBULA_EMPEROR then
		return lordInfo.emperorOfficial
	end
end
function lordInfoCtrl:reqSetSignatureBox(signatureBox)
	serverproxy = nil
	;(nil).signatureBox = signatureBox
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_SET_SIGNATURE_BOX, nil)
end
function lordInfoCtrl:setSignatureBoxRsp(content)
	dump(content, "lordInfoCtrl:setSignatureBoxRsp")
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_4131"))
		self:setSignatureBox(content.data.signatureBox)
	end
end
function lordInfoCtrl:reqCompleteMerge()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_COMPLETE_MERGE_GUIDE, nil)
end
function lordInfoCtrl:reqCompleteMergeRsp(content)
	dump(content, "lordInfoCtrl:reqCompleteMergeRsp")
	if content.err == gErrDef.Err_None then
	end
end
function lordInfoCtrl:reqCompleteNewMerge()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LORD_MODULE, gCmd.REQ_COMPLETE_NEW_MERGE_GUIDE, nil)
end
function lordInfoCtrl:getSignatureBox(...)
	return self.lordInfo.base.signatureBox
end
function lordInfoCtrl:setSignatureBox(signatureBox)
	self.lordInfo.base.signatureBox = signatureBox
end
function lordInfoCtrl:getWinAtlantisSeasonTime(...)
	if not self.lordInfo then
		return 0
	end
	return self.lordInfo.winAtlantisSeasonTime
end
function lordInfoCtrl:setWinAtlantisSeasonTime(time)
	self.lordInfo.winAtlantisSeasonTime = time
end
function lordInfoCtrl:setSecondaryLockDataSuccess(secondaryLockType)
	self.secondaryLockData[secondaryLockType] = true
end
function lordInfoCtrl:getIsNeedVerify(secondaryLockType)
	if device.platform == "mac" then
		return false
	end
	if secondaryLockType == gSecondaryLockType.Force then
		return true
	end
	if (secondaryLockType == gSecondaryLockType.BagItemLock or secondaryLockType == gSecondaryLockType.EquipLock) and table.nums(self.secondaryLockData) > 0 then
		return false
	end
	if (secondaryLockType == gSecondaryLockType.DelBuilding or secondaryLockType == gSecondaryLockType.WarGemEnchantUnlock or secondaryLockType == gSecondaryLockType.MagicLampSkillUnlock or secondaryLockType == gSecondaryLockType.ArmsRuneUnlock or secondaryLockType == gSecondaryLockType.BagItemLock or secondaryLockType == gSecondaryLockType.EquipLock) and self.secondaryLockData[secondaryLockType] then
		return false
	end
	local settingCtrl = SoraDGetCtrl("settingCtrl")
	local isSdkSwitchOn = userSDKManager.isNeedVerify()
	local isServerSwitchOn = settingCtrl:checkValue(gSettingKeyType.passwdVerify)
	local isNeedVerify = isServerSwitchOn and isSdkSwitchOn
	if isServerSwitchOn and not isSdkSwitchOn then
		SoraDShowMsgTip(i18n("Safety_lock_text_12"))
	end
	if secondaryLockType == gSecondaryLockType.DispatchArmy then
		if self.lordInfo and self.lordInfo.base then
			return self.lordInfo.base.passwdVerify and isNeedVerify
		else
			return false
		end
	end
	return isNeedVerify
end
function lordInfoCtrl:setPasswdVerify(isVerify)
	if self.lordInfo and self.lordInfo.base then
		self.lordInfo.base.passwdVerify = isVerify
	end
end
function lordInfoCtrl:getKillWastelandNpcCount(...)
	local npc = self.lordInfo.npc
	if npc.killWastelandNpcTime ~= 0 and not serviceFunctions.isSameDay(npc.killWastelandNpcTime) then
		npc.killWastelandNpcCount = 0
	end
	return npc.killWastelandNpcCount or 0
end
function lordInfoCtrl:filterSearchList(uinfolist)
	local selfUid = gametop.playertop_:getPlayerID()
	local gametop, ret = gametop.playertop_, gametop.playertop_
	for i, v in ipairs(uinfolist) do
		if v.uid ~= selfUid then
			table.insert(ret, v)
		end
	end
	return ret
end
function lordInfoCtrl:getMaxLordLev()
	if self.lordInfo then
		return self.lordInfo.maxLordLev or lordLocalData.__localGetMaxLordLev()
	end
	return lordLocalData.__localGetMaxLordLev()
end
return lordInfoCtrl
