local gamemodulec = include("GameModule")
local cityCtrl = class("cityCtrl", gamemodulec)
local cityCell = include("cityCell")
local buildCell = include("buildCell")
local resCalculate = include("resCalculate")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local dailyResLimitltCtrl = include("dailyResLimitltCtrl")
local worldMapDefine = include("worldMapDefine")
local specializationRead = include("specializationRead")
function cityCtrl:ctor(properties)
	cityCtrl.super.ctor(self, properties)
	self:resetData()
end
function cityCtrl:resetData()
	self.handle_city_notify = nil
	self.cityList, resCalculate, self.cid = nil, nil, "0"
	self.resCalculate = nil
	self.resCalculate = resCalculate.new()
	self.deltatime = 0
	self.kipchaksData, resCalculate, self.upgradePopLv = resCalculate.new(), resCalculate.new(), 0
end
function cityCtrl:update(dttime)
	self.deltatime = self.deltatime + dttime
	if self.deltatime >= 1 and G_MAINSCENE_CURRENT_VIEW_TYPE == VIEW_TYPE_CITY then
		local curcity = self:getCurCity()
		if curcity then
			local buildlist = curcity.buildList
			for k, bcell in pairs(buildlist) do
				if bcell then
					bcell:update(self.deltatime)
				end
			end
		end
		self.deltatime = 0
	end
end
function cityCtrl:buildQueueCallback(event)
	local data = event.data
	local eventname = event.name
	local optype = tonumber(data.optype)
	local bid = tonumber(data.bid)
	local iid = tonumber(data.iid)
	local queueType = tonumber(event.name)
	local bcell = self:getBuildCell(bid, iid)
	if bcell then
		local index = tonumber(bcell.info.index)
		if optype == BUILD_OPERATE_TYPE.UPGRADE then
			self:upgradeBuild(index)
			self:changeBuildState(index, BUILD_STATE.NORMAL)
			self:tipBattleAndExp(optype, bid, tonumber(bcell.info.lv))
			self:tipUpgradeComplete(bid, tonumber(bcell.info.lv))
		elseif optype == BUILD_OPERATE_TYPE.BUILD then
			self:changeBuildState(index, BUILD_STATE.NORMAL)
			self:tipBattleAndExp(optype, bid, tonumber(bcell.info.lv))
			self:tipUpgradeComplete(bid, tonumber(bcell.info.lv))
		elseif optype == BUILD_OPERATE_TYPE.DEMOLISH then
			self:demplishBuild(index)
		elseif optype == QUEUE_OPERATE_TYPE.CANCLE then
			self:tipCancle(index)
			self:changeBuildState(index, BUILD_STATE.NORMAL)
		end
		_ENV = self
		self.msg = "MESSAGE_UI_PANDECT_BUILDER"
		self.queueType = queueType
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_UI_PANDECT_ARMY"
		self.queueType = queueType
		self.bid = bid
		self.iid = iid
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK"
		self.queueType = queueType
		self.optype = optype
		self.index = index
		self.bid = bid
		self.iid = iid
		self.costres = data.costres
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
		self.queueType = queueType
		self.optype = optype
		self.bid = bid
		self.iid = iid
		SoraDSendMessage(self)
		if optype == BUILD_OPERATE_TYPE.UPGRADE then
			_ENV = data.costres
			data.costres.name = string.format(gEventName.event_city_build_level_up, bid)
			self:dispatchEvent(data.costres)
			_ENV = self
			self.msg = "MESSAGE_UPDATE_MASTERY_TOP_TIP"
			SoraDSendMessage(self)
		end
		if bid == BUILDID.CASTLE then
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
			SoraDSendMessage(self)
			if optype == BUILD_OPERATE_TYPE.UPGRADE and bcell.info.lv == CASTLE_LV4_LIMITED then
				_ENV = CASTLE_LV4_LIMITED
				CASTLE_LV4_LIMITED.msg = "MESSAGE_SERVER_PAVILION_UPDATE_TIP"
				SoraDSendMessage(CASTLE_LV4_LIMITED)
			end
		end
		_UPVALUE5_ = SoraDSendMessage
		SoraDSendMessage[1] = BUILDID.CHARIOT_PLANT
		SoraDSendMessage[2] = BUILDID.STABLES
		SoraDSendMessage[3] = BUILDID.RANGE
		SoraDSendMessage[4] = BUILDID.BARRACKS
		local SoraDSendMessage[5], bidArray = BUILDID.ELITE_PALACE, SoraDSendMessage
		if SoraDisInList(bid, bidArray) then
			local gametop = gModuleMgr.getObject("gametop")
			local armyCtrl = gametop.playertop_:getModule("armyCtrl")
			armyCtrl:updatePromoteCache(bid)
			_ENV = armyCtrl
			armyCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
			SoraDSendMessage(armyCtrl)
		end
		_ENV = gametop.playertop_:getModule("armyCtrl")
		gametop.playertop_:getModule("armyCtrl").msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
		SoraDSendMessage((gametop.playertop_:getModule("armyCtrl")))
	end
end
function cityCtrl:buildStarQueueCallback(event)
	dump(event, "==buildStarQueueCallback==")
	local data = event.data
	local eventname = event.name
	local optype = tonumber(data.optype)
	local bid = tonumber(data.bid)
	local iid = tonumber(data.iid)
	local queueType = tonumber(event.name)
	local bcell = self:getBuildCell(bid, iid)
	if bcell then
		local index = tonumber(bcell.info.index)
		if optype == BUILD_OPERATE_TYPE.UPGRADE_STAR then
			self:upgradeBuildStar(index)
			self:changeBuildStarState(index, BUILD_STAR_STATE.NORMAL)
			local cityltCtrl = include("cityltCtrl")
			local starLv = tonumber(bcell.info.starLv)
			local addexp = cityltCtrl.buildStarLvInfo(bid, starLv, BUILD_LVINFO.EXP)
			local addpower = cityltCtrl.getPowerReward(bid, starLv, true)
			local msgNotice = include("msgNotice")
			_ENV = nil
			;(nil).buildID = bid
			;(nil).level = starLv
			msgNotice.notice("Glory_text_35", nil)
			_ENV = nil
			;(nil).name = string.format(gEventName.event_city_build_level_up, bid)
			self:dispatchEvent(nil)
			if 1050 == index then
				SoraDPlaySound("innercontrol", 7)
			elseif cityltCtrl.buildAttr(bid, BUILD_ATTR.BTYPE) == 0 then
				SoraDPlaySound("innercontrol", 2)
			else
				SoraDPlaySound("innercontrol", 9)
			end
			_ENV = "innercontrol"
			;("innercontrol").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			;("innercontrol").buildIndex = index
			;("innercontrol").optype = optype
			SoraDSendMessage("innercontrol")
		elseif optype == QUEUE_OPERATE_TYPE.CANCLE then
			self:tipCancle(index)
			self:changeBuildStarState(index, BUILD_STAR_STATE.NORMAL)
		end
		_ENV = self
		self.msg = "MESSAGE_UI_PANDECT_BUILDER"
		self.queueType = queueType
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK"
		self.queueType = queueType
		self.optype = optype
		self.index = index
		self.bid = bid
		self.iid = iid
		self.costres = data.costres
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
		self.queueType = queueType
		self.optype = optype
		self.bid = bid
		self.iid = iid
		SoraDSendMessage(self)
	end
end
function cityCtrl:buildStatueBraveQueueCallback(event)
	dump(event, "==buildStatueBraveQueueCallback==")
	local data = event.data
	local eventname = event.name
	local optype = tonumber(data.optype)
	local bid = tonumber(data.bid)
	local iid = tonumber(data.iid)
	local queueType = tonumber(event.name)
	local bcell = self:getBuildCell(bid, iid)
	if bcell then
		local index = tonumber(bcell.info.index)
		if optype == BUILD_OPERATE_TYPE.UPGRADE_STAR then
			self:upgradeBuildStar(index)
			local cityltCtrl = include("cityltCtrl")
			local starLv = tonumber(bcell.info.starLv)
			local addexp = cityltCtrl.buildStarLvInfo(bid, starLv, BUILD_LVINFO.EXP)
			local addpower = cityltCtrl.getPowerReward(bid, starLv, true)
			local msgNotice = include("msgNotice")
			local info = cityltCtrl.getQualityByStarLv(starLv)
			_ENV = nil
			;(nil).quality = cityltCtrl.getStatueBraveQualityName(info.quality)
			;(nil).var = info.level
			msgNotice.notice("Soldiers_armor_text_64", nil)
			_ENV = nil
			;(nil).name = string.format(gEventName.event_city_build_level_up, bid)
			self:dispatchEvent(nil)
			if cityltCtrl.buildAttr(bid, BUILD_ATTR.BTYPE) == 0 then
				SoraDPlaySound("innercontrol", 2)
			else
				SoraDPlaySound("innercontrol", 9)
			end
			_ENV = "innercontrol"
			;("innercontrol").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			;("innercontrol").buildIndex = index
			;("innercontrol").optype = optype
			SoraDSendMessage("innercontrol")
		elseif optype == QUEUE_OPERATE_TYPE.CANCLE then
			self:tipCancle(index)
		end
		self:changeBuildStarState(index, BUILD_STAR_STATE.NORMAL)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_STATUEBRAVE_QUEQUE_CALLBACK"
		self.queueType = queueType
		self.optype = optype
		self.index = index
		self.bid = bid
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
		self.queueType = queueType
		self.optype = optype
		self.bid = bid
		self.iid = iid
		SoraDSendMessage(self)
	end
end
function cityCtrl:buildMagicLampQueueCallback(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAGICLAMP_UPDATE"
	SoraDSendMessage(nil)
end
function cityCtrl:tipUpgradeComplete(bid, blv)
	local buildLogic = include("buildLogic")
	local ret, wlv, progress = buildLogic.isBuildWarLv(blv)
	local msgNotice = include("msgNotice")
	if not ret then
		_ENV = nil
		;(nil).buildID = bid
		;(nil).level = blv
		msgNotice.notice("notice_0054", nil)
	elseif 0 == wlv and 0 == progress then
		if BUILDID.MIRACLE == bid then
			_ENV = nil
			;(nil).buildID = bid
			msgNotice.notice("common_text_2001", nil)
		else
			_ENV = nil
			;(nil).buildID = bid
			;(nil).level = blv
			msgNotice.notice("notice_0054", nil)
		end
	elseif 0 < progress then
		_ENV = nil
		;(nil).buildID = bid
		;(nil).warLv = wlv + 1
		;(nil).percent = progress * 100
		msgNotice.notice("common_text_1999", nil)
	else
		_ENV = nil
		;(nil).buildID = bid
		;(nil).warLv = wlv
		msgNotice.notice("common_text_2000", nil)
	end
end
function cityCtrl:tipCancle(index)
	local bcell = self:getBuildCellByIndex(index)
	print("sldkjflskjdfsd", index)
	if bcell then
		local msgNotice = include("msgNotice")
		local bid = tonumber(bcell.info.bid)
		local state = tonumber(bcell.info.state)
		local stateEx = tonumber(bcell.info.stateEx)
		if state == BUILD_STATE.UPGRADEING or stateEx == BUILD_STAR_STATE.UPGRADEING then
			if BUILDID.NEBULA_PALACE == bid then
				msgNotice.notice("notice_0178", nil, gNoticeIconTypeDef.ICON_BUILD, bid)
			else
				msgNotice.notice("notice_0055", nil, gNoticeIconTypeDef.ICON_BUILD, bid)
			end
		elseif state == BUILD_STATE.DEMOLISHING then
			msgNotice.notice("notice_0178", nil, gNoticeIconTypeDef.ICON_BUILD, bid)
		end
	end
end
function cityCtrl:tipBattleAndExp(optype, bid, blv)
	local cityltCtrl = include("cityltCtrl")
	local addexp = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.EXP)
	local addpower = cityltCtrl.getPowerReward(bid, blv)
	print(string.format("add exp=%d,add power=%d", addexp, addpower))
end
function cityCtrl:EnterGame()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.free_build_queue), handler(self, self.buildQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.charge_build_queue), handler(self, self.buildQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.build_star_queue), handler(self, self.buildStarQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.build_star_queue_privilege), handler(self, self.buildStarQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.glorious_upgrade), handler(self, self.buildStatueBraveQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.magic_lamp_jinn_level), handler(self, self.buildMagicLampQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.magic_lamp_jinn_star), handler(self, self.buildMagicLampQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.magic_lamp_jinn_class), handler(self, self.buildMagicLampQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.magic_lamp_hatch_level), handler(self, self.buildMagicLampQueueCallback))
	if not IsArClient then
		queueCtrl:addEventListener(tostring(gQueueTypeDef.build_mastery), handler(self, self.masteryQueueCallback))
		queueCtrl:addEventListener(tostring(gQueueTypeDef.construction_drawing), handler(self, self.drawingQueueCallback))
	end
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	backpackCtrl:addItemChangeEvent(300501, handler(self, self.toolCountChangeNotify))
	backpackCtrl:addItemChangeEvent(300601, handler(self, self.toolCountChangeNotify))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_INIT_CITYDATA, handler(self, self.initCityDataRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_BUILDING, handler(self, self.addBuildRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_UPGRADE, handler(self, self.upgradeBuildRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_STAR_UPGRADE, handler(self, self.upgradeBuildStarRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_DEMOLISH, handler(self, self.demolishBuildRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_EXCHANGE, handler(self, self.exchangePosRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_OPEN_GROUND, handler(self, self.openGroundRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_OPEN_CHARGE_QUEUE, handler(self, self.openChargeQueueRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_COLLECT_RES, handler(self, self.collectResRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_SPEED_UP_RES, handler(self, self.speedUpResRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_LEFT_CAN_GET_RES, handler(self, self.leftCanGetResRsp))
	msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_SET_CITY_UPGRADE_POP_LV, handler(self, self.setUpgradePopLvRsp))
	if not IsArClient then
		msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_UNLOCK_BUILD_MASTERY, handler(self, self.reqMasteryRsp))
		msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_UPGRADE_MASTERY_LEVEL, handler(self, self.reqMasteryRsp))
		msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_UPGRADE_MASTERY_BUFF, handler(self, self.reqMasteryRsp))
		msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_RESET_MASTERY_STAR, handler(self, self.reqMasteryRsp))
		msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_START_DRAWING, handler(self, self.reqMasteryDrawStartRsp))
		msgCtrl.register(gCmd.CMD_CITY_MODULE, gCmd.REQ_RECEIVE_DRAWING_REWARD, handler(self, self.reqMasteryDrawReceiveRsp))
	end
	msgCtrl.register(gCmd.CMD_KIPCHAKS_MODULE, gCmd.REQ_KIPCHAKS_INIT_DATA, handler(self, self.reqKipchaksInitRsp))
	msgCtrl.register(gCmd.CMD_KIPCHAKS_MODULE, gCmd.REQ_KIPCHAKS_ATTACK, handler(self, self.reqKipchaksAttackRsp))
	self:reqKipchaksInitReq()
	self.resCalculate:EnterGame()
end
function cityCtrl:Logout()
	cityCtrl.super.Logout(self)
	self.resCalculate:Logout()
	self:resetData()
end
function cityCtrl:toolCountChangeNotify(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
	SoraDSendMessage(nil)
end
function cityCtrl:addCity(cid, citycell)
	if not self.cityList[tostring(cid)] then
		self.cityList[tostring(cid)] = citycell
	else
		printf("cur cid already add,cid=%d", cid)
	end
end
function cityCtrl:isCrystalMineUnlock()
	local castleLevel = self:getCastleLevel()
	local unlockLevel = 60
	return castleLevel >= unlockLevel
end
function cityCtrl:initCrystalMine()
	local bcell = self:getBuildCell(BUILDID.CRYSTAL_MINE, 0)
	if bcell then
		if self:isCrystalMineUnlock() then
		else
			bcell.info.state = tostring(BUILD_STATE.LOCK)
		end
		local state = tonumber(bcell.info.state)
		if BUILD_STATE.LOCK == state then
			local handle = ""
			local buildListener = function(event)
				if self:isCrystalMineUnlock() then
					self:removeEventListener(handle)
					bcell.info.state = tostring(BUILD_STATE.NORMAL)
				end
			end
			local eventName = string.format(gEventName.event_city_build_level_up, BUILDID.CASTLE)
			handle = self:addEventListener(eventName, buildListener)
		end
	end
end
function cityCtrl:getCurCity()
	return self.cityList[self.cid]
end
function cityCtrl:getCurCityPos()
	local curcity = self:getCurCity()
	if curcity then
		local pos = curcity.info.pos
		_ENV = nil
		;(nil).x = tonumber(pos.x)
		;(nil).y = tonumber(pos.y)
		return nil
	end
end
function cityCtrl:updateCityPos(pos)
	local curcity = self:getCurCity()
	if curcity then
		_ENV = nil
		;(nil).x = tostring(pos.x)
		curcity.info.pos, (nil).y = nil, tostring(pos.y)
	end
end
function cityCtrl:getBuildList()
	local citycell = self:getCurCity()
	if citycell == nil then
		return nil
	end
	return citycell.buildList
end
function cityCtrl:getEmptyArea()
	local cityBuildMgr = include("cityBuildMgr")
	local index
	for k, v in ipairs(BUILD_INDEX) do
		local build = cityBuildMgr:getBuildByIndex(v)
		if not build then
			index = v
			break
		end
	end
	return index
end
function cityCtrl:getUnFullLvBuild()
	local buildList = self:getBuildList()
	local bid
	local iid = 0
	local lv = 1
	for k, v in ipairs(BUILD_INDEX) do
		local build = buildList[tostring(v)]
		if build and tonumber(build.info.lv) < SoraDGetCastleLv() and tonumber(build.info.state) == BUILD_STATE.NORMAL then
			bid = tonumber(build.info.bid)
			iid = tonumber(build.info.iid)
			lv = tonumber(build.info.lv)
			break
		end
	end
	return bid, iid, lv
end
function cityCtrl:getBuildCellByIndex(index)
	local buildlist = self:getBuildList()
	if buildlist == nil then
		return
	end
	local ret = buildlist[tostring(index)]
	if ret then
		return ret
	else
	end
end
function cityCtrl:getBuildCell(bid, iid)
	local buildlist = self:getBuildList()
	for k, bcell in pairs(buildlist) do
		if tonumber(bcell.info.bid) == tonumber(bid) and tonumber(bcell.info.iid) == tonumber(iid) then
			return bcell
		end
	end
end
function cityCtrl:getBuildCellList(bid)
	local _ENV, bcelllist
	local buildlist = self:getBuildList()
	if buildlist and next(buildlist) then
		for k, bcell in pairs(buildlist) do
			if tonumber(bcell.info.bid) == tonumber(bid) then
				table.insert(bcelllist, bcell)
			end
		end
	end
	return bcelllist
end
function cityCtrl:getBuildMaxLv(bid)
	local ret = 0
	local iid = 0
	if not self:getBuildList() then
		local _ENV, buildlist = self:getBuildList(), self:getBuildList()
	end
	for k, bcell in pairs(buildlist) do
		if tonumber(bcell.info.bid) == bid and ret < tonumber(bcell.info.lv) then
			ret = tonumber(bcell.info.lv)
			iid = tonumber(bcell.info.iid)
		end
	end
	return ret, iid
end
function cityCtrl:getBuildMaxStarLv(bid)
	local ret = 0
	local iid = 0
	local buildlist = self:getBuildList()
	for k, bcell in pairs(buildlist) do
		if tonumber(bcell.info.bid) == bid and ret < tonumber(bcell.info.starLv) then
			ret = tonumber(bcell.info.starLv)
			iid = tonumber(bcell.info.iid)
		end
	end
	return ret, iid
end
function cityCtrl:getBuildMaxStarLvEx(bid)
	local ret, blv, iid = 0, 0, 0
	local buildlist = self:getBuildList()
	for k, bcell in pairs(buildlist) do
		if tonumber(bcell.info.bid) == bid then
			local starLv = tonumber(bcell.info.starLv)
			local buildLv = tonumber(bcell.info.lv)
			if ret < starLv or starLv == ret and blv < buildLv then
				ret = starLv
				iid = tonumber(bcell.info.iid)
				blv = buildLv
			end
		end
	end
	return ret, iid
end
function cityCtrl:getBuildStarLv(bid, iid)
	if iid then
		local bcell = self:getBuildCell(bid, iid)
		if bcell then
			return tonumber(bcell.info.starLv)
		end
	end
	return self:getBuildMaxStarLv(bid)
end
function cityCtrl:getCastleLevel()
	local castleLevel = self:getBuildMaxLv(BUILDID.CASTLE)
	return castleLevel
end
function cityCtrl:getBuildCount(bid)
	local retcount = 0
	local buildlist = self:getBuildList()
	for k, buildcell in pairs(buildlist) do
		if bid == tonumber(buildcell.info.bid) then
			retcount = retcount + 1
		end
	end
	return retcount
end
function cityCtrl:getBuildMaxiid(bid)
	local retiid = 0
	local buildlist = self:getBuildList()
	for k, bcell in pairs(buildlist) do
		if tonumber(bcell.info.bid) == bid and retiid <= tonumber(bcell.info.iid) then
			retiid = tonumber(bcell.info.iid) + 1
		end
	end
	return retiid
end
function cityCtrl:createBuild(index, bid)
	local cityltCtrl = include("cityltCtrl")
	local btype = cityltCtrl.buildAttr(bid, BUILD_ATTR.BTYPE)
	local iid = 0
	if btype == BUILD_TYPE.OUTER then
		iid = self:getBuildMaxiid(bid)
	end
	local bcell = include("buildCell").new()
	local initlv = cityltCtrl.buildAttr(bid, BUILD_ATTR.INITLV)
	_ENV, initlv = tostring(initlv), tostring(initlv)
	tostring(initlv).index = tostring(index)
	tostring(initlv).bid = tostring(bid)
	tostring(initlv).iid = tostring(iid)
	tostring(initlv).lv = initlv
	tostring(initlv).state = BUILD_STATE.BUILDING
	tostring(initlv).curres = "0"
	tostring(initlv).starLv = 0
	bcell.info, tostring(initlv).stateEx = tostring(initlv), BUILD_STAR_STATE.NORMAL
	local curcity = self:getCurCity()
	curcity:addBuild(index, bcell)
	return iid
end
function cityCtrl:upgradeBuild(index)
	local index = tostring(index)
	local curcity = self:getCurCity()
	if curcity then
		curcity:upgradeBuild(index)
	else
		print("cityCtrl:upgradeBuild curcity is nil")
	end
end
function cityCtrl:upgradeBuildStar(index)
	local index = tostring(index)
	local curcity = self:getCurCity()
	if curcity then
		curcity:upgradeBuildStar(index)
	else
		print("cityCtrl:upgradeBuildStar curcity is nil")
	end
end
function cityCtrl:demplishBuild(index)
	local index = tostring(index)
	local curcity = self:getCurCity()
	if curcity then
		curcity:removeBuild(index)
	else
		print("cityCtrl:demplishBuild curcity is nil")
	end
end
function cityCtrl:changeBuildState(index, state)
	local index = tostring(index)
	local state = tostring(state)
	local bcell = self:getBuildCellByIndex(index)
	if bcell then
		bcell.info.state = state
	end
end
function cityCtrl:changeBuildStarState(index, state)
	local index = tostring(index)
	local state = tostring(state)
	local bcell = self:getBuildCellByIndex(index)
	if bcell then
		bcell.info.stateEx = state
	end
end
function cityCtrl:getResCount(resid)
	local curcity = self:getCurCity()
	if curcity.resList then
		local ret = curcity.resList[tostring(resid)]
		if ret then
			return math.floor(tonumber(ret))
		else
		end
	end
end
function cityCtrl:getResCountEx(resid)
	if self:isSafeResID(resid) then
		resid = self:transformSafeResIDToResID(resid)
		return self:getSafeRes(resid)
	else
		return self:getResCount(resid)
	end
end
function cityCtrl:getRealResid(resid)
	if self:isSafeResID(resid) then
		return self:transformSafeResIDToResID(resid)
	else
		return resid
	end
end
function cityCtrl:consumeArmyFood(count)
	local curcity = self:getCurCity()
	if curcity and curcity.resList then
		local curcount = tonumber(curcity.resList[tostring(gIDDef.FOOD)]) or 0
		local saferes = self:getSafeRes(gIDDef.FOOD)
		local normalres = curcount - saferes
		if 0 < normalres then
			if count > normalres then
				count = normalres
			end
			curcount = curcount - count
			if curcount < 0 then
				curcount = 0
			end
			curcity.resList[tostring(gIDDef.FOOD)] = tostring(curcount)
			_ENV = tostring(gIDDef.FOOD)
			_ENV, tostring(gIDDef.FOOD).msg = tostring(curcount), "MESSAGE_RESOURCE_UPDATE"
			tostring(gIDDef.FOOD).reslist, tostring(curcount)["1002"] = tostring(curcount), -count
			tostring(gIDDef.FOOD).animate = false
			SoraDSendMessage((tostring(gIDDef.FOOD)))
		end
	end
end
function cityCtrl:updateResCount(reslist, animate)
	if animate == nil then
		animate = true
	end
	local curcity = self:getCurCity()
	if curcity.resList then
		for resid, count in pairs(reslist) do
			local ret = tonumber(curcity.resList[tostring(resid)])
			if ret then
				ret = ret + tonumber(count)
				if ret <= 0 then
					ret = 0
				end
				curcity.resList[tostring(resid)] = tostring(ret)
			end
		end
		_ENV = pairs(reslist)
		pairs(reslist).msg = "MESSAGE_RESOURCE_UPDATE"
		pairs(reslist).reslist = reslist
		pairs(reslist).animate = animate
		SoraDSendMessage(pairs(reslist))
	end
end
function cityCtrl:getLeftDayMaxRes(resid, source)
	if worldMapDefine.isInLegendLord() or worldMapDefine.isInRemains() then
		return self:getResMaxTotal()
	end
	if self:isSafeResID(resid) then
		resid = self:transformSafeResIDToResID(resid)
	end
	local ret = 0
	local cityCell = self:getCurCity()
	if cityCell then
		local castleLV = self:getBuildMaxLv(BUILDID.CASTLE)
		local max
		if resid == gIDDef.GOLD then
			max = gConstValue.MAX_GOLD_COUNT
		else
			max = dailyResLimitltCtrl:getResLimit(resid, source, castleLV)
		end
		local curdaymax = cityCell:getCurDayMaxRes(resid, source)
		ret = max - curdaymax
		if ret < 0 then
			ret = 0
		end
	end
	return ret
end
function cityCtrl:getLeftTotalMaxRes(resid)
	if self:isSafeResID(resid) then
		resid = self:transformSafeResIDToResID(resid)
	end
	if resid == gIDDef.GOLD then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local curcount = lordInfoCtrl:getLordInfo().base.gold
		local ret = gConstValue.MAX_GOLD_COUNT - curcount
		if ret < 0 then
			ret = 0
		end
		return ret
	else
		local curcount = self:getResCount(resid)
		local ret = self:getResMaxTotal() - curcount
		if ret < 0 then
			ret = 0
		end
		return ret
	end
end
function cityCtrl:isMaxRes(resid, addcount, source)
	if not serviceFunctions.isResourceID(resid) and not self:isSafeResID(resid) then
		return false
	end
	if self:isSafeResID(resid) then
		resid = self:transformSafeResIDToResID(resid)
	end
	local leftDayMaxRes = self:getLeftDayMaxRes(resid, source)
	local leftTotalMaxRes = self:getLeftTotalMaxRes(resid)
	local msgNotice = include("msgNotice")
	local ret = false
	if addcount > leftDayMaxRes then
		ret = true
		local limitCount = self:getDailyResLimit(resid, gResSourceEnum.OTHER)
		_ENV = gResSourceEnum.OTHER
		gResSourceEnum.OTHER.resourceID = resid
		gResSourceEnum.OTHER.count = SoraDConvertNumberWithUnit(limitCount)
		msgNotice.notice("notice_0125", gResSourceEnum.OTHER)
	elseif addcount > leftTotalMaxRes then
		ret = true
		_ENV = "notice_0125"
		;("notice_0125").resourceID = resid
		;("notice_0125").count = SoraDConvertNumberWithUnit(self:getResMaxTotal())
		msgNotice.notice("notice_0124", "notice_0125")
	end
	return ret
end
function cityCtrl:getDailyResLimit(resID, source)
	local castleLV = self:getBuildMaxLv(BUILDID.CASTLE)
	return dailyResLimitltCtrl:getResLimit(resID, source, castleLV)
end
function cityCtrl:updateSafeRes(resid, count)
	local cityCell = self:getCurCity()
	if cityCell and cityCell.saferes and cityCell.saferes[tostring(resid)] then
		local cursafe = cityCell.saferes[tostring(resid)]
		local finalsafe = cursaferes + count
		if finalsafe < 0 then
			finalsafe = 0
		end
		cityCell.saferes[tostring(resid)] = finalsafe
	end
end
function cityCtrl:getSafeRes(resid)
	local ret = 0
	local cityCell = self:getCurCity()
	if cityCell and cityCell.saferes and cityCell.saferes[tostring(resid)] then
		ret = math.floor(cityCell.saferes[tostring(resid)])
	end
	return ret
end
function cityCtrl:getNormalRes(resid)
	local totalres = self:getResCount(resid)
	local saferes = self:getSafeRes(resid)
	local normalres = totalres - saferes
	if normalres < 0 then
		normalres = 0
	end
	return normalres
end
function cityCtrl:initCityDataReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_INIT_CITYDATA, nil, ...)
end
function cityCtrl:initCityDataRsp(content)
	dump(content, "cityCtrl:initCityDataRsp", 10)
	local data = content.data
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.mastery = data.mastery
	_citycell:setDrawingData(data.drawingData)
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:registerNotify()
end
function cityCtrl:addBuildReq(_index, _mode, _bid, ...)
	_ENV = nil
	;(nil).index = tostring(_index)
	;(nil).bid = tostring(_bid)
	local (nil).mode, data = tostring(_mode), nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_BUILDING, data, ...)
	SoraDPlaySound("innercontrol", 1)
	_ENV = "innercontrol"
	;("innercontrol").msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
	SoraDSendMessage("innercontrol")
end
function cityCtrl:addBuildRsp(content)
	local err = content.err
	print("cityCtrl:addBuildRsp err=" .. err)
	if err == gErrDef.Err_None then
	else
	end
	local curStep = SoraDIsGameGuide()
	if curStep then
		_ENV = err
		err.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		err.step = curStep
		err.reload = err ~= gErrDef.Err_None
		SoraDSendMessage(err)
	end
end
function cityCtrl:upgradeBuildReq(_index, _mode, _bid, ...)
	_ENV = nil
	;(nil).index = tostring(_index)
	;(nil).bid = tostring(_bid)
	local (nil).mode, data = tostring(_mode), nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_UPGRADE, data, ...)
	_ENV = serverproxy
	serverproxy.msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
	SoraDSendMessage(serverproxy)
end
function cityCtrl:upgradeBuildRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.data and tonumber(content.data.mode) == OPERATE_MODE.FREE and content.data.bid == BUILDID.CASTLE then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if tonumber(content.data.mode) == OPERATE_MODE.IMMEDIATELY and IS_SELECT_LOGIN_NOTICE then
			IS_FIRST_TIME_COST_GOLD_BUILDING = false
		end
		_ENV = OPERATE_MODE.IMMEDIATELY
		OPERATE_MODE.IMMEDIATELY.msg = "MESSAGE_BUILD_UPGRADE_MSG_BACK"
		OPERATE_MODE.IMMEDIATELY.mode = content.data.mode
		OPERATE_MODE.IMMEDIATELY.index = tonumber(content.data.index)
		OPERATE_MODE.IMMEDIATELY.bid = tonumber(content.data.bid)
		SoraDSendMessage(OPERATE_MODE.IMMEDIATELY)
		_ENV = OPERATE_MODE.IMMEDIATELY
		OPERATE_MODE.IMMEDIATELY.msg = "MESSAGE_CHEAT_BUILD_SUCCESS"
		OPERATE_MODE.IMMEDIATELY.bid = content.data.bid
		SoraDSendMessage(OPERATE_MODE.IMMEDIATELY)
	elseif err == gErrDef.Err_RESOUCH_NOT_REACH then
		SoraDShowMsgTip(i18n("hero_text_90"))
	elseif err == gErrDef.Err_PRECOND_NOT_REACH then
		SoraDShowMsgTip(i18n("common_text_4685"))
	elseif err == gErrDef.Err_TOOLS_NOT_REACH then
		SoraDShowMsgTip(i18n("common_text_2512"))
	elseif err == gErrDef.Err_GOLD_NOT_REACH then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_424"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			end
		end)
	else
		SoraDShowMsgTip(err)
	end
end
function cityCtrl:upgradeBuildStarReq(_index, _mode, _bid, ...)
	_ENV = nil
	;(nil).index = tostring(_index)
	;(nil).bid = tostring(_bid)
	local (nil).mode, data = tostring(_mode), nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_STAR_UPGRADE, data, ...)
	_ENV = serverproxy
	serverproxy.msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
	SoraDSendMessage(serverproxy)
end
function cityCtrl:upgradeBuildStarRsp(content)
	dump(content, "==upgradeBuildStarRsp==", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		_ENV = "==upgradeBuildStarRsp=="
		;("==upgradeBuildStarRsp==").msg = "MESSAGE_BUILD_STAR_UPGRADE_MSG_BACK"
		;("==upgradeBuildStarRsp==").mode = content.data.mode
		SoraDSendMessage("==upgradeBuildStarRsp==")
	elseif err == gErrDef.Err_RESOUCH_NOT_REACH then
		SoraDShowMsgTip(i18n("hero_text_90"))
	elseif err == gErrDef.Err_PRECOND_NOT_REACH then
		SoraDShowMsgTip(i18n("common_text_4685"))
	elseif err == gErrDef.Err_PER_STAR_NOT_REACH then
		SoraDShowMsgTip(i18n("common_text_4686"))
	elseif err == gErrDef.Err_TOOLS_NOT_REACH then
		SoraDShowMsgTip(i18n("common_text_2512"))
	elseif err == gErrDef.Err_GOLD_NOT_REACH then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_424"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			end
		end)
	end
	_ENV = i18n("common_text_423")
	i18n("common_text_423").msg = "MESSAGE_CHEAT_BUILD_SUCCESS"
	i18n("common_text_423").bid = content.data.bid
	SoraDSendMessage((i18n("common_text_423")))
	local curStep = SoraDIsGameGuide()
	if curStep then
		_ENV = content.data.bid
		content.data.bid.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		content.data.bid.step = curStep
		content.data.bid.reload = err ~= gErrDef.Err_None
		SoraDSendMessage(content.data.bid)
	end
end
function cityCtrl:demolishBuildReq(_index, ...)
	_ENV = nil
	local (nil).index, data = tostring(_index), nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_DEMOLISH, data, ...)
	_ENV = serverproxy
	serverproxy.msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
	SoraDSendMessage(serverproxy)
end
function cityCtrl:demolishBuildRsp(content)
	local err = content.err
	print("cityCtrl:demolishBuildRsp err=" .. err)
	if err == gErrDef.Err_None then
	else
	end
end
function cityCtrl:exchangePosReq(_preindex, _newindex, mode, ...)
	_ENV = nil
	;(nil).preindex = tostring(_preindex)
	;(nil).newindex = tostring(_newindex)
	local (nil).mode, data = tostring(mode), nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_BUILD_EXCHANGE, data, ...)
end
function cityCtrl:exchangePosRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local curcity = self:getCurCity()
		local preIndex = data.preindex
		local afterIndex = data.newindex
		curcity:exchangeBuild(data.preindex, data.newindex)
		_ENV = curcity
		curcity.msg = "MESSAGE_MAINCITYVIEW_EXCHANGE_BUILD"
		curcity.preIndex = preIndex
		curcity.afterIndex = afterIndex
		SoraDSendMessage(curcity, content)
	else
	end
end
function cityCtrl:openGroundReq(areaid, ...)
	serverproxy = nil
	local (nil).areaid, data = areaid, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_OPEN_GROUND, data, ...)
end
function cityCtrl:openGroundRsp(content)
	dump(content, "cityCtrl:openGroundRsp", 10)
	local err = content.err
	local data = content.data
	if err == gErrDef.Err_None then
		local areaid = data.areaid
		local cityCell = self:getCurCity()
		cityCell:openArea(areaid)
		_ENV = cityCell
		cityCell.msg = "MESSAGE_MAINCITYVIEW_SHOW_LOCKAREA_REQ_LOADING"
		cityCell.areaid = areaid
		SoraDSendMessage(cityCell)
		_ENV = cityCell
		cityCell.msg = "MESSAGE_SERVER_MAINCITYVIEW_UNLOCK_AREA_SUCCESS"
		cityCell.areaid = areaid
		SoraDSendMessage(cityCell)
	else
		SoraDShowMsgTip(i18n("hero_text_90"))
	end
end
function cityCtrl:openChargeQueueReq(times, ...)
	serverproxy = nil
	;(nil).times = times
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_OPEN_CHARGE_QUEUE, nil, ...)
end
function cityCtrl:openChargeQueueRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local starttime = serviceFunctions.systemTime()
		local data = content.data
		local totaltime = data.totaltime
		local lefttime = data.lefttime
		local curcity = self:getCurCity()
		curcity:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
		_ENV = curcity
		curcity.msg = "MESSAGE_BUILDER_OPEN"
		SoraDSendMessage(curcity, content)
		_ENV = curcity
		curcity.msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
		SoraDSendMessage(curcity)
		SoraDShowMsgTip(i18n("common_text_2627"), "#icon_building_pay.png")
	else
	end
end
function cityCtrl:collectResReq(bid, iid, ...)
	serverproxy = nil
	;(nil).bid = bid
	local (nil).iid, data = iid, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_COLLECT_RES, data, ...)
	local bcell = self:getBuildCell(bid, iid)
	if bcell then
		bcell.info.curres = tostring("0")
	end
end
function cityCtrl:collectResRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local drop = content.data.drop
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_NEW_COLLECTITEMS"
		;(nil).items = drop
		SoraDSendMessage(nil)
	else
	end
end
function cityCtrl:speedUpResReq(bid, iid, mode, toolid, ...)
	_ENV = nil
	;(nil).bid = tonumber(bid)
	;(nil).iid = tonumber(iid)
	;(nil).mode = mode
	local (nil).toolid, data = toolid, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_SPEED_UP_RES, data, ...)
end
function cityCtrl:speedUpResRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if content.data.mode == BUILD_EXCHANGE_MODE.TOOLS then
			local itemID = content.data.toolid
			local msgNotice = include("msgNotice")
			_ENV = nil
			;(nil).itemID = itemID
			msgNotice.notice("notice_0053", nil)
		end
		_ENV = msgNotice.notice
		msgNotice.notice.name = gEventName.event_buff_update
		self:dispatchEvent(msgNotice.notice)
	else
	end
end
function cityCtrl:reqKipchaksInitReq()
	serverproxy:Request(gCmd.CMD_KIPCHAKS_MODULE, gCmd.REQ_KIPCHAKS_INIT_DATA)
end
function cityCtrl:reqKipchaksInitRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.kipchaksData = content.rspdata
	else
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_KIPCHAKS"
	;(nil).isUpdate = true
	SoraDSendMessage(nil)
end
function cityCtrl:reqKipchaksAttackReq(buildIndex, heroInfo, armsInfo, army)
	_ENV = nil
	;(nil).buildIndex = tonumber(buildIndex)
	;(nil).heroInfo = heroInfo
	;(nil).armsInfo = armsInfo
	local (nil).army, data = army, nil
	serverproxy:Request(gCmd.CMD_KIPCHAKS_MODULE, gCmd.REQ_KIPCHAKS_ATTACK, data)
end
function cityCtrl:reqKipchaksAttackRsp(content)
	local err = content.err
	local rspdata = content.rspdata
	if err == gErrDef.Err_None then
		local isWin = rspdata.win
		rspdata.battleReport.attackerDetail[1].survive = rspdata.battleReport.attackerDetail[1].survive + rspdata.battleReport.attackerDetail[1].lost
		rspdata.battleReport.attackerDetail[1].lost = 0
		SoraDDelayCallOnce("reqKipchaksAttackRsp" .. content.data.buildIndex, function()
			if isWin then
				SoraDPlaySound("epicControl", 5)
				local panel = SoraDCreatePanel("kipchaksWinPopView")
				panel:initData(rspdata)
				panel:show()
			else
				SoraDPlaySound("epicControl", 2)
				local panel = SoraDCreatePanel("kipchaksLostPopView")
				panel:initData(rspdata)
				panel:show()
			end
		end, 5.5)
		if isWin and self.kipchaksData.refreshNpc then
			self.kipchaksData.refreshNpc[tostring(content.data.buildIndex)] = nil
		end
		_ENV = tostring(content.data.buildIndex)
		tostring(content.data.buildIndex).msg = "MESSAGE_MAINCITYVIEW_UPDATE_KIPCHAKS"
		tostring(content.data.buildIndex).army = content.data.army
		tostring(content.data.buildIndex).isWin = rspdata.win
		tostring(content.data.buildIndex).buildIndex = content.data.buildIndex
		SoraDSendMessage((tostring(content.data.buildIndex)))
	else
	end
	SoraDCloseLoading()
end
function cityCtrl:sendPopCastleLv()
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_SET_CITY_UPGRADE_POP_LV)
end
function cityCtrl:sendLeftCanGetResByUid(uid)
	serverproxy = nil
	;(nil).uid = uid
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_LEFT_CAN_GET_RES, nil)
end
function cityCtrl:setUpgradePopLvRsp(rsp)
	dump(rsp, "cityCtrl:setUpgradePopLvRsp")
	if rsp and rsp.rspdata and rsp.rspdata.upgradePopLv then
		self.upgradePopLv = rsp.rspdata.upgradePopLv
	elseif rsp.err == gErrDef.Err_None then
		self.upgradePopLv = self:getCastleLevel()
	end
end
function cityCtrl:leftCanGetResRsp(content)
	local err = content.err
	local leftCanGetRes
	if err == gErrDef.Err_None then
		if not content.data then
			local _ENV, data = content.data, content.data
		end
		leftCanGetRes = data.leftCanGetRes
	elseif err == gErrDef.Err_UID_NOT_LEGAL then
	elseif err == gErrDef.Err_NOT_LESS_3_LV then
	end
	_ENV = nil
	;(nil).msg = "MESSAGE_MARKET_REQ_OTHERINFO_BACK"
	;(nil).err = err
	;(nil).leftCanGetRes = leftCanGetRes
	SoraDSendMessage(nil)
end
function cityCtrl:sendReqMasteryUnlock(mid)
	serverproxy = nil
	local (nil).mid, data = mid, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_UNLOCK_BUILD_MASTERY, data)
end
function cityCtrl:sendReqMasteryUpgrade(mid, operateMode)
	serverproxy = nil
	;(nil).mid = mid
	local (nil).mode, data = operateMode, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_UPGRADE_MASTERY_LEVEL, data)
end
function cityCtrl:sendReqMasteryStars(mid, buffID)
	serverproxy = nil
	;(nil).mid = mid
	local (nil).buff, data = buffID, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_UPGRADE_MASTERY_BUFF, data)
end
function cityCtrl:sendReqMasteryReset(mid)
	serverproxy = nil
	local (nil).mid, data = mid, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_RESET_MASTERY_STAR, data)
end
function cityCtrl:reqMasteryRsp(content)
	dump(content, "cityCtrl:reqMasteryRsp")
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		if data and data.mid and data.masteryInfo then
			local cityCell = self:getCurCity()
			cityCell:addMastery(data.mid, data.masteryInfo)
		end
		if gCmd.REQ_UPGRADE_MASTERY_LEVEL == content.subcmd then
			if OPERATE_MODE.IMMEDIATELY == data.mode then
				_ENV = data.mode
				data.mode.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
				data.mode.name = "upgrade"
				SoraDSendMessage(data.mode)
				local bid = specializationRead.getBuildID(data.mid)
				local buildEntity = cityBuildMgr:getBuildByBid(bid)
				buildEntity:showEffectUpgrade()
				return
			end
			local bid = specializationRead.getBuildID(data.mid)
			local curLev = self:getMasteryByMid(data.mid).lev
			_ENV = self
			self.optype = tostring(BUILD_OPERATE_TYPE.UPGRADE)
			self.mid = tostring(data.mid)
			self.bid = bid
			self.curLev = tostring(curLev)
			self.costtool, _ENV, self.costres, _ENV, self.ishelp = tostring(curLev), tostring(curLev), tostring(curLev), tostring(curLev), 0
			local data = self
			local starttime = serviceFunctions.systemTime()
			local buildLogic = include("buildLogic")
			local totaltime = specializationRead.getCondTime(bid, curLev + 1)
			totaltime = buildLogic.getMasteryUpgradeTime(totaltime)
			local ottime = totaltime
			local lefttime = math.max(0, totaltime)
			local qtype = gQueueTypeDef.build_mastery
			local queueCtrl = SoraDGetCtrl("queueCtrl")
			queueCtrl:addQueue(qtype, starttime, totaltime, lefttime, data)
			local queue = queueCtrl:queryQueue(qtype)
			if queue then
				queue.ottime = ottime
			end
			_ENV = qtype
			qtype.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_VIEW"
			SoraDSendMessage(qtype)
			_ENV = qtype
			qtype.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
			qtype.name = "upgrade"
			SoraDSendMessage(qtype)
		elseif gCmd.REQ_UNLOCK_BUILD_MASTERY == content.subcmd then
			local bid = specializationRead.getBuildID(data.mid)
			_ENV = self
			self.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
			self.name = "unlock"
			self.bid = bid
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_UPDATE_MASTERY_TOP_TIP"
			SoraDSendMessage(self)
		elseif gCmd.REQ_UPGRADE_MASTERY_BUFF == content.subcmd then
			_ENV = content.subcmd
			content.subcmd.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
			content.subcmd.name = "setStar"
			SoraDSendMessage(content.subcmd)
		elseif gCmd.REQ_RESET_MASTERY_STAR == content.subcmd then
			_ENV = content.subcmd
			content.subcmd.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
			content.subcmd.name = "reset"
			SoraDSendMessage(content.subcmd)
		end
	end
end
function cityCtrl:getMasteryByMid(mid)
	local cityCell = self:getCurCity()
	local mastery = cityCell:getBuildMasteryInfo()
	return mastery[tostring(mid)]
end
function cityCtrl:masteryQueueCallback(event)
	dump(event, "cityCtrl:masteryQueueCallback")
	_ENV = event
	event.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_VIEW"
	SoraDSendMessage(event)
	_ENV = event
	event.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
	event.name = "updateQueue"
	event.mid = event.data.mid
	SoraDSendMessage(event)
	local buildEntity = cityBuildMgr:getBuildByBid(event.data.bid)
	if buildEntity then
		buildEntity:showEffectUpgrade()
	end
end
function cityCtrl:getBuildMasteryEffect(effectType)
	local buildMasteryEffect
	local cityCell = self:getCurCity()
	local masteryInfoTotal = cityCell:getBuildMasteryInfo()
	for mid, value in pairs(masteryInfoTotal) do
		local buffLevel = value[tostring(effectType)]
		if buffLevel then
			local bid = specializationRead.getBuildID(tonumber(mid))
			local needBid = specializationRead.getCondBuildingID(bid)
			local needLv = specializationRead.getCondBuildingLv(bid, value.lev)
			if needLv <= self:getBuildMaxLv(needBid) then
				local addEffect = specializationRead.getMasteryBuffAdd(tonumber(mid), effectType, buffLevel)
				buildMasteryEffect = (buildMasteryEffect or 0) + addEffect
			end
		end
	end
	return buildMasteryEffect
end
function cityCtrl:sendReqMasteryDrawStart(costTime, costItems)
	serverproxy = nil
	;(nil).costTime = costTime
	local (nil).costItems, data = costItems, nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_START_DRAWING, data)
end
function cityCtrl:reqMasteryDrawStartRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data
		if data.drawingData then
			local cityCell = self:getCurCity()
			cityCell:setDrawingData(data.drawingData)
			local starttime = serviceFunctions.systemTime()
			local totaltime = data.costTime
			local ottime = totaltime
			local lefttime = math.max(0, totaltime)
			local qtype = gQueueTypeDef.construction_drawing
			_ENV = totaltime
			local totaltime.drawingData, data = data.drawingData, totaltime
			local queueCtrl = SoraDGetCtrl("queueCtrl")
			queueCtrl:addQueue(qtype, starttime, totaltime, lefttime, data)
			local queue = queueCtrl:queryQueue(qtype)
			if queue then
				queue.ottime = ottime
			end
		end
		_ENV = serviceFunctions.systemTime()
		serviceFunctions.systemTime().msg = "MESSAGE_UPDATE_MASTERY_DRAWING_VIEW"
		SoraDSendMessage((serviceFunctions.systemTime()))
	end
end
function cityCtrl:sendReqMasteryDrawReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CITY_MODULE, gCmd.REQ_RECEIVE_DRAWING_REWARD, nil)
end
function cityCtrl:reqMasteryDrawReceiveRsp(content)
	dump(content, "cityCtrl:reqMasteryDrawReceiveRsp")
	local err = content.err
	if err == gErrDef.Err_None then
		local cityCell = self:getCurCity()
		_ENV = nil
		cityCell:setDrawingData(nil)
		_ENV = cityCell
		cityCell.msg = "MESSAGE_UPDATE_MASTERY_DRAWING_VIEW"
		cityCell.reward = content.data.reward
		SoraDSendMessage(cityCell)
		_ENV = cityCell
		cityCell.msg = "MESSAGE_UPDATE_MASTERY_TOP_TIP"
		SoraDSendMessage(cityCell)
		if content.data.reward then
			SoraDMailGainItems(content.data.reward, true)
		end
	end
end
function cityCtrl:drawingQueueCallback(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_UPDATE_MASTERY_DRAWING_VIEW"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_UPDATE_MASTERY_TOP_TIP"
	SoraDSendMessage(nil)
end
function cityCtrl:checkMasteryDrawCanReceive(...)
	local cityCell = self:getCurCity()
	local drawingData = cityCell:getDrawingData()
	return drawingData and next(drawingData) and drawingData.canReceive
end
function cityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_city_notify = notifyCtrl:register(gNotifyID.CITY, handler(self, self.updateCityData))
	notifyCtrl:register(gNotifyID.NOTIFY_KIPCHAKS, handler(self, self.updateKipChaksData))
end
function cityCtrl:updateKipChaksData(event)
	dump(event.data, "cityCtrl:updateKipChaksData", 5)
	local data = event.data
	for k, v in pairs(data) do
		self.kipchaksData = v.data
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_MAINCITYVIEW_UPDATE_KIPCHAKS"
	pairs(data).isUpdate = true
	SoraDSendMessage(pairs(data))
end
function cityCtrl:updateCityData(event)
	local needSendMsg = false
	local data = event.data
	for k, v in pairs(data) do
		local costreslist = v.res
		if costreslist then
			self:updateResCount(costreslist)
			needSendMsg = true
		end
		local saferes = v.saferes
		if saferes then
			local curcity = self:getCurCity()
			curcity.saferes = saferes
		end
		local reslist = v.reslist
		if reslist then
			local curcity = self:getCurCity()
			curcity.resList = reslist
			needSendMsg = true
		end
		local dayMaxRes = v.dayMaxRes
		if dayMaxRes then
			local curcity = self:getCurCity()
			if curcity then
				curcity.dayMaxRes = dayMaxRes
			end
		end
		local demolishInfo = v.demolishInfo
		if demolishInfo then
			local curcity = self:getCurCity()
			if curcity then
				curcity.demolishInfo = demolishInfo
			end
		end
		local updateUnCollectRes = v.updateUnCollectRes
		if updateUnCollectRes then
			for index, count in pairs(updateUnCollectRes) do
				local bcell = self:getBuildCellByIndex(index)
				if bcell then
					local curres = tonumber(bcell.info.curres) + count
					bcell.info.curres = tostring(curres)
				end
			end
		end
		local openChargeQueue = v.openChargeQueue
		if openChargeQueue then
			local starttime = serviceFunctions.systemTime()
			local totaltime = openChargeQueue.totaltime
			local lefttime = openChargeQueue.lefttime
			local curcity = self:getCurCity()
			if curcity then
				curcity:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
				_ENV = curcity
				curcity.msg = "MESSAGE_BUILDER_OPEN"
				SoraDSendMessage(curcity, content)
				needSendMsg = true
			end
		end
		local maxRes = v.maxRes
		if maxRes then
			local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
			for i = 1, #maxRes / 2 do
				local mtype = maxRes[2 * i - 1]
				local resid = tonumber(maxRes[2 * i])
				local msgNotice = include("msgNotice")
				if mtype == 0 then
					local limitCount = self:getDailyResLimit(resid, gResSourceEnum.OTHER)
					local max = SoraDConvertNumberWithUnit(limitCount)
					if resid == gIDDef.GOLD then
						max = SoraDConvertNumberWithUnit(gConstValue.MAX_GOLD_COUNT)
					end
					scheduler.performWithDelayGlobal(function()
						msgNotice = nil
						;(nil).resourceID = resid
						;(nil).count = max
						msgNotice.notice("notice_0125", nil)
					end, 2)
				elseif mtype == 1 then
					do
						local max = SoraDConvertNumberWithUnit(self:getResMaxTotal())
						if resid == gIDDef.GOLD then
							max = SoraDConvertNumberWithUnit(gConstValue.MAX_GOLD_COUNT)
						end
						scheduler.performWithDelayGlobal(function()
							msgNotice = nil
							;(nil).resourceID = resid
							;(nil).count = max
							msgNotice.notice("notice_0124", nil)
						end, 2)
					end
				end
			end
		end
		local mastery = v.mastery
		if mastery then
			local curcity = self:getCurCity()
			curcity:addMastery(mastery.mid, mastery.data)
			_ENV = curcity
			curcity.msg = "MESSAGE_MASTERY_VIEW_REFRESH"
			curcity.mid = mastery.mid
			SoraDSendMessage(curcity)
		end
		if v.drawingData then
			local curcity = self:getCurCity()
			curcity:setDrawingData(v.drawingData)
		end
		if v.buildStatue then
			self:upgradeBuildStar(v.buildStatue.index)
			_ENV = self
			self.msg = "MESSAGE_BUILD_STAR_UPGRADE"
			SoraDSendMessage(self)
		end
		if v.itemRecycleTokenLv then
			local curcity = self:getCurCity()
			curcity.itemRecycleTokenLv = v.itemRecycleTokenLv
			_ENV = v.buildStatue.index
			v.buildStatue.index.msg = "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK"
			v.buildStatue.index.itemMap = v.itemRecycleTokenLv
			SoraDSendMessage(v.buildStatue.index)
		end
		if v.updateBuildInfo then
			local bcell = self:getBuildCellByIndex(v.updateBuildInfo.index)
			if bcell then
				for k, v in pairs(v.updateBuildInfo) do
					bcell.info[k] = v
				end
			end
			_ENV = pairs(v.updateBuildInfo)
			pairs(v.updateBuildInfo).msg = "MESSAGE_BUILD_INFO_UPGRADE"
			pairs(v.updateBuildInfo).buildInfo = v.updateBuildInfo
			SoraDSendMessage(pairs(v.updateBuildInfo))
			needSendMsg = true
		end
	end
	if needSendMsg then
		_ENV = pairs(data)
		pairs(data).msg = "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE"
		SoraDSendMessage(pairs(data))
	end
end
_ENV, cityCtrl.initClientData = function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end, function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end
;(function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end)[gIDDef.FOOD] = gIDDef.FOOD_SAFE
;(function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end)[gIDDef.WOOD] = gIDDef.WOOD_SAFE
;(function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end)[gIDDef.IRON] = gIDDef.IRON_SAFE
;(function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end)[gIDDef.MITHRIL] = gIDDef.MITHRIL_SAFE
;(function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end)[gIDDef.CRYSTAL] = gIDDef.CRYSTAL_SAFE
local _ENV, (function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end)[gIDDef.METEOR_CRYSTAL], resIDToSafeResIDMap = gIDDef.METEOR_CRYSTAL, gIDDef.METEOR_CRYSTAL_SAFE, function(self, data)
	local _citycell = cityCell.new()
	local cityinfo = data.cinfo
	local buildlist = data.blist
	for k, v in ipairs(buildlist) do
		local _buildcell = buildCell.new()
		v.binfo.starLv = v.binfo.starLv or 0
		_buildcell.info = v.binfo
		_citycell:addBuild(v.binfo.index, _buildcell)
	end
	_citycell.info = cityinfo
	_citycell.demolishInfo = data.demolishInfo
	_citycell.resList = data.reslist
	_citycell.areaList = data.arealist
	_citycell.dayMaxRes = data.dayMaxRes
	_citycell.saferes = data.saferes
	_citycell.mastery = data.mastery
	_citycell.itemRecycleTokenLv = data.itemRecycleTokenLv
	_citycell:setDrawingData(data.drawingData)
	self.upgradePopLv = data.upgradePopLv
	local buildchargequeue = data.queue[tostring(gQueueTypeDef.charge_build_queue)]
	if buildchargequeue then
		local starttime = buildchargequeue.starttime
		local totaltime = buildchargequeue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		_citycell:addBuildChargeQueue(gQueueTypeDef.charge_build_queue, starttime, totaltime, lefttime)
	end
	self:addCity(cityinfo.cid, _citycell)
	self:initCrystalMine()
	self:registerNotify()
	cityCell = self
	self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
	SoraDSendMessage(self)
end
gIDDef.METEOR_CRYSTAL[gIDDef.FOOD_SAFE] = gIDDef.FOOD
gIDDef.METEOR_CRYSTAL[gIDDef.WOOD_SAFE] = gIDDef.WOOD
gIDDef.METEOR_CRYSTAL[gIDDef.IRON_SAFE] = gIDDef.IRON
gIDDef.METEOR_CRYSTAL[gIDDef.MITHRIL_SAFE] = gIDDef.MITHRIL
gIDDef.METEOR_CRYSTAL[gIDDef.CRYSTAL_SAFE] = gIDDef.CRYSTAL
local gIDDef.METEOR_CRYSTAL[gIDDef.METEOR_CRYSTAL_SAFE], safeResIDToResIDMap = gIDDef.METEOR_CRYSTAL, gIDDef.METEOR_CRYSTAL
function cityCtrl:isSafeResID(id)
	local safeResID = tonumber(id)
	if safeResID and safeResIDToResIDMap[safeResID] then
		return true
	end
	return false
end
function cityCtrl:transformResIDToSafeResID(id)
	local resID = tonumber(id)
	if resID then
		return resIDToSafeResIDMap[resID]
	elseif safeResIDToResIDMap[resID] then
		return id
	end
end
function cityCtrl:transformSafeResIDToResID(id)
	local safeResID = tonumber(id)
	if safeResID then
		return safeResIDToResIDMap[safeResID]
	end
end
function cityCtrl:getCastleUpgradePopStatus()
	print("cityCtrl:getCastleUpgradePopStatus", self.upgradePopLv)
	if self.upgradePopLv ~= nil then
		local lv = self:getCastleLevel()
		return lv > self.upgradePopLv
	end
end
function cityCtrl:getItemRecycleToken(id)
	local curcity = self:getCurCity()
	local id = id or gIDDef.ITEM_RECYCLE_TOKEN
	return curcity.itemRecycleTokenLv and curcity.itemRecycleTokenLv[tostring(id)] or 0
end
function cityCtrl:getResCapacityByResID(resID)
	local ret = 0
	local cityltCtrl = include("cityltCtrl")
	local bid = BUILDID.DEPOT
	local blv = self:getBuildMaxLv(bid)
	local capacity = cityltCtrl.buildLvInfo(bid, blv, "capacity")
	if capacity and next(capacity) then
		local retMap = serviceFunctions.tableFormatToMap(capacity)
		ret = retMap[resID] or 0
	end
	local slv = self:getBuildMaxStarLv(bid)
	if 0 < slv then
		local capacity = cityltCtrl.buildStarLvInfo(bid, slv, "capacity")
		if capacity and next(capacity) then
			local retMap = serviceFunctions.tableFormatToMap(capacity)
			ret = ret + (retMap[resID] or 0)
		end
	end
	return ret
end
function cityCtrl:getBuffEffect(effectType)
	local buildlist = self:getBuildList()
	if not buildlist or not next(buildlist) then
		return 0
	end
	local cityltCtrl = include("cityltCtrl")
	local value = 0
	for k, bcell in pairs(buildlist) do
		local starLv = tonumber(bcell.info.starLv)
		if 0 < starLv then
			local bid = tonumber(bcell.info.bid)
			if not cityltCtrl.buildStarLvInfo(bid, starLv, "buff") then
				local _ENV, buff = cityltCtrl.buildStarLvInfo(bid, starLv, "buff"), cityltCtrl.buildStarLvInfo(bid, starLv, "buff")
			end
			for i = 1, #buff, 2 do
				if buff[i] == effectType then
					value = value + buff[i + 1] / 10
				end
			end
		end
	end
	return value
end
function cityCtrl:getCanUpgradeStarBuild(...)
	if not cityBuildMgr then
		cityBuildMgr = include("cityBuildMgr")
	end
	local _ENV, blist = include("cityBuildMgr"), include("cityBuildMgr")
	if not self:getBuildList() then
		local _ENV, buildlist = self:getBuildList(), self:getBuildList()
	end
	for k, bcell in pairs(buildlist) do
		local index = tonumber(bcell.info.index)
		local build = cityBuildMgr:getBuildByIndex(index)
		if build and build.isCanUpgradeStar then
			table.insert(blist, bcell)
		end
	end
	table.sort(blist, function(acell, bcell)
		local alv = tonumber(acell.info.starLv)
		local blv = tonumber(bcell.info.starLv)
		if alv ~= blv then
			return alv < blv
		end
		return tonumber(acell.info.bid) < tonumber(bcell.info.bid)
	end)
	local bcell = blist[1]
	if bcell then
		return tonumber(bcell.info.bid), tonumber(bcell.info.iid)
	end
end
function cityCtrl:getResMaxTotal()
	local constantRead = include("constantRead")
	if worldMapDefine.isInLegendLord() then
		return constantRead.getConstValue("RES_MAX_TOTAL_LEGEND", gConstValue.RES_MAX_TOTAL_IN_LEGEND)
	else
		return constantRead.getConstValue("RES_MAX_TOTAL", gConstValue.RES_MAX_TOTAL)
	end
end
return cityCtrl
