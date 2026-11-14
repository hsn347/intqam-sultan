worldMapFunction, _ENV = nil, nil
function worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	return rotation, worldMapFunction.getSoliderImgAngelByRotation(rotation)
end
function worldMapFunction.getSoliderImgAngelByRotation(rotation)
	local moveAngle = 0
	if -22.5 <= rotation and rotation < 22.5 then
		moveAngle = 0
	elseif 22.5 <= rotation and rotation < 67.5 then
		moveAngle = 45
	elseif 67.5 <= rotation and rotation < 112.5 then
		moveAngle = 90
	elseif 112.5 <= rotation and rotation < 157.5 then
		moveAngle = 135
	elseif 157.5 <= rotation and rotation <= 180 then
		moveAngle = 180
	elseif -180 <= rotation and rotation <= -157.5 then
		moveAngle = -180
	elseif -157.5 <= rotation and rotation <= -112.5 then
		moveAngle = -135
	elseif -112.5 <= rotation and rotation <= -67.5 then
		moveAngle = -90
	elseif -67.5 <= rotation and rotation <= -22.5 then
		moveAngle = -45
	end
	local isFlipX = false
	local imgNameAngle = moveAngle
	if moveAngle == 0 then
		isFlipX = true
		imgNameAngle = "w"
	elseif moveAngle == -45 then
		isFlipX = true
		imgNameAngle = "wn"
	elseif moveAngle == -90 then
		isFlipX = true
		imgNameAngle = "n"
	elseif moveAngle == 45 then
		isFlipX = true
		imgNameAngle = "ws"
	elseif moveAngle == 90 then
		isFlipX = true
		imgNameAngle = "s"
	elseif moveAngle == 135 then
		isFlipX = false
		imgNameAngle = "ws"
	elseif moveAngle == -135 then
		isFlipX = false
		imgNameAngle = "wn"
	elseif moveAngle == 180 then
		isFlipX = false
		imgNameAngle = "w"
	elseif moveAngle == -180 then
		isFlipX = false
		imgNameAngle = "w"
	end
	return imgNameAngle, isFlipX, moveAngle
end
function worldMapFunction.getMonsterImgAngel(beginPoint, endPoint)
	local imgNameAngle = "wn"
	local isFlipX = false
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	if 0 <= rotation and rotation < 90 then
		imgNameAngle = "ws"
		isFlipX = true
	elseif 90 <= rotation and rotation < 180 then
		imgNameAngle = "ws"
		isFlipX = false
	elseif -180 <= rotation and rotation < -90 then
		imgNameAngle = "wn"
		isFlipX = false
	elseif -90 <= rotation and rotation < 0 then
		imgNameAngle = "wn"
		isFlipX = true
	end
	return rotation, imgNameAngle, isFlipX
end
function worldMapFunction.getMonsterImgAngelEx(faceType, showTilePoint, worldMapView)
	worldMapView = worldMapView or SoraDCurrentSceneShowView("worldMapView")
	local faceTilePoint
	if faceType == gMapNpcFaceTypeDef.monsterFaceType_LeftBottom then
		faceTilePoint = cc.p(showTilePoint.x, showTilePoint.y + 1)
	else
		faceTilePoint = cc.p(showTilePoint.x + 1, showTilePoint.y)
	end
	local beginPoint = worldMapView:getPointWithTile(showTilePoint)
	local endPoint = worldMapView:getPointWithTile(faceTilePoint)
	return worldMapFunction.getMonsterImgAngel(beginPoint, endPoint)
end
function worldMapFunction.getBatteryImgAngel(beginPoint, endPoint)
	local imgNameAngle = "w"
	local isFlipX = false
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	if -45 <= rotation and rotation < 45 then
		imgNameAngle = "w"
		isFlipX = true
	elseif -135 <= rotation and rotation < -45 then
		imgNameAngle = "n"
		isFlipX = false
	elseif 45 <= rotation and rotation < 135 then
		imgNameAngle = "s"
		isFlipX = false
	else
		imgNameAngle = "w"
		isFlipX = false
	end
	return rotation, imgNameAngle, isFlipX
end
function worldMapFunction.createThrowAction(target, beginPoint, endPoint, delayTime, speed, endCallFunc)
	if not target then
		return
	end
	target:setVisible(false)
	delayTime = delayTime or 0
	speed = speed or 300
	local distance = cc.pGetDistance(beginPoint, endPoint)
	local actionTime = math.abs(distance) / speed
	local rotationAngel = SoraDGetAngleByPos(beginPoint, endPoint)
	local changeAngel = 5 + 50 * math.abs(math.abs(rotationAngel) - 90) / 90
	local controlAngel = rotationAngel + changeAngel
	if 90 < rotationAngel or rotationAngel < -90 then
		controlAngel = rotationAngel - changeAngel
	end
	local radian = math.angle2radian(controlAngel)
	local pointX = beginPoint.x + 0.5 * distance * math.cos(radian)
	local pointY = beginPoint.y + 0.5 * distance * math.sin(radian)
	local controlPoint = cc.p(pointX, pointY)
	_UPVALUE3_ = pointX
	pointX[1] = beginPoint
	pointX[2] = controlPoint
	local pointX[3], bezier = endPoint, pointX
	local bezierTo = cc.BezierTo:create(actionTime, bezier)
	local startAngel = SoraDGetAngleByPos(beginPoint, controlPoint)
	local endAngel = SoraDGetAngleByPos(controlPoint, endPoint)
	target:setRotation(-(startAngel - 90))
	local rotateTo = cc.RotateTo:create(actionTime, -(endAngel - 90))
	local bezierAction = cc.Spawn:create(bezierTo, rotateTo)
	local _ENV, actionsArray = cc.Spawn, cc.Spawn
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(delayTime)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		target:setVisible(true)
	end)
	actionsArray[#actionsArray + 1] = cc.Spawn:create(bezierTo, rotateTo)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		if endCallFunc then
			endCallFunc()
		end
		target:removeFromParent()
	end)
	local action = transition.sequence(actionsArray)
	target:runAction(action)
end
function worldMapFunction.getMoveLineType(tipButtonType)
	local moveLineType
	if tipButtonType == worldMapDefine.worldMapTipButtonType_zhanLing then
		moveLineType = gMapMoveLineType.moveLineTypecapture
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_gongJi then
		moveLineType = gMapMoveLineType.moveLineTypeAttackLord
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_shibingYuabzhu then
		moveLineType = gMapMoveLineType.moveLineTypeArmyHelp
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_xiefang then
		moveLineType = gMapMoveLineType.moveLineTypeArmyHelp
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu then
		moveLineType = gMapMoveLineType.moveLineTypeResourceHelp
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_zhenCha then
		moveLineType = gMapMoveLineType.moveLineTypeScout
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_tanXian then
		moveLineType = gMapMoveLineType.moveLineTypeRelicsExplore
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_xuanZhan then
		moveLineType = gMapMoveLineType.moveLineTypeMass
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu then
		moveLineType = gMapMoveLineType.moveLineTypeMass
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_jianzao then
		moveLineType = gMapMoveLineType.moveLineTypeSuperRes
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_caiji then
		moveLineType = gMapMoveLineType.moveLineTypeSuperRes
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_yayun then
		moveLineType = gMapMoveLineType.moveLineTypeEscort
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_bangzhuyayun then
		moveLineType = gMapMoveLineType.moveLineTypeEscortHelp
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_lueduo then
		moveLineType = gMapMoveLineType.moveLineTypeEscortRob
	end
	return moveLineType
end
function worldMapFunction.gotoDispatch(data, isAutoJump, isSecondaryLock)
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local tipButtonType = data.dispatchType
	local toPoint = data.toPoint
	toPoint = cc.p(math.floor(toPoint.x), math.floor(toPoint.y))
	local moveLineType, matrixType
	local instanceID = data.instanceID
	local otherData = data.otherData
	local canVerify = false
	local isDuel = tipButtonType == worldMapDefine.worldMapTipButtonType_duel
	moveLineType, matrixType, canVerify = worldMapFunction.getMoveLineTypeAndMatrixType(tipButtonType, toPoint)
	print("moveLineType,matrixType,canVerify", moveLineType, matrixType, canVerify)
	local mapId = gametop.playertop_:getMapID()
	local isForbidSpeed = false
	if data.otherData and data.otherData.isForbidSpeed ~= nil then
		isForbidSpeed = data.otherData.isForbidSpeed
	end
	_ENV = data.otherData
	data.otherData.moveLineType = moveLineType
	_ENV, _ENV, data.otherData.matrixType = canVerify, matrixType, matrixType
	canVerify.x = toPoint.x
	canVerify.y = toPoint.y
	matrixType.to, canVerify.id = canVerify, instanceID
	matrixType.data = otherData
	matrixType.army = data.armyList
	matrixType.heroInfo = data.heroInfo
	matrixType.armsInfo = data.armsInfo
	matrixType.divineBeastInfo = data.divineBeastInfo
	matrixType.mapId = mapId
	matrixType.isDuel = isDuel
	matrixType.isKillLeaderNpc = data.isKillLeaderNpc
	matrixType.killNormalNpcLv = data.killNormalNpcLv
	matrixType.isForbidSpeed = isForbidSpeed
	data.otherData.data, matrixType.isSecondaryLock = matrixType, isSecondaryLock
	local moveLineData = data.otherData
	dump(moveLineData, "worldMapFunction.gotoDispatc", 10)
	if canVerify then
		local haveOtherPlayer = kingdomMapCtrl:isLockByOtherPlayer(toPoint.x, toPoint.y, gMapObjTypeDef.mapObjTypeResource)
		if haveOtherPlayer then
			local showMsg = i18n("common_text_492")
			SoraDShowMsgBox(showMsg, i18n("common_text_490"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					kingdomMapCtrl:reqMarch(moveLineData)
				end
			end)
		else
			kingdomMapCtrl:reqMarch(moveLineData)
		end
	else
		kingdomMapCtrl:reqMarch(moveLineData)
	end
	if tipButtonType == worldMapDefine.worldMapTipButtonType_lueduo then
		worldMapFunction.GotoEscort(nil, false)
	elseif not isAutoJump or not not SoraDConfigGet("Game:GameOptionsView:goOutSwitch~bool") then
		SoraDGotoWorldMapPoint(cityCtrl:getCurCityPos(), false)
	end
end
function worldMapFunction.getMoveLineTypeAndMatrixType(tipButtonType, toPoint)
	local canVerify = false
	local moveLineType, matrixType
	print("worldMapFunction.getMoveLineTypeAndMatrixType  tipButtonType = ", tipButtonType)
	if tipButtonType == worldMapDefine.worldMapTipButtonType_zhanLing then
		moveLineType = gMapMoveLineType.moveLineTypecapture
		local tileInstance
		local worldMapView = SoraDCurrentSceneShowView("worldMapView")
		if worldMapView then
			tileInstance = worldMapView:getShowInstance(toPoint)
		end
		if not tileInstance then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
		elseif tileInstance.instanceType == gMapObjTypeDef.mapObjTypeResource then
			canVerify = true
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
		elseif tileInstance.instanceType == gMapObjTypeDef.mapObjTypeChest or tileInstance.instanceType == gMapObjTypeDef.mapObjTypeChristmasTree then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeChest
		elseif tileInstance.instanceType == gMapObjTypeDef.mapObjNewTrialCity then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
			moveLineType = gMapMoveLineType.moveLineTypecapture
		elseif tileInstance.instanceType == gMapObjTypeDef.mapTypeATBuilding then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
		elseif tileInstance.instanceType == gMapObjTypeDef.mapTypeWarTreasure then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
		elseif tileInstance.instanceType == gMapObjTypeDef.mapTypeRadianceWarResource then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
		elseif tileInstance.instanceType == gMapObjTypeDef.mapTypeLostRuins or tileInstance.instanceType == gMapObjTypeDef.mapTypeWindTower or tileInstance.instanceType == gMapObjTypeDef.iceDragonLostBuild or tileInstance.instanceType == gMapObjTypeDef.mapTypeSnowWolfLost or tileInstance.instanceType == gMapObjTypeDef.legendOfPegasusBuild or tileInstance.instanceType == gMapObjTypeDef.firedragonOfAngerBuild or tileInstance.instanceType == gMapObjTypeDef.firedragonOfAnger2025Build or tileInstance.instanceType == gMapObjTypeDef.feast2024 then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeChest
		elseif tileInstance.instanceType == gMapObjTypeDef.mapTypeRamadanFeast then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
		elseif tileInstance.instanceType == gMapObjTypeDef.dailySaluteBribe then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeDetection
		elseif tileInstance.instanceType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
			matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
		end
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_zuduiwajue then
		moveLineType = gMapMoveLineType.moveLineTypeMass
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_treasuremap_wajue then
		moveLineType = gMapMoveLineType.moveLineTypecapture
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_anniversary_flame then
		moveLineType = gMapMoveLineType.moveLineTypeAnnCampfire
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_wajue then
		moveLineType = gMapMoveLineType.moveLineTypecapture
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_gongJi then
		moveLineType = gMapMoveLineType.moveLineTypeAttackLord
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_shibingYuabzhu then
		moveLineType = gMapMoveLineType.moveLineTypeArmyHelp
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_xiefang then
		moveLineType = gMapMoveLineType.moveLineTypeArmyHelp
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_ziyuanYuanzhu then
		moveLineType = gMapMoveLineType.moveLineTypeResourceHelp
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTrade
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_zhenCha then
		moveLineType = gMapMoveLineType.moveLineTypeScout
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeDetection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_tanXian then
		moveLineType = gMapMoveLineType.moveLineTypeRelicsExplore
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_desertMeteorite then
		moveLineType = gMapMoveLineType.moveLineTypeDesertMeteorite
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeCollection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_xuanZhan then
		moveLineType = gMapMoveLineType.moveLineTypeMass
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu then
		moveLineType = gMapMoveLineType.moveLineTypeMass
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_jianzao then
		local tileInstance
		local worldMapView = SoraDCurrentSceneShowView("worldMapView")
		if worldMapView then
			tileInstance = worldMapView:getShowInstance(toPoint)
		end
		if tileInstance and tileInstance.instanceType == gMapObjTypeDef.mapObjTypeAllianceBuild then
			moveLineType = gMapMoveLineType.moveLineTypeArmyHelp
		else
			moveLineType = gMapMoveLineType.moveLineTypeSuperRes
		end
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_caiji then
		moveLineType = gMapMoveLineType.moveLineTypeSuperRes
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_yayun then
		moveLineType = gMapMoveLineType.moveLineTypeEscort
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeEscort
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_bangzhuyayun then
		moveLineType = gMapMoveLineType.moveLineTypeEscortHelp
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeEscortHelp
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_lueduo then
		moveLineType = gMapMoveLineType.moveLineTypeEscortRob
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeEscortRob
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_duel then
		moveLineType = gMapMoveLineType.moveLineTypeAttackLord
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_nebuladefence_xiefang or tipButtonType == worldMapDefine.worldMapTipButtonType_nebuladefence_gongji then
		moveLineType = gMapMoveLineType.moveLineTypecapture
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_explore then
		moveLineType = gMapMoveLineType.moveLineTypeScout
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeDetection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
		moveLineType = gMapMoveLineType.moveLineTypeCommandHallNpc
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001670_lingqu then
		moveLineType = gMapMoveLineType.moveLineTypecapture
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeDetection
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001717_lingqu then
		moveLineType = gMapMoveLineType.moveLineTypecapture
		matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeDetection
	end
	return moveLineType, matrixType, canVerify
end
function worldMapFunction.GotoEscort(closeHanel, isSelect)
	if isSelect == nil then
		isSelect = true
	end
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() then
		return false
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	local escortCtrl = gametop.playertop_:getModule("escortCtrl")
	local minLv = escortCtrl.dataMgr:getEscortCityLevelMin()
	if tonumber(castleBcell.info.lv) < 12 then
		SoraDShowMsgTip(i18n("common_text_2483"), "#icon_escort_convey.png")
		return false
	end
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if not activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ESCORT) then
		SoraDShowMsgTip(i18n("common_text_2486"), "#icon_escort_convey.png")
		return false
	end
	local self
	local sendServer2Find = function(...)
		escortCtrl:reqGetClosestBuild()
		SoraDShowLoading(self)
	end
	local local2Find = function(_fun)
		SoraDShowLoading(self)
		local closestBuild = escortCtrl.dataMgr:getClosestBuild()
		if closestBuild and closestBuild.x ~= nil and closestBuild.y ~= nil then
			SoraDGotoWorldMapPoint(closestBuild, isSelect)
			SoraDCloseLoading(self)
			if closeHanel then
				closeHanel()
			end
		else
			_fun()
		end
	end
	local2Find(sendServer2Find)
	return true
end
function worldMapFunction.getFightingModel(model)
	model = model or 1
	local node = display.newNode()
	local et_node = SoraDGetFightingEffect()
	et_node:addTo(node, 1)
	local jt1 = display.newSprite("#frame_kingwar_arrow_01.png")
	jt1:setPositionY(-45)
	jt1:addTo(node)
	local jt2 = display.newSprite("#frame_kingwar_arrow_01.png")
	jt2:setFlippedY(true)
	jt2:setPositionY(120)
	jt2:addTo(node)
	if model == 2 then
		node:setRotation(90)
		et_node:setPosition(cc.p(60, 50))
		et_node:setRotation(-90)
	end
	return node
end
function worldMapFunction.moveKingdomAnimation(castleStyle, kingdomName, node)
	castleStyle = castleStyle or 1
	kingdomName = kingdomName or ""
	local palaceInfoRead = include("palaceInfoRead")
	local castleImg = palaceInfoRead.getImg(tonumber(castleStyle))
	if node then
		local castle = node:getChildByName("castle")
		if castle then
			castle:setURL(castleImg)
		end
		local kingdomNameLabel = node:getChildByName("kingdomName")
		if kingdomNameLabel then
			kingdomNameLabel:setString(kingdomName)
		end
		return node
	else
		local node = display.newNode()
		local spriteGear = display.newSprite("#frame_tech_round_02.png")
		spriteGear:addTo(node, 0)
		spriteGear:runAction(cc.RepeatForever:create(cca.rotateBy(10, 360)))
		local spriteDh = display.newSprite("#frame_tech_round_03.png")
		spriteDh:addTo(node, 1)
		local castle = display.newSprite("#" .. castleImg)
		castle:setName("castle")
		castle:setScale(spriteDh:getContentSize().width / castle:getContentSize().width)
		castle:addTo(node, 2)
		local kInfoBG = display.newScale9Sprite("#frame_map_09.png", 0, 0, cc.size(240, 60))
		kInfoBG:setPositionY(-spriteGear:getContentSize().height / 2 - 40)
		kInfoBG:addTo(node)
		local inKingdom = ccui.Text:create(i18n("common_text_2233"), "", 20)
		inKingdom:setTextColor(cc.c4b(240, 170, 60, 255))
		inKingdom:setPositionY(-spriteGear:getContentSize().height / 2 - 25)
		inKingdom:addTo(node, 1)
		local label_kName = ccui.Text:create(kingdomName, "", 24)
		label_kName:setName("kingdomName")
		label_kName:setTextColor(cc.c4b(255, 255, 255, 255))
		label_kName:setPositionY(-spriteGear:getContentSize().height / 2 - 55)
		label_kName:addTo(node, 1)
		return node
	end
end
function worldMapFunction.GotoTrialMass(uPos, instanceID)
	local buildLogic = include("buildLogic")
	local isOwn = buildLogic.isOwnBuild(BUILDID.HALL_OF_WAR)
	if isOwn then
		if instanceID then
			local panel = uiManager:show("WorldMapMass")
			_ENV = nil
			;(nil).uPos = uPos
			;(nil).dispatchType = worldMapDefine.worldMapTipButtonType_xuanZhan
			;(nil).instanceType = gMapObjTypeDef.mapObjTypeAllianceBuild
			;(nil).instanceID = instanceID
			;(nil).realDispatchType = worldMapDefine.worldMapTipButtonType_alliancepet_3
			panel.view:bindData(nil)
		else
			SoraDGotoWorldMapPoint(uPos, true)
			SoraDRemoveAllPrePanelFromManager(self)
		end
	else
		SoraDShowMsgBox(i18n("common_text_2125"), i18n("common_text_204"))
	end
end
function worldMapFunction.convertType(moveLineType, mapObj, data, mapId, kingdomId, uid)
	print(" worldMapFunction.convertType(moveLineType, mapObj, data, mapId, kingdomId, uid)", moveLineType, mapObj, data, mapId, kingdomId, uid)
	dump(mapObj, "mapObj", 10)
	local mapObjUtil = include("mapObjUtil")
	if moveLineType == gMapMoveLineClientType.moveLineTypeAttackLord then
		if mapObj then
			if mapObj.mapType == gWorldTypeServerDef.mapTypePlayer then
				return gMapMoveLineServerType.moveLineTypeAttackLord
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeNpc or mapObj.mapType == gMapObjTypeDef.nebulaNpc then
				return gMapMoveLineServerType.moveLineTypeKillNpc
			elseif mapObj.mapType == gMapObjTypeDef.mapObjTypeBoss or mapObj.mapType == gMapObjTypeDef.wastelandBoss or mapObj.mapType == gMapObjTypeDef.sweetMeatRobber then
				return gMapMoveLineServerType.moveLineTypeKillBoss
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeCamp then
				return gMapMoveLineServerType.moveLineTypeAttackCamp
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeResource then
				return gMapMoveLineServerType.moveLineTypeAttackResource
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeTreasure then
				return gMapMoveLineServerType.moveLineTypeAttackTreasure
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeAllianceBuild then
				return gMapMoveLineServerType.moveLineTypeAttackAllianceBuild
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeMonsterFiesta then
				return gMapMoveLineServerType.moveLineTypeKillNpc
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeAllianceWarBuilding then
				return gMapMoveLineServerType.moveLineTypeAttackAllianceBuild
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeFireTreasure then
				return gMapMoveLineServerType.moveLineTypeAtkTorchMine
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeWarTreasure then
				return gMapMoveLineServerType.moveLineTypeAttackWarTreasure
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeKingdomLevelBuild then
				return gMapMoveLineServerType.npcOccupyNebulaDefenceWar
			elseif mapObj.mapType == gWorldTypeServerDef.nebulaDefenceWarBuilding then
				return gMapMoveLineServerType.attackNebulaDefenceWarBuild
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeCastle or mapObj.mapType == gWorldTypeServerDef.mapTypeBattery or mapObj.mapType == gWorldTypeServerDef.mapTypeAllianceWarBuilding or mapObj.mapType == gWorldTypeServerDef.mapTypeKingWarBuilding or mapObj.mapType == gWorldTypeServerDef.mapTypeLegendLordWarBuilding or mapObj.mapType == gWorldTypeServerDef.mapTypeRuinsWarBuilding or mapObj.mapType == gWorldTypeServerDef.mapTypeDevilValleyWarBuilding or mapObj.mapType == gWorldTypeServerDef.mapTypeRadianceWarPalace or mapObj.mapType == gWorldTypeServerDef.mapTypeRadianceWarGate or mapObj.mapType == gWorldTypeServerDef.mapTypeRadianceWarBeacon then
				return gMapMoveLineServerType.moveLineTypeOccupy
			end
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeScout then
		if mapObj then
			if mapObj.mapType == gWorldTypeServerDef.mapTypePlayer or mapObj.mapType == gWorldTypeServerDef.mapTypeResource or mapObj.mapType == gWorldTypeServerDef.mapTypeCamp or mapObj.mapType == gWorldTypeServerDef.mapTypeTreasure or mapObj.mapType == gWorldTypeServerDef.mapTypeAllianceBuild or mapObj.mapType == gWorldTypeServerDef.mapTypeFireTreasure or mapObj.mapType == gWorldTypeServerDef.mapTypeWarTreasure or mapObj.mapType == gWorldTypeServerDef.mapTypeATBuilding or mapObjUtil.isWarBuild(mapObj.mapType) then
				return gMapMoveLineServerType.moveLineTypeScout
			elseif mapObj.mapType == gMapObjTypeDef.mapTypeMine then
				return gMapMoveLineServerType.moveLineTypeSurvey
			end
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypecapture then
		if mapObj then
			if mapObj.mapType == gWorldTypeServerDef.mapTypeResource then
				return gMapMoveLineServerType.moveLineTypeCollResource
			elseif mapObjUtil.isWarBuild(mapObj.mapType) then
				return gMapMoveLineServerType.moveLineTypeOccupy
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeATBuilding then
				return gMapMoveLineServerType.moveLineTypeATBuilding
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeChest then
				return gMapMoveLineServerType.moveLineTypeChest
			elseif not IsArClient and mapObj.mapType == gMapObjTypeDef.mapObjTypeChristmasTree then
				return gMapMoveLineServerType.moveLineTypeTree
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeEscort then
				return gMapMoveLineServerType.moveLineTypeEscort
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeFireTreasure then
				return gMapMoveLineServerType.moveLineTypeCollTorchMine
			elseif mapObj.mapType == gMapObjTypeDef.mapTypeRamadanFeast then
				return gMapMoveLineServerType.moveLineTypeRamadanFeast
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeWarTreasure then
				return gMapMoveLineServerType.moveLineTypeCollWarTreasure
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeRadianceWarResource then
				return gMapMoveLineServerType.moveLineTypeCollRadianceWarResource
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeLostRuins or mapObj.mapType == gWorldTypeServerDef.mapTypeWindTower or mapObj.mapType == gWorldTypeServerDef.mapTypeIceDragonLost or mapObj.mapType == gWorldTypeServerDef.mapTypeSnowWolfLost then
				return gMapMoveLineServerType.moveLineTypeSurvey
			elseif mapObj.mapType == gWorldTypeServerDef.nebulaDefenceWarBuilding then
				return gMapMoveLineServerType.moveLineTypeDigTreasure
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeKingdomLevelBuild then
				return gMapMoveLineServerType.occupyNebulaDefenceWar
			else
				return gMapMoveLineServerType.moveLineTypeToCamp
			end
		else
			return gMapMoveLineServerType.moveLineTypeToCamp
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeRelicsExplore then
		if mapObj and mapObj.mapType == gWorldTypeServerDef.mapTypeRelics then
			return gMapMoveLineServerType.moveLineTypeRelicsExplore
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeDesertMeteorite then
		return gMapMoveLineServerType.exploreDesertMeteorite
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeResourceHelp then
		if mapObj and mapObj.mapType == gWorldTypeServerDef.mapTypePlayer then
			return gMapMoveLineServerType.moveLineTypeResourceHelp
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeArmyHelp then
		if mapObj then
			if mapObj.mapType == gWorldTypeServerDef.mapTypePlayer then
				return gMapMoveLineServerType.moveLineTypeArmyHelp
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeAllianceBuild then
				return gMapMoveLineServerType.moveLineTypeGuardAllianceBuild
			end
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeMass then
		if data and data.isJoinMass then
			return gMapMoveLineServerType.moveLineTypeMassSlave
		end
		if mapObj then
			if mapObj.mapType == gWorldTypeServerDef.mapTypePlayer then
				return gMapMoveLineServerType.moveLineTypeMass
			elseif mapObjUtil.isWarBuild(mapObj.mapType) then
				return gMapMoveLineServerType.moveLineTypeOccupyMass
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeATBuilding then
				return gMapMoveLineServerType.moveLineTypeMassATBuilding
			elseif mapObj.mapType == gMapObjTypeDef.mapObjTypeBoss or mapObj.mapType == gMapObjTypeDef.wastelandBoss or mapObj.mapType == gMapObjTypeDef.sweetMeatRobber then
				return gMapMoveLineServerType.moveLineTypeMassBoss
			elseif not IsArClient and mapObj.mapType == gMapObjTypeDef.mapObjTypeChristmasTree then
				return gMapMoveLineServerType.moveLineTypeTree
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeAllianceBuild then
				if mapObj.subMapType == gWorldTypeServerDef.subTypeAllianceAltar then
					return gMapMoveLineServerType.moveLineTypeMassABeast
				else
					return gMapMoveLineServerType.moveLineTypeMassAllianceBuild
				end
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeHeroBattleBoss1 then
				return gMapMoveLineServerType.moveLineTypeMassBoss
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypeHeroBattleBoss2 then
				return gMapMoveLineServerType.moveLineTypeMassBoss
			elseif mapObj.mapType == gMapObjTypeDef.mapTypeWrathBeast then
				return gMapMoveLineServerType.moveLineTypeMassWBeast
			elseif mapObj.mapType == gMapObjTypeDef.sweetMeatRobber then
				if data.shield and data.shield > 0 then
					return gMapMoveLineServerType.massBossShield
				else
					return gMapMoveLineServerType.moveLineTypeMassBoss
				end
			elseif mapObj.mapType == gMapObjTypeDef.mapTypeWerewolf then
				return gMapMoveLineServerType.moveLineTypeMassBoss
			elseif mapObj.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
				return gMapMoveLineServerType.moveLineTypeMassAtlantisBoss
			elseif mapObj.mapType == gMapObjTypeDef.nebulaDefenceWarBuilding then
				return gMapMoveLineServerType.massNebulaDefenceWarBuild
			end
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeSuperRes then
		if mapObj then
			if mapObj.mapType == gWorldTypeServerDef.mapTypeSuperResource then
				return gMapMoveLineServerType.moveLineTypeSuperResource
			elseif mapObj.mapType == gWorldTypeServerDef.mapTypePlain then
				return gMapMoveLineServerType.moveLineTypeSuperResource
			end
		else
			return gMapMoveLineServerType.moveLineTypeSuperResource
		end
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeEscort then
		return gMapMoveLineServerType.moveLineTypeEscort
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeEscortRob then
		return gMapMoveLineServerType.moveLineTypeEscortRob
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeEscortHelp then
		return gMapMoveLineServerType.moveLineTypeEscortAssist
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeAnnCampfire then
		return gMapMoveLineServerType.moveLineTypeAnnCampfire
	elseif moveLineType == gMapMoveLineClientType.moveLineTypeCommandHallNpc then
		return gMapMoveLineServerType.commandHallNpc
	end
end
return worldMapFunction
