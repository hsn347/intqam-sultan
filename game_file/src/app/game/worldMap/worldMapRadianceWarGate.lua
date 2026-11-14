local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local worldMapDefine = include("worldMapDefine")
local worldMapInstance = include("worldMapInstance")
local radianceWarRead = include("radianceWarRead")
local worldMapRadianceWarGate = class("worldMapRadianceWarGate", function()
	local target = worldMapInstance.new("worldMapRadianceWarGate")
	include("worldMapBuildOccupyTime").new(target)
	include("worldMapBuildConnect").new(target)
	include("worldMapBuildProtectTips").new(target)
	return target
end)
local GROU_ID = worldMapDefine.GROU_ID
function worldMapRadianceWarGate:ctor()
	self:_initUI()
	self:_initData()
end
function worldMapRadianceWarGate:_initData()
	self.playerID = 0
	self.playerName = nil
	self.sourceID = 0
	self.iconID = nil
	self.avatar = nil
	self.leagueID = 0
	self.leagueName = nil
	self.leagueFlag = 1
	self.warStatus = gKingdomWarStatusType.close
	self.buildState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.level = 1
	self.isIn = false
	self.hp = 0
	self.hpMax = nil
	self.recoverHpTime = 0
	self:_initOccupyTimeData()
	self:_initBuildConnect()
	self:_initProtectData()
end
function worldMapRadianceWarGate:_initBuildBg()
	self.bgImage = display.newSpriteNoChild("#Map_build_radiance_gate_01.png")
	self.bgImage:setPosition(cc.p(self.centerPoint.x - 45, self.centerPoint.y + 50))
	self:addChild(self.bgImage, -1)
end
function worldMapRadianceWarGate:_initUI()
	self:_initBuildBg()
	self.image_Protect = worldMapDefine.createWorldMapProtect()
	self.image_Protect:setScale(1.0)
	self.image_Protect:setPosition(cc.p(self.centerPoint.x + 0, self.centerPoint.y + 80))
	self.image_Protect:addTo(self, 1)
	self.image_LeagueFlag = display.newSpriteNoChild(allianceDesRead.getFlagIcon(self.leagueFlag, true))
	self.image_LeagueFlag:setScale(0.3)
	self.image_LeagueFlag:setPosition(cc.p(self.centerPoint.x - 98, self.centerPoint.y - 10))
	self.image_LeagueFlag:setVisible(false)
	self.image_LeagueFlag:addTo(self, 1)
	self.image_LeagueFlag:setGroupID(GROU_ID.group_flag)
	self.image_build_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 90))
	self.image_build_name:addTo(self, 1)
	self.image_build_name:setGroupID(GROU_ID.group_level_build)
	worldMapDefine = self.image_build_name
	self.image_build_name.UILabelType = 2
	self.image_build_name.text = ""
	self.image_build_name.size = 20
	self.text_build_name = SoraDCreateLabelNoChild(self.image_build_name)
	self.text_build_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_build_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 90))
	self.text_build_name:addTo(self, 1)
	self.text_build_name:setGroupID(GROU_ID.group_text)
	self.image_player_name = display.newSpriteNoChild("#frame_map_07.png")
	self.image_player_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_player_name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 54))
	self.image_player_name:setVisible(false)
	self.image_player_name:addTo(self, 1)
	self.image_player_name:setGroupID(GROU_ID.group_level_build)
	worldMapDefine = self.image_player_name
	self.image_player_name.UILabelType = 2
	self.image_player_name.text = ""
	self.image_player_name.size = 20
	self.text_player_Name = SoraDCreateLabelNoChild(self.image_player_name)
	self.text_player_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_player_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 54))
	self.text_player_Name:setVisible(false)
	self.text_player_Name:addTo(self, 1)
	self.text_player_Name:setGroupID(GROU_ID.group_text)
end
function worldMapRadianceWarGate:_initProgressBar()
	if not self.progressBar then
		local progressBar = SoraDCreatePanel("worldMapBossProgressBar")
		progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 25))
		progressBar:setAnchorPoint(cc.p(0.5, 0.5))
		progressBar:addTo(self, 1)
		progressBar:setVisible(false)
		progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
		progressBar:setGroupAuto(true)
		self.progressBar = progressBar
	end
end
function worldMapRadianceWarGate:updateProcessBar()
	if self.warStatus == gKingdomWarStatusType.inWar and self.hp and self.hp > 0 then
		self:showProcessBar()
		if not self.hpMax then
			local hpMax = radianceWarRead.getBuildHpByObjectId(self.siteClassID) or 1
			self.hpMax = math.max(hpMax, 1)
		end
		local leftLife = math.floor(self.hp / self.hpMax * 100)
		self.progressBar:setPercent(leftLife)
		if self.recoverHpTime and 0 < self.recoverHpTime then
			self.progressBar:updateTips(self.recoverHpTime)
		else
			self.progressBar:updateTips(0)
		end
	else
		self:hideProcessBar()
	end
end
function worldMapRadianceWarGate:showProcessBar()
	if not self.progressBar then
		self:_initProgressBar()
	end
	if self.progressBar then
		self.progressBar:setVisible(true)
	end
end
function worldMapRadianceWarGate:hideProcessBar()
	if self.progressBar then
		self.progressBar:setVisible(false)
	end
end
function worldMapRadianceWarGate:showNodeEffectFire()
	if not self.nodeEffect_fire then
		self:_initNodeEffectFire()
	end
	if self.nodeEffect_fire then
		self.nodeEffect_fire:setVisible(true)
		for i, v in ipairs(self.nodeEffect_fire:getChildren()) do
			v:setVisible(false)
		end
		local nodeName = radianceWarRead.getBuildGateNodeName(self.siteClassID)
		if nodeName then
			local effectNode = SoraDGetChildByName(self.nodeEffect_fire, nodeName)
			if effectNode then
				effectNode:setVisible(true)
				local pos, scale = radianceWarRead.getBuildGatePos(self.siteClassID)
				effectNode:setPosition(pos)
				effectNode:setScale(scale)
			end
		end
	end
end
function worldMapRadianceWarGate:hideNodeEffectFire()
	if self.nodeEffect_fire then
		self.nodeEffect_fire:setVisible(false)
	end
end
function worldMapRadianceWarGate:_initNodeEffectFire()
	if not self.nodeEffect_fire then
		local nodeEffect = SoraDCreatAnimation("Node_Effect_lzjzcq01")
		nodeEffect:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y))
		nodeEffect:addTo(self, 1)
		nodeEffect:setVisible(false)
		self.nodeEffect_fire = nodeEffect
	end
end
function worldMapRadianceWarGate:getSiteClassID()
	return self.siteClassID
end
function worldMapRadianceWarGate:addCacheBefore()
	self:resetOccupyTime()
	self:resetProtectime()
	self:hideNodeEffectFire()
end
function worldMapRadianceWarGate:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapRadianceWarGate:initInstanceData(siteClassID, siteData, objId)
	self.siteClassID = objId
	if self.siteClassID then
		local imgName = radianceWarRead.getBuildImage(gMapObjTypeDef.mapTypeRadianceWarGate, objId)
		self.bgImage:setSpriteFrame(imgName)
		local x, y = radianceWarRead.getBuildPos(objId)
		self.bgImage:setPosition(cc.p(x, y))
		local name = radianceWarRead.getBuildName(gMapObjTypeDef.mapTypeRadianceWarGate, objId)
		self.text_build_name:setString(name)
		self.image_Protect:setPosition(cc.p(self.centerPoint.x + x, self.centerPoint.y + y + 110))
	end
	self:updateData(siteData)
end
function worldMapRadianceWarGate:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.headid then
		self.iconID = data.headid
	end
	if data.avatar then
		self.avatar = data.avatar
	end
	if data.playerName then
		self.playerName = data.playerName
	end
	if data.leagueID then
		self.leagueID = data.leagueID
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
	if data.sourceKid then
		self.sourceID = data.sourceKid
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.status then
		self.buildState = data.status
	end
	if data.level then
		self.level = data.level
	end
	if data.recoverHpTime then
		self.recoverHpTime = data.recoverHpTime
	end
	if data.hp then
		self.hp = data.hp
		self:updateProcessBar()
	end
	if data.isIn ~= nil then
		self.isIn = data.isIn
	end
	self:updateBuildConnect(data)
	self:updateDataOccupyTime(data)
	self:updateDataProtectime(data)
	self:updateEmojiByData(data)
	self:updatePlayerInfo()
	self:updateSafeState()
	self:updateStatus()
	_ENV = self
	self.msg = "MESSAGE_SERVER_RADIANCE_WAR_BUILD_UPDATE"
	self.siteClassID = self:getSiteClassID()
	SoraDSendMessage(self)
end
function worldMapRadianceWarGate:updateSafeState()
	if self.warStatus == gKingdomWarStatusType.inWar then
		self.image_Protect:setVisible(false)
		self:setProtectimeShow(false)
	else
		self.image_Protect:setVisible(true)
		local isProtect = self.leagueID and self.leagueID <= 0
		self.image_Protect:setGreenColor(isProtect)
		self:setProtectimeShow(true, isProtect)
		self:updateProtectimePos()
	end
end
function worldMapRadianceWarGate:updatePlayerInfo()
	if self.leagueID and self.leagueID > 0 then
		self:setOccupyTimeShow(true)
		if self:isOccupCompleted() then
			self:showNodeEffectFire()
		else
			self:hideNodeEffectFire()
		end
		local selfLeagueID = allianceMgr:getOwnTeamID()
		if self.leagueID == selfLeagueID then
			local nameColor = worldMapDefine.getLeagueManorLineColor(true)
			self.text_player_Name:setColor(nameColor)
		else
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
			local nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
			self.text_player_Name:setColor(nameColor)
		end
		self.image_LeagueFlag:setVisible(true)
		self.image_player_name:setVisible(true)
		self.text_player_Name:setVisible(true)
		if allianceDesRead.getFlagIcon(self.leagueFlag) then
			self.image_LeagueFlag:setSpriteFrame(allianceDesRead.getFlagIcon(self.leagueFlag))
			self.image_LeagueFlag:setScale(0.3)
		end
		local textName = self:isOccupCompleted() and self.leagueName or self.playerName
		if self.leagueID and self.leagueID > 0 and self.leagueAbbrName then
			allianceMgr = allianceDesRead.getFlagIcon(self.leagueFlag)
			allianceDesRead.getFlagIcon(self.leagueFlag).abbr = self.leagueAbbrName
			allianceDesRead.getFlagIcon(self.leagueFlag).name = textName
			textName = i18n("common_text_186", allianceDesRead.getFlagIcon(self.leagueFlag))
		end
		if 0 < self.sourceID then
			textName = textName .. "#" .. tostring(self.sourceID)
		end
		self.text_player_Name:setString(textName)
	else
		self:setOccupyTimeShow(false)
		self:hideNodeEffectFire()
		self.image_LeagueFlag:setVisible(false)
		self.image_player_name:setVisible(false)
		self.text_player_Name:setVisible(false)
	end
end
function worldMapRadianceWarGate:updateStatus()
	self:updateFireEffect(self.buildState)
end
function worldMapRadianceWarGate:playClickSound()
	SoraDPlaySound("innerbuildsound", 101)
end
function worldMapRadianceWarGate:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if isSelfKindom and 0 < selfLeagueID then
		if self.leagueID == 0 then
			if self.warStatus == gKingdomWarStatusType.inWar then
				local isConnected = self:isConnected()
				allianceMgr = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				;(nil).isButtonEnabled = isConnected
				table.insert(buttonTypeArray, nil)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					;(0).isButtonEnabled = isConnected
					table.insert(buttonTypeArray, 0)
				end
			end
			if not self.isIn then
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
				table.insert(buttonTypeArray, table.insert)
			end
		elseif selfLeagueID == self.leagueID then
			if self:checkHasArmy() then
				allianceMgr = table.insert
				table.insert.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
				table.insert(buttonTypeArray, table.insert)
			end
			allianceMgr = table.insert
			table.insert.buttonType = worldMapDefine.worldMapTipButtonType_shibingYuabzhu
			table.insert(buttonTypeArray, table.insert)
			local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
			if haveHall and 0 < selfLeagueID then
				allianceMgr = 0
				;(0).buttonType = worldMapDefine.worldMapTipButtonType_zuduiYuanzhu
				table.insert(buttonTypeArray, 0)
			end
			allianceMgr = 0
			;(0).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
			table.insert(buttonTypeArray, 0)
		else
			if self.warStatus == gKingdomWarStatusType.inWar then
				local isEnable
				local isEnableZhenCha = true
				local msgTipsKey
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				local selfSourceID = lordInfoCtrl:getMapSourceKid()
				if 0 < self.sourceID and selfSourceID == self.sourceID then
					isEnable = false
					isEnableZhenCha = false
					allianceMgr = nil
					;(nil).buildname = self:getFavoriteName()
					msgTipsKey = i18n("brightWar_text_131", nil)
				else
					isEnable = self:isConnected()
				end
				allianceMgr = nil
				;(nil).buttonType = worldMapDefine.worldMapTipButtonType_gongJi
				;(nil).isButtonEnabled = isEnable
				;(nil).msgTipsKey = msgTipsKey
				table.insert(buttonTypeArray, nil)
				local haveHall = cityCtrl:getBuildCell(BUILDID.HALL_OF_WAR, 0)
				if haveHall and 0 < selfLeagueID then
					allianceMgr = 0
					;(0).buttonType = worldMapDefine.worldMapTipButtonType_xuanZhan
					;(0).isButtonEnabled = isEnable
					;(0).msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, 0)
				end
				local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
				if 1 < towerLv then
					allianceMgr = worldMapDefine.worldMapTipButtonType_xuanZhan
					worldMapDefine.worldMapTipButtonType_xuanZhan.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
					worldMapDefine.worldMapTipButtonType_xuanZhan.isButtonEnabled = isEnableZhenCha
					worldMapDefine.worldMapTipButtonType_xuanZhan.msgTipsKey = msgTipsKey
					table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xuanZhan)
				end
			end
			if not self.isIn then
				allianceMgr = i18n("brightWar_text_131", nil)
				i18n("brightWar_text_131", nil).buttonType = worldMapDefine.worldMapTipButtonType_buDuiXiangqing
				table.insert(buttonTypeArray, (i18n("brightWar_text_131", nil)))
			end
		end
	end
	allianceMgr = i18n("brightWar_text_131", nil)
	i18n("brightWar_text_131", nil).buttonType = worldMapDefine.worldMapTipButtonType_zhuangTai
	table.insert(buttonTypeArray, (i18n("brightWar_text_131", nil)))
	return buttonTypeArray
end
return worldMapRadianceWarGate
