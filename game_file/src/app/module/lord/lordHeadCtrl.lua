local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local lordHeadCtrl = class("lordHeadCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
function lordHeadCtrl:ctor(properties)
	lordHeadCtrl.super.ctor(self, properties)
end
function lordHeadCtrl:EnterGame()
	self:registerNotify()
end
function lordHeadCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LORD_HEAD, handler(self, self.notifyHandler))
end
function lordHeadCtrl:getReceiveStatusAndNum()
	return false, 0
end
function lordHeadCtrl:initClientData(data)
	dump(data, "==lordHeadCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.headData = data.usedHead
end
function lordHeadCtrl:notifyHandler(event)
	dump(event.data, "lordHeadCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content then
			self:initClientData(content.data)
			_ENV = self
			self.msg = "MESSAGE_HEAD_ITEM_USE_SUCCESS"
			SoraDSendMessage(self)
		end
	end
end
function lordHeadCtrl:Logout()
	lordHeadCtrl.super.Logout(self)
	self:resetData()
end
function lordHeadCtrl:resetData()
	self.headData = nil
end
function lordHeadCtrl:getHeadIsUnlock(headId)
	return self.headData[headId]
end
return lordHeadCtrl
