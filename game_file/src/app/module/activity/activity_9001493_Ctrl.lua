local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001493_Ctrl = class("activity_9001493_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001493_Ctrl:ctor(properties)
	activity_9001493_Ctrl.super.ctor(self, properties)
	local constantRead = include("constantRead")
	self.itemID = constantRead.getConstValue("FRIENDS_IN_RAMADAN_ITEM", 861201)
end
function activity_9001493_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GIVE_GIFTS_GIVE, handler(self, self.reqGiveRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GIVE_GIFTS_GET_REMAIN_NUM, handler(self, self.reqGetRemainNumRsp))
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	backpackCtrl:addItemChangeEvent(self.itemID, handler(self, self.notifyItemCount))
end
function activity_9001493_Ctrl:Logout()
	activity_9001493_Ctrl.super.Logout(self)
end
function activity_9001493_Ctrl:resetData()
end
function activity_9001493_Ctrl:notifyItemCount(...)
	print("==activity_9001493_Ctrl:notifyItemCount==", ...)
	_ENV = "==activity_9001493_Ctrl:notifyItemCount=="
	;("==activity_9001493_Ctrl:notifyItemCount==").msg = "MESSAGE_ACTIVITY_9001493_UPDATE"
	SoraDSendMessage("==activity_9001493_Ctrl:notifyItemCount==")
end
function activity_9001493_Ctrl:reqGive(targetUid, count)
	serverproxy = nil
	;(nil).targetUid = targetUid
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GIVE_GIFTS_GIVE, nil)
	local proxy = uiManager:getProxy("Activity_9001493_friend")
	if proxy then
		proxy:showLoading()
	end
end
function activity_9001493_Ctrl:reqGiveRsp(content)
	dump(content, "activity_9001493_Ctrl:reqGiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("common_text_3656"))
	elseif content.err == gErrDef.Err_GIVE_GIFTS_BE_GIVE_LIMIT then
		_ENV = i18n("common_text_3656")
		i18n("common_text_3656").num = content.rspdata.remainNum
		SoraDShowMsgTip(i18n("ramadan_friends_02", i18n("common_text_3656")))
	elseif content.err == gErrDef.ERR_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	local proxy = uiManager:getProxy("Activity_9001493_friend")
	if proxy then
		proxy:closeLoading()
	end
end
function activity_9001493_Ctrl:reqGetRemainNum(targetUid)
	serverproxy = nil
	;(nil).targetUid = targetUid
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GIVE_GIFTS_GET_REMAIN_NUM, nil)
	local proxy = uiManager:getProxy("Activity_9001493_friend")
	if proxy then
		proxy:showLoading()
	end
end
function activity_9001493_Ctrl:reqGetRemainNumRsp(content)
	dump(content, "activity_9001493_Ctrl:reqGetRemainNumRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local targetUid = content.data.targetUid
		local remainNum = content.rspdata.remainNum
		if remainNum == 0 then
			_ENV = nil
			;(nil).num = remainNum
			SoraDShowMsgTip(i18n("ramadan_friends_02", nil))
		else
			local maxValue = math.min(self:getItemCount(), remainNum)
			_ENV, _ENV = i18n("ramadan_friends_02", nil)
			i18n("ramadan_friends_02", nil).data, i18n("ramadan_friends_02", nil).uid = i18n("ramadan_friends_02", nil)
			i18n("ramadan_friends_02", nil).itemID = self:getItemID()
			i18n("ramadan_friends_02", nil).maxValue = maxValue
			uiManager:show("ItemSendPop", i18n("ramadan_friends_02", nil))
		end
	elseif content.err == gErrDef.ERR_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	local proxy = uiManager:getProxy("Activity_9001493_friend")
	if proxy then
		proxy:closeLoading()
	end
end
function activity_9001493_Ctrl:getReceiveStatusAndNum(...)
	if self:getItemCount() > 0 then
		return true, -1
	else
		return false
	end
end
function activity_9001493_Ctrl:getItemID(...)
	return self.itemID
end
function activity_9001493_Ctrl:getItemCount(...)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	return backpackCtrl:getItemCount(self.itemID)
end
function activity_9001493_Ctrl:checkItemCount(...)
	local itemCount = self:getItemCount()
	if itemCount <= 0 then
		SoraDShowMsgTip(i18n("common_text_2512"))
		_ENV = i18n("common_text_2512")
		i18n("common_text_2512").itemID = self:getItemID()
		uiManager:show("CommonSourceGuide", i18n("common_text_2512"))
		return false
	else
		return true
	end
end
return activity_9001493_Ctrl
