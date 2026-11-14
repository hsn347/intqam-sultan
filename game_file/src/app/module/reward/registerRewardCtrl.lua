local GameModule = include("GameModule")
local registerRewardCtrl = class("registerRewardCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function registerRewardCtrl:ctor(properties)
	registerRewardCtrl.super.ctor(self, properties)
	self:resetData()
end
function registerRewardCtrl:resetData()
end
function registerRewardCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_REGISTER_REWARD_MODULE, gCmd.REQ_REGISTER_REWARD_DATA, handler(self, self.getRegisterRewardData))
	self:initRegisterReward()
end
function registerRewardCtrl:initRegisterReward(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_REGISTER_REWARD_MODULE, gCmd.REQ_REGISTER_REWARD_DATA, nil, ...)
end
function registerRewardCtrl:getRegisterRewardData(content)
	print("初始化数据结束")
end
function registerRewardCtrl:Logout()
	registerRewardCtrl.super.Logout(self)
	self:resetData()
end
return registerRewardCtrl
