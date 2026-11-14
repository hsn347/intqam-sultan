local pet = class("pet", cc.mvc.ModelBase)
local timerList = gModuleMgr.getObject("timerList")
function pet:ctor()
	pet.super.ctor(self)
	self.petid = 0
	self.level = 0
	self.curLevelExp = 0
	self.nextLevelExp = 0
	self.rank = 0
	self.curRankExp = 0
	self.queue, pet, self.nextRankExp = pet.super.ctor, pet.super.ctor, 0
	self:addEventListener(QUEUE_KEY_PET_SPECIAL_SKILL, handler(self, self.petSpecialSkillCallBack))
end
function pet:setPetInfo(petInfo)
	local petltCtrl = include("petltCtrl")
	self.petid = petInfo.petid
	self.level = petInfo.level
	self.curLevelExp = petInfo.curLevelExp
	self.rank = petInfo.rank
	self.curRankExp = petInfo.curRankExp
	self.nextRankExp = self:getPetIsReachMaxRank() and self.curRankExp or petltCtrl.getPetRankPro(self.petid, self.rank, gPetRankConfKey.exp)
	self.nextLevelExp = self:getPetIsReachMaxLvInCurRank() and self.curLevelExp or petltCtrl.getPetLevelPro(self.petid, self.level, gPetLevelConfKey.exp)
	if petInfo.queue then
		for queuetype, v in pairs(petInfo.queue) do
			local starttime = v.starttime
			local totaltime = v.totaltime
			local curtime = serviceFunctions.systemTime()
			local lasttime = curtime - starttime
			local lefttime = totaltime - lasttime
			if lefttime < 0 then
				lefttime = 0
			end
			if not v.data then
				local _ENV, data = v.data, v.data
			end
			self:addQueue(queuetype, starttime, totaltime, lefttime, data)
		end
	end
end
function pet:petSpecialSkillCallBack(event)
	local queuetype = event.name
	if QUEUE_KEY_PET_SPECIAL_SKILL == queuetype then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_PET_DATA_UPDATE"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_CENTER_VIEW"
		SoraDSendMessage(nil)
	end
end
function pet:getPetIsReachMaxLvInCurRank()
	local maxlv = include("petltCtrl").getPetRankPro(self.petid, self.rank, gPetRankConfKey.maxlv)
	if maxlv <= self.level then
		return true
	else
		return false
	end
end
function pet:getPetIsReachMaxRank()
	local maxRank = include("petltCtrl").getPetMaxRank(self.petid)
	if maxRank <= self.rank then
		return true
	else
		return false
	end
end
function pet:isActivateSpecialSkillSend()
	local skillMap = include("petltCtrl").getPetTelentAndSecialSkill(self.petid, self.rank, self.level)
	if table.nums(skillMap.special_send) > 0 then
		return true, skillMap.special_send
	end
	return false
end
function pet:getSpecialSkillSendCDTime()
	local ret = 0
	local queue = self:queryQueue(QUEUE_KEY_PET_SPECIAL_SKILL)
	if queue then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function pet:setPetSpecialSkillReceiveStatus(ret)
	self.isReceive = ret or false
end
function pet:getPetSpecialSkillReceiveStatus()
	return self.isReceive
end
function pet:getIsCanAdvance()
	local isFull = self:getPetIsReachMaxLvInCurRank() and not self:getPetIsReachMaxRank()
	if not isFull then
		return false
	end
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local needExp = self.nextRankExp - self.curRankExp
	local singleExp = backpackltCtrl:getPetAdvancedEXP(502801)
	local needCost = math.ceil(needExp / singleExp)
	local haveCount = backpackCtrl:getItemCount(502801)
	if needCost <= haveCount then
		return true
	end
	return false
end
function pet:addPetSpecialSkillSendQueue(starttime, totaltime)
	_ENV = nil
	self:addQueue(QUEUE_KEY_PET_SPECIAL_SKILL, starttime, totaltime, totaltime, nil)
end
function pet:removeSpecialSkillSendQueue()
	self:removeQueue(QUEUE_KEY_PET_SPECIAL_SKILL)
end
function pet:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
function pet:queryQueue(queuetype)
	return self.queue[tostring(queuetype)]
end
function pet:removeQueue(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[tostring(queuetype)] = nil
	end
end
function pet:getPower()
	local petltCtrl = include("petltCtrl")
	local rankPower = petltCtrl.getPetRankPro(self.petid, self.rank, gPetRankConfKey.power)
	local levelPower = petltCtrl.getPetLevelPro(self.petid, self.level, gPetLevelConfKey.power)
	Log.i("pet power", self.petid, rankPower, levelPower)
	local totalPower = rankPower + levelPower
	return totalPower
end
return pet
