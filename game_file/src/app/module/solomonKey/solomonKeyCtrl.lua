local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local solomonKeyCtrl = class("solomonKeyCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function solomonKeyCtrl:ctor(properties)
	solomonKeyCtrl.super.ctor(self, properties)
	self:resetData()
end
function solomonKeyCtrl:Logout()
	solomonKeyCtrl.super.Logout(self)
	self:resetData()
end
function solomonKeyCtrl:resetData()
end
function solomonKeyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SOLOMON_KEY_MODULE, gCmd.REQ_SOLOMONKEY_USEKEY, handler(self, self.reqUseKeyRsp))
	msgCtrl.register(gCmd.CMD_SOLOMON_KEY_MODULE, gCmd.REQ_SOLOMONKEY_GETLIST, handler(self, self.reqGetListRsp))
end
function solomonKeyCtrl:sendReqUseKey(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_SOLOMON_KEY_MODULE, gCmd.REQ_SOLOMONKEY_USEKEY, data)
end
function solomonKeyCtrl:sendReqGetList(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_SOLOMON_KEY_MODULE, gCmd.REQ_SOLOMONKEY_GETLIST, data)
end
function solomonKeyCtrl:reqUseKeyRsp(content)
	dump(content, "solomonKeyCtrl:reqUseKeyRsp", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_SOLOMON_AWARD_DATA"
		gErrDef.Err_None.reward = content.rspdata.reward[1]
		SoraDSendMessage(gErrDef.Err_None)
	end
	SoraDCloseLoading()
end
function solomonKeyCtrl:reqGetListRsp(content)
	dump(content, "turntableActivityCtrl:tenRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_SOLOMON_AWARD_LIST"
		gErrDef.Err_None.list = content.rspdata.list
		gErrDef.Err_None.keyID = content.data.keyID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
return solomonKeyCtrl
