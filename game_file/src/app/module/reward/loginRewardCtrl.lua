local GameModule = include("GameModule")
local loginRewardCtrl = class("loginRewardCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local dailyLoginRead = include("dailyLoginRead")
function loginRewardCtrl:ctor(properties)
	loginRewardCtrl.super.ctor(self, properties)
	self:resetData()
end
function loginRewardCtrl:resetData()
	self.loginRewardData, _UPVALUE0_ = nil, nil
	self.handle_reward_notify = nil
end
function loginRewardCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_LOGIN_REWARD_DATA, handler(self, self.getInitResp))
	msgCtrl.register(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_RECEIVE_REWARD, handler(self, self.getReceiveResp))
	msgCtrl.register(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_FINISH_GUIDE, handler(self, self.finishGuideResp))
	msgCtrl.register(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_NEBULA_DAILY_REWARD, handler(self, self.nebulaDailyRewardResp))
end
function loginRewardCtrl:Logout()
	loginRewardCtrl.super.Logout(self)
	self:resetData()
end
function loginRewardCtrl:initClientData(data)
	dump(data, "loginRewardCtrl:initClientData")
	if not data then
		return
	end
	self.loginRewardData = data
	dailyLoginRead.init(self:getRewardType())
	self:registerNotify()
end
function loginRewardCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_reward_notify = notifyCtrl:register(gNotifyID.DAILYLOGIN_REWARD, handler(self, self.notifyHandler))
end
function loginRewardCtrl:notifyHandler(event)
	if event and event.data then
		dump(event.data, "loginRewardCtrl:notifyHandler", 10)
		for _, content in ipairs(event.data) do
			if content.loginRewardData then
				self.loginRewardData = content.loginRewardData
				dailyLoginRead.init(self:getRewardType())
			end
		end
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_DAILYLOGIN_NOTIFY_DAILYREWARD"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_UPDATE_LOGIN_REWARD"
		SoraDSendMessage(ipairs(event.data))
	end
end
function loginRewardCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_LOGIN_REWARD_DATA)
end
function loginRewardCtrl:receiveReward(location)
	serverproxy = nil
	local (nil).location, data = location, nil
	serverproxy:Request(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_RECEIVE_REWARD, data)
end
function loginRewardCtrl:finishiGuide()
	serverproxy:Request(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_FINISH_GUIDE)
end
function loginRewardCtrl:nebulaDailyReward(nType)
	serverproxy = nil
	;(nil).nType = nType
	serverproxy:Request(gCmd.CMD_LOGIN_REWARD_MODULE, gCmd.REQ_NEBULA_DAILY_REWARD, nil)
end
function loginRewardCtrl:getInitResp(content)
	dump(content, "loginRewardCtrl:getInitResp", 10)
	if content and content.rspdata and content.rspdata.loginRewardData then
		self.loginRewardData = content.rspdata.loginRewardData
		dailyLoginRead.init(self:getRewardType())
		_ENV = self:getRewardType()
		self:getRewardType().msg = "MESSAGE_UPDATE_LOGIN_REWARD"
		SoraDSendMessage(self:getRewardType())
	end
end
function loginRewardCtrl:getReceiveResp(content)
	dump(content, "loginRewardCtrl:getReceiveResp", 10)
	if content.err == gErrDef.Err_None then
		self.loginRewardData = content.rspdata.loginRewardData
		_UPVALUE2_ = "loginRewardCtrl:getReceiveResp"
		;("loginRewardCtrl:getReceiveResp")[1] = "id"
		;("loginRewardCtrl:getReceiveResp")[2] = "count"
		local reward = serviceFunctions.tableFormat(content.rspdata.reward, "loginRewardCtrl:getReceiveResp")
		print("客户端刷新====")
		local index = content.data.location
		_ENV = "id"
		;("id").msg = "MESSAGE_DAILYLOGIN_RECEIVEREWARD_SUCCESS"
		;("id").index = index
		;("id").reward = reward
		;("id").mul = self.loginRewardData.cardList[index].cardMultiple
		SoraDSendMessage("id")
		_ENV = "id"
		;("id").msg = "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP"
		SoraDSendMessage("id")
		local cityBuildConstDef = include("cityBuildConstDef")
		_ENV = self.loginRewardData.cardList[index].cardMultiple
		self.loginRewardData.cardList[index].cardMultiple.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_EFFECT"
		self.loginRewardData.cardList[index].cardMultiple.buildIndex = cityBuildConstDef.OtherBuildDef.HuoChuang
		SoraDSendMessage(self.loginRewardData.cardList[index].cardMultiple)
	elseif content.err == gErrDef.Err_RECEIVED_REWARD then
	elseif content.err == gErrDef.Err_BACKPACK_IS_FULL then
		SoraDShowMsgTip(i18n("notice_0119"))
	end
end
function loginRewardCtrl:finishGuideResp(content)
	dump(content, "loginRewardCtrl:finishGuideResp", 10)
	if content.err == gErrDef.Err_None then
		self.loginRewardData = content.rspdata.loginRewardData
	end
end
function loginRewardCtrl:nebulaDailyRewardResp(content)
	dump(content, "loginRewardCtrl:nebulaDailyRewardResp", 10)
	if content.err == gErrDef.Err_None then
		self.loginRewardData = content.rspdata.loginRewardData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MAINCITYVIEW_UPDATE_NEBULA_PALACE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function loginRewardCtrl:getLoginRewardData(parameters)
	if self.loginRewardData then
		return self.loginRewardData
	end
end
function loginRewardCtrl:getCanReceive()
	return self.loginRewardData and self.loginRewardData.canReceive or false
end
function loginRewardCtrl:getCurDay()
	return self.loginRewardData and self.loginRewardData.curDay or 1
end
function loginRewardCtrl:getRewardType()
	return self.loginRewardData and self.loginRewardData.rewardType or 1
end
function loginRewardCtrl:isFinishGuide()
	return self.loginRewardData and self.loginRewardData.finishGuide or false
end
function loginRewardCtrl:getRecord(day)
	if not self.loginRewardData or not self.loginRewardData.cardHistory then
		local _ENV, cardHistory = self.loginRewardData.cardHistory, self.loginRewardData.cardHistory
	end
	if day then
		return cardHistory[tostring(day)]
	end
	return cardHistory
end
function loginRewardCtrl:getTodayIndex()
	return self.loginRewardData and self.loginRewardData.todayLocation
end
function loginRewardCtrl:getCardList()
	return self.loginRewardData and self.loginRewardData.cardList
end
function loginRewardCtrl:getTodayMul()
	local index = self:getTodayIndex()
	print("getTodayMul", index)
	if self.loginRewardData then
		for i, v in ipairs(self.loginRewardData.cardList) do
			print("getTodayMul", index, v.location)
			if v.location == index then
				dump(v, "getTodayMul")
				return v.cardMultiple
			end
		end
	end
end
function loginRewardCtrl:getNewLocation()
	if self.loginRewardData then
		for i, v in ipairs(self.loginRewardData.cardList) do
			if not v.get then
				return v.location
			end
		end
	end
end
function loginRewardCtrl:getIsCanReceiveNebulaReward1()
	return self.loginRewardData and self.loginRewardData.isCanReceiveNebulaReward1 or false
end
function loginRewardCtrl:getIsCanReceiveNebulaReward2()
	return self.loginRewardData and self.loginRewardData.isCanReceiveNebulaReward2 or false
end
return loginRewardCtrl
