local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local wishingTreeCtrl = class("wishingTreeCtrl", GameModule)
function wishingTreeCtrl:ctor(properties)
	wishingTreeCtrl.super.ctor(self, properties)
end
local giftId = 13562
function wishingTreeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WISH_REBATE_MODULE, gCmd.REQ_WISH_REBATE_BUY_GIFT, handler(self, self.sendReqGetUpRewardRsp))
	self:resetData()
	self:registerNotify()
end
function wishingTreeCtrl:Logout()
	self:resetData()
	wishingTreeCtrl.super.Logout(self)
end
function wishingTreeCtrl:initClientData(content)
	if not content then
		return
	end
end
function wishingTreeCtrl:resetData()
end
function wishingTreeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WISH_REBATE, handler(self, self.notifyCallback))
end
function wishingTreeCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			if content.type == "buyGift" then
				dump(content, "==wishingTreeCtrl:notifyCallback==", 20)
				if content.data.success then
					_ENV = content
					content.msg = "MESSAGE_WISHING_TRESS_RECHARGE_SUCCESS"
					SoraDSendMessage(content)
				end
			end
		end
	end
end
function wishingTreeCtrl:sendReqGetUpRewardRsp(content)
	dump(content, "==wishingTreeCtrl:sendReqRefreshRsp==", 20)
	if content.err == gErrDef.Err_None or not content.err then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.data.rechargeID or 13670, orderID)
	end
end
function wishingTreeCtrl:sendReqUpReward(data)
	serverproxy:Request(gCmd.CMD_WISH_REBATE_MODULE, gCmd.REQ_WISH_REBATE_BUY_GIFT, data)
end
function wishingTreeCtrl:getIsPrivilege()
	local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
	return privilegeGiftCtrl:getErrByRechargeID(giftId) == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY
end
function wishingTreeCtrl:getReceiveStatusAndNum(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local stageInfo = activityShowCtrl:getShowDataByID(self.activityId)
	local sessionType = stageInfo and stageInfo.doStage or 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local taskRet, taskNum = activityTaskComponentCtrl:getReceiveStatusAndNum(activityID)
	if sessionType ~= 0 then
		taskNum = 0
	end
	local rewardret, rewardNum = activityTaskComponentCtrl:getWishTreeRedPointAndNum(0)
	local total = (taskRet and taskNum or 0) + rewardNum
	return taskRet or rewardret, total, rewardNum
end
return wishingTreeCtrl
