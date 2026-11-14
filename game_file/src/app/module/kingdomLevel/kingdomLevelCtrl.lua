local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local kingdomLevelBuff = include("kingdomLevelBuff")
local kingdomLevelltCtrl = include("kingdomLevelltCtrl")
local kingdomLevelCtrl = class("kingdomLevelCtrl", gameModule)
local _ENV, REQ = "kingdomLevelCtrl", "kingdomLevelCtrl"
local _ENV, RSP = gameModule, gameModule
function kingdomLevelCtrl:ctor(properties)
	kingdomLevelCtrl.super.ctor(self, properties)
	self:resetData()
end
function kingdomLevelCtrl:initClientData(data)
	self.data = data or self.data
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.KINGDOM_LEVEL, handler(self, RSP.noitfyDataRsp))
end
function kingdomLevelCtrl:getKingdomLevel()
	return self.data.level
end
function kingdomLevelCtrl:isOpen()
	return self.data.isOpen
end
function kingdomLevelCtrl:isUnlock()
	return self.data.isUnlock
end
function kingdomLevelCtrl:getMultiple()
	return self.data.multiple or 2
end
function kingdomLevelCtrl:getServerMulti()
	return self.data.serverMulti or 0
end
function kingdomLevelCtrl:reqKingdomLevelInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_KINGDOM_LEVEL_MODULE, gCmd.REQ_KINGDOM_LEVEL_INFO, data)
end
function kingdomLevelCtrl:reqKingdomLevelExpInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_KINGDOM_LEVEL_MODULE, gCmd.REQ_KINGDOM_LEVEL_EXP_INFO, data)
end
function RSP:noitfyDataRsp(content)
	for i, notifyMsg in ipairs(content.data) do
		local notifyType = notifyMsg.notifyType
		local notifyData = notifyMsg.notifyData
		if "upgrade" == notifyType then
			local level = notifyData.level
			self.data.level = level
			kingdomLevelBuff:dispatchBuffChange(level)
			local gametop = gModuleMgr.getObject("gametop")
			local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
			local isOpened = romeActivityCtrl:isOpenRomeActivity()
			if not isOpened then
				romeActivityCtrl.serverLv = level
			end
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_WORLDKINGDOM_LV_CHANGE"
			;(nil).level = level
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_LORDINFO_UPDATE_BASE"
			SoraDSendMessage(nil)
		elseif "unlock" == notifyType then
			self.data.isUnlock = true
			local level = notifyData.level
			self.data.level = level
			kingdomLevelBuff:dispatchBuffChange(level)
			_ENV = kingdomLevelBuff
			kingdomLevelBuff.msg = "MESSAGE_SERVER_WORLDKINGDOM_LV_UNLOCK"
			kingdomLevelBuff.level = level
			SoraDSendMessage(kingdomLevelBuff)
		elseif "switch" == notifyType then
			local switchOpen = notifyData.switchOpen
			self.data.isOpen = switchOpen
		end
	end
end
local DISPLAY_COEFFICIENT = 10
local displayExp = function(exp)
	if "number" == type(exp) then
		exp = math.floor(exp / DISPLAY_COEFFICIENT)
	end
	return exp
end
function RSP:getKingdomLevelInfoRsp(content)
	if content.err == gErrDef.Err_None then
		self.data = content.data.levelInfo
		if self.data then
			self.data.dailyExp = displayExp(self.data.dailyExp)
			self.data.dailyLimit = displayExp(self.data.dailyLimit)
			self.data.exp = displayExp(self.data.exp)
			self.data.selfDailyExp = displayExp(self.data.selfDailyExp)
			self.data.needExp = displayExp(self.data.needExp)
		end
		_ENV = displayExp(self.data.needExp)
		displayExp(self.data.needExp).msg = "MESSAGE_SERVER_WORLDKINGDOM_LV_DATA_BACK"
		displayExp(self.data.needExp).data = self.data
		SoraDSendMessage((displayExp(self.data.needExp)))
	end
end
function RSP:getExpInfoRsp(content)
	if content.err == gErrDef.Err_None then
		local expInfo = content.data.expInfo
		local dailyExpDetail = expInfo.dailyExpDetail
		local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
		local expDetailList = worldKingdomLvDesRead.getExpListMap()
		local _ENV, temp
		for k, expSourceList in pairs(expDetailList) do
			for i, expSource in ipairs(expSourceList) do
				if dailyExpDetail[tostring(expSource)] then
					if not temp[k] then
						_ENV = temp[k]
						temp[k].expSource = k
						temp[k].exp = 0
					end
					temp[k] = temp[k]
					temp[k].exp = temp[k].exp + dailyExpDetail[tostring(expSource)]
				end
			end
		end
		local _ENV, ret = (for generator), pairs(expDetailList)
		for k, v in pairs(temp) do
			v.exp = displayExp(v.exp)
			if v.exp and v.exp > 0 then
				table.insert(ret, v)
			end
		end
		table.sort(ret, function(l, r)
			return worldKingdomLvDesRead.getExpItemRank(l.expSource) < worldKingdomLvDesRead.getExpItemRank(r.expSource)
		end)
		_ENV = ret
		ret.msg = "MESSAGE_SERVER_WORLDKINGDOM_LOG_BACK"
		ret.data = ret
		SoraDSendMessage(ret)
	end
end
function kingdomLevelCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).kingdomLevel = 0
	self.data, (nil).isUnlock = nil, false
end
function kingdomLevelCtrl:EnterGame()
	kingdomLevelCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_KINGDOM_LEVEL_MODULE, gCmd.REQ_KINGDOM_LEVEL_INFO, handler(self, RSP.getKingdomLevelInfoRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_LEVEL_MODULE, gCmd.REQ_KINGDOM_LEVEL_EXP_INFO, handler(self, RSP.getExpInfoRsp))
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local eventName = string.format(gEventName.event_city_build_level_up, BUILDID.CASTLE)
	cityCtrl:addEventListener(eventName, function()
		local kingdomLevel = self:getKingdomLevel()
		local buffValidCastleLvMin = kingdomLevelltCtrl:getBuffValidCastleLvMin()
		local self, temp = kingdomLevelltCtrl, kingdomLevelltCtrl
		temp[buffValidCastleLvMin] = true
		local castleLevel = cityCtrl:getCastleLevel()
		if temp[castleLevel] then
			kingdomLevelBuff:dispatchBuffChange(kingdomLevel)
		end
	end)
end
function kingdomLevelCtrl:Logout()
	kingdomLevelCtrl.super.Logout(self)
	self:resetData()
end
return kingdomLevelCtrl
