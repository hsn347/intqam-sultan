local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001616_Ctrl = class("activity_9001616_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001616_Ctrl:ctor(properties)
	activity_9001616_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GHOLD_EMERGENCE_ACTIVITY
	local constantRead = include("constantRead")
	self.itemID = constantRead.getConstValue("SUMMON_GHOUL_COST_ITEM＿ID", 868301)
	self.itemCost = constantRead.getConstValue("SUMMON_GHOUL_COST_ITEM＿NUM", 5)
	self:resetData()
end
function activity_9001616_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GHOLD_EMERGENCE_MODULE, gCmd.REQ_GHOLD_EMERGENCE_SUMMON_BOSS, handler(self, self.reqSummonBossRsp))
	msgCtrl.register(gCmd.CMD_GHOLD_EMERGENCE_MODULE, gCmd.REQ_GHOLD_EMERGENCE_ALLINCE_DATA, handler(self, self.reqAllinceDataRsp))
	msgCtrl.register(gCmd.CMD_GHOLD_EMERGENCE_MODULE, gCmd.REQ_GHOLD_EMERGENCE_GET_RECORD, handler(self, self.reqGetRecordRsp))
	self:registerNotify()
end
function activity_9001616_Ctrl:Logout()
	activity_9001616_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001616_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).score = 0
	;(nil).count = 0
	self.buffEffectMap, _UPVALUE0_, self.initData, (nil).isDefault = nil, nil, nil, true
	self.ownAid = 0
end
function activity_9001616_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GHOLD_EMERGENCE, handler(self, self.notifyHandler))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(self.itemID, handler(self, self.notifyItemCount))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CREATE_SUCCESS", handler(self, self.notifyAllianceInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DISMISS_SUCCESS", handler(self, self.notifyAllianceInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.notifyAllianceInfo))
end
function activity_9001616_Ctrl:notifyAllianceInfo(...)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local ownAid = allianceMgr:getOwnAid()
	print("==activity_9001616_Ctrl:notifyAllianceInfo==", self.ownAid, ownAid)
	if self.ownAid ~= ownAid then
		self.ownAid = ownAid
		if clientEventMgr.judgeIsOpen(self.activityID) then
			self:sendReqInitDataMsg()
		end
	end
end
function activity_9001616_Ctrl:notifyHandler(event)
