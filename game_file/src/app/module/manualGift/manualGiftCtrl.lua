local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local manualGiftCtrl = class("manualGiftCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function manualGiftCtrl:ctor(properties)
	manualGiftCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MANUAL_GIFT_ACTIVITY
end
function manualGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MANUAL_GIFT_MODULE, gCmd.REQ_BUY_MANUAL_GIFT, handler(self, self.reqBuyPackageRsp))
	self:resetData()
	self:registerNotify()
end
function manualGiftCtrl:initClientData(content)
	dump(content, "==manualGiftCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.clientData = content
end
function manualGiftCtrl:initActivityData(content)
	dump(content, "==manualGiftCtrl:initActivityData==", 20)
	if not content then
		return
	end
	self.activityData = content
end
function manualGiftCtrl:resetData()
	self.clientData = nil
	self.activityData = nil
end
function manualGiftCtrl:Logout()
	self:resetData()
	manualGiftCtrl.super.Logout(self)
end
function manualGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MANUAL_GIFT_ACTIVITY, handler(self, self.notifyHandler))
end
function manualGiftCtrl:notifyHandler(event)
	dump(event.data, "manualGiftCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			if content.type == "buyGift" then
				self.clientData.userData.buyGiftList = content.data.buyGiftList
				_ENV = content.data.buyGiftList
				content.data.buyGiftList.msg = "MESSAGE_OPTIONAL_PACKAGE_BUY_SUCCESS"
				SoraDSendMessage(content.data.buyGiftList)
				_ENV = content.data.buyGiftList
				_ENV, content.data.buyGiftList.msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				content.data.buyGiftList.data, (nil).result = nil, true
				SoraDSendMessage(content.data.buyGiftList)
			elseif content.type == "refreshData" then
				self.clientData.rechargeParam = content.data.rechargeParam
			end
		end
	end
end
function manualGiftCtrl:reqBuyPackageMsg(rechargeID)
	serverproxy = nil
	local (nil).rechargeID, data = rechargeID, nil
	serverproxy:Request(gCmd.CMD_MANUAL_GIFT_MODULE, gCmd.REQ_BUY_MANUAL_GIFT, data)
end
function manualGiftCtrl:reqBuyPackageRsp(content)
	dump(content, "manualGiftCtrl:reqBuyPackageRsp===", 10)
	if content.err == gErrDef.Err_None then
		paymentManager.purchase(content.data.rechargeID, content.rspdata.orderID)
	end
end
function manualGiftCtrl:getPackageIDList()
	local _ENV, packageList
	for k, v in pairs(self.clientData.rechargeParam) do
		table.insert(packageList, v)
	end
	table.sort(packageList, function(l, r)
		return l < r
	end)
	return packageList
end
function manualGiftCtrl:getBuyListInfo()
	local _ENV, buyInfo
	for k, v in pairs(self.clientData.userData.buyGiftList) do
		local single = SoraDStringSplit(k, "_")
		if not buyInfo[single[1]] then
			buyInfo[single[1]], _ENV = "_", "_"
		end
		buyInfo[single[1]] = v
	end
	return buyInfo
end
function manualGiftCtrl:getAlreadyBuyNum(rechargeID)
	local alreadybuy = 0
	local playerBuyInfo = self:getBuyListInfo()
	if playerBuyInfo[tostring(rechargeID)] then
		alreadybuy = playerBuyInfo[tostring(rechargeID)]
	end
	return alreadybuy
end
return manualGiftCtrl
