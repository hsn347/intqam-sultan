local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local palaceInfoRead = include("palaceInfoRead")
local worldMapBattery = class("worldMapBattery", function()
	local target = include("worldMapInstance").new("worldMapBattery")
	return target
end)
local gKWBattery = _G.gKWBattery
function worldMapBattery:ctor()
	self.bulletZoder = math.floor(cc.pGetDistance(cc.p(1200, 1200), cc.p(0, 0))) + 5
	self:_initUI()
	self:_initData()
end
function worldMapBattery:_initData()
	self.batteryState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.modelState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.allHurtNum = 100
	self.hurtCount = 4
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.rfKid = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warStatus = gKingdomWarStatusType.close
	self.kingStatus = gKingStatus.none
end
function worldMapBattery:_initUI()
	self.nodeMode = display.newNode()
	self:addChild(self.nodeMode, -1)
	self.baseImage = display.newSprite("#paotai_base.png")
	self.nodeMode:addChild(self.baseImage, -1)
	self.modelImage = display.newSprite("#paotai_dj_n_01.png")
	self.nodeMode:addChild(self.modelImage, -1)
	self.modelImageMask = display.newSprite("#map_battery_mask_14.png")
	self.modelImageMask:setPosition(cc.p(65, 55))
	self.nodeMode:addChild(self.modelImageMask, -1)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(1.0)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 80))
	self.image_Protect:addTo(self, 1)
	self.image_LeagueFlag = display.newSprite(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 147, self.centerPoint.y - 10))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(worldMapDefine.GROU_ID.group_flag)
	self.image_league_name = display.newSprite("#frame_map_07.png")
	self.image_league_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_league_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	self.image_league_name:setVisible(false)
	self.image_league_name:addTo(self, 1)
	self.image_league_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_league_name
	self.image_league_name.UILabelType = 2
	self.image_league_name.text = "leagueName"
	self.image_league_name.size = 20
	self.text_league_Name = SoraDCreateLabel(self.image_league_name)
	self.text_league_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_league_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 35))
	self.text_league_Name:setVisible(false)
	self.text_league_Name:addTo(self, 1)
	self.text_league_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_player_name = display.newSprite("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = "playerName"
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabel(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapBattery:addCacheBefore()
	self.modelImage:stopAllActions()
	self.modelImage:setFlippedX(false)
	self.image_Protect:setVisible(false)
end
function worldMapBattery:setBatchNodeGroupID(groupID)
	self.nodeMode:setGroupID(groupID)
	self.nodeMode:setGroupAuto(true)
end
function worldMapBattery:getSiteClassID()
	return self.siteClassID
end
function worldMapBattery:initInstanceData(siteClassID, batteryData, objId)
	self.siteClassID = objId
	self.showTilePoint = self:getTilePoint()
	self.worldCenterPoint = cc.p(600, 600)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		self.showTilePoint = worldMapView:getPointWithTile(self.showTilePoint)
		self.worldCenterPoint = worldMapView:getPointWithTile(self.worldCenterPoint)
	end
	local img = palaceInfoRead.getBatteryImg(self.siteClassID)
	if img then
		self.baseImage:setSpriteFrame(img)
		if self.siteClassID == gKWBattery.NORTH then
			self.nodeMode:setPosition(cc.p(-50, 50))
			self.modelImage:setVisible(false)
			self.modelImageMask:setVisible(false)
		elseif self.siteClassID == gKWBattery.SOUTH then
			self.nodeMode:setPosition(cc.p(-61, 98))
			self.modelImage:setVisible(false)
			self.modelImageMask:setVisible(false)
		elseif self.siteClassID == gKWBattery.EAST then
			self.nodeMode:setPosition(cc.p(-67, 23))
			self.modelImage:setVisible(true)
			self.modelImage:setSpriteFrame("fytp_dj_w_001.png")
			self.modelImage:setPosition(cc.p(50, 86))
			self.modelImage:setFlippedX(true)
			self.modelImageMask:setVisible(true)
		elseif self.siteClassID == gKWBattery.WEST then
			self.nodeMode:setPosition(cc.p(-59, 12))
			self.modelImage:setVisible(true)
			self.modelImage:setSpriteFrame("fytn_dj_w_001.png")
			self.modelImage:setPosition(cc.p(60, 100))
			self.modelImageMask:setVisible(false)
		end
	end
	self:updateData(batteryData)
end
function worldMapBattery:updateData(data)
	if not data then
		return
	end
	dump(data, "orldMapBattery:updateDat")
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.rfKid then
		self.rfKid = data.rfKid
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
	if data.status then
		self.batteryState = data.status
	end
	if data.modelState then
		self.modelState = data.modelState
	end
	if data.damage then
		self.allHurtNum = data.damage
		self.hurtCount = 4
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.kingStatus then
		self.kingStatus = data.kingStatus
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateBatteryState()
	self:updateModelState()
end
function worldMapBattery:updatePlayerInfo()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	if self.leagueID and self.leagueID > 0 then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local selfSourceID = lordInfoCtrl:getMapSourceKid()
		local leaderSourceID = gametop.playertop_:getKingdomID()
		if SoraDGetCtrl("conquestWarCtrl"):isHelper() then
			selfSourceID, _ = SoraDGetCtrl("conquestWarReinforcementsCtrl"):getAgreeKindom()
		end
		if 0 < self.rfKid then
			leaderSourceID = self.rfKid
		elseif 0 < self.sourceID then
			leaderSourceID = self.sourceID
		end
		if selfSourceID ~= leaderSourceID then
			self.text_league_Name:setColor(cc.c3b(200, 0, 0))
			self.text_player_Name:setColor(cc.c3b(200, 0, 0))
		elseif self.leagueID == selfLeagueID then
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
		local textName = self.playerName
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = self.playerName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if 0 < self.sourceID and selfSourceID ~= self.sourceID then
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
function worldMapBattery:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapBattery:updateBatteryState()
	self:updateFireEffect(self.batteryState)
end
function worldMapBattery:updateModelState()
	if self.modelState == gMapObjStateTypeDef.gMapObjStateTypeFighting and (self.siteClassID == gKWBattery.WEST or self.siteClassID == gKWBattery.EAST) then
		self:doFightingAnimation()
	end
end
function worldMapBattery:getAnimationKey()
	if self.siteClassID == gKWBattery.EAST then
		return "fytp"
	elseif self.siteClassID == gKWBattery.WEST then
		return "fytn"
	end
	return "paotai"
end
function worldMapBattery:doFreeAnimation()
	self.modelImage:stopAllActions()
	local _ENV, actionsArray = self.modelImage.stopAllActions, self.modelImage.stopAllActions
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(3.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local key = self:getAnimationKey()
		local frames = display.newFrames(key .. "_dj_w_%.3d.png", 1, 24)
		local animation = display.newAnimation(frames, 0.1)
		self.modelImage:playAnimationOnce(animation, false, handler(self, self.doFreeAnimation), 0.0)
	end)
	local action = transition.sequence(actionsArray)
	self.modelImage:runAction(action)
end
function worldMapBattery:updateShot(params)
	self.allHurtNum = params.damage
	self.hurtCount = 4
	if self.siteClassID == gKWBattery.WEST or self.siteClassID == gKWBattery.EAST then
		self:doFightingAnimation()
	end
end
function worldMapBattery:doFightingAnimation()
	if self.hurtCount <= 0 then
		self:doFreeAnimation()
	else
		self:doFightingAnimation_imp()
	end
end
function worldMapBattery:doFightingAnimation_imp()
	self.modelImage:stopAllActions()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local radius = math.random(-100, 100)
	local angle = math.random(-180, 180)
	local radian = math.angle2radian(angle)
	local rotation, fightingImgNameAngle = worldMapFunction.getBatteryImgAngel(self.showTilePoint, self.worldCenterPoint)
	local changeX, changeY, paojiX, paojiY
	local isLeft = false
	if -45 <= rotation and rotation < 45 then
		changeX = 50
		changeY = 125
		paojiX = -25
		paojiY = -10
	elseif -135 <= rotation and rotation < -45 then
		changeX = 0
		changeY = 150
		paojiX = -10
		paojiY = -35
	elseif 45 <= rotation and rotation < 135 then
		changeX = 0
		changeY = -10
		paojiX = -10
		paojiY = 50
	else
		changeX = -100
		changeY = 75
		paojiX = 32
		paojiY = 0
		isLeft = true
	end
	local delayTime = 1.5
	if self.siteClassID == gKWBattery.WEST then
		delayTime = 1.8
	end
	local beginPointX = self.showTilePoint.x + changeX
	local beginPointY = self.showTilePoint.y + changeY
	local endPointX = self.worldCenterPoint.x + radius * math.cos(radian)
	local endPointY = self.worldCenterPoint.y + radius * math.sin(radian)
	local _ENV, actionsArray = radius * math.sin(radian), radius * math.sin(radian)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(1.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local key = self:getAnimationKey()
		local frames = display.newFrames(key .. "_gj_w_%.3d.png", 1, 24)
		local animation = display.newAnimation(frames, 0.1)
		self.modelImage:playAnimationOnce(animation, false, handler(self, self.doFightingAnimation), 0.0)
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(delayTime)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local parNode = self:createPaojiEffect(fightingImgNameAngle, isLeft, angle)
		if parNode then
			parNode:setPosition(cc.p(beginPointX + paojiX, beginPointY + paojiY))
			parNode:addTo(self:getParent(), self:getLocalZOrder())
		end
	end)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local endCallFunc = function(position, parent, ZOrder, hurtNum)
			_ENV, _ENV = nil, nil
			_ENV, (nil).plist = nil, "et_kaichang_explosion_01.plist"
			;(nil).x = 0
			_ENV, (nil).pos, (nil).y = nil, nil, 0
			;(nil).x = 1
			;(nil).scale, (nil).y = nil, 1
			;(nil).posType = cc.POSITION_TYPE_RELATIVE
			;(nil).rotate = 0
			_ENV, (nil)[1], (nil).zorder = nil, nil, 0
			_ENV, (nil).plist = cc.POSITION_TYPE_RELATIVE, "et_kaichang_explosion_02.plist"
			cc.POSITION_TYPE_RELATIVE.x = 0
			_ENV, (nil).pos, cc.POSITION_TYPE_RELATIVE.y = cc.POSITION_TYPE_RELATIVE, cc.POSITION_TYPE_RELATIVE, 0
			cc.POSITION_TYPE_RELATIVE.x = 1
			;(nil).scale, cc.POSITION_TYPE_RELATIVE.y = cc.POSITION_TYPE_RELATIVE, 1
			;(nil).posType = cc.POSITION_TYPE_RELATIVE
			;(nil).rotate = 0
			;(nil)[2], (nil).zorder = nil, 0
			local endEffectParam
			if endEffectParam then
				local endEffectNode = SoraDCreateEffectNode(endEffectParam)
				endEffectNode:setPosition(position)
				endEffectNode:addTo(parent, ZOrder)
				local _ENV, effectNodeActionsArray = endEffectNode.addTo, endEffectNode.addTo
				effectNodeActionsArray[#effectNodeActionsArray + 1] = cc.DelayTime:create(1.0)
				effectNodeActionsArray[#effectNodeActionsArray + 1] = cc.CallFunc:create(function()
					endEffectNode:removeFromParent()
				end)
				local endEffectAction = transition.sequence(effectNodeActionsArray)
				endEffectNode:runAction(endEffectAction)
			end
			_ENV = endEffectNode.runAction
			endEffectNode.runAction.num = hurtNum
			_ENV = endEffectNode.runAction
			endEffectNode.runAction.color = display.COLOR_RED
			endEffectNode.runAction.pos = position
			endEffectNode.runAction.zOrder = ZOrder
			SoraDCreateWaveLabel(i18n("common_text_1527", endEffectNode.runAction), parent, endEffectNode.runAction)
		end
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		local hurtNum = 0
		if 1 < self.hurtCount then
			hurtNum = math.random(0, self.allHurtNum)
		elseif self.hurtCount == 1 then
			hurtNum = self.allHurtNum
		end
		self.allHurtNum = self.allHurtNum - hurtNum
		self.hurtCount = self.hurtCount - 1
		local bulletSprite = self:createEffectFireStone()
		bulletSprite:setPosition(cc.p(beginPointX, beginPointY))
		bulletSprite:setScale(1.0)
		bulletSprite:addTo(self:getParent(), self.bulletZoder)
		local addParent = self:getParent()
		worldMapFunction.createThrowAction(bulletSprite, cc.p(beginPointX, beginPointY), cc.p(endPointX, endPointY), 0, 500, function()
			endCallFunc(cc.p(endPointX, endPointY), addParent, self.bulletZoder, hurtNum)
		end)
	end)
	local action = transition.sequence(actionsArray)
	self.modelImage:runAction(action)
end
function worldMapBattery:doHurtDieAnimation()
end
function worldMapBattery:createPaojiEffect(fightingImgNameAngle, isLeft, angle)
	if self.siteClassID ~= gKWBattery.EAST then
		return
	end
	local scale = 1
	local rotate = 0
	local moveScale = 1
	local movePosX = 0
	local scaleY = 1
	if fightingImgNameAngle == "w" then
		scale = 0.5
		if isLeft then
			rotate = 20
		else
			rotate = -20
			moveScale = -1
		end
	elseif fightingImgNameAngle == "n" then
		scaleY = 0.5
		movePosX = 15
		moveScale = 1
	elseif fightingImgNameAngle == "s" then
		moveScale = 0
		movePosX = 10
	end
	gKWBattery, gKWBattery = nil, nil
	;(nil).plist = "et_paoji_01.plist"
	gKWBattery, (nil).autocull = nil, false
	;(nil).x = 15 * moveScale
	gKWBattery, (nil).pos, (nil).y = nil, nil, 0
	;(nil).x = moveScale
	gKWBattery, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1
	;(nil).plist = "et_paoji_02.plist"
	gKWBattery, (nil).autocull = nil, false
	;(nil).x = scale
	;(nil).scale, (nil).y = nil, scaleY
	gKWBattery, (nil).rotate = nil, rotate
	;(nil).x = 10 * moveScale
	gKWBattery, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, 0
	;(nil).plist = "et_paoji_03.plist"
	gKWBattery, (nil).autocull = nil, false
	;(nil).x = 10 + movePosX
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 0
	local param
	return SoraDCreateEffectNode(param)
end
function worldMapBattery:createEffectFireStone()
	if self.siteClassID == gKWBattery.WEST then
		local bulletNode = display.newNode()
		for _ = 1, 10 do
			local bulletSprite = display.newSprite("#icon_battle_jian_4.png")
			local randomPointX = math.random(0, 10)
			local randomPointY = math.random(0, 30)
			local point1 = cc.p(randomPointX, randomPointY)
			bulletSprite:setPosition(point1)
			bulletSprite:setScale(1.0)
			bulletSprite:setRotation(10)
			bulletNode:addChild(bulletSprite, 1)
		end
		return bulletNode
	end
	gKWBattery, gKWBattery = 1, bulletNode
	gKWBattery, (1).plist = 10, "et_paoshidan_display_01.plist"
	;(10).x = 0.45
	;(1).scale, (10).y = 10, 0.49
	;(1).rotate = 90
	gKWBattery, display.newNode()[1], (1).zorder = 1, 1, 6
	gKWBattery, (1).plist = 10, "et_paoshidan_display_02.plist"
	;(10).x = 0.34
	;(1).scale, (10).y = 10, 0.4
	;(1).rotate = 178.36
	gKWBattery, (1).zorder = 10, 5
	;(10).x = -3.04
	gKWBattery, display.newNode()[2], (1).pos, (10).y = 1, 1, 10, -3.04
	;(1).plist = "et_paoshidan_display_03.plist"
	;(1).scale = 0.71
	;(1).rotate = 90
	gKWBattery, (1).zorder = 10, 4
	;(10).x = -2.43
	gKWBattery, display.newNode()[3], (1).pos, (10).y = 1, 1, 10, -5.13
	;(1).plist = "et_paoshidan_display_04.plist"
	;(1).scale = 1
	;(1).rotate = 90
	gKWBattery, (1).zorder = 10, 3
	;(10).x = -2.4
	gKWBattery, display.newNode()[4], (1).pos, (10).y = 1, 1, 10, -2.4
	;(1).plist = "et_paoshidan_display_05.plist"
	;(1).scale = 1
	;(1).rotate = 90
	gKWBattery, (1).zorder = 10, 2
	;(10).x = -2
	gKWBattery, display.newNode()[5], (1).pos, (10).y = 1, 1, 10, -2
	;(1).plist = "et_paoshidan_display_06.plist"
	;(1).scale = 0.51
	;(1).rotate = 90
	display.newNode()[6], (1).zorder = 1, 1
	local param = display.newNode()
	return SoraDCreateEffectNode(param)
end
function worldMapBattery:playClickSound()
	SoraDPlaySound("worldmap", 17)
end
function worldMapBattery:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	print("点击炮台")
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom and self.warStatus == gKingdomWarStatusType.inWar and 0 < selfLeagueID then
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
			if self:checkHasArmy() then
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, buttonTypeArray)
			end
			if self:canHasEmojiOperator() then
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, buttonTypeArray)
			end
			_ENV = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
			table.insert(buttonTypeArray, buttonTypeArray)
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
			_ENV = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, buttonTypeArray)
			do
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
				else
				end
			end
		end
	else
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
return worldMapBattery
