local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local exchangeltCtrl = include("exchangeltCtrl")
local exchangeCtrl = class("exchangeCtrl", gameModule)
local _ENV, REQ = "exchangeCtrl", "exchangeCtrl"
local _ENV, RSP = gameModule, gameModule
function exchangeCtrl:ctor(properties)
	exchangeCtrl.super.ctor(self, properties)
end
function exchangeCtrl:EnterGame()
	exchangeCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE, handler(self, RSP.exchangeRsp))
	msgCtrl.register(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE_SPICE_FEAST, handler(self, RSP.exchangeFeastRsp))
	msgCtrl.register(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE_SUMMER_FESTIVAL, handler(self, RSP.exchangeSummerFextivalRsp))
	msgCtrl.register(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE_BARBEQUE, handler(self, RSP.bbqExchengeRsp))
end
function exchangeCtrl:Logout()
	exchangeCtrl.super.Logout(self)
end
function exchangeCtrl:initClientData(data)
end
function exchangeCtrl:exchange(eid, exchangeNum)
	REQ.reqExchange(eid, exchangeNum)
end
function exchangeCtrl:exchangeFeast(eid, exchangeNum)
	REQ.reqExchangeFeast(eid, exchangeNum)
end
function exchangeCtrl:exchangeBBQ(eid, exchangeNum)
	REQ.reqBBQExchangeMsg(eid, exchangeNum)
end
function exchangeCtrl:reqExchangeSummerFestival(eid, exchangeNum)
	REQ.reqExchangeSummerFestival(eid, exchangeNum)
end
function REQ.reqExchange(exchangeID, exchangeNum)
	serverproxy = nil
	;(nil).eid = exchangeID
	local (nil).exchangeNum, data = exchangeNum, nil
	serverproxy:Request(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE, data)
end
function REQ.reqExchangeFeast(exchangeID, exchangeNum)
	serverproxy = nil
	;(nil).eid = exchangeID
	local (nil).exchangeNum, data = exchangeNum, nil
	serverproxy:Request(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE_SPICE_FEAST, data)
end
function REQ.reqBBQExchangeMsg(exchangeID, exchangeNum)
	serverproxy = nil
	;(nil).eid = exchangeID
	local (nil).exchangeNum, data = exchangeNum, nil
	serverproxy:Request(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE_BARBEQUE, data)
end
function REQ.reqExchangeSummerFestival(exchangeID, exchangeNum)
	serverproxy = nil
	;(nil).eid = exchangeID
	local (nil).exchangeNum, data = exchangeNum, nil
	serverproxy:Request(gCmd.CMD_EXCHANGE_MODULE, gCmd.REQ_EXCHANGE_SUMMER_FESTIVAL, data)
end
function RSP:exchangeRsp(content)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ITEM_EXCHANGE_REFRESH"
		gErrDef.Err_None.err = content.err
		gErrDef.Err_None.result = content.data.result[1]
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:exchangeFeastRsp(content)
	dump(content, "exchangeCtrl.exchangeFeastRsp", 5)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.data.result, true)
		_ENV = content.data.result
		content.data.result.msg = "MESSAGE_SERVER_SPICE_FEAST_EXCHANGE"
		content.data.result.err = content.err
		content.data.result.result = content.data.result
		SoraDSendMessage(content.data.result)
	elseif content.err == gErrDef.Err_SPICE_FEAST_EXCHANGE_OUT then
		SoraDShowMsgTip(i18n("spices_text_07"))
	end
	SoraDCloseLoading()
end
function RSP:exchangeSummerFextivalRsp(content)
	dump(content, "exchangeCtrl.exchangeSummerFextivalRsp", 5)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.data.result, true)
		_ENV = content.data.result
		content.data.result.msg = "MESSAGE_SERVER_SUMMER_FESTIVAL_EXCHANGE"
		content.data.result.err = content.err
		content.data.result.result = content.data.result
		SoraDSendMessage(content.data.result)
	elseif content.err == gErrDef.Err_SPICE_FEAST_EXCHANGE_OUT then
		SoraDShowMsgTip(i18n("spices_text_07"))
	end
	SoraDCloseLoading()
end
function RSP:bbqExchengeRsp(content)
	dump(content, "RSP.bbqExchengeRsp", 5)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.data.result, true)
	end
	_ENV = content.data.result
	content.data.result.msg = "MESSAGE_ITEM_EXCHANGE_REFRESH"
	SoraDSendMessage(content.data.result)
end
function RSP:noitfyDataRsp(content)
	for i, notifyData in ipairs(content.data) do
		local notifyType = notifyData.notifyType
		if "" == notifyType then
		end
	end
	_ENV = ipairs(content.data)
	ipairs(content.data).msg = "MESSAGE_ITEM_EXCHANGE_REFRESH"
	SoraDSendMessage(ipairs(content.data))
end
return exchangeCtrl
