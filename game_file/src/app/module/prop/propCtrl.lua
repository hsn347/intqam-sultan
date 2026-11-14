local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local rechargeRedEnvelopesltCtrl = include("rechargeRedEnvelopesltCtrl")
local propCtrl = class("propCtrl", gameModule)
local _ENV, REQ = "propCtrl", "propCtrl"
local _ENV, RSP = gameModule, gameModule
function propCtrl:initClientData(data)
	if "table" == type(data) then
		for k, v in pairs(data) do
			self.property[tonumber(k)] = v
		end
	end
end
function propCtrl:likeJoke(jokeID)
	self:discussJoke("like", jokeID)
end
function propCtrl:unlikeJoke(jokeID)
	self:discussJoke("unlike", jokeID)
end
function propCtrl:discussJoke(op, jokeID)
	serverproxy = nil
	;(nil).jokeID = jokeID
	local (nil).op, data = op, nil
	serverproxy:Request(gCmd.CMD_PROP_MODULE, gCmd.REQ_PROP_DISCUSS_JOKE, data)
end
function propCtrl:getPumpkinCandy()
	if self._isGetPumpkinCandy then
		return
	end
	local serverproxy, data = self._isGetPumpkinCandy, self._isGetPumpkinCandy
	serverproxy:Request(gCmd.CMD_PROP_MODULE, gCmd.REQ_PROP_GET_PUMPKIN_CANDY, data)
	return gErrDef.Err_None
end
function propCtrl:getCurrentEffectID()
	if self.property[gItemEffectDef.EFFECT] then
		return self.property[gItemEffectDef.EFFECT].effectID
	end
end
function propCtrl:checkRechargeGoldGift(chatChannel, giftCount, message, rid)
	serverproxy = nil
	;(nil).chatChannel = chatChannel
	;(nil).giftCount = giftCount
	;(nil).message = message
	local (nil).rid, data = rid, nil
	serverproxy:Request(gCmd.CMD_PROP_MODULE, gCmd.REQ_PROP_CHECK_RECHARGE_GOLD_GIFT, data)
	return gErrDef.Err_None
end
function propCtrl:getRechargeRedEnvelopesList()
	return rechargeRedEnvelopesltCtrl:getRechargeList()
end
function RSP:discussJokeRsp(content)
	if content.err ~= gErrDef.Err_None then
	end
end
function RSP:getPumpkinCandyRsp(content)
	if content.err == gErrDef.Err_None then
		local _ENV, ret = content.err, content.err
		for i, v in ipairs(content.data) do
			table.insert(ret, v.nickName)
		end
		if 0 < #ret then
			_ENV = ipairs(content.data)
			ipairs(content.data).msg = "MESSAGE_HALLOWEEN_ACTION"
			ipairs(content.data).data = ret
			ipairs(content.data).isAFK = true
			SoraDSendMessage(ipairs(content.data))
		end
	end
end
function RSP:noitfyDataRsp(content)
	for i, notifyData in ipairs(content.data) do
		local notifyType = notifyData.notifyType
		if gItemEffectDef.ANIMATION == notifyType then
			local list = notifyData.data
			local _ENV, ret
			for i, v in ipairs(list) do
				table.insert(ret, v.nickname)
			end
			_ENV = ipairs(list)
			ipairs(list).msg = "MESSAGE_HALLOWEEN_ACTION"
			ipairs(list).data = ret
			SoraDSendMessage(ipairs(list))
		elseif gItemEffectDef.EFFECT == notifyType then
			self.property[gItemEffectDef.EFFECT] = notifyData.notifyData
		elseif gItemEffectDef.RECHARGE_GOLD_GIFT == notifyType then
			local success = notifyData.data.success
			local rid = notifyData.data.rid
			paymentManager.OnemtRechargeSuccess(notifyData.data.price)
			paymentManager.loopForFinishTransaction()
			_ENV = notifyData.data.price
			_ENV, notifyData.data.price.msg = ipairs(list)
			ipairs(list).result = success
			notifyData.data.price.data, ipairs(list).rid = ipairs(list)
			SoraDSendMessage(notifyData.data.price)
			print("success, rid = ", success, rid)
		end
	end
end
function RSP:checkGoldGiftRsp(content)
	local ret = content.err
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_RECHARGECENTER_REDPACKETNEXTCEHCKFAIL"
	SoraDSendMessage(nil)
	if gErrDef.Err_None == ret then
		local orderID = content.data.orderID
		local rid = content.data.rid
		paymentManager.purchase(rid, orderID)
	elseif gErrDef.Err_CLIENT_EXCEPTION == ret then
		local errParam = content.data.errParam
		if "chatChannel" == errParam then
		elseif "giftCount" == errParam then
		elseif "message" == errParam then
		elseif "playerInfo" == errParam then
		end
	elseif gErrDef.Err_ALLIANCE_PLAYER_NOT_IN_ALLIANCE == ret then
	elseif gErrDef.Err_TOOLS_NOT_REACH == ret then
	end
end
function propCtrl:ctor(properties)
	propCtrl.super.ctor(self, properties)
	self.property, propCtrl = propCtrl.super.ctor, propCtrl.super.ctor
end
function propCtrl:EnterGame()
	propCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_PROP_MODULE, gCmd.REQ_PROP_DISCUSS_JOKE, handler(self, RSP.discussJokeRsp))
	msgCtrl.register(gCmd.CMD_PROP_MODULE, gCmd.REQ_PROP_GET_PUMPKIN_CANDY, handler(self, RSP.getPumpkinCandyRsp))
	msgCtrl.register(gCmd.CMD_PROP_MODULE, gCmd.REQ_PROP_CHECK_RECHARGE_GOLD_GIFT, handler(self, RSP.checkGoldGiftRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.PROP, handler(self, RSP.noitfyDataRsp))
end
function propCtrl:resetData()
	self.property, _UPVALUE0_ = nil, nil
	self._isGetPumpkinCandy = false
end
function propCtrl:Logout()
	propCtrl.super.Logout(self)
	self:resetData()
end
return propCtrl
