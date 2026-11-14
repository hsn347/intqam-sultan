local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local alliancePetRead = include("alliancePetRead")
local worldMapAllianceBuild = class("worldMapAllianceBuild", function()
	local target = include("worldMapInstance").new("worldMapAllianceBuild")
	return target
end)
function worldMapAllianceBuild:ctor()
	self.modelImage = display.newSpriteNoChild("#Map_build_unionpalace.png")
	self.modelImage:setPosition(cc.p(0, 30))
	self:addChild(self.modelImage, -1)
	self.battleState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.modelState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.playerID = 0
	self.playerName = nil
	self.buildClassID = nil
	self.buildID = nil
	self.leagueID = 0
	self.leagueName = nil
	self.leagueAbbrName = ""
	self.leagueFlag = 1
	self.size = 1
	self.radioation = 1
	self.warStatus = gKingdomWarStatusType.close
	self.beastData, _ENV, self.kingStatus = gKingStatus.none, gKingStatus.none, gKingStatus.none
	self.image_LeagueFlag = display.newSpriteNoChild(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 10))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_league_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 60))
	self.image_league_name:setVisible(false)
	self.image_league_name:addTo(self, 1)
	self.image_league_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = "leagueName"
	self.image_league_name.size = 20
	self.text_league_Name = SoraDCreateLabelNoChild(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 60))
	self.text_league_Name:setVisible(false)
	self.text_league_Name:addTo(self, 1)
	self.text_league_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_player_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabelNoChild(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapAllianceBuild:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_FORBID_MAP_OBJ_WAR", handler(self, self.updateForbidMapObjWarSatusData))
end
function worldMapAllianceBuild:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapAllianceBuild:setBuildSize(size, radioation)
	self.size = size
	self.radioation = radioation
end
function worldMapAllianceBuild:initInstanceData(buildClassID, buildData)
	self.buildClassID = buildClassID
	local buildInfo = worldMapDefine.getAllianceBuildInfo(self.buildClassID)
	if buildInfo then
		self:setBuildSize(buildInfo.size, buildInfo.radioation)
		self.modelImage:setSpriteFrame(buildInfo.image)
	end
	self:updateData(buildData)
end
function worldMapAllianceBuild:getBuildClassID()
	return self.buildClassID
end
function worldMapAllianceBuild:getBuildID()
	return self.buildID
end
function worldMapAllianceBuild:updateData(data)
	if not data then
		return
	end
	dump(data, "worldMapAllianceBuild")
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
	if data.leagueAbbrName then
		self.leagueAbbrName = data.leagueAbbrName
	end
	if data.leagueFlag then
		self.leagueFlag = data.leagueFlag
	end
	if data.status and data.status == gMapObjStateTypeDef.gMapObjStateTypeFree and self.battleState and self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
		_ENV = gMapObjStateTypeDef.gMapObjStateTypeWorking
		_UPVALUE1_, gMapObjStateTypeDef.gMapObjStateTypeWorking.msg = "worldMapAllianceBuild", "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		gMapObjStateTypeDef.gMapObjStateTypeWorking.relatedTilePoints, ("worldMapAllianceBuild")[1] = "worldMapAllianceBuild", self.tilePoint
		SoraDSendMessage(gMapObjStateTypeDef.gMapObjStateTypeWorking)
	end
	if data.status then
		self.battleState = data.status
	end
	if data.modelState then
		self.modelState = data.modelState
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.kingStatus then
		self.kingStatus = data.kingStatus
	end
	if data.id then
		self.buildID = data.id
	end
	if data.beast then
		dump(data.beast, "data.beast")
		self.beastData = data.beast
	end
	if data.colorId then
		self.colorId = data.colorId
	end
	self:updatePlayerInfo()
	self:updateIsInConstruction()
	self:updateBattleState()
	self:updateProcessBar(data)
	self:updateForbidMapObjWarSatusData()
	if self.buildClassID == gMapAllianceBuildType.subTypeAllianceAltar then
		self:updateBeastInfo()
	end
end
function worldMapAllianceBuild:updateBeastInfo(...)
	if not self.beastData or not next(self.beastData) then
		return
	end
	local state = self.beastData.status
	if gAlliancePetState.CALL == state then
		if self.petSingle then
			self.petSingle:setVisible(false)
		end
	else
		local petType = self.beastData.type
		if not self.petSingle then
			self.petSingle = self:createPetSingle(petType)
		else
			self.petSingle:setVisible(true)
			self.petSingle.initData(petType)
		end
	end
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	if selfLeagueID == self.leagueID then
		self:closeAlliancePetEffect()
		if gAlliancePetState.TRIAL == state then
			if not self.progressBarPet then
				self:createProgressBarPet()
			end
			self.progressBarPet:setPercent(self.beastData.leftLife or 100)
			self:setTrialEffectDown()
			self:setTrialEffectUp()
		else
			if gAlliancePetState.BLESS == state then
				self:setBlessEffectDown()
				self:setBlessEffectUp()
			end
			if self.progressBarPet then
				self.progressBarPet:setVisible(false)
			end
		end
	end
end
function worldMapAllianceBuild:createProgressBarPet()
	local progressBarPet = SoraDCreatePanel("worldMapBossProgressBar")
	progressBarPet:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	progressBarPet:setAnchorPoint(cc.p(0.5, 0.5))
	progressBarPet:addTo(self, 1)
	progressBarPet:setVisible(false)
	self.progressBarPet = progressBarPet
end
function worldMapAllianceBuild:createPetSingle(petType)
	local petSingle = display.newSprite("#ma_ws_01.png")
	self:addChild(petSingle, 0)
	petSingle:setGroupID(worldMapDefine.GROU_ID.group_alliance_pet)
	function petSingle.initData(_petType)
		local offsetData = alliancePetRead.worldMapPetOffset[_petType]
		if offsetData and offsetData.position then
			petSingle:setPosition(offsetData.position)
			petSingle:setScale(offsetData.scale)
		end
		local imgName = alliancePetRead.getWorldMapModel(_petType)
		local frames = display.newFrames(imgName .. "_ws_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.15)
		petSingle:stopAllActions()
		petSingle:playAnimationForever(animation)
	end
	petSingle.initData(petType)
	return petSingle
end
function worldMapAllianceBuild:setBlessEffectDown(...)
	if self.effectNode_down then
		self.effectNode_down:removeFromParent()
		self.effectNode_down = nil
	end
	local effectNode = SoraDCreatAnimation("jitan_down")
	self.effectNode_down = effectNode
	effectNode:setPosition(cc.p(14, -13))
	effectNode:setScale(1.3)
	self:addChild(effectNode, -1)
	effectNode:setGroupID(worldMapDefine.GROU_ID.group_alliance_pet)
	effectNode:setGroupAuto(true)
	for i = 1, 4 do
		local name = string.format("Sprite_%d", i)
		local sp = SoraDGetChildByName(effectNode, name)
		if sp then
			if sp:isOpacityModifyRGB() then
				sp:setBlendFunc(gl.ONE, gl.ONE)
			else
				sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
	end
end
function worldMapAllianceBuild:setBlessEffectUp(...)
	if self.effectNode_up then
		self.effectNode_up:removeFromParent()
		self.effectNode_up = nil
	end
	local effectNode = SoraDCreatAnimation("jitan_up")
	self.effectNode_up = effectNode
	effectNode:setPosition(cc.p(14, -13))
	effectNode:setScale(1.3)
	self:addChild(effectNode, 0)
	effectNode:setGroupID(worldMapDefine.GROU_ID.group_alliance_pet)
	effectNode:setGroupAuto(true)
	for i = 1, 10 do
		local name = string.format("Sprite_%d", i)
		local sp = SoraDGetChildByName(effectNode, name)
		if sp then
			if sp:isOpacityModifyRGB() then
				sp:setBlendFunc(gl.ONE, gl.ONE)
			else
				sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
	end
end
function worldMapAllianceBuild:setTrialEffectDown(...)
	if self.effectNode_down then
		self.effectNode_down:removeFromParent()
		self.effectNode_down = nil
	end
	local effectNode = SoraDCreatAnimation("shilian_down")
	self.effectNode_down = effectNode
	effectNode:setPosition(cc.p(10, -10))
	effectNode:setScale(1.4)
	self:addChild(effectNode, -1)
	effectNode:setGroupID(worldMapDefine.GROU_ID.group_alliance_pet)
	effectNode:setGroupAuto(true)
	_UPVALUE1_ = effectNode
	effectNode[1] = "Sprite_3_0"
	for k, v in pairs(effectNode) do
		local sp = SoraDGetChildByName(effectNode, v)
		if sp then
			if sp:isOpacityModifyRGB() then
				sp:setBlendFunc(gl.ONE, gl.ONE)
			else
				sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
	end
end
function worldMapAllianceBuild:setTrialEffectUp(...)
	if self.effectNode_up then
		self.effectNode_up:removeFromParent()
		self.effectNode_up = nil
	end
	local effectNode = SoraDCreatAnimation("shilian_up")
	self.effectNode_up = effectNode
	effectNode:setPosition(cc.p(10, -10))
	effectNode:setScale(1.4)
	effectNode:setZ(-0.1)
	self:addChild(effectNode, 0)
	effectNode:setGroupID(worldMapDefine.GROU_ID.group_alliance_pet)
	effectNode:setGroupAuto(true)
	_UPVALUE1_ = effectNode
	effectNode[1] = "Sprite_3"
	for k, v in pairs(effectNode) do
		local sp = SoraDGetChildByName(effectNode, v)
		if sp then
			if sp:isOpacityModifyRGB() then
				sp:setBlendFunc(gl.ONE, gl.ONE)
			else
				sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
			end
		end
	end
end
function worldMapAllianceBuild:closeAlliancePetEffect(...)
	if self.effectNode_up then
		self.effectNode_up:removeFromParent()
		self.effectNode_up = nil
	end
	if self.effectNode_down then
		self.effectNode_down:removeFromParent()
		self.effectNode_down = nil
	end
end
function worldMapAllianceBuild:getTerritoryColor(...)
	if self.colorId then
		return allianceDesRead.getTerritoryColor(self.colorId)
	end
end
function worldMapAllianceBuild:updatePlayerInfo()
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	if self.leagueID and 0 < self.leagueID then
		local nameColor = cc.c3b(0, 200, 200)
		if self.leagueID == selfLeagueID then
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
			if self.colorId and 0 < self.colorId then
				self.rolygonColor = self:getTerritoryColor()
			else
				self.rolygonColor = nameColor
			end
		else
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID) or gMapAllianceRelationType.NORMAL
			local selfSourceID = lordInfoCtrl:getMapSourceKid()
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			local isMatchKingdom = conquestWarCtrl:isMatchKingdom(selfSourceID, self.kingdomID)
			if isMatchKingdom then
				allianceRelationType = gMapAllianceRelationType.ENEMY
			end
			nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			if (allianceRelationType == gMapAllianceRelationType.SELF or allianceRelationType == gMapAllianceRelationType.NORMAL) and self.colorId and 0 < self.colorId then
				self.rolygonColor = self:getTerritoryColor()
			else
				self.rolygonColor = nameColor
			end
		end
		self.text_league_Name:setColor(nameColor)
		self.text_player_Name:setColor(nameColor)
		self.image_league_name:setVisible(true)
		self.text_league_Name:setVisible(true)
		if self.buildClassID == gMapAllianceBuildType.subTypeAllianceFlag then
			self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 45))
			self.image_LeagueFlag:setVisible(true)
			self.image_LeagueFlag:setScale(0.5)
			self.modelImage:setScale(1.5)
			self.text_league_Name:setString(self.leagueAbbrName)
			if self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
				allianceMgr = cc.p(self.centerPoint.x, self.centerPoint.y + 45)
				cc.p(self.centerPoint.x, self.centerPoint.y + 45).name = self.leagueAbbrName
				self.text_league_Name:setString(i18n("alliance_stronghold_text_118", cc.p(self.centerPoint.x, self.centerPoint.y + 45)))
			end
		else
			local buildName = allianceDesRead.getBuildName(self.buildClassID)
			self.text_league_Name:setString("(" .. self.leagueAbbrName .. ")" .. buildName)
			if self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
				allianceMgr = ")"
				;(")").abbr = self.leagueAbbrName
				;(")").name = buildName
				self.text_league_Name:setString(i18n("alliance_stronghold_text_119", ")"))
			end
		end
		if allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if self.buildClassID == gMapAllianceBuildType.subTypeAllianceAltar then
			self:updateBeastInfo()
		end
	end
end
function worldMapAllianceBuild:updateBattleState()
	self:updateFireEffect(self.battleState)
end
function worldMapAllianceBuild:createProcessBar()
	local progressBar = SoraDCreatePanel("worldMapAllianceBuildProgressBar")
	progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 85))
	progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	progressBar:addTo(self, 1)
	self.progressBar = progressBar
end
function worldMapAllianceBuild:updateProcessBar(buildingData)
	if buildingData.wall then
		local hurtStatus = self.battleState == gMapObjStateTypeDef.gMapObjStateTypeHurtDie
		if not self.progressBar then
			self:createProcessBar()
		end
		self.progressBar:initData(buildingData, hurtStatus)
	end
end
function worldMapAllianceBuild:updateForbidMapObjWarSatusData()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local beginTime = kingdomMapCtrl:getForbidMapObjWarBeginTime(gMapObjTypeDef.mapObjTypeAllianceBuild)
	self:stopActionByTag(999)
	if 0 < beginTime then
		_UPVALUE1_ = self
		self[1] = cca.delay(beginTime)
		self[2] = cca.callFunc(function()
			self:updateForbidMapObjWarSatusData()
		end)
		self[3] = cca.callFunc(function()
			self:updateForbidMapObjWarSatusData()
		end)
		local seq = cca.seq(self)
		seq:setTag(999)
		self:runAction(seq)
	else
		local leftTime = kingdomMapCtrl:getForbidMapObjWarLeftTime(gMapObjTypeDef.mapObjTypeAllianceBuild)
		self:updateStopBattleTime(leftTime)
	end
end
function worldMapAllianceBuild:updateStopBattleTime(lastTime)
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	if self.leagueID == selfLeagueID then
		lastTime = 0
	end
	if 0 < lastTime then
		if not self.text_StateTime then
			self.image_pt_bg = display.newSprite("#frame_map_07.png")
			self.image_pt_bg:setAnchorPoint(cc.p(0.5, 0.5))
			self.image_pt_bg:setContentSize(cc.size(207, 120))
			self.image_pt_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 0))
			self.image_pt_bg:addTo(self, 2)
			self.image_pt_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
			allianceMgr = self.image_pt_bg
			self.image_pt_bg.UILabelType = 2
			self.image_pt_bg.text = i18n("Battlefield_queue_text_010")
			self.image_pt_bg.size = 20
			self.text_StateDesc = cc.ui.UILabel.new(self.image_pt_bg)
			self.text_StateDesc:setAnchorPoint(cc.p(0.5, 0.5))
			self.text_StateDesc:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 7))
			self.text_StateDesc:addTo(self, 3)
			self.text_StateDesc:setGroupID(worldMapDefine.GROU_ID.group_level_build)
			allianceMgr = self.text_StateDesc
			self.text_StateDesc.UILabelType = 2
			self.text_StateDesc.text = "00:00:00"
			self.text_StateDesc.size = 20
			self.text_StateTime = cc.ui.UILabel.new(self.text_StateDesc)
			self.text_StateTime:setAnchorPoint(cc.p(0.5, 0.5))
			self.text_StateTime:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 16))
			self.text_StateTime:addTo(self, 3)
			self.text_StateTime:setGroupID(worldMapDefine.GROU_ID.group_level_build)
			self.text_StateTime = SoraDCreateTimerLabel(self, self.text_StateTime)
		end
		self.text_StateTime:removeTime()
		self.text_StateTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_4530", nil)
		end)
		self.text_StateTime:setTimeEndListener(handler(self, self.updateForbidMapObjWarSatusData))
		self.text_StateTime:beginTime(lastTime)
		self.text_StateTime:setVisible(true)
		self.image_pt_bg:setVisible(true)
		self.text_StateDesc:setVisible(true)
	end
	if lastTime <= 0 and self.text_StateTime then
		self.text_StateTime:removeTime()
		self.text_StateTime:setVisible(false)
		self.image_pt_bg:setVisible(false)
		self.text_StateDesc:setVisible(false)
	end
end
function worldMapAllianceBuild:getFavoriteName()
	local favoriteName = self.playerName
	if self.buildClassID then
		local allianceBuild = allianceDesRead.getBuildName(self.buildClassID)
		local allianceName = self.leagueAbbrName
		allianceDesRead = nil
		;(nil).abbr = allianceName
		;(nil).name = allianceBuild
		favoriteName = i18n("common_text_186", nil)
	end
	return favoriteName
end
function worldMapAllianceBuild:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapAllianceBuild:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = self:onShowWorldMapTip(onShowView)
	local tilesRolygon = include("worldMapTilesRolygon").new(self.size + 2 * self.radioation)
	tilesRolygon:setRolygonColor(self.rolygonColor)
	return selectShowPanel, true, tilesRolygon
end
function worldMapAllianceBuild:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnAid() or 0
	if isSelfKindom then
		if self.buildClassID == gMapAllianceBuildType.subTypeAllianceAltar then
			if selfLeagueID == self.leagueID then
				local alliancePetCtrl = gametop.playertop_:getModule("alliancePetCtrl")
				local state = alliancePetCtrl:getAlliancePetState()
				if state == gAlliancePetState.CALL then
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_alliancepet_1
					table.insert(buttonTypeArray, nil)
				elseif state == gAlliancePetState.DONATE then
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_alliancepet_2
					table.insert(buttonTypeArray, nil)
				elseif state == gAlliancePetState.TRIAL then
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_alliancepet_3
					table.insert(buttonTypeArray, nil)
				elseif state == gAlliancePetState.BLESS then
					allianceMgr = nil
					;(nil).buttonType = worldMapDefine.worldMapTipButtonType_alliancepet_4
					table.insert(buttonTypeArray, nil)
				end
				allianceMgr = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_chakanxiangqing
				table.insert(buttonTypeArray, nil)
			else
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
				table.insert(buttonTypeArray, table.insert)
			end
		elseif selfLeagueID == self.leagueID then
			if self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking then
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_jianzao
				table.insert(buttonTypeArray, table.insert)
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_chakanzhujun
				table.insert(buttonTypeArray, table.insert)
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_chakanxiangqing
				table.insert(buttonTypeArray, table.insert)
			else
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_xiefang
				table.insert(buttonTypeArray, table.insert)
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_chakanzhujun
				table.insert(buttonTypeArray, table.insert)
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_chakanxiangqing
				table.insert(buttonTypeArray, table.insert)
			end
			if self:checkHasArmy() then
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, table.insert)
			end
		else
			allianceMgr = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, table.insert)
			local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
			if haveHall and 0 < selfLeagueID then
				allianceMgr = 0
				;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
				table.insert(buttonTypeArray, 0)
			end
			allianceMgr = 0
			;(0).buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
			table.insert(buttonTypeArray, 0)
		end
	else
	end
	return buttonTypeArray
end
function worldMapAllianceBuild:updateIsInConstruction()
	local isInConstruction = self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking
	if isInConstruction and self.buildingSp == nil then
		local sprite = SoraDCreatAnimation("chuizigx")
		sprite:setScale(1.0)
		sprite:addTo(self, 2)
		if self.buildClassID == gMapAllianceBuildType.subTypeAllianceFlag then
			sprite:setPosition(0, 120)
		else
			sprite:setPosition(0, 160)
		end
		self.buildingSp = sprite
	elseif self.buildingSp ~= nil then
		self.buildingSp:setVisible(isInConstruction)
	end
end
return worldMapAllianceBuild
