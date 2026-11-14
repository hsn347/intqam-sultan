local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local heroBiographyCtrl = class("heroBiographyCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local heroBiographyRead = include("heroBiographyRead")
function heroBiographyCtrl:ctor(properties)
	heroBiographyCtrl.super.ctor(self, properties)
end
function heroBiographyCtrl:Logout()
	heroBiographyCtrl.super.Logout(self)
	self:resetData()
end
function heroBiographyCtrl:resetData()
	self.finishedHeroMission, _UPVALUE0_, self.activeIndexList, _UPVALUE0_ = nil, nil, nil, nil
end
function heroBiographyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_BIOGRAPHY_MODULE, gCmd.REQ_HERO_BIOGRAPHY_INITDATA, handler(self, self.initDataRsp))
	msgCtrl.register(gCmd.CMD_HERO_BIOGRAPHY_MODULE, gCmd.REQ_HERO_BIOGRAPHY_UNLOCK, handler(self, self.unlockRsp))
	msgCtrl.register(gCmd.CMD_HERO_BIOGRAPHY_MODULE, gCmd.REQ_HERO_BIOGRAPHY_COMMIT_MISSION, handler(self, self.commitRsp))
end
function heroBiographyCtrl:initClientData(data)
	if data then
		self.activeIndexList = data.activeIndexList
		self.finishedHeroMission = data.finishedHeroMission
	end
	self:registerNotify()
end
function heroBiographyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_BIOGRAPHY, handler(self, self.notifyHandler))
end
function heroBiographyCtrl:notifyHandler(event)
	dump(event, "heroBiographyCtrl:notifyHandler", 5)
	for _, content in ipairs(event.data) do
		local svrData = content.data
		self.activeIndexList = svrData.activeIndexList
		self.finishedHeroMission = svrData.finishedHeroMission
	end
end
function heroBiographyCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HERO_BIOGRAPHY_MODULE, gCmd.REQ_HERO_BIOGRAPHY_INITDATA, nil)
end
function heroBiographyCtrl:reqUnlock(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_HERO_BIOGRAPHY_MODULE, gCmd.REQ_HERO_BIOGRAPHY_UNLOCK, nil)
end
function heroBiographyCtrl:reqInitData(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_HERO_BIOGRAPHY_MODULE, gCmd.REQ_HERO_BIOGRAPHY_COMMIT_MISSION, nil)
end
function heroBiographyCtrl:initDataRsp(content)
	dump(content, "heroBiographyCtrl:initDataRsp", 5)
	if gErrDef.Err_None == content.err then
		self.activeIndexList = content.initdata.activeIndexList
		self.finishedHeroMission = content.initdata.finishedHeroMission
	end
end
function heroBiographyCtrl:unlockRsp(content)
	dump(content, "heroBiographyCtrl:unlockRsp", 5)
	if gErrDef.Err_None == content.err then
		self.activeIndexList = content.rspdata.activeIndexList
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_HERO_STORY_UPDATE"
	content.err.isUnlock = true
	SoraDSendMessage(content.err)
end
function heroBiographyCtrl:commitRsp(content)
	dump(content, "heroBiographyCtrl:commitRsp", 5)
	if gErrDef.Err_None == content.err then
		self.finishedHeroMission = content.rspdata.finishedHeroMission
		self.rewardInfo = content.rspdata.rewardInfo
		SoraDMailGainItems(self.rewardInfo, true)
	end
	_ENV = self.rewardInfo
	self.rewardInfo.msg = "MESSAGE_SERVER_HERO_STORYTASK_UPDATE"
	self.rewardInfo.subMsg = "getReward"
	SoraDSendMessage(self.rewardInfo)
end
function heroBiographyCtrl:isAllHeroStoryOpen()
	local ret = true
	local heroBiographyRead = include("heroBiographyRead")
	local tb = heroBiographyRead.getStoryTb()
	for k, v in ipairs(tb) do
		if not self.activeIndexList[tostring(k)] then
			ret = false
			break
		end
	end
	return ret
end
function heroBiographyCtrl:isHeroStoryAdvanced(index)
	local ret = true
	local heroBiographyRead = include("heroBiographyRead")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
	for k, v in ipairs(heroList) do
		local info = heroCtrl:getHeroInfoByID(v)
		if not (not info or not (info.level < 120) and info.isAwake) or not info then
			ret = false
			break
		end
	end
	return ret
end
function heroBiographyCtrl:getUnlockHeroStoryNum()
	local num = 0
	local heroBiographyRead = include("heroBiographyRead")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local tb = heroBiographyRead.getStoryTb()
	for k, v in pairs(tb) do
		if not self.activeIndexList[tostring(v.GroupID)] then
			local isAllOwn = true
			for _, hid in ipairs(v.heroGroupID) do
				if not heroCtrl:getHeroInfoByID(hid) then
					isAllOwn = false
					break
				end
			end
			if isAllOwn then
				num = num + 1
			end
		end
	end
	return num
end
function heroBiographyCtrl:getHeroStoryStatus(index)
	local status = gHeroStoryUnLockType.LOCK
	if self.activeIndexList[tostring(index)] then
		status = gHeroStoryUnLockType.ACTIVED
	else
		local heroBiographyRead = include("heroBiographyRead")
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
		if heroList and next(heroList) then
			local isAllOwn = true
			for _, hid in ipairs(heroList) do
				if not heroCtrl:getHeroInfoByID(hid) then
					isAllOwn = false
					break
				end
			end
			if isAllOwn then
				status = gHeroStoryUnLockType.UNLOCK
			end
		end
	end
	return status
end
function heroBiographyCtrl:getNoneHeros(index)
	local _ENV, noneList
	local heroBiographyRead = include("heroBiographyRead")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
	for _, hid in ipairs(heroList) do
		if not heroCtrl:getHeroInfoByID(hid) then
			table.insert(noneList, hid)
		end
	end
	return noneList
end
function heroBiographyCtrl:getUnlockHeroStoryIndex()
	local index = 1
	local heroBiographyRead = include("heroBiographyRead")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local tb = heroBiographyRead.getStoryTb()
	for k, v in pairs(tb) do
		if not self.activeIndexList[tostring(k)] then
			local isAllOwn = true
			for _, hid in ipairs(v.heroGroupID) do
				if not heroCtrl:getHeroInfoByID(hid) then
					isAllOwn = false
					break
				end
			end
			if isAllOwn then
				index = k
				break
			end
		end
	end
	return index
end
function heroBiographyCtrl:isHeroSuitCondition(index, lv, awake)
	local ret = true
	local heroBiographyRead = include("heroBiographyRead")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroList = heroBiographyRead.getHeroListByStoryIndex(index)
	if lv and 0 < lv then
		for k, v in ipairs(heroList) do
			local info = heroCtrl:getHeroInfoByID(v)
			if info and lv > info.level or not info then
				ret = false
				break
			end
		end
	end
	if awake then
		for k, v in ipairs(heroList) do
			local info = heroCtrl:getHeroInfoByID(v)
			if not (not info or info.isAwake) or not info then
				ret = false
				break
			end
		end
	end
	return ret
end
function heroBiographyCtrl:isTaskFinish(taskType, heroID, taskGoal)
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	if not heroInfo then
		return false
	end
	if taskType == 2 then
		if taskGoal <= heroInfo.level then
			return true
		end
	elseif taskType == 3 then
		if taskGoal <= heroInfo.quality then
			return true
		end
	elseif taskType == 4 and heroInfo.isAwake then
		return true
	end
	return false
end
function heroBiographyCtrl:getHeroTaskList(heroID)
	local config = heroBiographyRead.getHeroTaskConfig(heroID)
	print("heroID", heroID)
	for i, v in ipairs(config) do
		if self.finishedHeroMission[tostring(v.missionID)] then
			v.status = gBtnTargetStatusDef.GOT
		elseif self:isTaskFinish(v.type, heroID, v.quality) then
			v.status = gBtnTargetStatusDef.GET
		else
			v.status = gBtnTargetStatusDef.GO
		end
	end
	table.sort(config, function(l, r)
		if l.status ~= r.status then
			return l.status < r.status
		else
			return l.missionID < r.missionID
		end
	end)
	return config
end
function heroBiographyCtrl:isAllTaskFinish(heroID)
	local taskList = self:getHeroTaskList(heroID)
	local isAllFinish = true
	local getAwardNum = 0
	for i, v in ipairs(taskList) do
		if v.status == gBtnTargetStatusDef.GO then
			isAllFinish = false
		elseif v.status == gBtnTargetStatusDef.GET then
			isAllFinish = false
			getAwardNum = getAwardNum + 1
		end
	end
	return isAllFinish, getAwardNum
end
function heroBiographyCtrl:getBiographyIndexByHeroID(heroID)
	local index = 1
	local biographyList = heroBiographyRead.getHeroBiographyList(heroID)
	table.sort(biographyList, function(a, b)
		return a.groupID < b.groupID
	end)
	local firstUnlockIndex
	if biographyList and next(biographyList) then
		if self:isAllHeroStoryOpen() then
			index = biographyList[1].groupID
		else
			for _, v in ipairs(biographyList) do
				local status = self:getHeroStoryStatus(v.groupID)
				if status == gHeroStoryUnLockType.UNLOCK then
					index = v.groupID
					firstUnlockIndex = nil
					break
				elseif gHeroStoryUnLockType.LOCK == status and not firstUnlockIndex then
					firstUnlockIndex = v.groupID
				else
					index = v.groupID
					break
				end
			end
			if firstUnlockIndex then
				index = firstUnlockIndex
			end
		end
	end
	return index
end
function heroBiographyCtrl:getHeroUnlockBiographyNum(heroID)
	local num = 0
	print("getHeroUnlockBiographyNum", heroID)
	local biographyList = heroBiographyRead.getHeroBiographyList(heroID)
	if biographyList and next(biographyList) then
		for _, v in ipairs(biographyList) do
			local status = self:getHeroStoryStatus(v.groupID)
			if status == gHeroStoryUnLockType.UNLOCK then
				num = num + 1
			end
		end
	else
		num = -1
	end
	return num
end
function heroBiographyCtrl:isStoryAwardGot(heroID)
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local taskID = heroBiographyRead.getHeroUnlockTaskID(heroID)
	if not taskID or self.finishedHeroMission[tostring(taskID)] then
		return true
	elseif heroCtrl:getHeroInfoByID(heroID) then
		return false
	else
		return true
	end
end
function heroBiographyCtrl:queryHeroBiographyBuff(buffType)
	local ret = 0
	local heroBiographyRead = include("heroBiographyRead")
	for k, v in pairs(heroBiographyRead.skill) do
		if not v.buffType then
			local _ENV, buffTypes = v.buffType, v.buffType
		end
		local buffModes = v.buffMode
		local buffNums = v.buffNum
		for k2, v2 in ipairs(buffTypes) do
			if v2 == buffType and heroBiographyRead.getIsActivedSkill(nil, v) then
				local val = buffNums[k2]
				if buffModes[k2] == 5 then
					val = val / 1000
				end
				ret = ret + val
			end
		end
	end
	return ret
end
function heroBiographyCtrl:isSkillActived(skillID)
	return heroBiographyRead.getIsActivedSkill(skillID) ~= nil
end
return heroBiographyCtrl
