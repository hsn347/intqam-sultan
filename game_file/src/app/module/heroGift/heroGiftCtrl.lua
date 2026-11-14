local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local heroGiftCtrl = class("heroGiftCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function heroGiftCtrl:ctor(properties)
	heroGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function heroGiftCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_GIFT_MODULE, gCmd.REQ_HERO_GIFT_BUY, handler(self, self.reqHeroGiftBuyRsp))
	self:registerNotify()
end
function heroGiftCtrl:Logout()
	heroGiftCtrl.super.Logout(self)
	self:resetData()
end
function heroGiftCtrl:initClientData(data)
	if not data then
		return
	end
	self.giftInfo = data
	self:updateRechargeList()
	self:checkHaveNewGift()
end
function heroGiftCtrl:resetData()
	self.rechargeList, _UPVALUE0_, self.giftInfo, _UPVALUE0_ = nil, nil, nil, nil
end
function heroGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_GIFT, handler(self, self.notifyHandler))
end
function heroGiftCtrl:notifyHandler(event)
	dump(event.data, "heroGiftCtrl:notifyHandler", 10)
	for k, content in ipairs(event.data) do
		if content then
			local info = content.data
			local giftType = content.type
			if "buyGift" == giftType then
				info = content.info
				if info.isDel then
					self.giftInfo[tostring(info.rid)] = nil
				else
					print("heroGiftCtrl:notifyHandler", info.buyNum, self.giftInfo[tostring(info.rid)].buyNum)
					self.giftInfo[tostring(info.rid)].buyNum = info.buyNum
				end
				if info.success == true then
					paymentManager.OnemtRechargeSuccess(info.price)
					paymentManager.loopForFinishTransaction()
					local _ENV, reward = paymentManager.loopForFinishTransaction, paymentManager.loopForFinishTransaction
					for i, v in ipairs(info.reward) do
						table.insert(reward, v.id)
						table.insert(reward, v.count)
					end
					local mailid = info.mailid
					local rid = info.rid
					_ENV = tostring(info.rid)
					_ENV, tostring(info.rid).msg = info.rid, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					info.rid.result = true
					info.rid.rid = rid
					info.rid.itemList = reward
					tostring(info.rid).data, info.rid.mailID = info.rid, mailid
					SoraDSendMessage((tostring(info.rid)))
				end
			elseif "newGift" == giftType then
				_ENV = SoraDSendMessage
				SoraDSendMessage.byUID = true
				SoraDConfigSet("Game:heroGiftCtrl:isNewGift~bool", true, SoraDSendMessage)
				self.giftInfo[tostring(info.rid)] = info.info
			elseif "delGift" == giftType then
				self.giftInfo[tostring(info.rid)] = nil
			end
			dump(self.rechargeList, "self.rechargeList")
			self:updateRechargeList()
			dump(self.rechargeList, "self.rechargeList")
			_ENV = self.rechargeList
			self.rechargeList.msg = "MESSAGE_HERO_GIFT_RECHARGE_REFRESH"
			SoraDSendMessage(self.rechargeList)
		end
	end
end
function heroGiftCtrl:reqHeroGiftBuy(data)
	serverproxy:Request(gCmd.CMD_HERO_GIFT_MODULE, gCmd.REQ_HERO_GIFT_BUY, data)
end
function heroGiftCtrl:reqHeroGiftBuyRsp(content)
	dump(content, "heroGiftCtrl:reqHeroGiftBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local orderID = content.rspdata.orderID
		paymentManager.purchase(content.data.rid, orderID)
	end
end
function heroGiftCtrl:getHeroGiftInfo(giftID)
	dump(self.giftInfo, "giftInfo")
	if giftID then
		return self.giftInfo[tostring(giftID)]
	else
		return self.giftInfo
	end
end
function heroGiftCtrl:updateRechargeList()
	self.rechargeList, _ENV = nil, nil
	local rechargeltCtrl = include("rechargeltCtrl")
	for heroID, v in pairs(rechargeltCtrl.getHeroRecruitInfo()) do
		local giftInfo = self.giftInfo[tostring(v.giftId)]
		if giftInfo and giftInfo.queue and giftInfo.queue.startTime then
			local endTime = giftInfo.queue.startTime + giftInfo.queue.totalTime
			_ENV = rechargeltCtrl.getHeroRecruitInfo()
			rechargeltCtrl.getHeroRecruitInfo().heroID = tonumber(heroID)
			rechargeltCtrl.getHeroRecruitInfo().giftId = v.giftId
			rechargeltCtrl.getHeroRecruitInfo().buyNum = giftInfo.buyNum
			rechargeltCtrl.getHeroRecruitInfo().endTime = endTime
			table.insert(self.rechargeList, rechargeltCtrl.getHeroRecruitInfo())
		end
	end
	table.sort(self.rechargeList, function(l, r)
		if l.endTime ~= r.endTime then
			return l.endTime < r.endTime
		else
			return l.heroID < r.heroID
		end
	end)
end
function heroGiftCtrl:getMinimumTimeGift()
	return self.rechargeList[1]
end
function heroGiftCtrl:getRechargeList()
	return self.rechargeList
end
function heroGiftCtrl:checkHaveNewGift()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil) then
		local _ENV, popDataList = SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil), SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil)
	end
	local giftID
	for _giftID, _ in pairs(self.giftInfo) do
		if not popDataList[tostring(_giftID)] then
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:heroGiftCtrl:isNewGift~bool", true, nil)
		end
	end
end
function heroGiftCtrl:getPopGiftIDAndRecord()
	self:updateRechargeList()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil) then
		local _ENV, popDataList = SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil), SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil)
	end
	local giftID
	for _, info in ipairs(self.rechargeList) do
		local leftTime = info.endTime - serviceFunctions.systemTime()
		if not popDataList[tostring(info.giftId)] then
			popDataList[tostring(info.giftId)] = true
			if not giftID then
				giftID = info.giftId
			end
		elseif not giftID and leftTime <= 86400 then
			giftID = info.giftId
		end
	end
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:heroGiftCtrl:popData~table", popDataList, nil)
	return giftID
end
function heroGiftCtrl:recordGift(giftId)
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil) then
		local _ENV, popDataList = SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil), SoraDConfigGet("Game:heroGiftCtrl:popData~table", nil)
	end
	popDataList[tostring(giftId)] = true
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:heroGiftCtrl:popData~table", popDataList, nil)
end
return heroGiftCtrl
