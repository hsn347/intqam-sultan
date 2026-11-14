local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001594_Ctrl = class("activity_9001594_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001594_Ctrl:ctor(properties)
	activity_9001594_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY
	local activity_9001594_Read = include("activity_9001594_Read")
	self.itemID = activity_9001594_Read.getItemID()
	self:resetData()
end
function activity_9001594_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_WATER, handler(self, self.reqWaterRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_SPREAD, handler(self, self.reqSpreadRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_MEMBERS, handler(self, self.reqMembersRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_ASSIST, handler(self, self.reqAssistRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_RANK, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_RECORD, handler(self, self.reqRecordRsp))
	msgCtrl.register(gCmd.CMD_PLANT_DATA_PALM_MODULE, gCmd.REQ_PLANT_DATA_PALM_GROUTH, handler(self, self.reqGrouthRsp))
	self:registerNotify()
	self:reqInitData()
end
function activity_9001594_Ctrl:Logout()
	activity_9001594_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001594_Ctrl:resetData()
	self.records, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil
end
function activity_9001594_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PLANT_DATA_PALM, handler(self, self.notifyHandler))
end
function activity_9001594_Ctrl:notifyHandler(event)
