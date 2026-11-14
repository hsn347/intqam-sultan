local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapDefine = include("worldMapDefine")
local worldMapInstance = include("worldMapInstance")
local radianceWarRead = include("radianceWarRead")
local worldMapRadianceWarBeacon = class("worldMapRadianceWarBeacon", function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)
local GROU_ID = worldMapDefine.GROU_ID
function _ENV()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end
;(function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)[gMapAllianceRelationType.NORMAL] = cc.c4b(234, 217, 203, 204.0)
;(function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)[gMapAllianceRelationType.SELF] = cc.c4b(117, 217, 0, 204.0)
;(function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)[gMapAllianceRelationType.ALLY] = cc.c4b(39, 215, 184, 153.0)
;(function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)[gMapAllianceRelationType.FRIENDLY] = cc.c4b(250, 250, 250, 204.0)
local (function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)[gMapAllianceRelationType.ENEMY], table_lineColor = cc.c4b(191, 58, 12, 204.0), function()
	local target = worldMapInstance.new("worldMapRadianceWarBeacon")
	include("worldMapBuildManorWar").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildFreeTime").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end
local getManorLineColor = function(lineType)
	lineType = lineType or gMapAllianceRelationType.NORMAL
	return table_lineColor[lineType]
end
function worldMapRadianceWarBeacon:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapRadianceWarBeacon:_initData()
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.iconID = nil
	self.avatar = nil
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.level = 1
	self.warStatus = gKingdomWarStatusType.inWar
	self.buildState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.relationType = gMapAllianceRelationType.NORMAL
	self.isIn = false
	self:_initOccupyTimeData()
	self:_initFreeTimeData()
	self:_initBuildConnect()
	self:_initProtectData()
end
function worldMapRadianceWarBeacon:_initBuildBg()
	self.bgImage = display.newSpriteNoChild("#Map_build_radiance_beacon.png")
	self.bgImage:setPosition(cc.p(self.centerPoint.x - 45, self.centerPoint.y + 50))
	self:addChild(self.bgImage, -1)
	self.imgColor = display.newSpriteNoChild("#dh_Tex_fht_006.png")
	self.imgColor:setPosition(cc.p(self.centerPoint.x + 8, self.centerPoint.y + 58))
	self.imgColor:setBlendFunc(gl.ONE, gl.ONE)
	self.imgColor:setGroupID(GROU_ID.group_build_color)
	self:addChild(self.imgColor, -1)
end
function worldMapRadianceWarBeacon:_initUI()
	self:_initBuildBg()
	self.image_Protect = worldMapDefine.createWorldMapProtect(true)
	self.image_Protect:setScale(0.5)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 100))
	self.image_Protect:addTo(self, 1)
	self.image_LeagueFlag = display.newSpriteNoChild(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 98, self.centerPoint.y + 30))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(GROU_ID.group_flag)
	self.image_build_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 50))
	self.image_build_name:addTo(self, 1)
	self.image_build_name:setGroupID(GROU_ID.group_level_build)
	worldMapDefine = self.image_build_name
	self.image_build_name.UILabelType = 2
	self.image_build_name.text = ""
	self.image_build_name.size = 20
	self.text_build_name = SoraDCreateLabelNoChild(self.image_build_name)
	self.text_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 50))
	self.text_build_name:addTo(self, 1)
	self.text_build_name:setGroupID(GROU_ID.group_text)
	self.text_build_name:setString(i18n("brightWar_build_09"))
	self.image_player_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 14))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(GROU_ID.group_level_build)
	worldMapDefine = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = ""
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabelNoChild(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 14))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(GROU_ID.group_text)
end
function worldMapRadianceWarBeacon:showNodeEffectFire()
	if not self.nodeEffect_fire then
		self:_initNodeEffectFire()
	end
	if self.nodeEffect_fire then
		self.nodeEffect_fire:setVisible(true)
		self.nodeEffect_fire:resume()
	end
end
function worldMapRadianceWarBeacon:hideNodeEffectFire()
	if self.nodeEffect_fire then
		self.nodeEffect_fire:setVisible(false)
		self.nodeEffect_fire:pause()
	end
end
function worldMapRadianceWarBeacon:_initNodeEffectFire()
	if not self.nodeEffect_fire then
		local nodeEffect = SoraDCreatAnimation("nodeEffect_beacon")
		nodeEffect:setPosition(cc.p(self.centerPoint.x - 45, self.centerPoint.y + 50))
		nodeEffect:addTo(self, 1)
		nodeEffect:setVisible(false)
		self.nodeEffect_fire = nodeEffect
		_ENV, _UPVALUE4_ = 1, false
		;(1).name = "Node_bg"
		;(1).groupId = GROU_ID.group_build_bg
		_ENV, (1).auto = GROU_ID.group_build_bg, true
		GROU_ID.group_build_bg.name = "Node_effect"
		GROU_ID.group_build_bg.groupId = GROU_ID.group_build_effect
		_ENV, GROU_ID.group_build_bg.auto = GROU_ID.group_build_effect, true
		GROU_ID.group_build_effect.name = "sp_light"
		_ENV, GROU_ID.group_build_effect.groupId = GROU_ID.group_build_light, GROU_ID.group_build_light
		GROU_ID.group_build_light.name = "et_light"
		GROU_ID.group_build_light.groupId = GROU_ID.group_build_light_et
		;(false)[1] = 1
		;(false)[2] = GROU_ID.group_build_bg
		;(false)[3] = GROU_ID.group_build_effect
		;(false)[4] = GROU_ID.group_build_light
		_G.SoraDSetGroup(nodeEffect, false)
	end
end
function worldMapRadianceWarBeacon:getSiteClassID()
	return self.siteClassID
end
function worldMapRadianceWarBeacon:addCacheBefore()
	self:resetOccupyTime()
	self:resetFreeTime()
	self:resetBuildManor()
	self:resetProtectime()
	self:hideNodeEffectFire()
end
function worldMapRadianceWarBeacon:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapRadianceWarBeacon:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = objId
	if self.siteClassID then
		local range = radianceWarRead.getBuildRange(self.siteClassID)
		self:setBuildSize(1, range)
	end
	self:updateData(siteData)
end
function worldMapRadianceWarBeacon:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.headid then
		self.iconID = data.headid
	end
	if data.avatar then
		self.avatar = data.avatar
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.leagueName then
		self.leagueName = data.leagueName
	end
	if data.leagueAbbrName then
		self.leagueAbbrName = data.leagueAbbrName
	end
	if data.leagueFlag then
		self.leagueFlag = data.leagueFlag
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.status then
		self.buildState = data.status
	end
	if data.level then
		self.level = data.level
		_ENV = nil
		;(nil).lv = self.level
		;(nil).name = i18n("brightWar_build_09")
		local name = i18n("common_text_134", nil)
		self.text_build_name:setString(name)
	end
	if data.isIn ~= nil then
		self.isIn = data.isIn
	end
	self:updateDataOccupyTime(data)
	self:updateDataFreeTime(data)
	self:updateDataProtectime(data)
	self:updateBuildConnect(data)
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateBuildManor()
	self:updateSafeState()
	self:updateStatus()
	_ENV = self
	self.msg = "MESSAGE_SERVER_RADIANCE_WAR_BUILD_UPDATE"
	self.siteClassID = self:getSiteClassID()
	SoraDSendMessage(self)
end
function worldMapRadianceWarBeacon:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
		self:setProtectimeShow(false)
	else
		self.image_Protect:setVisible(true)
		self:setProtectimeShow(true)
	end
end
function worldMapRadianceWarBeacon:updatePlayerInfo()
	if self.leagueID and self.leagueID > 0 then
		self:setOccupyTimeShow(true)
		if self:isOccupCompleted() then
			self:showNodeEffectFire()
		else
			self:hideNodeEffectFire()
		end
		local selfLeagueID = allianceMgr:getOwnTeamID()
		if self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_player_Name:setColor(nameColor)
			self.relationType = gMapAllianceRelationType.SELF
			self:setFreeTimeShow(true)
		else
			self:setFreeTimeShow(false)
			local allianceRelationType = gMapAllianceRelationType.NORMAL
			local nameColor = worldMapDefine.getLeagueManorLineColor(false, nil)
			self.text_player_Name:setColor(nameColor)
			if self:isConnected() then
				allianceRelationType = gMapAllianceRelationType.ENEMY
			else
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				local selfSourceID = lordInfoCtrl:getMapSourceKid()
				if 0 < self.sourceID and selfSourceID == self.sourceID then
					allianceRelationType = gMapAllianceRelationType.ALLY
				end
			end
			self.relationType = allianceRelationType
		end
		self.image_LeagueFlag:setVisible(true)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		if allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
			self.image_LeagueFlag:setScale(0.3)
		end
		local textName = self:isOccupCompleted() and self.leagueName or self.playerName
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = textName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if 0 < self.sourceID then
			textName = textName .. "#" .. tostring(self.sourceID)
		end
		self.text_player_Name:setString(textName)
	else
		self:setOccupyTimeShow(false)
		self:setFreeTimeShow(false)
		self:hideNodeEffectFire()
		self.image_LeagueFlag:setVisible(false)
		self.image_player_name:setVisible(false)
		self.text_player_Name:setVisible(false)
		local allianceRelationType = gMapAllianceRelationType.NORMAL
		if self:isConnected() then
			allianceRelationType = gMapAllianceRelationType.ENEMY
		end
		self.relationType = allianceRelationType
	end
	self:updateImageColor()
end
function worldMapRadianceWarBeacon:updateImageColor()
	local lineColor = getManorLineColor(self.relationType)
	self.lineColor = lineColor
	self.imgColor:setColor(lineColor)
end
function worldMapRadianceWarBeacon:updateStatus()
	self:updateFireEffect(self.buildState)
end
function worldMapRadianceWarBeacon:playClickSound()
	SoraDPlaySound("innerbuildsound", 101)
end
function worldMapRadianceWarBeacon:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = self:onShowWorldMapTip(onShowView)
	local tilesRolygon = include("worldMapTilesRolygon").new(self.size + 2 * self.radioation)
	tilesRolygon:setRolygonColor(self.lineColor, self.lineColor.a)
	return selectShowPanel, true, tilesRolygon
end
function worldMapRadianceWarBeacon:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom and 0 < selfLeagueID then
		if self.leagueID == 0 then
			if self.warStatus == gKingdomWarStatusType.inWar then
				local isConnected = self:isConnected()
				allianceMgr = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				;(nil).isButtonEnabled = isConnected
				table.insert(buttonTypeArray, nil)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					;(0).isButtonEnabled = isConnected
					table.insert(buttonTypeArray, 0)
				end
				if not self.isIn then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
					table.insert(buttonTypeArray, 0)
				end
			end
		elseif selfLeagueID == self.leagueID then
			if self:checkHasArmy() then
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, table.insert)
			end
			allianceMgr = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
			table.insert(buttonTypeArray, table.insert)
			local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
			if haveHall and 0 < selfLeagueID then
				allianceMgr = 0
				;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
				table.insert(buttonTypeArray, 0)
			end
			allianceMgr = 0
			;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, 0)
			if self:isOccupCompleted() and permissionCtrl:hasPlayerPermission(gAPermission.RADIANCE_BUILD_CANCEL) then
				if self:isFreeCompleted() then
					allianceMgr = gAPermission.RADIANCE_BUILD_CANCEL
					gAPermission.RADIANCE_BUILD_CANCEL.buttonType = worldMapDefine.worldMapTipButtonType_cancel
					table.insert(buttonTypeArray, gAPermission.RADIANCE_BUILD_CANCEL)
				else
					allianceMgr = gAPermission.RADIANCE_BUILD_CANCEL
					gAPermission.RADIANCE_BUILD_CANCEL.buttonType = worldMapDefine.worldMapTipButtonType_cancel_cancel
					table.insert(buttonTypeArray, gAPermission.RADIANCE_BUILD_CANCEL)
				end
			end
		else
			if self.warStatus == gKingdomWarStatusType.inWar then
				local isConnected = self:isConnected()
				allianceMgr = gAPermission.RADIANCE_BUILD_CANCEL
				gAPermission.RADIANCE_BUILD_CANCEL.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				gAPermission.RADIANCE_BUILD_CANCEL.isButtonEnabled = isConnected
				table.insert(buttonTypeArray, gAPermission.RADIANCE_BUILD_CANCEL)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					;(0).isButtonEnabled = isConnected
					table.insert(buttonTypeArray, 0)
				end
				local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
				if 1 < towerLv then
					allianceMgr = worldMapDefine.worldMapTipButtonType_xuanZhan
					worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
				end
				if not self.isIn then
					allianceMgr = worldMapDefine.worldMapTipButtonType_xuanZhan
					worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
				end
			else
			end
		end
	end
	allianceMgr = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER).buttonType = worldMapDefine.worldMapTipButtonType_build_info
	table.insert(buttonTypeArray, (cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)))
	allianceMgr = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, (cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)))
	return buttonTypeArray
end
return worldMapRadianceWarBeacon
