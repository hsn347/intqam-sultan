local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local worldMapAncientTreasure = class("worldMapAncientTreasure", function(target)
	local target = include("worldMapInstance").new("worldMapAncientTreasure")
	return target
end)
function worldMapAncientTreasure:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapAncientTreasure:_initData()
	self.playerName = ""
	self.playerID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueAbbrName = nil
	self.pos = nil
	self.buildID = nil
	self.buildType = 0
	self.treasureState = gATBuildingStatus.AT_EXPLORE
	self.emojiID = nil
end
function worldMapAncientTreasure:_initUI()
	self.image_LeagueFlag = display.newSprite(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 147, self.centerPoint.y - 10))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_league_name = display.newSprite("#frame_map_07.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	self.image_league_name:setVisible(false)
	self.image_league_name:addTo(self, 1)
	self.image_league_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = "leagueName"
	self.image_league_name.size = 20
	self.text_league_Name = SoraDCreateLabel(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	self.text_league_Name:setVisible(false)
	self.text_league_Name:addTo(self, 1)
	self.text_league_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_player_name = display.newSprite("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabel(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.treasureImg = display.newSprite("#Map_build_sgmk.png")
	self:addChild(self.treasureImg, -1)
	self.etNode = SoraDCreatAnimation("ancientTreasureEffect")
	SoraDMixtureGLONEByParent(self.etNode)
	self:addChild(self.etNode, 1)
end
function worldMapAncientTreasure:setBatchNodeGroupID(groupID)
	self.treasureImg:setGroupID(groupID)
end
function worldMapAncientTreasure:initInstanceData(treasureData)
	dump(treasureData, "treasureData=========")
	if not treasureData then
		return
	end
	self.pos = self:getTilePoint()
	if treasureData.buildID then
		self.buildID = treasureData.buildID
	end
	self:updateData(treasureData)
end
function worldMapAncientTreasure:updateData(treasureData)
	dump(treasureData, "worldMapAncientTreasure1111", 5)
	if not treasureData then
		return
	end
	if treasureData.playerID then
		self.playerID = treasureData.playerID
	end
	if treasureData.playerName then
		self.playerName = treasureData.playerName
	end
	local isOccupy = false
	if treasureData.aid then
		if self.leagueID ~= 0 and self.leagueID ~= treasureData.aid then
			isOccupy = true
		end
		self.leagueID = treasureData.aid
	end
	if treasureData.leagueName then
		self.leagueName = treasureData.leagueName
	end
	if treasureData.leagueAbbrName then
		self.leagueAbbrName = treasureData.leagueAbbrName
	end
	if treasureData.buildType then
		self.buildType = treasureData.buildType
	end
	if treasureData.buildStatus then
		self.treasureState = treasureData.buildStatus
	end
	self:updateEmojiByData(treasureData)
	self:updatePlayerInfo()
	_ENV = self
	self.msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	self.instance = self
	self.isOccupy = isOccupy
	SoraDSendMessage(self)
end
function worldMapAncientTreasure:updatePlayerInfo()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	if self.leagueID and self.leagueID > 0 and self.playerID and 0 < self.playerID then
		if self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_league_Name:setColor(nameColor)
			self.text_player_Name:setColor(nameColor)
		else
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			local nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			self.text_league_Name:setColor(nameColor)
			self.text_player_Name:setColor(nameColor)
		end
		self.image_LeagueFlag:setVisible(true)
		self.image_league_name:setVisible(true)
		self.text_league_Name:setVisible(true)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		if allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		self.text_league_Name:setString(self.leagueName)
		local textName = self.playerName
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = self.playerName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		self.text_player_Name:setString(textName)
	else
		self.image_LeagueFlag:setVisible(false)
		self.image_league_name:setVisible(false)
		self.text_league_Name:setVisible(false)
		self.image_player_name:setVisible(false)
		self.text_player_Name:setVisible(false)
	end
end
function worldMapAncientTreasure:getFavoriteName()
	local favoriteName = i18n("AncienTreasure_buildname_01")
	return favoriteName
end
function worldMapAncientTreasure:playClickSound()
	SoraDPlaySound("worldmap", 5)
end
function worldMapAncientTreasure:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local playerID = self.playerID or 0
	local leagueID = self.leagueID or 0
	print("playerID,selfPlayerID,leagueID,selfLeagueID,self.treasureState===", playerID, selfPlayerID, leagueID, selfLeagueID, self.treasureState)
	if isSelfKindom then
		if selfLeagueID == 0 or SoraDGetCastleLv() < 6 then
			allianceMgr = playerID
			playerID.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
			table.insert(buttonTypeArray, playerID)
			return buttonTypeArray
		end
		local allianceRelationType = SoraDGetCtrl("allianceRelationCtrl"):getRelationTypeWith(leagueID)
		if allianceRelationType == gMapAllianceRelationType.ALLY then
			allianceMgr = worldMapDefine.worldMapTipButtonType_shuoMing
			worldMapDefine.worldMapTipButtonType_shuoMing.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
			table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_shuoMing)
			return buttonTypeArray
		end
		if self.treasureState == gATBuildingStatus.AT_EXPLORE then
			if 0 < selfLeagueID and leagueID == selfLeagueID then
				allianceMgr = worldMapDefine.worldMapTipButtonType_shuoMing
				worldMapDefine.worldMapTipButtonType_shuoMing.buttonType = worldMapDefine.worldMapTipButtonType_tanmingmibao
				table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_shuoMing)
			end
			allianceMgr = worldMapDefine.worldMapTipButtonType_shuoMing
			worldMapDefine.worldMapTipButtonType_shuoMing.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
			table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_shuoMing)
		elseif self.treasureState == gATBuildingStatus.AT_MINNING then
			if 0 < selfLeagueID and self.leagueID == selfLeagueID or self.leagueID == 0 then
				allianceMgr = worldMapDefine.worldMapTipButtonType_shuoMing
				worldMapDefine.worldMapTipButtonType_shuoMing.buttonType = worldMapDefine.worldMapTipButtonType_wajuexiangqing
				table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_shuoMing)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiwajue
					table.insert(buttonTypeArray, 0)
				end
				allianceMgr = 0
				;(0).buttonType = worldMapDefine.worldMapTipButtonType_wajue
				table.insert(buttonTypeArray, 0)
			else
				print("self.leagueID,selfLeagueID===", self.leagueID, selfLeagueID)
				allianceMgr = self.leagueID
				allianceMgr, self.leagueID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi, worldMapDefine.worldMapTipButtonType_gongJi
				self.leagueID.extra, worldMapDefine.worldMapTipButtonType_gongJi.dispatchType = worldMapDefine.worldMapTipButtonType_gongJi, worldMapDefine.worldMapTipButtonType_zhanLing
				table.insert(buttonTypeArray, self.leagueID)
				if self.leagueID and 0 < self.leagueID then
					local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
					if 1 < towerLv then
						allianceMgr = worldMapDefine.worldMapTipButtonType_gongJi
						worldMapDefine.worldMapTipButtonType_gongJi.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_gongJi)
					end
				end
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					table.insert(buttonTypeArray, 0)
				end
			end
			allianceMgr = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
	else
		allianceMgr = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	return buttonTypeArray
end
return worldMapAncientTreasure
