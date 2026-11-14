local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
local allianceRank = class("allianceRank", gameModule)
function allianceRank:ctor(properties)
	allianceRank.super.ctor(self, properties)
end
function allianceRank:EnterGame()
	allianceRank.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DONATE_RANK, handler(self, self.donateRankRsp))
	self.queue, allianceRank = msgCtrl.register, msgCtrl.register
	self:addEventListener(ALLIANCE_DONATE_DAYRANK_QUEUE, handler(self, self.dayRankQueueCallBack))
	self:addEventListener(ALLIANCE_DONATE_WEEKRANK_QUEUE, handler(self, self.weekRankQueueCallBack))
end
function allianceRank:resetData()
end
function allianceRank:dayRankQueueCallBack(event)
	self:reqDonateRank()
end
function allianceRank:weekRankQueueCallBack(event)
	self:reqDonateRank()
end
function allianceRank:update(dttime)
end
function allianceRank:addRankQueue(queuetype, starttime, totaltime, lefttime)
	local curqueue = self.queue[queuetype]
	if curqueue then
		timerList:cancelTimer(curqueue.timerNode)
		self.queue[queuetype] = nil
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self.queue[queuetype] = nil
		self:dispatchEvent(event)
	end
	local timerList, queue = timerList, timerList
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		node.timer:resetStartTime(starttime)
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function allianceRank:queryQueue(queuetype)
	local ret = self.queue[queuetype]
	return ret
end
function allianceRank:getDayRankLeftTime()
	local dayqueue = self:queryQueue(ALLIANCE_DONATE_DAYRANK_QUEUE)
	if dayqueue then
		return dayqueue.timerNode.timer:getRemainTime()
	else
		return 0
	end
end
function allianceRank:getWeekRankLeftTime()
	local weekqueue = self:queryQueue(ALLIANCE_DONATE_WEEKRANK_QUEUE)
	if weekqueue then
		return weekqueue.timerNode.timer:getRemainTime()
	else
		return 0
	end
end
function allianceRank:getDonateRank(ranktype)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local alliance = allianceMgr:getAlliance()
	local idlist = alliance.memberlist
	local memberlist = memberMgr:getDonateRank(idlist, ranktype)
	return memberlist
end
function allianceRank:reqDonateRank(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DONATE_RANK, nil, ...)
end
function allianceRank:donateRankRsp(content)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if content.err == gErrDef.Err_None then
		local memberlist = content.data.retdata.memberlist
		memberMgr:cleatMemNotSelf()
		for k, v in pairs(memberlist) do
			local member = include("member").new()
			member:setProperty("minfo", v.minfo)
			member:setProperty("uinfo", v.uinfo)
			memberMgr:addMember(member)
		end
		local dayqueue = content.data.retdata.dayqueue
		if dayqueue then
			self:addRankQueue(dayqueue.qtype, dayqueue.starttime, dayqueue.totaltime, dayqueue.totaltime)
		end
		local weekqueue = content.data.retdata.weekqueue
		if weekqueue then
			self:addRankQueue(weekqueue.qtype, weekqueue.starttime, weekqueue.totaltime, weekqueue.totaltime)
		end
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_GET_DONATE_RANK_SUCCESS"
		SoraDSendMessage(self)
	else
	end
end
return allianceRank
