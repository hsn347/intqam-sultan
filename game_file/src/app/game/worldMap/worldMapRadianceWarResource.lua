local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local radianceWarRead = include("radianceWarRead")
local radianceWarUtil = include("radianceWarUtil")
local worldMapRadianceWarResource = class("worldMapRadianceWarResource", function()
	local target = include("worldMapInstance").new("worldMapRadianceWarResource")
	return target
end)
local GROU_ID = worldMapDefine.GROU_ID
function worldMapRadianceWarResource:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapRadianceWarResource:_initData()
	self.resourceClassID = nil
	self.resourceType = nil
	self.playerID = 0
	self.leagueID = 0
	self.sourceID = 0
	self.playerName = nil
	self.leagueAbbrName = nil
	self.belongTeam = nil
end
function worldMapRadianceWarResource:_initUI()
	self.resourceNode = display.newNode()
	self:addChild(self.resourceNode, -1)
	self.resourceNode:setScale(0.8)
	self.resourceImage = display.newSpriteNoChild("#Map_build_food.png")
	self.resourceNode:addChild(self.resourceImage, -1)
	self.image_level = display.newSpriteNoChild("#icon_map_reslevel.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x + 30, self.centerPoint.y - 25))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = ""
	self.image_level.size = 14
	self.resourceLevelLabel = SoraDCreateLabelNoChild(self.image_level)
	self.resourceLevelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.resourceLevelLabel:setSkewY(25)
	self.resourceLevelLabel:setPosition(cc.p(self.centerPoint.x + 38, self.centerPoint.y - 23))
	self.resourceLevelLabel:addTo(self, 1)
	self.resourceLevelLabel:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.occupyIcon = display.newSpriteNoChild("#icon_map_res_me.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self.occupyIcon:setScale(0.6)
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self.image_player_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 5))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(GROU_ID.group_level_build)
	_ENV = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = ""
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabelNoChild(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 5))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(GROU_ID.group_text)
end
function worldMapRadianceWarResource:addCacheBefore()
	self.occupyIcon:setVisible(false)
	local nodeEffect_unlock = SoraDGetChildByName(self, "nodeEffect_unlock")
	if nodeEffect_unlock then
		nodeEffect_unlock:removeFromParent()
	end
end
function worldMapRadianceWarResource:setBatchNodeGroupID(groupID)
	self.resourceImage:setGroupID(groupID)
end
function worldMapRadianceWarResource:initInstanceData(resourceClassID, resourceData)
	self.resourceClassID = resourceClassID
	self.siteClassID = resourceClassID
	self.resourceType = radianceWarRead.getResourceTpyeID(resourceClassID)
	local imgName = radianceWarRead.getResourceImageName(resourceClassID)
	self.imgName = imgName
	self.resourceImage:setSpriteFrame(imgName)
	local x, y = radianceWarRead.getResourceTpyePos(resourceClassID)
	self.resourceImage:setPosition(cc.p(x, y))
	local level = radianceWarRead.getResourceLevel(resourceClassID)
	self.level = level
	self.resourceLevelLabel:setString(level)
	self:updateData(resourceData)
end
function worldMapRadianceWarResource:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.leagueAbbrName then
		self.leagueAbbrName = data.leagueAbbrName
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.belongBuildTeamId then
		if nil ~= self.belongTeam and data.belongBuildTeamId > 0 and self.belongTeam ~= data.belongBuildTeamId then
			self:showNodeEffectUnlock()
		end
		self.belongTeam = data.belongBuildTeamId or 0
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
end
function worldMapRadianceWarResource:updatePlayerInfo()
	if self.playerID > 0 then
		self:setBeOccupyed()
		self:showNodeEffectFire()
	else
		self:cancelBeOccupyed()
		self:hideNodeEffectFire()
	end
end
function worldMapRadianceWarResource:setBeOccupyed()
	self.occupyIcon:setVisible(true)
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local occupyIconName
	if selfPlayerID == self.playerID then
		occupyIconName = "icon_map_res_me.png"
	else
		local selfLeagueID = allianceMgr:getOwnTeamID()
		if selfLeagueID == self.leagueID then
			occupyIconName = "icon_map_res_alliance.png"
		else
			local selfSourceID = lordInfoCtrl:getMapSourceKid()
			if self.sourceID and self.sourceID > 0 and self.sourceID == selfSourceID then
				occupyIconName = "icon_map_res_bund.png"
			else
				occupyIconName = "icon_map_res_enemy.png"
			end
		end
	end
	self.occupyIcon:setSpriteFrame(occupyIconName)
	self.image_player_name:setVisible(true)
	self.text_player_Name:setVisible(true)
	local textName = self.playerName or ""
	if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
		gametop = nil
		;(nil).abbr = self.leagueAbbrName
		;(nil).name = textName
		textName = i18n("common_text_186", nil)
	end
	if self.sourceID > 0 then
		textName = textName .. "#" .. tostring(self.sourceID)
	end
	local nameColor
	self.text_player_Name:setString(textName)
	local selfLeagueID = allianceMgr:getOwnTeamID()
	if self.leagueID == selfLeagueID then
		nameColor = worldMapDefine.getLeagueManorLineColor(true)
	else
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
		nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
	end
	self.text_player_Name:setColor(nameColor)
end
function worldMapRadianceWarResource:cancelBeOccupyed()
	self.occupyIcon:setVisible(false)
	self.image_player_name:setVisible(false)
	self.text_player_Name:setVisible(false)
end
function worldMapRadianceWarResource:playClickSound()
	local sID = radianceWarRead.getResourceTpyeID(self.resourceClassID)
	if sID == 1 then
		SoraDPlaySound("worldmap", 6)
	else
		SoraDPlaySound("innerbuildsound", 199 + sID)
	end
end
function worldMapRadianceWarResource:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local playerID = self.playerID or 0
	if isSelfKindom then
		local selfPlayerID = gametop.playertop_:getPlayerID()
		if 0 < playerID and playerID == selfPlayerID then
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_cancel
			table.insert(buttonTypeArray, nil)
		elseif self.leagueID ~= selfLeagueID then
			local isEnable = true
			local msgTipsKey
			if self.resourceType == _G.gWorldTypeServerDef.subMapTypeRadianceWarResAmberMine then
				isEnable = radianceWarUtil.checkCanOccupyAmberMine()
				if not isEnable then
					msgTipsKey = i18n("brightWar_text_170")
				end
			end
			if isEnable then
				isEnable = radianceWarUtil.isInSelfLeagueManor(self:getTilePoint(), selfLeagueID)
				if not isEnable then
					function msgTipsKey()
						radianceWarUtil.showGuildToBuild(self:getTilePoint())
					end
				end
			end
			allianceMgr = selfLeagueID
			selfLeagueID.buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
			selfLeagueID.isButtonEnabled = isEnable
			selfLeagueID.msgTipsKey = msgTipsKey
			table.insert(buttonTypeArray, selfLeagueID)
			allianceMgr = selfLeagueID
			selfLeagueID.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, selfLeagueID)
		end
		allianceMgr = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
		table.insert(buttonTypeArray, table.insert)
	end
	allianceMgr = buttonTypeArray
	buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, buttonTypeArray)
	return buttonTypeArray
end
function worldMapRadianceWarResource:showNodeEffectUnlock()
	local nodeEffect = SoraDCreatAnimation("nodeEffect_unlock")
	_ENV, _ENV = nil, "nodeEffect_unlock"
	_ENV, ("nodeEffect_unlock")["radiance_radiant_quarry_03.png"], (nil).pos = nil, nil, cc.p(25, 10)
	;(nil).pos = cc.p(-15, 10)
	;("nodeEffect_unlock")["radiance_Adv_War_Medal_02.png"], (nil).scale = nil, 1.23
	local buildResourceCfg = "nodeEffect_unlock"
	nodeEffect:setPosition(cc.p(0, 0))
	local cfg = buildResourceCfg[self.imgName]
	if cfg and cfg.pos then
		nodeEffect:setPosition(cfg.pos)
	end
	if cfg and cfg.scale then
		nodeEffect:setScale(cfg.scale)
	end
	nodeEffect:addTo(self, 1)
	nodeEffect:setName("nodeEffect_unlock")
	local Particle_1 = SoraDGetChildByName(nodeEffect, "Particle_1")
	Particle_1:setVisible(false)
	_UPVALUE3_ = cc.p(0, 0)
	cc.p(0, 0)[1] = cca.delay(0.5)
	cc.p(0, 0)[2] = cca.callFunc(function()
		Particle_1:setVisible(true)
		Particle_1:resume()
	end)
	cc.p(0, 0)[3] = cca.delay(1.0)
	cc.p(0, 0)[4] = cca.callFunc(function()
		nodeEffect:removeFromParent()
	end)
	cc.p(0, 0)[5] = cca.callFunc(function()
		nodeEffect:removeFromParent()
	end)
	nodeEffect:runAction(cca.seq(cc.p(0, 0)))
end
function worldMapRadianceWarResource:hideNodeEffectFire(...)
	if self.nodeEffect_fire then
		self.nodeEffect_fire:setVisible(false)
		self.nodeEffect_fire:pause()
	end
end
function worldMapRadianceWarResource:removeNodeEffectFire(...)
	if self.nodeEffect_fire then
		self.nodeEffect_fire:removeFromParent()
		self.nodeEffect_fire = nil
	end
end
function worldMapRadianceWarResource:showNodeEffectFire()
	_ENV = nil
	;(nil)["radiance_astral_ruins_01.png"] = "Node_Effect_xyyj01"
	;(nil)["radiance_astral_ruins_02.png"] = "Node_Effect_xyyj02"
	local (nil)["radiance_astral_ruins_03.png"], buildImage2csb = "Node_Effect_xyyj03", nil
	local csbName = buildImage2csb[self.imgName]
	if not csbName then
		self:hideNodeEffectFire()
		return
	end
	if self.nodeEffect_fire then
		if self.nodeEffect_fire.csbName == csbName then
			self.nodeEffect_fire:setVisible(true)
			self.nodeEffect_fire:resume()
			return
		else
			self:removeNodeEffectFire()
		end
	end
	if not self.nodeEffect_fire then
		local nodeEffect = SoraDCreatAnimation(csbName)
		local x, y = self.resourceImage:getPosition()
		nodeEffect:setPosition(cc.p(x, y))
		nodeEffect:addTo(self.resourceNode, 1)
		nodeEffect.csbName = csbName
		self.nodeEffect_fire = nodeEffect
		_ENV, _UPVALUE4_ = 1, self.resourceNode
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
		self.resourceNode[1] = 1
		self.resourceNode[2] = GROU_ID.group_build_bg
		self.resourceNode[3] = GROU_ID.group_build_effect
		self.resourceNode[4] = GROU_ID.group_build_light
		_G.SoraDSetGroup(nodeEffect, self.resourceNode)
	end
end
return worldMapRadianceWarResource
