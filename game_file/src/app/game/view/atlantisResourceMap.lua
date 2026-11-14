local mapSyncUtilClient = include("mapSyncUtilClient")
local worldMapWarDef = include("worldMapWarDef")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisResourceMap = class("atlantisResourceMap", function()
	local target = SoraDCreateBasePanel("atlantisResourceMap")
	include("worldResourceMapNormal").new(target)
	return target
end)
local _btnLeagueState = true
local _btnControlState = true
function atlantisResourceMap:ctor()
	self.isHideCurrentSceneView = true
	self.buildingsArray, _ENV, self.leagueMembersArray, _ENV, self.mySprite, _ENV, self.mapKindomID = worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID, worldMapDefine.currentMapKindomID
	self.isLeagueShow = _btnLeagueState
	self.closeIconList, _ENV, self.isButtonControlOpen = _btnControlState, _btnControlState, _btnControlState
	self:initWidget()
	self:initData()
end
function atlantisResourceMap:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_RESOURCEMAP_MOVETOCENTER", handler(self, self.moveSubPointToCenter))
end
function atlantisResourceMap:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self:initScroll("atlantisMapView_info")
	self:initTouchlayer()
	local containerViewSize = self.containerView:getContentSize()
	local offsetX = 0
	local offsetY = 135
	self.mapwidth = containerViewSize.width - offsetX * 2
	self.mapheight = containerViewSize.height - offsetY * 2
	self.ratioToResource = self.mapwidth / worldMapDefine.worldResourceMapSize.width
	self.zeroPoint = cc.p(self.containerView:getContentSize().width / 2, self.containerView:getContentSize().height - offsetY)
	self.tileW = self.mapwidth / 400
	self.tileH = self.mapheight / 400
	self:addResourcePoint(offsetX, offsetY)
	self:createBorder(self.mapwidth)
	self:initColorLayer()
	self:initNode()
	self:initBuildings()
	self:initNodeInfo()
	self.Text_kingDomName:setString(worldMapWarDef.getKingdomName())
	self.Text_stage = SoraDCreateTimerLabel(self, self.Text_stage)
	self.Text_stage:setTimeEndListener(function()
		self:refreshWarStage()
	end)
	self.Text_remain = SoraDCreateTimerLabel(self, self.Text_remain)
	self.Text_remain:setTimeLast(function(time)
		return i18n("atlantiswar_text_0099") .. time
	end)
	self.Button_goBack:addTouchEventListener(handler(self, self.buttonBackWorldCall))
	self.Button_control:addTouchEventListener(handler(self, self.buttonControlCall))
	self.Button_league:addTouchEventListener(handler(self, self.buttonLeagueCall))
	self.Button_league:setTag(1)
	local closeIcon = SoraDGetChildByName(self.Button_league, "Image_forbidden")
	closeIcon:setVisible(not self.isLeagueShow)
	table.insert(self.closeIconList, closeIcon)
	self:setBtnControlInfo()
end
function atlantisResourceMap:initData(...)
	self:refreshWarStage()
end
function atlantisResourceMap:initNode()
	self.nodeBuilding = display.newNode()
	self.nodeBuilding:addTo(self.containerView, 9)
	self.nodeMember = display.newNode()
	self.nodeMember:addTo(self.containerView, 9)
end
function atlantisResourceMap:setNodePos(node, pos, size)
	size = size or 1
	local offset = size * 0.5
	local tilex = pos.x + offset
	local tiley = pos.y + offset
	local x = self.zeroPoint.x + (tilex - tiley) * self.tileW / 2
	local y = self.zeroPoint.y + -(tilex + tiley) * self.tileH / 2
	local point = cc.p(x, y)
	node:setPosition(point)
end
function atlantisResourceMap:refreshTextBuildTime(widget, build)
	local warData = atlantisWarCtrl:getWarData()
	atlantisWarCtrl, atlantisWarCtrl = nil, atlantisWarCtrl
	;(nil).startTime = warData.bossWlynStartTime
	atlantisWarCtrl, atlantisWarCtrl[1], (nil).endTime = nil, nil, warData.bossWlynEndTime
	;(nil).startTime = warData.bossSdStartTime
	atlantisWarCtrl, atlantisWarCtrl[2], (nil).endTime = nil, nil, warData.bossSdEndTime
	;(nil).startTime = warData.warAreaStartTime
	atlantisWarCtrl[3], (nil).endTime = nil, warData.warAreaEndTime
	local timeConfig = atlantisWarCtrl
	local timeData
	if build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding and (build.type == gWorldTypeServerDef.subMapTypeAtlantisWarPalace or build.type == gWorldTypeServerDef.subMapTypeAtlantisWarFort) then
		timeData = timeConfig[3]
	elseif build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
		if build.type == gBossType.atlantisWarWlyn then
			timeData = timeConfig[1]
		elseif build.type == gBossType.atlantisWarSd then
			timeData = timeConfig[2]
		end
	end
	local refreshTime = function(timeData)
		local startTime = timeData.startTime
		local endTime = timeData.endTime
		local curTime = serviceFunctions.systemTime()
		if startTime > curTime then
			widget:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_606", nil)
			end)
			widget:beginTime(startTime - curTime)
		elseif endTime < curTime then
			_ENV = nil
			;(nil).var = ""
			widget:setString(i18n("atlantiswar_text_0231", nil))
		elseif startTime <= curTime and endTime >= curTime then
			widget:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_607", nil)
			end)
			widget:beginTime(endTime - curTime)
		end
	end
	if timeData then
		widget:setTimeEndListener(function()
			refreshTime(timeData)
		end)
		refreshTime(timeData)
	end
end
function atlantisResourceMap:initBuildings(...)
	local AMB = require_data("atlantiswar_map_build", true).data
	local AMBC = require_data("atlantiswar_map_build_config").data
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local stage = atlantisWarCtrl:getWarStage()
	_ENV = atlantisWarCtrl
	atlantisWarCtrl[1] = "icon_shmc_dot"
	atlantisWarCtrl[901] = "icon_shmc_small_901.png"
	atlantisWarCtrl[902] = "icon_shmc_small_902.png"
	atlantisWarCtrl[903] = "icon_shmc_small_903.png"
	atlantisWarCtrl[904] = "icon_shmc_small_904.png"
	atlantisWarCtrl[929] = "icon_shmc_small_905.png"
	atlantisWarCtrl[930] = "icon_shmc_small_905.png"
	atlantisWarCtrl[931] = "icon_shmc_small_905.png"
	atlantisWarCtrl[932] = "icon_shmc_small_917.png"
	atlantisWarCtrl[933] = "icon_shmc_small_917.png"
	local atlantisWarCtrl[934], config = "icon_shmc_small_917.png", atlantisWarCtrl
	local checkBossIsInWarState = function(bossType)
		_ENV = nil
		;(nil)[gAtlantisWarStageType.wlynIng] = gBossType.atlantisWarWlyn
		local (nil)[gAtlantisWarStageType.sdIng], stage2bossType = gBossType.atlantisWarSd, nil
		if stage2bossType[stage] == bossType then
			return true
		end
	end
	for k, build in pairs(AMB) do
		local imgName = config[k]
		if imgName then
			local Node_buildTime = self.Node_buildTime:clone()
			Node_buildTime:addTo(self.nodeBuilding, 1)
			local point = mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))
			self:setNodePos(Node_buildTime, point, build.size)
			if k == 901 then
				Node_buildTime:setPositionY(Node_buildTime:getPositionY() - 40)
			else
				Node_buildTime:setPositionY(Node_buildTime:getPositionY() - 20)
			end
			local Text_buildTime = Node_buildTime:getChildByName("Text_buildTime")
			Text_buildTime = SoraDCreateTimerLabel(self, Text_buildTime)
			self:refreshTextBuildTime(Text_buildTime, build)
			local sprite = display.newSprite("#" .. imgName)
			sprite:addTo(self.nodeBuilding)
			self:setNodePos(sprite, point, build.size)
			if k == 901 then
				sprite:setScale(0.8)
				sprite:setAnchorPoint(cc.p(0.65, 0.4))
			else
				sprite:setAnchorPoint(cc.p(0.5, 0.25))
			end
			self.buildingsArray[k] = sprite
		end
		if build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss and table.indexof(build.camp, selfCamp) and checkBossIsInWarState(build.type) then
			local sprite = self.buildingsArray[k]
			if sprite then
				local x, y = sprite:getPosition()
				_ENV = sprite
				sprite.x = x
				sprite.y = y + 15
				self:addMiaozhunEffect(sprite)
			end
		end
	end
	if stage == gAtlantisWarStageType.warAreaIng then
		local sprite = self.buildingsArray[901]
		if sprite then
			local x, y = sprite:getPosition()
			_ENV = config[k]
			config[k].x = x
			config[k].y = y
			self:addMiaozhunEffect(config[k])
		end
	end
	_ENV = sprite
	self.buildingsArray[901][1] = cc.p(50, 69)
	self.buildingsArray[901][2] = cc.p(196, 43)
	self.buildingsArray[901][3] = cc.p(361, 115)
	self.buildingsArray[901][4] = cc.p(358, 296)
	self.buildingsArray[901][5] = cc.p(212, 357)
	local self.buildingsArray[901][6], config = cc.p(38, 238), self.buildingsArray[901]
	for i, v in ipairs(config) do
		local node = display.newNode()
		node:addTo(self.nodeBuilding)
		self:setNodePos(node, v)
		local sprite
		if i == selfCamp then
			sprite = display.newSprite("#icon_shmc_small_born_blue.png")
		else
			sprite = display.newSprite("#icon_shmc_small_born.png")
		end
		sprite:addTo(node)
		local kid = atlantisWarCtrl:getCampKid(i)
		local text_kid = ccui.Text:create(tostring(kid), "", 22)
		text_kid:addTo(node)
		text_kid:setPosition(0, 10)
	end
end
function atlantisResourceMap:addMiaozhunEffect(info)
	if self.miaozhunEffect then
		self.miaozhunEffect:removeFromParent()
		self.miaozhunEffect = nil
	end
	local effect = SoraDCreatAnimation("nodeEffect_miaozhun")
	effect:addTo(self.nodeBuilding, 2)
	effect:setPosition(cc.p(info.x, info.y))
	self.miaozhunEffect = effect
end
function atlantisResourceMap:initNodeInfo()
	_ENV, _UPVALUE9_ = nil, nil
	;(nil).image = "position_city.png"
	_ENV, (nil).title = nil, "common_text_496"
	;(nil).image = "position_alli.png"
	_ENV, (nil).title = nil, "atlantiswar_text_0109"
	;(nil).image = "icon_shmc_small_born_blue.png"
	_ENV, (nil).title = nil, "atlantiswar_text_0110"
	;(nil).image = "icon_shmc_small_917.png"
	_ENV, (nil).title = nil, "atlantiswar_text_0080"
	;(nil).image = "icon_shmc_small_905.png"
	_ENV, (nil).title = nil, "atlantiswar_text_0064"
	;(nil).image = "icon_shmc_small_901.png"
	_ENV, (nil).title = nil, "atlantiswar_build_name_901"
	;(nil).image = "icon_shmc_small_902.png"
	_ENV, (nil).title = nil, "atlantiswar_build_name_902"
	;(nil).image = "icon_shmc_small_903.png"
	_ENV, (nil).title = nil, "atlantiswar_build_name_903"
	;(nil).image = "icon_shmc_small_904.png"
	;(nil).title = "atlantiswar_build_name_904"
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = nil
	;(nil)[4] = nil
	;(nil)[5] = nil
	;(nil)[6] = nil
	;(nil)[7] = nil
	;(nil)[8] = nil
	local (nil)[9], config
	if not (self.Node_info and config) or not next(config) then
		return
	end
	self.Node_info:setVisible(true)
	self.Node_info_single:setVisible(false)
	local itemH = 40
	local totalH = self.Panel_black:getContentSize().height
	local beginH = totalH - 10
	for i, v in ipairs(config) do
		local node = self.Node_info_single:clone()
		node:setVisible(true)
		node:addTo(self.Node_info)
		local col = (i - 1) % 3 + 1
		local row = math.ceil(i / 3)
		node:setPosition(SoraDFSign(275 - 200 * (col - 1)), beginH - itemH * (row - 0.5))
		local Sprite_info = SoraDGetChildByName(node, "Sprite_info")
		Sprite_info:setSpriteFrame(v.image)
		Sprite_info:setScale(35 / Sprite_info:getContentSize().height)
		local Text_info = SoraDGetChildByName(node, "Text_info")
		Text_info:setString(i18n(v.title))
	end
end
function atlantisResourceMap:viewOnClick(ref, event)
	if event == ccui.TouchEventType.ended then
		if not self.isMoved or SoraDIsGameGuide() then
			local touchEndPoint = self.touchlayer:getTouchEndPosition()
			local covertPoint = self.touchlayer:convertToNodeSpace(touchEndPoint)
			local isTouchInMember = false
			_ENV, _ENV = nil, touchEndPoint
			_UPVALUE1_, (nil).isShow = nil, true
			_ENV, touchEndPoint[1], (nil).array, (nil)[1] = nil, nil, nil, self.mySprite
			;(nil).isShow = self.isLeagueShow
			_ENV, touchEndPoint[2], (nil).array = nil, nil, self.leagueMembersArray
			;(nil).isShow = true
			touchEndPoint[3], (nil).array = nil, self.buildingsArray
			local tab = touchEndPoint
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
			if SorDIsPointInPolygon(self.resourcePolygonPtArray, covertPoint) then
				local subPoint = cc.pSub(self.containerViewCenterPoint, covertPoint)
				local ratio = worldMapDefine.worldMapViewSize.width / self.mapwidth
				subPoint = cc.p(subPoint.x * ratio, subPoint.y * ratio)
				local mapKindomID = worldMapDefine.currentMapKindomID
				_ENV = subPoint.y * ratio
				;(subPoint.y * ratio).msg = "MESSAGE_WORLD_MAP_MOVETOCENTER_SUBPOINT"
				;(subPoint.y * ratio).subPoint = subPoint
				;(subPoint.y * ratio).kingdomID = mapKindomID
				SoraDSendMessage(subPoint.y * ratio)
				SoraDShowLoading()
				self:showJumpAction(covertPoint, function()
					self:close(nil, ccui.TouchEventType.ended)
					SoraDCloseLoading()
				end)
			end
		end
		self.isMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = self.touchlayer:getTouchBeganPosition()
		local touchmovePoint = self.touchlayer:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.began then
		self.isMoved = false
	end
end
function atlantisResourceMap:buttonBackWorldCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function atlantisResourceMap:buttonControlCall(button, type)
	if type == ccui.TouchEventType.ended then
		self.isButtonControlOpen = not self.isButtonControlOpen
		self.Button_control:setTouchEnabled(false)
		self:setBtnControlInfo()
	end
end
function atlantisResourceMap:setBtnControlInfo()
	local buttonImgName = "btn_minimap_02.png"
	if not self.isButtonControlOpen then
		buttonImgName = "btn_minimap_05.png"
	end
	if not self.isButtonControlOpen then
		if not _btnControlState then
			self.Node_action:setScale(0)
			self.btn_minimap_eye:setSpriteFrame(buttonImgName)
			self.btn_minimap_act:setRotation(0)
		else
			_btnControlState = cc.ScaleTo
			cc.ScaleTo.easing = "BACKIN"
			function cc.ScaleTo.onComplete()
				self.btn_minimap_eye:setSpriteFrame(buttonImgName)
				self.Button_control:setTouchEnabled(true)
			end
			transition.execute(self.Node_action, cc.ScaleTo:create(0.5, 0), cc.ScaleTo)
			self.btn_minimap_act:runAction(cca.rotateTo(0.5, 0))
			self.btn_minimap_bg:runAction(cca.rotateTo(0.5, 0))
		end
	else
		self.btn_minimap_eye:setSpriteFrame(buttonImgName)
		self.btn_minimap_act:setRotation(0)
		self.btn_minimap_act:runAction(cca.rotateTo(0.5, 45))
		self.btn_minimap_bg:setRotation(0)
		self.btn_minimap_bg:runAction(cca.rotateTo(0.5, -45))
		_btnControlState = cc.ScaleTo
		cc.ScaleTo.easing = "BACKOUT"
		function cc.ScaleTo.onComplete()
			self.Button_control:setTouchEnabled(true)
		end
		transition.execute(self.Node_action, cc.ScaleTo:create(0.5, 1), cc.ScaleTo)
	end
end
function atlantisResourceMap:buttonLeagueCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isLeagueShow = not self.isLeagueShow
		self:setLeagueInfo()
		self.closeIconList[button:getTag()]:setVisible(not self.isLeagueShow)
	end
end
function atlantisResourceMap:setLeagueInfo(...)
	for k, v in pairs(self.leagueMembersArray) do
		v:setVisible(self.isLeagueShow)
	end
end
function atlantisResourceMap:setLeagueMembersInfo(memberArray)
	for _, v in pairs(memberArray) do
		local memberSprite
		local scale = 0.6
		if v.memberType == gWorldResourceMapPlayerType.youSelf then
			memberSprite = display.newSprite("#position_city.png")
			self.mySprite = memberSprite
		else
			memberSprite = display.newSprite("#position_alli.png")
			table.insert(self.leagueMembersArray, memberSprite)
			scale = 1.5
		end
		v.x = v.x * self.ratioToResource
		v.y = v.y * self.ratioToResource
		local point = cc.pSub(self.containerViewCenterPoint, cc.p(v.x, v.y))
		memberSprite:setAnchorPoint(cc.p(0.5, 0.1))
		memberSprite:setPosition(point)
		memberSprite:setScale(scale)
		memberSprite:addTo(self.nodeMember)
	end
	self:setLeagueInfo()
end
function atlantisResourceMap:refreshWarStage(...)
	local warData = atlantisWarCtrl:getWarData()
	if not next(warData) then
		return
	end
	local curtime = serviceFunctions.systemTime()
	local lefttime = warData.warEndTime - curtime
	if 0 < lefttime then
		self.Text_remain:beginTime(lefttime)
	end
	local stage, lefttime = atlantisWarCtrl:getWarStage()
	_UPVALUE6_ = lefttime
	lefttime[1] = i18n("atlantiswar_text_0100")
	lefttime[2] = i18n("atlantiswar_text_0101")
	lefttime[3] = i18n("atlantiswar_text_0102")
	lefttime[4] = i18n("atlantiswar_text_0103")
	lefttime[5] = i18n("atlantiswar_text_0104")
	lefttime[6] = i18n("atlantiswar_text_0105")
	lefttime[7] = i18n("atlantiswar_text_0106")
	local lefttime[8], stageConfig = i18n("atlantiswar_text_0106")
	self.Text_stage:setTimeLast(function(time)
		return stageConfig[stage] .. time
	end)
	if stage == gAtlantisWarStageType.battleEnd then
		self.Node_stage:setVisible(false)
	elseif 0 < lefttime then
		self.Node_stage:setVisible(true)
		self.Text_stage:beginTime(lefttime)
	end
end
function atlantisResourceMap:getSelfCampBoss(bossType)
	local AMB = require_data("atlantiswar_map_build", true).data
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	for k, build in pairs(AMB) do
		if build.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss and table.indexof(build.camp, selfCamp) and bossType == build.type then
			return k
		end
	end
end
function atlantisResourceMap:gameGuide_getTarget(itemName, parameters)
	if itemName == "Boss_wlyn" then
		local buildId = self:getSelfCampBoss(gBossType.atlantisWarWlyn)
		return self.buildingsArray[buildId]
	elseif itemName == "Boss_sd" then
		local buildId = self:getSelfCampBoss(gBossType.atlantisWarSd)
		return self.buildingsArray[buildId]
	elseif itemName == "Build_qzzc" then
		return self.buildingsArray[901]
	elseif itemName == "Build_qfys" then
		return self.buildingsArray[902]
	elseif itemName == "Build_qpys" then
		return self.buildingsArray[903]
	elseif itemName == "Build_qyys" then
		return self.buildingsArray[904]
	end
end
function atlantisResourceMap:gameGuide_move2Target(itemName)
	local sprite = self:gameGuide_getTarget(itemName)
	local x, y = sprite:getPosition()
	self:moveMapPointToCenter(cc.p(x, y), 0.3)
end
return atlantisResourceMap
