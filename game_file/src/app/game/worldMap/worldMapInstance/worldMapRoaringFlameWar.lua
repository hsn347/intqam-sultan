local gametop = gModuleMgr.getObject("gametop")
local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local worldMapInstance = include("worldMapInstance")
local worldMapRoaringFlameWar = class("worldMapRoaringFlameWar", function()
	local target = worldMapInstance.new("worldMapRoaringFlameWar")
	include("worldMapBuildOccupyTime").new(target)
	return target
end)
function worldMapRoaringFlameWar:ctor()
	self:_initData()
	self:_initUI()
end
function worldMapRoaringFlameWar:_initData(...)
	self.siteClassID = nil
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.collecterMap, _ENV, self.connect, _ENV, self.camp = gKingdomWarStatusType.close, gKingdomWarStatusType.close, gKingdomWarStatusType.close, gKingdomWarStatusType.close, 0
	self.protectScale = 0.7
	self:_initOccupyTimeData()
end
function worldMapRoaringFlameWar:_initUI(...)
	local obj = fgui.UIPackage:createObject("RoaringFlameWorldMap", "worldMapRoaringFlameWar")
	obj:addTo(self)
	self.fields = fguiHelper.get_fields(obj)
	self.fields.Node_player:setVisible(false)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 50))
	self.image_Protect:addTo(self, 1)
	self.Label_protect = SoraDCreateTimerLabel(self, self.fields.Label_protect)
	self.Label_protect:setTimeEndListener(function(...)
		self:updateSafeState()
		self:updateLabelProtect()
	end)
end
function worldMapRoaringFlameWar:addCacheBefore(...)
	local nodeEffect_unlock = SoraDGetChildByName(self, "nodeEffect_unlock")
	if nodeEffect_unlock then
		nodeEffect_unlock:removeFromParent()
	end
end
function worldMapRoaringFlameWar:setBatchNodeGroupID(groupID)
	self.fields.Com_build:setGroupID(groupID)
end
function worldMapRoaringFlameWar:getSiteClassID()
	return self.siteClassID
end
function worldMapRoaringFlameWar:getObjId()
	return self.objId
end
function worldMapRoaringFlameWar:getSubType()
	return self.subType
end
function worldMapRoaringFlameWar:getConnect()
	return self.connect
end
function worldMapRoaringFlameWar:getConnectCamp(...)
	local index = next(self.connect)
	if index then
		return self.connect[index].camp
	end
end
function worldMapRoaringFlameWar:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapRoaringFlameWar:initInstanceData(siteClassID, siteData, objId)
	print("==worldMapRoaringFlameWar==", siteClassID, objId)
	self.siteClassID = siteClassID
	self.objId = objId
	self.subType = roaringFlameWarRead.getBuildSubType(self.objId)
	if roaringFlameWarRead.checkShowRolygonSubType(self.subType) then
		local buildRect = roaringFlameWarRead.getBuildRect(self.objId)
		self.rolygonSize = cc.size(buildRect.width + 1, buildRect.height + 1)
	end
	self.fields.Com_build:initObjId(self.objId)
	local buildName = roaringFlameWarRead.getBuildName(self.subType)
	self.fields.Text_build:setString(buildName)
	local level = roaringFlameWarRead.getBuildLevel(self.objId)
	self.fields.Text_lv:setString(level)
	local scale = roaringFlameWarUtil.getProtectScale(self.subType)
	self.image_Protect:setScale(self.protectScale * scale)
	roaringFlameWarUtil.initBuild(self)
	self:updateData(siteData)
end
function worldMapRoaringFlameWar:updateData(data)
	if not data then
		return
	end
	dump(data, "==worldMapRoaringFlameWar:updateData==")
	self.data = data
	if data.playerID then
		self.playerID = data.playerID
	end
	self.fromKid = data.fromKid
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.connect then
		self.connect = data.connect
	end
	if data.camp then
		self.camp = data.camp
	end
	if data.collecterMap then
		self.collecterMap = data.collecterMap
	end
	self:updateEmojiByData(data)
	self:updatePlayerInfo(data)
	self:updateSafeState()
	self:updateFireEffect(self.buildState)
	self:updateCollectInfo()
	self:updateDataOccupyTime(data)
	if self.camp and self.camp > 0 then
		if self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
			self:setPalaceOccupyTimeShow(true)
			local progressBar = self.finishOccupy_progressBar
			if progressBar then
				progressBar:setPositionY(-28)
			end
		else
			self:setOccupyTimeShow(true)
			local progressBar = self.finishOccupy_progressBar
			if progressBar then
				progressBar:setPositionY(15)
			end
		end
	elseif self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
		self:setPalaceOccupyTimeShow(false)
	else
		self:setOccupyTimeShow(false)
	end
	self:updateLabelProtect()
	_ENV = self
	self.msg = "MESSAGE_ROARINGFLAMEWAR_BUILD_UPDATE"
	self.objId = self.objId
	self.camp = data.finishOccupy and self.camp or 0
	self.connect = self.connect
	SoraDSendMessage(self)
	if data.protectEndTime then
		self:updateProtectEndTime(data)
	end
end
function worldMapRoaringFlameWar:updatePlayerInfo(data)
	if self.camp and self.camp > 0 then
		self.fields.Node_player:setVisible(true)
		if self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
			self.fields.Node_player:setPositionY(-66)
		else
			self.fields.Node_player:setPositionY(10)
		end
		local nameColor = roaringFlameWarRead.getCampColor(self.camp)
		self.rolygonColor = nameColor
		self.fields.Text_camp:setColor(nameColor)
		self.fields.Text_player:setColor(nameColor)
		local campName = roaringFlameWarRead.getCampName(self.camp)
		self.fields.Text_camp:setString(campName)
		local playerName = textParser.formatPlayerName(nil, data.playerName, self.fromKid)
		self.fields.Text_player:setString(playerName)
	else
		self.fields.Node_player:setVisible(false)
		self.rolygonColor = cc.c3b(255, 255, 255)
	end
	local buildLvImage = roaringFlameWarRead.getCampBuildLvImage(self.camp or 0)
	self.fields.Load_lv:setURL(buildLvImage)
end
function worldMapRoaringFlameWar:updateSafeState()
	if self:checkProtectEndTime() then
		self.image_Protect:setVisible(true)
		return
	end
	if not self:checkOpenTime() then
		self.image_Protect:setVisible(true)
		return
	end
	_ENV = self.image_Protect.setVisible
	self.image_Protect.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix] = true
	self.image_Protect.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine] = true
	local self.image_Protect.setVisible[gWorldTypeServerDef.subTypeRoaringFlameWarGoldMine], config = true, self.image_Protect.setVisible
	if config[self.subType] or self:checkInWarStatus() then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapRoaringFlameWar:checkOpenTime(...)
	local openTime = self.data.openTime
	if openTime and openTime > serviceFunctions.systemTime() then
		return false
	else
		return true
	end
end
function worldMapRoaringFlameWar:getFavoriteName()
	return roaringFlameWarRead.getBuildName(self.subType)
end
function worldMapRoaringFlameWar:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapRoaringFlameWar:getSelfCollectInfo(...)
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	return self.collecterMap[tostring(selfPlayerID)]
end
function worldMapRoaringFlameWar:updateCollectInfo(...)
	if not roaringFlameWarUtil.checkIsMineBuild(self.subType) then
		self:cancelBeCollected()
		return
	end
	if next(self.collecterMap) then
		self:setBeCollected()
	else
		self:cancelBeCollected()
	end
	local buildName = roaringFlameWarRead.getBuildName(self.subType)
	local camp = self:getConnectCamp()
	if camp then
		local campName = roaringFlameWarRead.getCampName(camp)
		local buildStr = string.format("%s[%s]", buildName, campName)
		self.fields.Text_build:setString(buildStr)
	else
		self.fields.Text_build:setString(buildName)
	end
end
function worldMapRoaringFlameWar:setBeCollected(...)
	local occupyIconName = "icon_map_res_normal.png"
	if self:getSelfCollectInfo() then
		occupyIconName = "icon_map_res_me.png"
	else
		local selfCamp = roaringFlameWarCtrl:getSelfCamp()
		if selfCamp == self:getConnectCamp() then
			self:cancelBeCollected()
			return
		else
			occupyIconName = "icon_map_res_normal.png"
		end
	end
	if not self.occupyIcon then
		self.occupyIcon = display.newSpriteNoChild("#icon_map_res_me.png")
		self.occupyIcon:setAnchorPoint(0.5, 0.0)
		self.occupyIcon:setVisible(false)
		self:addChild(self.occupyIcon, 2)
		self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	end
	self.occupyIcon:setVisible(true)
	self.occupyIcon:setSpriteFrame(occupyIconName)
end
function worldMapRoaringFlameWar:cancelBeCollected()
	if self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
end
function worldMapRoaringFlameWar:updateLabelProtect(...)
	self.Label_protect:setVisible(false)
	if not self.image_Protect:isVisible() then
		return
	end
	local remain, pType = self:getProtectTime()
	if remain and 0 < remain then
		if pType == 1 then
			self.Label_protect:setTimeLast(function(time)
				_ENV = nil
				;(nil).var = time
				return i18n("alliance_stronghold_text_040", nil)
			end)
		else
			self.Label_protect:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("flames_dunes_text344", nil)
			end)
		end
		self.Label_protect:setVisible(true)
		self.Label_protect:beginTime(remain)
		return
	end
end
function worldMapRoaringFlameWar:getProtectTime(...)
	if not self:checkOpenTime() then
		local remain = self.data.openTime - serviceFunctions.systemTime()
		if 0 < remain then
			return remain, 1
		end
	end
	local remain = self:getProtectEndTimeRemain()
	if 0 < remain then
		return remain, 2
	end
	local remain = roaringFlameWarUtil.getPeaceStateRemainTime()
	if 0 < remain then
		return remain, 1
	end
end
function worldMapRoaringFlameWar:checkProtectEndTime(...)
	local remain = self:getProtectEndTimeRemain()
	return 0 < remain
end
function worldMapRoaringFlameWar:getProtectEndTimeRemain(...)
	local protectEndTime = self.data.protectEndTime or 0
	local remain = protectEndTime - serviceFunctions.systemTime()
	return remain
end
function worldMapRoaringFlameWar:updateProtectEndTime(data)
	local protectEndTime = data.protectEndTime
	if self.protectEndTime ~= protectEndTime then
		self.protectEndTime = protectEndTime
		local halfInstace = (self:getHoldInstace() - 1) * 0.5
		local showTilePoint = cc.p(self.tilePoint.x + halfInstace, self.tilePoint.y + halfInstace)
		_UPVALUE1_ = self.tilePoint.x + halfInstace
		local (self.tilePoint.x + halfInstace)[1], tilePointArray = showTilePoint, self.tilePoint.x + halfInstace
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		;(nil).relatedTilePoints = tilePointArray
		SoraDSendMessage(nil)
		if self.protectEndTime > 0 then
			self:showNodeEffectUnlock()
		end
	end
end
function worldMapRoaringFlameWar:showNodeEffectUnlock()
	local nodeEffect = roaringFlameWarUtil.showNodeEffectUnlock(self)
	if not nodeEffect then
		return
	end
	roaringFlameWarUtil = self
	self[8] = 2
	self[9] = 2
	self[10] = 2
	self[11] = 1
	self[12] = 1
	local self[13], cofnig = 2, self
	local scale = cofnig[self.subType] or 1.23
	nodeEffect:setScale(scale)
	roaringFlameWarUtil = nodeEffect.setScale
	nodeEffect.setScale[3] = 140
	nodeEffect.setScale[6] = 170
	local nodeEffect.setScale[7], cofnig = 170, nodeEffect.setScale
	local Node_3 = SoraDGetChildByName(nodeEffect, "Node_3")
	Node_3:setPositionY(cofnig[self.subType] or 130)
end
function worldMapRoaringFlameWar:onClickInstance(onShowView)
	self:playClickSound()
	local tilesRolygon
	if roaringFlameWarRead.checkShowRolygonSubType(self.subType) then
		tilesRolygon = include("worldMapTilesRolygon").new(self.rolygonSize, 2)
		tilesRolygon:setRolygonColor(self.rolygonColor)
	end
	local selectShowPanel = self:onShowWorldMapTip(onShowView)
	return selectShowPanel, true, tilesRolygon
end
function worldMapRoaringFlameWar:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if not self:checkOpenTime() then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, nil)
		return buttonTypeArray
	end
	local selfKid = gametop.playertop_:getKingdomID()
	local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
	local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
	if roaringFlameWarUtil.checkIsMineBuild(self.subType) then
		if self:getSelfCollectInfo() then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
			table.insert(buttonTypeArray, nil)
		else
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
			table.insert(buttonTypeArray, nil)
		end
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
		table.insert(buttonTypeArray, nil)
		return buttonTypeArray
	end
	if self:checkInWarStatus() or self:checkProtectEndTime() then
		if not self.fromKid or self.fromKid == 0 then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, nil)
			if haveHall then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
				table.insert(buttonTypeArray, nil)
			end
		elseif selfKid ~= self.fromKid then
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, nil)
			if haveHall then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
				table.insert(buttonTypeArray, nil)
			end
			if 1 < towerLv then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				table.insert(buttonTypeArray, nil)
			end
		elseif selfKid == self.fromKid then
			local hasArmy, queueId = self:checkHasArmy()
			if hasArmy and queueId and (not _G._returnQueueIdList or not _G._returnQueueIdList[queueId]) then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, nil)
			end
			if self:canHasEmojiOperator() then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, nil)
			end
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, nil)
			_ENV = nil
			;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
			table.insert(buttonTypeArray, nil)
			if haveHall then
				_ENV = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
				table.insert(buttonTypeArray, nil)
			end
		end
	elseif self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix then
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
		table.insert(buttonTypeArray, table.insert)
		_ENV = table.insert
		table.insert.buttonType = worldMapDefine.worldMapTipButtonType_9001674_phoenix
		table.insert(buttonTypeArray, table.insert)
	end
	_ENV = table.insert
	table.insert.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, table.insert)
	return buttonTypeArray
end
function worldMapRoaringFlameWar:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	if tipButtonType == worldMapDefine.worldMapTipButtonType_shuoMing then
		if roaringFlameWarUtil.checkIsMineBuild(self.subType) then
			_ENV = nil
			;(nil).instanceType = gMapObjTypeDef.roaringFlameWarBuilding
			;(nil).classId = self.subType
			uiManager:show("WorldMapExplain", nil)
		else
			_ENV = nil
			;(nil).objId = self.objId
			;(nil).data = self.data
			uiManager:show("RoaringFlameWar_Build", nil)
		end
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_zhanLing or tipButtonType == worldMapDefine.worldMapTipButtonType_fanHui then
		if roaringFlameWarUtil.checkIsMineBuild(self.subType) then
			local selfCamp = roaringFlameWarCtrl:getSelfCamp()
			if selfCamp == self:getConnectCamp() then
				if self:getSelfCollectInfo() then
					SoraDShowMsgBox(i18n("notice_0025"), i18n("common_text_054"), i18n("common_text_185"), function(callType)
						if callType == MSGBOX_CALLBACK_YES then
							roaringFlameWarCtrl:reqStopCollect(self.objId)
						end
					end)
				elseif roaringFlameWarUtil.checkCollQueueCount() then
					roaringFlameWarCtrl:reqCollect(self.objId)
				else
					local isActive = roaringFlameWarCtrl:isSeniorRewardLock()
					SoraDShowMsgTip(isActive and i18n("flames_dunes_text236") or i18n("flames_dunes_text349"))
				end
			else
				SoraDShowMsgTip(i18n("flames_dunes_text235"))
			end
			return true
		end
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_xiangqing then
		if roaringFlameWarUtil.checkIsMineBuild(self.subType) then
			_ENV = i18n("flames_dunes_text235")
			i18n("flames_dunes_text235").objId = self.objId
			i18n("flames_dunes_text235").camp = self:getConnectCamp()
			i18n("flames_dunes_text235").collecterList = tipButtonData.collecterList
			uiManager:show("RoaringFlameWar_Collect", i18n("flames_dunes_text235"))
			return true
		end
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_9001674_phoenix then
		uiManager:show("RoaringFlame_PhoenixMain")
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_gongJi or tipButtonType == worldMapDefine.worldMapTipButtonType_xuanZhan then
		if self:checkProtectEndTime() then
			SoraDShowMsgTip(i18n("flames_dunes_text345"))
			return true
		end
		if not self:checkPermissionAttackBuild() then
			return true
		end
		local buildCamp = roaringFlameWarRead.getBuildCamp(self.objId)
		local selfCamp = roaringFlameWarCtrl:getSelfCamp()
		if buildCamp ~= 0 and buildCamp ~= selfCamp then
			local campName = roaringFlameWarRead.getCampName(buildCamp)
			_ENV = i18n("flames_dunes_text345")
			i18n("flames_dunes_text345").camp = campName
			SoraDShowMsgTip(i18n("flames_dunes_text285", i18n("flames_dunes_text345")))
			return true
		end
		if not self:checkInWarStatus() and self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix and self.camp ~= selfCamp then
			local buildName = roaringFlameWarRead.getBuildName(self.subType)
			_ENV = i18n("flames_dunes_text285", i18n("flames_dunes_text345"))
			i18n("flames_dunes_text285", i18n("flames_dunes_text345")).city = buildName
			i18n("flames_dunes_text285", i18n("flames_dunes_text345")).monster = i18n("flames_dunes_text298")
			SoraDShowMsgTip(i18n("flames_dunes_text241", i18n("flames_dunes_text285", i18n("flames_dunes_text345"))))
			return true
		end
		local isConnect = false
		if self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarInitCity then
			isConnect = true
		else
			local binding = roaringFlameWarRead.getBuildBinding(self.objId)
			for __, _objId in ipairs(binding) do
				local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(_objId)
				if owner then
					isConnect = true
					break
				end
			end
		end
		if not isConnect then
			SoraDShowMsgTip(i18n("flames_dunes_text283"))
			return true
		end
	elseif (tipButtonType == worldMapDefine.worldMapTipButtonType_shibingYuabzhu or tipButtonType == worldMapDefine.worldMapTipButtonType_zuduiYuanzhu) and not self:checkPermissionAttackBuild() then
		return true
	end
end
function worldMapRoaringFlameWar:checkPermissionAttackBuild()
	if not self:checkInWarStatus() and self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix then
		return true
	end
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.ATTACK_BUILD, true) then
		return false
	end
	return true
end
return worldMapRoaringFlameWar
