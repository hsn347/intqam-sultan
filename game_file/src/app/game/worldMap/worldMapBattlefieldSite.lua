local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapBattlefieldSite = class("worldMapBattlefieldSite", function()
	local target = include("worldMapInstance").new("worldMapBattlefieldSite")
	return target
end)
function worldMapBattlefieldSite:ctor()
	self.instaceImage = display.newSprite("#Pyramid_build_small.png")
	self:addChild(self.instaceImage, -1)
	self.playerID = 0
	self.playerName = nil
	self.siteClassID = nil
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.buildClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.instanceState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.finishOccupyTime = 0
	self.occupyTimeHandle = nil
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(1.9)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
	self.image_Protect:addTo(self, 1)
	self.image_player_name = display.newSprite("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 75))
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabel(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_occupy_bg = display.newSprite("#frame_main_build.png")
	self.image_occupy_bg:setPosition(cc.p(self.centerPoint.x - 100, self.centerPoint.y - 80))
	self.image_occupy_bg:setVisible(false)
	self.image_occupy_bg:addTo(self, 1)
	local mage_occupySize = self.image_occupy_bg:getContentSize()
	_ENV = self
	self.UILabelType = 2
	self.text = "10"
	self.size = 20
	self.text_occupy_time = cc.ui.UILabel.new(self)
	self.text_occupy_time:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_occupy_time:setPosition(cc.p(mage_occupySize.width / 2, mage_occupySize.height / 2))
	self.text_occupy_time:setVisible(false)
	self.text_occupy_time:addTo(self.image_occupy_bg)
end
function worldMapBattlefieldSite:setBatchNodeGroupID(groupID)
	self.instaceImage:setGroupID(groupID)
end
function worldMapBattlefieldSite:registerMsg()
	if self.siteClassID == gMapBattlefieldSiteTypeDef.subMapObjTypeTransport then
		SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILES_ROLYGON", handler(self, self.setTilesRolygonStatus))
	end
end
function worldMapBattlefieldSite:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	local siteName = worldMapDefine.getPyramidbuildingName(self.siteClassID, self.objId)
	self.text_player_Name:setString(siteName)
	local imgName = worldMapDefine.getPyramidbuildingImage(siteClassID)
	self.instaceImage:setSpriteFrame(imgName)
	if self.siteClassID == gMapBattlefieldSiteTypeDef.subMapObjTypeBigPyramid or self.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWTemple then
		self.image_Protect:setScale(1.0)
		self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
		if self.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWTemple then
			self.instaceImage:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
		end
		self.instaceImage:setScale(0.8)
	elseif self.siteClassID == gMapBattlefieldSiteTypeDef.subMapTypeAWBellTower then
		self.image_Protect:setScale(0.7)
		self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 70))
		self.instaceImage:setPosition(cc.p(self.centerPoint.x - 60, self.centerPoint.y + 40))
	else
		self.image_Protect:setScale(0.7)
		self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
		if self.siteClassID == gMapBattlefieldSiteTypeDef.subMapTypeAWArmory then
			self.instaceImage:setPosition(cc.p(self.centerPoint.x + 20, self.centerPoint.y + 20))
		end
	end
	self.buildClassID = siteClassID
	self:registerMsg()
	self:updateData(siteData)
	if self.siteClassID == gMapBattlefieldSiteTypeDef.subMapObjTypeTransport then
		self:reinitCheckVisible()
	end
end
function worldMapBattlefieldSite:updateData(data)
	if not data then
		return
	end
	dump(data, "battlefieldSite")
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.headid then
		self.headid = data.headid
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
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.warStartTime then
		self.warStartTime = data.warStartTime
	end
	if data.kingStatus then
		self.kingStatus = data.kingStatus
	end
	if data.finishOccupyTime then
		self.finishOccupyTime = data.finishOccupyTime
	end
	if data.status then
		self.instanceState = data.status
	end
	if data.campType then
		self.campType = data.campType
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateInstanceState()
	local isShowTiles = data.isShowTiles or true
	if isShowTiles then
		self:updateTilesRolygonStatus(isShowTiles)
	end
	_ENV = self
	self.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
	SoraDSendMessage(self)
end
function worldMapBattlefieldSite:updataOccupyTime()
	if self.timeNumber <= 0 then
		SoraDManagerRemoveTimer(self, self.occupyTimeHandle)
		self.occupyTimeHandle = nil
		self.text_occupy_time:setVisible(false)
		local campType = self.campType
		if campType == gAllianceWarCampType.blue then
			self.image_occupy_bg:setSpriteFrame("icon_battlefield_north.png")
		else
			self.image_occupy_bg:setSpriteFrame("icon_battlefield_south.png")
		end
	else
		self.timeNumber = self.timeNumber - 1
		self.text_occupy_time:setString(self.timeNumber)
	end
end
function worldMapBattlefieldSite:updatePlayerInfo()
	if self.leagueID == 0 or self.warStatus ~= gKingdomWarStatusType.inWar then
		self.image_occupy_bg:setVisible(false)
		return
	end
	self.image_occupy_bg:setVisible(true)
	local sysTime = serviceFunctions.systemTime()
	self.timeNumber = self.finishOccupyTime - sysTime
	if 0 >= self.timeNumber then
		self:updataOccupyTime()
	else
		local campType = self.campType
		if campType == gAllianceWarCampType.blue then
			self.image_occupy_bg:setSpriteFrame("frame_main_build.png")
		else
			self.image_occupy_bg:setSpriteFrame("frame_battlefield_round_red.png")
		end
		self.text_occupy_time:setVisible(true)
		if self.occupyTimeHandle then
			SoraDManagerRemoveTimer(self, self.occupyTimeHandle)
			self.occupyTimeHandle = nil
		end
		self.text_occupy_time:setString(self.timeNumber)
		self.occupyTimeHandle = SoradCreateTimer(self, handler(self, self.updataOccupyTime))
	end
end
function worldMapBattlefieldSite:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapBattlefieldSite:updateInstanceState()
	self:updateFireEffect(self.instanceState)
end
function worldMapBattlefieldSite:getSiteClassID()
	return self.siteClassID
end
function worldMapBattlefieldSite:getObjId()
	return self.objId
end
function worldMapBattlefieldSite:isShowTilesRolygonStatus()
	if self.siteClassID ~= gMapBattlefieldSiteTypeDef.subMapObjTypeTransport then
		return false
	end
	if allianceWarCtrl:getRemainFreeMoveTimesByTransPoints() <= 0 then
		return false
	end
	return true
end
function worldMapBattlefieldSite:setTilesRolygonStatus(target, data)
	if self.siteClassID ~= gMapBattlefieldSiteTypeDef.subMapObjTypeTransport then
		return
	end
	local isShow = false
	if data.data then
		isShow = data.data.isShow or false
	end
	self:updateTilesRolygonStatus(isShow)
end
function worldMapBattlefieldSite:updateTilesRolygonStatus(isShow)
	isShow = isShow and self:isShowTilesRolygonStatus()
	if isShow and nil == self.tilesRolygon then
		local color = worldMapDefine.getLeagueManorLineColor(false)
		local tilesRolygon = include("worldMapTilesRolygon").new(10)
		tilesRolygon:setRolygonColor(color, 128)
		self.tilesRolygon = tilesRolygon
		self:addChild(tilesRolygon)
	end
	if self.tilesRolygon then
		self.tilesRolygon:setVisible(isShow)
	end
end
function worldMapBattlefieldSite:getFavoriteName()
	local favoriteName = worldMapDefine.getPyramidbuildingName(self.siteClassID, self.objId)
	return favoriteName
end
function worldMapBattlefieldSite:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapBattlefieldSite:getInstanceOp(isSelfKindom)
	if self.siteClassID == gMapBattlefieldSiteTypeDef.subMapTypeAWArmory then
		return self:getArmoryInstanceOp(isSelfKindom)
	elseif self.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWRes then
		return self:getResInstanceOp(isSelfKindom)
	elseif self.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWSupply or self.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWHeadquarters then
		return self:getSupplyInstanceOp(isSelfKindom)
	else
		return self:getComInstanceOp(isSelfKindom)
	end
end
function worldMapBattlefieldSite:getComInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if isSelfKindom and self.warStatus == gKingdomWarStatusType.inWar then
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if 0 < selfLeagueID then
			if self.leagueID == 0 then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, nil)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					_ENV = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					table.insert(buttonTypeArray, 0)
				end
			elseif selfLeagueID == self.leagueID then
				if self:checkHasArmy() then
					_ENV = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
					table.insert(buttonTypeArray, buttonTypeArray)
				end
				if self:canHasEmojiOperator() then
					_ENV = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
					table.insert(buttonTypeArray, buttonTypeArray)
				end
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
				table.insert(buttonTypeArray, buttonTypeArray)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					_ENV = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
					table.insert(buttonTypeArray, 0)
				end
				_ENV = 0
				;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
				table.insert(buttonTypeArray, 0)
			else
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, buttonTypeArray)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					_ENV = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					table.insert(buttonTypeArray, 0)
				end
				local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
				if 1 < towerLv then
					_ENV = worldMapDefine.worldMapTipButtonType_xuanZhan
					worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
				end
			end
		end
	end
	_ENV = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, (cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)))
	return buttonTypeArray
end
function worldMapBattlefieldSite:getArmoryInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if isSelfKindom and self.warStatus == gKingdomWarStatusType.inWar then
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if 0 < selfLeagueID then
			if self.leagueID == 0 then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, nil)
			elseif selfLeagueID == self.leagueID then
				if self:checkHasArmy() then
					_ENV = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
					table.insert(buttonTypeArray, nil)
				end
				if self:canHasEmojiOperator() then
					_ENV = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
					table.insert(buttonTypeArray, nil)
				end
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
				table.insert(buttonTypeArray, nil)
			else
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, nil)
				local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
				if 1 < towerLv then
					_ENV = worldMapDefine.worldMapTipButtonType_gongJi
					worldMapDefine.worldMapTipButtonType_gongJi.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_gongJi)
				end
			end
		end
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
function worldMapBattlefieldSite:getResInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if isSelfKindom and self.warStatus == gKingdomWarStatusType.inWar then
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if 0 < selfLeagueID then
			if self.leagueID == 0 then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
				table.insert(buttonTypeArray, nil)
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
				table.insert(buttonTypeArray, nil)
			elseif selfLeagueID == self.leagueID then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
				table.insert(buttonTypeArray, nil)
				if self:checkHasArmy() then
					_ENV = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
					table.insert(buttonTypeArray, nil)
				end
			else
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
				table.insert(buttonTypeArray, nil)
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				table.insert(buttonTypeArray, nil)
				local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
				if 1 < towerLv then
					_ENV = worldMapDefine.worldMapTipButtonType_gongJi
					worldMapDefine.worldMapTipButtonType_gongJi.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_gongJi)
				end
			end
		end
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
function worldMapBattlefieldSite:getSupplyInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
function worldMapBattlefieldSite:reinitCheckVisible()
	local offset = self.holdInstace * 256
	if self.siteClassID == gMapBattlefieldSiteTypeDef.subMapObjTypeTransport then
		offset = offset + 2560
	end
	self.rect = cc.rect(-offset, -offset, display.width + 2 * offset, display.height + 2 * offset)
	self.curTimerNum = 0
	self.curTimerMax = 1
	self:updateCheckVisible()
end
function worldMapBattlefieldSite:getOccupyData(...)
	_UPVALUE0_ = nil
	;(nil).buildType = self.siteClassID
	;(nil).buildID = self.objId
	;(nil).leagueID = self.leagueID
	;(nil).leagueName = self.leagueName
	;(nil).playerID = self.playerID
	;(nil).playerName = self.playerName
	return nil
end
function worldMapBattlefieldSite:getBuildClassID(...)
	return self.buildClassID
end
return worldMapBattlefieldSite
