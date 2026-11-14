local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001700_Ctrl = class("activity_9001700_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001700_Ctrl:ctor(properties)
	activity_9001700_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001700
	self:resetData()
end
function activity_9001700_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EIDAL_SALUTE_MODULE, gCmd.REQ_EIDAL_SALUTE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_EIDAL_SALUTE_MODULE, gCmd.REQ_EIDAL_SALUTE_QUEST_REWARD, handler(self, self.reqQuestRewardRsp))
	msgCtrl.register(gCmd.CMD_EIDAL_SALUTE_MODULE, gCmd.REQ_EIDAL_SALUTE_MAKE, handler(self, self.reqMakeRsp))
	msgCtrl.register(gCmd.CMD_EIDAL_SALUTE_MODULE, gCmd.REQ_EIDAL_SALUTE_GIVE, handler(self, self.reqGiveRsp))
	msgCtrl.register(gCmd.CMD_EIDAL_SALUTE_MODULE, gCmd.REQ_EIDAL_SALUTE_LET_OFF, handler(self, self.reqLetOffRsp))
	self:registerNotify()
end
function activity_9001700_Ctrl:Logout()
	activity_9001700_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001700_Ctrl:resetData()
	;(nil).materialList, _ENV, (nil).recievedSaluteList, _ENV, (nil).makedSaluteList, _ENV, (nil).questData, _ENV, (nil).dailyQuestData, _ENV, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.initData, (nil).letOffEndTime = nil, 0
	_ENV = nil
	;(nil).byUID = true
	self.isShield = SoraDConfigGet("Game:activity9001700:isShield~bool", nil) or false
	_ENV = nil
	;(nil).byUID = true
	self.readTime = SoraDConfigGet("Game:activity9001700:readTime~integer", nil) or 0
end
function activity_9001700_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.EIDAL_SALUTE, handler(self, self.notifyHandler))
	local activity_9001700_Read = include("activity_9001700_Read")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local drawingCostConfig = activity_9001700_Read.getDrawingCostConfig()
	for __, itemID in pairs(drawingCostConfig) do
		backpackCtrl:addItemChangeEvent(itemID, handler(self, self.notifyItemCount))
	end
end
function activity_9001700_Ctrl:notifyHandler(event)
