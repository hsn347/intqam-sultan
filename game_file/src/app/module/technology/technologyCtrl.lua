local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local technologyCtrl = class("technologyCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local technologyAuxiliary = include("technologyAuxiliary")
local technologyDef = include("technologyDef")
local gametop = gModuleMgr.getObject("gametop")
function technologyCtrl:ctor(properties)
	technologyCtrl.super.ctor(self, properties)
	self:resetData()
end
function technologyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_INIT_TECHNOLOGY_DATA, handler(self, self.getInitTechnologyRsp))
	msgCtrl.register(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_RESEARCH_TECHNOLOGY, handler(self, self.getResearchRsp))
	msgCtrl.register(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_INIT_QUEUE_DATA, handler(self, self.getInitQueueDataRsp))
	msgCtrl.register(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_CANCLE_TECHNOLOGY, handler(self, self.getCancleTechnologyRsp))
	msgCtrl.register(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_TECHNOLOGY_ADD_WAIT_QUEUE, handler(self, self.addWaitQueueRsp))
	msgCtrl.register(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_TECHNOLOGY_DEL_WAIT_QUEUE, handler(self, self.delWaitQueueRsp))
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.technology_upgrade_queue), handler(self, self.technologyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.war_tech_research), handler(self, self.technologyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.craft_study), handler(self, self.technologyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.nebula_palace_technology), handler(self, self.technologyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.garden_technology), handler(self, self.technologyQueueCallback))
	self:registerNotify()
end
function technologyCtrl:resetData()
	self.originData = nil
	self.technologyData = nil
	self.technologyAuxiliary = nil
	self.technologyAuxiliary = technologyAuxiliary.new()
	self.technologyAuxiliary:resetData()
end
function technologyCtrl:Logout()
	print("technologyCtrl:Logout()==========")
	technologyCtrl.super.Logout(self)
	self:resetData()
end
function technologyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TECHNOLOGY, handler(self, self.notifyHandler))
end
function technologyCtrl:notifyHandler(event)
	dump(event.data, "technologyCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		print(content.type, "content.type")
		if content.type == "researchQueue" then
			SoraDDelayCallOnce("technologyCtrl_researchQueue", function()
				self = nil
				;(nil).err = gErrDef.Err_None
				;(nil).data = content.data
				self:getResearchRsp(nil)
			end, 0.016666666666666666)
		elseif content.type == "updateTotalTechnology" then
			if content.data.modifyData then
				local technologyIdStr = self.technologyAuxiliary:mosaicTechnologyId(tonumber(content.data.modifyData.id), content.data.modifyData.level)
				local technologyDetails = self.technologyAuxiliary:getTechnologyDetailById(technologyIdStr)
				if technologyDetails and (technologyDetails.buffType == gTechnologyType.DAILY_RECEIVE_METEORITE_LV_ADD or technologyDetails.buffType == gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD) then
					local loginRewardCtrl = include("loginRewardCtrl")
					loginRewardCtrl:sendInitMsg()
				end
			end
			if content.data.technology then
				local addV1 = self:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_METEORITE_LV_ADD)
				local addV2 = self:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD)
				self.originData = content.data.technology
				for k, v in pairs(self.technologyData) do
					for k2, v2 in pairs(v) do
						local newLevel = content.data.technology[tostring(k2)]
						v2.currentLevel = newLevel and newLevel or 0
					end
				end
				self.technologyData = self.technologyAuxiliary:handlerTechnology(content.data.technology)
				_ENV = self.technologyAuxiliary
				self.technologyAuxiliary.msg = "MESSAGE_UPDATE_TECHNOLOGY"
				SoraDSendMessage(self.technologyAuxiliary)
				_ENV = self.technologyAuxiliary
				self.technologyAuxiliary.msg = "MESSAGE_MAINCITY_UPDATE_MAINUITOP_HEADPOS"
				SoraDSendMessage(self.technologyAuxiliary)
				local newAddV1 = self:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_METEORITE_LV_ADD)
				local newAddV2 = self:getTechnologyPower(gTechnologyType.DAILY_RECEIVE_CITY_BUILD_HELP_ADD)
				if addV1 ~= newAddV1 or addV2 ~= newAddV2 then
					local loginRewardCtrl = include("loginRewardCtrl")
					loginRewardCtrl:sendInitMsg()
				end
			end
		end
	end
end
function technologyCtrl:technologyQueueCallback(event)
	local data = event.data
	local _ENV, rs
	local value
	for _, var in pairs(data) do
		if type(var) == "table" then
			value = var
			local technologyId = var[1]
			local currentLevel = var[2]
			if self.originData then
				if self.originData[tostring(technologyId)] then
					self.originData[tostring(technologyId)][2] = currentLevel
				else
					_UPVALUE2_ = technologyId
					self.originData[tostring(technologyId)], technologyId[1] = technologyId, technologyId
					self.originData[tostring(technologyId)], technologyId[2] = technologyId, currentLevel
				end
			end
			self:techUpgrateNotify(technologyId, currentLevel)
			if self.technologyAuxiliary:isProcessTech(tonumber(technologyId)) then
				_ENV = tonumber(technologyId)
				tonumber(technologyId).techID = technologyId
				tonumber(technologyId).count = currentLevel
				include("msgNotice").notice("Soldiers_armor_text_57", tonumber(technologyId))
			elseif self.technologyAuxiliary:isManorTech(tonumber(technologyId)) then
				local manorTechRead = include("manorTechRead")
				local cfg = manorTechRead.getTechShowCfg(tonumber(technologyId))
				_ENV = tonumber(technologyId)
				tonumber(technologyId).techName = i18n(cfg.techName)
				tonumber(technologyId).lv = currentLevel
				SoraDShowMsgTip(i18n("garden_text_19", tonumber(technologyId)))
			else
				_ENV = SoraDShowMsgTip
				SoraDShowMsgTip.techID = technologyId
				SoraDShowMsgTip.count = currentLevel
				include("msgNotice").notice("notice_0133", SoraDShowMsgTip)
			end
			local bid = tonumber(BUILDID.COLLEGE)
			local queueType = self.technologyAuxiliary:getQueueTypeByTechnologyId(technologyId)
			if queueType == gQueueTypeDef.war_tech_research then
				bid = tonumber(BUILDID.MIRACLE)
			elseif queueType == gQueueTypeDef.craft_study then
				bid = tonumber(BUILDID.STAR_BRAVE_STATUE)
			elseif queueType == gQueueTypeDef.nebula_palace_technology then
				bid = tonumber(BUILDID.NEBULA_PALACE)
			end
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCell = cityCtrl:getBuildCell(bid, 0)
			if buildCell ~= nil then
				local buildIndex = tonumber(buildCell.info.index)
				_ENV = 0
				;(0).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
				;(0).buildIndex = buildIndex
				;(0).queueType = queueType
				SoraDSendMessage(0)
				_ENV = 0
				;(0).msg = "MESSAGE_UI_PANDECT_COLLEGE"
				;(0).queueType = queueType
				;(0).bid = bid
				SoraDSendMessage(0)
				_ENV = 0
				;(0).msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
				;(0).bid = bid
				SoraDSendMessage(0)
			end
		end
	end
	self.technologyData = self.technologyAuxiliary:handlerTechnology(data)
	rs = self.technologyAuxiliary:handlerUpdateRs(self.technologyData, value, TECHNOLOGY_RESEARCH.instantResearch)
	_ENV = self.technologyAuxiliary
	self.technologyAuxiliary.msg = "MESSAGE_UPDATE_TECHNOLOGY"
	self.technologyAuxiliary.technology = rs
	SoraDSendMessage(self.technologyAuxiliary)
	_ENV = self.technologyAuxiliary
	self.technologyAuxiliary.msg = "MESSAGE_MAINCITY_UPDATE_MAINUITOP_HEADPOS"
	SoraDSendMessage(self.technologyAuxiliary)
	for _, var in pairs(data) do
		if type(var) == "table" then
			local technologyId = var[1]
			local currentLevel = var[2]
			if technologyId and currentLevel then
				local technologyIdStr = self.technologyAuxiliary:mosaicTechnologyId(technologyId, currentLevel)
				if technologyIdStr then
					local technologyDetails = self.technologyAuxiliary:getTechnologyDetailById(technologyIdStr)
					if technologyDetails and next(technologyDetails) ~= nil and technologyDetails.buffType == gTechnologyType.EXPEDITION_TROOPS then
						_ENV = gTechnologyType.EXPEDITION_TROOPS
						gTechnologyType.EXPEDITION_TROOPS.msg = "MESSAGE_SERVER_WORLD_MAP_QUEUE_RSP"
						SoraDSendMessage(gTechnologyType.EXPEDITION_TROOPS)
					end
				end
			end
		end
	end
end
function technologyCtrl:getInitQueueDataRsp(respone)
	local err = respone.err
	local data = respone.data
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	if next(data) ~= nil then
		if data.remainTime and data.extraData then
			local remainTime = data.remainTime
			local starttime = serviceFunctions.systemTime()
			local totaltime = tonumber(remainTime)
			local lefttime = tonumber(remainTime)
			local extraData = data.extraData
			queueCtrl:addQueue(gQueueTypeDef.technology_upgrade_queue, starttime, totaltime, lefttime, extraData)
		end
		if data.other and next(data.other) then
			for queueType, v in pairs(data.other) do
				local starttime = serviceFunctions.systemTime()
				local totaltime = tonumber(v.remainTime)
				local lefttime = tonumber(v.remainTime)
				local extraData = v.extraData
				queueCtrl:addQueue(queueType, starttime, totaltime, lefttime, extraData)
			end
		end
	end
end
function technologyCtrl:getCancleTechnologyRsp(respone)
	local err = respone.err
	local data = respone.data
	local queueType = respone.queueType
	_ENV = nil
	;(nil).msg = "MESSAGE_CANCLE_TECHNOLOGY"
	;(nil).err = err
	;(nil).data = data
	;(nil).queueType = queueType
	SoraDSendMessage(nil)
	local msgNotice = include("msgNotice")
	local bid = tonumber(BUILDID.COLLEGE)
	if queueType == gQueueTypeDef.war_tech_research then
		bid = tonumber(BUILDID.MIRACLE)
	elseif queueType == gQueueTypeDef.craft_study then
		bid = tonumber(BUILDID.STAR_BRAVE_STATUE)
	elseif queueType == gQueueTypeDef.nebula_palace_technology then
		bid = tonumber(BUILDID.NEBULA_PALACE)
	end
	if bid == BUILDID.MIRACLE then
		msgNotice.notice("notice_0178", nil, gNoticeIconTypeDef.ICON_BUILD, bid)
	elseif bid == BUILDID.STAR_BRAVE_STATUE then
		msgNotice.notice("notice_0178", nil, gNoticeIconTypeDef.ICON_NORMAL, "#btn_armor_technology.png")
	elseif bid == BUILDID.NEBULA_PALACE then
		msgNotice.notice("notice_0178", nil, gNoticeIconTypeDef.ICON_BUILD, bid)
	else
		msgNotice.notice("notice_0055", nil, gNoticeIconTypeDef.ICON_BUILD, bid)
	end
end
function technologyCtrl:initQueueData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_INIT_QUEUE_DATA, nil, ...)
end
function technologyCtrl:initTechnologyData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_INIT_TECHNOLOGY_DATA, nil, ...)
end
function technologyCtrl:getInitTechnologyRsp(respone)
	self.originData = respone.data
	self.technologyData = self.technologyAuxiliary:handlerTechnology(respone.data)
end
function technologyCtrl:getResearchRsp(respone)
	local err = respone.err
	local data = respone.data
	dump(respone, "technologyCtrl:getResearchRsp")
	local type = data.type
	if err == gErrDef.Err_None then
		self.originData = data.data
		if type == TECHNOLOGY_RESEARCH.instantResearch then
			self.technologyData = self.technologyAuxiliary:handlerTechnology(data.data)
			local id = tonumber(data.modifyData[1])
			local level = tonumber(data.modifyData[2])
			self:techUpgrateNotify(id, level)
			if self.technologyAuxiliary:isProcessTech(id) then
				_ENV = id
				id.techID = id
				id.count = level
				include("msgNotice").notice("Soldiers_armor_text_57", id)
			elseif self.technologyAuxiliary:isManorTech(id) then
				local manorTechRead = include("manorTechRead")
				local cfg = manorTechRead.getTechShowCfg(id)
				_ENV = nil
				;(nil).techName = i18n(cfg.techName)
				;(nil).lv = level
				SoraDShowMsgTip(i18n("garden_text_19", nil))
			else
				_ENV = SoraDShowMsgTip
				SoraDShowMsgTip.techID = id
				SoraDShowMsgTip.count = level
				include("msgNotice").notice("notice_0133", SoraDShowMsgTip)
			end
		end
		local rs = self.technologyAuxiliary:handlerUpdateRs(self.technologyData, data.modifyData, type)
		if type == TECHNOLOGY_RESEARCH.research then
			local queueType = self.technologyAuxiliary:getQueueTypeByTechnologyId(data.modifyData[1])
			local tempData = self.technologyAuxiliary:getTechnologyDetailById(self.technologyAuxiliary:mosaicTechnologyId(data.modifyData[1], data.modifyData[2]))
			local basetime = tonumber(tempData.technologyTime)
			local finaltime = self.technologyAuxiliary:getResearchTime(basetime, queueType, self.originData)
			local queueCtrl = gametop.playertop_:getModule("queueCtrl")
			local starttime = serviceFunctions.systemTime()
			local totaltime = finaltime
			local lefttime = finaltime
			local _ENV, extraData = self.technologyAuxiliary:mosaicTechnologyId(data.modifyData[1], data.modifyData[2])
			extraData[tostring(data.modifyData[1])] = clone(data.modifyData)
			extraData.ishelp = 0
			print("queueType", queueType)
			queueCtrl:addQueue(queueType, starttime, totaltime, lefttime, extraData)
			if lefttime == 0 then
				print("train Immediately")
				return
			else
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local bid = BUILDID.COLLEGE
				if queueType == gQueueTypeDef.garden_technology then
					bid = MANOR_BUILD_ID.SMART_PALACE
					_ENV = starttime
					starttime.msg = "MESSAGE_MANOR_BUILD_TECH_QUEUE"
					SoraDSendMessage(starttime)
				else
					if queueType == gQueueTypeDef.war_tech_research then
						bid = BUILDID.MIRACLE
					elseif queueType == gQueueTypeDef.craft_study then
						bid = BUILDID.STAR_BRAVE_STATUE
					elseif queueType == gQueueTypeDef.nebula_palace_technology then
						bid = BUILDID.NEBULA_PALACE
					end
					local buildCell = cityCtrl:getBuildCell(tonumber(bid), 0)
					if nil ~= buildCell then
						_ENV = tonumber(bid)
						tonumber(bid).msg = "MESSAGE_BUILD_WORKING"
						tonumber(bid).buildID = tonumber(buildCell.info.index)
						tonumber(bid).buildCfgID = tonumber(data.bid)
						SoraDSendMessage((tonumber(bid)))
					end
				end
			end
		end
		SoraDPlaySound("innercontrol", 3)
		_ENV = "innercontrol"
		;("innercontrol").msg = "MESSAGE_UPDATE_TECHNOLOGY"
		;("innercontrol").technology = rs
		SoraDSendMessage("innercontrol", respone)
		_ENV = "innercontrol"
		;("innercontrol").msg = "MESSAGE_MAINCITY_UPDATE_MAINUITOP_HEADPOS"
		SoraDSendMessage("innercontrol")
	end
end
function technologyCtrl:getTechnologyData()
	if self.technologyData then
		return self.technologyData
	end
end
function technologyCtrl:isActiveTech(technologyId)
	if self.originData[tostring(technologyId)] then
		return true
	else
		return false
	end
end
function technologyCtrl:getTechnologyDataByType(type)
	if self.technologyData then
		return self.technologyData[type]
	end
end
function technologyCtrl:getTechDataByType(buffType)
	return self.technologyAuxiliary:getTechDataByType(self.originData, buffType)
end
function technologyCtrl:getTechnoDataByID(tid, type)
	_UPVALUE11_, tid = tostring(tid), tostring(tid)
	tostring(tid)[1] = TECHNOLOGY_ATTR.military
	tostring(tid)[2] = TECHNOLOGY_ATTR.cityDevelop
	tostring(tid)[3] = TECHNOLOGY_ATTR.anchor
	tostring(tid)[4] = TECHNOLOGY_ATTR.resource
	tostring(tid)[5] = TECHNOLOGY_ATTR.special
	tostring(tid)[6] = TECHNOLOGY_ATTR.wartechnology
	tostring(tid)[7] = TECHNOLOGY_ATTR.warbattle
	tostring(tid)[8] = TECHNOLOGY_ATTR.warmilitary
	tostring(tid)[9] = TECHNOLOGY_ATTR.warcommand
	tostring(tid)[10] = TECHNOLOGY_ATTR.warlight
	local tostring(tid)[11], tableKey = TECHNOLOGY_ATTR.advancedmilitary, tostring(tid)
	if not IsArClient then
		_UPVALUE9_ = IsArClient
		tableKey, IsArClient[1] = IsArClient, TECHNOLOGY_ATTR.military
		tableKey, IsArClient[2] = IsArClient, TECHNOLOGY_ATTR.cityDevelop
		tableKey, IsArClient[3] = IsArClient, TECHNOLOGY_ATTR.anchor
		tableKey, IsArClient[4] = IsArClient, TECHNOLOGY_ATTR.resource
		tableKey, IsArClient[5] = IsArClient, TECHNOLOGY_ATTR.special
		tableKey, IsArClient[6] = IsArClient, TECHNOLOGY_ATTR.wartechnology
		tableKey, IsArClient[7] = IsArClient, TECHNOLOGY_ATTR.warbattle
		tableKey, IsArClient[8] = IsArClient, TECHNOLOGY_ATTR.warcommand
		tableKey, IsArClient[9] = IsArClient, TECHNOLOGY_ATTR.advancedmilitary
	end
	if self.technologyData then
		if type and self.technologyData[type] then
			return self.technologyData[type][tid]
		end
		for i, v in ipairs(tableKey) do
			local data = self.technologyData[v][tid]
			if data then
				return data
			end
		end
	end
end
function technologyCtrl:getTechnologyDetails(technologyId, level)
	local rs = self.technologyAuxiliary:getTechnologyDetails(technologyId, level, self.technologyData, self.originData)
	return rs
end
function technologyCtrl:research(technologyId, type, ...)
	print("=========technologyCtrl:research")
	_ENV = nil
	;(nil).type = TECHNOLOGY_RESEARCH.research
	;(nil).technologyId = technologyId
	;(nil).rtype = type
	serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_RESEARCH_TECHNOLOGY, nil, ...)
end
function technologyCtrl:instantResearch(technologyId, ...)
	print("=========technologyCtrl:instantResearch")
	_ENV = nil
	;(nil).type = TECHNOLOGY_RESEARCH.instantResearch
	;(nil).technologyId = technologyId
	serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_RESEARCH_TECHNOLOGY, nil, ...)
end
_ENV, technologyCtrl.studyingTechnology = function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end, function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end
_UPVALUE2_, _ENV = nil, nil
_UPVALUE1_, (nil).attack, (nil)[1] = nil, nil, gTechnologyType.SOLDIER_BASE_ATTACK
_UPVALUE1_, (nil).attack, (nil)[2] = nil, nil, gTechnologyType.INFANTRY_BASE_ATTACK
_UPVALUE1_, (nil).defend, (nil)[1] = nil, nil, gTechnologyType.INFANTRY_BASE_DEFENSE
;(function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end)[gSoldierType.SOLDIER_TYPE_BUBING], (nil).blood, (nil)[1] = nil, nil, gTechnologyType.INFANTRY_BASE_HP
_UPVALUE2_, _ENV = nil, nil
_UPVALUE1_, (nil).attack, (nil)[1] = nil, nil, gTechnologyType.SOLDIER_BASE_ATTACK
_UPVALUE1_, (nil).attack, (nil)[2] = nil, nil, gTechnologyType.CAVALRY_BASE_ATTACK
_UPVALUE1_, (nil).defend, (nil)[1] = nil, nil, gTechnologyType.CAVALRY_BASE_DEFENSE
;(function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end)[gSoldierType.SOLDIER_TYPE_QIBING], (nil).blood, (nil)[1] = nil, nil, gTechnologyType.CAVALRY_BASE_HP
_UPVALUE2_, _ENV = nil, nil
_UPVALUE1_, (nil).attack, (nil)[1] = nil, nil, gTechnologyType.SOLDIER_BASE_ATTACK
_UPVALUE1_, (nil).attack, (nil)[2] = nil, nil, gTechnologyType.ARCHER_BASE_ATTACK
_UPVALUE1_, (nil).defend, (nil)[1] = nil, nil, gTechnologyType.ARCHER_BASE_DEFENSE
;(function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end)[gSoldierType.SOLDIER_TYPE_GONGBING], (nil).blood, (nil)[1] = nil, nil, gTechnologyType.ARCHER_BASE_HP
_UPVALUE1_, _ENV = nil, nil
;(function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end)[gSoldierType.SOLDIER_TYPE_CHEBING], (nil).blood, _ENV, (nil).defend, _ENV, (nil).attack, (nil)[1] = nil, nil, nil, nil, nil, nil, gTechnologyType.SOLDIER_BASE_ATTACK
_UPVALUE1_, _ENV = nil, nil
;(function(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end)[gSoldierType.SOLDIER_TYPE_ELITE], (nil).blood, _ENV, (nil).defend, _ENV, (nil).attack, (nil)[1] = nil, nil, nil, nil, nil, nil, gTechnologyType.SOLDIER_BASE_ATTACK
local function armyRefTechnologyBuff(self, queueType)
	return self.technologyAuxiliary:studyingTechnology(queueType, self.technologyData)
end
function technologyCtrl:getArmyBaseAdd(soldierType, proType)
	local retAdd = 0
	local buffList = armyRefTechnologyBuff[soldierType][proType]
	for _, tType in pairs(buffList) do
		retAdd = retAdd + self:getTechnologyPower(tType)
	end
	return retAdd
end
function technologyCtrl:getTechnologyPower(tType, bg, isEffective)
	return self.technologyAuxiliary:getTechnologyPower(self.originData, tType, bg, isEffective)
end
function technologyCtrl:cancleTechnology(queueType, ...)
	local ret = self.technologyAuxiliary:cancleTechnology(queueType)
	if ret then
		serverproxy = nil
		;(nil).queueType = queueType
		serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_CANCLE_TECHNOLOGY, nil, ...)
	end
end
function technologyCtrl:getFreeSpeedUpTime(queueType)
	local rettime = 0
	if tonumber(queueType) == gQueueTypeDef.nebula_palace_technology or tonumber(queueType) == gQueueTypeDef.garden_technology then
		return rettime
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local vipadd = buffCtrl:getBuffEffect(gBuffEffect.INSTANT_RESEARCH_SPEED_BOOST, gBuffSource.VIP)
	if vipadd then
		rettime = vipadd
	end
	local petadd = buffCtrl:getBuffEffect(gBuffEffect.INSTANT_RESEARCH_SPEED_BOOST, gBuffSource.PET)
	if petadd then
		rettime = rettime + petadd
	end
	return rettime
end
function technologyCtrl:getResearchTime(basetime, queueType)
	return self.technologyAuxiliary:getResearchTime(basetime, queueType, self.originData)
end
function technologyCtrl:getResearchTimeAddPercent(queueType)
	return self.technologyAuxiliary:getResearchTimeAddPercent(queueType, self.originData)
end
function technologyCtrl:checkIsFullTech()
	local ret = true
	for k, v in pairs(self.technologyData) do
		if k ~= "wartechnology" then
			for key, info in pairs(v) do
				if info.currentLevel < info.maxLevel then
					ret = false
					return ret
				end
			end
		end
	end
	return ret
end
function technologyCtrl:checkIsFull(techType)
	local ret = true
	for k, v in pairs(self.technologyData) do
		if k == techType then
			for key, info in pairs(v) do
				if info.currentLevel < info.maxLevel then
					ret = false
					return ret
				end
			end
		end
	end
	return ret
end
function technologyCtrl:getRecommendTech()
	local _ENV, reTechID
	local _UPVALUE5_, _ENV, _ENV, targetID
	_UPVALUE1_, (nil)[1], (nil)[1] = nil, nil, TECHNOLOGY_ATTR.military
	_UPVALUE1_, (nil)[1], (nil)[2] = nil, nil, TECHNOLOGY_ATTR.special
	_UPVALUE1_, (nil)[1], (nil)[3] = nil, nil, TECHNOLOGY_ATTR.soldier
	_UPVALUE1_, (nil)[1], (nil)[4] = nil, nil, TECHNOLOGY_ATTR.leader
	_UPVALUE1_, (nil)[1], (nil)[5] = nil, nil, TECHNOLOGY_ATTR.hero
	_UPVALUE2_, (nil)[2], (nil)[1] = nil, nil, TECHNOLOGY_ATTR.resource
	;(nil)[3], (nil)[1] = nil, TECHNOLOGY_ATTR.cityDevelop
	;(nil)[3], (nil)[2] = nil, TECHNOLOGY_ATTR.anchor
	local classDef
	for k, v in ipairs(classDef) do
		reTechID[k], _ENV = TECHNOLOGY_ATTR.hero, TECHNOLOGY_ATTR.hero
		for ki, vi in ipairs(v) do
			local techTree = self.technologyData[vi]
			if techTree then
				for tID, info in pairs(techTree) do
					if info.isOpened and info.currentLevel < info.maxLevel then
						table.insert(reTechID[k], info)
					end
				end
				table.sort(reTechID[k], function(a, b)
					return tonumber(a.technologyID) < tonumber(b.technologyID)
				end)
			end
		end
	end
	local len = 0
	local _ENV, indexArray = ipairs(classDef)
	for k, v in ipairs(reTechID) do
		if next(v) then
			len = len + 1
			table.insert(indexArray, k)
		end
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local function getTwoRandom(val)
		local _random
		if val then
			_random = math.random(#classDef)
			if _random == val then
				return getTwoRandom(val)
			end
		else
			_random = math.random(#classDef)
		end
		return _random
	end
	if len == #classDef then
		local random1 = getTwoRandom()
		local random2 = getTwoRandom(random1)
		table.insert(targetID, reTechID[random1][1])
		table.insert(targetID, reTechID[random2][1])
	elseif len == 2 then
		local index1 = indexArray[1]
		local index2 = indexArray[2]
		table.insert(targetID, reTechID[index1][1])
		table.insert(targetID, reTechID[index2][1])
	elseif len == 1 then
		local index1 = indexArray[1]
		table.insert(targetID, reTechID[index1][1])
	end
	return targetID
end
function technologyCtrl:isProcessTech(technologyId)
	return self.technologyAuxiliary:isProcessTech(tonumber(technologyId))
end
function technologyCtrl:getNextUnlockTechId(starLv)
	return self.technologyAuxiliary:getNextUnlockTechId(starLv)
end
function technologyCtrl:getTechnologyDetailById(technologyId, curLv)
	if curLv == 0 then
		curLv = curLv + 1
	end
	local technologyIdStr = self.technologyAuxiliary:mosaicTechnologyId(technologyId, curLv)
	return self.technologyAuxiliary:getTechnologyDetailById(technologyIdStr)
end
function technologyCtrl:techUpgrateNotify(id, level)
	local technologyIdStr = self.technologyAuxiliary:mosaicTechnologyId(id, level)
	local technologyDetails = self.technologyAuxiliary:getTechnologyDetailById(technologyIdStr)
	if technologyDetails and next(technologyDetails) ~= nil then
		local tempType = technologyDetails.buffType
		local techEventName = string.format(gEventName.event_tech_level_up, tempType)
		print("technologyCtrl:techUpgrateNotify", techEventName)
		_ENV = techEventName
		techEventName.name = techEventName
		techEventName.level = level
		self:dispatchEvent(techEventName)
	end
	_ENV = string.format(gEventName.event_tech_level_up, tempType)
	string.format(gEventName.event_tech_level_up, tempType).msg = "MESSAGE_UI_PANDECT_ALLREFRESH"
	SoraDSendMessage((string.format(gEventName.event_tech_level_up, tempType)))
end
function technologyCtrl:initClientData(data)
	self.originData = data
	self.technologyData = self.technologyAuxiliary:handlerTechnology(data)
end
function technologyCtrl:addWaitQueue(technologyId, rtype)
	serverproxy = nil
	;(nil).rtype = rtype
	;(nil).technologyId = technologyId
	serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_TECHNOLOGY_ADD_WAIT_QUEUE, nil)
end
function technologyCtrl:addWaitQueueRsp(respone)
	dump(respone, "==technologyCtrl:addWaitQueueRsp==", 10)
	if gErrDef.Err_None == respone.err then
		SoraDShowMsgTip(i18n("privilege_text_91"))
		_ENV = i18n("privilege_text_91")
		i18n("privilege_text_91").msg = "MESSAGE_TECHNOLOGY_WAITQUEUE"
		SoraDSendMessage(i18n("privilege_text_91"))
	end
end
function technologyCtrl:delWaitQueue(queueType)
	serverproxy = nil
	;(nil).queueType = tostring(queueType)
	serverproxy:Request(gCmd.CMD_TECHNOLOGY_MODULE, gCmd.REQ_TECHNOLOGY_DEL_WAIT_QUEUE, nil)
end
function technologyCtrl:delWaitQueueRsp(respone)
	dump(respone, "==technologyCtrl:delWaitQueueRsp==", 10)
	if gErrDef.Err_None == respone.err then
		SoraDShowMsgTip(i18n("alliance_text_09"))
		_ENV = i18n("alliance_text_09")
		i18n("alliance_text_09").msg = "MESSAGE_TECHNOLOGY_WAITQUEUE"
		SoraDSendMessage(i18n("alliance_text_09"))
	end
end
function technologyCtrl:getGardenTechPower()
	local techData = self:getTechnologyDataByType("manor")
	local ret = 0
	for _, v in pairs(techData) do
		if v.isOpened and 0 < v.currentLevel then
			local details = self:getTechnologyDetails(tonumber(v.technologyID), v.currentLevel)
			ret = ret + (details.curPower or 0)
		end
	end
	return ret
end
function technologyCtrl:getGardenTechBuffMap()
	local collegeDesRead = include("collegeDesRead")
	local techData = self:getTechnologyDataByType("manor")
	local _ENV, ret = self, self
	for _, v in pairs(techData) do
		if v.isOpened and v.currentLevel > 0 then
			local cfg = collegeDesRead.getTechBuffCfg(tonumber(v.technologyID), v.currentLevel)
			if not ret[cfg.buffType] then
				ret[cfg.buffType] = cfg
			else
				ret[cfg.buffType].powerNum = ret[cfg.buffType].powerNum + cfg.powerNum
			end
		end
	end
	return ret
end
return technologyCtrl
