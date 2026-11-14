local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local waitQueueCtrl = class("waitQueueCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function waitQueueCtrl:ctor(properties)
	waitQueueCtrl.super.ctor(self, properties)
	self:resetData()
end
function waitQueueCtrl:EnterGame()
	self:registerNotify()
end
function waitQueueCtrl:Logout()
	waitQueueCtrl.super.Logout(self)
	self:resetData()
end
function waitQueueCtrl:resetData()
	self.waitQueueData, _UPVALUE0_ = nil, nil
end
function waitQueueCtrl:initClientData(data)
	dump(data, "waitQueueCtrl:initClientData(data)", 10)
	self.waitQueueData = data
end
function waitQueueCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WAIT_QUEUE, handler(self, self.notifyHandler))
end
function waitQueueCtrl:notifyHandler(event)
	dump(event.data, "waitQueueCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content.type == "refreshData" then
			self.waitQueueData = content.data
		end
	end
end
function waitQueueCtrl:getWaitQueueData(queueType)
	return self.waitQueueData[tostring(queueType)]
end
function waitQueueCtrl:checkWaitQueueFree(queueType)
	return self:getWaitQueueData(queueType) == nil
end
function waitQueueCtrl:checkIsWaiting(queueType, technologyId)
	local data = self:getWaitQueueData(queueType)
	return data and tonumber(data.technologyId) == tonumber(technologyId)
end
return waitQueueCtrl
