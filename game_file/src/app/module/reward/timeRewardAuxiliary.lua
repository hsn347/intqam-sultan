local timeRewardAuxiliary = class("timeRewardAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
function timeRewardAuxiliary:ctor()
	self.timereward = include("timereward")
end
function timeRewardAuxiliary:handleData(data)
	if data and next(data) ~= nil then
		local time = data.time or 0
		self:openQueue(time)
		data.time = nil
	end
	return data.data
end
function timeRewardAuxiliary:openQueue(time)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.time_reward)
	if not queue and 0 < time then
		gametop = nil
		queueCtrl:addQueue(gQueueTypeDef.time_reward, serviceFunctions.systemTime(), time, time, nil)
		gametop = queueCtrl
		queueCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_MATOU_TIP"
		SoraDSendMessage(queueCtrl)
	end
end
return timeRewardAuxiliary
