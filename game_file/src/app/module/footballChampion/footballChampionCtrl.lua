local footballChampionRead = include("footballChampionRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local footballChampionCtrl = class("footballChampionCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function footballChampionCtrl:ctor(properties)
	footballChampionCtrl.super.ctor(self, properties)
	self:resetData()
end
function footballChampionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FOOTBALL_CHAMPION_MODULE, gCmd.REQ_FOOTBALL_CHAMPION_INIT, handler(self, self.reqFootballChampionInitRsp))
	msgCtrl.register(gCmd.CMD_FOOTBALL_CHAMPION_MODULE, gCmd.REQ_FOOTBALL_CHAMPION_GUESS, handler(self, self.reqFootballChampionGuessRsp))
	self:registerNotify()
end
function footballChampionCtrl:Logout()
	footballChampionCtrl.super.Logout(self)
	self:resetData()
end
function footballChampionCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function footballChampionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FOOTBALL_CHAMPION, handler(self, self.notifyHandler))
end
function footballChampionCtrl:notifyHandler(event)
	dump(event.data, "footballChampionCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData = v.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_FOOTBALL_CHAMPION_REFRESH"
		SoraDSendMessage(nil)
	end
end
function footballChampionCtrl:reqFootballChampionInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FOOTBALL_CHAMPION_MODULE, gCmd.REQ_FOOTBALL_CHAMPION_INIT, nil)
end
function footballChampionCtrl:reqFootballChampionGuess(data)
	serverproxy:Request(gCmd.CMD_FOOTBALL_CHAMPION_MODULE, gCmd.REQ_FOOTBALL_CHAMPION_GUESS, data)
end
function footballChampionCtrl:reqFootballChampionInitRsp(content)
	dump(content, "footballChampionCtrl:reqFootballChampionInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_FOOTBALL_CHAMPION_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function footballChampionCtrl:reqFootballChampionGuessRsp(content)
	dump(content, "footballChampionCtrl:reqFootballChampionGuessRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata.initData
	elseif content.err == gErrDef.Err_FOOTBALLCHAMPION_NOT_IN_GUESS_TIME then
		SoraDShowMsgTip(i18n("champion_prediction_20"))
	end
	_ENV = i18n("champion_prediction_20")
	i18n("champion_prediction_20").msg = "MESSAGE_FOOTBALL_CHAMPION_REFRESH"
	SoraDSendMessage(i18n("champion_prediction_20"))
end
function footballChampionCtrl:getDayQuestions()
	local _ENV, ret
	for i, v in ipairs(footballChampionRead.getDayQuestions()) do
		local nowTime = serviceFunctions.systemTime()
		print("nowTime", nowTime, v.start_time, v.end_time)
		if nowTime >= v.start_time and nowTime <= v.end_time and self.initData.resultRecord and not self.initData.resultRecord[v.id] then
			table.insert(ret, v)
		end
	end
	return ret
end
function footballChampionCtrl:getResutData(type)
	local _ENV, ret
	if self.initData.resultRecord then
		for i, v in pairs(self.initData.resultRecord) do
			local myGuess = self.initData.guessRecord[i]
			print("myGuess", myGuess)
			if myGuess then
				if type == 2 and v == myGuess then
					_ENV = myGuess
					myGuess.index = i
					myGuess.result = v
					myGuess.myGuess = myGuess
					table.insert(ret, myGuess)
				elseif type == 3 and v ~= myGuess then
					_ENV = myGuess
					myGuess.index = i
					myGuess.result = v
					myGuess.myGuess = myGuess
					table.insert(ret, myGuess)
				elseif type == 1 then
					_ENV = myGuess
					myGuess.index = i
					myGuess.result = v
					myGuess.myGuess = myGuess
					table.insert(ret, myGuess)
				end
			end
		end
	end
	table.sort(ret, function(l, r)
		local configL = footballChampionRead.getConfigByIndex(tonumber(l.index))
		local configR = footballChampionRead.getConfigByIndex(tonumber(r.index))
		if configL.type ~= configR.type then
			return configL.type > configR.type
		elseif configL.game_time ~= configR.game_time then
			return configL.game_time > configR.game_time
		else
			return l.index < r.index
		end
	end)
	return ret
end
function footballChampionCtrl:getMyGuess(index)
	return self.initData.guessRecord and self.initData.guessRecord[tostring(index)]
end
function footballChampionCtrl:getGameQuestions()
	local _ENV, ret
	for i, v in ipairs(footballChampionRead.getGameQuestions()) do
		local nowTime = serviceFunctions.systemTime()
		print("getGameQuestions", nowTime, v.start_time, v.end_time)
		if nowTime >= v.start_time then
			table.insert(ret, v)
		end
	end
	return ret
end
return footballChampionCtrl
