local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = class("cavalryRiseCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local activityID = gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY
local CAVALRY_RISE_LEVEL = 1
function cavalryRiseCtrl:getClassType()
	local param = SoraDGetCtrl("activityShowCtrl"):getParamByID(activityID)
	print("···cavalryRiseCtrl-paramlth", param.classtype)
	return param.classtype or 1
end
function cavalryRiseCtrl:getActivitySeasonEndTime()
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local endTime = activityShowCtrl:getEndTimeSecond(activityID)
	return endTime
end
function cavalryRiseCtrl:getActivityStatusTime()
	local endTime = self:getActivitySeasonEndTime()
	local sysTime = serviceFunctions.systemTime()
	if endTime > sysTime then
		return endTime - sysTime
	end
	return 0
end
function cavalryRiseCtrl:isActiveGold()
	return self.buytime > 0
end
function cavalryRiseCtrl:getTask()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	return activityTaskComponentCtrl:getQuestComponent(activityID)
end
function cavalryRiseCtrl:isResetEveryday()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local cavalryRiseRead = include("cavalryRiseRead")
	local taskList = self:getTaskList(self:getClassType())
	local ret = false
	for k, v in ipairs(taskList) do
		if v.type == 1 then
			ret = true
			break
		end
	end
	return ret
end
function cavalryRiseCtrl:getCurLevel()
	return self.curLv
end
function cavalryRiseCtrl:getCurLevelExp()
	return self.curExp
end
function cavalryRiseCtrl:getCurGoldLevel()
	return self.lv2
end
function cavalryRiseCtrl:getAwardReceiveStatusAndCount()
	local num = self:hasAward() and 1 or 0
	return 0 < num, num
end
function cavalryRiseCtrl:hasAward(level)
	local isGold = self:isActiveGold()
	level = level or self:getCurLevel()
	local cavalryRiseUtil = include("cavalryRiseUtil")
	local cavalryRiseRead = include("cavalryRiseRead")
	local CAVALRY_RISE_AWARD_TYPE = cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE
	local classType = self:getClassType()
	local getAwardNumByLevel = function(awardType, lv, count)
		local award
		if awardType == CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL then
			award = cavalryRiseRead:getLevelBronzeAward(lv, classType)
		else
			award = cavalryRiseRead:getLevelGoldAward(lv, classType)
		end
		return #award * count
	end
	local getAwardNumByLevelRange = function(awardType, levelBegin, levelEnd)
		if levelEnd < levelBegin then
			return 0
		end
		local num = 0
		local maxLevel = self:getMaxLevel()
		local levelEnd1 = math.min(levelEnd, maxLevel)
		for i = levelBegin, levelEnd1 do
			num = num + getAwardNumByLevel(awardType, i, 1)
			if 0 < num then
				print("###num", num, awardType, i)
				return num
			end
		end
		if levelEnd > maxLevel then
			num = num + getAwardNumByLevel(awardType, maxLevel + 1, levelEnd - maxLevel)
			if 0 < num then
				print("###num", num, awardType, levelBegin, levelEnd, maxLevel, levelEnd1)
				return num
			end
		end
		return num
	end
	local num = 0
	num = num + getAwardNumByLevelRange(CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL, self.lv1 + 1, level)
	if isGold then
		num = num + getAwardNumByLevelRange(CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD, self.lv2 + 1, level)
	end
	print("======num:", num, isGold, level)
	return 0 < num
end
function cavalryRiseCtrl:getAwardItemNum(minLv, maxLv)
	local awardItemNum_imp = function(lv)
		local curlv = math.max(lv, self:getCurLevel())
		return math.max(0, math.floor((curlv - self:getCurLevel()) / CAVALRY_RISE_LEVEL))
	end
	local num = awardItemNum_imp(maxLv) - awardItemNum_imp(minLv - 1)
	return math.max(0, num)
end
function cavalryRiseCtrl:getAwardItemStatus(awardType, lv)
	local cavalryRiseUtil = include("cavalryRiseUtil")
	local CAVALRY_RISE_AWARD_TYPE = cavalryRiseUtil.CAVALRY_RISE_AWARD_TYPE
	local CAVALRY_RISE_ITEM_TYPE = cavalryRiseUtil.CAVALRY_RISE_ITEM_TYPE
	local curLevel = self:getCurLevel()
	local cavalryRiseRead = include("cavalryRiseRead")
	local isLastLevel = cavalryRiseRead:isLastLevel(self:getClassType(), lv)
	if awardType == CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_NORMAL then
		if isLastLevel then
			lv = self.lv1 + 1
		end
		if lv <= self.lv1 then
			return CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_GOT
		elseif curLevel >= lv then
			return CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_GET
		end
	elseif awardType == CAVALRY_RISE_AWARD_TYPE.CAVALRY_RISE_AWARD_TYPE_GOLD then
		if isLastLevel then
			lv = self.lv2 + 1
		end
		if lv <= self.lv2 then
			return CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_GOT
		elseif curLevel >= lv then
			if self:isActiveGold() then
				return CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_GET
			else
				return CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_NEED_ACTIVITY
			end
		end
	end
	return CAVALRY_RISE_ITEM_TYPE.CAVALRY_RISE_ITEM_TYPE_NORMAL
end
function cavalryRiseCtrl:getTaskReceiveStatusAndNum()
	local num = 0
	local taskList = self:getTaskList(self:getClassType())
	for _, v in ipairs(taskList) do
		if not self:getTask():isTaskClaimed(v.taskID) and self:getTask():isTaskFinished(v.taskID) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function cavalryRiseCtrl:getReceiveStatusAndNum()
	local num1 = self:getAwardReceiveStatusAndCount() and 1 or 0
	local num2 = self:getTaskReceiveStatusAndNum() and 1 or 0
	local num = num1 + num2
	return 0 < num, num
end
function cavalryRiseCtrl:getTaskList(classType)
	local eventQuestRead = include("eventQuestRead")
	local cavalryRiseRead = include("cavalryRiseRead")
	if not cavalryRiseRead:getTaskShow(classType) then
		local _ENV, questShow = cavalryRiseRead:getTaskShow(classType), cavalryRiseRead:getTaskShow(classType)
	end
	local _ENV, typeID = cavalryRiseRead, cavalryRiseRead
	for questtype, listQuest in ipairs(questShow) do
		for index, questId in ipairs(listQuest) do
			typeID[questtype] = questId
			if not self:getTask():isTaskClaimed(questId) then
				break
			end
		end
	end
	local _ENV, t = (for generator), ipairs(questShow)
	for i, v in ipairs(typeID) do
		local taskConfig = eventQuestRead.getTaskConfig(v)
		_ENV = v
		v.taskID = v
		v.award = taskConfig.reward
		v.taskDes = taskConfig.taskDes
		t[i], v.guideId = v, taskConfig.guideId
	end
	return t
end
function cavalryRiseCtrl:reqActivityGetAllLevelReward()
	print("cavalryRiseCtrl:reqActivityGetAllLevelReward")
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CAVALRY_RISE_ACTIVITY_RECEIVE)
end
function cavalryRiseCtrl:ctor(properties)
	cavalryRiseCtrl.super.ctor(self, properties)
end
function cavalryRiseCtrl:EnterGame()
	self:resetData()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CAVALRY_RISE_ACTIVITY_RECEIVE, handler(self, self.reqCavalryRiseReceiveRSP))
	local notifyCtrl = SoraDGetCtrl("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:getQuestComponent(activityID)
end
function cavalryRiseCtrl:resetData()
	self.buytime = 0
	self.curLv = 0
	self.curExp = 0
	self.lv1 = 0
	self.lv2 = 0
end
function cavalryRiseCtrl:Logout()
	cavalryRiseCtrl.super.Logout(self)
	self:resetData()
end
function cavalryRiseCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content.activityID == activityID then
			self:updateData(content.notifyData, true)
			dump(content.notifyData, "铁骑崛起数据推送：=========", 10)
		end
	end
end
function cavalryRiseCtrl:initClientData(data)
	local activityInfo = data[tostring(activityID)]
	if not activityInfo then
		return
	end
	self:resetData()
	dump(activityInfo, "cavalryRiseCtrl:initClientData========", 10)
	self:updateData(activityInfo)
end
function cavalryRiseCtrl:updateData(data, bNotice)
	if data.buytime ~= nil and self.buytime ~= data.buytime then
		self.buytime = data.buytime
		if bNotice then
			self.willShowUnlockAnimation = true
			_ENV = data.buytime
			data.buytime.msg = "MESSAGE_CAVALRY_RISE_GOLD"
			SoraDSendMessage(data.buytime)
		end
	end
	local bNotifyLv, bNotifyExp
	if data.curLv ~= nil and self.curLv ~= data.curLv then
		print("等级修改", self.curLv, data.curLv)
		self.curLv = data.curLv
		bNotifyLv = true
	end
	if data.curExp ~= nil and self.curExp ~= data.curExp then
		print("经验修改", self.curExp, data.curExp)
		self.curExp = data.curExp
		bNotifyExp = true
	end
	if bNotice then
		if bNotifyLv then
			print("等级推送", self.curLv)
			_ENV = "等级推送"
			;("等级推送").msg = "MESSAGE_CAVALRY_RISE_LV"
			SoraDSendMessage("等级推送")
		elseif bNotifyExp then
			print("经验推送", self.curExp)
			_ENV = "经验推送"
			;("经验推送").msg = "MESSAGE_CAVALRY_RISE_EXP"
			SoraDSendMessage("经验推送")
		end
	end
	local bNotifyLv1, bNotifyLv2
	if data.lv1 ~= nil and self.lv1 ~= data.lv1 then
		self.lv1 = data.lv1
		bNotifyLv1 = true
	end
	if data.lv2 ~= nil and self.lv2 ~= data.lv2 then
		self.lv2 = data.lv2
		bNotifyLv1 = true
	end
	if bNotice and (bNotifyLv1 or bNotifyLv2) then
		_ENV = data.lv2
		data.lv2.msg = "MESSAGE_CAVALRY_RISE_AWARD"
		SoraDSendMessage(data.lv2)
	end
end
function cavalryRiseCtrl:exp2Lv(exp)
	return math.floor(exp / 100)
end
function cavalryRiseCtrl:reqCavalryRiseReceiveRSP(event)
	dump(event, "cavalryRiseCtrl:reqCavalryRiseReceiveRSP", 10)
	local err = event.err
	if err == gErrDef.Err_None then
		self:updateData(event.rspdata.cavalryRiseData, true)
		SoraDMailGainItems(event.rspdata.reward, true)
	end
end
function cavalryRiseCtrl:getMaxLevel()
	local cavalryRiseRead = include("cavalryRiseRead")
	return #cavalryRiseRead:getLevelList(self:getClassType()) - 1
end
function cavalryRiseCtrl:canGetLevelAwardBronze(level)
	local cavalryRiseRead = include("cavalryRiseRead")
	if cavalryRiseRead:isLastLevel(self:getClassType(), level) then
		return self.lv1 < self.curLv
	end
	return level > self.lv1 and level <= self.curLv
end
function cavalryRiseCtrl:canGetLevelAwardGold(level)
	local cavalryRiseRead = include("cavalryRiseRead")
	if cavalryRiseRead:isLastLevel(self:getClassType(), level) then
		return self.lv2 < self.curLv
	end
	return self:isActiveGold() and level > self.lv2 and level <= self.curLv
end
function cavalryRiseCtrl:getWillShowUnlockAnimation()
	return self.willShowUnlockAnimation
end
function cavalryRiseCtrl:resetWillShowUnlockAnimation()
	self.willShowUnlockAnimation = false
end
return cavalryRiseCtrl
