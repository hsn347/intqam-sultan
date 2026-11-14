local GameModule = include("GameModule")
local goldPackageCtrl = class("goldPackageCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function goldPackageCtrl:ctor(properties)
	goldPackageCtrl.super.ctor(self, properties)
end
function goldPackageCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_GOLD_GIFT_ACTIVITY_MODULE, gCmd.REQ_GET_INFO, handler(self, self.getGiftInfoRsp))
	msgCtrl.register(gCmd.CMD_GOLD_GIFT_ACTIVITY_MODULE, gCmd.REQ_BUY_GIFT_BY_GOLD, handler(self, self.getBuyGiftRsp))
	self:resetData()
end
function goldPackageCtrl:resetData()
	self.packageData, _UPVALUE0_, self.handle_notify = nil, nil, nil
end
function goldPackageCtrl:Logout()
	self:resetData()
	goldPackageCtrl.super.Logout(self)
end
function goldPackageCtrl:initClientData(data)
	self:registerNotify()
end
function goldPackageCtrl:dump()
end
function goldPackageCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GOLD_GIFT_ACTIVITY, handler(self, self.notifyHandler))
end
function goldPackageCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			if content.opType == "add" then
				table.insert(self.packageData, content.publishData)
			elseif content.opType == "remove" then
				for k, v in pairs(self.packageData) do
					if v.id == content.publishData.id then
						table.remove(self.packageData, k)
					end
				end
			end
			_ENV = pairs(self.packageData)
			pairs(self.packageData).msg = "MESSAGE_GOLD_PACKAGE_REFRESH_PACKAGE"
			SoraDSendMessage(pairs(self.packageData))
		end
	end
end
function goldPackageCtrl:sendGiftInfoMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_GOLD_GIFT_ACTIVITY_MODULE, gCmd.REQ_GET_INFO, data)
end
function goldPackageCtrl:sendBuyPackageMsg(id)
	local serverproxy, data
	data.id = id
	serverproxy:Request(gCmd.CMD_GOLD_GIFT_ACTIVITY_MODULE, gCmd.REQ_BUY_GIFT_BY_GOLD, data)
end
function goldPackageCtrl:getGiftInfoRsp(ret)
	if ret and ret.data.retdata then
		local data = ret.data.retdata.list
		if ret.err == gErrDef.Err_None then
			self.packageData, _ENV = ret.err, ret.err
			for k, v in pairs(data) do
				table.insert(self.packageData, v)
			end
		end
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_GOLD_PACKAGE_INIT_INFO"
	SoraDSendMessage(pairs(data))
end
function goldPackageCtrl:getBuyGiftRsp(ret)
	if ret and ret.data then
		local data = ret.data
		if ret.err == gErrDef.Err_None then
			for i, v in ipairs(self.packageData) do
				if v.id == data.id then
					v.remainTimes = data.retdata.remainTimes
					break
				end
			end
			SoraDShowMsgTip(i18n("gold_gift_text_04"))
		end
	end
	_ENV = SoraDShowMsgTip
	SoraDShowMsgTip.msg = "MESSAGE_GOLD_PACKAGE_REFRESH_PACKAGE"
	SoraDSendMessage(SoraDShowMsgTip)
end
function goldPackageCtrl:getPackageInfo()
	local _ENV, ret
	if self.packageData then
		for k, v in pairs(self.packageData) do
			table.insert(ret, v)
		end
	end
	table.sort(ret, function(l, r)
		return l.id > r.id
	end)
	return ret
end
return goldPackageCtrl
