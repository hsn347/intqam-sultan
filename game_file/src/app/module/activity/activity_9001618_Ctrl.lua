local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001618_Ctrl = class("activity_9001618_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001618_Ctrl:ctor(properties)
	activity_9001618_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_ALLIANCE_RECOMMEND
	self:resetData()
end
function activity_9001618_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HONOR_BACK_ALLIANCE_RECOMMEND_MODULE, gCmd.REQ_HONOR_BACK_ALLIANCE_RECOMMEND_DATA, handler(self, self.reqRecommendDataRsp))
end
function activity_9001618_Ctrl:Logout()
	activity_9001618_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001618_Ctrl:resetData()
end
function activity_9001618_Ctrl:reqRecommendData()
	serverproxy:Request(gCmd.CMD_HONOR_BACK_ALLIANCE_RECOMMEND_MODULE, gCmd.REQ_HONOR_BACK_ALLIANCE_RECOMMEND_DATA)
end
function activity_9001618_Ctrl:reqRecommendDataRsp(content)
	dump(content, "activity_9001618_Ctrl:reqRecommendDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001618_UPDATE"
		gErrDef.Err_None.recommend = content.rspdata.recommend
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001618_Ctrl:getReceiveStatusAndNum(...)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		return true, -1
	else
		return false, 0
	end
end
return activity_9001618_Ctrl
