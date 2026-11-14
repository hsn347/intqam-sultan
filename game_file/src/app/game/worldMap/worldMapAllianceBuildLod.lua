local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceDesRead = include("allianceDesRead")
local GROU_ID = worldMapDefine.GROU_ID
local worldMapAllianceBuildLod = class("worldMapResourceLod", include("worldMapInstanceLod"))
function worldMapAllianceBuildLod:ctor()
	worldMapAllianceBuildLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapAllianceBuildLod:_initUI()
	self.imgIcon = display.newSpriteNoChild("#lod_monster.png")
	self.imgIcon:addTo(self, -1)
	self.imgIcon:setGroupID(GROU_ID.group_lod_icon)
end
function worldMapAllianceBuildLod:_initData()
	self.isShowIcon = false
	self.leagueID = 0
	self.leagueAbbrName = nil
	self.battleState = gMapObjStateTypeDef.gMapObjStateTypeFree
end
function worldMapAllianceBuildLod:initUIBuildingIcon()
	if self.buildingIcon then
		return
	end
	self.buildingIcon = display.newSpriteNoChild("#lod_alliance_putup.png")
	self.buildingIcon:setAnchorPoint(0.5, 0.0)
	self.buildingIcon:setPosition(cc.p(0, 15))
	self.buildingIcon:setVisible(false)
	self.buildingIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self:addChild(self.buildingIcon, 2)
end
function worldMapAllianceBuildLod:initFire()
	if not self.imgFire then
		self.imgFire = display.newSprite("#lod_allianceBanner_Fire.png")
		self.imgFire:addTo(self, -1)
		self.imgFire:setGroupID(GROU_ID.group_lod_icon)
	end
end
function worldMapAllianceBuildLod:initName()
	if self.nodeName then
		return
	end
	self.nodeName = display.newNode()
	self.nodeName:addTo(self)
	self.nodeName:setPosition(cc.p(0, -30))
	self.image_league_name = display.newSprite("#frame_map_18.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:addTo(self.nodeName, 1)
	self.image_league_name:setScaleY(0.6)
	self.image_league_name:setScaleX(0.4)
	self.image_league_name:setGroupID(GROU_ID.group_level_build)
	_ENV = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = ""
	self.image_league_name.size = 14
	self.text_league_Name = SoraDCreateLabel(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:addTo(self.nodeName, 1)
	self.text_league_Name:setGroupID(GROU_ID.group_text)
end
function worldMapAllianceBuildLod:addCacheBefore()
	if self.nodeName then
		self.nodeName:setVisible(false)
	end
	if self.imgFire then
		self.imgFire:setVisible(false)
	end
	if self.buildingIcon then
		self.buildingIcon:setVisible(false)
	end
	self.isShowIcon = false
end
function worldMapAllianceBuildLod:initInstanceData(objData, worldInstanceData, instanceData)
	local classID = worldInstanceData.class
	self.classID = classID
	self:updateData(objData, true)
end
function worldMapAllianceBuildLod:updateData(data, init)
	if not data then
		return
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.status then
		self.battleState = data.status
	end
	if self.classID == gMapAllianceBuildType.subTypeAlliancePalace or self.classID == gMapAllianceBuildType.subTypeAlliancePriPalace then
		self:updateInfoPalace(data)
	elseif self.classID == gMapAllianceBuildType.subTypeAllianceFlag then
		self:updateInfoFlag(data)
		if not init then
			self:updateLodChange()
		end
	elseif self.classID == gMapAllianceBuildType.subTypeAllianceAltar then
		self:updateInfoAltar(data)
		if not init then
			self:updateLodChange()
		end
	end
	self:updateBuildingStatus()
end
function worldMapAllianceBuildLod:showInstance(show, delayTime)
	worldMapAllianceBuildLod.super.showInstance(self, show, delayTime)
	if show then
		self:updateLodChange()
	end
end
function worldMapAllianceBuildLod:updateBuildingStatus()
	local showIcon = false
	if self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
		local leagueID = self.leagueID or 0
		local selfLeagueID = allianceMgr:getOwnAid() or 0
		if leagueID == selfLeagueID then
			showIcon = true
		end
	end
	if showIcon then
		if not self.buildingIcon then
			self:initUIBuildingIcon()
		end
		self.buildingIcon:setVisible(true)
	elseif self.buildingIcon then
		self.buildingIcon:setVisible(false)
	end
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapAllianceBuildLod:updateLodChange()
	if self.classID == gMapAllianceBuildType.subTypeAllianceFlag then
		if self.isShowIcon then
			self:enableCheckVisible(self.lod <= worldLodDef.LOD4)
		else
			self:enableCheckVisible(self.lod <= worldLodDef.LOD2)
		end
	elseif self.classID == gMapAllianceBuildType.subTypeAllianceAltar then
		self:enableCheckVisible(self.lod <= worldLodDef.LOD3)
	else
		self:enableCheckVisible(self.lod <= worldLodDef.LOD4)
	end
end
local POS_PLACE = cc.p(-10, 15)
function worldMapAllianceBuildLod:updateInfoPalace(data)
	local leagueID = self.leagueID or 0
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	local nameColor = worldMapDefine.getNormalManorLineColor()
	local imgName = "lod_altarGray.png"
	if leagueID and 0 < leagueID then
		if leagueID == selfLeagueID then
			imgName = "lod_altarBlue.png"
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
		else
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			if allianceRelationType == gMapAllianceRelationType.ALLY then
				imgName = "lod_altarAzure.png"
			elseif allianceRelationType == gMapAllianceRelationType.FRIENDLY then
				imgName = "lod_altarYellow.png"
			elseif allianceRelationType == gMapAllianceRelationType.ENEMY then
				imgName = "lod_altarRed.png"
			end
		end
	end
	self.imgIcon:setColor(display.COLOR_WHITE)
	self.imgIcon:setPosition(POS_PLACE)
	self.imgIcon:setSpriteFrame(imgName)
	if data.leagueAbbrName then
		self.leagueAbbrName = data.leagueAbbrName
	end
	local leagueAbbrName = self.leagueAbbrName or ""
	if not self.nodeName then
		self:initName()
	end
	self.nodeName:setVisible(true)
	local buildName = allianceDesRead.getBuildName(self.classID)
	self.text_league_Name:setString("(" .. leagueAbbrName .. ")" .. buildName)
	self.text_league_Name:setColor(nameColor)
end
local POS_DEFAULT = cc.p(0, 0)
function worldMapAllianceBuildLod:updateInfoFlag(data)
	local leagueID = self.leagueID or 0
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	local nameColor = worldMapDefine.getNormalManorLineColor()
	local imgName = "lod_allianceBanner.png"
	if leagueID and 0 < leagueID then
		if leagueID == selfLeagueID then
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
			if data.status then
				if data.status == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
					if not self.imgFire then
						self:initFire()
					end
					self.isShowIcon = true
					self.imgFire:setVisible(true)
				else
					self.isShowIcon = false
					if self.imgFire then
						self.imgFire:setVisible(false)
					end
				end
			end
		else
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
		end
	end
	self.imgIcon:setColor(nameColor)
	self.imgIcon:setPosition(POS_DEFAULT)
	self.imgIcon:setSpriteFrame(imgName)
end
function worldMapAllianceBuildLod:updateInfoAltar(data)
	local leagueID = self.leagueID or 0
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	local nameColor = worldMapDefine.getNormalManorLineColor()
	local imgName = "lod_altar_Gray.png"
	if leagueID and 0 < leagueID then
		if leagueID == selfLeagueID then
			self.isShowIcon = true
			nameColor = display.COLOR_WHITE
			imgName = "lod_altar.png"
			if data.beast and data.beast.status and data.beast.status ~= _G.gAlliancePetState.CALL then
				imgName = "lod_altarBeast.png"
			end
		else
			self.isShowIcon = false
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
		end
	end
	self.imgIcon:setColor(nameColor)
	self.imgIcon:setPosition(POS_DEFAULT)
	self.imgIcon:setSpriteFrame(imgName)
end
return worldMapAllianceBuildLod
