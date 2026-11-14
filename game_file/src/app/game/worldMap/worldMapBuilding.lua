local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local legendLordCtrl = gametop.playertop_:getModule("legendLordCtrl")
local kingStarCtrl = gametop.playertop_:getModule("kingStarCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local allianceCounterSysCtrl = gametop.playertop_:getModule("allianceCounterSysCtrl")
local worldMapEffect = include("worldMapEffect")
local worldMapDefine = include("worldMapDefine")
local instanceCacheMgr = include("instanceCacheMgr")
local castleSkinConfigRead = include("castleSkinConfigRead")
local talentSkillCtrl = _G.SoraDGetCtrl("talentSkillCtrl")
local worldMapInstance = include("worldMapInstance")
local cityltCtrl = include("cityltCtrl")
local devicePerformanceUtil = require("app.devicePerformanceUtil")
local IMG_PROTECT_SCALE_DEF = 0.75
local IMG_PROTECT_SCALE_WAR = 0.95
local IMG_PROTECT_SCALE_WAR_10 = 1.0
local IMG_PROTECT_SCALE_SKIN = 0.9
local IMG_OFFSET_DEF = cc.p(0, 70)
local IMG_OFFSET_WAR = cc.p(-25, 110)
local IMG_OFFSET_WAR_10 = cc.p(0, 70)
local IMG_OFFSET_SKIN = cc.p(-30, 70)
local GROU_ID = worldMapDefine.GROU_ID
local gShowOfficialType = _G.gShowOfficialType
local worldMapBuilding = class("worldMapBuilding", function()
	local target = worldMapInstance.new("worldMapBuilding")
	return target
end)
function worldMapBuilding:ctor()
	self.bulletNum = 20
	self:_initData()
	self:_initUI()
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
end
function worldMapBuilding:onExitOther()
	local moveLineAutoHideOption = worldMapDefine.moveLineAutoHideOption
	moveLineAutoHideOption.buildingCount = moveLineAutoHideOption.buildingCount - 1
end
function worldMapBuilding:_initData()
	self.playerID = 0
	self.playerName = nil
	self.playerLevel = 1
	self.isShowWarLv = false
	self.inMapId = nil
	self:setName("worldMapBuilding")
	_ENV = "worldMapBuilding"
	;("worldMapBuilding").byUID = true
	local isShowOfficeIcon = SoraDConfigGet("Game:worldMapOfficeIcon:OfficeIcon~bool", "worldMapBuilding")
	if isShowOfficeIcon == nil then
		isShowOfficeIcon = true
	end
	_ENV = nil
	;(nil).byUID = true
	local isShowPrisionIcon = SoraDConfigGet("Game:castleChangeSetting:PrisonHeroIcon~bool", nil)
	if isShowPrisionIcon == nil then
		isShowPrisionIcon = true
	end
	self.isShowOffice = isShowOfficeIcon
	self.isShowPrision = isShowPrisionIcon
	self.cityLevel = 1
	self.showOfficialType = nil
	self.officialType = 0
	self.leaguedOfficialType = 0
	self.kingStarOfficialType = 0
	self.hegemonOfficialType = 0
	self.atlantisOfficialType = 0
	self.nebulaOfficialID = 0
	self.nebulaOfficialID2 = 0
	self.emperorOfficial = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warCamp = nil
	self.isSafe = false
	self.betray = 0
	self.prisonerNum = 0
	self.buildingState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.sourceID = 0
	self.rfKid = 0
	self.sourceKingdomID = nil
	self.emojiID = nil
	self.hideBattleLev = false
	self.facePoint = cc.p(0, 0)
	self.isCityBgSkin = 0
	self.fireNode_ex = nil
	self.imgScale = IMG_PROTECT_SCALE_DEF
	self.imgOffset = IMG_OFFSET_DEF
	self.isOnClick = false
	self.signature = nil
	self.starLv = 0
end
function worldMapBuilding:_initUI()
	self.cityImage = display.newSprite("#Castle_lv1_base.png")
	self:addChild(self.cityImage, -1)
	self.citySkin1Image = display.newSprite("#Castle_ramadan.png")
	self.citySkin1Image:setVisible(false)
	self:addChild(self.citySkin1Image, -1)
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
	self.image_Protect = worldMapDefine.createWorldMapProtectNew()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
	self.image_Protect:addTo(self, 4)
	self.bulletNode = display.newNode()
	self:addChild(self.bulletNode, 4)
	self.warLVnode = display.newNode()
	self:addChild(self.warLVnode)
	self.node_warLvNode = nil
end
function worldMapBuilding:isInAllianceWar()
	if self.inMapId then
		return self.inMapId ~= self.kingdomID
	end
	return false
end
local POINT_ZERO = cc.p(0, 0)
function worldMapBuilding:addCacheBefore()
	self:clearCastleSkinToCache()
	self.cityImage:setPosition(POINT_ZERO)
	self.cityImage:removeAllChildren()
	self.citySkin1Image:removeAllChildren()
	self:removeSkinEffect()
	self:removeWarLvEffect()
	if self.officalImage then
		self.officalImage:setVisible(false)
		self.officalIcon:removeAllChildren()
	end
	self.image_LeagueFlag:setVisible(false)
	self.image_crown:setVisible(false)
	self.image_zhencha:setVisible(false)
	self.image_Protect:setVisible(false)
	self:removePyramidProtectEffect()
	self:removeCastleEffect(true)
	self:removeCastleFireWorkEffect()
	self:removeEnemyCastleEffect()
	if self.fireNode_ex then
		self.fireNode_ex:removeFromParent()
		self.fireNode_ex = nil
	end
	self.moveCityTime = nil
	if self.nodeMoveCityTime then
		self.nodeMoveCityTime:setVisible(false)
		if self.txtMoveCityTime then
			self.txtMoveCityTime:removeTime()
		end
	end
	if self.tipsNode then
		self.tipsNode:removeFromParent()
		self.tipsNode = nil
	end
	self.warCamp = nil
	self:removeBuildStarEffect()
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
		self:updateBuildStar(self._starLv)
		self:warLvEffect(self._warLv)
		self:updateBuildingImg()
	end)
end
function worldMapBuilding:setBatchNodeGroupID(groupID)
	self.cityImage:setGroupID(groupID)
	self.cityImage:setGroupAuto(true)
end
local tableCastleTable = worldMapDefine.tableCastleTable
function worldMapBuilding:setSkinGroupID(model)
	local cityBuildCastleSkinConfig = include("cityBuildCastleSkinConfig")
	local skinType = cityBuildCastleSkinConfig.getOwnTexture(model)
	local groupID = tableCastleTable[skinType]
	if groupID then
		self.citySkin1Image:setGroupID(groupID)
		self.citySkin1Image_groupID = groupID
	end
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
	if data.hideBattleLev ~= nil then
		self.hideBattleLev = data.hideBattleLev
	end
	self._starLv = data.starLv
	if data.official or data.showOfficialType or data.worldOfficial or data.hegemonOfficial or data.atlantisOfficialType or data.nebulaOfficialID or data.nebulaOfficialID2 or data.legendForSepOfficial or data.emperorOfficial then
		if data.official then
			self.officialType = data.official
		end
		if data.worldOfficial then
			self.leaguedOfficialType = data.worldOfficial
		end
		if data.legendForSepOfficial then
			self.kingStarOfficialType = data.legendForSepOfficial
		end
		if data.hegemonOfficial then
			self.hegemonOfficialType = data.hegemonOfficial
		end
		if data.showOfficialType then
			self.showOfficialType = data.showOfficialType
		end
		if data.atlantisOfficialType then
			self.atlantisOfficialType = data.atlantisOfficialType
		end
		if data.nebulaOfficialID then
			self.nebulaOfficialID = data.nebulaOfficialID
		end
		if data.nebulaOfficialID2 then
			self.nebulaOfficialID2 = data.nebulaOfficialID2
		end
		if data.emperorOfficial then
			self.emperorOfficial = data.emperorOfficial
		end
		self:updateOfficial()
		self:updateTopShowIcons()
	end
	if data.factionType then
		self.factionType = data.factionType
	end
	self:updateEmojiByData(data)
	if data.prisonerNum ~= nil then
		self.prisonerNum = data.prisonerNum
		self:updatePrisoneIn()
		self:updateTopShowIcons()
	end
	if data.betray then
		self.betray = data.betray
		local returnHeadImg = function(...)
			local headIcon = self:getChildByName("Image_betrayFrm")
			if not headIcon then
				headIcon = ccui.Button:create("icon_alliance_traitor.png", "icon_alliance_traitor.png", "icon_alliance_traitor.png", ccui.TextureResType.plistType)
				headIcon:setScale(0.5)
				headIcon:setPosition(cc.p(self.centerPoint.x + 100, self.centerPoint.y - 82))
				headIcon:addTo(self, 2)
				headIcon:setName("Image_betrayFrm")
				headIcon:addTouchEventListener(function(button, eventType)
					if eventType == ccui.TouchEventType.ended then
						SoraDShowMsgBox(i18n("common_text_4144"), i18n("common_text_204"))
					end
				end)
			end
			return headIcon
		end
		if 0 < data.betray then
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			if conquestWarCtrl:getConquestWarState() == gConquestWarState.OPENING then
				local head = returnHeadImg()
				head:setVisible(true)
			end
		else
			local headIcon = self:getChildByName("Image_betrayFrm")
			if headIcon then
				headIcon:setVisible(false)
			end
		end
	end
	if data.cityLevel then
		self.cityLevel = data.cityLevel
		self.instanceLevel = self.cityLevel
		local textShowLV
		self.isShowWarLv, textShowLV = SoraDGetBuildWarLv(self.cityLevel)
		if self.isShowWarLv then
			self.image_level:setSpriteFrame("icon_main_build_warlv.png")
			self.image_level:setGroupID(0)
			self.image_level:setPosition(cc.p(self.centerPoint.x + 90, self.centerPoint.y - 50))
			self.text_Level:setPosition(cc.p(self.centerPoint.x + 110, self.centerPoint.y - 59))
		else
			self.image_level:setSpriteFrame("icon_main_build_lv.png")
			self.image_level:setGroupID(GROU_ID.group_level_build)
			self.image_level:setPosition(cc.p(self.centerPoint.x + 60, self.centerPoint.y - 50))
			self.text_Level:setPosition(cc.p(self.centerPoint.x + 80, self.centerPoint.y - 53))
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
		textName = i18n("common_text_496")
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
			else
				if (0 < self.rfKid and self.rfKid or self.sourceID) ~= self.kingdomID then
					nameColor = cc.c3b(190, 190, 190)
				end
				textName = self:setWarPlayerInfo(nil, nil, textName)
			end
		end
	end
	if worldMapDefine.isInNebula() then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = self:setWarPlayerInfo(nil, nil, textName)
		self:setWarPlayerInfo(nil, nil, textName).playerID = self.playerID
		self:setWarPlayerInfo(nil, nil, textName).leagueID = self.leagueID
		self:setWarPlayerInfo(nil, nil, textName).camp = self.warCamp
		nameColor = worldMapWarDef.getNameColorInNebula((self:setWarPlayerInfo(nil, nil, textName)))
	elseif worldMapDefine.isInNebulaAllStar(true) then
		local worldMapWarDef = include("worldMapWarDef")
		_ENV = self:setWarPlayerInfo(nil, nil, textName)
		self:setWarPlayerInfo(nil, nil, textName).camp = self.warCamp
		nameColor = worldMapWarDef.getNameColor((self:setWarPlayerInfo(nil, nil, textName)))
	end
	self.text_Name:setColor(nameColor)
	self.text_Name:setString(textName)
	if data.castleSkin then
		self.isCityBgSkin = data.castleSkin
		self:updateBuildingImg()
	end
	if data.nameBox then
		if data.nameBox ~= 0 then
			local castleSkinRead = include("castleSkinRead")
			local dressltCtrl = include("dressltCtrl")
			local nameBgSkin = castleSkinRead.getNameFloor(data.nameBox)
			local subType = dressltCtrl.getSubType(data.nameBox)
			print("nameBgSkin,subType=====", nameBgSkin, subType)
			if nameBgSkin and 0 < string.len(nameBgSkin) then
				self.image_crown:setVisible(false)
				self.image_name:setVisible(false)
				self.image_name_bg:setVisible(false)
				self.image_nameBgSkin:setVisible(true)
				self.image_nameBgSkin:setSpriteFrame(nameBgSkin)
				self.image_nameBgSkin:removeAllChildren()
				self.text_Name:setPositionY(self.centerPoint.y - 90)
				local nameBoxCfg = castleSkinConfigRead.getNameBoxCfg(subType)
				if nameBoxCfg then
					print("offSetY=======", nameBoxCfg.offSetY)
					self.text_Name:setPositionY(self.centerPoint.y - 90 + nameBoxCfg.offSetY)
					if nameBoxCfg.color then
						self.text_Name:setColor(nameBoxCfg.color)
					end
				end
				if subType == 417 then
					local et_bgsk = display.newSprite("#dh_ltmp_01.png")
					SoraDMixtureGLONE(et_bgsk)
					et_bgsk:setPosition(self.image_nameBgSkin:getContentSize().width / 2, self.image_nameBgSkin:getContentSize().height / 2)
					et_bgsk:addTo(self.image_nameBgSkin)
					local frames = display.newFrames("dh_ltmp_%.2d.png", 1, 24)
					local animation = display.newAnimation(frames, 2 / #frames)
					et_bgsk:playAnimationForever(animation)
				end
				if subType == 425 then
					local et_bgsk = display.newSprite("#dh_yqzcltzb_mp_01.png")
					SoraDMixtureGLONE(et_bgsk)
					et_bgsk:setPosition(self.image_nameBgSkin:getContentSize().width / 2, self.image_nameBgSkin:getContentSize().height / 2)
					et_bgsk:addTo(self.image_nameBgSkin)
					local frames = display.newFrames("dh_yqzcltzb_mp_%.2d.png", 1, 24)
					local animation = display.newAnimation(frames, 2 / #frames)
					et_bgsk:playAnimationForever(animation)
				end
			end
		else
			self.image_name_bg:setVisible(SoraDGetCastleWarLv() >= 5)
			self.image_name:setVisible(true)
			self.image_nameBgSkin:setVisible(false)
			if self.playerID == selfPlayerID then
				self.image_crown:setVisible(true)
				self.text_Name:setPositionY(self.centerPoint.y - 90)
			end
		end
	end
	if data.moveCityCDEndTime then
		if 0 < data.moveCityCDEndTime then
			local time = data.moveCityCDEndTime - serviceFunctions.systemTime()
			if 0 < time then
				self.moveCityTime = time
				self:updateMoveTime()
			elseif self.moveCityTime then
				self:cleanMoveTime()
			end
		else
			self:cleanMoveTime()
		end
	end
	self:updateBuildingState()
	self:updateSafeState()
	self:updateWarLvEffect()
	self:updateAllianceCounterAtkEffect()
	local castleEffect = data.castleEffect
	local castleEffectStatusEndTime = data.castleEffectStatusEndTime
	local selfCastleEffect = data.selfCastleEffect
	local castleAppearance = data.castleAppearance
	local selfCastleEffectStatusEndTime = data.selfCastleEffectStatusEndTime
	local castleAppearanceEndTime = data.castleAppearanceEndTime
	if castleEffect then
		if 0 < castleEffect and castleEffectStatusEndTime and -1 < castleEffectStatusEndTime then
			self:removeCastleEffect()
			if castleEffect == worldMapCastleEffectID.Crystal_Heart then
				self:castleLoveEffect()
			elseif castleEffect == worldMapCastleEffectID.Rainbow_castle then
				self:castleRainbowEffect()
			elseif castleEffect == worldMapCastleEffectID.Shining_Castle then
				self:castleShiningEffect()
			elseif castleEffect == worldMapCastleEffectID.Shining_Castle_2 then
				self:castleShining2Effect()
			elseif castleEffect == worldMapCastleEffectID.Shining_Castle_3 then
				self:castleShining3Effect()
			elseif castleEffect == worldMapCastleEffectID.IceWolf_Castle then
				self:castleShining4Effect()
			elseif castleEffect == worldMapCastleEffectID.IceGragon_Castle then
				self:castleShining5Effect()
			end
		else
			self:removeCastleEffect()
		end
	end
	if selfCastleEffect then
		if 0 < selfCastleEffect and selfCastleEffectStatusEndTime and -1 < selfCastleEffectStatusEndTime then
			self:removeCastleFireWorkEffect()
			local leftTime = selfCastleEffectStatusEndTime - serviceFunctions.systemTime()
			if selfCastleEffect == worldMapCastleEffectID.Flowery_Firework or selfCastleEffect == worldMapCastleEffectID.Victory_Firework or selfCastleEffect == worldMapCastleEffectID.Festival_Firework or selfCastleEffect == worldMapCastleEffectID.NewYear_FireWork_2020 or selfCastleEffect == worldMapCastleEffectID.NewYear_FireWork_2022 or selfCastleEffect == worldMapCastleEffectID.FirewWork_Ceremony then
				self.fireWork = include("worldMapFireWorkEffect").new(selfCastleEffect)
				self:addChild(self.fireWork)
				self.fireWork:play()
				if self.playerID == selfPlayerID then
					self.fireWorkTimeNode = worldMapEffect.createFireTimeNode()
					self.fireWorkTimeNode:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 120))
					self.fireWorkTimeNode:addTo(self, 5)
					self.fireWorkTimeNode.init(leftTime)
				end
			end
			if selfCastleEffect == worldMapCastleEffectID.Snow_Effect and 0 < leftTime then
				self:castleSnowEffect()
			end
		else
			self:removeCastleFireWorkEffect()
		end
	end
	if castleAppearance then
		self:castleSnowIceEffect(self.playerID == selfPlayerID)
	end
	if data.attr then
		local isAdd = false
		for i, v in ipairs(gRangeAttributeList) do
			local attr = data.attr[tostring(v)]
			if attr then
				if self:isNeedShowAttr(v) then
					self:sendTileEffectMessage(worldMapLeagueManorUpdateType.leagueManorInstanceAdd, attr.range)
					self:checkAllCastleMeteorteEffect(data.attr, false)
					isAdd = true
				end
				break
			end
		end
		if not isAdd then
			self:sendTileEffectMessage(worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
		end
	else
		self:removeMeteoriteSkillEffect()
	end
	if data.signature then
		self.signature = data.signature
		self.signatureBox = data.signatureBox
	end
	self:refreshSignText()
	self:refreshSkillEffect(data)
	self:updateBuildStar(data.starLv)
	self:updateNebulaAllStarValue(data)
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
function worldMapBuilding:setCitySkinName(node, nodeName)
	node:setCacheName(nodeName)
	if not self.castleSkinNods then
		self.castleSkinNods, _UPVALUE0_ = self.castleSkinNods, self.castleSkinNods
	end
	self.castleSkinNods[nodeName] = node
end
local addToInstanceCache = function(node, nodeName)
	if not node or tolua.isnull(node) then
		return
	end
	instanceCacheMgr.addNormalNodeByType(node, nodeName)
	node:removeFromParent(false)
end
function worldMapBuilding:addFromInstanceCache(name, order)
	local child = instanceCacheMgr.getInstance(name)
	if child ~= nil then
		self:setCitySkinName(child, name)
		self:addChild(child, order == nil and 2 or order)
		child:release()
		child:setVisible(true)
	end
	return child
end
function worldMapBuilding:clearCastleSkinToCache()
	if self.castleSkinNods then
		for name, node in pairs(self.castleSkinNods) do
			addToInstanceCache(node, name)
			self.castleSkinNods[name] = nil
		end
	end
end
function worldMapBuilding:updateBuildingImg()
	self.cityImage:removeAllChildren()
	self.citySkin1Image:removeAllChildren()
	self:removeSkinEffect()
	self:removeWarLvEffect()
	if worldMapDefine.isNebulaAllStarKingdomID(self.kingdomID) then
		self.hideBattleLev = true
		self.cityImage:setSpriteFrame("allstar_player_city.png")
		self.cityImage:setPosition(cc.p(0, 70))
		self.cityImage:setScale(0.9)
		if not self.nebulaAllStarEffect then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			worldMapDefine = 0.9
			;(0.9).mapType = gMapObjTypeDef.mapObjTypePlayer
			;(0.9).parent = self
			;(0.9).pos = cc.p(0, 70)
			;(0.9).scale = 0.9
			;(0.9).Sprite_build = self.cityImage
			;(0.9).groupID = GROU_ID.castleBatchNode
			local spriteEffect = nebulaAllStarUtil.getBuildSpriteEffect(0.9)
			self.nebulaAllStarEffect = spriteEffect
		end
		return
	end
	local textShowLV
	self.isShowWarLv, textShowLV = SoraDGetBuildWarLv(self.cityLevel)
	if self.isShowWarLv then
		self:warLvEffect(textShowLV)
	end
	local isWarLV5 = self.isShowWarLv and 5 <= textShowLV
	self.image_name_bg:setVisible(isWarLV5)
	self:clearCastleSkinToCache()
	if self.isCityBgSkin ~= 0 and not self.node_snowMan and self:isShowCastleSkin() then
		local castleSkinRead = include("castleSkinRead")
		local skinImageName = castleSkinRead.getMapImage(self.isCityBgSkin)
		local castleModel = castleSkinRead.getCastleType(self.isCityBgSkin)
		if skinImageName and 0 < string.len(skinImageName) then
			self.cityImage:setVisible(false)
			self.citySkin1Image:setVisible(true)
			self.citySkin1Image:setSpriteFrame(skinImageName)
			self:setSkinGroupID(castleModel)
			self.curCityImage = self.citySkin1Image
			local skinOffset = castleSkinConfigRead.getSkinOffset(castleModel)
			if skinOffset then
				self.curCityImage:setPosition(skinOffset)
			end
			self.curCityImage:setScale(1.0)
			self.curCityImage:stopAllActions()
			if castleModel == BUILD_CASTLE_MODEL.KINGCOBRA then
				self.curCityImage:setScale(0.9)
			end
			self.imgScale = IMG_PROTECT_SCALE_SKIN
			self.imgOffset = IMG_OFFSET_SKIN
			self:addSkinEffect(castleModel)
			if self.isShowWarLv then
				self:setSkinConfig(castleModel, textShowLV)
			end
			if castleModel == BUILD_CASTLE_MODEL.THUNDERCLOUD then
				self.citySkin1Image:setVisible(false)
				local tmpNode = self:addFromInstanceCache("Node_thunder_1")
				local Node_thunder_1, action = SoraDCreatAnimation("Node_thunder_1", tmpNode, false)
				if tmpNode == nil then
					self:setCitySkinName(Node_thunder_1, "Node_thunder_1")
					Node_thunder_1:addTo(self, 2)
				end
				Node_thunder_1:setPosition(0, 100)
				action:setFrameEventCallFunc(function(frameEventName)
					local frameEvent = frameEventName:getEvent()
					if frameEvent and frameEvent == "toSecond" then
						local tmpNode = self:addFromInstanceCache("Node_thunder_2")
						local Node_thunder_2 = SoraDCreatAnimation("Node_thunder_2", tmpNode)
						if tmpNode == nil then
							self:setCitySkinName(Node_thunder_2, "Node_thunder_2")
							Node_thunder_2:addTo(self, 2)
						end
						Node_thunder_2:setPosition(0, 100)
					end
				end)
			elseif castleModel == BUILD_CASTLE_MODEL.ALLSTARSHIP then
				self.citySkin1Image:setVisible(false)
				local Node_allstarShip = self:addFromInstanceCache("Node_allstarShip")
				if Node_allstarShip == nil then
					Node_allstarShip = SoraDCreatAnimation("Node_allstarShip")
					self:setCitySkinName(Node_allstarShip, "Node_allstarShip")
					Node_allstarShip:addTo(self, 2)
				else
					SoraDCreatAnimation("Node_allstarShip", Node_allstarShip)
				end
				Node_allstarShip:setPosition(-90, 110)
			elseif castleModel == BUILD_CASTLE_MODEL.KOH2024RAMADAN then
				self.citySkin1Image:setVisible(false)
				local Node_ramadan2024 = self:addFromInstanceCache("Node_ramadan2024")
				if Node_ramadan2024 == nil then
					Node_ramadan2024 = SoraDCreatAnimation("Node_ramadan2024")
					self:setCitySkinName(Node_ramadan2024, "Node_ramadan2024")
					Node_ramadan2024:addTo(self, 2)
				else
					SoraDCreatAnimation("Node_ramadan2024", Node_ramadan2024)
				end
				Node_ramadan2024:setPosition(-80, 100)
				Node_ramadan2024:setScale(1.3)
			elseif castleModel == BUILD_CASTLE_MODEL.SEVENTH then
				self.citySkin1Image:setVisible(false)
				local tmpNode = self:addFromInstanceCache("Node_starfall_1", -2)
				local Node_starfall_1, action = SoraDCreatAnimation("Node_starfall_1", tmpNode, false)
				if tmpNode == nil then
					self:setCitySkinName(Node_starfall_1, "Node_starfall_1")
					Node_starfall_1:addTo(self, -2)
				end
				Node_starfall_1:setPosition(0, 50)
				action:setFrameEventCallFunc(function(frameEventName)
					local frameEvent = frameEventName:getEvent()
					if frameEvent and frameEvent == "toSecond" then
						local tmpNode = self:addFromInstanceCache("Node_starfall_2", -1)
						local Node_starfall_2, action2 = SoraDCreatAnimation("Node_starfall_2", tmpNode, false)
						if tmpNode == nil then
							self:setCitySkinName(Node_starfall_2, "Node_starfall_2")
							Node_starfall_2:addTo(self, -1)
						end
						if self.citySkin1Image_groupID then
							SoraDGetChildByName(Node_starfall_2, "chengbaozhuangban_01"):setGroupID(self.citySkin1Image_groupID)
						end
						Node_starfall_2:setPosition(0, 80)
						action2:setFrameEventCallFunc(function(frameEventName)
							local frameEvent = frameEventName:getEvent()
							if frameEvent and frameEvent == "tothree" then
								local tmpNode = self:addFromInstanceCache("Node_starfall_3", -1)
								local Node_starfall_3, action3 = SoraDCreatAnimation("Node_starfall_3", tmpNode)
								if tmpNode == nil then
									self:setCitySkinName(Node_starfall_3, "Node_starfall_3")
									Node_starfall_3:addTo(self, -1)
								end
								Node_starfall_3:setPosition(0, 80)
								if self.citySkin1Image_groupID then
									SoraDGetChildByName(Node_starfall_3, "chengbaozhuangban_02"):setGroupID(self.citySkin1Image_groupID)
								end
								if not tolua.isnull(Node_starfall_1) then
									Node_starfall_1:setVisible(false)
								end
								if not tolua.isnull(Node_starfall_2) then
									Node_starfall_2:setVisible(false)
								end
							end
						end)
					end
				end)
			elseif castleModel == BUILD_CASTLE_MODEL.DAGGER then
				local Node_dagger = self:addFromInstanceCache("Node_dagger")
				if Node_dagger == nil then
					Node_dagger = SoraDCreatAnimation("Node_dagger")
					self:setCitySkinName(Node_dagger, "Node_dagger")
					Node_dagger:addTo(self, 2)
				else
					SoraDCreatAnimation("Node_dagger", Node_dagger)
				end
				Node_dagger:setPosition(-30, 144)
			elseif castleModel == BUILD_CASTLE_MODEL.CORBAN2021 then
				local Node_coffee = self:addFromInstanceCache("Node_coffee")
				if Node_coffee == nil then
					Node_coffee = SoraDCreatAnimation("Node_coffee")
					self:setCitySkinName(Node_coffee, "Node_coffee")
					Node_coffee:addTo(self, 2)
				else
					SoraDCreatAnimation("Node_coffee", Node_coffee)
				end
				Node_coffee:setPosition(0, 100)
			elseif castleModel == BUILD_CASTLE_MODEL.HOURGLASS then
				local Node_sgsl = self:addFromInstanceCache("Node_sgsl")
				if Node_sgsl == nil then
					Node_sgsl = SoraDCreatAnimation("Node_sgsl")
					self:setCitySkinName(Node_sgsl, "Node_sgsl")
					Node_sgsl:addTo(self, 2)
				else
					SoraDCreatAnimation("Node_sgsl", Node_sgsl)
				end
				Node_sgsl:setPosition(-15, -20)
			elseif castleModel == BUILD_CASTLE_MODEL.AFTERNOONDESSERT then
				local Node_whtd = self:addFromInstanceCache("Node_whtd")
				if Node_whtd == nil then
					Node_whtd = SoraDCreatAnimation("Node_whtd")
					self:setCitySkinName(Node_whtd, "Node_whtd")
					Node_whtd:addTo(self, 2)
				else
					SoraDCreatAnimation("Node_whtd", Node_whtd)
				end
				Node_whtd:setPosition(-31, 132)
			elseif castleModel == BUILD_CASTLE_MODEL.DEGULA then
				local dglNode = self:addFromInstanceCache("dglNode")
				if dglNode == nil then
					dglNode = SoraDCreatAnimation("degulacbwai")
					self:setCitySkinName(dglNode, "dglNode")
					dglNode:addTo(self, 2)
				else
					SoraDCreatAnimation("degulacbwai", dglNode)
				end
				dglNode:setPosition(40, 40)
			elseif castleModel == BUILD_CASTLE_MODEL.ICECASTLE then
				local castle47effect = self:addFromInstanceCache("castle47effect")
				if castle47effect == nil then
					castle47effect = SoraDCreatAnimation("castle47effect")
					self:setCitySkinName(castle47effect, "castle47effect")
					castle47effect:addTo(self, 2)
				else
					SoraDCreatAnimation("castle47effect", castle47effect)
				end
				castle47effect:setPosition(-64, 100)
			elseif castleModel == BUILD_CASTLE_MODEL.CONSTRUCTED then
				local cscNode = self:addFromInstanceCache("cscNode")
				if cscNode == nil then
					cscNode = SoraDCreatAnimation("constructedCastle")
					self:setCitySkinName(cscNode, "cscNode")
					cscNode:addTo(self, 2)
				else
					SoraDCreatAnimation("constructedCastle", cscNode)
				end
				cscNode:setPosition(-2, 124)
			elseif castleModel == BUILD_CASTLE_MODEL.KOH2021RAMADAN then
				local xlcbfdNode = self:addFromInstanceCache("xlcbfdNode")
				if xlcbfdNode == nil then
					xlcbfdNode = SoraDCreatAnimation("animationXLCBFD")
					self:setCitySkinName(xlcbfdNode, "xlcbfdNode")
					xlcbfdNode:addTo(self, 1)
				else
					SoraDCreatAnimation("animationXLCBFD", xlcbfdNode)
				end
				xlcbfdNode:setPosition(-70, -20)
			elseif castleModel == BUILD_CASTLE_MODEL.STARKING then
				local xczwcbNode = self:addFromInstanceCache("xczwcbNode")
				if xczwcbNode == nil then
					xczwcbNode = SoraDCreatAnimation("animationXCZWCB")
					self:setCitySkinName(xczwcbNode, "xczwcbNode")
					xczwcbNode:addTo(self, 1)
				else
					SoraDCreatAnimation("animationXCZWCB", xczwcbNode)
				end
				xczwcbNode:setPosition(-65, -40)
			elseif castleModel == BUILD_CASTLE_MODEL.MUSICCASTLESENIOR then
				local yqzchhNode = self:addFromInstanceCache("yqzchhNode", 1)
				if yqzchhNode == nil then
					yqzchhNode = SoraDCreatAnimation("animationYQZCHHB")
					self:setCitySkinName(yqzchhNode, "yqzchhNode")
					yqzchhNode:addTo(self, 1)
				else
					SoraDCreatAnimation("animationYQZCHHB", yqzchhNode)
				end
				yqzchhNode:setPosition(-65, 118)
			elseif castleModel == BUILD_CASTLE_MODEL.MUSICCASTLENORMAL then
				local yqzcptNode = self:addFromInstanceCache("yqzcptNode", 1)
				if yqzcptNode == nil then
					yqzcptNode = SoraDCreatAnimation("animationYQZCPTB")
					self:setCitySkinName(yqzcptNode, "yqzcptNode")
					yqzcptNode:addTo(self, 1)
				else
					SoraDCreatAnimation("animationYQZCPTB", yqzcptNode)
				end
				yqzcptNode:setPosition(-70, 112)
			elseif castleModel == BUILD_CASTLE_MODEL.FOOTBALL then
				local sjbcwNode = self:addFromInstanceCache("sjbcwNode", 1)
				if sjbcwNode == nil then
					sjbcwNode = SoraDCreatAnimation("animationSJBCW")
					self:setCitySkinName(sjbcwNode, "sjbcwNode")
					sjbcwNode:addTo(self, 1)
				else
					SoraDCreatAnimation("animationSJBCW", sjbcwNode)
				end
				sjbcwNode:setPosition(-50, 80)
			elseif castleModel == BUILD_CASTLE_MODEL.KINGSTARBATTLE then
				local xcwzcwNode = self:addFromInstanceCache("xcwzcwNode", 1)
				if xcwzcwNode == nil then
					xcwzcwNode = SoraDCreatAnimation("animationXCWZCW")
					self:setCitySkinName(xcwzcwNode, "xcwzcwNode")
					xcwzcwNode:addTo(self, 1)
				else
					SoraDCreatAnimation("animationXCWZCW", xcwzcwNode)
				end
				xcwzcwNode:setPosition(-30, 120)
			elseif castleModel == BUILD_CASTLE_MODEL.HALLOWEEN2018 then
				local sprite = self:addFromInstanceCache("citySkin1Image_down")
				if sprite == nil then
					sprite = display.newSprite("#Map_castle_Hallowmas2018_01.png")
					self:addChild(sprite, -2)
					self:setCitySkinName(sprite, "citySkin1Image_down")
				end
				sprite:setPosition(cc.p(-60, 40))
				IMG_OFFSET_SKIN = cc.p(-60, 40)
				cc.p(-60, 40)[1] = cca.moveBy(0.16666666666666666, 0, -1)
				cc.p(-60, 40)[2] = cca.moveBy(1.3333333333333333, 0, -9.0)
				cc.p(-60, 40)[3] = cca.moveBy(0.16666666666666666, 0, -1)
				cc.p(-60, 40)[4] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[5] = cca.moveBy(1.3333333333333333, 0, 9.0)
				cc.p(-60, 40)[6] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[7] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[8] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[9] = cca.moveBy(0.16666666666666666, 0, 1)
				sprite:runAction(cc.RepeatForever:create(cca.seq(cc.p(-60, 40))))
				if self.citySkin1Image_groupID then
					sprite:setGroupID(self.citySkin1Image_groupID)
				end
			elseif castleModel == BUILD_CASTLE_MODEL.GOLDENCITY then
				local curPosX = self.curCityImage:getPositionX()
				local curPosY = self.curCityImage:getPositionY()
				castleSkinConfigRead = cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[1] = cca.moveTo(0.03333333333333333, curPosX, curPosY - 0.08)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[2] = cca.moveTo(3.3, curPosX, curPosY - 15)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[3] = cca.moveTo(3.3, curPosX, curPosY - 0.08)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[4] = cca.moveTo(0.03333333333333333, curPosX, curPosY)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[5] = cca.moveTo(0.03333333333333333, curPosX, curPosY)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[6] = cca.moveTo(0.03333333333333333, curPosX, curPosY)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[7] = cca.moveTo(0.03333333333333333, curPosX, curPosY)
				cc.RepeatForever:create(cca.seq(cc.p(-60, 40)))[8] = cca.moveTo(0.03333333333333333, curPosX, curPosY)
				self.curCityImage:runAction(cc.RepeatForever:create(cca.seq(cc.RepeatForever:create(cca.seq(cc.p(-60, 40))))))
			elseif castleModel == BUILD_CASTLE_MODEL.EIGHTH then
				local frames = display.newFrames("dh_8zhouniancbcw_%.2d.png", 1, 15)
				local animation = display.newAnimation(frames, 1.5 / #frames)
				self.curCityImage:playAnimationForever(animation)
				self.curCityImage:setName("citySkin1Image")
			elseif castleModel == BUILD_CASTLE_MODEL.BUBBLE9TH then
				local sprite = self:addFromInstanceCache("Node_bubble")
				if sprite == nil then
					sprite = display.newSprite("#dh_castleSkin_70_01.png")
					local frames = display.newFrames("dh_castleSkin_70_%.2d.png", 1, 15)
					local animation = display.newAnimation(frames, 0.06666666666666667)
					sprite:playAnimationForever(animation)
					sprite:addTo(self, 1)
					self:setCitySkinName(sprite, "Node_bubble")
				end
				sprite:setPosition(-14, 161)
			end
			return
		end
	elseif self.isShowWarLv and (textShowLV == 5 or textShowLV == 10) then
		self.imgScale = IMG_PROTECT_SCALE_WAR_10
		self.imgOffset = IMG_OFFSET_WAR_10
	else
		self.imgScale = self.isShowWarLv and IMG_PROTECT_SCALE_WAR or IMG_PROTECT_SCALE_DEF
		self.imgOffset = self.isShowWarLv and IMG_OFFSET_WAR or IMG_OFFSET_DEF
	end
	if not self.node_snowMan then
		self.cityImage:setVisible(true)
		self.citySkin1Image:setVisible(false)
		worldMapDefine.createCityImageWithLevel(self.cityLevel, self.factionType, self.cityImage)
	end
end
function worldMapBuilding:updateBuildingNecklace()
	if self.neckLaceID and worldMapDefine.isInRadiance() then
		if not self.necklaceNode then
			self:createBuildingNecklace()
		end
		local equipDesRead = include("equipDesRead")
		self.necklaceNode:setVisible(true)
		local necklaceIcon = self.necklaceNode:getChildByName("necklaceIcon")
		necklaceIcon:setSpriteFrame(equipDesRead.getIcon(self.neckLaceID))
		local necklaceName = self.necklaceNode:getChildByName("necklaceName")
		necklaceName:setString(equipDesRead.getName(self.neckLaceID))
	elseif self.necklaceNode then
		self.necklaceNode:setVisible(false)
	end
end
function worldMapBuilding:createBuildingNecklace()
	self.necklaceNode = display.newNode()
	local necklaceIcon = display.newSpriteNoChild("#equip_01_6100111.png")
	necklaceIcon:setAnchorPoint(cc.p(0.5, 0.5))
	necklaceIcon:setScale(0.5)
	necklaceIcon:setName("necklaceIcon")
	necklaceIcon:addTo(self.necklaceNode)
	necklaceIcon:setPosition(0, 0)
	local image_name = display.newSpriteNoChild("#frame_map_07.png")
	image_name:setAnchorPoint(cc.p(0.5, 0.5))
	image_name:setPosition(cc.p(0, -50))
	image_name:addTo(self.necklaceNode)
	_ENV = image_name
	image_name.UILabelType = 2
	image_name.text = ""
	image_name.size = 14
	local necklaceName = SoraDCreateLabel(image_name)
	necklaceName:setAnchorPoint(cc.p(0.5, 0.5))
	necklaceName:addTo(self.necklaceNode)
	necklaceName:setName("necklaceName")
	necklaceName:setPosition(0, -50)
	necklaceName:setGroupID(GROU_ID.group_text)
	self.necklaceNode:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 150))
	self:addChild(self.necklaceNode, 4)
end
function worldMapBuilding:setLendLordPlayerInfo(name)
	local textName = name or self.playerName
	if self.sourceKingdomID and self.sourceKingdomID > 0 then
		textName = textName .. "#" .. self.sourceKingdomID
	end
	return textName
end
function worldMapBuilding:updateWarLvEffect(target, data)
	if self.warLVnode then
		self.warLVnode:setVisible(not self.hideBattleLev)
	end
end
function worldMapBuilding:updateAllianceCounter(target, data)
	if data and data.type and data.type == GREEN_POINT_NOTICE_TYPE.COUNTER_SYS then
		self:updateAllianceCounterAtkEffect()
	end
end
function worldMapBuilding:updateOfficeIcon(target, data)
	if self.officalImage then
		_ENV = nil
		;(nil).byUID = true
		local isShow = SoraDConfigGet("Game:worldMapOfficeIcon:OfficeIcon~bool", nil)
		if isShow == nil then
			isShow = true
		end
		if self.node_snowMan then
			isShow = false
		end
		self.isShowOffice = isShow
		self:updateOfficial()
	end
end
function worldMapBuilding:updatePrisionIcon(target, data)
	if self.prisoneInIcon then
		_ENV = nil
		;(nil).byUID = true
		local isShow = SoraDConfigGet("Game:castleChangeSetting:PrisonHeroIcon~bool", nil)
		if isShow == nil then
			isShow = true
		end
		if self.node_snowMan then
			isShow = false
		end
		self.isShowPrision = isShow
		self:updatePrisoneIn()
	end
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
function worldMapBuilding:addSkinEffect(castleModel)
	if not self.skinBgEffectNode then
		local et_node = worldMapDefine.getCastleSkinEffect(castleModel)
		if et_node then
			et_node:addTo(self, 1)
			self.skinBgEffectNode = et_node
		end
	end
end
function worldMapBuilding:removeSkinEffect()
	if self.skinBgEffectNode then
		self.skinBgEffectNode:removeFromParent()
		self.skinBgEffectNode = nil
	end
	if self.nebulaAllStarEffect then
		self.nebulaAllStarEffect:removeFromParent()
		self.nebulaAllStarEffect = nil
	end
end
function worldMapBuilding:setSkinConfig(castleModel, warLv)
	local config = castleSkinConfigRead.getSkinWarLvConfig(castleModel, warLv)
	if config then
		self.warLVnode:setScale(config.scale)
		self.warLVnode:setPosition(config.offset)
	else
		self.warLVnode:setScale(1)
		local data = worldMapDefine.getWarLevelData(warLv)
		local offset = data.offset or cc.p(0, 0)
		self.warLVnode:setPosition(offset)
		if self.curCityImage then
			self.curCityImage:setPosition(cc.p(0, 0))
		end
	end
end
function worldMapBuilding:updateBuildingState()
	self:updateFireEffect(self.buildingState)
end
function worldMapBuilding:setImgProtect()
	if self:isSysWarProtect() then
		self.image_Protect:setIsGray(true)
	else
		self.image_Protect:setIsGray(false)
	end
	self.image_Protect:setVisible(true)
	self.image_Protect:setScale(self.imgScale)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + self.imgOffset.x, self.centerPoint.y + self.imgOffset.y))
end
function worldMapBuilding:updateSafeState()
	if self:isInAllianceWar() then
		self:setImgProtect()
		self:addPyramidProtectEffect()
	else
		self:removePyramidProtectEffect()
		if self.isSafe then
			self:setImgProtect()
		else
			self.image_Protect:setVisible(false)
		end
	end
end
function worldMapBuilding:addFireEffect(fightTime, data)
	worldMapInstance.addFireEffect(self, fightTime, data)
	if data and data.fightingToPointX and data.fightingToPointY then
		self.facePoint = cc.p(data.fightingToPointX, data.fightingToPointY)
	end
	if worldMapDefine.moveLineAutoHideOption.isSwitchShow then
		return
	end
	self:doFightingAnimation()
end
function worldMapBuilding:doFightingAnimation()
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
		local bulletSprite = display.newSprite("#icon_battle_jian_4.png")
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
		local delayTime = math.random(0, 5) / 10
		worldMapFunction.createThrowAction(bulletSprite, point1, point2, delayTime)
	end
	local _ENV, actionsArray = (for index), 1
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(3.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:doFightingAnimation()
	end)
	local actions = transition.sequence(actionsArray)
	self.fireNode:runAction(actions)
end
function worldMapBuilding:crownUpEffect(node)
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_castle_officer_01.plist"
	_ENV, (nil)[1], (nil).scale = nil, nil, 1.1
	;(nil).plist = "et_castle_officer_02.plist"
	;(nil)[2], (nil).scale = nil, 1.3
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(node:getContentSize().width / 2, node:getContentSize().height / 2))
	parNode:addTo(node)
end
function worldMapBuilding:crownDownEffect(node)
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_cwgz_01.plist"
	;(nil)[1], (nil).scale = nil, 1.45
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(node:getContentSize().width / 2, node:getContentSize().height / 2))
	parNode:addTo(node)
end
function createLvEffectNode(warLv, fileName, isWarLod, showMoon)
	local data = worldMapDefine.getWarLevelData(warLv)
	if not data then
		return
	end
	local node_warLvNode = display.newNode()
	local node_bottom = display.newNode()
	node_bottom:addTo(node_warLvNode, 1)
	local bottom = data.bottom
	local bottomImg = bottom.img
	for _, v in pairs(bottomImg.bg) do
		local bg = display.newSpriteNoChild("#" .. v.png)
		bg:setPosition(v.pos)
		bg:setGroupID(GROU_ID.group_warLv_base)
		bg:addTo(node_bottom, 1)
	end
	for _, v in pairs(bottomImg.dh) do
		local dh = display.newSpriteNoChild("#" .. v.png)
		dh:setPosition(v.pos)
		dh:setGroupID(GROU_ID.group_warLv_base)
		if isWarLod then
			worldMapDefine = GROU_ID.group_warLv_base
			GROU_ID.group_warLv_base.beginOpacity = 0.3
			GROU_ID.group_warLv_base.endOpacity = 0.7
			SoraDFadeINOUT(dh, GROU_ID.group_warLv_base)
		end
		dh:addTo(node_bottom, 2)
	end
	if bottom.et and isWarLod then
		local et_bottom = SoraDCreateEffectNode(bottom.et)
		et_bottom:setGroupID(GROU_ID.group_warLv_base_particle)
		et_bottom:setGroupAuto(true)
		et_bottom:addTo(node_bottom, 3)
	end
	if bottom.scale then
		node_bottom:setScale(bottom.scale)
	end
	if bottom.offset then
		node_bottom:setPosition(bottom.offset)
	end
	local top = data.top
	local node_top = display.newNode()
	node_top:addTo(node_warLvNode, 2)
	local topImg = top.img
	for _, v in pairs(topImg.bg) do
		local bg = display.newSpriteNoChild("#" .. v.png)
		bg:setGroupID(GROU_ID.group_warLv_top)
		bg:setPosition(v.pos)
		bg:addTo(node_top, 1)
	end
	for _, v in pairs(topImg.dh) do
		local dh = display.newSpriteNoChild("#" .. v.png)
		dh:setPosition(v.pos)
		dh:setGroupID(GROU_ID.group_warLv_top)
		if isWarLod then
			worldMapDefine = GROU_ID.group_warLv_top
			GROU_ID.group_warLv_top.beginOpacity = 0.3
			GROU_ID.group_warLv_top.endOpacity = 0.7
			SoraDFadeINOUT(dh, GROU_ID.group_warLv_top)
		end
		dh:addTo(node_top, 2)
	end
	if top.et and isWarLod then
		local et_top = SoraDCreateEffectNode(top.et)
		et_top:setGroupID(GROU_ID.group_warLv_top_particle)
		et_top:setGroupAuto(true)
		et_top:addTo(node_top, 3)
	end
	if top.scale then
		node_top:setScale(top.scale)
	end
	if top.offset then
		node_top:setPosition(top.offset)
	end
	if showMoon then
		local top_sword = data.top_sword
		local node_top_sword = display.newNode()
		node_top_sword:addTo(node_top, 2)
		node_top_sword:setName("node_top_sword")
		if top_sword then
			local topImg = top_sword.img
			for _, v in pairs(topImg.bg) do
				local bg = display.newSpriteNoChild("#" .. v.png)
				bg:setGroupID(GROU_ID.group_warLv_top)
				bg:setPosition(v.pos)
				bg:addTo(node_top_sword, 1)
			end
			for _, v in pairs(topImg.dh) do
				local dh = display.newSpriteNoChild("#" .. v.png)
				dh:setPosition(v.pos)
				dh:setGroupID(GROU_ID.group_warLv_top)
				if isWarLod then
					worldMapDefine = GROU_ID.group_warLv_top
					GROU_ID.group_warLv_top.beginOpacity = 0.3
					GROU_ID.group_warLv_top.endOpacity = 0.7
					SoraDFadeINOUT(dh, GROU_ID.group_warLv_top)
				end
				dh:addTo(node_top_sword, 2)
			end
			if top_sword.et and isWarLod then
				local et_top = SoraDCreateEffectNode(top_sword.et)
				et_top:setGroupID(GROU_ID.group_warLv_top_particle)
				et_top:setGroupAuto(true)
				et_top:addTo(node_top_sword, 3)
			end
		end
	end
	if isWarLod then
		_ENV = display.newNode()
		display.newNode()[1] = cca.moveBy(1.5, 0, 5)
		display.newNode()[2] = cca.moveBy(1.5, 0, -5)
		display.newNode()[3] = cca.moveBy(1.5, 0, -5)
		display.newNode()[4] = cca.moveBy(1.5, 0, -5)
		display.newNode()[5] = cca.moveBy(1.5, 0, -5)
		display.newNode()[6] = cca.moveBy(1.5, 0, -5)
		display.newNode()[7] = cca.moveBy(1.5, 0, -5)
		display.newNode()[8] = cca.moveBy(1.5, 0, -5)
		display.newNode()[9] = cca.moveBy(1.5, 0, -5)
		display.newNode()[10] = cca.moveBy(1.5, 0, -5)
		display.newNode()[11] = cca.moveBy(1.5, 0, -5)
		local seq = cca.seq((display.newNode()))
		node_top:runAction(cc.RepeatForever:create(seq))
	end
	if showMoon and data.moon then
		local node_moon = display.newNode()
		node_moon:addTo(node_warLvNode, 3)
		node_moon:setName("node_moon")
		for _, v in pairs(data.moon.img.bg) do
			local bg = display.newSpriteNoChild("#" .. v.png)
			bg:setGroupID(GROU_ID.group_warLv_top)
			bg:setPosition(v.pos)
			bg:addTo(node_moon, 1)
		end
		for _, v in pairs(data.moon.img.dh) do
			local dh = display.newSpriteNoChild("#" .. v.png)
			dh:setPosition(v.pos)
			dh:setGroupID(GROU_ID.group_warLv_top)
			if isWarLod then
				worldMapDefine = GROU_ID.group_warLv_top
				GROU_ID.group_warLv_top.beginOpacity = 0.3
				GROU_ID.group_warLv_top.endOpacity = 0.7
				SoraDFadeINOUT(dh, GROU_ID.group_warLv_top)
			end
			dh:addTo(node_moon, 2)
		end
		if data.moon.et and isWarLod then
			local et_top = SoraDCreateEffectNode(data.moon.et)
			et_top:setGroupID(GROU_ID.group_warLv_top_particle)
			et_top:setGroupAuto(true)
			et_top:addTo(node_moon, 3)
		end
		if isWarLod and warLv == CASTLE_NEX_MAX_WARLV then
			_UPVALUE5_ = et_top.addTo
			et_top.addTo[1] = cca.moveBy(0.5833333333333334, 0, -8)
			et_top.addTo[2] = cca.moveBy(0.16666666666666666, 0, 4)
			et_top.addTo[3] = cca.moveBy(0.43333333333333335, 0, 8)
			et_top.addTo[4] = cca.moveBy(0.15, 0, -2)
			et_top.addTo[5] = cca.moveBy(0.5, 0, -8)
			et_top.addTo[6] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[7] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[8] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[9] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[10] = cca.moveBy(0.8333333333333334, 0, 6)
			local act = cca.seq(et_top.addTo)
			node_moon:runAction(cc.RepeatForever:create(act))
		end
		if data.moon.scale then
			node_moon:setScale(data.moon.scale)
		end
		if data.moon.offset then
			node_moon:setPosition(data.moon.offset)
		end
	end
	node_warLvNode:setCacheName(fileName)
	return node_warLvNode
end
function worldMapBuilding:warLvEffect(warLv)
	self._warLv = warLv
	if warLv == 0 or not self:isShowWarLvEffect() then
		self:removeWarLvEffect()
		return
	end
	local data = worldMapDefine.getWarLevelData(warLv)
	if not data then
		return
	end
	if data.offset then
		self.warLVnode:setPosition(data.offset)
	end
	local showMoon = true
	local starLv = self._starLv
	if starLv and 0 < starLv then
		local level = cityltCtrl.getBuildStarColor(starLv)
		if 1 < level then
			showMoon = false
		end
	end
	local isWarLod = self:isWarLvLod()
	local lod = isWarLod and 1 or 0
	local moon = showMoon and 1 or 0
	local fileName = string.format("WarLv_%d_%d_%d", warLv, lod, moon)
	local node_warLvNode = instanceCacheMgr.getInstance(fileName)
	if node_warLvNode then
		self.node_warLvNode = node_warLvNode
		node_warLvNode:addTo(self.warLVnode)
		node_warLvNode:release()
	else
		node_warLvNode = createLvEffectNode(warLv, fileName, isWarLod, showMoon)
		if node_warLvNode then
			self.node_warLvNode = node_warLvNode
			node_warLvNode:addTo(self.warLVnode)
		else
			print("createLvEffectNode error warLv", warLv)
		end
	end
end
function worldMapBuilding:removeWarLvEffect()
	if self.node_warLvNode then
		instanceCacheMgr.addNormalNodeByType(self.node_warLvNode, self.node_warLvNode:getCacheName())
		self.node_warLvNode:removeFromParent(false)
		self.node_warLvNode = nil
	end
	self.warLVnode:setPosition(POINT_ZERO)
end
function worldMapBuilding:addEnemyCastleEffect()
	if self.et_node_enemy then
		return
	end
	_ENV, _ENV = nil, self.et_node_enemy
	_ENV, (nil).plist = nil, "et_heiwu_display_01.plist"
	;(nil).x = -8
	self.et_node_enemy[1], (nil).pos, (nil).y = nil, nil, -10
	local param = self.et_node_enemy
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(self)
	self.et_node_enemy = et_node
end
function worldMapBuilding:removeEnemyCastleEffect()
	if self.et_node_enemy then
		self.et_node_enemy:removeFromParent()
		self.et_node_enemy = nil
	end
end
function worldMapBuilding:isNeedShowAttr(attrEnum)
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local leagueID = self.leagueID or 0
	for i, v in ipairs(gMeteoriteSkillList) do
		print("attrEnum,v", attrEnum, v)
		if attrEnum == v then
			if selfLeagueID == leagueID then
				return true
			else
				return false
			end
		end
	end
	return true
end
function worldMapBuilding:checkAllCastleMeteorteEffect(attr, isRemove)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ret = worldMapView:getShowTilesArray()
	if ret == nil then
		return
	end
	local selfPoint = self:getTilePoint()
	for i, v in ipairs(gMeteoriteSkillList) do
		local attrValue = attr[tostring(v)]
		if attr[tostring(v)] then
			local rect = cc.rect(selfPoint.x - attrValue.range, selfPoint.y - attrValue.range, attrValue.range * 2, attrValue.range * 2)
			for _, tileInstance in pairs(ret) do
				if tileInstance and tileInstance.instanceType == gMapObjTypeDef.mapObjTypePlayer and self.leagueID == tileInstance.leagueID then
					local tilePoint = tileInstance:getTilePoint()
					if cc.rectContainsPoint(rect, tilePoint) then
						tileInstance:addMeteoriteSkillEffect(v)
					end
				end
			end
		end
	end
end
function worldMapBuilding:addMeteoriteSkillEffect(atttE)
	if atttE == gAttributeEnum.METEOR_MARCH_SPEED_BOOST then
		self:removeMeteoriteSkillEffect()
		local effectSp = display.newSprite("#dh_chengbaosxzs_01.png")
		effectSp:setPosition(cc.p(-15, 50))
		effectSp:setScale(2.0)
		effectSp:addTo(self, 1)
		local frames = display.newFrames("dh_chengbaosxzs_%.2d.png", 1, 30)
		local animation = display.newAnimation(frames, 1.0 / #frames)
		effectSp:playAnimationForever(animation)
		_UPVALUE1_ = cc.p(-15, 50)
		cc.p(-15, 50)[1] = cca.delay(5)
		cc.p(-15, 50)[2] = cca.callFunc(function()
			self:removeMeteoriteSkillEffect()
		end)
		cc.p(-15, 50)[3] = cca.callFunc(function()
			self:removeMeteoriteSkillEffect()
		end)
		effectSp:runAction(cca.seq(cc.p(-15, 50)))
		self.meteoriteEffect = effectSp
	else
		local effectSp = display.newSprite("#dh_chengbaosxjn_01.png")
		effectSp:setPosition(cc.p(-15, 150))
		effectSp:setScale(2.5)
		effectSp:addTo(self, 1)
		local frames = display.newFrames("dh_chengbaosxjn_%.2d.png", 1, 29)
		local animation = display.newAnimation(frames, 2.0 / #frames)
		_ENV = cc.p(-15, 150)
		cc.p(-15, 150).removeSelf = true
		effectSp:playAnimationOnce(animation, cc.p(-15, 150))
	end
end
function worldMapBuilding:removeMeteoriteSkillEffect()
	if self.meteoriteEffect then
		self.meteoriteEffect:removeFromParent()
		self.meteoriteEffect = nil
	end
end
function worldMapBuilding:castleLoveEffect()
	if self.et_node_love then
		return
	end
	_ENV, _ENV = nil, self.et_node_love
	_ENV, (nil).plist = nil, "et_castlelove_02.plist"
	;(nil).x = 7.32
	_ENV, self.et_node_love[1], (nil).pos, (nil).y = nil, nil, nil, 27.46
	_ENV, (nil).plist = nil, "et_castlelove_03.plist"
	;(nil).x = 18.96
	_ENV, self.et_node_love[2], (nil).pos, (nil).y = nil, nil, nil, -59.42
	_ENV, (nil).plist = nil, "et_castlelove_04.plist"
	;(nil).x = 15.15
	;(nil).pos, (nil).y = nil, 10.27
	_ENV, self.et_node_love[3], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_castlelove_01.plist"
	;(nil).x = 9.99
	_ENV, (nil).pos, (nil).y = nil, nil, 53.25
	;(nil).x = 2.5
	self.et_node_love[4], (nil).scale, (nil).y = nil, nil, 4.6
	local param = self.et_node_love
	self.et_node_love = SoraDCreateEffectNode(param)
	self.et_node_love:addTo(self)
end
function worldMapBuilding:removeCastleEffect(isRemove)
	if self.et_node_love then
		self.et_node_love:removeFromParent()
		self.et_node_love = nil
	end
	if self.node_snowMan then
		self.node_snowMan:removeFromParent()
		self.node_snowMan = nil
		if not isRemove then
			self:updateBuildingImg()
			self:updateOfficeIcon()
			self:updatePrisoneIn()
		end
	end
	if self.et_node_rainbow then
		self.et_node_rainbow:stopAllActions()
		self.et_node_rainbow:removeFromParent()
		self.et_node_rainbow = nil
	end
	if self.et_node_rainbow_1 then
		self.et_node_rainbow_1:removeFromParent()
		self.et_node_rainbow_1 = nil
	end
	if self.et_node_rainbow_2 then
		self.et_node_rainbow_2:removeFromParent()
		self.et_node_rainbow_2 = nil
	end
	if self.et_node_shining then
		self.et_node_shining:removeFromParent()
		self.et_node_shining = nil
	end
end
function worldMapBuilding:castleSnowEffect()
	if self.node_snowEffect then
		return
	end
	self.node_snowEffect = display.newNode()
	self.node_snowEffect:setPosition(-30, 70)
	self.node_snowEffect:addTo(self, 1)
	local snowEffect = SoraDCreatAnimation("animationSnowEffect")
	snowEffect:addTo(self.node_snowEffect)
end
function worldMapBuilding:castleSnowIceEffect(isSelf)
	if self.node_snowMan then
		return
	end
	self.node_snowMan = display.newNode()
	self.node_snowMan:setPosition(0, 0)
	self.node_snowMan:addTo(self, 1)
	if isSelf and self.data.castleAppearanceEndTime then
		local leftTime = math.max(0, self.data.castleAppearanceEndTime - serviceFunctions.systemTime())
		local timeNode = worldMapEffect.createFireTimeNode()
		timeNode:setPosition(cc.p(0, -120))
		timeNode:addTo(self.node_snowMan, 5)
		timeNode.init(leftTime)
	end
	self.cityImage:setVisible(false)
	self.citySkin1Image:setVisible(false)
	self:updateOfficeIcon()
	self:updatePrisoneIn()
	local xueren = display.newSprite("#xuerenzhuangban.png")
	xueren:setPosition(cc.p(-45, 60))
	xueren:addTo(self.node_snowMan, 0)
	local yun = display.newSprite("#yunduozhuangban_001.png")
	yun:setPosition(cc.p(-15, 100))
	yun:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_COLOR)
	yun:addTo(self.node_snowMan, 1)
	local frames = display.newFrames("yunduozhuangban_%.3d.png", 1, 20)
	local animation = display.newAnimation(frames, 2.0 / #frames)
	yun:playAnimationForever(animation)
	_ENV, _ENV = yun, yun.playAnimationForever
	yun.plist = "et_xuerenddj_01.plist"
	yun.pos = cc.p(119.09, 53.82)
	_ENV, yun.playAnimationForever[1], yun.scale = yun, yun, 1.35
	yun.plist = "et_xuerenddj_01.plist"
	yun.pos = cc.p(-37.39, 57.54)
	_ENV, yun.playAnimationForever[2], yun.scale = yun, yun, 1.65
	yun.plist = "et_xuerenddj_02.plist"
	_ENV, yun.playAnimationForever[3], yun.pos = yun, yun, cc.p(-70.93, -33.32)
	yun.plist = "et_xuerenddj_02.plist"
	_ENV, yun.playAnimationForever[4], yun.pos = yun, yun, cc.p(-14.11, -89.37)
	yun.plist = "et_xuerenddj_02.plist"
	_ENV, yun.playAnimationForever[5], yun.pos = yun, yun, cc.p(152.46, -19.55)
	yun.plist = "et_xuerenddj_03.plist"
	yun.pos = cc.p(41.9, -46.1)
	_ENV, yun.playAnimationForever[6], yun.scale = yun, yun, 1.4237
	yun.plist = "et_xuerenddj_04.plist"
	yun.pos = cc.p(32.99, -36.95)
	_ENV, yun.playAnimationForever[7], yun.scale = yun, yun, 1.1245
	yun.plist = "et_xuerenddj_05.plist"
	yun.pos = cc.p(117.46, 54.45)
	_ENV, yun.playAnimationForever[8], yun.rotate = yun, yun, 179.07
	yun.plist = "et_xuerenddj_05.plist"
	yun.pos = cc.p(-31.71, 53.92)
	yun.scale = 0.8419
	yun.playAnimationForever[9], yun.rotate = yun, 179.07
	local param = yun.playAnimationForever
	local et_node = SoraDCreateEffectNode(param)
	et_node:setPosition(-45, 45)
	et_node:addTo(self.node_snowMan, 0)
end
function worldMapBuilding:castleShiningEffect()
	if self.et_node_shining then
		return
	end
	self.et_node_shining = display.newNode()
	self.et_node_shining:setPosition(0, 0)
	self.et_node_shining:addTo(self)
	for k, v in pairs(worldMapDefine.castleTwinkleCfg) do
		local effectNode = SoraDCreateShaderEffect(v, self.et_node_shining)
	end
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		self.et_node_shining:setScale(1.2)
	end
end
function worldMapBuilding:castleShining2Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("Node_bxcqcb_effect")
	effect:addTo(self, 999)
	effect:setPosition(cc.p(-60, 120))
	local hideName = SoraDFIsRA() and "Sprite_text_en" or "Sprite_text_ar"
	SoraDGetChildByName(effect, hideName):setVisible(false)
	self.et_node_shining = effect
end
function worldMapBuilding:castleShining3Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("animationXLCBCWTX")
	effect:setName("xlcbtxNode")
	effect:setPosition(-45, 140)
	effect:addTo(self, 2)
	self.et_node_shining = effect
end
function worldMapBuilding:castleShining4Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("animationBYXLCBYHTX")
	effect:setPosition(-45, 140)
	effect:addTo(self, 2)
	self.et_node_shining = effect
end
function worldMapBuilding:castleShining5Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("animationBXFLCBYHTX")
	effect:setPosition(-70, 120)
	effect:addTo(self, 2)
	self.et_node_shining = effect
end
function worldMapBuilding:castleRainbowEffect()
	if self.et_node_rainbow then
		return
	end
	local bPercent = 0
	local ePercent = 78
	local actionTime = 2
	local perFrame = ePercent / (actionTime * 60)
	local isEffectShow = false
	self.et_node_rainbow = display.newNode()
	self.et_node_rainbow:setPosition(cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50))
	self.et_node_rainbow:addTo(self, 9)
	local progress_rainbow = display.newProgressTimer("#icon_rainbow.png", display.PROGRESS_TIMER_RADIAL)
	progress_rainbow:setRotation(-140)
	progress_rainbow:addTo(self.et_node_rainbow, 9)
	progress_rainbow:setPercentage(bPercent)
	local freeEffect = function()
		local beginPos = cc.p(self.centerPoint.x - 161, self.centerPoint.y - 128.5)
		local control_1 = cc.p(self.centerPoint.x - 55.44, self.centerPoint.y + 307.77)
		local control_2 = cc.p(self.centerPoint.x + 281, self.centerPoint.y + 393.5)
		local endPos = cc.p(self.centerPoint.x + 315.6, self.centerPoint.y + 147.8)
		_ENV, _ENV = self.centerPoint.y + 147.8, self.centerPoint.x + 315.6
		;(self.centerPoint.y + 147.8).plist = "et_caihong_01.plist"
		;(self.centerPoint.y + 147.8).pos = beginPos
		;(self.centerPoint.y + 147.8).scale = 2.237
		;(self.centerPoint.y + 147.8).rotate = -18.87
		;(self.centerPoint.x + 315.6)[1], (self.centerPoint.y + 147.8).posType = self.centerPoint.y + 147.8, cc.POSITION_TYPE_FREE
		local param = self.centerPoint.x + 315.6
		local et_rainbow = SoraDCreateEffectNode(param)
		et_rainbow:addTo(self, 10)
		self.et_node_rainbow_2 = et_rainbow
		self = et_rainbow
		_UPVALUE3_ = nil
		;(nil)[1] = control_1
		;(nil)[2] = control_2
		;(nil)[3] = endPos
		et_rainbow[1] = cc.EaseSineIn:create(cc.BezierTo:create(1.6, nil))
		et_rainbow[2] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[3] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[4] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[5] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[6] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[7] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[8] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[9] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		local seq = cca.seq(et_rainbow)
		et_rainbow:runAction(seq)
	end
	_UPVALUE2_ = bPercent
	_UPVALUE1_ = cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)
	cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)[1] = cca.callFunc(function()
		progress_rainbow:stopAllActions()
		progress_rainbow:setPercentage(bPercent)
		progress_rainbow = progress_rainbow
		progress_rainbow[1] = cca.callFunc(function()
			if bPercent <= ePercent then
				progress_rainbow:setPercentage(bPercent)
			else
				progress_rainbow:stopAllActions()
			end
		end)
		progress_rainbow[2] = cca.delay(0.016666666666666666)
		progress_rainbow[3] = cca.delay(0.016666666666666666)
		progress_rainbow[4] = cca.delay(0.016666666666666666)
		local seq = cca.seq(progress_rainbow)
		progress_rainbow:runAction(cc.RepeatForever:create(seq))
	end)
	cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)[2] = cca.callFunc(freeEffect)
	cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)[3] = cca.callFunc(freeEffect)
	bPercent[1] = cca.spawn(cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50))
	bPercent[2] = cca.delay(2)
	bPercent[3] = cca.callFunc(function()
		if isEffectShow then
			return
		end
		isEffectShow, isEffectShow = nil, isEffectShow
		;(nil).plist = "et_caihong_02.plist"
		;(nil).rotate = -22.21
		isEffectShow, isEffectShow[1], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46)
		isEffectShow, (nil).plist = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), "et_caihong_03.plist"
		cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).x = -0.855
		;(nil).scale, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).y = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), 0.876
		;(nil).rotate = 42.65
		isEffectShow, isEffectShow[2], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 29, self.centerPoint.y + 76.06)
		;(nil).plist = "et_caihong_03.plist"
		;(nil).scale = 2.237
		;(nil).rotate = -18.87
		isEffectShow[3], (nil).pos = nil, cc.p(self.centerPoint.x + 61.85, self.centerPoint.y + 147.93)
		local param = isEffectShow
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self, 10)
		self.et_node_rainbow_1 = et_node
	end)
	bPercent[4] = cca.callFunc(function()
		if isEffectShow then
			return
		end
		isEffectShow, isEffectShow = nil, isEffectShow
		;(nil).plist = "et_caihong_02.plist"
		;(nil).rotate = -22.21
		isEffectShow, isEffectShow[1], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46)
		isEffectShow, (nil).plist = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), "et_caihong_03.plist"
		cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).x = -0.855
		;(nil).scale, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).y = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), 0.876
		;(nil).rotate = 42.65
		isEffectShow, isEffectShow[2], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 29, self.centerPoint.y + 76.06)
		;(nil).plist = "et_caihong_03.plist"
		;(nil).scale = 2.237
		;(nil).rotate = -18.87
		isEffectShow[3], (nil).pos = nil, cc.p(self.centerPoint.x + 61.85, self.centerPoint.y + 147.93)
		local param = isEffectShow
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self, 10)
		self.et_node_rainbow_1 = et_node
	end)
	bPercent[5] = cca.callFunc(function()
		if isEffectShow then
			return
		end
		isEffectShow, isEffectShow = nil, isEffectShow
		;(nil).plist = "et_caihong_02.plist"
		;(nil).rotate = -22.21
		isEffectShow, isEffectShow[1], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46)
		isEffectShow, (nil).plist = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), "et_caihong_03.plist"
		cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).x = -0.855
		;(nil).scale, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).y = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), 0.876
		;(nil).rotate = 42.65
		isEffectShow, isEffectShow[2], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 29, self.centerPoint.y + 76.06)
		;(nil).plist = "et_caihong_03.plist"
		;(nil).scale = 2.237
		;(nil).rotate = -18.87
		isEffectShow[3], (nil).pos = nil, cc.p(self.centerPoint.x + 61.85, self.centerPoint.y + 147.93)
		local param = isEffectShow
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self, 10)
		self.et_node_rainbow_1 = et_node
	end)
	local seqRainbow = cca.seq(bPercent)
	self.et_node_rainbow:runAction(seqRainbow)
end
function worldMapBuilding:removeCastleFireWorkEffect()
	if self.fireWork then
		self.fireWork:removeFromParent()
		self.fireWork = nil
		if self.fireWorkTimeNode then
			self.fireWorkTimeNode:stopAllActions()
			self.fireWorkTimeNode:removeFromParent()
			self.fireWorkTimeNode = nil
		end
	end
	if self.node_snowEffect then
		self.node_snowEffect:removeFromParent()
		self.node_snowEffect = nil
	end
end
function worldMapBuilding:addPyramidProtectEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_cjztzc_protect_01.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	_ENV, (nil)[1], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_cjztzc_protect_02.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	_ENV, (nil)[2], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_cjztzc_protect_03.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	_ENV, (nil)[3], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_cjztzc_protect_04.plist"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 140
	;(nil)[4], (nil).scale = nil, 2
	local param
	if self.pyramidProtectNode then
		SoraDResetEffectNode(self.pyramidProtectNode)
	else
		self.pyramidProtectNode = SoraDCreateEffectNode(param)
		self:addChild(self.pyramidProtectNode, 5)
		self.pyramidProtectNode:setScale(self.imgScale)
		self.pyramidProtectNode:setPosition(self.imgOffset)
	end
end
function worldMapBuilding:removePyramidProtectEffect()
	if self.pyramidProtectNode then
		self.pyramidProtectNode:removeFromParent()
		self.pyramidProtectNode = nil
	end
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
	local gametop, buttonTypeArray
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom then
		local playerID = self.playerID or 0
		local leagueID = self.leagueID or 0
		if selfPlayerID == playerID then
			if worldMapDefine.isInNebulaAllStar() then
				gametop = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_nebulaAllStar_defend
				table.insert(buttonTypeArray, nil)
			end
			gametop = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_defend
			table.insert(buttonTypeArray, nil)
			gametop = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_chengshiZengyi
			table.insert(buttonTypeArray, nil)
			if not worldMapDefine.isInNebulaAllStar() then
				gametop = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_decorate
				table.insert(buttonTypeArray, nil)
			end
			if SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.SIGNATURE) then
				gametop = gExaltedPrivilegeType.SIGNATURE
				gExaltedPrivilegeType.SIGNATURE.buttonType = worldMapDefine.worldMapTipButtonType_sign
				table.insert(buttonTypeArray, gExaltedPrivilegeType.SIGNATURE)
			end
		else
			if not isInWar and worldMapDefine.kingdomStatus == gKingStatus.king then
				gametop = gExaltedPrivilegeType.SIGNATURE
				gExaltedPrivilegeType.SIGNATURE.buttonType = worldMapDefine.worldMapTipButtonType_renMing
				table.insert(buttonTypeArray, gExaltedPrivilegeType.SIGNATURE)
			end
			local isInPyramid = self:isInAllianceWar()
			local msgTipsKey
			local gametop, atlantis = gExaltedPrivilegeType.SIGNATURE, gExaltedPrivilegeType.SIGNATURE
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
					gametop = self:getTilePoint()
					self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu
					self:getTilePoint().isButtonEnabled = not isInPyramid
					self:getTilePoint().msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, self:getTilePoint())
				end
				if kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.moveLineTypeMassSlave, nil, nil, self.playerID) then
					gametop = _G.gMapMoveLineServerType.moveLineTypeMassSlave
					_G.gMapMoveLineServerType.moveLineTypeMassSlave.buttonType = worldMapDefine.worldMapTipButtonType_jijieBuduiXinxi
					table.insert(buttonTypeArray, _G.gMapMoveLineServerType.moveLineTypeMassSlave)
				end
				if kingdomMapCtrl:hasArmyHelpQueue2Player(self.playerID, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
					gametop = self.playerID
					self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_chakanYuanjun
					table.insert(buttonTypeArray, self.playerID)
				else
					gametop = self.playerID
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
					isEnableGongJi = ok
					isEnableZhenCha = ok
					function msgTipsKey(target, event)
						local tipButtonType = target.tipButtonType
						worldMapDefine = nil
						;(nil)[worldMapDefine.worldMapTipButtonType_gongJi] = i18n("common_text_008")
						;(nil)[worldMapDefine.worldMapTipButtonType_xuanZhan] = i18n("common_text_009")
						local (nil)[worldMapDefine.worldMapTipButtonType_zhenCha], type2name = i18n("common_text_007"), nil
						worldMapDefine = nil
						;(nil).map = areaName
						;(nil).name = type2name[tipButtonType]
						SoraDShowMsgTip(i18n("nebula_war_text_0539", nil))
					end
				elseif worldMapDefine.isInNebulaEmperor() or worldMapDefine.isInNebulaAllStar() then
					isEnable = not isInPyramid
					isEnableGongJi, isEnableZhenCha = isEnable, isEnable
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
				gametop = i18n("common_text_4576")
				i18n("common_text_4576").buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				i18n("common_text_4576").isButtonEnabled = isEnableGongJi
				i18n("common_text_4576").msgTipsKey = msgTipsKey
				table.insert(buttonTypeArray, (i18n("common_text_4576")))
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID and self.cityLevel >= CASTLE_LV6_LIMITED then
					gametop = 0
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
					gametop = self:getTilePoint()
					self:getTilePoint().buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					self:getTilePoint().isButtonEnabled = isEnableZhenCha
					self:getTilePoint().msgTipsKey = _msgTipsKey
					table.insert(buttonTypeArray, self:getTilePoint())
				end
				local lordSkillModuleAPI = include("lordSkillModuleAPI")
				local qianruinfo = lordSkillModuleAPI:getSkillCDData(LORD_SKILL_QIANRU)
				if self.isSafe and qianruinfo.isOpened then
					gametop = worldMapDefine.worldMapTipButtonType_zhenCha
					worldMapDefine.worldMapTipButtonType_zhenCha.buttonType = worldMapDefine.worldMapTipButtonType_qianru
					worldMapDefine.worldMapTipButtonType_zhenCha.isButtonEnabled = not isInPyramid
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_zhenCha)
				end
			end
		end
		if self:canHasEmojiOperator(selfPlayerID) then
			gametop = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
			table.insert(buttonTypeArray, selfPlayerID)
		end
	end
	local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
	if worldMapDefine.isNebulaAllStarKingdomID(self.kingdomID) and nebulaAllStarCtrl:getIsViewer() then
		gametop = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_nebulaAllStar_gift
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	if not worldMapDefine.isInNebulaAllStar() or (self.playerID or 0) ~= selfPlayerID then
		gametop = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	if not isInWar then
		if 0 >= self.leaguedOfficialType and legendLordCtrl:getIsSelfLegendKing() then
			gametop = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_leaguerenMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
		if 0 >= self.kingStarOfficialType and kingStarCtrl:getIsSelfLegendKing() then
			gametop = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_kingStar_renMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
		if 0 >= self.hegemonOfficialType and hegemonCtrl:getIsSelfHegemon() then
			gametop = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_hegemonrenMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
	end
	if 0 < self.prisonerNum then
		gametop = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_prisonerIn
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	if worldMapDefine.isRemainsKingdomID(self.kingdomID) and not worldMapDefine.isInRemains() then
		gametop = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_remains_buff
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	return buttonTypeArray
end
function worldMapBuilding:lazyCreateOfficalImage()
	if self.officalImage == nil then
		local officalImage = display.newSprite("#frame_king_22.png")
		officalImage:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 150))
		officalImage:setScale(0.75)
		officalImage:addTo(self, 5)
		local officialImaSize = officalImage:getContentSize()
		local officalIcon = display.newSprite("#icon_king.png")
		officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
		officalIcon:addTo(officalImage, 2)
		self.officalImage = officalImage
		self.officalIcon = officalIcon
	else
		self.officalImage:setScale(0.75)
		self.officalIcon:setScale(1.0)
		self.officalImage:setVisible(true)
		self.officalIcon:removeAllChildren()
	end
end
function worldMapBuilding:updatePrisoneIn(...)
	if self.prisonerNum > 0 then
		self:lazyCreatePrisoneInImage()
	elseif self.prisoneInIcon then
		self.prisoneInIcon:setVisible(false)
	end
end
function worldMapBuilding:lazyCreatePrisoneInImage()
	if not self.node_snowMan then
		if self.prisoneInIcon == nil then
			local prisoneInIcon = display.newSprite("#btn_hero_prison.png")
			prisoneInIcon:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 120))
			prisoneInIcon:setScale(1.3)
			prisoneInIcon:addTo(self, 5)
			self.prisoneInIcon = prisoneInIcon
		else
			self.prisoneInIcon:setVisible(true)
		end
		local selfPlayerID = gametop.playertop_:getPlayerID() or 0
		if not self.isShowPrision and selfPlayerID == self.playerID then
			self.prisoneInIcon:setVisible(false)
		end
	elseif self.prisoneInIcon then
		self.prisoneInIcon:setVisible(false)
	end
end
function worldMapBuilding:updateOfficial()
	self:updateBuildingImg()
	local hide = true
	if self.isShowOffice then
		if self.lastTbOfficialInfo ~= nil and self.lastTbOfficialInfo.official == self.officialType and self.lastTbOfficialInfo.legendTitle == self.leaguedOfficialType and self.lastTbOfficialInfo.legendForSepTitle == self.kingStarOfficialType and self.lastTbOfficialInfo.hegemonTitle == self.hegemonOfficialType and self.lastTbOfficialInfo.atlantisOfficialType == self.atlantisOfficialType and self.lastTbOfficialInfo.nebulaOfficialID == self.nebulaOfficialID and self.lastTbOfficialInfo.nebulaOfficialID2 == self.nebulaOfficialID2 and self.lastTbOfficialInfo.emperorOfficial == self.emperorOfficial and self.lastTbOfficialInfo.showOfficialType == self.showOfficialType then
			return
		end
		local lordInfoCtrl, tbOfficialInfo = self.lastTbOfficialInfo.showOfficialType, self.lastTbOfficialInfo.showOfficialType
		tbOfficialInfo.official = self.officialType
		tbOfficialInfo.legendTitle = self.leaguedOfficialType
		tbOfficialInfo.legendForSepTitle = self.kingStarOfficialType
		tbOfficialInfo.hegemonTitle = self.hegemonOfficialType
		tbOfficialInfo.atlantisOfficialType = self.atlantisOfficialType
		tbOfficialInfo.nebulaOfficialID = self.nebulaOfficialID
		tbOfficialInfo.nebulaOfficialID2 = self.nebulaOfficialID2
		tbOfficialInfo.emperorOfficial = self.emperorOfficial
		tbOfficialInfo.showOfficialType = self.showOfficialType
		self.lastTbOfficialInfo = tbOfficialInfo
		local showOfficialType = lordInfoCtrl:getShowOfficialTypeForLord(tbOfficialInfo)
		print("showOfficialType1", showOfficialType, self.showOfficialType)
		hide = false
		if showOfficialType == gShowOfficialType.KING then
			self:lazyCreateOfficalImage()
			local officialInfoRead = include("officialInfoRead")
			local officialInfo = officialInfoRead.getInfoByType(self.officialType)
			if officialInfo then
				self.officalIcon:setSpriteFrame(officialInfo.img)
				print("----------")
				dump(officialInfo, "officialInfo")
				if officialInfo.class < 2 then
					self.officalImage:setSpriteFrame("frame_king_23.png")
					self:crownUpEffect(self.officalIcon)
				else
					self.officalImage:setSpriteFrame("frame_king_22.png")
					self:crownDownEffect(self.officalIcon)
				end
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.LEGEND then
			self:lazyCreateOfficalImage()
			local legendKingRead = include("legendKingRead")
			local officialInfo = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, self.leaguedOfficialType)
			if officialInfo then
				self.officalIcon:setSpriteFrame(officialInfo.img)
				self.officalImage:setSpriteFrame("icon_LegendaryKing_honor.png")
				self:crownUpEffect(self.officalIcon)
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.KINGSTAR then
			self:lazyCreateOfficalImage()
			local legendKingRead = include("legendKingRead")
			local officialInfo = legendKingRead.getOfficialInfo(gLegendBuffType.PLAYER, self.kingStarOfficialType, worldMapDefine.KINGSTAR_KINGDOM_ID)
			if officialInfo then
				self.officalIcon:setSpriteFrame(officialInfo.img)
				self.officalImage:setSpriteFrame("icon_LegendaryKing_honor.png")
				self:crownUpEffect(self.officalIcon)
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.HEGEMON then
			self:lazyCreateOfficalImage()
			self.officalImage:setScale(1.0)
			local hegemonRead = include("hegemonRead")
			local officialImage = hegemonRead.getOfficialIcon(self.hegemonOfficialType)
			local isGood = hegemonRead.judgeIsGood(self.hegemonOfficialType)
			if officialImage then
				self.officalIcon:setSpriteFrame(officialImage)
				if isGood then
					self.officalImage:setSpriteFrame("frame_touxiangkuang_01.png")
				else
					self.officalImage:setSpriteFrame("frame_touxiangkuang_02.png")
				end
				if self.hegemonOfficialType == 1 then
					self.officalIcon:setScale(0.45)
				end
				if isGood then
					self:crownUpEffect(self.officalIcon)
				end
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		elseif showOfficialType == gShowOfficialType.ATLANTIS or showOfficialType == gShowOfficialType.NEBULA or showOfficialType == gShowOfficialType.NEBULA2 or showOfficialType == gShowOfficialType.NEBULA_EMPEROR then
			lordInfoCtrl = gShowOfficialType.NEBULA_EMPEROR
			gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.ATLANTIS] = self.atlantisOfficialType
			gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.NEBULA] = self.nebulaOfficialID
			gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.NEBULA2] = self.nebulaOfficialID2
			local gShowOfficialType.NEBULA_EMPEROR[gShowOfficialType.NEBULA_EMPEROR], config = self.emperorOfficial, gShowOfficialType.NEBULA_EMPEROR
			self:lazyCreateOfficalImage()
			self.officalImage:setScale(1.0)
			if showOfficialType == gShowOfficialType.NEBULA or showOfficialType == gShowOfficialType.NEBULA2 then
				self.officalIcon:setScale(0.5384615384615384)
			end
			local lordOfficialRead = include("lordOfficialRead")
			local officialImage = lordOfficialRead.getOfficialIcon(showOfficialType, config[showOfficialType])
			if officialImage then
				self.officalIcon:setSpriteFrame(officialImage)
				self.officalImage:setSpriteFrame("frame_touxiangkuang_01.png")
				self:crownUpEffect(self.officalIcon)
				local officialImaSize = self.officalImage:getContentSize()
				self.officalIcon:setPosition(cc.p(officialImaSize.width / 2, officialImaSize.height / 2))
			end
		else
			hide = true
		end
	end
	if hide and self.officalImage and self.officalImage:isVisible() then
		self.officalImage:setVisible(false)
		self.officalIcon:removeAllChildren()
	end
end
function worldMapBuilding:updateTopShowIcons(...)
	_UPVALUE2_ = nil
	;(nil)[1] = self.prisoneInIcon
	local (nil)[2], sortList = self.officalImage, nil
	local _ENV, needShowTitleList = self.prisoneInIcon, self.prisoneInIcon
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
function worldMapBuilding:createMoveCityTimeNode()
	local node = display.newNode()
	node:addTo(self, 100)
	node:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 130))
	local image_bg = display.newSprite("#frame_map_18.png")
	image_bg:setAnchorPoint(cc.p(0.5, 0.5))
	image_bg:addTo(node)
	self.imageMoveCityTime = display.newSprite("#icon_hourglass.png")
	self.imageMoveCityTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.imageMoveCityTime:addTo(node)
	_ENV = self.imageMoveCityTime
	self.imageMoveCityTime.UILabelType = 2
	self.imageMoveCityTime.text = "00:00:00"
	self.imageMoveCityTime.size = 20
	self.txtMoveCityTime = cc.ui.UILabel.new(self.imageMoveCityTime)
	self.txtMoveCityTime:setAnchorPoint(cc.p(0.5, 0.5))
	self.txtMoveCityTime:addTo(node)
	self.txtMoveCityTime = SoraDCreateTimerLabel(self, self.txtMoveCityTime)
	self.txtMoveCityTime:setTimeLast(function(str, tick)
		_ENV = nil
		;(nil).time = str
		local reText = i18n("remains_text_83", nil)
		return reText
	end)
	self.txtMoveCityTime:setTimeEndListener(function()
		self:cleanMoveTime()
	end)
	self.txtMoveCityTime:setTimeUpdateListener(function()
		self.imageMoveCityTime:setPositionX(SoraDFSign(self.txtMoveCityTime:getContentSize().width / 2 + 20))
	end)
	return node
end
function worldMapBuilding:cleanMoveTime()
	self.moveCityTime = nil
	self:updateMoveTime()
end
function worldMapBuilding:updateMoveTime()
	if self.moveCityTime and self.moveCityTime > 0 then
		if not self.nodeMoveCityTime then
			self.nodeMoveCityTime = self:createMoveCityTimeNode()
		end
		if self.nodeMoveCityTime then
			self.nodeMoveCityTime:setVisible(true)
			if self.txtMoveCityTime then
				self.txtMoveCityTime:beginTime(self.moveCityTime)
			end
		end
	elseif self.nodeMoveCityTime then
		self.nodeMoveCityTime:setVisible(false)
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
	if not self.groundPet then
		local groundPetNode = SoraDCreatePanel("petShowSingle")
		_ENV = "petShowSingle"
		;("petShowSingle").petid = 1259
		;("petShowSingle").level = 27
		local ("petShowSingle").rank, curPetParam = 1, "petShowSingle"
		curPetParam.isShowPu = false
		groundPetNode:initData(curPetParam)
		local petCenterPos = cc.p(150, 0)
		groundPetNode:setPosition(petCenterPos)
		groundPetNode:setPositionZ(0)
		groundPetNode:setScale(0.3)
		groundPetNode:openMoveTouch(false)
		_ENV = false
		;(false).x = 20
		;(false).y = 34
		;(false).z = -10
		groundPetNode.petRootNode:setRotation3D(false)
		groundPetNode:setName("groundPetNode")
		groundPetNode:setIsForceOrthographic(true)
		self:addChild(groundPetNode, 1100, "groundPetNode")
		self.groundPet = groundPetNode
		gGroudPet = groundPetNode
	end
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
function worldMapBuilding:refreshSignShow(isShow)
	if self.signNode and tolua.isnull(self.signNode) then
		return
	end
	if self.signature and self.signature ~= "" then
		if not self.signNode then
			self:createSignShow()
		end
		self.signNode:setVisible(isShow)
	elseif self.signNode then
		self.signNode:setVisible(false)
	end
end
function worldMapBuilding:createSignShow()
	local signNode = display.newNode()
	signNode:addTo(self, 4)
	signNode:setPosition(cc.p(self.centerPoint.x + 40, self.centerPoint.y - 0))
	self.signNode = signNode
	signNode:setGroupID(GROU_ID.group_sign)
	signNode:setGroupAuto(true)
	local image = ccui.ImageView:create("frame_ssdt_qmk01.png", ccui.TextureResType.plistType)
	image:setScale9Enabled(true)
	image:setCapInsets(cc.rect(40, 40, 10, 10))
	image:addTo(signNode)
	image:setOpacity(204.0)
	self.signImage = image
	local label = ccui.Text:create()
	label:setColor(cc.c3b(80, 50, 0))
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:addTo(signNode)
	SoraDSetTextWidthHeight(label, cc.size(130, 35))
	label:setPosition(0, 12)
	label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	label:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	label:setFontSize(20)
	self.signText = label
end
function worldMapBuilding:refreshSignText()
	if self.signature and self.signature ~= "" then
		self:refreshSignShow(not self.isOnClick)
		self.signText:setString(self.signature)
		if self.signatureBox and self.signatureBox == 1 then
			self.signText:setPosition(0, -10)
			self.signImage:loadTexture("frame_shmc_signature.png", ccui.TextureResType.plistType)
			self.signImage:setContentSize(cc.size(160, 110))
		else
			self.signText:setPosition(0, 12)
			self.signImage:loadTexture("frame_ssdt_qmk01.png", ccui.TextureResType.plistType)
			self.signImage:setContentSize(cc.size(150, 62))
		end
	else
		self:refreshSignShow(false)
	end
end
function worldMapBuilding:setIsOnClick(isOnClick)
	self.isOnClick = isOnClick
	self:refreshSignShow(not self.isOnClick)
end
_ENV, worldMapBuilding.getSignature = function(self, ...)
	return self.signature
end, function(self, ...)
	return self.signature
end
;(function(self, ...)
	return self.signature
end).RUINS_WAR_MOVE_CITY_LOCKED = 1
;(function(self, ...)
	return self.signature
end).RUINS_WAR_SPEED_QUEUE_LOCKED = 2
;(function(self, ...)
	return self.signature
end).APPOINT_DAMAGE_BOOST = 3
local (function(self, ...)
	return self.signature
end).APPOINT_CURE_SOLDIER_SPEED_BOOST, skillEffectType = 4, function(self, ...)
	return self.signature
end
function worldMapBuilding:refreshSkillEffect(data)
	if not self.skillEffectList then
		skillEffectType = self.skillEffectList
		skillEffectType = nil
		;(nil).key = "isMoveCityLocked"
		self.skillEffectList[skillEffectType.RUINS_WAR_MOVE_CITY_LOCKED], (nil).effect = nil, nil
		skillEffectType = nil
		;(nil).key = "isSpeedQueueLocked"
		self.skillEffectList[skillEffectType.RUINS_WAR_SPEED_QUEUE_LOCKED], (nil).effect = nil, nil
		skillEffectType = nil
		;(nil).key = "isInDamagePlus"
		self.skillEffectList[skillEffectType.APPOINT_DAMAGE_BOOST], (nil).effect = nil, nil
		skillEffectType = nil
		;(nil).key = "isInCureSpeedPlus"
		self.skillEffectList, self.skillEffectList[skillEffectType.APPOINT_CURE_SOLDIER_SPEED_BOOST], (nil).effect = self.skillEffectList, nil, nil
	end
	for i, v in ipairs(self.skillEffectList) do
		if data[v.key] then
			if not v.effect then
				v.effect = self:createSkillEffect(i)
			end
		elseif v.effect then
			v.effect:removeFromParent()
			v.effect = nil
		end
	end
end
function worldMapBuilding:createSkillEffect(effectType)
	if effectType == skillEffectType.RUINS_WAR_MOVE_CITY_LOCKED then
		local effect = SoraDCreatAnimation("Node_yjzz_jntx2", nil, false)
		effect:addTo(self, 6)
		effect:setPosition(0, 50)
		return effect
	end
	if effectType == skillEffectType.RUINS_WAR_SPEED_QUEUE_LOCKED then
		local effect = SoraDCreatAnimation("Node_yjzz_jntx1", nil, false)
		effect:addTo(self, 5)
		effect:setPosition(0, 0)
		return effect
	end
	if effectType == skillEffectType.APPOINT_DAMAGE_BOOST then
		local criSprite = cc.criSprite.createCriSprite("G_shixue.usm", false, true, nil)
		criSprite:addTo(self, 6)
		criSprite:setPosition(0, 80)
		criSprite:setBlendFunc(gl.ONE, gl.ONE)
		return criSprite
	end
	if effectType == skillEffectType.APPOINT_CURE_SOLDIER_SPEED_BOOST then
		local criSprite = cc.criSprite.createCriSprite("shengliao.usm", false, true, nil)
		criSprite:addTo(self, 6)
		criSprite:setPosition(-10, 50)
		return criSprite
	end
end
function worldMapBuilding:isShowWarLvEffect()
	local isHideCastleWarLvEffect = SoraDConfigGet("Game:GameOptionsView:hideCastleWarLvEffect~bool")
	return not isHideCastleWarLvEffect and not worldMapDefine.moveLineAutoHideOption.isCastleHideSkin
end
function worldMapBuilding:isShowCastleSkin()
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	return self.playerID == selfPlayerID or not worldMapDefine.moveLineAutoHideOption.isCastleHideSkin
end
function worldMapBuilding:isWarLvLod()
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	return self.playerID == selfPlayerID or devicePerformanceUtil.getCurQualityLevel() >= 2
end
function worldMapBuilding:updateBuildStar(starLv)
	self._starLv = starLv
	if starLv and 0 < starLv and self:isShowWarLvEffect() then
		self.starLv = starLv
		self.image_level:setSpriteFrame("icon_main_buildstar_lv.png")
		self.image_level:setGroupID(GROU_ID.build_star_normal)
		self.image_level:setPosition(cc.p(self.centerPoint.x + 90, self.centerPoint.y - 43))
		self.text_Level:setPosition(cc.p(self.centerPoint.x + 112, self.centerPoint.y - 60))
		local isShowWarLv, textLv = SoraDGetBuildWarLv(self.cityLevel)
		self.text_Level:setString(string.format("%d-%d", textLv, self.starLv))
		if not self.spStarLight then
			local sprite = display.newSprite()
			sprite:addTo(self.image_level)
			sprite:setPosition(83, 35)
			self.spStarLight = sprite
		end
		local iconName = cityltCtrl.getBuildStarLight(self.starLv)
		self.spStarLight:setSpriteFrame(iconName)
		self:checkAndSetVisible(self.spStarLight, true)
	else
		self:checkAndSetVisible(self.spStarLight, false)
	end
	self:setBuildStarEffect()
end
function worldMapBuilding:setBuildStarEffect(...)
	if not (self.starLv and self.starLv > 0) or not self:isShowWarLvEffect() then
		self:checkAndSetVisible(self.buildStar_light, false)
		self:checkAndSetVisible(self.buildStar_level, false)
		return
	end
	local level = cityltCtrl.getBuildStarColor(self.starLv)
	local fileName = string.format("Node_buildStar_light_%d", level)
	local effect = self.buildStar_light
	if effect and effect:getCacheName() ~= fileName then
		instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
		effect:removeFromParent(false)
		self.buildStar_light = nil
	end
	local isWarLod = self:isWarLvLod()
	if not self.buildStar_light and isWarLod then
		local effect = instanceCacheMgr.getInstance(fileName)
		if effect then
			effect:addTo(self)
			local x, y = self.image_level:getPosition()
			effect:setPosition(x + 20, y - 10)
			self.buildStar_light = effect
			effect:release()
		elseif getCCSPath(fileName) then
			local effect = SoraDCreatAnimation(fileName)
			effect:addTo(self)
			local x, y = self.image_level:getPosition()
			effect:setPosition(x + 20, y - 10)
			effect:setCacheName(fileName)
			self:setBuildStarGroupID(effect, isWarLod)
			self.buildStar_light = effect
		end
	else
		self:checkAndSetVisible(self.buildStar_light, true)
	end
	if 1 < level then
		local __, warLv = SoraDGetBuildWarLv(self.cityLevel)
		local warLvColor = 0
		if 6 <= warLv and warLv <= 7 then
			warLvColor = 1
		elseif 8 <= warLv and warLv <= 9 then
			warLvColor = 2
		elseif 10 <= warLv then
			warLvColor = 3
		end
		local fileName
		if isWarLod then
			fileName = string.format("Node_buildStar_all_%d_%d", warLvColor, level - 1)
		else
			fileName = string.format("Node_buildStar_all_%d_%d_0", warLvColor, level - 1)
		end
		local effect = self.buildStar_level
		if effect and effect:getCacheName() ~= fileName then
			instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
			effect:removeFromParent(false)
			self.buildStar_level = nil
		end
		if not self.buildStar_level then
			local effect = instanceCacheMgr.getInstance(fileName)
			if effect then
				effect:addTo(self.warLVnode)
				self.buildStar_level = effect
				effect:release()
			elseif getCCSPath(fileName) then
				local effect = SoraDCreatAnimation(fileName)
				effect:addTo(self.warLVnode)
				effect:setCacheName(fileName)
				self:setBuildStarGroupID(effect, isWarLod)
				self.buildStar_level = effect
			end
		end
		local curEffect = self.buildStar_level
		if curEffect then
			local data = worldMapDefine.getWarLevelData(warLv)
			if data then
				local pos = data.bottom.img.bg[1].pos
				local scale = data.bottom.scale or 1
				local offset = data.bottom.offset or cc.p(0, 0)
				local x = pos.x * scale + offset.x
				local y = pos.y * scale + offset.y
				curEffect:setPosition(cc.p(x, y))
			end
			worldMapDefine = pos
			data.bottom.img.bg[1].pos[1] = cc.p(-100, -70)
			data.bottom.img.bg[1].pos[2] = cc.p(-50, -70)
			data.bottom.img.bg[1].pos[3] = cc.p(170, 0)
			data.bottom.img.bg[1].pos[4] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[5] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[6] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[7] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[8] = cc.p(130, 55)
			local data.bottom.img.bg[1].pos[9], nodePos = cc.p(130, 55)
			for i = 1, 4 do
				local Node_a = SoraDGetChildByName(curEffect, "Node_a" .. i)
				if Node_a then
					Node_a:setPosition(nodePos[i])
				end
			end
		end
		self:checkAndSetVisible(self.buildStar_level, true)
		if self.node_warLvNode then
			local node_moon = SoraDGetChildByName(self.node_warLvNode, "node_moon")
			self:checkAndSetVisible(node_moon, false)
			local node_top_sword = SoraDGetChildByName(self.node_warLvNode, "node_top_sword")
			self:checkAndSetVisible(node_top_sword, false)
		end
	else
		self:checkAndSetVisible(self.buildStar_level, false)
		if self.node_warLvNode then
			local node_moon = SoraDGetChildByName(self.node_warLvNode, "node_moon")
			self:checkAndSetVisible(node_moon, true)
			local node_top_sword = SoraDGetChildByName(self.node_warLvNode, "node_top_sword")
			self:checkAndSetVisible(node_top_sword, true)
		end
	end
end
function worldMapBuilding:removeBuildStarEffect(...)
	local effect = self.buildStar_light
	if effect then
		instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
		effect:removeFromParent(false)
		self.buildStar_light = nil
	end
	local effect = self.buildStar_level
	if effect then
		instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
		effect:removeFromParent(false)
		self.buildStar_level = nil
	end
end
function worldMapBuilding:checkAndSetVisible(widget, isVisible)
	if widget then
		widget:setVisible(isVisible)
	end
end
function worldMapBuilding:setBuildStarGroupID(target, isWarLod)
	if isWarLod then
		local children = target:getChildren()
		for _, v in pairs(children) do
			local nodeType = tolua.type(v)
			if nodeType == "FairyGUI.GComponent" then
				self:setBuildStarGroupID(v, true)
			elseif nodeType == "FairyGUI.GLoader" then
				local childName = v:getName()
				local nameType = string.sub(childName, 1, 2)
				if nameType == "G_" then
					v:setGroupID(GROU_ID.build_star_glone)
				else
					v:setGroupID(GROU_ID.build_star_normal)
				end
			elseif nodeType == "FairyGUI.ParticleEx" then
				v:setGroupID(GROU_ID.build_star_particle)
			end
		end
	else
		target:setGroupAuto(true)
		target:setGroupID(GROU_ID.build_star_normal)
	end
end
function worldMapBuilding:isSysWarProtect(...)
	local endTime = self.data.sysWarProtectStatusEndTime
	if endTime and endTime > serviceFunctions.systemTime() then
		return true
	else
		return false
	end
end
function worldMapBuilding:getAllianceAbbr(...)
	return self.leagueName
end
function worldMapBuilding:updateNebulaAllStarValue(data)
	local nebulaAllStarValue = data.nebulaAllStarValue
	if not nebulaAllStarValue then
		if self.nebulaAllStarPlayer then
			self.nebulaAllStarPlayer:removeFromParent()
			self.nebulaAllStarPlayer = nil
		end
		return
	end
	local node = self.nebulaAllStarPlayer
	if not node then
		node = self:createNodeLabel()
		self.nebulaAllStarPlayer = node
		node:setPosition(cc.p(self.centerPoint.x, -120))
		node:addTo(self)
	end
	local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
	if nebulaAllStarCtrl:checkIsAllStarTeam(data.leagueID) then
		_ENV = cc.p(self.centerPoint.x, -120)
		cc.p(self.centerPoint.x, -120).num = string.formatnumberthousands(nebulaAllStarValue)
		node.Text_name:setString(i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120)))
	else
		_ENV = i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120))
		i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120)).num = string.formatnumberthousands(nebulaAllStarValue)
		node.Text_name:setString(i18n("NebulaAllstar_358", i18n("NebulaAllstar_357", cc.p(self.centerPoint.x, -120))))
	end
end
function worldMapBuilding:createNodeLabel(...)
	local node = display.newNode()
	local Image_bg = display.newSprite("#frame_map_07.png")
	node.Image_bg = Image_bg
	Image_bg:addTo(node)
	Image_bg:setGroupID(GROU_ID.group_level_build)
	_ENV = Image_bg
	Image_bg.UILabelType = 2
	Image_bg.text = ""
	Image_bg.size = 20
	Image_bg.align = cc.TEXT_ALIGNMENT_CENTER
	Image_bg.valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
	local Text_name = SoraDCreateLabel(Image_bg)
	node.Text_name = Text_name
	Text_name:addTo(node)
	Text_name:setVisible(true)
	Text_name:setColor(cc.c3b(255, 235, 185))
	Text_name:setGroupID(GROU_ID.group_text)
	SoraDSetTextWidthHeight(Text_name, cc.size(240, 26))
	return node
end
return worldMapBuilding
