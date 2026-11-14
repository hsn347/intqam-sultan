local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local msgCtrl = include("msgCtrl")
local msgNotice = include("msgNotice")
local itemLogic = include("itemLogic")
local languageConfig = include("languageConfig")
local noticeCtrl = class("noticeCtrl", gameModule)
local _ENV, REQ = "noticeCtrl", "noticeCtrl"
local _ENV, RSP = gameModule, gameModule
function noticeCtrl:getNotDisturbStatus()
	return self.noticeData.notDisturbStatus
end
function noticeCtrl:openNotDisturb()
	print("noticeCtrl.openNotDisturb")
	self.noticeData.notDisturbStatus = true
	REQ.reqSetNotDisturbStatus(true)
end
function noticeCtrl:closeNotDisturb()
	print("noticeCtrl.closeNotDisturb")
	self.noticeData.notDisturbStatus = false
	REQ.reqSetNotDisturbStatus(false)
end
function noticeCtrl:setNotDisturbTime(beginTimeHour, beginTimeMin, endTimeHour, endTimeMin)
	print("noticeCtrl.setNotDisturbTime:", beginTimeHour, beginTimeMin, endTimeHour, endTimeMin)
	if "string" ~= type(beginTimeHour) or beginTimeHour < "00" or "23" < beginTimeHour or "string" ~= type(beginTimeMin) or beginTimeMin < "00" or "59" < beginTimeMin or "string" ~= type(endTimeHour) or endTimeHour < "00" or "23" < endTimeHour or "string" ~= type(endTimeMin) or endTimeMin < "00" or "59" < endTimeMin then
		print("REQ.reqSetNotDisturbTime error:", beginTimeHour, beginTimeMin, endTimeHour, endTimeMin)
		return
	end
	self.noticeData.beginTimeHour = beginTimeHour
	self.noticeData.beginTimeMin = beginTimeMin
	self.noticeData.endTimeHour = endTimeHour
	self.noticeData.endTimeMin = endTimeMin
	REQ.reqSetNotDisturbTime(beginTimeHour, beginTimeMin, endTimeHour, endTimeMin)
end
function noticeCtrl:getNotDisturbTime()
	print("noticeCtrl.getNotDisturbTime")
	return self.noticeData.beginTimeHour, self.noticeData.beginTimeMin, self.noticeData.endTimeHour, self.noticeData.endTimeMin
end
function noticeCtrl:closeNoticeStatus(noticeType)
	print("noticeCtrl.closeNoticeStatus: noticeType = ", noticeType)
	self.noticeData[noticeType] = false
	REQ.reqSetNoticeStatus(noticeType, false)
end
function noticeCtrl:openNoticeStatus(noticeType)
	print("noticeCtrl.openNoticeStatus: noticeType = ", noticeType)
	self.noticeData[noticeType] = true
	REQ.reqSetNoticeStatus(noticeType, true)
end
function noticeCtrl:setLanguage(clientLang)
	print("noticeCtrl:setLanguage:", clientLang)
	local language = clientLang
	if not languageConfig:isClientLanguage(language) then
		print("not found language config!")
		return
	end
	self.noticeData.language = language
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	settingCtrl:setClientLanguage(language)
end
function noticeCtrl:isInNotDisturbStatus()
	if self:getNotDisturbStatus() then
		local curTime = serviceFunctions.systemTime()
		local h = os.date("%H", curTime)
		local m = os.date("%M", curTime)
		local time = h .. ":" .. m
		local beginTime = self.property.beginTime
		local endTime = self.property.endTime
		if beginTime > endTime then
			if time >= beginTime or time <= endTime then
				return true
			else
				return false
			end
		elseif beginTime < endTime then
			if time >= beginTime and time <= endTime then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end
function REQ.reqInitData()
	serverproxy:Request(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_NOTICE_INIT_DATA)
end
function REQ.reqSetNotDisturbStatus(val)
	if false == val or true == val then
		serverproxy = nil
		local (nil).status, data = val, nil
		serverproxy:Request(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_NOT_DISTURB_STATUS, data)
	else
		print("REQ.reqSetNotDisturbStatus error: val = ", val)
	end
end
function REQ.reqSetNotDisturbTime(beginTimeHour, beginTimeMin, endTimeHour, endTimeMin)
	serverproxy = nil
	;(nil).beginTimeHour = beginTimeHour
	;(nil).beginTimeMin = beginTimeMin
	;(nil).endTimeHour = endTimeHour
	local (nil).endTimeMin, data = endTimeMin, nil
	serverproxy:Request(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_NOT_DISTURB_TIME, data)
end
function REQ.reqSetNoticeStatus(noticeType, val)
	if false == val or true == val then
		serverproxy = nil
		;(nil).noticeType = noticeType
		local (nil).status, data = val, nil
		serverproxy:Request(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_NOTICE_STATUS, data)
	else
		print("REQ.reqSetNoticeStatus error: val = ", val)
	end
end
function REQ.reqSetLanguage(language)
	serverproxy = nil
	local (nil).language, data = language, nil
	serverproxy:Request(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_LANGUAGE, data)
end
function RSP:initDataRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		self.noticeData = content.data
		SoraDConfigSet("System:GameMessageView:NoDisturb~bool", self.noticeData.notDisturbStatus)
		SoraDConfigSet("System:GameMessageView:Alliance~bool", self.noticeData[gNoticeType.ALLIANCE_CHAT])
		SoraDConfigSet("System:GameMessageView:Event~bool", self.noticeData[gNoticeType.ACTIVITY_START])
		SoraDConfigSet("System:GameMessageView:Mail~bool", self.noticeData[gNoticeType.NEW_PERSONAL_MAIL])
		SoraDConfigSet("System:GameMessageView:allianceAllMail~bool", self.noticeData[gNoticeType.ALLIANCE_GROUP_MAIL])
		SoraDConfigSet("System:GameMessageView:LevelTrain~bool", self.noticeData[gNoticeType.LEVELUP_AND_TRAIN])
		SoraDConfigSet("System:GameMessageView:FightTroop~bool", self.noticeData[gNoticeType.BATTLE_AND_TROOP])
		SoraDConfigSet("System:GameMessageView:Resource~bool", self.noticeData[gNoticeType.HARVEST])
		SoraDConfigSet("System:GameMessageView:Price~bool", self.noticeData[gNoticeType.REWARD])
		SoraDConfigSet("System:GameMessageView:RedBag~bool", self.noticeData[gNoticeType.GOLD_GIFT])
		SoraDConfigSet("System:GameMessageView:WarGuard~bool", self.noticeData[gNoticeType.PROTECTION_END])
		SoraDConfigSet("System:GameMessageView:AllianceAttacked~bool", self.noticeData[gNoticeType.ALLIANCE_ATTACKED])
		SoraDConfigSet("System:GameMessageView:TradeBoard~bool", self.noticeData[gNoticeType.SALES_ROOM])
		SoraDConfigSet("System:GameMessageView:LegendEquip~bool", self.noticeData[gNoticeType.LEGEND_EQUIP])
		SoraDConfigSet("System:GameMessageView:ArenaRank~bool", self.noticeData[gNoticeType.ARENA_RANK])
		SoraDConfigSet("System:GameMessageView:radianceWarBuildAttacked~bool", self.noticeData[gNoticeType.RADIANCE_BUILD_BE_ATTACKED])
		SoraDConfigSet("System:GameMessageView:voiceChatRoomInvite~bool", self.noticeData[gNoticeType.VOICE_CHAT_INVITATION])
		local beginTimeHour = tonumber(self.noticeData.beginTimeHour)
		local beginTimeMin = tonumber(self.noticeData.beginTimeMin)
		local endTimeHour = tonumber(self.noticeData.endTimeHour)
		local endTimeMin = tonumber(self.noticeData.endTimeMin)
		local sTime = SoraDNowDate()
		local eTime = SoraDNowDate()
		sTime.hour = beginTimeHour
		sTime.min = beginTimeMin
		eTime.hour = endTimeHour
		eTime.min = endTimeMin
		SoraDConfigSet("System:GameMessageView:NoDisturbStart~integer", SoraDDateToTime(sTime))
		SoraDConfigSet("System:GameMessageView:NoDisturbEnd~integer", SoraDDateToTime(eTime))
	end
end
function RSP:setNotDisturbStatusRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
	end
end
function RSP:setNotDisturbTimeRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
	end
end
function RSP:setNoticeStatusRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
	end
end
function RSP:setLanguageRsp(content)
	if content.err ~= gErrDef.Err_None then
	else
		local data = content.data
	end
end
function noticeCtrl:ctor(properties)
	noticeCtrl.super.ctor(self, properties)
	self:initData()
end
function noticeCtrl:initData()
	_ENV = nil
	;(nil).notDisturbStatus = false
	;(nil).beginTimeHour = "22"
	;(nil).beginTimeMin = "00"
	;(nil).endTimeHour = "08"
	;(nil).endTimeMin = "00"
	;(nil).language = gLanguage.ARAB
	;(nil)[gNoticeType.REWARD] = true
	;(nil)[gNoticeType.ACTIVITY_START] = true
	;(nil)[gNoticeType.NEW_PERSONAL_MAIL] = true
	;(nil)[gNoticeType.ALLIANCE_GROUP_MAIL] = true
	;(nil)[gNoticeType.ALLIANCE_CHAT] = false
	;(nil)[gNoticeType.LEVELUP_AND_TRAIN] = true
	;(nil)[gNoticeType.BATTLE_AND_TROOP] = true
	;(nil)[gNoticeType.HARVEST] = true
	;(nil)[gNoticeType.GOLD_GIFT] = true
	;(nil)[gNoticeType.PROTECTION_END] = true
	;(nil)[gNoticeType.ALLIANCE_ATTACKED] = true
	;(nil)[gNoticeType.SALES_ROOM] = true
	;(nil)[gNoticeType.LEGEND_EQUIP] = true
	;(nil)[gNoticeType.ARENA_RANK] = true
	;(nil)[gNoticeType.RADIANCE_BUILD_BE_ATTACKED] = true
	self.noticeData, (nil)[gNoticeType.VOICE_CHAT_INVITATION] = nil, true
end
function noticeCtrl:EnterGame()
	noticeCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_NOTICE_INIT_DATA, handler(self, RSP.initDataRsp))
	msgCtrl.register(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_NOT_DISTURB_STATUS, handler(self, RSP.setNotDisturbStatusRsp))
	msgCtrl.register(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_NOT_DISTURB_TIME, handler(self, RSP.setNotDisturbTimeRsp))
	msgCtrl.register(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_NOTICE_STATUS, handler(self, RSP.setNoticeStatusRsp))
	msgCtrl.register(gCmd.CMD_NOTICE_MODULE, gCmd.REQ_SET_LANGUAGE, handler(self, RSP.setLanguageRsp))
	REQ.reqInitData()
end
function noticeCtrl:resetData()
	self:initData()
end
function noticeCtrl:Logout()
	noticeCtrl.super.Logout(self)
	self:resetData()
end
return noticeCtrl
