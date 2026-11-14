local gametop = gModuleMgr.getObject("gametop")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
local timeTip = class("timeTip", function(cssFile)
	local view = include("ccsView")
	return view.new(cssFile)
end)
function timeTip:ctor()
	self.labTime = SoraDGetChildByName(self, "Text_time")
	self.labTime:setPositionY(31)
	self.leftTime = 0
	local timereward = include("timereward")
	local onlineRewardData = timeRewardCtrl:getTimeRewardData()
	self.curTimes = onlineRewardData.sequence
	self.curTime = timereward[self.curTimes].time
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.time_reward)
	if self.queue then
		self.leftTime = self.queue.timerNode.timer:getRemainTime()
		self.labTime:setString(SoraDConvertSecondToString(self.leftTime))
	else
		self:setVisible(false)
	end
	if self.leftTime > 0 then
		self:setLabTime()
	end
end
function timeTip:setLabTime()
	if self.timerHandler then
		SoraDManagerRemoveTimer(self, self.timerHandler)
		self.timerHandler = nil
	end
	self.timerHandler = SoradCreateTimer(self, handler(self, self.openTimeUp))
end
function timeTip:openTimeUp(dt)
	if self.queue then
		self.leftTime = self.queue.timerNode.timer:getRemainTime()
		if self.leftTime > 0 then
			self.labTime:setString(SoraDConvertSecondToString(self.leftTime))
		else
			self:endTimeUp()
		end
	elseif self:endTimeUp() then
		self:endTimeUp()
	end
end
function timeTip:endTimeUp()
	if self.timerHandler then
		SoraDManagerRemoveTimer(self, self.timerHandler)
		self.timerHandler = nil
	end
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_DELETE_MATOU_TIP"
	SoraDSendMessage(self)
end
return timeTip
