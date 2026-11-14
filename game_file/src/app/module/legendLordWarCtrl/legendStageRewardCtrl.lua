local legendRewardRead = include("legendRewardRead")
local GameModule = include("GameModule")
local legendStageRewardCtrl = class("legendStageRewardCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function legendStageRewardCtrl:ctor(properties)
	legendStageRewardCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LEGEND_LORD
	self:resetData()
end
function legendStageRewardCtrl:EnterGame()
	print("legendStageRewardCtrl:EnterGame()---")
	legendStageRewardCtrl.super.EnterGame(self)
	_ENV = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_WW_STAGE_REWARD_MODULE, gCmd.CMD_WW_STAGE_REWARD_STAGE_INFO, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_WW_STAGE_REWARD_MODULE, gCmd.CMD_WW_STAGE_REWARD_RANK_INFO, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_WW_STAGE_REWARD_MODULE, gCmd.CMD_WW_STAGE_REWARD_PERSON_PALACE_KILL, handler(self, self.reqKillRewardRsp))
	msgCtrl.register(gCmd.CMD_WW_STAGE_REWARD_MODULE, gCmd.CMD_WW_STAGE_REWARD_PERSON_PALACE_LOSE, handler(self, self.reqLoseRewardRsp))
	self:resetData()
	self:registerNotify()
end
function legendStageRewardCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).personPalaceKillScore = 0
	self.killAndLoseData, (nil).personPalaceLoseScore = nil, 0
end
function legendStageRewardCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WW_STAGE_REWARD, handler(self, self.notifyUpdate))
end
function legendStageRewardCtrl:notifyUpdate(event)
	local notifydata = event.data
	dump(event, "legendStageRewardCtrl:notifyUpdate", 10)
	_ENV = event
	event.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	event.eventID = self.activityID
	SoraDSendMessage(event)
	for k, v in ipairs(notifydata) do
		for _, data in pairs(v) do
			self:updateKillAndLoseData(data)
			_ENV = self
			self.msg = "MESSAGE_SERVER_LEGEND_STAGE_REWARD_KILL_OR_LOSE"
			SoraDSendMessage(self)
			return
		end
	end
end
function legendStageRewardCtrl:Logout()
	self:resetData()
	legendStageRewardCtrl.super.Logout(self)
end
function legendStageRewardCtrl:initClientData(retdata)
