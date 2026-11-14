local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local worldMapDefine = include("worldMapDefine")
local nationalFlagRead = include("nationalFlagRead")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local worldResourceMap = class("worldResourceMap", function()
	local target = SoraDCreateBasePanel("worldResourceMap")
	include("worldResourceMapNormal").new(target)
	return target
end)
function worldResourceMap:onEnterPanel()
	self:loadImagesFinish()
end
function worldResourceMap:ctor()
	self.isHideCurrentSceneView = true
	self.mapKindomID = worldMapDefine.currentMapKindomID
	self.myKindomID = gametop.playertop_:getMapID()
	self:setContentSize(display.size)
	self.isMoved = false
	self.mySprite = nil
	self.leagueMembersArray, worldMapDefine, self.lorderSprite = self.setContentSize, self.setContentSize, nil
	self.cityPolygonPtArray, worldMapDefine, self.resourcePolygonPtArray, worldMapDefine, self.closeIconList, worldMapDefine, self.hasJoinAlliance = allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance(), allianceMgr:hasJoinAlliance()
	self.batchNode = nil
	self.leagueBuildLayer = nil
	self.leagueBuild = nil
	self.leaguePlaceBuild = cc.p(0, 0)
	self.leagueBuildArray, worldMapDefine, self.leaguePlaceHas = cc.p(0, 0), cc.p(0, 0), false
	self.isLeagueBuildShow = false
	self.wrathBeastNode = nil
	self.wrathBeastArray, worldMapDefine, self.isWrathBeastShow = worldMapDefine.btnWrathBeast, worldMapDefine.btnWrathBeast, worldMapDefine.btnWrathBeast
	self.endlessTrialNode = nil
	self.markNodeList, worldMapDefine, self.endlessTrialArray, worldMapDefine, self.isEndlessTrialShow = worldMapDefine.btnEndless, worldMapDefine.btnEndless, worldMapDefine.btnEndless, worldMapDefine.btnEndless, worldMapDefine.btnEndless
	self:initWidget()
	self:initData()
	self:initColorLayer()
	self:addCloudAction()
end
function worldResourceMap:initWidget(...)
	self:initScroll("worldResourceMap_Info")
	self:initTouchlayer()
	self:initBgArea()
	self:addResourcePoint(0, 150)
	self:addPolygonPoint(self.containerViewCenterPoint, 80, 50)
	self:createBorder()
	self.kingdomLabel = SoraDGetChildByName(self, "Text_kingDomName")
	self.kingdomLvLabel = SoraDGetChildByName(self, "Text_kingdomlv")
	self.kingdom_node = SoraDGetChildByName(self, "kingdom_node")
	self.kingLabel = SoraDGetChildByName(self, "Text_kingName")
	self.spriteKingdomFlag = SoraDGetChildByName(self, "Sprite_kingdomFlag")
	self.labProtect = SoraDGetChildByName(self, "Text_protect")
	self.labProtectTime = SoraDGetChildByName(self, "Text_protect_time")
	self.labProtectTime = SoraDCreateTimerLabel(self, self.labProtectTime)
	self.neighborNode = SoraDGetChildByName(self.containerView, "Node_neighbour")
	self.neighborNode:setLocalZOrder(11)
	_ENV = self.neighborNode.setLocalZOrder
	self.neighborNode.setLocalZOrder[1] = "Node_ru"
	self.neighborNode.setLocalZOrder[2] = "Node_rd"
	self.neighborNode.setLocalZOrder[3] = "Node_lu"
	self.neighborName, self.neighborNode.setLocalZOrder[4] = self.neighborNode.setLocalZOrder, "Node_ld"
	for k, v in ipairs(self.neighborName) do
		local btnNeighbor = self.neighborNode:getChildByName(v):getChildByName("Button_touch")
		btnNeighbor:setTag(k)
		btnNeighbor:addTouchEventListener(handler(self, self.btnNeighborCall))
	end
	local buttonWorldSever = SoraDGetChildByName(self, "Button_worldSever")
	if buttonWorldSever then
		buttonWorldSever:addTouchEventListener(handler(self, self.buttonWorldSeverCall))
	end
	local buttonBackWorld = SoraDGetChildByName(self, "Button_goBack")
	if buttonBackWorld then
		buttonBackWorld:addTouchEventListener(handler(self, self.buttonBackWorldCall))
	end
	self.Bottom_Node_left = SoraDGetChildByName(self, "Bottom_Node_left")
	local newNode = display.newNode()
	newNode:addTo(self.Bottom_Node_left)
	self.actionNode = newNode
	self.buttonControl = SoraDGetChildByName(self, "Button_control")
	self.buttonBg = SoraDGetChildByName(self.buttonControl, "btn_minimap_bg")
	self.buttonEye = SoraDGetChildByName(self.buttonControl, "btn_minimap_eye")
	self.buttonAct = SoraDGetChildByName(self.buttonControl, "btn_minimap_act")
	if self.buttonControl then
		self.buttonControl:addTouchEventListener(handler(self, self.buttonControlCall))
	end
	self.buttonResouce = SoraDGetChildByName(self, "Button_resouce")
	if self.buttonResouce then
		self.buttonResouce:addTouchEventListener(handler(self, self.buttonResouceCall))
	end
	local closeIcon = SoraDGetChildByName(self.buttonResouce, "Image_forbidden")
	table.insert(self.closeIconList, closeIcon)
	self.buttonLeague = SoraDGetChildByName(self, "Button_league")
	if self.buttonLeague then
		self.buttonLeague:addTouchEventListener(handler(self, self.buttonLeagueCall))
	end
	closeIcon:setVisible(false)
	local closeIcon = SoraDGetChildByName(self.buttonLeague, "Image_forbidden")
	table.insert(self.closeIconList, closeIcon)
	self.buttonTerritory = SoraDGetChildByName(self, "Button_alliance_territory")
	if self.buttonTerritory then
		self.buttonTerritory:addTouchEventListener(handler(self, self.buttonTerritoryCall))
	end
	local closeIcon = SoraDGetChildByName(self.buttonTerritory, "Image_forbidden")
	table.insert(self.closeIconList, closeIcon)
	self.buttonBeast = self.buttonLeague:clone()
	self.buttonBeast:addTo(self.buttonLeague:getParent())
	self.buttonBeast:addTouchEventListener(handler(self, self.buttonBeastCall))
	local closeIcon = SoraDGetChildByName(self.buttonBeast, "Image_forbidden")
	closeIcon:setVisible(false)
	table.insert(self.closeIconList, closeIcon)
	local spriteIcon = SoraDGetChildByName(self.buttonBeast, "Image_league")
	spriteIcon:setSpriteFrame("icon_godbeast_mapsite.png")
	spriteIcon:setScale(1.65)
	self.buttonBeast:setVisible(false)
	self.buttonEndless = self.buttonLeague:clone()
	self.buttonEndless:addTo(self.buttonLeague:getParent())
	self.buttonEndless:addTouchEventListener(handler(self, self.buttonEndlessCall))
	local closeIcon = SoraDGetChildByName(self.buttonEndless, "Image_forbidden")
	table.insert(self.closeIconList, closeIcon)
	local spriteIcon = SoraDGetChildByName(self.buttonEndless, "Image_league")
	spriteIcon:setSpriteFrame("position_snowmountain.png")
	spriteIcon:setScale(2)
	spriteIcon:setPosition(48, 53)
	_UPVALUE5_ = spriteIcon.setPosition
	self.actionBtnList, spriteIcon.setPosition[1] = spriteIcon.setPosition, self.buttonResouce
	self.actionBtnList, spriteIcon.setPosition[2] = spriteIcon.setPosition, self.buttonLeague
	self.actionBtnList, spriteIcon.setPosition[3] = spriteIcon.setPosition, self.buttonTerritory
	self.actionBtnList, spriteIcon.setPosition[4] = spriteIcon.setPosition, self.buttonBeast
	self.actionBtnList, spriteIcon.setPosition[5] = spriteIcon.setPosition, self.buttonEndless
	for i, v in ipairs(self.actionBtnList) do
		v:removeFromParent()
		v:addTo(self.actionNode)
		v:setTag(i)
	end
	local imgTitleBg = SoraDGetChildByName(self, "Top_Image_kingdom_Bg")
	if imgTitleBg then
		imgTitleBg:setPositionY(display.height - 60)
	end
	self.imgKingNameBg = SoraDGetChildByName(self, "Top_Image_king_bg")
	if self.imgKingNameBg then
		self.imgKingNameBg:setPositionY(display.height - 120)
	end
	self.imgProtectTimeBg = SoraDGetChildByName(self, "Top_Image_protect_bg")
	if self.imgProtectTimeBg then
		self.imgProtectTimeBg:setPositionY(display.height - 160)
	end
	self.imgKingNameBg:setVisible(false)
	self.imgProtectTimeBg:setVisible(false)
	self.Node_resources_tag = SoraDGetChildByName(self, "Node_resources_tag")
	self.Node_resources_tag:setLocalZOrder(12)
	for i = 1, 6 do
		local node_textInfo = SoraDGetChildByName(self.Node_resources_tag, "Node_resource" .. i)
		_ENV = handler(self, self.buttonEndlessCall)
		handler(self, self.buttonEndlessCall).preLv = i
		handler(self, self.buttonEndlessCall).nextLv = i + 2
		node_textInfo:getChildByName("Text_info"):setString(i18n("common_text_527", handler(self, self.buttonEndlessCall)))
	end
	self.resource_belt = SoraDGetChildByName(self, "resource_belt")
	self:setNodeInfoTitle()
end
function worldResourceMap:setNodeInfoTitle()
	_ENV = nil
	;(nil).Text_city = "common_text_496"
	;(nil).Text_lord = "common_text_526"
	;(nil).Text_alli = "common_text_180"
	;(nil).Text_alli_pet = "alliance_beast_text_31"
	;(nil).Text_territory_flag = "common_text_2903"
	local (nil).Text_territory_build, nodeInfoTable = "common_text_2902", nil
	self.nodeInfoView = SoraDGetChildByName(self, "Bottom_Node_Info")
	for k, v in pairs(nodeInfoTable) do
		local txtInfo = SoraDGetChildByName(self.nodeInfoView, k)
		if txtInfo then
			txtInfo:setString(i18n(v))
		end
	end
end
function worldResourceMap:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER", handler(self, self.moveSubPointToCenter))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LV_CHANGE", handler(self, self.sMsgKingdomLvChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function()
		self:setWrathBeastInfo()
		self:setEndlessTrialsInfo()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ALLIANCE_MARK_REFRESH", handler(self, self.refreshAllianceMark))
end
function worldResourceMap:initData()
	local isK, kingdomInfo = kingdomCtrl:isFoundKingdomID(self.mapKindomID)
	if self.mapKindomID == nil then
		self.mapKindomID = worldMapDefine.currentMapKindomID or 0
	end
	local kingdomName = i18n("common_text_479") .. "#" .. self.mapKindomID
	local kingName, flagId
	if isK then
		kingdomName = kingdomInfo.kname
		kingName = kingdomInfo.uname
		flagId = kingdomInfo.flagid
	end
	worldMapDefine.currentKingdomKing = kingName
	if not kingName then
		kingName = i18n("common_text_480")
		self.kingLabel:setString(kingName)
	end
	if flagId then
		local flagImg = nationalFlagRead.getImgByID(flagId)
		if flagImg then
			self.spriteKingdomFlag:setSpriteFrame(flagImg)
		else
			self.spriteKingdomFlag:setVisible(false)
		end
	end
	self.kingdomLabel:setString(kingdomName)
	kingdomCtrl = self.kingdomLabel.setString
	self.kingdomLabel.setString.x = 600
	self.coordinate, self.kingdomLabel.setString.y = self.kingdomLabel.setString, 604
	self:updateKingdomLv()
	self.isButtonControlOpen = worldMapDefine.btnControlState
	self.isResourceShow = false
	self.resourceInfoArray, kingdomCtrl, self.scaleCtrlBg = worldMapDefine.btnControlState, worldMapDefine.btnControlState, 1
	for i = 1, 6 do
		local resoureName = "Node_resource" .. i
		local resourceInfo = SoraDGetChildByName(self.containerView, resoureName)
		resourceInfo:setVisible(self.isResourceShow)
		table.insert(self.resourceInfoArray, resourceInfo)
	end
	self:setResourceInfo()
	if not self.hasJoinAlliance then
		self.buttonLeague:setVisible(false)
		self.buttonTerritory:setVisible(false)
		self.scaleCtrlBg = 0.5
	end
	self.isLeagueShow = worldMapDefine.btnLeagueState
	self.isTerritoryShow = worldMapDefine.btnTerritory
	self.closeIconList[self.buttonTerritory:getTag()]:setVisible(not self.isTerritoryShow)
	if worldMapDefine.currentKingdomKing then
		self.imgKingNameBg:setVisible(true)
		kingdomCtrl = "Node_resource" .. i
		;("Node_resource" .. i).kingName = worldMapDefine.currentKingdomKing
		self.kingLabel:setString(i18n("common_text_529", "Node_resource" .. i))
		local bg_width = self.imgKingNameBg:getContentSize().width
		local king_width = 0.3 * self.spriteKingdomFlag:getContentSize().width + self.kingLabel:getContentSize().width
		local d_width = bg_width - king_width
		local posX_left = d_width / 3 + 0.3 * self.spriteKingdomFlag:getContentSize().width
		local posX_right = bg_width - d_width / 3 - self.kingLabel:getContentSize().width
		self.spriteKingdomFlag:setPositionX(posX_left)
		self.kingLabel:setPositionX(posX_right)
		if not SoraDFIsRA() then
			posX_left = bg_width - d_width / 3 - 0.3 * self.spriteKingdomFlag:getContentSize().width
			posX_right = d_width / 3 + self.kingLabel:getContentSize().width
			self.spriteKingdomFlag:setPositionX(posX_left)
			self.kingLabel:setPositionX(posX_right)
		end
	end
	local warStatus = kingdomMapCtrl:getWarStatus() or worldMapDefine.kingWarStatus
	local showWarStatusTime = kingdomMapCtrl:isShowWarStatusTime()
	print("warStatus=", warStatus, ",showWarStatusTime=", showWarStatusTime)
	if showWarStatusTime and warStatus then
		kingdomMapCtrl:reqRefreshKingdomWarTime()
		local warTime = kingdomMapCtrl:getWarStatusTime()
		if 0 < warTime then
			self.imgKingNameBg:setVisible(false)
			self.imgProtectTimeBg:setVisible(true)
			self.labProtectTime:beginTime(warTime)
		else
			self.imgProtectTimeBg:setVisible(false)
		end
		if warStatus == gKingdomWarStatusType.close then
			self.imgKingNameBg:setVisible(false)
			self.labProtect:setString(i18n("common_text_1215"))
			self.labProtect:setColor(cc.c3b(0, 200, 0))
		elseif warStatus == gKingdomWarStatusType.inWar then
			self.imgKingNameBg:setVisible(worldMapDefine.currentKingdomKing ~= nil)
			self.labProtect:setString(i18n("common_text_1214"))
			self.labProtect:setColor(cc.c3b(200, 0, 0))
		elseif warStatus == gKingdomWarStatusType.rule then
			self.imgKingNameBg:setVisible(worldMapDefine.currentKingdomKing ~= nil)
			self.labProtect:setString(i18n("common_text_1213"))
			self.labProtect:setColor(cc.c3b(0, 200, 0))
		end
		local bg_width = self.imgProtectTimeBg:getContentSize().width
		local protect_width = self.labProtectTime:getContentSize().width + self.labProtect:getContentSize().width
		local d_width = bg_width - protect_width
		local posX_left = d_width / 3 + self.labProtectTime:getContentSize().width
		local posX_right = bg_width - d_width / 3 - self.labProtect:getContentSize().width
		self.labProtectTime:setPositionX(posX_left)
		self.labProtect:setPositionX(posX_right)
		if not SoraDFIsRA() then
			posX_left = bg_width - d_width / 3 - self.labProtectTime:getContentSize().width
			posX_right = d_width / 3 + self.labProtect:getContentSize().width
			self.labProtectTime:setPositionX(posX_left)
			self.labProtect:setPositionX(posX_right)
		end
	else
		self.imgKingNameBg:setVisible(false)
		self.imgProtectTimeBg:setVisible(false)
	end
	if self.mapKindomID ~= self.myKindomID then
		self.buttonLeague:setVisible(false)
		self.buttonTerritory:setVisible(false)
		self.scaleCtrlBg = 0.5
		self.imgKingNameBg:setVisible(false)
		self.imgProtectTimeBg:setVisible(false)
	end
	self:updateBtnPosition()
	self:setBtnControlInfo()
	self:refreshNeighborNodeInfo()
	self:updateLeagueBuild()
	self:refreshAllianceMark()
end
function worldResourceMap:updateKingdomLv()
	local curKingdomLv = kingdomCtrl:getKingdomLevel(self.mapKindomID)
	if curKingdomLv and 1 <= curKingdomLv then
		kingdomCtrl = nil
		;(nil).lv = curKingdomLv
		self.kingdomLvLabel:setString(i18n("common_text_100", nil))
		self.kingdomLvLabel:addTouchEventListener(handler(self, self.onCoordinate))
		local myKindomID = gametop.playertop_:getMapID()
		if self.mapKindomID == myKindomID then
			SoraDDrawTextUnderLine(self.kingdomLvLabel, cc.c4b(255, 200, 100, 255), 2)
		else
			SoraDHideTextUnderLine(self.kingdomLvLabel, false)
		end
		self.kingdomLvLabel:setVisible(true)
		SoraDToCenter(self.kingdom_node, 5, SoraDFIsRA())
	else
		self.kingdomLvLabel:setVisible(false)
		SoraDToCenter(self.kingdom_node, 5, SoraDFIsRA())
	end
end
function worldResourceMap:viewOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		local touchEndPoint = self.touchlayer:getTouchEndPosition()
		print("touchPoint:" .. touchEndPoint.x, touchEndPoint.y)
		local covertPoint = self.touchlayer:convertToNodeSpace(touchEndPoint)
		print("coverPoint:" .. covertPoint.x, covertPoint.y)
		if not self.isMoved then
			SoraDPlaySound()
			print(SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint))
			if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
				if self.mySprite and cc.rectContainsPoint(self.mySprite:getCascadeBoundingBox(), touchEndPoint) then
					local x, y = self.mySprite:getPosition()
					covertPoint = cc.p(x, y)
				elseif self.lorderSprite and cc.rectContainsPoint(self.lorderSprite:getCascadeBoundingBox(), touchEndPoint) then
					local x, y = self.lorderSprite:getPosition()
					covertPoint = cc.p(x, y)
				else
					local isTouchInMember = false
					_ENV, _ENV = cc.p(x, y), self.lorderSprite:getPosition()
					cc.p(x, y).isShow = self.isLeagueShow
					_ENV, self.lorderSprite:getPosition()[1], cc.p(x, y).array = cc.p(x, y), cc.p(x, y), self.leagueMembersArray
					cc.p(x, y).isShow = self.isLeagueBuildShow
					_ENV, self.lorderSprite:getPosition()[2], cc.p(x, y).array = cc.p(x, y), cc.p(x, y), self.leagueBuildArray
					cc.p(x, y).isShow = self.isWrathBeastShow
					_ENV, self.lorderSprite:getPosition()[3], cc.p(x, y).array = cc.p(x, y), cc.p(x, y), self.wrathBeastArray
					cc.p(x, y).isShow = self.isEndlessTrialShow
					self.lorderSprite:getPosition()[4], cc.p(x, y).array = cc.p(x, y), self.endlessTrialArray
					local tab = self.lorderSprite:getPosition()
					for i, v in ipairs(tab) do
						if v.isShow then
							for k, w in pairs(v.array) do
								if cc.rectContainsPoint(w:getCascadeBoundingBox(), touchEndPoint) then
									local x, y = w:getPosition()
									covertPoint = cc.p(x, y)
									isTouchInMember = true
									break
								end
							end
						end
					end
					if not isTouchInMember then
						local cityPolygon = self.cityPolygonPtArray[1]
						if SorDIsPointInPolygon(cityPolygon.cityPolygonPtArray, covertPoint) then
							covertPoint = cityPolygon.point
						end
					end
				end
				local subPoint = cc.pSub(self.containerViewCenterPoint, covertPoint)
				local ratio = worldMapDefine.worldMapViewSize.width / worldMapDefine.worldResourceMapSize.width
				subPoint = cc.p(subPoint.x * ratio, subPoint.y * ratio)
				_ENV = subPoint.x * ratio
				;(subPoint.x * ratio).msg = "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT"
				;(subPoint.x * ratio).subPoint = subPoint
				;(subPoint.x * ratio).kingdomID = self.mapKindomID
				SoraDSendMessage(subPoint.x * ratio)
				SoraDShowLoading()
				self:showJumpAction(covertPoint, function()
					SoraCollectgarbage(self.__cname)
					SorDCloseWordResourceMap()
					SoraDCloseLoading()
				end)
			end
		end
		self.isMoved = false
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = self.touchlayer:getTouchBeganPosition()
		local touchmovePoint = self.touchlayer:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	end
end
function worldResourceMap:buttonWorldSeverCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local worldMapView = worldMapDefine.getWorldMapView()
		local worldMapCell = worldMapView:getCurrentInMapViewCell()
		local kid = worldMapCell:getKingdomID()
		local regionId
		if 0 < kid then
			local __, rId = nebulaActivityCtrl:getKingdomRegionType(kid)
			regionId = rId
		else
			regionId = worldMapCell:getRegionId()
		end
		local regionType = nebulaActivityCtrl:getRegionTypeByRegionId(regionId)
		_ENV = nil
		;(nil).regionType = regionType
		;(nil).regionId = regionId
		uiManager:show("BigWorldView", nil)
	end
end
function worldResourceMap:buttonBackWorldCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraCollectgarbage(self.__cname)
		SorDCloseWordResourceMap()
	end
end
function worldResourceMap:buttonControlCall(button, type)
	if type == ccui.TouchEventType.ended then
		self.isButtonControlOpen = not self.isButtonControlOpen
		self.buttonControl:setTouchEnabled(false)
		self:setBtnControlInfo()
		worldMapDefine.btnControlState = self.isButtonControlOpen
	end
end
function worldResourceMap:setBtnControlInfo(isFirst)
	local buttonImgName = "btn_minimap_02.png"
	if not self.isButtonControlOpen then
		buttonImgName = "btn_minimap_05.png"
	end
	if not self.isButtonControlOpen then
		if not worldMapDefine.btnControlState then
			self.actionNode:setScale(0)
			self.buttonEye:setSpriteFrame(buttonImgName)
			self.buttonAct:setRotation(0)
		else
			worldMapDefine = cc.ScaleTo
			cc.ScaleTo.easing = "BACKIN"
			function cc.ScaleTo.onComplete()
				self.buttonEye:setSpriteFrame(buttonImgName)
				self.buttonControl:setTouchEnabled(true)
			end
			transition.execute(self.actionNode, cc.ScaleTo:create(0.5, 0), cc.ScaleTo)
			self.buttonAct:runAction(cca.rotateTo(0.5, 0))
			self.buttonBg:runAction(cca.rotateTo(0.5, 0))
		end
	else
		self.buttonEye:setSpriteFrame(buttonImgName)
		self.buttonAct:setRotation(0)
		self.buttonAct:runAction(cca.rotateTo(0.5, 45))
		self.buttonBg:setRotation(0)
		self.buttonBg:runAction(cca.rotateTo(0.5, -45))
		worldMapDefine = cc.ScaleTo
		cc.ScaleTo.easing = "BACKOUT"
		function cc.ScaleTo.onComplete()
			self.buttonControl:setTouchEnabled(true)
		end
		transition.execute(self.actionNode, cc.ScaleTo:create(0.5, 1), cc.ScaleTo)
	end
end
function worldResourceMap:buttonResouceCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isResourceShow = not self.isResourceShow
		self:setResourceInfo()
	end
end
function worldResourceMap:buttonLeagueCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isLeagueShow = not self.isLeagueShow
		self:setLeagueInfo(button)
		worldMapDefine.btnLeagueState = self.isLeagueShow
	end
end
function worldResourceMap:buttonTerritoryCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isTerritoryShow = not self.isTerritoryShow
		worldMapDefine.btnTerritory = self.isTerritoryShow
		self.closeIconList[button:getTag()]:setVisible(not self.isTerritoryShow)
		self:updateLeagueBuild()
	end
end
function worldResourceMap:setResourceInfo()
	self.closeIconList[self.buttonResouce:getTag()]:setVisible(not self.isResourceShow)
	if self.isResourceShow then
		self:moveMapPointToCenter(cc.p(1200, 750))
	end
	self.resource_belt:setVisible(self.isResourceShow)
	for k, v in ipairs(self.resourceInfoArray) do
		_ENV = cc.DelayTime
		cc.DelayTime.delay = 0.15 * k
		function cc.DelayTime.onComplete()
			v:setVisible(self.isResourceShow)
		end
		transition.execute(v, cc.DelayTime:create(0.2), cc.DelayTime)
	end
end
function worldResourceMap:setLeagueInfo(fromTarget)
	if not permissionCtrl:hasPlayerPermission(gAPermission.VIEW_MEMBER_POS) then
		if fromTarget then
			permissionCtrl = nil
			;(nil).des = i18n("common_text_2375")
			SoraDShowMsgTip(i18n("common_text_2371", nil), nil, fromTarget)
		end
		self.isLeagueShow = false
	end
	self.closeIconList[self.buttonLeague:getTag()]:setVisible(not self.isLeagueShow)
	for k, v in pairs(self.leagueMembersArray) do
		v:setVisible(self.isLeagueShow)
		if self.mapKindomID ~= self.myKindomID then
			v:setVisible(false)
		end
	end
	if self.lorderSprite then
		self.lorderSprite:setVisible(self.isLeagueShow)
		if self.mapKindomID ~= self.myKindomID then
			self.lorderSprite:setVisible(false)
		end
	end
	if self.mySprite then
		self.mySprite:setVisible(self.mapKindomID == self.myKindomID)
	end
	if self.node_arrow then
		self.node_arrow:setVisible(self.mapKindomID == worldMapDefine.currentMapKindomID)
	end
end
function worldResourceMap:setLeagueMembersInfo(memberArray)
	self.batchNode = display.newBatchNode(getImageFileNameByPlatform("worldMap/worldMapUI"), #memberArray)
	self.batchNode:addTo(self.containerView, 9)
	for _, v in pairs(memberArray) do
		local memberSprite
		local scale = 0.6
		if v.memberType == gWorldResourceMapPlayerType.youSelf then
			memberSprite = display.newSprite("#position_city.png")
			self.mySprite = memberSprite
			if self.mapKindomID ~= self.myKindomID then
				self.mySprite:setVisible(false)
			end
		elseif v.memberType == gWorldResourceMapPlayerType.leader then
			memberSprite = display.newSprite("#position_lord.png")
			self.lorderSprite = memberSprite
		elseif v.memberType == gWorldResourceMapPlayerType.other then
			memberSprite = display.newSprite("#position_alli.png")
			memberSprite:setVisible(self.isLeagueShow)
			table.insert(self.leagueMembersArray, memberSprite)
			scale = 1.5
		end
		local point = cc.pSub(self.containerViewCenterPoint, cc.p(v.x, v.y))
		memberSprite:setAnchorPoint(cc.p(0.5, 0.1))
		memberSprite:setPosition(point)
		memberSprite:setScale(scale)
		memberSprite:addTo(self.batchNode)
	end
	self:setLeagueInfo()
end
function worldResourceMap:btnNeighborCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		local worldMapView = worldMapDefine.getWorldMapView()
		local worldMapCell = worldMapView:getCurrentInMapViewCell()
		local pos = worldMapCell:getKingdomPoint()
		local width = self.containerView:getContentSize().width
		local height = self.containerView:getContentSize().height
		local d_width = worldMapDefine.worldResourceMapSize.width
		local d_height = worldMapDefine.worldResourceMapSize.height
		local zoomScale = self.viewScrollView:getZoomScale()
		local kid = 0
		local dt_w = 250
		local dt_h = 125
		local centerHeight = (display.height - height) * zoomScale / 2
		local centerWidth = (display.width - width) * zoomScale / 2
		local moveOffset = cc.p(0, 0)
		local newOffset = cc.p(0, 0)
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local regionId = worldMapCell:getRegionId()
		if tag == 4 then
			kid = kingdomPointDefine.getKingdomIDWithPoint(cc.p(pos.x, pos.y + 1), regionId)
			moveOffset = cc.p(centerWidth * 2 + dt_w * zoomScale, centerHeight - dt_h * zoomScale)
			newOffset = cc.p(moveOffset.x + d_width / 2, moveOffset.y + d_height / 2)
		elseif tag == 2 then
			kid = kingdomPointDefine.getKingdomIDWithPoint(cc.p(pos.x + 1, pos.y), regionId)
			moveOffset = cc.p(-dt_w * zoomScale, centerHeight - dt_h * zoomScale)
			newOffset = cc.p(moveOffset.x - d_width / 2, moveOffset.y + d_height / 2)
		elseif tag == 3 then
			kid = kingdomPointDefine.getKingdomIDWithPoint(cc.p(pos.x - 1, pos.y), regionId)
			moveOffset = cc.p(centerWidth * 2 + dt_w * zoomScale, centerHeight + dt_h * zoomScale)
			newOffset = cc.p(moveOffset.x + d_width / 2, moveOffset.y - d_height / 2)
		elseif tag == 1 then
			kid = kingdomPointDefine.getKingdomIDWithPoint(cc.p(pos.x, pos.y - 1), regionId)
			moveOffset = cc.p(-dt_w * zoomScale, centerHeight + dt_h * zoomScale)
			newOffset = cc.p(moveOffset.x - d_width / 2, moveOffset.y - d_height / 2)
		end
		local isK, kInfo = kingdomCtrl:isFoundKingdomID(kid)
		if not isK then
			self:refreshNeighborNodeInfo()
			return
		end
		local goTokingdom = function()
			self.mapKindomID = kid
			newOffset = nil
			;(nil)[1] = cca.callFunc(function()
				self.viewScrollView:setContentOffsetInDuration(newOffset, 0.8)
			end)
			;(nil)[2] = cca.delay(1)
			;(nil)[3] = cca.callFunc(function()
				self.viewScrollView:setContentOffset(moveOffset)
			end)
			;(nil)[4] = cca.callFunc(function()
				worldMapDefine.currentMapKindomID = self.mapKindomID
				self:initData()
				self:setLeagueInfo()
			end)
			;(nil)[5] = cca.callFunc(function()
				worldMapDefine.currentMapKindomID = self.mapKindomID
				self:initData()
				self:setLeagueInfo()
			end)
			local seq = cca.seq(nil)
			self:runAction(seq)
		end
		_ENV = nil
		;(nil).kingdom = kInfo.kname
		SoraDShowMsgBox(i18n("common_text_2071", nil), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				goTokingdom()
			end
		end, nil, 1)
	end
end
function worldResourceMap:refreshKingdomNodeInfo(target, kID)
	local isK, kInfo = kingdomCtrl:isFoundKingdomID(kID)
	target:setVisible(isK)
	if isK then
		SoraDGetChildByName(target, "Text_kName"):setString(kInfo.kname)
		local isFlag = kInfo.uname ~= nil
		SoraDGetChildByName(target, "Nationalflag"):setVisible(isFlag)
		if isFlag then
			local flagImg = nationalFlagRead.getImgByID(kInfo.flagid)
			if flagImg then
				SoraDGetChildByName(target, "Nationalflag"):setSpriteFrame(flagImg)
			end
		end
	end
end
function worldResourceMap:refreshNeighborNodeInfo()
	local Node_ru = self.neighborNode:getChildByName("Node_ru")
	local Node_lu = self.neighborNode:getChildByName("Node_lu")
	local Node_rd = self.neighborNode:getChildByName("Node_rd")
	local Node_ld = self.neighborNode:getChildByName("Node_ld")
	local worldMapView = worldMapDefine.getWorldMapView()
	local worldMapCell = worldMapView:getCurrentInMapViewCell()
	local upID, downID, leftID, rightID = kingdomPointDefine.getNeighbourKingdomsByPoint(worldMapCell:getKingdomPoint(), worldMapCell:getRegionId())
	self:refreshKingdomNodeInfo(Node_ru, downID)
	self:refreshKingdomNodeInfo(Node_lu, leftID)
	self:refreshKingdomNodeInfo(Node_rd, rightID)
	self:refreshKingdomNodeInfo(Node_ld, upID)
end
function worldResourceMap:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_resouce" then
		self:buttonResouceCall(nil, ccui.TouchEventType.ended)
		return nil
	else
		return SoraDGetChildByName(self, itemName)
	end
end
function worldResourceMap:updateLeagueBuild()
	local bShow = false
	if self.isTerritoryShow and self.hasJoinAlliance and self.mapKindomID == self.myKindomID then
		bShow = true
	end
	self.isLeagueBuildShow = bShow
	if bShow then
		if self.leagueBuildLayer then
			self.leagueBuildLayer:setVisible(true)
		else
			self:setLeagueBuildInfo()
		end
	elseif self.leagueBuildLayer then
		self.leagueBuildLayer:setVisible(false)
	end
end
function worldResourceMap:setLeagueBuildInfo()
	local mainBuilding = allianceTerritoryAPI:getAllBuildingPos()
	if not mainBuilding or not next(mainBuilding) then
		return
	end
	self.leaguePlaceBuild = cc.p(0, 0)
	self.leagueBuildLayer = display.newNode()
	self.leagueBuildLayer:addTo(self.containerView, 8)
	self.leagueBuild = display.newNode()
	self.leagueBuild:addTo(self.leagueBuildLayer, -1)
	self:addLeagueMainBuild(mainBuilding)
	self:addLeagueBuildEffect(mainBuilding)
	self:addLeagueFlagBuild(mainBuilding)
end
function worldResourceMap:addLeagueMainBuild(mainBuilding)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	for k, v in pairs(mainBuilding) do
		if v.pos then
			local buildSprite
			if v.bid ~= gAllianceBuilding.FLAG then
				if v.bid == gAllianceBuilding.PALACE or v.bid == gAllianceBuilding.PRIMARY_PALACE then
					buildSprite = display.newSprite("#icon_alliance_territory_build.png")
					buildSprite:setScale(0.6)
				elseif v.bid == gAllianceBuilding.ALTAR then
					buildSprite = display.newSprite("#icon_alliance_territory_altar.png")
					buildSprite:setScale(0.6)
				end
				if buildSprite then
					local tilePoint = v.pos
					local pos = worldMapView:getPointWithTile(tilePoint)
					local subPt = cc.pSub(worldMapView.mapViewCenterPoint, pos)
					local x = subPt.x * ratio
					local y = subPt.y * ratio
					local point = cc.pSub(self.containerViewCenterPoint, cc.p(x, y))
					buildSprite:setAnchorPoint(cc.p(0.5, 0.25))
					buildSprite:setPosition(point)
					buildSprite:addTo(self.leagueBuildLayer, 100 - v.bid)
					if v.bid == gAllianceBuilding.PALACE then
						self.leaguePlaceBuild = point
						self.leaguePlaceHas = true
						self.leagueBuild:setPosition(self.leaguePlaceBuild)
					elseif v.bid == gAllianceBuilding.ALTAR then
					end
					table.insert(self.leagueBuildArray, buildSprite)
				end
			end
		end
	end
end
function worldResourceMap:addLeagueFlagBuild(mainBuilding)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	for k, v in pairs(mainBuilding) do
		if v.pos then
			local buildSprite
			if v.bid == gAllianceBuilding.FLAG then
				buildSprite = display.newSprite("#icon_alliance_territory_flag_03.png")
				local tilePoint = v.pos
				local pos = worldMapView:getPointWithTile(tilePoint)
				local subPt = cc.pSub(worldMapView.mapViewCenterPoint, pos)
				local x = subPt.x * ratio
				local y = subPt.y * ratio
				local point = cc.pSub(self.containerViewCenterPoint, cc.p(x, y))
				point = cc.pSub(point, self.leaguePlaceBuild)
				buildSprite:setAnchorPoint(cc.p(0.5, 0.1))
				buildSprite:setPosition(point)
				buildSprite:addTo(self.leagueBuild, 100 - v.bid)
				buildSprite:setOpacity(128)
				buildSprite:setScale(0.15)
				if self.leaguePlaceHas and (not self.pointsArray or SoraDIsPointInPolygonAll(point, self.pointsArray)) then
					worldMapDefine = point
					point[1] = cca.moveTo(0, point.x, point.y)
					point[2] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					point[3] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					point[4] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					point[5] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					point[6] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					point[7] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					point[8] = cca.moveTo(3.0, point.x * 7, point.y * 7)
					local seq_move = cca.seq(point)
					_UPVALUE2_ = cca.moveTo(0, point.x, point.y)
					cca.moveTo(0, point.x, point.y)[1] = cca.fadeTo(0, 0.75)
					cca.moveTo(0, point.x, point.y)[2] = cca.delay(2.0)
					cca.moveTo(0, point.x, point.y)[3] = cca.fadeTo(1.0, 0.25)
					cca.moveTo(0, point.x, point.y)[4] = cca.fadeTo(1.0, 0.25)
					cca.moveTo(0, point.x, point.y)[5] = cca.fadeTo(1.0, 0.25)
					cca.moveTo(0, point.x, point.y)[6] = cca.fadeTo(1.0, 0.25)
					cca.moveTo(0, point.x, point.y)[7] = cca.fadeTo(1.0, 0.25)
					local seq_fade = cca.seq((cca.moveTo(0, point.x, point.y)))
					worldMapDefine = cca.fadeTo(0, 0.75)
					cca.fadeTo(0, 0.75)[1] = cca.scaleTo(0, 0.15)
					cca.fadeTo(0, 0.75)[2] = cca.scaleTo(3.0, 0.5)
					cca.fadeTo(0, 0.75)[3] = cca.scaleTo(3.0, 0.5)
					cca.fadeTo(0, 0.75)[4] = cca.scaleTo(3.0, 0.5)
					cca.fadeTo(0, 0.75)[5] = cca.scaleTo(3.0, 0.5)
					cca.fadeTo(0, 0.75)[6] = cca.scaleTo(3.0, 0.5)
					local seq_scale = cca.seq((cca.fadeTo(0, 0.75)))
					_ENV = cca.scaleTo(0, 0.15)
					_UPVALUE3_ = cca.scaleTo(3.0, 0.5)
					cca.scaleTo(3.0, 0.5)[1] = seq_move
					cca.scaleTo(3.0, 0.5)[2] = seq_fade
					cca.scaleTo(3.0, 0.5)[3] = seq_scale
					cca.scaleTo(0, 0.15)[1] = cca.spawn(cca.scaleTo(3.0, 0.5))
					cca.scaleTo(0, 0.15)[2] = cca.spawn(cca.scaleTo(3.0, 0.5))
					cca.scaleTo(0, 0.15)[3] = cca.spawn(cca.scaleTo(3.0, 0.5))
					cca.scaleTo(0, 0.15)[4] = cca.spawn(cca.scaleTo(3.0, 0.5))
					cca.scaleTo(0, 0.15)[5] = cca.spawn(cca.scaleTo(3.0, 0.5))
					local seq_action = cca.seq((cca.scaleTo(0, 0.15)))
					buildSprite:runAction(cc.RepeatForever:create(seq_action))
				end
			end
		end
	end
end
function worldResourceMap:addLeagueBuildEffect(mainBuilding)
	local pointsArrayAll = self:getLeagueBuildPos(mainBuilding)
	if not pointsArrayAll or not next(pointsArrayAll) then
		return
	end
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	for k, pointsArray in ipairs(pointsArrayAll) do
		for i, v in ipairs(pointsArray) do
			local worldPoint = worldMapView:getPointWithTile(v)
			local subPt = cc.pSub(worldMapView.mapViewCenterPoint, worldPoint)
			local point = cc.p(subPt.x * ratio, subPt.y * ratio)
			point = cc.pSub(self.containerViewCenterPoint, point)
			point = cc.pSub(point, self.leaguePlaceBuild)
			v.x = point.x
			v.y = point.y
		end
	end
	self.pointsArray = nil
	for k, pointsArray in ipairs(pointsArrayAll) do
		local bAction = true
		if 1 < #pointsArrayAll then
			bAction = SoraDIsPointInPolygonAll(cc.p(0, 0), pointsArray)
			print("bAction", bAction)
			if bAction then
				self.pointsArray = pointsArray
			end
		end
		self:addLeagueBuildEffectBySignle(pointsArray, bAction)
	end
end
function worldResourceMap:addLeagueBuildEffectBySignle(pointsArray, bAction)
	local node = display.newNode()
	for i, v in ipairs(pointsArray) do
		local point1 = v
		local point2 = v
		if i == #pointsArray then
			point2 = pointsArray[1]
		end
		if i < #pointsArray then
			point2 = pointsArray[i + 1]
		end
		local distance = cc.pGetDistance(point1, point2) + 0.5
		local rotation = -SoraDGetAngleByPos(point1, point2)
		local line = display.newTilesSprite("SinglePicture/leagueLine1.png", cc.rect(0, 0, distance, 16))
		line:setScaleY(0.125)
		line:setAnchorPoint(cc.p(0.0, 0.5))
		line:setPosition(point1)
		line:setRotation(rotation)
		line:setColor(cc.c3b(0, 150, 250))
		line:addTo(node)
	end
	node:setCascadeOpacityEnabled(true)
	node:addTo(self.leagueBuild)
	if bAction and self.leaguePlaceHas then
		_UPVALUE1_ = node
		node[1] = cca.scaleTo(0, 1)
		node[2] = cca.scaleTo(3.0, 7.0)
		node[3] = cca.scaleTo(3.0, 7.0)
		node[4] = cca.scaleTo(3.0, 7.0)
		node[5] = cca.scaleTo(3.0, 7.0)
		node[6] = cca.scaleTo(3.0, 7.0)
		node[7] = cca.scaleTo(3.0, 7.0)
		node[8] = cca.scaleTo(3.0, 7.0)
		node[9] = cca.scaleTo(3.0, 7.0)
		node[10] = cca.scaleTo(3.0, 7.0)
		node[11] = cca.scaleTo(3.0, 7.0)
		node[12] = cca.scaleTo(3.0, 7.0)
		node[13] = cca.scaleTo(3.0, 7.0)
		node[14] = cca.scaleTo(3.0, 7.0)
		local seq_scale = cca.seq(node)
		_UPVALUE1_ = cca.scaleTo(0, 1)
		cca.scaleTo(0, 1)[1] = cca.fadeTo(0, 1.0)
		cca.scaleTo(0, 1)[2] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[3] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[4] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[5] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[6] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[7] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[8] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[9] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[10] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[11] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[12] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[13] = cca.fadeTo(3.0, 0.75)
		local seq_fade = cca.seq((cca.scaleTo(0, 1)))
		_ENV = cca.fadeTo(0, 1.0)
		_UPVALUE2_ = cca.fadeTo(3.0, 0.75)
		cca.fadeTo(3.0, 0.75)[1] = seq_scale
		cca.fadeTo(3.0, 0.75)[2] = seq_fade
		cca.fadeTo(0, 1.0)[1] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[2] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[3] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[4] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[5] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[6] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[7] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[8] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[9] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[10] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[11] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[12] = cca.spawn(cca.fadeTo(3.0, 0.75))
		local seq_action = cca.seq((cca.fadeTo(0, 1.0)))
		node:runAction(cc.RepeatForever:create(seq_action))
	end
end
function worldResourceMap:addLeagueBuildRect(v)
	local node = display.newNode()
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	local calcPos = function(pos)
		local worldPoint = worldMapView:getPointWithTile(pos)
		local subPt = cc.pSub(worldMapView.mapViewCenterPoint, worldPoint)
		local point = cc.p(subPt.x * ratio, subPt.y * ratio)
		point = cc.pSub(self.containerViewCenterPoint, point)
		point = cc.pSub(point, self.leaguePlaceBuild)
		return point
	end
	local point1 = calcPos(cc.p(v[1], v[2]))
	local point2 = calcPos(cc.p(v[1] + v[3], v[2]))
	local point3 = calcPos(cc.p(v[1] + v[3], v[2] + v[4]))
	local point4 = calcPos(cc.p(v[1], v[2] + v[4]))
	_UPVALUE2_, _UPVALUE2_ = cc.p(v[1], v[2] + v[4])
	_UPVALUE2_, cc.p(v[1], v[2] + v[4])[1] = point1.x, point1.x
	_UPVALUE2_, cc.p(v[1], v[2] + v[4])[2] = point1.x, point1.y
	point1.x[1] = point3.x
	point1.x[2] = point3.y
	_ENV, cc.p(v[1], v[2] + v[4])[1] = cc.p(v[1], v[2] + v[4])
	_ENV, cc.p(v[1], v[2] + v[4])[2] = cc.p(v[1], v[2] + v[4])
	cc.p(v[1], v[2] + v[4]).borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0)
	cc.p(v[1], v[2] + v[4]).borderWidth = 1
	do
		local line1 = display.newLine(cc.p(v[1], v[2] + v[4]))
		line1:addTo(node)
	end
	_UPVALUE2_, _UPVALUE2_ = line1, line1.addTo
	_UPVALUE2_, line1[1] = point2.x, point2.x
	_UPVALUE2_, line1[2] = point2.x, point2.y
	point2.x[1] = point4.x
	point2.x[2] = point4.y
	_ENV, line1.addTo[1] = line1, line1
	_ENV, line1.addTo[2] = line1, point2.x
	line1.borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0)
	line1.borderWidth = 1
	do
		local line1 = display.newLine(line1.addTo, line1)
		line1:addTo(node)
	end
	node:setCascadeOpacityEnabled(true)
	node:addTo(self.leagueBuild)
	if self.leaguePlaceHas then
		worldMapDefine = node
		node[1] = cca.scaleTo(0, 1)
		node[2] = cca.scaleTo(3.0, 7.0)
		node[3] = cca.scaleTo(3.0, 7.0)
		node[4] = cca.scaleTo(3.0, 7.0)
		node[5] = cca.scaleTo(3.0, 7.0)
		node[6] = cca.scaleTo(3.0, 7.0)
		local seq_scale = cca.seq(node)
		worldMapDefine = cca.scaleTo(0, 1)
		cca.scaleTo(0, 1)[1] = cca.fadeTo(0, 1.0)
		cca.scaleTo(0, 1)[2] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[3] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[4] = cca.fadeTo(3.0, 0.75)
		cca.scaleTo(0, 1)[5] = cca.fadeTo(3.0, 0.75)
		local seq_fade = cca.seq((cca.scaleTo(0, 1)))
		_ENV = cca.fadeTo(0, 1.0)
		_UPVALUE2_ = cca.fadeTo(3.0, 0.75)
		cca.fadeTo(3.0, 0.75)[1] = seq_scale
		cca.fadeTo(3.0, 0.75)[2] = seq_fade
		cca.fadeTo(0, 1.0)[1] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[2] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[3] = cca.spawn(cca.fadeTo(3.0, 0.75))
		cca.fadeTo(0, 1.0)[4] = cca.spawn(cca.fadeTo(3.0, 0.75))
		local seq_action = cca.seq((cca.fadeTo(0, 1.0)))
		node:runAction(cc.RepeatForever:create(seq_action))
	end
end
function worldResourceMap:getLeagueBuildPos(mainBuildingPos)
	local _ENV, manorDataArrary
	for k, v in pairs(mainBuildingPos) do
		local allianceBuildType = v.bid
		local allianceBuildInfo = worldMapDefine.getAllianceBuildInfo(allianceBuildType)
		local size = 1
		local radioation = 2
		if allianceBuildInfo then
			size = allianceBuildInfo.size
			radioation = allianceBuildInfo.radioation
		end
		local tilePoint = v.pos
		_UPVALUE4_ = nil
		;(nil)[1] = tonumber(tilePoint.x) - radioation
		;(nil)[2] = tonumber(tilePoint.y) - radioation
		;(nil)[3] = 2 * radioation + size
		local (nil)[4], lineData = 2 * radioation + size, nil
		table.insertto(manorDataArrary, lineData)
	end
	local RecognizeOutline = include("RecognizeOutline")
	local recognize = RecognizeOutline.new()
	local outlines = recognize:GetOutline(manorDataArrary)
	local j = 1
	local _ENV, pointsArrayAll = manorDataArrary, manorDataArrary
	for k, w in ipairs(outlines) do
		local _ENV, pointsArray
		local _ENV, pointsRoundArraryAll = table.insertto, table.insertto
		for i, v in ipairs(w) do
			if j == 1 then
				local _ENV, point
				pointsArray[#pointsArray + 1] = point
			end
			local point = pointsArray[#pointsArray]
			point[j] = v
			if j == 2 then
				local pointX = math.round(point[1])
				local pointY = math.round(point[2])
				local swapIndex = 0
				for index, pos in ipairs(pointsRoundArraryAll) do
					if pos.x == pointX and pos.y == pointY then
						swapIndex = index
						break
					end
				end
				pointsRoundArraryAll[#pointsRoundArraryAll + 1] = cc.p(pointX, pointY)
				if pointX < 0 then
					pointX = 0
				end
				local maxCoordinate = worldMapDefine.getMaxCoordinateByKid(self.mapKindomID)
				if pointX > maxCoordinate then
					pointX = maxCoordinate
				end
				if pointY < 0 then
					pointY = 0
				end
				if maxCoordinate < pointY then
					pointY = maxCoordinate
				end
				if pointX < point[1] and pointY < point[2] then
					pointX = pointX - 1.0 + 0.42
					pointY = pointY - 1.0 + 0.42
				elseif pointX < point[1] and pointY > point[2] then
					pointX = pointX - 1.0 + 0.42
					pointY = pointY - 0.42
				elseif pointX > point[1] and pointY > point[2] then
					pointX = pointX - 0.42
					pointY = pointY - 0.42
				elseif pointX > point[1] and pointY < point[2] then
					pointX = pointX - 0.42
					pointY = pointY - 1.0 + 0.42
				end
				local worldPoint = cc.p(pointX, pointY)
				pointsArray[#pointsArray] = worldPoint
				if 0 < swapIndex then
					local swapPoint = pointsArray[swapIndex]
					pointsArray[swapIndex] = worldPoint
					pointsArray[#pointsArray] = swapPoint
				end
			end
			j = j + 1
			if 2 < j then
				j = 1
			end
		end
		pointsArrayAll[k] = pointsArray
	end
	return pointsArrayAll
end
function worldResourceMap:loadImagesFinish()
	for i = 1, 9 do
		local imgBg = SoraDGetChildByName(self, "Image_bg_" .. i)
		if imgBg then
			imgBg:setSpriteFrame("map_center.png")
		end
	end
end
function worldResourceMap:onCoordinate(target, event)
	if event == ccui.TouchEventType.ended then
		local myKindomID = gametop.playertop_:getMapID()
		if self.mapKindomID ~= myKindomID then
			return
		end
		SoraDPlaySound()
		local targetPoint = cc.p(self.coordinate.x, self.coordinate.y)
		if SoraDGotoWorldMapPoint(targetPoint, false) then
			self:buttonBackWorldCall(nil, event)
		end
	end
end
function worldResourceMap:sMsgKingdomLvChange(target, data)
	self:updateKingdomLv()
end
function worldResourceMap:setWrathBeastInfo()
	if self.mapKindomID == self.myKindomID and not worldMapDefine.isInKingdomBattle() and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WRATH_BEAST_ACTIVITY) then
		if not self.wrathBeastNode then
			self.wrathBeastNode = display.newNode()
			self.wrathBeastNode:addTo(self.containerView, 9)
			local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
			local beastArray = wrathBeastCtrl:getWrathBeastConfig()
			self:addWrathBeast(beastArray)
		end
		self.wrathBeastNode:setVisible(self.isWrathBeastShow)
		self.closeIconList[self.buttonBeast:getTag()]:setVisible(not self.isWrathBeastShow)
		self.buttonBeast:setVisible(true)
	else
		if self.wrathBeastNode then
			self.wrathBeastNode:setVisible(false)
		end
		self.buttonBeast:setVisible(false)
	end
	self:updateBtnPosition()
end
function worldResourceMap:addWrathBeast(beastArray)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	for _, v in pairs(beastArray) do
		local bossSprite
		if v.bossType == gBossType.wrathBeastDrqsc then
			bossSprite = display.newSprite("#icon_godbeast_site_02.png")
		else
			bossSprite = display.newSprite("#icon_godbeast_site_01.png")
		end
		local tilePoint = cc.p(v.coordinate[1], v.coordinate[2])
		local point = self:getSpritePos(worldMapView, tilePoint)
		bossSprite:setAnchorPoint(cc.p(0.5, 0.1))
		bossSprite:setPosition(point)
		bossSprite:addTo(self.wrathBeastNode)
		table.insert(self.wrathBeastArray, bossSprite)
	end
end
function worldResourceMap:buttonBeastCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isWrathBeastShow = not self.isWrathBeastShow
		worldMapDefine.btnWrathBeast = self.isWrathBeastShow
		self.wrathBeastNode:setVisible(self.isWrathBeastShow)
		self.closeIconList[button:getTag()]:setVisible(not self.isWrathBeastShow)
	end
end
function worldResourceMap:setEndlessTrialsInfo(...)
	if self.mapKindomID == self.myKindomID and not worldMapDefine.isInKingdomBattle() and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY) then
		if not self.endlessTrialNode then
			self.endlessTrialNode = display.newNode()
			self.endlessTrialNode:addTo(self.containerView, 9)
			local worldMapView = SoraDCurrentSceneShowView("worldMapView")
			if not worldMapView then
				return
			end
			local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
			local list = endlessTrialsCtrl:getMountainConfig()
			for i, data in ipairs(list) do
				local sprite = display.newSprite("#position_snowmountain.png")
				local tilePoint = endlessTrialsCtrl:getProtalInfo(data.snowmountainID) or cc.p(data.coordinate[1], data.coordinate[2])
				local point = self:getSpritePos(worldMapView, tilePoint)
				sprite:setAnchorPoint(cc.p(0.5, 0.1))
				sprite:setPosition(point)
				sprite:addTo(self.endlessTrialNode)
				table.insert(self.endlessTrialArray, sprite)
			end
		end
		self.endlessTrialNode:setVisible(self.isEndlessTrialShow)
		self.closeIconList[self.buttonEndless:getTag()]:setVisible(not self.isEndlessTrialShow)
		self.buttonEndless:setVisible(true)
	else
		if self.endlessTrialNode then
			self.endlessTrialNode:setVisible(false)
		end
		self.buttonEndless:setVisible(false)
	end
	self:updateBtnPosition()
end
function worldResourceMap:buttonEndlessCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isEndlessTrialShow = not self.isEndlessTrialShow
		worldMapDefine.btnEndless = self.isEndlessTrialShow
		self.endlessTrialNode:setVisible(self.isEndlessTrialShow)
		self.closeIconList[button:getTag()]:setVisible(not self.isEndlessTrialShow)
	end
end
function worldResourceMap:getSpritePos(worldMapView, tilePoint)
	local ratio = worldMapDefine.worldResourceMapSize.width / worldMapDefine.worldMapViewSize.width
	local pos = worldMapView:getPointWithTile(tilePoint)
	local subPt = cc.pSub(worldMapView.mapViewCenterPoint, pos)
	local x = subPt.x * ratio
	local y = subPt.y * ratio
	local point = cc.pSub(self.containerViewCenterPoint, cc.p(x, y))
	return point
end
function worldResourceMap:updateBtnPosition()
	local posy = 90
	for i, v in ipairs(self.actionBtnList) do
		if v:isVisible() then
			v:setPosition(cc.p(0, posy))
			posy = posy + 70
		end
	end
end
function worldResourceMap:refreshAllianceMark(...)
	local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
	if not collectMapCtrl:showAllianceMark() then
		for k, v in pairs(self.markNodeList) do
			if v.point then
				v.point:setVisible(false)
			end
		end
		return
	end
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	if not self.Node_AllianceMark then
		local node = display.newNode()
		node:addTo(self.containerView, 10)
		node:setName("Node_AllianceMark")
		self.Node_AllianceMark = node
	end
	local allianceMarkData = collectMapCtrl:getAllianceMarkData()
	local scale = 0.01
	local revertScale = 1 / scale
	for k, v in pairs(allianceMarkData) do
		local node = self.markNodeList[k] and self.markNodeList[k].point
		if v.mapID == self.mapKindomID then
			if not node then
				node = SoraDCreatePanel("worldMapAllianceMark")
				node:addTo(self.Node_AllianceMark)
				node:setScale(scale)
				node:updateLodLevel(worldMapDefine.worldLodDef.LOD6)
				node:updateScaleZoom(revertScale)
				_ENV = node
				self.markNodeList[k], node.point = node, node
			else
				node:setVisible(true)
			end
			node:initData(v)
			local position = v.position
			local point = self:getSpritePos(worldMapView, cc.p(position[1], position[2]))
			node:setPosition(point)
		elseif node then
			node:setVisible(false)
		end
	end
	for k, v in pairs(self.markNodeList) do
		if v.point and not allianceMarkData[k] then
			v.point:setVisible(false)
		end
	end
end
return worldResourceMap
