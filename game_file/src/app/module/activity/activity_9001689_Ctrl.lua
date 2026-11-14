local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001689_Ctrl = class("activity_9001689_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001689_Ctrl:ctor(properties)
	activity_9001689_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE_BRIBE
	self:resetData()
end
function activity_9001689_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DAILY_SALUTE_BRIBE_MODULE, gCmd.REQ_DAILY_SALUTE_BRIBE_DATA, handler(self, self.reqDataRsp))
	self:registerNotify()
end
function activity_9001689_Ctrl:Logout()
	activity_9001689_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001689_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).opencount = 0
	self.defaultData, (nil).totalCount = nil, 0
	self.build = nil
end
function activity_9001689_Ctrl:initClientData(data)
	dump(data, "activity_9001689_Ctrl:initClientData===")
end
function activity_9001689_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DAILY_SALUTE_BRIBE, handler(self, self.notifyHandler))
end
function activity_9001689_Ctrl:notifyHandler(event)
	dump(event, "activity_9001689_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.data then
			self.defaultData = v.data
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001689_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001689_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_DAILY_SALUTE_BRIBE_MODULE, gCmd.REQ_DAILY_SALUTE_BRIBE_DATA, nil)
end
function activity_9001689_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001689_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.defaultData = content.rspdata.data
		self.build = content.rspdata.build
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001689_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001689_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
	local status, leftTime = activity_9001688_Ctrl:getCycleState()
	if status == 1 and 0 < self:getRemainTimes() then
		num = num + 1
	end
	return 0 < num, num
end
function activity_9001689_Ctrl:getBuildPos()
	local mapSyncUtilClient = include("mapSyncUtilClient")
	if not self.build then
		return nil
	end
	return mapSyncUtilClient.serverTOClientPos(cc.p(self.build.x, self.build.y))
end
function activity_9001689_Ctrl:getRemainTimes()
	local constantRead = include("constantRead")
	local bribeNum = constantRead.getConstValue("DAILY_SALUTE_BRIBE_NUM")
	return bribeNum - self.defaultData.totalCount
end
return activity_9001689_Ctrl
