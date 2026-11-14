local gamemodulec = include("GameModule")
local petCtrl = class("petCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local timerList = gModuleMgr.getObject("timerList")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local petClass = include("pet")
local petltCtrl = include("petltCtrl")
_ENV = "petltCtrl"
;("petltCtrl")[gPetAttributeType.GATHER_SPEED_BOOST] = gBuffEffect.GATHER_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.SOLDIER_LOAD_BOOST] = gBuffEffect.SOLDIER_LOAD_BOOST
;("petltCtrl")[gPetAttributeType.TRAIN_SPEED_BOOST] = gBuffEffect.TRAIN_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.TROOP_ATTACK_BOOST] = gBuffEffect.TROOP_ATTACK_BOOST
;("petltCtrl")[gPetAttributeType.MARCH_MONSTER_SPEED_BOOST] = gBuffEffect.MARCH_MONSTER_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.STUDY_RESOURCE_REDUCE] = gBuffEffect.STUDY_RESOURCE_REDUCE
;("petltCtrl")[gPetAttributeType.CLUMP_NUM_BOOST] = gBuffEffect.CLUMP_NUM_BOOST
;("petltCtrl")[gPetAttributeType.MARCH_VALUE_LIMIT_BOOST] = gBuffEffect.MARCH_VALUE_LIMIT_BOOST
;("petltCtrl")[gPetAttributeType.REINFORCEMENTS_MAX_COUNT] = gBuffEffect.REINFORCEMENTS_MAX_COUNT
;("petltCtrl")[gPetAttributeType.SKILL_CDTIME_REDUCE] = gBuffEffect.SKILL_CDTIME_REDUCE
;("petltCtrl")[gPetAttributeType.PET_RESOURCE_PROTECT_BOOST] = gBuffEffect.RESOURCE_PROTECT_BOOST
;("petltCtrl")[gPetAttributeType.PET_RESOURCE_OUTPUT_BOOST] = gBuffEffect.RESOURCE_OUTPUT_BOOST
;("petltCtrl")[gPetAttributeType.PET_TROOP_DEFENSE_BOOST] = gBuffEffect.TROOP_DEFENSE_BOOST
;("petltCtrl")[gPetAttributeType.PET_FOOD_CONSUME_REDUCE] = gBuffEffect.FOOD_CONSUME_REDUCE
;("petltCtrl")[gPetAttributeType.PET_RESOURCE_PLUNDER_UP] = gBuffEffect.RESOURCE_PLUNDER_UP
;("petltCtrl")[gPetAttributeType.PET_CURE_SOLDIER_SPEED_BOOST] = gBuffEffect.CURE_SOLDIER_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.PET_TROOP_HP_BOOST] = gBuffEffect.TROOP_HP_BOOST
;("petltCtrl")[gPetAttributeType.PET_WOUNDED_SOLDIER_LIMIT_BOOST] = gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST
;("petltCtrl")[gPetAttributeType.PET_MASS_ATTACK_SPEED_UP] = gBuffEffect.MASS_ATTACK_SPEED_UP
;("petltCtrl")[gPetAttributeType.PET_PROTECT_POWER_EXCHANGE_UP] = gBuffEffect.PROTECT_POWER_EXCHANGE_UP
;("petltCtrl")[gPetAttributeType.PET_ELITE_POWER_UP] = gBuffEffect.ELITE_POWER_UP
;("petltCtrl")[gPetAttributeType.PET_INSTANT_BUILD_SPEED_BOOST] = gBuffEffect.INSTANT_BUILD_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.PET_INSTANT_RESEARCH_SPEED_BOOST] = gBuffEffect.INSTANT_RESEARCH_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.PET_ARMY_DEFENCE_REDUCE] = gBuffEffect.ARMY_DEFENCE_REDUCE
;("petltCtrl")[gPetAttributeType.PET_MASS_ATTACK_ATK_PLUS] = gBuffEffect.MASS_ATTACK_ATK_PLUS
;("petltCtrl")[gPetAttributeType.PET_SINGLE_ATTACK_MASSACRE_UP] = gBuffEffect.SINGLE_ATTACK_MASSACRE_UP
;("petltCtrl")[gPetAttributeType.ENEMY_ATTACK_REDUCE] = gBuffEffect.ENEMY_ATTACK_REDUCE
;("petltCtrl")[gPetAttributeType.IN_DEFENDING_SOLDIER_DEFENSE_BOOST] = gBuffEffect.IN_DEFENDING_SOLDIER_DEFENSE_BOOST
;("petltCtrl")[gPetAttributeType.DAMAGE_REDUCE] = gBuffEffect.DAMAGE_REDUCE
;("petltCtrl")[gPetAttributeType.BUILD_SPEED_BOST] = gBuffEffect.BUILD_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.MARCH_SPEED_BOOST] = gBuffEffect.MARCH_SPEED_BOOST
;("petltCtrl")[gPetAttributeType.DAMAGE_BOOST] = gBuffEffect.DAMAGE_BOOST
;("petltCtrl")[gPetAttributeType.LEGEND_DEF_UP] = gBuffEffect.LEGEND_DEF_UP
;("petltCtrl")[gPetAttributeType.LEGEND_ATTACK_UP] = gBuffEffect.LEGEND_ATTACK_UP
;("petltCtrl")[gPetAttributeType.LEGEND_HALLOFWAR_ARMY_UP_PERCENT] = gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT
;("petltCtrl")[gPetAttributeType.EXPEDITION_LOSS] = gBuffEffect.EXPEDITION_LOSS
;("petltCtrl")[gPetAttributeType.RUINS_WAR_MARCH_VALUE_LIMIT_BOOST] = gBuffEffect.RUINS_WAR_MARCH_VALUE_LIMIT_BOOST
;("petltCtrl")[gPetAttributeType.SOLDIER_BASE_ATTACK] = gBuffEffect.SOLDIER_BASE_ATTACK
;("petltCtrl")[gPetAttributeType.SOLDIER_BASE_HP] = gBuffEffect.SOLDIER_BASE_HP
local _ENV, ("petltCtrl")[gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST], petAttribute_2_buffAttribute = gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST, gBuffEffect.RADIANCE_MARCH_SPEED_BOOST, "petltCtrl"
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.GATHER_SPEED_BOOST] = gPetAttributeType.GATHER_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.SOLDIER_LOAD_BOOST] = gPetAttributeType.SOLDIER_LOAD_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.TRAIN_SPEED_BOOST] = gPetAttributeType.TRAIN_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.TROOP_ATTACK_BOOST] = gPetAttributeType.TROOP_ATTACK_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.MARCH_MONSTER_SPEED_BOOST] = gPetAttributeType.MARCH_MONSTER_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.STUDY_RESOURCE_REDUCE] = gPetAttributeType.STUDY_RESOURCE_REDUCE
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.CLUMP_NUM_BOOST] = gPetAttributeType.CLUMP_NUM_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] = gPetAttributeType.MARCH_VALUE_LIMIT_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.REINFORCEMENTS_MAX_COUNT] = gPetAttributeType.REINFORCEMENTS_MAX_COUNT
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.SKILL_CDTIME_REDUCE] = gPetAttributeType.SKILL_CDTIME_REDUCE
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.RESOURCE_PROTECT_BOOST] = gPetAttributeType.PET_RESOURCE_PROTECT_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.RESOURCE_OUTPUT_BOOST] = gPetAttributeType.PET_RESOURCE_OUTPUT_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.TROOP_DEFENSE_BOOST] = gPetAttributeType.PET_TROOP_DEFENSE_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.FOOD_CONSUME_REDUCE] = gPetAttributeType.PET_FOOD_CONSUME_REDUCE
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.RESOURCE_PLUNDER_UP] = gPetAttributeType.PET_RESOURCE_PLUNDER_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.CURE_SOLDIER_SPEED_BOOST] = gPetAttributeType.PET_CURE_SOLDIER_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.TROOP_HP_BOOST] = gPetAttributeType.PET_TROOP_HP_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.WOUNDED_SOLDIER_LIMIT_BOOST] = gPetAttributeType.PET_WOUNDED_SOLDIER_LIMIT_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.MASS_ATTACK_SPEED_UP] = gPetAttributeType.PET_MASS_ATTACK_SPEED_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.PROTECT_POWER_EXCHANGE_UP] = gPetAttributeType.PET_PROTECT_POWER_EXCHANGE_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.ELITE_POWER_UP] = gPetAttributeType.PET_ELITE_POWER_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.INSTANT_BUILD_SPEED_BOOST] = gPetAttributeType.PET_INSTANT_BUILD_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.INSTANT_RESEARCH_SPEED_BOOST] = gPetAttributeType.PET_INSTANT_RESEARCH_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.ARMY_DEFENCE_REDUCE] = gPetAttributeType.PET_ARMY_DEFENCE_REDUCE
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.MASS_ATTACK_ATK_PLUS] = gPetAttributeType.PET_MASS_ATTACK_ATK_PLUS
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.SINGLE_ATTACK_MASSACRE_UP] = gPetAttributeType.PET_SINGLE_ATTACK_MASSACRE_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.ENEMY_ATTACK_REDUCE] = gPetAttributeType.ENEMY_ATTACK_REDUCE
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.IN_DEFENDING_SOLDIER_DEFENSE_BOOST] = gPetAttributeType.IN_DEFENDING_SOLDIER_DEFENSE_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.DAMAGE_REDUCE] = gPetAttributeType.DAMAGE_REDUCE
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.BUILD_SPEED_BOOST] = gPetAttributeType.BUILD_SPEED_BOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.MARCH_SPEED_BOOST] = gPetAttributeType.MARCH_SPEED_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.DAMAGE_BOOST] = gPetAttributeType.DAMAGE_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.LEGEND_DEF_UP] = gPetAttributeType.LEGEND_DEF_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.LEGEND_ATTACK_UP] = gPetAttributeType.LEGEND_ATTACK_UP
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT] = gPetAttributeType.LEGEND_HALLOFWAR_ARMY_UP_PERCENT
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.EXPEDITION_LOSS] = gPetAttributeType.EXPEDITION_LOSS
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.RUINS_WAR_MARCH_VALUE_LIMIT_BOOST] = gPetAttributeType.RUINS_WAR_MARCH_VALUE_LIMIT_BOOST
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.SOLDIER_BASE_ATTACK] = gPetAttributeType.SOLDIER_BASE_ATTACK
gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.SOLDIER_BASE_HP] = gPetAttributeType.SOLDIER_BASE_HP
local _ENV, gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.RADIANCE_MARCH_SPEED_BOOST], buffAttribute_2_petAttribute = gBuffEffect.RADIANCE_MARCH_SPEED_BOOST, gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST, gPetAttributeType.RADIANCE_MARCH_SPEED_BOOST
gBuffEffect.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.LEGEND_DEF_UP] = gKingdomClassType.legendLord
gBuffEffect.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.LEGEND_ATTACK_UP] = gKingdomClassType.legendLord
local _ENV, gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT.petList, _ENV, _ENV, gBuffEffect.RADIANCE_MARCH_SPEED_BOOST[gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT], checkGroundBuff = gKingdomClassType.legendLord, gKingdomClassType.legendLord, gKingdomClassType.legendLord, gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT, gKingdomClassType.legendLord, gBuffEffect.RADIANCE_MARCH_SPEED_BOOST
gKingdomClassType.legendLord.curFreeFeed = 0
gKingdomClassType.legendLord.curGoldFeed = 0
gKingdomClassType.legendLord.curToolFeedExp = 0
gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT.queue, _ENV, gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT.feedInfo, gKingdomClassType.legendLord.feedTime = gKingdomClassType.legendLord, gKingdomClassType.legendLord, gKingdomClassType.legendLord, 0
local defaultData = gBuffEffect.LEGEND_HALLOFWAR_ARMY_UP_PERCENT
function petCtrl:ctor()
	petCtrl.super.ctor(self)
	self:resetData()
end
function petCtrl:resetData()
	self.handle_notify = nil
	self.petList = clone(defaultData.petList)
	self.feedInfo = clone(defaultData.feedInfo)
	self.queue = clone(defaultData.queue)
end
function petCtrl:update(dttime)
end
function petCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_UNLOCK_PET, handler(self, self.unlockPetRsp))
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_FEED_PET, handler(self, self.feedPetRsp))
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_ADVANCE_PET, handler(self, self.advancePetRsp))
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_GET_SPECIAL_SKILL_TOOL, handler(self, self.getSpecialSkillToolRsp))
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_GET_SPECIAL_SKILL_TOOL_ONEKEY, handler(self, self.getOnkeySpecialSkillToolRsp))
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_PET_SHARE, handler(self, self.petShareRsp))
	msgCtrl.register(gCmd.CMD_PET_MODULE, gCmd.REQ_PET_HANDBOOK, handler(self, self.pethandbookRsp))
	self:addEventListener(QUEUE_KEY_PET_INITIATIVE_SHARE, handler(self, self.petInitiactiveShareQueueCallBack))
end
function petCtrl:Logout()
	petCtrl.super.Logout(self)
	self:resetData()
end
function petCtrl:addPet(pet)
	self.petList[tostring(pet.petid)] = pet
end
function petCtrl:getPet(petid)
	return self.petList[tostring(petid)]
end
function petCtrl:getPetFeeder()
	return self.petFeeder.feederdata
end
function petCtrl:getPetUnlockData()
	return self.petFeeder.unlockdata
end
function petCtrl:getPetFeederById(petid)
	return self.petFeeder.feederdata[tostring(petid)]
end
function petCtrl:getPetUnlockDataById(petid)
	return self.petFeeder.unlockdata[tostring(petid)]
end
function petCtrl:getSortPetMapInfoList()
	local petMapList = petltCtrl:getPetMapInfoList()
	local petltCtrl, ret = petltCtrl, petltCtrl
	local petltCtrl, sortValues
	petltCtrl = nil
	;(nil).byUID = true
	local lastFeedPet = SoraDConfigGet("petCtrl:getSortPetMapInfoList:lastFeedPet~integer", nil)
	for _, petInfo in ipairs(petMapList) do
		if self:getPet(petInfo.pid) == nil and petCtrl:petIsCanUnlock(petInfo.pid) then
			table.insert(ret, petInfo)
		end
		local petId = petInfo.pid
		sortValues[petId] = 0
		local petData = self:getPet(petId)
		if petData == nil and petCtrl:petIsCanUnlock(petId) then
			sortValues[petId] = 50
		elseif petData ~= nil then
			if petData:getIsCanAdvance() then
				sortValues[petId] = 40
			elseif lastFeedPet == petId then
				sortValues[petId] = 20
			else
				sortValues[petId] = 10
			end
		end
	end
	for _, petInfo in ipairs(petMapList) do
		if self:getPet(petInfo.pid) ~= nil then
			table.insert(ret, petInfo)
		end
	end
	for _, petInfo in ipairs(petMapList) do
		if self:getPet(petInfo.pid) == nil and not petCtrl:petIsCanUnlock(petInfo.pid) then
			table.insert(ret, petInfo)
		end
	end
	local maxKey
	for key, value in pairs(sortValues) do
		if maxKey == nil or value >= sortValues[maxKey] then
			if maxKey == nil then
				maxKey = key
			elseif sortValues[maxKey] == value then
				if value == 40 and key > maxKey then
					maxKey = key
				elseif value ~= 40 and key < maxKey then
					maxKey = key
				end
			elseif value > sortValues[maxKey] then
				maxKey = key
			end
		end
	end
	return ret, maxKey
end
function petCtrl:getPetList()
	local _ENV, ret
	for k, v in pairs(petltCtrl.getPetCustomSort()) do
		if self.petList[tostring(v)] then
			table.insert(ret, self.petList[tostring(v)])
		end
	end
	return ret
end
function petCtrl:getHandbookInfo()
	local ret = clone(self.pethandbook)
	if not ret then
		ret, _ENV = self.pethandbook, self.pethandbook
	end
	return ret
end
function petCtrl:getPetMapInfoList()
	local petltCtrl = include("petltCtrl")
	local _ENV, ret = "petltCtrl", "petltCtrl"
	for i, v in ipairs(self:getHandbookInfo()) do
		if v.show == gPetHandbookStatus.VISIBLE then
			_ENV = self:getHandbookInfo()
			self:getHandbookInfo().pid = v.pet_id
			self:getHandbookInfo().rankInfo = petltCtrl.getPetRankList(v.pet_id)
			table.insert(ret, self:getHandbookInfo())
		end
	end
	return ret
end
function petCtrl:petInitiactiveShareQueueCallBack(event)
end
function petCtrl:petIsAleadyUnlock(petid)
	if self:getPet(petid) then
		return true
	else
		return false
	end
end
function petCtrl:petIsCanUnlock(petid)
	local petltCtrl = include("petltCtrl")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local isUnlock = true
	local debris, castlelv, lordlv, kill
	local info = petltCtrl.getPetUnlockInfo(petid)
	local curDebrisCount = backpackCtrl:getItemCount(info.debrisid)
	if curDebrisCount < info.debriscount then
		isUnlock = false
	end
	if info.debriscount > 0 then
		_ENV = info.debriscount
		info.debriscount.curDebrisCount = curDebrisCount
		info.debriscount.needDebriscount = info.debriscount
		info.debriscount.debrisid = info.debrisid
		debris, info.debriscount.isreach = info.debriscount, curDebrisCount >= info.debriscount
	end
	local curCastlelv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curCastlelv < info.castlelv then
		isUnlock = false
	end
	if 0 < info.castlelv then
		_ENV = info.castlelv
		info.castlelv.curCastlelv = curCastlelv
		info.castlelv.needCastlelv = info.castlelv
		castlelv, info.castlelv.isreach = info.castlelv, curCastlelv >= info.castlelv
	end
	local curLordlv = lordInfoCtrl.lordInfo.base.level
	if curLordlv < info.loardLv then
		isUnlock = false
	end
	if 0 < info.loardLv then
		_ENV = info.loardLv
		info.loardLv.curLordlv = curLordlv
		info.loardLv.needLoardLv = info.loardLv
		lordlv, info.loardLv.isreach = info.loardLv, curLordlv >= info.loardLv
	end
	local curKillCount = lordInfoCtrl.lordInfo.fcInfo.killCount
	if curKillCount < info.kill then
		isUnlock = false
	end
	if 0 < info.kill then
		_ENV = info.kill
		info.kill.curKillCount = curKillCount
		info.kill.needKillCount = info.kill
		kill, info.kill.isreach = info.kill, curKillCount >= info.kill
	end
	_ENV = info.kill
	info.kill.debris = debris
	info.kill.castlelv = castlelv
	info.kill.lordlv = lordlv
	local info.kill.kill, ret = kill, info.kill
	return isUnlock, ret
end
function petCtrl:getPetAttributeAdd(buffAttributeType)
	local attrType = buffAttribute_2_petAttribute[buffAttributeType]
	local ret = 0
	if checkGroundBuff[buffAttributeType] then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local mapClassType = kingdomMapCtrl:getKingdomClass()
		if mapClassType ~= checkGroundBuff[buffAttributeType] then
			return nil
		end
	end
	local getValue = function(aType, value)
		_UPVALUE2_ = nil
		;(nil)[1] = 85
		local (nil)[2], spArray = 86, nil
		if SoraDisInList(aType, spArray) then
			return value / 1000
		end
		return value
	end
	if attrType then
		for _, pet in pairs(self.petList) do
			local skillMap = include("petltCtrl").getPetTelentAndSecialSkill(pet.petid, pet.rank, pet.level)
			local telent = skillMap.telent
			for _, v in pairs(telent) do
				if v.attrType == attrType then
					ret = ret + getValue(attrType, v.value)
				end
			end
			local special_add = skillMap.special_add
			for _, v in pairs(special_add) do
				if v.attrType == attrType then
					ret = ret + getValue(attrType, v.value)
				end
			end
		end
	end
	if 0 == ret then
		ret = nil
	end
	return ret
end
function petCtrl:getPetShareLeftCDTime()
	local ret = 0
	local queue = self:queryQueue(QUEUE_KEY_PET_INITIATIVE_SHARE)
	if queue then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function petCtrl:getCanReceiveSpecialSkillToolNum()
	local ret = 0
	if self.petList and 0 < table.nums(self.petList) then
		for _, tempPet in pairs(self.petList) do
			if tempPet:isActivateSpecialSkillSend() and tempPet:getSpecialSkillSendCDTime() == 0 then
				ret = ret + 1
			end
		end
	end
	return ret
end
function petCtrl:getHasCanUnlockPet()
	local cityBuildBaseEntity = include("cityBuildBaseEntity")
	if cityBuildBaseEntity:getIsLocked(BUILDID.PETCENTER) then
		return false
	end
	local petMapList = petltCtrl:getPetMapInfoList()
	local petList = self:getPetList()
	local hasCanUnlock = false
	local _ENV, retList
	for _, petInfo in ipairs(petMapList) do
		if self:getPet(petInfo.pid) == nil and petCtrl:petIsCanUnlock(petInfo.pid) then
			hasCanUnlock = true
			table.insert(retList, petInfo.pid)
		end
	end
	return hasCanUnlock, retList
end
function petCtrl:getHasCanAdvancePet()
	if self:getIsShowedAdvanceTip() then
		return false
	end
	for key, value in pairs(self.petList) do
		if value:getIsCanAdvance() then
			return true
		end
	end
	return false
end
function petCtrl:getIsShowedAdvanceTip()
	_ENV = nil
	;(nil).byUID = true
	local lastOpenTime = SoraDConfigGet("petCtrl:getHasCanAdvancePet:lastOpenTime~integer", nil)
	if lastOpenTime and serviceFunctions.isSameDay(lastOpenTime) then
		return true
	end
	return false
end
function petCtrl:addPetShareQueue(starttime, totaltime, lefttime, data)
	self:addQueue(QUEUE_KEY_PET_INITIATIVE_SHARE, starttime, totaltime, lefttime, data)
end
function petCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self.queue[tostring(queuetype)] = nil
		self:dispatchEvent(event)
	end
	local _ENV, queue = self, self
	queue.starttime = starttime
	queue.totaltime = totaltime
	queue.data = data
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[tostring(queuetype)] = queue
	end
end
function petCtrl:queryQueue(queuetype)
	return self.queue[tostring(queuetype)]
end
function petCtrl:removeQueue(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[tostring(queuetype)] = nil
	end
end
function petCtrl:reqUnlockPet(petid, ...)
	serverproxy = nil
	;(nil).petid = petid
	serverproxy:Request(gCmd.CMD_PET_MODULE, gCmd.REQ_UNLOCK_PET, nil, ...)
end
function petCtrl:unlockPetRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local petInfo = content.data.retdata
		local pet = petClass.new()
		pet:setPetInfo(petInfo)
		self:addPet(pet)
		_ENV = self
		self.msg = "MESSAGE_SERVER_PET_UNLOCK"
		self.petid = petInfo.petid
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_SHOW"
		SoraDSendMessage(self)
		local eventName = gEventName.event_pet_update
		_ENV = nil
		;(nil).name = eventName
		self:dispatchEvent(nil)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_CENTER_VIEW"
		SoraDSendMessage(self)
	else
		print("petCtrl:unlockPetRsp err", err)
	end
end
function petCtrl:reqFeedPet(petid, feedType, other, ...)
