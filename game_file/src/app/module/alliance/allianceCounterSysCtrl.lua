local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceCounterSysCtrl = class("allianceCounterSysCtrl", gameModule)
function allianceCounterSysCtrl:ctor(properties)
	allianceCounterSysCtrl.super.ctor(self, properties)
	self:resetData()
end
function allianceCounterSysCtrl:resetData()
	self.allianceListData, _UPVALUE0_ = nil, nil
	self.canUpdateList, (nil)[2], _UPVALUE0_, (nil)[1], _UPVALUE0_, _UPVALUE0_, self.readList, _UPVALUE0_, self.ownListData = nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function allianceCounterSysCtrl:Logout()
	allianceCounterSysCtrl.super.Logout(self)
	self.handle_chat_notify = nil
	self:resetData()
end
function allianceCounterSysCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_INIT, handler(self, self.getDataRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_ALLIANCE_ENEMY_INFO, handler(self, self.getAllianceEnemyInfoRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_COUNTER_RECORD, handler(self, self.getCounterRecordRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_ADD_PERSONAL_ENEMY, handler(self, self.addPersonalEnemyRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_DEL_PERSONAL_ENEMY, handler(self, self.delPersonalEnemyRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_TOP_PERSONAL_ENEMY, handler(self, self.topPersonalEnemyRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_PERSONAL_ENEMY_LIST, handler(self, self.getOwnDataRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_UPDATA_COORDINATE, handler(self, self.updateEnemyPosRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_SEND_ALLIANCE_HELP, handler(self, self.getSendAllianceHelpRsp))
	msgCtrl.register(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_ENEMY_SEARCH, handler(self, self.getEnemyPosRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.COUNTER_SYSTEM, handler(self, self.notifyData))
	self:initData()
	self:getOwnData()
end
function allianceCounterSysCtrl:notifyData(rep)
	dump(rep.data, "allianceCounterSysCtrl:notifyData", 10)
	for i, v in ipairs(rep.data) do
		self:initAllianceData(v.data)
	end
	_ENV = ipairs(rep.data)
	ipairs(rep.data).msg = "MESSAGE_GREEN_POINT_UPDATE"
	ipairs(rep.data).type = GREEN_POINT_NOTICE_TYPE.COUNTER_SYS
	SoraDSendMessage(ipairs(rep.data))
end
function allianceCounterSysCtrl:initData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_INIT, nil)
end
function allianceCounterSysCtrl:getAllianceEnemyInfoReq(uid)
	print("uid", uid)
	_ENV = nil
	;(nil).enemyId = uid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_ALLIANCE_ENEMY_INFO, nil)
end
function allianceCounterSysCtrl:getCounterRecord(uid)
	serverproxy = nil
	;(nil).enemyId = uid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_COUNTER_RECORD, nil)
end
function allianceCounterSysCtrl:getSendAllianceHelp(uid)
	serverproxy = nil
	;(nil).enemyId = uid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_SEND_ALLIANCE_HELP, nil)
end
function allianceCounterSysCtrl:updateEnemyPos(uid, enemyType, coordinate)
	serverproxy = nil
	;(nil).enemyType = enemyType == 1 and 2 or 1
	;(nil).enemyId = uid
	;(nil).coordinate = coordinate
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_UPDATA_COORDINATE, nil)
end
function allianceCounterSysCtrl:updateEnemyPosRsp(data)
	dump(data, "allianceCounterSysCtrl:updateEnemyRsp", 10)
	if data.err == gErrDef.Err_None then
		for i, v in ipairs(self.ownListData) do
			if v.uid == data.data.enemyId then
				self.ownListData[i].coordinate = data.data.coordinate
				_ENV = data.data.coordinate
				data.data.coordinate.msg = "MESSAGE_ALLIANCE_COUNTER_OWN_REFRESH"
				SoraDSendMessage(data.data.coordinate)
				break
			end
		end
		if self.allianceListData[tostring(data.data.enemyId)] then
			self.allianceListData[tostring(data.data.enemyId)].coordinate = data.data.coordinate
			_ENV = data.data.coordinate
			data.data.coordinate.msg = "MESSAGE_GREEN_POINT_UPDATE"
			data.data.coordinate.type = GREEN_POINT_NOTICE_TYPE.COUNTER_SYS
			SoraDSendMessage(data.data.coordinate)
		end
		SoraDShowMsgTip(i18n("CounterSystem_text_11"))
		self:getUpdateList()
	end
end
function allianceCounterSysCtrl:getEnemyPos(uid)
	serverproxy = nil
	;(nil).enemyId = uid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_ENEMY_SEARCH, nil)
end
function allianceCounterSysCtrl:getEnemyPosRsp(data)
	dump(data, "allianceCounterSysCtrl:getEnemyPosRsp", 10)
	if data.err == gErrDef.Err_None then
		if data.rspdata.isFindEnemy then
			SoraDGotoWorldMapPoint(data.rspdata.coordinate, true)
			SoraDRemoveAllPanelFromManager()
		elseif data.rspdata.alliancePalacePos then
			SoraDShowMsgBox(i18n("CounterSystem_text_05"), i18n("common_text_204"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					SoraDGotoWorldMapPoint(data.rspdata.alliancePalacePos, true)
					SoraDRemoveAllPanelFromManager()
				end
			end)
		else
			SoraDGotoWorldMapPoint(data.rspdata.coordinate, true)
			SoraDRemoveAllPanelFromManager()
		end
	end
	SoraDCloseLoading()
end
function allianceCounterSysCtrl:getSendAllianceHelpRsp(data)
	if data.err == gErrDef.Err_None then
	end
end
function allianceCounterSysCtrl:getAllianceEnemyInfoRsp(data)
	if data.err == gErrDef.Err_None then
		self:updateAllianceData(data.rspdata)
	end
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_COUNTER_ENEMY_INFO"
	self.enemyData = data.rspdata
	SoraDSendMessage(self)
end
function allianceCounterSysCtrl:topPersonalEnemy(uid)
	serverproxy = nil
	;(nil).enemyId = uid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_TOP_PERSONAL_ENEMY, nil)
end
function allianceCounterSysCtrl:delPersonalEnemy(uid)
	serverproxy = nil
	;(nil).enemyId = uid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_DEL_PERSONAL_ENEMY, nil)
end
function allianceCounterSysCtrl:addPersonalEnemy(mid)
	serverproxy = nil
	;(nil).mid = mid
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_ADD_PERSONAL_ENEMY, nil)
end
function allianceCounterSysCtrl:delPersonalEnemyRsp(data)
	dump(data, "allianceCounterSysCtrl:delPersonalEnemyRsp", 10)
	if data.err == gErrDef.Err_None then
		if self.ownListData then
			for i, v in ipairs(self.ownListData) do
				if v.uid == data.data.enemyId then
					table.remove(self.ownListData, i)
					break
				end
			end
		end
		SoraDShowMsgTip(i18n("CounterSystem_text_10"))
		_ENV = i18n("CounterSystem_text_10")
		i18n("CounterSystem_text_10").msg = "MESSAGE_ALLIANCE_COUNTER_OWN_REFRESH"
		SoraDSendMessage(i18n("CounterSystem_text_10"))
	end
	SoraDCloseLoading()
end
function allianceCounterSysCtrl:topPersonalEnemyRsp(data)
	if data.err == gErrDef.Err_None then
		if self.ownListData then
			for i, v in ipairs(self.ownListData) do
				if v.uid == data.data.enemyId then
					self.ownListData[i].isTop = not self.ownListData[i].isTop
					break
				end
			end
		end
		_ENV = ipairs(self.ownListData)
		ipairs(self.ownListData).msg = "MESSAGE_ALLIANCE_COUNTER_OWN_REFRESH"
		SoraDSendMessage(ipairs(self.ownListData))
	end
	SoraDCloseLoading()
end
function allianceCounterSysCtrl:addPersonalEnemyRsp(data)
	dump(data, "allianceCounterSysCtrl:addPersonalEnemyRsp", 10)
	if data.err == gErrDef.Err_None then
		self.ownListData = data.rspdata
		SoraDShowMsgTip(i18n("CounterSystem_text_09"))
	end
	SoraDCloseLoading()
end
function allianceCounterSysCtrl:getCounterRecordRsp(data)
	dump(data, "allianceCounterSysCtrl:getCounterRecordRsp", 10)
	if data.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_COUNTER_RECORD_INFO"
		gErrDef.Err_None.enemyData = data.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function allianceCounterSysCtrl:getOwnData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_COUNTER_SYSTEM_MODULE, gCmd.REQ_COUNTER_SYSTEM_PERSONAL_ENEMY_LIST, nil)
end
function allianceCounterSysCtrl:getDataRsp(data)
	dump(data, "allianceCounterSysCtrl:initClientData", 10)
	if data.err == gErrDef.Err_None then
		self:initAllianceData(data.rspdata)
	end
end
function allianceCounterSysCtrl:getOwnDataRsp(data)
	if data.err == gErrDef.Err_None then
		self:initOwnData(data.rspdata)
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_COUNTER_OWN_REFRESH"
		SoraDSendMessage(self)
	end
end
function allianceCounterSysCtrl:initOwnData(data)
	self.ownListData = data
end
function allianceCounterSysCtrl:updateAllianceData(data)
	for k, v in pairs(self.allianceListData) do
		if tonumber(k) == tonumber(data.uid) then
			self.allianceListData[k] = data
			break
		end
	end
end
function allianceCounterSysCtrl:initAllianceData(data)
	self.allianceListData = data
end
function allianceCounterSysCtrl:getAllianceList()
	local _ENV, ret
	for k, v in pairs(self.allianceListData) do
		table.insert(ret, v)
	end
	table.sort(ret, function(l, r)
		return l.hostile > r.hostile
	end)
	return ret
end
function allianceCounterSysCtrl:getOwnList(needGet)
	if self.ownListData == nil or needGet then
		self:getOwnData()
	end
	if self.ownListData then
		local _ENV, ret = self.ownListData, self.ownListData
		for k, v in pairs(self.ownListData) do
			table.insert(ret, v)
		end
		table.sort(ret, function(l, r)
			if l.isTop ~= r.isTop then
				return l.isTop
			else
				return l.hostile > r.hostile
			end
		end)
		return ret
	end
end
function allianceCounterSysCtrl:checkOwnEnemy(uid)
	if uid then
		uid = tonumber(uid)
		if self.ownListData then
			for i, v in ipairs(self.ownListData) do
				if v.uid == uid then
					return true
				end
			end
		end
	end
	return false
end
function allianceCounterSysCtrl:checkAllianceEnemy(uid)
	if uid then
		uid = tostring(uid)
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		if self.allianceListData[uid] and not memberMgr:getMember(uid) then
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			if worldMapDefine.checkCurrentKingdomIsMyKingdom() and not worldMapDefine.isInWar() and not conquestWarCtrl:isPlayerConquestWarMigration() and worldMapDefine.kingWarStatus ~= gKingdomWarStatusType.inWar then
				return true
			end
		end
	end
	return false
end
function allianceCounterSysCtrl:getAllianceEnemyInfo(uid)
	if uid then
		uid = tostring(uid)
		if self.allianceListData[uid] then
			return self.allianceListData[uid]
		end
	end
	return nil
end
function allianceCounterSysCtrl:getMapTipButtonName(tipButtonType, mapInstance, buttonName)
	_ENV = nil
	;(nil)[worldMapDefine.worldMapTipButtonType_gongJi] = "CounterSystem_btn_01"
	local _ENV, (nil)[worldMapDefine.worldMapTipButtonType_xuanZhan], tipName = worldMapDefine.worldMapTipButtonType_xuanZhan, "CounterSystem_btn_02", nil
	worldMapDefine.worldMapTipButtonType_xuanZhan[gMapObjTypeDef.mapObjTypeResource] = true
	worldMapDefine.worldMapTipButtonType_xuanZhan[gMapObjTypeDef.mapObjTypeCampsite] = true
	local worldMapDefine.worldMapTipButtonType_xuanZhan[gMapObjTypeDef.mapObjTypePlayer], instanceType = true, worldMapDefine.worldMapTipButtonType_xuanZhan
	local strKey = tipName[tipButtonType]
	if strKey == nil then
		return buttonName
	end
	if mapInstance == nil or mapInstance.playerID == nil or mapInstance.playerID == 0 or not instanceType[mapInstance:getInstanceType()] then
		return buttonName
	end
	if self:checkAllianceEnemy(mapInstance.playerID) then
		return i18n(strKey)
	end
	return buttonName
end
function allianceCounterSysCtrl:getTipButtonImageName(tipButtonType, mapInstance, spriteName)
	_ENV = nil
	;(nil)[worldMapDefine.worldMapTipButtonType_gongJi] = "icon_map_operate_02_01.png"
	local _ENV, (nil)[worldMapDefine.worldMapTipButtonType_xuanZhan], tipName = worldMapDefine.worldMapTipButtonType_xuanZhan, "icon_map_operate_09_01.png", nil
	worldMapDefine.worldMapTipButtonType_xuanZhan[gMapObjTypeDef.mapObjTypeResource] = true
	worldMapDefine.worldMapTipButtonType_xuanZhan[gMapObjTypeDef.mapObjTypeCampsite] = true
	local worldMapDefine.worldMapTipButtonType_xuanZhan[gMapObjTypeDef.mapObjTypePlayer], instanceType = true, worldMapDefine.worldMapTipButtonType_xuanZhan
	local strKey = tipName[tipButtonType]
	if strKey == nil then
		return spriteName
	end
	if mapInstance == nil or mapInstance.playerID == nil or mapInstance.playerID == 0 or not instanceType[mapInstance:getInstanceType()] then
		return spriteName
	end
	if self:checkAllianceEnemy(mapInstance.playerID) then
		return i18n(strKey)
	end
	return spriteName
end
function allianceCounterSysCtrl:getNewPoint()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	gametop = nil
	;(nil).byUID = true
	local lastLogoutTime = SoraDConfigGet("Game:allianceCounterSys:readTime~integer", nil)
	if lastLogoutTime == 0 then
		lastLogoutTime = lordInfoCtrl:getLordInfo().onlineInfo.lastLogoutTime
		gametop = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:allianceCounterSys:readTime~integer", lastLogoutTime, nil)
	end
	local ret = 0
	print("lastLogoutTime", lastLogoutTime)
	for k, v in pairs(self.allianceListData) do
		if self.readList[k] == nil then
			if lastLogoutTime < v.time then
				ret = ret + 1
			end
		elseif v.time > self.readList[k] then
			ret = ret + 1
		end
	end
	return ret
end
function allianceCounterSysCtrl:checkNewPoint(uid)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	gametop = nil
	;(nil).byUID = true
	local lastLogoutTime = SoraDConfigGet("Game:allianceCounterSys:readTime~integer", nil)
	if lastLogoutTime == 0 then
		lastLogoutTime = lordInfoCtrl:getLordInfo().onlineInfo.lastLogoutTime
		gametop = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:allianceCounterSys:readTime~integer", lastLogoutTime, nil)
	end
	local ret = 0
	uid = tostring(uid)
	for k, v in pairs(self.allianceListData) do
		if uid == k then
			if self.readList[k] == nil then
				if lastLogoutTime < v.time then
					return true
				end
			elseif v.time > self.readList[k] then
				return true
			end
			return false
		end
	end
	return false
end
function allianceCounterSysCtrl:readPointByUid(uid)
	self.readList[tostring(uid)] = serviceFunctions.systemTime()
	_ENV = tostring(uid)
	tostring(uid).msg = "MESSAGE_GREEN_POINT_UPDATE"
	tostring(uid).justPoint = true
	tostring(uid).type = GREEN_POINT_NOTICE_TYPE.COUNTER_SYS
	SoraDSendMessage((tostring(uid)))
end
function allianceCounterSysCtrl:readNewPoint()
	self.readList, _ENV = nil, nil
	local time = serviceFunctions.systemTime()
	for k, v in pairs(self.allianceListData) do
		self.readList[k] = time
	end
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:allianceCounterSys:readTime~integer", time, nil)
	_ENV = "Game:allianceCounterSys:readTime~integer"
	;("Game:allianceCounterSys:readTime~integer").msg = "MESSAGE_GREEN_POINT_UPDATE"
	;("Game:allianceCounterSys:readTime~integer").type = GREEN_POINT_NOTICE_TYPE.COUNTER_SYS
	SoraDSendMessage("Game:allianceCounterSys:readTime~integer")
end
function allianceCounterSysCtrl:getUpdateList()
	self.canUpdateList, (nil)[2], _ENV, (nil)[1], _ENV, _ENV = nil, nil, nil, nil, nil, nil
	local scene = SoraDCurrentSceneShowView("worldMapView")
	if scene then
		local curPos = scene.currentInMapViewCell:tilePositionFromLocation(cc.p(0, 110))
		local curSize = scene.currentInMapViewCell:tilePositionFromLocation(cc.p(display.width - 1, display.height - 90))
		local curRect = cc.rect(curSize.x, curSize.y, curPos.x - curSize.x, curPos.y - curSize.y)
		for k, v in pairs(scene:getShowTilesArray()) do
			local pos = SoraDStringSplit(k, ",")
			pos[1] = tonumber(pos[1])
			pos[2] = tonumber(pos[2])
			if cc.rectContainsPoint(curRect, cc.p(pos[1], pos[2])) and v:getInstanceType() == gMapObjTypeDef.mapObjTypePlayer and v.playerID and v.playerID ~= 0 then
				if self:checkOwnEnemy(v.playerID) then
					self.canUpdateList[2][tostring(v.playerID)] = v.tilePoint
				end
				if self:checkAllianceEnemy(v.playerID) then
					self.canUpdateList[1][tostring(v.playerID)] = v.tilePoint
				end
			end
		end
	end
end
function allianceCounterSysCtrl:checkCanUpdate(uid, type)
	return self.canUpdateList[type][tostring(uid)]
end
return allianceCounterSysCtrl
