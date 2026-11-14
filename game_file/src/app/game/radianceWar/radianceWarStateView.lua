local kingdomMapUtil = include("kingdomMapUtil")
local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local mailFunctions = include("mailFunctions")
local instanceFactory = include("instanceFactory")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local radianceWarRead = include("radianceWarRead")
local radianceWarStateView = class("radianceWarStateView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarStateView")
	end
	return target
end)
function radianceWarStateView:ctor()
	self:_initData()
	self:_initUI()
end
function radianceWarStateView:_initData()
	self.myKingInfo, _UPVALUE0_, self.myPlaceInfo, _UPVALUE0_ = nil, nil, nil, nil
end
function radianceWarStateView:_initUI()
	SoraDGetAllChildFromWidget(self, self)
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Node_style_1:setVisible(false)
	self.Node_style_2:setVisible(false)
	self:_initFireNode()
	self:_initEffect()
end
function radianceWarStateView:_initFireNode()
	_UPVALUE2_ = nil
	;(nil)[1] = self.Node_fire_L
	;(nil)[2] = self.Node_fire_R
	for __, fire in ipairs(nil) do
		local nodeFire = _G.SoraDGetCommonJetFireNode(true)
		nodeFire:setPositionY(100)
		nodeFire:addTo(fire)
	end
end
function radianceWarStateView:_initEffect()
	self.particleSandArray = SoraDGetChildsArrayByName(self, "Particle_12_", 6, 1)
	local particleArray = SoraDGetChildsArrayByName(self, "Particle_AutoCell_", 7, 1)
	for i, v in ipairs(particleArray) do
		v:setAutoCull(false)
	end
	_UPVALUE3_ = nil
	;(nil)[1] = cca.callFunc(handler(self, self.resetParticalSystem))
	;(nil)[2] = cca.delay(3)
	;(nil)[3] = cca.callFunc(handler(self, self.stopParticalSystem))
	;(nil)[4] = cca.delay(3)
	;(nil)[5] = cca.delay(3)
	;(nil)[6] = cca.delay(3)
	self:runAction(cca.repeatForever(cca.seq(nil)))
	local cssFileName = "radianceWarStateView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, 40, false)
	if action and tolua.cast(action, "cc.Action") then
		action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			if frameEvent and frameEvent == "ShowRepeat" then
				action:gotoFrameAndPlay(40, 184, true)
			end
		end)
	end
	self:runAction(action)
end
function radianceWarStateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.reqInfoRsp))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_BUILD_UPDATE", handler(self, self.updateBuild))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function radianceWarStateView:initData(mapInstance, argList)
	self.argList = argList
	self.mapInstance = mapInstance
	self:setWarStatues()
	self:initTitle()
	SoraDGetAllChildFromWidget(self.Node_curStyle, self)
	self:initOpButton()
	self:fixNodePos()
	self:reqInfo()
end
function radianceWarStateView:setWarStatues()
	if self.mapInstance then
		self.kingWarState = self.mapInstance.warStatus
	end
end
function radianceWarStateView:initTitle(...)
	local instanceType = self.argList.instanceType
	if gMapObjTypeDef.mapTypeRadianceWarPalace == instanceType then
		self.Node_curStyle = self.Node_style_2
		local Sprite_bg = SoraDGetChildByName(self.Node_style_2, "Sprite_bg")
		local _, isDown = SoraDIsFileExistByFileName("bg_rydt_dt.png")
		if isDown then
			Sprite_bg:setSpriteFrame("bg_rydt_dt.png")
		else
			Sprite_bg:setSpriteFrame("bg_gmzz_beijing01.png")
		end
	elseif gMapObjTypeDef.mapTypeRadianceWarGate == instanceType then
		self.Node_curStyle = self.Node_style_1
	elseif gMapObjTypeDef.mapTypeRadianceWarBeacon == instanceType then
		self.Node_curStyle = self.Node_style_1
	end
	local name = radianceWarRead.getBuildName(instanceType, self.argList.siteClassID)
	self.title:setTitle(name)
	self.Node_curStyle:setVisible(true)
end
function radianceWarStateView:updateTimeTips(...)
	local instanceType = self.argList.instanceType
	if gMapObjTypeDef.mapTypeRadianceWarPalace == instanceType then
		self:updateTimeTipsPalace()
	else
		self:updateTimeTipsBeacon()
	end
end
function radianceWarStateView:updateTimeTipsPalace()
	local finishOccupyTime = self.myPlaceInfo.finishOccupyTime or 0
	local finishOccupy = self.myPlaceInfo.finishOccupy or false
	if finishOccupy then
		self.Node_time:setVisible(true)
		local sysTime = serviceFunctions.systemTime()
		self.timeNumber = sysTime - finishOccupyTime
		if 0 > self.timeNumber then
			self.timeNumber = 0
		end
		local histKingdomOccupySecs = self.myPlaceInfo.histKingdomOccupySecs or 0
		self.timeNumber = self.timeNumber + histKingdomOccupySecs
		_ENV = nil
		;(nil).time = ""
		self.Text_timeTips:setString(i18n("brightWar_text_36", nil))
		self.Text_time:beginTimeNode(function()
			self.timeNumber = self.timeNumber + 1
			return self.timeNumber
		end)
		SoraDToCenter(self.Node_time, nil, SoraDFIsRA())
	else
		self.Text_time:endTime()
		self.Node_time:setVisible(false)
	end
	self:updateView_player()
end
function radianceWarStateView:updateTimeTipsBeacon()
	local finishOccupyTime = self.myPlaceInfo.finishOccupyTime or 0
	local finishOccupy = self.myPlaceInfo.finishOccupy or false
	local sysTime = serviceFunctions.systemTime()
	self.timeNumber = finishOccupyTime - sysTime
	if finishOccupy or 0 >= self.timeNumber then
		self.Text_time:endTime()
		self.Node_time:setVisible(false)
		self:updateView_alliance()
	else
		_ENV = nil
		;(nil).time = ""
		self.Text_timeTips:setString(i18n("brightWar_text_35", nil))
		self.Text_time:beginTimeNode(function()
			self.timeNumber = self.timeNumber - 1
			if self.timeNumber <= 0 then
				self:reqInfo(true)
			end
			return self.timeNumber
		end)
		self.Node_time:setVisible(true)
		SoraDToCenter(self.Node_time, nil, SoraDFIsRA())
		self:updateView_player()
	end
end
function radianceWarStateView:updateView(...)
	self.Node_time:setVisible(false)
	self.Node_spine:setVisible(false)
	self.Node_tips:setVisible(false)
	self.Node_info:setVisible(false)
	self.Node_info_rule:setVisible(false)
	self.Node_info_inwar:setVisible(false)
	self.Node_ParticleS:setVisible(false)
	self.Sprite_state:setVisible(false)
	self.Sprite_state_war:setVisible(false)
	if self.myPlaceInfo.finishOccupyTime == nil then
		self.kingWarState = gKingdomWarStatusType.close
	end
	if gKingdomWarStatusType.close == self.kingWarState then
		local occupyUsrData = self.myPlaceInfo
		if occupyUsrData and occupyUsrData.aid and occupyUsrData.aid > 0 then
			self:updateView_protect()
		else
			self:updateView_close()
		end
	elseif gKingdomWarStatusType.inWar == self.kingWarState then
		self:updateView_inWar()
	elseif gKingdomWarStatusType.rule == self.kingWarState then
		self:updateView_rule()
	end
end
function radianceWarStateView:updateView_close(...)
	self.Text_status:setString(i18n("common_text_4210"))
	self.Text_status:setColor(cc.c3b(94, 235, 61))
	self.Sprite_state:setVisible(true)
	self.Sprite_state:setPositionX(self.Text_status:getPositionX() + SoraDFSign(0.5 * self.Text_status:getContentSize().width + 30))
	self.Node_tips:setVisible(true)
	self.Text_tips:setString(i18n("common_text_1450"))
end
function radianceWarStateView:updateView_inWar(...)
	self.Text_status:setString(i18n("common_text_1446"))
	self.Text_status:setColor(cc.c3b(239, 1, 1))
	self.Sprite_state_war:setVisible(true)
	self.Sprite_state_war:setPositionX(self.Text_status:getPositionX() + SoraDFSign(0.5 * self.Text_status:getContentSize().width + 30))
	self:updateTimeTips()
end
function radianceWarStateView:updateView_player()
	self.Node_ParticleS:setVisible(true)
	self.Node_info:setVisible(true)
	self.Node_info_inwar:setVisible(true)
	self:updateOccupyInfo_spine(self.myPlaceInfo.iconID)
	self:updateOccupyInfo_num(self.myPlaceInfo)
	SoraDGetAllChildFromWidget(self.Node_info_inwar, self)
	local str = mailFunctions:getWrappedName(self.myPlaceInfo.abbr, self.myPlaceInfo.name, self.myPlaceInfo.fromKid)
	self.Text_player:setString(str)
	self.Text_alliance:setString(self.myPlaceInfo.aName)
	SoraDGetAllianceFlagByFid(self.myPlaceInfo.flag):addTo(self.Node_flag)
	self.Node_flag:setPositionX(SoraDFPosX(self.Text_alliance:getContentSize().width / 2 + 30, 0))
	self.Button_FlagTouch:setPositionX(self.Node_flag:getPositionX())
	self.Button_FlagTouch:setTouchEnabled(true)
	self.Button_FlagTouch:addTouchEventListener(handler(self, self.btnFlagClick))
	self.Image_playerHead:setTouchEnabled(true)
	self.Image_playerHead:addTouchEventListener(handler(self, self.btnPlayerHeadClick))
	SoraDGetHeadFromManager(self.Image_playerHead, self.myPlaceInfo.iconID, self.myPlaceInfo.avatar)
end
function radianceWarStateView:updateView_protect(...)
	self.Text_status:setString(i18n("common_text_690"))
	self:updateView_ProtectImp()
end
function radianceWarStateView:updateView_rule(...)
	self.Text_status:setString(i18n("common_text_4210"))
	self:updateView_ProtectImp()
end
function radianceWarStateView:updateView_ProtectImp(...)
	self.Text_status:setColor(cc.c3b(94, 235, 61))
	self.Sprite_state:setVisible(true)
	self.Sprite_state:setPositionX(self.Text_status:getPositionX() + SoraDFSign(0.5 * self.Text_status:getContentSize().width + 30))
	self:updateView_alliance()
end
function radianceWarStateView:updateView_alliance()
	self.Node_info:setVisible(true)
	self.Node_info_rule:setVisible(true)
	SoraDGetAllChildFromWidget(self.Node_info_rule, self)
	self:updateOccupyInfo_spine(self.myPlaceInfo.iconID)
	self:updateOccupyInfo_num(self.myPlaceInfo)
	local str = mailFunctions:getWrappedName(self.myPlaceInfo.abbr, self.myPlaceInfo.aName, self.myPlaceInfo.fromKid)
	self.Text_alliance:setString(str)
	SoraDGetAllianceFlagByFid(self.myPlaceInfo.flag):addTo(self.Node_flag)
	self.Button_FlagTouch:setTouchEnabled(true)
	self.Button_FlagTouch:addTouchEventListener(handler(self, self.btnFlagClick))
end
function radianceWarStateView:updateOccupyInfo_num(occupyUsrData)
	if not self:checkSameAlliance(occupyUsrData.aid) then
		self.Node_troop:setVisible(false)
		return
	end
	if occupyUsrData.maxNum then
		local curNum = 0
		if self.argList.armyData then
			curNum = kingdomMapUtil.getArmyCount(self.argList.armyData)
		elseif self.argList.armyNum then
			curNum = self.argList.armyNum
		end
		self.Text_troop:setString(curNum .. "/" .. occupyUsrData.maxNum)
		self.Text_troop:setPositionX(SoraDFSign(-20))
		self.Image_troop:setPositionX(SoraDFPosX(self.Text_troop:getPositionX() + self.Text_troop:getContentSize().width / 2 + 30, 0))
		self.Node_troop:setVisible(true)
	else
		self.Node_troop:setVisible(false)
	end
end
function radianceWarStateView:updateOccupyInfo_spine(imageId)
	self.Node_spine:setVisible(true)
	if not self.spineNode then
		local node = SoraDCreatePanel("lordSpineNode")
		node:addTo(self.Node_spine)
		node:setPosition(0, 200)
		self.spineNode = node
	end
	self.spineNode:setCascadeOpacityEnabled(true)
	self.spineNode:initData(imageId)
end
function radianceWarStateView:fixNodePos(...)
	local posy = math.max(-722, 414 - display.height)
	self.Node_curStyle:setPositionY(posy)
	self.Image_wall:setFillType(1)
	local sSize = self.Image_wall:getContentSize()
	local offset = math.max(0, display.height - 1136)
	self.Image_wall:setContentSize(cc.size(sSize.width, sSize.height + offset))
	self.Bottom_Node:setPositionY(self.Bottom_Node:getPositionY() - offset)
	self.Node_tips:setPositionY(self.Node_tips:getPositionY() - offset / 2)
	self.Node_info:setPositionY(self.Node_info:getPositionY() - offset / 2)
	self.Sprite_bg:setPositionY(self.Sprite_bg:getPositionY() - math.max(0, 1060 - display.height))
	if self.spineNode then
		local scale = 1 - math.max(0, (1000 - display.height) / 147 * 0.3)
		self.spineNode:setPositionY(scale * self.spineNode:getPositionY())
		self.spineNode:setScale(scale)
	end
end
function radianceWarStateView:reqInfo(isRefresh)
	local instanceType = self.argList.instanceType
	if gMapObjTypeDef.mapTypeRadianceWarPalace == instanceType then
		if not self.reqMsg then
			self.reqMsg = true
			SoraDShowLoading(self)
			local kingdomID = worldMapDefine.currentMapKindomID
			kingdomMapCtrl:reqPlaceOwnerInfo(kingdomID, self.argList.siteClassID)
		end
		if isRefresh then
			self:requestInstanceInfo()
		end
	else
		self:requestInstanceInfo()
	end
end
function radianceWarStateView:requestInstanceInfo()
	if not self.mapInstance or not self.mapInstance.__cname then
		return
	end
	local mapInstance = self.mapInstance
	if mapInstance and not self.reqObjMsg then
		local tilePoint = mapInstance:getTilePoint()
		local instanceID = mapInstance:getInstanceID()
		local kingdomID = mapInstance:getWorldMapCell().kingdomID
		self.reqObjMsg = true
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID, kingdomID)
	end
end
function radianceWarStateView:reqInfoRsp(target, data)
	if data and data.retdata then
		self.reqMsg = false
		self:updateData(data.retdata)
		SoraDCloseLoading(self)
	end
end
function radianceWarStateView:updateData(data)
