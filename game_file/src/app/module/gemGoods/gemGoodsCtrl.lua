local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local gemGoodsCtrl = class("gemGoodsCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function gemGoodsCtrl:ctor(properties)
	gemGoodsCtrl.super.ctor(self, properties)
	self:resetData()
end
function gemGoodsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_INIT, handler(self, self.reqGemGoodsInitRsp))
	msgCtrl.register(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_RECEIVE, handler(self, self.reqGemGoodsReceiveRsp))
	msgCtrl.register(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_CHOOSE, handler(self, self.reqGemGoodsChooseRsp))
	msgCtrl.register(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_BUY, handler(self, self.reqGemGoodsBuyRsp))
	msgCtrl.register(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_REFRESH, handler(self, self.reqGemGoodsRefreshRsp))
	self:registerNotify()
end
function gemGoodsCtrl:Logout()
	gemGoodsCtrl.super.Logout(self)
	self:resetData()
end
function gemGoodsCtrl:resetData()
	self.itemID = 829701
	self.gemGoodsData, _ENV, self.activityID = gActivityTimeActivityID.GEM_GOODS_ACTIVITY, gActivityTimeActivityID.GEM_GOODS_ACTIVITY, gActivityTimeActivityID.GEM_GOODS_ACTIVITY
	self.minPrice = 99999999
end
function gemGoodsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GEM_GOODS_ACTIVITY, handler(self, self.notifyHandler))
end
function gemGoodsCtrl:notifyHandler(event)
	dump(event.data, "gemGoodsCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self:setGemGoodsData(v.gemGoodsData)
	end
end
function gemGoodsCtrl:initClientData(data)
	self:setGemGoodsData(data)
end
function gemGoodsCtrl:reqGemGoodsInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_INIT, nil)
end
function gemGoodsCtrl:reqGemGoodsReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_RECEIVE, nil)
end
function gemGoodsCtrl:reqGemGoodsChoose(position, index)
	serverproxy = nil
	;(nil).position = position
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_CHOOSE, nil)
end
function gemGoodsCtrl:reqGemGoodsBuy()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_BUY, nil)
end
function gemGoodsCtrl:reqGemGoodsRefresh()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GEM_GOODS_MODULE, gCmd.REQ_GEM_GOODS_REFRESH, nil)
end
function gemGoodsCtrl:reqGemGoodsInitRsp(content)
	dump(content, "gemGoodsCtrl:reqGemGoodsInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setGemGoodsData(content.rspdata.gemGoodsData)
		_ENV = self
		self.msg = "MESSAGE_EVENT_GEMGODDS_INIT"
		SoraDSendMessage(self)
	end
end
function gemGoodsCtrl:reqGemGoodsReceiveRsp(content)
	dump(content, "gemGoodsCtrl:reqGemGoodsReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setGemGoodsData(content.rspdata.gemGoodsData)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function gemGoodsCtrl:reqGemGoodsChooseRsp(content)
	dump(content, "gemGoodsCtrl:reqGemGoodsChooseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setGemGoodsData(content.rspdata.gemGoodsData)
		_ENV = self
		self.msg = "MESSAGE_EVENT_GEMGODDS_CHOOSE"
		SoraDSendMessage(self)
	end
end
function gemGoodsCtrl:reqGemGoodsBuyRsp(content)
	dump(content, "gemGoodsCtrl:reqGemGoodsBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setGemGoodsData(content.rspdata.gemGoodsData)
		local reward = content.rspdata.reward
		_ENV = content.rspdata.gemGoodsData
		content.rspdata.gemGoodsData.msg = "MESSAGE_EVENT_GEMGODDS_BUY"
		content.rspdata.gemGoodsData.name = "buy"
		content.rspdata.gemGoodsData.reward = reward
		SoraDSendMessage(content.rspdata.gemGoodsData)
		_ENV = content.rspdata.gemGoodsData
		content.rspdata.gemGoodsData.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(content.rspdata.gemGoodsData)
	end
end
function gemGoodsCtrl:reqGemGoodsRefreshRsp(content)
	dump(content, "gemGoodsCtrl:reqGemGoodsRefreshRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:setGemGoodsData(content.rspdata.gemGoodsData)
		_ENV = self
		self.msg = "MESSAGE_EVENT_GEMGODDS_REFRESH"
		self.name = "refresh"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(self)
	end
end
local goods_detail = require_data("linlang_goods", true).data
function gemGoodsCtrl:getGoodsDetail(index)
	if index then
		return goods_detail[index]
	else
		return goods_detail
	end
end
function gemGoodsCtrl:getRewardInfo(...)
	if not self.rewardInfo then
		self.rewardInfo, _ENV = self.rewardInfo, self.rewardInfo
		for i, v in ipairs(goods_detail) do
			if v.showinui and v.showinui == 1 then
				_ENV = v.showinui
				v.showinui.id = v.content[1]
				local v.showinui.count, data = v.content[2], v.showinui
				table.insert(self.rewardInfo, data)
			end
		end
	end
	return self.rewardInfo
end
function gemGoodsCtrl:findMinPrice(...)
	local price
	for k, v in pairs(self.gemGoodsData.curShowList) do
		local detail = self:getGoodsDetail(v)
		price = price or detail and detail.tokenprice
		if detail and price > detail.tokenprice then
			price = detail.tokenprice
		end
	end
	return price
end
local linlang_discount = require_data("linlang_discount", true).data
function gemGoodsCtrl:getDiscount(num)
	if linlang_discount[num] then
		return 1000 - linlang_discount[num].discount
	end
	return 0
end
function gemGoodsCtrl:getGemGoodsData(...)
	return self.gemGoodsData
end
function gemGoodsCtrl:setGemGoodsData(gemGoodsData)
	self.gemGoodsData = gemGoodsData
	if self.gemGoodsData and self.gemGoodsData.curShowList then
		self.minPrice = self:findMinPrice()
	else
		self.minPrice = 99999999
	end
end
function gemGoodsCtrl:getReceiveStatusAndNum(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false, 0
	end
	local constantRead = include("constantRead")
	local max_count = constantRead.getConstValue("GEM_GOODS_MAX_BUY_COUNT", 10)
	local left_count = max_count - self.gemGoodsData.buyCount
	if left_count <= 0 then
		return false, 0
	end
	if self.gemGoodsData.refreshCost and 0 >= self.gemGoodsData.refreshCost then
		return true, -1
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	if self.itemCount >= self.minPrice then
		return true, -1
	end
	return false, 0
end
return gemGoodsCtrl
