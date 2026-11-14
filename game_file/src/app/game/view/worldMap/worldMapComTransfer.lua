local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
local remainsWarUtil = include("remainsWarUtil")
local atlantisWarUtil = include("atlantisWarUtil")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local teamDef = include("teamDef")
local worldMapComTransfer = class("worldMapComTransfer", include("worldMapCom"))
local Z_ORDER = worldMapDefine.Z_ORDER
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
local createFeastEffect = function(worldMapCell, holdInstaceWidth, tilePoint, preCallFunc, midCallFunc)
	local point = worldMapCell:getPointWithTile(tilePoint, holdInstaceWidth)
	local particl_node = display.newNode()
	particl_node:setPosition(cc.p(point.x, point.y))
	particl_node:addTo(worldMapCell, Z_ORDER_CELL.moveLine)
	local addEffectStep1 = function()
		local particle_move1 = cc.ParticleSystemQuad:create("Particle/et_castle_move_01.plist")
		particle_move1:setPosition(cc.p(0, 0))
		particle_move1:setScaleX(2.5)
		particle_move1:setScaleY(1.5)
		particle_move1:setPositionType(cc.POSITION_TYPE_RELATIVE)
		particle_move1:addTo(particl_node, 2)
	end
	local addEffectStep2 = function()
		local effectLamp = SoraDCreatAnimation("hjyt_map_shine", nil, false)
		effectLamp:setPosition(cc.p(0, 10))
		particl_node:addChild(effectLamp, 10)
	end
	local effectTime = 0.5
	local _ENV, actionsArray = Z_ORDER_CELL.moveLine, Z_ORDER_CELL.moveLine
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		if preCallFunc then
			preCallFunc()
		end
	end)
	actionsArray[#actionsArray + 1] = cca.callFunc(addEffectStep1)
	actionsArray[#actionsArray + 1] = cca.delay(effectTime)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		if midCallFunc then
			midCallFunc()
		end
	end)
	actionsArray[#actionsArray + 1] = cca.delay(effectTime)
	actionsArray[#actionsArray + 1] = cca.callFunc(addEffectStep2)
	actionsArray[#actionsArray + 1] = cca.delay(effectTime + 2)
	actionsArray[#actionsArray + 1] = cca.callFunc(function()
		if particl_node then
			particl_node:removeFromParent()
		end
	end)
	local actions = transition.sequence(actionsArray)
	worldMapCell:runAction(actions)
end
local createTransferEffect = function(worldMapCell, holdInstaceWidth, tilePoint, preCallFunc, midCallFunc)
	local point = worldMapCell:getPointWithTile(tilePoint, holdInstaceWidth)
	local particl_node = display.newNode()
	particl_node:setPosition(cc.p(point.x, point.y))
	particl_node:addTo(worldMapCell, Z_ORDER_CELL.moveLine)
	local addEffectStep1 = function()
		local particle_move1 = cc.ParticleSystemQuad:create("Particle/et_castle_move_01.plist")
		particle_move1:setPosition(cc.p(0, 0))
		particle_move1:setScaleX(2.5)
		particle_move1:setScaleY(1.5)
		particle_move1:setPositionType(cc.POSITION_TYPE_RELATIVE)
		particle_move1:addTo(particl_node, 2)
	end
	local addEffectStep2 = function()
		local particle_move2 = cc.ParticleSystemQuad:create("Particle/et_castle_move_02.plist")
		particle_move2:setPosition(cc.p(0, 0))
		particle_move2:setScale(1.2)
		particle_move2:setPositionType(cc.POSITION_TYPE_RELATIVE)
		particle_move2:addTo(particl_node, 2)
		local particle_move3 = cc.ParticleSystemQuad:create("Particle/et_castle_move_03.plist")
		particle_move3:setPosition(cc.p(0, 0))
		particle_move3:setPositionType(cc.POSITION_TYPE_RELATIVE)
		particle_move3:addTo(particl_node, 2)
	end
	local effectTime = 1.0
	local _ENV, actionsArray = Z_ORDER_CELL.moveLine, Z_ORDER_CELL.moveLine
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		if preCallFunc then
			preCallFunc()
		end
	end)
	actionsArray[#actionsArray + 1] = cca.callFunc(addEffectStep1)
	actionsArray[#actionsArray + 1] = cca.delay(effectTime)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		if midCallFunc then
			midCallFunc()
		end
	end)
	actionsArray[#actionsArray + 1] = cca.delay(effectTime)
	actionsArray[#actionsArray + 1] = cca.callFunc(addEffectStep2)
	actionsArray[#actionsArray + 1] = cca.delay(effectTime + 2)
	actionsArray[#actionsArray + 1] = cca.callFunc(function()
		if particl_node then
			particl_node:removeFromParent()
		end
	end)
	local actions = transition.sequence(actionsArray)
	worldMapCell:runAction(actions)
end
function worldMapComTransfer:ctor()
	worldMapComTransfer.super.ctor(self, "worldMapComTransfer")
end
function worldMapComTransfer:init()
	worldMapComTransfer.super.init(self)
	self.containerView = self.target_.containerView
	self.tileSize = self.target_.tileSize
	self.viewScrollView = self.target_.viewScrollView
	self.mapLayer = self.target_.mapLayer
	self.groundLayer = self.target_.groundLayer
	self.mapClassType = self.target_.mapClassType
	self.groundLayer_marsh = self.target_.groundLayer_marsh
end
function worldMapComTransfer:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TRANSFER_BUILDING", handler(self, self.transferBuilding))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_TRANSFER_TO_SELFKINDOM", handler(self, self.serverMessage_tranferToSelfKindom))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_TRANSFER_TO_OTHERKINDOM", handler(self, self.serverMessage_tranferToOtherKindom))
	SoraDAddMessage(self, "MESSAGE_RAMADAN_FEAST_SET_SUCCESS", handler(self, self.serverMessage_tranferFeast))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_TRANS, handler(self, self.goTransfer))
end
function worldMapComTransfer:serverMessage_tranferFeast(target, data)
	SoraDShowMsgTip(i18n("tips_place_feast_success"))
end
function worldMapComTransfer:serverMessage_tranferToSelfKindom(target, data)
	local mapId = data.mapId
	local toMapClassType = worldMapDefine.getKingdomMapClassByKingdomId(mapId)
	local curMapClassType = kingdomMapCtrl:getKingdomClass()
	if curMapClassType == gKingdomClassType.garden or toMapClassType == gKingdomClassType.garden then
		return
	end
	if curMapClassType == gKingdomClassType.normal and toMapClassType == gKingdomClassType.roaringFlame then
		SoraDShowMsgTip(i18n("flames_dunes_text312"))
	else
		SoraDShowMsgTip(i18n("common_text_1126"))
	end
end
function worldMapComTransfer:serverMessage_tranferToOtherKindom(target, data)
	if data.state == gMapTranferToOtherKindomState.start then
		SoraDShowLoading()
	elseif data.state == gMapTranferToOtherKindomState.finish then
		_ENV = gMapTranferToOtherKindomState.finish
		gMapTranferToOtherKindomState.finish.msg = "MESSAGE_MAINSCEN_ONSHOW"
		gMapTranferToOtherKindomState.finish.viewType = VIEW_TYPE_MAP
		SoraDSendMessage(gMapTranferToOtherKindomState.finish)
		SoraDCloseLoading()
	end
end
function worldMapComTransfer:goTransfer(event)
	local layInstanceType = event.layInstanceType
	local layInstanceData = event.layInstanceData
	local pos = event.pos
	if layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
		local mapViewCell = event.mapViewCell
		local isLeagueManorTransfer = event.isLeagueManorTransfer
		self:gotoTranferCity(pos, mapViewCell, isLeagueManorTransfer)
	elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceResource then
		self:gotoLayAllianceResource(pos, layInstanceData)
	elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss then
		self:gotoLayBoss(pos, layInstanceData)
	elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		self:gotoLayAllianceManor(pos, layInstanceData)
	elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
		self:gotoLayFeast(pos, layInstanceData)
	end
end
function worldMapComTransfer:transferBuilding(target, data)
	local mapViewCell = data.mapViewCell
	if not mapViewCell then
		return
	end
	local buttonType = data.buttonType
	local layInstanceType = data.layInstanceType
	if buttonType == "cancel" then
		self:removeTransferView(mapViewCell)
	elseif buttonType == "move" then
		local holdInstaceWidth = 2
		local transferPoint = data.tilePoint
		local preCallFunc = function()
			SoraDShowLoading()
			self:removeTransferView(mapViewCell)
			self.target_:moveTilePointToCenter(transferPoint, false, worldMapLayInstanceTypeDef.layInstanceNone, nil, 0, mapViewCell)
		end
		local midCallFunc = function()
			if layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
				kingdomMapCtrl:reqMoveCity(data.itemId, transferPoint.x, transferPoint.y, data.mode, mapViewCell.kingdomID)
			elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceResource then
				local allianceBuild = gametop.playertop_:getModule("allianceBuild")
				local allianceResourceBid = data.allianceResourceBid
				local allianceResourceIiD = data.allianceResourceIiD
				allianceBuild:setBuilding(allianceResourceBid, allianceResourceIiD, transferPoint.x, transferPoint.y)
			elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
				print("放置联盟建筑", data.allianceBuildClassID)
				local buildInfo = worldMapDefine.getAllianceBuildInfo(data.allianceBuildClassID)
				if buildInfo then
				end
				local allianceTerritoryAPI = include("allianceTerritoryAPI")
				local allianceBuildClassID = data.allianceBuildClassID
				local costType = data.costType or gAllianceCreateBuildingCostType.GOLD
				allianceTerritoryAPI:buildAllianceBuilding(allianceBuildClassID, transferPoint, costType)
			elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss then
				print("放置boss")
				local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
				layInstanceType = allianceTerritoryAPI
				allianceTerritoryAPI.x = transferPoint.x
				allianceTerritoryAPI.y = transferPoint.y
				backpackCtrl:reqUseItem(data.itemID, 1, allianceTerritoryAPI)
			elseif layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
				local serverPos = include("mapSyncUtilClient").clientTOServerPos(cc.p(transferPoint.x, transferPoint.y))
				local activityID = data.activityID
				if activityID == gActivityTimeActivityID.FANTASY_LAND then
					local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
					activity_9001717_Ctrl:reqConveneParty(serverPos.x, serverPos.y)
				else
					local activity_9001625_Ctrl = SoraDGetCtrl("activity_9001625_Ctrl")
					activity_9001625_Ctrl:reqPlaceFeast(data.feastLv, serverPos.x, serverPos.y)
				end
			end
			SoraDCloseLoading()
		end
		if layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
			createFeastEffect(mapViewCell, holdInstaceWidth, transferPoint, preCallFunc, midCallFunc)
		else
			createTransferEffect(mapViewCell, holdInstaceWidth, transferPoint, preCallFunc, midCallFunc)
		end
	end
end
function worldMapComTransfer:resetData()
	self.isTransfering = false
	self.transferTilesArray, gametop, self.transferView = nil, nil, nil
	self.layInstanceRageDataArray, gametop, self.layInstanceRageViewArray, gametop, self.transferTilesRolygon = nil, nil, nil, nil, nil
	self.myKindomID = gametop.playertop_:getMapID()
end
function worldMapComTransfer:cleanData()
	if self:isTransferShow() then
		self:resetTransferView()
	end
end
function worldMapComTransfer:addTransferView(toPoint, mapViewCell, layInstanceData)
	if self.transferView then
		self:removeTransferView(mapViewCell)
	end
	self.isTransfering = true
	mapViewCell:setSwallowTouches(true)
	self.transferView = include("worldMapTransferView").new(mapViewCell, layInstanceData)
	self.transferView:setSwallowTouches(false)
	local showPoint = mapViewCell:getPointWithTile(toPoint)
	local coverShowPoint = SoraDCoverToPoint(mapViewCell, showPoint, G_IS_UNITY and self.target_.containerViewNode or self.containerView)
	self.transferView:setPosition(coverShowPoint)
	self.target_.containerViewNode:addChild(self.transferView, Z_ORDER.transView)
	self.transferView:updateBuildingImg()
	self:drawTransferTilesRolygon(toPoint, mapViewCell, layInstanceData)
end
function worldMapComTransfer:removeTransferView(mapViewCell)
	mapViewCell = mapViewCell or self.target_.currentInMapViewCell
	mapViewCell:setSwallowTouches(false)
	if self.transferView then
		if self.transferView.layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
			local layInstanceData = self.transferView.layInstanceData
			layInstanceData.updateType = worldMapLeagueManorUpdateType.leagueManorInstanceRemove
			self:updateLeagueManorInstance(layInstanceData)
		end
		self.transferView:removeFromParent()
		self.transferView = nil
	end
	for _, v in pairs(self.transferTilesArray) do
		v:removeFromParent()
	end
	self.transferTilesArray, _ENV = pairs(self.transferTilesArray)
	if self.transferTilesRolygon then
		self.transferTilesRolygon:removeFromParent()
		self.transferTilesRolygon = nil
	end
	for _, v in pairs(self.layInstanceRageViewArray) do
		v:removeFromParent()
	end
	self.layInstanceRageDataArray, _ENV, self.layInstanceRageViewArray, _ENV = pairs(self.layInstanceRageViewArray)
end
function worldMapComTransfer:getWorldMapCell(kingdomID)
	local mapViewCell = self.target_:getWorldMapCell(kingdomID or self.myKindomID) or self.target_.currentInMapViewCell
	return mapViewCell
end
function worldMapComTransfer:gotoLayBoss(toPoint, layInstanceData)
	local mapViewCell = self:getWorldMapCell()
	if not layInstanceData then
		layInstanceData, _ENV = self, self
	end
	layInstanceData.layInstanceType = worldMapLayInstanceTypeDef.layInstanceBoss
	layInstanceData.activityStatus = true
	layInstanceData.kingdomID = self.myKindomID
	self:addTransferView(toPoint, mapViewCell, layInstanceData)
end
function worldMapComTransfer:gotoLayFeast(toPoint, layInstanceData)
	local mapViewCell = self:getWorldMapCell()
	if not layInstanceData then
		layInstanceData, _ENV = self, self
	end
	layInstanceData.layInstanceType = worldMapLayInstanceTypeDef.layInstanceFeast
	layInstanceData.activityStatus = true
	layInstanceData.kingdomID = self.myKindomID
	self:addTransferView(toPoint, mapViewCell, layInstanceData)
end
function worldMapComTransfer:gotoLayAllianceManor(toPoint, layInstanceData)
	local mapViewCell = self:getWorldMapCell()
	if not layInstanceData then
		layInstanceData, _ENV = self, self
	end
	layInstanceData.layInstanceType = worldMapLayInstanceTypeDef.layInstanceAllianceManor
	layInstanceData.instanceID = "leagueManorInstanceID"
	layInstanceData.activityStatus = true
	layInstanceData.leagueID = allianceMgr:getOwnTeamID()
	layInstanceData.kingdomID = self.myKindomID
	self:addTransferView(toPoint, mapViewCell, layInstanceData)
end
function worldMapComTransfer:gotoLayAllianceResource(toPoint, layInstanceData)
	local mapViewCell = self:getWorldMapCell()
	if not layInstanceData then
		layInstanceData, _ENV = self, self
	end
	layInstanceData.layInstanceType = worldMapLayInstanceTypeDef.layInstanceAllianceResource
	print("放置联盟资源点操作")
	local allianceLeaderPoint = allianceMgr:getLeaderPos()
	if not allianceLeaderPoint then
		SoraDShowMsgTip(i18n("common_text_2173"))
		return
	end
	local layInstanceRageView = SoraDCreateDiamondNode(12 * self.tileSize.width)
	_ENV = 12 * self.tileSize.width
	;(12 * self.tileSize.width).minX = allianceLeaderPoint.x - 5
	;(12 * self.tileSize.width).maxX = allianceLeaderPoint.x + 6
	;(12 * self.tileSize.width).minY = allianceLeaderPoint.y - 5
	local (12 * self.tileSize.width).maxY, layInstanceRageData = allianceLeaderPoint.y + 6, 12 * self.tileSize.width
	local point = mapViewCell:getPointWithTile(cc.p(allianceLeaderPoint.x + 0.5, allianceLeaderPoint.y + 0.5))
	local coverShowPoint = SoraDCoverToPoint2DOr3D(mapViewCell, point, self.containerView)
	layInstanceRageView:setPosition(coverShowPoint)
	layInstanceRageView:addTo(self.containerView, Z_ORDER.rolygonView)
	table.insert(self.layInstanceRageViewArray, layInstanceRageView)
	table.insert(self.layInstanceRageDataArray, layInstanceRageData)
	self:addTransferView(toPoint, mapViewCell, layInstanceData)
end
function worldMapComTransfer:gotoTranferCity(toPoint, mapViewCell, isLeagueManorTransfer)
	mapViewCell = mapViewCell or self.target_.currentInMapViewCell
	local _ENV, layInstanceData = self.target_, self.target_
	layInstanceData.layInstanceType = worldMapLayInstanceTypeDef.layInstanceCity
	local buiLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local gotoTranfer = function()
		local haveMass = kingdomMapCtrl:isHasMassQueue()
		if haveMass then
			local showMsg = i18n("notice_0148")
			SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
		else
			local buildLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
			layInstanceData.cityLevel = buildLv
			layInstanceData.isLeagueManorTransfer = isLeagueManorTransfer or false
			local dressCtrl = gametop.playertop_:getModule("dressCtrl")
			local skinID = dressCtrl:getDressOfCastle()
			layInstanceData.skinID = skinID
			self:addTransferView(toPoint, mapViewCell, layInstanceData)
		end
	end
	local showgotoTranferError = function()
		local showMsg = i18n("common_text_2486")
		SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
	end
	if worldMapDefine.isInGarden() then
		local manorCityUtil = include("manorCityUtil")
		local isCanTransfer, transferPos = manorCityUtil.adaptToTransferPos(toPoint)
		if isCanTransfer then
			toPoint = transferPos
		end
	end
	local isSelfKindom = self.myKindomID == mapViewCell.kingdomID
	if buiLevel < CASTLE_LV6_LIMITED and not worldMapDefine.isLegendLordKingdomID(mapViewCell.kingdomID) then
		if worldMapDefine.isPyramidKingdomID(mapViewCell.kingdomID) then
			return
		end
		if toPoint.x >= 540 and toPoint.x <= 660 and 540 <= toPoint.y and 660 >= toPoint.y then
			local showMsg = i18n("notice_0151")
			SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
		elseif isSelfKindom then
			gotoTranfer()
		else
			if SoraDGetCtrl("newStartMainCtrl"):checkIsInherit() then
				SoraDShowMsgBox(i18n("newstart_text_36"))
				return
			end
			if kingdomCtrl:isFire(mapViewCell.kingdomID) then
				if self.myKindomID < mapViewCell.kingdomID then
					SoraDShowMsgBox(i18n("common_text_4410"), i18n("common_text_054"))
					return
				elseif lordInfoCtrl:getRegisterDays() > 3 then
					if IsArClient then
						SoraDShowMsgBox(i18n("common_text_2426"), i18n("common_text_054"))
					else
						_ENV = i18n("common_text_054")
						i18n("common_text_054").count = 3
						SoraDShowMsgBox(i18n("common_text_1517", i18n("common_text_054")), i18n("common_text_054"), nil, nil)
					end
					return
				end
				local lang = userSDKManager.getChannel()
				if lang ~= "ar" and (cityCtrl:getResCount(gIDDef.FOOD) > 500000 or 500000 < cityCtrl:getResCount(gIDDef.WOOD)) then
					local showMsg = i18n("common_text_2425")
					SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
						if callType == MSGBOX_CALLBACK_YES then
							gotoTranfer()
						end
					end)
					return
				end
			end
			if worldMapDefine.kingdomStatus == gKingStatus.king then
				local showMsg = i18n("common_text_1897")
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
				return
			end
			local isLeader = allianceMgr:isLeader()
			if isLeader then
				local showMsg = i18n("common_text_689")
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
			else
				local showMsg = i18n("notice_0152")
				if kingdomCtrl:isFire(self.myKindomID) then
					showMsg = i18n("common_text_4388")
				elseif kingdomCtrl:isFire(mapViewCell.kingdomID) then
					showMsg = i18n("common_text_2426")
				end
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						gotoTranfer()
					end
				end)
			end
		end
	else
		local kingdomID = mapViewCell.kingdomID
		if isSelfKindom then
			local isInEnemyKingdom = conquestWarCtrl:isPlayerConquestWarMigration()
			if isInEnemyKingdom then
				gotoTranfer()
			elseif worldMapDefine.isRemainsKingdomID(kingdomID) then
				if remainsWarCtrl:isInClose() then
					SoraDShowMsgTip(i18n("remains_text_153"))
				elseif remainsWarCtrl:isMoveCityCDEndTime() then
					SoraDShowMsgTip(i18n("remains_text_160"))
				else
					gotoTranfer()
				end
			elseif worldMapDefine.isNebulaEmperorKingdomID(kingdomID) then
				local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
				local remainTime = nebulaEmperorCtrl:getWarTipRemainTime()
				if 0 < remainTime then
					SoraDShowMsgTip(i18n("nebulaemperor_text_243"))
				else
					gotoTranfer()
				end
			else
				gotoTranfer()
			end
		elseif worldMapDefine.isLegendLordKingdomID(kingdomID) then
			local isLegendJoinActivity = legendLordWarCtrl:isKingdomJoinActivity()
			dump(legendLordWarCtrl:isKingdomJoinActivity(), "legendLordWarCtrl:isKingdomJoinActivity")
			local isHegemonJoinActivity = hegemonCtrl:isKingdomJoinActivity()
			if not isLegendJoinActivity and not isHegemonJoinActivity then
				local showMsg = i18n("legendaryking_text_28")
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
			elseif isHegemonJoinActivity then
				local isMoveToWar = hegemonCtrl:isPlayerMoveToHegemonWar(kingdomID)
				local lifeWaterCtrl = gametop.playertop_:getModule("lifeWaterCtrl")
				local ret, info = lifeWaterCtrl:getValueArmy()
				local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
				if isMoveToWar then
					local armyCtrl = gametop.playertop_:getModule("armyCtrl")
					if buiLevel < _G.CASTLE_LV30_LIMITED then
						_ENV = i18n("nebulaemperor_text_243")
						i18n("nebulaemperor_text_243").lv = 30
						SoraDShowMsgTip(i18n("hegemon_text_01", i18n("nebulaemperor_text_243")))
					elseif not hegemonCtrl:isHegemonKingdomActivityOpen() then
						local hegemonRead = include("hegemonRead")
						local bid = legendLordWarCtrl:getOpenBuildID(worldMapDefine.currentMapKindomID)
						if bid <= 0 then
							bid = hegemonCtrl:getJoinBid()
						end
						local name = hegemonRead.getName(bid)
						_ENV = i18n("hegemon_text_01", i18n("nebulaemperor_text_243"))
						i18n("hegemon_text_01", i18n("nebulaemperor_text_243")).name = name
						SoraDShowMsgTip(i18n("hegemon_text_23", i18n("hegemon_text_01", i18n("nebulaemperor_text_243"))))
					elseif ret then
						uiManager:show("DeadArmyInfo")
					elseif not teamCtrl:isHasTeam() then
						local tip = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_05" or "free_team_text_19"
						SoraDShowMsgBox(i18n("tip"), i18n("common_text_477"), nil, function(eventType)
							if eventType == MSGBOX_CALLBACK_YES then
								_G.clientEventMgr.singleClickEvent(_G.gActivityCenterUIEnum.LEGEND_HEGEMON, 3)
							end
						end)
					elseif 0 < armyCtrl:getCuringArmyCount() then
						SoraDShowMsgBox(i18n("legendaryking_text_25"), i18n("common_text_054"), nil, nil)
					elseif 0 < armyCtrl:getTotalWoundedArmyCount() then
						SoraDShowMsgBox(i18n("legendaryking_text_25"), i18n("common_text_402"), nil, function(eventType)
							if eventType == MSGBOX_CALLBACK_YES then
								uiManager:show("HospitalView"):setLV()
							end
						end)
					elseif kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
						SoraDShowMsgTip(i18n("legendaryking_text_24"))
					else
						local showMsg = i18n("hegemon_text_24")
						SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
							if callType == MSGBOX_CALLBACK_YES then
								layInstanceData.isHegemonWar = true
								gotoTranfer()
							end
						end)
					end
				else
					showgotoTranferError()
				end
			elseif isLegendJoinActivity then
				local isMoveToWar = legendLordWarCtrl:isPlayerMoveToLegendLordWar(kingdomID)
				dump(isMoveToWar, "isMoveToWar")
				if isMoveToWar then
					local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
					local armyCtrl = gametop.playertop_:getModule("armyCtrl")
					local lifeWaterCtrl = gametop.playertop_:getModule("lifeWaterCtrl")
					local constantRead = include("constantRead")
					local castle_limited = constantRead.getConstValue("LEGEND_LORD_WAR_LV_LIMIT", _G.CASTLE_LV50_LIMITED)
					local ret, info = lifeWaterCtrl:getValueArmy()
					if buiLevel < castle_limited then
						local tip = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_01" or "common_text_4198"
						_ENV = i18n("legendaryking_text_24")
						i18n("legendaryking_text_24").lv = 2
						SoraDShowMsgTip(i18n(tip, i18n("legendaryking_text_24")))
					elseif ret then
						uiManager:show("DeadArmyInfo")
					elseif not teamCtrl:isHasTeam() then
						local tip = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_05" or "free_team_text_19"
						SoraDShowMsgBox(i18n(tip), i18n("common_text_477"), nil, function(eventType)
							if eventType == MSGBOX_CALLBACK_YES then
								local legendLordWarCtrl = SoraDGetCtrl("legendLordWarCtrl")
								_G.clientEventMgr.singleClickEvent(legendLordWarCtrl:isLegendLordTeamOpen() and gActivityTimeActivityID.LEGEND_LORD or gActivityTimeActivityID.KING_STAR_BATTLE, 3)
							end
						end)
					elseif 0 < armyCtrl:getCuringArmyCount() then
						local tip = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_06" or "legendaryking_text_25"
						SoraDShowMsgBox(i18n(tip), i18n("common_text_054"), nil, nil)
					elseif 0 < armyCtrl:getTotalWoundedArmyCount() then
						local tip = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_06" or "legendaryking_text_25"
						SoraDShowMsgBox(i18n(tip), i18n("common_text_402"), nil, function(eventType)
							if eventType == MSGBOX_CALLBACK_YES then
								uiManager:show("HospitalView"):setLV()
							end
						end)
					elseif kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
						local tip = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_07" or "legendaryking_text_24"
						SoraDShowMsgTip(i18n(tip))
					else
						local msg = worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) and "kingstarbattle_text_09" or "common_text_4201"
						local showMsg = i18n(msg)
						SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
							if callType == MSGBOX_CALLBACK_YES then
								layInstanceData.isLegendLordWar = true
								gotoTranfer()
							end
						end)
					end
				else
					showgotoTranferError()
				end
			else
				showgotoTranferError()
			end
		elseif conquestWarCtrl:isPlayerMoveToEnemyKingdom(kingdomID) then
			if buiLevel < CASTLE_LV16_LIMITED then
				SoraDShowMsgTip(i18n("common_text_2258"))
			elseif not allianceMgr:hasJoinAlliance() and conquestWarCtrl:isPlayerMoveToReinforceMatchKingdom(kingdomID) then
				SoraDShowMsgTip(i18n("conquestwar_text_51"))
			else
				local showMsg = i18n("common_text_2259")
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						gotoTranfer()
					end
				end)
			end
		elseif conquestWarCtrl:isPlayerReturnSourceKingdom(kingdomID) then
			if conquestWarCtrl:isHelperInReinforceKingdom() and allianceMgr:hasJoinAlliance() then
				SoraDShowMsgTip(i18n("conquestwar_text_52"))
			elseif conquestWarCtrl:isHelperInReinforceMatchKingdom() then
				SoraDShowMsgTip(i18n("atlantiswar_text_0009"))
			else
				gotoTranfer()
			end
		elseif legendLordWarCtrl:isPlayerReturnSourceKingdom(kingdomID) or hegemonCtrl:isPlayerReturnSourceKingdom(kingdomID) then
			local legendTeamUtil = include("legendTeamUtil")
			if legendTeamUtil.isWarTest() then
				local legendTranfer = function()
					local armyCtrl = SoraDGetCtrl("armyCtrl")
					if armyCtrl:checkWoundedArmyState() then
						SoraDShowMsgBox(i18n("Battlefield_queue_text_004"), i18n("common_text_054"), nil, nil)
					else
						gotoTranfer()
					end
				end
				legendTranfer()
			else
				local legendTranfer = function()
					gotoTranfer()
				end
				legendTranfer()
			end
		elseif _G.commonCheck.MOVE_CITY_ACTIVIYT and activityShowCtrl:getCanMoveIn(kingdomID) then
			if allianceMgr:isLeader() then
				SoraDShowMsgBox(i18n("migrate_notice_02"), i18n("common_text_054"), nil, nil)
			elseif allianceMgr:hasJoinAlliance() then
				SoraDShowMsgBox(i18n("migrate_notice_03"), i18n("common_text_054"), nil, nil)
			else
				local showMsg = i18n("notice_0152")
				local lordInfo = lordInfoCtrl:getLordInfo()
				if lordInfo and lordInfo.official then
					showMsg = i18n("migrate_notice_04")
				end
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						gotoTranfer()
					end
				end)
			end
		elseif conquestWarCtrl:isPlayerMoveToReinforceKingdom(kingdomID) then
			local sourceKid = lordInfoCtrl:getSourceKid()
			if sourceKid == 0 and allianceMgr:hasJoinAlliance() then
				SoraDShowMsgTip(i18n("notice_0089"))
			elseif SoraDIsSelfKing() then
				SoraDShowMsgTip(i18n("conquestwar_text_44"))
			else
				local showMsg = i18n("conquestwar_text_50")
				SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						gotoTranfer()
					end
				end)
			end
		else
			local showMsg = i18n("notice_0149")
			SoraDShowMsgBox(showMsg, i18n("common_text_054"), nil, nil)
		end
	end
end
function worldMapComTransfer:drawTransferTilesRolygon(tilePos, mapViewCell, layInstanceData)
	local isFirstDraw = true
	if #self.transferTilesArray > 0 then
		isFirstDraw = false
	end
	local tileNum = 4
	if layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
		local allianceBuildInfo = worldMapDefine.getAllianceBuildInfo(layInstanceData.buildClassID)
		if allianceBuildInfo then
			tileNum = allianceBuildInfo.size * allianceBuildInfo.size
		end
	elseif layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
		tileNum = 4
	end
	local tipStr
	local firstTilePoint = self.transferTilesArray[1]
	if not firstTilePoint or not SoraDIsEqualPoints(firstTilePoint.tilePoint, tilePos) then
		local isCanAllTransfer = true
		local isInWarRange = false
		local layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorNormal
		local _ENV, tempTilesArray
		for k, v in pairs(self.transferTilesArray) do
			if v ~= "NONE" then
				for i = 1, tileNum do
					local x, y = 0, 0
					if i == 2 then
						y = 1
					elseif i == 3 then
						x = 1
						y = 1
					elseif i == 4 then
						x = 1
					end
					local showTilePoint = cc.p(tilePos.x + x, tilePos.y + y)
					if SoraDIsEqualPoints(v.tilePoint, showTilePoint) then
						self.transferTilesArray[k] = "NONE"
						tempTilesArray[i] = v
						local color = cc.c3b(0, 255, 0)
						if not v.isCanTransfer then
							color = cc.c3b(255, 0, 0)
						end
						v:setColor(color)
						isCanAllTransfer = isCanAllTransfer and v.isCanTransfer
					end
				end
			end
		end
		for i = 1, tileNum do
			if not tempTilesArray[i] then
				local x, y = 0, 0
				if i == 2 then
					y = 1
				elseif i == 3 then
					x = 1
					y = 1
				elseif i == 4 then
					x = 1
				end
				local showTilePoint = cc.p(tilePos.x + x, tilePos.y + y)
				local tileGID = self.mapLayer:getTileGIDAt(showTilePoint)
				local groundGID = self.groundLayer:getTileGIDAt(showTilePoint)
				local tileInstance = self.target_:getShowInstance(showTilePoint)
				local isCanTransfer = true
				local maxCoordinate = worldMapDefine.getMaxCoordinateByKid(mapViewCell.kingdomID)
				if 0 > showTilePoint.x or maxCoordinate < showTilePoint.x or 0 > showTilePoint.y or maxCoordinate < showTilePoint.y then
					isCanTransfer = false
				end
				if (layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity or layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceResource or layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor) and not worldMapDefine.isInWar() and (0 >= showTilePoint.x or maxCoordinate <= showTilePoint.x or 0 >= showTilePoint.y or maxCoordinate <= showTilePoint.y) then
					isCanTransfer = false
					tipStr = i18n("boundary_text_1")
				end
				if isCanTransfer and 0 < #self.layInstanceRageDataArray then
					local isInRageView = false
					for _, v in pairs(self.layInstanceRageDataArray) do
						local layInstanceRageData = v
						if showTilePoint.x >= layInstanceRageData.minX and showTilePoint.x <= layInstanceRageData.maxX and showTilePoint.y >= layInstanceRageData.minY and showTilePoint.y <= layInstanceRageData.maxY then
							isInRageView = true
						end
					end
					if not isInRageView then
						isCanTransfer = false
					end
				end
				if isCanTransfer and layInstanceData and (layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceBoss or layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor) and tileGID == 67 then
					isCanTransfer = false
				end
				if self.mapClassType == gKingdomClassType.nebula or self.mapClassType == gKingdomClassType.nebulaEmperor or self.mapClassType == gKingdomClassType.nebulaAllStar or self.mapClassType == gKingdomClassType.roaringFlame or self.mapClassType == gKingdomClassType.garden then
					if isCanTransfer and tileInstance then
						isCanTransfer = false
					end
				elseif isCanTransfer and tileGID < 0 then
					isCanTransfer = false
				elseif isCanTransfer and 5 <= tileGID and tileGID <= 23 then
					isCanTransfer = false
				elseif 62 <= tileGID and tileGID <= 79 and tileGID ~= 67 then
					if self.mapClassType ~= gKingdomClassType.remains then
						isCanTransfer = false
					end
				elseif isCanTransfer and 99 <= groundGID and groundGID <= 111 then
					isCanTransfer = false
				elseif isCanTransfer and tileInstance then
					isCanTransfer = false
				end
				if self.mapClassType == gKingdomClassType.normal and isCanTransfer and allianceStrongholdMineRead.isInHoldArea(showTilePoint) then
					isCanTransfer = false
					print("在据点隶属区域内======")
				end
				if isCanTransfer and self.mapClassType == gKingdomClassType.radiance and self.groundLayer_marsh then
					groundGID = self.groundLayer_marsh:getTileGIDAt(showTilePoint)
					if 0 < groundGID then
						isCanTransfer = false
					end
				end
				if not isInWarRange and 62 <= tileGID and tileGID <= 79 then
					isInWarRange = true
				end
				if self.mapClassType == gKingdomClassType.remains then
					local isInBorn = remainsWarUtil.checkIsInForbidArea(showTilePoint)
					if isInBorn then
						isCanTransfer = false
					end
				end
				if not tileInstance and self.mapClassType == gKingdomClassType.atlantis then
					isCanTransfer = atlantisWarUtil.checkIsInForbidAreaQiancheng(showTilePoint)
				end
				isCanTransfer = isCanTransfer and not kingdomMapCtrl:checkIsInNormalFog(showTilePoint, mapViewCell.kingdomID)
				if self.mapClassType == gKingdomClassType.nebula then
					if isCanTransfer then
						local worldMapWarDef = include("worldMapWarDef")
						local ok, err = worldMapWarDef.checkIsCanTransfer(self.mapClassType, showTilePoint)
						isCanTransfer = ok
						if not isCanTransfer and layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorNormal then
							layInstanceError = err
						end
					end
					if not isInWarRange then
						local nebulaWarUtil = include("nebulaWarUtil")
						local selfManorRect = cc.rect(showTilePoint.x, showTilePoint.y, 0, 0)
						isInWarRange = nebulaWarUtil.checkIsWarRange(selfManorRect)
					end
				elseif isCanTransfer then
					local worldMapWarDef = include("worldMapWarDef")
					local ok, err = worldMapWarDef.checkIsCanTransfer(self.mapClassType, showTilePoint)
					if not ok then
						isCanTransfer = false
						layInstanceError = err
					end
				end
				local color = cc.c3b(0, 255, 0)
				if not isCanTransfer then
					color = cc.c3b(255, 0, 0)
				end
				local showPoint = mapViewCell:getPointWithTile(showTilePoint)
				local tileRolygon = include("worldMapTileRolygon").new(color)
				tileRolygon:setPosition(showPoint)
				tileRolygon.tilePoint = showTilePoint
				tileRolygon.isCanTransfer = isCanTransfer
				tileRolygon:disableToggle3D()
				mapViewCell:addChild(tileRolygon, Z_ORDER_CELL.moveLine)
				tempTilesArray[i] = tileRolygon
				isCanAllTransfer = isCanAllTransfer and isCanTransfer
			end
		end
		local isUpdateRolygon = isFirstDraw
		local isInSelfLeagueManor = false
		local isInOtherLeagueManor = false
		for _, v in pairs(self.transferTilesArray) do
			if v ~= "NONE" then
				isUpdateRolygon = true
				v:removeFromParent()
			end
		end
		self.transferTilesArray = tempTilesArray
		if isUpdateRolygon then
			local isCanTransfer = true
			if layInstanceData and layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
				if layInstanceData.isLeagueManorTransfer then
					for _, v in pairs(self.transferTilesArray) do
						local isInLeagueManor = self.target_:isInselfOrAllyLeagueManor(v.tilePoint, false)
						if not isInLeagueManor then
							isCanTransfer = false
							break
						end
					end
				elseif self.mapClassType == gKingdomClassType.pyramid then
					if 0 >= allianceWarCtrl:getRemainMoveTimes4AllianceWar() then
						isCanTransfer = false
					end
				elseif self.mapClassType == gKingdomClassType.newTrial then
					isCanTransfer = false
				end
			end
			for _, v in pairs(self.transferTilesArray) do
				v:doAnimation()
			end
			if self.transferTilesRolygon then
				self.transferTilesRolygon:removeFromParent()
				self.transferTilesRolygon = nil
			end
			if layInstanceData then
				if layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
					local radioation = 1
					local size = 2
					local allianceBuildType = layInstanceData.buildClassID
					local allianceBuildInfo = worldMapDefine.getAllianceBuildInfo(allianceBuildType)
					if allianceBuildInfo then
						size = allianceBuildInfo.size
						radioation = allianceBuildInfo.radioation
					end
					local selfManorRect = cc.rect(tonumber(tilePos.x) - radioation, tonumber(tilePos.y) - radioation, 2 * radioation + size - 1, 2 * radioation + size - 1)
					local selfBuildRect = cc.rect(tonumber(tilePos.x), tonumber(tilePos.y), size - 1, size - 1)
					local forbidRect = cc.rect(575, 575, 51, 51)
					isCanTransfer = not cc.rectIntersectsRect(selfManorRect, forbidRect)
					if isCanTransfer then
						if allianceBuildType == gMapAllianceBuildType.subTypeAllianceFlag then
							local allianceTerritoryAPI = include("allianceTerritoryAPI")
							if allianceTerritoryAPI:getAllianceFlagCount() >= allianceTerritoryAPI:getCurrentFlagLimit() then
								isCanTransfer = false
								layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorMax
							end
						end
						if isCanTransfer then
							if allianceBuildType == gMapAllianceBuildType.subTypeAlliancePalace or allianceBuildType == gMapAllianceBuildType.subTypeAlliancePriPalace then
								isInSelfLeagueManor = true
							else
								isInSelfLeagueManor = self.target_:isInSelfLeagueManor(layInstanceData.leagueID, selfManorRect)
								isInOtherLeagueManor = self.target_:isFullInOtherLeagueManor(layInstanceData.leagueID, selfManorRect, selfBuildRect)
							end
							if isInSelfLeagueManor then
								isInOtherLeagueManor = self.target_:isFullInOtherLeagueManor(layInstanceData.leagueID, selfManorRect, selfBuildRect)
								if isInOtherLeagueManor then
									layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInOther
								end
							elseif isInOtherLeagueManor then
								layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInOther
							elseif self.target_:isInSelfHoldManor(layInstanceData.leagueID, selfManorRect) then
								layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelfHold
							else
								layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelf
							end
							if allianceBuildType == gMapAllianceBuildType.subTypeAlliancePalace and allianceStrongholdMineRead.isInHoldArea(tilePos) then
								layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInHold
							end
						end
						dump(selfManorRect, "weiurwoeuroieurdsfsdf")
						print("dklfjskldjfslkfjd", isCanTransfer, isInSelfLeagueManor, isInOtherLeagueManor)
						if isCanTransfer and isInSelfLeagueManor and not isInOtherLeagueManor then
							isCanTransfer = true
						else
							isCanTransfer = false
						end
					end
					local showPoint = mapViewCell:getPointWithTile(cc.p(tilePos.x + (size - 1) / 2, tilePos.y + (size - 1) / 2))
					local coverShowPoint = SoraDCoverToPoint2DOr3D(mapViewCell, showPoint, self.containerView)
					local tilesRolygon = include("worldMapTilesRolygon").new(size + 2 * radioation)
					tilesRolygon:setPosition(coverShowPoint)
					tilesRolygon:setRolygonColor()
					tilesRolygon:addTo(self.containerView, Z_ORDER.selectBgView)
					if not isCanTransfer then
						local redColor = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ENEMY)
						tilesRolygon:setRolygonColor(redColor)
					end
					self.transferTilesRolygon = tilesRolygon
					layInstanceData.tilePoint = tilePos
					layInstanceData.updateType = worldMapLeagueManorUpdateType.leagueManorInstanceRemove
					self:updateLeagueManorInstance(layInstanceData)
					layInstanceData.updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
					layInstanceData.sn = gManorlineSn.placePreview
					self:updateLeagueManorInstance(layInstanceData)
					if allianceBuildType == gMapAllianceBuildType.subTypeAlliancePriPalace or allianceBuildType == gMapAllianceBuildType.subTypeAlliancePalace then
						local alliance = allianceMgr:getAlliance()
						if alliance and alliance:getMemberCount() < 15 and allianceStrongholdMineRead.isNearHoldArea(tilePos) then
							isCanTransfer = false
							layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorNearHold
						end
					end
				elseif self.mapClassType == gKingdomClassType.radiance and layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceCity then
					if isCanAllTransfer then
						local radianceWarUtil = include("radianceWarUtil")
						isInSelfLeagueManor = radianceWarUtil.isInSelfLeagueManor(tilePos, nil, 2, 0, true)
						if not isInSelfLeagueManor and radianceWarUtil.isRelease() then
							isCanTransfer = false
							layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelf
						end
					end
				elseif layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceFeast then
					local radioation = 1
					local size = 2
					local selfManorRect = cc.rect(tonumber(tilePos.x) - radioation, tonumber(tilePos.y) - radioation, 2 * radioation + size - 1, 2 * radioation + size - 1)
					local forbidRect = cc.rect(575, 575, 50, 50)
					isCanTransfer = not cc.rectIntersectsRect(selfManorRect, forbidRect)
				end
			end
			if not isCanTransfer then
				local redColor = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ENEMY)
				for _, v in pairs(self.transferTilesArray) do
					v:setColor(redColor)
				end
			end
			isCanAllTransfer = isCanAllTransfer and isCanTransfer
			if layInstanceData and layInstanceData.layInstanceType == worldMapLayInstanceTypeDef.layInstanceAllianceManor then
				local allianceBuildType = layInstanceData.buildClassID
				if allianceBuildType == gMapAllianceBuildType.subTypeAllianceFlag and not isCanAllTransfer and layInstanceError == worldMapLayInstanceTypeErrorDef.layInstanceErrorNormal then
					layInstanceError = worldMapLayInstanceTypeErrorDef.layInstanceErrorInSelf
				end
			end
		end
		firstTilePoint = self.transferTilesArray[1]
		self.transferView:updateData(firstTilePoint.tilePoint, isCanAllTransfer, layInstanceError, isInWarRange)
		if tipStr then
			SoraDShowMsgTip(tipStr)
		end
	end
end
function worldMapComTransfer:isTransferShow()
	return self.isTransfering and self.transferView
end
function worldMapComTransfer:resetTransferView(mapView, forceRemove)
	if self.transferView.isBeganTouchIn then
		self.transferView.isBeganTouchIn = false
	elseif forceRemove or self.transferView.layInstanceType ~= worldMapLayInstanceTypeDef.layInstanceFeast then
		self:removeTransferView(mapView)
	end
end
function worldMapComTransfer:isTransferTouchIn()
	if self.isTransfering and self.transferView and self.transferView.isBeganTouchIn then
		return true
	end
	return false
end
function worldMapComTransfer:moveTransferView(touchmovePoint, mapView)
	local zoomScale = self.viewScrollView:getZoomScale()
	local tileSize = self.tileSize
	local covertPoint = mapView:convertToNodeSpace(touchmovePoint)
	local toPoint = cc.p(covertPoint.x, covertPoint.y)
	local tempLenght = tileSize.width * zoomScale
	if tempLenght > touchmovePoint.x then
		toPoint = cc.p(toPoint.x + (tempLenght - touchmovePoint.x) * zoomScale, toPoint.y)
	end
	tempLenght = display.width - tileSize.width * zoomScale
	if tempLenght < touchmovePoint.x then
		toPoint = cc.p(toPoint.x + (tempLenght - touchmovePoint.x) * zoomScale, toPoint.y)
	end
	tempLenght = 150 + tileSize.height * zoomScale
	if tempLenght > touchmovePoint.y then
		toPoint = cc.p(toPoint.x, toPoint.y + (tempLenght - touchmovePoint.y) * zoomScale)
	end
	tempLenght = display.height - (120 + tileSize.height * zoomScale)
	if tempLenght < touchmovePoint.y then
		toPoint = cc.p(toPoint.x, toPoint.y + (tempLenght - touchmovePoint.y) * zoomScale)
	end
	local offsetPoint = self.viewScrollView:getContentOffset()
	local subPoint = cc.pSub(toPoint, covertPoint)
	local distance = cc.pGetDistance(toPoint, covertPoint)
	local maxDistance = 10
	if distance > maxDistance then
		local percent = maxDistance / distance
		subPoint = cc.p(subPoint.x * percent, subPoint.y * percent)
	end
	local newOffsetPoint = cc.pAdd(offsetPoint, subPoint)
	self.viewScrollView:setContentOffset(newOffsetPoint, false)
	local firstTileCoverPoint = cc.p(toPoint.x, toPoint.y + zoomScale * tileSize.height / 2)
	local firstTileWorldPoint = mapView:convertToWorldSpace(firstTileCoverPoint)
	local tilePos = mapView:tilePositionFromLocation(firstTileWorldPoint)
	if tilePos.x < 0 or tilePos.y < 0 or tilePos.x > 1199 or tilePos.y > 1199 then
		self:removeTransferView(mapView)
		return
	end
	self:drawTransferTilesRolygon(tilePos, mapView, self.transferView.layInstanceData)
	local coverShowPoint = SoraDCoverToPoint2DOr3D(mapView, toPoint, G_IS_UNITY and self.target_.containerViewNode or self.containerView)
	self.transferView:setPosition(coverShowPoint)
end
function worldMapComTransfer:updateLeagueManorInstance(data)
	data.msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	SoraDSendMessage(data)
end
function worldMapComTransfer:exportMethods()
	_UPVALUE4_ = nil
	;(nil)[1] = "isTransferShow"
	;(nil)[2] = "resetTransferView"
	;(nil)[3] = "isTransferTouchIn"
	;(nil)[4] = "moveTransferView"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComTransfer
