local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local divineBeastCtrl = class("divineBeastCtrl", GameModule)
local divineBeastRead = include("divineBeastRead")
local constantRead = include("constantRead")
local msgNotice = include("msgNotice")
_ENV = "msgNotice"
;("msgNotice").TREAT = 0
;("msgNotice").NORMAL = 1
;("msgNotice").DEFEND = 2
;("msgNotice").ATTACK = 3
DIVINE_BEAST_STATE, ("msgNotice").ATTACK_DEFEND = "msgNotice", 4
function divineBeastCtrl:ctor(properties)
	divineBeastCtrl.super.ctor(self, properties)
	self.isFuncOpen = constantRead.getConstValue("DIVINE_BEAST_FUNCTION_SWITCH", 0)
	self.taskLimit = constantRead.getConstValue("DIVINE_BEAST_DAILY_QUEST_LIMIT", 5)
	self.unlockDispatchStarlv = constantRead.getConstValue("DVINE_BEAST_UNLOCK_DISPATCH", 5)
	self.unlockDefendStarlv = constantRead.getConstValue("DVINE_BEAST_UNLOCK_DEFEND", 5)
	self.treatLimit = constantRead.getConstValue("DIVINE_BEAST_TREAT_LIMIT", 5)
end
function divineBeastCtrl:EnterGame()
	print("divineBeastCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_DATA, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_REFRESH_TASK, handler(self, self.sendRefreshTaskRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_TASK_REWARD, handler(self, self.sendGetTaskRewardRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_TREAT, handler(self, self.sendTreatRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_GROW, handler(self, self.sendGrowRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_UP_STEP, handler(self, self.sendUpStepRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_UP_STAR, handler(self, self.sendUpStarRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_DEFEND, handler(self, self.sendDefendRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_TREAT_TO_NORMAL, handler(self, self.sendTreatToNormalRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_MARCH_SHOW, handler(self, self.sendMarchShowRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_FREE_GIFT, handler(self, self.sendFreeGiftRsp))
	msgCtrl.register(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_FINISH_QUEST, handler(self, self.sendFinishQuestRsp))
	self:resetData()
	self:registerNotify()
end
function divineBeastCtrl:onLoginFinish()
end
function divineBeastCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DIVINE_BEAST, handler(self, self.notifyHandler))
end
function divineBeastCtrl:notifyHandler(event)
	dump(event.data, "divineBeastCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		if content.type == "resMax" then
			local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
			scheduler.performWithDelayGlobal(function()
				msgNotice = nil
				;(nil).resourceID = content.resourceId
				;(nil).count = SoraDConvertNumberWithUnit(content.resMax)
				msgNotice.notice("notice_0124", nil)
			end, 1)
		else
			self:setData(content)
			_ENV = self
			self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
			SoraDSendMessage(self)
		end
	end
end
function divineBeastCtrl:initClientData(data)
	dump(data, "divineBeastCtrl:initClientData", 10)
	_ENV = "divineBeastCtrl:initClientData"
	;("divineBeastCtrl:initClientData").byUID = true
	self.showingBeastId = SoraDConfigGet("System:divineBeastCtrl:showingBeastId~integer", "divineBeastCtrl:initClientData") or gBestID.ONE
	if data then
		self:setData(data)
	end
end
function divineBeastCtrl:Logout()
	self:resetData()
	divineBeastCtrl.super.Logout(self)
end
function divineBeastCtrl:resetData()
	_UPVALUE0_ = nil
	self:setData(nil)
end
function divineBeastCtrl:setData(data)
	self.beastList, _ENV, self.data = nil, nil, data
	if self.data.beast ~= nil then
		for k, v in pairs(self.data.beast) do
			_ENV = nil
			;(nil).beastId = tonumber(k)
			;(nil).data = v
			table.insert(self.beastList, nil)
		end
		table.sort(self.beastList, function(a, b)
			return a.beastId < b.beastId
		end)
	end
	self.dispatchBuffDatas, _ENV, self.buffDatas, _ENV, self.attBuffDatas, _ENV = table.sort, table.sort, table.sort, table.sort, table.sort, table.sort
	if self.data.beast == nil then
		return
	end
	for k, v in pairs(self.data.beast) do
		if v.state ~= DIVINE_BEAST_STATE.TREAT then
			self.dispatchBuffDatas[k], _ENV = DIVINE_BEAST_STATE.TREAT, DIVINE_BEAST_STATE.TREAT
			local attBuffData = self:getGrowAttData(k, v.stepLv, v.growLv)
			local cfg = divineBeastRead.getDbCfg(k)
			local starLv = v.starLv or 0
			local starCfg = divineBeastRead.getStarCfg(k, v.starLv or 0)
			for i2, v2 in ipairs(cfg.divineSkill) do
				if starLv >= cfg.unlockStar[i2] then
					local skillLv = starCfg.skillLevel[i2]
					local skillCfg = divineBeastRead.getSkillCfg(v2)[skillLv]
					for i3, v3 in ipairs(skillCfg.buff) do
						if skillCfg.activeType == 1 then
							self.buffDatas[v3.buffType] = self.buffDatas[v3.buffType] or 0
							self.buffDatas[v3.buffType] = self.buffDatas[v3.buffType] + v3.value
						else
							self.dispatchBuffDatas[k][v3.buffType] = self.dispatchBuffDatas[k][v3.buffType] or 0
							self.dispatchBuffDatas[k][v3.buffType] = self.dispatchBuffDatas[k][v3.buffType] + v3.value
						end
					end
				end
			end
			self.attBuffDatas[k] = attBuffData
		else
			self.attBuffDatas[k], _ENV = divineBeastRead.getDbCfg(k), divineBeastRead.getDbCfg(k)
		end
	end
	for k, v in pairs(self.attBuffDatas) do
		for i2, v2 in ipairs(v) do
			self.buffDatas[v2.buffType] = self.buffDatas[v2.buffType] or 0
			self.buffDatas[v2.buffType] = self.buffDatas[v2.buffType] + v2.value
		end
	end
	dump(self.dispatchBuffDatas, "self.dispatchBuffDatas")
end
function divineBeastCtrl:getGrowAttData(divineID, stepLv, growLv)
	local cfg = divineBeastRead.getDbCfg(divineID)
	local attBuffData = clone(cfg.buff)
	local attCfgs = divineBeastRead.getAttributeCfgs(divineID)
	stepLv = stepLv or 0
	stepLv = math.min(stepLv, #attCfgs)
	for i = 0, stepLv do
		local attCfg = attCfgs[i]
		for i2, v2 in ipairs(attBuffData) do
			if i < stepLv then
				attBuffData[i2].value = attBuffData[i2].value + attCfg.growLimit[i2] * attCfg.growValue[i2] / 10
			else
				local growLv = growLv and growLv[i2] or 0
				attBuffData[i2].value = attBuffData[i2].value + growLv * attCfg.growValue[i2] / 10
			end
		end
	end
	local stepCfg = divineBeastRead.getStepCfg(divineID, stepLv)
	for i, v in ipairs(stepCfg.attribute) do
		attBuffData[i].value = attBuffData[i].value + v / 10
	end
	return attBuffData
end
function divineBeastCtrl:sendReqInitDataMsg()
	print("divineBeastCtrl:sendReqInitDataMsg")
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_DATA)
end
function divineBeastCtrl:sendRefreshTask()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_REFRESH_TASK, nil)
end
function divineBeastCtrl:sendGetTaskReward(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_TASK_REWARD, nil)
end
function divineBeastCtrl:sendTreat(beastId)
	serverproxy = nil
	;(nil).beastId = beastId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_TREAT, nil)
end
function divineBeastCtrl:sendGrow(beastId, growId)
	serverproxy = nil
	;(nil).beastId = beastId
	;(nil).growId = growId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_GROW, nil)
end
function divineBeastCtrl:sendUpStep(beastId)
	serverproxy = nil
	;(nil).beastId = beastId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_UP_STEP, nil)
end
function divineBeastCtrl:sendUpStar(beastId)
	serverproxy = nil
	;(nil).beastId = beastId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_UP_STAR, nil)
end
function divineBeastCtrl:sendDefend(beastId, set)
	serverproxy = nil
	;(nil).beastId = beastId
	;(nil).set = set
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_DEFEND, nil)
end
function divineBeastCtrl:sendTreatToNormal(beastId)
	serverproxy = nil
	;(nil).beastId = beastId
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_TREAT_TO_NORMAL, nil)
end
function divineBeastCtrl:sendMarchShow(beastId, show)
	serverproxy = nil
	;(nil).beastId = beastId
	;(nil).show = show
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_MARCH_SHOW, nil)
end
function divineBeastCtrl:sendFreeGift()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_FREE_GIFT, nil)
end
function divineBeastCtrl:sendFinishQuest(questID, shopItemID)
	serverproxy = nil
	;(nil).questID = questID
	;(nil).shopItemID = shopItemID
	serverproxy:Request(gCmd.CMD_DIVINE_BEAST_MODULE, gCmd.REQ_DIVINE_BEAST_FINISH_QUEST, nil)
end
function divineBeastCtrl:checkFastFinishTask(questID)
	if self:getIsTaskFinished(questID) or self:getIsTaskClaimed(questID) then
		SoraDShowMsgTip(i18n("Actpass_text_07"))
		return false
	end
	if self:getDayTaskRewardCount() >= self.taskLimit then
		_ENV = i18n("Actpass_text_07")
		i18n("Actpass_text_07").time = SoraDConvertSecondToString(serviceFunctions.getTodayRemainTime())
		SoraDShowMsgTip(i18n("Divine_beast_text_45", i18n("Actpass_text_07")))
		return false
	end
	local isCurrent = false
	if not self.data.dayQuests then
		_ENV = self.data.dayQuests
	end
	for _, taskID in ipairs(self.data.dayQuests) do
		if taskID == questID then
			isCurrent = true
			break
		end
	end
	if not isCurrent or not divineBeastRead.getTaskFastPassCost(questID) then
		SoraDShowMsgTip(i18n("Actpass_text_03"))
		return false
	end
	return true
end
function divineBeastCtrl:finishTaskWithPass(questID, buyCount)
	if not self:checkFastFinishTask(questID) then
		return
	end
	local itemID, count = divineBeastRead.getTaskFastPassCost(questID)
	local passCount = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
	if count <= passCount then
		self:sendFinishQuest(questID)
	elseif buyCount and buyCount >= count - passCount then
		local needCount = count - passCount
		local price = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(1000214)
		if SoraDEnoughGold(needCount * price) then
			self:sendFinishQuest(questID, 1000214)
		end
	else
		SoraDShowMsgTip(i18n("notice_0120"))
	end
end
function divineBeastCtrl:sendReqInitRsp(content)
	dump(content, "divineBeastCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendRefreshTaskRsp(content)
	dump(content, "==sendRefreshTaskRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendGetTaskRewardRsp(content)
	dump(content, "==sendGetTaskRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.data)
		SoraDMailGainItems(data.reward, true)
		_ENV = data.reward
		data.reward.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(data.reward)
		return
	end
end
function divineBeastCtrl:sendTreatRsp(content)
	dump(content, "==sendTreatRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.data)
		SoraDMailGainItems(data.reward, true)
		_ENV = data.reward
		data.reward.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		data.reward.isTreat = true
		SoraDSendMessage(data.reward)
		return
	end
end
function divineBeastCtrl:sendGrowRsp(content)
	dump(content, "==sendGrowRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendUpStepRsp(content)
	dump(content, "==sendUpStepRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendUpStarRsp(content)
	dump(content, "==sendUpStarRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendDefendRsp(content)
	dump(content, "==sendDefendRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendTreatToNormalRsp(content)
	dump(content, "==sendTreatToNormalRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		SoraDGetCtrl("beastCanyonCtrl"):sendReqInitDataMsg(gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY)
		_ENV = SoraDGetCtrl("beastCanyonCtrl")
		SoraDGetCtrl("beastCanyonCtrl").msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage((SoraDGetCtrl("beastCanyonCtrl")))
		return
	end
end
function divineBeastCtrl:sendMarchShowRsp(content)
	dump(content, "==sendMarchShowRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		return
	end
end
function divineBeastCtrl:sendFreeGiftRsp(content)
	dump(content, "==sendFreeGiftRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self.data.lastFreeGiftTime = data.data.lastFreeGiftTime
		local reward = data.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(reward)
		return
	end
end
function divineBeastCtrl:sendFinishQuestRsp(content)
	dump(content, "==sendFinishQuestRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_DIVINEBEAST"
		SoraDSendMessage(self)
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
		return
	end
end
function divineBeastCtrl:getIsFuncOpen()
	return self.isFuncOpen == 1
end
function divineBeastCtrl:getIsInCity(divineID)
	local divineData = self:getBeastData(divineID)
	return divineData and divineData.state ~= DIVINE_BEAST_STATE.ATTACK and divineData.state ~= DIVINE_BEAST_STATE.ATTACK_DEFEND
end
function divineBeastCtrl:getHighestStepLv()
	if self.data.beast == nil then
		return 0
	end
	local highestStepLv = 0
	for i, v in pairs(self.data.beast) do
		if highestStepLv < (v.stepLv or 0) then
			highestStepLv = v.stepLv or 0
		end
	end
	return highestStepLv
end
function divineBeastCtrl:getStepLv(divineID)
	local divineData = self:getBeastData(divineID)
	if divineData == nil then
		return -1
	end
	if divineData.state == DIVINE_BEAST_STATE.TREAT then
		return -1
	else
		return divineData.stepLv or 0
	end
end
function divineBeastCtrl:getHighestStarLv()
	if self.data.beast == nil then
		return 0
	end
	local highestStarLv = 0
	for i, v in pairs(self.data.beast) do
		if highestStarLv < (v.starLv or 0) then
			highestStarLv = v.starLv or 0
		end
	end
	return highestStarLv
end
function divineBeastCtrl:getStarLv(divineID)
	local divineData = self:getBeastData(divineID)
	if divineData == nil then
		return -1
	end
	return divineData.starLv or 0
end
function divineBeastCtrl:getIsCanyonUnlock()
	if self.data.beast ~= nil then
		for k, v in pairs(self.data.beast) do
			if v.state ~= DIVINE_BEAST_STATE.TREAT then
				return true
			end
		end
	end
	return false
end
function divineBeastCtrl:getUnlockBeastIDList()
	local divineBeastRead, ret
	local beastConfigs = divineBeastRead.getBeastConfigs()
	for k, v in ipairs(beastConfigs) do
		if self:getIsUnlock(v.divineID) then
			table.insert(ret, v.divineID)
		end
	end
	return ret
end
function divineBeastCtrl:getIsUnlock(divineID)
	if not self:getIsFuncOpen() then
		return false
	end
	divineID = divineID or gBestID.ONE
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local dbCfg = divineBeastRead.getDbCfg(divineID)
	dump(dbCfg, "divineBeastCtrl:getIsUnlock")
	local unlockType = dbCfg.unlock[1]
	if unlockType ~= nil then
		if unlockType == 1 or unlockType == 2 then
			local jinnLv = magicLampCtrl:getJinnLv(unlockType)
			if jinnLv < dbCfg.unlock[2] then
				return false
			end
		elseif unlockType == 3 then
			local lv = self:getStepLv(gBestID.ONE)
			if lv < dbCfg.unlock[2] then
				return false
			end
		end
	end
	if divineID == gBestID.ONE then
		return self.data.beast ~= nil and next(self.data.beast) ~= nil
	else
		local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
		local nebulaMileStoneLimit = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_DIVINE_BEAST_1901)
		return self.data.beast ~= nil and next(self.data.beast) ~= nil and nebulaMileStoneLimit ~= nil
	end
end
function divineBeastCtrl:getIsCanDisaptch(mode, beastId)
	beastId = beastId or gBestID.ONE
	local starLv = self:getStarLv(beastId)
	local stepLv = self:getStepLv(beastId)
	print("divineBeastCtrl:getIsCanDisaptch", beastId, starLv, stepLv)
	if mode == gHeroSelectBannerStyle.defend then
		return divineBeastRead.getIsUnlockDefend(beastId, starLv, stepLv)
	else
		return divineBeastRead.getIsUnlockDispatch(beastId, starLv, stepLv)
	end
end
function divineBeastCtrl:getBeastData(id)
	return self.data.beast and self.data.beast[tostring(id)] or nil
end
function divineBeastCtrl:getIsShowBubble(bubbleType)
	if self.data.beast == nil then
		return false
	end
	local cityBuildConstDef = include("cityBuildConstDef")
	if bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_STARUP then
		for _, beast in ipairs(self.beastList) do
			local k = beast.beastId
			local v = beast.data
			if v.state ~= DIVINE_BEAST_STATE.TREAT then
				local starLv = v.starLv or 0
				local stepLv = v.stepLv or 0
				local starCfg = divineBeastRead.getStarCfg(k, starLv)
				local nextStarCfg = divineBeastRead.getStarCfg(k, starLv + 1)
				local nebulaMileStoneUnlock = true
				if nextStarCfg and nextStarCfg.NebulaMilestone ~= 0 then
					local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
					nebulaMileStoneUnlock = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(nextStarCfg.NebulaMilestone) >= starLv + 1
				end
				if nebulaMileStoneUnlock and nextStarCfg and stepLv >= nextStarCfg.stepDemand and self:getIsEnough(starCfg.promoteItem) then
					return true, tonumber(k)
				end
			end
		end
		return false
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_STEPUP then
		for _, beast in ipairs(self.beastList) do
			local k = beast.beastId
			local v = beast.data
			if v.state ~= DIVINE_BEAST_STATE.TREAT then
				local stepLv = v.stepLv or 0
				local stepCfg = divineBeastRead.getStepCfg(k, stepLv)
				local nextStepCfg = divineBeastRead.getStepCfg(k, stepLv + 1)
				local nebulaMileStoneUnlock = true
				if nextStepCfg and nextStepCfg.NebulaMilestone ~= 0 then
					local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
					nebulaMileStoneUnlock = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(nextStepCfg.NebulaMilestone) >= stepLv + 1
				end
				if nebulaMileStoneUnlock and nextStepCfg and self:getIsEnough(stepCfg.promoteItem) then
					local attributeCfg = divineBeastRead.getAttributeCfg(k, stepLv)
					if attributeCfg == nil then
						return true, tonumber(k)
					end
					local isAllGrowMax = true
					for i2, v2 in ipairs(attributeCfg.growLimit) do
						local growLv = v.growLv and v.growLv[i2] or 0
						if growLv == nil or v2 > growLv then
							isAllGrowMax = false
							break
						end
					end
					if isAllGrowMax then
						return true, tonumber(k)
					end
				end
			end
		end
		return false
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_ATTUP then
		for _, beast in ipairs(self.beastList) do
			local k = beast.beastId
			local v = beast.data
			if v.state ~= DIVINE_BEAST_STATE.TREAT then
				local stepLv = v.stepLv or 0
				local attributeCfg = divineBeastRead.getAttributeCfg(k, stepLv)
				if attributeCfg == nil then
					return true, tonumber(k)
				end
				for i2, v2 in ipairs(attributeCfg.growLimit) do
					local growLv = v.growLv and v.growLv[i2] or 0
					if growLv == nil or v2 > growLv then
						divineBeastRead = tonumber(k)
						tonumber(k)[1] = attributeCfg.promoteItem[i2]
						if self:getIsEnough(tonumber(k)) then
							return true, tonumber(k)
						end
					end
				end
			end
		end
		return false
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_TREAT then
		for _, beast in ipairs(self.beastList) do
			local k = beast.beastId
			local v = beast.data
			if v.dayTreatCount == nil or v.dayTreatCount < self.treatLimit then
				local treatCfg = divineBeastRead.getTreatCfg(k)
				if self:getIsEnough(treatCfg.promoteItem) then
					return true, tonumber(k)
				end
			end
		end
		return false
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_TASK then
		if self.data.dayTaskRewardCount == nil or self.taskLimit > self.data.dayTaskRewardCount then
			return true
		end
		return self:getIsHaveTaskFinished()
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_CANYON then
		local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
		local isShow, _ = beastCanyonCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY)
		return isShow
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_53 then
		local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
		local isShow, _ = beastCanyonCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650)
		return isShow
	elseif bubbleType == cityBuildConstDef.topType.TOP_TYPE_NEWBORN_TREE_MARK then
		local isShow = false
		for _, beast in ipairs(self.beastList) do
			local k = beast.beastId
			local v = beast.data
			if v.state ~= DIVINE_BEAST_STATE.TREAT then
				local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
				isShow = divineBeastMarkCtrl:getIsShowBubble(k, v.stepLv or 0)
				if isShow then
					return isShow, tonumber(k)
				end
			end
		end
		return isShow
	end
end
_ENV, divineBeastCtrl.getIsEnough = function(self, promoteItem)
	if next(promoteItem) == nil then
		return false
	end
	local publicUtil = include("publicUtil")
	for k, v in pairs(promoteItem) do
		if publicUtil.getCount(v.id) < v.num then
			return false
		end
	end
	return true
end, function(self, promoteItem)
	if next(promoteItem) == nil then
		return false
	end
	local publicUtil = include("publicUtil")
	for k, v in pairs(promoteItem) do
		if publicUtil.getCount(v.id) < v.num then
			return false
		end
	end
	return true
end
;(function(self, promoteItem)
	if next(promoteItem) == nil then
		return false
	end
	local publicUtil = include("publicUtil")
	for k, v in pairs(promoteItem) do
		if publicUtil.getCount(v.id) < v.num then
			return false
		end
	end
	return true
end).FINISH = 1
;(function(self, promoteItem)
	if next(promoteItem) == nil then
		return false
	end
	local publicUtil = include("publicUtil")
	for k, v in pairs(promoteItem) do
		if publicUtil.getCount(v.id) < v.num then
			return false
		end
	end
	return true
end).UNCOMPLETE = 2
local (function(self, promoteItem)
	if next(promoteItem) == nil then
		return false
	end
	local publicUtil = include("publicUtil")
	for k, v in pairs(promoteItem) do
		if publicUtil.getCount(v.id) < v.num then
			return false
		end
	end
	return true
end).RECEIVE, TaskStatus = 3, function(self, promoteItem)
	if next(promoteItem) == nil then
		return false
	end
	local publicUtil = include("publicUtil")
	for k, v in pairs(promoteItem) do
		if publicUtil.getCount(v.id) < v.num then
			return false
		end
	end
	return true
end
function divineBeastCtrl:getDayRefreshCount()
	return self.data.dayTaskRefreshCount or 0
end
function divineBeastCtrl:getDayTaskRewardCount()
	return self.data.dayTaskRewardCount or 0
end
function divineBeastCtrl:getSortList()
	local _ENV, ret
	if self.data == nil then
		return ret
	end
	local eventQuestRead = include("eventQuestRead")
	if not self.data.dayQuests then
		local _ENV, queueList = self.data.dayQuests, self.data.dayQuests
	end
	if not self.data.questData then
		local _ENV, serverData = self.data.questData, self.data.questData
	end
	for i, v in ipairs(queueList) do
		local questID = v
		local cfgItem = eventQuestRead.questconfig[tonumber(questID)]
		local count = 0
		local taskStatus = gBtnTargetStatusDef.GO
		if serverData then
			if serverData.questProgress then
				count = serverData.questProgress[tostring(questID)] or 0
			end
			if serverData.claimedQuest and serverData.claimedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GOT
			elseif serverData.finishedQuest and serverData.finishedQuest[tostring(questID)] then
				taskStatus = gBtnTargetStatusDef.GET
			end
		end
		_ENV = questID
		questID.taskID = questID
		questID.count = count
		questID.award = cfgItem.reward
		questID.total = cfgItem.aim
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.taskDes
		questID.guideId = cfgItem.guideId
		questID.isAct = cfgItem.isAct
		table.insert(ret, questID)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
function divineBeastCtrl:getTaskLimit()
	return self.taskLimit
end
function divineBeastCtrl:getTaskStatus(taskID)
	local status = TaskStatus.UNCOMPLETE
	if self:getIsTaskClaimed(taskID) then
		status = TaskStatus.RECEIVE
	elseif self:getIsTaskFinished(taskID) then
		status = TaskStatus.FINISH
	end
	return status
end
function divineBeastCtrl:getIsTaskClaimed(taskID)
	if not (self.data and self.data.questData) or not self.data.questData.claimedQuest then
		return false
	end
	local ret = self.data.questData.claimedQuest[tostring(taskID)]
	return ret ~= nil
end
function divineBeastCtrl:getIsTaskFinished(taskID)
	if not (self.data and self.data.questData) or not self.data.questData.finishedQuest then
		return false
	end
	local ret = self.data.questData.finishedQuest[tostring(taskID)]
	return ret ~= nil
end
function divineBeastCtrl:getIsHaveTaskFinished()
	if self.data.dayQuests == nil then
		return false
	end
	if self.data.dayTaskRewardCount ~= nil and self.taskLimit <= self.data.dayTaskRewardCount then
		return false
	end
	for i, v in ipairs(self.data.dayQuests) do
		if self:getTaskStatus(v) == TaskStatus.FINISH then
			return true
		end
	end
end
function divineBeastCtrl:getAttBuffData(divineID)
	return self.attBuffDatas[tostring(divineID)]
end
function divineBeastCtrl:getBuffEffect(effectType)
	return self.buffDatas[effectType] or 0
end
function divineBeastCtrl:getDispatchAddCount(divineBeastInfo, effectType, dispatchMode)
	local num = 0
	local isNotInCity = false
	local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
	for k, v in pairs(divineBeastInfo) do
		local isNotInCity = self:getIsNotInCity(v)
		if dispatchMode ~= gHeroSelectBannerStyle.dispatch or not isNotInCity then
			local buffDatas = self.dispatchBuffDatas[tostring(v)]
			if buffDatas and buffDatas[effectType] then
				num = num + buffDatas[effectType]
			end
			num = num + divineBeastMarkCtrl:getDispatchAddCount(v, effectType)
		end
	end
	return num, isNotInCity
end
function divineBeastCtrl:getIsNotInCity(divineID)
	local divineBeastData = self:getBeastData(divineID)
	if not divineID then
		return true
	end
	return divineBeastData.state == DIVINE_BEAST_STATE.ATTACK or divineBeastData.state == DIVINE_BEAST_STATE.ATTACK_DEFEND
end
function divineBeastCtrl:getPower(divineData)
	local power = 0
	local starCfg = divineBeastRead.getStarCfg(divineData.beastId, divineData.starLv or 0)
	power = power + starCfg.power
	local stepCfg = divineBeastRead.getStepCfg(divineData.beastId, divineData.stepLv or 0)
	power = power + stepCfg.power
	local dbCfg = divineBeastRead.getDbCfg(divineData.beastId)
	if divineData.growLv then
		local growCfg = divineBeastRead.getAttributeCfg(divineData.beastId, divineData.stepLv or 0)
		for growId, growLv in ipairs(divineData.growLv) do
			power = power + dbCfg.buff[growId].value + growCfg.powerValue[growId] * growLv
		end
	end
	local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
	power = power + divineBeastMarkCtrl:getPower(divineData.beastId)
	return power
end
function divineBeastCtrl:getItemCount(itemID)
	if not self.data or not self.data.resource then
		return 0
	end
	return self.data.resource[tostring(itemID)] or 0
end
function divineBeastCtrl:setShowingBeast(beastId)
	if self.showingBeastId ~= beastId then
		self.showingBeastId = beastId
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("System:divineBeastCtrl:showingBeastId~integer", beastId, nil)
	end
end
function divineBeastCtrl:getShowingBeast()
	return self.showingBeastId
end
function divineBeastCtrl:isCanGetFreeGift()
	if self.data.lastFreeGiftTime then
		return not serviceFunctions.isSameDay(self.data.lastFreeGiftTime)
	end
	return true
end
return divineBeastCtrl
