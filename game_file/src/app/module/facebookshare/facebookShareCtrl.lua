local GameModule = include("GameModule")
local facebookShareCtrl = class("facebookShareCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function facebookShareCtrl:ctor(properties)
	facebookShareCtrl.super.ctor(self, properties)
end
function facebookShareCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FACEBOOK_SHARE_MODULE, gCmd.REQ_DAILYREWARD_SHARE_REWARD, handler(self, self.getDailyRewardShareReward))
	msgCtrl.register(gCmd.CMD_FACEBOOK_SHARE_MODULE, gCmd.REQ_LORDLVUP_SHARE_REWARD, handler(self, self.getLordLvUpShareReward))
	msgCtrl.register(gCmd.CMD_FACEBOOK_SHARE_MODULE, gCmd.REQ_CASTLELVUP_SHARE_REWARD, handler(self, self.getCastleLvUpShareReward))
end
function facebookShareCtrl:getDailyRewardShareReward(content)
	local err = content.err
end
function facebookShareCtrl:getLordLvUpShareReward(content)
	local err = content.err
end
function facebookShareCtrl:getCastleLvUpShareReward(content)
	local err = content.err
end
function facebookShareCtrl:resetData()
end
function facebookShareCtrl:Logout()
	facebookShareCtrl.super.Logout(self)
end
function facebookShareCtrl:receiveDailyRewardShareReward(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FACEBOOK_SHARE_MODULE, gCmd.REQ_DAILYREWARD_SHARE_REWARD, nil, ...)
end
function facebookShareCtrl:receiveLordLvUpShareReward(...)
	print("请求领取领主升级分享奖励")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_FACEBOOK_SHARE_MODULE, gCmd.REQ_LORDLVUP_SHARE_REWARD, nil, ...)
end
function facebookShareCtrl:receiveCastleLvUpShareReward(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FACEBOOK_SHARE_MODULE, gCmd.REQ_CASTLELVUP_SHARE_REWARD, nil, ...)
end
return facebookShareCtrl
