local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapDefine = include("worldMapDefine")
local hegemonRead = include("hegemonRead")
local worldMapLegendLord = class("worldMapLegendLord", function()
	local target = include("worldMapInstance").new("worldMapLegendLord")
	return target
end)
function worldMapLegendLord:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapLegendLord:_initData()
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warStatus = gKingdomWarStatusType.close
	self.kingStatus = gKingStatus.none
	self.buildState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.occupyTime = 0
	self.isOccupy = false
	self.occupier = nil
	self.firstKillReward = false
end
function worldMapLegendLord:_initBuildBg()
	self.bgImage = display.newNode()
	self.bgImage:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 10))
	self:addChild(self.bgImage, -1)
	self.image_bg = display.newSprite("#LegendaryKing_palace.png")
	self.image_bg:setPosition(cc.p(-95, 120))
	self.image_bg:addTo(self.bgImage, 1)
end
function worldMapLegendLord:_initUI()
	self:_initBuildBg()
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:addTo(self, 1)
	self.image_LeagueFlag = display.newSprite(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 147, self.centerPoint.y + 30))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_build_name = display.newSprite("#frame_map_07.png")
	self.image_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 150))
	self.image_build_name:addTo(self, 1)
	self.image_build_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	worldMapDefine = self.image_build_name
	self.image_build_name.UILabelType = 2
	self.image_build_name.text = "playerName"
	self.image_build_name.size = 20
	self.text_build_name = SoraDCreateLabel(self.image_build_name)
	self.text_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 150))
	self.text_build_name:addTo(self, 1)
	self.text_build_name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_league_name = display.newSprite("#frame_map_07.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 25))
	self.image_league_name:setVisible(false)
	self.image_league_name:addTo(self, 1)
	self.image_league_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	worldMapDefine = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = "leagueName"
	self.image_league_name.size = 20
	self.text_league_Name = SoraDCreateLabel(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 25))
	self.text_league_Name:setVisible(false)
	self.text_league_Name:addTo(self, 1)
	self.text_league_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_player_name = display.newSprite("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 30))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	worldMapDefine = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabel(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 30))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.progressBar = SoraDCreatePanel("worldMapLegendLordProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 75))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setVisible(false)
end
function worldMapLegendLord:getSiteClassID()
	return self.siteClassID
end
function worldMapLegendLord:addCacheBefore()
	self.image_Protect:setVisible(false)
end
function worldMapLegendLord:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
	self.bgImage:setGroupAuto(true)
end
function worldMapLegendLord:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = objId
	if self.siteClassID then
		local buildName = hegemonRead.getName(self.siteClassID)
		self.text_build_name:setString(buildName)
		self.progressBar:setBuildID(self.siteClassID)
		local imgName = hegemonRead.getImage(self.siteClassID)
		self.image_bg:setSpriteFrame(imgName)
		if hegemonRead.isLegendLordBuilding(self.siteClassID) then
			self.image_bg:setPosition(cc.p(-95, 120))
			self.image_Protect:setScale(2.1)
			self.image_Protect:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 225))
			if not commonCheck.LEGEND_LORD then
				self.text_build_name:setVisible(false)
				self.image_build_name:setVisible(false)
			end
		else
			self.image_bg:setPosition(cc.p(10, 120))
			self.image_Protect:setScale(1.5)
			self.image_Protect:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 175))
		end
	end
	self:updateData(siteData)
end
function worldMapLegendLord:updateData(data)
	dump(data, "updateLegendData", 10)
	if not data then
		return
	end
	if data.occupier then
		self.occupier = data.occupier
		local occupier = data.occupier
		if not next(occupier) then
			self.playerID = 0
			self.playerName = nil
			self.leagueID = 0
			self.sourceID = occupier.sourceKid
			self.leagueName = nil
			self.leagueAbbrName = nil
			self.leagueFlag = 1
			self.occupyTime = 0
			self.isOccupy = false
			self:updateProcessBar()
			_ENV = self
			self.msg = "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_CHANGE"
			self.buildID = self.siteClassID
			self.occupier = data.occupier
			SoraDSendMessage(self)
		else
			if occupier.playerID then
				self.playerID = occupier.playerID
			end
			if occupier.playerName then
				self.playerName = occupier.playerName
			end
			if occupier.leagueID then
				self.leagueID = occupier.leagueID
			end
			if occupier.sourceKid then
				self.sourceID = occupier.sourceKid
			end
			if occupier.leagueName then
				self.leagueName = occupier.leagueName
			end
			if occupier.leagueAbbrName then
				self.leagueAbbrName = occupier.leagueAbbrName
			end
			if occupier.leagueFlag then
				self.leagueFlag = occupier.leagueFlag
			end
			if occupier.currOccupyBeginTime and occupier.histOccupyTotalSecs then
				local occupyTime = legendLordWarCtrl:getLegendOccupyTime(occupier.currOccupyBeginTime)
				self.occupyTime = occupyTime + occupier.histOccupyTotalSecs
				self.isOccupy = true
				print(self.occupyTime, "occupyTime")
				if 0 > self.occupyTime then
					self.occupyTime = 0
				end
				self:updateProcessBar()
			end
			_ENV = self.updateProcessBar
			self.updateProcessBar.msg = "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_CHANGE"
			self.updateProcessBar.buildID = self.siteClassID
			self.updateProcessBar.occupier = data.occupier
			SoraDSendMessage(self.updateProcessBar)
		end
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.kingStatus then
		self.kingStatus = data.kingStatus
	end
	if data.status then
		self.buildState = data.status
	end
	if data.firstKillReward ~= nil then
		self.firstKillReward = data.firstKillReward
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateStatus()
end
function worldMapLegendLord:updatePlayerInfo()
	if self.leagueID and self.leagueID > 0 then
		local selfLeagueID = allianceMgr:getOwnTeamID()
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
		local textName = self.playerName or ""
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = self.playerName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if 0 < self.sourceID then
			textName = textName .. "#" .. tostring(self.sourceID)
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
function worldMapLegendLord:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapLegendLord:updateStatus()
	self:updateFireEffect(self.buildState)
end
function worldMapLegendLord:updateProcessBar()
	if self.isOccupy and self.occupyTime >= 0 then
		self.progressBar:beginTime(self.occupyTime)
	else
		self.progressBar:endTime()
	end
end
function worldMapLegendLord:playClickSound()
	SoraDPlaySound("innerbuildsound", 101)
end
function worldMapLegendLord:getInstanceOp(isSelfKindom)
	print("传奇君王")
	local _ENV, buttonTypeArray = print, print
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom then
		if self.warStatus == gKingdomWarStatusType.inWar then
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
					local hasArmy, queueId = self:checkHasArmy()
					if hasArmy and queueId and (not _G._returnQueueIdList or not _G._returnQueueIdList[queueId]) then
						_ENV = worldMapDefine.worldMapTipButtonType_xuanZhan
						worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
					end
					if self:canHasEmojiOperator() then
						_ENV = worldMapDefine.worldMapTipButtonType_xuanZhan
						worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
					end
					_ENV = worldMapDefine.worldMapTipButtonType_xuanZhan
					worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
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
					_ENV = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					table.insert(buttonTypeArray, (cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)))
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
				if self.firstKillReward then
					_ENV = table.insert
					table.insert.buttonType = worldMapDefine.worldMapTipButtonType_baoxiang
					table.insert(buttonTypeArray, table.insert)
				end
			end
		else
			if self.warStatus == gKingdomWarStatusType.rule then
			else
			end
		end
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
function worldMapLegendLord:getFavoriteName()
	local favoriteName = hegemonRead.getName(self.siteClassID)
	return favoriteName
end
function worldMapLegendLord:onClickInstance(onShowView)
	if hegemonRead.isLegendLordBuilding(self.siteClassID) and not commonCheck.LEGEND_LORD then
		return nil, false
	end
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
return worldMapLegendLord
