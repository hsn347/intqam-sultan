local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local worldMapBuildingLod2 = class("worldMapBuildingLod2", include("worldMapInstanceLod"))
local worldMapDefine = include("worldMapDefine")
local GROU_ID = worldMapDefine.GROU_ID
function worldMapBuildingLod2:ctor()
	worldMapBuildingLod2.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapBuildingLod2:_initData()
	self.playerID = 0
	self.playerName = nil
	self.leagueName = nil
	self.leagueRank = nil
	self.leagueID = 0
	self.kingdomId = 0
	self.warCamp = nil
end
function worldMapBuildingLod2:_initUI()
	self.imgIcon = display.newSpriteNoChild("#monster.png")
	self.imgIcon:addTo(self, -1)
	self.imgIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self.imgIcon:setPosition(-6, 9)
	if worldMapDefine.isNebulaAllStarKingdomID() then
		self.imgIcon:setScale(0.3)
	end
	_ENV = self.imgIcon
	self.imgIcon.UILabelType = 2
	self.imgIcon.text = ""
	self.imgIcon.size = 16
	self.text_Name = SoraDCreateLabelNoChild(self.imgIcon)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(0, -65))
	self.text_Name:addTo(self, 4)
	self.text_Name:setGroupID(GROU_ID.group_text)
	self.image_level = display.newSpriteNoChild("#frame_map_18.png")
	self.image_level:setPosition(cc.p(0, -40))
	self.image_level:addTo(self, 2)
	self.image_level:setScaleY(0.6)
	self.image_level:setScaleX(0.4)
	self.image_level:setGroupID(GROU_ID.group_level_build)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.text_Level = SoraDCreateLabelNoChild(self.image_level)
	self.text_Level:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Level:setPosition(cc.p(0, -40))
	self.text_Level:addTo(self, 2)
	self.text_Level:setGroupID(GROU_ID.group_text)
end
function worldMapBuildingLod2:initHead()
	if self.nodeHead then
		return
	end
	self.nodeHead = display.newNode()
	self.nodeHead:addTo(self)
	self.nodeHead:setPosition(cc.p(0, -30))
	self.image_league_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:addTo(self.nodeHead, 1)
	self.image_league_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = ""
	self.image_league_name.size = 20
	self.text_league_Name = SoraDCreateLabelNoChild(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:addTo(self.nodeHead, 1)
	self.text_league_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapBuildingLod2:addCacheBefore()
	if self.nodeHead then
		self.nodeHead:setVisible(false)
	end
end
function worldMapBuildingLod2:initInstanceData(objData, worldInstanceData, instanceData)
	self:updateData(objData)
end
function worldMapBuildingLod2:updateData(data)
	if not data then
		return
	end
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.leagueName then
		self.leagueName = data.leagueName
	end
	if data.leagueRank then
		self.leagueRank = data.leagueRank
	end
	if data.kingdomId then
		self.kingdomId = data.kingdomId
	end
	if data.cityLevel then
		if worldMapDefine.isGardenKingdomID() then
			self.text_Level:setString(data.gardenLv or 0)
		else
			local isWarLv, lv, _ = SoraDGetBuildWarLv(data.cityLevel)
			if isWarLv then
				gametop = nil
				;(nil).lv = lv
				if i18n("common_text_1948", nil) then
					goto lbl_71
				end
			end
			local lvDes = lv
			::lbl_71::
			if data.starLv and 0 < data.starLv then
				self.text_Level:setString(string.format("%s-%s", lvDes, data.starLv))
			else
				self.text_Level:setString(lvDes)
			end
		end
	end
	local textName = self.playerName
	if self.leagueID and 0 < self.leagueID and self.leagueName then
		textName = "(" .. self.leagueName .. ")" .. self.playerName
	end
	if self.playerID == selfPlayerID then
		if worldMapDefine.isInGarden() then
			textName = i18n("garden_text_20")
		else
			textName = i18n("common_text_496")
		end
	elseif worldMapDefine.isInRoaringFlame() then
		if data.camp then
			self.warCamp = data.camp
		end
		local roaringFlameWarRead = include("roaringFlameWarRead")
		local campName = roaringFlameWarRead.getCampName(self.warCamp)
		textName = textParser.formatPlayerName(campName, self.playerName)
	elseif worldMapDefine.isInSimulatedDrill() then
		local simulatedDrillUtil = include("simulatedDrillUtil")
		local campName = simulatedDrillUtil.getCampName(data.camp)
		textName = textParser.formatPlayerName(campName, self.playerName)
	elseif worldMapDefine.isGardenKingdomID() then
		gametop = textParser.formatPlayerName(campName, self.playerName)
		textParser.formatPlayerName(campName, self.playerName).name = textName
		textName = i18n("garden_text_21", (textParser.formatPlayerName(campName, self.playerName)))
	end
	local worldMapWarDef = include("worldMapWarDef")
	gametop = textParser.formatPlayerName(campName, self.playerName)
	textParser.formatPlayerName(campName, self.playerName).playerID = self.playerID
	textParser.formatPlayerName(campName, self.playerName).leagueID = self.leagueID
	textParser.formatPlayerName(campName, self.playerName).camp = self.warCamp or data.camp
	local nameColor = worldMapWarDef.getNameColor((textParser.formatPlayerName(campName, self.playerName)))
	self.text_Name:setString(textName)
	self.text_Name:setColor(nameColor)
	self.text_Level:setColor(nameColor)
	local imgName = self:getImgIconName()
	self.imgIcon:setSpriteFrame(imgName)
end
function worldMapBuildingLod2:getImgIconName(...)
	if worldMapDefine.isNebulaAllStarKingdomID() then
		return "allstar_player_city.png"
	end
	local worldMapWarDef = include("worldMapWarDef")
	worldMapDefine = nil
	;(nil).playerID = self.playerID
	;(nil).leagueID = self.leagueID
	;(nil).kingdomId = self.kingdomId
	;(nil).leagueRank = self.leagueRank
	local imgNameLod3, imgNameLod4 = worldMapWarDef.getCastleImage(nil)
	return imgNameLod3
end
return worldMapBuildingLod2
