local GameModule = include("GameModule")
local christmasBattleCtrl = class("christmasBattleCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function christmasBattleCtrl:ctor(properties)
	christmasBattleCtrl.super.ctor(self, properties)
end
function christmasBattleCtrl:EnterGame()
	christmasBattleCtrl = nil
	;(nil).REQ_CHRISTMAS_BATTLE_EXCHANGE_SOCKS = "1"
	;(nil).REQ_CHRISTMAS_BATTLE_SUBMIT_SOCKS = "2"
	;(nil).REQ_CHRISTMAS_BATTLE_GET_CHRIS_GIFT = "3"
	local (nil).REQ_CHRISTMAS_BATTLE_GET_FAVOR_GIFT, cmdList = "4", nil
	christmasBattleCtrl.super.autoRegister(self, gCmd.CMD_CHRISTMAS_BATTLE_MODULE, cmdList)
	self:registerNotify()
end
function christmasBattleCtrl:initClientData(data)
	dump(data, "init christmasBattle Data", 5)
	self.christmasData = data
end
function christmasBattleCtrl:getChristData()
	return self.christmasData
end
function christmasBattleCtrl:sendExchangeSocks(nType, nNum)
	print("sendExchangeSocksParty", nType, nNum)
	_ENV = nil
	;(nil).nType = nType
	;(nil).nNum = nNum
	serverproxy:Request(gCmd.CMD_CHRISTMAS_BATTLE_MODULE, gCmd.REQ_CHRISTMAS_BATTLE_EXCHANGE_SOCKS, nil)
end
function christmasBattleCtrl:sendSubmitSocks(nType, nNum)
	print("sendExchangeSocksParty", nType, nNum)
	_ENV = nil
	;(nil).nType = nType
	;(nil).nNum = nNum
	serverproxy:Request(gCmd.CMD_CHRISTMAS_BATTLE_MODULE, gCmd.REQ_CHRISTMAS_BATTLE_SUBMIT_SOCKS, nil)
end
function christmasBattleCtrl:sendGetChrisGift()
	print("sendGetChrisGift")
	serverproxy:Request(gCmd.CMD_CHRISTMAS_BATTLE_MODULE, gCmd.REQ_CHRISTMAS_BATTLE_GET_CHRIS_GIFT)
end
function christmasBattleCtrl:sendGetFavorGift(nIndex)
	print("sendExchangeSocksParty", nType, nNum)
	_ENV = nil
	;(nil).nIndex = nIndex
	serverproxy:Request(gCmd.CMD_CHRISTMAS_BATTLE_MODULE, gCmd.REQ_CHRISTMAS_BATTLE_GET_FAVOR_GIFT, nil)
end
function christmasBattleCtrl:sendReqChristmasBattleExchangeSocks(content)
	dump(content, "ExchangeSocks back", 5)
	if gErrDef.Err_None == content.err then
		self.christmasData.exchangeNum = content.data.exchangeNum
		self:receiveReward(content.data.rewardinfo)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_EXCHANGE_BACK"
		SoraDSendMessage(self)
	end
end
function christmasBattleCtrl:sendReqChristmasBattleSubmitSocks(content)
	dump(content, "SubmitSocks back", 5)
	SoraDCloseLoading()
	if gErrDef.Err_None == content.err then
		self.christmasData.favorite = content.data.favorite
		self:receiveReward(content.data.rewardinfo)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_UPDATE"
		SoraDSendMessage(self)
	end
end
function christmasBattleCtrl:sendReqChristmasBattleGetChrisGift(content)
	dump(content, "getChristGift back", 5)
	if gErrDef.Err_None == content.err then
		self.christmasData.chrisGift = content.data.chrisGift
		self:receiveReward(content.data.rewardinfo)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_UPDATE"
		SoraDSendMessage(self)
	end
end
function christmasBattleCtrl:sendReqChristmasBattleGetFavorGift(content)
	dump(content, "GetFavorGift back", 5)
	if gErrDef.Err_None == content.err then
		self.christmasData.favoriteReward = content.data.favoriteReward
		self:receiveReward(content.data.rewardinfo)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_UPDATE"
		SoraDSendMessage(self)
	end
end
function christmasBattleCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CHRISTMAS_BATTLE, handler(self, self.notifyBattleData))
end
function christmasBattleCtrl:notifyBattleData(event)
	dump(event.data, "christmasBattleCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			self.christmasData.exchangeNum = content.exchangeNum
			self.christmasData.chrisGift = content.chrisGift
			_ENV = content.chrisGift
			content.chrisGift.msg = "MESSAGE_SERVER_EVENTCENTER_CHRISTMAS_EXCHANGE_BACK"
			SoraDSendMessage(content.chrisGift)
		end
	end
end
function christmasBattleCtrl:receiveReward(reward)
	if not reward then
		return
	end
	local _ENV, itemList
	for _, v in ipairs(reward) do
		itemList[v.id] = v.count
	end
	SoraDMailGainItems(itemList)
end
return christmasBattleCtrl
