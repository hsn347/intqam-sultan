local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local worldMapRedTreasureMap = class("worldMapRedTreasureMap", function(target)
	local target = include("worldMapInstance").new("worldMapRedTreasureMap")
	return target
end)
function worldMapRedTreasureMap:ctor()
	self.isBeOccupyed = false
	self.playerName = ""
	self.playerID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.digTime = 0
	self.treasureState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.emojiID = nil
	self.treasureImg = display.newSprite("#Map_build_treasure_free.png")
	self:addChild(self.treasureImg, -1)
	self.occupyIcon = display.newSprite("#icon_map_res_me.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self.workManImg = display.newSprite("#kaicaikuangshi_001.png")
	self.workManImg:setPosition(cc.p(30, 10))
	self.workManImg:addTo(self, 999)
	local frames = display.newFrames("kaicaikuangshi_0%.2d.png", 1, 12)
	local animation = display.newAnimation(frames, 0.15)
	self.workManImg:playAnimationForever(animation)
	self.workManImg:setVisible(false)
	self.workManImg:setLocalZOrder(1)
	_ENV, _ENV = self.workManImg, self.workManImg.setLocalZOrder
	_ENV, self.workManImg.plist = 1, "et_castle_attack_yan_01.plist"
	;(1).x = 0.74
	_ENV, self.workManImg.setLocalZOrder[1], self.workManImg.scale, (1).y = self.workManImg, self.workManImg, 1, 0.74
	_ENV, self.workManImg.plist = 1, "et_castle_attack_yan_02.plist"
	;(1).x = -11.82
	_ENV, self.workManImg.pos, (1).y = 1, 1, -2.1
	;(1).x = 1.27
	self.workManImg.setLocalZOrder[2], self.workManImg.scale, (1).y = self.workManImg, 1, 1.15
	local param = self.workManImg.setLocalZOrder
	self.fireNode = SoraDCreateEffectNode(param)
	self.fireNode:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y - 0))
	self:addChild(self.fireNode, 3)
	_ENV, _ENV = self, self.addChild
	_ENV, self.addChild[1], self.plist = self, self, "et_castle_ranshao_yan_01.plist"
	_ENV, self.plist = self.fireNode, "et_castle_ranshao_yan_02.plist"
	self.fireNode.x = -6
	self.addChild[2], self.pos, self.fireNode.y = self, self.fireNode, -16.32
	local param = self.addChild
	self.fireNode_ex = SoraDCreateEffectNode(param)
	self.fireNode_ex:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y - 0))
	self:addChild(self.fireNode_ex, 3)
	_ENV, _ENV = self, self.addChild
	_ENV, self.plist = self.fireNode_ex, "et_Par_jkkk_001.plist"
	self.fireNode_ex.x = 3
	_ENV, self.pos, self.fireNode_ex.y = self.fireNode_ex, self.fireNode_ex, -75.0
	self.fireNode_ex.x = 1.2
	self.addChild[1], self.scale, self.fireNode_ex.y = self, self.fireNode_ex, 1.2
	local param = self.addChild
	self.lightNode = SoraDCreateEffectNode(param)
	self.lightNode:setPosition(cc.p(self.centerPoint.x + 20, self.centerPoint.y + 80))
	self:addChild(self.lightNode, 3)
	self.fireLightImg = display.newSprite("#dh_Tex_jkkk_001.png")
	self.fireLightImg:addTo(self.lightNode, 999)
	self.fireLightImg:setPosition(cc.p(40, -25))
	self.fireLightImg:setScale(1.3)
	self.fireLightImg:setRotation(22.28)
	SoraDMixtureGLONE(self.fireLightImg)
	self.fireLightImg:setLocalZOrder(2)
	_ENV, _ENV = self.fireLightImg, self.fireLightImg.setLocalZOrder
	_ENV, self.fireLightImg.plist = 2, "et_Par_jkkk_002.plist"
	;(2).x = -36.69
	_ENV, self.fireLightImg.pos, (2).y = 2, 2, -32.91
	;(2).x = 1.3
	_ENV, self.fireLightImg.setLocalZOrder[1], self.fireLightImg.scale, (2).y = self.fireLightImg, self.fireLightImg, 2, 1.3
	_ENV, self.fireLightImg.plist = 2, "et_Par_jkkk_002.plist"
	;(2).x = 45.2
	_ENV, self.fireLightImg.pos, (2).y = 2, 2, -20.94
	;(2).x = 0.6
	_ENV, self.fireLightImg.setLocalZOrder[2], self.fireLightImg.scale, (2).y = self.fireLightImg, self.fireLightImg, 2, 1.0
	_ENV, self.fireLightImg.plist = 2, "et_Par_jkkk_002.plist"
	;(2).x = -0.63
	_ENV, self.fireLightImg.pos, (2).y = 2, 2, 9.34
	;(2).x = 0.6023
	_ENV, self.fireLightImg.setLocalZOrder[3], self.fireLightImg.scale, (2).y = self.fireLightImg, self.fireLightImg, 2, 1.4283
	_ENV, self.fireLightImg.plist = 2, "et_Par_jkkk_003.plist"
	;(2).x = -19.92
	_ENV, self.fireLightImg.pos, (2).y = 2, 2, -35.55
	;(2).x = 0.5
	_ENV, self.fireLightImg.setLocalZOrder[4], self.fireLightImg.scale, (2).y = self.fireLightImg, self.fireLightImg, 2, 0.5
	_ENV, self.fireLightImg.plist = 2, "et_Par_jkkk_003.plist"
	;(2).x = 39.79
	_ENV, self.fireLightImg.pos, (2).y = 2, 2, -12.66
	;(2).x = 0.5
	self.fireLightImg.setLocalZOrder[5], self.fireLightImg.scale, (2).y = self.fireLightImg, 2, 0.5
	local param = self.fireLightImg.setLocalZOrder
	self.yanNode = SoraDCreateEffectNode(param)
	self.yanNode:setPosition(cc.p(self.centerPoint.x + 10, self.centerPoint.y + 30))
	self:addChild(self.yanNode, 3)
	self:removeFireEffect(true, true)
end
function worldMapRedTreasureMap:setBatchNodeGroupID(groupID)
	self.treasureImg:setGroupID(groupID)
end
function worldMapRedTreasureMap:initInstanceData(resourceClassID, treasureData)
	dump(treasureData, "worldMapRedTreasureMap:initInstanceData(treasureData)", 10)
	if not treasureData then
		return
	end
	self:updateData(treasureData)
end
function worldMapRedTreasureMap:updateData(treasureData)
	dump(treasureData, "worldMapRedTreasureMap:updateData(treasureData)", 10)
	if not treasureData then
		return
	end
	self.playerID = treasureData.playerID or 0
	if self.playerID == 0 then
		self.playerName = nil
	end
	self.leagueID = treasureData.aid or 0
	print("worldMapRedTreasureMap:updateDat--- ", self.leagueID)
	if self.leagueID == 0 then
		self.leagueName = nil
	end
	if treasureData.createNickName then
		self.playerName = treasureData.createNickName
	end
	if treasureData.createAbbr then
		self.leagueName = treasureData.createAbbr
	end
	self.digTime = treasureData.digTime - treasureData.digTimePassed
	self.digEndTime = treasureData.digEndTime or 0
	self.createUid = treasureData.createUid
	if treasureData.status then
		self.treasureState = treasureData.status
	end
	self.defendFailedTimes = treasureData.defendFailedTimes
	print("self.treasureState", self.treasureState)
	self.fireLightImg:setVisible(self.treasureState == gMapObjStateTypeDef.gMapObjStateTypeWorking)
	self.workManImg:setVisible(self.treasureState == gMapObjStateTypeDef.gMapObjStateTypeWorking)
	self.yanNode:setVisible(self.defendFailedTimes >= 3)
	if self.treasureState == gMapObjStateTypeDef.gMapObjStateTypeFree and self.defendFailedTimes < 3 then
		self.workManImg:setVisible(false)
		self:removeFireEffect(true, true)
		self.lightNode:setVisible(true)
		self.treasureImg:setSpriteFrame("Map_build_treasure_free.png")
	elseif self.treasureState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
		self.fireLightImg:setColor(cc.c3b(255, 117, 117))
		_UPVALUE1_ = cc.c3b(255, 117, 117)
		_UPVALUE1_ = cc.c3b(255, 117, 117)
		cc.c3b(255, 117, 117)[1] = cca.tintTo(1, 1, 1, 1)
		cc.c3b(255, 117, 117)[2] = cca.tintTo(1, 1, 0.4588235294117647, 0.4588235294117647)
		cc.c3b(255, 117, 117)[3] = cca.tintTo(1, 1, 0.4588235294117647, 0.4588235294117647)
		cc.c3b(255, 117, 117)[4] = cca.tintTo(1, 1, 0.4588235294117647, 0.4588235294117647)
		cc.c3b(255, 117, 117)[5] = cca.tintTo(1, 1, 0.4588235294117647, 0.4588235294117647)
		cc.c3b(255, 117, 117)[6] = cca.tintTo(1, 1, 0.4588235294117647, 0.4588235294117647)
		_UPVALUE1_ = cca.tintTo(1, 1, 1, 1)
		cca.tintTo(1, 1, 1, 1)[1] = cca.fadeTo(1, 1)
		cca.tintTo(1, 1, 1, 1)[2] = cca.fadeTo(1, 0.5)
		cca.tintTo(1, 1, 1, 1)[3] = cca.fadeTo(1, 0.5)
		cca.tintTo(1, 1, 1, 1)[4] = cca.fadeTo(1, 0.5)
		cca.tintTo(1, 1, 1, 1)[5] = cca.fadeTo(1, 0.5)
		cc.c3b(255, 117, 117)[1] = cca.seq(cc.c3b(255, 117, 117))
		cc.c3b(255, 117, 117)[2] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		cc.c3b(255, 117, 117)[3] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		cc.c3b(255, 117, 117)[4] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		cc.c3b(255, 117, 117)[5] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		cc.c3b(255, 117, 117)[6] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		cc.c3b(255, 117, 117)[7] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		cc.c3b(255, 117, 117)[8] = cca.seq((cca.tintTo(1, 1, 1, 1)))
		self.fireLightImg:runAction(cca.repeatForever(cca.spawn(cc.c3b(255, 117, 117))))
		self.lightNode:setVisible(true)
		self.treasureImg:setSpriteFrame("Map_build_treasure_working.png")
	elseif self.defendFailedTimes >= 3 then
		self.workManImg:setVisible(false)
		self.lightNode:setVisible(false)
		self.treasureImg:setSpriteFrame("Map_build_treasure_hurtDie.png")
	end
	self:updateFireEffect(self.treasureState)
	self:updateEmojiByData(treasureData)
	if self.playerID > 0 then
		self:setBeOccupyed()
	else
		self:cancelBeOccupyed()
	end
end
function worldMapRedTreasureMap:setBeOccupyed()
	self.isBeOccupyed = true
	self.occupyIcon:setVisible(true)
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
	self.occupyIcon:setSpriteFrame(occupyIconName)
end
function worldMapRedTreasureMap:cancelBeOccupyed()
	self.isBeOccupyed = false
	self.occupyIcon:setVisible(false)
end
function worldMapRedTreasureMap:getFavoriteName()
	local favoriteName = i18n("treasuremap_text_47")
	return favoriteName
end
function worldMapRedTreasureMap:playClickSound()
	SoraDPlaySound("worldmap", 5)
end
function worldMapRedTreasureMap:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local playerID = self.playerID or 0
	local leagueID = self.leagueID or 0
	print("worldMapRedTreasureMap:getInstanceOp --", self.playerID, self.leagueID)
	if isSelfKindom then
		if playerID == selfPlayerID then
			allianceMgr = self.playerID
			self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, self.playerID)
			allianceMgr = self.playerID
			self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
			table.insert(buttonTypeArray, self.playerID)
			if self:canHasEmojiOperator(selfPlayerID) then
				allianceMgr = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif playerID <= 0 and self.createUid == selfPlayerID then
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_treasuremap_wajue
			table.insert(buttonTypeArray, selfPlayerID)
		elseif (selfLeagueID ~= leagueID or selfLeagueID <= 0) and self.defendFailedTimes < 3 and not worldMapDefine.isInKingdomBattle() then
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, selfPlayerID)
			local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
			if 1 < towerLv and 0 < playerID then
				allianceMgr = worldMapDefine.worldMapTipButtonType_gongJi
				worldMapDefine.worldMapTipButtonType_gongJi.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_gongJi)
			end
		end
	end
	allianceMgr = buttonTypeArray
	buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, buttonTypeArray)
	return buttonTypeArray
end
return worldMapRedTreasureMap
