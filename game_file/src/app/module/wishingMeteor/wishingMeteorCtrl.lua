local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local wishingMeteorCtrl = class("wishingMeteorCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function wishingMeteorCtrl:ctor(properties)
	wishingMeteorCtrl.super.ctor(self, properties)
	self:resetData()
end
function wishingMeteorCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WISHING_METEOR_MODULE, gCmd.REQ_WISHING_METEOR_DATA, handler(self, self.reqWishingMeteorDataRsp))
	msgCtrl.register(gCmd.CMD_WISHING_METEOR_MODULE, gCmd.REQ_WISHING_METEOR_WISH, handler(self, self.reqWishingMeteorWishRsp))
	msgCtrl.register(gCmd.CMD_WISHING_METEOR_MODULE, gCmd.REQ_WISHING_METEOR_DRAW_LOTTERY, handler(self, self.reqWishingMeteorDrawLotteryRsp))
end
function wishingMeteorCtrl:Logout()
	wishingMeteorCtrl.super.Logout(self)
	self:resetData()
end
function wishingMeteorCtrl:resetData()
	self.wish, _UPVALUE0_ = nil, nil
end
function wishingMeteorCtrl:reqWishingMeteorData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WISHING_METEOR_MODULE, gCmd.REQ_WISHING_METEOR_DATA, nil)
end
function wishingMeteorCtrl:reqWishingMeteorWish(data)
	serverproxy:Request(gCmd.CMD_WISHING_METEOR_MODULE, gCmd.REQ_WISHING_METEOR_WISH, data)
end
function wishingMeteorCtrl:reqWishingMeteorDrawLottery()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WISHING_METEOR_MODULE, gCmd.REQ_WISHING_METEOR_DRAW_LOTTERY, nil)
end
function wishingMeteorCtrl:reqWishingMeteorDataRsp(content)
	dump(content, "wishingMeteorCtrl:reqWishingMeteorDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.wish = content.rspdata.wish
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_WISHING_METEOR_BACK"
		gErrDef.Err_None.subMsg = "initBack"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function wishingMeteorCtrl:reqWishingMeteorWishRsp(content)
	dump(content, "wishingMeteorCtrl:reqWishingMeteorWishRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.wish = content.rspdata.wish
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_WISHING_METEOR_BACK"
		gErrDef.Err_None.subMsg = "wishBack"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function wishingMeteorCtrl:reqWishingMeteorDrawLotteryRsp(content)
	dump(content, "wishingMeteorCtrl:reqWishingMeteorDrawLotteryRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_WISHING_METEOR_BACK"
		gErrDef.Err_None.subMsg = "lotteryBack"
		gErrDef.Err_None.lv = content.rspdata.lv
		gErrDef.Err_None.idx = content.rspdata.idx
		gErrDef.Err_None.reward = content.rspdata.reward
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function wishingMeteorCtrl:getWishData()
	if not self.wish then
		_UPVALUE0_ = self.wish
	end
	return self.wish
end
function wishingMeteorCtrl:getReceiveStatusAndNum()
	return include("publicUtil").getCount(include("constantRead").getConstValue("WISHING_METEOR_ITMES", 857701)) > 0, -1
end
return wishingMeteorCtrl
