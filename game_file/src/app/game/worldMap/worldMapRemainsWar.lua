local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapDefine = include("worldMapDefine")
local remainsWarRead = include("remainsWarRead")
local worldMapInstance = include("worldMapInstance")
local worldMapRemainsWar = class("worldMapRemainsWar", function()
	local target = worldMapInstance.new("worldMapRemainsWar")
	return target
end)
function worldMapRemainsWar:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapRemainsWar:_initData()
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warCamp = nil
	self.warStatus = gKingdomWarStatusType.close
	self.buildState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.occupier = nil
end
function worldMapRemainsWar:_initBuildBg()
	self.bgImage = display.newNode()
	self.bgImage:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y))
	self:addChild(self.bgImage, -1)
	self.image_bg = display.newSprite("#ruins_palace.png")
	self.image_bg:setPosition(cc.p(-60, 100))
	self.image_bg:addTo(self.bgImage, 1)
	local GROU_ID = worldMapDefine.GROU_ID
	self.image_top = display.newSprite("ruins_palace_top.png")
	self.image_top:setPosition(cc.p(self.centerPoint.x + 26.28, self.centerPoint.y + 199))
	self:addChild(self.image_top, -1)
	self.image_top:setGroupID(GROU_ID.group_flag)
end
function worldMapRemainsWar:_initUI()
	self:_initBuildBg()
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(2.25)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 220))
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
	self.image_player_name = display.newSprite("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 90))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	worldMapDefine = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabel(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 90))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapRemainsWar:getSiteClassID()
	return self.siteClassID
end
function worldMapRemainsWar:addCacheBefore()
	self.image_Protect:setVisible(false)
	self.warCamp = nil
end
function worldMapRemainsWar:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
	self.bgImage:setGroupAuto(true)
end
function worldMapRemainsWar:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = objId
	if self.siteClassID then
		local buildName = remainsWarRead.getBuildName(self.siteClassID)
		self.text_build_name:setString(buildName)
		local imgName = remainsWarRead.getBuildImage(self.siteClassID)
		self.image_bg:setSpriteFrame(imgName)
		if not _G.SoraDHasBg(imgName) then
			self.image_top:setVisible(false)
		else
			self.image_top:setVisible(true)
		end
	end
	self:updateData(siteData)
end
function worldMapRemainsWar:updateData(data)
	dump(data, "updateRemainsWarData", 10)
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
		self.headid = data.headid
	end
	if data.avatar then
		self.avatar = data.avatar
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.camp then
		self.warCamp = data.camp
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
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateStatus()
	_ENV = self
	self.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
	SoraDSendMessage(self)
end
function worldMapRemainsWar:updatePlayerInfo()
	if self.leagueID and self.leagueID > 0 then
		local selfLeagueID = allianceMgr:getOwnTeamID()
		if self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_player_Name:setColor(nameColor)
		else
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			local nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			self.text_player_Name:setColor(nameColor)
		end
		self.image_LeagueFlag:setVisible(true)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		if self.warCamp and 0 < self.warCamp then
			self.image_LeagueFlag:setSpriteFrame(remainsWarRead.getCampIcon(self.warCamp))
			if 1 == self.warCamp then
				self.image_LeagueFlag:setScale(0.5)
			else
				self.image_LeagueFlag:setScale(1.0)
			end
		elseif allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
			self.image_LeagueFlag:setScale(0.3)
		end
		local textName = self.playerName
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
		self.image_player_name:setVisible(false)
		self.text_player_Name:setVisible(false)
	end
end
function worldMapRemainsWar:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapRemainsWar:updateStatus()
	self:updateFireEffect(self.buildState)
end
function worldMapRemainsWar:addFireEffect(fightTime, data)
	worldMapInstance.addFireEffect(self, fightTime, data)
	if self.fireNode then
		local GROU_ID = worldMapDefine.GROU_ID
		self.fireNode:setGroupID(GROU_ID.group_flag)
		self.fireNode:setGroupAuto(true)
	end
end
function worldMapRemainsWar:playClickSound()
	SoraDPlaySound("innerbuildsound", 101)
end
function worldMapRemainsWar:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom then
		if self.warStatus == gKingdomWarStatusType.inWar then
			if 0 < selfLeagueID then
				if self.leagueID == 0 then
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					table.insert(buttonTypeArray, nil)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						allianceMgr = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						table.insert(buttonTypeArray, 0)
					end
				elseif selfLeagueID == self.leagueID then
					if self:checkHasArmy() then
						allianceMgr = buttonTypeArray
						buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
						table.insert(buttonTypeArray, buttonTypeArray)
					end
					if self:canHasEmojiOperator() then
						allianceMgr = buttonTypeArray
						buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
						table.insert(buttonTypeArray, buttonTypeArray)
					end
					allianceMgr = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
					table.insert(buttonTypeArray, buttonTypeArray)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						allianceMgr = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
						table.insert(buttonTypeArray, 0)
					end
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
					table.insert(buttonTypeArray, 0)
				else
					allianceMgr = buttonTypeArray
					buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
					table.insert(buttonTypeArray, buttonTypeArray)
					local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
					if haveHall and 0 < selfLeagueID then
						allianceMgr = 0
						;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
						table.insert(buttonTypeArray, 0)
					end
					local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
					if 1 < towerLv then
						allianceMgr = worldMapDefine.worldMapTipButtonType_xuanZhan
						worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
						table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
					end
				end
			end
		else
			if self.warStatus == gKingdomWarStatusType.rule then
			else
			end
		end
	end
	allianceMgr = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
return worldMapRemainsWar
