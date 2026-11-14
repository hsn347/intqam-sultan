local gamemodulec = include("GameModule")
local killMonsterVerifyCtrl = class("killMonsterVerifyCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local SEARCH_MONSTER_DISABLE_QUEUE_KEY = "SEARCH_MONSTER_DISABLE_QUEUE_KEY"
function killMonsterVerifyCtrl:ctor(properties)
	killMonsterVerifyCtrl.super.ctor(self, properties)
	self:resetData()
end
function killMonsterVerifyCtrl:resetData()
	self.queue, _UPVALUE0_ = nil, nil
end
function killMonsterVerifyCtrl:update(dttime)
end
function killMonsterVerifyCtrl:EnterGame()
	self:addEventListener(SEARCH_MONSTER_DISABLE_QUEUE_KEY, handler(self, self.quickSearchMonsterLockCallBack))
	msgCtrl.register(gCmd.CMD_KILL_MONSTER_VERIFY, gCmd.REQ_VERIFY_INIT, handler(self, self.getVerifyInitRsp))
	msgCtrl.register(gCmd.CMD_KILL_MONSTER_VERIFY, gCmd.REQ_ANSTER_QUESTION, handler(self, self.ansterQuestionRsp))
	self:reqGetVerifyInit()
end
function killMonsterVerifyCtrl:Logout()
	killMonsterVerifyCtrl.super.Logout(self)
	self:resetData()
end
function killMonsterVerifyCtrl:quickSearchMonsterLockCallBack(event)
	print("killMonsterVerifyCtrl:quickSearchMonsterLockCallBack")
	self:reqGetVerifyInit()
end
function killMonsterVerifyCtrl:isQuickSearchMonsterLock()
	local queue = self:queryQueue(SEARCH_MONSTER_DISABLE_QUEUE_KEY)
	if queue then
		return true
	else
		return false
	end
end
function killMonsterVerifyCtrl:getQuickSearchMonsterLockLeftTime()
	local lefttime = 0
	local queue = self:queryQueue(SEARCH_MONSTER_DISABLE_QUEUE_KEY)
	if queue then
		lefttime = queue.timerNode.timer:getRemainTime()
	end
	return lefttime
end
function killMonsterVerifyCtrl:addPunishMentTimeQueue(totaltime)
	local lefttime = self:getQuickSearchMonsterLockLeftTime()
	if totaltime > lefttime then
		local starttime = serviceFunctions.systemTime()
		local lefttime = totaltime
		_ENV = nil
		self:addQueue(SEARCH_MONSTER_DISABLE_QUEUE_KEY, starttime, totaltime, lefttime, nil)
	end
end
function killMonsterVerifyCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
		queuetype = self
		self.msg = "MESSAGE_SERVER_WORLD_MAP_MONSTER_SEARCH_LOCK"
		SoraDSendMessage(self)
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
	_ENV = tostring(queuetype)
	tostring(queuetype).msg = "MESSAGE_SERVER_WORLD_MAP_MONSTER_SEARCH_LOCK"
	SoraDSendMessage((tostring(queuetype)))
end
function killMonsterVerifyCtrl:queryQueue(queuetype)
	return self.queue[tostring(queuetype)]
end
function killMonsterVerifyCtrl:removeQueue(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[tostring(queuetype)] = nil
	end
end
function killMonsterVerifyCtrl:reqGetVerifyInit(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KILL_MONSTER_VERIFY, gCmd.REQ_VERIFY_INIT, nil, ...)
end
function killMonsterVerifyCtrl:getVerifyInitRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		if retdata and retdata.queue then
			for queuetype, v in pairs(retdata.queue) do
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
end
function killMonsterVerifyCtrl:reqAnsterQuestion(correctAnsterId, ...)
	print("killMonsterVerifyCtrl:reqAnsterQuestion", correctAnsterId)
	_ENV = nil
	;(nil).correctAnsterId = correctAnsterId
	serverproxy:Request(gCmd.CMD_KILL_MONSTER_VERIFY, gCmd.REQ_ANSTER_QUESTION, nil, ...)
end
function killMonsterVerifyCtrl:ansterQuestionRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		if retdata.lastAnsterResult then
			if retdata.reward then
				local _ENV, tableReward = retdata.reward, retdata.reward
				for i, v in ipairs(retdata.reward) do
					tableReward[v.id] = v.count
				end
				SoraDMailGainItems(tableReward)
			end
			SoraDShowMsgTip(i18n("common_text_2864"))
			_ENV = i18n("common_text_2864")
			i18n("common_text_2864").msg = "MESSAGE_SERVER_WORLD_MAP_MONSTER_VERIFY_BACK"
			i18n("common_text_2864").lastAnsterResult = retdata.lastAnsterResult
			SoraDSendMessage(i18n("common_text_2864"))
		else
			if retdata.isReach then
				self:addPunishMentTimeQueue(retdata.time)
				_ENV = i18n("common_text_2864")
				i18n("common_text_2864").count = retdata.count
				i18n("common_text_2864").time = SoraDConvertSecondToString(retdata.time)
				SoraDShowMsgTip(i18n("common_text_2868", i18n("common_text_2864")))
			else
				_ENV = i18n("common_text_2868", i18n("common_text_2864"))
				i18n("common_text_2868", i18n("common_text_2864")).count = retdata.count
				i18n("common_text_2868", i18n("common_text_2864")).time = SoraDConvertSecondToString(retdata.time)
				SoraDShowMsgTip(i18n("common_text_2867", i18n("common_text_2868", i18n("common_text_2864"))))
			end
			_ENV = i18n("common_text_2867", i18n("common_text_2868", i18n("common_text_2864")))
			i18n("common_text_2867", i18n("common_text_2868", i18n("common_text_2864"))).msg = "MESSAGE_SERVER_WORLD_MAP_MONSTER_VERIFY_BACK"
			i18n("common_text_2867", i18n("common_text_2868", i18n("common_text_2864"))).retdata = retdata
			SoraDSendMessage(i18n("common_text_2867", i18n("common_text_2868", i18n("common_text_2864"))))
		end
	else
		print("killMonsterVerifyCtrl:ansterQuestionRsp error", err)
	end
end
return killMonsterVerifyCtrl
