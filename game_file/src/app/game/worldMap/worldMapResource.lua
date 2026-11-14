local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local instanceCacheMgr = include("instanceCacheMgr")
local worldMapResource = class("worldMapResource", function(target)
	local target = include("worldMapInstance").new("worldMapResource")
	return target
end)
function worldMapResource:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapResource:_initData()
	self.isBeOccupyed = false
	self.resourceClassID = nil
	self.resourceType = nil
	self.resourceLevel = 0
	self.playerID = 0
	self.playerName = nil
	self.leagueID = 0
	self.leagueName = nil
	self.currentSourceNum = 0
	self.sourceID = 0
	self.isSafe = false
	self.emojiID = nil
end
function worldMapResource:_initUI()
	self.resourceImage = display.newSpriteNoChild("#Map_build_food.png")
	self:addChild(self.resourceImage, -1)
	self.image_level = display.newSpriteNoChild("#icon_map_reslevel.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x + 30, self.centerPoint.y - 25))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = "1"
	self.image_level.size = 14
	self.resourceLevelLabel = SoraDCreateLabelNoChild(self.image_level)
	self.resourceLevelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.resourceLevelLabel:setSkewY(25)
	self.resourceLevelLabel:setPosition(cc.p(self.centerPoint.x + 38, self.centerPoint.y - 23))
	self.resourceLevelLabel:addTo(self, 1)
	self.resourceLevelLabel:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapResource:addCacheBefore()
	if self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
	if self.image_Protect then
		self.image_Protect:setVisible(false)
	end
	self:removeParticleNode()
end
function worldMapResource:setBatchNodeGroupID(groupID)
	self.resourceImage:setGroupID(groupID)
end
function worldMapResource:initInstanceData(resourceClassID, resourceData)
	self.resourceClassID = resourceClassID
	self.resourceType = worldMapDefine.getResourceTpyeID(resourceClassID)
	local imgName = worldMapDefine.getResourceImageName(resourceClassID)
	self.resourceImage:setSpriteFrame(imgName)
	local level = worldMapDefine.getResourceLevel(resourceClassID)
	self.resourceLevel = level
	self.instanceLevel = self.resourceLevel
	self.resourceLevelLabel:setString(level)
	self:updateData(resourceData)
end
function worldMapResource:updateData(data)
	if not data then
		return
	end
	self.playerID = data.playerID or 0
	if self.playerID == 0 then
		self.playerName = nil
	end
	self.leagueID = data.leagueID or 0
	if self.leagueID == 0 then
		self.leagueName = nil
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.leagueName then
		self.leagueName = data.leagueName
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	self:updateEmojiByData(data)
	self.currentSourceNum = data.currentSourceNum or 0
	data.lvBgColor = data.lvBgColor or gMapResourceLvBgColorDef.lvBgColorNormal
	if data.lvBgColor == gMapResourceLvBgColorDef.lvBgColorNormal then
		self.image_level:setSpriteFrame("icon_map_reslevel.png")
	elseif data.lvBgColor == gMapResourceLvBgColorDef.lvBgColorSilver then
		self.image_level:setSpriteFrame("icon_map_silvery.png")
	elseif data.lvBgColor == gMapResourceLvBgColorDef.lvBgColorGold then
		self.image_level:setSpriteFrame("icon_map_gold.png")
	end
	if data.isSafe ~= nil then
		self.isSafe = data.isSafe
	end
	if self.playerID > 0 then
		self:setBeOccupyed()
	else
		self:cancelBeOccupyed()
	end
	self:updateSafeState()
	self:updateParticleNode()
	self:updateAllianceCounterAtkEffect()
end
function worldMapResource:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.updateAllianceCounter))
end
function worldMapResource:updateAllianceCounter(target, data)
	if data and data.type and data.type == GREEN_POINT_NOTICE_TYPE.COUNTER_SYS then
		self:updateAllianceCounterAtkEffect()
	end
end
function worldMapResource:updateSafeState()
	if self.isSafe then
		if not self.image_Protect then
			self.image_Protect = worldMapDefine.createWorldMapProtect(true)
			self.image_Protect:setScale(0.5)
			self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 40))
			self.image_Protect:addTo(self, 1)
		end
		self.image_Protect:setVisible(true)
	elseif self.image_Protect then
		self.image_Protect:setVisible(false)
	end
end
function worldMapResource:setBeOccupyed()
	self.isBeOccupyed = true
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local occupyIconName = "icon_map_res_normal.png"
	if selfPlayerID == self.playerID then
		occupyIconName = "icon_map_res_me.png"
	elseif selfLeagueID == self.leagueID then
		occupyIconName = "icon_map_res_alliance.png"
	else
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
		if allianceRelationType == gMapAllianceRelationType.ALLY then
			occupyIconName = "icon_map_res_bund.png"
		elseif allianceRelationType == gMapAllianceRelationType.FRIENDLY then
			occupyIconName = "icon_map_res_friend.png"
		elseif allianceRelationType == gMapAllianceRelationType.ENEMY then
			occupyIconName = "icon_map_res_enemy.png"
		end
		if self.sourceID and self.sourceID > 0 then
			local selfSourceID = lordInfoCtrl:getMapSourceKid()
			if self.sourceID ~= selfSourceID then
				occupyIconName = "icon_map_res_others.png"
			end
		end
	end
	if not self.occupyIcon then
		self.occupyIcon = display.newSpriteNoChild("#icon_map_res_me.png")
		self.occupyIcon:setAnchorPoint(0.5, 0.0)
		self.occupyIcon:setVisible(false)
		self:addChild(self.occupyIcon, 2)
		self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	end
	self.occupyIcon:setVisible(true)
	self.occupyIcon:setSpriteFrame(occupyIconName)
end
function worldMapResource:cancelBeOccupyed()
	self.isBeOccupyed = false
	if self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
end
function worldMapResource:getFavoriteName()
	local favoriteName = worldMapDefine.getResourceName(self.resourceClassID)
	return favoriteName
end
function worldMapResource:onClickInstance(onShowView)
	local buildLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local resourceLevelLimit = worldMapDefine.getResourceCastleLv(self.resourceClassID)
	if buildLv < resourceLevelLimit then
		local lv = resourceLevelLimit
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(lv)
		if 0 < warLv then
			cityCtrl = nil
			;(nil).lv = warLv
			lv = i18n("common_text_1948", nil)
		end
		cityCtrl = nil
		;(nil).Level = lv
		local limitString = i18n("common_text_497", nil)
		SoraDShowMsgTip(limitString)
		return
	end
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapResource:playClickSound()
	local sID = worldMapDefine.getResourceTpyeID(self.resourceClassID)
	if sID == 1 then
		SoraDPlaySound("worldmap", 6)
	else
		SoraDPlaySound("innerbuildsound", 199 + sID)
	end
end
function worldMapResource:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local playerID = self.playerID or 0
	local leagueID = self.leagueID or 0
	if playerID <= 0 then
		if isSelfKindom then
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
			table.insert(buttonTypeArray, nil)
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, nil)
		end
		allianceMgr = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, nil)
	elseif isSelfKindom then
		if playerID == selfPlayerID then
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
			table.insert(buttonTypeArray, nil)
			allianceMgr = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, nil)
			if self:canHasEmojiOperator(selfPlayerID) then
				allianceMgr = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif 0 < selfLeagueID and selfLeagueID == leagueID then
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, selfPlayerID)
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, selfPlayerID)
		else
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, selfPlayerID)
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, selfPlayerID)
			local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
			if 1 < towerLv then
				allianceMgr = worldMapDefine.worldMapTipButtonType_xiangqing
				worldMapDefine.worldMapTipButtonType_xiangqing.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xiangqing)
			end
			allianceMgr = worldMapDefine.worldMapTipButtonType_xiangqing
			worldMapDefine.worldMapTipButtonType_xiangqing.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xiangqing)
		end
	else
		allianceMgr = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	return buttonTypeArray
end
local createGoldParticleNode = function()
	_ENV, _ENV = nil, nil
	;(nil).plist = "et_cwjinkuang_01.plist"
	_ENV, (nil)[1], (nil).scale = nil, nil, 1.5
	;(nil)[2], (nil).plist = nil, "et_cwjinkuang_02.plist"
	local param
	local et_node = SoraDCreateEffectNode(param)
	return et_node
end
function worldMapResource:updateParticleNode()
	if self.resourceType == 1 then
		self:addParticleNode()
	else
		self:removeParticleNode()
	end
end
local effectName = "worldMapResourceEffect"
local createParticleNode = function()
	local particle_node = display.newNode()
	local sprite = display.newSpriteNoChild("#dh_xwxuzhuang_01.png")
	SoraDMixtureGLONE(sprite)
	local frames = display.newFrames("dh_xwxuzhuang_%.2d.png", 1, 15)
	local animation = display.newAnimation(frames, 0.1111111111111111)
	sprite:setScale(2.0)
	sprite:playAnimationForever(animation)
	sprite:addTo(particle_node)
	sprite:setAnchorPoint(cc.p(0.5, 0.25))
	sprite:setOpacity(51.0)
	local et_node = createGoldParticleNode()
	if et_node then
		et_node:addTo(particle_node)
	end
	particle_node:setName(effectName)
	return particle_node
end
function worldMapResource:addParticleNode()
	local particle_node = instanceCacheMgr.getInstance(effectName)
	if particle_node then
		self.particle_node = particle_node
		self:addChild(self.particle_node, 1)
		particle_node:release()
	else
		particle_node = createParticleNode()
		if particle_node then
			self.particle_node = particle_node
			self:addChild(self.particle_node, 1)
		else
			print("createParticleNode error ")
		end
	end
end
function worldMapResource:removeParticleNode()
	if self.particle_node then
		instanceCacheMgr.addNormalNodeByType(self.particle_node, effectName)
		self.particle_node:removeFromParent(false)
		self.particle_node = nil
	end
end
return worldMapResource
