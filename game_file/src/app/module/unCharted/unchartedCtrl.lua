local GameModule = include("GameModule")
local unchartedCtrl = class("unchartedCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function unchartedCtrl:ctor(properties)
	unchartedCtrl.super.ctor(self, properties)
end
function unchartedCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_INFO, handler(self, self.reqUnchartedInitRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_THROW_DICE, handler(self, self.reqThrowDiceRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_RESET_TASK, handler(self, self.reqResetTaskRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_GIVEUP_REWARD, handler(self, self.reqGiveUpRewardRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_GET_REWARD, handler(self, self.reqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_MONEYGET_REWARD, handler(self, self.reqGoldGetRewardRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_SHOP_BUY, handler(self, self.reqShopBuyRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_TRADER_BUY, handler(self, self.reqTraderBuyRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_BUY_THROW_NUM, handler(self, self.reqBuyFreeThrowTimesRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_SHOP_RECORDS, handler(self, self.reqStoreBuyRecordRsp))
	msgCtrl.register(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_EXCHANGE_COIN, handler(self, self.reqExchangeCoinsRsp))
	self:resetData()
end
function unchartedCtrl:initClientData(data)
	if not data then
		return
	end
	self.unchartedData = data
	self:registerNotify()
end
function unchartedCtrl:initHelpClientData(data)
	if not data then
		return
	end
	self.unchartedHelpData = data
end
function unchartedCtrl:addUnchartedData(data)
	if data and next(data) then
		if not self.unchartedData then
			_ENV = self.unchartedData
		end
		self.unchartedData = self.unchartedData
		for activityID, value in pairs(data) do
			self.unchartedData[tostring(activityID)] = value
		end
	end
end
function unchartedCtrl:resetData()
	self.handle_notify = nil
	self.unchartedData = nil
	self.storeBuyRecordData = nil
	self.finishReward = nil
	self.isFirstTimePop = false
end
function unchartedCtrl:Logout()
	self:resetData()
	unchartedCtrl.super.Logout(self)
end
function unchartedCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SECRET_EXPLORE, handler(self, self.notifyHandler))
end
function unchartedCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content then
			if content.taskInfo and content.taskInfo.type == gUnchartedGridType.FINISH and content.taskInfo.data.items then
				local ok, items = SoraDchangeToMap(content.taskInfo.data.items)
				if ok then
					self.finishReward = nil
					local _ENV, tTbl
					for k, v in pairs(items) do
						tTbl[v.key] = v.value
					end
					self.finishReward = tTbl
				end
			end
			self:addUnchartedData(content)
			if content.mapGrid then
				self.unchartedData.mapGrid = content.mapGrid
			end
			if content.freeTask then
				if content.freeTask.type == gUnchartedFreeType.WISH then
					self.unchartedData.wishInfo = content.freeTask.data
				elseif content.freeTask.type == gUnchartedFreeType.COSTPW then
					self.unchartedData.costPWCoin = content.freeTask.data
				elseif content.freeTask.type == gUnchartedFreeType.COSTPHYSICAL then
					self.unchartedData.costPhysical = content.freeTask.data
				elseif content.freeTask.type == gUnchartedFreeType.CHEST then
					self.unchartedData.openChest = content.freeTask.data
				end
				if content.finishType then
					self.unchartedData.throwFree = self.unchartedData.throwFree + 1
					_ENV = self.unchartedData.throwFree + 1
					;(self.unchartedData.throwFree + 1).msg = "MESSAGE_SERVER_UNCHARTED_TASK_FINISH_BACK"
					;(self.unchartedData.throwFree + 1).finishType = content.finishType
					;(self.unchartedData.throwFree + 1).need = content.freeTask.data.need
					SoraDSendMessage(self.unchartedData.throwFree + 1)
				end
			end
			if content.taskInfo.bFinish == true then
				self.unchartedData.taskInfo.bFinish = content.taskInfo.bFinish
				if content.taskInfo.type == gUnchartedGridType.TASK then
					self.unchartedData.taskInfo = content.taskInfo
					if not self.isFirstTimePop then
						_ENV = content.taskInfo
						content.taskInfo.msg = "MESSAGE_SERVER_UNCHARTED_TASK_FINISH_BACK"
						content.taskInfo.taskInfo = content.taskInfo.data
						SoraDSendMessage(content.taskInfo)
						self.isFirstTimePop = true
					end
				end
			end
			if self.unchartedData.diceRate and 1 < self.unchartedData.diceRate then
				self.unchartedData.diceRate = content.diceRate
			end
			if self.unchartedData.coinRate and 1 < self.unchartedData.coinRate and content.taskInfo.data then
				self.unchartedData.coin = self.unchartedData.coin + content.taskInfo.data.coin * self.unchartedData.coinRate
			end
			local isOnlyOne = false
			if content.taskInfo.type == gUnchartedGridType.SURPRICE or content.taskInfo.type == gUnchartedGridType.BOX then
				isOnlyOne = true
			end
			_ENV = gUnchartedGridType.BOX
			gUnchartedGridType.BOX.msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
			gUnchartedGridType.BOX.isOnlyOne = isOnlyOne
			SoraDSendMessage(gUnchartedGridType.BOX)
		end
	end
end
function unchartedCtrl:sendInitUnchartedMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_INFO, data)
end
function unchartedCtrl:sendThrowDiceMsg(throwType)
	serverproxy = nil
	local (nil).type, data = throwType, nil
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_THROW_DICE, data)
end
function unchartedCtrl:sendResetTaskMsg(freeTaskType)
	serverproxy = nil
	local (nil).type, data = freeTaskType, nil
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_RESET_TASK, data)
end
function unchartedCtrl:sendGiveUpRewardsMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_GIVEUP_REWARD, data)
end
function unchartedCtrl:sendGetRewardsMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_GET_REWARD, data)
end
function unchartedCtrl:sendGoldGetRewardsMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_MONEYGET_REWARD, data)
end
function unchartedCtrl:sendShopBuyMsg(goodId, count)
	serverproxy = nil
	;(nil).goodId = goodId
	local (nil).count, data = count, nil
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_SHOP_BUY, data)
end
function unchartedCtrl:sendTraderBuyMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_TRADER_BUY, data)
end
function unchartedCtrl:sendBuyFreeThrowTimesMsg(count)
	serverproxy = nil
	local (nil).count, data = count, nil
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_BUY_THROW_NUM, data)
end
function unchartedCtrl:sendStoreBuyRecordMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_SHOP_RECORDS, data)
end
function unchartedCtrl:sendExchangeCoinsMsg(nType, nNum)
	serverproxy = nil
	;(nil).nType = nType
	local (nil).nNum, data = nNum, nil
	serverproxy:Request(gCmd.CMD_SECRET_EXPLORE_MODULE, gCmd.REQ_SECRET_EXPLORE_EXCHANGE_COIN, data)
end
function unchartedCtrl:reqUnchartedInitRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self:addUnchartedData(ret.data)
		_ENV = self
		self.msg = "MESSAGE_SERVER_UNCHARTED_INIT_INFO"
		SoraDSendMessage(self)
	end
end
function unchartedCtrl:reqThrowDiceRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.gridId = ret.data.gridId
		self.unchartedData.taskInfo = ret.data.task
		self.unchartedData.throwFree = ret.data.throwFree
		if ret.data.task.data and ret.data.task.data.coin and ret.data.task.type == gUnchartedGridType.NORMAL or ret.data.task.type == gUnchartedGridType.BOX then
			self.unchartedData.coin = self.unchartedData.coin + ret.data.task.data.coin * self.unchartedData.coinRate
		end
		if ret.data.task.data and ret.data.task.data.coin and ret.data.task.type == gUnchartedGridType.SURPRICE then
			self.unchartedData.coin = self.unchartedData.coin + ret.data.task.data.coin * self.unchartedData.coinRate
			if ret.data.task.data.type == gUnchartedSurpriseType.ADD_THROW then
				self.unchartedData.throwFree = self.unchartedData.throwFree + ret.data.task.data.effect
			end
		end
		if self.unchartedData.coinRate and self.unchartedData.coinRate > 1 then
			self.unchartedData.coin = self.unchartedData.coin - ret.data.task.data.coin * self.unchartedData.coinRate
		end
		_ENV = self.unchartedData.coin - ret.data.task.data.coin * self.unchartedData.coinRate
		;(self.unchartedData.coin - ret.data.task.data.coin * self.unchartedData.coinRate).msg = "MESSAGE_SERVER_UNCHARTED_THROW_DICE_REFRESH"
		SoraDSendMessage(self.unchartedData.coin - ret.data.task.data.coin * self.unchartedData.coinRate)
	end
end
function unchartedCtrl:reqResetTaskRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		if ret.data.type == gUnchartedFreeType.WISH then
			self.unchartedData.wishInfo = ret.data.task
		elseif ret.data.type == gUnchartedFreeType.COSTPW then
			self.unchartedData.costPWCoin = ret.data.task
		elseif ret.data.type == gUnchartedFreeType.COSTPHYSICAL then
			self.unchartedData.costPhysical = ret.data.task
		elseif ret.data.type == gUnchartedFreeType.CHEST then
			self.unchartedData.openChest = ret.data.task
		end
		self.unchartedData.totalReset = ret.data.totalReset
		_ENV = ret.data.totalReset
		ret.data.totalReset.msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
		SoraDSendMessage(ret.data.totalReset)
	end
end
function unchartedCtrl:reqGiveUpRewardRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.taskInfo.bFinish = true
		self.unchartedData.taskInfo.data, _ENV = gErrDef.Err_None, gErrDef.Err_None
		self.isFirstTimePop = false
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_UNCHARTED_GIVEUP_TASK_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function unchartedCtrl:reqGetRewardRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.coin = ret.data.coin
		self.unchartedData.throwFree = ret.data.throwFree
		self.isFirstTimePop = false
		if ret.data.items then
			local reward = ret.data.items
			if table.nums(reward) > 0 then
				SoraDPopGainItem(reward[1], reward[2])
			end
		end
		_ENV = SoraDPopGainItem
		SoraDPopGainItem.msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
		SoraDPopGainItem.isOnlyOne = true
		SoraDSendMessage(SoraDPopGainItem)
	end
end
function unchartedCtrl:reqGoldGetRewardRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.taskInfo.bFinish = true
		self.unchartedData.throwFree = ret.data.throwFree
		self.unchartedData.coin = ret.data.coin
		self.isFirstTimePop = false
		if ret.data.items then
			local reward = ret.data.items
			if table.nums(reward) > 0 then
				SoraDPopGainItem(reward[1], reward[2])
			end
		end
		_ENV = SoraDPopGainItem
		SoraDPopGainItem.msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
		SoraDPopGainItem.isOnlyOne = true
		SoraDSendMessage(SoraDPopGainItem)
	end
end
function unchartedCtrl:reqShopBuyRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		local isFirst = false
		self.unchartedData.coin = ret.data.coin
		for k, v in pairs(self.storeBuyRecordData) do
			if ret.data.goodId == tonumber(k) then
				self.storeBuyRecordData[k] = v + ret.data.count
				isFirst = true
			end
		end
		if not isFirst then
			self.storeBuyRecordData[ret.data.goodId] = ret.data.count
		end
		local reward = ret.data.item
		SoraDPopGainItem(reward[1], reward[2])
		_ENV = reward[1]
		reward[1].msg = "MESSAGE_SERVER_UNCHARTED_SHOP_BUY_BACK"
		SoraDSendMessage(reward[1])
		_ENV = reward[1]
		reward[1].msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
		SoraDSendMessage(reward[1])
	end
end
function unchartedCtrl:reqTraderBuyRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.taskInfo.bFinish = true
		self.unchartedData.throwFree = ret.data.throwFree
		self.unchartedData.coin = ret.data.coin
		local reward = ret.data.items
		SoraDPopGainItem(reward[1], reward[2])
		_ENV = reward[1]
		reward[1].msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
		reward[1].isOnlyOne = true
		SoraDSendMessage(reward[1])
	end
end
function unchartedCtrl:reqBuyFreeThrowTimesRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.throwFree = ret.data.throwFree
		self.unchartedData.buyThrow = ret.data.buyThrow
		_ENV = ret.data.buyThrow
		ret.data.buyThrow.msg = "MESSAGE_SERVER_UNCHARTED_COMMON_REFRESH_BACK"
		SoraDSendMessage(ret.data.buyThrow)
	end
end
function unchartedCtrl:reqStoreBuyRecordRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.storeBuyRecordData = ret.data
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_UNCHARTED_STORE_INIT_INFO"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function unchartedCtrl:reqExchangeCoinsRsp(ret)
	if ret and ret.data and ret.err == gErrDef.Err_None then
		self.unchartedData.coin = self.unchartedData.coin + ret.data.coin
		self.unchartedData.exchangeNum = ret.data.exchangeNum
		_ENV = ret.data.exchangeNum
		ret.data.exchangeNum.msg = "MESSAGE_SERVER_UNCHARTED_HELP_BUY_BACK"
		SoraDSendMessage(ret.data.exchangeNum)
	end
end
function unchartedCtrl:getUnchartedInfo()
	local _ENV, ret
	if self.unchartedData then
		for k, v in pairs(self.unchartedData) do
			ret = self.unchartedData
		end
	end
	return ret
end
function unchartedCtrl:getUnchartedHelpInfo()
	local _ENV, ret
	if self.unchartedHelpData then
		for k, v in pairs(self.unchartedHelpData.param) do
			table.insert(ret, v)
		end
		table.sort(ret, function(l, r)
			return l.id < r.id
		end)
	end
	return ret
end
function unchartedCtrl:getStoreBuyRecordInfo()
	local _ENV, ret
	if self.storeBuyRecordData then
		for k, v in pairs(self.storeBuyRecordData) do
			if not ret[tonumber(k)] then
				ret[tonumber(k)], _ENV = k, k
			end
			ret[tonumber(k)] = v
		end
	end
	return ret
end
function unchartedCtrl:getFinishRewardTable()
	local _UPVALUE0_, ret
	if self.finishReward then
		ret = self.finishReward
	end
	return ret
end
return unchartedCtrl
