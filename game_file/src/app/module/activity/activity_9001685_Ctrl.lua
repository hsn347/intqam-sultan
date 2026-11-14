local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001685_Ctrl = class("activity_9001685_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001685_Ctrl:ctor(properties)
	activity_9001685_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.WEAPON_SPECIAL_BOX
	self.exchangeActID = gActivityTimeActivityID.WEAPON_SPECIAL_BOX
	self:resetData()
end
function activity_9001685_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WEAPON_SPECIAL_BOX_MODULE, gCmd.REQ_WEAPON_SPECIAL_BOX_DRAW, handler(self, self.reqDrawRsp))
end
function activity_9001685_Ctrl:Logout()
	activity_9001685_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001685_Ctrl:resetData()
end
function activity_9001685_Ctrl:initClientData(data)
	dump(data, "activity_9001685_Ctrl:initClientData===")
end
function activity_9001685_Ctrl:reqDraw(drawType)
	serverproxy = nil
	;(nil).drawType = drawType
	serverproxy:Request(gCmd.CMD_WEAPON_SPECIAL_BOX_MODULE, gCmd.REQ_WEAPON_SPECIAL_BOX_DRAW, nil)
end
function activity_9001685_Ctrl:reqDrawRsp(content)
	dump(content, "activity_9001685_Ctrl:reqDrawRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001685_UPDATE"
		gErrDef.Err_None.rewards = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001685_Ctrl:getReceiveStatusAndNum()
	local num = self:getDrawRedNum() + self:getExchangeRedNum()
	return 0 < num, -1
end
function activity_9001685_Ctrl:getDrawRedNum()
	local num = 0
	local activity_9001685_Read = include("activity_9001685_Read")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local drawCfg1 = activity_9001685_Read.getDrawCfg(1)
	local cost1 = drawCfg1.drawCost[2]
	local costCount = backpackCtrl:getItemCount(drawCfg1.drawCost[1])
	local reduceCount = backpackCtrl:getItemCount(drawCfg1.reduceId)
	local curCost1 = math.max(math.ceil(cost1 / 2), cost1 - reduceCount)
	if costCount >= curCost1 then
		num = 1
	end
	return num
end
function activity_9001685_Ctrl:getExchangeRedNum()
	local num = 0
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	if not activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID) then
		local _ENV, exchangeList = activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID), activityExchangeMallCtrl:getConfigByActivityID(self.exchangeActID)
	end
	for _, v in ipairs(exchangeList) do
		if v.remindStatus == 1 and v.curExchangeNum < v.limitnum then
			local itemEnough1 = backpackCtrl:getItemCount(v.exchangeitem) >= v.exchangenum
			local itemEnough2 = true
			if v.exchangeitem2 and v.exchangenum2 then
				itemEnough2 = backpackCtrl:getItemCount(v.exchangeitem2) >= v.exchangenum2
			end
			if itemEnough1 and itemEnough2 then
				num = num + 1
			end
		end
	end
	return num
end
return activity_9001685_Ctrl
