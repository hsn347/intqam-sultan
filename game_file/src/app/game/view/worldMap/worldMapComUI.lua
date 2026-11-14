local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapViewDef = include("worldMapViewDef")
local worldMapUtil = include("worldMapUtil")
local worldMapComUI = class("worldMapComUI", include("worldMapCom"))
function worldMapComUI:ctor()
	worldMapComUI.super.ctor(self, "worldMapComUI")
end
function worldMapComUI:init()
	worldMapComUI.super.init(self)
	self.mapClassType = self.target_.mapClassType
	self.displayCenterPoint = self.target_.displayCenterPoint
	self.tileSize = self.target_.tileSize
	self.myCityTilePoint = cityCtrl:getCurCityPos()
	self.isHideDis = false
	self.mapViewCenterPoint = self.target_.mapViewCenterPoint
	self.Node_bottom = SoraDGetChildByName(self.target_, "Node_bottom")
	self.bottomPointNode = SoraDGetExtendChildFromCCSByName(self.target_, "CCS_worldMapBottomPoint_1")
	self.bottomPointNode:addTouchEventListener(function(ref, type)
		self:bottomPointOnClick(ref, type)
	end)
	self.faceToDistanceNode = SoraDGetWorldMapFaceToDistanceNode()
	self.faceToDistanceNode:addTouchEventListener(function(ref, type)
		self:faceToDistanceOnClick(ref, type)
	end)
	self.buttonWorldResouce = SoraDGetChildByName(self.target_, "Button_worldResource")
	if self.buttonWorldResouce then
		self.buttonWorldResouce:addTouchEventListener(handler(self, self.buttonWorldResouceCall))
		if self.mapClassType == gKingdomClassType.newTrial then
			self.buttonWorldResouce:setVisible(false)
		end
	end
	self.buttonFavorite = SoraDGetChildByName(self.target_, "Button_favorite")
	if self.buttonFavorite then
		self.buttonFavoriteStar = SoraDGetChildByName(self.buttonFavorite, "Image_star")
		self.buttonFavoriteStar:setVisible(false)
		self.buttonFavorite:addTouchEventListener(handler(self, self.buttonFavoriteCall))
		worldMapComUI = handler(self, self.buttonFavoriteCall)
		handler(self, self.buttonFavoriteCall).checkData = true
		self:serverMessage_addBookMark(self, handler(self, self.buttonFavoriteCall))
		if self.mapClassType == gKingdomClassType.newTrial or self.mapClassType == gKingdomClassType.garden then
			self.buttonFavorite:setVisible(false)
		end
	end
	self.buttonMyCity = SoraDGetChildByName(self.target_, "Button_myCity")
	if self.buttonMyCity then
		self.buttonMyCity:setVisible(false)
		if self.myKindomID ~= worldMapDefine.currentMapKindomID then
			self.buttonMyCity:setVisible(true)
		end
		if self.mapClassType == gKingdomClassType.legendLord then
			local textMyCity = SoraDGetChildByName(self.buttonMyCity, "Text_myCity")
			textMyCity:setString(i18n("common_title_01"))
		elseif self.mapClassType == gKingdomClassType.remains or self.mapClassType == gKingdomClassType.newTrial then
			self.buttonMyCity:setVisible(false)
		elseif self.mapClassType == gKingdomClassType.garden then
			local textMyCity = SoraDGetChildByName(self.buttonMyCity, "Text_myCity")
			if worldMapDefine.isInGarden() then
				textMyCity:setString(i18n("garden_text_35"))
			else
				textMyCity:setString(i18n("common_text_4580"))
			end
		else
			local textMyCity = SoraDGetChildByName(self.buttonMyCity, "Text_myCity")
			textMyCity:setString(i18n("common_text_4580"))
		end
		self.buttonMyCity:addTouchEventListener(handler(self, self.buttonMyCityCall))
	end
	self:fitNodeBottom()
	if self.bottomPointNode then
		self:showOrHideGuideView()
	end
end
function worldMapComUI:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		self.Node_bottom:setPositionY(170 + display.iPhoneXBottom)
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	local addX = (640 - fitScale * 640) / 2
	self.Node_bottom:setScale(fitScale)
	self.Node_bottom:setPositionX(addX)
	self.Node_bottom:setPositionY(170 * fitScale + display.iPhoneXBottom)
	local posX = self.buttonWorldResouce:getPositionX()
	print("fitWidth - 640, addX, posX", fitWidth - 640, addX, posX)
	self.buttonWorldResouce:setPositionX(SoraDFIsRA() and posX + (fitWidth - 640) - addX / fitScale or posX - addX / fitScale)
end
function worldMapComUI:relogin()
	worldMapComUI.super.relogin(self)
	self.myCityTilePoint = cityCtrl:getCurCityPos()
	self:updateFaceToDistance()
end
function worldMapComUI:resetData()
	self.myKindomID = gametop.playertop_:getMapID()
end
function worldMapComUI:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_RESOURCE_MAP_MEMBERS", handler(self, self.serverMessage_LeagueMembersInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_COLLECTMAP_SUCCESS", handler(self, self.serverMessage_addBookMark))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_UPDATE_SELF_POINT", handler(self, self.serverMessage_UpdateSelfPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_HIDE_AND_SHOW", handler(self, self.showOrHideGuideView))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_DISTANCE_VISIBLE", handler(self, self.showOrHideDistance))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_DID, handler(self, self.updateFaceToDistance))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateScrollChange))
	self:updateFaceToDistance()
end
function worldMapComUI:showOrHideDistance(target, data)
	self.isHideDis = data.ret or false
	self:updateFaceToDistance()
end
function worldMapComUI:serverMessage_UpdateSelfPoint(target, data)
	self.myCityTilePoint.x = data.data.x
	self.myCityTilePoint.y = data.data.y
	self.target_:moveTilePointToCenter(self.myCityTilePoint)
end
function worldMapComUI:serverMessage_LeagueMembersInfo(target, data)
	if data and (not data.clientData or data.clientData.from ~= "worldMapComUI") then
		return
	end
	local currentInMapViewCell = self.target_.currentInMapViewCell
	SoraDCloseLoading(self.buttonWorldResouce)
	local centerPoint = currentInMapViewCell:convertToNodeSpace(self.displayCenterPoint)
	centerPoint = SoraDCoverToPoint2DOr3D(currentInMapViewCell, centerPoint, currentInMapViewCell)
	local subPoint = cc.pSub(self.mapViewCenterPoint, centerPoint)
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	subPoint = cc.p(subPoint.x * ratio, subPoint.y * ratio)
	local _ENV, memberArray = cc.p(subPoint.x * ratio, subPoint.y * ratio), cc.p(subPoint.x * ratio, subPoint.y * ratio)
	if data and data.data then
		local dataArray = data.data
		for _, v in pairs(dataArray) do
			if v.x and v.y then
				local tilePoint = cc.p(v.x - 1, v.y - 1)
				local point = self.target_:getPointWithTile(tilePoint)
				local subPt = cc.pSub(self.mapViewCenterPoint, point)
				v.x = subPt.x * ratio
				v.y = subPt.y * ratio
				table.insert(memberArray, v)
			end
		end
	end
	_ENV = dataArray
	data.data[gKingdomClassType.pyramid] = "pyramidBattleMapView"
	data.data[gKingdomClassType.legendLord] = "legendLordMapView"
	data.data[gKingdomClassType.remains] = "remainsMapView"
	local data.data[gKingdomClassType.atlantis], warType_config = "atlantisResourceMap", data.data
	local panelName = warType_config[self.mapClassType]
	if panelName then
		local panel = SoraDSearchPanelFromManagerByName(panelName)
		if not panel then
			panel = SoraDCreatePanel(panelName)
			panel:show()
			panel:setLeagueMembersInfo(memberArray)
			_ENV = panel
			panel.msg = "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER"
			panel.subPoint = subPoint
			SoraDSendMessage(panel)
		end
	elseif self.mapClassType == gKingdomClassType.radiance then
		local panel = SoraDSearchPanelFromManagerByName("radianceWarMapView")
		if not panel then
			local radianceWarMapView = SoraDCreatePanelByFixName("radianceWarMapView")
			radianceWarMapView:show()
			radianceWarMapView:setLeagueMembersInfo(memberArray)
			radianceWarMapView:setEnterType("worldMapView")
			_ENV = radianceWarMapView
			radianceWarMapView.msg = "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER"
			radianceWarMapView.subPoint = subPoint
			SoraDSendMessage(radianceWarMapView)
			SoraDGetCtrl("radianceWarCtrl"):radianceWarMatchResult()
		end
	else
		local resourceMap = SorDShowWorldResourceMap()
		resourceMap:setLeagueMembersInfo(memberArray)
		resourceMap:setWrathBeastInfo()
		resourceMap:setEndlessTrialsInfo()
		_ENV = resourceMap
		resourceMap.msg = "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER"
		resourceMap.subPoint = subPoint
		SoraDSendMessage(resourceMap)
	end
end
function worldMapComUI:serverMessage_addBookMark(target, data)
	if not data.checkData then
		SoraDShowMsgTip(i18n("common_text_494"))
	end
	local haveLook = false
	for _, v in pairs(gCollectTempData) do
		if v.isLook == false then
			haveLook = true
		end
	end
	self.buttonFavoriteStar:setVisible(haveLook)
end
function worldMapComUI:showOrHideGuideView()
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local guideStep = guideCtrl:getCurForceGuideStep()
	self.bottomPointNode:setVisible(false)
	if self.buttonFavorite then
		self.buttonFavorite:setVisible(false)
	end
	self.buttonWorldResouce:setVisible(false)
	if not guideStep then
		self.bottomPointNode:setVisible(true)
		if self.mapClassType ~= gKingdomClassType.newTrial and self.mapClassType ~= gKingdomClassType.garden and self.buttonFavorite then
			self.buttonFavorite:setVisible(true)
		end
		if self.mapClassType ~= gKingdomClassType.newTrial then
			self.buttonWorldResouce:setVisible(true)
		end
	end
end
function worldMapComUI:bottomPointOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local hideKingIDTextField = false
		if self.target_.isSingleMapCell then
			hideKingIDTextField = true
		end
		local gotoPanel = include("worldMapGotoPointPanel").new(hideKingIDTextField)
		gotoPanel:show()
		local covertCenterTilePoint = self.bottomPointNode.tilePoint
		if hideKingIDTextField then
			gotoPanel:updateData(worldMapDefine.currentMapKindomID, covertCenterTilePoint)
		else
			gotoPanel:updateData(self.myKindomID, covertCenterTilePoint)
		end
	end
end
function worldMapComUI:faceToDistanceOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.currentTroopTip then
			local troopMoveLineID = self.currentTroopTip:getMoveLineID()
			_ENV = nil
			;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
			;(nil).moveLineID = troopMoveLineID
			SoraDSendMessage(nil)
		end
		if not tolua.isnull(self.target_) then
			self.target_:moveTilePointToCenter(self.myCityTilePoint)
			self.target_:cleanShowPanel()
		end
	end
end
function worldMapComUI:buttonWorldResouceCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.target_:getComponent("worldMapComLod") then
			_ENV = nil
			;(nil).toScale = worldMapViewDef.MIN_SCALE
			;(nil).needAction = true
			self.target_:gotoTilePointNew(self.target_, nil)
			return
		end
		if not SoraDGetLoading(self.buttonWorldResouce) then
			local loading = SoraDShowLoading(self.buttonWorldResouce, cc.size(50, 50))
			loading:setPosition(cc.p(60, 60))
		end
		_ENV = loading.setPosition
		loading.setPosition.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(loading.setPosition)
		local bReqMember = true
		if self.mapClassType == gKingdomClassType.legendLord then
			bReqMember = false
			local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
			if teamCtrl:isHasTeam() then
				_ENV = teamCtrl
				teamCtrl.from = "worldMapComUI"
				kingdomMapCtrl:reqAllianceMember(worldMapDefine.currentMapKindomID, teamCtrl:getTeamID(), teamCtrl)
			else
				self:serverMessage_LeagueMembersInfo()
			end
		elseif self.mapClassType == gKingdomClassType.pyramid then
			if not worldMapDefine.isInPyramid() then
				self:serverMessage_LeagueMembersInfo()
				bReqMember = false
			end
		elseif self.mapClassType == gKingdomClassType.nebula then
			self:serverMessage_LeagueMembersInfo()
			bReqMember = false
		end
		if bReqMember then
			_ENV = teamCtrl:getTeamID()
			teamCtrl:getTeamID().from = "worldMapComUI"
			kingdomMapCtrl:reqAllianceMember(nil, nil, (teamCtrl:getTeamID()))
		end
	end
end
function worldMapComUI:buttonFavoriteCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(nil)
		uiManager:show("WorldMapBookMark")
	end
end
function worldMapComUI:buttonMyCityCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isLegendLordKingdomID() and worldMapDefine.isInLegendLord() then
			local kid = gametop.playertop_:getKingdomID()
			SoraDGotoWorldMapPoint(cc.p(600, 600), false, kid or self.myKindomID)
		elseif worldMapDefine.isPyramidKingdomID() and not worldMapDefine.isInPyramid() then
			SoraDGotoWorldMapPoint(self.myCityTilePoint, false, self.myKindomID, nil, nil, true)
		elseif worldMapDefine.isGardenKingdomID() and not worldMapDefine.isInGarden() then
			SoraDGotoWorldMapPoint(self.myCityTilePoint, false, self.myKindomID, nil, nil, true)
		else
			SoraDGotoWorldMapPoint(self.myCityTilePoint, false, self.myKindomID)
		end
	end
end
function worldMapComUI:updateFaceToDistance()
	local currentInMapViewCell = self.target_.currentInMapViewCell
	local covertCenterTilePoint = currentInMapViewCell:tilePositionFromLocation(self.displayCenterPoint)
	if covertCenterTilePoint.x >= 0 and 0 <= covertCenterTilePoint.y then
		local kingdomID
		if self.myKindomID ~= currentInMapViewCell.kingdomID then
			kingdomID = currentInMapViewCell.kingdomID
			if not worldMapDefine.isGardenKingdomID(kingdomID) then
				local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
				local isK = kingdomCtrl:isFoundKingdomID(kingdomID)
				if not isK then
					kingdomID = 0
				end
			end
		end
		self.bottomPointNode:updateData(covertCenterTilePoint, kingdomID)
		self.covertCenterTilePoint = covertCenterTilePoint
	end
	self:updateButtonMyCity()
	if self.myKindomID ~= currentInMapViewCell.kingdomID then
		if gKingdomClassType.remains ~= self.mapClassType and gKingdomClassType.newTrial ~= self.mapClassType then
			self.faceToDistanceNode:setVisible(false)
		else
			self.faceToDistanceNode:setVisible(false)
		end
		return
	end
	self.faceToDistanceNode:setVisible(not self.isHideDis)
	local distance = cc.pGetDistance(self.myCityTilePoint, covertCenterTilePoint)
	distance = math.ceil(distance)
	if self.faceToDistanceNode and self.faceToDistanceNode.__cname then
		if covertCenterTilePoint.x >= 0 and 0 <= covertCenterTilePoint.y then
			self.faceToDistanceNode:updateData(distance)
		end
		local myCityPoint = currentInMapViewCell:getPointWithTile(self.myCityTilePoint)
		myCityPoint = cc.p(myCityPoint.x, myCityPoint.y - self.tileSize.height / 2)
		local myCityDisplayPoint
		if distance < 20 then
			myCityDisplayPoint = SoraDProjec2ScreenPos2DOr3D(currentInMapViewCell, myCityPoint)
		else
			myCityDisplayPoint = SoraDVerticalProject2ScreenPos2DOr3D(currentInMapViewCell, myCityPoint)
		end
		local showRect = cc.rect(60, 150, display.width - 120, display.height - 240)
		local isIntersect, intersectPointArray = SoraDLineIntersectRect(self.displayCenterPoint, myCityDisplayPoint, showRect)
		if isIntersect and 0 < #intersectPointArray then
			local intersectPoint = intersectPointArray[1]
			self.faceToDistanceNode:setVisible(not self.isHideDis)
			self.faceToDistanceNode:setPosition(intersectPoint)
			local rotation = SoraDGetAngleByPos(self.displayCenterPoint, myCityDisplayPoint)
			self.faceToDistanceNode:setArrowRotation(-rotation)
		else
			self.faceToDistanceNode:setVisible(false)
		end
	end
end
function worldMapComUI:updateScrollChange(event)
	self:updateButtonMyCity()
end
function worldMapComUI:updateButtonMyCity(...)
	local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
	if nebulaAllStarCtrl:getIsViewer() then
		self.buttonMyCity:setVisible(false)
		return
	end
	if self.target_:getCurLod() >= worldMapDefine.worldLodDef.LOD2 then
		self.buttonMyCity:setVisible(true)
		return
	end
	local currentInMapViewCell = self.target_.currentInMapViewCell
	if self.myKindomID ~= currentInMapViewCell.kingdomID then
		if gKingdomClassType.remains ~= self.mapClassType and gKingdomClassType.newTrial ~= self.mapClassType then
			self.buttonMyCity:setVisible(true)
		else
			self.buttonMyCity:setVisible(false)
		end
		return
	elseif not worldMapDefine.isLegendLordKingdomID(currentInMapViewCell.kingdomID) then
		self.buttonMyCity:setVisible(false)
		return
	end
end
function worldMapComUI:getButtonWorldResouce(...)
	return self.buttonWorldResouce
end
function worldMapComUI:getButtonFavorite(...)
	return self.buttonFavorite
end
function worldMapComUI:getBottomPointNode(...)
	return self.bottomPointNode
end
function worldMapComUI:getCovertCenterTilePoint(...)
	return self.covertCenterTilePoint or cc.p(0, 0)
end
function worldMapComUI:exportMethods()
	_UPVALUE4_ = nil
	;(nil)[1] = "getButtonWorldResouce"
	;(nil)[2] = "getButtonFavorite"
	;(nil)[3] = "getBottomPointNode"
	;(nil)[4] = "getCovertCenterTilePoint"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComUI
