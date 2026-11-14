local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapFortress = class("worldMapFortress", function(target)
	local target = include("worldMapInstance").new("worldMapFortress")
	return target
end)
function worldMapFortress:ctor()
	self:addFortressEffect()
	self:_initUI()
	self:_initData()
end
function worldMapFortress:_initData()
	self.battleState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.modelState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warStatus = gKingdomWarStatusType.close
	self.kingStatus = gKingStatus.none
end
function worldMapFortress:_initUI()
	self.modelImage = display.newSprite("#Map_build_fort.png")
	self.modelImage:setPosition(cc.p(0, 45))
	self:addChild(self.modelImage, -1)
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(0.7)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 150))
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
function worldMapFortress:addCacheBefore()
	self.image_Protect:setVisible(false)
end
function worldMapFortress:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapFortress:initInstanceData(fortressData)
	self:updateData(fortressData)
end
function worldMapFortress:updateData(data)
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
		self.battleState = data.status
	end
	if data.modelState then
		self.modelState = data.modelState
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
	self:updateBattleState()
	self:updateModelState()
end
function worldMapFortress:updatePlayerInfo()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	if self.leagueID and self.leagueID > 0 then
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local selfSourceID = lordInfoCtrl:getMapSourceKid()
		if 0 < self.sourceID and selfSourceID ~= self.sourceID then
			self.text_league_Name:setColor(cc.c3b(200, 0, 0))
			self.text_player_Name:setColor(cc.c3b(200, 0, 0))
		elseif self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_league_Name:setColor(nameColor)
			self.text_player_Name:setColor(nameColor)
		else
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
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
function worldMapFortress:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
	else
		self.image_Protect:setVisible(true)
	end
end
function worldMapFortress:updateBattleState()
	self:updateFireEffect(self.battleState)
end
function worldMapFortress:updateModelState()
	if self.modelState == gMapObjStateTypeDef.gMapObjStateTypeFree then
		self:doFreeAnimation()
	elseif self.modelState == gMapObjStateTypeDef.gMapObjStateTypeFighting then
		self:doFightingAnimation()
	elseif self.modelState == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		self:doHurtDieAnimation()
	end
end
function worldMapFortress:doFreeAnimation()
end
function worldMapFortress:doFightingAnimation()
end
function worldMapFortress:doHurtDieAnimation()
end
function worldMapFortress:addFortressEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33.78
	_ENV, (nil).pos, (nil).y = nil, nil, 41.28
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 34.25
	_ENV, (nil).pos, (nil).y = nil, nil, 70.5
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 36.07
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 106.15
	local param
	local fire_1 = SoraDCreateEffectNode(param)
	fire_1:setScale(0.45)
	fire_1:setRotation(15)
	fire_1:setPosition(cc.p(-80, 130))
	fire_1:addTo(self, 2)
	local fire_2 = SoraDCreateEffectNode(param)
	fire_2:setScale(0.35)
	fire_2:setRotation(15)
	fire_2:setPosition(cc.p(79, 22))
	fire_2:addTo(self, 2)
	local qizhi = display.newSprite("#ysqz_01.png")
	qizhi:setPosition(cc.p(118, 150))
	qizhi:addTo(self, 2)
	local frames = display.newFrames("ysqz_%.2d.png", 1, 8)
	local animation = display.newAnimation(frames, 1 / #frames)
	qizhi:playAnimationForever(animation)
end
function worldMapFortress:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapFortress:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	print("点击要塞")
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
return worldMapFortress
