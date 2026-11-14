local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapDefine = include("worldMapDefine")
local talentSkillCtrl = _G.SoraDGetCtrl("talentSkillCtrl")
local worldMapInstance = include("worldMapInstance")
local GROU_ID = worldMapDefine.GROU_ID
local worldMapBuilding = class("worldMapBuilding", function()
	local target = worldMapInstance.new("worldMapBuilding")
	return target
end)
function worldMapBuilding:ctor()
	_ENV, _UPVALUE13_, self.bulletCache, _ENV, self.bulletNum = nil, nil, nil, nil, 20
	;(nil).abbrName = "buildEffect"
	_ENV, (nil).className = nil, "worldMapBuildEffect"
	;(nil).abbrName = "buildOfficer"
	_ENV, (nil).className = nil, "worldMapBuildOfficer"
	;(nil).abbrName = "buildBetray"
	_ENV, (nil).className = nil, "worldMapBuildBetray"
	;(nil).abbrName = "buildPrisone"
	_ENV, (nil).className = nil, "worldMapBuildPrisone"
	;(nil).abbrName = "buildMeteoriteSkill"
	_ENV, (nil).className = nil, "worldMapBuildMeteoriteSkill"
	;(nil).abbrName = "build3dPet"
	_ENV, (nil).className = nil, "worldMapBuild3dPet"
	;(nil).abbrName = "buildMoveTime"
	_ENV, (nil).className = nil, "worldMapBuildMoveTime"
	;(nil).abbrName = "buildNameBox"
	_ENV, (nil).className = nil, "worldMapBuildNameBox"
	;(nil).abbrName = "buildNebulaAllStarValue"
	_ENV, (nil).className = nil, "worldMapBuildNebulaAllStarValue"
	;(nil).abbrName = "buildSignature"
	_ENV, (nil).className = nil, "worldMapBuildSignature"
	;(nil).abbrName = "buildSkill"
	_ENV, (nil).className = nil, "worldMapBuildSkill"
	;(nil).abbrName = "buildProtect"
	_ENV, (nil).className = nil, "worldMapBuildProtect"
	;(nil).abbrName = "build9001700"
	;(nil).className = "worldMapBuild9001700"
	self.compMap, _ENV, self.compList, _ENV, (nil)[1] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[2] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[3] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[4] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[5] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[6] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[7] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[8] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[9] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[10] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[11] = nil, nil, nil, nil, nil
	self.compMap, _ENV, self.compList, _ENV, (nil)[12] = nil, nil, nil, nil, nil
	local self.compMap, _ENV, self.compList, _ENV, (nil)[13], componentConfig
	for __, cfg in ipairs(componentConfig) do
		local class = include(cfg.className).new(self)
		self.compMap[cfg.abbrName] = class
		self.compMap[cfg.className] = class
		table.insert(self.compList, class)
	end
	self:_initData()
	self:_initUI()
end
function worldMapBuilding:getBuildCom(comName)
	return self.compMap[comName]
end
function worldMapBuilding:onEnterOther()
	local moveLineAutoHideOption = worldMapDefine.moveLineAutoHideOption
	moveLineAutoHideOption.buildingCount = moveLineAutoHideOption.buildingCount + 1
	if not worldMapDefine.moveLineAutoHideOption.isSwitchShow then
		local limitNum = moveLineAutoHideOption.getLimitBuildingNum()
		if limitNum <= moveLineAutoHideOption.buildingCount then
			worldMapDefine = nil
			;(nil).msg = "MESSAGE_MOVELINE_SWITCH_UPDATE"
			;(nil).isShow = true
			SoraDSendMessage(nil)
		end
	end
	for __, component in ipairs(self.compList) do
		component:onMessageListener()
	end
end
function worldMapBuilding:onExitOther()
	local moveLineAutoHideOption = worldMapDefine.moveLineAutoHideOption
	moveLineAutoHideOption.buildingCount = moveLineAutoHideOption.buildingCount - 1
	for __, component in ipairs(self.compList) do
		SoraDRemoveMessageByTarget(component)
	end
end
function worldMapBuilding:_initData()
	self.playerID = 0
	self.playerName = nil
	self.playerLevel = 1
	self.isShowWarLv = false
	self.inMapId = nil
	self:setName("worldMapBuilding")
	self.cityLevel = 1
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warCamp = nil
	self.isSafe = false
	self.betray = 0
	self.buildingState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.sourceID = 0
	self.rfKid = 0
	self.sourceKingdomID = nil
	self.emojiID = nil
	self.hideBattleLev = false
	self.facePoint = cc.p(0, 0)
	self.fireNode_ex = nil
	for __, component in ipairs(self.compList) do
		component:_initData()
	end
end
function worldMapBuilding:_initUI()
	self.image_LeagueFlag = display.newSpriteNoChild(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 147, self.centerPoint.y - 10))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 2)
	self.image_LeagueFlag:setGroupID(GROU_ID.group_flag)
	self.image_crown = display.newSpriteNoChild("#icon_map_mycastle.png")
	self.image_crown:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 64))
	self.image_crown:setVisible(false)
	self.image_crown:addTo(self, 4)
	self.image_crown:setGroupID(GROU_ID.group_protect)
	self.image_zhencha = display.newSpriteNoChild("#icon_spy_01.png")
	self.image_zhencha:setPosition(cc.p(self.centerPoint.x - 80, self.centerPoint.y - 80))
	self.image_zhencha:setVisible(false)
	self.image_zhencha:setScale(0.5)
	self.image_zhencha:addTo(self, 3)
	self.image_zhencha:setGroupID(GROU_ID.group_protect)
	self.image_name_bg = display.newSpriteNoChild("#frame_map_18.png")
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 84))
	self.image_name_bg:addTo(self, 3)
	self.image_name_bg:setGroupID(GROU_ID.group_level_build)
	self.image_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_name:addTo(self, 3)
	self.image_name:setGroupID(GROU_ID.group_level_build)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = ""
	self.image_name.size = 20
	self.text_Name = SoraDCreateLabelNoChild(self.image_name)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 90))
	self.text_Name:addTo(self, 4)
	self.text_Name:setGroupID(GROU_ID.group_text)
	self.image_level = display.newSprite("#icon_map_reslevel.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x + 60, self.centerPoint.y - 50))
	self.image_level:addTo(self, 2)
	self.image_level:setGroupID(GROU_ID.group_level_build)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.text_Level = SoraDCreateLabelNoChild(self.image_level)
	self.text_Level:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Level:setSkewY(25)
	self.text_Level:setPosition(cc.p(self.centerPoint.x + 68, self.centerPoint.y - 58))
	self.text_Level:addTo(self, 2)
	self.text_Level:setGroupID(GROU_ID.group_text)
	self.image_nameBgSkin = display.newSprite("#frame_castle_name_01.png")
	self.image_nameBgSkin:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_nameBgSkin:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 78))
	self.image_nameBgSkin:setScale(1.0)
	self.image_nameBgSkin:addTo(self, 3)
	self.image_nameBgSkin:setVisible(false)
	self.bulletNode = display.newNode()
	self:addChild(self.bulletNode, 4)
	for __, component in ipairs(self.compList) do
		component:_initUI()
	end
end
function worldMapBuilding:isInAllianceWar()
	if self.inMapId then
		return self.inMapId ~= self.kingdomID
	end
	return false
end
local POINT_ZERO = cc.p(0, 0)
function worldMapBuilding:addCacheBefore()
	self.image_LeagueFlag:setVisible(false)
	self.image_crown:setVisible(false)
	self.image_zhencha:setVisible(false)
	if self.fireNode_ex then
		self.fireNode_ex:removeFromParent()
		self.fireNode_ex = nil
	end
	if self.tipsNode then
		self.tipsNode:removeFromParent()
		self.tipsNode = nil
	end
	self.warCamp = nil
	for __, component in ipairs(self.compList) do
		component:addCacheBefore()
	end
end
function worldMapBuilding:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_3D", handler(self, self.toggle3D))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_ENEMY_CASTLE_EFFECT", handler(self, self.setWarPlayerInfo))
	SoraDAddMessage(self, "MESSAGE_WALLS_NOTIFY_TRIAL_WARNING", handler(self, self.updateWallWarning))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_CASTLE_OFFICEICON", handler(self, self.updateOfficeIcon))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_TITLE_SHOW", handler(self, self.updateOfficeIcon))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_CASTLE_PRISIONICON", handler(self, self.updatePrisionIcon))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateAllianceCounter))
	SoraDAddMessage(self, "MESSAGE_LOCAL_OPTION_CATLE_WAR_LV_SHOW", function()
		self.compMap.buildEffect:updateBuildStar2()
		self.compMap.buildEffect:warLvEffect2()
		self:updateBuildingImg()
	end)
end
function worldMapBuilding:setBatchNodeGroupID(groupID)
	for __, component in ipairs(self.compList) do
		component:setBatchNodeGroupID(groupID)
	end
end
function worldMapBuilding:setSkinGroupID(model)
	return self.compMap.buildEffect:setSkinGroupID(model)
end
function worldMapBuilding:setSignNodeGroupID(model)
	return self.compMap.buildSignature:setSignNodeGroupID(model)
end
function worldMapBuilding:initCityData(data)
	self:updateData(data)
end
function worldMapBuilding:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapBuilding:updateData==", 10)
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	self.data = data
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.playerLevel then
		self.playerLevel = data.playerLevel
	end
	if data.inMapId then
		self.inMapId = data.inMapId
	end
	self:updateEmojiByData(data)
	if self.compMap.buildOfficer:updateData(data) then
		self:updateTopShowIcons()
	end
	if self.compMap.buildPrisone:updateData(data) then
		self:updateTopShowIcons()
	end
	if data.betray then
		self.betray = data.betray
		self.compMap.buildBetray:updateData(data)
	end
	if data.cityLevel then
		self.cityLevel = data.cityLevel
		self.instanceLevel = self.cityLevel
		local textShowLV
		if worldMapDefine.isGardenKingdomID() then
			self.isShowWarLv, textShowLV = false, data.gardenLv or 0
		else
			self.isShowWarLv, textShowLV = SoraDGetBuildWarLv(self.cityLevel)
		end
		if self.isShowWarLv then
			self.image_level:setSpriteFrame("icon_main_build_warlv.png")
			self.image_level:setGroupID(0)
			self.image_level:setPosition(cc.p(self.centerPoint.x + 90, self.centerPoint.y - 50))
			self.text_Level:setPosition(cc.p(self.centerPoint.x + 110, self.centerPoint.y - 53))
		else
			self.image_level:setSpriteFrame("icon_main_build_lv.png")
			self.image_level:setGroupID(GROU_ID.group_level_build)
			self.image_level:setPosition(cc.p(self.centerPoint.x + 60, self.centerPoint.y - 50))
			self.text_Level:setPosition(cc.p(self.centerPoint.x + 80, self.centerPoint.y - 48))
		end
		self.text_Level:setString(textShowLV)
		if not data.castleSkin then
			self:updateBuildingImg()
		end
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.leagueName then
		self.leagueName = data.leagueName
	end
	if data.leagueFlag then
		self.leagueFlag = data.leagueFlag
	end
	if data.camp then
		self.warCamp = data.camp
	end
	if data.leagueID or data.leagueName or data.leagueFlag or data.camp then
		self:updateLeagueInfo()
	end
	if data.status then
		self.buildingState = data.status
	end
	if data.isSafe ~= nil then
		self.isSafe = data.isSafe
	end
	if data.hasScoutRecord ~= nil then
		if data.hasScoutRecord then
			self.image_zhencha:setVisible(true)
		else
			self.image_zhencha:setVisible(false)
		end
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.rfKid then
		self.rfKid = data.rfKid
	end
	if data.kingdomId then
		self.sourceKingdomID = data.kingdomId
	end
	local textName = self.playerName
	if self.leagueID and 0 < self.leagueID and self.leagueName then
		textName = "(" .. self.leagueName .. ")" .. self.playerName
		self.text_Name:setString("(" .. self.leagueName .. ")" .. self.playerName)
	end
	local nameColor = cc.c3b(255, 235, 185)
	if self.playerID == selfPlayerID then
		self.image_crown:setVisible(true)
		if worldMapDefine.isInGarden() then
			textName = i18n("garden_text_20")
		else
			textName = i18n("common_text_496")
		end
	else
		local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId(self.kingdomId)
		if self.leagueID == selfLeagueID then
			if mapClassType == gKingdomClassType.legendLord then
				textName = self:setLendLordPlayerInfo(textName)
			elseif mapClassType == gKingdomClassType.radiance and self.sourceKingdomID and 0 < self.sourceKingdomID then
				textName = textName .. "#" .. self.sourceKingdomID
			end
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
		else
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			if mapClassType == gKingdomClassType.legendLord then
				textName = self:setLendLordPlayerInfo(textName)
				if self.sourceKingdomID ~= self.kingdomID then
					nameColor = cc.c3b(190, 190, 190)
				end
			elseif mapClassType == gKingdomClassType.radiance then
				if self.sourceKingdomID and 0 < self.sourceKingdomID then
					textName = textName .. "#" .. self.sourceKingdomID
				end
			elseif mapClassType == gKingdomClassType.nebulaEmperor or mapClassType == gKingdomClassType.nebulaAllStar then
				nameColor = worldMapDefine.getLeagueManorLineColor(nil, gMapAllianceRelationType.ENEMY)
			elseif mapClassType == gKingdomClassType.garden then
			else
				if (0 < self.rfKid and self.rfKid or self.sourceID) ~= self.kingdomID then
					nameColor = cc.c3b(190, 190, 190)
				end
				textName = self:setWarPlayerInfo(nil, nil, textName)
			end
		end
		if worldMapDefine.isInRoaringFlame() then
			local roaringFlameWarRead = include("roaringFlameWarRead")
			local campName = roaringFlameWarRead.getCampName(self.warCamp)
			textName = textParser.formatPlayerName(campName, self.playerName)
		elseif worldMapDefine.isInSimulatedDrill() then
			local simulatedDrillUtil = include("simulatedDrillUtil")
			local campName = simulatedDrillUtil.getCampName(self.warCamp)
			textName = textParser.formatPlayerName(campName, self.playerName)
		elseif worldMapDefine.isGardenKingdomID() then
			_ENV = textParser.formatPlayerName(campName, self.playerName)
			textParser.formatPlayerName(campName, self.playerName).name = textName
			textName = i18n("garden_text_21", (textParser.formatPlayerName(campName, self.playerName)))
		end
	end
	if worldMapDefine.isInNebula() then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = "garden_text_21"
		;("garden_text_21").playerID = self.playerID
		;("garden_text_21").leagueID = self.leagueID
		;("garden_text_21").camp = self.warCamp
		nameColor = worldMapWarDef.getNameColorInNebula("garden_text_21")
	elseif worldMapDefine.isInNebulaAllStar(true) then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = "garden_text_21"
		;("garden_text_21").camp = self.warCamp
		nameColor = worldMapWarDef.getNameColor("garden_text_21")
	elseif worldMapDefine.isInRoaringFlame() or worldMapDefine.isInSimulatedDrill() then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = "garden_text_21"
		;("garden_text_21").playerID = self.playerID
		;("garden_text_21").leagueID = self.leagueID
		;("garden_text_21").camp = self.warCamp
		nameColor = worldMapWarDef.getNameColor("garden_text_21")
	end
	self.text_Name:setColor(nameColor)
	self.text_Name:setString(textName)
	self.compMap.buildEffect:updateData(data)
	self.compMap.buildNameBox:updateData(data)
	self.compMap.buildMoveTime:updateData(data)
	self:updateBuildingState()
	self.compMap.buildProtect:updateData(data)
	self:updateWarLvEffect()
	self:updateAllianceCounterAtkEffect()
	self.compMap.buildEffect:updateCastleEffect(data)
	self.compMap.buildMeteoriteSkill:updateData(data)
	self.compMap.buildSignature:updateData(data)
	self.compMap.buildSkill:updateData(data)
	self.compMap.buildEffect:updateBuildStar(data.starLv)
	self.compMap.buildNebulaAllStarValue:updateData(data)
	self.compMap.build9001700:updateData(data)
end
function worldMapBuilding:showInstance(show, delayTime)
	delayTime = delayTime or 0
	if 0 < delayTime then
		local _ENV, actionsArray
		actionsArray[#actionsArray + 1] = cc.DelayTime:create(delayTime)
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
			if tolua.isnull(self) then
				return
			end
			self:setVisible(show)
		end)
		local action = transition.sequence(actionsArray)
		self:runAction(action)
	else
		self:setVisible(show)
	end
	if not show then
		self:sendTileEffectMessage(worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
		self:removeInstanceSelf()
	end
end
function worldMapBuilding:updateLeagueInfo()
	if worldMapDefine.isInRoaringFlame() then
		self.image_LeagueFlag:setVisible(false)
		return
	end
	if self.leagueID and self.leagueID > 0 then
		self.image_LeagueFlag:setVisible(true)
		if worldMapDefine.isInNebulaEmperor() or worldMapDefine.isInNebulaAllStar(true) then
			local nebulaEmperorUtil = include("nebulaEmperorUtil")
			local areaIcon = nebulaEmperorUtil.getAreaIcon(self.leagueFlag)
			self.image_LeagueFlag:setSpriteFrame(areaIcon)
			self.image_LeagueFlag:setScale(0.7)
		elseif self.leagueFlag then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
			self.image_LeagueFlag:setScale(0.3)
		end
	else
		self.image_LeagueFlag:setVisible(false)
	end
end
function worldMapBuilding:updateBuildingImg()
	self.compMap.buildEffect:updateBuildingImg()
end
function worldMapBuilding:setLendLordPlayerInfo(name)
	local textName = name or self.playerName
	if self.sourceKingdomID and self.sourceKingdomID > 0 then
		textName = textName .. "#" .. self.sourceKingdomID
	end
	return textName
end
function worldMapBuilding:updateWarLvEffect(target, data)
	self.compMap.buildEffect:updateWarLvEffect()
end
function worldMapBuilding:updateAllianceCounter(target, data)
	if data and data.type and data.type == GREEN_POINT_NOTICE_TYPE.COUNTER_SYS then
		self:updateAllianceCounterAtkEffect()
	end
end
function worldMapBuilding:updateOfficeIcon(target, data)
	self.compMap.buildOfficer:updateOfficeIcon()
end
function worldMapBuilding:updatePrisionIcon(target, data)
	self.compMap.buildPrisone:updatePrisionIcon(target, data)
end
function worldMapBuilding:setWarPlayerInfo(target, data, name)
	local textName = name or self.playerName
	local selfSourceID = lordInfoCtrl:getMapSourceKid()
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isMatchKingdom = conquestWarCtrl:isMatchKingdom(selfSourceID, self.kingdomID)
	if selfSourceID == self.kingdomID or isMatchKingdom then
		print("addEnemyCastleEffect", selfSourceID, self.sourceID, self.kingdomID, self.rfKid)
		local isEnemy = selfSourceID ~= self.sourceID
		if self.rfKid and self.rfKid ~= 0 then
			isEnemy = self.rfKid ~= selfSourceID
		end
		if isEnemy then
			textName = textName .. "#" .. self.sourceID
			self.text_Name:setColor(cc.c3b(200, 0, 0))
			local boolWarSmoke = SoraDConfigGet("Game:GameOptionsView:warSmoke~bool")
			if boolWarSmoke then
				self:addEnemyCastleEffect()
			else
				self:removeEnemyCastleEffect()
			end
			self.image_name:setSpriteFrame("frame_castle_name_enemy.png")
		elseif self.leagueID and 0 < self.leagueID and self.leagueName then
			textName = "(" .. self.leagueName .. ")" .. self.playerName
		end
	end
	return textName
end
function worldMapBuilding:updateBuildingState()
	self:updateFireEffect(self.buildingState)
end
function worldMapBuilding:addFireEffect(fightTime, data)
	worldMapInstance.addFireEffect(self, fightTime, data)
	if data and data.fightingToPointX and data.fightingToPointY then
		self.facePoint = cc.p(data.fightingToPointX, data.fightingToPointY)
	end
	self:doFightingAnimation()
end
function worldMapBuilding:doFightingAnimation()
	if worldMapDefine.moveLineAutoHideOption.isSwitchShow then
		return
	end
	local x, y = self:getPosition()
	local beginPoint = cc.p(x, y + 30)
	local endPoint = self.facePoint
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		endPoint = worldMapView:getPointWithTile(self.facePoint)
	end
	local angle = SoraDGetAngleByPos(beginPoint, endPoint)
	local radius = 80
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	for _ = 1, self.bulletNum do
		do
			local bulletSprite = self:popBullet("#icon_battle_jian_4.png")
			local randomPointX = math.random(-20, 20)
			local randomPointY = math.random(-20, 20)
			local randomAngle = math.random(-50, 50)
			local randomDistence = radius + math.random(-30, 30)
			local newAngle = angle + randomAngle
			local radian = math.angle2radian(newAngle)
			local pointX = randomDistence * math.cos(radian)
			local pointY = randomDistence * math.sin(radian)
			local point1 = cc.p(randomPointX, randomPointY)
			local point2 = cc.p(pointX, pointY)
			bulletSprite:setPosition(point1)
			bulletSprite:setScale(0.5)
			self.bulletNode:addChild(bulletSprite, 1)
			bulletSprite:release()
			local delayTime = math.random(0, 5) / 10
			worldMapFunction.createThrowAction(bulletSprite, point1, point2, delayTime, nil, function()
				self:pushBullet("#icon_battle_jian_4.png", bulletSprite)
			end)
		end
	end
	local worldMapDefine, actionsArray = (for index), 1
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(3.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:doFightingAnimation()
	end)
	local actions = transition.sequence(actionsArray)
	self.fireNode:runAction(actions)
end
function worldMapBuilding:popBullet(bulletSpriteName)
	local bullets = gBulletCache[bulletSpriteName]
	local cnt = bullets and #bullets or 0
	if 0 < cnt then
		local bulletSp = bullets[cnt]
		if bulletSp then
			table.remove(bullets, cnt)
			return bulletSp
		end
	end
	local bullet = display.newSprite(bulletSpriteName)
	bullet:retain()
	if not bullet then
		return
	end
	return bullet
end
function worldMapBuilding:pushBullet(bulletSpriteName, bullet)
	bullet:retain()
	if not gBulletCache[bulletSpriteName] then
		_ENV = gBulletCache[bulletSpriteName]
	end
	gBulletCache[bulletSpriteName] = gBulletCache[bulletSpriteName]
	table.insert(gBulletCache[bulletSpriteName], bullet)
end
function worldMapBuilding:addEnemyCastleEffect()
	self.compMap.buildEffect:addEnemyCastleEffect()
end
function worldMapBuilding:removeEnemyCastleEffect()
	self.compMap.buildEffect:removeEnemyCastleEffect()
end
function worldMapBuilding:addMeteoriteSkillEffect(atttE)
	self.compMap.buildMeteoriteSkill:addMeteoriteSkillEffect(atttE)
end
function worldMapBuilding:getFavoriteName()
	local favoriteName = self.playerName
	if self.leagueName then
		_ENV = nil
		;(nil).abbr = self.leagueName
		;(nil).name = self.playerName
		favoriteName = i18n("common_text_186", nil)
	end
	return favoriteName
end
function worldMapBuilding:playClickSound()
	SoraDPlaySound("innerbuildsound", 101)
end
function worldMapBuilding:getInstanceOp(isSelfKindom, isInWar)
	local worldMapDefine, buttonTypeArray
	if worldMapDefine.isGardenKingdomID(self.kingdomID) then
		if SoraDGetPlayerID() == self.playerID then
			worldMapDefine = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_garden_self
			table.insert(buttonTypeArray, nil)
		else
			worldMapDefine = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_garden_visit
			table.insert(buttonTypeArray, nil)
		end
		worldMapDefine = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, nil)
		return buttonTypeArray
	end
	if worldMapDefine.isInSimulatedDrill() then
		worldMapDefine = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, nil)
		return buttonTypeArray
	end
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom then
		local playerID = self.playerID or 0
		local leagueID = self.leagueID or 0
		if selfPlayerID == playerID then
			if worldMapDefine.isInNebulaAllStar() then
				worldMapDefine = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_nebulaAllStar_defend
				table.insert(buttonTypeArray, nil)
			end
			worldMapDefine = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_defend
			table.insert(buttonTypeArray, nil)
			worldMapDefine = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_chengshiZengyi
			table.insert(buttonTypeArray, nil)
			if not worldMapDefine.isInNebulaAllStar() then
				worldMapDefine = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_decorate
				table.insert(buttonTypeArray, nil)
			end
			if SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.SIGNATURE) then
				worldMapDefine = gExaltedPrivilegeType.SIGNATURE
				gExaltedPrivilegeType.SIGNATURE.buttonType = worldMapDefine.worldMapTipButtonType_sign
				table.insert(buttonTypeArray, gExaltedPrivilegeType.SIGNATURE)
			end
		else
			if not isInWar and worldMapDefine.kingdomStatus == gKingStatus.king then
				worldMapDefine = gExaltedPrivilegeType.SIGNATURE
				gExaltedPrivilegeType.SIGNATURE.buttonType = worldMapDefine.worldMapTipButtonType_renMing
				table.insert(buttonTypeArray, gExaltedPrivilegeType.SIGNATURE)
			end
			local isInPyramid = self:isInAllianceWar()
			local msgTipsKey
			local worldMapDefine, atlantis = gExaltedPrivilegeType.SIGNATURE, gExaltedPrivilegeType.SIGNATURE
			if worldMapDefine.isInAtlantis() then
				local atlantisWarUtil = include("atlantisWarUtil")
				local ret = atlantisWarUtil.isTouchMarshal(self:getTilePoint())
				if ret then
					atlantis.isCanZhanling = false
					atlantis.isCanZhencha = false
					atlantis.zhenchaTips = i18n("atlantiswar_text_0096")
					isInPyramid = not atlantis.isCanZhanling
					msgTipsKey = atlantis.zhenchaTips
				else
					atlantis = atlantisWarUtil.checkAreaState(self:getTilePoint())
					isInPyramid = not atlantis.isCanZhanling
					msgTipsKey = atlantis.clickTips
				end
			elseif worldMapDefine.isInNebula() then
				local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
				if nebulaActivityCtrl:getCurRound() <= 3 then
					isInPyramid = true
					msgTipsKey = i18n("nebula_war_text_0194")
				end
			elseif worldMapDefine.isInNebulaEmperor() then
				local nebulaEmperorUtil = include("nebulaEmperorUtil")
				if nebulaEmperorUtil.isForbitWarByInBorn() then
					isInPyramid = true
					msgTipsKey = i18n("nebulaemperor_text_220")
				elseif nebulaEmperorUtil.isTileInBornArea(self:getTilePoint()) then
					isInPyramid = true
					msgTipsKey = i18n("nebulaemperor_text_219")
				end
			elseif worldMapDefine.isInNebulaAllStar() then
				local nebulaAllStarUtil = include("nebulaAllStarUtil")
				local ok, errTip = nebulaAllStarUtil.checkIsCanZhanling(self:getTilePoint())
				if not ok then
					isInPyramid = true
					msgTipsKey = errTip
				end
			end
			local sameCamp = false
			if worldMapDefine.isInNebulaAllStar() then
				local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
				local selfCamp = nebulaAllStarCtrl:getSelfCamp()
				if self.warCamp == selfCamp then
					sameCamp = true
				end
			end
			if sameCamp or 0 < selfLeagueID and selfLeagueID == leagueID then
				local worldMapWarDef = include("worldMapWarDef")
				if worldMapWarDef.isInWarForbidResourceHelp() and self.rfKid == 0 and not SoraDGetCtrl("conquestWarCtrl"):isHelper() then
					worldMapDefine = self:getTilePoint()
					self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu
					self:getTilePoint().isButtonEnabled = not isInPyramid
					self:getTilePoint().msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, self:getTilePoint())
				end
				if kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.moveLineTypeMassSlave, nil, nil, self.playerID) then
					worldMapDefine = _G.gMapMoveLineServerType.moveLineTypeMassSlave
					_G.gMapMoveLineServerType.moveLineTypeMassSlave.buttonType = worldMapDefine.worldMapTipButtonType_jijieBuduiXinxi
					table.insert(buttonTypeArray, _G.gMapMoveLineServerType.moveLineTypeMassSlave)
				end
				if kingdomMapCtrl:hasArmyHelpQueue2Player(self.playerID, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
					worldMapDefine = self.playerID
					self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_chakanYuanjun
					table.insert(buttonTypeArray, self.playerID)
				elseif worldMapWarDef.isInWarForbidSoldierHelp() then
					worldMapDefine = self.playerID
					self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
					self.playerID.isButtonEnabled = not isInPyramid
					self.playerID.msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, self.playerID)
				end
			else
				local isEnable = true
				local isEnableZhenCha = true
				local isEnableGongJi = true
				if worldMapDefine.isRadianceKingdomID(self.kingdomID) then
					local selfSourceID = lordInfoCtrl:getMapSourceKid()
					if self.sourceKingdomID and 0 < self.sourceKingdomID and selfSourceID == self.sourceKingdomID then
						isEnable = false
						isEnableZhenCha = false
						msgTipsKey = i18n("brightWar_text_133")
					else
						local radianceWarUtil = include("radianceWarUtil")
						isEnable = radianceWarUtil.isInSelfLeagueManor(self:getTilePoint(), selfLeagueID, 2)
						if not isEnable then
							function msgTipsKey()
								radianceWarUtil.showGuildToBuild(self:getTilePoint())
							end
						end
					end
					isEnableGongJi = isEnable
				elseif worldMapDefine.isInAtlantis() then
					isEnable = atlantis.isCanZhanling
					isEnableGongJi = atlantis.isCanZhanling
				elseif worldMapDefine.isInNebula() then
					local nebulaWarUtil = include("nebulaWarUtil")
					local ok, areaName = nebulaWarUtil.checkIsCanGongji(self:getTilePoint())
					isEnable = ok
					isEnableGongJi = false
					isEnableZhenCha = ok
					function msgTipsKey(target, event)
						local tipButtonType = target.tipButtonType
						if tipButtonType == worldMapDefine.worldMapTipButtonType_gongJi then
							SoraDShowMsgTip(i18n("nebula_war_text_0640"))
							return
						end
						worldMapDefine = SoraDShowMsgTip
						SoraDShowMsgTip[worldMapDefine.worldMapTipButtonType_gongJi] = i18n("common_text_008")
						SoraDShowMsgTip[worldMapDefine.worldMapTipButtonType_xuanZhan] = i18n("common_text_009")
						local SoraDShowMsgTip[worldMapDefine.worldMapTipButtonType_zhenCha], type2name = i18n("common_text_007"), SoraDShowMsgTip
						worldMapDefine = i18n("nebula_war_text_0640")
						i18n("nebula_war_text_0640").map = areaName
						i18n("nebula_war_text_0640").name = type2name[tipButtonType]
						SoraDShowMsgTip(i18n("nebula_war_text_0539", i18n("nebula_war_text_0640")))
					end
				elseif worldMapDefine.isInNebulaEmperor() or worldMapDefine.isInNebulaAllStar() then
					isEnable = not isInPyramid
					isEnableGongJi, isEnableZhenCha = isEnable, isEnable
				elseif worldMapDefine.isInRoaringFlame() then
					isEnable = false
					isEnableGongJi = false
					msgTipsKey = i18n("flames_dunes_text284")
				elseif _G.IsArClient then
					local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
					if conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
						local selfSourceID = lordInfoCtrl:getMapSourceKid()
						if self.sourceID and 0 < self.sourceID and selfSourceID == self.sourceID then
							isEnable = false
							msgTipsKey = i18n("common_text_4576")
						end
					end
				end
				worldMapDefine = i18n("common_text_4576")
				i18n("common_text_4576").buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				i18n("common_text_4576").isButtonEnabled = isEnableGongJi
				i18n("common_text_4576").msgTipsKey = msgTipsKey
				table.insert(buttonTypeArray, (i18n("common_text_4576")))
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID and self.cityLevel >= CASTLE_LV6_LIMITED then
					worldMapDefine = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					;(0).isButtonEnabled = isEnable
					;(0).msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, 0)
				end
				local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
				if towerLv >= WATCH_TOWER_SCOUT_MIN_LV and not self.isSafe then
					local _msgTipsKey = msgTipsKey
					if worldMapDefine.isInAtlantis() then
						isEnableZhenCha = atlantis.isCanZhencha
						_msgTipsKey = atlantis.zhenchaTips
					end
					worldMapDefine = self:getTilePoint()
					self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					self:getTilePoint().isButtonEnabled = isEnableZhenCha
					self:getTilePoint().msgTipsKey = _msgTipsKey
					table.insert(buttonTypeArray, self:getTilePoint())
				end
				local lordSkillModuleAPI = include("lordSkillModuleAPI")
				local qianruinfo = lordSkillModuleAPI:getSkillCDData(LORD_SKILL_QIANRU)
				if self.isSafe and qianruinfo.isOpened then
					worldMapDefine = worldMapDefine.worldMapTipButtonType_zhenCha
					worldMapDefine.worldMapTipButtonType_zhenCha.buttonType = worldMapDefine.worldMapTipButtonType_qianru
					worldMapDefine.worldMapTipButtonType_zhenCha.isButtonEnabled = not isInPyramid
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_zhenCha)
				end
			end
		end
		if self:canHasEmojiOperator(selfPlayerID) then
			worldMapDefine = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
			table.insert(buttonTypeArray, selfPlayerID)
		end
	end
	local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
	if worldMapDefine.isNebulaAllStarKingdomID(self.kingdomID) and nebulaAllStarCtrl:getIsViewer() then
		worldMapDefine = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_nebulaAllStar_gift
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	if not worldMapDefine.isInNebulaAllStar() or (self.playerID or 0) ~= selfPlayerID then
		worldMapDefine = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	if not isInWar then
		if self.compMap.buildOfficer:checkLeaguedOfficialType() then
			worldMapDefine = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_leaguerenMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
		if self.compMap.buildOfficer:checkKingStarOfficialType() then
			worldMapDefine = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_kingStar_renMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
		if self.compMap.buildOfficer:checkHegemonOfficialType() then
			worldMapDefine = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_hegemonrenMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
	end
	local prisonerNum = self.compMap.buildPrisone:getPrisonerNum()
	if 0 < prisonerNum then
		worldMapDefine = worldMapDefine.worldMapTipButtonType_hegemonrenMing
		worldMapDefine.worldMapTipButtonType_hegemonrenMing.buttonType = worldMapDefine.worldMapTipButtonType_prisonerIn
		table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_hegemonrenMing)
	end
	if worldMapDefine.isRemainsKingdomID(self.kingdomID) and not worldMapDefine.isInRemains() then
		worldMapDefine = worldMapDefine.worldMapTipButtonType_hegemonrenMing
		worldMapDefine.worldMapTipButtonType_hegemonrenMing.buttonType = worldMapDefine.worldMapTipButtonType_remains_buff
		table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_hegemonrenMing)
	end
	return buttonTypeArray
end
function worldMapBuilding:updateTopShowIcons(...)
	_UPVALUE1_ = nil
	;(nil)[1] = self.compMap.buildPrisone:getPrisoneInIcon()
	;(nil)[2] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[3] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[4] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[5] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[6] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[7] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[8] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[9] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[10] = self.compMap.buildOfficer:getOfficalImage()
	;(nil)[11] = self.compMap.buildOfficer:getOfficalImage()
	local (nil)[12], sortList = self.compMap.buildOfficer:getOfficalImage()
	local _ENV, needShowTitleList = self.compMap.buildPrisone:getPrisoneInIcon(), self.compMap.buildPrisone:getPrisoneInIcon()
	for _, v in ipairs(sortList) do
		if v and v:isVisible() then
			table.insert(needShowTitleList, v)
		end
	end
	if 1 <= #needShowTitleList then
		local dis = #needShowTitleList * 105 / 2
		for i, v in ipairs(needShowTitleList) do
			v:setPosition(cc.p(self.centerPoint.x - dis + 52.5 + (i - 1) * 105, self.centerPoint.y + 120))
		end
	end
end
function worldMapBuilding:updateWallWarning(target, data)
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local playerID = self.playerID or 0
	if selfPlayerID == playerID and playerID ~= 0 then
		local tipsHandler = function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
			;(nil).bid = BUILDID.WALLS
			local (nil).view, data = "defendView", nil
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			;(nil).otherData = data
			SoraDSendMessage(nil)
			SoraDRemoveAllPanelFromManager()
		end
		if worldMapDefine.isInNewTrial() then
			self:showWarningTip("devilvalley_text_23", tipsHandler)
		end
	end
end
function worldMapBuilding:getSourceKingdomID()
	if self.sourceKingdomID then
		return self.sourceKingdomID
	end
	return self.kingdomID
end
function worldMapBuilding:test3dPet()
	self.compMap.build3dPet:test3dPet()
end
function worldMapBuilding:sendTileEffectMessage(updateType, raduis)
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local playerID = self.playerID or 0
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local leagueID = self.leagueID or 0
	local _raduis = raduis or talentSkillCtrl:getSkillConfig(3).raduis
	gametop = 3
	;(3).msg = "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT"
	;(3).tilePoint = self:getTilePoint()
	;(3).holdInstace = self:getHoldInstace()
	;(3).radiation = _raduis
	;(3).isSelf = 0 < selfLeagueID and selfLeagueID == leagueID
	;(3).instanceID = self.instanceID
	;(3).updateType = updateType
	SoraDSendMessage(3)
end
function worldMapBuilding:onClickInstance(onShowView)
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapBuilding:onShowWorldMapTip(...)
	if gAtlantisUseSkillEffect then
		local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
		atlantisWarCtrl:reqThrowBossSkillToPlayer(gAtlantisUseSkillEffect, self.playerID)
		gAtlantisUseSkillEffect = nil
		return nil, false
	end
	self:setIsOnClick(true)
	return worldMapInstance.onShowWorldMapTip(self, ...)
end
function worldMapBuilding:setIsOnClick(isOnClick)
	self.compMap.buildSignature:setIsOnClick(isOnClick)
end
function worldMapBuilding:getSignature(...)
	return self.compMap.buildSignature:getSignature(...)
end
function worldMapBuilding:isSysWarProtect(...)
	return self.compMap.buildProtect:isSysWarProtect(...)
end
function worldMapBuilding:getAllianceAbbr(...)
	return self.leagueName
end
return worldMapBuilding
