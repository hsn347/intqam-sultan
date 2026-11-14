local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local heroFestivalCtrl = class("heroFestivalCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function heroFestivalCtrl:ctor(properties)
	heroFestivalCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HERO_FESTIVAL
end
function heroFestivalCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_FEAST_DRAW_LOTTERY, handler(self, self.reqturnTableDrawTimesRsp))
	self:resetData()
end
function heroFestivalCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function heroFestivalCtrl:Logout()
	self:resetData()
	heroFestivalCtrl.super.Logout(self)
end
function heroFestivalCtrl:sendReqturnTableDrawTimesMsg(num)
	serverproxy = nil
	local (nil).num, data = num, nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_HERO_FEAST_DRAW_LOTTERY, data)
end
function heroFestivalCtrl:reqturnTableDrawTimesRsp(content)
	dump(content, "heroFestivalCtrl:reqturnTableDrawTimesRsp===", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_HERO_FESTIVAL_DRAW_REFRESH"
		gErrDef.Err_None.reward = content.rspdata.reward
		SoraDSendMessage(gErrDef.Err_None)
	end
end
return heroFestivalCtrl
