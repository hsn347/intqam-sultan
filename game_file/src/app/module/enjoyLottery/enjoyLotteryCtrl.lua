local GameModule = include("GameModule")
local enjoyLotteryCtrl = class("enjoyLotteryCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function enjoyLotteryCtrl:ctor(properties)
	enjoyLotteryCtrl.super.ctor(self, properties)
end
function enjoyLotteryCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ENJOY_LOTTERY_MODULE, gCmd.REQ_ENJOY_LOTTERY_POND, handler(self, self.sendReqPondRsp))
	self:resetData()
end
function enjoyLotteryCtrl:resetData()
end
function enjoyLotteryCtrl:Logout()
	self:resetData()
	enjoyLotteryCtrl.super.Logout(self)
end
function enjoyLotteryCtrl:sendReqPond(nNum)
	serverproxy = nil
	local (nil).nNum, data = nNum, nil
	serverproxy:Request(gCmd.CMD_ENJOY_LOTTERY_MODULE, gCmd.REQ_ENJOY_LOTTERY_POND, data)
end
function enjoyLotteryCtrl:sendReqPondRsp(content)
	dump(content, "enjoyLotteryCtrl:sendReqPondRsp", 10)
	if gErrDef.Err_None == content.err and content.data.rewardinfo then
		_ENV = content.err
		content.err.msg = "MESSAGE_ENJOYLOTTERY_REFRESH"
		content.err.rewardinfo = content.data.rewardinfo
		SoraDSendMessage(content.err)
	end
end
return enjoyLotteryCtrl
