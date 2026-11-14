local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local worldMapIconLodStrong = class("worldMapIconLodStrong", include("worldMapInstanceLod"))
function worldMapIconLodStrong:ctor()
	worldMapIconLodStrong.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapIconLodStrong:_initData()
	self.isShowIcon = nil
	self.leagueID = 0
end
function worldMapIconLodStrong:_initUI()
	self.imgIcon = display.newSpriteNoChild("#lod_monster.png")
	self.imgIcon:addTo(self, -1)
	self.imgIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self.node = display.newNode()
	self.node:setPositionY(-20)
	self.node:addTo(self, 1)
	self.image_level = display.newSpriteNoChild("#lod_mineLevel.png")
	self.image_level:setPosition(cc.p(0, -2))
	self.image_level:addTo(self.node)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.text_level = SoraDCreateLabel(self.image_level)
	self.text_level:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_level:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.text_level:addTo(self.node)
end
function worldMapIconLodStrong:initInstanceData(objData, worldInstanceData, instanceData)
	local classID = worldInstanceData.class
	self.classID = classID
	local lv = allianceStrongholdMineRead.getGateLv(classID)
	self.text_level:setString(lv)
	self:updateData(objData)
	self:updateLodChange()
end
function worldMapIconLodStrong:updateData(data)
	if not data then
		return
	end
	if data.occupy then
		self.leagueID = data.occupy.aid
	end
	self:updateColor()
end
local lodIcon = worldMapDefine.worldLodDef.LOD5
function worldMapIconLodStrong:updateLodChange()
	local isShowIcon = self.lod >= lodIcon
	if isShowIcon ~= self.isShowIcon then
		self.isShowIcon = isShowIcon
		self:updateImage()
		if self.isShowIcon then
			self.node:setPositionY(-20)
		else
			self.node:setPositionY(-40)
		end
	end
end
function worldMapIconLodStrong:updateImage()
	local imgName
	local buildInfo = allianceStrongholdMineRead.getGateClientCfg(self.classID)
	if buildInfo then
		if self.isShowIcon then
			imgName = buildInfo.iconLod or "lod_stronghold_tower.png"
		else
			imgName = buildInfo.imageLod or "icon_milestone_unlock_002.png"
		end
	else
		imgName = self.isShowIcon and "lod_stronghold_tower.png" or "icon_milestone_unlock_002.png"
	end
	if imgName then
		self.imgIcon:setSpriteFrame(imgName)
	end
	self:updateColor()
end
function worldMapIconLodStrong:updateColor()
	if self.isShowIcon then
		local leagueID = self.leagueID or 0
		local selfLeagueID = allianceMgr:getOwnTeamID()
		local nameColor
		if selfLeagueID == leagueID then
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
		else
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
		end
		self:setColor(nameColor)
	else
		self:setColor(display.COLOR_WHITE)
	end
end
return worldMapIconLodStrong
