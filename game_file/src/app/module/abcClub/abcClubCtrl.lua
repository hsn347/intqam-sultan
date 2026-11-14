local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local abcClubCtrl = class("abcClubCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function abcClubCtrl:ctor(properties)
	abcClubCtrl.super.ctor(self, properties)
	self.dataTable, abcClubCtrl = abcClubCtrl.super.ctor, abcClubCtrl.super.ctor
end
function abcClubCtrl:getPickLightData()
	return self.dataTable
end
function abcClubCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ABC_CLUB_MODULE, gCmd.REQ_SEND_EXCHANGE, handler(self, self.getExchangeRsp))
	msgCtrl.register(gCmd.CMD_ABC_CLUB_MODULE, gCmd.REQ_SEND_REFRESH, handler(self, self.getRefreshRsp))
	msgCtrl.register(gCmd.CMD_ABC_CLUB_MODULE, gCmd.REQ_OPEN_PAGE, handler(self, self.getOpenPageRsp))
end
function abcClubCtrl:sendExchange(mIndex)
	if 0 ~= mIndex then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_ABC_CLUB_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_SEND_EXCHANGE, gCmd.REQ_SEND_EXCHANGE
		;(nil).data, gCmd.REQ_SEND_EXCHANGE.index = gCmd.REQ_SEND_EXCHANGE, mIndex
		local msg
		serverproxy:SendMsg(msg)
	end
end
function abcClubCtrl:sendRefresh()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ABC_CLUB_MODULE
	local (nil).subcmd, msg = gCmd.REQ_SEND_REFRESH, nil
	serverproxy:SendMsg(msg)
end
function abcClubCtrl:sendOpenPage()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ABC_CLUB_MODULE
	local (nil).subcmd, msg = gCmd.REQ_OPEN_PAGE, nil
	serverproxy:SendMsg(msg)
end
function abcClubCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function abcClubCtrl:Logout()
	abcClubCtrl.super.Logout(self)
	self:resetData()
end
function abcClubCtrl:getExchangeRsp(content)
	if gErrDef.Err_None == content.err then
		local rewards = content.result
		SoraDPopGainItem(rewards[1].id, rewards[1].count)
	else
	end
	_ENV = SoraDPopGainItem
	SoraDPopGainItem.msg = "MESSAGE_SERVER_EVENTCENTER_LETTER_CLUB_EXCHANGE"
	SoraDPopGainItem.index = content.data.index
	SoraDSendMessage(SoraDPopGainItem)
	self:sendOpenPage()
end
function abcClubCtrl:getRefreshRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_EVENTCENTER_LETTER_CLUB_REFRESH"
	content.err.data = self.dataTable
	SoraDSendMessage(content.err)
end
function abcClubCtrl:getOpenPageRsp(content)
	if gErrDef.Err_None == content.err then
		self.dataTable = content.result
	else
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_EVENTCENTER_LETTER_CLUB_BACK"
	content.err.data = self.dataTable
	SoraDSendMessage(content.err)
end
return abcClubCtrl
