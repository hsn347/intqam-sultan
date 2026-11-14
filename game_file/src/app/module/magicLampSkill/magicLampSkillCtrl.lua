local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local magicLampSkillCtrl = class("magicLampSkillCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function magicLampSkillCtrl:ctor(properties)
	magicLampSkillCtrl.super.ctor(self, properties)
	self:resetData()
end
function magicLampSkillCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_MERGE, handler(self, self.reqMergeRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_UPGRADE_LV, handler(self, self.reqUpgradeLvRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_UPGRADE_CLASS, handler(self, self.reqUpgradeClassRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_RESOLVE, handler(self, self.reqResolveRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_REBIRTH, handler(self, self.reqRebirthRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_LOCK, handler(self, self.reqLockRsp))
	self:registerNotify()
	self:reqInit()
end
function magicLampSkillCtrl:Logout()
	magicLampSkillCtrl.super.Logout(self)
	self:resetData()
end
function magicLampSkillCtrl:resetData()
	self.hasSkillTypeMap, _UPVALUE0_, self.skillMap, _UPVALUE0_ = nil, nil, nil, nil
	self.energy = 0
	self.expSSS = 0
end
function magicLampSkillCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MAGIC_LAMP_SKILL, handler(self, self.notifyHandler))
end
function magicLampSkillCtrl:notifyHandler(event)
	dump(event.data, "magicLampSkillCtrl:notifyHandler", 10)
	local needRefreshMagicLamp = false
	for k, v in ipairs(event.data) do
		local notifyType = v.type
		if notifyType == "addSkill" then
			self:addSkill(v.skillList)
			needRefreshMagicLamp = true
		elseif notifyType == "delSkill" then
			if self.skillMap then
				for _, skillID in pairs(v.skillList) do
					self.skillMap[skillID] = nil
				end
			end
			needRefreshMagicLamp = true
		elseif notifyType == "updateEnergy" then
			self.energy = v.energy
			_ENV = pairs(v.skillList)
			pairs(v.skillList).msg = "MESSAGE_MAGICLAMP_SKILL_ENERGY"
			SoraDSendMessage(pairs(v.skillList))
			_ENV = pairs(v.skillList)
			pairs(v.skillList).msg = "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK"
			SoraDSendMessage(pairs(v.skillList))
		elseif notifyType == "updateExpSSS" then
			self.expSSS = v.expSSS
			_ENV = pairs(v.skillList)
			pairs(v.skillList).msg = "MESSAGE_MAGICLAMP_SKILL_ENERGY"
			SoraDSendMessage(pairs(v.skillList))
			_ENV = pairs(v.skillList)
			pairs(v.skillList).msg = "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK"
			SoraDSendMessage(pairs(v.skillList))
		end
	end
	if needRefreshMagicLamp then
		self:refreshMagicLampSkillState()
	end
end
function magicLampSkillCtrl:updateSkillMap(content)
	local rspdata = content.rspdata
	local _type = rspdata.type
	if _type == "addSkill" then
		self:addSkill(rspdata.skillList)
	elseif _type == "updateSkill" then
		local skillID = content.data.skillID
		self.skillMap[skillID] = rspdata.skillData
	end
end
function magicLampSkillCtrl:addSkill(skillList)
	for __, v in ipairs(skillList) do
		self.skillMap[v.id] = v
	end
end
function magicLampSkillCtrl:refreshMagicLampSkillState()
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if magicLampCtrl and magicLampCtrl.syncSkillGroupsWithSkillState then
		magicLampCtrl:syncSkillGroupsWithSkillState()
	end
	if magicLampCtrl and magicLampCtrl.refreshSkillState then
		magicLampCtrl:refreshSkillState()
	end
end
function magicLampSkillCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_INIT, nil)
end
function magicLampSkillCtrl:reqInitRsp(content)
	dump(content, "magicLampSkillCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.skillMap, _ENV = content.err, content.err
		local skillList = content.rspdata.list
		self:addSkill(skillList)
		self.energy = content.rspdata.energy or 0
		self.expSSS = content.rspdata.expSSS or 0
		self:refreshMagicLampSkillState()
	end
end
function magicLampSkillCtrl:reqMerge(skillType, mergeCount)
	serverproxy = nil
	;(nil).skillType = skillType
	;(nil).mergeCount = mergeCount
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_MERGE, nil)
end
function magicLampSkillCtrl:reqMergeRsp(content)
	dump(content, "magicLampSkillCtrl:reqMergeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateSkillMap(content)
		local skillType = content.data.skillType
		local mergeCount = content.data.mergeCount
		local magicLampSkillRead = include("magicLampSkillRead")
		local skillName = magicLampSkillRead.getSkillName(skillType)
		_ENV = nil
		;(nil).name = skillName
		;(nil).num = mergeCount
		SoraDShowMsgTip(i18n("jinn_skill_60", nil))
		_ENV = i18n("jinn_skill_60", nil)
		i18n("jinn_skill_60", nil).msg = "MESSAGE_MAGICLAMP_SKILL_MERGE"
		i18n("jinn_skill_60", nil).skillType = skillType
		SoraDSendMessage(i18n("jinn_skill_60", nil))
	end
end
function magicLampSkillCtrl:reqUpgradeLv(skillID)
	serverproxy = nil
	;(nil).skillID = skillID
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_UPGRADE_LV, nil)
end
function magicLampSkillCtrl:reqUpgradeLvRsp(content)
	dump(content, "magicLampSkillCtrl:reqUpgradeLvRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateSkillMap(content)
		self:refreshMagicLampSkillState()
		_ENV = 10
		;(10).lv = content.rspdata.skillData.lv
		SoraDShowMsgTip(i18n("jinn_skill_24", 10))
		_ENV = i18n("jinn_skill_24", 10)
		i18n("jinn_skill_24", 10).msg = "MESSAGE_MAGICLAMP_SKILL_UPGRADE_LV"
		SoraDSendMessage(i18n("jinn_skill_24", 10))
	end
end
function magicLampSkillCtrl:reqUpgradeClass(skillID, costList)
	serverproxy = nil
	;(nil).skillID = skillID
	;(nil).costList = costList
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_UPGRADE_CLASS, nil)
end
function magicLampSkillCtrl:reqUpgradeClassRsp(content)
	dump(content, "magicLampSkillCtrl:reqUpgradeClassRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.rewards, true)
		self:updateSkillMap(content)
		local costList = content.data.costList
		for __, skillID in ipairs(costList) do
			self.skillMap[skillID] = nil
		end
		self:refreshMagicLampSkillState()
		_ENV = nil
		;(nil).lv = content.rspdata.skillData.classLv
		SoraDShowMsgTip(i18n("jinn_skill_34", nil))
		local proxy = uiManager:getProxy("MagicLampSkillAdvance")
		if proxy then
			proxy:removeAllView()
		end
		_ENV = proxy
		proxy.msg = "MESSAGE_MAGICLAMP_SKILL_UPGRADE_CLASS"
		SoraDSendMessage(proxy)
	end
end
function magicLampSkillCtrl:reqResolve(skillList)
	serverproxy = nil
	;(nil).skillList = skillList
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_RESOLVE, nil)
end
function magicLampSkillCtrl:reqResolveRsp(content)
	dump(content, "magicLampSkillCtrl:reqResolveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.rewards, true)
		local skillList = content.data.skillList
		for __, skillID in ipairs(skillList) do
			self.skillMap[skillID] = nil
		end
		self:refreshMagicLampSkillState()
		SoraDShowMsgTip(i18n("jinn_skill_57"))
		_ENV = i18n("jinn_skill_57")
		i18n("jinn_skill_57").msg = "MESSAGE_MAGICLAMP_SKILL_RESOLVE"
		SoraDSendMessage(i18n("jinn_skill_57"))
	end
end
function magicLampSkillCtrl:reqRebirth(skillID)
	serverproxy = nil
	;(nil).skillID = skillID
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_REBIRTH, nil)
end
function magicLampSkillCtrl:reqRebirthRsp(content)
	dump(content, "magicLampSkillCtrl:reqRebirthRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		local skillID = content.data.skillID
		self.skillMap[skillID] = rspdata.skillData
		if not rspdata.skillList then
			local _ENV, skillList = rspdata.skillList, rspdata.skillList
		end
		self:addSkill(skillList)
		self:refreshMagicLampSkillState()
		local proxy = uiManager:getProxy("MagicLampSkillRebirth")
		if proxy then
			proxy:removeAllView()
		end
		local magicLampSkillRead = include("magicLampSkillRead")
		table.sort(skillList, function(a, b)
			local qualityA = magicLampSkillRead.getSkillQuality(a.skillType)
			local qualityB = magicLampSkillRead.getSkillQuality(b.skillType)
			if qualityA ~= qualityB then
				return qualityA > qualityB
			end
			return a.skillType < b.skillType
		end)
		_ENV = skillList
		skillList.skillData = rspdata.skillData
		skillList.skillList = skillList
		skillList.rewards = rspdata.rewards
		local rewardList = magicLampSkillRead.getRebirthRewardList(skillList)
		_ENV = nil
		;(nil).rewardList = rewardList
		uiManager:show("MagicLampSkillRebirthBack", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAGICLAMP_SKILL_REBIRTH"
		SoraDSendMessage(uiManager)
		SoraDShowMsgTip(i18n("jinn_skill_83"))
	end
end
function magicLampSkillCtrl:reqLock(skillID, isLock)
	serverproxy = nil
	;(nil).skillID = skillID
	;(nil).isLock = isLock
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_LOCK, nil)
end
function magicLampSkillCtrl:reqLockRsp(content)
	dump(content, "magicLampSkillCtrl:reqLockRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateSkillMap(content)
		if content.data.isLock then
			SoraDShowMsgTip(i18n("jinn_skill_66"))
		else
			SoraDShowMsgTip(i18n("jinn_skill_65"))
		end
		_ENV = i18n("jinn_skill_65")
		i18n("jinn_skill_65").msg = "MESSAGE_MAGICLAMP_SKILL_LOCK"
		SoraDSendMessage(i18n("jinn_skill_65"))
	end
end
function magicLampSkillCtrl:getSkillMap(...)
	return self.skillMap
end
function magicLampSkillCtrl:getSkillList(...)
	return table.values(self.skillMap)
end
function magicLampSkillCtrl:getSkillData(skillID)
	return self.skillMap[skillID]
end
function magicLampSkillCtrl:getSkillEnergy()
	return self.energy
end
function magicLampSkillCtrl:getItemCount(itemID)
	if itemID == gIDDef.MAGIC_LAMP_SKILL_ENERGY then
		return self:getSkillEnergy()
	elseif itemID == gIDDef.MAGIC_LAMP_SKILL_ENERGY_SSS then
		return self.expSSS
	else
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		return backpackCtrl:getItemCount(itemID)
	end
end
function magicLampSkillCtrl:addGameItem(...)
	local _ENV, data
	local magicLampSkillRead = include("magicLampSkillRead")
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		_ENV = nil
		;(nil).id = v.compound[1]
		;(nil).count = 100
		table.insert(data, nil)
	end
	local cheatCtrl = SoraDGetCtrl("cheatCtrl")
	cheatCtrl:reqAddGameItem(data)
end
function magicLampSkillCtrl:initSkillBase(fields, data)
	local magicLampSkillRead = include("magicLampSkillRead")
	local skillType = data.skillType
	fields.Text_name:setString(magicLampSkillRead.getSkillName(skillType))
	_ENV = magicLampSkillRead.getSkillName(skillType)
	magicLampSkillRead.getSkillName(skillType).lv = data.lv or 1
	fields.Text_lv:setString(i18n("common_text_100", magicLampSkillRead.getSkillName(skillType)))
	local classLvMax = magicLampSkillRead.getSkillStageMax(skillType)
	print("classLvMax=====", classLvMax)
	fields.Com_star:initData(data.classLv or 0, classLvMax)
	local quality = magicLampSkillRead.getSkillQuality(skillType)
	local qualityCfg = magicLampSkillRead.getQualityConfig(quality)
	fields.Text_quality:setString(qualityCfg.name)
	fields.Load_icon:setURL(magicLampSkillRead.getSkillIcon(skillType))
end
function magicLampSkillCtrl:getSkillStorageMax(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("JINN_SKILL_STORAGE_MAX")
end
function magicLampSkillCtrl:getSkillStorageSpace(...)
	local max = self:getSkillStorageMax()
	return max - table.nums(self.skillMap)
end
function magicLampSkillCtrl:getSkillResolvePro(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("JINN_SKILL_RESOLVE_PRO", 0.8)
end
function magicLampSkillCtrl:getSkillListFilter(filter)
	local magicLampSkillRead = include("magicLampSkillRead")
	local skillList = self:getSkillList()
	local _ENV, otherMap = self, self
	if not filter.otherList then
		_ENV = filter.otherList
	end
	for __, v in ipairs(filter.otherList) do
		otherMap[v] = true
	end
	local _ENV, ret = (for generator), ipairs(filter.otherList)
	for __, data in ipairs(skillList) do
		if not otherMap[data.id] and data.classLv == filter.classLv then
			if filter.skillType then
				if data.skillType == filter.skillType then
					table.insert(ret, data)
				end
			elseif filter.quality then
				local _quality = magicLampSkillRead.getSkillQuality(data.skillType)
				if _quality == filter.quality then
					table.insert(ret, data)
				end
			end
		end
	end
	return ret
end
function magicLampSkillCtrl:getAutoChooseList(needSkill, data, curChooseList)
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local _ENV, chooseList = "magicLampCtrl", "magicLampCtrl"
	local _ENV, selectMap
	local enough = true
	for index, cfg in ipairs(needSkill) do
		local skillList
		if cfg.type == gJinnSkillNeedSkillType.SKILLTYPE then
			_ENV = nil
			;(nil).skillType = data.skillType
			_UPVALUE1_, (nil).classLv = cfg.classLv, cfg.classLv
			;(nil).otherList, cfg.classLv[1] = cfg.classLv, data.id
			skillList = self:getSkillListFilter(nil)
		elseif cfg.type == gJinnSkillNeedSkillType.QUALITY then
			_ENV = nil
			;(nil).quality = cfg.value
			_UPVALUE1_, (nil).classLv = cfg.classLv, cfg.classLv
			;(nil).otherList, cfg.classLv[1] = cfg.classLv, data.id
			skillList = self:getSkillListFilter(nil)
		end
		if skillList and next(skillList) then
			local magicLampSkillRead = include("magicLampSkillRead")
			magicLampSkillRead.sortAutoChooseList(skillList)
			if not curChooseList or not curChooseList[index] then
				local _ENV, ret = curChooseList[index], curChooseList[index]
			end
			for i, skillID in ipairs(ret) do
				selectMap[skillID] = true
			end
			for i, v in ipairs(skillList) do
				if #ret >= cfg.count then
					break
				end
				local skillID = v.id
				if not selectMap[skillID] and not v.lock and not magicLampCtrl:getIsUsing(skillID) then
					table.insert(ret, skillID)
					selectMap[skillID] = true
				end
			end
			if #ret < cfg.count then
				enough = false
				break
			end
			chooseList[index] = ret
		else
			enough = false
			break
		end
	end
	return enough, chooseList
end
function magicLampSkillCtrl:updateHasSkillTypeMap(...)
	local _ENV, ret
	for k, v in pairs(self.skillMap) do
		ret[v.skillType] = true
	end
	self.hasSkillTypeMap = ret
	return self.hasSkillTypeMap
end
function magicLampSkillCtrl:checkHasSkill(skillType)
	return self.hasSkillTypeMap[skillType] or false
end
function magicLampSkillCtrl:checkCanUpgradeLv(data, showTip)
	local magicLampSkillRead = include("magicLampSkillRead")
	local lvMax = magicLampSkillRead.getSkillLvMax(data.skillType)
	if lvMax <= data.lv then
		if showTip then
			SoraDShowMsgTip(i18n("jinn_skill_14"))
		end
		return false, 1
	end
	local stageGroup = magicLampSkillRead.getSkillStageGroup(data.skillType)
	local lvLimit = magicLampSkillRead.getStageLvLimit(stageGroup, data.classLv)
	if lvLimit <= data.lv then
		if showTip then
			_ENV = i18n("jinn_skill_14")
			i18n("jinn_skill_14").lv = data.classLv + 1
			SoraDShowMsgTip(i18n("jinn_skill_16", i18n("jinn_skill_14")))
		end
		return false, 2
	end
	return true
end
function magicLampSkillCtrl:checkCanUpgradeClass(data, showTip)
	local magicLampSkillRead = include("magicLampSkillRead")
	local stageGroup = magicLampSkillRead.getSkillStageGroup(data.skillType)
	local classLvMax = magicLampSkillRead.getSkillStageMax(data.skillType)
	if classLvMax <= data.classLv then
		if showTip then
			SoraDShowMsgTip(i18n("jinn_skill_17"))
		end
		return false, 1
	end
	local needLv = magicLampSkillRead.getStageNeedLv(stageGroup, data.classLv + 1)
	if needLv > data.lv then
		if showTip then
			_ENV = i18n("jinn_skill_17")
			i18n("jinn_skill_17").lv = needLv
			SoraDShowMsgTip(i18n("jinn_skill_19", i18n("jinn_skill_17")))
		end
		return false, 2
	end
	return true
end
function magicLampSkillCtrl:checkSkillShowRed(data)
	local magicLampSkillRead = include("magicLampSkillRead")
	if self:checkCanUpgradeLv(data) then
		local lvGroup = magicLampSkillRead.getSkillLvGroup(data.skillType)
		local needItems = magicLampSkillRead.getUpgradeLvNeedItem(lvGroup, data.lv + 1)
		local needItem = needItems[1]
		local itemCount = self:getItemCount(needItem.id)
		if itemCount >= needItem.count then
			return true
		end
	end
	if self:checkCanUpgradeClass(data) then
		local stageGroup = magicLampSkillRead.getSkillStageGroup(data.skillType)
		local needSkill = magicLampSkillRead.getAdvanceNeedSkill(stageGroup, data.classLv + 1)
		local enough, chooseList = self:getAutoChooseList(needSkill, data)
		if enough then
			return true
		end
	end
	return false
end
function magicLampSkillCtrl:checkMergeItemEnough(...)
	local magicLampSkillRead = include("magicLampSkillRead")
	local skillTypeList = magicLampSkillRead.getSkillTypeList()
	for __, list in pairs(skillTypeList) do
		for __, skillType in ipairs(list) do
			local needItems = magicLampSkillRead.getSkillCompound(skillType)
			local needItem = needItems[1]
			local itemCount = self:getItemCount(needItem.id)
			if itemCount >= needItem.count then
				return true
			end
		end
	end
	return false
end
function magicLampSkillCtrl:checkHasSkillCount(...)
	if self.skillMap and next(self.skillMap) then
		return true
	else
		return false
	end
end
function magicLampSkillCtrl:updateGuideSkill(...)
	if not self:checkHasSkillCount() then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.MLS_CULTIVATE)
end
function magicLampSkillCtrl:updateGuideSkill2(...)
	if not self:checkHasSkillCount() then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.MLS_CULTIVATE, false, 2)
end
function magicLampSkillCtrl:updateGuideActive(...)
	if not self:checkHasSkillCount() then
		return
	end
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if not magicLampCtrl:checkBigBlessUnlock() then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.MLS_ACTIVE)
end
function magicLampSkillCtrl:updateGuideActive2(...)
	if not self:checkHasSkillCount() then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.MLS_ACTIVE, false, 2)
end
function magicLampSkillCtrl:getIsSkillShowInArea(skillType)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType = nebulaActivityCtrl:getKingdomRegionType()
	if regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		return true
	end
	local magicLampSkillRead = include("magicLampSkillRead")
	local skillTypeCfg = magicLampSkillRead.getSkillTypeCfg(skillType)
	local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
	local doStage = activity_9001656_Ctrl:getDoStage()
	if doStage == 1 and skillTypeCfg.showPreparing == 1 then
		return true
	end
	return false
end
function magicLampSkillCtrl:getExchangeSkillCount(quality)
	local magicLampSkillRead = include("magicLampSkillRead")
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local count = 0
	for _, v in pairs(self.skillMap) do
		local _quality = magicLampSkillRead.getSkillQuality(v.skillType)
		if _quality == quality and v.lv == 1 and v.classLv == 0 and not magicLampCtrl:getIsUsing(v.id) then
			count = count + 1
		end
	end
	return count
end
function magicLampSkillCtrl:updateGuideExchangeMall(...)
	if worldMapDefine.inInCrossWar() then
		return
	end
	local constantRead = include("constantRead")
	self.is3SSwitchOpen = constantRead.getConstValue("MAGIC_SKILL_3S_SWITCH", 0) == 1
	if not self.is3SSwitchOpen then
		return
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if not guideCtrl:isGuideNotCompleted(gGuideModule.MAGIC_SKILL_EXCHANGE) then
		return
	end
	local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
	if magicLampSkillLotteryCtrl:getIsUnlock() then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		if magicLampCtrl:getIsUnlock() then
			guideCtrl:updateGuideModule(gGuideModule.MAGIC_SKILL_EXCHANGE)
		end
	end
end
return magicLampSkillCtrl
