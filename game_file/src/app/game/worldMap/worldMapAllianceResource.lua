local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local worldMapAllianceResource = class("worldMapAllianceResource", function(target)
	local target = include("worldMapInstance").new("worldMapAllianceResource")
	return target
end)
function worldMapAllianceResource:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapAllianceResource:_initData()
	self.resourceClassID = nil
	self.resourceType = nil
	self.resourceLevel = 0
	self.leagueID = 0
	self.leagueName = nil
	self.isSelfIn = false
	self.leftTime = 0
	self.buildPoint = 0
	self.allianceResourceState = gMapObjStateTypeDef.gMapObjStateTypeFree
end
function worldMapAllianceResource:_initUI()
	self.occupyIcon = display.newSpriteNoChild("#icon_map_res_me.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self.resourceImage = display.newSpriteNoChild("#alliance_mineral_nongtian.png")
	self:addChild(self.resourceImage, -1)
	self.image_name = display.newSpriteNoChild("#frame_SJDT_mingpai.png")
	self.image_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name:setOpacity(127.5)
	self.image_name:setContentSize(cc.size(173, 25))
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_name:addTo(self, 1)
	self.image_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = "allianceResource"
	self.image_name.size = 18
	self.text_Name = SoraDCreateLabelNoChild(self.image_name)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.text_Name:addTo(self, 2)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapAllianceResource:addCacheBefore()
end
function worldMapAllianceResource:setBatchNodeGroupID(groupID)
	self.resourceImage:setGroupID(groupID)
end
function worldMapAllianceResource:initInstanceData(resourceClassID, resourceData)
	self.resourceClassID = resourceClassID
	self.resourceType = worldMapDefine.getAllianceResourceType(resourceClassID)
	local imgName = worldMapDefine.getAllianceResourceImageName(resourceClassID)
	self.resourceImage:setSpriteFrame(imgName)
	self:updateData(resourceData)
end
function worldMapAllianceResource:updateData(data)
	if not data then
		return
	end
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local resourceName = worldMapDefine.getAllianceResourceName(self.resourceClassID)
	if data.level then
		self.resourceLevel = data.level
		self.instanceLevel = self.resourceLevel
	end
	self.leagueID = data.leagueID or 0
	if self.leagueID == 0 then
		self.leagueName = nil
	end
	if data.leagueName then
		self.leagueName = data.leagueName
	end
	if data.isSelfIn ~= nil then
		self.isSelfIn = data.isSelfIn
	else
		local isSelfIn = self:checkIsSelfIn()
		self.isSelfIn = isSelfIn
	end
	if data.status then
		self.allianceResourceState = data.status
	end
	if data.leftTime then
		self.leftTime = data.leftTime
	end
	self.superRes = data
	self.occupyIcon:setVisible(self.isSelfIn)
	if self.allianceResourceState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
		self.text_Name:setString("(" .. self.leagueName .. ")" .. resourceName .. "(" .. i18n("common_text_2139") .. ")")
	else
		self.text_Name:setString("(" .. self.leagueName .. ")" .. resourceName .. "(" .. i18n("common_text_830") .. ")")
	end
	self:updateIsInConstruction()
	if self.leagueID and self.leagueID > 0 then
		local nameColor = cc.c3b(0, 200, 200)
		if self.leagueID == selfLeagueID then
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
		else
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			local selfSourceID = lordInfoCtrl:getMapSourceKid()
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			local isMatchKingdom = conquestWarCtrl:isMatchKingdom(selfSourceID, self.kingdomID)
			if isMatchKingdom then
				allianceRelationType = gMapAllianceRelationType.ENEMY
			end
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
		end
		self.text_Name:setColor(nameColor)
	else
		self.text_Name:setColor(cc.c3b(200, 200, 200))
	end
end
function worldMapAllianceResource:getFavoriteName()
	local favoriteName
	if self.leagueName then
		_ENV = nil
		;(nil).abbr = self.leagueName
		;(nil).name = worldMapDefine.getAllianceResourceName(self.resourceClassID)
		favoriteName = i18n("common_text_186", nil)
	else
		favoriteName = worldMapDefine.getAllianceResourceName(self.resourceClassID)
	end
	return favoriteName
end
function worldMapAllianceResource:playClickSound()
	local sId = worldMapDefine.getAllianceResourceType(self.resourceClassID) + 1
	if sId == 1 then
		SoraDPlaySound("worldmap", 6)
	else
		SoraDPlaySound("innerbuildsound", 199 + sId)
	end
end
function worldMapAllianceResource:getBuildPoint()
	local buildPoint = 0
	if self.superRes then
		local surplusPoint = self.superRes.surplusPoint or 0
		if self.superRes.buildSpeed and 0 < self.superRes.buildSpeed and self.superRes.buildSpeedTime and 0 < self.superRes.buildSpeedTime then
			surplusPoint = self.superRes.surplusPoint - self.superRes.buildSpeed * (serviceFunctions.systemTime() - self.superRes.buildSpeedTime)
		end
		buildPoint = math.floor((self.superRes.totalPoint or 0) - surplusPoint)
	end
	return buildPoint
end
function worldMapAllianceResource:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local isInWarKingdom = false
	local gametop = gModuleMgr.getObject("gametop")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	if conquestWarCtrl:isPlayerConquestWarMigration() then
		isInWarKingdom = true
	end
	if 0 < selfLeagueID and selfLeagueID == self.leagueID then
		if self.isSelfIn then
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
			;(nil).isButtonEnabled = not isInWarKingdom
			table.insert(buttonTypeArray, nil)
		elseif self.allianceResourceState == gMapObjStateTypeDef.gMapObjStateTypeFree then
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_caiji
			;(nil).isButtonEnabled = not isInWarKingdom
			table.insert(buttonTypeArray, nil)
		elseif self.allianceResourceState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_jianzao
			;(nil).isButtonEnabled = not isInWarKingdom
			table.insert(buttonTypeArray, nil)
		end
		allianceMgr = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_chakanxiangqing
		;(nil).isButtonEnabled = not isInWarKingdom
		table.insert(buttonTypeArray, nil)
	else
		allianceMgr = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, nil)
	end
	return buttonTypeArray
end
function worldMapAllianceResource:checkIsSelfIn()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if kingdomMapCtrl.kingdomMapCell:hasMyQueueToMapObj(self.instanceID, gMapMoveLineServerType.moveLineTypeSuperResource, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
		return true
	end
end
function worldMapAllianceResource:updateIsInConstruction()
	local isInConstruction = self.allianceResourceState == gMapObjStateTypeDef.gMapObjStateTypeWorking
	if isInConstruction and self.buildingSp == nil then
		local sprite = SoraDCreatAnimation("chuizigx")
		sprite:setScale(1.0)
		sprite:addTo(self, 2)
		sprite:setPosition(0, 140)
		self.buildingSp = sprite
	elseif self.buildingSp ~= nil then
		self.buildingSp:setVisible(isInConstruction)
	end
end
return worldMapAllianceResource
