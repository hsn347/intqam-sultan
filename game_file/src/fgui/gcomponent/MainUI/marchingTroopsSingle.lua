local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local autokillCtrl = gametop.playertop_:getModule("autokillCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local mailFunctions = include("mailFunctions")
local armyltCtrl = include("armyltCtrl")
local worldMapDefine = include("worldMapDefine")
local mapObjUtil = include("mapObjUtil")
local baseComponent = require("fgui.base.baseComponent")
local marchingTroopsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/marchingTroopsSingle", marchingTroopsSingle)
function marchingTroopsSingle:onInit()
	self.tableTroop, _ENV = nil, nil
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeUpdateListener(handler(self, self.updateTroopBar))
	self.Text_time:setTimeEndListener(handler(self, self.updateTimeEnd))
	self.fields.Button_troops:addClickListener(handler(self, self.OnBtnTroopsClick))
	self.fields.Button_jump:addClickListener(handler(self, self.OnBtnJumpClick))
	self.fields.Button_setting:addClickListener(handler(self, self.OnBtnSettingClick))
	self:fixChildrenPos()
	self.fields.n0:fix()
	self.fields.Bar_et:setScaleX(SoraDFIsRA() and 1 or -1)
end
function marchingTroopsSingle:onShow()
end
function marchingTroopsSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function marchingTroopsSingle:serverMessage_RequestMapInstaceInfo(target, data)
	if not data.data then
		return
	end
	SoraDCloseLoading(self)
	if data.data.data and data.data.mapType == gMapObjTypeDef.mapTypeRamadanFeast then
		local feastPopPanel = SoraDSearchPanelFromManagerByName("getTogertherFeastPopView")
		if feastPopPanel then
			feastPopPanel:initData(data.data.data.feastData, self.tableTroop:getToId())
			return
		end
		local panel = SoraDCreatePanel("getTogertherFeastPopView")
		panel:initData(data.data.data.feastData, self.tableTroop:getToId())
		panel:show()
	end
end
function marchingTroopsSingle:initAutoKill()
	self.isAutoKill = true
	self:showQueue(false)
	self:initAutoKillEffect(2)
	self.fields.Button_setting:setVisible(false)
	self:updateAutoKill()
end
function marchingTroopsSingle:updateAutoKill(isFull)
	if isFull then
		self.fields.Text_state:setString(i18n("automatic_text_24"))
	else
		self.fields.Text_state:setString(i18n("automatic_text_13"))
	end
end
function marchingTroopsSingle:initData(troopData)
	self.tableTroop = troopData
	dump(self.tableTroop, "self.tableTroop===", 10)
	if not self.tableTroop.autoAttack then
		self.isAutoKill = false
		self.controllers.c1:setSelectedIndex(0)
	end
	self.moveLineType = self.tableTroop:getMoveLineType()
	self.targetObjType = self.tableTroop:getToMapType()
	self.eventType = self.tableTroop:getEventType()
	self:updateData()
	self:initSoldierClassIcon()
end
function marchingTroopsSingle:updateData()
	self.fields.Button_troops:setBright(true)
	self.fields.Button_setting:setVisible(self.tableTroop:isShowSpeedSetting())
	local targetObjType = self.targetObjType
	local moveLineType = self.moveLineType
	print("==MarchingTroopsSingle:updateData==", self.tableTroop:isShowSpeedSetting(), self.eventType, self.moveLineType, self.targetObjType, self.tableTroop.moveLineModel)
	local btnIcon
	self.fields.Bar_et:setIconIndex(0)
	if self.eventType == gMapEventTypeDef.mapEventTypeMapInstance then
		btnIcon = "img_xingjunduilie_black.png"
		if targetObjType == gMapObjTypeDef.mapObjTypePlayer then
			if moveLineType == gMapMoveLineType.moveLineTypeArmyHelp then
				self.fields.Text_state:setString(i18n("common_text_010"))
				self.Text_time:setString(tostring(self.tableTroop:getToX()) .. "," .. tostring(self.tableTroop:getToY()))
				self:showQueue(false)
			elseif moveLineType == gMapMoveLineType.moveLineTypeMass then
				btnIcon = "img_xingjunduilie_chakan.png"
				self.fields.Text_state:setString(i18n("common_text_299"))
				self:showQueue(true)
			elseif moveLineType == gMapMoveLineType.moveLineTypeEscortHelp then
				self.fields.Text_state:setString(i18n("common_text_2470"))
				self.fields.Button_troops:setColor(cc.c3b(100, 100, 100))
				self:showQueue(true)
			end
		elseif targetObjType == gMapObjTypeDef.mapObjTypeResource or targetObjType == gMapObjTypeDef.mapTypeFireTreasure or targetObjType == gMapObjTypeDef.mapTypeRadianceWarResource or targetObjType == gMapObjTypeDef.mapTypeWarTreasure or targetObjType == gMapObjTypeDef.nebulaWarMine then
			self.fields.Text_state:setString(i18n("common_text_830"))
			self:showQueue(true)
		elseif targetObjType == gMapObjTypeDef.mapObjTypeTreasure then
			self.fields.Text_state:setString(i18n("common_text_1647"))
			self:showQueue(true)
		elseif targetObjType == gMapObjTypeDef.mapObjTypeRelics then
			self.fields.Text_state:setString(i18n("common_text_831"))
			self:showQueue(true)
		elseif targetObjType == gMapObjTypeDef.desertMeteorite then
			self.fields.Text_state:setString(i18n("pickup_star_014"))
			self:showQueue(true)
		elseif targetObjType == gMapObjTypeDef.mapObjTypeCampsite then
			self.fields.Text_state:setString(i18n("common_text_832"))
			self.Text_time:setString(tostring(self.tableTroop:getToX()) .. "," .. tostring(self.tableTroop:getToY()))
			self:showQueue(false)
		elseif targetObjType == gMapObjTypeDef.mapObjTypeKingdomLevelBuild then
			self.fields.Text_state:setString(i18n("common_text_010"))
			self.Text_time:setString(tostring(self.tableTroop:getToX()) .. "," .. tostring(self.tableTroop:getToY()))
			self:showQueue(false)
		elseif targetObjType == gMapObjTypeDef.mapObjTypeCastale or targetObjType == gMapObjTypeDef.mapObjTypeBattery or targetObjType == gMapObjTypeDef.mapTypeATBuilding or targetObjType == gMapObjTypeDef.mapObjTypeBoss or targetObjType == gMapObjTypeDef.mapTypeHeroBattleBoss1 or targetObjType == gMapObjTypeDef.mapTypeHeroBattleBoss2 or targetObjType == gMapObjTypeDef.mapObjTypeBattlefieldSite or targetObjType == gMapObjTypeDef.mapObjTypeLegendLord or targetObjType == gMapObjTypeDef.mapObjTypeRemainsWar or targetObjType == gMapObjTypeDef.mapObjNewTrialCity or targetObjType == gMapObjTypeDef.mapObjTypeFortress or targetObjType == gMapObjTypeDef.mapTypeWerewolf or targetObjType == gMapObjTypeDef.mapTypeRadianceWarPalace or targetObjType == gMapObjTypeDef.mapTypeRadianceWarGate or targetObjType == gMapObjTypeDef.mapTypeRadianceWarBeacon or targetObjType == gMapObjTypeDef.mapTypeWrathBeast or targetObjType == gMapObjTypeDef.mapTypeAtlantisWarBuilding or targetObjType == gMapObjTypeDef.stronghold or targetObjType == gMapObjTypeDef.mapTypeAtlantisWarBoss or targetObjType == gMapObjTypeDef.wastelandBoss or targetObjType == gMapObjTypeDef.nebulaWarBuilding or targetObjType == gMapObjTypeDef.fireDragon2 or targetObjType == gMapObjTypeDef.sweetMeatRobber or targetObjType == gMapObjTypeDef.nebulaDefenceWarBuilding or targetObjType == gMapObjTypeDef.nebulaEmperorWarBuilding or targetObjType == gMapObjTypeDef.nebulaAllStarWarBuilding or targetObjType == gMapObjTypeDef.roaringFlameWarBuilding or mapObjUtil.isWarBuild(targetObjType) then
			if moveLineType == gMapMoveLineType.moveLineTypeMass then
				btnIcon = "img_xingjunduilie_chakan.png"
				self.fields.Text_state:setString(i18n("common_text_299"))
				self:showQueue(true)
			else
				self.fields.Text_state:setString(i18n("common_text_1461"))
				self.Text_time:setString(tostring(self.tableTroop:getToX()) .. "," .. tostring(self.tableTroop:getToY()))
				self:showQueue(false)
				if targetObjType == gMapObjTypeDef.mapTypeATBuilding then
					self.fields.Text_state:setString(i18n("overview_text_03"))
					self:showQueue(true)
				elseif targetObjType == gMapObjTypeDef.roaringFlameWarBuilding then
					local objId = self.tableTroop:getToObjId()
					local roaringFlameWarUtil = include("roaringFlameWarUtil")
					local remain = roaringFlameWarUtil.getFinishOccupyRemainTime(objId)
					if remain then
						self.fields.Text_state:setString(i18n("brightWar_text_115"))
						self:showQueue(true)
					end
				end
				if _G._returnQueueIdList and _G._returnQueueIdList[self.tableTroop:getId()] then
					self.Text_time:setString(i18n("Battlefield_queue_text_006"))
					btnIcon = "icon_shalou_01.png"
				end
			end
		elseif targetObjType == gMapObjTypeDef.mapObjTypeSuperResource then
			if self.tableTroop:isTargetBuilding() then
				self.fields.Text_state:setString(i18n("common_text_043"))
			else
				self.fields.Text_state:setString(i18n("common_text_830"))
			end
			self:showQueue(true)
		elseif targetObjType == gMapObjTypeDef.mapObjTypeAllianceBuild then
			if moveLineType == gMapMoveLineType.moveLineTypeArmyHelp then
				self.fields.Text_state:setString(i18n("common_text_010"))
				self.Text_time:setString(tostring(self.tableTroop:getToX()) .. "," .. tostring(self.tableTroop:getToY()))
				self:showQueue(false)
				local remainTime = self.tableTroop:getStatusRemainTime()
				if self.tableTroop.status == gMapMoveLineStatusType.moveLineStatusTypeWorking and 0 < remainTime then
					self.fields.Text_state:setString(i18n("common_text_043"))
					self:showQueue(true)
				end
			elseif moveLineType == gMapMoveLineType.moveLineTypeMass then
				btnIcon = "img_xingjunduilie_chakan.png"
				self.fields.Text_state:setString(i18n("common_text_299"))
				self:showQueue(true)
			end
		elseif targetObjType == gMapObjTypeDef.mapTypeRamadanFeast then
			self.fields.Text_state:setString(i18n("activity_feast_toDinner_name"))
			btnIcon = "img_xingjunduilie_chakan.png"
			self:showQueue(true)
		elseif targetObjType == gMapObjTypeDef.feast2024 then
			self.fields.Text_state:setString(i18n("activity_feast_toDinner_name"))
			self:showQueue(true)
		end
	elseif self.eventType == gMapEventTypeDef.mapEventTypeTroopInstance then
		btnIcon = SoraDFIsRA() and "img_xingjunduilie_jiasu.png" or "img_xingjunduilie_jiasu_en.png"
		if self.tableTroop.moveLineModel == gMapMoveLineModel.moveLineModelGoOut then
			_ENV = i18n("activity_feast_toDinner_name")
			i18n("activity_feast_toDinner_name").x = self.tableTroop:getToX()
			i18n("activity_feast_toDinner_name").y = self.tableTroop:getToY()
			self.fields.Text_state:setString(i18n("common_text_833", i18n("activity_feast_toDinner_name")))
			self:showQueue(true)
			local isForbid = worldMapDefine.isInWarForbidSpeed(self.tableTroop, true)
			self.fields.Button_troops:setBright(not isForbid)
		elseif self.tableTroop.moveLineModel == gMapMoveLineModel.moveLineModelGoBack then
			self.fields.Bar_et:setIconIndex(1)
			self.fields.Text_state:setString(i18n("common_text_006"))
			self:showQueue(true)
		end
		if moveLineType == gMapMoveLineType.moveLineTypeEscort or moveLineType == gMapMoveLineType.moveLineTypeEscortRob or moveLineType == gMapMoveLineType.moveLineTypeEscortHelp then
			if moveLineType == gMapMoveLineType.moveLineTypeEscort then
				self.fields.Text_state:setString(i18n("common_text_2352"))
			elseif moveLineType == gMapMoveLineType.moveLineTypeEscortHelp then
				self.fields.Text_state:setString(i18n("common_text_2339"))
			end
			self.fields.Button_troops:setColor(cc.c3b(100, 100, 100))
		end
	end
	if 0 < autokillCtrl:getAutoKillQueueCount() then
		if autokillCtrl:isAutoKillQueue(self.tableTroop:getId()) then
			self:initAutoKillEffect(1)
			self.isAutoKill = true
		else
			local orgQueueId = self.tableTroop:getOrgId()
			if orgQueueId and autokillCtrl:isAutoKillQueue(orgQueueId) then
				self:initAutoKillEffect(1)
				self.isAutoKill = true
			end
		end
	end
	if btnIcon then
		self.fields.Button_troops:setIcon(btnIcon)
	end
	self:updateFlag()
end
function marchingTroopsSingle:initAutoKillEffect(index)
	self.controllers.c1:setSelectedIndex(index)
end
function marchingTroopsSingle:initSoldierClassIcon(...)
	_ENV = nil
	_ENV = nil
	;(nil).sort = 1
	;(nil)[gSoldierType.SOLDIER_TYPE_BUBING], (nil).icon = nil, "img_duilie_biaozhi1.png"
	_ENV = nil
	;(nil).sort = 2
	;(nil)[gSoldierType.SOLDIER_TYPE_GONGBING], (nil).icon = nil, "img_duilie_biaozhi4.png"
	_ENV = nil
	;(nil).sort = 3
	;(nil)[gSoldierType.SOLDIER_TYPE_QIBING], (nil).icon = nil, "img_duilie_biaozhi3.png"
	_ENV = nil
	;(nil).sort = 4
	;(nil)[gSoldierType.SOLDIER_TYPE_CHEBING], (nil).icon = nil, "img_duilie_biaozhi2.png"
	_ENV = nil
	;(nil).sort = 5
	;(nil)[gSoldierType.SOLDIER_TYPE_ELITE], (nil).icon = nil, "img_duilie_biaozhi5.png"
	local config
	local fromArmy = self.tableTroop:getFromArmy()
	local _ENV, data = self.tableTroop, self.tableTroop
	for _, v in ipairs(fromArmy) do
		local _sType = armyltCtrl.getSoldierType(v.id)
		if v.num > 0 and config[_sType] then
			data[_sType] = data[_sType] or 0
			data[_sType] = data[_sType] + v.num
		end
	end
	local _ENV, ret = (for generator), ipairs(fromArmy)
	for k, v in pairs(data) do
		_ENV = nil
		;(nil).stype = k
		;(nil).num = v
		table.insert(ret, nil)
	end
	table.sort(ret, function(a, b)
		if a.num ~= b.num then
			return a.num > b.num
		end
		return config[a.stype].sort < config[b.stype].sort
	end)
	if next(ret) then
		local soldierType = ret[1].stype
		local classIcon = config[soldierType].icon
		self.fields.Node_icon:setClassIcon(classIcon)
		self.fields.Node_icon:setClassVisible(true)
	else
		self.fields.Node_icon:setClassVisible(false)
	end
end
function marchingTroopsSingle:updateFlag()
	local curMoveLineType = self.moveLineType
	local curObjType = self.targetObjType
	local imgSize = 40
	local spriteName = worldMapDefine.getSqueueIcon(curMoveLineType, curObjType, self.tableTroop:getData())
	self.fields.Node_icon:setFlagIcon(spriteName)
	local totalNum = self.tableTroop.totalNum or self.tableTroop:getTotalNum() or 0
	if 0 < totalNum then
		self.fields.Node_icon:isShowArmyNum(true)
		self.fields.Node_icon:setArmyNum(totalNum)
	else
		self.fields.Node_icon:isShowArmyNum(false)
	end
end
function marchingTroopsSingle:showQueue(isShow)
	if isShow then
		local time_remain = math.ceil(self.tableTroop:getStatusRemainTime())
		local totalTime = self.tableTroop:getOrgStatusTotalTime()
		if self.targetObjType == gMapObjTypeDef.roaringFlameWarBuilding then
			local objId = self.tableTroop:getToObjId()
			local roaringFlameWarUtil = include("roaringFlameWarUtil")
			local remain, total = roaringFlameWarUtil.getFinishOccupyRemainTime(objId)
			if remain then
				time_remain = remain
				totalTime = total
				self.Text_time:setTimeLast(function(__, time)
					local timeStr = SoraDConvertSecondToStringNoDayNoHour(time)
					local posStr = self:getToPositionStr()
					return "(" .. timeStr .. ")" .. posStr
				end)
			end
		end
		self.Text_time:beginTime(time_remain)
		self.totalTime = totalTime
		self:updateTroopBar(time_remain)
		if self.preStatus and self.preStatus == self.tableTroop.status then
			if time_remain == 0 then
				self:updateTimeEnd()
				if self.eventType == gMapEventTypeDef.mapEventTypeTroopInstance then
					return true
				end
			end
		else
			self.preStatus = self.tableTroop.status
		end
	else
		self.Text_time:endTime()
	end
	self.fields.Bar_et:setVisible(isShow)
end
function marchingTroopsSingle:updateTroopBar(times)
	local totalTime = self.totalTime or 1
	local percent = totalTime ~= 0 and (totalTime - times) / totalTime or 0
	self.fields.Bar_et:setPercent(percent)
end
function marchingTroopsSingle:updateTimeEnd(...)
	if self.eventType == gMapEventTypeDef.mapEventTypeTroopInstance then
		self.Text_time:setString(i18n("Battlefield_queue_text_006"))
		self.fields.Button_troops:setIcon("icon_shalou_01.png")
		self.fields.Button_setting:setVisible(false)
	end
	if self.eventType == gMapEventTypeDef.mapEventTypeMapInstance and self.targetObjType == gMapObjTypeDef.roaringFlameWarBuilding then
		self.fields.Text_state:setString(i18n("common_text_1461"))
		self.Text_time:setString(self:getToPositionStr())
		self.fields.Bar_et:setVisible(false)
	end
end
function marchingTroopsSingle:OnBtnTroopsClick()
	if self.isAutoKill then
		return
	end
	SoraDPlaySound()
	if not self.fields.Button_troops:isBright() then
		worldMapDefine.isInWarForbidSpeed(self.tableTroop)
		return
	end
	if self.moveLineType == gMapMoveLineType.moveLineTypeEscort or self.moveLineType == gMapMoveLineType.moveLineTypeEscortRob or self.moveLineType == gMapMoveLineType.moveLineTypeEscortHelp then
		SoraDShowMsgTip(i18n("common_text_4955"))
		return
	end
	if self.eventType == gMapEventTypeDef.mapEventTypeTroopInstance then
		local troopID
		if self.tableTroop:isWorking() then
			troopID = self.tableTroop:getMainId() or self.tableTroop:getId()
		else
			troopID = self.tableTroop:getId()
		end
		if not self.tableTroop:isCanUseSpeedInQueue() then
			SoraDShowMsgTip(i18n("common_text_4513"))
			return
		end
		if not self.tableTroop:isCanUseSpeedInAtlantis() then
			SoraDShowMsgTip(i18n("atlantiswar_text_0276"))
			return
		end
		if worldMapDefine.checkCurrentKingdomIsMyKingdom() then
			local moveLineID = self.tableTroop:getMassId() or self.tableTroop:getId()
			local panel = SoraDCreatePanel("speedUpReCallBuyPopView")
			_ENV = i18n("atlantiswar_text_0276")
			i18n("atlantiswar_text_0276").troopsID = troopID
			i18n("atlantiswar_text_0276").moveLineID = moveLineID
			panel:initData(gItemType.MARCH_SPEED_UP, i18n("atlantiswar_text_0276"))
			panel:show()
		else
			_ENV = panel
			_ENV, panel.itemType = gItemType.MARCH_SPEED_UP, gItemType.MARCH_SPEED_UP
			panel.troopData, gItemType.MARCH_SPEED_UP.troopsID = gItemType.MARCH_SPEED_UP, troopID
			uiManager:show("speedUpReCallBuyView", panel)
		end
	elseif self.eventType == gMapEventTypeDef.mapEventTypeMapInstance then
		if self.moveLineType == gMapMoveLineType.moveLineTypeMass then
			local troopID = self.tableTroop:getMainId() or self.tableTroop:getId()
			local panel = uiManager:show("AllianceWarRallyView")
			panel:initData(troopID)
		elseif self.targetObjType == gMapObjTypeDef.mapObjTypeTreasure then
			_ENV = gItemType.MARCH_SPEED_UP
			gItemType.MARCH_SPEED_UP.fromTarget = self
			SoraDShowMsgBox(i18n("common_text_1648"), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					kingdomMapCtrl:reqBackQueueById(self.tableTroop:getId())
				end
			end, gItemType.MARCH_SPEED_UP)
		elseif self.targetObjType == gMapObjTypeDef.mapTypeRamadanFeast then
			kingdomMapCtrl:reqMapObjInfo(self.tableTroop:getToX(), self.tableTroop:getToY(), self.tableTroop:getToId())
			SoraDShowLoading(self)
		else
			if _G._returnQueueIdList and _G._returnQueueIdList[self.tableTroop:getId()] then
				SoraDShowMsgTip(i18n("Battlefield_queue_text_002"))
				return
			end
			local showMsg = i18n("notice_0025")
			if self.targetObjType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
				showMsg = i18n("brightWar_text_225")
			elseif self.targetObjType == gMapObjTypeDef.mapTypeRadianceWarGate then
				showMsg = i18n("brightWar_text_149")
				local constantRead = include("constantRead")
				local RADIANCE_ATTACK_BARRIER_CD = constantRead.getConstValue("RADIANCE_ATTACK_BARRIER_CD", 0)
				if 0 < RADIANCE_ATTACK_BARRIER_CD then
					_ENV = i18n("Battlefield_queue_text_002")
					i18n("Battlefield_queue_text_002").num = RADIANCE_ATTACK_BARRIER_CD
					showMsg = i18n("radiance_common_text_2", i18n("Battlefield_queue_text_002"))
				end
			elseif self.targetObjType == gMapObjTypeDef.nebulaWarMine then
				showMsg = i18n("nebula_war_text_0282")
			elseif self.targetObjType == gMapObjTypeDef.feast2024 then
				showMsg = i18n("activity_feast_back_sure_desc")
			end
			_ENV = i18n("Battlefield_queue_text_002")
			i18n("Battlefield_queue_text_002").fromTarget = self
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					kingdomMapCtrl:reqBackQueueById(self.tableTroop:getId())
					if self.targetObjType == gMapObjTypeDef.mapObjTypeLegendLord or self.targetObjType == gMapObjTypeDef.nebulaWarBuilding or self.targetObjType == gMapObjTypeDef.nebulaEmperorWarBuilding or self.targetObjType == gMapObjTypeDef.nebulaAllStarWarBuilding then
						local queueId = self.tableTroop:getId()
						if not _G._returnQueueIdList then
							_G._returnQueueIdList, _ENV = self.tableTroop:getId()
						end
						_G._returnQueueIdList[queueId] = true
					end
				end
			end, i18n("Battlefield_queue_text_002"))
		end
	end
end
function marchingTroopsSingle:OnBtnJumpClick()
	SoraDPlaySound()
	if not worldMapDefine.checkCurrentKingdomIsMyKingdom() then
		return
	end
	if not self.eventType then
		return
	end
	if self.eventType == gMapEventTypeDef.mapEventTypeMapInstance then
		SoraDGotoWorldMapPoint(cc.p(self.tableTroop:getToX(), self.tableTroop:getToY()), true)
	elseif self.tableTroop:isWorking() then
		SoraDGotoWorldMoveLine(self.tableTroop:getMainId() or self.tableTroop:getId())
	else
		SoraDGotoWorldMoveLine(self.tableTroop:getId())
	end
end
function marchingTroopsSingle:OnBtnSettingClick()
	SoraDPlaySound()
	dump(self.tableTroop, "marchingTroopsSingle:OnBtnSettingClick", 10)
	if self.tableTroop.status == gMapMoveLineStatusType.moveLineStatusTypeRally then
		_ENV = 10
		;(10).troopData = self.tableTroop
		uiManager:show("WorldMapMass", 10)
	else
		_ENV = 10
		;(10).troopData = self.tableTroop
		uiManager:show("AllianceWarRallySettingView", 10)
	end
end
function marchingTroopsSingle:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_COMMON_MSGBOX"
	;(nil).fromTarget = self
	SoraDSendMessage(nil)
end
function marchingTroopsSingle:getToPositionStr(...)
	return tostring(self.tableTroop:getToX()) .. "," .. tostring(self.tableTroop:getToY())
end
return marchingTroopsSingle
