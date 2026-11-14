local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapTrialBattery = class("worldMapTrialBattery", function(target)
	local target = include("worldMapInstance").new("worldMapBattery")
	return target
end)
function worldMapTrialBattery:ctor()
	self.bulletZoder = math.floor(cc.pGetDistance(cc.p(1200, 1200), cc.p(0, 0))) + 5
	self:_initUI()
	self:_initData()
end
function worldMapTrialBattery:_initData()
	self.batteryState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.modelState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.allHurtNum = 100
	self.hurtCount = 4
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warStatus = gKingdomWarStatusType.close
end
function worldMapTrialBattery:_initUI()
	self.baseImage = display.newSprite("#paotai_base.png")
	self.baseImage:setPosition(cc.p(0, 30))
	self:addChild(self.baseImage, -1)
	self.modelImage = display.newSprite("#paotai_dj_n_01.png")
	self.modelImage:setPosition(cc.p(0, 80))
	self:addChild(self.modelImage, -1)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
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
function worldMapTrialBattery:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_SHOW_BUILD_TIPS", handler(self, self.onShowBuildTips))
end
function worldMapTrialBattery:addCacheBefore()
	self.modelImage:stopAllActions()
	self.image_Protect:setVisible(false)
end
function worldMapTrialBattery:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
	self.baseImage:setGroupID(groupID)
end
function worldMapTrialBattery:initInstanceData(batteryData)
	self.showTilePoint = self:getTilePoint()
	local devilValleyltCtrl = include("devilValleyltCtrl")
	local cityCfg = devilValleyltCtrl.getWarBuildingById(801)
	_ENV = 801
	;(801).x = cityCfg.x + 2
	self.targetCityPoint, (801).y = 801, cityCfg.y + 2
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		self.showTilePoint = worldMapView:getPointWithTile(self.showTilePoint)
		self.worldCenterPoint = worldMapView:getPointWithTile(self.targetCityPoint)
	end
	self:updateData(batteryData)
end
function worldMapTrialBattery:updateData(data)
	dump(data, "updateBatteryData", 5)
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
	if data.sourceKid then
		self.sourceID = data.sourceKid
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
	if data.isNpc ~= nil then
		self.isNpc = data.isNpc
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.isIn ~= nil then
		self.isIn = data.isIn
	end
	if self.isNpc == true then
		self.leagueID = 0
		self.leagueName = ""
		self.leagueAbbrName = ""
		self.leagueFlag = 1
		self.isIn = false
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateBatteryState()
	self:updateModelState()
end
function worldMapTrialBattery:updatePlayerInfo()
	print("updatePlayerInfo", self.leagueID, self.isNpc)
	if self.isNpc then
		self.image_LeagueFlag:setVisible(false)
		self.image_league_name:setVisible(false)
		self.text_league_Name:setVisible(false)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		self.text_player_Name:setColor(cc.c3b(200, 0, 0))
		self.text_player_Name:setString(i18n("devilvalley_text_20"))
	elseif self.leagueID and self.leagueID > 0 then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local nameColor = worldMapDefine.getLeagueManorLineColor(true)
		self.text_league_Name:setColor(nameColor)
		self.text_player_Name:setColor(nameColor)
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
			_ENV = allianceDesRead.getFlagIcon(self.leagueFlag)
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
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		self.text_player_Name:setString(i18n("devilvalley_text_21"))
		self.text_player_Name:setColor(cc.c3b(200, 200, 200))
	end
end
function worldMapTrialBattery:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapTrialBattery:updateBatteryState()
	self:updateFireEffect(self.batteryState)
end
function worldMapTrialBattery:updateModelState()
	if self.modelState == gMapObjStateTypeDef.gMapObjStateTypeFree then
	elseif self.modelState == gMapObjStateTypeDef.gMapObjStateTypeFighting then
		self:doFightingAnimation()
	elseif self.modelState == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
	end
end
function worldMapTrialBattery:doFreeAnimation()
	self.modelImage:stopAllActions()
	local rotation, fightingImgNameAngle, isFlipX = worldMapFunction.getBatteryImgAngel(self.showTilePoint, self.worldCenterPoint)
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(3.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local frames = display.newFrames("paotai_dj_" .. fightingImgNameAngle .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.25)
		self.modelImage:playAnimationOnce(animation, false, handler(self, self.doFreeAnimation), 0.0)
	end)
	local action = transition.sequence(actionsArray)
	self.modelImage:runAction(action)
	self.modelImage:setFlippedX(isFlipX)
end
function worldMapTrialBattery:updateShot(params)
	self.allHurtNum = params.damage
	self.hurtCount = 4
	self:doFightingAnimation()
end
function worldMapTrialBattery:doFightingAnimation()
	if self.hurtCount <= 0 then
		self:doFreeAnimation()
	else
		self:doFightingAnimation_imp()
	end
end
function worldMapTrialBattery:doFightingAnimation_imp()
	self.modelImage:stopAllActions()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local radius = math.random(-100, 100)
	local angle = math.random(-180, 180)
	local radian = math.angle2radian(angle)
	local rotation, fightingImgNameAngle, isFlipX = worldMapFunction.getBatteryImgAngel(self.showTilePoint, self.worldCenterPoint)
	local changeX = 0
	local changeY = 0
	local paojiX = 0
	local paojiY = 0
	local isLeft = false
	if -45 <= rotation and rotation < 45 then
		changeX = 100
		changeY = 75
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
		paojiY = -10
		isLeft = true
	end
	local beginPointX = self.showTilePoint.x + changeX
	local beginPointY = self.showTilePoint.y + changeY
	local endPointX = self.worldCenterPoint.x + radius * math.cos(radian)
	local endPointY = self.worldCenterPoint.y + radius * math.sin(radian)
	local _ENV, actionsArray = radius * math.sin(radian), radius * math.sin(radian)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(1.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local frames = display.newFrames("paotai_gj_" .. fightingImgNameAngle .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.125)
		self.modelImage:playAnimationOnce(animation, false, handler(self, self.doFightingAnimation), 0.0)
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.5)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		local parNode = self:createPaojiEffect(fightingImgNameAngle, isLeft)
		parNode:setPosition(cc.p(beginPointX + paojiX, beginPointY + paojiY))
		parNode:addTo(self:getParent(), self:getLocalZOrder())
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
		end
		math.randomseed(tostring(os.time()):reverse():sub(1, 6))
		local hurtNum = 0
		if 1 < self.hurtCount then
			hurtNum = math.random(1, self.allHurtNum - self.hurtCount + 1)
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
	self.modelImage:setFlippedX(isFlipX)
end
function worldMapTrialBattery:doHurtDieAnimation()
end
function worldMapTrialBattery:createPaojiEffect(fightingImgNameAngle, isLeft)
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
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_paoji_01.plist"
	;(nil).x = 15 * moveScale
	_ENV, (nil).pos, (nil).y = nil, nil, 0
	;(nil).x = moveScale
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1
	_ENV, (nil).plist = nil, "et_paoji_02.plist"
	;(nil).x = scale
	;(nil).scale, (nil).y = nil, scaleY
	_ENV, (nil).rotate = nil, rotate
	;(nil).x = 10 * moveScale
	_ENV, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, 0
	_ENV, (nil).plist = nil, "et_paoji_03.plist"
	;(nil).x = 10 + movePosX
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 0
	local param
	return SoraDCreateEffectNode(param)
end
function worldMapTrialBattery:createEffectFireStone()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_paoshidan_display_01.plist"
	;(nil).x = 0.45
	;(nil).scale, (nil).y = nil, 0.49
	;(nil).rotate = 90
	_ENV, (nil)[1], (nil).zorder = nil, nil, 6
	_ENV, (nil).plist = nil, "et_paoshidan_display_02.plist"
	;(nil).x = 0.34
	;(nil).scale, (nil).y = nil, 0.4
	;(nil).rotate = 178.36
	_ENV, (nil).zorder = nil, 5
	;(nil).x = -3.04
	_ENV, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, -3.04
	;(nil).plist = "et_paoshidan_display_03.plist"
	;(nil).scale = 0.71
	;(nil).rotate = 90
	_ENV, (nil).zorder = nil, 4
	;(nil).x = -2.43
	_ENV, (nil)[3], (nil).pos, (nil).y = nil, nil, nil, -5.13
	;(nil).plist = "et_paoshidan_display_04.plist"
	;(nil).scale = 1
	;(nil).rotate = 90
	_ENV, (nil).zorder = nil, 3
	;(nil).x = -2.4
	_ENV, (nil)[4], (nil).pos, (nil).y = nil, nil, nil, -2.4
	;(nil).plist = "et_paoshidan_display_05.plist"
	;(nil).scale = 1
	;(nil).rotate = 90
	_ENV, (nil).zorder = nil, 2
	;(nil).x = -2
	_ENV, (nil)[5], (nil).pos, (nil).y = nil, nil, nil, -2
	;(nil).plist = "et_paoshidan_display_06.plist"
	;(nil).scale = 0.51
	;(nil).rotate = 90
	;(nil)[6], (nil).zorder = nil, 1
	local param
	return SoraDCreateEffectNode(param)
end
function worldMapTrialBattery:playClickSound()
	SoraDPlaySound("worldmap", 17)
end
function worldMapTrialBattery:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	print("点击炮台")
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	print("selfLeagueID", selfLeagueID, self.leagueID, self.isNpc)
	if isSelfKindom then
		if self.warStatus == gKingdomWarStatusType.inWar then
			if 0 < selfLeagueID then
				if self.leagueID == 0 then
					if self.isNpc then
						_ENV = selfLeagueID
						selfLeagueID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
						table.insert(buttonTypeArray, selfLeagueID)
						_ENV = selfLeagueID
						selfLeagueID.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
						table.insert(buttonTypeArray, selfLeagueID)
					else
						_ENV = selfLeagueID
						selfLeagueID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
						table.insert(buttonTypeArray, selfLeagueID)
					end
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
				end
			else
				_ENV = buttonTypeArray
				buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
				table.insert(buttonTypeArray, buttonTypeArray)
			end
		else
			_ENV = buttonTypeArray
			buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, buttonTypeArray)
		end
	else
	end
	return buttonTypeArray
end
function worldMapTrialBattery:getSiteClassID()
	return _G.gMapNewTrialBuildType.subMapTypeDVWBattery
end
return worldMapTrialBattery
