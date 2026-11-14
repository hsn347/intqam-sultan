local GameModule = include("GameModule")
local clientLogCtrl = class("clientLogCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function clientLogCtrl:ctor(properties)
	clientLogCtrl.super.ctor(self, properties)
end
function clientLogCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CLIENT_LOG_MODULE, gCmd.REQ_CLIENT_LOG_GIFT, handler(self, self.getClientLogGift))
	msgCtrl = gCmd.REQ_CLIENT_LOG_GIFT
	gCmd.REQ_CLIENT_LOG_GIFT.name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(gCmd.REQ_CLIENT_LOG_GIFT)
end
function clientLogCtrl:initData()
end
function clientLogCtrl:resetData()
end
function clientLogCtrl:Logout()
	clientLogCtrl.super.Logout(self)
	self:resetData()
end
function clientLogCtrl:getClientLogGift()
end
function clientLogCtrl:sendClickGift(giftid)
	local serverproxy, data
	data.giftid = giftid
	serverproxy:Request(gCmd.CMD_CLIENT_LOG_MODULE, gCmd.REQ_CLIENT_LOG_GIFT, data)
end
return clientLogCtrl
