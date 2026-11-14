local gametop = gModuleMgr.getObject("gametop")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local mapSyncUtilClient = include("mapSyncUtilClient")
local atlantisWarUtil = include("atlantisWarUtil")
local worldMapMiniMapBase = include("worldMapMiniMapBase")
local atlantisWarMiniMap = class("atlantisWarMiniMap", worldMapMiniMapBase)
local OP_TYPE = worldMapMiniMapBase.OP_TYPE
function atlantisWarMiniMap:ctor()
	atlantisWarMiniMap.super.ctor(self)
	self.swinklePlayerList, atlantisWarMiniMap, self.swinkleBuildList, atlantisWarMiniMap, self.focusPosCdTime = atlantisWarMiniMap.super.ctor, atlantisWarMiniMap.super.ctor, atlantisWarMiniMap.super.ctor, atlantisWarMiniMap.super.ctor, 30
	atlantisWarMiniMap = nil
	;(nil).from = "atlantisWarMiniMap"
	kingdomMapCtrl:reqAllianceMember(nil, nil, nil)
end
function atlantisWarMiniMap:onMessageListener()
	atlantisWarMiniMap.super.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_RESOURCE_MAP_MEMBERS", handler(self, self.serverMessage_LeagueMembersInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_NOTIFYPLAYERCITY", handler(self, self.updateTeamMember))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.greenPointUpdate))
end
function atlantisWarMiniMap:initWidget(...)
	atlantisWarMiniMap.super.initWidget(self, ...)
	self.node_refresh_time = SoraDGetChildByName(self, "Node_refresh_time")
	self.node_refresh_time:setVisible(false)
	if atlantisWarUtil.isNewMap() then
		SoraChangeSpriteImage(self.image_map, "frame_shmc_xdt.png")
	else
		SoraChangeSpriteImage(self.image_map, "frame_shmc_xdt_ROS.png")
	end
	if atlantisWarUtil.checkCanNotifyFocusPos() then
		self.btnOpTip:setVisible(true)
	else
		self.btnOpTip:setVisible(false)
		if self.opType == OP_TYPE.OP_TYPE_TIPS then
			self:setOpType(OP_TYPE.OP_TYPE_NONE)
		end
	end
end
function atlantisWarMiniMap:initNode(...)
	atlantisWarMiniMap.super.initNode(self, ...)
end
function atlantisWarMiniMap:initView(...)
	atlantisWarMiniMap.super.initView(self, ...)
	self:initBuildings()
end
function atlantisWarMiniMap:initOpType(...)
	self:setOpType(OP_TYPE.OP_TYPE_JUMP, true)
end
function atlantisWarMiniMap:setOpType(opType, config)
	atlantisWarMiniMap.super.setOpType(self, opType, true)
end
function atlantisWarMiniMap:getSpriteImageName(buildId, color)
	_ENV = nil
	;(nil)[1] = "icon_shmc_dot"
	;(nil)[901] = "icon_shmc_pillar"
	;(nil)[902] = "icon_shmc_falls"
	;(nil)[903] = "icon_shmc_wind"
	;(nil)[904] = "icon_shmc_rock"
	;(nil)[929] = "icon_shmc_shmcclr"
	;(nil)[930] = "icon_shmc_shmcclr"
	;(nil)[931] = "icon_shmc_shmcclr"
	;(nil)[932] = "icon_shmc_shmcsd"
	;(nil)[933] = "icon_shmc_shmcsd"
	local (nil)[934], config = "icon_shmc_shmcsd", nil
	local key = config[buildId]
	if key then
		color = color or "white"
		local name = string.format("%s_%s.png", key, color)
		return name
	end
end
function atlantisWarMiniMap:setSpriteStateRed(sprite, buildId)
	if sprite then
		local imgName = self:getSpriteImageName(buildId, "red")
		sprite:setSpriteFrame(imgName)
		self:setSpriteSwinkle(sprite)
	end
end
function atlantisWarMiniMap:setSpriteSwinkle(sprite)
	if sprite then
		sprite:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeTo(1, 0.5)
		;(nil)[2] = cca.fadeTo(1, 1)
		;(nil)[3] = cca.fadeTo(1, 1)
		;(nil)[4] = cca.fadeTo(1, 1)
		sprite:runAction(cca.repeatForever(cca.seq(nil)))
	end
end
function atlantisWarMiniMap:initQueueData(...)
	local queueRoot = kingdomMapCtrl:getQueueRootByWar()
	local allianceWarListData = queueRoot:getAllWarHallQueue()
	if not allianceWarListData or not next(allianceWarListData) then
		for i, v in ipairs(self.swinkleBuildList) do
			v:stopAllActions()
			v:setOpacity(255)
		end
		self.swinkleBuildList, kingdomMapCtrl = ipairs(self.swinkleBuildList)
		for k, v in pairs(self.swinklePlayerList) do
			local sprite = self.teamMembersArray[tostring(k)]
			if sprite then
				sprite:stopAllActions()
				sprite:setOpacity(255)
				local imgName = self:getSpriteImageName(1, "blue")
				sprite:setSpriteFrame(imgName)
			end
		end
		self.swinklePlayerList, kingdomMapCtrl = pairs(self.swinklePlayerList)
		return
	end
	for key, v in pairs(allianceWarListData) do
		for k, w in pairs(v.queues) do
			local data = w.to
			local mapType = data.mapType
			if mapType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
				local sprite = self.buildingsArray[data.objId]
				if sprite then
					self:setSpriteSwinkle(sprite)
					table.insert(self.swinkleBuildList, sprite)
				end
			elseif mapType == gMapObjTypeDef.mapObjTypePlayer then
				local key = serviceFunctions.getMapKey(data.x, data.y)
				local sprite = self.teamMembersArray[tostring(key)]
				if sprite then
					local imgName = self:getSpriteImageName(1, "red")
					sprite:setSpriteFrame(imgName)
					self:setSpriteSwinkle(sprite)
					self.swinklePlayerList[tostring(key)] = true
				end
			end
		end
	end
end
function atlantisWarMiniMap:initBuildings(...)
	local AMB = require_data("atlantiswar_map_build", true).data
	local AMBC = require_data("atlantiswar_map_build_config").data
	for k, build in pairs(AMB) do
		local imgName = self:getSpriteImageName(k, "white")
		if imgName then
			local sprite = display.newSprite("#" .. imgName)
			sprite:addTo(self.nodeBuilding)
			local point = mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))
			self:setNodePos(sprite, point, build.size)
			self.buildingsArray[k] = sprite
		end
	end
	local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
	local stage = atlantisWarCtrl:getWarStage()
	local selfCamp = atlantisWarCtrl:getSelfCamp()
	local checkBossIsInWarState = function(bossType)
		_ENV = nil
		;(nil)[gAtlantisWarStageType.wlynIng] = gBossType.atlantisWarWlyn
		local (nil)[gAtlantisWarStageType.sdIng], stage2bossType = gBossType.atlantisWarSd, nil
		if stage2bossType[stage] == bossType then
			return true
		end
	end
	for k, v in pairs(AMB) do
		if v.mapType == gMapObjTypeDef.mapTypeAtlantisWarBoss and table.indexof(v.camp, selfCamp) and checkBossIsInWarState(v.type) then
			local sprite = self.buildingsArray[k]
			if sprite then
				local imgName = self:getSpriteImageName(k, "red")
				sprite:setSpriteFrame(imgName)
				self:setSpriteSwinkle(sprite)
				local x, y = sprite:getPosition()
				_ENV = cc.p(build.x, build.y)
				cc.p(build.x, build.y).x = x
				cc.p(build.x, build.y).y = y
				self:addMiaozhunEffect(cc.p(build.x, build.y))
			end
		end
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local warBuildingOwnerMgr = kingdomMapCtrl.kingdomMapCell.warBuildingOwnerMgr
	_UPVALUE4_ = mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))
	mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))[1] = 901
	mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))[2] = 902
	mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))[3] = 903
	mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y))[4] = 904
	for i, buildId in ipairs((mapSyncUtilClient.serverTOClientPos(cc.p(build.x, build.y)))) do
		local sprite = self.buildingsArray[buildId]
		if sprite then
			local owner = warBuildingOwnerMgr:getOwner(worldMapDefine.currentMapKindomID, buildId)
			if owner then
				if owner.camp == selfCamp then
					local imgName = self:getSpriteImageName(buildId, "blue")
					sprite:setSpriteFrame(imgName)
				else
					local imgName = self:getSpriteImageName(buildId, "red")
					sprite:setSpriteFrame(imgName)
				end
			else
				local imgName = self:getSpriteImageName(buildId, "white")
				sprite:setSpriteFrame(imgName)
			end
			if buildId == 901 and stage == gAtlantisWarStageType.warAreaIng then
				local x, y = sprite:getPosition()
				_ENV = cc.p(build.x, build.y)
				cc.p(build.x, build.y).x = x
				cc.p(build.x, build.y).y = y
				self:addMiaozhunEffect(cc.p(build.x, build.y))
			end
		end
	end
end
function atlantisWarMiniMap:serverMessage_LeagueMembersInfo(target, data)
	if data and (not data.clientData or data.clientData.from ~= "atlantisWarMiniMap") then
		return
	end
	if not data.data then
		return
	end
	local _ENV, memberArray = data.data, data.data
	for uid, v in pairs(data.data) do
		local key = serviceFunctions.getMapKey(v.x - 1, v.y - 1)
		self:addTeamMember(key, v)
	end
	self:initQueueData()
end
function atlantisWarMiniMap:addTeamMember(key, data)
	local sprite = self.teamMembersArray[tostring(key)]
	if not sprite then
		local imgName = self:getSpriteImageName(1, "blue")
		if #self.memberSpare > 0 then
			sprite = table.remove(self.memberSpare)
			sprite:setVisible(true)
			sprite:setSpriteFrame(imgName)
		else
			sprite = display.newSprite("#" .. imgName)
			sprite:setScale(1.5)
			sprite:addTo(self.nodeMember)
		end
		self.teamMembersArray[tostring(key)] = sprite
	end
	self:setNodePos(sprite, cc.p(data.x, data.y))
end
function atlantisWarMiniMap:removeTeamMember(key)
	local sprite = self.teamMembersArray[tostring(key)]
	if sprite then
		sprite:setVisible(false)
		sprite:stopAllActions()
		sprite:setOpacity(255)
		table.insert(self.memberSpare, sprite)
		self.teamMembersArray[tostring(key)] = nil
		self.swinklePlayerList[tostring(key)] = nil
	end
end
function atlantisWarMiniMap:updateTeamMember(target, data)
	local notifyData = data.notifyData
	local key = serviceFunctions.getMapKey(notifyData.x - 1, notifyData.y - 1)
	if data.notifyType == "addPlayerCity" then
		_ENV = data.notifyType
		data.notifyType.x = notifyData.x
		local data.notifyType.y, memeber = notifyData.y, data.notifyType
		self:addTeamMember(key, memeber)
	elseif data.notifyType == "removePlayerCity" then
		self:removeTeamMember(key)
	end
end
function atlantisWarMiniMap:reqNotifyFocusPos(subPoint, mapId)
	local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
	atlantisWarCtrl:reqNotifyFocusPos(subPoint.x, subPoint.y, mapId)
end
function atlantisWarMiniMap:greenPointUpdate(target, data)
	if data.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR then
		print("==atlantisWarMiniMap:greenPointUpdate==")
		self:initQueueData()
	end
end
function atlantisWarMiniMap:addMiaozhunEffect(info)
	if self.miaozhunEffect then
		self.miaozhunEffect:removeFromParent()
		self.miaozhunEffect = nil
	end
	local effect = SoraDCreatAnimation("nodeEffect_miaozhun")
	effect:addTo(self.nodeWar)
	effect:setPosition(cc.p(info.x, info.y))
	self.miaozhunEffect = effect
end
function atlantisWarMiniMap:showFocusPosInCdMsgTip(...)
	if self.preClockTime then
		local curTime = SoraDGetSocketTime()
		local time = curTime - self.preClockTime
		if time < self.focusPosCdTime then
			local remain = self.focusPosCdTime - time
			_ENV = nil
			;(nil).time = SoraDConvertSecondToStringNoDayNoHour(remain)
			SoraDShowMsgTip(i18n("atlantiswar_text_0259", nil))
			return
		end
	end
	SoraDShowMsgTip(i18n("common_text_046"))
end
return atlantisWarMiniMap
