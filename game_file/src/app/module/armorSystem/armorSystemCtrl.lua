local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local armorSystemCtrl = class("armorSystemCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local msgCtrl = include("msgCtrl")
local armyDesRead = include("armyDesRead")
function armorSystemCtrl:ctor(properties)
	armorSystemCtrl.super.ctor(self, properties)
	self:resetData()
end
function armorSystemCtrl:EnterGame()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.armor_forging), handler(self, self.endQueueCallBack))
	msgCtrl.register(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_INIT, handler(self, self.reqArmorSystemInitRsp))
	msgCtrl.register(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_FORGING, handler(self, self.reqArmorSystemForgingRsp))
	msgCtrl.register(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_WEAR_ARMOR, handler(self, self.reqArmorSystemWearArmorRsp))
	msgCtrl.register(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_WEAR_ALL_ARMOR, handler(self, self.reqOneKeyWearArmorRsp))
	msgCtrl.register(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_EXCHANGE, handler(self, self.reqArmorExchangeRsp))
	msgCtrl.register(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SOLDIER_PROMOTION, handler(self, self.reqArmorPromotRsp))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
	self:registerNotify()
end
function armorSystemCtrl:newDay()
	local curTime = serviceFunctions.systemTime()
	if self.mothPromotionInfo and self.mothPromotionInfo.lastResetTime ~= 0 and not serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime) then
		_ENV = serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime)
		serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime).lastResetTime = curTime
		self.mothPromotionInfo, serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime).count = serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime), 0
	end
end
function armorSystemCtrl:Logout()
	armorSystemCtrl.super.Logout(self)
	self:resetData()
end
function armorSystemCtrl:initClientData(data)
	dump(data, "armorSystemCtrl:initClientData", 10)
	if not data then
		return
	end
	self.armorList = data.armorList
	self.exchangeInfo = data.exchangeInfo
	self.dailyGetArmorInfo = data.dailyGetArmorInfo
	if data.mothPromotionInfo then
		self.mothPromotionInfo = data.mothPromotionInfo
		local curTime = serviceFunctions.systemTime()
		if not serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime) then
			_ENV = serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime)
			serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime).lastResetTime = curTime
			self.mothPromotionInfo, serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime).count = serviceFunctions.isSameYearAndMonth(self.mothPromotionInfo.lastResetTime, curTime), 0
		end
	end
end
function armorSystemCtrl:resetData()
	_UPVALUE0_, self.exchangeInfo, _UPVALUE0_, self.armorList, _UPVALUE0_ = nil, nil, nil, nil, nil
	_UPVALUE0_, self.dailyGetArmorInfo, (nil).getArmorNum, _UPVALUE0_, (nil).lastResetTime = nil, nil, nil, nil, 0
	;(nil).lastResetTime = 0
	self.mothPromotionInfo, (nil).count = nil, 0
end
function armorSystemCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ARMOR_SYSTEM, handler(self, self.notifyHandler))
end
function armorSystemCtrl:notifyHandler(event)
	dump(event.data, "armorSystemCtrl:notifyHandler", 10)
	for _, v in ipairs(event.data) do
		if v.data.armorList then
			self.armorList = v.data.armorList
		end
		if v.data.exchangeInfo then
			self.exchangeInfo = v.data.exchangeInfo
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_EXCHANGE_BACK"
			SoraDSendMessage(nil)
		end
		if v.type == "forgingSuccess" then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_FORGING_SUCCESS"
			;(nil).armorId = v.data.armorId
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).num1 = string.formatnumberthousands(v.data.count)
			;(nil).name1 = armorSystemRead.getName(v.data.armorId)
			SoraDShowMsgTip(i18n("Soldiers_armor_text_52", nil))
		end
		_ENV = i18n("Soldiers_armor_text_52", nil)
		i18n("Soldiers_armor_text_52", nil).msg = "MESSAGE_MAINCITYVIEW_WARFRAME_NOTIFY"
		i18n("Soldiers_armor_text_52", nil).armorId = v.data.armorId
		SoraDSendMessage(i18n("Soldiers_armor_text_52", nil))
	end
end
function armorSystemCtrl:reqArmorSystemInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_INIT, nil)
end
function armorSystemCtrl:reqArmorSystemForging(data)
	serverproxy:Request(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_FORGING, data)
end
function armorSystemCtrl:reqArmorSystemWearArmor(data)
	serverproxy:Request(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_WEAR_ARMOR, data)
end
function armorSystemCtrl:reqOneKeyWearArmor(level)
	serverproxy = nil
	;(nil).level = level
	serverproxy:Request(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SYSTEM_WEAR_ALL_ARMOR, nil)
end
function armorSystemCtrl:reqArmorExchange(data)
	serverproxy:Request(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_EXCHANGE, data)
end
function armorSystemCtrl:reqArmorPromote(armyId, count, toArmyId)
	serverproxy = nil
	;(nil).armyId = armyId
	;(nil).count = count
	;(nil).toArmyId = toArmyId
	serverproxy:Request(gCmd.CMD_ARMOR_SYSTEM_MODULE, gCmd.REQ_ARMOR_SOLDIER_PROMOTION, nil)
end
function armorSystemCtrl:reqArmorSystemInitRsp(content)
	dump(content, "armorSystemCtrl:reqArmorSystemInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.exchangeInfo = content.rspdata.exchangeInfo
		self.armorList = content.rspdata.armorList
	end
end
function armorSystemCtrl:reqArmorSystemForgingRsp(content)
	dump(content, "armorSystemCtrl:reqArmorSystemForgingRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.data then
			local _ENV, data = content.data, content.data
		end
		if not content.rspdata then
			local _ENV, retdata = content.rspdata, content.rspdata
		end
		self.armorList = retdata.armorList
		local queueCtrl = SoraDGetCtrl("queueCtrl")
		local queuetype = gQueueTypeDef.armor_forging
		local totaltime = tonumber(retdata.leftTime)
		local lefttime = tonumber(retdata.leftTime)
		local starttime = content.time
		if 0 < lefttime then
			_ENV = nil
			;(nil).armorId = data.armorId
			;(nil).bid = tostring(BUILDID.STAR_BRAVE_STATUE)
			;(nil).count = data.num
			queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCell = cityCtrl:getBuildCell(tonumber(BUILDID.STAR_BRAVE_STATUE), 0)
			if nil ~= buildCell then
				_ENV = tonumber(BUILDID.STAR_BRAVE_STATUE)
				tonumber(BUILDID.STAR_BRAVE_STATUE).msg = "MESSAGE_BUILD_WORKING"
				tonumber(BUILDID.STAR_BRAVE_STATUE).buildID = tonumber(buildCell.info.index)
				tonumber(BUILDID.STAR_BRAVE_STATUE).buildCfgID = tonumber(BUILDID.STAR_BRAVE_STATUE)
				SoraDSendMessage((tonumber(BUILDID.STAR_BRAVE_STATUE)))
			end
		else
			_ENV = tonumber(BUILDID.STAR_BRAVE_STATUE)
			tonumber(BUILDID.STAR_BRAVE_STATUE).num1 = string.formatnumberthousands(data.num)
			tonumber(BUILDID.STAR_BRAVE_STATUE).name1 = armorSystemRead.getName(data.armorId)
			SoraDShowMsgTip(i18n("Soldiers_armor_text_52", (tonumber(BUILDID.STAR_BRAVE_STATUE))))
		end
	elseif content.err == gErrDef.Err_ARMOR_SYSTEM_DAILY_LIMIT then
		local armorId = content.data.armorId
		local info = armorSystemRead:getArmorRefSoldierInfo(armorId)
		_ENV = tonumber(retdata.leftTime)
		tonumber(retdata.leftTime).name = i18n(armorSystemRead:getProperty(armorId, "name"))
		tonumber(retdata.leftTime).num = string.formatnumberthousands(info.protection_limit)
		SoraDShowMsgTip(i18n("gilt_armor_text17", (tonumber(retdata.leftTime))))
	end
	_ENV = armorSystemRead:getArmorRefSoldierInfo(armorId)
	armorSystemRead:getArmorRefSoldierInfo(armorId).msg = "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK"
	armorSystemRead:getArmorRefSoldierInfo(armorId).armorId = content.data.armorId
	SoraDSendMessage((armorSystemRead:getArmorRefSoldierInfo(armorId)))
end
function armorSystemCtrl:reqArmorSystemWearArmorRsp(content)
	dump(content, "armorSystemCtrl:reqArmorSystemWearArmorRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, retdata = content.rspdata, content.rspdata
		end
		self.armorList = retdata.armorList
		local panel = SoraDCreatePanel("warframeGainSoldier")
		panel:show()
		panel:initData(retdata.num, retdata.newArmyId)
		_ENV = panel
		panel.msg = "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK"
		SoraDSendMessage(panel)
	end
end
function armorSystemCtrl:reqOneKeyWearArmorRsp(content)
	dump(content, "armorSystemCtrl:reqOneKeyWearArmorRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if not content.rspdata then
			local _ENV, retdata = content.rspdata, content.rspdata
		end
		self.armorList = retdata.armorList
		local strVar = ""
		local i = 0
		local totalNum = table.nums(retdata.armorUseInfo)
		for _, v in pairs(retdata.armorUseInfo) do
			strVar = strVar .. string.formatnumberthousands(v.wearNum) .. armyDesRead.getName(v.newArmyId)
			i = i + 1
			if i ~= totalNum then
				strVar = strVar .. ","
			end
		end
		if strVar ~= "" then
			_ENV = nil
			;(nil).var = strVar
			SoraDShowMsgTip(i18n("Soldiers_armor_text_25", nil))
		end
		_ENV = i18n("Soldiers_armor_text_25", nil)
		i18n("Soldiers_armor_text_25", nil).msg = "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK"
		SoraDSendMessage(i18n("Soldiers_armor_text_25", nil))
	end
end
function armorSystemCtrl:reqArmorExchangeRsp(content)
	dump(content, "armorSystemCtrl:reqArmorExchangeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.exchangeInfo = content.rspdata.data.exchangeInfo
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_EXCHANGE_BACK"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function armorSystemCtrl:reqArmorPromotRsp(content)
	dump(content, "armorSystemCtrl:reqArmorPromotRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.armorList = content.rspdata.data.armorList
		self.dailyGetArmorInfo = content.rspdata.data.dailyGetArmorInfo
		self.mothPromotionInfo = content.rspdata.data.mothPromotionInfo
		_ENV = 10
		;(10).toArmyId = content.data.toArmyId
		;(10).armyId = content.data.armyId
		;(10).count = content.data.count
		uiManager:show("soldiersPromoteTSuccess", 10)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_WARFRAME_PROMOTE_BACK"
		uiManager.armorId = content.data.armyId
		SoraDSendMessage(uiManager)
	end
end
function armorSystemCtrl:endQueueCallBack(event)
	dump(event, "armorSystemCtrl:endQueueCallBack")
	local eventname = event.name
	local data = event.data
	local optype = tonumber(data.optype)
	local isCancel = false
	if optype == QUEUE_OPERATE_TYPE.CANCLE then
		isCancel = true
		local msgNotice = include("msgNotice")
		msgNotice.notice("notice_0178", nil, gNoticeIconTypeDef.ICON_NORMAL, "#btn_armor_forging.png")
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCell(tonumber(BUILDID.STAR_BRAVE_STATUE), 0)
	if nil ~= buildCell then
		local buildIndex = tonumber(buildCell.info.index)
		if tonumber(buildCell.info.state) == BUILD_STATE.NORMAL then
			_ENV = BUILD_STATE.NORMAL
			BUILD_STATE.NORMAL.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
			BUILD_STATE.NORMAL.buildIndex = buildIndex
			BUILD_STATE.NORMAL.isCancel = isCancel
			SoraDSendMessage(BUILD_STATE.NORMAL)
		end
	end
	_ENV = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
	SoraDSendMessage.bid = BUILDID.STAR_BRAVE_STATUE
	SoraDSendMessage(SoraDSendMessage)
end
function armorSystemCtrl:getArmorNumByID(armorId)
	dump(self.armorList, "armorList")
	print("armorId", armorId)
	return self.armorList[tostring(armorId)] or 0
end
function armorSystemCtrl:getArmyNumByArmorId(armorId, lv)
	lv = lv or 12
	local soldierNum = 0
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	print("armorId", armorId)
	local armyType = armorSystemRead:getProperty(tonumber(armorId), "armyType")
	if armyType then
		soldierNum = armyCtrl:getArmyCountByLv(armyType, lv)
	end
	return soldierNum
end
function armorSystemCtrl:getArmyIdByArmorId(armorId, lv)
	lv = lv or 12
	local _ENV, trainList
	local armyLogic = include("armyLogic")
	local barrackID = armorSystemRead:getProperty(tonumber(armorId), "barrackID")
	if barrackID then
		trainList = armyLogic.getCanTrainList(barrackID)
	end
	return trainList[lv] and trainList[lv].armyid
end
function armorSystemCtrl:getArmyIdByArmorIdEx(armorId, lv)
	local armyLogic = include("armyLogic")
	lv = lv or 12
	local barrackID = armorSystemRead:getProperty(tonumber(armorId), "barrackID")
	local armyid = armyLogic.getArmyIdByLevelAndBid(barrackID, lv, 10, 70)
	return armyid
end
local MAX_BAG_CAPACITY = 40
function armorSystemCtrl:getArmorBagList()
	local _ENV, list
	local _ENV, tmpList
	for armorId, _ in pairs(self.armorList) do
		table.insert(tmpList, armorId)
	end
	table.sort(tmpList, function(l, r)
		return l < r
	end)
	for _, armorId in ipairs(tmpList) do
		local limitCount = 9999
		local totalCount = self.armorList[armorId]
		while 0 < totalCount and table.nums(list) < MAX_BAG_CAPACITY do
			local itemCount = 0 < totalCount - limitCount and limitCount or totalCount
			_ENV = nil
			;(nil).armorId = armorId
			;(nil).count = itemCount
			table.insert(list, nil)
			totalCount = totalCount - itemCount
		end
	end
	return list
end
function armorSystemCtrl:getArmorForgingCostRes(armorId)
	local _ENV, retCostRes
	local technologyCtrl = SoraDGetCtrl("technologyCtrl")
	local armorForgingResReduce = technologyCtrl:getTechnologyPower(armorSystemRead:getProperty(armorId, "resTechnology")) or 0
	local armorForgingConsumeAddTime = technologyCtrl:getTechnologyPower(armorSystemRead:getProperty(armorId, "consumeTechnology")) or 0
	local armorForgingCrystalReduce = technologyCtrl:getTechnologyPower(armorSystemRead:getProperty(armorId, "crystalTechnology")) or 0
	for k, v in ipairs(armorSystemRead:getProperty(armorId, "costRes")) do
		local count = 0
		if v.id == gIDDef.FOOD or v.id == gIDDef.WOOD or v.id == gIDDef.IRON or v.id == gIDDef.MITHRIL then
			count = v.count * (1 - armorForgingResReduce - armorForgingConsumeAddTime)
		elseif v.id == gIDDef.CRYSTAL then
			count = v.count * (1 - armorForgingCrystalReduce - armorForgingConsumeAddTime)
		else
			count = v.count
		end
		if count < 0 then
			count = 0
		end
		_ENV = armorSystemRead:getProperty(armorId, "costRes")
		armorSystemRead:getProperty(armorId, "costRes").id = v.id
		armorSystemRead:getProperty(armorId, "costRes").count = count
		table.insert(retCostRes, armorSystemRead:getProperty(armorId, "costRes"))
	end
	print("armorSystemCtrl:getArmorForgingCostRes", armorId, armorForgingResReduce, armorForgingConsumeAddTime, armorForgingCrystalReduce)
	return retCostRes
end
function armorSystemCtrl:getArmorForgTime(armorId)
	local buildLogic = include("buildLogic")
	local forgingTime = armorSystemRead:getProperty(tonumber(armorId), "forgingTime") or 0
	return forgingTime * buildLogic.getArmorForgingSpeedAdd(armorId)
end
function armorSystemCtrl:getCurExchangeNum(shopItemID)
	return self.exchangeInfo and self.exchangeInfo.exchangeList and self.exchangeInfo.exchangeList[tostring(shopItemID)] or 0
end
function armorSystemCtrl:getDailyGetArmorNum(armorId)
	return self.dailyGetArmorInfo.getArmorNum[tostring(armorId)] or 0
end
function armorSystemCtrl:getMothyGetArmorNum()
	return self.mothPromotionInfo and self.mothPromotionInfo.count or 0
end
function armorSystemCtrl:getMothyPromoteNum()
	local limitTechNum = SoraDGetCtrl("technologyCtrl"):getTechnologyPower(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM) or 0
	return math.max(0, limitTechNum - self:getMothyGetArmorNum())
end
return armorSystemCtrl
